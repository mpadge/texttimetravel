#' ttt_keyness
#'
#' Keyness metrics for associations with specified key words; see
#' \url{https://en.wikipedia.org/wiki/Keyword_(linguistics)}
#'
#' @param x A \pkg{quanteda} `tokens` list, obtained by `tokens(corpus)`.
#' @param word The key word for which associations with other words are to be
#' calculated.
#' @param window Passed to \pkg{quanteda} `tokens_keep/remove` functions; the
#' number of words surrounding each instance of `word` to be considered in
#' measures of assocation.
#' @return A \pkg{quanteda} `keyness` object listing words (`features`) and
#' associated keyness statistics.
#' @export
ttt_keyness <- function (x, word = "school", window = 10)
{
    if (!methods::is (x, "tokens"))
    {
        if (methods::is (x, "corpus"))
        {
            message ("argument is a corpus; translating to tokens")
            x <- quanteda::tokens (x)
        } else
            stop ("unknown class of object; ",
                  "please submit a corpus or tokens object")
    }

    word_dfm <- quanteda::tokens_keep (x, quanteda::phrase (word), window = window) %>%
        quanteda::dfm ()
    not_word_dfm <- quanteda::tokens_remove (x, quanteda::phrase (word),
                                             window = window) %>%
        quanteda::dfm ()

    quanteda::textstat_keyness (rbind (word_dfm, not_word_dfm),
                                seq_len (quanteda::ndoc (word_dfm)))
}
