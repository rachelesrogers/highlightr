test_that("there are 5 collocations by default", {
  comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
  toks_comment <- token_comments(comment_example_rename)
  transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
  toks_transcript <- token_transcript(transcript_example_rename)
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment)

  expect_identical(grep("col_",colnames(collocation_object), value=TRUE),
                   c("col_1","col_2","col_3","col_4","col_5"))
})

test_that("6 collocations results in right number of columns", {
  comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
  toks_comment <- token_comments(comment_example_rename)
  transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
  toks_transcript <- token_transcript(transcript_example_rename)
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 6)
  default_collocation <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 5)

  expect_identical(grep("col_",colnames(collocation_object), value=TRUE),
                   c("col_1","col_2","col_3","col_4","col_5", "col_6"))

  expect_identical(default_collocation$to_merge, collocation_object$to_merge)
})

test_that("2 collocations results in right number of columns", {
  comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
  toks_comment <- token_comments(comment_example_rename)
  transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
  toks_transcript <- token_transcript(transcript_example_rename)
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 2)

  expect_identical(grep("col_",colnames(collocation_object), value=TRUE),
                   c("col_1","col_2"))
})

test_that("correct output when nothing meets the fuzzy threshold",{
  rep_test <-
    data.frame(ID=1:6,
               Notes=c(rep("in an example", 6)))
  comment_example_rename <- dplyr::rename(rep_test, page_notes=Notes)
  toks_comment <- token_comments(comment_example_rename)
  dash_transcript <- data.frame(Text="in an example - here is a dash space
                                  in the year 1892-1777 dash-name did this")
  transcript_example_rename <- dplyr::rename(dash_transcript, text=Text)
  toks_transcript <- token_transcript(transcript_example_rename)
  collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment, collocate_length = 2)
  frequency_test <- transcript_frequency(transcript_example_rename, collocation_object)

  expect_identical(frequency_test$Freq[1:3], c(6,6,3))
})
