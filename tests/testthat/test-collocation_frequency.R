testthat::skip_on_cran()
Sys.setenv("OMP_THREAD_LIMIT" = 1)

test_that("size 2 collocation works", {
  collocation_test <- data.frame(ID = c("source", 1:6),
                                 Notes = c("This is a test.", "this is a test", "this is a test", "is a test", "is a test", "a test", "a test"))

  toks_comment <- tokenize_derivative(collocation_test, source_row=1, text_column = "Notes")
  toks_source <- tokenize_source(collocation_test, source_row=1, text_column="Notes")

  frequency_test <- collocation_frequency(collocation_test[which(collocation_test$ID=="source"),][["Notes"]], toks_source, toks_comment, collocate_length=2)

  expect_identical(dim(frequency_test), c(4L, 14L))

  expect_identical(frequency_test$Freq, c(2,3,5,6))

})

test_that("removing html tags works", {
  collocation_test <- data.frame(ID = c("source",1:6),
                                 Notes = c("<i>This </i> <b>is</b> a<br> test.", "this is a test", "this is a test", "is a test", "is a test", "a test", "a test"))

  toks_comment <- tokenize_derivative(collocation_test, source_row=1, text_column = "Notes")
  toks_source <- tokenize_source(collocation_test, source_row=1, text_column="Notes")

  frequency_test <- collocation_frequency(collocation_test[which(collocation_test$ID=="source"),][["Notes"]], toks_source, toks_comment, collocate_length=2)

  expect_identical(dim(frequency_test), c(9L, 14L))

  expect_identical(frequency_test$Freq, c(NaN, 2,NaN, NaN, 3,NaN, 5, NaN, 6))

  expect_identical(frequency_test$to_merge, c("","this","","","is","","a","","test"))

})

test_that("dash check", {

  collocation_test <- data.frame(ID = c("source",1:6),
                                 Notes = c("This - is a - test.", "this is a test", "this is a test",
                                           "is a test", "is a test", "a test", "a test"))
  toks_comment <- tokenize_derivative(collocation_test, source_row=1, text_column = "Notes")
  toks_source <- tokenize_source(collocation_test, source_row=1, text_column="Notes")

  frequency_test <- collocation_frequency(collocation_test[which(collocation_test$ID=="source"),][["Notes"]], toks_source, toks_comment, collocate_length=2)

  expect_identical(frequency_test$to_merge, c("this","","is","a","","test"))

  expect_identical(frequency_test$Freq, c(2,NaN, 3, 5, NaN, 6))
})

test_that("values are given to the last observations",{

  toks_comment <- tokenize_derivative(notepad_example, source_row=which(notepad_example$ID=="source"), text_column="Text")
  toks_source <- tokenize_source(notepad_example, source_row=which(notepad_example$ID=="source"), text_column="Text")

  freq_test <- collocation_frequency(notepad_example[which(notepad_example$ID=="source"),][["Text"]], toks_source, toks_comment,
                                     collocate_length = 6)

  expect_true(all(!is.na(tail(freq_test$col_6, n=5))))
  expect_true(all(!is.na(tail(freq_test$Freq))))


})

test_that("symbols are used correctly for merging",{
  symbol_test <-
    data.frame(ID=c("source",1:7),
               Notes=c("They/them were the pronouns they used when they paid $4.50
                                  to use a No.2 pencil. What… is how they started their speech; there
                                  were 5,000 people",
                       "They paid $4.50", "There were 5,000 people", "Use a No.2 pencil",
                       "they/them were the pronouns they used", "What… they paid $4.50",
                       "They paid $4.50, and there were 5,000 people who used a No.2 pencil",
                       "they/them were the pronouns they used when they paid $4.50"))

  toks_comment <- tokenize_derivative(symbol_test, source_row=1, text_column="Notes")

  toks_transcript <- tokenize_source(symbol_test, source_row=1, text_column="Notes")
  collocation_object <- collocate_comments(toks_transcript, toks_comment, collocate_length = 2)
  frequency_test <- collocation_frequency(symbol_test[1,][["Notes"]], toks_transcript, toks_comment, collocate_length = 2)

  expect_identical(collocation_object$col_1, frequency_test$col_1)

}
          )

