[![Build
Status](https://travis-ci.org/mpadge/texttimetravel.svg?branch=master)](https://travis-ci.org/mpadge/texttimetravel)
[![Project Status:
Active](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![codecov](https://codecov.io/gh/mpadge/texttimetravel/branch/master/graph/badge.svg)](https://codecov.io/gh/mpadge/texttimetravel)

texttimetravel
==============

Tools for analysing temporally structured text collections, including
tools for reading large sets of texts in (via
[`pdftools`](https://github.com/ropensci/pdftools)), and for time series
analysis of qualitative statistics such as word associations and topic
models (primarily via [`quanteda`](https://quanteda.io) and
[`topicmodels`](https://cran.r-project.org/package=topicmodels).

Installation
------------

System requirements (for linux):

-   libpoppler-cpp-dev
-   libgsl-dev

For other systems, see respective documentation for
[`pdftools`](https://github.com/ropensci/pdftools)) and
[`topicmodels`](https://cran.r-project.org/package=topicmodels).

    devtools::install_github ('mpadge/texttimetravel')

------------------------------------------------------------------------

Usage
-----

Load packages and a temporally-structured corpus to work with:

    library (texttimetravel)
    library (quanteda)
    dat <- data_corpus_inaugural
    #dat <- corpus_reshape (dat, to = "sentences") # if desired

([`data_corpus_inaugural`](https://quanteda.io/reference/data_corpus_inaugural.html)
is a sample corpus from [`quanteda`](https://quanteda.io) of inaugural
speeches of US presidents.) Then use [`quanteda`](https://quanteda.io)
functions to convert to desired tokenized form:

    tok <- tokens (dat,
                   remove_numbers = TRUE,
                   remove_punct = TRUE,
                   remove_separators = TRUE)
    tok <- tokens_remove (tok, stopwords("english"))

keywords
--------

Keyword associations can be extracted with the `ttt_keyness` function,
which relies on the `quanteda::keyness` function, yet simplifies the
interface by allowing keyness statistics to be extracted with a single
function call.

    x <- ttt_keyness (tok, "politic*")
    head (x, n = 10) %>% knitr::kable()

| feature   |       chi2 |         p | n\_target | n\_reference | n\_target\_rel | n\_reference\_rel |
|:----------|-----------:|----------:|----------:|-------------:|---------------:|------------------:|
| political | 2633.60428 | 0.0000000 |       106 |            0 |      0.0427937 |         0.0000000 |
| politics  |  275.16176 | 0.0000000 |        12 |            0 |      0.0048446 |         0.0000000 |
| parties   |   74.20399 | 0.0000000 |        13 |           30 |      0.0052483 |         0.0004835 |
| petty     |   37.28986 | 0.0000000 |         3 |            1 |      0.0012111 |         0.0000161 |
| voice     |   35.14114 | 0.0000000 |         7 |           17 |      0.0028260 |         0.0002740 |
| social    |   30.59193 | 0.0000000 |         8 |           26 |      0.0032297 |         0.0004190 |
| party     |   29.52876 | 0.0000001 |        13 |           68 |      0.0052483 |         0.0010959 |
| inspiring |   28.86421 | 0.0000001 |         3 |            2 |      0.0012111 |         0.0000322 |
| prejudice |   27.81692 | 0.0000001 |         5 |           10 |      0.0020186 |         0.0001612 |
| imply     |   27.43670 | 0.0000002 |         2 |            0 |      0.0008074 |         0.0000000 |

    x <- ttt_keyness (tok, "school*")
    head (x, n = 10) %>% knitr::kable()

| feature      |       chi2 |   p | n\_target | n\_reference | n\_target\_rel | n\_reference\_rel |
|:-------------|-----------:|----:|----------:|-------------:|---------------:|------------------:|
| schools      | 2255.56491 |   0 |        18 |            0 |      0.0372671 |         0.0000000 |
| colleges     |  275.41371 |   0 |         3 |            0 |      0.0062112 |         0.0000000 |
| school       |  275.41371 |   0 |         3 |            0 |      0.0062112 |         0.0000000 |
| universities |  148.42169 |   0 |         2 |            0 |      0.0041408 |         0.0000000 |
| businesses   |   97.95431 |   0 |         2 |            1 |      0.0041408 |         0.0000156 |
| harness      |   72.72437 |   0 |         2 |            2 |      0.0041408 |         0.0000312 |
| ownership    |   57.58940 |   0 |         2 |            3 |      0.0041408 |         0.0000468 |
| free         |   48.75559 |   0 |        10 |          173 |      0.0207039 |         0.0027014 |
| watching     |   40.29872 |   0 |         2 |            5 |      0.0041408 |         0.0000781 |
| health       |   37.18705 |   0 |         3 |           17 |      0.0062112 |         0.0002655 |

topics
------

The function `ttt_fit_topics` provides a convenient wrapper around the
functions provided by the
[`topicmodels`](https://cran.r-project.org/package=topicmodels) package,
and extends functionality via two additional parameters:

1.  `years`, allowing topic models to be fitted only to those portions
    of a corpus corresponding to the specified years;
2.  `topic`, allowing models to be fitted around a specified topic
    phrase.

<!-- -->

    x <- ttt_fit_topics (tok, ntopics = 5)
    topicmodels::get_terms(x, 10) %>% knitr::kable()

| Topic 1 | Topic 2 | Topic 3   | Topic 4 | Topic 5  |
|:--------|:--------|:----------|:--------|:---------|
| peopl   | nation  | govern    | govern  | us       |
| nation  | world   | state     | state   | american |
| upon    | us      | constitut | nation  | nation   |
| govern  | can     | peopl     | countri | peopl    |
| can     | peopl   | power     | peopl   | america  |
| must    | america | can       | power   | must     |
| law     | peac    | may       | great   | new      |
| great   | freedom | upon      | public  | world    |
| peac    | new     | law       | may     | govern   |
| shall   | must    | one       | everi   | time     |

    x <- ttt_fit_topics (tok, years = 1789:1900, ntopics = 5)
    topicmodels::get_terms(x, 10) %>% knitr::kable()

| Topic 1 | Topic 2   | Topic 3 | Topic 4 | Topic 5   |
|:--------|:----------|:--------|:--------|:----------|
| govern  | upon      | state   | peopl   | constitut |
| state   | state     | govern  | govern  | state     |
| power   | nation    | nation  | nation  | power     |
| union   | peopl     | countri | shall   | govern    |
| great   | law       | may     | public  | peopl     |
| nation  | govern    | peopl   | can     | can       |
| countri | constitut | us      | may     | may       |
| right   | great     | public  | everi   | upon      |
| peopl   | countri   | everi   | upon    | one       |
| duti    | public    | war     | countri | union     |

    x <- ttt_fit_topics (tok, topic = "nation", ntopics = 5)
    topicmodels::get_terms(x, 10) %>% knitr::kable()

| Topic 1 | Topic 2 | Topic 3   | Topic 4 | Topic 5  |
|:--------|:--------|:----------|:--------|:---------|
| govern  | nation  | govern    | nation  | us       |
| state   | peopl   | peopl     | peopl   | nation   |
| nation  | govern  | upon      | upon    | world    |
| power   | us      | state     | can     | america  |
| may     | world   | power     | peac    | peopl    |
| countri | can     | constitut | world   | new      |
| peopl   | must    | law       | must    | can      |
| union   | war     | may       | govern  | american |
| public  | shall   | countri   | law     | must     |
| great   | men     | great     | countri | time     |
