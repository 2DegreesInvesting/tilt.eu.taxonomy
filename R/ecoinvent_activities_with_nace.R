#' Map NACE codes to Ecoinvent activities
#'
#' @param ep_companies_ei_activities [ep_companies_ei_activities]
#' @param isic_nace_mapper [isic_nace_mapper]
#'
#' @return A dataframe
#' @export
#'
#' @examples
#' output <- ecoinvent_activities_with_nace(ep_companies_ei_activities, isic_nace_mapper)
#' output
ecoinvent_activities_with_nace <- function(ep_companies_ei_activities, isic_nace_mapper) {
  ep_companies_ei_activities |>
    left_join(isic_nace_mapper, by = c("isic_4digit" = "ISIC"), relationship = "many-to-many")
}
