#' CTTimeShift: Analyze Camera Trap Image Metadata and Color Patterns
#'
#' This package provides tools to extract metadata and perform grid-based color analysis by clasifying each images in grayscale or color using Kmeans clustering to identify if an image is a day or nigth
#' on camera trap images, helping to correct timestamp shifts in each images.
#' Key functions include:
#' - \code{\link{extract_all_metadata}}: Extracts metadata and color statistics from JPEG images.
#' - \code{\link{calcColorSumStats}}: Computes grid-based color summaries.
#' - \code{\link{getGridPoints}}: Generates grid coordinates for image analysis.
#'
#' Example usage:
#' \dontrun{
#' img_dir <- system.file("extdata", "BlackWhite", package = "CTTimeShift")
#' result <- extract_all_metadata(img_dir)
#' head(result)
#' }
#'
#' @keywords internal
"_PACKAGE"
