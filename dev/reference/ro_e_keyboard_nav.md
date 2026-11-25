# Add arrow-key tooltip navigation to an echarts4r chart

Internal: called by
[`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_standard.md).
Attaches a keydown listener that moves the tooltip across data points
with the arrow keys. Direction is auto-detected from the chart
orientation
([`echarts4r::e_flip_coords()`](https://echarts4r.john-coene.com/reference/e_flip_coords.html)
gives up/down, otherwise left/right), or set explicitly via `axis`.

## Usage

``` r
ro_e_keyboard_nav(e, axis = NULL)
```

## Arguments

- e:

  An echarts4r object.

- axis:

  Character. One of `"horizontal"`, `"vertical"`, or `"both"`. Default
  `NULL` auto-detects from the chart orientation.

## Value

The modified echarts4r object, with keyboard navigation attached via
[`htmlwidgets::onRender()`](https://rdrr.io/pkg/htmlwidgets/man/onRender.html).

## See also

Other echarts4r:
[`ro_e_announce_title_first()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_announce_title_first.md),
[`ro_e_build_keyboard_nav_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_build_keyboard_nav_js.md),
[`ro_e_build_onrender_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_build_onrender_js.md),
[`ro_e_detect_axis_orientation()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav_axis_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav_axis_js.md),
[`ro_e_legend_a11y_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_legend_a11y_js.md),
[`ro_e_sort_axis_labels()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_sort_axis_labels.md),
[`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_standard.md),
[`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md),
[`ro_e_theme_list()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme_list.md),
[`ro_e_tooltip_announce_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_tooltip_announce_js.md)
