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

test_that("ro_e_theme returns an echarts4r object", {
  result <- bar_chart()

  expect_true(inherits(result, "echarts4r"))
  expect_true(inherits(result, "htmlwidget"))
})

test_that("ro_e_theme applies a theme to the chart", {
  result <- bar_chart()

  expect_false(is.null(result$x$theme))
})

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

test_that("theme applies correct typography settings", {
  theme <- ro_e_theme_list("categorical", "Verdana")

  expect_equal(theme$title$textStyle$fontSize, 17)
  expect_equal(theme$title$subtextStyle$fontSize, 14)
  expect_equal(theme$title$subtextStyle$color, ro_color("lintblauw"))

  expect_equal(theme$categoryAxis$axisLabel$fontSize, 12)
  expect_equal(theme$valueAxis$axisLabel$fontSize, 12)

  expect_equal(theme$categoryAxis$nameTextStyle$fontSize, 13)
  expect_equal(theme$categoryAxis$nameTextStyle$color, ro_color("lintblauw"))
  expect_equal(theme$valueAxis$nameTextStyle$fontSize, 13)
  expect_equal(theme$valueAxis$nameTextStyle$color, ro_color("lintblauw"))

  expect_equal(theme$tooltip$textStyle$fontSize, 13)
  expect_equal(theme$tooltip$textStyle$color, "#000000")
})

test_that("ro_e_theme_list passes font_family through to tooltip and textStyle", {
  theme <- ro_e_theme_list("categorical", "Arial")

  expect_equal(theme$textStyle$fontFamily, "Arial")
  expect_equal(theme$tooltip$textStyle$fontFamily, "Arial")
})

test_that("theme applies correct axis line and grid settings", {
  theme <- ro_e_theme_list("categorical", "Verdana")

  expect_equal(theme$categoryAxis$axisLine$lineStyle$width, 1.5)
  expect_equal(theme$categoryAxis$axisTick$lineStyle$width, 1.5)
  expect_equal(theme$categoryAxis$axisTick$length, 4)

  expect_equal(theme$valueAxis$splitLine$lineStyle$color, ro_color("grijs_8"))
  expect_equal(theme$valueAxis$splitLine$lineStyle$width, 0.25)

  expect_equal(theme$timeAxis$axisLine$lineStyle$width, 1.5)
  expect_equal(theme$timeAxis$axisTick$lineStyle$width, 1.5)
  expect_equal(theme$timeAxis$axisTick$length, 4)

  expect_equal(theme$logAxis$splitLine$lineStyle$color, ro_color("grijs_8"))
  expect_equal(theme$logAxis$splitLine$lineStyle$width, 0.25)
})

test_that("theme applies correct axis title positioning", {
  theme <- ro_e_theme_list("categorical", "Verdana")

  expect_equal(theme$categoryAxis$nameLocation, "end")
  expect_equal(theme$categoryAxis$nameGap, 0)
  expect_equal(theme$categoryAxis$nameTextStyle$align, "right")
  expect_equal(theme$categoryAxis$nameTextStyle$verticalAlign, "top")
  expect_equal(theme$categoryAxis$nameTextStyle$padding, c(25, 0, 0, 0))

  expect_equal(theme$valueAxis$nameLocation, "end")
  expect_equal(theme$valueAxis$nameGap, 9)
  expect_equal(theme$valueAxis$nameRotate, 0)
  expect_equal(theme$valueAxis$nameTextStyle$align, "left")

  expect_equal(theme$timeAxis$nameLocation, "end")
  expect_equal(theme$timeAxis$nameGap, 0)
  expect_equal(theme$timeAxis$nameTextStyle$align, "right")
  expect_equal(theme$timeAxis$nameTextStyle$verticalAlign, "top")
  expect_equal(theme$timeAxis$nameTextStyle$padding, c(25, 0, 0, 0))

  expect_equal(theme$logAxis$nameLocation, "end")
  expect_equal(theme$logAxis$nameGap, 9)
  expect_equal(theme$logAxis$nameRotate, 0)
  expect_equal(theme$logAxis$nameTextStyle$align, "left")
})

test_that("theme applies correct legend settings", {
  theme <- ro_e_theme_list("categorical", "Verdana")

  expect_equal(theme$legend$itemWidth, 24)
  expect_equal(theme$legend$itemHeight, 12)

  expect_equal(theme$legend$icon, "rect")
  expect_equal(theme$legend$itemStyle$borderWidth, 0)

  expect_equal(theme$legend$emphasis$itemStyle$borderWidth, 0)
  expect_equal(theme$legend$emphasis$itemStyle$borderRadius, 0)
  expect_equal(theme$legend$emphasis$label$fontWeight, "bold")
  expect_equal(theme$legend$emphasis$label$color, ro_color("hemelblauw"))

  expect_equal(theme$legend$inactiveStyle$textStyle$color, "#c8c8c8")

  expect_equal(theme$legend$textStyle$fontSize, 13)
})

test_that("ro_e_theme attaches the custom legend onRender hook", {
  result <- bar_chart()
  expect_true(length(result$jsHooks$render) > 0)
})

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
