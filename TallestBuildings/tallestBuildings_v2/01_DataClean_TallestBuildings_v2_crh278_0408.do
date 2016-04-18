/*

Tallest buildings exercise - 1st .do file
By: Clayton Hunter
Date: April 8, 2016

NOTES
In your working directory (aka this folder) You should have 
1) this .do file, 
2) two Excel spreadsheets ("(797600776) buildings_2016-03-10-21-20-21" and "universe-of-cities-data")
3) a directory (againt "FOLDER") called "temp_data"

*/

/* set working directory*/
cd "C:\Users\crh278\Desktop\tallestBuildings_v2"

/* clear any existing data*/
drop _all

/* import and clean first sheet in building dataset */
import excel "(797600776) buildings_2016-03-10-21-20-21.xlsx", sheet("page 1") cellrange(A2:AA45) firstrow
rename A Rank
drop B C E F G H J L N O Q R T V W X Z AA
/* save temporary data  */
save ".\temp_data\1_buildings.dta"

/* clear any existing data
drop _all
*/

/* read in remaining sheets that all have the same layout */
forval i=2/62 {
	import excel "(797600776) buildings_2016-03-10-21-20-21.xlsx", sheet("page `i'") firstrow clear
	drop B
	rename A Rank
	append using "temp_data\1_buildings.dta", nolabel nonotes force
	save "temp_data\1_buildings.dta", replace
}
