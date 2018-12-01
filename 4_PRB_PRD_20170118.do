use "$dataFolder/Ross_Sales_data.dta", clear

// This empty matrix will hold results
mat PRD_results_1=J(13,6,.)
mat PRD_results_0=J(13,6,.)
mat PRD_results=J(13,6,.)
mat PRB_results=J(13,6,.)
mat suites_results=	J(14,3,.)

drop if ratio>3
drop if ratio1>3


//PRD by condo
foreach condo in 0 1 {
preserve 
keep if condo==`condo'
forval year=2003(1)2015{
local row=`year'-2002
mat PRD_results_`condo'[`row',1]=`year'

	//PRD calculation
		set seed 1
		prd ratio1 value `year' 1 //This command is coded in prd.ado
		mat PRD_results_`condo'[`row',2]=r(prd)
		mat PRD_results_`condo'[`row',3]=1.96*sqrt(r(variance))

		
		set seed 1
		prd ratio value `year' 1
		mat PRD_results_`condo'[`row',4]=r(prd)
		mat PRD_results_`condo'[`row',5]=1.96*sqrt(r(variance))
		
		quietly sum ratio if taxyear==`year'
		mat PRD_results_`condo'[`row', 6]=r(N)
}
restore
}

//PRB
// generate blank variables for PRB regressions
g prb_ratio1=.
g prb_ratio=.
g prb_value1=.
g prb_value=.
forval year=2003(1)2015{
	// PRB variable generation - need two varibles to regress
	// First pass
	quietly sum ratio1 if taxyear==`year', detail
	local median=r(p50) 
	quietly replace prb_ratio1=(ratio1-`median')/`median' if taxyear==`year'
	quietly sum value if taxyear==`year', detail
	local median=r(p50) 
	quietly replace prb_value1=ln(.5*((av1*10)/`median')+.5*value)/ln(2) if taxyear==`year'
	
	//After appeal
	quietly sum ratio if taxyear==`year', detail
	local median=r(p50) 
	quietly replace prb_ratio=(ratio-`median')/`median' if taxyear==`year'
	quietly sum value if taxyear==`year', detail
	local median=r(p50) 
	quietly replace prb_value=ln(.5*((av*10)/`median')+.5*value)/ln(2) if taxyear==`year'
	
}
forval year=2003(1)2015{

	// Next, we use a regression and capture the coefficient as the PRB figure
	local row=`year'-2002
	mat PRB_results[`row',1]=`year'
			quietly sum ratio1 if taxyear==`year', detail
			local p1=r(p1)
			local p99=r(p99)
	 quietly reg prb_ratio1 prb_value1 if taxyear==`year' & ratio1>`p1' & ratio1<`p99'
	mat X=r(table)
	mat PRB_results[`row',2]=_b[prb_value1]
	mat PRB_results[`row',3]=X[2,1]
			quietly sum ratio if taxyear==`year', detail
			local p1=r(p1)
			local p99=r(p99)
	 quietly reg prb_ratio prb_value if taxyear==`year' & ratio>`p1' & ratio<`p99'
	 mat X=r(table)
	mat PRB_results[`row',4]=_b[prb_value]
	mat PRB_results[`row',5]=X[2,1]
	
	quietly sum prb_ratio if taxyear==`year'
	mat PRB_results[`row',6]=r(N) 
}

// Suites
forval year=2003(1)2015{
	local row=`year'-2002
	mat suites_results[`row', 1]=`year'

suites taxes value `year' // This command is coded in suites.ado
	mat suites_results[`row', 2]=r(suites)
	mat suites_results[`row', 3]=1.96*sqrt(r(variance))

}
// Suites for 2003-2015

sort value 
quietly sum value
g x=sum(value)/r(sum)

quietly sum taxes
g y=sum(taxes)/r(sum)

g z=y

twoway (area y x, fc(edkblue) lc(edkblue)) ///
		(area y z, fc(ltbluishgray) lc(edkblue)), ///
	title(Suites Curve) subtitle("Cook County, 2003-2015") ///
	legend(lab(1 "Suites Curve") lab(2 "Proportional Distribution")) ///
	ytitle("Cumulative proportion of total tax" " ") ///
	xtitle(" " "Cumulative proportion of total property values")
graph export "$graphFolder\Suites.eps", replace
graph save "$graphFolder\Suites.gph", replace

drop x y z
// Examples
log using "$logFolder\prd_v_prb.txt", text name(PRD_v_PRB) replace
/* Here is the code used to generate the values for the regressions:
	// PRB variable generation - need two varibles to regress
	// First pass
	quietly sum ratio1 if taxyear==`year', detail
	local median=r(p50) 
	quietly replace prb_ratio1=(ratio1-`median')/`median' if taxyear==`year'
	quietly sum value if taxyear==`year', detail
	local median=r(p50) 
	quietly replace prb_value1=ln(.5*((av1*10)/`median')+.5*value)/ln(2) if taxyear==`year'
	
	//After appeal
	quietly sum ratio if taxyear==`year', detail
	local median=r(p50) 
	quietly replace prb_ratio=(ratio-`median')/`median' if taxyear==`year'
	quietly sum value if taxyear==`year', detail
	local median=r(p50) 
	quietly replace prb_value=ln(.5*((av*10)/`median')+.5*value)/ln(2) if taxyear==`year'
	
*/
use "$dataFolder/Ross_Sales_data.dta", clear

reg prb_ratio1 prb_value1 if taxyear==2011
reg prb_ratio prb_value if taxyear==2011

		quietly mean ratio1 [fw=value] if taxyear==2011
		quietly mat table=r(table)
		quietly sum ratio1 if taxyear==2011
		display r(mean)/table[1,1]
		
		quietly mean ratio [fw=value] if taxyear==2011
		quietly mat table=r(table)
		quietly sum ratio if taxyear==2011
		display r(mean)/table[1,1]
// These are giving qualitativly similar answers
capture log close

// Now we can transform the matrix of values into datasets for graphing
//PRD
clear
svmat PRD_results_0
rename PRD_results_01 year
rename PRD_results_02 PRD_0_1
rename PRD_results_03 PRD_0_1_moe
rename PRD_results_04 PRD_0_2
rename PRD_results_05	PRD_0_2_moe
g PRD_difference_0=PRD_0_2-PRD_0_1

save "$resultsFolder\PRD", replace

clear
svmat PRD_results_1
rename PRD_results_11 year
rename PRD_results_12 PRD_1_1
rename PRD_results_13 PRD_1_1_moe
rename PRD_results_14 PRD_1_2
rename PRD_results_15	PRD_1_2_moe
g PRD_difference_1=PRD_1_2-PRD_1_1

merge 1:1 year using "$resultsFolder\PRD"
drop _merge 
save "$resultsFolder\PRD", replace
export excel "$resultsFolder\PRD.xlsx", replace

//PRD graphs
 use "$resultsFolder\PRD", clear

twoway ///
	(line PRD_1_1 year, lc(edkblue) lw(thick)) ///
	(line PRD_0_1 year, lc(maroon) lw(thick)), ///
	xlab(2003(1)2015, angle(45)) ///
	yline(1, lp(dash) lc(black)) ///
	title(Price-related differential) ///
	legend(lab(1 "Single-Family") lab(2 "Condominiums"))
graph save "$graphFolder\PRD.gph", replace
graph export  "$graphFolder\PRD.eps", replace
graph export  "$graphFolder\PRD.pdf", replace

twoway ///
	(scatter PRD_1_1 year, lc(edkblue) lw(thick)) ///
	(scatter PRD_1_2 year, lc(maroon) lw(thick)), ///
	xlab(2003(1)2015, angle(45)) ///
	ylab(1(.05)1.1) ///
	yline(1, lp(dash) lc(black)) ///
	title(Price-related differential) ///
	subtitle(Condos) ///
	legend(lab(1 "Pre-appeal") lab(2 "Post-appeal"))
graph save "$graphFolder\PRD_1_scatter.gph", replace
graph export  "$graphFolder\PRD_1_scatter.eps", replace
graph export  "$graphFolder\PRD_1_scatter.pdf", replace

twoway ///
	(scatter PRD_0_1 year, lc(edkblue) lw(thick)) ///
	(scatter PRD_0_2 year, lc(maroon) lw(thick)), ///
	xlab(2003(1)2015, angle(45)) ///
	yline(1, lp(dash) lc(black)) ///
	title(Price-related differential) ///
	subtitle(Single-family) ///
	legend(lab(1 "Pre-appeal") lab(2 "Post-appeal"))
graph save "$graphFolder\PRD_0_scatter.gph", replace
graph export  "$graphFolder\PRD_0_scatter.eps", replace
graph export  "$graphFolder\PRD_0_scatter.pdf", replace

twoway ///
	(line PRD_difference_0 year, lw(thick) lc(edkblue)) ///
	(line PRD_0_1_moe year, lc(edkblue) lw(medium) lp(dash)), ///
	xlab(2003(1)2015, angle(45)) ///
	yline(0, lp(dash) lc(black)) ///
	ylab(-.005(.005).04) ///
	ytitle("Change in PRD" " ") ///
	title(Effect of appeals on PRD) subtitle(Single-family homes) ///
	legend(lab(1 "Change in PRD" "caused by appeals") ///
		lab(2 "Margin of error" "for first-pass PRD"))
graph save "$graphFolder\PRD_effect0.gph", replace

twoway ///
	(line PRD_difference_1 year, lw(thick) lc(edkblue)) ///
	(line PRD_1_1_moe year, lc(edkblue) lw(medium) lp(dash)), ///
	xlab(2003(1)2015, angle(45)) ///
	yline(0, lp(dash) lc(black)) ///
	ylab(-.005(.005).04) ///
	ytitle("Change in PRD" " ") ///
	title(Effect of appeals on PRD) subtitle(Condominiums) ///
	legend(lab(1 "Change in PRD" "caused by appeals") ///
		lab(2 "Margin of error" "for first-pass PRD"))
graph save "$graphFolder\PRD_effect1.gph", replace

grc1leg  "$graphFolder\PRD_effect0.gph" ///
"$graphFolder\PRD_effect1.gph", ///
	subtitle(2003-2015) 
graph export "$graphFolder\PRD_graph.eps", replace
graph export "$graphFolder\PRD_graph.pdf", replace

// Table for paper
use "$resultsFolder\PRD", clear
stack PRD_1_1 PRD_1_1_moe PRD_1_2 PRD_1_2_moe PRD_results_16 ///
PRD_difference_1 PRD_0_1 PRD_0_1_moe PRD_0_2 PRD_0_2_moe PRD_results_06  ///
PRD_difference_0, into(PRD1 PRD1_moe PRD2 PRD2_moe N PRD_difference) clear
g year=2002+_n if _stack==1
replace year=1989+_n if _stack==2

lab var year "Year"
lab var PRD1 "First-pass assessments"
lab var PRD2 "Final assessments"
lab var PRD_difference "Effect of appeals on PRD"
lab var PRD1_moe "Margin of error for first-pass PRD"
lab var N "Number of sales"
texsave year N PRD1 PRD1_moe PRD2 PRD_difference using "$tableFolder\PRD.tex", ///
	replace varlabels frag title(Effect of appeals on PRD by year)
//Manually finish table in LaTex

//PRB 
clear
svmat PRB_results
rename PRB_results1 year
rename PRB_results2 PRB1
rename PRB_results3 PRB1_moe
rename PRB_results4 PRB2
rename PRB_results5	PRB2_moe
rename PRB_results6	N
g PRB_difference=PRB2-PRB1

save "$resultsFolder\PRB", replace
export excel "$resultsFolder\PRB.xlsx", replace

twoway ///
	(line PRB1 year, lc(edkblue)), ///
	xlab(2003(1)2015, angle(45)) ///
	yline(0, lp(dash) lc(black)) ///
	title(Price-related bias)  legend(off)
graph save "$graphFolder\PRB.gph", replace

twoway ///
	(line PRB_difference year, lc(edkblue)), ///
	xlab(2003(1)2015, angle(45)) ///
	yline(0, lp(dash) lc(black)) ///
	ytitle("Change in PRB" " ") ///
	title(Effect of appeals on PRB) legend(off)
graph save "$graphFolder\PRB_effect.gph", replace

graph combine "$graphFolder\PRB.gph" "$graphFolder\PRB_effect.gph", ///
	subtitle(2003-2015) 
graph export "$graphFolder\PRB_graph.eps", replace
graph export "$graphFolder\PRB_graph.pdf", replace

// Suites & PRB table for paper
clear
svmat suites_results
rename suites_results1 year
rename suites_results2 suites
rename suites_results3 suites_moe

lab var suites "Suites Index"
lab var suites_moe "Margin of errror"

save "$resultsFolder\suites", replace
export excel "$resultsFolder\suites.xlsx", replace

merge 1:1 year using "$resultsFolder\PRB"

lab var year "Year"
lab var PRB1 "First-pass assessments"
lab var PRB2 "Final assessments"
lab var PRB_difference "Effect of appeals on PRB"
lab var PRB1_moe "Margin of error for first-pass PRB"
lab var N "Number of sales"

texsave year N PRB1 PRB2 PRB1_moe PRB_difference suites suites_moe using "$tableFolder\prb_suites.tex", ///
	replace varlabels frag title(Price-related Bias and Suites Indices)

	
