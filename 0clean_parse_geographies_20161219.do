// Geogrphic data matching pin to area was created by Alvaro Mana 

// There is a problem matching on census tract identifier.
// First, the tract identifier needs to be modified so that it is accurate 
// to the second decimal point. For example, "8036.0498" should just be
// "8036.05"
// Second, the census tract numbers in Alvaro's files are 2000 census 
// tracts, so you need a concordance file for census variables so that 
// you can merge on the 2000 census tract and match to 2010 census 
// demographic values.
// Finally, pin14 should be 14 digits long. If not, add a leading 0

clear all
set obs 1
g pin10="."
lab data "Geographic areas for pins"
save "$dataFolder/pin_geographies.dta", replace


forval year=2003(1)2009{
quietly import delimited "$rawdataFolder\geo2003.csv", clear stringcols(22)

quietly keep pin14 tract censustract
quietly save tmp, replace

// First, I fix the problem of the additional digits in censustract 
// by truncating census
// tract numbers to two decimal points
quietly g tract2000=censustract
quietly tostring tract2000, force replace
quietly split tract2000, p(".")
quietly replace tract2000=tract20001+"00" if strpos(tract2000, ".")==0
quietly replace tract2000=tract20001+substr(tract20002, 1,2) if strpos(tract2000, ".")>0
quietly destring tract2000, replace

merge m:m tract2000 using "$dataFolder/census_2010_data"
// There are some tract numbers which, due to rounding, are not correct.
// I can fix them by merging twice
quietly keep if _merge==1
quietly keep tract
quietly merge m:m tract using tmp

quietly g tract2000=censustract
quietly tostring tract2000, force replace
quietly split tract2000, p(".")
quietly replace tract2000=tract20001+"00" if strpos(tract2000, ".")==0
quietly replace tract2000=tract20001+substr(tract20002, 1,2) if strpos(tract2000, ".")>0
quietly destring tract2000, replace
quietly replace tract2000=tract if _merge==3 // Here, I correct for the rounding problem

quietly drop _merge 
display "THIS MERGE IS CRITICAL"
merge m:m tract2000 using "$dataFolder/census_2010_data"
quietly drop _merge

// pin10  should be 10 digits, pin14 should be 14 digits
// If not, pin14 needs a zero tagged onto the beginning
replace pin14="0"+pin14 if strlen(pin14)==13
drop if strlen(pin14)<13
g pin10=substr(pin14,1,10)
drop pin14 

quietly append using "$dataFolder/pin_geographies.dta"
duplicates drop pin10, force
quietly save "$dataFolder/pin_geographies.dta", replace
}
forval year=2010(1)2010{

quietly import delimited "$rawdataFolder\geo`year'.csv", clear  stringcols(2)
quietly keep pin10* tract community area_numbe
quietly ren tract tract2010
merge m:m tract2010 using "$dataFolder/census_2010_data"

// pin10  should be 10 digits. If not, it needs a zero tagged onto the end
replace pin10="0"+pin10 if strlen(pin10)==9
drop if strlen(pin10)<9

quietly append using "$dataFolder/pin_geographies.dta"
duplicates drop pin10, force
quietly save "$dataFolder/pin_geographies.dta", replace
}

forval year=2011(1)2011{
quietly import delimited "$rawdataFolder\geo`year'.csv", clear stringcols(20)
quietly g tract2010=subinstr(namelsad, "Census Tract ","",.)
quietly replace tract2010=tract2010+"00" if strpos(tract2010, ".")==0
quietly replace tract2010=subinstr(tract2010, ".","",.)
quietly keep pin14 tract2010 community area_numbe
quietly destring tract2010, replace
merge m:m tract2010 using "$dataFolder/census_2010_data"
quietly drop _merge

// pin10  should be 10 digits. If not, it needs a zero tagged onto the end
replace pin14="0"+pin14 if strlen(pin14)==13
drop if strlen(pin14)<13
g pin10=substr(pin14, 1, 10)
drop pin14

quietly append using "$dataFolder/pin_geographies.dta"
quietly duplicates drop pin10, force
quietly save "$dataFolder/pin_geographies.dta", replace
}
forval year=2012(1)2012{
quietly import delimited "$rawdataFolder\geo`year'.csv", clear stringcols(20)
quietly ren tractce tract2010 
quietly keep pin14 tract2010 community area_numbe
merge m:m tract2010 using "$dataFolder/census_2010_data"
quietly drop _merge

// pin10  should be 10 digits. If not, it needs a zero tagged onto the end
replace pin14="0"+pin14 if strlen(pin14)==13
drop if strlen(pin14)<13
g pin10=substr(pin14, 1, 10)
drop pin14

quietly append using "$dataFolder/pin_geographies.dta"
duplicates drop pin10, force
quietly save "$dataFolder/pin_geographies.dta", replace
}
forval year=2013(1)2013{
quietly import delimited "$rawdataFolder\geo`year'.csv", clear stringcols(17)
quietly ren tractce tract2010 
quietly keep pin14 tract2010 community area_numbe
merge m:m tract2010 using "$dataFolder/census_2010_data"
quietly drop _merge

// pin10  should be 10 digits. If not, it needs a zero tagged onto the end
replace pin14="0"+pin14 if strlen(pin14)==13
drop if strlen(pin14)<13
g pin10=substr(pin14, 1, 10)
drop pin14

quietly append using "$dataFolder/pin_geographies.dta"
duplicates drop pin10, force
quietly save "$dataFolder/pin_geographies.dta", replace
}
forval year=2014(1)2015{
quietly import delimited "$rawdataFolder\geo`year'.csv", clear stringcols(16)
quietly ren tractce tract2010 
quietly keep pin14 tract2010 community area_numbe
merge m:m tract2010 using "$dataFolder/census_2010_data"
quietly drop _merge

// pin10  should be 10 digits. If not, it needs a zero tagged onto the end
replace pin14="0"+pin14 if strlen(pin14)==13
drop if strlen(pin14)<13
g pin10=substr(pin14, 1, 10)
drop pin14

quietly append using "$dataFolder/pin_geographies.dta"
duplicates drop pin10, force
quietly save "$dataFolder/pin_geographies.dta", replace
}

