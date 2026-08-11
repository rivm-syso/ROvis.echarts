# Apply the RO echarts theme to an echarts4r object

`ro_e_theme()` applies the Rijksoverheid (RO) visual style to an
[echarts4r](https://echarts4r.john-coene.com/) chart. It is the echarts
equivalent of `ROvis.ggplot2::ro_gg_theme()` and is designed to slot
into any echarts4r pipeline.

The theme is generated at call time from
[`ROvis.utils::ro_color()`](https://rdrr.io/pkg/ROvis.utils/man/ro_color.html)
and
[`ROvis.utils::ro_color_palette()`](https://rdrr.io/pkg/ROvis.utils/man/ro_color_palette.html).
A custom accessible HTML legend is always included. The native ECharts
legend is replaced automatically to meet the RO accessibility spec.

## Usage

``` r
ro_e_theme(
  e,
  palette = "categorical",
  fixed_aspect = TRUE,
  font = NULL,
  renderer = "svg"
)
```

## Arguments

- e:

  An echarts4r object (created with
  [`echarts4r::e_charts()`](https://echarts4r.john-coene.com/reference/init.html)).

- palette:

  Character. Palette to use for series colors. One of `"categorical"`
  (default), `"gender_con"`, or `"gender_unc"`. Passed to
  [`ro_color_palette()`](https://rdrr.io/pkg/ROvis.utils/man/ro_color_palette.html).

- fixed_aspect:

  Logical. When `TRUE` (default), the total element (title + chart +
  legend) maintains a 2:1 width-to-height ratio, and the inner plot area
  (grid only, excluding axis labels and legend) maintains a 3:1
  width-to-height ratio. Both ratios update responsively on resize. Set
  to `FALSE` to let the chart fill whatever height its container
  provides (useful when embedding in a fixed-size layout or a Shiny app
  with explicit `height`).

- font:

  `NULL` (default) or a character string naming a system font family.
  When `NULL`, RijksoverheidSansWebText is used if installed, otherwise
  Verdana. Supply a font name to override both the chart labels and the
  custom HTML legend. A warning is issued if the font is not found on
  the system.

- renderer:

  The renderer to use. One of `"svg"` or `"canvas"`. Defaults to `"svg"`
  to comply with accessibility standards.

## Value

The modified echarts4r object.

## RO style applied

- Series colors from
  [`ro_color_palette()`](https://rdrr.io/pkg/ROvis.utils/man/ro_color_palette.html)
  (default: `"categorical"`).

- Title in `ro_color("lintblauw")`, subtitle in
  `ro_color("donkerblauw")`.

- Axis labels and ticks in `ro_color("grijs_7")`.

- Horizontal grid lines (value axis); no vertical grid lines.

- No axis line or ticks on the value axis.

- Custom HTML legend with per-item borders and hover/hidden styles.

## See also

- `ROvis.ggplot2::ro_gg_theme()` for the ggplot2 equivalent.

- [`ro_e_keyboard_nav()`](ro_e_keyboard_nav.md) to add keyboard
  accessibility on top of the theme.

- [`ROvis.utils::ro_color_palette()`](https://rdrr.io/pkg/ROvis.utils/man/ro_color_palette.html)
  to inspect the available palettes.

- [`ROvis.utils::ro_color()`](https://rdrr.io/pkg/ROvis.utils/man/ro_color.html)
  to look up individual RO color hex codes.

Other echarts4r:
[`ro_e_build_keyboard_nav_js()`](ro_e_build_keyboard_nav_js.md),
[`ro_e_build_onrender_js()`](ro_e_build_onrender_js.md),
[`ro_e_detect_axis_orientation()`](ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav()`](ro_e_keyboard_nav.md),
[`ro_e_keyboard_nav_axis_js()`](ro_e_keyboard_nav_axis_js.md),
[`ro_e_keyboard_nav_legend_js()`](ro_e_keyboard_nav_legend_js.md),
[`ro_e_theme_list()`](ro_e_theme_list.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(echarts4r)

mtcars |>
  e_charts(wt) |>
  e_scatter(mpg) |>
  ro_e_theme()
} # }
```
