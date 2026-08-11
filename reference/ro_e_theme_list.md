# Builds the RO echarts theme as a nested R list.

All color values are derived from ro_color(): never use raw hex codes
here.

## Usage

``` r
ro_e_theme_list(palette, font_family)
```

## Arguments

- palette:

  Name of the palette to pass to ro_color_palette().

- font_family:

  Resolved font family string (from ro_check_if_font_available()).

## Value

A nested list suitable for jsonlite::write_json().

## See also

Other echarts4r:
[`ro_e_build_keyboard_nav_js()`](ro_e_build_keyboard_nav_js.md),
[`ro_e_build_onrender_js()`](ro_e_build_onrender_js.md),
[`ro_e_detect_axis_orientation()`](ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav()`](ro_e_keyboard_nav.md),
[`ro_e_keyboard_nav_axis_js()`](ro_e_keyboard_nav_axis_js.md),
[`ro_e_keyboard_nav_legend_js()`](ro_e_keyboard_nav_legend_js.md),
[`ro_e_theme()`](ro_e_theme.md)
