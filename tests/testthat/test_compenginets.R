context("compenginets")

test_that("get_cets returns list of time series", {
  expect_is(get_cets("finance"), "list")
  expect_equal(unique(sapply(get_cets("meteorology"), class)), "numeric")
  expect_error(get_cets("asdfghjkl"), "No matched time series was found")
})



