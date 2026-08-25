*****************Project: Differential associations between education and blood pressure by gender and race
*****************Author: Lucia Pacca
*****************Code Reviewer: Amanda Irish

***********Robustness checks
***********1) Two alternative outcomes: HTN based on 2017 guidelines (BP<=130/80) and diastolic BP
***********2) Alternative exposure: terminal degree
***********(Robustness check using ultiple imputation is reported in another .do file)

***************************************************
*****1) Alternative outcomes
*****Alternative Outcomes, base model
*****Systolic Blood Pressure
global conf i.race female fedu medu missing_medu missing_fedu i.bplace age i.year

xtgee bpdia edu_low12 knot_12 edu_high12 $conf, corr(exchangeable) robust 
*xtgee bpdia edu_low12 knot_12 edu_high12 if e(sample), corr(exchangeable) robust 
outreg2 using altoutcomes_overall.doc, dec(2) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label replace

*****HTN
xtgee hypertension_2017 edu_low12 knot_12 edu_high12 $conf, family(binomial) link(logit) corr(exchangeable) eform
*xtgee hypertension edu_low12 knot_12 edu_high12 if e(sample), family(binomial) link(logit) corr(exchangeable) eform 
outreg2 using altoutcomes_overall.doc, dec(2) eform cti(odds ratio) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label append

*****Alternative Outcomes, interaction models
*****Race-gender interactions
global conf fedu medu missing_medu missing_fedu bplace_d* age i.year

*****Systolic Blood Pressure Interactions
xtgee bpdia c.edu_high12##i.race_gen knot_12##i.race_gen c.edu_low12##i.race_gen $conf, corr(exchangeable) robust //Adjusted
*xtgee bpdia c.edu_high12##i.race_gen knot_12##i.race_gen c.edu_low12##i.race_gen if e(sample), corr(exchangeable) robust //Unadjusted
outreg2 using altoutcomes_interactions.doc, dec(2) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label replace

*****HTN Interactions
xtgee hypertension c.edu_high12##i.race_gen knot_12##i.race_gen c.edu_low12##i.race_gen $conf, family(binomial) link(logit) corr(exchangeable) eform robust //Adjusted
*xtgee hypertension c.edu_high12##i.race_gen knot_12##i.race_gen c.edu_low12##i.race_gen if e(sample), family(binomial) link(logit) corr(exchangeable) eform robust  //Unadjusted
outreg2 using altoutcomes_interactions.doc, dec(2) eform cti(odds ratio) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label append

********Systolic Blood Pressure Stratified
xtgee bpdia edu_low12 knot_12 edu_high12 i.year $conf if age>=51, corr(exchangeable) robust
estimate store Overall_DBP
xtgee bpdia edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==1 & female==0, corr(exchangeable) robust
estimate store Black_men_DBP
xtgee bpdia edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==0 & female==0, corr(exchangeable) robust
estimate store White_men_DBP
xtgee bpdia edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==2 & female==0, corr(exchangeable) robust
estimate store Hispanic_men_DBP
xtgee bpdia edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==1 & female==1, corr(exchangeable) robust
estimate store Black_women_DBP
xtgee bpdia edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==0 & female==1, corr(exchangeable) robust
estimate store White_women_DBP
xtgee bpdia edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==2 & female==1, corr(exchangeable) robust
estimate store Hispanic_women_DBP

coefplot (Overall_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(black) ciopts(lcolor(black))) (White_men_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(maroon) ciopts(lcolor(maroon))) (White_women_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(maroon*0.5) ciopts(lcolor(maroon*0.5))) (Black_men_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(navy) ciopts(lcolor(navy))) (Black_women_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(navy*0.5) ciopts(lcolor(navy*0.5))) (Hispanic_men_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen) ciopts(lcolor(dkgreen))) (Hispanic_women_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen*0.5) ciopts(lcolor(dkgreen*0.5))), xline(0, lcolor(black) lwidth(thin) lpattern(dash)) legend(col(3) size(small))

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

****Combined coefplots
*********Combined coefficients plot
coefplot (Overall_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(black) ciopts(lcolor(black))) (White_men_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(maroon) ciopts(lcolor(maroon))) (White_women_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(maroon*0.5) ciopts(lcolor(maroon*0.5))) (Black_men_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(navy) ciopts(lcolor(navy))) (Black_women_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(navy*0.5) ciopts(lcolor(navy*0.5))) (Hispanic_men_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen) ciopts(lcolor(dkgreen))) (Hispanic_women_DBP, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen*0.5) ciopts(lcolor(dkgreen*0.5))), legend(col(3) size(small)) || (Overall_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(black) ciopts(lcolor(black))) (White_Men_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(maroon) ciopts(lcolor(maroon))) (White_Women_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(maroon*0.5) ciopts(lcolor(maroon*0.5))) (Black_Men_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(navy) ciopts(lcolor(navy))) (Black_Women_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(navy*0.5) ciopts(lcolor(navy*0.5))) (Hispanic_Men_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen) ciopts(lcolor(dkgreen))) (Hispanic_Women_HTN, eform keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen*0.5) ciopts(lcolor(dkgreen*0.5))), legend(col(3) size(small))||, drop(_cons) byopts(xrescale cols(2))

