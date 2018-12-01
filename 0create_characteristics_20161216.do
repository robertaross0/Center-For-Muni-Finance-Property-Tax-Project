
clear
set obs 1
g pin=.
lab data "Residential property characteristics in Cook County, IL"
save "$dataFolder/property_characteristics", replace

forval year=2003(1)2013{
	import delimited "$rawdataFolder\neqb`year'.txt", clear  stringcols(1)
	rename v1 pin14
	rename v2 type
	rename v3 use
	rename v4 apts
	rename v5 walls
	rename v6 roof
	rename v7 rooms
	rename v8 beds
	rename v9 basement
	rename v10 basementfin
	rename v11 centralheat
	rename v12 otherheat
	rename v13 ac
	rename v14 fireplaces
	rename v15 attic
	rename v16 atticfin
	rename v17 fb
	rename v18 hb
	rename v19 plantype
	rename v20 designtype
	rename v21 quality
	rename v22 rnv
	rename v23 site
	rename v24 garagesize
	rename v25 garageconstruction
	rename v26 garageattached
	rename v27 garagearea
	rename v28 garagesize2
	rename v29 garageconstruction2
	rename v30 garageattached2
	rename v31 garagearea2
	rename v32 porch
	rename v33 imp
	rename v34 squarefoot
	rename v35 repair
	rename v36 neqclass
	rename v37 age
	rename v38 hdsf
	rename v39 nbhd
	rename v40 mltind
	rename v41 mltcode
	rename v42 vol
	rename v43 ncu
	
	append using "$dataFolder/property_characteristics"
	sort pin14
	save "$dataFolder/property_characteristics", replace
}
	
	lab var pin14 "14 digit property index number"
	lab var type "Type of residence"
	lab var use "Single or multi-family"
	lab var apts "Number of apartments"
	lab var walls "Exterior construction"
	lab var roof "Roof construction"
	lab var rooms "Number of rooms"
	lab var beds "Number of bedrooms"
	lab var basement "Construction of basement"
	lab var basementfin "Finished basement"
	lab var centralheat "Central heating"
	lab var otherheat "Other heating"
	lab var ac "Central air conditioning"
	lab var fireplaces "Number of fireplaces"
	lab var attic "Type of attic"
	lab var atticfin "Finished attic"
	lab var fb "Full bathrooms"
	lab var hb "Half bathrooms"
	lab var plantype "Architectural plan type"
	lab var designtype "? Cathedral ceilings?"
	lab var quality "Construction quality"
	lab var rnv "Construction rennovation or new"
	lab var site "Site desireability"
	lab var garagesize "Size of garage"
	lab var garageconstruction "Type of garage construction"
	lab var garageattached "Attached garage"
	lab var garagearea "Garage in area"
	lab var garagesize2 "Size of garage"
	lab var garageconstruction2 "Type of garage construction"
	lab var garageattached2 "Attached garage"
	lab var garagearea2 "Garage in area"
	lab var porch "Enclosed porch"
	lab var imp "Additional improvements"
	lab var squarefoot "Building square foot area"
	lab var repair "State of repair"
	lab var neqclass "Property class"
	lab var age "Age of structure"
	lab var hdsf "?"
	lab var nbhd "?"
	lab var mltind "?"
	lab var mltcode "?"
	lab var vol "Volume"
	lab var ncu "?"


	label define use 1 "Single-family" 2 "Multi-family"
	lab val use use
	replace apts=apts+1 //this is dumb
	replace apts=0 if apts==7
	lab define walls 1 "Wood frame" 2 "Masonry" 3 "Wood frame and masonry" 4 "Stucco"
	lab val walls walls
	lab define basement1 1 "Full basement" 2 "Slab basement" 3 "Partial basement" 4 "crawlspace"
	lab val basement basement1
	lab define basementfin 1 "Formal rec-room" 2 "Apartment" 3 "Unfinished"
	lab val basementfin basementfin
	lab define centralheat 1 "Warm air" 2 "Steam" 3 "Electric" 4 "None"
	lab val centralheat centralheat
	lab define otherheat 1 "Floor furnace" 2 "Unit heater" 3 "Stove" 4 "Solar" 5 "None"
	lab val otherheat otherheat
	lab define yesno 1 "Yes" 2 "No"
	lab val ac yesno
	lab define attic 1 "Full" 2 "Partial" 4 "None"
	lab val attic attic
	lab define atticfin 1 "Living area" 2 "Apartment" 3 "Unfinished"
	lab val atticfin atticfin
	lab define plantype 1 "Custom" 2 "Stock plan"
	lab val plantype plantype
	lab define quality 1 "Delux" 2 "Average" 3 "Crappy"
	lab val quality quality
	lab val rnv yesno
	lab define site 1 "Adds to value" 2 "Not relevent to value" 3 "Detracts from value"
	lab val site site
	lab define repair 1 "Good" 2 "Average" 3 "Poor"
	lab val repair repair
	lab define porch 1 "Wood" 2 "Masonry" 3 "None"
	lab val porch porch

	replace garagesize= 1.5 if garagesize==2
	replace garagesize= 2 if garagesize==3
	replace garagesize= 2.5 if garagesize==4
	replace garagesize= 3 if garagesize==5
	replace garagesize= 3.5 if garagesize==6
	replace garagesize= 0 if garagesize==7
	replace garagesize= 4 if garagesize==8
	drop garagesize2

	lab define garageconstruction 1 "Wood frame" 2 "Masonry" 3 "Wood and masonry" 4 "Stucco"
	lab val garageconstruction garageconstruction
	lab val garageattached yesno
	lab val garagearea yesno
	lab define type 1 "1-story" 2 "2-story" 3 "3-story" 4 "multilevel" 5 "?"
	destring type, replace
	lab val type type
	

	sort pin14
	drop pin
	duplicates drop pin14, force


save "$dataFolder/property_characteristics", replace

