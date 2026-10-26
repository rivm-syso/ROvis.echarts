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
    ro_e_keyboard_nav()

  expect_true(inherits(result, "echarts4r"))
  expect_true(inherits(result, "htmlwidget"))
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
