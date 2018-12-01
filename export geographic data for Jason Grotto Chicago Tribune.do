use "$dataFolder\Ross_Sales_data", clear
g N=1
collapse (median) ratio1 ratio value erate taxes av av1 ///
	(sum) N (mean) appeal_flag, by(taxyear)

lab var taxyear "Tax year"
lab var ratio1 "Median first-pass assessment ratio"
lab var ratio "Median final assessment ratio"
lab var taxes "Median tax bill"
lab var value "Median sale price"
lab var erate "Median effective tax rate"
lab var av "Median assessed value" 
lab var av1 "Median First-Pass assessed value"
lab var N "Number of sales"
lab var appeal_flag "Average rate of appeal for sold properties"
order taxyear N, first
texsave using "$tableFolder\summary.tex", ///
	replace varlabels frag title(Summary statistics by taxyear)

use "$dataFolder\Ross_Sales_data", clear
g N=1
collapse (median) ratio1 ratio value erate taxes av av1 ///
(sum) N (mean) appeal_flag white black hispanic nativ asian two medhinc college poverty condo ///
	(first) community, by(tract2010 taxyear)
lab var taxyear "Tax year"
lab var ratio1 "Median first-pass assessment ratio"
lab var ratio "Median final assessment ratio"
lab var taxes "Median tax bill"
lab var value "Median sale price"
lab var erate "Median effective tax rate"
lab var av "Median assessed value" 
lab var av1 "Median First-Pass assessed value"
lab var N "Number of sales"
lab var appeal_flag "Average rate of appeal for sold properties"
lab var condo "% condominium properties"
lab var white "% white"
lab var black "% black"
lab var asian "% asian"
lab var hispanic "% hispanic"
lab var two "% two or more races"
lab var nativ "% native american"
lab var medhinc "Median HH income"
lab var college "% holding a BA"
lab var poverty "% below federal poverty rate"

lab var community "community area"
lab val community communities
tostring taxyear, replace
order taxyear N community ratio1 ratio value erate taxes av av1 appeal_flag condo, first
sutex ratio1 ratio value erate taxes av av1 appeal_flag condo ///
white hispanic nativ asian two medhinc college poverty, ///
labels digits(0)

save tmp, replace
use "$dataFolder\Berry_Ross_Sales_data", clear
g N=1
keep if taxyear>2008 
collapse (median) ratio1 ratio value erate taxes av av1 ///
(sum) N (mean) appeal_flag white black hispanic nativ asian two medhinc college poverty condo ///
	(first) community, by(tract2010)
g taxyear="2009-2015"
append using tmp

lab var taxyear "Tax year"
lab var ratio1 "Median first-pass assessment ratio"
lab var ratio "Median final assessment ratio"
lab var taxes "Median tax bill"
lab var value "Median sale price"
lab var erate "Median effective tax rate"
lab var av "Median assessed value" 
lab var av1 "Median First-Pass assessed value"
lab var N "Number of sales"
lab var appeal_flag "Average rate of appeal for sold properties"
lab var condo "% condominium properties"
lab var white "% white"
lab var black "% black"
lab var asian "% asian"
lab var hispanic "% hispanic"
lab var two "% two or more races"
lab var nativ "% native american"
lab var medhinc "Median HH income"
lab var college "% holding a BA"
lab var poverty "% below federal poverty rate"

lab var community "community area"
lab val community communities
tostring taxyear, replace
order taxyear N community ratio1 ratio value erate taxes av av1 appeal_flag condo, first

lab data "Geographic property data, prepared for Jason Grotto, Chicago Tribune"
note: Compiles TS
note: Rob Ross, raross1217@gmail.com

save "$dataFolder\geo_export", replace
save "${root}\public material\geo_export", replace

export delimited "${root}\public material\geo_export.csv", replace


use "$dataFolder\Ross_Sales_data", clear
g N=1
keep if taxyear>=2011

tostring pzip, gen(pzip2) format(%09.0f) 
g short_zip=substr(pzip2,1,5)
collapse (median) ratio1 ratio value erate taxes av av1 ///
(sum) N (mean) appeal_flag white black hispanic nativ asian two medhinc college poverty condo ///
, by(short_zip)
capture lab var taxyear "Tax year"
lab var ratio1 "Median first-pass assessment ratio"
lab var ratio "Median final assessment ratio"
lab var taxes "Median tax bill"
lab var value "Median sale price"
lab var erate "Median effective tax rate"
lab var av "Median assessed value" 
lab var av1 "Median First-Pass assessed value"
lab var N "Number of sales"
lab var appeal_flag "Average rate of appeal for sold properties"
lab var condo "% condominium properties"
lab var white "% white"
lab var black "% black"
lab var asian "% asian"
lab var hispanic "% hispanic"
lab var two "% two or more races"
lab var nativ "% native american"
lab var medhinc "Median HH income"
lab var college "% holding a BA"
lab var poverty "% below federal poverty rate"

lab var short_zip "Zip Code"
capture lab val community communities
capture tostring taxyear, replace
order N ratio1 ratio value erate taxes av av1 appeal_flag condo, first
sutex ratio1 ratio value erate taxes av av1 appeal_flag condo ///
white hispanic nativ asian two medhinc college poverty, ///
labels digits(0)
export delimited "C:\Users\Robert A Ross\Dropbox\Property Tax Regressivity Jan2017\CMF_property_tax_study_May_2017\geo_export_byshortzip_after2010.csv", replace


use "$dataFolder\Ross_Sales_data", clear
g N=1
collapse (median) ratio1 ratio value erate taxes av av1 ///
(sum) N (mean) appeal_flag white black hispanic nativ asian two medhinc college poverty condo ///
, by(community taxyear)
lab var taxyear "Tax year"
lab var ratio1 "Median first-pass assessment ratio"
lab var ratio "Median final assessment ratio"
lab var taxes "Median tax bill"
lab var value "Median sale price"
lab var erate "Median effective tax rate"
lab var av "Median assessed value" 
lab var av1 "Median First-Pass assessed value"
lab var N "Number of sales"
lab var appeal_flag "Average rate of appeal for sold properties"
lab var condo "% condominium properties"
lab var white "% white"
lab var black "% black"
lab var asian "% asian"
lab var hispanic "% hispanic"
lab var two "% two or more races"
lab var nativ "% native american"
lab var medhinc "Median HH income"
lab var college "% holding a BA"
lab var poverty "% below federal poverty rate"

lab var community "community area"
lab val community communities
tostring taxyear, replace
order taxyear N community ratio1 ratio value erate taxes av av1 appeal_flag condo, first
sutex ratio1 ratio value erate taxes av av1 appeal_flag condo ///
white hispanic nativ asian two medhinc college poverty, ///
labels digits(0)
export delimited "C:\Users\Robert A Ross\Dropbox\Property Tax Regressivity Jan2017\CMF_property_tax_study_May_2017\geo_export_bycommunity.csv", replace

save tmp, replace

erase tmp.dta
clear all

        

