Sys.setenv("OMP_THREAD_LIMIT" = 1)

test_that("testing html tags", {
  collocation_test <- data.frame(ID = c("source",1:6),
                                 Notes = c("<i>This </i> <b>is</b> a<br> test.", "this is a test", "this is a test", "is a test", "is a test", "a test", "a test"))


  frequency_test <- collocation_frequency(collocation_test, source_row=1, text_column = "Notes", collocate_length=2)
  freq_plot <- collocation_plot(frequency_test)

  expect_identical(freq_plot$build$data[[1]]$label, c("<i>","This", "</i>", "<b>",
  "is","</b>", "a","<br>", "test."))

  expect_equal(max(freq_plot$freq$frequency), 6)

  expect_equal(min(freq_plot$freq$frequency), 0)
})

test_that("dash check", {
  collocation_test <- data.frame(ID = c("source",1:6),
                                 Notes = c("This - is a - test.", "this is a test", "this is a test",
                                           "is a test", "is a test", "a test", "a test"))
  frequency_test <- collocation_frequency(collocation_test, source_row=1, text_column = "Notes", collocate_length=2)
  freq_plot <- collocation_plot(frequency_test)

  expect_identical(freq_plot$build$data[[1]]$label, c("This","-","is","a","-","test."))
})

test_that("renaming", {
  collocation_test <- data.frame(writing = c("This", "is", "a",
                                             "test"),
                                 value = c(2,3,4,1),
                                 number = 1:4)
  freq_plot <- collocation_plot(collocation_test, values="value", order="number", text="writing")

  col_output <- collocation_test
  colnames(col_output) <- c("words", "frequency", "x_coord")
  expect_identical(freq_plot$build$data[[1]]$label, c("This", "is", "a", "test"))
  expect_identical(freq_plot$freq, col_output)
})
