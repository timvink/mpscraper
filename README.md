# mpscraper: A Marktplaats scraper for R

This R package enables you to web scrape an individual [marktplaats](http://www.marktplaats.nl/) advertisement or all advertisements related to a search query. 

## Installation

```r 
devtools::install_github("timvink/mpscraper")
```

## Features

`list_advertisements(url)`: zoekopdracht. list of advertisements
`scrape_advertisement(id)`: ...
`scrape_advertiser(id)`: ... 

## Using mpscraper

```r
# Get all advertisements for a certain search query
url <- "http://www.marktplaats.nl/z/telecommunicatie/mobiele-telefoons-apple-iphone/iphone.html?query=iphone&categoryId=1953&sortBy=SortIndex"
ads <- list_advertisements(url, advertisement_type = "individuals", max_pages = 5)

# Build a dataset with the details from all the adds
todo..
```

## Documentation (todo)

### Functions

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

### Scripts
- `gather_iphone_advs_data()`: Scraping all available advertisements on Marktplaats within the group *Telecommunicatie* and column *Mobiele telefoons | Apple iPhone* while using the query *iphone* and sorting by *date desc*, to collect the following informatie for each advertisement:
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


