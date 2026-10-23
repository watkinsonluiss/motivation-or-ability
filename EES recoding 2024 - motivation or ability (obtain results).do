cd "C:\Users\willa\OneDrive - Luiss\data_new\polarisation"

*drop Malta
drop if country == 470

*missing values
*missing perc
egen missing_pos = total(missing(pos)) if issue != "lr", by(resp_id)

gen not_missing_ptv_lr = 1 if pos !=. & education !=. & polInterest !=. & gender !=. & class !=. & turnout_ptv == 1 & fraction_correct != . & issue=="lr"
gen not_missing_ptv_eu = 1 if pos !=. & education !=. & polInterest !=. & gender !=. & class !=.  & turnout_ptv == 1 & fraction_correct != . & issue=="eu"
gen not_missing_ptv_issues = 1 if missing_pos == 0 & education !=. & polInterest !=. & gender !=. & class !=. & turnout_ptv == 1

gen not_missing_proximity_vote_lr = 1 if pos !=. & education !=. & polInterest !=. & fraction_correct != . & gender !=. & class !=. & issue=="lr"
gen not_missing_proximity_vote_eu = 1 if pos !=. & education !=. & polInterest !=. & fraction_correct != . & gender !=. & class !=. & issue=="eu"
gen not_missing_pv_issues = 1 if missing_pos == 0 & education !=. & polInterest !=. & gender !=. & class !=.

*cluster-mean variables 
egen country_issue = concat(country issue), punct("_") 
bysort country_issue: generate unique_country_issue = (_n == 1)

egen fraction_correct_mean = mean(fraction_correct), by(country_issue)
egen differential_min_mean = mean(differential_min), by(country_issue)

egen proximity_vote_mean = mean(proximity_vote), by(country_issue)

egen education_mean = mean(education), by(country)
egen polInterest_mean = mean(polInterest), by(country)

*descriptive statistics
scatter differential_min pos if issue=="lr"
scatter differential_min pos if issue=="eu"

scatter sdw_party_polarisation differential_min_mean if issue=="lr" & unique_country_issue==1, mlabel(country)

*CONTENTS 
*MAIN TEXT
*1) regression models
**a) left-right voting / party polarisation (weighted)
**b) eu issue voting / party polarisation (weighted)

*2) mediate - left-right voting
**a) party polarisation (weighted)

*3) mediate - eu issue voting 
**a) party polarisation (weighted)

*APPENDIX
*1) regression models 
**a) logit - left-right voting / party polarisation (weighted)
**b) logit - eu issue voting / party polarisation (weighted)
**c) melogit - left-right voting / party polarisation (weighted)
**d) melogit - eu issue voting / party polarisation (weighted)

*2) robustness checks - OLS regression
**a) party polarisation = absolute average deviation measure 
**b) including 'distance_min' as a control 
**c) perceived indifference 
**d) exclude respondents with 2+ closest parties 

*3) robustness checks - for party position knowledge variable
*OLS regression
**a) no minimum threshold 
**b) party position knowledge - excluding don't know responses 
**c) party position knowledge - excluding don't know responses + excluding respondents for whom there is no variation (novar==0)

*mediation analysis
**a) no minimum threshold 
**b) party position knowledge - excluding don't know responses 
**c) party position knowledge - excluding don't know responses + excluding respondents for whom there is no variation (novar==0)

*4) mixed - effect of distance on PTVs

*5) descriptive statistics 
**a) variation in the main variables by country
**b) bivariate correlations

*6) N/A - Worked example of how party position knowledge is calculated

*7) Issue by issue
**a) within voters + between issues (fixed effects) / party polarisation (weighted)
**b) between voters + within issues / party polarisation (weighted)

*MAIN TEXT
*1) regression models
**a) left-right voting party polarisation (weighted)
regress proximity_vote sdw_party_polarisation differential_min fraction_correct education polInterest age gender class party_id_match party_count if issue=="lr" & not_missing_proximity_vote_lr==1, vce(cluster country)
outreg2 using maintext_reg.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

**b) eu issue voting party polarisation (weighted)
regress proximity_vote sdw_party_polarisation differential_min fraction_correct education polInterest age gender class party_id_match party_count if issue=="eu" & not_missing_proximity_vote_eu==1, vce(cluster country)
outreg2 using maintext_reg.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

*2) mediate - left-right voting
**a) party polarisation (weighted)
preserve 
drop if issue !="lr"