test_that("dashes are used correctly for merging",{
  dash_test <-
    data.frame(ID=c("source",1:6),
               Notes=c("in an example - here is a dash space
                                  in the year 1892-1777 dash-name did this",
                       "dash-name did this", "year 1892-1777 was significant", "another dash-name did this",
                       "in year 1892-1777 dash-name did another thing", "in an example - here is a dash space",
                       "in an example - here is a dash space with dash-name and year 1892-1777"))

  toks_comment <- tokenize_derivative(dash_test, source_row=1, text_column="Notes")

  toks_transcript <- tokenize_source(dash_test, source_row=1, text_column="Notes")
  frequency_test <- collocation_frequency(dash_test[1,][["Notes"]], toks_transcript, toks_comment, n_bands=5000, threshold=0.4, collocate_length=2)

  expect_identical(frequency_test$to_merge, c("in","an","example","","here","is","a","dash","space","in",
                   "the","year","1892","","1777","dash","","name","did","this"))

}
)


test_that("colons are removed correctly for merging",{
  colon_test <-
    data.frame(ID=c("source",1:6),
               Notes=c("in an example: here is a colon space
                                  in the year 1892:1777 wɔːlz did this",
                       "wɔːlz did this", "year 1892:1777 was significant", "another wɔːlz did this",
                       "in year 1892:1777 wɔːlz did another thing", "in an example: here is a colon space",
                       "in an example: here is a colon space with wɔːlz and year 1892:1777"))

  toks_comment <- tokenize_derivative(colon_test, source_row=1, text_column="Notes")
  toks_transcript <- tokenize_source(colon_test, source_row=1, text_column="Notes")
  frequency_test <- collocation_frequency(colon_test[1,][["Notes"]], toks_transcript, toks_comment, collocate_length = 2)

  expect_identical(frequency_test$to_merge, c("in","an","example","here","is","a","colon","space","in",
                                              "the","year","18921777","wɔlz","did","this"))

}
)

test_that("... are treated consistently",{
  elipses_test <-
    data.frame(ID=c("source",1:5),
               Notes=c("in an example... who ... did this it...was significant. another... did another thing",
                       "who... did this", "it...was significant", "another... did this",
                       "...did another thing",
                       "in an example... here is a...with...another thing"))
  toks_comment <- tokenize_derivative(elipses_test, source_row=1, text_column="Notes")
  toks_transcript <- tokenize_source(elipses_test, source_row=1, text_column="Notes")
  frequency_test <- collocation_frequency(elipses_test[1,][["Notes"]], toks_transcript, toks_comment, collocate_length = 2)

  expect_identical(frequency_test$to_merge, c("in","an","example","who","did","this","it","was","significant",
                                              "another","did","another","thing"))

}
)

test_that("math symbols are used correctly for merging",{
  symbol_test <-
    data.frame(ID=c("source",1:5),
               Notes=c("They added 2 + 3 = 5 in an .html with the function add_numbers()",
                       "They added 2 + 3 = 5", "2+3=5", "saved as an .html",
                       "the function was add_numbers()", "they used add_numbers()"))
  toks_comment <- tokenize_derivative(symbol_test, source_row=1, text_column="Notes")
  toks_transcript <- tokenize_source(symbol_test, source_row=1, text_column="Notes")
  collocation_object <- collocate_comments(toks_transcript, toks_comment, collocate_length = 2)
  frequency_test <- collocation_frequency(symbol_test[1,][["Notes"]], toks_transcript, toks_comment, collocate_length = 2)

  expect_identical(collocation_object$col_1, frequency_test$col_1)

}
)


