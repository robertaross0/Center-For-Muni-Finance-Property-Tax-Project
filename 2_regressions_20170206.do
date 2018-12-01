use "$dataFolder\Ross_Sales_data", clear

// Regression on probability of appealing
// Crreate variable containing number of units in a building

collapse (count) av, by(pin10 taxyear)
collapse (max) av, by(pin10)
rename av units
lab var units "Number of units in a building"
g units2=units^2
lab var units2 "Squared number of units in a building"
save "$dataFolder\units", replace

use "$dataFolder\Ross_Sales_data", clear
merge m:1 pin10 using "$dataFolder\units"
drop _merge

// Scaling variables
g nonwhite=(1-white)*100
lab var nonwhite "Percent not white or hispanic"
replace value =value *100000
replace totalpop=totalpop/1000
replace erate=erate*100
replace appeal=appeal/av1

estimates clear
// Main correlates with appealing
eststo: reg ratio1 value i.condo units units2 ///
	nonwhite college  ///	
 	, noc cluster(spmap_census2010_id)
eststo: reg appeal_flag ratio1 value i.condo units units2 ///
	nonwhite college , noc ///	
 	cluster(spmap_census2010_id)
eststo: reg win ratio1 value i.condo units units2 ///
	nonwhite college if appeal_flag ==1, noc ///	
 	cluster(spmap_census2010_id)	
eststo: reg appeal ratio1 value i.condo units units2 ///
	nonwhite college , noc ///	
 	cluster(spmap_census2010_id)	
eststo: reg erate ratio1 value i.condo units units2 ///
	nonwhite college if tri==1 ///
 	, noc cluster(spmap_census2010_id)
esttab, label
esttab using "$tableFolder\appeals.tex", ///
	nonum stats(N r2) label ///
	mtitles("First-pass assessments" "Probability of appealing" ///
	"Probability of winning an appeal" "Reduction in taxable value" ///
	"Effective tax rate" ) ///
	title(Correlates with appealing, winning appeal) ///
	replace  ///
	addnotes("Errors clustered on 2010 Census Tracts") ///
		coeflabels(totalpop "Tract population (thousands)")

//Manually edit table for appearance
*/
