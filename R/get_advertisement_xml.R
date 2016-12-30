#' @importFrom magrittr "%>%"
NULL

#' Scrape advertisement
#'
#' Downloads the HTML code of a given advertisement
#'
#' @inheritParams scrape_advertisement
#'
#' @return a XML with the HTML of the marktplaats advertisement
#'
get_advertisement_xml <- function(ad_id,
                                  wait_time = 0,
                                  number_of_tries = 1,
                                  verbose = F) {
  
  stopifnot(all(valid_ad_id(ad_id)))
  
  if(verbose) print(sprintf("%s: Scraping advertisement %s", Sys.time(), ad_id))
  stopifnot(number_of_tries > 0)
  
  # Get html for the page
  get_adv_html <- function(ad_id) {
    result <- try(xml2::read_html(sprintf("http://www.marktplaats.nl/%s", ad_id)), silent = T)
    return(result)
  }
  
  # retry if there are connection problems
  for(i in 1:number_of_tries) {
    adv_html <- get_adv_html(ad_id)
    
    # If page not found, state that ad is closed.
    if(any(grepl("HTTP error 404", adv_html))) return(tibble::tibble(ad_id = ad_id, closed = 1))
    
    # If a connection problem persists for 'number_of_tries' times, return NULL
    if(any(class(adv_html) == "try-error")) {
      if(i == number_of_tries) return(NULL)
      Sys.sleep(min(i^2,20)) # wait for a bit (1, 4, 9, 16, 20, 20)
      next
    } else {
      break
    }
  }
  
  return(adv_html)
}
