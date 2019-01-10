[![Build
Status](https://travis-ci.org/mpadge/texttimetravel.svg?branch=master)](https://travis-ci.org/mpadge/texttimetravel)
[![Project Status:
Active](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

# texttimetravel

Developers: Mark Padgham ([@mpadge](https://github.com/mpadge)) and
Felicity Jensz ([@fjensz](https://github.com/fjensz)).

Tools for analysing temporally structured text collections, including
tools for reading large sets of texts in (via
[`pdftools`](https://github.com/ropensci/pdftools)), and for time series
analysis of qualitative statistics such as word associations and topic
models (primarily via [`quanteda`](https://quanteda.io) and
[`topicmodels`](https://cran.r-project.org/package=topicmodels).

## Installation

System requirements (for linux):

  - libpoppler-cpp-dev
  - libgsl0-dev

For other systems, see respective documentation for
[`pdftools`](https://github.com/ropensci/pdftools)) and
[`topicmodels`](https://cran.r-project.org/package=topicmodels).

``` r
devtools::install_github ('mpadge/texttimetravel')
```

-----

## Usage

Load packages and a temporally-structured corpus to work with:

``` r
library (texttimetravel)
library (quanteda)
dat <- data_corpus_inaugural
#dat <- corpus_reshape (dat, to = "sentences") # if desired
```

([`data_corpus_inaugural`](https://quanteda.io/reference/data_corpus_inaugural.html)
is a sample corpus from [`quanteda`](https://quanteda.io) of inaugural
speeches of US presidents.) Then use [`quanteda`](https://quanteda.io)
functions to convert to desired tokenized form:

``` r
tok <- tokens (dat,
               remove_numbers = TRUE,
               remove_punct = TRUE,
               remove_separators = TRUE)
tok <- tokens_remove (tok, stopwords("english"))
```

## keywords

Keyword associations can be extracted with the `ttt_keyness` function,
which relies on the `quanteda::keyness` function, yet simplifies the
interface by allowing keyness statistics to be extracted with a single
function call.

``` r
x <- ttt_keyness (tok, "politic*")
head (x, n = 10) %>% knitr::kable()
```

| feature   |       chi2 |         p | n\_target | n\_reference | n\_target\_rel | n\_reference\_rel |
| :-------- | ---------: | --------: | --------: | -----------: | -------------: | ----------------: |
| political | 2633.43470 | 0.0000000 |       106 |            0 |      0.0427937 |         0.0000000 |
| politics  |  275.14397 | 0.0000000 |        12 |            0 |      0.0048446 |         0.0000000 |
| parties   |   74.19817 | 0.0000000 |        13 |           30 |      0.0052483 |         0.0004835 |
| petty     |   37.28733 | 0.0000000 |         3 |            1 |      0.0012111 |         0.0000161 |
| voice     |   35.13833 | 0.0000000 |         7 |           17 |      0.0028260 |         0.0002740 |
| social    |   30.58931 | 0.0000000 |         8 |           26 |      0.0032297 |         0.0004191 |
| party     |   29.52579 | 0.0000001 |        13 |           68 |      0.0052483 |         0.0010960 |
| inspiring |   28.86219 | 0.0000001 |         3 |            2 |      0.0012111 |         0.0000322 |
| prejudice |   27.81476 | 0.0000001 |         5 |           10 |      0.0020186 |         0.0001612 |
| regaining |   27.43489 | 0.0000002 |         2 |            0 |      0.0008074 |         0.0000000 |

``` r
x <- ttt_keyness (tok, "school*")
head (x, n = 10) %>% knitr::kable()
```

| feature      |       chi2 | p | n\_target | n\_reference | n\_target\_rel | n\_reference\_rel |
| :----------- | ---------: | -: | --------: | -----------: | -------------: | ----------------: |
| schools      | 2255.42401 | 0 |        18 |            0 |      0.0372671 |         0.0000000 |
| colleges     |  275.39646 | 0 |         3 |            0 |      0.0062112 |         0.0000000 |
| school       |  275.39646 | 0 |         3 |            0 |      0.0062112 |         0.0000000 |
| universities |  148.41238 | 0 |         2 |            0 |      0.0041408 |         0.0000000 |
| businesses   |   97.94810 | 0 |         2 |            1 |      0.0041408 |         0.0000156 |
| harness      |   72.71971 | 0 |         2 |            2 |      0.0041408 |         0.0000312 |
| ownership    |   57.58567 | 0 |         2 |            3 |      0.0041408 |         0.0000468 |
| free         |   48.75158 | 0 |        10 |          173 |      0.0207039 |         0.0027015 |
| watching     |   40.29606 | 0 |         2 |            5 |      0.0041408 |         0.0000781 |
| health       |   37.18447 | 0 |         3 |           17 |      0.0062112 |         0.0002655 |

## topics

The function `ttt_fit_topics` provides a convenient wrapper around the
functions provided by the
[`topicmodels`](https://cran.r-project.org/package=topicmodels) package,
and extends functionality via two additional parameters:

1.  `years`, allowing topic models to be fitted only to those portions
    of a corpus corresponding to the specified years;
2.  `topic`, allowing models to be fitted around a specified topic
    phrase.

<!-- end list -->

``` r
x <- ttt_fit_topics (tok, ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1 | Topic 2 | Topic 3   | Topic 4  | Topic 5 |
| :------ | :------ | :-------- | :------- | :------ |
| nation  | state   | govern    | us       | govern  |
| govern  | nation  | state     | nation   | peopl   |
| peopl   | peopl   | constitut | world    | upon    |
| world   | great   | power     | peopl    | nation  |
| can     | govern  | peopl     | america  | law     |
| must    | war     | upon      | new      | countri |
| upon    | shall   | may       | can      | can     |
| us      | public  | can       | must     | must    |
| great   | power   | union     | american | secur   |
| shall   | may     | nation    | freedom  | great   |

``` r
x <- ttt_fit_topics (tok, years = 1789:1900, ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1      | Topic 2      | Topic 3    | Topic 4      | Topic 5                 |
| :----------- | :----------- | :--------- | :----------- | :---------------------- |
| constitut    | power        | war        | govern       | govern                  |
| peopl        | govern       | state      | state        | peopl                   |
| govern       | constitut    | great      | nation       | public                  |
| state        | state        | nation     | peopl        | shall                   |
| upon         | peopl        | power      | upon         | nation                  |
| nation       | upon         | govern     | countri      | state                   |
| can          | may          | may        | great        | may                     |
| law          | one          | citizen    | union        | countri                 |
| shall        | can          | unit       | constitut    | everi                   |
| may          | citizen      | countri    | duti         | us                      |
| Note the tok | en “everi” t | hat appear | s in the sec | ond topic is a mistaken |
| tokenization | of the word  | s "perserv | ering“,”fev  | erish“, and”severity".  |

``` r
x <- ttt_fit_topics (tok, topic = "nation", ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1 | Topic 2 | Topic 3   | Topic 4 | Topic 5  |
| :------ | :------ | :-------- | :------ | :------- |
| govern  | nation  | govern    | nation  | us       |
| peopl   | govern  | state     | shall   | nation   |
| nation  | state   | power     | world   | world    |
| upon    | great   | peopl     | war     | peopl    |
| law     | may     | constitut | must    | america  |
| can     | power   | upon      | us      | can      |
| countri | countri | may       | great   | new      |
| must    | public  | countri   | peopl   | must     |
| state   | peopl   | can       | can     | american |
| great   | war     | everi     | upon    | freedom  |
