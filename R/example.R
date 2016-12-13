

if(FALSE) {

url <- "http://www.marktplaats.nl/z/telecommunicatie/mobiele-telefoons-apple-iphone/iphone.html?query=iphone&categoryId=1953&sortBy=SortIndex"
ads <- list_advertisements(url, advertisement_type = "individuals", max_pages = 5)
ads

test <- scrape_advertisement(ad_id = "m1116224541")
test

test2 <- scrape_advertisement(ad_id = "m1116309415")
head(test2)

test2 <- scrape_advertisement(ad_id = "a1011385991")
ad_id = ""

adsdf <- lapply(ads$adv_id[1:15], scrape_advertisement, verbose = T)
bind_rows(adsdf) %>% View

# nog verder te doen
#- Update advertentie schrijven?
#- aantal biedingen, views, of hij nu wel of niet gereserveerd is?

# hier een verlopen advertentie: m949656304 

# more tests, incl travisCI badge

# document features in README

# experiment with OpenImageR
library(OpenImageR)

path = '~/Downloads/image.jpeg'
im = readImage(path)
imageShow(im)
# https://www.r-bloggers.com/openimager-an-image-processing-toolkit/
# pHash algoritm
# http://www.hackerfactor.com/blog/index.php?/archives/529-Kind-of-Like-That.html

phash(rgb_2gray(im), hash_size = 8, highfreq_factor = 4, MODE = 'hash', resize = "bilinear")

# Add up to 24 images. We can image hash them

}







