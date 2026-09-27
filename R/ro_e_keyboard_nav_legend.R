#' Improve keyboard accessibility for echarts4r legends
#'
#' `r ROvis.utils::ro_group_badge('toegankelijkheid')`
#'
#' Makes the legend of a \code{echarts4r} plot accessible via keyboard.
#' Users can use Tab to focus legend items and activate them with Enter or Space.
#' Focus indication is only shown when navigating with the keyboard. ARIA attributes are added for screen readers.
#'
#' @param fig A \code{echarts4r} object, requires `renderer = "svg"`, and `rep(list("path://M0,0 L40,0 L40,20 L0,20 Z"), 2)`
#'
#' @return A \code{echarts4r} object with improved legend accessibility.
#'
#' @export
#' @examples
#' \dontrun{
#' data <- tidyr::tibble(
#'   expand.grid(`Age group` = c("A", "B", "C", "D", "E"), `Sex` = c("Man", "Vrouw")),
#'   `Number of Cases` = sample(1:50, 10, TRUE)
#' )
#' data_wide <- data |>
#'   tidyr::pivot_wider(
#'     names_from  = Sex,
#'     values_from = `Number of Cases`
#'   )
#' fig <- data_wide |>
#'   e_charts(`Age group` , renderer = "svg") |>
#'   e_bar(Man, name = "Man") |>
#'   e_bar(Vrouw, name = "Vrouw") |>
#'   e_flip_coords() |>
#'     e_legend(
#'     icons      = rep(list("path://M0,0 L40,0 L40,20 L0,20 Z"), 2),
#'     itemHeight = 16
#'   )
#'
#' fig2 <-   ro_e_keyboard_nav_legend(fig)
#' }
ro_e_keyboard_nav_legend <- function(fig2) {
# Add separate keyboard accessibility for legend items
fig3 <- htmlwidgets::onRender(fig2, "
  function(el) {
    var myChart = echarts.getInstanceByDom(el);

    var keyboardMode = false;
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Tab' || e.key === 'Enter' || e.key === ' ') keyboardMode = true;
    }, true);
    document.addEventListener('mouseup', function(e) { keyboardMode = false; }, true);

    function addLegendKeyboardNav() {
      var option = myChart.getOption();
      var seriesNames = [];

      if (option.series) {
        option.series.forEach(function(s) {
          if (s.name) {
            seriesNames.push(s.name);
          }
        });
      }

      console.log('Series names from chart:', seriesNames);

      var allPaths = el.querySelectorAll('svg path');
      var legendRectPaths = [];
      var legendHitAreaPaths = [];

      allPaths.forEach(function(p) {
        var d = p.getAttribute('d');
        if (d && d.indexOf('M0 1.75L25 1.75L25 14.25L0 14.25Z') !== -1) {
          var transform = p.getAttribute('transform');
          if (transform) {
            legendRectPaths.push(p);
          }
        }
        if (d && d.match(/^M0 1[.]75l[0-9.]+ 0l0 12[.]5l-[0-9.]+ 0Z$/)) {
          var hitAreaTransform = p.getAttribute('transform');
          if (hitAreaTransform && p.getAttribute('fill') === 'none') {
            legendHitAreaPaths.push(p);
          }
        }
      });

      console.log('Found legend rectangle paths:', legendRectPaths.length);

      var legendTexts = el.querySelectorAll('svg text');
      var textElements = [];

      legendTexts.forEach(function(textEl) {
        var content = textEl.textContent || '';
        if (seriesNames.indexOf(content) !== -1) {
          textElements.push({ text: textEl, name: content });
        }
      });

      console.log('Found legend text elements:', textElements.length);

      var legendItems = [];

      textElements.forEach(function(item) {
        var textRect = item.text.getBoundingClientRect();
        var closestPath = null;
        var minDistance = Infinity;

        legendRectPaths.forEach(function(path) {
          if (path.getAttribute('data-legend-setup') === 'true') {
            return;
          }
          var pathRect = path.getBoundingClientRect();
          var distance = Math.abs(pathRect.left - textRect.left) + Math.abs(pathRect.top - textRect.top);

          if (distance < minDistance) {
            minDistance = distance;
            closestPath = path;
          }
        });

        if (closestPath) {
          console.log('Matched', item.name, 'to path at distance', minDistance);
          var closestHitArea = null;
          var hitAreaMinDistance = Infinity;
          legendHitAreaPaths.forEach(function(path) {
            if (path.getAttribute('data-legend-setup') === 'true') {
              return;
            }
            var pathRect = path.getBoundingClientRect();
            var distance = Math.abs(pathRect.left - textRect.left) + Math.abs(pathRect.top - textRect.top);
            if (distance < hitAreaMinDistance) {
              hitAreaMinDistance = distance;
              closestHitArea = path;
            }
          });
          legendItems.push({
            path: closestHitArea || closestPath,
            iconPath: closestPath,
            text: item.text,
            name: item.name
          });
        }
      });

      console.log('Final legend items array:', legendItems.length);

      legendItems.forEach(function(item, idx) {
        var path = item.path;
        var iconPath = item.iconPath;
        var text = item.text;
        var itemName = item.name;

        if (path.getAttribute('data-legend-setup') === 'true') {
          console.log('Skipping already setup legend:', itemName);
          return;
        }

        path.setAttribute('data-legend-setup', 'true');
        path.setAttribute('data-legend-name', itemName);
        path.setAttribute('tabindex', '0');
        path.setAttribute('role', 'button');
        path.setAttribute('aria-label', 'Legenda: ' + itemName);


        var legendSelected = option.legend && option.legend[0] && option.legend[0].selected;
        var isSelected = !legendSelected || legendSelected[itemName] !== false;
        path.setAttribute('aria-pressed', String(isSelected));

        console.log('Setup legend item:', itemName, 'tabindex:', path.getAttribute('tabindex'));

        if (!path.__legendFocusHandler) {
          path.__legendFocusHandler = true;
          path.addEventListener('focus', function() {
            var currentName = path.getAttribute('data-legend-name');
            console.log('Legend item focused:', currentName);
            if (keyboardMode) {
              path.style.outline = '2px solid #333';
              path.style.outlineOffset = '2px';
            } else {
              path.style.outline = 'none';
            }
          });

          path.addEventListener('blur', function() {
            path.style.outline = 'none';
          });
        }

        // Mouse clicks are handled by ECharts itself; adding a DOM handler here
        // would toggle the series a second time and cancel out the click.
        if (!path.__legendKeyHandler) {
          path.__legendKeyHandler = true;
          path.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' || e.key === ' ') {
              e.preventDefault();
              e.stopPropagation();
              var currentName = path.getAttribute('data-legend-name');
              console.log('Legend activated with keyboard:', currentName);
              myChart.dispatchAction({ type: 'legendToggleSelect', name: currentName });
            }
          });
        }
      });
    }

    setTimeout(addLegendKeyboardNav, 600);

    myChart.on('legendselectchanged', function(params) {
      console.log('Legend selection changed event fired');
      var focusedName = params.name;
      setTimeout(function() {
        var oldPaths = el.querySelectorAll('[data-legend-setup]');
        oldPaths.forEach(function(p) {
          p.removeAttribute('data-legend-setup');
          p.removeAttribute('data-legend-name');
        });
        addLegendKeyboardNav();

        if (focusedName) {
          var allPaths = el.querySelectorAll('[data-legend-name]');
          allPaths.forEach(function(p) {
            if (p.getAttribute('data-legend-name') === focusedName) {
              p.focus();
            }
          });
        }
      }, 100);
    });
  }
  ")

return(fig3)
}
