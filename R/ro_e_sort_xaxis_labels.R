# Internal helpers ---------------------------------------------------------

#' Make screen readers announce x-axis labels in left-to-right order
#'
#' Internal: called by [ro_e_standard()]. ECharts does not always add x-axis
#' labels to the SVG in their visual order. On a time axis, for example, the
#' year label ("2024") is drawn after the month labels, so screen readers
#' announce it last. This reorders the label nodes to match their
#' left-to-right position on screen.
#'
#' ECharts restores its own element order whenever it redraws (legend toggle,
#' resize, and the resize [ro_e_theme()] does right after the first render), so
#' the sort is re-applied on every `finished` event, not only once. Does nothing
#' for charts without a grid or x-axis (e.g. pie charts), or with
#' `renderer = "canvas"` (no SVG).
#'
#' @param e An echarts4r object.
#'
#' @return The modified echarts4r object, with an [htmlwidgets::onRender()]
#' hook attached.
#'
#' @family echarts4r
#' @keywords internal
#' @importFrom htmlwidgets onRender
ro_e_sort_xaxis_labels <- function(e) {
  onRender(
    e,
    "
  function(el) {
    var myChart = echarts.getInstanceByDom(el);
    if (!myChart) return;

    function sortXAxisLabels() {
      var svg = el.querySelector('svg');
      if (!svg) return;

      var model = myChart.getModel();
      var grid = model.getComponent('grid', 0);
      var xAxis = model.getComponent('xAxis', 0);
      if (!grid || !grid.coordinateSystem || !xAxis || !xAxis.axis) return;

      var gridRect = grid.coordinateSystem.getRect();
      var axisExtent = xAxis.axis.getExtent();
      var svgRect = svg.getBoundingClientRect();
      var gridBottom = gridRect.y + gridRect.height;
      var axisLeft = Math.min(axisExtent[0], axisExtent[1]);
      var axisRight = Math.max(axisExtent[0], axisExtent[1]);

      var labels = Array.prototype.filter.call(svg.querySelectorAll('text'), function(t) {
        var r = t.getBoundingClientRect();
        var relTop = r.top - svgRect.top;
        var relLeft = r.left - svgRect.left;
        return relTop >= gridBottom - 2 && relTop <= gridBottom + 40 &&
          relLeft >= axisLeft - 50 && relLeft <= axisRight + 50;
      });
      if (labels.length < 2) return;

      // Keep the block in its original spot: anchor on whatever currently
      // follows the last label (in document order), then reinsert in
      // sorted order right before that anchor.
      var parent = labels[0].parentNode;
      var byDocPosition = labels.slice().sort(function(a, b) {
        var position = a.compareDocumentPosition(b);
        if (position & Node.DOCUMENT_POSITION_FOLLOWING) return -1;
        if (position & Node.DOCUMENT_POSITION_PRECEDING) return 1;
        return 0;
      });
      var anchor = byDocPosition[byDocPosition.length - 1].nextSibling;

      labels.sort(function(a, b) {
        return a.getBoundingClientRect().left - b.getBoundingClientRect().left;
      });
      labels.forEach(function(label) {
        parent.insertBefore(label, anchor);
      });
    }

    sortXAxisLabels();
    myChart.on('finished', sortXAxisLabels);
  }
  "
  )
}
