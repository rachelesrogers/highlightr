test_that("html tags removed", {
  testing <- data.frame(text =
                          "<i> The review </i>. text with <br> a page break.<b>tag without spaces</b>.<font color='#9900FF'> color </font>")

  results <- token_transcript(testing)

  expect_identical(results[[1]], c("the", "review", "text", "with", "a", "page", "break",
                                   "tag", "without", "spaces", "color"))

})

test_that("dollar sign removed", {
  testing <- data.frame(ID = c(1),
                        page_notes = c("$4.50"))

  results <- token_transcript(testing)

  expect_identical(results[[1]], c("4.50"))

})
