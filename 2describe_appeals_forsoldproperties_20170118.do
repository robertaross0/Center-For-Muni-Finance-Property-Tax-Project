use "$dataFolder\Berry_Ross_Sales_data", clear

// In-line stats for paper
quietly sum ratio if percentile==25 & taxyear>2008
local lratio=`r(mean)'
quietly sum ratio1 if percentile==25 & taxyear>2008
local lfpratio=`r(mean)'
quietly sum ratio if percentile==75 & taxyear>2008
local hratio=`r(mean)'
quietly sum ratio1 if percentile==75 & taxyear>2008
local hfpratio=`r(mean)'


// Difference in first and last ratio
display `lfpratio' ", " `lratio' ", "`hfpratio' ", "`hratio'
display "% reduction in ratios for first quartile=" ///
	(`lfpratio'-`lratio')/`lfpratio'*100
display "% reduction in ratios for last quartile=" ///
	(`hfpratio'-`hratio')/`hfpratio'*100

// Difference in ratios first and fourth quartile 
display "% difference in first-pass ratios 75th-25th =" ///
	(`hfpratio'-`lfpratio')/`lfpratio'*100
display "% difference in first-pass ratios 75th-25th =" ///
	(`hratio'-`lratio')/`lratio'*100
	
// in-line stats about BOR
sum av if taxyear>2008
sum av if ratio1<1 & taxyear>2008
display 126209 / 230177   

sum appeal_flag if ratio1<1 & taxyear>2008
display r(sum)/126209
sum appeal if ratio1<1 & taxyear>2008 //unconditional
sum appeal if ratio1<1 & appeal>0 & taxyear>2008 //conditional on winning
sum av if ratio1<1 & appeal>0 & taxyear>200
display 5789/24863

// How about over assessed?
sum appeal if ratio1>1 & appeal>0 & taxyear>2008 //conditional on winning
sum av if ratio1>1 & appeal>0 & taxyear>200
display 8169/28432

// How predictive is ratio
g percent_reduction=appeal/av1
replace win=(appeal>0)
probit win ratio1
reg percent_reduction ratio1, noc
// Properties which are mis-appraised appeal more
quietly sum appeal_flag if taxyear>2008
local N=r(N)
binscatter appeal_flag ratio1 if taxyear>2008, ///
	nq(20) ///
	by(condo) linetype(connect) ///
	ytitle("Rate of appeal" " ") ///
	xtitle("Ratio") ///
	subtitle(2009-2015) ///
	ylab(0 "0%" .25 "25%" .5 "50%" .75 "75%") ///
	title("Ratio of final estimated maket value to actual market value") ///
	note(For `N' properties sold in 2009-2015.) ///
	legend(lab(1 "Non-condo") lab(2 "Condominiums")) 
 graph export "$graphFolder\appeals5.eps", replace

 // higher value properties appeal more
quietly sum appeal_flag if taxyear>2008 & value<2500000
local N=r(N)
binscatter appeal_flag value if taxyear>2008, ///
	nq(20) ///
	by(condo) linetype(connect) ///
	ytitle("Rate of appeal" " ") ///
	xtitle("Sale Value") ///
	subtitle(2009-2015) ///
	xlab(500000 "$500K" 1000000 "$1 mln" 1500000 "$1.5 mln") ///
	ylab(0 "0%" .25 "25%" .5 "50%" .75 "75%") ///
	title("Rate of appeal for condos and not-condos") ///
	note(For `N' properties sold in 2009-2015.) ///
	legend(lab(1 "Non-condo") lab(2 "Condominiums")) 
 graph export "$graphFolder\appeals6.eps", replace

 binscatter win value if taxyear>2008, ///
	nq(20) ///
	by(condo) linetype(connect) ///
	ytitle("Rate of appeal" " ") ///
	xtitle("Sale Value") ///
	subtitle(2009-2015) ///
	xlab(500000 "$500K" 1000000 "$1 mln" 1500000 "$1.5 mln") ///
	ylab(0 "0%" .25 "25%" .5 "50%" .75 "75%") ///
	title("Rate of successful appeal for condos and not-condos") ///
	note(For `N' properties sold in 2009-2015.) ///
	legend(lab(1 "Non-condo") lab(2 "Condominiums")) 
 graph export "$graphFolder\appeals7.eps", replace
 
tabstat online win appeal_flag, stat(mean) by(taxyear)	

/* Decided not to show this
binscatter appeal_flag ratio1, ///
	nq(20) ///
	by(condo) linetype(connect) ///
	ytitle("Rate of appeal" " ") ///
	ylab(.25 "25%" .5 "50%") ///
	xtitle(" " "First-pass assessment ratio") 
graph save "$graphFolder\tmp3.gph", replace
*/
binscatter percent_reduction ratio1 if taxyear>2008, ///
	nq(20) ///
	by(condo) linetype(connect) ///
	ytitle("Percent reduction in" "taxable value" " ") ///
	ylab(.1 "10%" .3 "30%" ) ///
	xtitle(" " "First-pass assessment ratio")  ///
	xline(1, lp(dash)) subtitle(2009-2015)
graph save "$graphFolder\tmp3.gph", replace

binscatter win ratio1 if taxyear>2008, ///
	nq(20) ///
	by(condo) linetype(connect) ///
	ytitle("Percent of properties" "winning an appeal" " ") ///
	ylab(.85 "85%" .95 "95%" 1 "100%") ///
	xline(1, lp(dash)) ///
	xtitle(" " "First-pass assessment ratio")  subtitle(2009-2015)
graph save "$graphFolder\tmp4.gph", replace

grc1leg "$graphFolder/appeals2.gph" "$graphFolder/appeals3.gph" ///
"$graphFolder/tmp3.gph" "$graphFolder/tmp4.gph", ///
subtitle(Cook County 2003-2015)
graph export "$graphFolder/appeals.eps", replace



erase "$graphFolder/tmp1.gph" 
erase "$graphFolder/tmp2.gph" 
erase "$graphFolder/tmp3.gph" 
erase "$graphFolder/tmp4.gph" 


	

	
