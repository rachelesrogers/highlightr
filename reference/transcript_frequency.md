# Mapping Collocation Frequency to Transcript Document

This function connects the collocation frequency calculated in
[`collocate_comments_fuzzy()`](https://rachelesrogers.github.io/highlightr/reference/collocate_comments_fuzzy.md)
to the base transcript.

## Usage

``` r
transcript_frequency(transcript, collocate_object)
```

## Arguments

- transcript:

  transcript document

- collocate_object:

  collocation object (returned from
  [`collocate_comments_fuzzy()`](https://rachelesrogers.github.io/highlightr/reference/collocate_comments_fuzzy.md)
  or
  [`collocate_comments()`](https://rachelesrogers.github.io/highlightr/reference/collocate_comments.md))

## Value

a dataframe of the transcript document with collocation values by word

## Examples

``` r
# Tokenize the derivative document
toks_comment <- tokenize_derivative(comment_example, text_column="Notes")
# Tokenize source document
toks_source <- tokenize_source(transcript_example)
# Compute collocation frequencies
collocation_object <- collocate_comments(toks_source, toks_comment)
# Merge frequencies with source document to provide averages by word and correct formatting
merged_frequency <- transcript_frequency(transcript_example, collocation_object)
```
