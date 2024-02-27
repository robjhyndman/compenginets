context("compenginets")

test_that("get_cets returns list of time series", {
  expect_equal(length(get_cets("finance")), 100L)
})


test_that("category with spaces", {
  expect_equal(length(get_cets("animal sounds", maxpage = 1)), 10L)
})
