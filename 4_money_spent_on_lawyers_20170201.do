// Calculate the amount of money spent on lawyers
// Equalization factors found here http://www.cookcountyclerk.com/tsd/DocumentLibrary/Equalization%20Factor%20Overview%201973-current.pdf

use "$dataFolder\appeals", clear
drop if lawyer=="" //No lawyer
keep if taxyear>2008
merge 1:1 pin14 taxyear using "$dataFolder\taxes.dta"
keep if _merge==3
drop if lawyer==tnam //Self-represented taxpayers

quietly sum appeal if taxyear==2015
local a=r(sum)
quietly sum rate if taxyear==2015
local b=r(mean)
display `a'*2.6685*`b'/100/10


collapse (sum) appeal (mean) rate, by(taxyear)
replace rate=rate/1000

g eav=.

replace eav=appeal*2.6685 if taxyear==2015
replace eav=appeal*2.7253 if taxyear==2014
replace eav=appeal*2.6621 if taxyear==2013
replace eav=appeal*2.8056 if taxyear==2012
replace eav=appeal*2.9706 if taxyear==2011
replace eav=appeal*3.3 if taxyear==2010
replace eav=appeal*3.3701 if taxyear==2009

g tax=eav*rate
sum tax
display r(sum)

clear
