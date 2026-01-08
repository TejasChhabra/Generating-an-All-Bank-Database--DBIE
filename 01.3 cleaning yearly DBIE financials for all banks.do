 /*---------------------------------
File: 01.3 cleanup for DBIE Dataset
Purpose: Cleans Raw data and Prepares datasets for regressions/exhibits
Users: Tejas
--------------------------------------*/

/* import excel "$raw/_1.Liabilities and Assets of Scheduled Commercial Banks .xlsx", cellrange(B7) firstrow sheet("ASSETS")  clear */

 
import excel "$raw/_1.Liabilities and Assets of Scheduled Commercial Banks .xlsx", sheet("ASSETS") clear 
 
drop in 1/6  // remove first two rows 
 
 // Row 1 has the variable names
local nvars = _N // don't really need this - need this if you have a fixed number of observations 

local obs1 = 1 // don't need this either 


foreach var of varlist _all {
     local val = `var'[1]
 
     local clean = lower("`val'")
 
     local clean = subinstr("`clean'", ".", "", .)
     local clean = subinstr("`clean'", " ", "_", .)
 
     local clean = ustrregexra("`clean'", "[^a-zA-Z0-9_]", "")
 
     local clean = ustrregexra("`clean'", "^[^a-zA-Z]+", "")
  
     local clean = substr("`clean'", 1, 32)
  
     rename `var' `clean'
}

 
drop in 1

// renaming some variables that didn't turn out okay in the loop 
rename balances_with_banks_outside_indi bal_with_banks_outside_ind
rename investments total_investments 
rename i_____government_securities govt_securities_india
rename ii____other_approved_securities other_approved_sect_india 
rename iii___shares inv_in_shares_india
rename iv___debentures_and_bonds inv_in_deb_bonds_india
rename v____subsidiaries_andor_joint_ve subsidaries_joint_vent_ind
rename vi___others other_inv_in_india 
rename i______government_securities govt_sect_outside_ind
rename ii____subsidiaries_andor_joint_v subsidaries_joint_vent_out_ind
rename iii___others other_inv_out_india
rename advances total_advances 
rename a1____bills_purchased_and_discou bills_purchase_and_discount_adv
rename a2____cash_credits_overdrafts__l cash_credit_overdraft_adv 
rename a3____term_loans term_loans_adv
rename b1____secured_by_tangible_assets secured_by_tangile_assets_adv
rename b2____covered_by_bankgovt_guaran secured_bank_govt_gurantee_adv
rename b3____unsecured  unsecured_advances 
rename c1_____advances_in_india         total_advances_in_india 
rename i_________priority_sectors_      adv_to_priority_sect_india
rename ii________public_sectors         adv_to_public_sect_india 
rename iii_______banks                  adv_to_other_banks_india 
rename iv_______others                  adv_to_others_india 
rename c2____advances_outside_india     total_advances_outside_india 
rename fixed_assets total_fixed_assets 
rename other_assets total_other_assets 
rename banks bank_name

drop if mi(bank_name)

// forward setting the year 
replace year = year[_n-1] if missing(year)


save "$raw/DBIE_2024_Assets_All_Banks", replace 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import excel "$raw/_1.Liabilities and Assets of Scheduled Commercial Banks .xlsx", sheet("LIABILITIES_Upto2019") clear 

drop in 1/6

// Keep track of used names to avoid duplicates
local usednames

// Loop through all variables in the dataset
foreach var of varlist _all {

    // Get the first-row value (will be used as new name)
    local val = `var'[1]

    // Convert to lowercase
    local clean = lower("`val'")

    // Replace periods and spaces
    local clean = subinstr("`clean'", ".", "", .)
    local clean = subinstr("`clean'", " ", "_", .)

    // Remove invalid characters (keep only letters, numbers, underscores)
    local clean = ustrregexra("`clean'", "[^a-zA-Z0-9_]", "")

    // Remove leading non-letter characters
    local clean = ustrregexra("`clean'", "^[^a-zA-Z]+", "")

    // Truncate to 32 characters
    local base = substr("`clean'", 1, 32)
    local clean = "`base'"

    // Append suffix if name already used
    local suffix = 1
    while strpos(" `usednames' ", " `clean' ") {
        local suffix_str = "_`suffix'"
        local clean = substr("`base'", 1, 32 - length("`suffix_str'")) + "`suffix_str'"
        local ++suffix
    }

    // Mark this name as used
    local usednames "`usednames' `clean'"

    // Rename and display the change
    rename `var' `clean'
    display "`var' renamed to `clean'"
}

// Drop the header row that was used to rename variables
drop in 1



// renaming some variables that didn't turn out okay in the loop 
rename banks bank_name
rename reserves_and_surplus total_reserves_and_surplus 
rename deposits total_deposits 
rename a1__demand_deposits total_demand_deposits 
rename i__________from_banks demand_deposits_from_banks
rename ii_________from_others demand_deposits_from_others
rename a2___savings_bank_deposits total_saving_deposits 
rename a3___term_deposits total_term_deposits 
rename i__________from_banks_1 term_deposits_from_banks
rename ii_________from_others_1 term_deposits_from_others 
rename b1___deposits_of_branches_in_ind Deposits_from_indian_branches 
rename b2___deposits_of_branches_outsid Deposit_from_non_indian_branches
rename borrowings total_borrowings 
rename borrowings_in_india total_borrowings_in_india 
rename i________from_reserve_bank_of_in borrowing_from_RBI
rename ii_______from_other_banks borrowing_from_other_banks
rename iii______from_other_institutions borrowing_from_other_instiutes
rename borrowings_outside_india total_borrowings_outside_India
rename secured_borrowings_included_in_4 total_secured_borrowings 
rename other_liabilities__provisions total_other_liabilities_prov
rename others_including_provisions other_liabilities_include_prov

drop if mi(bank_name)

// forward setting the year 
replace year = year[_n-1] if missing(year)


save "$raw/DBIE_2019_Liabilities_All_Banks", replace 


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import excel "$raw/_1.Liabilities and Assets of Scheduled Commercial Banks .xlsx", sheet("LIABILITIES_2020_Onwards") clear 

