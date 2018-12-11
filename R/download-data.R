#' dl_canada
#'
#' Download annual Indian Affairs Reports for Canada
#'
#' @param data_dir Directory where data are to be stored (will be created if it
#' does not exist).
#' @param quiet If `TRUE`, display progress information on screen
#' @return `TRUE` if successful
#' @export
dl_canada <- function (data_dir = "./data", quiet = FALSE)
{
    if (!dir.exists (data_dir))
    {
        message ("data_dir [", data_dir, "] does not exist and will now ",
                 "be created.")
        dir.create (data_dir, recursive = TRUE)
    }

    years <- c (1864, 1868:1914)
    url_base <- "http://central.bac-lac.gc.ca/.item/?id="
    url_suffix <- "-IAAR-RAAI&op=pdf&app=indianaffairs"

    for (y in years)
    {
        res <- httr::GET (paste0 (url_base, y, url_suffix))
        message (y, appendLF = FALSE)
        if (httr::status_code (res) != 200)
            message (res)
        else
        {
            saveRDS (httr::content (res),
                     file = file.path (data_dir, paste0 ("iar_", y, ".pdf")),
                     compress = FALSE)
            message ()
        }
    }
    return (TRUE)
}
