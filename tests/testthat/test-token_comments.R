test_that("html tags removed", {
  testing <- data.frame(ID = c(1,2),
                        page_notes = c("<i> The review </i>.",
                                       "text with </br> a page break",
                                       "<b>tag without spaces</b>",
                                       "<font color='#9900FF'> color </font>"))

  results <- token_comments(testing)

  expect_identical(results[[1]], c("the", "review"))

  expect_identical(results[[2]], c("text", "with", "a", "page", "break"))

  expect_identical(results[[3]], c("tag", "without", "spaces"))

  expect_identical(results[[4]], "color")

})

test_that("dollar sign removed", {
  testing <- data.frame(ID = c(1),
                        page_notes = c("$4.50"))

  results <- token_comments(testing)

  expect_identical(results[[1]], c("450"))

})

test_that("period between characters removed to keep characters together", {
  testing <- data.frame(ID = c(1),
                        page_notes = c("This is a sentence. No.2"))

  results <- token_comments(testing)

  expect_identical(results[[1]], c("this","is","a","sentence","no2"))

})

test_that("comma between characters removed to keep characters together", {
  testing <- data.frame(ID = c(1),
                        page_notes = c("This, is a sentence. 5,000"))

  results <- token_comments(testing)

  expect_identical(results[[1]], c("this","is","a","sentence","5000"))

})

test_that("dash removed and separates characters", {
  testing <- data.frame(ID = c(1,2),
                        page_notes = c("dash-name","1877-1777"))

  results <- token_comments(testing)

  expect_identical(results[[1]], c("dash","name"))
  expect_identical(results[[2]], c("1877","1777"))

})
