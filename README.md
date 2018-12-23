[![Build
Status](https://travis-ci.org/mpadge/texttimetravel.svg?branch=master)](https://travis-ci.org/mpadge/texttimetravel)
[![Project Status:
Active](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

# texttimetravel

Tools for analysing temporally structured text collections

## Installation

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

| feature   |       chi2 |         p | n\_target | n\_reference | target\_total | reference\_total |
| :-------- | ---------: | --------: | --------: | -----------: | ------------: | ---------------: |
| political | 2633.43470 | 0.0000000 |       106 |            0 |          2477 |            62044 |
| politics  |  275.14397 | 0.0000000 |        12 |            0 |          2477 |            62044 |
| parties   |   74.19817 | 0.0000000 |        13 |           30 |          2477 |            62044 |
| petty     |   37.28733 | 0.0000000 |         3 |            1 |          2477 |            62044 |
| voice     |   35.13833 | 0.0000000 |         7 |           17 |          2477 |            62044 |
| social    |   30.58931 | 0.0000000 |         8 |           26 |          2477 |            62044 |
| party     |   29.52579 | 0.0000001 |        13 |           68 |          2477 |            62044 |
| inspiring |   28.86219 | 0.0000001 |         3 |            2 |          2477 |            62044 |
| prejudice |   27.81476 | 0.0000001 |         5 |           10 |          2477 |            62044 |
| regaining |   27.43489 | 0.0000002 |         2 |            0 |          2477 |            62044 |

``` r
x <- ttt_keyness (tok, "school")
head (x, n = 10) %>% knitr::kable()
```

| feature |      chi2 | p | n\_target | n\_reference | target\_total | reference\_total |
| :------ | --------: | -: | --------: | -----------: | ------------: | ---------------: |
| school  | 2130.8134 | 0 |         3 |            0 |            63 |            64458 |
| laissez |  255.2899 | 0 |         1 |            0 |            63 |            64458 |
| faire   |  255.2899 | 0 |         1 |            0 |            63 |            64458 |
| outward |  255.2899 | 0 |         1 |            0 |            63 |            64458 |
| attest  |  255.2899 | 0 |         1 |            0 |            63 |            64458 |
| teacher |  255.2899 | 0 |         1 |            0 |            63 |            64458 |
| miss    |  255.2899 | 0 |         1 |            0 |            63 |            64458 |
| julia   |  255.2899 | 0 |         1 |            0 |            63 |            64458 |
| coleman |  255.2899 | 0 |         1 |            0 |            63 |            64458 |
| writers |  127.1479 | 0 |         1 |            1 |            63 |            64458 |

Note that all words associated with “school” occur only once in the
corpus, and so even though `p = 0` in all cases, these associations can
not be interpreted as statistically meaningful.

## topics

The function `ttt_fit_topics` provides a convenient wrapper around the
functions provided by the
[`topicmodels`](https://cran.r-project.org/package=topicmodels) package,
and provides additional functionality via two additional parameters:

1.  `years`, allowing topic models to be fitted only to those portions
    of a corpus corresponding to the specified years;
2.  `topic`, allowing models to be fitted around a specified topic
    phrase.

<!-- end list -->

``` r
x <- ttt_fit_topics (tok, ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1   | Topic 2 | Topic 3   | Topic 4  | Topic 5 |
| :-------- | :------ | :-------- | :------- | :------ |
| state     | nation  | govern    | us       | peopl   |
| govern    | govern  | upon      | nation   | nation  |
| constitut | peopl   | power     | world    | govern  |
| union     | great   | peopl     | peopl    | upon    |
| nation    | can     | state     | america  | shall   |
| shall     | countri | constitut | new      | great   |
| power     | state   | may       | can      | state   |
| may       | peac    | can       | must     | us      |
| countri   | upon    | countri   | american | public  |
| right     | may     | law       | freedom  | law     |

``` r
x <- ttt_fit_topics (tok, years = 1789:1900, ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1   | Topic 2 | Topic 3 | Topic 4 | Topic 5   |
| :-------- | :------ | :------ | :------ | :-------- |
| constitut | peopl   | nation  | state   | govern    |
| state     | upon    | govern  | govern  | state     |
| govern    | govern  | public  | great   | nation    |
| peopl     | law     | war     | nation  | peopl     |
| power     | public  | state   | countri | upon      |
| may       | shall   | union   | unit    | power     |
| can       | state   | countri | everi   | constitut |
| upon      | nation  | right   | peopl   | countri   |
| one       | great   | shall   | may     | union     |
| shall     | countri | power   | power   | can       |

``` r
x <- ttt_fit_topics (tok, topic = "nation", ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1 | Topic 2  | Topic 3 | Topic 4   | Topic 5 |
| :------ | :------- | :------ | :-------- | :------ |
| nation  | us       | nation  | govern    | peopl   |
| govern  | america  | us      | state     | govern  |
| state   | nation   | world   | power     | upon    |
| may     | world    | peopl   | constitut | law     |
| power   | american | can     | peopl     | must    |
| peopl   | must     | new     | upon      | nation  |
| everi   | peopl    | must    | nation    | countri |
| great   | freedom  | peac    | countri   | can     |
| countri | new      | govern  | union     | state   |
| public  | time     | great   | may       | public  |
