# Wraps axis and legend JS snippets in the full onRender callback template.

Wraps axis and legend JS snippets in the full onRender callback
template.

## Usage

``` r
ro_e_build_keyboard_nav_js(axis_js, legend_js)
```

## Arguments

- axis_js:

  Character. Output of ro_e_keyboard_nav_axis_js().

- legend_js:

  Character. Output of ro_e_keyboard_nav_legend_js().

## Value

A single JavaScript string ready for htmlwidgets::onRender().

## See also

Other echarts4r:
[`ro_e_build_onrender_js()`](ro_e_build_onrender_js.md),
[`ro_e_detect_axis_orientation()`](ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav()`](ro_e_keyboard_nav.md),
[`ro_e_keyboard_nav_axis_js()`](ro_e_keyboard_nav_axis_js.md),
[`ro_e_keyboard_nav_legend_js()`](ro_e_keyboard_nav_legend_js.md),
[`ro_e_theme()`](ro_e_theme.md),
[`ro_e_theme_list()`](ro_e_theme_list.md)
