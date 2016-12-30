# mpscraper: A Marktplaats scraper for R

[![Build Status](https://travis-ci.org/timvink/mpscraper.svg?branch=master)](https://travis-ci.org/timvink/mpscraper)

This R package enables you to web scrape an individual [marktplaats](http://www.marktplaats.nl/) advertisement or all advertisements related to a search query. 
If you want to analyse your own advertisements, you could consider the [official Marktplaats API]().

## Installation

```r 
devtools::install_github("timvink/mpscraper")
```

## Features

- `list_advertisements(url)`: Scrapes a given markplaats search url and returns the list of advertisements (incl ad_id) for all search result pages.
- `scrape_advertisement(ad_id)`: Collects a set of features from a given advertisement id
- `scrape_ads(ad_ids)`: Collects a set of features from a vector of advertisement ids
- `scrape_adv_images(ad_id)`: Collects the available images for a single advertisement id

## Example use case

```r
# Get all advertisements for a certain search query
url <- "http://www.marktplaats.nl/z/telecommunicatie/mobiele-telefoons-apple-iphone/iphone.html?query=iphone&categoryId=1953&sortBy=SortIndex"
ads <- list_advertisements(url, advertisement_type = "individuals", max_pages = 5)

# Build a dataset with the details from all the adds
all_ad_data <- scrape_ads(ads$ad_id)
```

Note that you can find the URL of an ad using the id: `http://www.marktplaats.nl/<id>`.

## List of advertisement features returned

- ID
- timestamp information retrieved
- title
- price
- number of views
- number of favorites
- displayed since
- shipping information
- shipping costs
- reserved
- number_of_photos
- categories 1,2,3
- counterparty name
- counterparty id
- counterparty number of advertisements
- counterparty contact preferences
- counterparty has website
- counterparty telephone number
- counterparty active since
- counterparty location
- biddings enabled
- biddings number
- biddings highest
- biddings lowest
- biddings number of unique bidders
- product attributes
- closed (0 for open and 1 for closed)

## Contribute

Some ideas:

- add in some data cleaning functions for dates, times, durations etc
- add scrape advertiser features
- add scrape ad images features, including for autom. hashing of the image, together with an image URL. 

