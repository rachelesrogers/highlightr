test_that("html tags work", {

  transcript_test <- data.frame(text="<i>This </i> <b>is</b> a<br> test.")
  collocation_test <- data.frame(word_number=1:4, col_1=c(2,4,6, NA), col_2=c(NA, 2, 4, 6),
                                 to_merge = c("this", "is", "a", "test"),
                                 collocation= c("this is", "is a", "a test", NA))
  frequency_test <- transcript_frequency(transcript_test, collocation_test)
  freq_plot <- collocation_plot(frequency_test)
  test_highlight <- highlighted_text(freq_plot)

  answer <- "<div>  0 <div style=\"\n    height: 20px;\n    width: 200px;\n    display: inline-block;\n    background: linear-gradient(45deg, #F251FC , #F8FF1B );\"> </div> 6  </div> <i><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FF95C3,#FF95C3) \">This&nbsp;</div></i><b><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FF95C3,#FFB2A5) \">is&nbsp;</div></b><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFB2A5,#FFE65E) \">a&nbsp;</div><br><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFE65E,#F8FF1B) \">test.&nbsp;</div>"
  expect_identical(test_highlight, answer)
})

test_that("dash check", {

  transcript_test <- data.frame(text="This - is a - test.")
  collocation_test <- data.frame(word_number=1:4, col_1=c(2,4,6, NA), col_2=c(NA, 2, 4, 6),
                                 to_merge = c("this", "is", "a", "test"),
                                 collocation= c("this is", "is a", "a test", NA))
  frequency_test <- transcript_frequency(transcript_test, collocation_test)
  freq_plot <- collocation_plot(frequency_test)
  test_highlight <- highlighted_text(freq_plot)

  answer <- "<div>  0 <div style=\"\n    height: 20px;\n    width: 200px;\n    display: inline-block;\n    background: linear-gradient(45deg, #F251FC , #F8FF1B );\"> </div> 6  </div> <div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FF95C3,#FF95C3) \">This&nbsp;</div><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background-color: #FF95C3 \">-&nbsp;</div><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FF95C3,#FFB2A5) \">is&nbsp;</div><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFB2A5,#FFE65E) \">a&nbsp;</div><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background-color: #FFE65E \">-&nbsp;</div><div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFE65E,#F8FF1B) \">test.&nbsp;</div>"
  expect_identical(test_highlight, answer)
})
