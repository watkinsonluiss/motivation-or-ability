cd "C:\Users\willa\OneDrive - Luiss\data_new\polarisation"

rename Weight2 weight_country

drop country
rename countrycode country

replace country=57 if meta_BE_college==1

label define country 40 "Austria" 56 "Belgium - Flanders" 57 "Belgium - Wallonia" 100 "Bulgaria" 191 "Croatia" 196 "Cyprus" 203 "Czechia" 208 "Denmark" 233 "Estonia" 246 "Finland" 250 "France" 276 "Germany" 300 "Greece" 348 "Hungary" 372 "Ireland" 380 "Italy" 428 "Latvia" 440 "Lithuania" 442 "Luxembourg" 470 "Malta" 528 "The Netherlands" 616 "Poland" 620 "Portugal" 642 "Romania" 703 "Slovakia" 705 "Slovenia" 724 "Spain" 752 "Sweden", modify
label values country country

*sociodemographic
recode Edu_rec (98=.), gen(education)
recode d3 (1=0 "Male") (2=1 "Female") (3=.), gen(gender)
rename d4_age age
recode d7 (6=.), gen(class)
recode d10 (1=8) (2=7) (3=6) (4=5) (5=4) (6=3) (7=2) (8=1), gen(religiosity)

*interest 
recode q15 (1=4) (2=3) (3=2) (4=1) (98=.), gen(polInterest)

*left-right (i.e. issue 99)
recode q10 (11/max=.), gen(poslr)

*issues
recode q12_2 (11/max=.), gen(posredist)
recode q12_1 (11/max=.), gen(postrade)
recode q12_3 (11/max=.), gen(possamesex)
recode q12_4 (11/max=.) (0=10) (1=9) (2=8) (3=7) (4=6) (5=5) (6=4) (7=3) (8=2) (9=1) (10=0), gen(posimm)
recode q17 (11/max=.) (0=10) (1=9) (2=8) (3=7) (4=6) (5=5) (6=4) (7=3) (8=2) (9=1) (10=0), gen(poseu)
recode q12_5 (11/max=.), gen(posclimate)

*issues - perceptions of each party's position 
forvalues i=1(1)8 {
	recode q11_`i' (11/max=.), gen(perclr`i')
}

forvalues i=1(1)8 {
	recode q18_`i' (0=10) (1=9) (2=8) (3=7) (4=6) (5=5) (6=4) (7=3) (8=2) (9=1) (10=0) (11/max=.), gen(perceu`i')
}

*issue extremity 
foreach i in lr redist trade samesex imm eu climate {
	gen ext_pos`i' = abs(5-pos`i')
}

*ptv
forvalues i=1(1)8 {
	recode q9_`i' (11/max=.), gen(ptv`i')
}

reshape long perclr perceu ptv, i(resp_id) j(party_A)

*voting (part 2)
gen vote_EU = 1 if q6n == party_A
replace vote_EU = 0 if vote_EU != 1

*account for party mergers 
replace vote_EU = 1 if q6n == 99 & party_A == 2 & country == 100 
replace vote_EU = 1 if q6n == 99 & party_A == 2 & country == 203
replace vote_EU = 1 if q6n == 99 & party_A == 1 & country == 642

*party identification
gen party_id_match = 1 if q19n == party_A
replace party_id_match = 0 if party_id_match != 1

replace party_id_match = 1 if q19n == 3 & party_A == 2 & country == 100 
replace party_id_match = 1 if q19n == 6 & party_A == 2 & country == 203 
replace party_id_match = 1 if q19n == 2 & party_A == 1 & country == 642 

*party_A -> CHES code
replace party_A = 1302 if party_A == 1 & country == 40
replace party_A = 1301 if party_A == 2 & country == 40
replace party_A = 1306 if party_A == 3 & country == 40
replace party_A = 1304 if party_A == 4 & country == 40
replace party_A = 1303 if party_A == 5 & country == 40

replace party_A = 112 if party_A == 1 & country == 56
replace party_A = 110 if party_A == 2 & country == 56
replace party_A = 103 if party_A == 3 & country == 56
replace party_A = 105 if party_A == 4 & country == 56
replace party_A = 109 if party_A == 5 & country == 56
replace party_A = 119 if party_A == 6 & country == 56
replace party_A = 107 if party_A == 7 & country == 56

