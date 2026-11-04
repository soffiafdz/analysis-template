# =============================================================================
# Figures
# =============================================================================
# One plot_<thing>() per figure; the shared theme, colours and saving come
# from plotting.R
# =============================================================================

source(here::here("R/utils/plotting.R"))

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
