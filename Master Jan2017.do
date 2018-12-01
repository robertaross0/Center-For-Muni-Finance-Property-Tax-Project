********************************************************************************
**
**Regressivity in Property Tax Assessments and Appeals in Cook County, IL
**analysis conducted by Rob Ross
**at the Harris School of Public Policy's Center for Municipal Finance
**January, 2017
**In partnership with Jason Grotto, Chicago Tribune
**
** Raw data required: appeals`year'.csv for years 2003-2015
**
** Primary datasets used in analysis are: Ross_Sales_data, appeals.dta,
** taxes.dta
**
** Note: user must specify {root} file. File structure is
**				File structure is as follows
**			${root}-->rawdata
**				   -->data
**				   -->dofiles
**				   -->results
**						-->tables
**						-->graphs
**						-->maps
**						-->logs
**	
** Note: Step 0 requires 16GB of RAM to run.
**	Last Update:	2/22/2017
*******************************************************************************

clear all 
set more off
clear all
set more off, permanently

********************
**Set User Folders**
**User 1: Rob Ross
**User 2: Christopher Berry
********************

local user 1

if `user' == 1 {
	global root "C:\Users\Robert A Ross\Dropbox\Property Tax Regressivity Jan2017"
}

else if `user' == 2 {
	//Put Chris Berry's root folder here.
} 

global doFolder = "${root}/dofiles"
global rawdataFolder = "${root}/rawdata"
global dataFolder = "${root}/data"
global resultsFolder = "${root}/results"
	global tableFolder = "${resultsFolder}/tables"
	global graphFolder = "${resultsFolder}/graphs"
	global logFolder = "${resultsFolder}/logs"
	global mapFolder = "${resultsFolder}/maps"

cap mkdir $resultsFolder
cap mkdir $rawdataFolder
cap mkdir $tableFolder
cap mkdir $graphFolder
cap mkdir $logFolder
cap mkdir $mapFolder

set scheme s1color 

// Step 0 - Clean, parse, and combine raw data into usable dataset
//This file transforms raw appeal data into a single dta file with all years
//2003-2015
do "$doFolder/0clean_parse_appeals20161213.do" //This file transforms raw 
// tax bill data into a single dta file will all years
//2002-2015. I keep only residential properties.
do "$doFolder/0clean_parse_taxbills_20161213.do" //This file transforms raw 
// sales data into a single sales file with all years
//2002-2015
do "$doFolder/0clean_parse_sales_20161213.do" // This file creates a file 
// of property-specific characteristics which 
do "$doFolder/0create_characteristics_20161216.do" // The next files need to 
// be executed in sequence 
// This file prepares census demographic characteristics from the Census 
do "$doFolder/0clean_parse_demovars_20161222.do"
// This file creates map files to be used for mapping later
do "$doFolder/0create_maps_20161219.do" 
// Next file requires maps files
// This file identifies the census tract and community area for each pin,
// and merges with demographic data.
do "$doFolder/0clean_parse_geographies.do"
//This file merges data and generates useful variables to form a final dataset
// for analysis
do "$doFolder/0compile_data_for_analysis_20161214.do"


//Step 1 - produce descriptive statistics for paper, basic graphs
// This fil summarizes the data
do "$doFolder/1summary_Statistics_20161214.do"
//This file graphs the housing bubble
do "$doFolder/1graph_housing_bubble_20161215.do"

// Step 2 - Describe appeals in Cook County
do "$doFolder/2describe_appeals_20170117.do"
do "$doFolder/2describe_appeals_forsoldproperties_20170118.do"
// This file graphs effective tax rates
do "$doFolder/2graph_effective_tax_rates_20161215.do"
//This file runs regressions to show correlates with appealing
do "$doFolder/2_regressions_20170206.do"

// Step 3 mapping
// This file maps effective tax rates
do "$doFolder/3map_effective_tax_rates_20161222.do"
do "$doFolder/3_demographic_correlations_20170120.do"

// Step 4 - PRD and PRB
// This file calcualtes two standard measures of regressivity and graphs them
// over time
do "$doFolder/4_PRB_PRD_20170118.do"
//This file calculates PRD with IRQ trimmiing
do "$doFolder/4_PRD_trimming_20170226.do"
// This file graphs effective tax rates before and after appeals
do "$doFolder/4_erate_prepostappeal_20170120.do"
//This file calculates the total amount of money spent on lawyers fees
do "$doFolder/4_money_spent_on_lawyers_20170201.do"
erase tmp.dta
erase "$dataFolder\tmp.dta"
erase "$dataFolder\tmp2.dta"