replace party_A = 102 if party_A == 1 & country == 57
replace party_A = 108 if party_A == 2 & country == 57
replace party_A = 120 if party_A == 3 & country == 57
replace party_A = 104 if party_A == 4 & country == 57
replace party_A = 111 if party_A == 5 & country == 57
replace party_A = 106 if party_A == 6 & country == 57

replace party_A = 2010 if party_A == 1 & country == 100
replace party_A = 2021 if party_A == 2 & country == 100
replace party_A = 2022 if party_A == 4 & country == 100
replace party_A = 2003 if party_A == 5 & country == 100
replace party_A = 2019 if party_A == 6 & country == 100
replace party_A = 2020 if party_A == 7 & country == 100

replace party_A = 3122 if party_A == 1 & country == 191
replace party_A = 3101 if party_A == 2 & country == 191
replace party_A = 3115 if party_A == 3 & country == 191
replace party_A = 3120 if party_A == 4 & country == 191
replace party_A = 3102 if party_A == 5 & country == 191

replace party_A = 4001 if party_A == 1 & country == 196
replace party_A = 4003 if party_A == 2 & country == 196
replace party_A = 4004 if party_A == 3 & country == 196
replace party_A = 4009 if party_A == 4 & country == 196
replace party_A = 4006 if party_A == 5 & country == 196
replace party_A = 4005 if party_A == 6 & country == 196
replace party_A = 4015 if party_A == 7 & country == 196

replace party_A = 2111 if party_A == 1 & country == 203
replace party_A = 2102 if party_A == 2 & country == 203
replace party_A = 2114 if party_A == 3 & country == 203
replace party_A = 2115 if party_A == 4 & country == 203
replace party_A = 2116 if party_A == 5 & country == 203
replace party_A = 2101 if party_A == 7 & country == 203
replace party_A = 2103 if party_A == 8 & country == 203

replace party_A = 201 if party_A == 1 & country == 208
replace party_A = 203 if party_A == 2 & country == 208
replace party_A = 206 if party_A == 3 & country == 208
replace party_A = 218 if party_A == 4 & country == 208
replace party_A = 215 if party_A == 5 & country == 208
replace party_A = 211 if party_A == 6 & country == 208
replace party_A = 222 if party_A == 7 & country == 208
replace party_A = 213 if party_A == 8 & country == 208

replace party_A = 2201 if party_A == 1 & country == 233
replace party_A = 2203 if party_A == 2 & country == 233
replace party_A = 2209 if party_A == 3 & country == 233
replace party_A = 2204 if party_A == 4 & country == 233
replace party_A = 2202 if party_A == 5 & country == 233
replace party_A = 2210 if party_A == 6 & country == 233
replace party_A = 2211 if party_A == 7 & country == 233

replace party_A = 1401 if party_A == 1 & country == 246
replace party_A = 1402 if party_A == 2 & country == 246
replace party_A = 1405 if party_A == 3 & country == 246
replace party_A = 1403 if party_A == 4 & country == 246
replace party_A = 1404 if party_A == 5 & country == 246
replace party_A = 1408 if party_A == 6 & country == 246
replace party_A = 1406 if party_A == 7 & country == 246
replace party_A = 1409 if party_A == 8 & country == 246

replace party_A = 610 if party_A == 1 & country == 250
replace party_A = 626 if party_A == 2 & country == 250
replace party_A = 627 if party_A == 3 & country == 250
replace party_A = 609 if party_A == 4 & country == 250
replace party_A = 605 if party_A == 5 & country == 250
replace party_A = 602 if party_A == 6 & country == 250
replace party_A = 630 if party_A == 7 & country == 250

replace party_A = 301 if party_A == 1 & country == 276
replace party_A = 302 if party_A == 2 & country == 276
replace party_A = 303 if party_A == 3 & country == 276
replace party_A = 304 if party_A == 4 & country == 276
replace party_A = 306 if party_A == 5 & country == 276
replace party_A = 310 if party_A == 6 & country == 276
replace party_A = 313 if party_A == 7 & country == 276

replace party_A = 402 if party_A == 1 & country == 300
replace party_A = 403 if party_A == 2 & country == 300
replace party_A = 401 if party_A == 3 & country == 300
replace party_A = 416 if party_A == 4 & country == 300
replace party_A = 404 if party_A == 5 & country == 300
replace party_A = 419 if party_A == 7 & country == 300
replace party_A = 420 if party_A == 8 & country == 300

