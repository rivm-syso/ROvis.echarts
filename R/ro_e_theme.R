# Public function ----------------------------------------------------------

#' Apply the RO echarts theme to an echarts4r object
#'
#' @description
# #' `r ro_group_badge('echarts4r')`
#' `ro_e_theme()` applies the Rijksoverheid (RO) visual style to
#' an [echarts4r](https://echarts4r.john-coene.com/) chart. It is the echarts
#' equivalent of [ROvis.ggplot2::ro_gg_theme()] and is designed to slot into any echarts4r
#' pipeline.
#'
#' The theme is generated at call time from [ROvis.utils::ro_color()] and [ROvis.utils::ro_color_palette()].
#' A custom accessible HTML legend is always included. The native ECharts
#' legend is replaced automatically to meet the RO accessibility spec.
#'
#' @section RO style applied:
#' * Series colors from [ro_color_palette()] (default: `"categorical"`).
#' * Title in `ro_color("lintblauw")`, subtitle in `ro_color("donkerblauw")`.
#' * Axis labels and ticks in `ro_color("grijs_7")`.
#' * Horizontal grid lines (value axis); no vertical grid lines.
#' * No axis line or ticks on the value axis.
#' * Custom HTML legend with per-item borders and hover/hidden styles.
#'
#' @param e An echarts4r object (created with [echarts4r::e_charts()]).
#' @param palette Character. Palette to use for series colors. One of
#' `"categorical"` (default), `"gender_con"`, or `"gender_unc"`. Passed to
#' [ro_color_palette()].
#' @param fixed_aspect Logical. When `TRUE` (default), the total element
#' (title + chart + legend) maintains a 2:1 width-to-height ratio, and the
#' inner plot area (grid only, excluding axis labels and legend) maintains a
#' 3:1 width-to-height ratio. Both ratios update responsively on resize. Set
#' to `FALSE` to let the chart fill whatever height its container provides
#' (useful when embedding in a fixed-size layout or a Shiny app with explicit
#' `height`).
#' @param font `NULL` (default) or a character string naming a system font
#' family. When `NULL`, RijksoverheidSansWebText is used if installed,
#' otherwise Verdana. Supply a font name to override both the chart labels and
#' the custom HTML legend. A warning is issued if the font is not found on the
#' system.
#' @param renderer The renderer to use. One of `"svg"` or `"canvas"`.
#' Defaults to `"svg"` to comply with accessibility standards.
#'
#' @return The modified echarts4r object.
#'
#' @seealso
#' * [ROvis.ggplot2::ro_gg_theme()] for the ggplot2 equivalent.
#' * [ro_e_keyboard_nav()] to add keyboard accessibility on top of the theme.
#' * [ROvis.utils::ro_color_palette()] to inspect the available palettes.
#' * [ROvis.utils::ro_color()] to look up individual RO color hex codes.
#'
#' @examples
#' \dontrun{
#' library(echarts4r)
#'
#' mtcars |>
#'   e_charts(wt) |>
#'   e_scatter(mpg) |>
#'   ro_e_theme()
#' }
#'
#' @importFrom echarts4r e_theme_custom
#' @importFrom htmlwidgets onRender
#' @family echarts4r
#' @export
ro_e_theme <- function(
  e,
  palette = "categorical",
  fixed_aspect = TRUE,
  font = NULL,
  renderer = "svg"
) {
  renderer <- arg_match(renderer, c("svg", "canvas"))
  e$x$renderer <- renderer

  palette <- arg_match(
    palette,
    c("categorical", "full", "gender_con", "gender_unc", "greys")
  )

  palette_colors <- unname(ro_color_palette(palette))
  font_family <- ro_check_if_font_available(
    font %||% "RijksoverheidSansWebText"
  )

  series <- e$x$opts$series %||% list()

  # Warn when a bar or line chart has a numeric (value) x-axis. Scatter charts
  # intentionally use continuous axes, so they are excluded. Horizontal bar
  # charts (e_flip_coords()) are also excluded: after flipping, y is "category"
  # and x is "value" by design.
  series_types <- vapply(series, function(s) s[["type"]] %||% "", character(1))
  xaxis <- e$x$opts$xAxis
  yaxis <- e$x$opts$yAxis
  if (
    any(series_types == "bar") &&
      length(xaxis) > 0 &&
      identical(xaxis[[1]]$type, "value") &&
      !(length(yaxis) > 0 && identical(yaxis[[1]]$type, "category"))
  ) {
    cli_warn(c(
      "!" = "The x-axis variable is numeric, which creates a continuous axis.",
      "i" = "If not intended, convert the variable to a factor: {.code mutate(year = factor(year))}"
    ))
  }
  series_names <- vapply(
    series,
    function(s) as.character(s[["name"]] %||% ""),
    character(1)
  )
  series_names <- series_names[nzchar(series_names)]

  theme <- ro_e_theme_list(palette, font_family)
  tmp <- tempfile(fileext = ".json")
  jsonlite::write_json(theme, tmp, auto_unbox = TRUE)
  e <- e_theme_custom(e, tmp)
  onRender(
    e,
    ro_e_build_onrender_js(
      palette_colors,
      series_names,
      font_family,
      ro_color("lintblauw"),
      fixed_aspect
    )
  )
}


