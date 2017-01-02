#' @importFrom magrittr "%>%"
NULL

#' @importFrom magrittr "%>%"
NULL


valid_ad_id <- function(ad_id) {
  grepl("[mM|aA][0-9]{9}", ad_id)
}



#' Get css element from html page
#'
#' \code{get_css_element} gets a specific css element from a html page.
#'
#' The function uses a css string to extract information from a specific html
#' node of a html page.
#'
#' @param html Xml_document containing the html content of an advertisements
#'   page.
#' @param css String indicating the css element to extract.
#' @param remove_chars Vector indivating which characters are to be removed from
#'   the result.
#' @param as_numeric Boolean indicating whether the result should be returned as
#'   numeric.
#' @param expecting_one Boolean indicating whether a single result is expected
#'   or a vector of results.
#'
#' @return a character/numeric or vector object.
#'
get_css_element <- function(html, css, remove_chars = c(), as_numeric = FALSE, expecting_one = TRUE) {
  # Get css element from html
  element <- html %>%
    rvest::html_nodes(css) %>%
    rvest::html_text()
  # Remove characters from result if required
  if(length(remove_chars) > 0) {
    for(chars in remove_chars) {
      element <- gsub(chars,"",element)
    }
  }
  # Convert to numeric if required
  if(as_numeric) {
    element <- as.numeric(element)
  }
  # Check if results match expectations
  if(expecting_one & length(element) > 1) {
    message <- paste0("Result of css '",css,"' has results with length of ",length(element)," (instead of 1) having values:\n",paste0(element,collapse="\n"))
    stop(message)
  } else if(length(element) == 0) {
    return(NA)
  } else {
    return(element)
  }
}

#' Get the number of advs of a counterparty
#'
#' \code{get_n_of_advs_of_counterparty} gets the number of advertisements that a
#' counterparty is currently hosting.
#'
#' The function uses the html of a marktplaats advertisement to get the total
#' number of advertisements that the counterparty of the advertisement is
#' hosting on marktplaats.
#'
#' @param html Xml_document containing the html content of an advertisement
#'   page.
#'
#' @return a numeric object.
#'
get_n_of_advs_of_counterparty <- function(html) {
  # Get urls to cp site
  urls <- html %>%
    rvest::html_nodes(".top-info") %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")
  # Filter correct url and get number of advs
  n_advs <- urls[grepl("/verkopers/",urls)] %>%
    xml2::read_html() %>%
    rvest::html_nodes("#soi-breadcrumbs-content li:nth-child(2) span") %>%
    rvest::html_text()
  # Extract value
  stringr::str_extract(n_advs,"[0-9]*") %>%
    as.numeric() %>%
    return()
}

#' Check if advertisement is still available
#'
#' \code{check_adv_available} checks whether a specific advertisement is still
#' available on marktplaats.
#'
#' The function uses the html of a marktplaats advertisement to determine
#' whether the advertisement is still available or whether it has been removed.
#'
#' @param html Xml_document containing the html content of an advertisement
#'   page.
#'
#' @return a boolean.
#'
check_adv_available <- function(html) {
  if(all(grepl("xml",class(html)))) {
    not_found <- html %>%
      rvest::html_nodes(".evip-caption") %>%
      rvest::html_text()
    if(identical(not_found, character(0))) {
      return(TRUE)
    }
  }
  return(FALSE)
}

#' @importFrom magrittr "%>%"
NULL

#' Get the number of pages advs
#'
#' \code{get_number_of_adv_pages} determines the number of pages with
#' advertisements.
#'
#' The function scrapes a specified marktplaats url to determine the number of
#' results pages with advertisements.
#'
#' @param marktplaats_url String containing the marktplaats url, which
#'   corresponds to the results of a search for advertisements.
#'
#' @return a numeric object.
#'
get_number_of_adv_pages <- function(marktplaats_url) {
  marktplaats_iphone <- xml2::read_html(marktplaats_url) %>%
    rvest::html_node("a:nth-child(13)") %>%
    rvest::html_text() %>%
    as.numeric()
}

#' Get the url for each adv on a page
#'
#' \code{get_adv_urls_from_page} gets the url for each of the advertisements on
#' a search results page.
#'
#' The function uses the html of a marktplaats search results page to get the
#' url for each of the advertisments on that page.
#'
#' @param page_html Xml_document containing the html content of a search results
#'   page.
#'
#' @return a vector object containing strings.
#'
get_adv_urls_from_page <- function(page_html) {
  page_html %>%
    rvest::html_nodes(".listing-title-description") %>%
    rvest::html_nodes("h2") %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")
}

#' Get the title for each adv on a page
#'
#' \code{get_adv_titles_from_page} gets the title for each of the advertisements on
#' a search results page.
#'
#' The function uses the html of a marktplaats search results page to get the
#' title for each of the advertisments on that page.
#'
#' @param page_html Xml_document containing the html content of a search results
#'   page.
#'
#' @return a vector object containing strings.
#'
get_adv_titles_from_page <- function(page_html) {
  page_html %>%
    rvest::html_nodes(".listing-title-description") %>%
    rvest::html_nodes(".mp-listing-title") %>%
    rvest::html_attr("title")
}

#' Get info on all advs on a page
#'
#' \code{get_advs_overview_from_page} gets the info on all advertisments on a
#' search results page.
#'
#' The function scrapes a specified marktplaats url corresponding to a search
#' results page. For each advertisement on the page, the title and url are
#' scraped and the advertisement id is extracted from the url. The results are
#' combined into a data.frame and returned.
#'
#' @param page_url String containing the marktplaats url, which corresponds to a
#'   single page with results of a search for advertisements.
#' @param filter_admarkt Boolean indicating whether admarkt advertisements need
#'   to be filtered.
#' @param verbose Boolean indicating whether information on the progress should
#'   be printed during execution.
#'
#' @return a data.frame object, with columns 'title', 'url' and 'ad_id' and one
#'   row per advertisement.
#'
#'
get_advs_overview_from_page <- function(page_url, filter_admarkt = TRUE, verbose = TRUE) {
  # Get html for the page
  page_html <- xml2::read_html(page_url)

  adv_info <- tibble::tibble(
    title = get_adv_titles_from_page(page_html),
    url = get_adv_urls_from_page(page_html)
  ) %>%
    dplyr::mutate(
      url = as.character(stringr::str_replace(url,"html?.*","html")),
      ad_id = as.character(stringr::str_extract(url,'[am][0-9]{1,10}'))
    )

  if(filter_admarkt) {
    adv_info <- adv_info %>%
      dplyr::filter(!grepl("admarkt.marktplaats.nl",url))
  }

  # Message
  if(verbose) print(paste0("Scraped ",dim(adv_info)[1]," advertisements from page ",sub('.*currentPage=(.*).*','\\1',page_url)))
  # Return results
  return(adv_info)
}

