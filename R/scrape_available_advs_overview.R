
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
#' @examples
#'
#' get_number_of_adv_pages(marktplaats_url = 'http://www.marktplaats.nl/z/telecommunicatie/mobiele-telefoons-apple-iphone/iphone.html?query=iphone&categoryId=1953')
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
#' @examples
#'
#' get_adv_urls_from_page(page_html = read_html('http://www.marktplaats.nl/z/telecommunicatie/mobiele-telefoons-apple-iphone/iphone.html?query=iphone&categoryId=1953'))
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
#' @examples
#'
#' get_adv_titles_from_page(page_html = read_html('http://www.marktplaats.nl/z/telecommunicatie/mobiele-telefoons-apple-iphone/iphone.html?query=iphone&categoryId=1953'))
#'
get_adv_titles_from_page <- function(page_html) {
  page_html %>%
    rvest::html_nodes(".listing-title-description") %>%
    rvest::html_nodes(".mp-listing-title") %>%
    rvest::html_attr("title")
}



#' Combine adv info from a page
#'
#' \code{combine_adv_info_from_page} combines the titles and urls of
#' advertisements from a search results page.
#'
#' The function combines vectors of advertisement titles and urls into a
#' data.frame object, while also extracting the advertisement ids from the urls
#' and optionally filtering admarkt advertisements (which are payed
#' advertisements from companies)
#'
#' @param titles Vector object containing strings corresponding to advertisement
#'   titles.
#' @param urls Vector object containing strings corresponding to advertisement
#'   urls.
#' @param filter_admarkt Boolean indicating whether admarkt advertisements need
#'   to be filtered.
#'
#' @return a data.frame object, with columns 'title', 'url' and 'adv_id' and one
#'   row per advertisement.
#'
#' @examples
#'
#' combine_adv_info_from_page(
#'    titles = c("Adv A","Adv B"),
#'    urls = c("https://url_A","https://url_B")
#' )
#'
combine_adv_info_from_page <- function(titles, urls, filter_admarkt = TRUE) {
  if(length(titles) == length(urls) & length(titles) > 0 ) {
    adv_info <- data.frame(
      title = titles,
      url = urls
    ) %>%
      dplyr::mutate(
        url = stringr::str_replace(url,"html?.*","html"),
        adv_id = stringr::str_extract(url,'[am][0-9]{1,10}')
      )
    # Filter admarkt advs if required
    if(filter_admarkt) {
      adv_info %>%
        dplyr::filter(!grepl("admarkt.marktplaats.nl",url)) %>%
        return()
    } else {
      return(adv_info)
    }
  } else {
    message <- paste0("Length of titles (",length(titles),") is not equal to length of urls (",length(urls),"), please have a look at the functions creating these vectors")
    stop(message)
  }
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
#' @return a data.frame object, with columns 'title', 'url' and 'adv_id' and one
#'   row per advertisement.
#'
#' @export
#' @examples
#'
#' get_advs_overview_from_page(
#'    titles = c("Adv A","Adv B"),
#'    urls = c("https://url_A","https://url_B")
#' )
#'
get_advs_overview_from_page <- function(page_url, filter_admarkt = TRUE, verbose = TRUE) {
  # Get html for the page
  page_html <- page_url %>%
    xml2::read_html()
  # Get adv urls
  page_adv_urls <- page_html %>%
    get_adv_urls_from_page()
  # Get adv titles
  page_adv_titles <- page_html %>%
    get_adv_titles_from_page()
  # Combine titles and urls and return
  adv_info <- combine_adv_info_from_page(
    titles = page_adv_titles,
    urls = page_adv_urls,
    filter_admarkt = filter_admarkt
  )
  # Message
  if(verbose) print(paste0("Scraped ",dim(adv_info)[1]," advertisements from page ",sub('.*currentPage=(.*).*','\\1',page_url)))
  # Return results
  return(adv_info)
}
