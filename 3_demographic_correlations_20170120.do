use "$dataFolder/Berry_Ross_Sales_data.dta", clear
keep if taxyear>2009 & tri==1

binscatter erate white, nq(20) ///
	linetype(connect) 
binscatter erate black if taxyear>2008, nq(20) ///
	linetype(connect) 	///
	xtitle(" ") ///
	ytitle("Effective Tax Rate" "on housing wealth" " ") ///
	xlab(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%") ///
	subtitle(% African American)
 graph save "$graphFolder\tmp1.gph", replace

binscatter erate hispanic if taxyear>2008, nq(20) ///
	linetype(connect) ///
	xtitle(" ") ///
	ytitle("Effective Tax Rate" "on housing wealth" " ") ///
	xlab(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%") ///
	subtitle(% Hispanic)
 graph save "$graphFolder\tmp2.gph", replace

binscatter erate medhinc if taxyear>2008, nq(20) ///
	linetype(connect) ///
	xtitle(" ") ///
	ytitle("Effective Tax Rate" "on housing wealth" " ") ///
	ylab(.013 "1.3%" .015 "1.5%" .017 "1.7%") ///
	xlab(31580 "$31K" 50000 "$5K" 100000 "$100K" 120000 "$120K") ///
	subtitle(Household income)
graph save "$graphFolder\tmp3.gph", replace


binscatter erate college if taxyear>2008, nq(20) ///
	linetype(connect)  ///
	xtitle(" ") ///
	ytitle("Effective Tax Rate" "on housing wealth" " ") ///
	xlab(.2 "20%" .4 "40%" .6 "60%" .8 "80%") ///
	subtitle(% College Educated)
graph save "$graphFolder\tmp4.gph", replace

quietly sum erate if taxyear>2008
local N=r(N)

graph combine "$graphFolder/tmp1.gph" "$graphFolder/tmp2.gph" ///
"$graphFolder/tmp3.gph" "$graphFolder/tmp4.gph", ///
	subtitle(Chicago 2009-2015) ///
	note(For `N' properties sold between 2009-2015)
graph export "$graphFolder/democorrs.eps", replace

erase "$graphFolder/tmp1.gph"
erase "$graphFolder/tmp2.gph"
erase "$graphFolder/tmp3.gph"
erase "$graphFolder/tmp4.gph"


// Where are college educated people?
collapse (mean) college, by(spmap_census2010_id)

spmap college using "$dataFolder/census_2010_cords", ///
	id(spmap_census2010_id) ///
	fc(Greens) clnumber(9) ///
	title(Percent with BA or higher) subtitle(Cook County 2009-2015)
