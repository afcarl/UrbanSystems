/*

Tallest buildings exercise - 3rd .do file
By: Clayton Hunter
Date: April 8, 2016

NOTES
create some graphs from previously compiled data in "temp_data" directory

*/

/* set working directory*/
cd "C:\Users\crh278\Desktop\tallestBuildings_v2"

/* clear any existing data*/
drop _all

/* load building dataset */
use ".\temp_data\3_buildings.dta"

/* 
some obvious mistakes (eg joins los angeles buildings to Los Angeles, Chile instead of California, USA) 
so, drop records with less than 500,000 population in 2000 as manually looking through those look mostly wrong and above seems 
more or less right
*/
drop if POPULATION2000 < 500000

/* create log variables */
gen lg_pop = log(POPULATION2000)
gen lg_popDensity = log(DENSITYPEOPLEPERHECTARE)
gen lg_Height = log(Heightm)


/* 
check all correlations of city and building data 
do not appear to be any obvious correlations,
and population seems to be slightly negatively correlated 
with building height
*/
pwcorr Heightm Rank lg_Height POPULATION2000 DENSITYPEOPLEPERHECTARE lg_popDensity lg_pop AREAHECTARES DISTANCETOOCEANKMS

/* create graphs for all buildings */
twoway (scatter Heightm POPULATION2000), name(height_v_pop, replace)
twoway (scatter Heightm lg_pop), name(height_v_lgPop, replace)
twoway (scatter Heightm lg_popDensity), name(height_v_logPopDensity, replace)
twoway (scatter Heightm DENSITYPEOPLEPERHECTARE), name(height_v_popDensity, replace)
twoway (scatter lg_Height lg_pop), name(lgHeight_v_lgPop, replace)


/* collapse to look at just the tallest buildings */
collapse (max) Height_m = Heightm, by(City POPULATION2000 DENSITYPEOPLEPERHECTARE AREAHECTARES)
/* create log variables */
gen lg_pop = log(POPULATION2000)
gen lg_popDensity = log(DENSITYPEOPLEPERHECTARE)
gen lg_Height = log(Height_m)

pwcorr Height_m lg_Height POPULATION2000 DENSITYPEOPLEPERHECTARE lg_popDensity lg_pop AREAHECTARES

/* plot highest correlation */
twoway (scatter lg_Height lg_pop), name(Tallest_lgHeight_v_lgPop, replace)