drop in 1/6

// Keep track of used names to avoid duplicates
local usednames

// Loop through all variables in the dataset
foreach var of varlist _all {

    // Get the first-row value (will be used as new name)
    local val = `var'[1]

    // Convert to lowercase
    local clean = lower("`val'")

    // Replace periods and spaces
    local clean = subinstr("`clean'", ".", "", .)
    local clean = subinstr("`clean'", " ", "_", .)

    // Remove invalid characters (keep only letters, numbers, underscores)
    local clean = ustrregexra("`clean'", "[^a-zA-Z0-9_]", "")

    // Remove leading non-letter characters
    local clean = ustrregexra("`clean'", "^[^a-zA-Z]+", "")

    // Truncate to 32 characters
    local base = substr("`clean'", 1, 32)
    local clean = "`base'"

    // Append suffix if name already used
    local suffix = 1
    while strpos(" `usednames' ", " `clean' ") {
        local suffix_str = "_`suffix'"
        local clean = substr("`base'", 1, 32 - length("`suffix_str'")) + "`suffix_str'"
        local ++suffix
    }

    // Mark this name as used
    local usednames "`usednames' `clean'"

    // Rename and display the change
    rename `var' `clean'
    display "`var' renamed to `clean'"
}

// Drop the header row that was used to rename variables
drop in 1

// renaming some variables that didn't turn out okay in the loop 
rename banks bank_name
rename reserves_and_surplus total_reserves_and_surplus 
rename deposits total_deposits 
rename a1__demand_deposits total_demand_deposits 
rename i__________from_banks demand_deposits_from_banks
rename ii_________from_others demand_deposits_from_others
rename a2___savings_bank_deposits total_saving_deposits 
rename a3___term_deposits total_term_deposits 
rename i__________from_banks_1 term_deposits_from_banks
rename ii_________from_others_1 term_deposits_from_others 
rename b1___deposits_of_branches_in_ind Deposits_from_indian_branches 
rename b2___deposits_of_branches_outsid Deposit_from_non_indian_branches
rename borrowings total_borrowings 
rename borrowings_in_india total_borrowings_in_india 
rename i________from_reserve_bank_of_in borrowing_from_RBI
rename ii_______from_other_banks borrowing_from_other_banks
rename iii______from_other_institutions borrowing_from_other_instiutes
rename borrowings_outside_india total_borrowings_outside_India
rename secured_borrowings_included_in_4 total_secured_borrowings 
rename other_liabilities__provisions total_other_liabilities_prov
rename others_including_provisions other_liabilities_include_prov
rename statutory_reserve statutory_reserves
rename capital_reserve capital_reserves

drop if mi(bank_name)

// forward setting the year 
replace year = year[_n-1] if missing(year)


save "$raw/DBIE_2020_Liabilities_All_Banks", replace 

// Now appending the liabilities together and merging with the assets
use "$raw/DBIE_2019_Liabilities_All_Banks", clear 
append using "$raw/DBIE_2020_Liabilities_All_Banks", force // doesn't have data on investment fluctuation reserves 
sort bank_name year 

merge 1:1 bank_name year using "$raw/DBIE_2024_Assets_All_Banks", force nogen keep(3)


destring year, replace
save "$clean/DBIE_financials_2005_2024_file_1_All_Banks", replace


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import excel "$raw/_2.Earnings and Expenses of Scheduled Commercial Banks.xlsx", cellrange(B8) firstrow sheet("EARNINGS") clear 

rename Year year 
rename Banks bank_name 
rename aInterestDiscountearnedon Int_Income_on_Bills_Advances
rename bIncomeoninvestments Income_on_Investments 
rename cInterestonbalanceswithR Int_Income_on_Dep_RBI_and_Banks
rename dOthers Int_Income_others 
rename TotalI Int_Income_Total 
rename aCommissionexchangeandbr Inc_comis_exchange_brokerage
rename bNetprofitlossonsaleo Net_Prft_on_sale_of_investments 
rename cNetprofitlossonrevalu   Net_Prft_on_reval_of_investments
rename dNetprofitlossonsaleo   Net_Prft_sale_land_or_assets 
rename eNetprofitlossonexchan   Net_Prft_on_exchange_trans
rename fMiscellaneousincome     Miscellaneouse_income 
rename TotalII Non_Interest_Income_Total
rename TotalIII Total_Income

drop if mi(bank_name)

// forward setting the year 
replace year = year[_n-1] if missing(year)


save "$raw/DBIE_2024_Income_All_Banks", replace 

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import excel "$raw/_2.Earnings and Expenses of Scheduled Commercial Banks.xlsx", cellrange(B8) firstrow sheet("EXPENSES") clear 

rename Year year 
rename Banks bank_name 
rename aInterestondeposits Int_Exp_on_deposits
rename bInterestonRBIInterb Int_Exp_on_RBI_banks_loans  
rename cOthers Int_Exp_others
rename TotalII Int_Exp_Total 
rename aPaymentstoandprovisions Employee_based_Exp 
rename bRenttaxesandlighting Rent_Taxes_Lighting_Exp
rename cPrintingandstationery Print_Stationery_Exp 
rename dAdvertisementandpublicit   Adv_publicity_Exp
rename eDepreciationonbankspro   Dep_on_property_Exp 
rename fDirectorsfeesallowanc   Director_based_Exp
rename gAuditorsfeesandexpense   Auditor_fees_and_Exp
rename hLawcharges Legal_Exp 
rename iPostagetelegramstelep Communication_Exp
rename jRepairsandmaintenance Repair_maintenance_Exp 
rename kInsurance Insurance_Exp 
rename lOtherexpenditure Other_Exp 
rename TotalIV Non_Interest_Exp_Total
rename VNetInterestIncomeIII Net_Interest_Income 
rename VIProvisionsandContingenc Provisions_and_Contingencies
rename VIIOperatingProfitIIIII Operating_Profit_Total 
rename VIIIProfitLossduringthe Net_Profit


drop if mi(bank_name)

// forward setting the year 
replace year = year[_n-1] if missing(year)


save "$raw/DBIE_2024_Expenses_All_Banks", replace 

