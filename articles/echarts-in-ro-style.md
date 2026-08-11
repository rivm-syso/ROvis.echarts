# ECharts in RO style

This vignette covers the `echarts4r` functions in `ROvis`:
[`ro_e_theme()`](../reference/ro_e_theme.md) and
[`ro_e_keyboard_nav()`](../reference/ro_e_keyboard_nav.md). Together
they let you build interactive charts that follow the Rijksoverheid (RO)
visual style. If you are new to `echarts4r`, we recommend checking out
the [echarts4r documentation](https://echarts4r.john-coene.com/) first.

## Setup

Load the packages we need:

``` r

library(echarts4r)
library(dplyr)
# library(ROvis)
library(ROvis.echarts)
library(ROvis.utils)
```

We use a small synthetic dataset throughout this vignette so you can run
everything standalone:

``` r

sex_levels <- c("Women", "Men", "Total")

# Reported cases per age group and sex
dat_cases <- data.frame(
  agegroup = rep(c("0-19", "20-39", "40-59", "60-79", "80+"), times = 3),
  sex = factor(rep(sex_levels, each = 5), levels = sex_levels),
  n = c(
    12000,
    48000,
    61000,
    43000,
    18000,
    10000,
    45000,
    58000,
    39000,
    14000,
    22000,
    93000,
    119000,
    82000,
    32000
  )
)

# Reported cases per week (three series)
dat_weekly <- data.frame(
  week = factor(rep(1:12, times = 3), levels = 1:12),
  sex = factor(rep(sex_levels, each = 12), levels = sex_levels),
  n = c(
    800,
    950,
    1100,
    1400,
    1600,
    1550,
    1300,
    1100,
    900,
    750,
    600,
    500,
    700,
    880,
    1020,
    1300,
    1480,
    1420,
    1180,
    990,
    820,
    680,
    540,
    440,
    1500,
    1830,
    2120,
    2700,
    3080,
    2970,
    2480,
    2090,
    1720,
    1430,
    1140,
    940
  )
)
```

## Apply the RO theme

[`ro_e_theme()`](../reference/ro_e_theme.md) applies the RO visual style
to any `echarts4r` chart. It slots into an `echarts4r` pipeline the same
way `ro_gg_theme()` does in `ggplot2.` Add it at the end, after all your
chart layers:

``` r

dat_cases |>
  filter(sex == "Women") |>
  e_charts(agegroup) |>
  e_bar(n, name = "Women") |>
  e_title("Cases by age group", "Women only") |>
  e_x_axis(name = "Age class") |>
  e_y_axis(name = "Value") |>
  e_tooltip(trigger = "axis") |>
  ro_e_theme()
```

## Chart types

### Column chart (grouped)

For grouped charts, group the data with
[`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
before piping into
[`e_charts()`](https://echarts4r.john-coene.com/reference/init.html):

``` r

dat_cases |>
  group_by(sex) |>
  e_charts(agegroup) |>
  e_bar(n) |>
  e_title("Cases by age group and sex") |>
  e_x_axis(name = "Age class") |>
  e_y_axis(name = "Value") |>
  e_tooltip(trigger = "axis") |>
  ro_e_theme(palette = "gender_con")
```

### Horizontal bar chart

Use
[`e_flip_coords()`](https://echarts4r.john-coene.com/reference/e_flip_coords.html)
to turn a column chart into a horizontal bar chart:

``` r

dat_cases |>
  filter(sex == "Women") |>
  e_charts(agegroup) |>
  e_bar(n, name = "Women") |>
  e_flip_coords() |>
  e_title("Cases by age group", "Women only") |>
  e_x_axis(name = "Value") |>
  e_y_axis(name = "Age class") |>
  e_tooltip(trigger = "axis") |>
  ro_e_theme()
```

### Line chart

``` r

dat_weekly |>
  group_by(sex) |>
  e_charts(week) |>
  e_line(n) |>
  e_title("Weekly cases by sex") |>
  e_x_axis(name = "Week") |>
  e_y_axis(name = "Value") |>
  e_tooltip(trigger = "axis") |>
  ro_e_theme(palette = "gender_con")
```

A note on x-axis variable types: if your x-axis variable is numeric
(like a year or week number), `echarts4r` treats it as a value axis. The
RO theme shows grid lines on all value axes, so you will end up with
vertical grid lines as well as horizontal ones. To avoid this, make the
x-axis variable a factor with explicit levels. That way `echarts4r` uses
a category axis, which has no grid lines, while the order of the values
stays correct. For example, we achieved this by:

``` r

# Turns week into a category axis without changing the order
week = factor(rep(1:12, times = 3), levels = 1:12)
```

For convenience, there will also be a warning displayed when you try to
do so:

``` r

data_multi <- data.frame(
  year = c(2020, 2021, 2022, 2023, 2024),
  women = c(120, 145, 160, 175, 190),
  men = c(95, 110, 125, 140, 150)
)

data_multi |>
  e_charts(year) |>
  e_bar(women, name = "Women") |>
  e_bar(men, name = "Men") |>
  ro_e_theme(palette = "gender_con")
```

    ## Warning: ! The x-axis variable is numeric, which creates a continuous axis.
    ## ℹ If not intended, convert the variable to a factor: `mutate(year =
    ##   factor(year))`

### Grouped trendline

``` r

tab_cases_week_by_prov <- expand.grid(
  week = seq(as.Date("2022-04-01"), by = "week", length.out = 20),
  Province = c("Flevoland", "Groningen", "Noord-Brabant", "Utrecht", "Zeeland")
) |>
  mutate(n = sample(10:1000, n(), replace = TRUE))

tab_cases_week_by_prov |>
  group_by(Province) |>
  e_charts(x = week) |>
  e_line(n) |>
  e_axis_labels(y = "Number of cases") |>
  e_x_axis(
    name = "Date",
    formatter = htmlwidgets::JS(
      'function (value) {
    var monthShortNames = ["Jan","Feb","Mar","Apr","May","Jun",
                           "Jul","Aug","Sep","Oct","Nov","Dec"];
    var d = new Date(value);
    return monthShortNames[d.getMonth()] + "  " + d.getFullYear();
  }'
    )
  ) |>
  e_y_axis(name = "Value") |>
  e_title("Cases per week for 5 Dutch provinces") |>
  e_legend() |>
  e_tooltip(trigger = "item") |>
  ro_e_theme()
```

## Aspect ratio

By default, [`ro_e_theme()`](../reference/ro_e_theme.md) enforces fixed
aspect ratios in accordance with the RO data visualisation guidelines:
the **total element** (title + chart + legend) is **2:1
width-to-height**, and the inner **plot area** (grid only, without axis
labels or legend) is **3:1 width-to-height**. Both ratios update
automatically whenever the container width changes, for example when the
browser window is resized or a Shiny sidebar is toggled. This is
controlled by the `fixed_aspect` argument, which defaults to `TRUE`.

``` r

dat_cases |>
  filter(sex == "Women") |>
  e_charts(agegroup) |>
  e_bar(n, name = "Women") |>
  e_title("2:1 aspect ratio (default)", "fixed_aspect = TRUE") |>
  e_x_axis(name = "Age class") |>
  e_y_axis(name = "Value") |>
  e_tooltip(trigger = "axis") |>
  ro_e_theme()
```

Set `fixed_aspect = FALSE` when you need to control the chart height
yourself, for example inside a Shiny app with a fixed-height container
or a dashboard where the chart must fill an exact pixel area. The chart
then keeps the height you specify (via `e_charts(height = …)` or the
chunk’s `fig.height` option) and stops adjusting it on resize:

``` r

dat_cases |>
  filter(sex == "Women") |>
  e_charts(agegroup, height = 400) |>
  e_bar(n, name = "Women") |>
  e_title("Fixed 400 px height (fixed_aspect = FALSE)") |>
  e_x_axis(name = "Age class") |>
  e_y_axis(name = "Value") |>
  e_tooltip(trigger = "axis") |>
  ro_e_theme(fixed_aspect = FALSE)
```

## Color palettes

[`ro_e_theme()`](../reference/ro_e_theme.md) accepts a `palette`
argument. The available palettes are the same ones used by
[`ro_color_palette()`](https://rdrr.io/pkg/ROvis.utils/man/ro_color_palette.html):

- `"categorical"` (default) for general categorical data
- `"gender_con"` for conventional gender colors
- `"gender_unc"` for unconventional gender colors
- `"full"` for all 18 RO colors
- `"greys"` for grey tints only

You can preview any palette with
[`ro_show_colors()`](https://rdrr.io/pkg/ROvis.utils/man/ro_show_colors.html):

``` r

ro_show_colors("categorical")
```

``` r

ro_show_colors("gender_con")
```

``` r

ro_show_colors("gender_unc")
```

``` r

ro_show_colors("greys")
```

Apply a different palette by passing its name to
[`ro_e_theme()`](../reference/ro_e_theme.md):

``` r

dat_cases |>
  group_by(sex) |>
  e_charts(agegroup) |>
  e_bar(n) |>
  e_title("Cases by age group and sex", "gender_unc palette") |>
  e_x_axis(name = "Age class") |>
  e_y_axis(name = "Value") |>
  e_tooltip(trigger = "axis") |>
  ro_e_theme(palette = "gender_unc")
```

## Keyboard navigation

Interactive charts need to be accessible to keyboard-only users.
[`ro_e_keyboard_nav()`](../reference/ro_e_keyboard_nav.md) adds keyboard
controls on top of [`ro_e_theme()`](../reference/ro_e_theme.md):

- **Arrow keys** move the tooltip across data points. The direction is
  auto-detected from the chart orientation (left/right for column and
  line charts, up/down for horizontal bar charts). You can also set it
  explicitly with `axis`.
- **Letter keys** toggle individual series on and off. Use the
  `series_keys` argument to map a single letter to each series name.

Add [`ro_e_keyboard_nav()`](../reference/ro_e_keyboard_nav.md) as the
last step in the pipeline:

``` r

dat_weekly |>
  group_by(sex) |>
  e_charts(week) |>
  e_line(n) |>
  e_title(
    "Weekly cases by sex",
    "Use arrow keys to navigate, W/M to toggle series"
  ) |>
  e_x_axis(name = "Week") |>
  e_y_axis(name = "Value") |>
  e_tooltip(trigger = "axis") |>
  ro_e_theme(palette = "gender_con") |>
  ro_e_keyboard_nav(series_keys = c(w = "Women", m = "Men", t = "Total"))
```

Where you assign “w” to “Women”, “m” to “Men”, and “t” to “Total”. You
can also extent this further. For example, in the case of Dutch
provinces:

``` r

tab_cases_week_by_prov |>
  group_by(Province) |>
  e_charts(x = week) |>
  e_line(n) |>
  e_axis_labels(y = "Number of cases", x = "Date") |>
  e_x_axis(
    formatter = htmlwidgets::JS(
      'function (value) {
    var monthShortNames = ["Jan","Feb","Mar","Apr","May","Jun",
                           "Jul","Aug","Sep","Oct","Nov","Dec"];
    var d = new Date(value);
    return monthShortNames[d.getMonth()] + "  " + d.getFullYear();
  }'
    )
  ) |>
  e_title("COVID-19 cases per week for 5 Dutch provinces") |>
  e_legend() |>
  e_tooltip(trigger = "item") |>
  ro_e_theme() |>
  ro_e_keyboard_nav(
    series_keys = c(
      f = "Flevoland",
      g = "Groningen",
      n = "Noord-Brabant",
      u = "Utrecht",
      z = "Zeeland"
    ),
    axis = "both"
  )
```

Note that names must be single letters and values must exactly match the
series names in the chart.

For a horizontal bar chart,
[`ro_e_keyboard_nav()`](../reference/ro_e_keyboard_nav.md) auto-detects
the vertical orientation and binds the up/down arrow keys instead:

``` r

dat_cases |>
  filter(sex == "Women") |>
  e_charts(agegroup) |>
  e_bar(n, name = "Women") |>
  e_flip_coords() |>
  e_title("Cases by age group", "Use up/down arrow keys to navigate") |>
  e_y_axis(name = "Age class") |>
  e_x_axis(name = "Value") |>
  e_tooltip(trigger = "axis") |>
  ro_e_theme() |>
  ro_e_keyboard_nav()
```
