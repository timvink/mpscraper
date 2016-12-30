#' @importFrom magrittr "%>%"
NULL

image_download <- function(url, prefix, storage_dir, include_hash) {
  img_code <- url %>% 
    dirname() %>% 
    stringr::str_match(".{16}$") %>% .[,1]
  
  img_name <- file.path(storage_dir, 
                        sprintf("%s_%s.jpg", prefix, img_code))
  
  utils::download.file(
    url = url,
    destfile = img_name,
    quiet = TRUE,
    mode = "wb"
  )
  
  return(img_name)
}