// merging the two files 

merge 1:1 bank_name year using "$raw/DBIE_2024_Income_All_Banks", force nogen keep(3)


destring year, replace

save "$clean/DBIE_financials_2005_2024_file_2_All_Banks", replace 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import excel "$raw/_4.Provisions and Contingencies of Scheduled Commercial Banks.xlsx", cellrange(B7) firstrow clear 

drop in 1 
// Bank Taxation NPA Investments Others Total
rename B year 
rename Bank bank_name 
rename Taxation taxation_provisions
rename NPA NPA_provisions
rename Investments investments_provisions 
rename Others other_provisions 
rename Total total_provisions 

drop if mi(bank_name)

// forward setting the year 
replace year = year[_n-1] if missing(year)


destring year, replace

save "$clean/DBIE_financials_2005_2024_file_4_All_Banks", replace 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import excel "$raw/_3.Bank-wise Capital Adequacy Ratios (CRAR) of Scheduled Commercial Banks.xlsx", cellrange(B7) firstrow clear 

drop in 1/2
// Year BankName BaselI E F BaselII H I BaselIII K L
rename Year year_old
rename BankName bank_name 
rename BaselI Basel_I_I_Tier_1
rename E Basel_I_I_Tier_2 
rename F Basel_I_I_Total
rename BaselII Basel_I_II_Tier_1
rename H Basel_I_II_Tier_2 
rename I Basel_I_II_Total 
rename BaselIII Basel_I_III_Tier_1
rename K Basel_I_III_Tier_2 
rename L IBasel_I_II_Total 

drop if mi(bank_name)

// forward setting the year 
*recreate year variable
gen year_raw = year_old

* identifying the rows with dates 
gen has_date = regexm(lower(year_old), "^[0-9]{2}[a-z]{3}20[0-9]{2}")

* converting stata date 
gen date = date(year_old, "DMY") if has_date
format date %td

* extracting year from the date 
gen year = year(date) if has_date 

* moving forward 
gen obs_id = _n
sort obs_id // just to make sure correct ordering 
replace year = year[_n-1] if missing(year)

drop year_old year_raw has_date obs_id date


save "$clean/DBIE_financials_2005_2024_file_3_All_Banks", replace 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import excel "$raw/_6.Movement of Non Performing Assets (NPAs) of Scheduled Commercial Banks.xlsx", cellrange(B8) firstrow clear 

drop in 1
// B C OpeningBalance AdditionduringtheYear ReductionduringtheYear WriteoffduringtheYear ClosingBalance I J K
rename B year
rename C bank_name 
rename OpeningBalance Gross_NPA_Open_Bal
rename AdditionduringtheYear Gross_NPA_Addition_in_year
rename ReductionduringtheYear Gross_NPA_Reduction_in_year 
rename WriteoffduringtheYear Gross_NPA_Written_off_in_year
rename ClosingBalance Gross_NPA_Closing_Bal
rename I Net_NPA_Open_Bal
rename J Net_NPA_Closing_Bal

 
drop K 
drop if mi(bank_name)

// forward setting the year 
replace year = year[_n-1] if missing(year)

destring year, replace

save "$clean/DBIE_financials_2005_2024_file_6_All_Banks", replace 



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import excel "$raw/_8.Exposure to Sensitive Sectors of Scheduled Commercial Banks.xlsx", cellrange(B7) firstrow clear 

drop in 1
// CapitalMarketSector RealEstateSector Commodities Total
rename B year
rename C bank_name 
rename CapitalMarketSector Capital_Mkt_Sector_Advances
rename RealEstateSector Real_Estate_Sector_Advances
rename Commodities Commodities_Based_Advances
rename Total Total_Advances 

drop if mi(bank_name)

// forward setting the year 
replace year = year[_n-1] if missing(year)

destring year, replace


save "$clean/DBIE_financials_2005_2024_file_8_All_Banks", replace 


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import excel "$raw/_7.Appropriation of Profit of Scheduled Commercial Banks.xlsx", cellrange(B7) firstrow clear 

drop in 1
drop B 

rename C year
rename Bank bank_name 
rename NetProfit Net_Profit
rename ProfitBroughtForward Profit_Brought_Forward
rename ProfitAvailableforAppropriati Profit_Avail_Appropriation
rename TransfertoStatutoryReserves Prft_Trans_Statutory_Reserve
rename TransfertoCapitalReserves Prft_Trans_Capital_Reserve
rename TransfertodebentureRedemption Prft_Trans_Deb_Redemption
rename TransfertoInvestmentsFluctuat Prft_Trans_Inv_Fluctuate_Reserve
rename TransfertoOtherReserves Prft_Trans_Other_Reserves 
rename TransfertoProposedDividend Prft_Trans_Proposed_Dividend
rename TransfertoTaxonDividend Prft_Trans_Tax_on_Dividend
rename BalanceCarriedOvertoBalance Prft_Bal_carried_to_BS

drop if mi(bank_name)

// forward setting the year 
replace year = year[_n-1] if missing(year)

save "$clean/DBIE_financials_2005_2024_file_7_All_Banks", replace 



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import excel "$raw/_9.Maturity Profile of Select Items of Liabilities and Assets of Scheduled Commercial Banks.xlsx", cellrange(B7) firstrow clear 

drop in 1

rename B year 
rename C bank_name 
rename a114days Dep_1_to_14_Days 
rename b1528days Dep_15_to_28_Days 
rename c29daysto3months Dep_29_Days_to_3_Months
rename dOver3monthsto6months Dep_3_Months_to_6_Months
rename eOver6monthsto1year Dep_6_Months_to_1_year 
rename fOver1yearto3years Dep_1_year_to_3_years
rename gOver3yearsto5years Dep_3_years_to_5_years 
rename hOver5years Dep_over_5_years 
rename TotalofDeposits Total_Deposits 

rename M Borrowings_1_to_14_Days 
rename N Borrowings_15_to_28_Days 
rename O Borrowings_29_Days_to_3_Months
rename P Borrowings_3_Months_to_6_Months
rename Q Borrowings_6_Months_to_1_year 
rename R Borrowings_1_year_to_3_years
rename S Borrowings_3_years_to_5_years 
rename T Borrowings_over_5_years 
rename TotalOfBorrowings Total_Borrowings 

