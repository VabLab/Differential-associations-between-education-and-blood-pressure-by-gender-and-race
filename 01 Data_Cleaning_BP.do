*****************Project: Differential associations between education and blood pressure by gender and race
*****************Author: Lucia Pacca
*****************Code Reviewer: Amanda Irish
*****************Project Summary: Using data from the Health and Retirement Study, we investigate the association between education and blood pressure across race by gender subgroups.


*****************This .do file (Data Cleaning) includes:
*****************1) MERGE THE DIFFERENT DATA SOURCES (lines 10-129)
*****************2) CLEAN MAIN VARIABLES (lines 133-256)
*****************3) RESHAPE DATA FROM WIDE TO LONG (lines 260-292)
*****************4) DEFINE ELIGIBLE SAMPLE (lines 294-297)
*****************5) DEFINE OUTCOME (lines 300-319)
*****************6) DEFINE EXPOSURE (lines 329-416)

local path /Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP

*******************1)MERGING THE DIFFERENT DATA SOURCES
*****************Files from Core Surveys
**We need them if we want to look at original BP measurements 
clear
set more off
foreach data in H06C_R H06I_R H08C_R H08I_R H10C_R H10I_R H12C_R H12I_R H14C_R H14I_R H16C_R H16I_R{
global path "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP"
infile using "$path/`data'.dct", using("$path/`data'.DA")
save "$path/`data'.dta", replace
clear
}

**TRACKER
use "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/trk2018tr_r.dta"
capture drop key
gen key=HHID+PN
sort key
save, replace

* Most variables come from RAND (2018 v2) data
clear
clear mata
set maxvar 30000 //set STATA memory to 
use  "//Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/randhrs1992_2018v1.dta", clear
keep hhidpn raedyrs ragender raracem rabyear rahispan rabplace rameduc rafeduc *bpsys *bpdia *hibp racohbyr //keep only relevant variables
gen key = string(hhidpn,"%09.0f")
sort key
save "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/bp_analysis_dataset.dta", replace
use "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/bp_analysis_dataset.dta", clear
sort key
merge 1:1 key using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/trk2018tr_r.dta", keepusing(DEGREE HHID PN)
keep if _merge==3
save, replace

*************MERGE WITH YEARLY FILES - keep bp variables including self-reported medication use
use "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/bp_analysis_dataset.dta", clear
sort HHID PN
capture drop _merge
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/H06I_R.dta", keepusing (KI854-KI871 KPMELIG)
drop _merge
sort HHID PN
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/H06C_R.dta", keepusing (KC005 KC006 KC008 KC009 KC211 KC212 KC213)
drop _merge
sort HHID PN
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/H08I_R.dta", keepusing (LI855M1 LI855M2 LI855M3 LI855M4 LI857 LI859 LI860 LI861 LI862 LI864 LI865 LI866 LI867 LI869 LI870 LI871 LPMELIG)
drop _merge
sort HHID PN
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/H08C_R.dta", keepusing (LC005 LC006 LC008 LC009 LC211 LC212 LC213)
drop _merge
sort HHID PN
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/H10I_R.dta", keepusing (MI855M1 MI855M2 MI855M3 MI855M4 MI857 MI859 MI860 MI861 MI862 MI864 MI865 MI866 MI867 MI869 MI870 MI871 MPMELIG)
drop _merge
sort HHID PN
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/H10C_R.dta", keepusing (MC005 MC006 MC008 MC009 MC211 MC212 MC213)
drop _merge
sort HHID PN
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/H12I_R.dta", keepusing (NI855M1 NI855M2 NI855M3 NI855M4 NI857 NI859 NI860 NI861 NI862 NI864 NI865 NI866 NI867 NI869 NI870 NI871 NPMELIG)
drop _merge
sort HHID PN
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/H12C_R.dta", keepusing (NC005 NC006 NC008 NC009 NC211 NC212 NC213)
drop _merge
sort HHID PN
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/H14I_R.dta", keepusing (OI855M1 OI855M2 OI855M3 OI855M4 OI857 OI859 OI860 OI861 OI862 OI864 OI865 OI866 OI867 OI869 OI870 OI871 OPMELIG)
drop _merge
sort HHID PN
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/H14C_R.dta", keepusing (OC005 OC006)
drop _merge
sort HHID PN
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/H16I_R.dta", keepusing (PI855M1 PI855M2 PI855M3 PI855M4 PI857 PI859 PI860 PI861 PI862 PI864 PI865 PI866 PI867 PI869 PI870 PI871 PPMELIG)
drop _merge
sort HHID PN
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/H16C_R.dta", keepusing (PC005 PC006)
drop _merge
sort HHID PN
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/h18i_r.dta", keepusing (QI855M1 QI855M2 QI855M3 QI855M4 QI857 QI859 QI860 QI861 QI862 QI864 QI865 QI866 QI867 QI869 QI870 QI871 qpmelig)
drop _merge
sort HHID PN
merge 1:1 HHID PN using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/Core Survey BP/h18c_r.dta", keepusing (QC005 QC006)
save, replace

