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

test_that("ro_e_theme works for all palettes", {
  expect_no_error(bar_chart("categorical"))
  expect_no_error(bar_chart("gender_con"))
  expect_no_error(bar_chart("gender_unc"))
  expect_no_error(bar_chart("full"))
  expect_no_error(bar_chart("greys"))
})

test_that("ro_e_theme errors on invalid palette", {
  expect_error(
    bar_chart("rainbow"),
    "rainbow"
  )
})
