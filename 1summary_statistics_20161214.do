
use "$dataFolder/Berry_Ross_Sales_data", clear

// Number of observations by year and type
tabstat pin appeal, by(taxyear) stats(count)
tabstat condo sf, by(taxyear) stats(sum)

// Distribution of home values
tabstat value, by(taxyear) stats(p25 p50 p75)
forval triennial=1(1)3{
	display `triennial'
	tabstat value if tri==`triennial', by(taxyear) stats(p25 p50 p75)
	}