*******************************Rename variables with repeated values so that they have interview year at the end
*******************************BP MEDICATIONS YES/NO

gen bpmed_2006=.
replace bpmed_2006=1 if KC006==1
replace bpmed_2006=0 if KC006==5

gen bpmed_2008=.
replace bpmed_2008=1 if LC006==1
replace bpmed_2008=0 if LC006==5

gen bpmed_2010=.
replace bpmed_2010=1 if MC006==1
replace bpmed_2010=0 if MC006==5

gen bpmed_2012=.
replace bpmed_2012=1 if NC006==1
replace bpmed_2012=0 if NC006==5

gen bpmed_2014=.
replace bpmed_2014=1 if OC006==1
replace bpmed_2014=0 if OC006==5

gen bpmed_2016=.
replace bpmed_2016=1 if PC006==1
replace bpmed_2016=0 if PC006==5

gen bpmed_2018=.
replace bpmed_2018=1 if QC006==1
replace bpmed_2018=0 if QC006==5

*******************************FACE-TO_FACE INTERVIEW ELIGIBILITY
*******************************This variable identifies those who were eligible for face-to-face interview and, therefore, for haveing their BP taken.
rename KPMELIG eligible_2006
rename LPMELIG eligible_2008
rename MPMELIG eligible_2010
rename NPMELIG eligible_2012
rename OPMELIG eligible_2014
rename PPMELIG eligible_2016
rename qpmelig eligible_2018

*******************************2) CLEANING MAIN VARIABLES
*******************************EXPOSURE: EDUCATION operationalized as # school years
*******************************
*Using raedyrs to construct final "school years" variable --> cleaned by RAND
* Those having education less than 5 years are grouped into category of having 5 years of education due to lower frequency (<500)
tab raedyrs, mis
gen schlyrs_final=raedyrs

replace schlyrs_final=5 if schlyrs_final<=4
tab schlyrs_final, mis

*****************CONFOUNDERS

* GENDER (females as reference)
tab ragender, mis
			gen female = 0 if ragender==1
			replace female = 1 if ragender==2
			tab female 
			
* RACE/ETHNICITY (non-hispanic white as reference)

			gen race=0 if raracem==1 & rahispan==0	// Non hispanic white
			replace race = 1 if raracem==2 & rahispan==0 // NH black 
			replace race = 3 if raracem==3	& rahispan==0 // NH other 
			replace race = 2 if rahispan==1	//hispanic
			
			tab race 
			
			label def race 0 "NH white" 1 "NH black" 2 "hispanic" 3 "NH other" 
			lab value race race
            tab race, mi
			