# Internal helpers ---------------------------------------------------------

#' Builds the RO echarts theme as a nested R list.
#'
#' All color values are derived from ro_color(): never use raw hex codes here.
#'
#' @keywords internal
#'
#' @param palette Name of the palette to pass to ro_color_palette().
#' @param font_family Resolved font family string (from ro_check_if_font_available()).
#' @family echarts4r
#' @return A nested list suitable for jsonlite::write_json().
ro_e_theme_list <- function(palette, font_family) {
  list(
    color = as.list(unname(ro_color_palette(palette))),

    backgroundColor = "rgba(0,0,0,0)",

    textStyle = list(fontFamily = font_family),

    title = list(
      left = "left",
      textStyle = list(
        color = ro_color("lintblauw"),
        fontWeight = "bold",
        fontSize = 17
      ),
      subtextStyle = list(color = ro_color("lintblauw"), fontSize = 14)
    ),

    # --- Series type defaults -------------------------------------------

    # Line chart: markers hidden via opacity:0 in normal state; shown on hover.
    # showSymbol:true keeps symbol elements in the DOM so opacity transitions
    # are handled cleanly by ECharts. showSymbol:false uses an internal
    # show/hide mechanism that has a known glitch where symbols get stuck
    # visible after moving off a hovered marker back onto the canvas.
    # emphasis.focus = "series" is required to activate blur on other series.
    line = list(
      showSymbol = TRUE,
      symbol = "circle",
      symbolSize = 10,
      lineStyle = list(width = 1.5),
      smooth = FALSE,
      itemStyle = list(borderWidth = 0, opacity = 0),
      emphasis = list(
        focus = "series",
        lineStyle = list(width = 2.5),
        itemStyle = list(color = "#ffffff", borderWidth = 3, opacity = 1)
      ),
      blur = list(
        lineStyle = list(opacity = 0.3),
        itemStyle = list(opacity = 0)
      )
    ),

    # Bar / column chart.
    # barCategoryGap: space between category groups
    # barGap: space between bars within a group
    # emphasis.focus = "series" activates blur on other series when hovering.
    bar = list(
      barCategoryGap = "20%",
      barGap = "0%",
      itemStyle = list(barBorderWidth = 0),
      emphasis = list(focus = "series"),
      blur = list(itemStyle = list(opacity = 0.3))
    ),

    # Scatter: no item border.
    scatter = list(itemStyle = list(borderWidth = 0)),

    # Remaining series types (radar, pie, boxplot, etc.) can be filled in
    # when those chart types are added.

    # --- Grid -----------------------------------------------------------
    # Reserve space for the subtitle (if any)
    grid = list(
      top = 100,
      left = "left",
      right = 10
    ),

    # --- Axis styles ----------------------------------------------------

    # Category axis (x-axis for column/line; y-axis for bar after e_flip_coords()).
    categoryAxis = list(
      axisLine = list(
        show = TRUE,
        lineStyle = list(color = ro_color("grijs_7"), width = 1.5)
      ),
      axisTick = list(
        show = TRUE,
        lineStyle = list(color = ro_color("grijs_7"), width = 1.5),
        length = 4
      ),
      axisLabel = list(show = TRUE, color = ro_color("grijs_7"), fontSize = 12),
      nameLocation = "end",
      nameGap = 0,
      # verticalAlign "top" anchors the bounding box at the axis line; padding pushes text below labels
      # axisLabel.margin (8) + axisLabel fontSize (12) + 5px offset = 25
      nameTextStyle = list(
        fontSize = 13,
        color = ro_color("lintblauw"),
        align = "right",
        verticalAlign = "top",
        padding = c(25, 0, 0, 0)
      ),
      splitLine = list(show = FALSE),
      splitArea = list(show = FALSE)
    ),

    # Value axis (y-axis for column/line; x-axis for bar after e_flip_coords()).
    valueAxis = list(
      axisLine = list(show = FALSE),
      axisTick = list(show = FALSE),
      axisLabel = list(show = TRUE, color = ro_color("grijs_7"), fontSize = 12),
      nameLocation = "end",
      nameGap = 9,
      nameRotate = 0,
      nameTextStyle = list(
        fontSize = 13,
        color = ro_color("lintblauw"),
        align = "left"
      ),
      splitLine = list(
        show = TRUE,
        lineStyle = list(color = ro_color("grijs_8"), width = 0.25)
      ),
      splitArea = list(show = FALSE)
    ),

    # Time axis: same axis line / tick / split style as category axis.
    timeAxis = list(
      axisLine = list(
        show = TRUE,
        lineStyle = list(color = ro_color("grijs_7"), width = 1.5)
      ),
      axisTick = list(
        show = TRUE,
        lineStyle = list(color = ro_color("grijs_7"), width = 1.5),
        length = 4
      ),
      axisLabel = list(show = TRUE, color = ro_color("grijs_7"), fontSize = 12),
      nameLocation = "end",
      nameGap = 0,
      nameTextStyle = list(
        fontSize = 13,
        color = ro_color("lintblauw"),
        align = "right",
        verticalAlign = "top",
        padding = c(25, 0, 0, 0)
      ),
      splitLine = list(show = FALSE),
      splitArea = list(show = FALSE)
    ),

    # Log axis: same style as value axis.
    logAxis = list(
      axisLine = list(show = FALSE),
      axisTick = list(show = FALSE),
      axisLabel = list(show = TRUE, color = ro_color("grijs_7"), fontSize = 12),
      nameLocation = "end",
      nameGap = 9,
      nameRotate = 0,
      nameTextStyle = list(
        fontSize = 13,
        color = ro_color("lintblauw"),
        align = "left"
      ),
      splitLine = list(
        show = TRUE,
        lineStyle = list(color = ro_color("grijs_8"), width = 0.25)
      ),
      splitArea = list(show = FALSE)
    ),

    # --- Legend ---------------------------------------------------------
    # Position (bottom) is the ECharts 6 default
    legend = list(
      left = "8%",
      bottom = "1%",
      icon = "rect",
      itemWidth = 24,
      itemHeight = 12,
      itemStyle = list(borderWidth = 0),
      emphasis = list(
        itemStyle = list(
          borderWidth = 0,
          borderRadius = 0
        ),
        label = list(fontWeight = "bold", color = ro_color("hemelblauw"))
      ),
      inactiveStyle = list(
        textStyle = list(color = "#c8c8c8")
      ),
      textStyle = list(color = ro_color("grijs_7"), fontSize = 13)
    ),

    # --- Tooltip --------------------------------------------------------
    tooltip = list(
      backgroundColor = "#ffffff",
      borderColor = "#000000",
      borderWidth = 1,
      borderRadius = 0,
      shadowBlur = 0,
      shadowColor = "transparent",
      textStyle = list(
        fontFamily = font_family,
        fontSize = 13,
        color = "#000000",
        fontWeight = "normal"
      ),
      axisPointer = list(
        type = "line",
        axis = "x",
        lineStyle = list(
          color = ro_color("grijs_7"),
          type = "dashed",
          width = 1
        )
      )
    ),

    # --- Toolbox --------------------------------------------------------
    toolbox = list(iconStyle = list(borderColor = ro_color("grijs_7")))
  )
}
