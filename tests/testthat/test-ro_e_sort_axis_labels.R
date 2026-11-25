data_gender <- data.frame(
  sex = c("Women", "Men"),
  value = c(120, 95)
)

bar_chart <- function(palette = "gender_con") {
  data_gender |>
    dplyr::group_by(sex) |>
    echarts4r::e_charts(sex) |>
    echarts4r::e_bar(value) |>
    echarts4r::e_title("Gender split") |>
    ro_e_theme(palette = palette)
}

last_hook <- function(e) {
  hooks <- e$jsHooks$render
  hooks[[length(hooks)]]$code
}

test_that("ro_e_sort_axis_labels returns an echarts4r/htmlwidget object", {
  result <- bar_chart() |> ro_e_sort_axis_labels()

  expect_true(inherits(result, "echarts4r"))
  expect_true(inherits(result, "htmlwidget"))
})

test_that("ro_e_sort_axis_labels sorts both axes and re-applies after every redraw", {
  js <- bar_chart() |> ro_e_sort_axis_labels() |> last_hook()

  expect_match(js, "sortAxis(svg, model, 'x')", fixed = TRUE)
  expect_match(js, "sortAxis(svg, model, 'y')", fixed = TRUE)
  expect_match(js, "myChart.on('finished', sortAxisLabels)", fixed = TRUE)
  expect_no_match(js, "window.addEventListener", fixed = TRUE)
})

test_that("ro_e_sort_axis_labels only sorts the labels ECharts reports", {
  js <- bar_chart() |> ro_e_sort_axis_labels() |> last_hook()

  expect_match(js, "getViewLabels", fixed = TRUE)
  expect_match(js, "convertToPixel", fixed = TRUE)
})

test_that("ro_e_sort_axis_labels skips charts without a grid", {
  js <- bar_chart() |> ro_e_sort_axis_labels() |> last_hook()

  expect_match(
    js,
    "if (!grid || !grid.coordinateSystem || !axisModel || !axisModel.axis) return;",
    fixed = TRUE
  )
})

test_that("ro_e_standard includes axis label sorting", {
  result <- data_gender |>
    dplyr::group_by(sex) |>
    echarts4r::e_charts(sex) |>
    echarts4r::e_bar(value) |>
    ro_e_standard()
  js <- paste(unlist(result$jsHooks), collapse = "\n")

  expect_match(js, "sortAxisLabels", fixed = TRUE)
})
