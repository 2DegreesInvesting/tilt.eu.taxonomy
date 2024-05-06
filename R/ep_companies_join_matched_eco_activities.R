#' Join matched ecoinvent activties after gpt validation to Europages companies
#'
#' @param companies A dataframe
#' @param eco_activities_gpt_validation A dataframe
#'
#' @return A dataframe
#' @export
#' @examples
#' \dontrun{
#' ecoinvent_activities_with_nace <- ecoinvent_activities_with_nace(
#'   ep_companies_ei_activities |> dplyr::slice(4:6),
#'   isic_nace_mapper
#' )
#'
#' eu_tax_activities_all <- eu_tax_activities_all(
#'   eu_tax_climate_mitigation, eu_tax_climate_adaptation,
#'   eu_tax_water_protection, eu_tax_circular_economy_transition,
#'   eu_tax_pollution_prevention, eu_tax_biodiversity_protection
#' )
#' eu_tax_activities_all_with_keywords <- eu_tax_activities_all_with_keywords(
#'   eu_tax_activities_all,
#'   eu_tax_activities_keywords
#' )
#'
#' eco_activities_after_keywords_search <- eco_activities_after_keywords_search(
#'   ecoinvent_activities_eu_tax_activities(
#'     ecoinvent_activities_with_nace, eu_tax_activities_all_with_keywords
#'   )
#' )
#'
#' eco_activities_gpt_validation <- eco_activities_gpt_validation(eco_activities_after_keywords_search)
#' companies <- ep_companies_ei_activities_at_company_level(ep_companies_ei_activities)
#'
#' output <- ep_companies_join_matched_eco_activities(companies, eco_activities_gpt_validation)
#' output
#' }
ep_companies_join_matched_eco_activities <- function(companies, eco_activities_gpt_validation) {
  full_join(companies, eco_activities_gpt_validation, by = c(
    "ep_product", "activity_uuid_product_uuid"
  ), relationship = "many-to-many")
}
