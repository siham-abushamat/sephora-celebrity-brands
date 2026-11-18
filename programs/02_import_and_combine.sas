/*==================================================================
  Program : 02_import_and_combine.sas
  Purpose : Import the Sephora product file (non-celebrity brands),
            give it the same columns as RHODE_PRODUCTS, and stack
            the two into one table for the analysis.
  Input   : data/product_info.csv
            WORK.RHODE_PRODUCTS (created by 01_data_rhode.sas)
  Output  : WORK.SEPHORA_PRODUCTS  (celebrity_brand = 0)
            WORK.COMBINED_DATA     (Sephora products + Rhode)
==================================================================*/

/* Folder where this project is saved in SAS OnDemand.
   ~ is your home folder (Files (Home) in SAS Studio).
   Change this line if you saved the project somewhere else. */
%let project = ~/sephora-celebrity-brands;

/* The CSV uses Windows line endings (CRLF). Telling SAS this also
   lets it read the one product whose ingredients contain a line
   break. */
filename prodcsv "&project/data/product_info.csv" termstr=crlf;

proc import datafile=prodcsv
    out=sephora_import
    dbms=csv
    replace;
    guessingrows=max;
run;

data sephora_products;
    /* Same lengths as RHODE_PRODUCTS so no text is cut off */
    length product_id         $ 11
           product_name       $ 107
           brand_id           $ 8
           brand_name         $ 33
           size               $ 65
           ingredients        $ 16488
           highlights         $ 192
           primary_category   $ 15
           secondary_category $ 25;

    set sephora_import(rename=(brand_id = brand_id_num));

    /* brand_id is a number in this file but text (e.g. RH001) in
       the Rhode data, so store it as text here as well */
    brand_id = cats(brand_id_num);

    celebrity_brand = 0;

    keep product_id product_name brand_id brand_name loves_count
         rating reviews size ingredients price_usd highlights
         primary_category secondary_category celebrity_brand;
run;

/* Stack the Sephora products and the Rhode products */
data combined_data;
    set sephora_products rhode_products;
run;

/* Quick check: number of products in each group */
proc freq data=combined_data;
    tables celebrity_brand;
run;
