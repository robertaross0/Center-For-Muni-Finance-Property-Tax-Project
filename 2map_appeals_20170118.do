// A tmp datafile was built in "$doFolder/2describe_appeals_20170117.do"
// Here, we use that to map all appeals by merging with pin_geographies.dta

use "$dataFolder\tmp", clear
keep if taxyear>2008
merge m:1 pin10 using "$dataFolder/pin_geographies.dta"
keep if _merge==3
drop _merge

g appealed=(appeal!=.)
g chicago=(strpos(pcity, "CHICAGO")!=0 &strpos(pcity, "HEIGHTS")==0 )

collapse (mean) appealed win condo chicago ///
	white black nativ asian hispanic college medhinc poverty, ///
	by(spmap_census2010_id)

spmap appealed using "$dataFolder/census_2010_cords", ///
	id(spmap_census2010_id) ///
	fc(Blues2)  clmethod(q) clnumber(5)  ///
	title(Appeal rates) ///
	subtitle(Cook County 2010 Census Tracts 2009-2015) ///
	     legtitle("Quintiles of probability" "of appealing") /// 
		legend(lab(1 "No Data") lab(2 "1st quintile")  lab(3 "2nd quintile") ///
		 lab(4 "3rd quintile")  lab(5 "4th quintile") lab(6 "5th quintile"))
graph export "$mapFolder/appeal_map.eps", replace

use  "$dataFolder/Ross_Sales_data.dta", clear
collapse (mean) ratio, ///
	by(spmap_census2010_id)

spmap ratio using "$dataFolder/census_2010_cords", ///
	id(spmap_census2010_id) ///
	fc(Reds)  clmethod(q) clnumber(5)  ///
	title(Final Assessment Ratios) ///
	subtitle(Cook County 2010 Census Tracts 2009-2015) ///
	     legtitle("Quintiles of post-appeal" "assessment ratio") /// 
		legend(lab(1 "No Data") lab(2 "1st quintile")  lab(3 "2nd quintile") ///
		 lab(4 "3rd quintile")  lab(5 "4th quintile") lab(6 "5th quintile"))
graph export "$mapFolder/ratio_map.eps", replace
