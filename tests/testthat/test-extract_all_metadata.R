test_that("extract_all_metadata works with sample images", {
  img_dir <- system.file("extdata", "BlackWhite", package = "CTTimeShift")
  skip_if(img_dir == "", "Sample image directory not found")

  result <- extract_all_metadata(img_dir)
  expect_s3_class(result, "data.frame")
  expect_gt(nrow(result), 0)
})