// investments at book value 

rename V Inv_at_BV_1_to_14_Days 
rename W Inv_at_BV_15_to_28_Days 
rename X Inv_at_BV_29_Days_to_3_Months
rename Y Inv_at_BV_3_Months_to_6_Months
rename Z Inv_at_BV_6_Months_to_1_year 
rename AA Inv_at_BV_1_year_to_3_years
rename AB Inv_at_BV_3_years_to_5_years 
rename AC Inv_at_BV_over_5_years 
rename TotalofInvestmentsatbookva Total_Inv_Book_Value 

rename AE Frgn_Cur_Asts_1_to_14_Days 
rename AF Frgn_Cur_Asts_15_to_28_Days 
rename AG Frgn_Cur_Asts_29_Days_to_3_Mnths
rename AH Frgn_Cur_Asts_3_Mnths_to_6_Mnths
rename AI Frgn_Cur_Asts_6_Mnths_to_1_year 
rename AJ Frgn_Cur_Asts_1_year_to_3_years
rename AK Frgn_Cur_Asts_3_years_to_5_years 
rename AL Frgn_Cur_Asts_over_5_years 
rename TotalofForeignCurrencyAssets Total_Foreign_Currency_Assets 

rename AN Frgn_Cur_Lia_1_to_14_Days 
rename AO Frgn_Cur_Lia_15_to_28_Days 
rename AP Frgn_Cur_Lia_29_Days_to_3_Mnths
rename AQ Frgn_Cur_Lia_3_Mnths_to_6_Mnths
rename AR Frgn_Cur_Lia_6_Mnths_to_1_year 
rename AS Frgn_Cur_Lia_1_year_to_3_years
rename AT Frgn_Cur_Lia_3_years_to_5_years 
rename AU Frgn_Cur_Lia_over_5_years 
rename TotalofForeignCurrencyLiabil Total_Foreign_Currency_Lia 

rename AW Loans_Adv_1_to_14_Days 
rename AX Loans_Adv_15_to_28_Days 
rename AY Loans_Adv_29_Days_to_3_Months
rename AZ Loans_Adv_3_Months_to_6_Months
rename BA Loans_Adv_6_Months_to_1_year 
rename BB Loans_Adv_1_year_to_3_years
rename BC Loans_Adv_3_years_to_5_years 
rename BD Loans_Adv_over_5_years 
rename TotalofLoansandAdvances Total_Loans_and_Advances

drop if mi(bank_name)

// forward setting the year 
replace year = year[_n-1] if missing(year)

destring year, replace

save "$clean/DBIE_financials_2005_2024_file_9_All_Banks", replace 


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import excel "$raw/11.Select Ratios of Scheduled Commercial Banks.xlsx", cellrange(B7) firstrow clear 

drop in 1

rename Year year 
rename Bank bank_name 
rename CashDepositRatio Cash_Deposit_Ratio 
rename CreditDepositRatio Credit_Deposit_Ratio 
rename InvestmentDepositRatio Inv_Deposit_Ratio
rename CreditInvestmentDepo Cred_and_Inv_to_Deposit_Ratio
rename Ratioofdepositstototal Dep_to_Total_Lia_Ratio 
rename Ratioofdemandsavingsb Dem_and_Sav_Dep_to_Total_Dep
rename Ratioofprioritysectorad PSL_Loans_to_Total_Loans_Ratio
rename Ratiooftermloanstotota Term_Loans_to_Total_Adv_Ratio
rename Ratioofsecuredadvancest Sec_Adv_to_Total_Adv_Ratio
rename Ratioofinvestmentsinnon Non_Approved_Sec_Inv_to_Tot_Inv
rename Ratioofinterestincometo Int_Inc_to_Total_Assets_Ratio
rename Ratioofnetinterestincom NIM  
rename Ratioofnoninterestincom Non_Int_Inc_to_Tot_Assets_Ratio
rename Ratioofintermediationcos Intermediation_cost_to_Tot_Asset
rename Ratioofwagebillstointe Wage_Bill_to_Intermediation_cost
rename Ratioofwagebillstotota Wage_Bill_to_Tot_Expense_Ratio
rename T Wage_Bill_to_Total_Income_Ratio

rename Ratioofburdentointerest Ratio_of_burden_to_int_income
rename Ratioofoperatingprofits Operating_Profit_to_Tot_Assets
rename Returnonassets Return_on_Assets 
rename Returnonequity Return_on_Equity
rename Costofdeposits Cost_of_Deposits 
rename Costofborrowings Cost_of_Borrowings 
rename Costoffunds Cost_of_Funds 
rename Returnonadvances Return_on_Advances 
rename Returnoninvestments Return_on_Investments 
rename Returnonadvancesadjusted Return_on_Advances_Adjusted
rename Returnoninvestmentsadjus Return_on_Inv_Adjusted 
rename BusinessperemployeeinRu Business_per_emp_in_Rs_Lakhs
rename ProfitperemployeeinRu Profit_per_emp_in_Rs_Lakhs
rename Capitaladequacyratio Capital_Adequacy_Ratio
rename CapitaladequacyratioTie Capital_Adequacy_Ratio_TierI
rename AK Capital_Adequacy_Ratio_TierII
rename RatioofnetNPATonetadv Net_NPA_to_Total_Adv_Ratio


drop if mi(bank_name)

// forward setting the year 
replace year = year[_n-1] if missing(year)

replace year = "2024" if missing(year) | year == "." | year == "" 

destring year, force replace
save "$clean/DBIE_financials_2005_2024_file_11_All_Banks", replace 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import excel "$raw/13.Loan Subjected to Restructuring and Corporate Debt Restructured.xlsx", cellrange(B7) firstrow clear 


drop in 1

rename Year year 
rename Bank bank_name 

