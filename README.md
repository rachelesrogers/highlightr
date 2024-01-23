
<!-- README.md is generated from README.Rmd. Please edit that file -->

# highlightr

<!-- badges: start -->
<!-- badges: end -->

This package can be used to create a highlighted source document based
on the frequency of phrases found in single or multiple note sheets. The
goal of this method is to indicate the portions of the source document
that individuals felt was most worth copying into notes, based on phrase
frequency. The inputs necessary for this procedure are a notes document
and a source document. The output will be HTML code for generating the
highlighted text.

## Acknowledgements

This work was funded (or partially funded) by the Center for Statistics
and Applications in Forensic Evidence (CSAFE) through Cooperative
Agreements 70NANB15H176 and 70NANB20H019 between NIST and Iowa State
University, which includes activities carried out at Carnegie Mellon
University, Duke University, University of California Irvine, University
of Virginia, West Virginia University, University of Pennsylvania,
Swarthmore College and University of Nebraska, Lincoln.

## Installation

You can install the development version of highlightr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rachelesrogers/highlightr")
```

## Example

``` r
library(highlightr)
comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
toks_comment <- token_comments(comment_example_rename)
transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
toks_transcript <- token_transcript(transcript_example_rename)
collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment)
#> Joining with `by = join_by(tolower.unlist.descript_ngrams..)`
#> Joining with `by = join_by(collocation)`
#> Joining with `by = join_by(collocation)`
#> Joining with `by = join_by(collocation.y)`
#> Joining with `by = join_by(collocation)`
#> Joining with `by = join_by(word_number)`
merged_frequency <- transcript_frequency(transcript_example_rename, collocation_object)
#> Joining with `by = join_by(to_merge)`
#> Joining with `by = join_by(lines, n_words, words, word_num, word_length,
#> x_coord, to_merge, stanza_freq, word_number)`
freq_plot <- collocation_plot(merged_frequency)
page_highlight <- highlighted_text(freq_plot, merged_frequency)
```

``` r
page_highlight
```

\[1\] “

<div>

0 \<div style="height: 20px;width: 200px;display:
inline-block;background: linear-gradient(45deg, \#F8FF1B , \#F251FC
);"\>

</div>

46
</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,,#FEE95A) \">In&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FEE95A,#FEE85A) \">this&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FEE85A,#FFE85B) \">case,&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFE85B,#FFE55F) \">the&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFE55F,#FFE363) \">defendant&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFE363,#FFD874) \">-&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFD874,#FFD874) \">Richard&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFD874,#FFCE82) \">Cole&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFCE82,#FFC48F) \">-&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFC48F,#FFC48F) \">has&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFC48F,#FFBB9A) \">been&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFBB9A,#FFB0A8) \">charged&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFB0A8,#FFAAAE) \">with&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFAAAE,#FF9BBE) \">willfully&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FF9BBE,#FF87D1) \">discharging&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FF87D1,#FB76E1) \">a&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FB76E1,#F764EF) \">firearm&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#F764EF,#F251FC) \">in&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#F251FC,#F660F2) \">a&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#F660F2,#FB76E0) \">place&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FB76E0,#FF88D1) \">of&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FF88D1,#FF9CBD) \">business.&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FF9CBD,#FFAFA9) \">This&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFAFA9,#FFB89E) \">crime&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFB89E,#FFBF96) \">is&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFBF96,#FFC58E) \">a&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFC58E,#FFCB87) \">felony.&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFCB87,#FFCF82) \">Mr.&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFCF82,#FFCB87) \">Cole&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFCB87,#FFCA88) \">has&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFCA88,#FFC989) \">pleaded&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFC989,#FFC88A) \">not&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFC88A,#FFD27E) \">guilty&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFD27E,#FFDE6C) \">to&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFDE6C,#FFE65F) \">the&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FFE65F,#FDEE50) \">charge.&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FDEE50,#FBF53F) \">You&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF540) \">will&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF540,#FBF540) \">now&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF540,#FBF540) \">read&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF540,#FBF53F) \">a&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">summary&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">of&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">the&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">case.&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">This&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53E) \">summary&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53E,#FBF53E) \">was&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53E,#FBF53E) \">prepared&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53E,#FBF53F) \">by&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">an&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">objective&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">court&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">clerk.&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">It&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">describes&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">select&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">evidence&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">that&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">was&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">presented&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">at&nbsp;</div>
<div style=\"display: inline-block; padding:0px;\n  margin-left:-5px; background: linear-gradient(to right,#FBF53F,#FBF53F) \">trial.&nbsp;</div>

”
