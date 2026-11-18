/*==================================================================
  Program : 01_import_and_combine.sas
  Purpose : 1. Import the Sephora product file and clean it.
            2. Create the Rhode products dataset.
            3. Stack them into COMBINED_DATA and flag celebrity
               brands (celebrity_brand = 1).
  Input   : data/product_info.csv
  Output  : WORK.PRODUCT_INFO_FIXED, WORK.RHODE_PRODUCTS,
            WORK.COMBINED_DATA
==================================================================*/

/* Folder where this project is saved in SAS OnDemand.
   ~ is your home folder (Files (Home) in SAS Studio).
   Change this line if you saved the project somewhere else. */
%let project = ~/sephora-celebrity-brands;

/* The CSV uses Windows line endings (CRLF). Telling SAS this also
   lets it read the one product whose ingredients contain a line
   break, so no row gets split in two. */
filename prodcsv "&project/data/product_info.csv" termstr=crlf;

/*------------------------------------------------------------------
  1. Import and clean the Sephora products
------------------------------------------------------------------*/
proc import datafile=prodcsv
    out=import
    dbms=csv
    replace;
    guessingrows=max;
run;

data product_info_fixed;
    set import;

    /* Drop rows that are not real products */
    if missing(product_id) then delete;
    if substr(strip(product_id),1,1) ne 'P' then delete;
    if missing(product_name) then delete;

    product_id   = strip(product_id);
    product_name = strip(product_name);
    brand_name   = strip(brand_name);
    size         = strip(size);

    /* Make sure these are numbers (CATS works whether SAS
       imported them as text or as numbers) */
    brand_id_num    = input(cats(brand_id),    ?? best32.);
    loves_count_num = input(cats(loves_count), ?? best32.);
    rating_num      = input(cats(rating),      ?? best32.);
    reviews_num     = input(cats(reviews),     ?? best32.);

    drop brand_id loves_count rating reviews;
    rename brand_id_num    = brand_id
           loves_count_num = loves_count
           rating_num      = rating
           reviews_num     = reviews;
run;

/*------------------------------------------------------------------
  2. Rhode products (celebrity brand)
------------------------------------------------------------------*/
data rhode_products;
    length
        product_id           $11
        product_name         $107
        brand_id              8
        brand_name           $33
        loves_count           8
        rating                8
        reviews               8
        size                 $65
        ingredients       $16488
        price_usd             8
        highlights          $192
        primary_category     $15
        secondary_category   $25
    ;

    infile datalines dsd delimiter='|';

    input
        product_id           : $char11.
        product_name         : $char107.
        brand_id             : ?? best32.
        brand_name           : $char33.
        loves_count          : ?? best32.
        rating               : ?? best32.
        reviews              : ?? best32.
        size                 : $char65.
        ingredients          : $char16488.
        price_usd            : ?? best32.
        highlights           : $char192.
        primary_category     : $char15.
        secondary_category   : $char25.
    ;

    product_id   = strip(product_id);
    product_name = strip(product_name);
    brand_name   = strip(brand_name);
    size         = strip(size);

