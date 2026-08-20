data_gender <- data.frame(
  sex = c("Women", "Men"),
  value = c(120, 95)
)

bar_chart <- function(palette = "gender_con") {
  data_gender |>
    dplyr::group_by(sex) |>
    echarts4r::e_charts(sex) |>
    echarts4r::e_bar(value) |>
    ro_e_theme(palette = palette)
}

test_that("ro_e_keyboard_nav returns an echarts4r object", {
  result <- bar_chart() |>
    ro_e_keyboard_nav(series_keys = c(w = "Women", m = "Men"))

  expect_true(inherits(result, "echarts4r"))
  expect_true(inherits(result, "htmlwidget"))
})

test_that("ro_e_keyboard_nav works without series_keys", {
  expect_no_error(
    bar_chart() |> ro_e_keyboard_nav()
  )
})

test_that("ro_e_keyboard_nav works with explicit axis values", {
  expect_no_error(bar_chart() |> ro_e_keyboard_nav(axis = "horizontal"))
  expect_no_error(bar_chart() |> ro_e_keyboard_nav(axis = "vertical"))
  expect_no_error(bar_chart() |> ro_e_keyboard_nav(axis = "both"))
})

test_that("ro_e_keyboard_nav errors on invalid axis value", {
  expect_error(
    bar_chart() |> ro_e_keyboard_nav(axis = "diagonal"),
    "diagonal"
  )
})

test_that("ro_e_keyboard_nav errors when series_keys names are not single letters", {
  expect_error(
    bar_chart() |>
      ro_e_keyboard_nav(series_keys = c(women = "Women", men = "Men")),
    "single letters"
  )
})

test_that("ro_e_keyboard_nav errors when series_keys values are empty strings", {
  expect_error(
    bar_chart() |> ro_e_keyboard_nav(series_keys = c(w = "")),
    "non-empty"
  )
})

test_that("ro_e_keyboard_nav errors when series_keys is unnamed", {
  expect_error(
    bar_chart() |> ro_e_keyboard_nav(series_keys = c("Women", "Men")),
    "named character vector"
  )
})
