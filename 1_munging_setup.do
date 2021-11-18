/*

*/

/*
Set-Up
*/

clear
cls
set linesize 140

global bann 	"S:/IOEQSS_Main/Bann/crosscinequality"
global raw		"D:"
global clean 	"D:/Projects/Cognition Measures/Data"
global code		"D:/Projects/Cognition Measures/Code"

// ssc install egenmore
// ssc install wridit
// net install dm0004_1.pkg // zanthro


/*
Make Programmes
*/
capture program drop gen_age
program define gen_age
	args new_var int_m int_y birth_my
	
	tempvar date
	gen `date' = ym(1900 + `int_y', `int_m') if `int_y' >= 0 & `int_m' >= 0
	gen `new_var' = (`date' - `birth_my') / 12
	drop `date'
end
	
capture program drop gen_residuals
program define gen_residuals
	syntax varlist [, covars(varlist)]
	
	foreach var of local varlist{
		local age = substr("`var'", -2, .)
		local stub = substr("`var'", 1, strpos("`var'", "_") - 1)
		
		regress `var' age_cog_`age' `covars'
		predict `stub'_resid_`age', residuals
	}
end

/*
Run Do Files
*/
// do "${code}/1a_munging_mcs.do"
// do "${code}/1b_munging_bcs70.do"
// do "${code}/1c_munging_ncds.do"
// do "${code}/1d_munging_nshd.do"