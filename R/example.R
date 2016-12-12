

if(FALSE) {

library(mpscraper)
library(tidyverse)

url <- "http://www.marktplaats.nl/z/telecommunicatie/mobiele-telefoons-apple-iphone/iphone.html?query=iphone&categoryId=1953&sortBy=SortIndex"

ads_list <- list_advertisements(url, advertisement_type = "individuals", max_pages = 5)

test <- scrape_advertisement(ads_list$url[1])
ads <- purrr::map_df(ads_list$url, scrape_advertisement)

head(ads)

}






