# Detects chart orientation from the echarts4r object.

Returns "horizontal" for column/line charts (categories on xAxis) and
"vertical" for bar charts (categories on yAxis after e_flip_coords()).

## Usage

``` r
ro_e_detect_axis_orientation(e)
```

## Arguments

- e:

  An echarts4r object.

## Value

One of "horizontal" or "vertical".

## Details

Detection strategy: after e_flip_coords(), echarts4r moves category data
to yAxis. Check whether e\$x\$opts\$yAxis has a non-NULL `data` element.

## See also

Other echarts4r:
[`ro_e_announce_title_first()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_announce_title_first.md),
[`ro_e_build_keyboard_nav_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_build_keyboard_nav_js.md),
[`ro_e_build_onrender_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_build_onrender_js.md),
[`ro_e_keyboard_nav()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav.md),
[`ro_e_keyboard_nav_axis_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav_axis_js.md),
[`ro_e_legend_a11y_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_legend_a11y_js.md),
[`ro_e_sort_axis_labels()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_sort_axis_labels.md),
[`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_standard.md),
[`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md),
[`ro_e_theme_list()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme_list.md),
[`ro_e_tooltip_announce_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_tooltip_announce_js.md)
