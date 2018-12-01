
program suites, rclass
	version 14
	args taxes value year

set matsize 1000
mat suites=J(1000, 1, .)
display "Suites Index calculation, using 1,000 bootstrapped samples to estimate variance"
display "Trim top and bottom 1\%"
display "Chicago properties only"

preserve
quietly keep if taxyear==`year' & tri==1
quietly g random = .
quietly g sample=.
quietly g x=.
quietly g y=.

// Trim top and bottom 1%
display `year'
sum value, detail
quietly drop if value<r(p1) | value>r(p99)
sum taxes, detail
quietly drop if taxes<r(p1) | taxes>r(p99)

quietly sum taxes
local N=r(N)

// Resampling 1,000 times, using various size samples
	forval i=1(1)20{
		forval b=.49(.01).98{
			quietly replace random = runiform()
			quietly sort random
			quietly replace sample=(_n<=`b'*`N')
			quietly sort sample value			
			quietly sum value if sample==1
			local sum=r(sum)

			quietly replace x=sum(value)/`sum' if sample==1

			quietly sum taxes if sample==1
			local sum=r(sum)
			quietly replace y=sum(taxes)/`sum' if sample==1

			quietly sum y if sample==1
			local A=r(sum)
			quietly sum x if sample==1
			local B=r(sum)
			
			local row=(`b'-.48)*100+(`i'-1)*50
			mat suites[`row',1]=1-(`A'/`B')
	}
}
clear
	svmat suites
	quietly sum suites1
	quietly g dev=(suites1-r(mean))^2
	quietly sum dev
	return scalar variance=r(mean)
restore

// Now calculate the suites index

sort value
quietly sum value if taxyear==`year' & tri==1
local sum=r(sum)
quietly g x=sum(value)/`sum' if  taxyear==`year' & tri==1

quietly sum taxes if  taxyear==`year' & tri==1
local sum=r(sum)
quietly g y=sum(taxes)/`sum' if taxyear==`year' & tri==1

quietly sum y if taxyear==`year' & tri==1
local A=r(sum) 
quietly sum x if taxyear==`year' & tri==1
local B=r(sum)
drop x y
display 1-(`A'/`B')

return scalar suites=1-(`A'/`B')

end
