/*
1958 Cohort (NCDS)
*/
use "${raw}/NCDS/0y-16y/ncds0123.dta", clear
rename ncdsid NCDSID
merge 1:1 NCDSID using "D:/NCDS/50y/ncds_2008_followup.dta", ///
	keepusing(N8CFANI N8CFLISN N8CFLISD N8CFRC N8CFMIS N8INTMON N8INTYR) nogen

// Individual Cognition Measures


* Age 7
gen reading_07 = n92 if n92 >= 0 // 3.1.1 Southgate Group Reading Test; Verbal (Reading)
gen arithmetic_07 = n90 if n90 >= 0	// 3.1.2 Problem Arithmetic Test; Arithmetic (Problems)
gen visuospatial_07 = n457 if n457 >= 0 // 3.1.3 Copying Designs Test; Visuospatial
gen drawing_07 = n1840 if n1840 >= 0 // 3.1.4 Human Figure Drawing; General Ability (Perceptual)

* Age 11
gen_age age_11 n910 n911 `=ym(1958, 3)' // Test Booklet 2T

gen verbal_11 = n914 if n914 >= 0 // 3.2.1 General Ability Test; Verbal (Reasoning)
gen nonverbal_11 = n917 if n917 >= 0  // 3.2.1 General Ability Test; Non-Verbal (Reasoning)
gen general_11 = n920 if n920 >= 0  // 3.2.1 General Ability Test; Verbal + Non-Verbal (Reasoning)
gen comprehension_11 = n923 if n923 >= 0 // 3.2.2 Reading Comprehension Test; Verbal (Reading)
gen arithmetic_11 = n926 if n926 >= 0 // 3.2.3 Mathematics Test; Arithmetic
gen visuospatial_11 = n929 if n929 >= 0 // 3.1.4 Copying Designs Test; Visuospatial

* Age 16
gen_age age_16 n2925 n2927 `=ym(1958, 3)' // Test Booklet 3T

gen comprehension_16 = n2928 if n2928 >= 0 // 3.2.2 Reading Comprehension Test; Verbal (Reading)
gen maths_16 = n2930 if n2930 >= 0 // 3.2.3 Mathematics Test; Mathematics

* Age 50
gen_age age_50 N8INTMON N8INTYR `=ym(1958, 3)' 

gen fluency_50 = N8CFANI if N8CFANI >= 0 // 3.6.1 Verbal Fluency (Animal Naming) Test; Verbal (Fluency)
gen memory_immediate_50 = N8CFLISN if N8CFLISN >= 0 // 3.6.2 Verbal Learning / Word List Recall Test (Immediate); Verbal (Memory)     
gen memory_delayed_50 = N8CFLISD if N8CFLISD >= 0 // 3.6.2 Verbal Learning / Word List Recall Test (Delayed); Verbal (Memory) 
gen process_speed_50 = N8CFRC if N8CFRC >= 0 // 3.6.3 Timed Letter Search / Letter Cancellation Test; Processing Speed
gen process_accuracy_50 = N8CFMIS if N8CFMIS >= 0 // 3.6.3 Timed Letter Search/ Letter Cancellation Test; Processing Accuracy (# Mistakes)


// Measures of g


// Format Dataset
rename NCDSID id
gen cohort = "1958c"
gen survey_weight = 1
keep id cohort survey_weight *_07 *_11 *_16 *_50
order id cohort survey_weight
compress
save "${clean}/1958c_cognition.dta", replace