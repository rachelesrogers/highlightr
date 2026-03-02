# Tokenize comments

This function tokenizes comments that are to be used in
[`collocate_comments_fuzzy()`](https://rachelesrogers.github.io/highlightr/reference/collocate_comments_fuzzy.md)
or
[`collocate_comments()`](https://rachelesrogers.github.io/highlightr/reference/collocate_comments.md)

## Usage

``` r
tokenize_derivative(derivative_document, text_column)
```

## Arguments

- derivative_document:

  data frame containing derivative documents, where each row represents
  a document

- text_column:

  string indicating the name of the column containing derivative text

## Value

tokenized comments

## Examples

``` r
# Rename relevant column to page_notes in the derivative document
comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
# Tokenize the derivative document
toks_comment <- tokenize_derivative(comment_example, text_column="Notes")
```
