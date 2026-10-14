library(ROvis.utils)


font = NULL

palette <- c(
  aqualight = "#00a1cd",
  bluemiddle = "#0058b8",
  greendark = "#488225",
  limemiddle = "#899d0c",
  orangemiddle = "#da5914",
  purpledark = "#56217a",
  redmiddle = "#c90c0f",
  pinklight = "#d9328a",
  aqualight2 = "#0581a2",
  bluemiddle2 = "#163a72",
  greendark2 = "#53a31d",
  limemiddle2 = "#afcb05",
  orangemiddle2 = "#f39200",
  purpledark2 = "#7d4791",
  redmiddled2 = "#9c1006",
  pinklight2 = "#af0e80"
)

css_color <- list(
  brand_color= "#271d6c",
  white= "#fff",
  light_gray= "#e9e9e9",
  dark_gray= "#878787",
  aqua= "#0580a1",
  light_aqua= "#00a1cd",
  dark_aqua= "#005470",
  blue= "#0058b8",
  dark_blue= "#163a72",
  pink= "#af0e80",
  dark_purple= "#56217a",
  red= "#c90c0f",
  web_text= "#091d23"
)

cbs_blue <- c(
  "#e1f4fd"
  , "#c0e7ff"
  , "#77cbe5"
  , "#3d95d4"
  , "#2256a0"
  , "#143564"
  , "#09183c"
)

cbs_blue_7 <- cbs_blue
cbs_blue_5 <- cbs_blue[2:6]


cbs_green <- c(
  "#f1f6de"
  , "#edf0c7"
  , "#c9de85"
  , "#85bc22"
  , "#348a3a"
  , "#0f5f34"
  , "#114625"
)

cbs_green_7 <- cbs_green
cbs_green_5 <- cbs_green[2:6]

cbs_red <- c(
  "#fedfc7"
  , "#ffc597"
  , "#f89e6b"
  , "#e74d15"
  , "#c01f26"
  , "#82001e"
  , "#5b0708"
)

cbs_red_7 <- cbs_red
cbs_red_5 <- cbs_red[2:6]

cbs_purple <- c(
  "#fbe2ed"
  , "#f8c1d9"
  , "#e38cbf"
  , "#be3e8d"
  , "#8b176f"
  , "#490045"
  , "#2d002c"
)

cbs_purple_7 <- cbs_purple
cbs_purple_5 <- cbs_purple[2:6]

cbs_grey <- "#e5e5e5"
cbs_gridLinesColor <- "#878787"
cbs_axisLineColor <- "#777777"

font_title <- "Soho W01 Medium, Cambria, serif"
font_text <- "Akko W01 Regular, Cambria Light, sans-serif"

