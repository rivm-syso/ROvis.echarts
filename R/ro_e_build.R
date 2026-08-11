# Internal helpers ---------------------------------------------------------


#' Generates the JavaScript snippet for legend-toggle keyboard navigation.
#'
#' One JS line is emitted per entry in series_keys.
#'
#' Key name format: paste0("Key", toupper(names(series_keys)))
#' e.g. c(w = "Women", m = "Men") becomes 'KeyW', 'KeyM'
#'
#' @keywords internal
#' @family echarts4r
#' @param series_keys Named character vector, or NULL.
#'
#' @return A character string of JavaScript, or "" when series_keys is NULL.
ro_e_keyboard_nav_legend_js <- function(series_keys) {
  if (is.null(series_keys)) {
    return("")
  }

  js_lines <- sprintf(
    "if (pp.code == 'Key%s') myChart.dispatchAction({ type: 'legendToggleSelect', name: '%s' });",
    toupper(names(series_keys)),
    series_keys
  )
  paste(js_lines, collapse = "\n")
}

#' Wraps axis and legend JS snippets in the full onRender callback template.
#'
#' @keywords internal
#'
#' @param axis_js Character. Output of ro_e_keyboard_nav_axis_js().
#' @param legend_js Character. Output of ro_e_keyboard_nav_legend_js().
#' @family echarts4r
#' @return A single JavaScript string ready for htmlwidgets::onRender().
ro_e_build_keyboard_nav_js <- function(axis_js, legend_js) {
  sprintf(
    "function(el) {
      const myChart = echarts.getInstanceByDom(el)
      var idx = 0
      var sidx = 0
      window.addEventListener('keydown', function(pp) {
        %s
        %s
      })
    }",
    axis_js,
    legend_js
  )
}

# onRender helper -----------------------------------------------------------

