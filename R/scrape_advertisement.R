
scrape_advertisement <- function(ad_id) {
  
  # Get html for the page
  adv_html <- sprintf("http://marktplaats.nl/%s", ad_id) %>% xml2::read_html()
  
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

  # Get details and return
  ad_data <- data_frame(id = ad_id) %>%
    dplyr::mutate(
      title = get_css_element(adv_html, "#title"),
      price = get_css_element(adv_html, "#vip-ad-price-container .price"),
      views = get_css_element(adv_html, "#view-count", as_numeric = TRUE),
      favorites = get_css_element(adv_html, "#favorited-count", as_numeric = TRUE),
      displayed_since = get_css_element(adv_html, "#displayed-since span:nth-child(3)"),
      shipping = get_css_element(adv_html, ".shipping-details-value:nth-child(2)"),
      category_1 = categories[1],
      category_2 = categories[2],
      category_3 = categories[3],
      counterparty = get_css_element(adv_html, ".top-info .name"),
      cp_n_of_advs = get_n_of_advs_of_counterparty(adv_html),
      cp_tel_number = get_css_element(adv_html, ".seller-info-links .alternative"),
      cp_active_since  = get_css_element(adv_html, "#vip-active-since span"),
      cp_location = get_css_element(adv_html, "#vip-seller-location", remove_chars = c("\n","  ")),
      biddings = list(
        data.frame (
          bidder = get_css_element(adv_html, "#vip-bids-top .ellipsis", expecting_one = FALSE),
          bid = get_css_element(adv_html, ".bid-amount", expecting_one = FALSE),
          bid_date = get_css_element(adv_html, ".bid-date", expecting_one = FALSE)
        )
      ),
      attributes = list(
        data.frame (
          attribute = get_css_element(adv_html, "#vip-ad-attributes .name", expecting_one = FALSE),
          value = get_css_element(adv_html, "#vip-ad-attributes .value", expecting_one = FALSE)
        )
      ),
      description = get_css_element(adv_html, "#vip-ad-description")
    )
  
  # Get kenmerken
  get_kenmerken <- function(adv_html) {
    data_frame(
      kenmerk  = get_css_element(adv_html
                                 , css = ".l-body-content .name"
                                 , expecting_one = FALSE),
      waarde = get_css_element(adv_html
                               , css = ".l-body-content .value"
                               , expecting_one = FALSE)
    ) %>% filter(!is.na(kenmerk))
  }
  kenmerken <- get_kenmerken(adv_html)
  
  # add kenmerken if present
  for(i in seq_along(kenmerken$kenmerk)) {
    kenmerk <- kenmerken$kenmerk[i] %>%
      tolower() %>%
      stringr::str_replace_all(" ", "_")
    
    ad_data <- ad_data %>%
      mutate_(.dots = setNames(list(~kenmerken$waarde[i]), kenmerk))
  }
  
  return(ad_data)

}


