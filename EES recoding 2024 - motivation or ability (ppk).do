*Note - for this article: need to consider how to treat the three merged parties in both 1) the measurement of party polarisation + 2) the measurement of party position knowledge.  
cd "C:\Users\willa\OneDrive - Luiss\data_new\polarisation"

rename Weight2 weight_country

drop country
rename countrycode country

replace country=57 if meta_BE_college==1

label define country 40 "Austria" 56 "Belgium - Flanders" 57 "Belgium - Wallonia" 100 "Bulgaria" 191 "Croatia" 196 "Cyprus" 203 "Czechia" 208 "Denmark" 233 "Estonia" 246 "Finland" 250 "France" 276 "Germany" 300 "Greece" 348 "Hungary" 372 "Ireland" 380 "Italy" 428 "Latvia" 440 "Lithuania" 442 "Luxembourg" 470 "Malta" 528 "The Netherlands" 616 "Poland" 620 "Portugal" 642 "Romania" 703 "Slovakia" 705 "Slovenia" 724 "Spain" 752 "Sweden", modify
label values country country

*left-right
recode q10 (11/max=.), gen(poslr)

*issues
recode q17 (11/max=.) (0=10) (1=9) (2=8) (3=7) (4=6) (5=5) (6=4) (7=3) (8=2) (9=1) (10=0), gen(poseu)

*issues - perceptions of each party's position 
forvalues i=1(1)8 {
	recode q11_`i' (11/max=.), gen(perclr`i')
}

forvalues i=1(1)8 {
	recode q18_`i' (0=10) (1=9) (2=8) (3=7) (4=6) (5=5) (6=4) (7=3) (8=2) (9=1) (10=0) (11/max=.), gen(perceu`i')
}

reshape long perclr perceu, i(resp_id) j(party_A)

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
replace party_A = 120 if party_A == 6 & country == 56
replace party_A = 107 if party_A == 7 & country == 56

replace party_A = 102 if party_A == 1 & country == 57
replace party_A = 108 if party_A == 2 & country == 57
replace party_A = 119 if party_A == 3 & country == 57
replace party_A = 104 if party_A == 4 & country == 57
replace party_A = 111 if party_A == 5 & country == 57
replace party_A = 106 if party_A == 6 & country == 57

replace party_A = 2010 if party_A == 1 & country == 100
replace party_A = 2021 if party_A == 2 & country == 100
replace party_A = 2018 if party_A == 3 & country == 100
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
replace party_A = 2109 if party_A == 6 & country == 203
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
replace party_A = 422 if party_A == 6 & country == 300
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
replace party_A = 2705 if party_A == 2 & country == 642
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

*next step - append w/ CHES data
merge m:1 party_A using CHES
drop if _merge == 1
drop _merge

order country resp_id party_A party_A_name family epvote poslr poseu expert_poslr expert_poseu perclr perceu
keep country resp_id party_A party_A_name family epvote poslr poseu expert_poslr expert_poseu perclr perceu

*GENERATE PARTY-DYAD STRUCTURE
tostring country, gen(country_string)
order country_string, after(country)

* Step 0: obtain "EES_partyB.dta"
preserve 

keep resp_id party_A party_A_name expert_poslr expert_poseu perclr perceu
rename party_A party_B
rename party_A_name party_B_name
rename expert_poslr expert_poslrB
rename expert_poseu expert_poseuB
rename perclr perclrB
rename perceu perceuB

gen str resp_idB = string(resp_id) + "_" + string(party_B)
order resp_idB, after(resp_id)

save "C:\Users\willa\OneDrive - Luiss\data_new\polarisation\EES_partyB.dta"
restore

* Step 1: Keep only the list of all parties per country
preserve

keep country_string party_A
rename party_A party_B

duplicates drop
tempfile allparties
save `allparties'

restore

* Step 2: Prepare the main data
sort country resp_id party_A party_A_name

* Step 3: Loop country-by-country to generate combinations efficiently
levelsof country, local(countries)
tempfile results
save `results', emptyok

foreach c of local countries {
    preserve
    keep if country == `c'
    
    tempfile base
    save `base'
	
    joinby country_string using `allparties'

    append using `results'
    save `results', replace

    restore
}

* Step 4: Load final dataset
use `results', clear

order party_B, after(party_A)

drop if party_A == party_B
drop if party_A == . | party_B == .

* Step 5 - drop duplicates 
gen dyad_min = min(party_A, party_B)
gen dyad_max = max(party_A, party_B)

sort resp_id dyad_min dyad_max
bysort resp_id dyad_min dyad_max: keep if _n == 1

* Step 6 - import party_B variables (e.g. expert / voter perceptions, ptvs etc)
gen str resp_idB = string(resp_id) + "_" + string(party_B)

merge m:1 resp_idB using EES_partyB.dta

drop if party_A == .
drop _merge

sort resp_id party_A party_B
by resp_id: gen unique_voter = (_n == 1)

*CALCULATE PPK (BASED ON DYADIC STRUCTURE)
*accuracy - party-dyad calculation (e.g. Fortunato et al, 2016)
**distance vs perceived distance 
foreach issue in lr eu {
	gen distance_`issue' = abs(pos`issue'-expert_pos`issue')
	gen distance_`issue'B = abs(pos`issue'-expert_pos`issue'B)
	gen p_distance_`issue' = abs(pos`issue'-perc`issue')
	gen p_distance_`issue'B = abs(pos`issue'-perc`issue'B)
}

