/*==================================================================
  Program : 03_graphs_loves_rating.sas
  Purpose : Compare celebrity and non-celebrity brands on
            loves (average and spread) and on product rating.
  Input   : WORK.COMBINED_DATA
==================================================================*/

/* Show 0/1 as readable labels on the graphs */
proc format;
    value celebf 0 = 'Non-celebrity brand'
                 1 = 'Celebrity brand';
run;

/* Average loves per product */
title "Average Loves per Product: Celebrity vs Non-celebrity Brands";
proc sgplot data=combined_data;
    format celebrity_brand celebf.;
    vbar celebrity_brand / response=loves_count stat=mean;
    yaxis label="Average Loves";
    xaxis label="Brand Type";
run;

/* Spread of loves */
title "Distribution of Loves: Celebrity vs Non-celebrity Brands";
proc sgplot data=combined_data;
    format celebrity_brand celebf.;
    vbox loves_count / category=celebrity_brand;
    yaxis label="Loves";
    xaxis label="Brand Type";
run;

/* Spread of ratings */
title "Distribution of Ratings: Celebrity vs Non-celebrity Brands";
proc sgplot data=combined_data;
    format celebrity_brand celebf.;
    vbox rating / category=celebrity_brand;
    yaxis label="Rating (out of 5)";
    xaxis label="Brand Type";
run;

title;
