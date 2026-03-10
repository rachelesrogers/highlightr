# Mapping Collocation Frequency to Source Document

This function provides the frequency of collocations in comments that
correspond to the provided source document.

## Usage

``` r
collocation_frequency(
  transcript,
  transcript_token,
  note_token,
  collocate_length = 5,
  fuzzy = FALSE,
  n_bands = 50,
  threshold = 0.7,
  n_gram_width = 4
)
```

## Arguments

- transcript:

  transcript document

- transcript_token:

  transcript token to act as baseline for notes, resulting from
  [`tokenize_source()`](https://rachelesrogers.github.io/highlightr/reference/tokenize_source.md)

- note_token:

  tokenized document of notes, resulting from
  [`tokenize_derivative()`](https://rachelesrogers.github.io/highlightr/reference/tokenize_derivative.md)

- collocate_length:

  the length of the collocation. Default is 5

- fuzzy:

  whether or not to use fuzzy matching in collocation calculations

- n_bands:

  number of bands used in MinHash algorithm passed to
  [`zoomerjoin::jaccard_right_join()`](https://beniaminogreen.github.io/zoomerjoin/reference/jaccard-joins.html).
  Default is 50

- threshold:

  Jaccard distance threshold to be considered a match passed to
  [`zoomerjoin::jaccard_right_join()`](https://beniaminogreen.github.io/zoomerjoin/reference/jaccard-joins.html).
  Default is 0.7

- n_gram_width:

  width of n-grams used in Jaccard distance calculation passed to
  [`zoomerjoin::jaccard_right_join()`](https://beniaminogreen.github.io/zoomerjoin/reference/jaccard-joins.html).
  Default is 4

## Value

a dataframe of the transcript document with collocation values by word

## Details

Collocations are sequences of words present in the source document. For
example, the phrase "the blue bird flies" contains one collocation of
length 4 ("the blue bird flies"), two collocations of length 3 ("the
blue bird" and "blue bird flies"), and three collocations of length 2
("the blue", "blue bird", and "bird flies"). This function counts the
number of corresponding phrases in the 'notes', or the derivative
documents. When fuzzy matching is included, indirect matches are
included with a weight of (n\*d)/m, where n is the frequency of the
fuzzy collocation, d is the Jaccard similarity between the transcript
and note collocation, and m is the number of closest matches for the
note collocation.

## Examples

``` r
# Tokenize the derivative document
toks_comment <- tokenize_derivative(comment_example, text_column="Notes")
# Tokenize source document
toks_source <- tokenize_source(transcript_example)
# Merge frequencies with source document to provide averages by word and correct formatting
merged_frequency <- collocation_frequency(transcript_example, toks_source, toks_comment)
```
