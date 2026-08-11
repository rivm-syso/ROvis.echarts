# Generates the JavaScript snippet for legend-toggle keyboard navigation.

One JS line is emitted per entry in series_keys.

## Usage

``` r
ro_e_keyboard_nav_legend_js(series_keys)
```

## Arguments

- series_keys:

  Named character vector, or NULL.

## Value

A character string of JavaScript, or "" when series_keys is NULL.

## Details

Key name format: paste0("Key", toupper(names(series_keys))) e.g. c(w =
"Women", m = "Men") becomes 'KeyW', 'KeyM'

## See also

Other echarts4r:
[`ro_e_build_keyboard_nav_js()`](ro_e_build_keyboard_nav_js.md),
[`ro_e_build_onrender_js()`](ro_e_build_onrender_js.md),
[`ro_e_detect_axis_orientation()`](ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav()`](ro_e_keyboard_nav.md),
[`ro_e_keyboard_nav_axis_js()`](ro_e_keyboard_nav_axis_js.md),
[`ro_e_theme()`](ro_e_theme.md),
[`ro_e_theme_list()`](ro_e_theme_list.md)
