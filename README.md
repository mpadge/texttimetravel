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
library(texttimetravel)
library (quanteda)
library (topicmodels)
dat <- data_corpus_inaugural # from quanteda
```

Then convert to desired tokenized form:

``` r
tok <- tokens (dat, remove_numbers = TRUE, remove_punct = TRUE,
               remove_separators = TRUE)
tok <- tokens_remove (tok, stopwords("english"))
```

## keywords

``` r
x <- ttt_keyness (tok, "school")
head (x, n = 10) %>% knitr::kable()
```

| feature |      chi2 | p | n\_target | n\_reference |
| :------ | --------: | -: | --------: | -----------: |
| school  | 2130.8134 | 0 |         3 |            0 |
| laissez |  255.2899 | 0 |         1 |            0 |
| faire   |  255.2899 | 0 |         1 |            0 |
| outward |  255.2899 | 0 |         1 |            0 |
| attest  |  255.2899 | 0 |         1 |            0 |
| teacher |  255.2899 | 0 |         1 |            0 |
| miss    |  255.2899 | 0 |         1 |            0 |
| julia   |  255.2899 | 0 |         1 |            0 |
| coleman |  255.2899 | 0 |         1 |            0 |
| writers |  127.1479 | 0 |         1 |            1 |

``` r
x <- ttt_keyness (tok, "politic*")
head (x, n = 10) %>% knitr::kable()
```

| feature   |       chi2 |         p | n\_target | n\_reference |
| :-------- | ---------: | --------: | --------: | -----------: |
| political | 2633.43470 | 0.0000000 |       106 |            0 |
| politics  |  275.14397 | 0.0000000 |        12 |            0 |
| parties   |   74.19817 | 0.0000000 |        13 |           30 |
| petty     |   37.28733 | 0.0000000 |         3 |            1 |
| voice     |   35.13833 | 0.0000000 |         7 |           17 |
| social    |   30.58931 | 0.0000000 |         8 |           26 |
| party     |   29.52579 | 0.0000001 |        13 |           68 |
| inspiring |   28.86219 | 0.0000001 |         3 |            2 |
| prejudice |   27.81476 | 0.0000001 |         5 |           10 |
| regaining |   27.43489 | 0.0000002 |         2 |            0 |

## topics

``` r
x <- ttt_fit_topics (dat, ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1   | Topic 2 | Topic 3 | Topic 4  | Topic 5 |
| :-------- | :------ | :------ | :------- | :------ |
| peopl     | nation  | govern  | peopl    | world   |
| can       | us      | upon    | may      | state   |
| us        | countri | power   | nation   | shall   |
| must      | everi   | can     | world    | right   |
| state     | can     | nation  | citizen  | must    |
| great     | great   | peopl   | american | nation  |
| nation    | may     | state   | freedom  | peac    |
| constitut | law     | us      | unit     | public  |
| time      | one     | countri | life     | new     |
| one       | now     | world   | power    | call    |

``` r
x <- ttt_fit_topics (dat, years = 1789:1900, ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1  | Topic 2 | Topic 3  | Topic 4 | Topic 5  |
| :------- | :------ | :------- | :------ | :------- |
| nation   | shall   | govern   | govern  | peopl    |
| can      | great   | nation   | peopl   | state    |
| countri  | may     | can      | state   | right    |
| us       | new     | power    | power   | nation   |
| shall    | world   | us       | countri | us       |
| american | public  | upon     | great   | upon     |
| everi    | govern  | new      | must    | must     |
| must     | everi   | now      | law     | peac     |
| one      | citizen | interest | nation  | american |
| upon     | make    | world    | can     | countri  |

``` r
x <- ttt_fit_topics (dat, topic = "nation", ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1  | Topic 2 | Topic 3 | Topic 4 | Topic 5  |
| :------- | :------ | :------ | :------ | :------- |
| nation   | nation  | nation  | nation  | nation   |
| world    | great   | govern  | us      | everi    |
| peopl    | union   | upon    | great   | spirit   |
| govern   | land    | peopl   | one     | peopl    |
| make     | can     | power   | citizen | govern   |
| war      | power   | right   | presid  | interest |
| respect  | bless   | state   | respons | upon     |
| neighbor | mani    | protect | america | state    |
| new      | everi   | great   | part    | honor    |
| purpos   | countri | peac    | can     | may      |
