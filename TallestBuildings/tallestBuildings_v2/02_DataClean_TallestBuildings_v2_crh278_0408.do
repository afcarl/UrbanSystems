/*

Tallest buildings exercise - 2nd .do file
By: Clayton Hunter
Date: April 8, 2016

NOTES
In your working directory (aka this folder) You should have 
1) this .do file, 
2) the output '1_buildings.dta' (from the 1st .do file) in a directory (again, aka "FOLDER") called "temp_data"

*/

/* set working directory*/
cd "C:\Users\crh278\Desktop\tallestBuildings_v2"

/* clear any existing data*/
drop _all

/* load building dataset */
use ".\temp_data\1_buildings.dta", clear

/* keep just subset of messy data */
keep Rank BuildingName City Heightm Heightft Floors Completed Material Use
drop if missing(BuildingName)

/* clean City variable*/
gen cityclean = subinstr(trim(itrim(lower(City))), " ","",.)
sort cityclean

/* save out cleaned buildings data */
save "temp_data\2_buildings.dta"

/* clean up workspace */
drop _all

/* read in city data */
import excel "universe-of-cities-data.xls", sheet("Urban_clusters_final_centers") firstrow

/* clean city name, selecting just one of the "maincity" options if has a comma */
gen cityclean = subinstr(trim(itrim(lower(MAINCITY))), " ","",.)
replace cityclean = substr(cityclean, 1, strpos(cityclean, ",")-1) if strpos(cityclean, ",")>0

/* sort by cleaned city name */
sort cityclean

/* merge saved building data to current city data */
merge m:m cityclean using "temp_data\2_buildings.dta", keep(match)

/* drop cities without building observations */
drop if missing(Rank)

/* sort by building name to check for duplicates, 
some buildings in different cities have the same name (eg Bank of America Plaza)
so make sure looking at actual duplicates by including city name and building height */
sort BuildingName
duplicates list BuildingName cityclean Heightm

drop in 1530
drop in 1525 
drop in 1240 
drop in 183 

/* save out compiled dataset */
save "temp_data\3_buildings.dta"
