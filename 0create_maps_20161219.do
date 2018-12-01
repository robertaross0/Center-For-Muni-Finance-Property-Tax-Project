clear
// 2010 Census tracts from
// https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2013&layergroup=Census+Tracts

// Chicago Community Areas from the Chicago Data Portal
// Note: to get properly formatted shapfiles, DO NOT export as a shapefile
// export as "original." Good job Chicago.

// 2010 census tracts
shp2dta using "$rawdataFolder/tl_2013_17_tract", ///
	data("$dataFolder/census_2010_data") ///
	coordinates("$dataFolder/census_2010_cords") ///
	genid(spmap_census2010_id)


// 2000 Census Tracts
shp2dta using "$rawdataFolder/Census_Tracts_2000", ///
	data("$dataFolder/census_2000_data") ///
	coordinates("$dataFolder/census_2000_cords") ///
	genid(spmap_census2000_id)

use "$dataFolder/census_2010_data", clear
keep if COUNTYFP=="031" // Cook County
drop if NAME=="9900"
keep spmap_census2010_id NAME 
rename NAME tract
//Census tract numbers don't have decimals in merge files
g tract2010 = real(tract)*100 
merge 1:m tract2010 using "$dataFolder/demovars"
drop _merge // ok Good merge
destring tract, replace
ren tract tract2010_2
save "$dataFolder/census_2010_data", replace

collapse medhinc , by( spmap_census2010_id)
spmap medhinc using "$dataFolder/census_2010_cords", ///
	id(spmap_census2010_id) ///
	fc(Greens2) legtitle("Median HH Income") ///
	title(Median HH income) subtitle(Cook County 2008-2012)
graph export "$graphFolder/median_hh_inc.pdf", replace

// Community areas
clear 
shp2dta using "$rawdataFolder/CommAreas", ///
	data("$dataFolder/communityarea_data") ///
	coordinates("$dataFolder/communityarea_cords") ///
	genid(spmap_community_id)

use "$dataFolder/communityarea_data", clear
keep AREA_NUMBE spma*
rename AREA_NUMBE community
destring community, replace
g x=rnormal()
spmap x using "$dataFolder/communityarea_cords", id(spmap_community_id) 
drop x
save "$dataFolder/communityarea_data", replace

