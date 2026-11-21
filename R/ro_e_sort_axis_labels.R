# Internal helpers ---------------------------------------------------------

#' Make screen readers announce axis labels in axis order
#'
#' Internal: called by [ro_e_standard()]. ECharts does not always add axis
#' labels to the SVG in their visual order. On a time axis, for example, the
#' year label ("2024") is drawn after the month labels, so screen readers
#' announce it last. This reorders the label nodes of the first x-axis and the
#' first y-axis to follow the axis from start to end: left to right for a
#' normal x-axis, bottom to top for a normal y-axis, reversed for
#' `inverse = TRUE`. That is also the data order, so category labels on a
#' horizontal bar chart ([echarts4r::e_flip_coords()]) keep their order.
#'
#' Labels are matched on both position (outside the grid, next to the axis)
#' and text (the labels ECharts reports for that axis), so axis names are not
#' sorted in between.
#'
#' ECharts restores its own element order whenever it redraws (legend toggle,
#' resize, and the resize [ro_e_theme()] does right after the first render), so
#' the sort is re-applied on every `finished` event, not only once. Does nothing
#' for charts without a grid (e.g. pie charts), or with `renderer = "canvas"`
#' (no SVG).
#'
#' @param e An echarts4r object.
#'
#' @return The modified echarts4r object, with an [htmlwidgets::onRender()]
#' hook attached.
#'
#' @family echarts4r
#' @keywords internal
#' @importFrom htmlwidgets onRender
ro_e_sort_axis_labels <- function(e) {
  onRender(
    e,
    "
  function(el) {
    var myChart = echarts.getInstanceByDom(el);
    if (!myChart) return;

    // Label texts ECharts shows for an axis, without rich-text markup
    // ('{primary|2024}' -> '2024').
    function axisLabelTexts(axis) {
      var texts = {};
      try {
        axis.getViewLabels().forEach(function(l) {
          var s = String(l.formattedLabel).replace(/[{][^|{}]*[|]([^{}]*)[}]/g, '$1');
          texts[s] = true;
        });
      } catch (err) {
        return null;
      }
      return texts;
    }

    function sortAxis(svg, model, dim) {
      var grid = model.getComponent('grid', 0);
      var axisModel = model.getComponent(dim + 'Axis', 0);
      if (!grid || !grid.coordinateSystem || !axisModel || !axisModel.axis) return;
      var axis = axisModel.axis;

      var texts = axisLabelTexts(axis);
      if (!texts) return;

      // Screen direction of the axis: +1 if it runs left-to-right / top-to-bottom,
      // -1 if it runs right-to-left / bottom-to-top (normal y-axis, inverse x-axis).
      var finder = {};
      finder[dim + 'AxisIndex'] = 0;
      var scaleExtent = axis.scale.getExtent();
      var p0 = myChart.convertToPixel(finder, scaleExtent[0]);
      var p1 = myChart.convertToPixel(finder, scaleExtent[1]);
      var direction = p1 >= p0 ? 1 : -1;

      var rect = grid.coordinateSystem.getRect();
      var svgRect = svg.getBoundingClientRect();
      var labels = Array.prototype.filter.call(svg.querySelectorAll('text'), function(t) {
        if (!texts[t.textContent]) return false;
        var r = t.getBoundingClientRect();
        var top = r.top - svgRect.top;
        var bottom = r.bottom - svgRect.top;
        var left = r.left - svgRect.left;
        var right = r.right - svgRect.left;
        if (dim === 'x') {
          return (top >= rect.y + rect.height - 2 || bottom <= rect.y + 2) &&
            right >= rect.x - 50 && left <= rect.x + rect.width + 50;
        }
        return (right <= rect.x + 2 || left >= rect.x + rect.width - 2) &&
          bottom >= rect.y - 20 && top <= rect.y + rect.height + 20;
      });
      if (labels.length < 2) return;

      function position(t) {
        var r = t.getBoundingClientRect();
        return dim === 'x' ? (r.left + r.right) / 2 : (r.top + r.bottom) / 2;
      }

      // Keep the block in its original spot: anchor on whatever currently
      // follows the last label (in document order), then reinsert in
      // sorted order right before that anchor.
      var parent = labels[0].parentNode;
      var byDocPosition = labels.slice().sort(function(a, b) {
        var p = a.compareDocumentPosition(b);
        if (p & Node.DOCUMENT_POSITION_FOLLOWING) return -1;
        if (p & Node.DOCUMENT_POSITION_PRECEDING) return 1;
        return 0;
      });
      var anchor = byDocPosition[byDocPosition.length - 1].nextSibling;
      if (anchor && anchor.parentNode !== parent) anchor = null;

      labels.sort(function(a, b) {
        return direction * (position(a) - position(b));
      });
      labels.forEach(function(label) {
        parent.insertBefore(label, anchor);
      });
    }

    function sortAxisLabels() {
      var svg = el.querySelector('svg');
      if (!svg) return;
      var model = myChart.getModel();
      sortAxis(svg, model, 'x');
      sortAxis(svg, model, 'y');
    }

    sortAxisLabels();
    myChart.on('finished', sortAxisLabels);
  }
  "
  )
}
