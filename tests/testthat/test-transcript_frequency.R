test_that("size 2 collocation works", {
  transcript_test <- data.frame(text="This is a test.")
  collocation_test <- data.frame(word_number=1:4, col_1=c(2,4,6, NA), col_2=c(NA, 2, 4, 6),
                                 to_merge = c("this", "is", "a", "test"),
                                 collocation= c("this is", "is a", "a test", NA))
  frequency_test <- transcript_frequency(transcript_test, collocation_test)

  expect_identical(dim(frequency_test), c(4L, 14L))

  expect_identical(frequency_test$Freq, c(2,3,5,6))

})

test_that("removing html tags works", {
  transcript_test <- data.frame(text="<i>This </i> <b>is</b> a<br> test.")
  collocation_test <- data.frame(word_number=1:4, col_1=c(2,4,6, NA), col_2=c(NA, 2, 4, 6),
                                 to_merge = c("this", "is", "a", "test"),
                                 collocation= c("this is", "is a", "a test", NA))
  frequency_test <- transcript_frequency(transcript_test, collocation_test)

  expect_identical(dim(frequency_test), c(9L, 14L))

  expect_identical(frequency_test$Freq, c(NaN, 2,NaN, NaN, 3,NaN, 5, NaN, 6))

  expect_identical(frequency_test$to_merge, c("","this","","","is","","a","","test"))

})

test_that("dash check", {

  transcript_test <- data.frame(text="This - is a - test.")
  collocation_test <- data.frame(word_number=1:4, col_1=c(2,4,6, NA), col_2=c(NA, 2, 4, 6),
                                 to_merge = c("this", "is", "a", "test"),
                                 collocation= c("this is", "is a", "a test", NA))
  frequency_test <- transcript_frequency(transcript_test, collocation_test)

  expect_identical(frequency_test$to_merge, c("this","","is","a","","test"))

  expect_identical(frequency_test$Freq, c(2,NaN, 3, 5, NaN, 6))
})
