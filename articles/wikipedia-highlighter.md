# Wikipedia Highlighter Article

In a second example, we view previous versions of a Wikipedia article
(in this case, on the
[Highlighter](https://en.wikipedia.org/wiki/Highlighter)), in order to
see which parts are consistently included. This data includes the first
150 versions of the article, as well as the latest 150 versions of the
article, collected around 14 March, 2024. The data was gathered as
follows:

``` r

library(rvest)
library(dplyr)
library(purrr)
library(tibble)
library(stringr)

class_of_interest <- ".mw-content-ltr" ## ids are #id-name, classes are .class-name

# Finding newest 150 versions of Wikipedia's highlighter article
editurl <- "https://en.wikipedia.org/w/index.php?title=Highlighter&action=history&offset=&limit=150"
editclass_of_interest <- ".mw-changeslist-date"

# Save the urls of the full articles
url_list1 <- editurl %>%
  rvest::read_html() %>%
  rvest::html_nodes(editclass_of_interest) %>%
  purrr::map(., list()) %>%
  tibble::tibble(node = .) %>%
  dplyr::mutate(link = purrr::map_chr(node, html_attr, "href") %>% paste0("https://en.wikipedia.org", .))

# Finding oldest 150 versions of Wikipedia's highlighter article
editurl2 <- "https://en.wikipedia.org/w/index.php?title=Highlighter&action=history&dir=prev&limit=150"

# Save the urls of the full articles
url_list2 <- editurl2 %>%
  rvest::read_html() %>%
  rvest::html_nodes(editclass_of_interest) %>%
  purrr::map(., list()) %>%
  tibble::tibble(node = .) %>%
  dplyr::mutate(link = purrr::map_chr(node, html_attr, "href") %>% paste0("https://en.wikipedia.org", .))

# Combine url list
url_list <- rbind(url_list1, url_list2)

# create a data frame with the text of the documents
wiki_pages <- data.frame(page_notes = rep(NA, dim(url_list)[1]))

for (i in 1:dim(url_list)[1]){

  wiki_list <-  url_list$link[i] %>%
    rvest::read_html() %>%
    rvest::html_node(class_of_interest) %>%
    rvest::html_children() %>%
    purrr::map(., list()) %>%
    tibble::tibble(node = .) %>%
    dplyr::mutate(type = purrr::map_chr(node, html_name)) %>%
    dplyr::filter(type == "p") %>%
    dplyr::mutate(text = purrr::map_chr(node, html_text)) %>%
    dplyr::mutate(cleantext = stringr::str_remove_all(text, "\\[.*?\\]") %>% stringr::str_trim()) %>%
    plyr::summarise(cleantext = paste(cleantext, collapse = "<br> "))

  wiki_pages$page_notes[i] <- wiki_list$cleantext[1]

}
```

Note that the Wikipedia version text is placed in a column labelled
“page_notes”, as needed for the comment functions in this package. This
allows for the comments to be tokenized, or separated into words.

``` r
library(highlightr)

# tokenize comments 
toks_comment <- tokenize_derivative(highlightr::wiki_pages, text_column = "page_notes")
```

The latest version of the article is the first row in the dataset, and
can be used as the “transcript text”, or the base text to which the
highlighting is applied. In this case, the column must be named “text”.
This reference version is also tokenized for comparison to the
derivative versions.

``` r

# tokenize most recent version of the article (as the reference)
transcript_example <- wiki_pages[1,]
toks_transcript <- tokenize_source(as.character(wiki_pages[1,]))
```

The previous versions are then compared to the current version’s
collocations with fuzzy matching in order to provide a count for the
amount of times each collocation occurs.

``` r

# use fuzzy matching to calculate weighted frequency values between derivative and source documents

collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment)
#> Joining with `by = join_by(unlist.descript_ngrams.)`
#> Joining with `by = join_by(collocation)`
#> Joining with `by = join_by(collocation)`
#> Warning in join_func(a = a, b = b, by_a = by_a, by_b = by_b, block_by_a = block_by_a, : A pair of records at the threshold (0.7) have only a 95% chance of being compared.
#> Please consider changing `n_bands` and `band_width`.
#> Joining with `by = join_by(collocation.y)`
#> Joining with `by = join_by(collocation)`
#> Joining with `by = join_by(word_number)`

head(collocation_object)
#> # A tibble: 6 × 8
#>   word_number col_1 col_2 col_3 col_4 col_5 to_merge    collocation             
#>         <int> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>       <chr>                   
#> 1           1  8    NA    NA    NA    NA    a           a highlighter also call…
#> 2           2  7.74  8    NA    NA    NA    highlighter highlighter also called…
#> 3           3  7     7.74  8    NA    NA    also        also called a fluoresce…
#> 4           4  7     7     7.74  8    NA    called      called a fluorescent pe…
#> 5           5  7     7     7     7.74  8    a           a fluorescent pen is a  
#> 6           6  7     7     7     7     7.74 fluorescent fluorescent pen is a ty…
```

These frequencies can be mapped back to the transcript document, then
highlighted as described based on the average collocation frequency that
each word appeared in. The results are shown below by specifying
`` `r page_highlight` `` in an R Markdown document outside of a code
chunk and knitting to HTML. Note that the “labels” argument can be used
to add additional labels to the gradient key.

``` r

# connect collocation frequencies to source document
merged_frequency <- transcript_frequency(transcript_example, collocation_object)
#> Joining with `by = join_by(to_merge)`
#> Joining with `by = join_by(., lines, n_words, words, word_num, word_length,
#> x_coord, to_merge, stanza_freq, word_number)`

# create a ggplot object of the transcript
freq_plot <- collocation_plot(merged_frequency)

# add html tags to source document
page_highlight <- highlighted_text(freq_plot, labels=c("(fewest articles)", "(most articles)"))
```

(fewest articles) 0

275 (most articles)

A 

highlighter, 

also 

called 

a 

fluorescent 

pen, 

is 

a 

type 

of 

writing 

device 

used 

to 

bring 

attention 

to 

sections 

of 

text 

by 

marking 

them 

with 

a 

vivid, 

translucent 

colour. 

A 

typical 

highlighter 

is 

fluorescent 

yellow, 

with 

the 

color 

coming 

from 

pyranine. 

Different 

compounds, 

such 

as 

rhodamines 

(Rhodamine 

6GD, 

Rhodamine 

B) 

are 

used 

for 

other 

colours. 

  

A 

highlighter 

is 

a 

felt 

- 

tip 

marker 

filled 

with 

transparent 

fluorescent 

ink 

instead 

of 

black 

or 

opaque 

ink. 

The 

first 

highlighter 

was 

invented 

by 

Dr. 

Frank 

Honn 

in 

1962 

and 

produced 

by 

Carter’s 

Ink 

Company, 

using 

the 

trademarked 

name 

Hi 

- 

Liter. 

Avery 

Dennison 

Corporation 

now 

owns 

the 

brand, 

having 

acquired 

Carter’s 

in 

1975. 

  

Many 

highlighters 

come 

in 

bright, 

often 

fluorescent 

and 

vibrant 

colors. 

Being 

fluorescent, 

highlighter 

ink 

glows 

under 

black 

light. 

The 

most 

common 

color 

for 

highlighters 

is 

yellow, 

but 

they 

are 

also 

found 

in 

orange, 

red, 

pink, 

purple, 

blue, 

and 

green 

varieties. 

Some 

yellow 

highlighters 

may 

look 

greenish 

in 

colour 

to 

the 

naked 

eye. 

Yellow 

is 

the 

preferred 

color 

to 

use 

when 

making 

a 

photocopy 

as 

it 

will 

not 

produce 

a 

shadow 

on 

the 

copy. 

  

Highlighters 

are 

available 

in 

multiple 

forms, 

including 

some 

that 

have 

a 

retractable 

felt 

tip 

or 

an 

eraser 

on 

the 

end 

opposite 

the 

felt. 

Other 

types 

of 

highlighters 

include 

the 

trilighter, 

a 

triangularly 

- 

shaped 

pen 

with 

a 

different 

- 

coloured 

tip 

at 

each 

corner, 

and 

ones 

that 

are 

stackable. 

There 

are 

also 

some 

forms 

of 

highlighters 

that 

have 

a 

wax 

- 

like 

quality 

similar 

to 

an 

oil 

pastel. 

  

“Dry 

highlighters” 

(occasionally 

called 

“dry 

line 

highlighters”) 

have 

an 

applicator 

that 

applies 

a 

thin 

strip 

of 

highlighter 

tape 

(physically 

similar 

to 

audio 

tape 

or 

correction 

tape) 

instead 

of 

a 

felt 

tip. 

Unlike 

standard 

highlighters, 

they 

are 

easily 

erasable. 

They 

are 

different 

from 

“dry 

mark 

highlighters”, 

which 

are 

sometimes 

advertised 

as 

being 

useful 

for 

highlighting 

books 

with 

thin 

pages. 

  

“Gel 

highlighters” 

contain 

a 

gel 

stick 

rather 

than 

a 

felt 

tip. 

The 

gel 

does 

not 

bleed 

through 

paper 

or 

become 

dried 

out 

in 

the 

pen 

as 

other 

highlighters’ 

inks 

may, 

which 

renders 

them 

useless. 

  

“Liquid 

Highlighters” 

in 

a 

range 

of 

colours 

are 

also 

available, 

and 

because 

they 

put 

more 

ink 

on 

a 

page 

when 

highlighting, 

they 

make 

words 

stand 

out 

more 

than 

with 

non 

- 

liquid 

types. 

Also 

the 

fact 

that 

more 

highlighting 

ink 

is 

put 

on 

the 

page 

with 

liquid 

highlighters 

means 

that 

the 

highlighting 

ink 

is 

much 

more 

resistive 

to 

fading 

with 

age. 

  

“Pastel 

Highlighters” 

use 

pastel 

dyes 

instead 

of 

fluorescent 

dyes. 

  

Some 

word 

processing 

software 

can 

simulate 

highlighting 

by 

using 

a 

technique 

similar 

to 

reverse 

video 

on 

some 

terminals. 

Some 

forms 

of 

syntax 

highlighting 

may 

also 

be 

displayed 

in 

the 

style 

of 

a 

highlighter 

pen, 

with 

a 

bright 

or 

pastel 

background 

to 

the 

text. 

Some 

web 

browser 

extensions 

also 

enables 

users 

to 

create 

digital 

highlights 

on 

websites 

and 

online 

PDFs. 

  

This text indicates changes to the Wikipedia article, where yellow
indicates more occurrences (such as yellow as the primary highlight
color and information regarding the trilighter). Darker colors indicate
text that is seen in fewer versions of the article (such as the
introductory sentence and the reference to correction tape).

We could also use the oldest version of the Highlighter article in the
dataset as the transcript reference to view which text has been changed:

``` r

# separate the oldest version of the article

transcript_example_2 <- wiki_pages[dim(wiki_pages)[1],]

# tokenize the transcript
toks_transcript2 <- tokenize_source(as.character(transcript_example_2))

# use fuzzy collocation on the source and derivative documents
collocation_object2 <- collocate_comments_fuzzy(toks_transcript2, toks_comment)
#> Joining with `by = join_by(unlist.descript_ngrams.)`
#> Joining with `by = join_by(collocation)`
#> Joining with `by = join_by(collocation)`
#> Warning in join_func(a = a, b = b, by_a = by_a, by_b = by_b, block_by_a = block_by_a, : A pair of records at the threshold (0.7) have only a 95% chance of being compared.
#> Please consider changing `n_bands` and `band_width`.
#> Joining with `by = join_by(collocation.y)`
#> Joining with `by = join_by(collocation)`
#> Joining with `by = join_by(word_number)`

# connect collocation frequencies to source document
merged_frequency2 <- transcript_frequency(transcript_example_2, collocation_object2)
#> Joining with `by = join_by(to_merge)`
#> Joining with `by = join_by(., lines, n_words, words, word_num, word_length,
#> x_coord, to_merge, stanza_freq, word_number)`

# create a gpplot object of the transcript
freq_plot2 <- collocation_plot(merged_frequency2)

# add html tags to source document
page_highlight2 <- highlighted_text(freq_plot2, labels=c("(fewest articles)", "(most articles)"))
```

(fewest articles) 0

243 (most articles)

A 

highlighter 

is 

a 

form 

of 

marker 

pen 

which 

is 

used 

to 

highlight 

sections 

of 

documents 

in 

a 

vivid 

colour, 

but 

not 

intended 

to 

obscure 

the 

content 

beneath 

the 

marking. 

As 

such, 

highlighter 

ink 

is 

translucent. 

  

Many 

highlighters 

come 

in 

bright, 

often 

neon 

colors, 

such 

as 

yellow 

or 

pink, 

but 

also 

coming 

in 

colors 

such 

as 

blue, 

green, 

or 

purple. 

  

In this case, the beginning of the first sentence (“A highlighter is a
form…”) is fairly popular.

Wikipedia Citation: “Highlighter.” Wikipedia, 14 Mar. 2024. Wikipedia,
<https://en.wikipedia.org/w/index.php?title=Highlighter&oldid=1213690238>.
