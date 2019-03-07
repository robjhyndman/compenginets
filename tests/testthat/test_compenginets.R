context("compenginets")

test_that("get_cets returns list of time series", {
  expect_equal(length(get_cets("finance")), 100)
})