mediate (proximity_vote education polInterest age gender class party_id_match party_count) (differential_min education polInterest age gender class party_id_match party_count, linear) (fraction_correct education polInterest age gender class party_id_match party_count, linear) (sdw_party_polarisation, continuous(0 1)) if issue=="lr" & not_missing_proximity_vote_lr==1, vce(cluster country)

putdocx begin
putdocx paragraph, halign(center)
putdocx text ("Left-right"), bold
putdocx table tbl1 = etable
putdocx save "maintext_med.docx", replace

restore 

*3) mediate - eu issue voting
**a) party polarisation (weighted)
preserve 
drop if issue !="eu"

mediate (proximity_vote education polInterest age gender class party_id_match party_count) (differential_min education polInterest age gender class party_id_match party_count, linear) (fraction_correct education polInterest age gender class party_id_match party_count, linear) (sdw_party_polarisation, continuous(0 1)) if issue=="eu" & not_missing_proximity_vote_eu==1, vce(cluster country)

putdocx begin
putdocx paragraph, halign(center)
putdocx text ("EU issue"), bold
putdocx table tbl1 = etable
putdocx save "maintext_med.docx", append

restore

*APPENDIX
*1) regression models (+ multilevel)
**a) logit - left-right voting / party polarisation (weighted)
logit proximity_vote sdw_party_polarisation differential_min fraction_correct education polInterest age gender class party_id_match party_count if issue=="lr" & not_missing_proximity_vote_lr==1, vce(cluster country)
outreg2 using appendix_reg_part1.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

**b) logit - eu issue voting / party polarisation (weighted)
logit proximity_vote sdw_party_polarisation differential_min fraction_correct education polInterest age gender class party_id_match party_count if issue=="eu" & not_missing_proximity_vote_eu==1, vce(cluster country)
outreg2 using appendix_reg_part1.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

**c) melogit - left-right voting / party polarisation (weighted)
melogit proximity_vote sdw_party_polarisation differential_min fraction_correct education polInterest age gender class party_id_match party_count if issue=="lr" & not_missing_proximity_vote_lr==1 || country:
outreg2 using appendix_reg_part1.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

**d) melogit - eu issue voting / party polarisation (weighted)
melogit proximity_vote sdw_party_polarisation differential_min fraction_correct education polInterest age gender class party_id_match party_count if issue=="eu" & not_missing_proximity_vote_eu==1 || country:
outreg2 using appendix_reg_part1.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

*2) GSEM models
**left-right
gsem (fraction_correct_mean <- sdw_party_polarisation education_mean polInterest_mean) (differential_min_mean <- sdw_party_polarisation education_mean polInterest_mean) (proximity_vote_mean <- sdw_party_polarisation fraction_correct_mean differential_min_mean education_mean polInterest_mean party_count) if issue=="lr" & unique_country_issue==1, vce(cluster country)

nlcom indirect1: _b[fraction_correct_mean:sdw_party_polarisation] * _b[proximity_vote_mean:fraction_correct_mean]
nlcom indirect2: _b[differential_min_mean:sdw_party_polarisation] * _b[proximity_vote_mean:differential_min_mean]
nlcom total_effect: (_b[fraction_correct_mean:sdw_party_polarisation] * _b[proximity_vote_mean:fraction_correct_mean]) + ( _b[differential_min_mean:sdw_party_polarisation] * _b[proximity_vote_mean:differential_min_mean] + _b[proximity_vote_mean:sdw_party_polarisation])

**eu issue
gsem (fraction_correct_mean <- sdw_party_polarisation education_mean polInterest_mean) (differential_min_mean <- sdw_party_polarisation education_mean polInterest_mean) (proximity_vote_mean <- sdw_party_polarisation fraction_correct_mean differential_min_mean education_mean polInterest_mean party_count) if issue=="eu" & unique_country_issue==1, vce(cluster country)

nlcom indirect1: _b[fraction_correct_mean:sdw_party_polarisation] * _b[proximity_vote_mean:fraction_correct_mean]
nlcom indirect2: _b[differential_min_mean:sdw_party_polarisation] * _b[proximity_vote_mean:differential_min_mean]
nlcom total_effect: (_b[fraction_correct_mean:sdw_party_polarisation] * _b[proximity_vote_mean:fraction_correct_mean]) + ( _b[differential_min_mean:sdw_party_polarisation] * _b[proximity_vote_mean:differential_min_mean] + _b[proximity_vote_mean:sdw_party_polarisation])