replace party_A = 2302 if party_A == 1 & country == 348
replace party_A = 2318 if party_A == 2 & country == 348
replace party_A = 2311 if party_A == 3 & country == 348
replace party_A = 2314 if party_A == 4 & country == 348
replace party_A = 2316 if party_A == 5 & country == 348
replace party_A = 2308 if party_A == 6 & country == 348
replace party_A = 2315 if party_A == 7 & country == 348
replace party_A = 2309 if party_A == 8 & country == 348

replace party_A = 707 if party_A == 1 & country == 372
replace party_A = 702 if party_A == 2 & country == 372
replace party_A = 701 if party_A == 3 & country == 372
replace party_A = 710 if party_A == 4 & country == 372
replace party_A = 705 if party_A == 5 & country == 372
replace party_A = 713 if party_A == 6 & country == 372
replace party_A = 703 if party_A == 7 & country == 372
replace party_A = 709 if party_A == 8 & country == 372

replace party_A = 844 if party_A == 1 & country == 380
replace party_A = 837 if party_A == 2 & country == 380
replace party_A = 845 if party_A == 3 & country == 380
replace party_A = 815 if party_A == 4 & country == 380
replace party_A = 811 if party_A == 5 & country == 380
replace party_A = 838 if party_A == 6 & country == 380
replace party_A = 849 if party_A == 7 & country == 380
replace party_A = 832 if party_A == 8 & country == 380

replace party_A = 2412 if party_A == 1 & country == 428
replace party_A = 2406 if party_A == 2 & country == 428
replace party_A = 2420 if party_A == 3 & country == 428
replace party_A = 2410 if party_A == 4 & country == 428
replace party_A = 2419 if party_A == 5 & country == 428
replace party_A = 2418 if party_A == 6 & country == 428
replace party_A = 2414 if party_A == 7 & country == 428
replace party_A = 2417 if party_A == 8 & country == 428

replace party_A = 2501 if party_A == 1 & country == 440
replace party_A = 2506 if party_A == 2 & country == 440
replace party_A = 2507 if party_A == 3 & country == 440
replace party_A = 2518 if party_A == 5 & country == 440
replace party_A = 2526 if party_A == 6 & country == 440
replace party_A = 2524 if party_A == 7 & country == 440

replace party_A = 3701 if party_A == 4 & country == 470
replace party_A = 3702 if party_A == 5 & country == 470

replace party_A = 1003 if party_A == 1 & country == 528
replace party_A = 1004 if party_A == 2 & country == 528
replace party_A = 1002 if party_A == 3 & country == 528
replace party_A = 1017 if party_A == 4 & country == 528
replace party_A = 1054 if party_A == 5 & country == 528
replace party_A = 1056 if party_A == 6 & country == 528
replace party_A = 1014 if party_A == 7 & country == 528
replace party_A = 1001 if party_A == 8 & country == 528

replace party_A = 2603 if party_A == 1 & country == 616
replace party_A = 2601 if party_A == 2 & country == 616
replace party_A = 2623 if party_A == 3 & country == 616
replace party_A = 2605 if party_A == 4 & country == 616
replace party_A = 2619 if party_A == 5 & country == 616

replace party_A = 1201 if party_A == 1 & country == 620
replace party_A = 1206 if party_A == 2 & country == 620
replace party_A = 1208 if party_A == 3 & country == 620
replace party_A = 1252 if party_A == 4 & country == 620
replace party_A = 1205 if party_A == 5 & country == 620
replace party_A = 1253 if party_A == 6 & country == 620
replace party_A = 1251 if party_A == 7 & country == 620
replace party_A = 1250 if party_A == 8 & country == 620

replace party_A = 2701 if party_A == 1 & country == 642
replace party_A = 2715 if party_A == 3 & country == 642
replace party_A = 2713 if party_A == 4 & country == 642
replace party_A = 2706 if party_A == 5 & country == 642
replace party_A = 2716 if party_A == 6 & country == 642

replace party_A = 2819 if party_A == 1 & country == 703
replace party_A = 2812 if party_A == 3 & country == 703
replace party_A = 2809 if party_A == 4 & country == 703
replace party_A = 2803 if party_A == 5 & country == 703
replace party_A = 2823 if party_A == 6 & country == 703
replace party_A = 2805 if party_A == 7 & country == 703
replace party_A = 2824 if party_A == 8 & country == 703

