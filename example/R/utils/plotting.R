# =============================================================================
# Plotting Utilities
# =============================================================================
# Generic theme, colours and saving with ggplot2. Project-specific
# plot_<thing>() functions go below the generic section.
# =============================================================================

source(here::here("R/utils/data_io.R"))

# ----- Color Palettes -----

#' Color palettes for manuscript figures
#'
#' The single source of colours for every figure, so a variable has the same
#' colour everywhere. Do not redefine colours in individual plotting
#' functions; add a named entry here instead.
#'
#' @return Named list of color values
manuscript_colors <- function() {
  list(
    female = "#8B0000",        # Dark red
    male = "#191970",          # Midnight blue
    combined = "gray40",
    reference_line = "gray50",
    # Slide figures: the slide theme's inks (reports-src/slides.scss), a
    # light grid, and a grey for marks shown as context beside an
    # emphasised one
    ink = "#161616",
    ink_soft = "#454545",
    ink_muted = "#737373",
    grid = "#E4E4E4",
    context = "#A6A6A6",
    # Species, from tol_bright; red is left out because it is too close to
    # the McGill red of the slides (docs/STYLE.md)
    adelie = "#4477AA",               # tol_bright blue
    chinstrap = "#228833",            # tol_bright green
    gentoo = "#AA3377"                # tol_bright purple
  )
}

#' Get standard color palette
#'
#' Colourblind-safe palettes. Use manuscript_colors() for named, per-variable
#' colours.
#'
#' @param type "default" (Okabe-Ito), "tol_bright", "tol_muted", "sex",
#'   "sex_md" (ggtext labels)
#' @return Color vector
get_palette <- function(type = "default") {
  colors.lst <- manuscript_colors()
  palettes <- list(
    default = c(
      "#999999", "#E69F00", "#56B4E9", "#009E73",
      "#F0E442", "#0072B2", "#D55E00", "#CC79A7"
    ),
    # Paul Tol, https://personal.sron.nl/~pault/
    tol_bright = c(
      blue = "#4477AA", cyan = "#66CCEE", green = "#228833",
      yellow = "#CCBB44", red = "#EE6677", purple = "#AA3377",
      grey = "#BBBBBB"
    ),
    tol_muted = c(
      indigo = "#332288", cyan = "#88CCEE", teal = "#44AA99",
      green = "#117733", olive = "#999933", sand = "#DDCC77",
      rose = "#CC6677", wine = "#882255", purple = "#AA4499"
    ),
    sex = c(
      Female = colors.lst$female,
      Male = colors.lst$male,
      Combined = colors.lst$combined
    ),
    sex_md = c(
      Female = sprintf(
        "<span style='color: %s;'>Female</span>", colors.lst$female
      ),
      Male = sprintf(
        "<span style='color: %s;'>Male</span>", colors.lst$male
      )
    )
  )

  if (!type %in% names(palettes)) {
    stop("Unknown palette: ", type, call. = FALSE)
  }
  palettes[[type]]
}

# ----- Plot Themes -----

#' Standard ggplot theme for publications
#' @param base_size Base font size
#' @param use_markdown Whether to use ggtext markdown in axis titles and text,
#'   strips and the plot title (requires the ggtext package)
#' @return ggplot2 theme object
theme_publication <- function(base_size = 10, use_markdown = FALSE) {
  base_theme <- ggplot2::theme_classic(base_size = base_size) +
    ggplot2::theme(
      text = ggplot2::element_text(size = base_size),
      axis.text = ggplot2::element_text(size = base_size - 1),
      plot.caption = ggplot2::element_text(size = base_size - 3),
      legend.position = "bottom"
    )

  if (use_markdown) {
    if (!requireNamespace("ggtext", quietly = TRUE)) {
      stop("use_markdown = TRUE requires the ggtext package", call. = FALSE)
    }
    base_theme <- base_theme +
      ggplot2::theme(
        axis.title.x = ggtext::element_markdown(),
        axis.title.y = ggtext::element_markdown(),
        axis.text.x = ggtext::element_markdown(),
        axis.text.y = ggtext::element_markdown(),
        strip.text = ggtext::element_markdown(),
        plot.title = ggtext::element_markdown()
      )
  }

  base_theme
}

#' Base size in points that sets figure text to the slides' data size
#' @param text_px Text height on the slide, in slide pixels
#' @param dpi Resolution the slide figure is saved at
#' @return Font size in points
slide_base_size <- function(text_px, dpi) {
  text_px / (dpi / 72)
}

#' Register the slides' typeface for figures
#'
#' Quarto ships Source Sans Pro with its revealjs theme, in regular and
#' semibold. Registering those files lets ragg draw figure text in the
#' slides' face, with "bold" set in the semibold, as on the slides.
#' @param family Family name to register
#' @return The family name, invisibly
register_slide_font <- function(family = "Source Sans Pro") {
  share <- system2("quarto", "--paths", stdout = TRUE)[[2]]
  font_dir <- file.path(share, "formats", "revealjs", "reveal", "dist",
                        "theme", "fonts", "source-sans-pro")
  files.v <- file.path(font_dir, paste0(
    "source-sans-pro-", c("regular", "semibold", "italic", "semibolditalic"),
    ".ttf"
  ))
  if (!all(file.exists(files.v))) {
    stop("Source Sans Pro not found in ", font_dir, call. = FALSE)
  }
  systemfonts::register_font(family, plain = files.v[1], bold = files.v[2],
                             italic = files.v[3], bolditalic = files.v[4])
  invisible(family)
}

