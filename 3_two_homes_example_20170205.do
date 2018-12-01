use  "$dataFolder/Ross_Sales_data.dta", clear

keep if taxyear==2011 & percentile==25 | percentile==75
keep if appeal_flag==1 & condo==0 & appeal>0

set seed 1
sample 1, count by(percentile)

brows tname av1 av appeal value pcity tadres pstreet ratio ratio1 percentile ///
	white college medhinc  pin14 community

	
// for reference, this selected pins pin14 =
// 19063070050000
// 13112040170000
// when I ran it.

use  "$dataFolder/Ross_Sales_data.dta", clear
sum white medhinc college poverty condo if pcity=="STICKNEY"
sum white medhinc college poverty condo if community==33

keep if pin14=="19063070050000" | pin14=="13112040170000"

brows tname av1 av appeal value pcity tadres pstreet ratio ratio1 percentile ///
	white college medhinc  pin14 community 
brows taxes rate erate eav *ex av* pcity

display 2.9706*26880*6.433/100
display 2.9706*22602*6.433/100

display 2.9706*130000*6.433/1000
display 2.9706*309000*6.433/1000

// Cumulative effect tax shifting
use  "$dataFolder/Ross_Sales_data.dta", clear
quietly sum erate if taxyear==2011 & tri==1 & percentile==25, detail
local first=r(p25)
quietly sum erate if taxyear==2011 & tri==1 & percentile==75, detail
local last=r(p25)
display "The 25th percentile's 2011 effective tax rate was " ///
(`first'-`last')/`first'*100 "% higher than the 75th percentile's"

// Exercise: suppose revenues from sold properties each year were redistributed
// uniformly
use  "$dataFolder/Ross_Sales_data.dta", clear
sum taxes  if taxyear==2011 & tri==1 
g taxes2=.
g adjustment=.
g adjustment_flag=.

forval year=2003(1)2015{
quietly sum erate if taxyear==`year'  & tri==1 , detail
	local ul=r(p99)
	local ll=r(p1)

quietly sum value if taxyear==`year' & tri==1 & erate>`ll' & erate<`ul'
local base=r(sum)
quietly sum taxes if taxyear==`year' & tri==1 & erate>`ll' & erate<`ul'
local levy=r(sum)
display "Year= " `year' "; rate=" `levy'/`base'
quietly replace taxes2=`levy'/`base'*value if taxyear==`year' & tri==1 
quietly replace adjustment=taxes2-taxes if taxyear==`year' & tri==1 
}
quietly replace adjustment_flag=(adjustment<0)

tabstat adjustment if taxyear==2011, stats(count mean sum) by(adjustment_flag)
quietly sum adjustment if adjustment_flag==1
local dec=r(mean)
quietly sum adjustment if adjustment_flag==0
local inc=r(mean)


// Histrogram of adjustments
/*
bihist adjustment if adjustment<`ub' & adjustment>`lb' & taxyear==2011, by(adjustment_flag) 
*/
quietly sum adjustment if taxyear==2011 & tri==1, detail
local ub=r(p99)
local lb=r(p1)
local N=r(N)

// graph showing effective tax rate adjustment
collapse erate value taxes taxes2 adjustment, by(percentile taxyear tri)
foreach p in 1 25 50 75 99 {
quietly sum value if taxyear==2011 & tri==1, detail
	local p`p'=round(r(p`p'), 10000)/1000
}
twoway (line adjustment percentile, lw(medium) lc(ebblue)) ///
		if taxyear==2011 & tri==1 & percentile>1 & percentile<99, ///
		yline(0,  lc(erose) lw(thick) lp(dash)) ///
		ytitle("Avg. difference in uniform rate and" "actual tax bills" "(Thousands of $)" " ") ///
		xtitle(" " "Sale price of property" "(Thousands of $)") ///
		xlab(0 "`p1'" 25 "`p25'" 50 "`p50'" 75 "`p75'" 100 "`p99'") ///
		ylab(-2000 "-2" 0 "0" 2000 "2" 4000 "4" 6000 "6" 8000 "8")

graph save "$graphFolder\adjustment_line1.gph", replace

twoway (line erate percentile, lc(ebblue) lw(medium)) ///
	if taxyear==2011 & tri==1, ///
	xtitle(" " "Sale price of property" "(Thousands of $)") ///
	ytitle("Effective tax rate" "on housing wealth" ) ///
	ylab( .01 "1%" .01269 "Uniform rate" .02 "2%" .03 "3%", angle(60)) ///
	yline(.01269459, lc(erose) lw(thick) lp(dash)) ///
	xlab(0 "`p1'" 25 "`p25'" 50 "`p50'" 75 "`p75'" 100 "`p99'") 
graph save "$graphFolder\adjustment_line2.gph", replace

graph combine "$graphFolder\adjustment_line1.gph" "$graphFolder\adjustment_line2.gph", ///
	note(For `N' properties sold in Chicago in 2011) subtitle(2011)
graph export "$graphFolder\adjustment.eps", replace

// How many residential properties in the city in total?

use "$dataFolder\taxes", clear

