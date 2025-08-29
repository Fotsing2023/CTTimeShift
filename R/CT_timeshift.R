


#get grid points from Ct images

#' Function to create grid point on camera trap image
#' @param picture picture is the image of animal taken by camera trap
#' @param nrow A number of row of our grid that we want to set in the image that correspond to my grid
#' @param ncol A number of colum of our grid that we want to set in the image that correspond to my grid
#' @return return a grid with coordinate x and y
#' @keywords internal
#' @export

getGridPoints <- function(picture, nrow = 9, ncol = 16){
  h <- dim(picture)[1]
  w <- dim(picture)[2]

  return(list(
    x = round(0.9 * h / nrow * (1:nrow - 0.5)),
    y = round(w / ncol * (1:ncol - 0.5)),
    n = nrow * ncol
  ))
}

#' Function to perfomr summary statistic for each image
#' @param img_path img_path this the folder directory where the image are located
#' @param nrow A grid number of row
#' @param ncol A grid number of colum
#' @return return a dataframe with proportion of black and white or color for each imagesy
#' @keywords internal
#' @export
# ——— GRID-BASED COLOR ANALYSIS FUNCTION ———
calcColorSumStats <- function(img_path, nrow = 9, ncol = 16) {
  # open image
  message("Processing: ", img_path)
  tryCatch({
    pic <- jpeg::readJPEG(img_path)
  }, error = function(e) {
    message("Error reading image '", img_path, "': ", e$message)
  })

  if (length(dim(pic)) < 3 || dim(pic)[3] != 3) stop("Image is not RGB")

  # Extract RGB values at selected grid points
  grid <- getGridPoints(pic,nrow, ncol)
  subset <- pic[grid$x, grid$y, 1:3]
  mean_vals <- apply(subset, c(1,2), sum) / 3

  # calculate stats
  return(
    c(
      sum(!(subset[,,1] == subset[,,2]  & subset[,,1] == subset[,,3])) / grid$n,
      sapply(seq(0.1, 0.5, by=0.1), function(p){ sum(mean_vals < p) }) / grid$n
    )
  )
}

#' Extract Metadata and Color Statistics from Camera Trap Images
#'
#' @param root_dir root_dir this the main directory where all the folder containg the image are located
#' @return return a dataframe with  9 colum as follow: ImagesPath, Datetime, classification, is.color, dark_0.1, darrk_0.2, dark_0.3, dark_0.4, dark_0.5, proportion of black and white or color for each imagesy
#' @keywords internal
#' @importFrom stats kmeans
#' @export
#' @examples
#' img_dir <- system.file("extdata", "BlackWhite", package = "CTTimeShift")
#' result <- extract_all_metadata(img_dir)
#'head(result)
#'
# ——— METADATA + COLOR EXTRACTION FUNCTION ———
extract_all_metadata <- function(root_dir) {

  # identify img files
  root_dir <- normalizePath(root_dir, winslash = "/", mustWork = TRUE)
  img_files <- list.files(root_dir,
                          pattern = "\\.(jpg|jpeg|JPG|JPEG)$",
                          recursive = TRUE, full.names = TRUE, ignore.case = TRUE)

  if (length(img_files) == 0) stop("No images found in ", root_dir)

  # read exif data
  exif_data <-  exifr::read_exif(img_files, tags = "DateTimeOriginal")

  # calc color summary statistics
  color_stats <- as.data.frame(t(sapply(img_files, calcColorSumStats)))
  names(color_stats) <- c("is.color", paste0("dark_", seq(0.1, 0.5, by = 0.1)))

  # identify clusters and assing images to day and night
  kmeans_result <- stats::kmeans(color_stats, centers = 2)# tells R to find 2 clusters — one for day, one for night

  classification <- rep("night", length(img_files))
  if(mean(color_stats$is.color[kmeans_result$cluster == 1]) > mean(color_stats$is.color[kmeans_result$cluster == 2])){
    classification[kmeans_result$cluster == 1] <- "day"
  } else if(mean(color_stats$is.color[kmeans_result$cluster == 1]) < mean(color_stats$is.color[kmeans_result$cluster == 2])){
    classification[kmeans_result$cluster == 2] <- "day"
  } else if(mean(color_stats$median_red[kmeans_result$cluster == 1]) > mean(color_stats$is.color[kmeans_result$cluster == 2])){
    classification[kmeans_result$cluster == 1] <- "day"
  } else {
    classification[kmeans_result$cluster == 2] <- "day"
  }

  # return data frame
  rownames(color_stats) <- NULL
  return(
    cbind(
      img_files, exif_data$DateTimeOriginal, classification, color_stats
    )
  )
}





