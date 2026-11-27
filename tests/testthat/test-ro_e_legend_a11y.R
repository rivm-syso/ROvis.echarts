test_that("ro_e_legend_a11y_js adds focus, role, label, state and key handling", {
  js <- ro_e_legend_a11y_js()
  expect_match(
    js,
    "container.setAttribute('aria-label', 'Legenda')",
    fixed = TRUE
  )
  expect_match(js, "tabindex", fixed = TRUE)
  expect_match(js, "role', 'button'", fixed = TRUE)
  expect_match(js, "Legenda: ", fixed = TRUE)
  expect_match(js, "aria-pressed", fixed = TRUE)
  expect_match(js, "ev.key === 'Enter' || ev.key === ' '", fixed = TRUE)
  expect_match(js, "legendToggleSelect", fixed = TRUE)
  expect_match(js, ":focus-visible", fixed = TRUE)
})

test_that("ro_e_legend_a11y_js does not listen on the whole page", {
  js <- ro_e_legend_a11y_js()
  expect_no_match(js, "window.addEventListener", fixed = TRUE)
  expect_no_match(js, "document.addEventListener", fixed = TRUE)
})
