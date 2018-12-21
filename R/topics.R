#' ttt_topics
#'
#' Fit sentence-based topic models for all of some of a corpus, with the ability
#' to fit topics around a specified word or phrase.
#'
#' @param dat A temporally-structued \pkg{quanteda} corpus with a `docar` of
#' `year`
#' @param years If specified, restrict topic models to specified years only
#' @param ntopics Number of topics to be fitted. This should be reasonably
#' large, to allow words not strongly associated with any primary topics to be
#' allocated to latter, effectively meaningless topics.
#' @param topic If specified, construct topic models around the specified
#' phrase.
#' @param filename If specified, the topic model is saved to the nominated file
#' and can be re-loaded with `x <- readRDS(filename)`.
#' @return An \pkg{topicmodels} object of class `LDA`.
#'
#' @note This function may take a long time to execute; please be patient.
#'
#' @export
#' @examples
#' dat <- quanteda::data_corpus_inaugural
#' x <- ttt_fit_topics (dat, ntopics = 5)
#' topicmodels::get_terms(x, 20)
#' x <- ttt_fit_topics (dat, years = 1789:1900, ntopics = 5)
ttt_fit_topics <- function (dat, years = NULL, ntopics = 20, topic = NULL,
                            filename = NULL, quiet = FALSE)
{
    # rm no visible binding notes
    year <- index <- NULL
    if (!is.null (years))
    {
        dv <- quanteda::docvars (dat)
        yvar <- names (dv) [grep ("year", names (dv), ignore.case = TRUE)]
        quanteda::corpus_subset (dat, dv [[yvar]] %in% years)
    }
    if (!dat$settings$units == "sentences")
        dat <- quanteda::corpus_reshape (dat, to = "sentences")
    tok <- quanteda::tokens (dat, remove_numbers = TRUE, remove_punct = TRUE,
                             remove_separators = TRUE)
    d <- quanteda::dfm (tok,
                        remove = c (letters, quanteda::stopwords ("english")),
                        stem = TRUE,
                        remove_punct = TRUE)

    if (!is.null (topic))
    {
        dfm_topic <- quanteda::tokens_keep (tok, quanteda::phrase (topic)) %>%
            quanteda::dfm ()
        indx <- which (as.numeric (dfm_topic) > 0)
        quanteda::docvars (dat, "index") <- seq (quanteda::ndoc (dat))
        d <- quanteda::corpus_subset (dat, index %in% indx)
        tok <- quanteda::tokens (d, remove_numbers = TRUE, remove_punct = TRUE,
                                 remove_separators = TRUE)
        d <- quanteda::dfm (tok,
                            remove = c (letters, quanteda::stopwords ("english")),
                            stem = TRUE,
                            remove_punct = TRUE)
    }

    dtm <- quanteda::convert (d, to = "topicmodels")
    res <- topicmodels::LDA (dtm, k = ntopics)
    if (!is.null (filename))
        saveRDS (res, file = filename)
    return (res)
}
