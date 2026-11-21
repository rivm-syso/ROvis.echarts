# Internal helpers ---------------------------------------------------------

#' Generates the JavaScript snippet for legend keyboard and screen reader access.
#'
#' Kept separate from the legend styling in ro_e_build_onrender_js() so it can
#' be switched off or changed on its own. The snippet runs inside the
#' `seriesNames.length > 1` block of that function and expects `container`
#' (the `.ro-legend-container` div) and `chart` (the ECharts instance) in scope.
#'
#' What it adds to every `.ro-legend-item`:
#' - `tabindex="0"` and `role="button"`, so Tab reaches it and it is announced
#'   as a button.
#' - `aria-label` "Legenda: <series>", as on the SPIN chart approved for
#'   accessibility.
#' - `aria-pressed`, kept in sync with the series visibility.
#' - Enter / Space toggle the series, same as a mouse click.
#' - A focus outline that only shows for keyboard focus (`:focus-visible`).
#'
#' @keywords internal
#' @family echarts4r
#' @return A character string of JavaScript.
ro_e_legend_a11y_js <- function() {
  "
        // Legend keyboard and screen reader access (ro_e_legend_a11y_js()).
        (function(container, chart) {
          if (!document.getElementById('ro-legend-a11y-style')) {
            var style = document.createElement('style');
            style.id = 'ro-legend-a11y-style';
            style.textContent =
              '.ro-legend-item:focus { outline: none; }' +
              '.ro-legend-item:focus-visible { outline: 2px solid #333333; outline-offset: 2px; }';
            document.head.appendChild(style);
          }

          container.querySelectorAll('.ro-legend-item').forEach(function(item) {
            var name = item.dataset.name;
            item.setAttribute('tabindex', '0');
            item.setAttribute('role', 'button');
            item.setAttribute('aria-label', 'Legenda: ' + name);
            item.setAttribute('aria-pressed', 'true');

            item.addEventListener('keydown', function(ev) {
              if (ev.key === 'Enter' || ev.key === ' ') {
                ev.preventDefault();
                chart.dispatchAction({ type: 'legendToggleSelect', name: name });
              }
            });
          });

          chart.on('legendselectchanged', function(event) {
            container.querySelectorAll('.ro-legend-item').forEach(function(item) {
              item.setAttribute('aria-pressed', String(!!event.selected[item.dataset.name]));
            });
          });
        })(container, chart);
"
}
