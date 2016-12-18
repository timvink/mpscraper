#' @importFrom magrittr "%>%"
NULL

#' Scrape advertisement
#'
#' Collects a set of features from a given advertisement id
#' 
#' @param ad_id The ID of a marktplaats advertisement
#' @param wait_time To prevent hammering markplaats with rapid requests, you can
#'   specify a delay after collecting the data
#' @param number_of_tries If scraping fails we can retry more times
#' @param verbose Be chatty about data collection?
#'   
#' @return a data.frame with features collected from the ad
#' @export
#' 
scrape_advertisement <- function(ad_id, 
                                 wait_time = 0,
                                 number_of_tries = 1,
                                 verbose = F) {

  if(verbose) print(sprintf("%s: Scraping advertisement %s", Sys.time(), ad_id))
  stopifnot(number_of_tries > 0)
  
  # Get html for the page
  get_adv_html <- function(ad_id) {
    result <- try(xml2::read_html(sprintf("http://marktplaats.nl/%s", ad_id)), silent = T)
    return(result)
  }
  
  # retry if there are connection problems
  for(i in 1:number_of_tries) {
    adv_html <- get_adv_html(ad_id)
    if(any(class(adv_html) == "try-error")) {
      if(i == number_of_tries) return(NULL) # failed, just return a null
      Sys.sleep(min(i^2,20)) # wait for a bit (1, 4, 9, 16, 20, 20)
      next
    } else {
      break
    }
  }
  
  # Only get add if still available
  if(!check_adv_available(adv_html)) return()

  # Get categories
  get_categories <- function() {
    get_css_element(adv_html, ".breadcrumbs .with-right-triangle", expecting_one = FALSE) %>%
      stringr::str_replace_all("\\n|  ", "") %>%
      stringr::str_replace_all(" $", "") %>%
      purrr::discard(~ .x == "Home") %>%
      stringr::str_split(" \\| ") %>% unlist
  }
  categories <- get_categories()

  get_seller_id <- function() {
    id <- NA_integer_
    try(
      id <- adv_html %>%
        rvest::html_nodes(".top-info a:nth-child(2)") %>%
        rvest::html_attr("href") %>%
        basename() %>%
        stringr::str_replace("\\.html", "") %>%
        as.integer()
      )
    if(length(id) == 0) id <- NA_integer_
    return(id)
  }

  get_number_of_bids <- function() {
    html <- get_css_element(adv_html, 
                            "#vip-list-bids-block .bid", 
                            expecting_one = F)
    # tests
    # html <- NA
    # html <- c("\n                    Ramon<U+20AC> 310,0010 dec. '16\n                ")
    # html <- c("\n                    Ramon<U+20AC> 310,0010 dec. '16\n                ",
    #           "\n                    Jeffrey<U+20AC> 300,0010 dec. '16\n                ")
    # html <- c("\n    \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n    \n    \n    \n        Geen biedingen geplaatst.\n    \n    \n\n\n    \n    \n    \n")
    if(any(is.na(html))) return(NA)
    if(any(grepl("Geen biedingen", html))) return(0)
    return(length(html))
  }

  get_biddings <- function() {
      data.frame (
        bidder = get_css_element(adv_html, "#vip-list-bids-block .ellipsis", expecting_one = FALSE),
        bid = get_css_element(adv_html, "#vip-list-bids-block .bid-amount", expecting_one = FALSE) %>%
          stringr::str_extract("[0-9]+[,]?[0-9]*") %>%
          stringr::str_replace(",",".") %>%
          as.numeric(),
        bid_date = get_css_element(adv_html, "#vip-list-bids-block .bid-date", expecting_one = FALSE)
      )
  }

  # Get details and return
  ad_data <- tibble::data_frame(id = ad_id) %>%
    dplyr::mutate(
      title = get_css_element(adv_html, "#title"),
      price = get_css_element(adv_html, "#vip-ad-price-container .price"),
      views = get_css_element(adv_html, "#view-count", as_numeric = TRUE),
      favorites = get_css_element(adv_html, "#favorited-count", as_numeric = TRUE),
      displayed_since = get_css_element(adv_html, "#displayed-since span:nth-child(3)"),
      shipping = get_css_element(adv_html, ".shipping-details-value:nth-child(2)"),
      shipping_costs = get_css_element(adv_html, ".l-top-content .price", expecting_one = F)[2],
      reserved = get_css_element(adv_html, ".reserved-label"),
      category_1 = categories[1],
      category_2 = categories[2],
      category_3 = categories[3],
      counterparty = get_css_element(adv_html, ".top-info .name"),
      cp_id = get_seller_id(),
      cp_n_of_advs = get_n_of_advs_of_counterparty(adv_html),
      cp_has_contact_preference =
        !is.na(get_css_element(adv_html, ".messaging-section .contact-heading")),
      cp_has_website = !is.na(get_css_element(adv_html, "#vip-seller-url")),
      cp_tel_number = get_css_element(adv_html, ".seller-info-links .alternative"),
      cp_active_since  = get_css_element(adv_html, "#vip-active-since span"),
      cp_location = get_css_element(adv_html, "#vip-seller-location", remove_chars = c("\n","  ")),
      biddings_active = !is.na(get_css_element(adv_html, "#vip-place-bid-block")),
      biddings_n = get_number_of_bids(),
      biddings_highest_bid = get_biddings()$bid %>% max,
      biddings_lowest_bid = get_biddings()$bid %>% min,
      biddings_unique_bidders = get_biddings()$bidder %>% dplyr::n_distinct(),
      description = get_css_element(adv_html, "#vip-ad-description")
    )

  # Get kenmerken
  get_kenmerken <- function(adv_html) {
    tibble::data_frame(
      kenmerk  = get_css_element(adv_html
                                 , css = ".l-body-content .name"
                                 , expecting_one = FALSE),
      waarde = get_css_element(adv_html
                               , css = ".l-body-content .value"
                               , expecting_one = FALSE)
    ) %>% dplyr::filter(!is.na(kenmerk))
  }
  kenmerken <- get_kenmerken(adv_html)

  # add kenmerken if present
  for(i in seq_along(kenmerken$kenmerk)) {
    kenmerk <- kenmerken$kenmerk[i] %>%
      tolower() %>%
      stringr::str_replace_all(" ", "_")

    ad_data <- ad_data %>%
      dplyr::mutate_(.dots = stats::setNames(list(~kenmerken$waarde[i]), kenmerk))
  }

  # If you want to use this function to
  # scrape lots of ads, you might want to 
  # add a bit of delay to prevent hammering
  # the server and possibly losing your connection
  Sys.sleep(wait_time)
  
  return(ad_data)

}


