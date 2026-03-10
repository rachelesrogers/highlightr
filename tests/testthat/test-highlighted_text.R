Sys.setenv("OMP_THREAD_LIMIT" = 1)

test_that("html tags work", {

  transcript_test <- data.frame("<i>This </i> <b>is</b> a<br> test.")
  collocation_test <- data.frame(Notes = c("this is a test", "this is a test", "is a test", "is a test", "a test", "a test"))

  toks_comment <- tokenize_derivative(collocation_test, text_column = "Notes")
  toks_source <- tokenize_source(transcript_test)

  frequency_test <- collocation_frequency(transcript_test, toks_source, toks_comment, collocate_length=2)
  freq_plot <- collocation_plot(frequency_test)
  test_highlight <- highlighted_text(freq_plot)

  answer <- "<div>  0 <div style=\"\n    height: 20px;\n    width: 200px;\n    display: inline-block;\n    background: linear-gradient(45deg, #F251FC , #F8FF1B );\"> </div> 6  </div> <i><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FF95C3,#FF95C3) \">This&nbsp;</div></i><b><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FF95C3,#FFB2A5) \">is&nbsp;</div></b><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFB2A5,#FFE65E) \">a&nbsp;</div><br><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFE65E,#F8FF1B) \">test.&nbsp;</div>"
  expect_identical(test_highlight, answer)
})

test_that("dash check", {

  transcript_test <- data.frame("This - is a - test.")

  collocation_test <- data.frame(Notes = c("this is a test", "this is a test",
                                           "is a test", "is a test", "a test", "a test"))
  toks_comment <- tokenize_derivative(collocation_test, text_column = "Notes")
  toks_source <- tokenize_source(transcript_test)

  frequency_test <- collocation_frequency(transcript_test, toks_source, toks_comment, collocate_length=2)
  freq_plot <- collocation_plot(frequency_test)
  test_highlight <- highlighted_text(freq_plot)

  answer <- "<div>  0 <div style=\"\n    height: 20px;\n    width: 200px;\n    display: inline-block;\n    background: linear-gradient(45deg, #F251FC , #F8FF1B );\"> </div> 6  </div> <div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FF95C3,#FF95C3) \">This&nbsp;</div><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background-color: #FF95C3 \">-&nbsp;</div><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FF95C3,#FFB2A5) \">is&nbsp;</div><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFB2A5,#FFE65E) \">a&nbsp;</div><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background-color: #FFE65E \">-&nbsp;</div><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFE65E,#F8FF1B) \">test.&nbsp;</div>"
  expect_identical(test_highlight, answer)
})
