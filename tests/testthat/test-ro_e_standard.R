data_gender <- data.frame(
  sex = c("Women", "Men"),
  value = c(120, 95)
)

bar <- function() {
  data_gender |>
    dplyr::group_by(sex) |>
    echarts4r::e_charts(sex) |>
    echarts4r::e_bar(value)
}

test_that("ro_e_standard returns an echarts4r object", {
  result <- bar() |> ro_e_standard(palette = "gender_con")
  expect_true(inherits(result, "echarts4r"))
  expect_true(inherits(result, "htmlwidget"))
})

test_that("ro_e_standard adds theme and keyboard navigation", {
  result <- bar() |> ro_e_standard(palette = "gender_con")
  js <- paste(unlist(result$jsHooks), collapse = "\n")
  expect_match(js, "ro-legend-container", fixed = TRUE)
  expect_match(js, "ro_e_legend_a11y_js()", fixed = TRUE)
  expect_match(js, "ArrowLeft", fixed = TRUE)
})

test_that("ro_e_standard passes axis and theme arguments on", {
  result <- suppressWarnings(
    bar() |> ro_e_standard(axis = "vertical", renderer = "canvas")
  )
  js <- paste(unlist(result$jsHooks), collapse = "\n")
  expect_match(js, "ArrowUp", fixed = TRUE)
  expect_no_match(js, "ArrowLeft", fixed = TRUE)
  expect_equal(result$x$renderer, "canvas")
})

test_that("ro_e_standard errors on invalid axis value", {
  expect_error(bar() |> ro_e_standard(axis = "diagonal"), "diagonal")
})

test_that("ro_e_standard warns that screen reader fixes need svg", {
  expect_warning(bar() |> ro_e_standard(renderer = "canvas"), "svg")
  expect_no_warning(bar() |> ro_e_standard())
})
