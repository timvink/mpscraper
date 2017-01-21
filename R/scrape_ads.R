#' scrape_ads
#'
#' @param ad_ids vector of ad ids to scrape
#' @param ads_per_minute limit the rate of scraping. Default is as fast as possible.
#' @param report_every_nth_scrape report scraping every nth ad. Default is 10
#' @param number_of_tries Number of tries to scrape an ad if a problem occurs.
#'
#' @return data.frame with features from the ads
#' @export
#'
scrape_ads <- function(ad_ids,
                       ads_per_minute = Inf,
                       report_every_nth_scrape = 10,
                       number_of_tries = 2) {
  
  # Return empty data.frame if ad_ids is empty
  if(length(ad_ids) == 0) {
    return(data.frame())
  } 
  
  # determine delays
  if(ads_per_minute == Inf) {
    delay_times <- 0
  } else {
    delay_times <- stats::rnorm(n = length(ad_ids),
                         mean = 60 / ads_per_minute,
                         sd = 0.2)
    delay_times <- ifelse(delay_times < 0, 0, delay_times)
  }

  # determine verbosity
  verbose <- rep(F, length(ad_ids))
  if(!is.na(report_every_nth_scrape))
    verbose[seq(1,length(ad_ids),report_every_nth_scrape)] <- T

  # Scrape them ads!
  data <- list(ad_id = ad_ids,
       wait_time = delay_times,
       number_of_tries = number_of_tries,
       verbose = verbose) %>%
    purrr::pmap_df(scrape_advertisement)

  return(data)
}
