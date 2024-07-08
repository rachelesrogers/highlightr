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
