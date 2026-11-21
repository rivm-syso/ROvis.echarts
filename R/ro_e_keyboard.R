# Internal helpers ---------------------------------------------------------

#' Add arrow-key tooltip navigation to an echarts4r chart
#'
#' Internal: called by [ro_e_standard()]. Attaches a keydown listener that
#' moves the tooltip across data points with the arrow keys. Direction is
#' auto-detected from the chart orientation ([echarts4r::e_flip_coords()]
#' gives up/down, otherwise left/right), or set explicitly via `axis`.
#'
#' @param e An echarts4r object.
#' @param axis Character. One of `"horizontal"`, `"vertical"`, or `"both"`.
#' Default `NULL` auto-detects from the chart orientation.
#'
#' @return The modified echarts4r object, with keyboard navigation attached via
#' [htmlwidgets::onRender()].
#' @keywords internal
#' @family echarts4r
#' @importFrom htmlwidgets onRender
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
