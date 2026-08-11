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
[`ro_e_build_keyboard_nav_js()`](ro_e_build_keyboard_nav_js.md),
[`ro_e_build_onrender_js()`](ro_e_build_onrender_js.md),
[`ro_e_detect_axis_orientation()`](ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav()`](ro_e_keyboard_nav.md),
[`ro_e_keyboard_nav_legend_js()`](ro_e_keyboard_nav_legend_js.md),
[`ro_e_theme()`](ro_e_theme.md),
[`ro_e_theme_list()`](ro_e_theme_list.md)