**handle missing / outlying values 
foreach issue in lr eu {
	gen `issue'_dk = 1 if perc`issue' == . | perc`issue'B == .
	replace `issue'_dk = 0 if perc`issue' != . & perc`issue'B != .
	gen `issue'_expert_diff = abs(expert_pos`issue'-expert_pos`issue'B)
}

foreach issue in lr eu {
	egen `issue'_sdA = sd(perc`issue'), by(resp_id)
	egen `issue'_sdB = sd(perc`issue'B), by(resp_id)
	gen `issue'_sd = `issue'_sdA + `issue'_sdB
	gen novar`issue' = 1 if `issue'_sd == 0
	replace novar`issue' = 0 if `issue'_sd != 0 & `issue'_sd != .
}

**calculate correct / incorrect party orders 
***knowledge (real vs perceived party position) 
foreach issue in lr eu {	
	gen expert_order_`issue' = 1 if expert_pos`issue' > expert_pos`issue'B
	replace expert_order_`issue' = 0 if expert_order_`issue' != 1
	gen voter_order_`issue' = 1 if perc`issue' > perc`issue'B & `issue'_dk != 1
	replace voter_order_`issue' = 0 if voter_order_`issue' != 1 & `issue'_dk != 1
	gen correct_order_`issue' = 1 if voter_order_`issue'==expert_order_`issue'
	replace correct_order_`issue' = 0 if voter_order_`issue'!=expert_order_`issue'
	replace correct_order_`issue' = 0 if perc`issue'==perc`issue'B
	replace correct_order_`issue' = . if `issue'_expert_diff < 0.5
	egen dyad_count_`issue' = count(correct_order_`issue'), by(resp_id)
}

***knowledge (where 'don't know' values have been excluded)
foreach issue in lr eu {	
	gen correct_order_`issue'wdk = 1 if voter_order_`issue'==expert_order_`issue' & `issue'_dk != 1
	replace correct_order_`issue'wdk = 0 if voter_order_`issue'!=expert_order_`issue' & `issue'_dk != 1
	replace correct_order_`issue'wdk = 0 if perc`issue'==perc`issue'B & `issue'_dk != 1
	replace correct_order_`issue'wdk = . if `issue'_expert_diff < 0.5
	egen dyad_count_`issue'wdk = count(correct_order_`issue'wdk), by(resp_id)
}

**calculate fraction correct 
foreach issue in lr eu {	
	egen fraction_correct`issue' = sum(correct_order_`issue'), by(resp_id)
	replace fraction_correct`issue' = fraction_correct`issue'/dyad_count_`issue'
}

foreach issue in lr eu {	
	egen fraction_correctwdk`issue' = sum(correct_order_`issue'wdk), by(resp_id)
	replace fraction_correctwdk`issue' = fraction_correctwdk`issue'/dyad_count_`issue'wdk
}

**calculate correct / incorrect party orders - NO threshold 
***knowledge (real vs perceived party position) 
foreach issue in lr eu {	
	gen NOth_correct_order`issue' = 1 if voter_order_`issue'==expert_order_`issue'
	replace NOth_correct_order`issue' = 0 if voter_order_`issue'!=expert_order_`issue'
	replace NOth_correct_order`issue' = 0 if perc`issue'==perc`issue'B
	egen NOth_dyad_count_`issue' = count(NOth_correct_order`issue'), by(resp_id)
}

**calculate fraction correct - NO threshold 
foreach issue in lr eu {	
	egen NOth_fraction_correct`issue' = sum(NOth_correct_order`issue'), by(resp_id)
	replace NOth_fraction_correct`issue' = NOth_fraction_correct`issue'/NOth_dyad_count_`issue'
}

*CHECK - ORDER VARIABLES
order resp_id party_A party_B party_A_name party_B_name poslr perclr perclrB lr_dk lr_sd novarlr voter_order_lr expert_poslr expert_poslrB expert_order_lr correct_order_lr fraction_correctlr poseu perceu perceuB eu_dk eu_sd novareu voter_order_eu expert_poseu expert_poseuB expert_order_eu correct_order_eu fraction_correcteu NOth_fraction_correctlr NOth_fraction_correcteu fraction_correctwdklr fraction_correctwdkeu

*JUST KEEP ID + PPK TO EXPORT
drop if unique_voter == 0
keep resp_id fraction_correctlr fraction_correcteu NOth_fraction_correctlr NOth_fraction_correcteu fraction_correctwdklr fraction_correctwdkeu novarlr novareu