#' Builds the single onRender JS for the RO theme.
#'
#' Handles legend replacement, tooltip formatter, and axis number formatting in
#' one function so there is only one chart.setOption() call. Multiple separate
#' setOption() calls risk re-applying theme defaults (including re-showing the
#' native legend), because ECharts merges each call against the registered theme.
#'
#' Colors and series names are baked in from R. ECharts theme-registered
#' colors are not returned by chart.getOption(), so we pass them explicitly.
#'
#' @keywords internal
#'
#' @param colors Character vector of hex colors (from ro_color_palette()).
#' @param series_names Character vector of series names from the echarts4r object.
#' @param font_family Font family string resolved by ro_e_theme().
#' @param fixed_aspect Logical. When TRUE the chart enforces a 2:1 width:height
#'   aspect ratio and stays responsive on resize.
#' @family echarts4r
#' @return A JavaScript string for htmlwidgets::onRender().
ro_e_build_onrender_js <- function(
  colors,
  series_names,
  font_family,
  name_color,
  fixed_aspect = TRUE
) {
  colors_json <- jsonlite::toJSON(colors, auto_unbox = FALSE)
  names_json <- jsonlite::toJSON(series_names, auto_unbox = FALSE)
  font_family_json <- jsonlite::toJSON(font_family, auto_unbox = TRUE)
  name_color_json <- jsonlite::toJSON(name_color, auto_unbox = TRUE)
  fixed_aspect_json <- jsonlite::toJSON(fixed_aspect, auto_unbox = TRUE)

  js <- "function(el) {
      var chart = echarts.getInstanceByDom(el);
      if (!chart) return;

      var palette = __COLORS__;
      var seriesNames = __NAMES__;
      var fontFamily = __FONT_FAMILY__;
      var nameColor = __NAME_COLOR__;
      var fixedAspect = __FIXED_ASPECT__;
      var lastW = Math.round(el.getBoundingClientRect().width);

      // Read current options once: used for axis formatter updates and axis title caching.
      var opt0 = chart.getOption();
      var xTitle = (opt0.xAxis && opt0.xAxis[0] && opt0.xAxis[0].name) || '';
      var yTitle = (opt0.yAxis && opt0.yAxis[0] && opt0.yAxis[0].name) || '';

      // ECharts nameTextStyle.padding on a value axis uses a rotated coordinate
      // system, so the label ends up in the wrong place on a horizontal bar chart.
      // We capture the name early, clear it from the axis, and re-draw it as a
      // graphic element in doLayout() where we know the exact grid rect.
      var hBarXName = (function() {
        var ax = opt0.xAxis && opt0.xAxis[0] || {};
        return ((ax.type === 'value' || ax.type === 'log') && ax.name) ? ax.name : '';
      })();

      var nlFmt = function(v) {
        var n = Number(v);
        return isFinite(n) ? n.toLocaleString('nl-NL') : String(v);
      };

      // Square inline marker for tooltip rows: matches legend icon style.
      var marker = function(col) {
        return '<span style=\"display:inline-block;width:6px;height:6px;border-radius:0;' +
          'flex-shrink:0;background-color:' + col + ';margin-right:6px;' +
          'vertical-align:middle;\"></span>';
      };

      var tooltipFormatter = function(params) {
        var isAxis = Array.isArray(params);
        var out = '';

        if (isAxis) {
          var axVal = nlFmt(params.length ? params[0].axisValue : '');
          out += '<div style=\"margin-bottom:6px;\">' +
            (xTitle ? xTitle + ': ' : '') + '<b>' + axVal + '</b></div>';
          params.forEach(function(p) {
            if (p.value == null || p.value === '-') return;
            var val = nlFmt(Array.isArray(p.value) ? p.value[p.value.length - 1] : p.value);
            out += '<div style=\"display:flex;align-items:center;margin:2px 0;\">' +
              marker(p.color) +
              '<span>' + p.seriesName + ': <b>' + val + '</b>' +
              (yTitle ? ' ' + yTitle.toLowerCase() : '') + '</span></div>';
          });
        } else {
          var col = params.color || palette[params.seriesIndex % palette.length];
          out += '<div style=\"display:flex;align-items:center;margin-bottom:4px;\">' +
            marker(col) + '<b>' + params.seriesName + '</b></div>';
          if (params.name) {
            out += '<div style=\"margin:2px 0;\">' +
              (xTitle ? xTitle + ': ' : '') + '<b>' + params.name + '</b></div>';
          }
          var val = nlFmt(Array.isArray(params.value)
            ? params.value[params.value.length - 1] : params.value);
          out += '<div style=\"margin:2px 0;\">' +
            (yTitle ? yTitle + ': ' : '') + '<b>' + val + '</b></div>';
        }

        return '<div style=\"font-family:' + fontFamily +
          ';font-size:13px;color:#000000;line-height:1.5;\">' + out + '</div>';
      };

      // Build axis label formatter updates from opt0 so we can merge them into
      // the single setOption call below.
      var axisUpd = {};
      ['xAxis', 'yAxis'].forEach(function(k) {
        var axes = opt0[k] || [];
        var upd = axes.map(function(a) {
          var u = (a.type === 'value' || a.type === 'log' || !a.type)
            ? { axisLabel: { formatter: nlFmt } } : {};
          // Apply name styles by physical axis position, not axis type.
          // e_flip_coords() moves the value axis to x and the category axis to y,
          // so without this the theme's type-based styles land on the wrong axis.
          if (k === 'xAxis') {
            if (a.type === 'value' || a.type === 'log') {
              // Native name cleared here; re-drawn as a graphic element in doLayout().
              if (hBarXName) u.name = '';
              u.nameGap = 0;
              // Suppress vertical grid lines when a numeric variable is used as x
              // on a regular (non-flipped) chart. On a horizontal bar chart the
              // y-axis is category type; those vertical lines are intentional
              // reference lines and must be kept.
              var yAxes = opt0.yAxis || [];
              var yIsCategory = yAxes.length > 0 && yAxes[0].type === 'category';
              if (!yIsCategory) u.splitLine = { show: false };
            } else {
              // Column / line chart: category or time axis on x.
              // line 1.5 + tick 4 + label margin 8 + label height 12 = 25px vertical offset.
              u.nameGap = 0;
              u.nameTextStyle = { align: 'right', verticalAlign: 'top', padding: [25, 0, 0, 0] };
            }
          } else {
            u.nameGap = 9;
            u.nameRotate = 0;
            // Reset padding and verticalAlign so the category axis theme values
            // do not bleed through when e_flip_coords() moves that axis to y.
            u.nameTextStyle = { align: 'left', verticalAlign: 'middle', padding: [0, 0, 0, 0] };
          }
          return u;
        });
        if (upd.length) axisUpd[k] = upd;
      });

      // Per-series emphasis borderColor using the actual palette colors.
      // Cannot be expressed in the static JSON theme because it must reference
      // the series color dynamically.
      var seriesEmphasis = (opt0.series || []).map(function(s, i) {
        return {
          emphasis: { itemStyle: { borderColor: palette[i % palette.length] } },
          blur: { itemStyle: { opacity: s.type === 'line' ? 0 : 0.3 } }
        };
      });

      // One setOption call: legend hide + tooltip formatter + axis formatters
      // + per-series emphasis borderColor. Keeping this as a single call prevents
      // any subsequent merge from re-showing the native legend via theme defaults.
      chart.setOption(Object.assign(
        {
          legend: { show: false },
          tooltip: { formatter: tooltipFormatter },
          series: seriesEmphasis,
          stateAnimation: { duration: 0 }
        },
        axisUpd
      ));

      // Read the natural axis area (space below the grid for ticks, labels and
      // axis name) ONCE here, before doLayout() ever sets grid.bottom. ECharts
      // retains whatever grid.bottom we set across resizes, so reading it inside
      // doLayout() would return a stale inflated value after a change from large to small
      // resize and cause the grid to shrink incorrectly on each cycle.
      var naturalAxisAreaH = 60;
      try {
        var r0 = chart.getModel().getComponent('grid', 0).coordinateSystem.getRect();
        naturalAxisAreaH = Math.max(chart.getHeight() - r0.y - r0.height, 30);
      } catch(e) { console.warn('ROvis: could not read initial grid rect, using fallback axis area.', e); }

      // Declared here so doLayout() closes over it; assigned below when the
      // legend container is created (remains null for single-series / no-legend charts).
      var container = null;

      // Enforces aspect ratio targets and aligns the legend + hBarXName label.
      //
      // fixedAspect=true layout:
      //   el (total element) = 1:2 height:width  ->  el.style.height = W/2
      //   ECharts canvas     = el minus legend    ->  chart.resize({ width: W, height: W/2 - legendH })
      //   grid (plot area)   = 1:3 height:width   ->  grid.bottom = chartH - rect.y - rect.width/3
      //
      // chart.resize({ width, height }) is the key: it sets the canvas to exact pixel
      // dimensions without depending on el.style.height being correct first, so the
      // rect read immediately after is always current (no stale-rect problem).
      //
      // fixedAspect=false: chart fills el at whatever height R provided; grid.bottom
      // is adjusted only enough to keep the legend from overlapping the plot area.
      function doLayout() {
        var W = el.offsetWidth;
        if (!W) return;
        var legendH = container ? container.offsetHeight : 0;
        var opts = {};
        var rect;

        if (fixedAspect) {
          var elH = Math.round(W / 2);
          var chartH = Math.max(elH - legendH, 50);
          el.style.height = elH + 'px';
          chart.resize({ width: W, height: chartH });
          try {
            rect = chart.getModel().getComponent('grid', 0).coordinateSystem.getRect();
            var targetGridH = Math.round(rect.width / 3);
            opts.grid = { bottom: Math.max(chartH - rect.y - targetGridH, naturalAxisAreaH + 3) };
            if (container) container.style.left = rect.x + 'px';
            if (hBarXName) {
              opts.graphic = [{ type: 'text',
                left: rect.x + rect.width,
                top: rect.y + targetGridH + 25,
                style: { text: hBarXName, textAlign: 'right',
                  fill: nameColor, fontSize: 13, fontFamily: fontFamily } }];
            }
          } catch(e) { console.warn('ROvis: could not read grid rect in fixed-aspect layout.', e); }
        } else {
          chart.resize();
          try {
            rect = chart.getModel().getComponent('grid', 0).coordinateSystem.getRect();
            if (container) container.style.left = rect.x + 'px';
            if (legendH > 0) opts.grid = { bottom: naturalAxisAreaH + legendH + 3 };
            if (hBarXName) {
              opts.graphic = [{ type: 'text',
                left: rect.x + rect.width,
                top: rect.y + rect.height + 25,
                style: { text: hBarXName, textAlign: 'right',
                  fill: nameColor, fontSize: 13, fontFamily: fontFamily } }];
            }
          } catch(e) { console.warn('ROvis: could not read grid rect in free-height layout.', e); }
        }

        if (Object.keys(opts).length) chart.setOption(opts);
      }

      if (seriesNames.length > 1) {
        // Place the legend inside el (absolutely positioned at the bottom).
        // el.style.height = W/2 includes the legend height, so the ECharts canvas
        // is resized to W/2 - legendH, leaving the legend row below without overlap.
        // Inserting outside el fails because htmlwidgets sets overflow:hidden on the
        // parent wrapper.
        container = document.createElement('div');
        container.className = 'ro-legend-container';
        container.style.cssText = 'position:absolute;bottom:0;left:0;right:0;z-index:10;' +
          'display:flex;flex-wrap:wrap;justify-content:flex-start;padding:8px 0 0 0;gap:4px;background:#ffffff;';
        el.style.position = 'relative';
        el.appendChild(container);

        var selected = {};

        function styleNormal(item) {
          item.style.border = '1px solid #aaaaaa';
          item.style.backgroundColor = '';
          item.querySelector('.ro-legend-text').style.cssText =
            'font-size:13px;color:#535353;font-weight:normal;font-family:' + fontFamily + ';';
          item.querySelector('.ro-legend-icon').style.opacity = '1';
        }

        function styleHover(item) {
          item.style.border = '2px solid #00619e';
          item.style.backgroundColor = 'rgba(0,97,158,0.1)';
          item.querySelector('.ro-legend-text').style.cssText =
            'font-size:13px;color:#007bc7;font-weight:bold;font-family:' + fontFamily + ';';
        }

        function styleHidden(item) {
          item.style.border = '1px solid #aaaaaa';
          item.style.backgroundColor = '';
          item.querySelector('.ro-legend-text').style.cssText =
            'font-size:13px;color:#c8c8c8;font-weight:normal;text-decoration:none;font-family:' +
            fontFamily + ';';
          item.querySelector('.ro-legend-icon').style.opacity = '0.4';
        }

        seriesNames.forEach(function(name, i) {
          selected[name] = true;

          var item = document.createElement('span');
          item.className = 'ro-legend-item';
          item.dataset.name = name;
          item.style.cssText = 'display:inline-flex;align-items:center;border:1px solid #aaaaaa;' +
            'border-radius:0;padding:1px 6px 1px 4px;cursor:pointer;gap:6px;';

          var icon = document.createElement('span');
          icon.className = 'ro-legend-icon';
          icon.style.cssText = 'display:inline-block;width:24px;height:12px;flex-shrink:0;border-radius:0;' +
            'background-color:' + palette[i % palette.length] + ';';

          var text = document.createElement('span');
          text.className = 'ro-legend-text';
          text.style.cssText = 'font-size:13px;color:#535353;font-weight:normal;font-family:' + fontFamily + ';';
          text.textContent = name;

          item.appendChild(icon);
          item.appendChild(text);
          container.appendChild(item);

          item.addEventListener('mouseenter', function() {
            if (selected[name]) styleHover(item);
          });
          item.addEventListener('mouseleave', function() {
            if (selected[name]) styleNormal(item);
          });
          item.addEventListener('click', function() {
            chart.dispatchAction({ type: 'legendToggleSelect', name: name });
          });
        });

        chart.on('legendselectchanged', function(event) {
          selected = event.selected;
          container.querySelectorAll('.ro-legend-item').forEach(function(item) {
            if (selected[item.dataset.name]) styleNormal(item); else styleHidden(item);
          });
        });
      }

      // Defer one tick so the browser has painted and offsetHeight is stable.
      setTimeout(doLayout, 0);

      // ResizeObserver fires on width changes. Setting el.style.height inside
      // doLayout() changes contentRect.height but not contentRect.width, so the
      // lastW guard prevents re-entrant calls from our own height assignments.
      new ResizeObserver(function(entries) {
        var w = Math.round(entries[0].contentRect.width);
        if (w > 0 && w !== lastW) {
          lastW = w;
          doLayout();
        }
      }).observe(el);

      chart.on('globalout', function() {
        chart.dispatchAction({ type: 'hideTip' });
        chart.dispatchAction({ type: 'downplay' });
      });
    }"

  js <- gsub("__FIXED_ASPECT__", fixed_aspect_json, js, fixed = TRUE)
  js <- gsub("__COLORS__", colors_json, js, fixed = TRUE)
  js <- gsub("__NAMES__", names_json, js, fixed = TRUE)
  js <- gsub("__FONT_FAMILY__", font_family_json, js, fixed = TRUE)
  js <- gsub("__NAME_COLOR__", name_color_json, js, fixed = TRUE)
  js
}
