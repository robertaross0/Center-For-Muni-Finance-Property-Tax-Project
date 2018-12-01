
import delimited "$rawdataFolder\nhgis0022_ts_nominal_tract.csv", clear
keep if statefp==17
keep if countyfp==31
keep if year=="2008-2012" | year=="2010"

// the codebook for the data is in the $rawdataFolder

rename av0aa totalpop

g white=b18aa/totalpop
g black=b18ab/totalpop
g nativ=b18ac/totalpop
g asian=b18ad/totalpop
g two=b18ae/totalpop

g hispanic=a35aa/totalpop

g college=b69ac

ren b79aa medhinc

ren cl6aa poverty

ren tracta tract2010
keep tract2010 white black nativ asian two hispanic college medhinc poverty totalpop

collapse white black nativ asian two hispanic college medhinc poverty totalpop, by(tract2010)
drop if tract2010==.
replace college = college/totalpop
replace poverty = poverty/totalpop

sum // check if variable values have sensible ranges

lab var white "% White: 2010 Census"
lab var black "% Black: 2010 Census"
lab var asian "% Asian: 2010 Census"
lab var nativ "% Native American: 2010 Census"
lab var two "% Two or more races: 2010 Census"
lab var hispanic "% hispanic: 2010 Census"

lab var college "% Holding a BA or higher: 2008-2012 ACS"
lab var medhinc "Median household income: 2008-2012 ACS"
lab var poverty "% Below poverty threshold: 2008-2012 ACS"

lab var tract2010 "Normalized census tract"
lab var totalpop "Total population: 2010 Census"

lab data "Census Demographic Data for Cook County, IL"

save "$dataFolder/demovars", replace

// 2010 to 2000 concordance files
import delimited "http://www2.census.gov/geo/docs/maps-data/data/rel/trf_txt/il17trf.txt", clear
// record layout can be found here: https://www.census.gov/geo/maps-data/data/tract_rel_layout.html
keep if v1==17
keep if v2==31 // COok County
keep v3 v12
ren v3 tract2000
ren v12 tract2010
merge m:1 tract2010 using "$dataFolder/demovars"
drop _merge // Good merge
save "$dataFolder/demovars", replace
