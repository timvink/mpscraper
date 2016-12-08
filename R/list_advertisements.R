

#' Lists the advertisements listed for a given search url
#'
#' @param url The HTTP URL of a marktplace search page
#'   page.
#' @param advertisement_type Choose which type of advertisements to would like to select
#' @param max_pages limit the number of pages webscrape. Useful for testing. Default is all pages.
#'
#' @return a data frame with title, url and ID of advertisements
#'
#' @examples
#'
#' url <- "http://www.marktplaats.nl/z/telecommunicatie/mobiele-telefoons-apple-iphone/iphone.html?query=iphone&categoryId=1953&sortBy=SortIndex"
#' list_advertisements(url, advertisement_type = "individuals", max_pages = 5)
#'
list_advertisements <- function(url,
                                advertisement_type = c("both", "individuals", "companies"),
                                max_pages = Inf) {

  advertisement_type <- match.arg(advertisement_type)

  # Create vector of pages to crawl
  n_pages <- get_number_of_adv_pages(url)
  n_pages <- min(n_pages, max_pages)
  page_urls <- paste0(url,"&currentPage=",1:n_pages)

  # Get advs from each page
  advs_data <- lapply(X = page_urls,FUN = get_advs_overview_from_page)
  advs_data <- do.call("rbind", advs_data)

  # Remove dublicates and filter business advs
  advs_data <- advs_data %>%
    dplyr::distinct(.keep_all = T) %>%
    dplyr::arrange(desc(adv_id))

  switch(advertisement_type,
         both = advs_data,
         individuals = dplyr::filter(advs_data, grepl("m",adv_id)),
         companies = dplyr::filter(advs_data, grepl("a",adv_id)))

}


# what zijn admarkt ads?




# Define settings
settings <- list(
  # Define marktplaats url for iphone
  url_marktplaats_search = "http://www.marktplaats.nl/z/telecommunicatie/mobiele-telefoons-apple-iphone/iphone.html?query=iphone&categoryId=1953&sortBy=SortIndex",
  # Define css selectors for adv scraping wrapper
  css_price = "#vip-ad-price-container .price",
  css_view_count = "#view-count",
  css_favoured_count = "#favorited-count",
  css_displayed_since = "#displayed-since span:nth-child(3)",
  css_shipping_details = ".shipping-details-value:nth-child(2)",
  css_counterparty = ".top-info .name",
  css_cp_active_since = "#vip-active-since span",
  css_cp_location = "#vip-seller-location",
  css_attribute_names = "#vip-ad-attributes .name",
  css_attribute_values = "#vip-ad-attributes .value",
  css_description = "#vip-ad-description",
  css_bidder = "#vip-bids-top .ellipsis",
  css_bid_amount = ".bid-amount",
  css_bid_date = ".bid-date"
)
