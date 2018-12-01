use "$dataFolder/Ross_Sales_data.dta", clear

// In order to calculate effective tax rates supposing no appeals
// we need to calculate taxes using av1
// For simplicity, we assume that the statutory rate will remain unchanged
// This assumption is not consistent with reality, but it will be most 
// favorable to the appeals process

g appeal_effect=(ratio-ratio1)/ratio1
lab var appeal_effect "Effect of appeals on assessment ratio"

binscatter ratio1 ratio value if taxyear>2008, nq(20) ///
	linetype(connect) 	///
	ytitle("Ratio of assessments" "to sale price"" ") ///
	xtitle(" " "Sale value") ///
	legend(lab(1 "Pre-appeal") lab(2 "Post-appeal")) ///
	xlab(250000 "$250K" 500000 "$500K" 1000000 "$1 mln" 1300000 "$1.3 mln") ///
	subtitle(Assessment ratios)
graph save "$graphFolder\tmp1.gph", replace

binscatter appeal_effect value if taxyear>2008, nq(20) ///
	linetype(connect) ///
	ytitle("Effect of appeals on" "assessment ratio" "") ///
	ylab(-.06 "-6%" -.05 "-5%" -.04 "-4%" -.03 "-3%") ///
	xlab(250000 "$250K" 500000 "$500K" 1000000 "$1 mln" 1300000 "$1.3 mln") ///
	xtitle(" " "Sale value") ///
	subtitle("Difference in pre- and" "post- assessment ratios")
graph save "$graphFolder\tmp2.gph", replace

grc1leg "$graphFolder/tmp1.gph" "$graphFolder/tmp2.gph", ///
	subtitle(Cook County 2009-2015)
graph export "$graphFolder/appealeffect.eps", replace

erase "$graphFolder/tmp1.gph"
erase "$graphFolder/tmp2.gph"