*3) robustness checks - OLS regression
**a) party polarisation = absolute average deviation measure 
regress proximity_vote party_polarisation differential_min fraction_correct education polInterest age gender class party_id_match party_count if issue=="lr" & not_missing_proximity_vote_lr==1, vce(cluster country)
outreg2 using appendix_reg_part2.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

regress proximity_vote party_polarisation differential_min fraction_correct education polInterest age gender class party_id_match party_count if issue=="eu" & not_missing_proximity_vote_eu==1, vce(cluster country)
outreg2 using appendix_reg_part2.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

**b) including 'distance_min' as a control 
regress proximity_vote sdw_party_polarisation differential_min fraction_correct education polInterest age gender class party_id_match distance_min party_count if issue=="lr" & not_missing_proximity_vote_lr==1, vce(cluster country)
outreg2 using appendix_reg_part2.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

regress proximity_vote sdw_party_polarisation differential_min fraction_correct education polInterest age gender class party_id_match distance_min party_count if issue=="eu" & not_missing_proximity_vote_eu==1, vce(cluster country)
outreg2 using appendix_reg_part2.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

**c) percieved indifference 
regress proximity_vote sdw_party_polarisation p_differential_min fraction_correct education polInterest age gender class party_id_match party_count if issue=="lr" & not_missing_proximity_vote_lr==1, vce(cluster country)
outreg2 using appendix_reg_part2.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

regress proximity_vote sdw_party_polarisation p_differential_min fraction_correct education polInterest age gender class party_id_match party_count if issue=="eu" & not_missing_proximity_vote_eu==1, vce(cluster country)
outreg2 using appendix_reg_part2.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

**d) exclude respondents with 2+ closest parties 
regress proximity_vote sdw_party_polarisation differential_min fraction_correct education polInterest age gender class party_id_match party_count if issue=="lr" & not_missing_proximity_vote_lr==1 & closest_party_n==1, vce(cluster country)
outreg2 using appendix_reg_part2.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

regress proximity_vote sdw_party_polarisation differential_min fraction_correct education polInterest age gender class party_id_match party_count if issue=="eu" & not_missing_proximity_vote_eu==1 & closest_party_n==1, vce(cluster country)
outreg2 using appendix_reg_part2.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

*4) robustness checks - party position knowledge
**a) party position knowledge - no minimum threshold 
regress proximity_vote sdw_party_polarisation differential_min NOth_fraction_correct education polInterest age gender class party_id_match party_count if issue=="lr" & not_missing_proximity_vote_lr==1, vce(cluster country)
outreg2 using appendix_reg_part3.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

regress proximity_vote sdw_party_polarisation differential_min NOth_fraction_correct education polInterest age gender class party_id_match party_count if issue=="eu" & not_missing_proximity_vote_eu==1, vce(cluster country)
outreg2 using appendix_reg_part3.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

**b) party position knowledge - excluding don't know responses 
regress proximity_vote sdw_party_polarisation differential_min fraction_correctwdk education polInterest age gender class party_id_match party_count if issue=="lr" & not_missing_proximity_vote_lr==1, vce(cluster country)
outreg2 using appendix_reg_part3.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

regress proximity_vote sdw_party_polarisation differential_min fraction_correctwdk education polInterest age gender class party_id_match party_count if issue=="eu" & not_missing_proximity_vote_eu==1, vce(cluster country)
outreg2 using appendix_reg_part3.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

**c) party position knowledge - excluding don't know responses + those that had no variation (novar==0)
regress proximity_vote sdw_party_polarisation differential_min fraction_correctwdk education polInterest age gender class party_id_match party_count if issue=="lr" & not_missing_proximity_vote_lr==1 & novar==0, vce(cluster country)
outreg2 using appendix_reg_part3.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

regress proximity_vote sdw_party_polarisation differential_min fraction_correctwdk education polInterest age gender class party_id_match party_count if issue=="eu" & not_missing_proximity_vote_eu==1 & novar==0, vce(cluster country)
outreg2 using appendix_reg_part3.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

**b /c) party position knowledge - excluding don't know responses + those that had no variation (novar==0) (mediation analysis) 
preserve 
drop if issue !="lr"

