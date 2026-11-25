# Generates the JavaScript snippet for arrow-key tooltip navigation.

Arrow key direction depends on chart orientation:

- "horizontal": ArrowLeft / ArrowRight, reads xAxis

- "vertical": ArrowDown / ArrowUp, reads yAxis

- "both": all four arrow keys, each bound to the correct axis

## Usage

``` r
ro_e_keyboard_nav_axis_js(axis)
```

## Arguments

- axis:

  One of "horizontal", "vertical", or "both".

## Value

A character string of JavaScript to be embedded in the onRender body.

## See also

Other echarts4r:
[`ro_e_announce_title_first()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_announce_title_first.md),
[`ro_e_build_keyboard_nav_js()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_build_keyboard_nav_js.md),
[`ro_e_build_onrender_js()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_build_onrender_js.md),
[`ro_e_detect_axis_orientation()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_keyboard_nav.md),
[`ro_e_legend_a11y_js()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_legend_a11y_js.md),
[`ro_e_sort_axis_labels()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_sort_axis_labels.md),
[`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_standard.md),
[`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_theme.md),
[`ro_e_theme_list()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_theme_list.md),
[`ro_e_tooltip_announce_js()`](https://rivm-syso.github.io/ROvis.echarts/reference/ro_e_tooltip_announce_js.md)
