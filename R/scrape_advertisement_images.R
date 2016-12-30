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
  
  if(!dir.exists(storage_dir)) 
    stop(sprintf("The indicated storage_dir '%s' does not exist, 
                 please specify an existing folder and try again...",
                 storage_dir))
  
  adv_html <- get_advertisement_xml(ad_id, wait_time, number_of_tries, verbose)
  
  # If we get an ad not available anymore, return add as closed
  if(!check_adv_available(adv_html)) return(tibble::tibble(ad_id = ad_id, closed = 1))
  
  data <- tibble::tibble(
    ad_id = ad_id,
    img_url = get_urls_to_adv_images(adv_html)
  )

  # Download images and save image location
  data$img_loc <- purrr::map2_chr(data$img_url, 
                 data$ad_id, 
                 download_image,
                 storage_dir = storage_dir)
  
  if(include_hash) { 
    data$img_hash <- data$img_loc %>% 
      purrr::map_chr(image_hash)
  }
  
  # todo; test case for ad with no images. 
  # todo; split function into separate .R files
  # todo; document image .R functions
  # todo; implement hashing function
  return(data)
}