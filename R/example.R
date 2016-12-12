

if(FALSE) {

library(mpscraper)
library(tidyverse)

url <- "http://www.marktplaats.nl/z/telecommunicatie/mobiele-telefoons-apple-iphone/iphone.html?query=iphone&categoryId=1953&sortBy=SortIndex"

ads <- list_advertisements(url, advertisement_type = "individuals", max_pages = 5)
ads

test <- scrape_advertisement(ad_id = "m1108584675")
test

purrr::map()

test2 <- scrape_advertisement(ad_id = "m1116249032")
head(test2)

}






