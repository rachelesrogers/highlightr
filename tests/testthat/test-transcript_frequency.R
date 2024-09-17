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

test_that("values are given to the last observations",{
  comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
  toks_comment <- token_comments(comment_example_rename)
  transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
  toks_transcript <- token_transcript(transcript_example_rename)
  collocation_object <- collocate_comments(toks_transcript, toks_comment, collocate_length = 6)
  transcript_example_rename <- dplyr::rename(transcript_example, text=Text)

  freq_test <- transcript_frequency(transcript_example_rename, collocation_object)

  expect_true(all(!is.na(tail(freq_test$col_6, n=5))))
  expect_true(all(!is.na(tail(freq_test$Freq))))


})

test_that("symbols are used correctly for merging",{
  symbol_test <-
    data.frame(ID=1:7,
               Notes=c("They paid $4.50", "There were 5,000 people", "Use a No.2 pencil",
                       "they/them were the pronouns they used", "What… they paid $4.50",
                       "They paid $4.50, and there were 5,000 people who used a No.2 pencil",
                       "they/them were the pronouns they used when they paid $4.50"))
  comment_example_rename <- dplyr::rename(symbol_test, page_notes=Notes)
  toks_comment <- token_comments(comment_example_rename)
  symbol_transcript <- data.frame(Text="They/them were the pronouns they used when they paid $4.50
                                  to use a No.2 pencil. What… is how they started their speech; there
                                  were 5,000 people")
  transcript_example_rename <- dplyr::rename(symbol_transcript, text=Text)
  toks_transcript <- token_transcript(transcript_example_rename)
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 2)
  frequency_test <- transcript_frequency(transcript_example_rename, collocation_object)

  expect_identical(collocation_object$col_1, frequency_test$col_1)

}
          )

test_that("dashes are used correctly for merging",{
  dash_test <-
    data.frame(ID=1:6,
               Notes=c("dash-name did this", "year 1892-1777 was significant", "another dash-name did this",
                       "in year 1892-1777 dash-name did another thing", "in an example - here is a dash space",
                       "in an example - here is a dash space with dash-name and year 1892-1777"))
  comment_example_rename <- dplyr::rename(dash_test, page_notes=Notes)
  toks_comment <- token_comments(comment_example_rename)
  dash_transcript <- data.frame(Text="in an example - here is a dash space
                                  in the year 1892-1777 dash-name did this")
  transcript_example_rename <- dplyr::rename(dash_transcript, text=Text)
  toks_transcript <- token_transcript(transcript_example_rename)
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 2)
  frequency_test <- transcript_frequency(transcript_example_rename, collocation_object)

  expect_identical(frequency_test$to_merge, c("in","an","example","","here","is","a","dash","space","in",
                   "the","year","1892","","1777","dash","","name","did","this"))

}
)


test_that("colons are removed correctly for merging",{
  colon_test <-
    data.frame(ID=1:6,
               Notes=c("wɔːlz did this", "year 1892:1777 was significant", "another wɔːlz did this",
                       "in year 1892:1777 wɔːlz did another thing", "in an example: here is a colon space",
                       "in an example: here is a colon space with wɔːlz and year 1892:1777"))
  comment_example_rename <- dplyr::rename(colon_test, page_notes=Notes)
  toks_comment <- token_comments(comment_example_rename)
  dash_transcript <- data.frame(Text="in an example: here is a colon space
                                  in the year 1892:1777 wɔːlz did this")
  transcript_example_rename <- dplyr::rename(dash_transcript, text=Text)
  toks_transcript <- token_transcript(transcript_example_rename)
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 2)
  frequency_test <- transcript_frequency(transcript_example_rename, collocation_object)

  expect_identical(frequency_test$to_merge, c("in","an","example","here","is","a","colon","space","in",
                                              "the","year","18921777","wɔlz","did","this"))

}
)

test_that("... are treated consistently",{
  elipses_test <-
    data.frame(ID=1:5,
               Notes=c("who... did this", "it...was significant", "another... did this",
                       "...did another thing",
                       "in an example... here is a...with...another thing"))
  comment_example_rename <- dplyr::rename(elipses_test, page_notes=Notes)
  toks_comment <- token_comments(comment_example_rename)
  elipses_transcript <- data.frame(Text="in an example... who ... did this it...was significant. another... did another thing")
  transcript_example_rename <- dplyr::rename(elipses_transcript, text=Text)
  toks_transcript <- token_transcript(transcript_example_rename)
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 2)
  frequency_test <- transcript_frequency(transcript_example_rename, collocation_object)

  expect_identical(frequency_test$to_merge, c("in","an","example","who","did","this","it","was","significant",
                                              "another","did","another","thing"))

}
)