#' Theme for slide figures: recessive axes and grid, text in the slide inks
#' and typeface, no legend (marks are labelled directly)
#' @param base_size Base font size in points, from slide_base_size()
#' @param base_family Font family, registered by register_slide_font()
#' @return ggplot2 theme object
theme_slide <- function(base_size, base_family = "Source Sans Pro") {
  colors.lst <- manuscript_colors()
  ggplot2::theme_minimal(base_size = base_size,
                         base_family = base_family) +
    ggplot2::theme(
      text = ggplot2::element_text(colour = colors.lst$ink_soft),
      axis.text = ggplot2::element_text(size = base_size,
                                        colour = colors.lst$ink_muted),
      axis.title = ggplot2::element_text(size = base_size,
                                         colour = colors.lst$ink),
      panel.grid.major = ggplot2::element_line(colour = colors.lst$grid,
                                               linewidth = 0.3),
      panel.grid.minor = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(size = base_size, face = "bold",
                                         colour = colors.lst$ink, hjust = 0),
      legend.position = "none",
      # A legend, where a figure has one, starts at the figure's left edge,
      # in line with the slide text
      legend.location = "plot",
      legend.justification.top = "left",
      legend.margin = ggplot2::margin(0, 0, 0, 0),
      legend.key.size = ggplot2::unit(base_size, "pt"),
      legend.text = ggplot2::element_text(size = base_size,
                                          colour = colors.lst$ink),
      # No left margin: labels and legends start at the slide's text edge
      plot.margin = ggplot2::margin(4, 8, 4, 0)
    )
}

# ----- Plot Helpers -----

#' Save plot with standard settings
#' @param plot ggplot object
#' @param filename Output filename; the extension sets the format
#' @param width Plot width in inches
#' @param height Plot height in inches
#' @param dpi Resolution
save_plot <- function(plot, filename, width = 7, height = 7, dpi = 600) {
  ensure_directory(dirname(filename))

  # ggsave's default pdf device leaves fonts unembedded, which journals
  # reject; cairo_pdf embeds them. PNGs go through ragg, which draws the
  # fonts registered with systemfonts
  extension <- tolower(tools::file_ext(filename))
  device <- if (extension == "pdf") {
    grDevices::cairo_pdf
  } else if (extension == "png") {
    ragg::agg_png
  }

  ggplot2::ggsave(
    filename = filename,
    plot = plot,
    device = device,
    width = width,
    height = height,
    units = "in",
    dpi = dpi
  )

  invisible(filename)
}

#' Wrap long text (titles, captions)
#' @param text Text to wrap, or NULL
#' @param width Maximum line width
#' @param indent Indentation for wrapped lines
#' @return Wrapped text, or NULL for NULL
wrap_text <- function(text, width = 100, indent = 0) {
  # str_wrap(NULL) gives character(0), for which ggplot2 still lays out a
  # label; NULL leaves it out
  if (is.null(text)) return(NULL)
  stringr::str_wrap(text, width = width, exdent = indent)
}

#' Coefficient plot: estimates with CIs, by group
#' @param data Data frame
#' @param x Term variable (axis after coord_flip)
#' @param y Estimate variable
#' @param group Grouping variable (colour and shape)
#' @param ci_lower Lower CI bound variable
#' @param ci_upper Upper CI bound variable
#' @param sig Optional variable with values "sig" / "non-sig"
#' @param colors Color palette
#' @return ggplot object
plot_comparison <- function(data, x, y, group, ci_lower, ci_upper,
                            sig = NULL, colors = NULL) {
  if (is.null(colors)) {
    colors <- get_palette("default")
  }

  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = .data[[x]], y = .data[[y]],
      colour = .data[[group]], group = .data[[group]]
    )
  )

  if (!is.null(sig)) {
    p <- p + ggplot2::aes(alpha = .data[[sig]])
  }

  p <- p +
    ggplot2::geom_errorbar(
      ggplot2::aes(ymin = .data[[ci_lower]], ymax = .data[[ci_upper]]),
      position = ggplot2::position_dodge(width = 1),
      width = 0
    ) +
    ggplot2::geom_point(
      ggplot2::aes(shape = .data[[group]]),
      position = ggplot2::position_dodge(width = 1),
      size = 0.75
    ) +
    ggplot2::geom_hline(
      yintercept = 0,
      linetype = "dashed",
      alpha = 0.5,
      colour = manuscript_colors()$reference_line
    ) +
    ggplot2::scale_colour_manual(values = colors) +
    theme_publication()

  if (!is.null(sig)) {
    p <- p +
      ggplot2::scale_alpha_manual(
        values = c("non-sig" = 0.5, "sig" = 1),
        guide = "none"
      )
  }

  p + ggplot2::coord_flip()
}

