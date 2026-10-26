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

test_that("ro_e_keyboard_nav_legend returns an echarts4r object", {
  result <- bar_chart() |> ro_e_keyboard_nav_legend()

  expect_true(inherits(result, "echarts4r"))
  expect_true(inherits(result, "htmlwidget"))
})

test_that("ro_e_keyboard_nav_legend shows no error on a non-themed chart", {
  expect_no_error(
    data_gender |>
      dplyr::group_by(sex) |>
      echarts4r::e_charts(sex) |>
      echarts4r::e_bar(value) |>
      ro_e_keyboard_nav_legend()
  )
})

test_that("ro_e_keyboard_nav_legend shows no error after ro_e_theme", {
  expect_no_error(
    bar_chart() |> ro_e_keyboard_nav_legend()
  )
})
