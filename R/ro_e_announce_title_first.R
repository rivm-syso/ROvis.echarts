# Internal helpers ---------------------------------------------------------

#' Make screen readers announce the chart title first
#'
#' Internal: called by [ro_e_standard()]. ECharts draws the title near the end
#' of the SVG, so screen readers announce it after the axes and data. This
#' moves the title's SVG group to the front.
#'
#' ECharts restores its own element order whenever it redraws (legend toggle,
#' resize, and the resize [ro_e_theme()] does right after the first render), so
#' the move is re-applied on every `finished` event, not only once. Does nothing
#' for charts without a title, or with `renderer = "canvas"` (no SVG).
#'
#' @param e An echarts4r object.
#'
#' @return The modified echarts4r object, with an [htmlwidgets::onRender()]
#' hook attached.
#'
#' @family echarts4r
#' @keywords internal
#' @importFrom htmlwidgets onRender
ro_e_announce_title_first <- function(e) {
  onRender(
    e,
    "
  function(el) {
    var myChart = echarts.getInstanceByDom(el);
    if (!myChart) return;

    function moveTitleFirst() {
      var title = myChart.getOption().title;
      var titleText = title && title[0] && title[0].text;
      if (!titleText) return;

      var svg = el.querySelector('svg');
      if (!svg) return;
      var root = svg.querySelector('g');
      if (!root) return;

      var titleEl = null;
      svg.querySelectorAll('text').forEach(function(t) {
        if (t.textContent === titleText) titleEl = t;
      });
      if (!titleEl) return;

      var node = titleEl;
      while (node.parentNode && node.parentNode !== root) {
        node = node.parentNode;
      }
      if (node.parentNode === root && root.firstChild !== node) {
        root.insertBefore(node, root.firstChild);
      }
    }

    moveTitleFirst();
    myChart.on('finished', moveTitleFirst);
  }
  "
  )
}
