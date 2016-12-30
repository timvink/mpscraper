#' @importFrom magrittr "%>%"
NULL

image_hash <- function(img_loc) {
  
  if(!file.exists(img_loc)) 
    stop(sprintf("File does not exists: %s", img_loc))
  
  im = OpenImageR::readImage(img_loc)
  
  # pHash algoritm
  # https://www.r-bloggers.com/openimager-an-image-processing-toolkit/
  # http://www.hackerfactor.com/blog/index.php?/archives/529-Kind-of-Like-That.html
  
  OpenImageR::phash(
    OpenImageR::rgb_2gray(im),
    hash_size = 8, 
    highfreq_factor = 4, 
    MODE = 'hash', 
    resize = "bilinear"
  ) %>% return()
  
}