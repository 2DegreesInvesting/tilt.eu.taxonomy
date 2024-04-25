#' Mapping Ecoinvent activities (with NACE) to EU Taxonomy activities
#'
#' @param ecoinvent_activities_with_nace A dataframe
#' @param eu_tax_activities_all_with_keywords A dataframe
#'
#' @return A dataframe
#' @export
#'
#' @examples
#'
#' ecoinvent_activities_with_nace <- ecoinvent_activities_with_nace(
#'   ep_companies_ei_activities |> head(10),
#'   isic_nace_mapper
#' )
#'
#' eu_tax_activities_all <- eu_tax_activities_all(
#'   eu_tax_climate_mitigation, eu_tax_climate_adaptation,
#'   eu_tax_water_protection, eu_tax_circular_economy_transition,
#'   eu_tax_pollution_prevention, eu_tax_biodiversity_protection
#' )
#' eu_tax_activities_all_with_keywords <- eu_tax_activities_all_with_keywords(
#'   eu_tax_activities_all, eu_tax_activities_keywords
#' )
#'
#' output <- ecoinvent_activities_eu_tax_activities(
#'   ecoinvent_activities_with_nace,
#'   eu_tax_activities_all_with_keywords
#' )
#' output
ecoinvent_activities_eu_tax_activities <- function(ecoinvent_activities_with_nace, eu_tax_activities_all_with_keywords) {
  ecoinvent_activities_with_nace |>
    # `full_join` is used to keep the unmatched EU Taxonomy activities in the final result
    full_join(eu_tax_activities_all_with_keywords, by = c("NACE" = "nace"), relationship = "many-to-many") |>
    distinct()
}