rename StandardAssetsduringtheYear  Standard_Assets_yr_Loans
rename SubStandardAssetsduringtheY  Sub_Standard_Assets_yr_Loans
rename DoubtfulAssetsduringtheYear  Doubtful_Assets_yr_Loans
rename Total1123                    Tot_Loans_Subject_Restructuring
rename H Standard_Assets_yr_Corp_Deb
rename I Sub_Standard_Assets_yr_Corp_Deb 
rename J Doubtful_Assets_yr_Corp_Dev
rename Total2567 Tot_Corp_Deb_Subj_Restructuring 
rename Total348 Total_Assets_Subj_Restructuring


drop if mi(bank_name)

// forward setting the year 
replace year = year[_n-1] if missing(year)

destring year, replace
save "$clean/DBIE_financials_2005_2024_file_13_All_Banks", replace 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Merging all the sheets together to get the 2024 master financials 


use "$clean/DBIE_financials_2005_2024_file_1_All_Banks", clear 

forvalues i = 2/13 {
	local f "$clean/DBIE_financials_2005_2024_file_`i'_All_Banks.dta" // need this for the confirm capture and we don't have file 5,10, 12 
	
	capture confirm file "`f'"
	if _rc == 0 {
		merge 1:1 bank_name year using "`f'", force gen(_merge`i')
		
		if `i' != 6 {
			drop _merge`i' // this is to retain the NPA sheet merge to keep a track of observations where we 
		}
	}
	else {
		di "Don't have DBIE file : `f'"
	}
}


encode bank_name, gen(bank_id)
xtset bank_id year
drop if missing(year)
isid bank_name year //no duplicates exist have checked 
replace bank_name = "IDFC FIRST BANK LIMITED" if bank_name == "IDFC BANK LIMITED" // renaming to ensure symmetry and ignoring the name change post merger with Capital Ltd 

// Removing all the aggregate terms as we commented out all the bank name matching 

drop if bank_name == "ALL SCHEDULED COMMERCIAL BANKS" | bank_name == "FOREIGN BANKS" | bank_name == "NATIONALISED BANKS" | bank_name == "PAYMENTS BANKS" | bank_name == "PRIVATE SECTOR BANKS" | bank_name == "PUBLIC SECTOR BANKS" | bank_name == "SMALL FINANCE BANKS" | bank_name == "STATE BANK OF INDIA AND ITS ASSOCIATES"
 

save "$clean/Annual_Financals_DBIE_2005_2024_All_Banks", replace 


// Destring all variables except year, bank_name, and bank_id

ds year bank_name bank_id, not
local t `r(varlist)'

foreach var of local t {
    destring `var', force replace
}


//  Running a loop to rescale into billions rupees 

ds (year bank_name Basel_I_I_Tier_1 Basel_I_I_Tier_2 Basel_I_I_Total Basel_I_II_Tier_1 Basel_I_II_Tier_2 Basel_I_II_Total Basel_I_III_Tier_1 Basel_I_III_Tier_2 IBasel_I_II_Total Cash_Deposit_Ratio- Net_NPA_to_Total_Adv_Ratio bank_id), not

local sto `r(varlist)'

foreach s in `sto'{
	replace `s' = `s'/ 1000000000
	la var `s' "`s' (In Billion Rs.)"
}


rename IBasel_I_II_Total Basel_I_III_Total // renaming this variable


//Trying to relabel again 

