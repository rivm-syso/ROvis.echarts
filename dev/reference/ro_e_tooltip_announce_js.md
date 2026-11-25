# Generates the JavaScript snippet that reads the tooltip to screen readers.

Kept separate from the arrow-key navigation in
ro_e_build_keyboard_nav_js() so it can be switched off or changed on its
own. The snippet runs inside that function's onRender callback and
expects `el` (the chart element) in scope. It defines
`announceTooltip()`, which the keydown listener calls after every arrow
key.

## Usage

``` r
ro_e_tooltip_announce_js()
```

## Value

A character string of JavaScript.

## Details

The ECharts tooltip is a plain `div`, so screen readers don't notice
when its content changes. This adds a visually hidden live region
(`role="status"`, `aria-live="polite"`) to the chart and copies the
tooltip text into it, one line per tooltip row separated by commas, e.g.
"2016, Groep A: 5, Groep B: 3". Reading the rendered tooltip (instead of
the data) keeps the announcement identical to what sighted users see,
including the RO number formatting.

## See also

Other echarts4r:
[`ro_e_announce_title_first()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_announce_title_first.md),
[`ro_e_build_keyboard_nav_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_build_keyboard_nav_js.md),
[`ro_e_build_onrender_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_build_onrender_js.md),
[`ro_e_detect_axis_orientation()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav.md),
[`ro_e_keyboard_nav_axis_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav_axis_js.md),
[`ro_e_legend_a11y_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_legend_a11y_js.md),
[`ro_e_sort_axis_labels()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_sort_axis_labels.md),
[`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_standard.md),
[`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md),
[`ro_e_theme_list()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme_list.md)
