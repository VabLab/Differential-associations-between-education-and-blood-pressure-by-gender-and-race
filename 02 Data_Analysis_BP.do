*****************Project: Differential associations between education and blood pressure by gender and race
*****************Author: Lucia Pacca
*****************Code Reviewer: Amanda Irish
*****************Project Summary: Using data from the Health and Retirement Study, we investigate the association between education and blood pressure across race by gender subgroups.

*****************This .do file (Data Analysis) includes:
*****************1) DESCRIPTIVE STATISTICS FOR TABLE 1 (lines 10-35)
*****************2)MAIN RESULTS (lines 39-183) - Table 2, Table 3 and Figure 1

********************************************************************************
*****1) DESCRIPTIVE STATISTICS
*****TABLE 1 - summary statistics for analytic sample
*****Run regresion for base model and then keep analytic sample
use "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/bp_analysis_short.dta", replace
drop if bpsys==.
global conf i.race female fedu medu missing_medu missing_fedu i.bplace age i.year
xtgee hypertension edu_low12 knot_12 edu_high12 $conf, family(binomial) link(logit) corr(exchangeable) eform

capture drop sample mean_sample
gen sample=1 if e(sample)
tab sample
bysort id: egen mean_sample=mean(sample)

capture drop baseline_bpsys
bysort id (year) : gen baseline_bpsys = bpsys[1]

bysort id (year) : gen time=_n

baselinetable age(cts) schlyrs_final(cts) race female bplace(cat) medu(cts) fedu(cts) missing_medu(cat) missing_fedu(cat) bpsys(cts) bpdia(cts) hypertension(cat) if time==1 & mean_sample==1, exportexcel(table1_overall)

baselinetable age(cts) schlyrs_final(cts) bplace(cat) medu(cts) fedu(cts) missing_medu(cat) missing_fedu(cat) bpsys(cts) bpdia(cts) hypertension(cat) if time==1 & mean_sample==1, by(race_gen) exportexcel(table1_bygroup)

*****Main Characteristics by race and gender
su schlyrs_final if time==1 & race_gen==5
su bpsys if time==1 & race_gen==5
tab hypertension if time==1 & race_gen==0 & e(sample)

********************************************************************************
*****2) MAIN RESULTS
*****This section includes: 1)Baseline GEE results, no interactions 2)Interaction Analyses 3)Stratified Results for Hypertension and Systolic Blood Pressure outcomes.

*****1) Basic GEE regressions, no interactions
*****Table 2

use "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/bp_analysis_short.dta", replace
global conf i.race female fedu medu missing_medu missing_fedu i.bplace age i.year

*****Systolic Blood Pressure
xtgee bpsys edu_low12 knot_12 edu_high12 $conf, corr(exchangeable) robust 
*xtgee bpsys edu_low12 knot_12 edu_high12 if e(sample), corr(exchangeable) robust 
outreg2 using overall.doc, dec(2) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label replace

*****HTN
xtgee hypertension edu_low12 knot_12 edu_high12 $conf, family(binomial) link(logit) corr(exchangeable) eform
*xtgee hypertension edu_low12 knot_12 edu_high12 if e(sample), family(binomial) link(logit) corr(exchangeable) eform 
outreg2 using overall.doc, dec(2) eform cti(odds ratio) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label append

*****2) Differential Returns - Interaction Analyses
*****Table 3

*****Race-gender interactions
global conf fedu medu missing_medu missing_fedu bplace_d* age i.year

*****Systolic Blood Pressure Interactions
xtgee bpsys c.edu_high12##i.race_gen knot_12##i.race_gen c.edu_low12##i.race_gen $conf, corr(exchangeable) robust //Adjusted
estimate store interactions_BP
*xtgee bpsys c.edu_high12##i.race_gen knot_12##i.race_gen c.edu_low12##i.race_gen if e(sample), corr(exchangeable) robust //Unadjusted
outreg2 using interactions.doc, dec(2) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label replace

