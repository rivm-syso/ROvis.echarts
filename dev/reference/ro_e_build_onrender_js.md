# Builds the single onRender JS for the RO theme.

Handles legend replacement, tooltip formatter, and axis number
formatting in one function so there is only one chart.setOption() call.
Multiple separate setOption() calls risk re-applying theme defaults
(including re-showing the native legend), because ECharts merges each
call against the registered theme.

## Usage

``` r
ro_e_build_onrender_js(
  colors,
  series_names,
  font_family,
  name_color,
  fixed_aspect = TRUE,
  legend_a11y = TRUE
)
```

## Arguments

- colors:

  Character vector of hex colors (from ro_color_palette()).

- series_names:

  Character vector of series names from the echarts4r object.

- font_family:

  Font family string resolved by ro_e_theme().

- fixed_aspect:

  Logical. When TRUE the chart enforces a 2:1 width:height aspect ratio
  and stays responsive on resize.

- legend_a11y:

  Logical. When TRUE (default) the HTML legend gets keyboard and screen
  reader support from ro_e_legend_a11y_js().

## Value

A JavaScript string for htmlwidgets::onRender().

## Details

Colors and series names are baked in from R. ECharts theme-registered
colors are not returned by chart.getOption(), so we pass them
explicitly.

## See also

Other echarts4r:
[`ro_e_announce_title_first()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_announce_title_first.md),
[`ro_e_build_keyboard_nav_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_build_keyboard_nav_js.md),
[`ro_e_detect_axis_orientation()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav.md),
[`ro_e_keyboard_nav_axis_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav_axis_js.md),
[`ro_e_legend_a11y_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_legend_a11y_js.md),
[`ro_e_sort_axis_labels()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_sort_axis_labels.md),
[`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_standard.md),
[`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md),
[`ro_e_theme_list()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme_list.md),
[`ro_e_tooltip_announce_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_tooltip_announce_js.md)
