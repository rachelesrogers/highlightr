# Tokenize comments

This function tokenizes comments that are to be used in
[`collocate_comments_fuzzy()`](https://rachelesrogers.github.io/highlightr/reference/collocate_comments_fuzzy.md)
or
[`collocate_comments()`](https://rachelesrogers.github.io/highlightr/reference/collocate_comments.md)

## Usage

``` r
token_comments(comment_document)
```

## Arguments

- comment_document:

  document containing notes by individual, where the column containing
  the notes is named page_notes

## Value

tokenized comments

## Examples

``` r
# Rename relevant column to page_notes in the derivative document
comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
# Tokenize the derivative document
toks_comment <- token_comments(comment_example_rename)
```
