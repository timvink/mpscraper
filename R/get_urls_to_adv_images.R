#' @importFrom magrittr "%>%"
NULL

#' Get urls to adv images
#' 
#' \code{get_urls_to_adv_images} gets the url for each of the images used in an
#' advertisement.
#' 
#' The function uses the html of a marktplaats advertisement to get the 
#' url for each of images linked to that advertisment.
#' 
#' @param html Xml_document containing the html content of an advertisement 
#'   page.
#'   
#' @return a vector object containing strings.
#'   
get_urls_to_adv_images <- function(html) {
  html %>% 
    rvest::html_nodes("#vip-gallery") %>% 
    rvest::html_nodes(".carousel") %>% 
    rvest::html_attr("data-images-l") %>% 
    stringr::str_split("&") %>% 
    unlist() %>% 
    sprintf("http:%s", .) %>% 
    return()
}


