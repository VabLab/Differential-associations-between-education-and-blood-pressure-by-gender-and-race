*****************Project: Differential associations between education and blood pressure by gender and race
*****************Author: Lucia Pacca
*****************Code Reviewer: Amanda Irish
*****************Robustness Check # 3: Multiple Imputation

**********Sensitivity Analysis: Multiple Imputation by Chained Equations for missing outcome
**********we performed multiple imputations by chained equations (MICE) on missing outcomes and covariates to minimize potential selection bias
**********We kept the missing indicator for mother's and father's education since we belive that missingness is informative 
use "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/bp_analysis_short.dta", clear
gen wave=8 if year==2006
replace wave=9 if year==2008
replace wave=10 if year==2010
replace wave=11 if year==2012
replace wave=12 if year==2014
replace wave=13 if year==2016
replace wave=14 if year==2018
gen hhidpn=key
sort hhidpn wave

***********Merge with interview status to look at people who died or dropped out
merge hhidpn wave using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/randhrs1992_2018v1_IWSTAT.dta"
tab _merge
keep if _merge==3

replace schlyrs_final=. if schlyrs_final==.m

gen eligible_new=2 if eligible==1|eligible==2|eligible==7 //eligible
replace eligible_new=1 if eligible==5|eligible==6|iwstat!=1 & iwstat!=4|age<51 & bpsys==. //not eligible because of age, nursing home, proxy, dead/dropout or age ineligible
replace eligible_new=0 if eligible==. & age>=51 & iwstat==1 //if alive, age eligible but reported as eligible in a different wave

replace edu_low12=. if schlyrs_final==.
capture drop _est*
capture drop race_d* year_d*
capture drop bplace_d*
capture drop hibp
capture drop hypertension_2017 hypertension_sr
capture drop sample*
capture drop hypertension
capture drop schlyrs_cen12 edu_low12 edu_high12 knot_12

capture drop _merge
reshape wide bpsys bpdia bpmed eligible eligible_new wave iwstat age, i(id) j(year)

***We are merging waves because we don't want to impute too much data
foreach var in bpsys bpdia bpmed age{
gen `var'1=`var'2006
replace `var'1=`var'2008 if `var'2006==. & `var'2008!=.
gen `var'2=`var'2010
replace `var'2=`var'2012 if `var'2010==. & `var'2012!=.
gen `var'3=`var'2014
replace `var'3=`var'2016 if `var'2014==. & `var'2016!=.
gen `var'4=`var'2018
}

egen eligible_new1=rowmax(eligible_new2006 eligible_new2008)
egen eligible_new2=rowmax(eligible_new2010 eligible_new2012)
egen eligible_new3=rowmax(eligible_new2014 eligible_new2016)
gen eligible_new4=eligible_new2018

replace eligible_new4=. if eligible_new2016==2 & bpsys2016!=. & eligible_new4==0

drop *2006 *2008 *2010 *2012 *2014 *2012 *2014 *2016 *2018

reshape long bpsys bpdia bpmed eligible eligible_new age, i(id) j(timepoint)
//keep if rabyear!=. & schlyrs_final!=. & female!=. & race!=. & bplace!=. & eligible_new!=1 & eligible_new!=.
keep if eligible_new!=1 & eligible_new!=.

tab race, gen(race_d)
tab bplace, gen(bplace_d)

nmissing

***Tell stata how to arrange imputed datasets
mi set mlong

***Reshape data from long to wide
***Having the data in wide form takes care of both the nesting issue (creates one row of data per individual) and allows us to easily use variables from the other time periods as predictors of missing values, since in wide form, they are just other variables in the dataset (rather than being part of another row in the dataset).
mi xtset, clear

mi reshape wide bpsys bpdia bpmed eligible eligible_new age, i(id) j(timepoint)

***Register imputed variables - tell STATA which variables will need to be imputed
mi register imputed bpsys1 bpsys2 bpsys3 bpsys4 bpdia1 bpdia2 bpdia3 bpdia4 schlyrs_final bplace age1 age2 age3 age4

**Perform Chained imputation  
mi impute chained (regress) bpsys1 bpsys2 bpsys3 bpsys4 bpdia1 bpdia2 bpdia3 bpdia4 schlyrs_final age1 age2 age3 age4 (mlogit) bplace = female race medu fedu missing_medu missing_fedu, add(30) rseed(2022) dots force augment

***Now I am reshaping the data back to long, since I will need them in this form for the analyses
mi reshape long bpsys bpdia bpmed eligible eligible_new age, i(id) j(timepoint)

***Summarize bpsys for each of the imputed datasets to make sure it is not out of range
mi xeq: su bpsys, d

***Regenerate HTN from imputed blood pressure data
mi passive: gen hypertension=0 if bpsys<140 & bpdia<90
mi passive: replace hypertension=1 if bpsys>=140|bpdia>=90
mi passive: replace hypertension=1 if bpmed==1
mi passive: replace hypertension=. if bpsys==. & bpdia==.