replace party_A = 2902 if party_A == 1 & country == 705
replace party_A = 2916 if party_A == 2 & country == 705
replace party_A = 2912 if party_A == 3 & country == 705
replace party_A = 2905 if party_A == 4 & country == 705
replace party_A = 2903 if party_A == 5 & country == 705
replace party_A = 2918 if party_A == 6 & country == 705
replace party_A = 2917 if party_A == 8 & country == 705

replace party_A = 501 if party_A == 1 & country == 724
replace party_A = 502 if party_A == 2 & country == 724
replace party_A = 527 if party_A == 3 & country == 724
replace party_A = 551 if party_A == 4 & country == 724
replace party_A = 525 if party_A == 8 & country == 724

replace party_A = 1605 if party_A == 1 & country == 752
replace party_A = 1603 if party_A == 2 & country == 752
replace party_A = 1602 if party_A == 3 & country == 752
replace party_A = 1601 if party_A == 4 & country == 752
replace party_A = 1607 if party_A == 5 & country == 752
replace party_A = 1610 if party_A == 6 & country == 752
replace party_A = 1604 if party_A == 7 & country == 752
replace party_A = 1606 if party_A == 8 & country == 752

order country resp_id party_A ptv vote_EU party_id_match age education gender class religiosity polInterest poslr posredist postrade possamesex posimm poseu posclimate ext_poslr ext_posredist ext_postrade ext_possamesex ext_posimm ext_poseu ext_posclimate

order country resp_id party_A ptv vote_EU party_id_match age education gender class religiosity polInterest poslr posredist postrade possamesex posimm poseu posclimate ext_poslr ext_posredist ext_postrade ext_possamesex ext_posimm ext_poseu ext_posclimate

sort resp_id party_A

*drop parties not in the CHES / otherwise unused 
drop if party_A < 9

*turnout - vote
egen turnout_EU = total(vote_EU), by(resp_id)

*turnout / not missing - ptv
egen turnout_ptv = total(missing(ptv)), by(resp_id)
recode turnout_ptv (0=1) (else=0)

*party identifier 
egen party_identifier = total(party_id), by(resp_id)

*party position knowledge (fraction correct measure, e.g. Fortunato et al, 2016)
merge m:1 resp_id using EES_ppk
drop _merge

*append w/ CHES data + drop unmatched observations
merge m:1 party_A using CHES
drop if _merge != 3
drop _merge

egen resp_id_party_A = concat(resp_id party_A), punct("_")

reshape long pos ext_pos perc expert_pos party_polarisation sd_party_polarisation w_party_polarisation sdw_party_polarisation fraction_correct NOth_fraction_correct fraction_correctwdk novar, i(resp_id_party_A) j(issue) string

egen resp_id_issue = concat(resp_id issue), punct("_")
egen country_issue_party = concat(country issue party_A), punct("_")

*distance
gen distance = abs(pos-expert_pos)
egen distance_min = min(distance), by(resp_id_issue)

*proximity vote (from Singh, 2010)
gen closest_party = 1 if distance == distance_min & distance != .
replace closest_party = 0 if closest_party != 1 & distance != .

gen proximity_vote = closest_party if vote_EU == 1 & distance != .

egen closest_party_n = sum(closest_party), by(resp_id_issue)

*differential
**party count (divided by the 7 issues)
egen party_count = count(party_A_name), by(resp_id)
replace party_count = party_count/7
order party_count, after(party_A_name)

*differential min - "spread relative to the closest party / best option vs. all others"
gen subtraction = abs(distance-distance_min)
egen differential_min = total(subtraction) if distance!=., by(resp_id_issue)
replace differential_min = differential_min/party_count
drop subtraction

summ differential_min
replace differential_min = (differential_min - r(min)) / (r(max) - r(min))

*perceived distance
gen p_distance = abs(pos-perc)
egen p_distance_min = min(p_distance), by(resp_id_issue) 

*perceived differential
**perceived differential min - "spread relative to the closest party / best option vs. all others"
gen subtraction = abs(p_distance-p_distance_min)
egen p_differential_min = total(subtraction) if p_distance!=., by(resp_id_issue)
replace p_differential_min = p_differential_min/party_count
drop subtraction

summ p_differential_min
replace p_differential_min = (p_differential_min - r(min)) / (r(max) - r(min))