// Final data construction
use "$dataFolder/pin_geographies.dta", clear
keep pin10 area_numbe community tract2010 spmap_census2010_id white ///
 black nativ asian two hispanic college medhinc poverty totalpop 


// merge community based on census tract so that all pins have
// a community
preserve 
collapse (first) area_numbe, by(tract)
save tmp, replace
restore
drop area_numbe
merge m:1 tract using tmp
drop _merge

drop community
ren area_numbe community
replace community=999 if community==.


lab define communities  1 "Rogers Park" 2 "West Ridge" 3 "Uptown" 4 ///
"Lincoln Square" 5 "North Center" 6 "Lake View" 7 "Lincoln Park" 8 ///
"Near North Side" 9 "Edison Park" 10 "Norwood Park" 11 "Jefferson Park" ///
12 "Forest Glen" 13 "North Park" 14 "Albany Park" 15 "Portage Park" ///
16 "Irving Park" 17 "Dunning" 18 "Montclare" 19 "Belmont Cragin" ///
20 "Hermosa" 21 "Avondale" 22 "Logan Square" 23 "Humboldt Park" ///
24 "West Town" 25 "Austin" 26 "West Garfield Park" 27 "East Garfield Park" ///
28 "Near West Side" 29 "North Lawndale" 30 "South Lawndale" ///
31 "Lower West Side" 32 "Loop" 33 "Near South Side" 34 "Armour Square" ///
35 "Douglas" 36 "Oakland" 37 "Fuller Park" 38 "Grand Boulevard" 39 "Kenwood" ///
40 "Washington Park" 41 "Hyde Park" 42 "Woodlawn" 43 "South Shore" 44 "Chatham" ///
45 "Avalon Park" 46 "South Chicago" 47 "Burnside" 48 "Calumet Heights" ///
49 "Roseland" 50 "Pullman" 51 "South Deering" 52 "East Side" 53 "West Pullman" ///
54 "Riverdale" 55 "Hegewisch" 56 "Garfield Ridge" 57 "Archer Heights" ///
58 "Brighton Park" 59 "McKinley Park" 60 "Bridgeport" 61 "New City" ///
62 "West Elsdon" 63 "Gage Park" 64 "Clearing" 65 "West Lawn" 66 "Chicago Lawn" ///
67 "West Englewood" 68 "Englewood" 69 "Greater Grand Crossing" 70 "Ashburn" ///
71 "Auburn Gresham" 72 "Beverly" 73 "Washington Heights" 74 "Mount Greenwood" ///
75 "Morgan Park" 76 "O'Hare" 77 "Edgewater" 999 "Not in Chicago"
lab val community communities


merge m:1 community using "$dataFolder/communityarea_data"
drop if _merge==2
drop _merge

replace totalpop=round(totalpop,1)

drop if tract2010==.
duplicates drop pin10, force
order pin10 tract2010 community spmap_census2010_id spmap_community_id, first


lab var tract2010 "2010 census tract"
lab var community "Chicago community area"
lab var spmap_census2010_id "Mapping variable for 2010 census tracts"
lab var spmap_community_id "Mapping variable for community areas"

lab data "Every PIN from 2003-2014 and its Chicagoland geography"

save "$dataFolder/pin_geographies.dta", replace

erase tmp.dta
clear all
