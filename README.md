# mpscraper: A Marktplaats scraper for R

This R package enables you to web scrape an individual [marktplaats](http://www.marktplaats.nl/) advertisement or all advertisements related to a search query. 
If you want to analyse your own advertisements, you could consider the [official Marktplaats API](). If you are more familiar with javascript, have a look at [manuelvanrijn/mp-scraper](https://github.com/manuelvanrijn/mp-scraper).

## Installation

```r 
devtools::install_github("timvink/mpscraper")
```

## Features

- `list_advertisements(url)`: Scrapes a given search url and returns the list of advertisements for all search result pages.
- `scrape_advertisement(id)`: Collects a set of features from a given advertisement id
- `scrape_advertiser(id)`: Collects a set of features from a given advertiser id

## Example use case

```r
# Get all advertisements for a certain search query
url <- "http://www.marktplaats.nl/z/telecommunicatie/mobiele-telefoons-apple-iphone/iphone.html?query=iphone&categoryId=1953&sortBy=SortIndex"
ads <- list_advertisements(url, advertisement_type = "individuals", max_pages = 5)

# Build a dataset with the details from all the adds
todo..
```


## Documentation (todo)

### Scripts
  - ID 
  - title (todo)
	- price
	- number of views
	- number of favorites
	- displayed since
	- shipping information
	- counterparty name
	- counterparty number of advertisements
	- counterparty active since
	- counterparty location
	- list of biddings
	- list of product attributes
	- advertisement description
	- advertisement images


## todo
- finish scrape_* functions
- add in some data cleaning functions
  - date, times, durations, lists etc
- document features and type
- build in a delay scraping feature to prevent being blocked. in seconds and add some random noise from a long tailed distri capped at 10 sec
- think of extra features? 
  - advertiser diversity of ads shown
- upgrade the scrape_ad_image() function with option for autom. hashing of the image, together with an image URL. 
  - check if there is a google image search, so we can determine if the image used is stock or not

### notes

- Get overview of available advertisements
	- `get_number_of_adv_pages()`: determines the number of pages with advertisements
	- `get_adv_urls_from_page()`: gets the url for each of the advertisements on a search results page
	- `get_adv_titles_from_page()`: gets the title for each of the advertisements on a search results page
	- `combine_adv_info_from_page()`: combines the titles and urls of advertisements from a search results page
	- `get_advs_overview_from_page()`: gets the info on all advertisments on a search results page
- Get detailed information on each advertisement
	- `get_css_element()`: gets a specific css element from a html page
	- `get_n_of_advs_of_counterparty()`: gets the number of advertisements that a counterparty is currently hosting
	- `check_adv_available()`: checks whether a specific advertisement is still available
- Get images linked to each advertisement
	- `get_urls_to_adv_images()`: gets the url for each of the images used in an advertisement
	- `download_adv_images_as_jpg()`: downloads images used in an advertisement and stores them in a jpg format in the specified directory
	- `get_adv_images()`: downloads and stores all images used in the advertisement indicated in the specified url


