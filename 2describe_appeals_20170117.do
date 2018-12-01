// For this part, we use a file with ALL residential tax records and appeals,
// this file is built below and saved as a temporary file.
use "$dataFolder/appeals", clear
merge 1:1 pin14 taxyear using "$dataFolder/taxes"
keep if _merge!=1 // These are non-residential properties
drop _merge

g condo=(maj_descr=="NonReg Residential")
preserve //2015 didn't have a major_class variable, so I fill in as best I can
collapse (max) condo, by(pin14)
g taxyear=2015
save tmp, replace
restore
merge 1:1 pin14 taxyear using tmp
drop _merge
g pin10=substr(pin14,1,10)
// for the appeals analysis, also want to know size of building
preserve 
g units=1
collapse (sum) units, by(pin10 taxyear)
collapse (max) units, by(pin10)
save tmp, replace 
restore
merge m:1 pin10 using tmp
drop _merge
replace units=1000 if units>1000
save "$dataFolder\tmp", replace 

// Number of appeals over time is increaing
use "$dataFolder\tmp", clear
g appealed=(appeal!=.)
g appealed2=(appeal!=.)
collapse (sum) appealed (mean) appealed2, by(taxyear)
replace appealed=appealed/10000
twoway (line appealed taxyear) (line appealed2 taxyear, yaxis(2)), ///
	xlab(2003(2)2015) ///
	xtitle (Year) ///
	ytitle("Number of residential appeals" "(Tens of thousands)") ///
	ytitle(Percent of residential properties appealing, axis(2)) ///
	ylab(.1 "10%" .2 "20%", axis(2)) ///
	legend(lab(1 "Total appeals") lab(2 "% appealing")) ///
	title(Number of appeals)
graph export "$graphFolder/appeals1.eps", replace

// People are winning appeals more, and condos appeal more often
use "$dataFolder\tmp", clear
g appealed=(appeal!=.)
collapse (mean) win appealed, by(taxyear condo)
reshape wide appealed win, i(taxyear) j(condo)
drop if taxyear==2002 | taxyear==. | taxyear==2015

twoway (line appealed0 taxyear, lc(navy) lw(thick)) ///
		(line appealed1 taxyear, lc(maroon) lw(thick)), ///
	xlab(2003(2)2014) ///
	xtitle (Year) ///
	ylab(.1 "10%" .3 "30%" .5 "50%") ///
	ytitle("Percent of all" "properties appealing" " ") ///
	legend(lab(1 "Single Family") lab(2 "Condominiums")) ///
	title(Probability of appealing)
graph export "$graphFolder/appeals2.eps", replace
graph save "$graphFolder/appeals2.gph", replace

twoway (line win0 taxyear, lc(navy) lw(thick)) ///
		(line win1 taxyear, lc(maroon) lw(thick)), ///
	xlab(2003(2)2014) ///
	xtitle (Year) ///
	ylab(.4 "40%" .6 "60%" .8 "80%") ///
	ytitle("Percent of all properties" "winning an appeal" " ") ///
	legend(lab(1 "Single Family") lab(2 "Condominiums")) ///
	title(Probability of winning an appeal)
graph export "$graphFolder/appeals3.eps", replace
graph save "$graphFolder/appeals3.gph", replace


// The size of a condo building influences whether you appeal
use "$dataFolder\tmp", clear
g appealed=(appeal!=.)
binscatter appealed units if condo==1, nq(20) ///
	linetype(connect) lc(maroon) mc(maroon) ///
	ytitle("Probability of appealing" " ") ///
	xtitle("Number of units in" "condominium building") ///
	ylab(0 "0%" .2 "20%" .4 "40%", angle(90)) ///
	title(Probability of appealing) ///
	subtitle(By size of building)
graph export "$graphFolder/appeals4.eps", replace
graph save "$graphFolder/tmp3.gph", replace


	
