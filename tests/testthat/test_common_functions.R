
testthat::context("Test common functions") 

testthat::test_that("check_adv_available() works correctly", {
  testthat::expect_error(
    check_adv_available("")
  )
})
