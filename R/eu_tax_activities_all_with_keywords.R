#' Assign domain-specific keywords to EU Taxonomy activities
#'
#' @param eu_tax_activities_all A dataframe
#' @param eu_tax_activities_keywords [eu_tax_activities_keywords]
#'
#' @return A dataframe
#' @export
#'
#' @examples
#' eu_tax_activities_all <- eu_tax_activities_all(
#'   eu_tax_climate_mitigation, eu_tax_climate_adaptation,
#'   eu_tax_water_protection, eu_tax_circular_economy_transition,
#'   eu_tax_pollution_prevention, eu_tax_biodiversity_protection
#' )
#' output <- eu_tax_activities_all_with_keywords(eu_tax_activities_all, eu_tax_activities_keywords)
#' output
eu_tax_activities_all_with_keywords <- function(eu_tax_activities_all, eu_tax_activities_keywords) {
  eu_tax_activities_all |>
    left_join(eu_tax_activities_keywords, by = c("tax_activity" = "tax_activity"))
}
