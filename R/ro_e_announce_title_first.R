
#' Moves the title's SVG node to be the first child so screen readers
#' announce it before the legend/axes/etc. instead of after.
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
#'  ro_e_announce_title_first()
#' }
#' @importFrom htmlwidgets onRender
ro_e_announce_title_first <- function(fig) {
  fig <- htmlwidgets::onRender(fig, "
  function(el) {
    var myChart = echarts.getInstanceByDom(el);
    var titleText = myChart.getOption().title[0].text;

    function moveTitleFirst() {
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
    window.addEventListener('resize', function() {
      setTimeout(moveTitleFirst, 100);
    });
  }
  ")
  return(fig)
}
