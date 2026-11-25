# Apply the RO style and accessibility features to an echarts4r chart

`ro_e_standard()` is the recommended way to finish an echarts4r chart.
It applies the RO visual style with
[`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md)
and adds all accessibility features on top. Use
[`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md)
instead only when you need the styling without the extra accessibility
features, for example for a chart type that `ro_e_standard()` does not
cover.

## Usage

``` r
ro_e_standard(
  e,
  palette = "categorical",
  fixed_aspect = TRUE,
  font = NULL,
  renderer = "svg",
  axis = NULL
)
```

## Arguments

- e:

  An echarts4r object (created with
  [`echarts4r::e_charts()`](https://echarts4r.john-coene.com/reference/init.html)).

- palette:

  Character. Palette to use for series colors. One of `"categorical"`
  (default), `"gender_con"`, or `"gender_unc"`. Passed to
  [`ro_color_palette()`](https://rivm-syso.github.io/ROvis.utils/reference/ro_color_palette.html).

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

- axis:

  Character. Arrow-key direction for tooltip navigation. One of
  `"horizontal"` (ArrowLeft / ArrowRight), `"vertical"` (ArrowUp /
  ArrowDown), or `"both"`. Default `NULL` auto-detects from the chart
  orientation.

## Value

The modified echarts4r object.

## Accessibility features

- **Legend**: Tab focuses legend items, Enter or Space toggles a series.
  Screen readers announce each item as a button with its on/off state.
  This is part of the legend that
  [`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md)
  draws, so it is there with
  [`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md)
  too.

- **Arrow keys** move the tooltip across data points. The direction is
  auto-detected from the chart orientation (left/right for column and
  line charts, up/down for horizontal bar charts made with
  [`echarts4r::e_flip_coords()`](https://echarts4r.john-coene.com/reference/e_flip_coords.html)),
  or set explicitly with `axis`. The chart needs focus first: Tab to it
  or click it. Screen readers read out the tooltip content at every
  step.

- **Title first**: screen readers announce the chart title before the
  axes and data. Needs `renderer = "svg"` (the default).

- **Axis label order**: screen readers announce axis labels in axis
  order (left to right on the x-axis, bottom to top on the y-axis), also
  on time axes where ECharts draws the year label last. Needs
  `renderer = "svg"`.

## See also

- [`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md)
  for the styling only.

- [`ROvis.utils::ro_color_palette()`](https://rivm-syso.github.io/ROvis.utils/reference/ro_color_palette.html)
  to inspect the available palettes.

Other echarts4r:
[`ro_e_announce_title_first()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_announce_title_first.md),
[`ro_e_build_keyboard_nav_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_build_keyboard_nav_js.md),
[`ro_e_build_onrender_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_build_onrender_js.md),
[`ro_e_detect_axis_orientation()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav.md),
[`ro_e_keyboard_nav_axis_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav_axis_js.md),
[`ro_e_legend_a11y_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_legend_a11y_js.md),
[`ro_e_sort_axis_labels()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_sort_axis_labels.md),
[`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md),
[`ro_e_theme_list()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme_list.md),
[`ro_e_tooltip_announce_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_tooltip_announce_js.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(echarts4r)

data.frame(
  week = factor(rep(1:5, 2)),
  sex = rep(c("Women", "Men"), each = 5),
  n = c(12, 15, 11, 18, 20, 10, 13, 14, 16, 17)
) |>
  dplyr::group_by(sex) |>
  e_charts(week) |>
  e_line(n) |>
  e_tooltip(trigger = "axis") |>
  ro_e_standard(palette = "gender_con")
} # }
```
