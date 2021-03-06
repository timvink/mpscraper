% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scrape_advs_images.R
\name{download_adv_images_as_jpg}
\alias{download_adv_images_as_jpg}
\title{Download adv images as jpg}
\usage{
download_adv_images_as_jpg(images, storage_dir, prefix)
}
\arguments{
\item{images}{Vector of strings corresponding to urls.}

\item{storage_dir}{String indicating the storage location for the downloaded
images.}

\item{prefix}{String indicating the prefix to be used when storing the
images.}
}
\value{
No return.
}
\description{
\code{download_adv_images_as_jpg} downloads images used in an advertisement 
and stores them in a jpg format in the specified directory.
}
\details{
The function uses a vector of urls corresponding to images used in an 
advertisement, to loop over each url to download the image and store it in 
the specified directory.
}
