# Celebrity vs Non-celebrity Beauty Brands (SAS)

An academic project in SAS Studio that asks whether products from celebrity beauty brands get more attention from shoppers than products from other brands. It uses **8,494 products sold at Sephora** plus **19 Rhode products**, and compares the two groups on **loves** (how many shoppers saved a product as a favorite), **number of reviews**, **rating**, **price**, and a combined **popularity score**.

## Data

| Source | What it is | Where |
|---|---|---|
| Sephora product data | 8,494 Sephora products scraped in March 2023, from the [Sephora Products and Skincare Reviews](https://www.kaggle.com/datasets/nadyinky/sephora-products-and-skincare-reviews) dataset on Kaggle | `data/product_info.csv` |
| Rhode products | 19 Rhode products, entered directly in the program | `programs/01_import_and_combine.sas` |
| Rhode products, detailed version | A second Rhode dataset with full ingredient lists and highlights, kept for reference and not used in the analysis | `programs/06_rhode_detailed_data.sas` |

The Kaggle dataset also includes about 1 million customer reviews, split across five CSV files (roughly 520 MB in total). They are **not included** in this repository: they are too large for GitHub, and none of the programs use them. You can download them from the Kaggle page above.

### Which brands count as celebrity brands

`celebrity_brand = 1` for Rhode and for celebrity-founded brands sold at Sephora, including Fenty Beauty, Fenty Skin, Rare Beauty, Haus Labs, Huda Beauty, KORA Organics, GXVE, PATTERN, JLo Beauty, ONE/SIZE and ROSE INC. The full list is in `01_import_and_combine.sas`. All other brands are `celebrity_brand = 0`.

### Variables used

| Variable | Meaning |
|---|---|
| `product_id`, `product_name`, `brand_name` | Product and brand |
| `loves_count` | Number of shoppers who added the product to their favorites |
| `reviews` | Number of reviews |
| `rating` | Average star rating (1–5) |
| `price_usd` | Price in US dollars |
| `size` | Product size |
| `celebrity_brand` | 1 = celebrity brand, 0 = other brands |

### Popularity score

```
popularity_score = (0.7 × reviews / 1,000  +  0.3 × loves / 100,000) × 100
```

Reviews get more weight (70%) than loves (30%), and both are scaled first so they are on a similar range.

## Project structure

```
sephora-celebrity-brands/
├── README.md
├── data/
│   └── product_info.csv
└── programs/
    ├── 01_import_and_combine.sas    # Imports Sephora data, adds Rhode, flags celebrity brands
    ├── 02_summary_table.sas         # Averages by brand type (PROC REPORT)
    ├── 03_graphs_loves_rating.sas   # Loves and rating: bar chart and box plots
    ├── 04_popularity_score.sas      # Builds the popularity score and graphs it
    ├── 05_celebrity_only.sas        # Table with celebrity-brand products only
    └── 06_rhode_detailed_data.sas   # Detailed Rhode dataset (reference only)
```

## How to run (SAS OnDemand for Academics)

1. In SAS Studio, under **Files (Home)**, create a folder called `sephora-celebrity-brands` with two subfolders, `data` and `programs`.
2. Upload `product_info.csv` into `data` and the `.sas` files into `programs`.
3. If you saved the project somewhere else, change the `%let project = ...` line at the top of `01_import_and_combine.sas`.
4. Run programs **01 to 05 in order, in the same session**. The datasets are kept in the temporary WORK library, so each program uses what the earlier ones created. Program 06 runs on its own.

## Output

- Number of products in each group, and mean, median, min and max of rating, loves, reviews and price (PROC FREQ, PROC MEANS)
- Summary table: number of products and average rating, loves, reviews and price for each brand type
- Average loves per product, celebrity vs non-celebrity (bar chart)
- Distribution of loves (box plot)
- Distribution of ratings (box plot)
- Average popularity score (bar chart)

## Tools

SAS Studio on SAS OnDemand for Academics. The programs use PROC IMPORT, the DATA step, PROC SQL, PROC FREQ, PROC MEANS, PROC REPORT, PROC PRINT and PROC SGPLOT.
