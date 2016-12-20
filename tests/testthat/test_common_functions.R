
testthat::context("Test common functions")

testthat::test_that("check_adv_available() works correctly", {
  testthat::expect_error(
    check_adv_available("")
  )
})

testthat::test_that("check_adv_available() works correctly", {

  ad_ids <- c(1, "1234", "A1119090828","A11190908281")
  testthat::expect_equal(valid_ad_id(ad_ids) , c(F, F, T, T))

})

