# =============================================================================
# Report tables
# =============================================================================
# One create_<thing>_table() per table; the shared styling, formatting and
# saving come from tables.R
# =============================================================================

source(here::here("R/utils/tables.R"))

#' Body mass by species and sex
#'
#' @param table.dt One row per species: species, n and value columns for
#'   each sex (suffixed with the sex label) and difference, already formatted
#' @param sex_labels.v The two sex labels, female first
#' @param ci_level Confidence level, for the column labels
#' @param title Bold short title, may use markdown; NULL in documents, where
#'   the caption carries it
#' @return gt table
create_body_mass_table.fn <- function(table.dt, sex_labels.v, ci_level,
                                      title) {
  ci_label <- sprintf("Mean (%.0f%% CI)", 100 * ci_level)
  labels.lst <- list(species = "Species", difference = sprintf(
    "%s minus %s (%.0f%% CI)", sex_labels.v[2], tolower(sex_labels.v[1]),
    100 * ci_level
  ))
  for (sex in sex_labels.v) {
    labels.lst[[paste0("n_", sex)]] <- "n"
    labels.lst[[paste0("value_", sex)]] <- ci_label
  }
  tbl <- gt::gt(table.dt) |>
    add_title.fn(title) |>
    gt::cols_label(.list = labels.lst) |>
    gt::tab_source_note("Body mass in grams.")
  for (sex in sex_labels.v) {
    tbl <- gt::tab_spanner(
      tbl, label = sex, columns = paste0(c("n_", "value_"), sex)
    )
  }
  style_screen_table.fn(tbl)
}
