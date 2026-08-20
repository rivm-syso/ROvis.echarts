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
