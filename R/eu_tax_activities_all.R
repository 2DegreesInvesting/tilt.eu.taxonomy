#' Calculate all EU Taxonomy activities
#'
#' @param eu_tax_climate_mitigation [eu_tax_climate_mitigation]
#' @param eu_tax_climate_adaptation [eu_tax_climate_adaptation]
#' @param eu_tax_water_protection [eu_tax_water_protection]
#' @param eu_tax_circular_economy_transition [eu_tax_circular_economy_transition]
#' @param eu_tax_pollution_prevention [eu_tax_pollution_prevention]
#' @param eu_tax_biodiversity_protection [eu_tax_biodiversity_protection]
#'
#' @return A dataframe
#' @export
#'
#' @examples
#' output <- eu_tax_activities_all(
#'   eu_tax_climate_mitigation, eu_tax_climate_adaptation,
#'   eu_tax_water_protection, eu_tax_circular_economy_transition,
#'   eu_tax_pollution_prevention, eu_tax_biodiversity_protection
#' )
#' output
eu_tax_activities_all <- function(eu_tax_climate_mitigation, eu_tax_climate_adaptation,
                                  eu_tax_water_protection, eu_tax_circular_economy_transition,
                                  eu_tax_pollution_prevention, eu_tax_biodiversity_protection) {
  dfs <- list(
    eu_tax_climate_mitigation, eu_tax_climate_adaptation,
    eu_tax_water_protection, eu_tax_circular_economy_transition,
    eu_tax_pollution_prevention, eu_tax_biodiversity_protection
  )

  column_names <- c("Activity", "NACE", "Description")
  combined_df <- data.frame()
  for (i in seq_along(dfs)) {
    combined_df <- bind_rows(combined_df, dfs[[i]] |>
      select(all_of(column_names)), .id = "source_df")
  }

  prepare_eu_tax_activities_all(combined_df)
}

prepare_eu_tax_activities_all <- function(data) {
  data |>
    select(-c("source_df")) |>
    customize_col_names() |>
    distinct() |>
    # Null NACE creates false mapping between ecoinvent activities and taxonomy activities
    filter(!is.na(.data$nace)) |>
    rename(tax_activity = "activity", tax_activity_description = "description") |>
    separate_rows(.data$nace, sep = ",\\s*")
}
