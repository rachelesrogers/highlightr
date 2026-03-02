Sys.setenv("OMP_THREAD_LIMIT" = 1)

test_that("html tags removed", {
  testing <- "<i> The review </i>. text with <br> a page break.<b>tag without spaces</b>.<font color='#9900FF'> color </font>"

  results <- tokenize_source(testing)

  expect_identical(results[[1]], c("the", "review", "text", "with", "a", "page", "break",
                                   "tag", "without", "spaces", "color"))

})

test_that("dollar sign removed", {
  testing <- "$4.50"

  results <- tokenize_source(testing)

  expect_identical(results[[1]], c("450"))

})

test_that("period between characters removed to keep characters together", {
  testing <- "This is a sentence. No.2"

  results <- tokenize_source(testing)

  expect_identical(results[[1]], c("this","is","a","sentence","no2"))

})

test_that("comma between characters removed to keep characters together", {
  testing <- "This, is a sentence. 5,000"

  results <- tokenize_source(testing)

  expect_identical(results[[1]], c("this","is","a","sentence","5000"))

})

test_that("dash removed and separates characters", {
  testing <- "dash-name, 1877-1777"

  results <- tokenize_source(testing)

  expect_identical(results[[1]], c("dash","name", "1877", "1777"))

})
