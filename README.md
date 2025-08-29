# CTTimeShift

CTTimeShift is an R package for analyzing cameras traps images. It extracts EXIF metadata (date and time from each images). performs grid-based color analysis to classify each images by time of day and tell you if the image is a day or night image using clustering classification.

## Installation

You can install the development version of **CTTimeShift** directly from GitHub:

```r
# install.packages("devtools") if needed
devtools::install_github("Fotsing2023/CTTimeShift")

## Example Usage

```r
library(CTTimeShift)

# Load sample image folder bundled with the package
img_dir <- system.file("extdata", "BlackWhite", package = "CTTimeShift")

# Run the analysis
result <- extract_all_metadata(img_dir)

# View the first few rows
head(result)


 A short explanation of the example shown above is below 

 This example extracts metadata and peform color scale statistics from sample camera trap images included in the package.


