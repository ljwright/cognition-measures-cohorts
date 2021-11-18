/*
1970 Cohort (BCS70)
*/
capture rm "${clean}/1970c_temp.dta"

capture program drop get_correct
program define get_correct
	args new_var correct vlist
	tempvar observed
	qui{
		capture drop `new_var'
	   	gen `new_var' = 0
		gen `observed' = 0
		foreach var of varlist `vlist'{
			replace `new_var' = `new_var' + 1 if `var' == `correct'
			replace `observed' = `observed' + 1 if !missing(`var') & `var' >= 0
		}
		replace `new_var' = . if `observed' == 0
		drop `observed' 
	}
	sum `new_var', d
end

capture program drop save_bcs
program define save_bcs
	args age
	keep bcsid *_`age'
	capture merge 1:1 bcsid using "${clean}/1970c_temp.dta", nogen
	save "${clean}/1970c_temp.dta", replace
end



// Individual Cognition Tests
* Age 5
use "D:/BCS70/5y/f699c.dta", clear

gen age_05 = f112/365.25 if f112 >= 0

// gen literacy_05 = ...f099... // 4.3.1 Parental Reading Ability; Verbal (Reading); Raw Variable Not Cleaned Correctly
gen reading_05 = f100 if f100 >= 0 // 4.3.1 Schonell Reading Test; Verbal (Reading)
gen vocabulary_05 = 56 - f087 if f086 == 91 // 4.3.2 English Picture Vocabulary Test; Verbal (Vocabulary)
replace vocabulary_05 = 0 if f085 == 0 & missing(vocabulary_05) // NOT STRICTLY CORRECT - COULD BE 0-4 IN PRACTICE
replace vocabulary_05 = f117 if inrange(f117, 5, 56) & missing(vocabulary_05)
gen visuospatial_05 = f119 if f119 >= 0 // 4.3.3 Copying Designs Test; Visuospatial
gen drawing_harris_v1_05 = f113 if f113 >= 0 // 4.3.4 Human Figure Drawing; General Ability (Perceptual); 1st figure, Harris Scoring
gen drawing_harris_v2_05 = f114 if f114 >= 0 // 4.3.4 Human Figure Drawing; General Ability (Perceptual); 2nd figure, Harris Scoring
gen drawing_koppitz_v1_05 = f115 if f115 >= 0 // 4.3.4 Human Figure Drawing; General Ability (Perceptual); 1st figure, Koppitz Scoring
gen drawing_koppitz_v2_05 = f116 if f116 >= 0 // 4.3.4 Human Figure Drawing; General Ability (Perceptual); 2nd figure, Koppitz Scoring
gen spatial_05 = f118 if f118 >= 0 // 4.3.5 Complete a Profile Test; Spatial Development

save_bcs 05

* Age 10
use "D:/BCS70/10y/bcs3derived.dta", clear
rename BCSID bcsid
by bcsid, sort: gen rows = _N
drop if missing(BD3CNTRY) & rows == 2
merge 1:1 bcsid using "D:/BCS70/10y/sn3723.dta", nogen

drop *_10

gen reading_10 = BD3RREAD if BD3RREAD >= 0 // 4.4.1 Edinburgh Reading Test; Verbal (Word Recognition)
gen maths_10 = BD3MATHS if BD3MATHS >= 0 // 4.4.2 Friendly Maths Test; Mathematics

recode i98-i110 (1 = 0) // 4.4.3 Pictorial Language Comprehension Test; Verbal
get_correct comprehension_total_10 0 "i8-i110"
get_correct comprehension_vocab_10 0 "i8-i81"
get_correct comprehension_sentence_10 0 "i82-i97"
get_correct comprehension_sequence_10 0 "i98-i110"

get_correct spelling_10 1 "i3815-i3864" // 4.4.4 Spelling Dictation Task; Verbal (Spelling)
get_correct bas_sim_10 1 "i4201-i4221"  // 4.4.5 BAS Similarities (Word); Verbal (Reasoning); DIFFERENT RESULT TO GUIDE
get_correct bas_words_10 1 "i3504-i3540" // 4.4.6 BAS Word Definitions; Verbal Knowledge (Acquired and Expressive)
get_correct bas_digits_10 1 "i3541-i3574" // 4.4.7 BAS Recall of Digits; Short-term auditory memory
get_correct bas_matrices_10 1 "i3617-i3644" // 4.4.8 BAS Matrices; Inductive, non-verbal reasoning

save_bcs 10

* Age 16
use BCSID SCR_? SCRTOTAL using "D:/BCS70/16y/bcs1986_reading_matrices.dta", clear
merge 1:1 BCSID using "D:/BCS70/16y/bcs4derived.dta", ///
	nogen keepusing(BD4RREAD) 
rename BCSID bcsid
merge 1:1 bcsid using "D:/BCS70/16y/bcs7016x.dta", ///
	nogen keepusing(bversion cvo* c7**)
merge 1:1 bcsid using "D:/BCS70/16y/bcs70_16-year_arithmetic_data.dta", ///
	nogen keepusing(mathscore)

gen home_test_16 = bversion if bversion >= 0

gen ert_skim_16 = SCR_A if SCR_A >= 0 // 4.5.1 Edinburgh Reading Test; Verbal (Reading); Skimming
gen ert_vocab_16 = SCR_B if SCR_B >= 0 // 4.5.1 Edinburgh Reading Test; Verbal (Reading); Vocabulary
gen ert_facts_16 = SCR_C if SCR_C >= 0 // 4.5.1 Edinburgh Reading Test; Verbal (Reading); Reading for Facts
gen ert_pov_16 = SCR_D if SCR_D >= 0 // 4.5.1 Edinburgh Reading Test; Verbal (Reading); Points of View
gen ert_comp_16 = SCR_E if SCR_E >= 0 // 4.5.1 Edinburgh Reading Test; Verbal (Reading); Comprehension
gen ert_total_16 = SCRTOTAL if SCRTOTAL >= 0 // 4.5.1 Edinburgh Reading Test; Total Score
gen apu_arithmetic_16 = mathscore if mathscore >= 0 // 4.5.2 APU Arithmetic Test; Arithmetic Achievement

capture program drop make_correct
program define make_correct
	args vlist	
	tempvar decoded
	qui{
		foreach var of varlist `vlist'{
			decode `var', gen(`decoded')
			gen `var'_correct = strpos(`decoded', "correct") == 1 if `var' >= 0
			drop `decoded'
		}
	}
end

make_correct "cvo*"
get_correct apu_vocab_a_16 1 "cvo*_correct" // 4.5.3 APU Vocabulary Test; Verbal Vocabulary; Derived Score (Different to Supplied)
gen apu_vocab_b_16 = BD4RREAD if BD4RREAD >= 0 // 4.5.3 APU Vocabulary Test; Verbal Vocabulary; Supplied Derived Score 


get_correct spelling_a_16 1 "c7a1-c7a100" // 4.5.4 Spelling Test; Verbal (Spelling); Test A
get_correct spelling_b_16 1 "c7b1-c7b100" // 4.5.4 Spelling Test; Verbal (Spelling); Test B
get_correct spelling_total_b_16 1 "c7a1-c7a100 c7b1-c7b100" // 4.5.4 Spelling Test; Verbal (Spelling); Total
gen spelling_total_a_16 = spelling_a_16 + spelling_b_16 // 4.5.4 Spelling Test; Verbal (Spelling); Need answers on both tests
gen bas_matrices_16 = SCR_M if SCR_M >= 0 // 4.5.5 BAS Matrices; Inductive Non-Verbal Reasoning

save_bcs 16

* Age 34
use "D:\BCS70\34y\bcs_2004_adult_assessment_basic_skills.dta", clear

get_correct literacy_basic_a_34 1 "litor0??" // 4.8.1 Basic Skills; Basic Literacy; Any Answer
gen literacy_basic_b_34 = litort if litort >= 0 // 4.8.1 Basic Skills; Basic Literacy; All Answers
get_correct numeracy_basic_a_34 1 "numor0??" // 4.8.1 Basic Skills; Basic Numeracy; Any Answer
gen numeracy_basic_b_34 = numort if numort >= 0 // 4.8.1 Basic Skills; Basic Numeracy; All Answers
gen literacy_functional_34 = litmc30 if litmc30 >= 0 // 4.8.2 Literacy and numeracy skills; Literacy
gen numeracy_functional_34 = nummct if nummct >= 0 // 4.8.2 Literacy and numeracy skills; Numeracy

save_bcs 34

* Age 42
use "D:\BCS70\42y\bcs70_2012_flatfile.dta", clear
rename BCSID bcsid

gen apu_vocab_42 = B9VSCORE if B9VSCORE >= 0 // 4.9.1 APU Vocabulary Test; Verbal Vocabulary; Supplied Derived Score 

save_bcs 42

* Age 46
use "D:\BCS70\46y\bcs_age46_main.dta", clear
rename BCSID bcsid

gen fluency_46 = B10CFANI if B10CFANI >= 0 // 4.10.1 Verbal Fluency (Animal Naming) Test; Verbal Fluency
gen memory_short_46 = B10CFLISN if B10CFLISN >= 0 // 4.10.2 Verbal Learning / Word List Recall Test (Immediate); Verbal (Memory)
gen memory_delayed_46 = B10CFLISD if B10CFLISD >= 0 // 4.10.2 Verbal Learning / Word List Recall Test (Delayed); Verbal (Memory)
gen process_speed_46 = B10CFRC if B10CFRC >= 0 // 4.10.3 Timed Letter Search / Letter Cancellation Test; Processing Speed
gen process_accuracy_46 = B10CFMIS if B10CFMIS >= 0 // 4.10.3 Timed Letter Search/ Letter Cancellation Test; Processing Accuracy (# Mistakes)

save_bcs 46


// Measures of g
 

// Format Dataset
rename bcsid id
gen cohort = "1970c"
gen survey_weight = 1
order id cohort survey_weight
compress 
save "${clean}/1970c_cognition.dta", replace
rm "${clean}/1970c_temp.dta"