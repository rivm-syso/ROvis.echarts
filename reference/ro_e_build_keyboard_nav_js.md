# Wraps the axis JS snippet in the full onRender callback template.

The listener sits on the chart element, not on `window`, so the arrow
keys only act on the chart that has focus (not on every chart on the
page, and not while typing in an input). The chart gets `tabindex="0"`
so Tab reaches it, and a focus outline for keyboard focus only
(`:focus-visible`).

## Usage

``` r
ro_e_build_keyboard_nav_js(axis_js, announce = TRUE)
```

## Arguments

- axis_js:

  Character. Output of ro_e_keyboard_nav_axis_js().

- announce:

  Logical. When TRUE (default) the tooltip text is read out to screen
  readers after every arrow key, via ro_e_tooltip_announce_js().

## Value

A single JavaScript string ready for htmlwidgets::onRender().

## See also

Other echarts4r:
[`ro_e_announce_title_first()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_announce_title_first.md),
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
