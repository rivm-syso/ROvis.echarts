#' Detects chart orientation from the echarts4r object.
#'
#' Returns "horizontal" for column/line charts (categories on xAxis) and
#' "vertical" for bar charts (categories on yAxis after e_flip_coords()).
#'
#' Detection strategy: after e_flip_coords(), echarts4r moves category data to
#' yAxis. Check whether e$x$opts$yAxis has a non-NULL `data` element.
#'
#' @keywords internal
#' @family echarts4r
#' @param e An echarts4r object.
#'
#' @return One of "horizontal" or "vertical".
ro_e_detect_axis_orientation <- function(e) {
  y_data <- e$x$opts$yAxis[[1]]$data
  if (!is.null(y_data) && length(y_data) > 0) "vertical" else "horizontal"
}