* race * sex 
			gen race_gen = 0 if race==0 & female==0						 // most advantaged = reference group = white men 	
			replace race_gen = 1 if race==0 & female == 1 
			
			replace race_gen = 2 if race==1 & female == 0 
			replace race_gen = 3 if race == 1 & female == 1
			
			replace race_gen = 4 if race == 2 & female == 0 			
			
			replace race_gen = 5 if race == 2 & female == 1				
			
			replace race_gen = 6 if race == 3 & female == 0				
			replace race_gen = 7 if race == 3 & female == 1	
			replace race_gen = . if race == . | female == . 
		
		* check coding
			tab race_gen, mi

		* label 
			label define race_gen 0 "white men" 1 "white women" 2 "black men" 3 "black women" 4 "hispanic men" 5 "hispanic women"	6 "other men" 7 "other women" 
			label values race_gen race_gen 
			tab race_gen, mi


* birth place: southern birth & immigrant. Born in the south = south atlantic (WV, MD, DE, DC, VA, NC, SC, GA, FL),
												// east south central (KY, TN, MS, AL), 
												// west south central (TX, OK, AR, LA)
tab rabplace,mi
replace  rabplace =. if rabplace==.m
	
		gen bplace = 0 if !inrange(rabplace, 5, 7) & rabplace != 11 & rabplace != . //us not south 
		replace bplace = 1 if rabplace == 5 | rabplace == 6 | rabplace == 7 // southern birth
		replace bplace = 2 if rabplace == 11		// born outside the US
		replace bplace = 3 if rabplace == 10  		// us not known - we do not want to exclude these people (774 people)
		tab bplace, mi
		tab rabplace bplace, mi
		
		
		label define bplace 0 "us not south" 1 "southern birth" 2 "immigrant" 3 "us not specified"
		label values bplace bplace
		
		save, replace

*****************Mother's and Father's Education
*****************We are replacing missing values with the average and then defining missing indicator for mother's and father's education
foreach var of varlist rameduc rafeduc {
replace `var'=. if `var'==.a|`var'==.d|`var'==.e|`var'==.l|`var'==.m|`var'==.n|`var'==.r|`var'==.s|`var'==.w|`var'==.x
}

capture drop medu fedu
egen rameduc_mean=mean(rameduc)
egen rafeduc_mean=mean(rafeduc)

gen medu = rameduc
replace medu=rameduc_mean if medu==.

gen fedu = rafeduc
replace fedu=rafeduc_mean if fedu==.

gen missing_medu=0 //Missing indicator for mother's education
replace missing_medu=1 if rameduc==.

gen missing_fedu=0 //Missing indicator for father's education
replace missing_fedu=1 if rafeduc==.

save, replace

*****************For AHEAD values, use values imputed by Anusha 
*****************For AHEAD cohort, mother's and father'd education is originally coded as either 7.5 or 8.5
use "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/cses_measures.dta"
sort key
save, replace

use "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/bp_analysis_dataset.dta", clear
sort key
capture drop _merge
merge key using "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/cses_measures.dta"
drop if _merge==2
save, replace

replace medu=myrs if medu==7.5|medu==8.5
replace fedu=fyrs if fedu==7.5|fedu==8.5

save, replace

*******************Only keep variables that will be actually used in our model
use "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/bp_analysis_dataset.dta", clear
keep HHID PN DEGREE key raedyrs schlyrs_final female rabyear race medu fedu missing_medu missing_fedu bplace racohbyr r*bpsys r*bpdia r*hibp race_gen bplace bpmed* eligible*

*******************3) RESHAPE DATA FROM WIDE TO LONG
*******************Reshape data "long"
rename r8bpsys bpsys_2006
rename r9bpsys bpsys_2008
rename r10bpsys bpsys_2010
rename r11bpsys bpsys_2012
rename r12bpsys bpsys_2014
rename r13bpsys bpsys_2016
rename r14bpsys bpsys_2018

