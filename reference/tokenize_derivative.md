# Tokenize comments

This function tokenizes comments that are to be used in
[`collocation_frequency()`](https://rachelesrogers.github.io/highlightr/reference/collocation_frequency.md)

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
# Tokenize the derivative document
toks_comment <- tokenize_derivative(comment_example, text_column="Notes")
```