la var year "Year"
la var bank_name "Bank Name"
la var capital "Capital (In Billion Rs.)"
la var total_reserves_and_surplus "Total Reserves \& Surplus (In Billion Rs.)"
la var statutory_reserves "Statutory Reserves (In Billion Rs.)"
la var capital_reserves "Capital Reserves (In Billion Rs.)"
la var share_premium "Share Premium (In Billion Rs.)"
la var investments_fluctuations_reserve "Investments Fluctuations Reserve (In Billion Rs.)"
la var revenue_and_other_reserves "Revenue \& Other Reserves (In Billion Rs.)"
la var balance_of_profit "Balance of Profit (In Billion Rs.)"
la var total_deposits "Total Deposits (In Billion Rs.)"
la var total_demand_deposits "Total Demand Deposits (In Billion Rs.)"
la var demand_deposits_from_banks "Demand Deposits from Banks (In Billion Rs.)"
la var demand_deposits_from_others "Demand Deposits from Others (In Billion Rs.)"
la var total_saving_deposits "Total Saving Deposits (In Billion Rs.)"
la var total_term_deposits "Total Term Deposits (In Billion Rs.)"
la var term_deposits_from_banks "Term Deposits from Banks (In Billion Rs.)"
la var term_deposits_from_others "Term Deposits from Others (In Billion Rs.)"
la var Deposits_from_indian_branches "Deposits from Indian Branches (In Billion Rs.)"
la var Deposit_from_non_indian_branches "Deposits from Non-Indian Branches (In Billion Rs.)"
la var total_borrowings "Total Borrowings (In Billion Rs.)"
la var total_borrowings_in_india "Total Borrowings from Indian Sources (In Billion Rs.)"
la var borrowing_from_RBI "Borrowings from RBI (In Billion Rs.)"
la var borrowing_from_other_banks "Borrowings from Other Banks (In Billion Rs.)"
la var borrowing_from_other_instiutes "Borrowings from Other Financial Institutions"
la var total_borrowings_outside_India "Total Borrowings from Non-Indian Sources (In Billion Rs.)"
la var total_secured_borrowings "Security Backed Borrowings (In Billion Rs.)"
la var total_other_liabilities_prov " Total of Other Liabilities (In Billion Rs.)"
la var bills_payable "Bills Payable (In Billion Rs.)"
la var interoffice_adjustments "Interoffice Adjustments (In Billion Rs.)"
la var interest_accrued "Interest Payable on Liabilities Side (In Billion Rs.)"
la var subordinate_debt "Subordinate Debt (In Billion Rs.)"
la var deferred_tax_liabilities "Deferred Tax Liabilities (In Billion Rs.)"
la var other_liabilities_include_prov "Other Liabilities including Provisions (In Billion Rs.)"
la var total_liabilities "Total Liabilities (In Billion Rs.)"
la var cash_in_hand "Cash in Hand (In Billion Rs.)"
la var balances_with_rbi "Balances with RBI (In Billion Rs.)"
la var balances_with_banks_in_india "Balances with Banks in India (In Billion Rs.)"
la var money_at_call_and_short_notice "Money at Call \& Short Notice (In Billion Rs.)"
la var bal_with_banks_outside_ind "Balances with Banks outside India (In Billion Rs.)"
la var total_investments "Total Investments (In Billion Rs.)"
la var investments_in_india "Investments in India (In Billion Rs.)"
la var govt_securities_india "Investments in Indian Gsecs (In Billion Rs.)"
la var other_approved_sect_india "Investments in other Approved Indian Securities (In Billion Rs.)"
la var inv_in_shares_india "Investments in Indian Shares (In Billion Rs.)"
la var inv_in_deb_bonds_india "Investments in Indian Debuntures and Bonds (In Billion Rs.)"
la var subsidaries_joint_vent_ind "Investments in Indian Subsidiaries \& Joint Ventures (In Billion Rs.)"
la var other_inv_in_india "Other Indian Investments(In Billion Rs.)"
la var investments_outside_india "Investments outside India (In Billion Rs.)"
la var govt_sect_outside_ind "Investments in Non-Indian Gsecs (In Billion Rs.)"
la var subsidaries_joint_vent_out_ind "Investments in Non-Indian Subsidiaries \& Joint Ventures (In Billion Rs.)"
la var other_inv_out_india "Other Non-Indian Investments(In Billion Rs.)"
la var total_advances "Total Advances (In Billion Rs.)"
la var bills_purchase_and_discount_adv "Bills Purchased and Discounted (In Billion Rs.)"
la var cash_credit_overdraft_adv "Cash Credit \& Overdraft (In Billion Rs.)"
la var term_loans_adv "Term Loans (In Billion Rs.)"
la var secured_by_tangile_assets_adv "Advances secured by Tangible Assets (In Billion Rs.)"
la var secured_bank_govt_gurantee_adv "Advances secured by Govt. Gurantees (In Billion Rs.)"
la var unsecured_advances "Unsecured Advances (In Billion Rs.)"
la var total_advances_in_india "Total Advances to Indian Entities (In Billion Rs.)"
la var adv_to_priority_sect_india "PSL Advances in India (In Billion Rs.)"
la var adv_to_public_sect_india "Advances to the Indian Public Sector (In Billion Rs.)"
la var adv_to_other_banks_india "Advances to other Indian Banks (In Billion Rs.)"
la var adv_to_others_india "Other Advances to Indian Entities (In Billion Rs.)"
la var total_advances_outside_india "Total Advances to Non-Indian Entities (In Billion Rs.)"
la var total_fixed_assets "Total Fixed Assets (In Billion Rs.)"
la var premises "Value of Premises (In Billion Rs.)"
la var fixed_assets_under_construction "Value of Fixed Assets under Construction (In Billion Rs.)"
la var other_fixed_assets "Value of other Fixed Assets (In Billion Rs.)"
la var total_other_assets "Total Other Assets (In Billion Rs.)"
la var interoffice_adjustments_net "Net Value of Interoffice Adjustments (In Billion Rs.)"
la var interest_accrued_ "Interest Accrued on Asset Side (In Billion Rs.)"
la var tax_paid "Tax Paid (In Billion Rs.)"
la var stationery_and_stamps "Stationary \& Stamps (In Billion Rs.)"
la var others "Other Assets (In Billion Rs.)"
la var total_assets "Total Assets (In Billion Rs.)"
la var Int_Exp_on_deposits "Interest Expense on Deposits (In Billion Rs.)"
la var Int_Exp_on_RBI_banks_loans "Interest Repayable on Borrowings from RBI \& Other Banks (In Billion Rs.)"
la var Int_Exp_others "Other Interest Expenses (In Billion Rs.)"
la var Int_Exp_Total "Total Interest Expenses (In Billion Rs.)"
la var Employee_based_Exp "Staffing Expenses (In Billion Rs.)"
la var Rent_Taxes_Lighting_Exp "Rent, Lighting and Other Tax Expenses (In Billion Rs.)"
la var Print_Stationery_Exp "Print and Stationary Expenses (In Billion Rs.)"
la var Adv_publicity_Exp "Advertisement and Publicity Expenses (In Billion Rs.)"
la var Dep_on_property_Exp "Depreciation on Property (In Billion Rs.)"
la var Director_based_Exp "Directors' Fees \& Allowances (In Billion Rs.)"
la var Auditor_fees_and_Exp "Auditors' Fees and Expenses (In Billion Rs.)"
la var Legal_Exp "Legal Expenses (In Billion Rs.)"
la var Communication_Exp "Communication Expenses (In Billion Rs.)"
la var Repair_maintenance_Exp "Repair \& Maintenance Expenses (In Billion Rs.)"
la var Insurance_Exp "Insurance Expenses (In Billion Rs.)"
la var Other_Exp "Other Expenses (In Billion Rs.)"
la var Non_Interest_Exp_Total "Total Non-Interest Expenses (In Billion Rs.)"
la var Net_Interest_Income "Net Interest Income (In Billion Rs.)"
la var Provisions_and_Contingencies "Provisions \& Contingencies in the P\&L (In Billion Rs.)"
la var Operating_Profit_Total "Operating Profit (In Billion Rs.)"
la var Net_Profit "Net Profit (In Billion Rs.)"
la var Int_Income_on_Bills_Advances "Interest and Discount Income on Advances and Bills (In Billion Rs.)"
la var Income_on_Investments "Income on Investments (In Billion Rs.)"
la var Int_Income_on_Dep_RBI_and_Banks "Interest from Deposits at RBI \& Advances to Other Banks (In Billion Rs.)"
la var Int_Income_others "Other sources of Interest Income (In Billion Rs.)"
la var Int_Income_Total "Total Interest Income (In Billion Rs.)"
la var Inc_comis_exchange_brokerage "Commission, Exchange \& Brokerage Income (In Billion Rs.)"
la var Net_Prft_on_sale_of_investments "Net Profit on Sale of Investments (In Billion Rs.)"
la var Net_Prft_on_reval_of_investments "Net Profit on Reevaluation of Investments (In Billion Rs.)"
la var Net_Prft_sale_land_or_assets "Net Profit on Sale of Land or Assets (In Billion Rs.)"
la var Net_Prft_on_exchange_trans "Net Profit on Exchange Transactions (In Billion Rs.)"
la var Miscellaneouse_income "Miscellaneouse Income (In Billion Rs.)"
la var Non_Interest_Income_Total "Total Non-Interest Income (In Billion Rs.)"
la var Total_Income "Total Income (In Billion Rs.)"

