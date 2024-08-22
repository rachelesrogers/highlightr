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
