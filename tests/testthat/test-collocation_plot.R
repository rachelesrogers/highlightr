test_that("testing html tags", {
  transcript_test <- data.frame(text="<i>This </i> <b>is</b> a<br> test.")
  collocation_test <- data.frame(word_number=1:4, col_1=c(2,4,6, NA), col_2=c(NA, 2, 4, 6),
                                 to_merge = c("this", "is", "a", "test"),
                                 collocation= c("this is", "is a", "a test", NA))
  frequency_test <- transcript_frequency(transcript_test, collocation_test)
  freq_plot <- collocation_plot(frequency_test)

  expect_identical(freq_plot$build$data[[1]]$label, c("<i>","This", "</i>", "<b>",
  "is","</b>", "a","<br>", "test."))

  expect_equal(max(freq_plot$freq$frequency), 6)

  expect_equal(min(freq_plot$freq$frequency), 0)
})

test_that("dash check", {

  transcript_test <- data.frame(text="This - is a - test.")
  collocation_test <- data.frame(word_number=1:4, col_1=c(2,4,6, NA), col_2=c(NA, 2, 4, 6),
                                 to_merge = c("this", "is", "a", "test"),
                                 collocation= c("this is", "is a", "a test", NA))
  frequency_test <- transcript_frequency(transcript_test, collocation_test)
  freq_plot <- collocation_plot(frequency_test)

  expect_identical(freq_plot$build$data[[1]]$label, c("This","-","is","a","-","test."))
})
