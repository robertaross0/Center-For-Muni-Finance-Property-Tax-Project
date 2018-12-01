// We received new data from the assessor which contains all appeals for the
// time period under consideration
import delimited "$rawdataFolder\appeals.csv", clear stringcols(2, 3, 15)
ren pin pin14
drop pin2
ren attorneytaxrep lawyer
ren win_reduction appeal

g online=(strpos(appealnum, "6")==1)
keep pin14 *win* appeal taxyear lawyer online

replace pin14="0"+pin14 if strlen(pin14)==13 //"leading zero" added to pins less
// than 14 digits
quietly sort pin14 taxyear
quietly note: Compiled TS
quietly note: Residential properties assessed at 10% of estimated market value

quietly lab var online "Dummy for appealed online"
quietly lab var lawyer "Name of tax rep"
quietly lab var appeal "Total adjustments to assessed value from appeals"
quietly lab var pin14 "14 digit unique property identifier"
quietly lab var taxyear "Year tax payments applied to"
quietly lab var ass_win "Dummy for appeal win at assessor"
quietly lab var bor_win "Dummy for appeal win at Board of review"
quietly lab var win "Dummy for appeal win"

quietly save "$dataFolder/appeals", replace

// Want to include first-pass assessments 

forval year=2003(1)2015{
import delimited "$rawdataFolder\res_p1_`year'.csv", clear stringcols(9)
keep pin taxyear p1_ccao_ass
ren pin pin14
ren p1_ccao_ass av1

lab var av1 "First-pass assessed value"
duplicates drop pin14, force
merge 1:1 pin14 taxyear using "$dataFolder/appeals"
drop _merge
quietly save "$dataFolder/appeals", replace
}
clear all
