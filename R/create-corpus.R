#' ttt_create_corpus
#'
#' Create a corpus by reading a directory of pre-downloaded `pdf` files.
#'
#' @inheritParams dl_canada
#' @return A \pkg{quanteda} corpus representing the text contents of all `pdf`
#' documents contained in `data_dir`.
#' @export
create_ttt_corpus <- function (data_dir = "./data")
{
    if (!dir.exists (data_dir))
        stop("data_dir [", data_dir, "] does not exist")

    flist <- list.files (data_dir, full.names = TRUE)
    dat <- NULL

    pb <- utils::txtProgressBar (style = 3)
    for (f in seq (flist))
    {
        suppressMessages (txt <- pdftools::pdf_text (flist [f]))
        dat_temp <- quanteda::corpus (txt)
        year <- strsplit (flist [f], "/") [[1]] [3] %>%
            substr (2, 5) %>%
            as.numeric ()
        pages <- seq (quanteda::ndoc (dat_temp))
        doc_names <- sprintf ("DIA_%04d_%03d", year, pages)
        quanteda::docvars (dat_temp, "year") <- year
        quanteda::docvars (dat_temp, "pages") <- pages
        quanteda::docnames (dat_temp) <- doc_names
        if (f == 1)
            dat <- dat_temp
        else
            dat <- dat + dat_temp
        utils::setTxtProgressBar (pb, f / length (flist))
    }
    close (pb)

    return (dat)
}
