# Make screen readers announce axis labels in axis order

Internal: called by
[`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_standard.md).
ECharts does not always add axis labels to the SVG in their visual
order. On a time axis, for example, the year label ("2024") is drawn
after the month labels, so screen readers announce it last. This
reorders the label nodes of the first x-axis and the first y-axis to
follow the axis from start to end: left to right for a normal x-axis,
bottom to top for a normal y-axis, reversed for `inverse = TRUE`. That
is also the data order, so category labels on a horizontal bar chart
([`echarts4r::e_flip_coords()`](https://echarts4r.john-coene.com/reference/e_flip_coords.html))
keep their order.

## Usage

``` r
ro_e_sort_axis_labels(e)
```

## Arguments

- e:

  An echarts4r object.

## Value

The modified echarts4r object, with an
[`htmlwidgets::onRender()`](https://rdrr.io/pkg/htmlwidgets/man/onRender.html)
hook attached.

## Details

Labels are matched on both position (outside the grid, next to the axis)
and text (the labels ECharts reports for that axis), so axis names are
not sorted in between.

ECharts restores its own element order whenever it redraws (legend
toggle, resize, and the resize
[`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md)
does right after the first render), so the sort is re-applied on every
`finished` event, not only once. Does nothing for charts without a grid
(e.g. pie charts), or with `renderer = "canvas"` (no SVG).

## See also

Other echarts4r:
[`ro_e_announce_title_first()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_announce_title_first.md),
[`ro_e_build_keyboard_nav_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_build_keyboard_nav_js.md),
[`ro_e_build_onrender_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_build_onrender_js.md),
[`ro_e_detect_axis_orientation()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav.md),
[`ro_e_keyboard_nav_axis_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav_axis_js.md),
[`ro_e_legend_a11y_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_legend_a11y_js.md),
[`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_standard.md),
[`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md),
[`ro_e_theme_list()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme_list.md),
[`ro_e_tooltip_announce_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_tooltip_announce_js.md)
