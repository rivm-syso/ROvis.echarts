library(ROvis.utils)


font_text <-  "roboto"

palette <- c(
  rood = "#e41a1c",
  blauw = "#377eb8",
  groen = "#4daf4a",
  lime = "#899d0c",
  paars = "#984ea3",
  oranje = "#ff7f00",
  geel = "#ffff33",
  bruin = "#a65628",
  roze = "#f781bf"
)


default_style <- list(
  color = as.list(unname(palette))

  , backgroundColor = "transparent"

  , textStyle = list(
    fontFamily = font_text
  )

  , title = list(
  )

  # --- Axis styles ----------------------------------------------------

  # Category axis (x-axis for column/line; y-axis for bar after e_flip_coords()).
  , categoryAxis = list(
  )

  # Value axis (y-axis for column/line; x-axis for bar after e_flip_coords()).
  , valueAxis = list(
  )

  # Time axis: same axis line / tick / split style as category axis.
  , timeAxis = list(
  )

  # Log axis: same style as value axis.
  , logAxis = list(
  )

  # --- Legend ---------------------------------------------------------
  , legend = list(
  )

  # --- Tooltip --------------------------------------------------------
  , tooltip = list(
  )

  # --- Series type defaults -------------------------------------------
  , line = list(
  )
  , bar = list(
  )
  , scatter = list(
  )

  # --- Toolbox --------------------------------------------------------
  , toolbox = list(
  )
)

jsonlite::write_json(default_style, "inst/extdata/default.json", auto_unbox = TRUE, pretty = TRUE)
