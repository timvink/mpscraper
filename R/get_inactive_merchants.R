#' @importFrom magrittr "%>%"
NULL

#' Get the number of current advertisements of a merchant
#'
#' @param ad_id The ID of a marktplaats merchant (a.k.a. counterparty)
#' @param n_tries If scraping fails we can retry more times
#'
#' @return a character string
#' @export
#' 
#' @examples
#' \dontrun{
#' get_n_current_advs_of_merchant(merchant_id = 15818)
#' }
get_n_current_advs_of_merchant <- function(merchant_id, 
                                           n_tries = 3) {
  
  # retry if there are connection problems
  for (i in 1:n_tries) {
    # Get html for a merchant
    merchant_html <- try(xml2::read_html(sprintf("http://www.marktplaats.nl/verkopers/%s.html",merchant_id), silent = T))

    # If page not found, state that ad is closed.
    if (any(grepl("HTTP error 404", merchant_html) | grepl("HTTP error 410", merchant_html))) return("Removed")

    # If a connection problem persists for 'number_of_tries' times, return NULL
    if (any(class(merchant_html) == "try-error")) {
      if (i == n_tries) return(NULL)
      Sys.sleep(min(i^2,20)) # wait for a bit (1, 4, 9, 16, 20, 20)
      next
    } else {
      break
    }
  }
  
  # Get number of currently open advs
  merchant_html %>%
    rvest::html_nodes("#soi-breadcrumbs-content li:nth-child(2) span") %>%
    stringr::str_extract("[[:digit:]]+") %>% 
    return()
  
}