mediate (proximity_vote education polInterest age gender class party_id_match party_count) (differential_min education polInterest age gender class party_id_match party_count, linear) (fraction_correctwdk education polInterest age gender class party_id_match party_count, linear) (sdw_party_polarisation, continuous(0 1)) if issue=="lr" & not_missing_proximity_vote_lr==1 & novar==0, vce(cluster country)

putdocx begin
putdocx paragraph, halign(center)
putdocx text ("Left-right"), bold
putdocx table tbl1 = etable
putdocx save "appendix_med.docx", replace

restore 

*b / c) eu issue voting
preserve 
drop if issue !="eu"

mediate (proximity_vote education polInterest age gender class party_id_match party_count) (differential_min education polInterest age gender class party_id_match party_count, linear) (fraction_correctwdk education polInterest age gender class party_id_match party_count, linear) (sdw_party_polarisation, continuous(0 1)) if issue=="eu" & not_missing_proximity_vote_eu==1 & novar==0, vce(cluster country)

putdocx begin
putdocx paragraph, halign(center)
putdocx text ("EU issue"), bold
putdocx table tbl1 = etable
putdocx save "appendix_med.docx", append

restore

*5) mixed - effect of distance on PTVs
mixed ptv c.distance##c.sdw_party_polarisation c.distance##c.differential_min c.distance##c.fraction_correct c.distance##c.education c.distance##c.polInterest c.distance##c.age c.distance##c.gender c.distance##c.class c.distance##c.party_id_match || country: || resp_id: if issue=="lr" & not_missing_ptv_lr == 1
outreg2 using appendix_reg_part4.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

mixed ptv c.distance##c.sdw_party_polarisation c.distance##c.differential_min c.distance##c.fraction_correct c.distance##c.education c.distance##c.polInterest c.distance##c.age c.distance##c.gender c.distance##c.class c.distance##c.party_id_match || country: || resp_id: if issue=="eu" & not_missing_ptv_eu == 1
outreg2 using appendix_reg_part4.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)

*6) descriptive statistics 
**b) univariate
hist differential_min if issue=="lr" & not_missing_proximity_vote_lr == 1
hist differential_min if issue=="eu" & not_missing_proximity_vote_eu == 1

hist fraction_correct if issue=="lr" & not_missing_proximity_vote_lr == 1
hist fraction_correct if issue=="eu" & not_missing_proximity_vote_eu == 1

hist fraction_correctwdk if issue=="lr" & not_missing_proximity_vote_lr == 1 & novar == 0
hist fraction_correctwdk if issue=="eu" & not_missing_proximity_vote_eu == 1 & novar == 0

**b) bivariate correlations
corr differential_min fraction_correct education polInterest age gender class if issue=="lr" & not_missing_proximity_vote_lr == 1
corr differential_min fraction_correct education polInterest age gender class if issue=="eu" & not_missing_proximity_vote_eu == 1

**c) variation in the main variables by country
tabstat proximity_vote if issue=="lr" & not_missing_proximity_vote_lr == 1, by(country)
tabstat proximity_vote if issue=="eu" & not_missing_proximity_vote_eu == 1, by(country)

tabstat differential_min if issue=="lr" & not_missing_proximity_vote_lr == 1, by(country)
tabstat differential_min if issue=="eu" & not_missing_proximity_vote_eu == 1, by(country)

tabstat fraction_correct if issue=="lr" & not_missing_proximity_vote_lr == 1, by(country)
tabstat fraction_correct if issue=="eu" & not_missing_proximity_vote_eu == 1, by(country)

*7) N/A = Worked example of how party position knowledge is calculated 

*8) Issue by issue
**a) within voters + between issues (fixed effects) / party polarisation (weighted)
xtset resp_id

xtreg proximity_vote sdw_party_polarisation if issue!="lr" & not_missing_pv_issues==1, fe

xtreg proximity_vote sdw_party_polarisation differential_min if issue!="lr" & not_missing_pv_issues==1, fe

**b) between voters + within issues / party polarisation (weighted)
foreach issue in redist trade samesex imm eu climate {
	logit proximity_vote sdw_party_polarisation differential_min education polInterest age gender class party_id_match party_count if issue=="`issue'" & not_missing_pv_issues==1, vce(cluster country)
	outreg2 using appendix_reg_part7.doc, alpha(0.001, 0.01, 0.05) append dec(3) label symbol(***, **, *)
}
