/*==================================================================
  Program : 05_celebrity_only.sas
  Purpose : Keep only the celebrity-brand products in their own
            table for a closer look.
  Input   : WORK.COMBINED_DATA
  Output  : WORK.CELEBRITY_ONLY
==================================================================*/

proc sql;
    create table celebrity_only as
    select *
    from combined_data
    where celebrity_brand = 1;
quit;