addplot 1: , xline(0) norescaling legend(off)
addplot 2: , xline(1) norescaling legend(off)

***************************************************
*****2) Use terminal degree as alternative exposure
*****DEGREE as exposure
global conf i.race female fedu medu missing_medu missing_fedu i.bplace age i.year

fvset base 1 degree

xtgee bpsys i.degree $conf, corr(exchangeable) robust
outreg2 using degree_overall.doc, dec(2) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label replace

xtgee hypertension i.degree $conf, family(binomial) link(logit) corr(exchangeable) eform robust
outreg2 using degree_overall.doc, dec(2) eform cti(odds ratio) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label append

*****DEGREE - Differential Returns
global conf fedu medu missing_medu missing_fedu i.bplace age i.year

fvset base 1 degree
xtgee bpsys i.degree##i.race_gen $conf, corr(exchangeable) robust //Adjusted
outreg2 using degree_interactions.doc, dec(2) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label replace

fvset base 1 degree
xtgee hypertension i.degree##i.race_gen $conf, family(binomial) link(logit) corr(exchangeable) eform robust //Adjusted
outreg2 using degree_interactions.doc, dec(2) eform cti(odds ratio) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label append

********Systolic Blood Pressure Stratified
xtgee bpsys i.degree i.year $conf if age>=51, corr(exchangeable) robust
estimate store Overall_BP
xtgee bpsys i.degree i.year $conf if age>=51 & race==1 & female==0, corr(exchangeable) robust
estimate store Black_men_BP
xtgee bpsys i.degree i.year $conf if age>=51 & race==0 & female==0, corr(exchangeable) robust
estimate store White_men_BP
xtgee bpsys i.degree i.year $conf if age>=51 & race==2 & female==0, corr(exchangeable) robust
estimate store Hispanic_men_BP
xtgee bpsys i.degree i.year $conf if age>=51 & race==1 & female==1, corr(exchangeable) robust
estimate store Black_women_BP
xtgee bpsys i.degree i.year $conf if age>=51 & race==0 & female==1, corr(exchangeable) robust
estimate store White_women_BP
xtgee bpsys i.degree i.year $conf if age>=51 & race==2 & female==1, corr(exchangeable) robust
estimate store Hispanic_women_BP

******HTN Stratified
xtgee hypertension i.degree i.year $conf if age>=51, family(binomial) link(logit) robust eform
estimate store Overall_HTN
xtgee hypertension i.degree i.year $conf if age>=51 & race==1 & female==0, family(binomial) link(logit) robust eform
estimate store Black_Men_HTN
xtgee hypertension i.degree i.year $conf if age>=51 & race==1 & female==1, family(binomial) link(logit) corr(exchangeable) robust
estimate store Black_Women_HTN
xtgee hypertension i.degree i.year $conf if age>=51 & race==0 & female==0, family(binomial) link(logit) corr(exchangeable) robust
estimate store White_Men_HTN
xtgee hypertension i.degree i.year $conf if age>=51 & race==0 & female==1, family(binomial) link(logit) corr(exchangeable) robust
estimate store White_Women_HTN
xtgee hypertension i.degree i.year $conf if age>=51 & race==2 & female==0, family(binomial) link(logit) corr(exchangeable) robust
estimate store Hispanic_Men_HTN
xtgee hypertension i.degree i.year $conf if age>=51 & race==2 & female==1, family(binomial) link(logit) corr(exchangeable) robust
estimate store Hispanic_Women_HTN

*********Combined coefficients plot
coefplot (Overall_BP, keep(*degree) mcolor(black) ciopts(lcolor(black))) (White_men_BP, keep(*degree) mcolor(maroon) ciopts(lcolor(maroon))) (White_women_BP, keep(*degree) mcolor(maroon*0.5) ciopts(lcolor(maroon*0.5))) (Black_men_BP, keep(*degree) mcolor(navy) ciopts(lcolor(navy))) (Black_women_BP, keep(*degree) mcolor(navy*0.5) ciopts(lcolor(navy*0.5))) (Hispanic_men_BP, keep(*degree) mcolor(dkgreen) ciopts(lcolor(dkgreen))) (Hispanic_women_BP, keep(*degree) mcolor(dkgreen*0.5) ciopts(lcolor(dkgreen*0.5))), legend(col(3) size(small)) || (Overall_HTN, eform keep(*degree) mcolor(black) ciopts(lcolor(black))) (White_Men_HTN, eform keep(*degree) mcolor(maroon) ciopts(lcolor(maroon))) (White_Women_HTN, eform keep(*degree) mcolor(maroon*0.5) ciopts(lcolor(maroon*0.5))) (Black_Men_HTN, eform keep(*degree) mcolor(navy) ciopts(lcolor(navy))) (Black_Women_HTN, eform keep(*degree) mcolor(navy*0.5) ciopts(lcolor(navy*0.5))) (Hispanic_Men_HTN, eform keep(*degree) mcolor(dkgreen) ciopts(lcolor(dkgreen))) (Hispanic_Women_HTN, eform keep(*degree) mcolor(dkgreen*0.5) ciopts(lcolor(dkgreen*0.5))), legend(col(3) size(small))||, drop(_cons) byopts(xrescale cols(2))

