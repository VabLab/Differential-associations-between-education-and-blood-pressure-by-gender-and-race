# Differential-associations-between-education-and-blood-pressure-by-gender-and-race
Code for the "Differential associations between education and blood pressure by gender and race" publication.

Link to paper: https://link.springer.com/article/10.1186/s12889-025-23409-5 

# Authors
Lucia Pacca, Amanda M Irish, Catherine dP Duarte, Alicia R Riley, Mark J Pletcher, Zinzi D Bailey & Anusha M Vable 

# Abstract
**Background:** Previous research suggests education is inversely associated with blood pressure, but little work has
examined whether this relationship differs by race and gender jointly. Identifying the most vulnerable groups may
inform hypertension prevention strategies. In this population-based study, we investigate the association between
education and blood pressure overall and across race-by-gender subgroups.

**Methods:** Our analytic sample included participants aged 50 + to the US Health and Retirement Study data from 2006
to 2008 (N = 24,526). Our exposure was education, measured as self-reported years of schooling and modeled as a
spline with a knot and discontinuity at 12 years representing high school diploma. We used generalized estimating
equations to estimate the relationship between education and repeated measurements of two blood pressure
outcomes: systolic blood pressure (SBP) and hypertension (HTN), then included race-by-gender interactions with
education to evaluate differential associations. All models were adjusted for age, birthplace, parents’ education, and
survey year.

**Results:** Mean age was 64.4 years, mean SBP was 129.9 mmHg, and HTN prevalence was 63.1%. Overall, below 12
years, each additional year of education was not associated with blood pressure, while twelve years of schooling
was associated with lower blood pressure (b=-1.02; 95% CI: -2.04, 0.00 for SBP) and each additional year of education
after 12 years was associated with lower SBP and lower odds of HTN (e.g., SBP: b=-0.75 mmHg; 95% CI: -0.88, -0.62).
We observed some differential relationships by demographic subgroup such that, among Black men, 12 years of
education predicted higher odds of HTN compared to White men (interaction OR = 1.60; 95% CI: 1.02, 2.52), and
each additional year of education after 12 years was associated with larger SBP benefits for White, Hispanic and Black
women compared to White men.

**Conclusions:** We found an overall protective relationship between more education and blood pressure/hypertension
such that each additional year of college education was associated with lower blood pressure/hypertension,
particularly among White and Hispanic women. However, we also found evidence of diminished benefits to high
school degree attainment among Black men compared to other groups in hypertension prevalence.

# Repository Content
**01 Data_Cleaning_BP.do:** This .do file prepares the analytic dataset by merging data from multiple sources, cleaning the main variables, and reshaping the data from wide to long format. It then defines the eligible analytic sample, outcome, and exposure variables used in the analysis.

**02 Data_Analysis_BP.do:** This .do file conducts the main statistical analyses, including descriptive statistics for Table 1 and the primary analyses used to generate Tables 2–3 and Figure 1.

**03 Sensitivity_Analyses_BP.do:** This .do file conducts robustness checks using two alternative outcomes—hypertension based on the 2017 guidelines and diastolic blood pressure—and an alternative exposure based on terminal degree. The robustness check using multiple imputation is conducted in a separate .do file.

**04 Multiple_Imputations_BP.do:** This .do file conducts a sensitivity analysis using multiple imputation by chained equations (MICE) for missing outcomes and covariates to minimize potential selection bias. 

Data can be accessed through the Health and Retirement Study (HRS) public files.

# Contact information
lucia.pacca88@gmail.com