la var Basel_I_I_Tier_1 "Basel I Tier I (\%)"
la var Basel_I_I_Tier_2 "Basel I Tier II (\%)"
la var Basel_I_I_Total "Basel I Total (\%)"
la var Basel_I_II_Tier_1 "Basel II Tier I (\%)"
la var Basel_I_II_Tier_2 "Basel II Tier II (\%)"
la var Basel_I_II_Total "Basel II Total (\%)"
la var Basel_I_III_Tier_1 "Basel III Tier I (\%)"
la var Basel_I_III_Tier_2 "Basel III Tier II (\%)"
la var Basel_I_III_Total "Basel III Total (\%)"

la var taxation_provisions "Provisions for Taxation (In Billion Rs.)"
la var NPA_provisions "Provisions for NPAs (In Billion Rs.)"
la var investments_provisions "Provisions for Investments (In Billion Rs.)"
la var other_provisions "Other Provisions (In Billion Rs.)"
la var total_provisions "Total Value of Provisions (In Billion Rs.)"

la var Gross_NPA_Open_Bal "Opening Balance of Gross NPAs (In Billion Rs.)"
la var Gross_NPA_Addition_in_year "Gross NPA Additions in the year (In Billion Rs.)"
la var Gross_NPA_Reduction_in_year "Gross NPA Reductions in the year (In Billion Rs.)"
la var Gross_NPA_Written_off_in_year "Gross NPAs Written off in the year (In Billion Rs.)"
la var Gross_NPA_Closing_Bal "Closing Balance of Gross NPAs (In Billion Rs.)"
la var Net_NPA_Open_Bal "Opening Balance of Net NPAs (In Billion Rs.)"
la var Net_NPA_Closing_Bal "Closing Balance of Net NPAs (In Billion Rs.)"
la var _merge6 "NPA Bank Merge (1 - Asterix Banks - Inconsistent Balance Sheets)"
la var Profit_Brought_Forward "Profit Brought Forward (In Billion Rs.)"
la var Profit_Avail_Appropriation "Profit Available for Appropriation (In Billion Rs.)"
la var Prft_Trans_Statutory_Reserve "Profit Transferred to Statutory Reserve (In Billion Rs.)"
la var Prft_Trans_Capital_Reserve "Profit Transferred to Capital Reserve (In Billion Rs.)"
la var Prft_Trans_Deb_Redemption "Profit Transferred for Debenture Redemption (In Billion Rs.)"
la var Prft_Trans_Inv_Fluctuate_Reserve "Profit Transferred to Investment Fluctuation Reserve (In Billion Rs.)"
la var Prft_Trans_Other_Reserves "Profit Transferred to Other Reserves (In Billion Rs.)"
la var Prft_Trans_Proposed_Dividend "Profit Transferred for Proposed Dividends (In Billion Rs.)"
la var Prft_Trans_Tax_on_Dividend "Profit Transferred for Tax on Dividends (In Billions Rs.)"
la var Prft_Bal_carried_to_BS "Profit Balance Carried to the Balance Sheet (In Billion Rs.)"
la var Capital_Mkt_Sector_Advances "Advances to the Capital Market (In Billion Rs.)"
la var Real_Estate_Sector_Advances "Advances to the Real Estate Sector (In Billion Rs.)"
la var Commodities_Based_Advances "Commodity Based Advances (In Billion Rs.)"
la var Total_Advances "Total Advances to Sensitive Sectors (In Billion Rs.)"


la var Dep_1_to_14_Days "Value of Deposits tenured between 1 and 14 days (In Billion Rs.)"
la var Dep_15_to_28_Days "Value of Deposits tenured between 15 and 28 days (In Billion Rs.)"
la var Dep_29_Days_to_3_Months "Value of Deposits tenured between 29 days and 3 months (In Billion Rs.)"
la var Dep_3_Months_to_6_Months "Value of Deposits tenured between 3 Months and 6 Months (In Billion Rs.)"
la var Dep_6_Months_to_1_year "Value of Deposits tenured between 6 Months and 1 year (In Billion Rs.)"
la var Dep_1_year_to_3_years "Value of Deposits tenured between 1 year and 3 years (In Billion Rs.)"
la var Dep_3_years_to_5_years "Value of Deposits tenured between 3 years and 5 years (In Billion Rs.)"
la var Dep_over_5_years "Value of Deposits tenured over 5 years (In Billion Rs.)"
la var Total_Deposits "Total Deposits (In Billion Rs.)"

la var Borrowings_1_to_14_Days "Value of Borrowings maturing between 1 and 14 days (In Billion Rs.)"
la var Borrowings_15_to_28_Days "Value of Borrowings maturing between 15 and 28 days (In Billion Rs.)"
la var Borrowings_29_Days_to_3_Months "Value of Borrowings maturing between 29 days and 3 months (In Billion Rs.)"
la var Borrowings_3_Months_to_6_Months "Value of Borrowings maturing between 3 Months and 6 Months (In Billion Rs.)"
la var Borrowings_6_Months_to_1_year "Value of Borrowings maturing between 6 Months and 1 year (In Billion Rs.)"
la var Borrowings_1_year_to_3_years "Value of Borrowings maturing between 1 year and 3 years (In Billion Rs.)"
la var Borrowings_3_years_to_5_years "Value of Borrowings maturing between 3 years and 5 years (In Billion Rs.)"
la var Borrowings_over_5_years "Value of Borrowings maturing over 5 years (In Billion Rs.)"
la var Total_Borrowings "Total Borrowings (In Billion Rs.)"


