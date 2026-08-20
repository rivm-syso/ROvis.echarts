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

test_that("ro_e_theme accepts a custom font", {
  expect_no_error(
    data_gender |>
      echarts4r::e_charts(sex) |>
      echarts4r::e_bar(value) |>
      ro_e_theme(font = "Verdana")
  )
})

test_that("ro_e_theme errors when the requested font is not installed", {
  expect_error(
    data_gender |>
      echarts4r::e_charts(sex) |>
      echarts4r::e_bar(value) |>
      ro_e_theme(font = "ThisFontDoesNotExist_XYZ"),
    "Can't find"
  )
})

test_that("ro_e_theme_list passes font_family through to tooltip and textStyle", {
  theme <- ro_e_theme_list("categorical", "Arial")

  expect_equal(theme$textStyle$fontFamily, "Arial")
  expect_equal(theme$tooltip$textStyle$fontFamily, "Arial")
})