**F test for joint significance of the interaction terms (Mark's advice)
test 1.race_gen#c.edu_high12 2.race_gen#c.edu_high 3.race_gen#c.edu_high12 4.race_gen#c.edu_high12 5.race_gen#c.edu_high12 6.race_gen#c.edu_high12 7.race_gen#c.edu_high12 1.knot_12#1.race_gen 1.knot_12#2.race_gen 1.knot_12#3.race_gen 1.knot_12#4.race_gen 1.knot_12#5.race_gen 1.knot_12#6.race_gen 1.knot_12#7.race_gen 1.race_gen#c.edu_low12 2.race_gen#c.edu_low12 3.race_gen#c.edu_low12 4.race_gen#c.edu_low12 5.race_gen#c.edu_low12 6.race_gen#c.edu_low12 7.race_gen#c.edu_low12 

*****HTN Interactions
xtgee hypertension c.edu_high12##i.race_gen knot_12##i.race_gen c.edu_low12##i.race_gen $conf, family(binomial) link(logit) corr(exchangeable) eform robust //Adjusted
estimate store interactions_HTN
*xtgee hypertension c.edu_high12##i.race_gen knot_12##i.race_gen c.edu_low12##i.race_gen if e(sample), family(binomial) link(logit) corr(exchangeable) eform robust  //Unadjusted
outreg2 using interactions.doc, dec(2) eform cti(odds ratio) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label append

**F test for joint significance of the interaction terms (Mark's advice)
test 1.race_gen#c.edu_high12 2.race_gen#c.edu_high 3.race_gen#c.edu_high12 4.race_gen#c.edu_high12 5.race_gen#c.edu_high12 6.race_gen#c.edu_high12 7.race_gen#c.edu_high12 1.knot_12#1.race_gen 1.knot_12#2.race_gen 1.knot_12#3.race_gen 1.knot_12#4.race_gen 1.knot_12#5.race_gen 1.knot_12#6.race_gen 1.knot_12#7.race_gen 1.race_gen#c.edu_low12 2.race_gen#c.edu_low12 3.race_gen#c.edu_low12 4.race_gen#c.edu_low12 5.race_gen#c.edu_low12 6.race_gen#c.edu_low12 7.race_gen#c.edu_low12 

*********Supplemental material: plots for key interaction terms 
*********Panel 1: Key interaction terms for SBP
coefplot interactions_BP, keep(1.race_gen#c.edu_high12 2.race_gen#c.edu_high12 3.race_gen#c.edu_high12 4.race_gen#c.edu_high12 5.race_gen#c.edu_high12) xline(0, lcolor(black) lwidth(thin))
coefplot interactions_BP, keep(1.knot_12#1.race_gen 1.knot_12#2.race_gen 1.knot_12#3.race_gen 1.knot_12#4.race_gen 1.knot_12#5.race_gen) xline(0, lcolor(black) lwidth(thin))

*********Panel 2: Key interaction terms for HTN
coefplot interactions_HTN, keep(1.race_gen#c.edu_high12 2.race_gen#c.edu_high12 3.race_gen#c.edu_high12 4.race_gen#c.edu_high12 5.race_gen#c.edu_high12) eform xline(1, lcolor(black) lwidth(thin))
coefplot interactions_HTN, keep(1.knot_12#1.race_gen 1.knot_12#2.race_gen 1.knot_12#3.race_gen 1.knot_12#4.race_gen 1.knot_12#5.race_gen) eform xline(1, lcolor(black) lwidth(thin))

addplot 1: , xline(0) norescaling legend(off)
addplot 2: , xline(1) norescaling legend(off) 

******3) Stratified Results
******Presented in Figure 1

********Systolic Blood Pressure Stratified
xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51, corr(exchangeable) robust
estimate store Overall_BP

xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==1 & female==0, corr(exchangeable) robust
estimate store Black_men_BP
***Predict adjusted means for black men
margins, at(edu_low=-7 knot_12=0 edu_high=0)
margins, at(edu_low=0 knot_12=0 edu_high=0)
margins, at(edu_low=0 knot_12=1 edu_high=0)
margins, at(edu_low=0 knot_12=1 edu_high=5)

xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==0 & female==0, corr(exchangeable) robust
estimate store White_men_BP
***Predict adjusted means for white men
margins, at(edu_low=-7 knot_12=0 edu_high=0)
margins, at(edu_low=0 knot_12=0 edu_high=0)
margins, at(edu_low=0 knot_12=1 edu_high=0)
margins, at(edu_low=0 knot_12=1 edu_high=5)

xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==2 & female==0, corr(exchangeable) robust
estimate store Hispanic_men_BP
***Predict adjusted means for white men
margins, at(edu_low=-7 knot_12=0 edu_high=0)
margins, at(edu_low=0 knot_12=0 edu_high=0)
margins, at(edu_low=0 knot_12=1 edu_high=0)
margins, at(edu_low=0 knot_12=1 edu_high=5)

xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==1 & female==1, corr(exchangeable) robust
estimate store Black_women_BP
***Predict adjusted means for black women
margins, at(edu_low=-7 knot_12=0 edu_high=0)
margins, at(edu_low=0 knot_12=0 edu_high=0)
margins, at(edu_low=0 knot_12=1 edu_high=0)
margins, at(edu_low=0 knot_12=1 edu_high=5)

xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==0 & female==1, corr(exchangeable) robust
estimate store White_women_BP
***Predict adjusted means for white women
margins, at(edu_low=-7 knot_12=0 edu_high=0)
margins, at(edu_low=0 knot_12=0 edu_high=0)
margins, at(edu_low=0 knot_12=1 edu_high=0)
margins, at(edu_low=0 knot_12=1 edu_high=5)

xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==2 & female==1, corr(exchangeable) robust
estimate store Hispanic_women_BP
***Predict adjusted means for hispanic women
margins, at(edu_low=-7 knot_12=0 edu_high=0)
margins, at(edu_low=0 knot_12=0 edu_high=0)
margins, at(edu_low=0 knot_12=1 edu_high=0)
margins, at(edu_low=0 knot_12=1 edu_high=5)

coefplot (Overall_BP, keep(edu_low12 edu_high12 knot_12) mcolor(black) ciopts(lcolor(black))) (White_men_BP, keep(edu_low12 edu_high12 knot_12) mcolor(maroon) ciopts(lcolor(maroon))) (White_women_BP, keep(edu_low12 edu_high12 knot_12) mcolor(maroon*0.5) ciopts(lcolor(maroon*0.5))) (Black_men_BP, keep(edu_low12 edu_high12 knot_12) mcolor(navy) ciopts(lcolor(navy))) (Black_women_BP, keep(edu_low12 edu_high12 knot_12) mcolor(navy*0.5) ciopts(lcolor(navy*0.5))) (Hispanic_men_BP, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen) ciopts(lcolor(dkgreen))) (Hispanic_women_BP, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen*0.5) ciopts(lcolor(dkgreen*0.5))), xline(0, lcolor(black) lwidth(thin) lpattern(dash)) legend(col(3) size(small))

******Predicted coefficients were copied and saved in an Excel file
******Graphs for Figure 2

import excel "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Predicted_bpsys_spline.xlsx", sheet("Adjusted means") firstrow clear //import predicted coefficients from Excel file

******Revised graph: white men vs. black men (shows difference in the knot) - after reviewers' comment, show discontinuity and add open/closed circle for intervals of the spline
graph twoway (line bpsyshat_whitemen_low education) (scatter bpsyshat_whitemen_knot_low education, ms(Oh))||(line bpsyshat_whitemen_high education) (scatter bpsyshat_whitemen_knot_high education, ms(o))||(line bpsyshat_blackmen_low education) (scatter bpsyshat_blackmen_knot_low education, ms(Oh))||(line bpsyshat_blackmen_high education) (scatter bpsyshat_blackmen_knot_high education, ms(o)), xlabel(5(1)17) xline(12, lpattern(dash) lcolor(gray)) legend(col(2) size(small))

******white men vs. white women, hispanic women and black women (shows difference in slopes)
graph twoway (line bpsyshat_whitemen_low education) (scatter bpsyshat_whitemen_knot_low education, ms(Oh))||(line bpsyshat_whitemen_high education) (scatter bpsyshat_whitemen_knot_high education, ms(o))||(line bpsyshat_whitewomen_low education) (scatter bpsyshat_whitewomen_knot_low education, ms(Oh))||(line bpsyshat_whitewomen_high education) (scatter bpsyshat_whitewomen_knot_high education, ms(o))||(line bpsyshat_hispanicwomen_low education) (scatter bpsyshat_hispanicwomen_knot_low education, ms(Oh))||(line bpsyshat_hispanicwomen_high education) (scatter bpsyshat_hispanicwomen_knot_high education, ms(o))||(line bpsyshat_blackwomen_low education) (scatter bpsyshat_blackwomen_knot_low education, ms(Oh))||(line bpsyshat_blackwomen_high education) (scatter bpsyshat_blackwomen_knot_high education, ms(o)), xlabel(5(1)17) xline(12, lpattern(dash) lcolor(gray)) legend(col(4) size(small))

use "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/bp_analysis_short.dta", replace

******HTN Stratified
xtgee hypertension edu_low12 knot_12 edu_high12 i.year $conf if age>=51, family(binomial) link(logit) robust eform
estimate store Overall_HTN
xtgee hypertension edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==1 & female==0, family(binomial) link(logit) robust eform
estimate store Black_Men_HTN
xtgee hypertension edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==1 & female==1, family(binomial) link(logit) corr(exchangeable) robust
estimate store Black_Women_HTN
xtgee hypertension edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==0 & female==0, family(binomial) link(logit) corr(exchangeable) robust
estimate store White_Men_HTN
xtgee hypertension edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==0 & female==1, family(binomial) link(logit) corr(exchangeable) robust
estimate store White_Women_HTN
xtgee hypertension edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==2 & female==0, family(binomial) link(logit) corr(exchangeable) robust
estimate store Hispanic_Men_HTN
xtgee hypertension edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==2 & female==1, family(binomial) link(logit) corr(exchangeable) robust
estimate store Hispanic_Women_HTN

coefplot (Overall_HTN, keep(edu_low12 edu_high12 knot_12) mcolor(black) ciopts(lcolor(black))) (White_Men_HTN, keep(edu_low12 edu_high12 knot_12) mcolor(maroon) ciopts(lcolor(maroon))) (White_Women_HTN, keep(edu_low12 edu_high12 knot_12) mcolor(maroon*0.5) ciopts(lcolor(maroon*0.5))) (Black_Men_HTN, keep(edu_low12 edu_high12 knot_12) mcolor(navy) ciopts(lcolor(navy))) (Black_Women_HTN, keep(edu_low12 edu_high12 knot_12) mcolor(navy*0.5) ciopts(lcolor(navy*0.5))) (Hispanic_Men_HTN, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen) ciopts(lcolor(dkgreen))) (Hispanic_Women_HTN, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen*0.5) ciopts(lcolor(dkgreen*0.5))), xline(0, lcolor(black) lwidth(thin) lpattern(dash)) legend(col(3) size(small))

*********Combined coefficients plot
coefplot (Overall_BP, keep(edu_low12 edu_high12 knot_12) mcolor(black) ciopts(lcolor(black))) (White_men_BP, keep(edu_low12 edu_high12 knot_12) mcolor(maroon) ciopts(lcolor(maroon))) (White_women_BP, keep(edu_low12 edu_high12 knot_12) mcolor(maroon*0.5) ciopts(lcolor(maroon*0.5))) (Black_men_BP, keep(edu_low12 edu_high12 knot_12) mcolor(navy) ciopts(lcolor(navy))) (Black_women_BP, keep(edu_low12 edu_high12 knot_12) mcolor(navy*0.5) ciopts(lcolor(navy*0.5))) (Hispanic_men_BP, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen) ciopts(lcolor(dkgreen))) (Hispanic_women_BP, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen*0.5) ciopts(lcolor(dkgreen*0.5))), legend(col(3) size(small)) || (Overall_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(black) ciopts(lcolor(black))) (White_Men_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(maroon) ciopts(lcolor(maroon))) (White_Women_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(maroon*0.5) ciopts(lcolor(maroon*0.5))) (Black_Men_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(navy) ciopts(lcolor(navy))) (Black_Women_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(navy*0.5) ciopts(lcolor(navy*0.5))) (Hispanic_Men_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen) ciopts(lcolor(dkgreen))) (Hispanic_Women_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen*0.5) ciopts(lcolor(dkgreen*0.5))), legend(col(3) size(small))||, drop(_cons) byopts(xrescale cols(2))

addplot 1: , xline(0) norescaling legend(off)
addplot 2: , xline(1) norescaling legend(off)
