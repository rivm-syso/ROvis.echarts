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

test_that("ro_e_sort_xaxis_labels returns an echarts4r/htmlwidget object", {
  result <- bar_chart() |> ro_e_sort_xaxis_labels()

  expect_true(inherits(result, "echarts4r"))
  expect_true(inherits(result, "htmlwidget"))
})

test_that("ro_e_sort_xaxis_labels sorts and re-applies after every redraw", {
  js <- bar_chart() |> ro_e_sort_xaxis_labels() |> last_hook()

  expect_match(js, "insertBefore", fixed = TRUE)
  expect_match(js, "myChart.on('finished', sortXAxisLabels)", fixed = TRUE)
  expect_no_match(js, "window.addEventListener", fixed = TRUE)
})

test_that("ro_e_sort_xaxis_labels skips charts without a grid or x-axis", {
  js <- bar_chart() |> ro_e_sort_xaxis_labels() |> last_hook()

  expect_match(
    js,
    "if (!grid || !grid.coordinateSystem || !xAxis || !xAxis.axis) return;",
    fixed = TRUE
  )
})

test_that("ro_e_standard includes x-axis label sorting", {
  result <- data_gender |>
    dplyr::group_by(sex) |>
    echarts4r::e_charts(sex) |>
    echarts4r::e_bar(value) |>
    ro_e_standard()
  js <- paste(unlist(result$jsHooks), collapse = "\n")

  expect_match(js, "sortXAxisLabels", fixed = TRUE)
})
