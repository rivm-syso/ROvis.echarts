# Generates the JavaScript snippet for legend keyboard and screen reader access.

Kept separate from the legend styling in ro_e_build_onrender_js() so it
can be switched off or changed on its own. The snippet runs inside the
`seriesNames.length > 1` block of that function and expects `container`
(the `.ro-legend-container` div) and `chart` (the ECharts instance) in
scope.

## Usage

``` r
ro_e_legend_a11y_js()
```

## Value

A character string of JavaScript.

## Details

What it adds to every `.ro-legend-item`:

- `tabindex="0"` and `role="button"`, so Tab reaches it and it is
  announced as a button.

- `aria-label` "Legenda: ", as on the SPIN chart approved for
  accessibility.

- `aria-pressed`, kept in sync with the series visibility.

- Enter / Space toggle the series, same as a mouse click.

- A focus outline that only shows for keyboard focus (`:focus-visible`).

## See also

Other echarts4r:
[`ro_e_announce_title_first()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_announce_title_first.md),
[`ro_e_build_keyboard_nav_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_build_keyboard_nav_js.md),
[`ro_e_build_onrender_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_build_onrender_js.md),
[`ro_e_detect_axis_orientation()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_detect_axis_orientation.md),
[`ro_e_keyboard_nav()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav.md),
[`ro_e_keyboard_nav_axis_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav_axis_js.md),
[`ro_e_sort_axis_labels()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_sort_axis_labels.md),
[`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_standard.md),
[`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md),
[`ro_e_theme_list()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme_list.md),
[`ro_e_tooltip_announce_js()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_tooltip_announce_js.md)
