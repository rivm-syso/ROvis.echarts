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

test_that("ro_e_build_onrender_js bakes in colors, series names and legend markup", {
  js <- ro_e_build_onrender_js(
    colors = c("#aa0000", "#0000aa"),
    series_names = c("Alpha", "Beta"),
    font_family = "Verdana",
    name_color = "#154273"
  )
  expect_match(js, "#aa0000")
  expect_match(js, "Alpha")
  expect_match(js, "ro-legend-container")
  expect_match(js, "legendselectchanged")
})