rename r8bpdia bpdia_2006
rename r9bpdia bpdia_2008
rename r10bpdia bpdia_2010
rename r11bpdia bpdia_2012
rename r12bpdia bpdia_2014
rename r13bpdia bpdia_2016
rename r14bpdia bpdia_2018

rename r8hibp hibp_2006
rename r9hibp hibp_2008
rename r10hibp hibp_2010
rename r11hibp hibp_2012
rename r12hibp hibp_2014
rename r13hibp hibp_2016
rename r14hibp hibp_2018

replace key=HHID+PN
reshape long  bpsys_ bpdia_  bpmed_ hibp_ eligible_, i(key) j(year)
rename bpsys_ bpsys
rename bpdia_ bpdia
rename bpmed_ bpmed
rename hibp_ hibp
rename eligible_ eligible

*******4) DEFINE ELIGIBLE SAMPLE: all individuals aged 51 and older (HRS eligible); exclude younger spouses
*******Age at each bp measurements
gen age=year-rabyear
keep if age>=51

*******5) DEFINE OUTCOMES
*******We are defining our final outcomes and exposure now, since it is easier to do it after reshaping the data "long"
*******OUTCOME # 1: HYPERTENSION
*******Either measured hypertension (BP>=140/90) or taking BP medications

foreach var of varlist bpsys bpdia {
replace `var'=. if `var'==.a|`var'==.d|`var'==.e|`var'==.l|`var'==.m|`var'==.n|`var'==.r|`var'==.s|`var'==.w|`var'==.x
}

capture drop hypertension //MAIN OUTCOME
gen hypertension=0 if bpsys<140 & bpdia<90
replace hypertension=1 if bpsys>=140|bpdia>=90
replace hypertension=1 if bpmed==1
replace hypertension=. if bpsys==. & bpdia==.

capture drop hypertension_2017 //SENSITIVITY TO A DIFFERENT CUTOFF: 130/80 (AHA 2017)
gen hypertension_2017=0 if bpsys<130 & bpdia<80
replace hypertension_2017=1 if bpsys>=130|bpdia>=80
replace hypertension_2017=1 if bpmed==1
replace hypertension_2017=. if bpsys==. & bpdia==.

*****Alternative Outcome: Self reported Hypertension
*****"Have you ever had high BP?"
capture drop hypertension_sr
gen hypertension_sr=1 if hibp==1
replace hypertension_sr=0 if hibp==0
replace hypertension_sr=. if hibp>1

*******6) DEFINE EXPOSURE
*******EXPOSURE: EDUCATION - Try splines with different knots
*******Graphs to visually look at discontinuity

bysort HHID PN: egen mean_sbp=mean(bpsys) //Mean SBP by # school years
bysort schlyrs_final:egen mean_sbp_schlyrs=mean(mean_sbp)
twoway (scatter mean_sbp_schlyrs schlyrs_final), xline(12)

gen sample_htn=0 //Prevalence of HTN by school years
replace sample_htn=1 if hypertension!=.
bysort schlyrs_final:egen total_sample_htn=total(sample_htn)
bysort schlyrs_final:egen total_htn=total(hypertension)
gen prevalence_htn=total_htn/total_sample_htn
twoway (scatter prevalence_htn schlyrs_final), xline(12)

*****Spline with knot at 12 years of education
gen schlyrs_cen12 = schlyrs_final - 12
gen edu_low12 = schlyrs_cen12 if schlyrs_cen12 < 0
replace edu_low12 = 0 if schlyrs_cen12 >= 0
replace edu_low12 =. if schlyrs_cen12==.
gen knot_12 = 1 if schlyrs_cen12 >= 0 & schlyrs_cen12 != .
replace knot_12 = 0 if schlyrs_cen12 < 0 
gen edu_high12 = schlyrs_cen12 if schlyrs_cen12 >= 1 & schlyrs_cen12 != .
replace edu_high12 = 0 if schlyrs_cen12 <1

