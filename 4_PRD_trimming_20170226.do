log using "$logFolder\prd_trimming.txt", text name(prd_trimming) replace
use "$dataFolder/Ross_Sales_data.dta", clear

// TRIMMING QUESTION: IIAO says 1.5X the interquartile range
// I use 1% on either end
// How different?
//First, identify the cutpoints for trimming
sum ratio if taxyear==2011, detail
display "upper bound using 1.5XIRQ= " r(p50)+1.5*(r(p75)-r(p25))
local ub_irq=r(p75)+(1.5*(r(p75)-r(p25)))
display "upper bound using 99th percentile= " r(p99)
local p99=r(p99)
display "lower bound using 1.5XIRQ= " r(p50)-1.5*(r(p75)-r(p25))
local lb_irq=r(p25)-(1.5*(r(p75)-r(p25)))
display "lower bound using 1st percentile= " r(p1)
local p1=r(p1)
sum value if ratio>`ub_irq' & taxyear==2011 | ratio<`lb_irq' & taxyear==2011
sum value if ratio>`p99' & taxyear==2011 | ratio<`p1' & taxyear==2011
// Shown on the distribution
hist ratio, percent ///
addplot(pci 0 `lb_irq' 10 `lb_irq', lc(orange) lp(dash) ||  ///
pci 0 `ub_irq' 10 `ub_irq', lc(orange) lp(dash) || ///
pci 0 `p1' 10 `p1', lc(blue) lp(dash) || ///
pci 0 `p99' 10 `p99', lc(blue) lp(dash)) ///
legend(lab(2 "IIAO trim") lab(3 "IIAO trim") lab(4 "1% trim") lab(5 "1% trim")) 
graph export "$graphFolder\trim.pdf", replace
//How does the trimming impact PRD?

		//PRD with 1% trim
		quietly mean ratio [fw=value] if taxyear==2011 & ratio>`p1' & ratio<`p99'
		quietly mat table=r(table)
		quietly sum ratio if taxyear==2011 & ratio>`p1' & ratio<`p99'
		display "PRD with 1% trim= " r(mean)/table[1,1]
		
		//PRD with IRQ trim
		quietly mean ratio [fw=value] if taxyear==2011 & ratio>`lb_irq' & ratio<`ub_irq'
		quietly mat table=r(table)
		quietly sum ratio if taxyear==2011 & ratio>`lb_irq' & ratio<`ub_irq'
		display "PRD with IRQ trim= " r(mean)/table[1,1]
		
		//PRD with 1% trim-FIRST PASS
		quietly mean ratio1 [fw=value] if taxyear==2011 & ratio>`p1' & ratio<`p99'
		quietly mat table=r(table)
		quietly sum ratio1 if taxyear==2011 & ratio>`p1' & ratio<`p99'
		display "First pass  PRD with 1% trim= " r(mean)/table[1,1]
		
		//PRD with IRQ trim-FIRST PASS
		quietly mean ratio1 [fw=value] if taxyear==2011 & ratio>`lb_irq' & ratio<`ub_irq'
		quietly mat table=r(table)
		quietly sum ratio1 if taxyear==2011 & ratio>`lb_irq' & ratio<`ub_irq'
		display "First pass PRD with IRQ trim= " r(mean)/table[1,1]
		
// I wrote an .ado file to calculate PRD using two differnt trim settings,
// and a bootstrapped margin of error as well
 display "$S_TIME  $S_DATE"
	prd ratio value 2011 1
 display "$S_TIME  $S_DATE"
	prd ratio value 2011 2
 display "$S_TIME  $S_DATE"

log off
log close


// Calculate PRD with IRQ trim

use "$dataFolder/Ross_Sales_data.dta", clear

mat PRD_results_trim_0=J(13,6,.)
mat PRD_results_trim_1=J(13,6,.)

//PRD by condo
foreach condo in 0 1 {
preserve 
keep if condo==`condo'
forval year=2003(1)2015{
local row=`year'-2002
mat PRD_results_trim_`condo'[`row',1]=`year'

	//PRD calculation
		set seed 1
		prd ratio1 value `year' 2 //This command is coded in prd.ado
		mat PRD_results_trim_`condo'[`row',2]=r(prd)
		mat PRD_results_trim_`condo'[`row',3]=1.96*sqrt(r(variance))

		
		set seed 1
		prd ratio value `year' 2
		mat PRD_results_trim_`condo'[`row',4]=r(prd)
		mat PRD_results_trim_`condo'[`row',5]=1.96*sqrt(r(variance))
		
		quietly sum ratio if taxyear==`year'
		mat PRD_results_trim_`condo'[`row', 6]=r(N)
}
restore
}

clear
svmat PRD_results_trim_0
rename PRD_results_trim_01 year
rename PRD_results_trim_02 PRD_trim_0_1
rename PRD_results_trim_03 PRD_trim_0_1_moe
rename PRD_results_trim_04 PRD_trim_0_2
rename PRD_results_trim_05	PRD_trim_0_2_moe
g PRD_difference_trim_0=PRD_trim_0_2-PRD_trim_0_1

save "$resultsFolder\PRD_trim", replace

clear
svmat PRD_results_trim_1
rename PRD_results_trim_11 year
rename PRD_results_trim_12 PRD_trim_1_1
rename PRD_results_trim_13 PRD_trim_1_1_moe
rename PRD_results_trim_14 PRD_trim_1_2
rename PRD_results_trim_15	PRD_trim_1_2_moe
g PRD_difference_trim_1=PRD_trim_1_2-PRD_trim_1_1

merge 1:1 year using "$resultsFolder\PRD"
drop _merge 
save "$resultsFolder\PRD_trim", replace
export excel "$resultsFolder\PRD_trim.xlsx", replace


