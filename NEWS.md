# highlightr 2.0.1

* `collocation_frequency()` arguments of `n_bands`, and `band_width` described in 
highlightr vignette
* `highlighted_text()` updated to appropriately recognize "&"
* `collocation_frequency()` updated to appropriately recognize "_"

# highlightr 2.0.0

* `collocation_plot()` updated to accept inputs not generated from `collocation_frequency()`

* `collocation_frequency()` (formerly transcript_frequency()) restructured to be main input,

* `collocate_comments()`, `collocate_comments_fuzzy()`, `tokenize_source()`, 
and `tokenize_derivative()` are now internal functions

*`transcript_frequency()` updated to appropriately recognize "+","=", ".extension"

# highlightr 1.2.0

* Providing instructions on how to save highlighted output to .html file

* Correcting `wiki_pages` description with correct number of rows

* Listing packages necessary for creating `wiki_pages` object

* Adding option to specify n-gram width in `collocate_comments_fuzzy`

* Adding comments to example scripts and further description for collocation functions

# highlightr 1.1.2

* Remove dependency on `fuzzyjoin` package, and use `zoomerjoin` package instead

* Change Levenshtein distance calculation in fuzzy joins to Jaccard distance

* Re-compute fuzzy weights based on new distance calculation

# highlightr 1.0.2

* Clarified wording in vignettes

* Fixed computation issue in collocations not of length 5

* Fixed merge issue with special characters

* Replaced non-ascii characters in datasets

# highlightr 1.0.0

* Initial CRAN submission.
