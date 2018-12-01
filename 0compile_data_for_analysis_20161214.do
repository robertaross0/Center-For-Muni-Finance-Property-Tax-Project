clear
capture log close
log using "$logFolder/merge_report.txt", text replace name(Mergelog)
*******************************************************************************
**
**	This log records the results of merging different 
**	datasets to ensure that as many observations are 
**	retained as possible.
**
*******************************************************************************
// Merge taxes with sales, and select only properties which sold.
quietly use "$dataFolder/taxes", clear
merge 1:1 pin14 taxyear using "$dataFolder/residential_sales"
// You expect a large number of properties in the taxes data to not match the 
// sales, but there are 559 properties in the sales data which lack 
// corrosponding tax data.
quietly drop if _merge!=3 
quietly drop _merge

// Merge with appeals file
merge 1:1 pin14 taxyear using "$dataFolder/appeals"
quietly drop if _merge==2 // We only want properties which sold
quietly drop _merge

sum if appeal<0 
drop if appeal<0 // 61 properties with increases in av post-appeal

replace av1=av-appeal if av1==. //For properties which did not appeal, first pass=
// final av
replace av1=0 if av1<0 //Because assessed value cannot be below zero

drop if pin14=="."
drop if pin14==""
duplicates drop pin14 taxyear, force

// Merge with property characteristic files
merge m:1 pin14 using "$dataFolder/property_characteristics"
quietly drop if _merge==2 // We only want properties which sold
quietly drop _merge

// Geogrphies use the first 10 digits of the pin14
merge m:1 pin10 using "$dataFolder/pin_geographies.dta"
quietly drop if _merge==2 // We only want properties which sold
quietly replace _merge=(_merge==3)
quietly ren _merge geo_merge
quietly lab var geo_merge "Dummy for successful merge with geography file"
tabstat geo_merge, by(taxyear)

quietly drop if taxyear==2002 //Because we don't have appeals for that year

capture log close

// Generate variables
replace totaltax=totaltax_paid if taxyear==2015
drop totaltax_* muniflag vetex disabpersvet
rename totaltax taxes

encode maj_descr, g(major_class)
drop maj_*

preserve //2015 didn't have a major_class variable, so I fill in
collapse (first) major_class, by(class)
g taxyear=2015
save tmp, replace
restore
merge m:1 class taxyear using tmp
drop _merge
replace major_class=3 if class==299
replace major_class=4 if major_class==.
// generate some useful dummies
g appeal_flag=(appeal!=.)
g appeal_flag2=(appeal>0 & appeal!=.)
g condo=( class==299)
g sf=( class!=299)

g percentile=. //generate a percentile of value for each year
forval taxyear=2003(1)2015{
	xtile x=value if taxyear==`taxyear', nq(100)
	replace percentile=x if taxyear==`taxyear'
	drop x
	}

g ratio=av*10/value // final asessment ratio
g ratio1=av1*10/value // first-pass assessment ratio	
g erate=taxes/value //effective tax rates

lab var ratio "Ratio of final estimated to realized market value"
lab var ratio1 "Ratio of first-pass estimated to realized market value"
lab var erate "Effective tax rate"	
lab var percentile "Percentile of value in year, 100 percentiles"
lab var condo "Idicator for Condominium"
lab var sf "Indicator for not condominium"
lab var appeal_flag "Indicator for appeal attempt"
lab var appeal_flag2 "Indicator for appeal win"
lab var av "Final assessed value"
lab var eav "Adjusted Equalized Assessed Value"
lab var rate "Rate applied by County Clerk to EAV"
lab var taxes "Total taxes paid"
lab var longex "Longtime exemption"
lab var homeowner "Dummy for homeowner occupied"
lab var retvetex "Retired veterans exemption"
lab var disabpersex "Disabled person exemption"
lab var disabvetex "Disabled veteran exemption"
lab var homeex "Homeowners' exemption"
lab var senex "Senior exemption"
lab var senfrzex "Senior freeze exemption"
lab var major_class "Residential class type"
lab var pin10 "First 10 digits of pin corrosponding to buildings"

lab defin tris 1 "Chicago" 2 "Northwest Suburban Cook County" 3 "Southwest Suburban Cook County"
lab val tri tris

lab define condo 1 "Condominium" 0 "Non-condo"
lab val condo condo

order pin14 pin10 tract2010 community spmap_census2010_id ///
spmap_community_id taxyear tri class major_class condo sf tname tadres tcity ///
tstate tzip pnum pdir pstreet psuf pcity pstate pzip value percentile av1 appeal_flag ///
appeal_flag2 appeal av eav rate erate ratio1 ratio ///
taxes, first
order type use apts walls roof rooms beds basement basementfin centralheat ///
otherheat ac fireplaces attic atticfin fb hb plantype designtype quality ///
rnv site garagesize garageconstruction garageattached garagearea ///
garageconstruction2 garageattached2 garagearea2 porch imp squarefoot ///
repair neqclass age hdsf nbhd mltind mltcode vol ncu, last

sort taxyear tri pin14
lab data "Property tax, appeal, and sales data for Cook County, IL 2003-2015"

save "$dataFolder/Ross_Sales_data.dta", replace
