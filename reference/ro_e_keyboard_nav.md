# Add keyboard navigation to an echarts4r chart

`ro_e_keyboard_nav()` attaches JavaScript keyboard event listeners to an
echarts4r chart, enabling keyboard-only users to navigate data points
and toggle legend series. It is designed to follow
[`ro_e_theme()`](ro_e_theme.md) at the end of an echarts4r pipeline.

## Usage

``` r
ro_e_keyboard_nav(e, series_keys = NULL, axis = NULL)
```

## Arguments

- e:

  An echarts4r object.

- series_keys:

  Named character vector mapping single-letter key codes to series
  names, e.g. `c(w = "Women", m = "Men", t = "Total")`. Names must be
  single letters (case-insensitive); values must exactly match the
  series names as used in the chart. Set to `NULL` (default) to omit
  legend controls.

- axis:

  Character. Arrow-key direction for tooltip navigation. One of
  `"horizontal"` (ArrowLeft / ArrowRight), `"vertical"` (ArrowUp /
  ArrowDown), or `"both"`. Default `NULL` auto-detects from the chart
  orientation.

## Value

The modified echarts4r object, with keyboard navigation attached via
[`htmlwidgets::onRender()`](https://rdrr.io/pkg/htmlwidgets/man/onRender.html).

## Keyboard controls

Arrow keys: move the tooltip across data points. Direction is
auto-detected from chart orientation (left/right for column and line
charts; up/down for bar charts), or set explicitly via `axis`. Letter
keys: toggle individual legend series. Controlled by `series_keys`;
nothing is hardcoded. Pass `NULL` to omit legend controls.

## Axis auto-detection

The function inspects the echarts4r object to determine whether
[`echarts4r::e_flip_coords()`](https://echarts4r.john-coene.com/reference/e_flip_coords.html)
was applied, and assigns arrow keys accordingly. Override this with the
`axis` argument.

## See also

- [`ro_e_theme()`](ro_e_theme.md) to apply the RO visual theme.

- [`echarts4r::e_flip_coords()`](https://echarts4r.john-coene.com/reference/e_flip_coords.html)
  which determines axis orientation.

Other echarts4r:
[`ro_e_build_keyboard_nav_js()`](ro_e_build_keyboard_nav_js.md),
[`ro_e_build_onrender_js()`](ro_e_build_onrender_js.md),
[`ro_e_detect_axis_orientation()`](ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav_axis_js()`](ro_e_keyboard_nav_axis_js.md),
[`ro_e_keyboard_nav_legend_js()`](ro_e_keyboard_nav_legend_js.md),
[`ro_e_theme()`](ro_e_theme.md),
[`ro_e_theme_list()`](ro_e_theme_list.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(echarts4r)

data |>
 dplyr::group_by(sex) |>
 e_charts(year) |>
 e_line(value) |>
 e_tooltip(trigger = "axis") |>
 ro_e_theme() |>
 ro_e_keyboard_nav(series_keys = c(w = "Women", m = "Men", t = "Total"))
} # }
```
