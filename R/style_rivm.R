library(ROvis.utils)

palette = "categorical"
font = NULL

palette <- arg_match(
  palette,
  c("categorical", "full", "gender_con", "gender_unc", "greys")
)

palette_colors <- unname(ro_color_palette(palette))
font_family <- ro_check_if_font_available(
  font %||% "RijksoverheidSansWebText"
)

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
) |>
  jsonlite::write_json("inst/extdata/rivm.json", auto_unbox = TRUE)
