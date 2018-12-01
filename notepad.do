	version 14
	args y x 
	confirm var `y'
	confirm var `x'
	tempname ymean yn
	mean `y' [fw=`x'] 
	local `ymean'=r(mean)
	return scalar n_`y'=r(N)
	sum `y'
	return scalar n_`x'
	return scalar prd=`ymean'/r(mean)
