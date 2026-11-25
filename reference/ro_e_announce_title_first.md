# Make screen readers announce the chart title first

Internal: called by
[`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_standard.md).
ECharts draws the title near the end of the SVG, so screen readers
announce it after the axes and data. This moves the title's SVG group to
the front.

## Usage

``` r
ro_e_announce_title_first(e)
```

## Arguments

- e:

  An echarts4r object.

## Value

The modified echarts4r object, with an
[`htmlwidgets::onRender()`](https://rdrr.io/pkg/htmlwidgets/man/onRender.html)
hook attached.

## Details

ECharts restores its own element order whenever it redraws (legend
toggle, resize, and the resize
[`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_theme.md)
does right after the first render), so the move is re-applied on every
`finished` event, not only once. Does nothing for charts without a
title, or with `renderer = "canvas"` (no SVG).

## See also

Other echarts4r:
[`ro_e_build_keyboard_nav_js()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_build_keyboard_nav_js.md),
[`ro_e_build_onrender_js()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_build_onrender_js.md),
[`ro_e_detect_axis_orientation()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_keyboard_nav.md),
[`ro_e_keyboard_nav_axis_js()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_keyboard_nav_axis_js.md),
[`ro_e_legend_a11y_js()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_legend_a11y_js.md),
[`ro_e_sort_axis_labels()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_sort_axis_labels.md),
[`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_standard.md),
[`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_theme.md),
[`ro_e_theme_list()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_theme_list.md),
[`ro_e_tooltip_announce_js()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_tooltip_announce_js.md)
