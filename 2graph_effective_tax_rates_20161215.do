use  "$dataFolder/Ross_Sales_data.dta", clear

sum erate value taxes if percentile==25 & tri==1 & taxyear>2008
sum erate value taxes if percentile==75 & tri==1 & taxyear>2008

sum ratio if percentile==25 & tri==1 & taxyear>2008
sum ratio if percentile==75 & tri==1 & taxyear>2008

sum ratio if percentile==25 & taxyear>2008
sum ratio if percentile==75 & taxyear>2008

sum ratio1 if percentile==25 & taxyear>2008
sum ratio1 if percentile==75 & taxyear>2008


display  "Assessment ratios are " round((1.078072 -.807557  )/.807557  *100,1) ///
	"% higher for 25th percentile than the 75th percentile CHICAGO"
	
display  "First-pass assessment ratios are " round((1.094377   -.8923291   )/.8923291   *100,1) ///
	"% higher for 25th percentile than the 75th percentile COUNTY"
display  "Final assessment ratios are " round((1.058879    -.850971   )/.850971   *100,1) ///
	"% higher for 25th percentile than the 75th percentile COUNTY"
	
display  "Effective tax rates are " round((.0154617-.0124828)/.0124828*100,1) ///
	"% higher for 25th percentile than the 75th percentile"
	
display "If properties at the 25th percentile paid the rates applied to the" ///
	"75th percentile, they would pay " round(.0154617* 156146.3- .0124828*156146.3, 1) ///
	"$ less"
display "If properties at the 75th percentile paid the rates applied to the" ///
	"25th percentile, they would pay " round( .0154617 *  383206.3 - .0124828* 383206.3, 1) ///
	"$ more"
	
// Cannot compare effective tax rates across jurisdictions
// However, all properties in Chicago face the same levies.
// Regressivity in taxes in Chicago
quietly sum tri if taxyear>2008 & tri==1
loca N=r(N)
binscatter erate value if taxyear>2008 & tri==1, ///
	nq(50) ///
	by(condo) linetype(connect) ///
	ytitle("Effective tax rate on housing wealth" " ") ///
	xtitle(Sale value of property) ///
	xlab(500000 "$500k" 1000000 "$1mln" 1500000 "$1.5mln" 2000000 "$2mln") ///
	title(Effective tax rates) ///
	subtitle(Chicago 2009-2015) ///
	note(For `N' properties sold in Chicago 2009-2015.) ///
	legend(lab(1 "Single-Family") lab(2 "Condominiums")) 
graph save "$graphFolder/tmp1.gph", replace
graph export "$graphFolder/erate.eps", replace

use  "$dataFolder/Berry_Ross_Sales_data.dta", clear
quietly sum tri if taxyear>2008 
loca N=r(N)
binscatter ratio value if taxyear>2008, ///
	nq(50) ///
	by(condo) linetype(connect) ///
	ytitle("Assessment ratios" " ") ///
	xtitle(" " "Sale value of property" ) ///
	xlab(500000 "$500k" 1000000 "$1mln" 1500000 "$1.5mln" 2000000 "$2mln") ///
	title("Assessment Ratios") ///
	subtitle(Cook County 2009-2015) ///
	note(For `N' properties sold in Cook County 2009-2015.) ///
	legend(lab(1 "Single-Family") lab(2 "Condominiums")) 
graph export "$graphFolder/ratio2.eps", replace
graph save "$graphFolder/tmp2.gph", replace

grc1leg "$graphFolder/tmp1.gph" "$graphFolder/tmp2.gph"

graph export "$graphFolder/panel2.eps", replace




