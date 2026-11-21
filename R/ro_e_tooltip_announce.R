# Internal helpers ---------------------------------------------------------

#' Generates the JavaScript snippet that reads the tooltip to screen readers.
#'
#' Kept separate from the arrow-key navigation in ro_e_build_keyboard_nav_js()
#' so it can be switched off or changed on its own. The snippet runs inside
#' that function's onRender callback and expects `el` (the chart element) in
#' scope. It defines `announceTooltip()`, which the keydown listener calls
#' after every arrow key.
#'
#' The ECharts tooltip is a plain `div`, so screen readers don't notice when
#' its content changes. This adds a visually hidden live region
#' (`role="status"`, `aria-live="polite"`) to the chart and copies the tooltip
#' text into it, one line per tooltip row separated by commas, e.g.
#' "2016, Groep A: 5, Groep B: 3". Reading the rendered tooltip (instead of
#' the data) keeps the announcement identical to what sighted users see,
#' including the RO number formatting.
#'
#' @keywords internal
#' @family echarts4r
#' @return A character string of JavaScript.
ro_e_tooltip_announce_js <- function() {
  "
      // Screen reader announcement of the tooltip (ro_e_tooltip_announce_js()).
      var liveRegion = document.createElement('div');
      liveRegion.className = 'ro-tooltip-live';
      liveRegion.setAttribute('role', 'status');
      liveRegion.setAttribute('aria-live', 'polite');
      liveRegion.setAttribute('aria-atomic', 'true');
      liveRegion.style.cssText =
        'position:absolute;width:1px;height:1px;margin:-1px;padding:0;' +
        'overflow:hidden;clip:rect(0 0 0 0);white-space:nowrap;border:0;';
      el.appendChild(liveRegion);

      function announceTooltip() {
        // ECharts may render the tooltip content asynchronously.
        setTimeout(function() {
          var tip = null;
          for (var i = 0; i < el.children.length; i++) {
            if (el.children[i].style.zIndex === '9999999') tip = el.children[i];
          }
          if (!tip || tip.style.display === 'none') return;
          var text = tip.innerText.split('\\n').map(function(s) {
            return s.trim();
          }).filter(Boolean).join(', ');
          if (text) liveRegion.textContent = text;
        }, 50);
      }
"
}
