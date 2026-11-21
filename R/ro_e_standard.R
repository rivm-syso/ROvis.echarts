# Public function ----------------------------------------------------------

#' Apply the RO style and accessibility features to an echarts4r chart
#'
#' @description
#' `ro_e_standard()` is the recommended way to finish an echarts4r chart. It
#' applies the RO visual style with [ro_e_theme()] and adds all accessibility
#' features on top. Use [ro_e_theme()] instead only when you need the styling
#' without the extra accessibility features, for example for a chart type that
#' `ro_e_standard()` does not cover.
#'
#' @section Accessibility features:
#' * **Legend**: Tab focuses legend items, Enter or Space toggles a series.
#'   Screen readers announce each item as a button with its on/off state. This
#'   is part of the legend that [ro_e_theme()] draws, so it is there with
#'   [ro_e_theme()] too.
#' * **Arrow keys** move the tooltip across data points. The direction is
#'   auto-detected from the chart orientation (left/right for column and line
#'   charts, up/down for horizontal bar charts made with
#'   [echarts4r::e_flip_coords()]), or set explicitly with `axis`.
#'
#' @inheritParams ro_e_theme
#' @param axis Character. Arrow-key direction for tooltip navigation. One of
#' `"horizontal"` (ArrowLeft / ArrowRight), `"vertical"` (ArrowUp / ArrowDown),
#' or `"both"`. Default `NULL` auto-detects from the chart orientation.
#'
#' @return The modified echarts4r object.
#'
#' @seealso
#' * [ro_e_theme()] for the styling only.
#' * [ROvis.utils::ro_color_palette()] to inspect the available palettes.
#'
#' @examples
#' \dontrun{
#' library(echarts4r)
#'
#' data.frame(
#'   week = factor(rep(1:5, 2)),
#'   sex = rep(c("Women", "Men"), each = 5),
#'   n = c(12, 15, 11, 18, 20, 10, 13, 14, 16, 17)
#' ) |>
#'   dplyr::group_by(sex) |>
#'   e_charts(week) |>
#'   e_line(n) |>
#'   e_tooltip(trigger = "axis") |>
#'   ro_e_standard(palette = "gender_con")
#' }
#'
#' @family echarts4r
#' @export
ro_e_standard <- function(
  e,
  palette = "categorical",
  fixed_aspect = TRUE,
  font = NULL,
  renderer = "svg",
  axis = NULL
) {
  e |>
    ro_e_theme(
      palette = palette,
      fixed_aspect = fixed_aspect,
      font = font,
      renderer = renderer
    ) |>
    ro_e_keyboard_nav(axis = axis)
}