**Regenerate education variables
*****Spline with knot at 12 years of education
mi passive: gen schlyrs_cen12 = schlyrs_final - 12
mi passive: gen edu_low12 = schlyrs_cen12 if schlyrs_cen12 < 0
mi passive: replace edu_low12 = 0 if schlyrs_cen12 >= 0
mi passive: replace edu_low12 =. if schlyrs_cen12==.
mi passive: gen knot_12 = 1 if schlyrs_cen12 >= 0 & schlyrs_cen12 != .
mi passive: replace knot_12 = 0 if schlyrs_cen12 < 0 
mi passive: gen edu_high12 = schlyrs_cen12 if schlyrs_cen12 >= 1 & schlyrs_cen12 != .
mi passive: replace edu_high12 = 0 if schlyrs_cen12 <1

***Run regression - Base Model
***We have time point instead of year because we had to merge two waves in order to do the imputation  
mi xtset id timepoint
mi estimate: xtgee bpsys c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967, corr(exchangeable) robust

mi estimate, eform: xtgee hypertension c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967, family(binomial) link(logit) corr(exchangeable) robust

***Run regression - Interaction Model
mi xtset id timepoint
mi estimate: xtgee bpsys c.edu_low12##i.race_gen knot_12##i.race_gen c.edu_high12##i.race_gen fedu medu missing_medu missing_fedu age i.bplace i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967, corr(exchangeable) robust

mi estimate, eform: xtgee hypertension c.edu_low12##i.race_gen knot_12##i.race_gen c.edu_high12##i.race_gen fedu medu missing_medu missing_fedu age i.bplace i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967, family(binomial) link(logit) corr(exchangeable) robust

***Outreg does not work with "mi estimate"; so I made the tables manually.

***Stratified Results
********Systolic Blood Pressure Stratified
mi estimate:xtgee bpsys c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967, corr(exchangeable) robust
estimate store Overall_BP
mi estimate:xtgee bpsys c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967 & race==1 & female==0, corr(exchangeable) robust
estimate store Black_men_BP
mi estimate:xtgee bpsys c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967 & race==0 & female==0, corr(exchangeable) robust
estimate store White_men_BP
mi estimate:xtgee bpsys c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967 & race==2 & female==0, corr(exchangeable) robust
estimate store Hispanic_men_BP
mi estimate:xtgee bpsys c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967 & race==1 & female==1, corr(exchangeable) robust
estimate store Black_women_BP
mi estimate:xtgee bpsys c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967 & race==0 & female==1, corr(exchangeable) robust
estimate store White_women_BP
mi estimate:xtgee bpsys c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967 & race==2 & female==1, corr(exchangeable) robust
estimate store Hispanic_women_BP

******HTN Stratified
mi estimate, eform: xtgee hypertension c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967, family(binomial) link(logit) robust eform
estimate store Overall_HTN
mi estimate, eform: xtgee hypertension c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967 & race==1 & female==0, family(binomial) link(logit) robust eform
estimate store Black_Men_HTN
mi estimate, eform: xtgee hypertension c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967 & race==1 & female==1, family(binomial) link(logit) corr(exchangeable) robust
estimate store Black_Women_HTN
mi estimate, eform: xtgee hypertension c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967 & race==0 & female==0, family(binomial) link(logit) corr(exchangeable) robust
estimate store White_Men_HTN
mi estimate, eform: xtgee hypertension c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967 & race==0 & female==1, family(binomial) link(logit) corr(exchangeable) robust
estimate store White_Women_HTN
mi estimate, eform: xtgee hypertension c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967 & race==2 & female==0, family(binomial) link(logit) corr(exchangeable) robust
estimate store Hispanic_Men_HTN
mi estimate, eform: xtgee hypertension c.edu_low12 knot_12 c.edu_high12 female i.race fedu medu missing_medu missing_fedu i.bplace age i.timepoint if eligible_new!=1 & eligible_new!=. & rabyear<=1967 & race==2 & female==1, family(binomial) link(logit) corr(exchangeable) robust
estimate store Hispanic_Women_HTN

*********Combined coefficients plot
coefplot (Overall_BP, keep(edu_low12 edu_high12 knot_12) mcolor(black) ciopts(lcolor(black))) (White_men_BP, keep(edu_low12 edu_high12 knot_12) mcolor(maroon) ciopts(lcolor(maroon))) (White_women_BP, keep(edu_low12 edu_high12 knot_12) mcolor(maroon*0.5) ciopts(lcolor(maroon*0.5))) (Black_men_BP, keep(edu_low12 edu_high12 knot_12) mcolor(navy) ciopts(lcolor(navy))) (Black_women_BP, keep(edu_low12 edu_high12 knot_12) mcolor(navy*0.5) ciopts(lcolor(navy*0.5))) (Hispanic_men_BP, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen) ciopts(lcolor(dkgreen))) (Hispanic_women_BP, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen*0.5) ciopts(lcolor(dkgreen*0.5))), legend(col(3) size(small)) || (Overall_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(black) ciopts(lcolor(black))) (White_Men_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(maroon) ciopts(lcolor(maroon))) (White_Women_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(maroon*0.5) ciopts(lcolor(maroon*0.5))) (Black_Men_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(navy) ciopts(lcolor(navy))) (Black_Women_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(navy*0.5) ciopts(lcolor(navy*0.5))) (Hispanic_Men_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen) ciopts(lcolor(dkgreen))) (Hispanic_Women_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen*0.5) ciopts(lcolor(dkgreen*0.5))), legend(col(3) size(small))||, drop(_cons) byopts(xrescale cols(2))

addplot 1: , xline(0) norescaling legend(off)
addplot 2: , xline(1) norescaling legend(off)











