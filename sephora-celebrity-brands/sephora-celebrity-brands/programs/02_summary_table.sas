/*==================================================================
  Program : 02_summary_table.sas
  Purpose : Summary table comparing celebrity and non-celebrity
            brands: number of products and average rating, loves,
            reviews and price.
  Input   : WORK.COMBINED_DATA
==================================================================*/

/* Show 0/1 as readable labels in the table */
proc format;
    value celebf 0 = 'Non-celebrity brand'
                 1 = 'Celebrity brand';
run;

title "Average Rating, Loves, Reviews and Price by Brand Type";
proc report data=combined_data nowd;
    column celebrity_brand n rating loves_count reviews price_usd;

    define celebrity_brand / group format=celebf. "Brand Type";
    define n               / "Products";
    define rating          / analysis mean format=4.2       "Avg Rating";
    define loves_count     / analysis mean format=comma10.  "Avg Loves";
    define reviews         / analysis mean format=comma8.   "Avg Reviews";
    define price_usd       / analysis mean format=dollar8.2 "Avg Price";
run;
title;
