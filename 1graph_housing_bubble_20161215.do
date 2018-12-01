use "$dataFolder/Berry_Ross_Sales_data", clear

// Graph the housing bubble 
collapse (median) value (count) tract2010, by(taxyear tri)
drop if tri==.
reshape wide value tract2010, i(taxyear) j(tri)
twoway (line value1 taxyear, lw(thick) lc(green)) ///
		(line value2 taxyear, lw(thick) lc(ebblue)) ///
		(line value3 taxyear, lw(thick) lc(orange)), ///
	xlab(2003(1)2015, angle(45)) xtitle(Tax year) ///
	ytitle("Sale value of homes" "(net personal property)" " ") ///
	legend(lab( 1 "Chicago") lab(2 "NW Suburbs") ///
	lab( 3 "SW Suburbs") rows(1)) ylab(150000 "$150k" 200000 "$200k" ///
	250000 "$250k" 300000 "$300k" 350000 "$350k") ///
	title(Median sale value of homes) ///
	subtitle(by triennial reassessment area)
graph save "$graphFolder/tmp1.gph", replace

twoway (line tract20101 taxyear, lw(thick) lc(green)) ///
		(line tract20102 taxyear, lw(thick) lc(ebblue)) ///
		(line tract20103 taxyear, lw(thick) lc(orange)), ///
	xlab(2003(1)2015, angle(45)) xtitle(Tax year) ///
	ytitle("Residential sales" "(thousands of sales)" " ") ///
	legend(lab( 1 "Chicago") lab(2 "NW Suburbs") ///
	lab( 3 "SW Suburbs") rows(1)) ///
	title(Volume of residential sales) ///
	subtitle(by triennial reassessment area)
graph save "$graphFolder/tmp2.gph", replace

grc1leg "$graphFolder/tmp1.gph" "$graphFolder/tmp2.gph"

graph export "$graphFolder/bubble.eps", replace

erase "$graphFolder/tmp1.gph"
erase "$graphFolder/tmp2.gph"