# =============================================================================
# Project-specific figures: one plot_<thing>() per figure
# =============================================================================

#' Body mass by species, one panel per sex
#'
#' @param penguins.dt Penguins with columns species, sex and body_mass
#' @param means.dt Means with CIs: species, sex, mean, lower, upper
#' @param colors.v Colours named by species
#' @param title,subtitle,caption Figure text; the title may use markdown
#' @param base_size Base font size
#' @param slide TRUE for the slide version, in theme_slide()
#' @return ggplot object
plot_body_mass.fn <- function(penguins.dt, means.dt, colors.v, title,
                              subtitle, caption, base_size, slide = FALSE) {
  plot <- ggplot2::ggplot(mapping = ggplot2::aes(species, colour = species)) +
    ggplot2::geom_jitter(
      data = penguins.dt, ggplot2::aes(y = body_mass),
      width = 0.2, height = 0, alpha = 0.35,
      size = if (slide) 1.6 else base_size / 10
    ) +
    ggplot2::geom_pointrange(
      data = means.dt,
      ggplot2::aes(y = mean, ymin = lower, ymax = upper),
      colour = "black", size = if (slide) 0.6 else base_size / 25,
      linewidth = if (slide) 0.9 else base_size / 15
    ) +
    ggplot2::facet_wrap(~sex, nrow = 1) +
    ggplot2::scale_colour_manual(values = colors.v, guide = "none") +
    ggplot2::labs(
      x = NULL, y = "Body mass (g)",
      title = title, subtitle = subtitle, caption = wrap_text(caption, 100)
    )
  if (slide) {
    return(plot + theme_slide(base_size) +
             ggplot2::theme(panel.grid.major.x = ggplot2::element_blank(),
                            panel.spacing = ggplot2::unit(2, "lines")))
  }
  plot + theme_publication(base_size = base_size, use_markdown = TRUE)
}

#' Slide figure: penguins analysed per species, one panel per sex, with
#' each count at its bar's end
#'
#' @param penguins.dt Penguins with columns species and sex
#' @param colors.v Colours named by species
#' @param base_size Base font size, from slide_base_size()
#' @return ggplot object
plot_sample_counts.fn <- function(penguins.dt, colors.v, base_size) {
  counts.dt <- penguins.dt[, .N, by = .(species, sex)]
  counts.dt[, species := factor(species, levels = rev(names(colors.v)))]
  ggplot2::ggplot(counts.dt,
                  ggplot2::aes(x = N, y = species, fill = species)) +
    ggplot2::geom_col(width = 0.62) +
    ggplot2::geom_text(ggplot2::aes(label = N), hjust = -0.2,
                       colour = manuscript_colors()$ink,
                       size = base_size / ggplot2::.pt) +
    ggplot2::facet_wrap(~sex, nrow = 1) +
    ggplot2::scale_fill_manual(values = colors.v, guide = "none") +
    ggplot2::scale_x_continuous(expand = ggplot2::expansion(mult = c(0, 0.3))) +
    ggplot2::labs(x = "Penguins analysed", y = NULL) +
    theme_slide(base_size) +
    ggplot2::theme(
      panel.grid.major.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_text(colour = manuscript_colors()$ink),
      panel.spacing = ggplot2::unit(1.5, "lines")
    )
}

#' Slide figure: male minus female body mass within each species, with the
#' model's single difference adjusted for species as a reference line
#'
#' @param differences.dt Differences with CIs: species, estimate, lower,
#'   upper
#' @param model_difference The adjusted difference from the linear model
#' @param colors.v Colours named by species
#' @param base_size Base font size, from slide_base_size()
#' @return ggplot object
plot_differences.fn <- function(differences.dt, model_difference, colors.v,
                                base_size) {
  colors.lst <- manuscript_colors()
  plot.dt <- copy(differences.dt)
  plot.dt[, species := factor(species, levels = rev(names(colors.v)))]
  ggplot2::ggplot(plot.dt, ggplot2::aes(x = estimate, y = species,
                                        colour = species)) +
    ggplot2::geom_vline(xintercept = model_difference, linetype = "22",
                        colour = colors.lst$ink_muted, linewidth = 0.5) +
    ggplot2::annotate("text", x = model_difference, y = 3.55,
                      label = sprintf("Model: %.0f g", model_difference),
                      hjust = -0.06, vjust = 0, colour = colors.lst$ink_muted,
                      size = base_size / ggplot2::.pt) +
    ggplot2::geom_segment(ggplot2::aes(x = lower, xend = upper,
                                       yend = species), linewidth = 1) +
    ggplot2::geom_point(size = 4.5) +
    ggplot2::scale_colour_manual(values = colors.v, guide = "none") +
    ggplot2::scale_y_discrete(expand = ggplot2::expansion(add = c(0.5, 0.9))) +
    ggplot2::coord_cartesian(clip = "off") +
    ggplot2::labs(x = "Male minus female body mass (g)", y = NULL) +
    theme_slide(base_size) +
    ggplot2::theme(
      panel.grid.major = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_text(colour = colors.lst$ink)
    )
}
