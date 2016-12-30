#' @importFrom magrittr "%>%"
NULL


#' Scrape advertisement images
#'
#' returns a data frame with image properties
#'
#' @inheritParams scrape_advertisement
#' @param include_hash Use pHash algoritm to hash image
#'
#' @return a dataframe
#'
scrape_advertisement_images <- function(ad_id,
                                        wait_time = 0,
                                        number_of_tries = 1,
                                        verbose = F, 
                                        include_hash = F)
  {
  
  adv_html <- get_advertisement_xml(ad_id, wait_time, number_of_tries, verbose)
  
  # If we get an ad not available anymore, return add as closed
  if(!check_adv_available(adv_html)) return(tibble::tibble(ad_id = ad_id, closed = 1))
  
  get_urls_to_adv_images(adv_html)
  
}