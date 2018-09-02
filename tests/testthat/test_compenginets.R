context("compenginets")

test_that("get_cets returns list of time series", {
  expect_is(get_cets("finance"), "list")
  expect_equal(unique(sapply(get_cets("meteorology"), class)), "numeric")
  expect_error(get_cets("asdfghjkl"), "No category matches the keyword.")
  expect_error(get_cets("asdfghjkl", FALSE), "No matched time series was found")
  expect_warning(get_cets("model"), "More than one category matched")
  expect_identical(names(attributes(get_cets("finance")[[1]])), colnames(meta))
})


test_that("category information", {
  expect_is(cate_path, "list")
  expect_true(length(unique(sapply(cate_path, length))) != 1)

})
