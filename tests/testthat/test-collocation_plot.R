Sys.setenv("OMP_THREAD_LIMIT" = 1)

test_that("testing html tags", {
  transcript_test <- data.frame("<i>This </i> <b>is</b> a<br> test.")
  collocation_test <- data.frame(Notes = c("this is a test", "this is a test", "is a test", "is a test", "a test", "a test"))

  toks_comment <- tokenize_derivative(collocation_test, text_column = "Notes")
  toks_source <- tokenize_source(transcript_test)

  frequency_test <- collocation_frequency(transcript_test, toks_source, toks_comment, collocate_length=2)
  freq_plot <- collocation_plot(frequency_test)

  expect_identical(freq_plot$build$data[[1]]$label, c("<i>","This", "</i>", "<b>",
  "is","</b>", "a","<br>", "test."))

  expect_equal(max(freq_plot$freq$frequency), 6)

  expect_equal(min(freq_plot$freq$frequency), 0)
})

test_that("dash check", {

  transcript_test <- data.frame("This - is a - test.")

  collocation_test <- data.frame(Notes = c("this is a test", "this is a test",
                                           "is a test", "is a test", "a test", "a test"))
  toks_comment <- tokenize_derivative(collocation_test, text_column = "Notes")
  toks_source <- tokenize_source(transcript_test)

  frequency_test <- collocation_frequency(transcript_test, toks_source, toks_comment, collocate_length=2)
  freq_plot <- collocation_plot(frequency_test)

  expect_identical(freq_plot$build$data[[1]]$label, c("This","-","is","a","-","test."))
})