cbs_style <- list(
  color = as.list(unname(palette))

  , backgroundColor = "transparent"

  , textStyle = list(
    fontFamily = font_text
    , fontSize = 12
  )

  , title = list(
    left = "left"
    , textStyle = list(
      fontFamily = font_title
      , color = css_color$web_text
      , fontSize = 17
    )
    , subtextStyle = list(
      color = css_color$web_text
      , fontSize = 12
    )
  )

  # --- Axis styles ----------------------------------------------------

  # Category axis (x-axis for column/line; y-axis for bar after e_flip_coords()).
  , categoryAxis = list(
    axisLine = list(
      show = TRUE
      , lineStyle = list(color = cbs_axisLineColor, width = 2)
    )
    , axisTick = list(show = FALSE) #, lineStyle = list(color = css_color$dark_gray, width = 1.5), length = 4)
    , axisLabel = list(
      show = TRUE
      , color = css_color$web_text
      , fontSize = 12
    )
    , nameLocation = "end"
    , nameGap = 0
    # verticalAlign "top" anchors the bounding box at the axis line; padding pushes text below labels
    # axisLabel.margin (8) + axisLabel fontSize (12) + 5px offset = 25
    , nameTextStyle = list(
      fontSize = 13
      , color = css_color$web_text
      , align = "left"
      , verticalAlign = "top"
      , padding = c(25, 0, 0, 0)
    )
    , splitLine = list(show = FALSE)
    , splitArea = list(show = FALSE)
  )

  # Value axis (y-axis for column/line; x-axis for bar after e_flip_coords()).
  , valueAxis = list(
    axisLine = list(show = FALSE)
    , axisTick = list(show = FALSE)
    , axisLabel = list(show = TRUE, color = css_color$web_text, fontSize = 12)#, formatter = htmlwidgets::JS(
    #   "function(value) { return Number(value).toLocaleString('fr-FR'); }"
    # ))
    , position = "left"
    , nameLocation = "end"
    , nameGap = 0
    , nameRotate = 50
    , nameTextStyle = list(
      fontSize = 13
      , color = css_color$web_text
      , align = "right"
    )
    , splitLine = list(
      show = TRUE
      , lineStyle = list(color = cbs_gridLinesColor, width = 1)
    )
    , splitArea = list(show = FALSE)
  )

  # Time axis: same axis line / tick / split style as category axis.
  , timeAxis = list(
    axisLine = list(
      show = TRUE
      , lineStyle = list(color = cbs_axisLineColor, width = 2)
    )
    , axisTick = list(show = FALSE) #, lineStyle = list(color = css_color$dark_gray, width = 1.5), length = 4)
    , axisLabel = list(show = TRUE, color = css_color$web_text, fontSize = 12)
    , nameLocation = "end"
    , nameGap = 0
    , nameTextStyle = list(
      fontSize = 30
      , color = css_color$web_text
      , align = "right"
      , verticalAlign = "top"
      , padding = c(25, 0, 0, 0)
    )
    , splitLine = list(show = FALSE)
    , splitArea = list(show = FALSE)
  )

  # Log axis: same style as value axis.
  , logAxis = list(
    axisLine = list(show = FALSE)
    , axisTick = list(show = FALSE)
    , axisLabel = list(show = TRUE, color = css_color$web_text, fontSize = 12)
    , nameLocation = "end"
    , nameGap = 9
    , nameRotate = 0
    , nameTextStyle = list(
      fontSize = 13
      , color = css_color$web_text
      , align = "left"
    )
    , splitLine = list(
      show = TRUE
      , lineStyle = list(color = cbs_gridLinesColor, width = 1)
    )
    , splitArea = list(show = FALSE)
  )


  # --- Legend ---------------------------------------------------------
  # Position (bottom) is the ECharts 6 default
  , legend = list(
    left = "8%"
    , bottom = "1%"
    , icon = "rect"
    , itemWidth = 25
    , itemHeight = 10
    , itemStyle = list(borderWidth = 0)
    , emphasis = list(
      itemStyle = list(
        borderWidth = 0
        , borderRadius = 0
      )
      , label = list(fontWeight = "normal", color = css_color$web_text)
    )
    , inactiveStyle = list(
      textStyle = list(color = "#c8c8c8")
    )
    , textStyle = list(color = css_color$web_text, fontSize = 13)
  )


  # --- Tooltip --------------------------------------------------------
  , tooltip = list(
    backgroundColor = "#ffffffE6"
    , borderColor = css_color$web_text
    , borderWidth = 0.5
    , borderRadius = 0
    , shadowBlur = 0
    , shadowColor = "transparent"
    , textStyle = list(
      fontFamily = font_text
      , fontSize = 13
      , color = "#000000"
      , fontWeight = "normal"
    )
    , axisPointer = list(
      type = "line"
      , axis = "x"
      , lineStyle = list(
        color = css_color$dark_gray
        , type = "dashed"
        , width = 1
      )
    )
  )






  # --- Series type defaults -------------------------------------------

  # Line chart: markers hidden via opacity:0 in normal state; shown on hover.
  # showSymbol:true keeps symbol elements in the DOM so opacity transitions
  # are handled cleanly by ECharts. showSymbol:false uses an internal
  # show/hide mechanism that has a known glitch where symbols get stuck
  # visible after moving off a hovered marker back onto the canvas.
  # emphasis.focus = "series" is required to activate blur on other series.
  , line = list(
    showSymbol = TRUE
    , symbol = "circle"
    , symbolSize = 10
    , lineStyle = list(width = 1.5)
    , smooth = FALSE
    , itemStyle = list(borderWidth = 0, opacity = 0)
    , emphasis = list(
      focus = "series"
      , lineStyle = list(width = 2.5)
      , itemStyle = list(color = "#ffffff", borderWidth = 3, opacity = 1)
    )
    , blur = list(
      lineStyle = list(opacity = 0.3)
      , itemStyle = list(opacity = 0)
    )
  )

  # Bar / column chart.
  # barCategoryGap: space between category groups
  # barGap: space between bars within a group
  # emphasis.focus = "series" activates blur on other series when hovering.
  , bar = list(
    barCategoryGap = "20%"
    , barGap = "0%"
    , itemStyle = list(barBorderWidth = 0)
    , emphasis = list(focus = "series")
    , blur = list(itemStyle = list(opacity = 0.3))
  )

  # Scatter: no item border.
  , scatter = list(itemStyle = list(borderWidth = 0))

  # Remaining series types (radar, pie, boxplot, etc.) can be filled in
  # when those chart types are added.
  #
  # --- Grid -----------------------------------------------------------
  # Reserve space for the subtitle (if any)
  , grid = list(
    top = 100
    , left = "left"
    , right = 10
    , bottom = 10
  )


  # --- Toolbox --------------------------------------------------------
  , toolbox = list(iconStyle = list(borderColor = ro_color("grijs_7")))
)

jsonlite::write_json(cbs_style, "inst/extdata/cbs.json", auto_unbox = TRUE, pretty = TRUE)
