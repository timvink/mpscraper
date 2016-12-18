
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
#' @examples
#' \dontrun{
#' get_css_element(
#'    html = read_html('http://www.marktplaats.nl/z/telecommunicatie/mobiele-telefoons-apple-iphone/iphone.html?query=iphone&categoryId=1953'),
#'    css = '.price-new',
#'    expecting_one = F
#' )
#' }
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
#' @examples
#' \dontrun{
#' get_n_of_advs_of_counterparty(html = read_html('http://www.marktplaats.nl/a/telecommunicatie/mobiele-telefoons-apple-iphone/m1106778417-apple-telefoon-4s.html'))
#' }
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
#' @examples
#' \dontrun{
#' check_adv_available(html = read_html('http://www.marktplaats.nl/a/telecommunicatie/mobiele-telefoons-apple-iphone/m1106778417-apple-telefoon-4s.html'))
#' }
check_adv_available <- function(html) {
  not_found <- html %>%
    rvest::html_nodes(".evip-caption") %>%
    rvest::html_text()
  if(identical(not_found, character(0))) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
