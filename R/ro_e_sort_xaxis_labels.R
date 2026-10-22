
#' Reorders x-axis label text nodes to match their left-to-right
#' (chronological) on-screen order, since echarts' anti-overlap label layout
#' can append them out of sequence. This ensures screen readers announce the
#' labels in chronological order instead of DOM-insertion order.
#'
#' @param fig An echarts4r/htmlwidget figure.
#'
#' @return The figure, wrapped with an `htmlwidgets::onRender()` call.
#'
#' @family echarts4r
#' @examples
#' \dontrun{
#' library(echarts4r)
#'
#' mtcars |>
#'  e_charts(wt) |>
#'  e_scatter(mpg) |>
#'  e_title("mtcars as title") |>
#'  ro_e_theme() |>
#'  ro_e_sort_xaxis_labels()
#' }
#' @importFrom htmlwidgets onRender
ro_e_sort_xaxis_labels <- function(fig) {
  fig <- htmlwidgets::onRender(fig, "
  function(el) {
    var myChart = echarts.getInstanceByDom(el);

    function sortXAxisLabels() {
      var svg = el.querySelector('svg');
      if (!svg) return;

      var model = myChart.getModel();
      var gridRect = model.getComponent('grid', 0).coordinateSystem.getRect();
      var axisExtent = model.getComponent('xAxis', 0).axis.getExtent();
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
    window.addEventListener('resize', function() {
      setTimeout(sortXAxisLabels, 100);
    });
  }
  ")
  return(fig)
}
