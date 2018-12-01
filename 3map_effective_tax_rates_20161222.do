use "$dataFolder/Ross_Sales_data.dta", clear
keep if taxyear>2008 & tri==1
collapse erate value, by( spmap_census2010_id)

spmap erate using "$dataFolder/census_2010_cords", ///
	id(spmap_census2010_id) ///
	fc(Reds2) clnumber(5) clmethod(q) ///
	title(Effective tax rates) ///
	subtitle(2010 Chicago Census Tracts 2009-2015) ///
    legtitle("Quintiles of effective" "tax rates") /// 
	legend(lab(1 "No Data") lab(2 "1st quintile")  lab(3 "2nd quintile") ///
	 lab(4 "3rd quintile")  lab(5 "4th quintile") lab(6 "5th quintile"))

graph export "$mapFolder/erate_map.eps", replace
graph export "$mapFolder/erate_map.pdf", replace
graph export "$mapFolder/erate_map.png", replace

spmap value using "$dataFolder/census_2010_cords", ///
	id(spmap_census2010_id) ///
	fc(Greens2) clnumber(5) clmethod(q) ///
	title(Mean home value) ///
	subtitle(2010 Cook County Census Tracts 2009-2015) ///
    legtitle("Quintiles of mean" "property value") /// 
	legend(lab(1 "No Data") lab(2 "1st quintile")  lab(3 "2nd quintile") ///
	 lab(4 "3rd quintile")  lab(5 "4th quintile") lab(6 "5th quintile"))
graph export "$mapFolder/value_map.eps", replace