addplot 1: , xline(0) norescaling legend(off)
addplot 2: , xline(1) norescaling legend(off)

********3) After review: Sensitivity analysis excluding immigrants
use "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/bp_analysis_short.dta", clear
global conf i.race female fedu medu missing_medu missing_fedu i.bplace age i.year 

*****Systolic Blood Pressure
xtgee bpsys edu_low12 knot_12 edu_high12 $conf if bplace_d3!=1, corr(exchangeable) robust 
*xtgee bpsys edu_low12 knot_12 edu_high12 if e(sample), corr(exchangeable) robust 
outreg2 using overall_noimmigrant.doc, dec(2) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label replace

*****HTN
xtgee hypertension edu_low12 knot_12 edu_high12 $conf if bplace_d3!=1, family(binomial) link(logit) corr(exchangeable) eform
*xtgee hypertension edu_low12 knot_12 edu_high12 if e(sample), family(binomial) link(logit) corr(exchangeable) eform 
outreg2 using overall_noimmigrant.doc, dec(2) eform cti(odds ratio) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label append

*****Systolic Blood Pressure Interactions
xtgee bpsys c.edu_low12##i.race_gen knot_12##i.race_gen c.edu_high12##i.race_gen $conf if bplace_d3!=1, corr(exchangeable) robust //Adjusted
*xtgee bpsys c.edu_high12##i.race_gen knot_12##i.race_gen c.edu_low12##i.race_gen if e(sample), corr(exchangeable) robust //Unadjusted
outreg2 using interactions_noimmigrant.doc, dec(2) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label replace

*****HTN Interactions
xtgee hypertension c.edu_low12##i.race_gen knot_12##i.race_gen c.edu_high12##i.race_gen $conf if bplace_d3!=1, family(binomial) link(logit) corr(exchangeable) eform robust //Adjusted
*xtgee hypertension c.edu_high12##i.race_gen knot_12##i.race_gen c.edu_low12##i.race_gen if e(sample), family(binomial) link(logit) corr(exchangeable) eform robust  //Unadjusted
outreg2 using interactions_noimmigrant.doc, dec(2) eform cti(odds ratio) stats(coef ci pval) sideway alpha(0.001, 0.01, 0.05) label append

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

******SBP Stratified
********Systolic Blood Pressure Stratified
xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51, corr(exchangeable) robust
estimate store Overall_BP
xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==1 & female==0, corr(exchangeable) robust
estimate store Black_men_BP
xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==0 & female==0, corr(exchangeable) robust
estimate store White_men_BP
xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==2 & female==0, corr(exchangeable) robust
estimate store Hispanic_men_BP
xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==1 & female==1, corr(exchangeable) robust
estimate store Black_women_BP
xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==0 & female==1, corr(exchangeable) robust
estimate store White_women_BP
xtgee bpsys edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==2 & female==1, corr(exchangeable) robust
estimate store Hispanic_women_BP

coefplot (Overall_BP, keep(edu_low12 edu_high12 knot_12) mcolor(black) ciopts(lcolor(black))) (White_men_BP, keep(edu_low12 edu_high12 knot_12) mcolor(maroon) ciopts(lcolor(maroon))) (White_women_BP, keep(edu_low12 edu_high12 knot_12) mcolor(maroon*0.5) ciopts(lcolor(maroon*0.5))) (Black_men_BP, keep(edu_low12 edu_high12 knot_12) mcolor(navy) ciopts(lcolor(navy))) (Black_women_BP, keep(edu_low12 edu_high12 knot_12) mcolor(navy*0.5) ciopts(lcolor(navy*0.5))) (Hispanic_men_BP, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen) ciopts(lcolor(dkgreen))) (Hispanic_women_BP, keep(edu_low12 edu_high12 knot_12) mcolor(dkgreen*0.5) ciopts(lcolor(dkgreen*0.5))), xline(0, lcolor(black) lwidth(thin) lpattern(dash)) legend(col(3) size(small))

******HTN Stratified
xtgee hypertension edu_low12 knot_12 edu_high12 i.year $conf if age>=51, family(binomial) link(logit) robust eform
estimate store Overall_HTN
xtgee hypertension edu_low12 knot_12 edu_high12 i.year $conf if age>=51 & race==1 & female==0, family(binomial) link(logit) corr(exchangeable) robust
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














