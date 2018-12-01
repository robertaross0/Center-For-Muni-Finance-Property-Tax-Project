program prd, rclass
	version 14
	args ratio value year trim
	set matsize 1000
	mat PRD=J(1000, 1, .)
	display "PRD calculation, using 200 bootstrapped samples to estimate variance"

preserve

quietly keep if taxyear==`year'
quietly sum ratio
local N1=r(N)
		
// trim argument tells Stata 1 = 1% trim, 2 = IRQ method mean+-IRQ
// trim==0 does not trim at all
if `trim'==0 {
}
else if `trim'==1 {
	foreach var in ratio ratio1{
			quietly sum `var', detail
			keep if `var'>r(p1) & `var'<r(p99)
		}
				quietly sum ratio, detail
				local N2=r(N)
				local trimmed=round((`N1'-`N2')/`N1'*100, .0001)
				display "Trim setting " `trim' " selected, " `trimmed' "% of sample trimmed"
}
else if `trim'==2 {
		foreach var in ratio ratio1{
			quietly sum `var', detail
				local ub_irq=r(p75)+(1.5*(r(p75)-r(p25)))
				local lb_irq=r(p25)-(1.5*(r(p75)-r(p25)))
			keep if `var'>`lb_irq' & `var'<`ub_irq'
		}
				quietly sum ratio, detail
				local N2=r(N)
				local trimmed=round((`N1'-`N2')/`N1'*100, .0001)
				display "Trim setting " `trim' " selected, " `trimmed' "% of sample trimmed"
}

		quietly g dev=.
		quietly g random = .
	forval i=1(1)2{
		forval b=49(1)98{ //bootstrapping proceedure 20 iterations of sample 
		// sizes ranging from 40% - 98% of the dataset
			quietly replace random = runiform()
			quietly sort random
			quietly sum ratio
			local sample=r(N)
			quietly mean `ratio' [fw=`value'] if taxyear==`year' & _n<=`sample'*(`b'/100)
			mat X=r(table)
			local wmean=X[1,1]
			quietly mean `ratio' if taxyear==`year' & _n<=`sample'*(`b'/100)
			mat X=r(table) 
			local mean=X[1,1]
			
			local row=(`b'-48)+(`i'-1)*50
			mat PRD[`row',1]=`mean'/`wmean'
			
			}
		}
clear
	svmat PRD
		quietly sum PRD1
		quietly g dev=(PRD1-r(mean))^2
		quietly sum dev
		local varaince=r(mean)
restore

quietly mean `ratio' [fw=`value'] if taxyear==`year'
mat X=r(table)
local wmean=X[1,1]
quietly mean `ratio' if taxyear==`year'
mat X=r(table) 
local mean=X[1,1]

return scalar trimmed=`trimmed'
return scalar variance=`varaince'
return scalar prd=`mean'/`wmean'

end
