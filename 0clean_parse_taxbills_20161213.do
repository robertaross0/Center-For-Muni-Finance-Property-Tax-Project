/* */ 
clear
set obs 1
g taxyear=.
save "$dataFolder/taxes.dta" ,replace
lab data "Residential property taxes in Cook County, IL"
clear

forvalues year=2003(1)2014{
	quietly import delimited "$rawdataFolder/PropTax`year'.csv", clear stringcols(3)
	quietly rename segmentcode segcode
	quietly rename pin pin14
	quietly rename volume vol
	quietly rename classification class
	quietly rename taxpayername tname
	quietly rename taxpayermailingaddress tadres
	quietly rename taxpayermailingcity tcity
	quietly rename taxpayermailingstate tstate
	quietly rename taxpayermailingzip tzip
	quietly rename taxpayerpropertyhouse pnum
	quietly rename taxpayerpropertydirection pdir
	quietly rename taxpayerpropertystreet pstreet
	quietly rename taxpayerpropertysuffix psuf
	quietly rename taxpayerpropertycity pcity
	quietly rename taxpayerpropertystate pstate
	quietly rename taxpayerpropertyzip pzip
	quietly rename taxpayerpropertytown ptown
	quietly rename taxcode pcode
	quietly rename taxstatus taxstat
	quietly rename homeownerexempt homeexflag
	quietly rename seniorexempt senexflag
	quietly rename seniorfreezeexempt senfrzexflag
	quietly rename longtimehomeownersexempt longexflag
	quietly rename taxinfotype info
	quietly rename taxtype taxtype
	quietly rename taxyear taxyear
	quietly rename billyear billyear
	quietly rename accountstatus actstat
	quietly rename billtype billtype
	quietly rename segmentcode2 segcode2
	quietly rename installmentnumber1 install1
	quietly rename adjustedamountdue1 adjamt1
	quietly rename taxamountdue1 taxdue1
	quietly rename refundtaxamountdueindicator1 refund1
	quietly rename interestamountdue1 int1
	quietly rename refundinterestdueindicator1 refundint1
	quietly rename costamountdue1 cost1
	quietly rename refundcostdueindicator1 refundcost1
	quietly rename totalamountdue1 totaldue1
	quietly rename refundtotaldueindicator1 refunddueflag1
	quietly rename lastpaymentdate1 laspmtdate1
	quietly rename lastpaymentsource1 lastpmtsource1
	quietly rename installmentnumber2 install2
	quietly rename originaltaxdue2 origdue2
	quietly rename adjustedtaxdue2 adjtax2
	quietly rename taxamountdue2 taxdue2
	quietly rename refundtaxamountdueindicator2 refundamtflag2
	quietly rename interestamountdue2 int2
	quietly rename refundinterestdueindicator2 refundint2
	quietly rename costamountdue2 cost2
	quietly rename refundcostdueindicator2 refundcost2
	quietly rename totalamountdue2 totaldue2
	quietly rename refundtaxdueindicator2 refundflag2
	quietly rename lastpaymentdate2 laspmtdate2
	quietly rename lastpaymentsource2 lastpmtsource2
	quietly rename cofenumber cofenumber
	quietly rename pasttaxsalestatus taxsaleflag
	quietly rename assessedvaluation av
	quietly rename equalizedevaluation eav
	quietly rename taxrate rate
	quietly rename recordcount reccount
	quietly rename condemnationstatus condemnflag
	quietly rename municipalacquisitionstatus muniflag
	quietly rename acquisitionstatus aquisflag
	quietly rename exemptstatus exemptflag
	quietly rename bankruptstatus bankruptflag
	quietly rename refundstatus refundflag
	quietly rename lastpaymentreceivedamount1 taxpaid1
	quietly rename lastpaymentreceivedamount2 taxpaid2
	quietly rename endmarker endmrk
	quietly rename taxdueestimated1 taxest1
	quietly rename returningvetexemptionamount retvetex
	quietly rename disabledpersonexemptionamount disabpersex
	quietly rename disabledvetexemptionamount disabvetex
	quietly rename disabledpersonvetexemptionamount disabpersvet
	quietly rename homeownerexemptamount homeex
	quietly rename seniorexemptamount senex
	quietly rename seniorfreezeexemptamount senfrzex
	quietly rename longtimehomeownersexemptamount longex
	quietly rename veteranexempt vetex

	quietly lab var segcode "Constant PH-PIN Header"
	quietly lab var pin14 "Property Index Number"
	quietly lab var vol "Refers to the volume number of warrant book"
	quietly lab var class "Property Classification. See table below for description of codes"
	quietly lab var tname "Taxpayer name"
	quietly lab var tadres "Taxpayer mailing address"
	quietly lab var tcity "Taxpayer mailing city"
	quietly lab var tstate "Taxpayer mailing state"
	quietly lab var tzip "Taxpayer maliing zip"
	quietly lab var pnum "House number of the taxpayer's property"
	quietly lab var pdir "Direction of the taxpayer's property"
	quietly lab var pstreet "Street name where the taxpayer's property"
	quietly lab var psuf "Street classification of the taxpayer's property"
	quietly lab var pcity "City where taxpayer's property is located"
	quietly lab var pstate "State where taxpayer's property is located"
	quietly lab var pzip "Zip code of taxpayer's property."
	quietly lab var ptown "Town where taxpayer's property is located"
	quietly lab var pcode "Tax Code used to determine tax rate."
	quietly lab var taxstat "Property taxable status  01=100% Exempt; 00=taxable; 03=non-coop;"
	quietly lab var homeexflag "Flag if there is a homeowner's exemption 0=No, 1=Yes, 2=Waived"
	quietly lab var senexflag "Flag if there is a senior exemption  0=No, 1=Yes, 2=Waived"
	quietly lab var senfrzexflag "Flag to determine if there is a senior freeze exemption  0=No, 1=Yes, 2=Waived"
	quietly lab var longexflag "Flag to determine if homeowners exemption has been extended  0=No, 1=Yes, 2=Waived"
	quietly lab var info "Real Estate/Special Assessment/etc"
	quietly lab var taxtype "Determines the type of bill:  0-Current Tax, 1-Back Tax, 2-Roll Back Tax, 3-Air Pollution, 4-Arrearage D,M, 5-Circulator, 6-Special Assessments, 9-Railroad"
	quietly lab var taxyear "The year monies will be applied to; (Warrant Year in APIN)"
	quietly lab var billyear "The actual year the tax is being billed for. If the tax type is 1 for Back Tax then this will be the lesser year and not the current tax collection year, if the Tax Type is 0 for current then this year will be the same as the Tax Year (Tax Year in APIN)"
	quietly lab var actstat "'P' Paid or 'O'Open Code (Determined by Field 36 + Field 49 = >1 then O or else P)"
	quietly lab var billtype "Taxable Parcel - 1                  Divided Parcel No Bill - 2               New Parcel Div. Result - 3                        New RR in Prior Yr taxable in Current - 4               RR Taxable Prior Exempt in Current - 5                          RR Exempt Prior Exempt in Current - 6                           No Tax Dues Pursuant to Chap.. 120 Sec. 642 of IL.Rev Stat. - 7                         Billable Type - 9"
	quietly lab var segcode2 ""
	quietly lab var install1 "Constant 01 for Tax type 0"
	quietly lab var adjamt1 "Original tax amount due after second installment (may change from original estimate due 1 due to reassessments) (F for installment on APIN)"
	quietly lab var taxdue1 "Outstanding tax balance, if negative"
	quietly lab var refund1 "'P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var int1 "Outstanding interest balance"
	quietly lab var refundint1 "P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var cost1 "Outstanding cost balance"
	quietly lab var refundcost1 "'P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var totaldue1 "Outstanding total balance"
	quietly lab var refunddueflag1 "'P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var laspmtdate1 "1st Installment Last Payment Date"
	quietly lab var lastpmtsource1 "The three digit Source ID of the last posted payment"
	quietly lab var install2 "Constant 02 for Tax type 0"
	quietly lab var origdue2 "Original tax amount due after second installment  (F for installment on APIN)"
	quietly lab var adjtax2 "Based on C of E, Exemptions, or Legal Court Orders otherwise will be the same as Field 45"
	quietly lab var taxdue2 "Outstanding tax balance."
	quietly lab var refundamtflag2 "'P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var int2 "Outstanding interest balance"
	quietly lab var refundint2 "'P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var cost2 "Outstanding cost balance"
	quietly lab var refundcost2 "P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var totaldue2 "Outstanding total balance"
	quietly lab var refundflag2 "'P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var laspmtdate2 "2nd installment last payment date"
	quietly lab var lastpmtsource2 "The three digit Source ID of the last posted payment"
	quietly lab var cofenumber "Zero Filled if no C of E is Applicable"
	quietly lab var taxsaleflag "N for not sold, S for sold"
	quietly lab var av "Final assessed valuation"
	quietly lab var eav "Equalized valuation"
	quietly lab var rate "Tax Rate Assigned by Clerk"
	quietly lab var reccount "Record Number this PIN is within the file (e.g.  00000000002 out of 99999999999)"
	quietly lab var condemnflag "0=No, 1=Yes"
	quietly lab var muniflag "0=No, 1=Yes"
	quietly lab var aquisflag "0=No, 1=Yes"
	quietly lab var exemptflag "0=No, 1=Yes, 2=Filed Exemption"
	quietly lab var bankruptflag "0=No, 1=Yes"
	quietly lab var refundflag "If an R segment exist on APIN, 0=No, 1=Yes"
	quietly lab var taxpaid1 "Dollar amount of the last payment received for first installment (payments refunded are excluded)"
	quietly lab var taxpaid2 "Dollar amount of the last payment received for the second installment (payments refunded are excluded)"
	quietly lab var endmrk "Constant X"
	quietly lab var taxest1 "Original Amount Due before second installment reassessment (E for installment on APIN)"
	quietly lab var retvetex ""
	quietly lab var disabpersex ""
	quietly lab var disabvetex ""
	quietly lab var disabpersvet ""
	quietly lab var homeex ""
	quietly lab var senex ""
	quietly lab var senfrzex ""
	quietly lab var longex ""
	quietly lab var vetex "Based on C of E, Exemptions, or Legal Court Orders otherwise will be the same as Field 33"

	quietly duplicates drop pin14, force
	quietly sort pin14
	quietly keep if class>199 & class<300
	quietly keep pin14 tname tadres tcity tstate tzip pnum pdir pstreet psuf pcity pstate ///
	pzip taxyear av eav rate retvetex disabpersex disabvetex disabpersvet ///
	homeex senex senfrzex longex vetex totaltax* homeowner m*
	
	quietly destring pnum av eav rate *ex disabpersvet, replace

quietly append using "$dataFolder/taxes.dta"
quietly sort pin14 taxyear
save "$dataFolder/taxes.dta", replace
}
forvalues year=2015(1)2015{
	quietly import delimited "$rawdataFolder/PropTax`year'.csv", clear stringcols(2)
	quietly rename segmentcode segcode
	quietly rename pin pin14
	quietly rename volume vol
	quietly rename classification class
	quietly rename taxpayername tname
	quietly rename taxpayermailingaddress tadres
	quietly rename taxpayermailingcity tcity
	quietly rename taxpayermailingstate tstate
	quietly rename taxpayermailingzip tzip
	quietly rename taxpayerpropertyhouse pnum
	quietly rename taxpayerpropertydirection pdir
	quietly rename taxpayerpropertystreet pstreet
	quietly rename taxpayerpropertysuffix psuf
	quietly rename taxpayerpropertycity pcity
	quietly rename taxpayerpropertystate pstate
	quietly rename taxpayerpropertyzip pzip
	quietly rename taxpayerpropertytown ptown
	quietly rename taxcode pcode
	quietly rename taxstatus taxstat
	quietly rename homeownerexempt homeexflag
	quietly rename seniorexempt senexflag
	quietly rename seniorfreezeexempt senfrzexflag
	quietly rename longtimehomeownersexempt longexflag
	quietly rename taxinfotype info
	quietly rename taxtype taxtype
	quietly rename taxyear taxyear
	quietly rename billyear billyear
	quietly rename accountstatus actstat
	quietly rename billtype billtype
	quietly rename segmentcode2 segcode2
	quietly rename installmentnumber1 install1
	quietly rename adjustedamountdue1 adjamt1
	quietly rename taxamountdue1 taxdue1
	quietly rename refundtaxamountdueindicator1 refund1
	quietly rename interestamountdue1 int1
	quietly rename refundinterestdueindicator1 refundint1
	quietly rename costamountdue1 cost1
	quietly rename refundcostdueindicator1 refundcost1
	quietly rename totalamountdue1 totaldue1
	quietly rename refundtotaldueindicator1 refunddueflag1
	quietly rename lastpaymentdate1 laspmtdate1
	quietly rename lastpaymentsource1 lastpmtsource1
	quietly rename installmentnumber2 install2
	quietly rename originaltaxdue2 origdue2
	quietly rename adjustedtaxdue2 adjtax2
	quietly rename taxamountdue2 taxdue2
	quietly rename refundtaxamountdueindicator2 refundamtflag2
	quietly rename interestamountdue2 int2
	quietly rename refundinterestdueindicator2 refundint2
	quietly rename costamountdue2 cost2
	quietly rename refundcostdueindicator2 refundcost2
	quietly rename totalamountdue2 totaldue2
	quietly rename refundtaxdueindicator2 refundflag2
	quietly rename lastpaymentdate2 laspmtdate2
	quietly rename lastpaymentsource2 lastpmtsource2
	quietly rename cofenumber cofenumber
	quietly rename pasttaxsalestatus taxsaleflag
	quietly rename assessedvaluation av
	quietly rename equalizedevaluation eav
	quietly rename taxrate rate
	quietly rename recordcount reccount
	quietly rename condemnationstatus condemnflag
	quietly rename municipalacquisitionstatus muniflag
	quietly rename acquisitionstatus aquisflag
	quietly rename exemptstatus exemptflag
	quietly rename bankruptstatus bankruptflag
	quietly rename refundstatus refundflag
	quietly rename lastpaymentreceivedamount1 taxpaid1
	quietly rename lastpaymentreceivedamount2 taxpaid2
	quietly rename endmarker endmrk
	quietly rename taxdueestimated1 taxest1
	quietly rename returningvetexemptionamount retvetex
	quietly rename disabledpersonexemptionamount disabpersex
	quietly rename disabledvetexemptionamount disabvetex
	quietly rename disabledpersonvetexemptionamount disabpersvet
	quietly rename homeownerexemptamount homeex
	quietly rename seniorexemptamount senex
	quietly rename seniorfreezeexemptamount senfrzex
	quietly rename longtimehomeownersexemptamount longex
	quietly rename veteranexempt vetex

	quietly lab var segcode "Constant PH-PIN Header"
	quietly lab var pin14 "Property Index Number"
	quietly lab var vol "Refers to the volume number of warrant book"
	quietly lab var class "Property Classification. See table below for description of codes"
	quietly lab var tname "Taxpayer name"
	quietly lab var tadres "Taxpayer mailing address"
	quietly lab var tcity "Taxpayer mailing city"
	quietly lab var tstate "Taxpayer mailing state"
	quietly lab var tzip "Taxpayer maliing zip"
	quietly lab var pnum "House number of the taxpayer's property"
	quietly lab var pdir "Direction of the taxpayer's property"
	quietly lab var pstreet "Street name where the taxpayer's property"
	quietly lab var psuf "Street classification of the taxpayer's property"
	quietly lab var pcity "City where taxpayer's property is located"
	quietly lab var pstate "State where taxpayer's property is located"
	quietly lab var pzip "Zip code of taxpayer's property."
	quietly lab var ptown "Town where taxpayer's property is located"
	quietly lab var pcode "Tax Code used to determine tax rate."
	quietly lab var taxstat "Property taxable status  01=100% Exempt; 00=taxable; 03=non-coop;"
	quietly lab var homeexflag "Flag if there is a homeowner's exemption 0=No, 1=Yes, 2=Waived"
	quietly lab var senexflag "Flag if there is a senior exemption  0=No, 1=Yes, 2=Waived"
	quietly lab var senfrzexflag "Flag to determine if there is a senior freeze exemption  0=No, 1=Yes, 2=Waived"
	quietly lab var longexflag "Flag to determine if homeowners exemption has been extended  0=No, 1=Yes, 2=Waived"
	quietly lab var info "Real Estate/Special Assessment/etc"
	quietly lab var taxtype "Determines the type of bill:  0-Current Tax, 1-Back Tax, 2-Roll Back Tax, 3-Air Pollution, 4-Arrearage D,M, 5-Circulator, 6-Special Assessments, 9-Railroad"
	quietly lab var taxyear "The year monies will be applied to; (Warrant Year in APIN)"
	quietly lab var billyear "The actual year the tax is being billed for. If the tax type is 1 for Back Tax then this will be the lesser year and not the current tax collection year, if the Tax Type is 0 for current then this year will be the same as the Tax Year (Tax Year in APIN)"
	quietly lab var actstat "'P' Paid or 'O'Open Code (Determined by Field 36 + Field 49 = >1 then O or else P)"
	quietly lab var billtype "Taxable Parcel - 1                  Divided Parcel No Bill - 2               New Parcel Div. Result - 3                        New RR in Prior Yr taxable in Current - 4               RR Taxable Prior Exempt in Current - 5                          RR Exempt Prior Exempt in Current - 6                           No Tax Dues Pursuant to Chap.. 120 Sec. 642 of IL.Rev Stat. - 7                         Billable Type - 9"
	quietly lab var segcode2 ""
	quietly lab var install1 "Constant 01 for Tax type 0"
	quietly lab var adjamt1 "Original tax amount due after second installment (may change from original estimate due 1 due to reassessments) (F for installment on APIN)"
	quietly lab var taxdue1 "Outstanding tax balance, if negative"
	quietly lab var refund1 "'P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var int1 "Outstanding interest balance"
	quietly lab var refundint1 "P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var cost1 "Outstanding cost balance"
	quietly lab var refundcost1 "'P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var totaldue1 "Outstanding total balance"
	quietly lab var refunddueflag1 "'P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var laspmtdate1 "1st Installment Last Payment Date"
	quietly lab var lastpmtsource1 "The three digit Source ID of the last posted payment"
	quietly lab var install2 "Constant 02 for Tax type 0"
	quietly lab var origdue2 "Original tax amount due after second installment  (F for installment on APIN)"
	quietly lab var adjtax2 "Based on C of E, Exemptions, or Legal Court Orders otherwise will be the same as Field 45"
	quietly lab var taxdue2 "Outstanding tax balance."
	quietly lab var refundamtflag2 "'P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var int2 "Outstanding interest balance"
	quietly lab var refundint2 "'P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var cost2 "Outstanding cost balance"
	quietly lab var refundcost2 "P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var totaldue2 "Outstanding total balance"
	quietly lab var refundflag2 "'P' = Positive Number meaning no Refund Due and 'N' = Negative Number meaning a Refund is due"
	quietly lab var laspmtdate2 "2nd installment last payment date"
	quietly lab var lastpmtsource2 "The three digit Source ID of the last posted payment"
	quietly lab var cofenumber "Zero Filled if no C of E is Applicable"
	quietly lab var taxsaleflag "N for not sold, S for sold"
	quietly lab var av "Final assessed valuation"
	quietly lab var eav "Equalized valuation"
	quietly lab var rate "Tax Rate Assigned by Clerk"
	quietly lab var reccount "Record Number this PIN is within the file (e.g.  00000000002 out of 99999999999)"
	quietly lab var condemnflag "0=No, 1=Yes"
	quietly lab var muniflag "0=No, 1=Yes"
	quietly lab var aquisflag "0=No, 1=Yes"
	quietly lab var exemptflag "0=No, 1=Yes, 2=Filed Exemption"
	quietly lab var bankruptflag "0=No, 1=Yes"
	quietly lab var refundflag "If an R segment exist on APIN, 0=No, 1=Yes"
	quietly lab var taxpaid1 "Dollar amount of the last payment received for first installment (payments refunded are excluded)"
	quietly lab var taxpaid2 "Dollar amount of the last payment received for the second installment (payments refunded are excluded)"
	quietly lab var endmrk "Constant X"
	quietly lab var taxest1 "Original Amount Due before second installment reassessment (E for installment on APIN)"
	quietly lab var retvetex ""
	quietly lab var disabpersex ""
	quietly lab var disabvetex ""
	quietly lab var disabpersvet ""
	quietly lab var homeex ""
	quietly lab var senex ""
	quietly lab var senfrzex ""
	quietly lab var longex ""
	quietly lab var vetex "Based on C of E, Exemptions, or Legal Court Orders otherwise will be the same as Field 33"

	quietly duplicates drop pin14, force
	quietly sort pin14
	quietly keep if class>199 & class<300
	quietly keep pin14 tname tadres tcity tstate tzip pnum pdir pstreet psuf pcity pstate ///
	pzip taxyear av eav rate retvetex disabpersex disabvetex disabpersvet ///
	homeex senex senfrzex longex vetex totaltax* homeowner m*
	foreach var in av eav rate retvetex disabpersex disabvetex disabpersvet ///
	homeex senex senfrzex totaltax_due totaltax_paid{
	display "`var'"
		quietly g `var'_x=real(`var')
		quietly drop `var'
		quietly rename `var'_x `var'
	}
	quietly destring pnum av eav rate *ex disabpersvet, replace

quietly append using "$dataFolder/taxes.dta"
quietly sort pin14 taxyear
save "$dataFolder/taxes.dta", replace
}

save "$dataFolder/taxes.dta", replace

clear all
