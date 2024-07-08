test_that("html tags removed", {
  testing <- data.frame(text =
                          "<i> The review </i>. text with <br> a page break.<b>tag without spaces</b>.<font color='#9900FF'> color </font>")

  results <- token_transcript(testing)

  expect_identical(results[[1]], c("the", "review", "text", "with", "a", "page", "break",
                                   "tag", "without", "spaces", "color"))

})
