#' ttt_topics
#'
#' Fit sentence-based topic models for all of some of a corpus, with the ability
#' to fit topics around a specified word or phrase.
#'
#' @param tok A \pkg{quanteda} `tokens` object
#' @param years If specified, restrict topic models to specified years only
#' (requires `tok` to include a `docvars` of "year" or similar).
#' @param ntopics Number of topics to be fitted. This should be reasonably
#' large, to allow words not strongly associated with any primary topics to be
#' allocated to latter, effectively meaningless topics.
#' @param topic If specified, construct topic models around the specified
#' phrase.
#' @param filename If specified, the topic model is saved to the nominated file
#' and can be re-loaded with `x <- readRDS(filename)`.
#' @param quiet If `TRUE`, display progress information on screen.
#' @return An \pkg{topicmodels} object of class `LDA`.
#'
#' @note This function may take a long time to execute; please be patient.
#'
#' @export
#' @examples
#' library(quanteda)
#' dat <- data_corpus_inaugural %>% # from quanteda
#'      corpus_reshape (to = "sentences") # convert documents to sentences
#' tok <- tokens (dat, remove_numbers = TRUE, remove_punct = TRUE,
#'                remove_separators = TRUE)
#' tok <- tokens_remove(tok, stopwords("english"))
#' x <- ttt_fit_topics (tok, ntopics = 5)
#' topicmodels::get_terms(x, 20)
#' x <- ttt_fit_topics (tok, years = 1789:1900, ntopics = 5)
ttt_fit_topics <- function (tok, years = NULL, ntopics = 20, topic = NULL,
                            filename = NULL, quiet = FALSE)
{
    if (!methods::is (tok, "tokens"))
        stop ("ttt_fit_topics requires a quanteda tokens object")

    # rm no visible binding notes
    index <- NULL
    dv <- quanteda::docvars (tok)
    yvar <- names (dv) [grep ("year", names (dv), ignore.case = TRUE)]

    if (!is.null (years))
    {
        tok <- quanteda::tokens_subset (tok, dv [[yvar]] %in% years)
        dv <- quanteda::docvars (tok)
    }

    if (!is.null (topic))
    {
        dfm_topic <- quanteda::tokens_keep (tok, quanteda::phrase (topic)) %>%
            quanteda::dfm ()
        indx <- which (as.numeric (dfm_topic) > 0)
        quanteda::docvars (tok, "index") <- seq (quanteda::ndoc (tok))
        tok <- quanteda::tokens_subset (tok, index %in% indx)
        dv <- quanteda::docvars (tok)
    }
    tm <- quanteda::dfm (tok,
                        remove = c (letters, quanteda::stopwords ("english")),
                        stem = TRUE,
                        remove_punct = TRUE) %>%
        quanteda::convert (to = "topicmodels")

    res <- topicmodels::LDA (tm, k = ntopics)

    # Then just make sure that the names of the documents have the year as the
    # first four characters. This is used in the print functions
    if (!all (substring (names (tok), 1, 4) == dv [[yvar]]))
        names (tok) <- paste0 (dv [[yvar]], "_", names (tok))

    if (!is.null (filename))
        saveRDS (res, file = filename)
    return (res)
}
