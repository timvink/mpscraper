
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
#' @examples
#' \dontrun{
#' get_urls_to_adv_images(html = read_html('http://www.marktplaats.nl/a/telecommunicatie/mobiele-telefoons-apple-iphone/m1106778417-apple-telefoon-4s.html'))
#' }
get_urls_to_adv_images <- function(html) {
  html %>% 
    html_nodes("#vip-gallery") %>% 
    html_nodes(".carousel") %>% 
    html_attr("data-images-l") %>% 
    str_split("&") %>% 
    unlist() %>% 
    return()
}

#' Download adv images as jpg
#' 
#' \code{download_adv_images_as_jpg} downloads images used in an advertisement 
#' and stores them in a jpg format in the specified directory.
#' 
#' The function uses a vector of urls corresponding to images used in an 
#' advertisement, to loop over each url to download the image and store it in 
#' the specified directory.
#' 
#' @param images Vector of strings corresponding to urls.
#' @param storage_dir String indicating the storage location for the downloaded
#'   images.
#' @param prefix String indicating the prefix to be used when storing the
#'   images.
#'   
#' @return No return.
#'   
#' @examples
#' \dontrun{
#' download_adv_images_as_jpg(
#'    images = c('//i.marktplaats.com/00/s/NzIwWDk2MA==/z/zH8AAOSwcUBYJalk/$_84.JPG'),
#'    storage_dir = "C:/",
#'    prefix = 'm1106778417'
#' )
#' }
download_adv_images_as_jpg <- function(images,storage_dir,prefix) {
  # Determine number of images to store
  n_images <- length(images)
  # Create set of locations to save to
  image_files <- paste0(storage_dir,"/",prefix,"_",1:n_images,".jpg")
  # Download and save each file
  for(i in 1:n_images) {
    download.file(
      url = paste0("http:",images[i]),
      destfile = image_files[i],
      quiet = TRUE,
      mode="wb"
    )
  }
}

#' Get adv images
#' 
#' \code{get_adv_images} downloads and stores all images used in the 
#' advertisement indicated in the specified url.
#' 
#' The function uses a string containing the url to an advertisement to download
#' and store all images linked to that advertisement.
#' 
#' @param adv_url String containing the url to an advertisement.
#' @param storage_dir String indicating the storage location for the downloaded 
#'   images.
#'   
#' @return No return.
#'   
#' @examples
#' \dontrun{
#' get_adv_images(
#'    adv_url = 'http://www.marktplaats.nl/a/telecommunicatie/mobiele-telefoons-apple-iphone/m1106778417-apple-telefoon-4s.html',
#'    storage_dir = "C:/"
#' )
#' }
get_adv_images <- function(adv_url, storage_dir = "") {
  # Get html for the page
  adv_html <- adv_url %>% 
    read_html()
  # Get add if still available
  if(check_adv_available(adv_html)) {
    # Get images if required
    if(dir.exists(storage_dir)) {
      images <- get_urls_to_adv_images(adv_html)
      if(images[1] != "") {
        download_adv_images_as_jpg(
          images = images,
          storage_dir = storage_dir,
          prefix = get_adv_id(adv_url)
        )
      }
    } else {
      message <- paste0("The indicated storage_dir '",storage_dir,"' does not exist, please specify an existing folder and try again...")
      stop(message)
    }
  }
}