test_that("there are 5 collocations by default", {
  toks_comment <- tokenize_derivative(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  toks_transcript <- tokenize_source(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment)

  expect_identical(grep("col_",colnames(collocation_object), value=TRUE),
                   c("col_1","col_2","col_3","col_4","col_5"))
})

test_that("6 collocations results in right number of columns", {
  toks_comment <- tokenize_derivative(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  toks_transcript <- tokenize_source(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 6)
  default_collocation <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 5)

  expect_identical(grep("col_",colnames(collocation_object), value=TRUE),
                   c("col_1","col_2","col_3","col_4","col_5", "col_6"))

  expect_identical(default_collocation$to_merge, collocation_object$to_merge)
})

test_that("2 collocations results in right number of columns", {
  toks_comment <- tokenize_derivative(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  toks_transcript <- tokenize_source(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 2)

  expect_identical(grep("col_",colnames(collocation_object), value=TRUE),
                   c("col_1","col_2"))
})

test_that("correct output when nothing meets the fuzzy threshold",{
  rep_test <-
    data.frame(ID=c("source",1:6),
               Notes=c("in an example - here is a dash space
                                  in the year 1892-1777 dash-name did this",
                       rep("in an example", 6)))
  toks_comment <- tokenize_derivative(rep_test, source_row=1, text_column = "Notes")
  toks_transcript <- tokenize_source(rep_test, source_row=1, text_column = "Notes")
  frequency_test <- collocation_frequency(rep_test[1,][["Notes"]], toks_transcript, toks_comment, collocate_length = 2,
                                          fuzzy=TRUE)

  expect_identical(frequency_test$Freq[1:3], c(6,6,3))
})

########### FUZZY MATCHING ##################

test_that("there are 5 collocations by default fuzzy", {
  toks_comment <- tokenize_derivative(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  toks_transcript <- tokenize_source(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment)

  expect_identical(grep("col_",colnames(collocation_object), value=TRUE),
                   c("col_1","col_2","col_3","col_4","col_5"))
})

test_that("6 collocations results in right number of columns fuzzy", {
  toks_comment <- tokenize_derivative(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  toks_transcript <- tokenize_source(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 6)
  default_collocation <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 5)

  expect_identical(grep("col_",colnames(collocation_object), value=TRUE),
                   c("col_1","col_2","col_3","col_4","col_5", "col_6"))

  expect_identical(default_collocation$to_merge, collocation_object$to_merge)
})

test_that("2 collocations results in right number of columns fuzzy", {
  toks_comment <- tokenize_derivative(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  toks_transcript <- tokenize_source(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 2)

  expect_identical(grep("col_",colnames(collocation_object), value=TRUE),
                   c("col_1","col_2"))
})

test_that("correct output when nothing meets the fuzzy threshold fuzzy",{
  rep_test <-
    data.frame(ID=c("source",1:6),
               Notes=c("in an example - here is a dash space
                                  in the year 1892-1777 dash-name did this",
                                  rep("in an example", 6)))
  toks_comment <- tokenize_derivative(rep_test, source_row = 1, text_column = "Notes")
  toks_transcript <- tokenize_source(rep_test, source_row = 1, text_column = "Notes")
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 2)
  frequency_test <- collocation_frequency(rep_test[1,][["Notes"]], toks_transcript, toks_comment, collocate_length = 2,
                                          fuzzy=TRUE)

  expect_identical(frequency_test$Freq[1:3], c(6,6,3))
})

############# NONFUZZY MATCHING ###############
Sys.setenv("OMP_THREAD_LIMIT" = 1)

test_that("there are 5 collocations by default nonfuzzy", {
  toks_comment <- tokenize_derivative(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  toks_transcript <- tokenize_source(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  collocation_object <- collocate_comments(toks_transcript, toks_comment)

  expect_identical(grep("col_",colnames(collocation_object), value=TRUE),
                   c("col_1","col_2","col_3","col_4","col_5"))
})

test_that("6 collocations results in right number of columns and to_merge renders correctly nonfuzzy", {
  toks_comment <- tokenize_derivative(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  toks_transcript <- tokenize_source(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  collocation_object <- collocate_comments(toks_transcript, toks_comment, collocate_length = 6)
  default_collocation <- collocate_comments(toks_transcript, toks_comment, collocate_length = 5)

  expect_identical(grep("col_",colnames(collocation_object), value=TRUE),
                   c("col_1","col_2","col_3","col_4","col_5", "col_6"))

  expect_identical(default_collocation$to_merge, collocation_object$to_merge)
})

test_that("2 collocations results in right number of columns nonfuzzy", {

  toks_comment <- tokenize_derivative(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  toks_transcript <- tokenize_source(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")
  collocation_object <- collocate_comments(toks_transcript, toks_comment, collocate_length = 2)

  expect_identical(grep("col_",colnames(collocation_object), value=TRUE),
                   c("col_1","col_2"))
})