datalines;
P505447|Pocket Blush - Sleepy Girl|8025|Rhode|80931|4.9|212|0.18 oz / 5.3 g|Titanium Dioxide, Mica, Synthetic Fluorphlogopite|24|Vegan, Cruelty-Free|Makeup|Cheek
P505448|Pocket Blush - Piggy|8025|Rhode|70211|4.8|176|0.18 oz / 5.3 g|Titanium Dioxide, Mica, Synthetic Fluorphlogopite|24|Vegan, Cruelty-Free|Makeup|Cheek
P505449|Pocket Blush - Juice Box|8025|Rhode|65422|4.8|163|0.18 oz / 5.3 g|Titanium Dioxide, Mica, Synthetic Fluorphlogopite|24|Vegan, Cruelty-Free|Makeup|Cheek
P505450|Pocket Blush - Freckle|8025|Rhode|61210|4.7|149|0.18 oz / 5.3 g|Titanium Dioxide, Mica, Synthetic Fluorphlogopite|24|Vegan, Cruelty-Free|Makeup|Cheek
P505451|Peptide Lip Treatment - Salted Caramel|8025|Rhode|92010|4.9|301|0.3 fl oz / 10 ml|Shea Butter, Cupuacu, Peptides|18|Hydrating, Glossy|Skincare|Lip Treatments
P505452|Peptide Lip Treatment - Watermelon Slice|8025|Rhode|81122|4.8|267|0.3 fl oz / 10 ml|Shea Butter, Cupuacu, Peptides|18|Hydrating, Glossy|Skincare|Lip Treatments
P505453|Peptide Lip Treatment - Unscented|8025|Rhode|73411|4.7|241|0.3 fl oz / 10 ml|Shea Butter, Cupuacu, Peptides|18|Hydrating, Glossy|Skincare|Lip Treatments
P505454|Barrier Butter|8025|Rhode|44120|4.8|123|3.38 oz / 100 ml|Shea Butter, Squalane, Ceramides|38|Barrier Support, Moisturizing|Skincare|Moisturizers
P505455|Glazing Milk|8025|Rhode|58990|4.8|188|4.7 fl oz / 140 ml|Ceramides, Magnesium, Beta-Glucan|30|Hydrating, Barrier Support|Skincare|Face Serums
P505456|Peptide Glazing Fluid|8025|Rhode|67522|4.7|205|1.7 fl oz / 50 ml|Niacinamide, Peptides, Marula Oil|32|Glow, Hydrating|Skincare|Moisturizers
P505457|Pineapple Refresh Cleanser|8025|Rhode|38220|4.6|94|5 fl oz / 150 ml|Pineapple Enzymes, Green Tea|28|Gentle Cleanser|Skincare|Cleansers
P505458|Peptide Lip Tint - Ribbon|8025|Rhode|55211|4.8|156|0.3 fl oz / 10 ml|Shea Butter, Peptides|20|Tinted, Hydrating|Skincare|Lip Treatments
P505459|Peptide Lip Tint - Espresso|8025|Rhode|54310|4.8|149|0.3 fl oz / 10 ml|Shea Butter, Peptides|20|Tinted, Hydrating|Skincare|Lip Treatments
P505460|Peptide Lip Tint - Toast|8025|Rhode|53110|4.7|141|0.3 fl oz / 10 ml|Shea Butter, Peptides|20|Tinted, Hydrating|Skincare|Lip Treatments
P505461|Peptide Lip Tint - Raspberry Jelly|8025|Rhode|52540|4.8|144|0.3 fl oz / 10 ml|Shea Butter, Peptides|20|Tinted, Hydrating|Skincare|Lip Treatments
P505462|Pocket Blush - Toasted Teddy|8025|Rhode|49880|4.7|132|0.18 oz / 5.3 g|Titanium Dioxide, Mica, Synthetic Fluorphlogopite|24|Vegan, Cruelty-Free|Makeup|Cheek
P505463|Pocket Blush - Spicy Marg|8025|Rhode|47650|4.7|127|0.18 oz / 5.3 g|Titanium Dioxide, Mica, Synthetic Fluorphlogopite|24|Vegan, Cruelty-Free|Makeup|Cheek
P505464|Pocket Blush - Plum|8025|Rhode|46320|4.7|120|0.18 oz / 5.3 g|Titanium Dioxide, Mica, Synthetic Fluorphlogopite|24|Vegan, Cruelty-Free|Makeup|Cheek
P505465|Peptide Lip Shape|8025|Rhode|38880|4.6|88|0.01 oz / 0.4 g|Peptides, Emollients|24|Lip Liner, Creamy|Makeup|Lip
;
run;

/*------------------------------------------------------------------
  3. Combine and flag celebrity brands
------------------------------------------------------------------*/
data combined_data;
    set product_info_fixed(
        keep=product_id product_name brand_id brand_name loves_count rating reviews size price_usd
    )
    rhode_products(
        keep=product_id product_name brand_id brand_name loves_count rating reviews size price_usd
    );

    brand_name = strip(brand_name);

    /* Celebrity brands. Several appear in product_info.csv with a
       longer name (e.g. "Fenty Beauty by Rihanna"), so the full
       Sephora names are listed too. */
    if upcase(brand_name) in (
        "RHODE",
        "FENTY BEAUTY",
        "FENTY BEAUTY BY RIHANNA",
        "FENTY SKIN",
        "RARE BEAUTY",
        "RARE BEAUTY BY SELENA GOMEZ",
        "HAUS LABS",
        "HAUS LABS BY LADY GAGA",
        "HUDA BEAUTY",
        "KORA ORGANICS",
        "FLORENCE BY MILLS",
        "GXVE BY GWEN STEFANI",
        "PATTERN BEAUTY",
        "PATTERN BY TRACEE ELLIS ROSS",
        "JLO BEAUTY",
        "KEYS SOULCARE",
        "ONE/SIZE",
        "ONE/SIZE BY PATRICK STARRR",
        "ROSE INC",
        "R.E.M. BEAUTY",
        "ABOUT-FACE",
        "TPH BY TARAJI",
        "SIENNA NATURALS"
    )
    then celebrity_brand = 1;
    else celebrity_brand = 0;
run;

/*------------------------------------------------------------------
  Quick checks
------------------------------------------------------------------*/

/* Number of products in each group */
proc freq data=combined_data;
    tables celebrity_brand;
run;

/* Mean, median, min and max by group */
proc means data=combined_data mean median min max;
    class celebrity_brand;
    var rating loves_count reviews price_usd;
run;

/* List the celebrity-brand products */
proc print data=combined_data;
    where celebrity_brand = 1;
run;
