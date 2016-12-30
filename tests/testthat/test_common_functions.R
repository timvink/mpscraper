
testthat::context("Test common functions")

testthat::test_that("valid_ad_id() works correctly", {
  testthat::expect_true(valid_ad_id("m1121381310"))
  testthat::expect_true(valid_ad_id("a1121381310"))
  testthat::expect_true(valid_ad_id("a0121381310"))
  testthat::expect_true(valid_ad_id("m1121380310"))
  testthat::expect_false(valid_ad_id("m112138131011"))
  testthat::expect_false(valid_ad_id("mm1213131011"))
  testthat::expect_false(valid_ad_id("m1121380i10"))
  testthat::expect_false(valid_ad_id("y1121380110"))
  testthat::expect_false(valid_ad_id("01121380110"))
  testthat::expect_false(valid_ad_id("aa1121380110"))
  
  ad_ids <- c(1, "1234", "A1119090828","A11190908281")
  testthat::expect_equal(valid_ad_id(ad_ids) , c(F, F, T, F))
  
})


testthat::test_that("check_adv_available() works correctly", {
  testthat::expect_error(
    check_adv_available("")
  )
})