*****Spline with knot at 11 years of education
gen schlyrs_cen11 = schlyrs_final - 11
gen edu_low11 = schlyrs_cen11 if schlyrs_cen11 < 0
replace edu_low11 = 0 if schlyrs_cen11 >= 0
replace edu_low11 =. if schlyrs_cen11==.
gen knot_11 = 1 if schlyrs_cen11 >= 0 & schlyrs_cen11 != .
replace knot_11 = 0 if schlyrs_cen11 < 0 
gen edu_high11 = schlyrs_cen11 if schlyrs_cen11 >= 1 & schlyrs_cen11 != .
replace edu_high11 = 0 if schlyrs_cen11 <1

*****Spline with knot at 10 years of education
gen schlyrs_cen10 = schlyrs_final - 10
gen edu_low10 = schlyrs_cen10 if schlyrs_cen10 < 0
replace edu_low10 = 0 if schlyrs_cen10 >= 0
replace edu_low10 =. if schlyrs_cen10==.
gen knot_10 = 1 if schlyrs_cen10 >= 0 & schlyrs_cen10 != .
replace knot_10 = 0 if schlyrs_cen10 < 0 
gen edu_high10 = schlyrs_cen10 if schlyrs_cen10 >= 1 & schlyrs_cen10 != .
replace edu_high10 = 0 if schlyrs_cen10 <1

*****Try spline at 10 vs. 11 vs. 12 years of education, then select best fitting model using QIC
tab race, gen (race_d)
tab year, gen (year_d)
tab bplace, gen (bplace_d)
global conf age female race_d* fedu medu missing_medu missing_fedu bplace* year_d*

*****Alternative Exposure: DEGREE 
*****We are going to test if DEGREE is a better fit than years of schooling
capture drop degree
gen degree=0 if DEGREE==0|DEGREE==1
replace degree=1 if DEGREE==2
replace degree=2 if DEGREE>=3 & DEGREE<=6
replace degree=2 if DEGREE==9

capture drop degree_d*
tab degree, gen (degree_d)

egen id=group(key)
xtset id year

*****After defining all the potential exposure variables, we look at the QIC (equivalent to AIC but for GEE model) to look at the best model fit
*****Lower QIC indicates better model fit
qic hypertension edu_low12 knot_12 edu_high12 $conf, family(binomial) link(logit) corr(exchangeable) robust 
qic hypertension edu_high11 knot_11 edu_low11 $conf, family(binomial) link(logit) corr(exchangeable) robust  
qic hypertension edu_high10 knot_10 edu_low10 $conf, family(binomial) link(logit) corr(exchangeable) robust 
qic hypertension schlyrs_final $conf, family(binomial) link(logit) corr(exchangeable) robust  
qic hypertension degree_d* $conf, family(binomial) link(logit) corr(exchangeable) robust  

qic bpsys edu_low12 knot_12 edu_high12 $conf, corr(exchangeable) robust 
qic bpsys edu_high11 knot_11 edu_low11 $conf, corr(exchangeable) robust  
qic bpsys edu_high10 knot_10 edu_low10 $conf, corr(exchangeable) robust 
qic bpsys schlyrs_final $conf, corr(exchangeable) robust  
qic bpsys degree_d* $conf, corr(exchangeable) robust  

****We chose a knot at 12 years for 2 reasons: 1)model fit based on QIC; 2)interpretation: 12 years generally corresponds to achieving high school diploma.

****Label final variables for Tables/Figures
label variable edu_high12 "Education > 12 years"
label variable edu_low12 "Education < 12 years"
label variable medu "Mother's Education"
label variable fedu "Father's Education"
label variable missing_medu "Missing Mother's Education"
label variable missing_fedu "Missing Father's Education"

save "/Users/lpacca/Library/CloudStorage/Box-Box/04 - Education and BP/bp_analysis_short.dta", replace




























