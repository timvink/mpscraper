
scrape_advertisement <- function(adv_url) {
  # Get html for the page
  adv_html <- adv_url %>% xml2::read_html()

  # Only get add if still available
  if(check_adv_available(adv_html)) {
    # Get details and return
    data.frame(adv_url = adv_url) %>%
      dplyr::mutate(
        price = get_css_element(adv_html, "#vip-ad-price-container .price"),
        views = get_css_element(adv_html, "#view-count", as_numeric = TRUE),
        favorites = get_css_element(adv_html, "#favorited-count", as_numeric = TRUE),
        displayed_since = get_css_element(adv_html, "#displayed-since span:nth-child(3)"),
        shipping = get_css_element(adv_html, ".shipping-details-value:nth-child(2)"),
        counterparty = get_css_element(adv_html, ".top-info .name"),
        cp_n_of_advs = get_n_of_advs_of_counterparty(adv_html),
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
      ) %>%
      return()
  }
}


