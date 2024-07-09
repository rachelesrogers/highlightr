test_that("size 2 collocation works", {
  transcript_test <- data.frame(text="This is a test.")
  collocation_test <- data.frame(word_number=1:4, col_1=c(2,4,6, NA), col_2=c(NA, 2, 4, 6),
                                 to_merge = c("this", "is", "a", "test"),
                                 collocation= c("this is", "is a", "a test", NA))
  transcript_test <- transcript_frequency(transcript_test, collocation_test)

  expect_identical(dim(transcript_test), c(4L, 14L))

  expect_identical(transcript_test$Freq, c(2,3,5,6))

})

test_that("removing html tags works", {
  transcript_test <- data.frame(text="<i>This <\\i> <b>is</b> a<br> test.")
  collocation_test <- data.frame(word_number=1:4, col_1=c(2,4,6, NA), col_2=c(NA, 2, 4, 6),
                                 to_merge = c("this", "is", "a", "test"),
                                 collocation= c("this is", "is a", "a test", NA))
  transcript_test <- transcript_frequency(transcript_test, collocation_test)

  expect_identical(dim(transcript_test), c(4L, 14L))

  expect_identical(transcript_test$Freq, c(2,3,5,6))

})