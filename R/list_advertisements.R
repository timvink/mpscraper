#' @importFrom magrittr "%>%"
NULL

#' Lists the advertisements listed for a given search url
#'
#' @param url The HTTP URL of a marktplace search page
#'   page.
#' @param advertisement_type Choose which type of advertisements to would like to select
#' @param max_pages limit the number of pages webscrape. Useful for testing. Default is all pages.
#'
#' @return a data frame with title, url and ID of advertisements
#' @export
#' 
#' @examples
#' \dontrun{
#' url <- "http://www.marktplaats.nl/z/telecommunicatie/mobiele-telefoons-apple-iphone/iphone.html?query=iphone&categoryId=1953&sortBy=SortIndex"
#' list_advertisements(url, advertisement_type = "individuals", max_pages = 5)
#' }
list_advertisements <- function(url,
                                advertisement_type = c("both", "individuals", "companies"),
                                max_pages = Inf) {

  advertisement_type <- match.arg(advertisement_type)

  # Create vector of pages to crawl
  n_pages <- get_number_of_adv_pages(url)
  n_pages <- min(n_pages, max_pages)
  page_urls <- paste0(url,"&currentPage=",1:n_pages)

  # Get advs from each page
  advs_data <- purrr::map_df(page_urls, get_advs_overview_from_page)

  # Remove dublicates and filter business advs
  advs_data <- advs_data %>%
    dplyr::distinct(.keep_all = T) %>%
    dplyr::arrange(desc(ad_id))

  switch(advertisement_type,
         both = advs_data,
         individuals = dplyr::filter(advs_data, grepl("m",ad_id)),
         companies = dplyr::filter(advs_data, grepl("a",ad_id)))

}