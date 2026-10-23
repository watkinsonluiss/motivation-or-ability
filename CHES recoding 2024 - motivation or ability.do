rename party_id party_A
rename party party_A_name

*remove countries not in the EES
drop if country == 11 | country == 34 | country == 35 | country == 36 | country == 45

*remove parties not in the EES + drop some regional parties (e.g. in Spain)
drop if inlist(party_A, 2002,2004,2023,2024,3106,3110,3121,2104,2117,2118,202,219,220,221,2212,1410,1414,601,613,631,308,314,421,2301,827,850,2402,2405,2511,2525,2527,2528,1005,1006,1016,1018,1050,1051,1052, 2606,1202,2717,2814,2822,2919,504,506,511,513,517,524,550,552,553)

*Flanders = 56, Wallonia = 57 - note Workers party (party_A = 119) in both regions 
replace country = 56 if party_A==103
replace country = 56 if party_A==105
replace country = 56 if party_A==107
replace country = 56 if party_A==109
replace country = 56 if party_A==110
replace country = 56 if party_A==112
replace country = 56 if party_A==119

replace country = 57 if party_A==102
replace country = 57 if party_A==104
replace country = 57 if party_A==106
replace country = 57 if party_A==108
replace country = 57 if party_A==111

expand 2 if party_A==119, gen(copy)
replace country = 57 if party_A==119 & copy==1

replace country = 100 if country==20
replace country = 191 if country==31
replace country = 196 if country==40
replace country = 203 if country==21
replace country = 208 if country==2
replace country = 233 if country==22
replace country = 246 if country==14
replace country = 250 if country==6
replace country = 276 if country==3
replace country = 300 if country==4
replace country = 348 if country==23
replace country = 372 if country==7
replace country = 380 if country==8
replace country = 428 if country==24
replace country = 440 if country==25
replace country = 442 if country==38
replace country = 470 if country==37
replace country = 528 if country==10
replace country = 616 if country==26
replace country = 620 if country==12
replace country = 642 if country==27
replace country = 703 if country==28
replace country = 705 if country==29
replace country = 724 if country==5
replace country = 752 if country==16
replace country = 40 if country==13

label define country 40 "Austria" 56 "Belgium - Flanders" 57 "Belgium - Wallonia" 100 "Bulgaria" 191 "Croatia" 196 "Cyprus" 203 "Czechia" 208 "Denmark" 233 "Estonia" 246 "Finland" 250 "France" 276 "Germany" 300 "Greece" 348 "Hungary" 372 "Ireland" 380 "Italy" 428 "Latvia" 440 "Lithuania" 442 "Luxembourg" 470 "Malta" 528 "The Netherlands" 616 "Poland" 620 "Portugal" 642 "Romania" 703 "Slovakia" 705 "Slovenia" 724 "Spain" 752 "Sweden", modify
label values country country

*recode / rename party positions
replace eu_position = ((7-eu_position)*10/6)

rename redistribution expert_posredist
rename protectionism expert_postrade
rename samesex_marriage expert_possamesex
rename immigrate_policy expert_posimm
rename eu_position expert_poseu
rename climate_change expert_posclimate
rename lrgen expert_poslr

*delete v minor / fringe parties
drop if epvote == .
drop if epvote < 2

*renaming Wallonia party 119 -> 120 to permit polarisation calc / import etc
replace party_A=120 if party_A==119 & country==57

*calculate party polarisation (unweighted)
*absolute average deviation (unweighted)
egen party_count = count(party_A_name), by(country)
order party_count, after(party_A_name)

foreach i in lr redist trade samesex imm eu climate {
	egen expert_pos_mean`i' = mean(expert_pos`i'), by(country)
	gen deviation`i' = abs(expert_pos`i'-expert_pos_mean`i')
	egen party_polarisation`i' = sum(deviation`i'), by(country)
	replace party_polarisation`i' = party_polarisation`i'/party_count
}

*standard deviation (unweighted)
foreach i in lr redist trade samesex imm eu climate {
	gen deviation_2`i' = (expert_pos`i'-expert_pos_mean`i')^2
	egen sd_party_polarisation`i' = sum(deviation_2`i'), by(country)
	replace sd_party_polarisation`i' = sqrt(sd_party_polarisation`i'/party_count)
}

*calculate party polarisation (weighted)
**for each country, epvote_total should sum to 1
egen epvote_total = sum(epvote), by(country)
gen w = epvote / epvote_total
drop epvote_total

**for each country, calculate the weighted mean value 
foreach i in lr redist trade samesex imm eu climate {
	gen expert_pos_w`i' = w*expert_pos`i'
	egen expert_pos_mean_w`i' = sum(w*expert_pos`i'), by(country)
}

*absolute average deviation (weighted)
foreach i in lr redist trade samesex imm eu climate {
	gen deviation_w`i' = w*abs(expert_pos`i'-expert_pos_mean_w`i')
	egen w_party_polarisation`i' = sum(deviation_w`i'), by(country)
}

*standard deviation (weighted)
foreach i in lr redist trade samesex imm eu climate {
	gen deviation_2w`i' = w*(expert_pos`i'-expert_pos_mean_w`i')^2
	egen sdw_party_polarisation`i' = sum(deviation_2w`i'), by(country)
	replace sdw_party_polarisation`i' = sqrt(sdw_party_polarisation`i')
}

keep country party_A party_A_name family epvote expert_poslr expert_posredist expert_postrade expert_posimm expert_possamesex expert_poseu expert_posclimate party_polarisationlr party_polarisationredist party_polarisationtrade party_polarisationimm party_polarisationsamesex party_polarisationeu party_polarisationclimate sd_party_polarisationlr sd_party_polarisationredist sd_party_polarisationtrade sd_party_polarisationimm sd_party_polarisationsamesex sd_party_polarisationeu sd_party_polarisationclimate w_party_polarisationlr w_party_polarisationredist w_party_polarisationtrade w_party_polarisationimm w_party_polarisationsamesex w_party_polarisationeu w_party_polarisationclimate sdw_party_polarisationlr sdw_party_polarisationredist sdw_party_polarisationtrade sdw_party_polarisationimm sdw_party_polarisationsamesex sdw_party_polarisationeu sdw_party_polarisationclimate

order country party_A party_A_name family epvote expert_poslr expert_posredist expert_postrade expert_posimm expert_possamesex expert_poseu expert_posclimate party_polarisationlr party_polarisationredist party_polarisationtrade party_polarisationimm party_polarisationsamesex party_polarisationeu party_polarisationclimate sd_party_polarisationlr sd_party_polarisationredist sd_party_polarisationtrade sd_party_polarisationimm sd_party_polarisationsamesex sd_party_polarisationeu sd_party_polarisationclimate w_party_polarisationlr w_party_polarisationredist w_party_polarisationtrade w_party_polarisationimm w_party_polarisationsamesex w_party_polarisationeu w_party_polarisationclimate sdw_party_polarisationlr sdw_party_polarisationredist sdw_party_polarisationtrade sdw_party_polarisationimm sdw_party_polarisationsamesex sdw_party_polarisationeu sdw_party_polarisationclimate
