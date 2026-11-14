# Public function ----------------------------------------------------------

#' Add keyboard navigation to an echarts4r chart
#'
#'
#' @description
# #' `r ro_group_badge('echarts4r')`
#' `ro_e_keyboard_nav()` attaches JavaScript keyboard event listeners
#' to an echarts4r chart, enabling keyboard-only users to navigate data points.
#' It is designed to follow [ro_e_theme()] at the end of an echarts4r pipeline.
#' Pair it with [ro_e_keyboard_nav_legend()] to make the legend keyboard-accessible.
#'
#' @section Keyboard controls:
#' Arrow keys: move the tooltip across data points. Direction is
#' auto-detected from chart orientation (left/right for column and line
#' charts; up/down for bar charts), or set explicitly via `axis`.
#'
#' @section Axis auto-detection:
#' The function inspects the echarts4r object to determine whether
#' [echarts4r::e_flip_coords()] was applied, and assigns arrow keys
#' accordingly. Override this with the `axis` argument.
#'
#' @param e An echarts4r object.
#' @param axis Character. Arrow-key direction for tooltip navigation. One of
#' `"horizontal"` (ArrowLeft / ArrowRight), `"vertical"` (ArrowUp / ArrowDown),
#' or `"both"`. Default `NULL` auto-detects from the chart orientation.
#'
#' @return The modified echarts4r object, with keyboard navigation attached via
#' [htmlwidgets::onRender()].
#'
#' @seealso
#' * [ro_e_theme()] to apply the RO visual theme.
#' * [ro_e_keyboard_nav_legend()] for legend keyboard accessibility.
#' * [echarts4r::e_flip_coords()] which determines axis orientation.
#' @family echarts4r
#' @examples
#' \dontrun{
#' library(echarts4r)
#'
#' data |>
#'  dplyr::group_by(sex) |>
#'  e_charts(year) |>
#'  e_line(value) |>
#'  e_tooltip(trigger = "axis") |>
#'  ro_e_theme() |>
#'  ro_e_keyboard_nav() |>
#'  ro_e_keyboard_nav_legend()
#' }
#'
#' @importFrom htmlwidgets onRender
#' @export
ro_e_keyboard_nav <- function(e, axis = NULL) {
  if (!is.null(axis)) {
    axis <- arg_match(axis, c("horizontal", "vertical", "both"))
  }

  # Resolve axis direction: auto-detect if not supplied by the user.
  if (is.null(axis)) {
    axis <- ro_e_detect_axis_orientation(e)
  }

  axis_js <- ro_e_keyboard_nav_axis_js(axis)
  js <- ro_e_build_keyboard_nav_js(axis_js)

  onRender(e, js)
}


# Internal helpers ---------------------------------------------------------

#' Generates the JavaScript snippet for arrow-key tooltip navigation.
#'
#' Arrow key direction depends on chart orientation:
#' - "horizontal": ArrowLeft / ArrowRight, reads xAxis
#' - "vertical": ArrowDown / ArrowUp, reads yAxis
#' - "both": all four arrow keys, each bound to the correct axis
#'
#' @keywords internal
#'
#' @param axis One of "horizontal", "vertical", or "both".
#' @family echarts4r
#' @return A character string of JavaScript to be embedded in the onRender body.
ro_e_keyboard_nav_axis_js <- function(axis) {
  horizontal <- "
  if (['ArrowLeft', 'ArrowRight'].includes(pp.code)) {
    if (pp.code == 'ArrowLeft') idx = Math.max(idx - 1, 0);
    if (pp.code == 'ArrowRight') idx = Math.min(idx + 1, myChart.getOption().xAxis[0].data.length - 1);
    myChart.dispatchAction({ type: 'showTip', dataIndex: idx, seriesIndex: sidx });
  }"

  vertical <- "
  if (['ArrowDown', 'ArrowUp'].includes(pp.code)) {
    if (pp.code == 'ArrowDown') idx = Math.max(idx - 1, 0);
    if (pp.code == 'ArrowUp') idx = Math.min(idx + 1, myChart.getOption().yAxis[0].data.length - 1);
    myChart.dispatchAction({ type: 'showTip', dataIndex: idx, seriesIndex: sidx });
  }"

  switch(
    axis,
    horizontal = horizontal,
    vertical = vertical,
    both = paste(horizontal, vertical)
  )
}
