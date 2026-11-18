/*==================================================================
  Program : 04_popularity_score.sas
  Purpose : Build a popularity score from reviews and loves and
            compare it between celebrity and non-celebrity brands.

            popularity_score = (0.7 * reviews / 1,000
                              + 0.3 * loves   / 100,000) * 100

            Reviews get more weight (70%) than loves (30%). Both are
            scaled first so they are on a similar range.
  Input   : WORK.COMBINED_DATA
  Output  : WORK.COMBINED_DATA (adds loves_scaled, reviews_scaled,
            popularity_score)
==================================================================*/

data combined_data;
    set combined_data;

    loves_scaled   = loves_count / 100000;
    reviews_scaled = reviews / 1000;

    popularity_score = ((reviews_scaled * 0.7) + (loves_scaled * 0.3)) * 100;
run;

/* Show 0/1 as readable labels on the graph */
proc format;
    value celebf 0 = 'Non-celebrity brand'
                 1 = 'Celebrity brand';
run;

title "Average Popularity Score: Celebrity vs Non-celebrity Brands";
proc sgplot data=combined_data;
    format celebrity_brand celebf.;
    vbar celebrity_brand / response=popularity_score stat=mean;
    yaxis label="Average Popularity Score";
    xaxis label="Brand Type";
run;
title;
