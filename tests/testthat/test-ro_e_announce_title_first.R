data_gender <- data.frame(
  sex = c("Women", "Men"),
  value = c(120, 95)
)

bar_chart <- function(palette = "gender_con") {
  data_gender |>
    dplyr::group_by(sex) |>
    echarts4r::e_charts(sex) |>
    echarts4r::e_bar(value) |>
    echarts4r::e_title("Title to announce") |>
    ro_e_theme(palette = palette)
}

test_that("ro_e_announce_title_first returns an echarts4r/htmlwidget object", {
  result <- bar_chart() |> ro_e_announce_title_first()

  expect_true(inherits(result, "echarts4r"))
  expect_true(inherits(result, "htmlwidget"))
})

test_that("ro_e_announce_title_first attaches an onRender hook", {
  result <- bar_chart() |> ro_e_announce_title_first()

  expect_true(length(result$jsHooks$render) > 0)

  js <- result$jsHooks$render[[length(result$jsHooks$render)]]$code
  expect_match(js, "moveTitleFirst")
  expect_match(js, "insertBefore")
})

