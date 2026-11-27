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

test_that("ro_e_build_onrender_js includes legend accessibility by default", {
  js <- ro_e_build_onrender_js(
    colors = c("#aa0000", "#0000aa"),
    series_names = c("Alpha", "Beta"),
    font_family = "Verdana",
    name_color = "#154273"
  )
  expect_match(js, "ro_e_legend_a11y_js()", fixed = TRUE)
  expect_no_match(js, "__LEGEND_A11Y__", fixed = TRUE)
})

test_that("ro_e_build_onrender_js can leave legend accessibility out", {
  js <- ro_e_build_onrender_js(
    colors = c("#aa0000", "#0000aa"),
    series_names = c("Alpha", "Beta"),
    font_family = "Verdana",
    name_color = "#154273",
    legend_a11y = FALSE
  )
  expect_no_match(js, "ro_e_legend_a11y_js()", fixed = TRUE)
  expect_no_match(js, "__LEGEND_A11Y__", fixed = TRUE)
})

test_that("ro_e_build_onrender_js keeps a user's axis label formatter (#46)", {
  js <- ro_e_build_onrender_js("#aa0000", "Alpha", "Verdana", "#154273")
  expect_match(
    js,
    "var userFmt = a.axisLabel && a.axisLabel.formatter;",
    fixed = TRUE
  )
})

test_that("ro_e_build_onrender_js keeps a user's tooltip formatter (#45)", {
  js <- ro_e_build_onrender_js("#aa0000", "Alpha", "Verdana", "#154273")
  expect_match(
    js,
    "tooltip: userTooltipFmt ? {} : { formatter: tooltipFormatter }",
    fixed = TRUE
  )
})

test_that("ro_e_build_onrender_js formats the tooltip header by axis type (#23)", {
  js <- ro_e_build_onrender_js("#aa0000", "Alpha", "Verdana", "#154273")
  expect_match(js, "toLocaleDateString('nl-NL'", fixed = TRUE)
  expect_match(js, "var catIsY", fixed = TRUE)
  expect_null(
    ro_e_theme_list("categorical", "Verdana")$tooltip$axisPointer$axis
  )
})
