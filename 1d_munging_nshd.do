/*
1946 Cohort (NSHD)
*/
use "${raw}/NSHD/46c_ht_cog.dta", clear
merge 1:1 nshdid_db1120  using "${raw}/NSHD/magels_fagels.dta", nogen

// Individual Cognition Measures
* Age 8
gen age_08 = date53c/12 if inrange(date53c, 83, 93)

gen picture_08 = pi8r if pi8r != 99 // 2.1.1 Picture Intelligence; Non-Verbal (Reasoning)
gen comprehension_08 = sc8r if sc8r != 99 // 2.1.2 Reading Comprehension; Verbal (Reading)
gen reading_08 = r8r if r8r != 99 // 2.1.3 Word Reading; Verbal (Reading)
gen vocab_08 = voc8r if voc8r != 99 // 2.1.4 Vocabulary; Verbal (Comprehension)

* Age 11
gen age_11 = date57c/12 if inrange(date57c, 128, 137)

gen verbal_11 = v11r if v11r != 99 // 2.2.1 General Ability Test; Verbal (Reasoning)
gen nonverbal_11 = nv11r if nv11r != 99 // 2.2.1 General Ability Test; Non-Verbal (Reasoning)
gen general_11 = ga11r if ga11r != 999 // 2.2.1 General Ability Test; Verbal + Non-Verbal (Reasoning)
gen arithmetic_11 = a11r if a11r != 99 // 2.2.2 Arithmetic Test; Verbal (Problem Qs) + Non-Verbal (Mechanical Sums)
gen reading_11 = r11r if r11r != 99 // 2.2.3 Word Reading; Verbal (Reading)
gen vocab_11 = voc11r if voc11r != 99 // 2.2.4 Vocabul; ; Verbal (Comprehension)

* Age 15
gen age_15 = date61c/12 if inrange(date61c, 172, 182)

gen verbal_15 = v15r if v15r != 99 // 2.3.1 The Alice Heim Group Ability Test; Verbal (Reasoning)
gen nonverbal_15 = nv15r if nv15r != 99 // 2.3.1 The Alice Heim Group Ability Test; Non-Verbal (Reasoning)
gen general_15 = ga15r if ga15r != 999 // 2.3.1 The Alice Heim Group Ability Test; Verbal + Non-Verbal (Reasoning)
gen reading_15 = r15r if r15r != 99 // 2.3.2 The Watts-Vernon Reading Test; Verbal (Reading)
gen arithmetic_15 = m15r if m15r != 99 // 2.3.3 Mathematics Test; Verbal (Arithmetic)

* Age 26
gen age_26 = age72/12 if inrange(age72, 312, 356)

gen reading_a_26 = r26r if r26r != 99 // 2.4.1 Watts-Vernon Reading Test; Verbal (Reading)
gen reading_b_26 = wv26r if wv26r != 99 // 2.4.1 Watts-Vernon Reading Test; Verbal (Reading); 1st 35 Qs

* Age 43
gen age_43 = age89/12 if inrange(age89, 514, 533)

gen memory_short_43 = wlt89 if inrange(wlt89, 0, 45) // 2.5.1 Verbal Learning / Word List Recall Test; Verbal (Memory)
// gen memory_long_43 = // 2.5.2 Long-Term Recall; Verbal (Memory)
// gen memory_visual_43 = // 2.5.3 Visual Memory; Non-Verbal (Memory)
// gen process_speed_43 = // 2.5.4 Timed Letter Search/Letter Cancellation Test; Processing Speed
// motor_43 = // Motor Speed and Praxis; Motor Skills

* Age 53
gen age_53 = age99/12 if inrange(age99, 636, 650)

gen memory_short_53 = wlt99 if inrange(wlt99, 0, 45)  // 2.6.1 Verbal Learning / Word List Recall Test; Verbal (Memory)
// gen process_speed_53 = // 2.6.2 Timed Letter Search/Letter Cancellation Test; Processing Speed
// gen fluency_53 = // 2.6.3 Verbal Fluency (Animal Naming) Test; Verbal Fluency
// gen memory_prospective_53 = // 2.6.4 Prospective Memory; Verbal Memory
// gen literacy_53 = // 2.6.5 National Adult Reading Test (NART); Verbal (Reading)
// gen memory_delay_53 = // 2.6.6 Delayed Verbal Memory; Verbal (Memory)

* Age 60-64
// gen age_62 = 

// gen memory_short_62 =  // 2.7.1 Verbal Learning / Word List Recall Test; Verbal (Memory)
// gen process_speed_63 = // 2.7.2 Timed Letter Search/Letter Cancellation Test; Processing Speed
// gen reaction_63 = // 2.7.3 Reaction Time Test; Reaction Time

* Age 68-70
// gen age_69 =

// gen memory_short_69 =  // 2.8.1 Verbal Learning / Word List Recall Test; Verbal (Memory)
// gen process_speed_69 = // 2.8.2 Timed Letter Search/Letter Cancellation Test; Processing Speed
// gen coord_speed_69 = // 2.8.3 Finger Tapping Test; Non-Verbal
// gen general_69 = // 2.8.4 Addenbrooke's Cognitive Examination-III Total Score; Verbal + Non-Verbal Ability
// gen orientation_69 = // 2.8.5 Addenbrooke's Cognitive Examination-III Attention/Orientation Scale; Verbal Orientation
// gen memory_69 = // 2.8.6 Addenbrooke's Cognitive Examination-III Memory; Verbal Memory
// gen fluency_69 = // 2.8.7 Addenbrooke's Cognitive Examination-III Fluency; Verbal Fluency
// gen language_69 = // 2.8.8 Addenbrooke's Cognitive Examination-III Language Test; Verbal (Language Ability)
// gen visuospatial_69 = // 2.8.9 Addenbrooke's Cognitive Examination-III Visuospatial Skills; Non-Verbal Ability


// Measures of g
gen iq_sum_08 = cog8h // p.22; Standardized Sum-Score of Standardized Test Scores
gen iq_sum_11 = cog11h // p.22; Standardized Sum-Score of Standardized Test Scores
gen iq_sum_15 = cog15h // p.22; Standardized Sum-Score of Standardized Test Scores


// Format Dataset
egen total_weight = total(inf)
gen survey_weight = inf * _N / total_weight
tostring nshdid_db1120, gen(id)
gen cohort = "1946c"
keep id cohort survey_weight *_08 *_11 *_15 *_26 *_43 *_53
order id cohort survey_weight
compress
save "${clean}/1946c_cognition.dta", replace