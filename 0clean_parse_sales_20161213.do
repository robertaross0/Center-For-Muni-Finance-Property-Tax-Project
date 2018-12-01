clear
set obs 1
g taxyear=.
save "$dataFolder/residential_sales.dta" ,replace
lab data "Residential property sales in Cook County, IL"
clear

forvalues year=2002(1)2015{

quietly import delimited "$rawdataFolder\res_sales`year'.csv", clear  stringcols(2, 9)

ren pin pin14

lab var pin10 "Property Idenitification Number (first 10 digits)"
lab var neighnum "Neighborhood number"
lab var town "Township"
lab var ward "Ward"
lab var district_n "State House district"
lab var senatedist "State Senate district"
lab var tri "Triennial Area"
lab var pin14 "Property Idenitification Number"
lab var joinyr "Join year"
lab var taxyear "Tax Year"
lab var bor_class "Classification"
lab var netconsideration "Sale price (net of personal property)"
lab var bor_ccao_ass "Final assessment (from CCAO files)"
lab var bor_ass_final "Final assesment (as calculated by Tribune)"
lab var bor_val_final "Final market value (as calculated by Tribune)"
lab var townneigh "Township and Neighborhood numbers"
lab var area "Area (first two digits of PIN)"
lab var bor_majclass "Major Classification (residential is 2)"
lab var bor_valratio "Sales ratio"
lab var bor_assratio "Assessment ratio"

duplicates drop pin14, force
rename bor_class class
rename netconsideration value
rename bor_majclass maj_class
keep pin* tri taxyear class value maj_class

 
append using "$dataFolder/residential_sales.dta" 
sort pin14 taxyear
save "$dataFolder/residential_sales.dta" , replace
}

clear all