la var Inv_at_BV_1_to_14_Days "Book Value of Investments maturing between 1 and 14 days (In Billion Rs.)"
la var Inv_at_BV_15_to_28_Days "Book Value of Investments maturing between 15 and 28 days (In Billion Rs.)"
la var Inv_at_BV_29_Days_to_3_Months "Book Value of Investments maturing between 29 days and 3 months (In Billion Rs.)"
la var Inv_at_BV_3_Months_to_6_Months "Book Value of Investments maturing between 3 Months and 6 Months (In Billion Rs.)"
la var Inv_at_BV_6_Months_to_1_year "Book Value of Investments maturing between 6 Months and 1 year (In Billion Rs.)"
la var Inv_at_BV_1_year_to_3_years "Book Value of Investments maturing between 1 year and 3 years (In Billion Rs.)"
la var Inv_at_BV_3_years_to_5_years "Book Value of Investments maturing between 3 years and 5 years (In Billion Rs.)"
la var Inv_at_BV_over_5_years "Book Value of Investments maturing over 5 years (In Billion Rs.)"
la var Total_Inv_Book_Value "Total Investments at Book Value (In Billion Rs.)"


la var Frgn_Cur_Asts_1_to_14_Days "Value of Foreign Currency Assets  maturing between 1 and 14 days (In Billion Rs.)"
la var Frgn_Cur_Asts_15_to_28_Days "Value of Foreign Currency Assets maturing between 15 and 28 days (In Billion Rs.)"
la var Frgn_Cur_Asts_29_Days_to_3_Mnths "Value of Foreign Currency Assets maturing between 29 days and 3 months (In Billion Rs.)"
la var Frgn_Cur_Asts_3_Mnths_to_6_Mnths "Value of Foreign Currency Assets maturing between 3 Months and 6 Months (In Billion Rs.)"
la var Frgn_Cur_Asts_6_Mnths_to_1_year "Value of Foreign Currency Assets maturing between 6 Months and 1 year (In Billion Rs.)"
la var Frgn_Cur_Asts_1_year_to_3_years "Value of Foreign Currency Assets maturing between 1 year and 3 years (In Billion Rs.)"
la var Frgn_Cur_Asts_3_years_to_5_years "Value of Foreign Currency Assets maturing between 3 years and 5 years (In Billion Rs.)"
la var Frgn_Cur_Asts_over_5_years "Value of Foreign Currency Assets maturing over 5 years (In Billion Rs.)"
la var Total_Foreign_Currency_Assets "Total Foreign Currency Assets (In Billion Rs.)"


la var Frgn_Cur_Lia_1_to_14_Days "Value of Foreign Currency Liabilities  maturing between 1 and 14 days (In Billion Rs.)"
la var Frgn_Cur_Lia_15_to_28_Days "Value of Foreign Currency Liabilities maturing between 15 and 28 days (In Billion Rs.)"
la var Frgn_Cur_Lia_29_Days_to_3_Mnths "Value of Foreign Currency Liabilities maturing between 29 days and 3 months (In Billion Rs.)"
la var Frgn_Cur_Lia_3_Mnths_to_6_Mnths "Value of Foreign Currency Liabilities maturing between 3 Months and 6 Months (In Billion Rs.)"
la var Frgn_Cur_Lia_6_Mnths_to_1_year "Value of Foreign Currency Liabilities maturing between 6 Months and 1 year (In Billion Rs.)"
la var Frgn_Cur_Lia_1_year_to_3_years "Value of Foreign Currency Liabilities maturing between 1 year and 3 years (In Billion Rs.)"
la var Frgn_Cur_Lia_3_years_to_5_years "Value of Foreign Currency Liabilities maturing between 3 years and 5 years (In Billion Rs.)"
la var Frgn_Cur_Asts_over_5_years "Value of Foreign Currency Liabilities maturing over 5 years (In Billion Rs.)"
la var Total_Foreign_Currency_Lia "Total Foreign Currency Liabilities (In Billion Rs.)"


la var Loans_Adv_1_to_14_Days "Value of Advances maturing between 1 and 14 days (In Billion Rs.)"
la var Loans_Adv_15_to_28_Days "Value of Advances maturing between 15 and 28 days (In Billion Rs.)"
la var Loans_Adv_29_Days_to_3_Months "Value of Advances maturing between 29 days and 3 months (In Billion Rs.)"
la var Loans_Adv_3_Months_to_6_Months "Value of Advances maturing between 3 Months and 6 Months (In Billion Rs.)"
la var Loans_Adv_6_Months_to_1_year "Value of Advances maturing between 6 Months and 1 year (In Billion Rs.)"
la var Loans_Adv_1_year_to_3_years "Value of Advances maturing between 1 year and 3 years (In Billion Rs.)"
la var Loans_Adv_3_years_to_5_years "Value of Advances maturing between 3 years and 5 years (In Billion Rs.)"
la var Loans_Adv_over_5_years "Value of Advances maturing over 5 years (In Billion Rs.)"
la var Total_Loans_and_Advances "Total Advances (In Billion Rs.)"


la var Standard_Assets_yr_Loans "Standard Loans during the year (In Billion Rs.)"
la var Sub_Standard_Assets_yr_Loans "Sub Standard Loans during the year (In Billion Rs.)"
la var Doubtful_Assets_yr_Loans "Doubtful Loans during the year (In Billion Rs.)"
la var Tot_Loans_Subject_Restructuring "Total Loans subject to Restructuring during the year (In Billion Rs.)"
la var Standard_Assets_yr_Corp_Deb "Standard Corporate Loans during the year (In Billion Rs.)"
la var Sub_Standard_Assets_yr_Corp_Deb "Sub Standard Corporate Loans during the year (In Billion Rs.)"
la var Doubtful_Assets_yr_Corp_Dev "Doubtful Corporate Loans during the year (In Billion Rs.)"
la var Tot_Corp_Deb_Subj_Restructuring "Total Corporate Loans subject to Restructuring during the year (In Billion Rs.)"
la var Total_Assets_Subj_Restructuring "Total Assets subject to Restructuring during the year (In Billion Rs.)"
la var bank_id "Bank ID"


save "$clean/Annual_Financials_2005_2024_All_Vars_All_Banks", replace

