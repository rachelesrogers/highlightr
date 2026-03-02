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
# Rename relevant column to page_notes in the derivative document
comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
# Tokenize the derivative document
toks_comment <- tokenize_derivative(comment_example_rename)
# Rename relevant column in the source document to text
transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
# Tokenize source document
toks_source <- tokenize_source(as.character(transcript_example))
# Compute collocation frequencies
collocation_object <- collocate_comments(toks_source, toks_comment)
#> Joining with `by = join_by(tolower.unlist.descript_ngrams..)`
#> Joining with `by = join_by(collocation)`
#> Joining with `by = join_by(word_number)`
# Merge frequencies with source document to provide averages by word and correct formatting
merged_frequency <- transcript_frequency(as.character(transcript_example), collocation_object)
#> Joining with `by = join_by(to_merge)`
#> Joining with `by = join_by(., lines, n_words, words, word_num, word_length,
#> x_coord, to_merge, stanza_freq, word_number)`
```
