#' Outputs product-level columns of `ep_companies_ei_activities`
#'
#' @param data [ep_companies_ei_activities]
#'
#' @return A dataframe
#' @export
#'
#' @examples
#' output <- ep_companies_ei_activities_at_product_level(ep_companies_ei_activities)
#' output
ep_companies_ei_activities_at_product_level <- function(data) {
  data |>
    select("ep_product", "activity_uuid_product_uuid", "ecoinvent_activity_name", "isic_4digit") |>
    distinct()
}

#' Outputs company-level columns of `ep_companies_ei_activities`
#'
#' @param data [ep_companies_ei_activities]
#'
#' @return A dataframe
#' @export
#'
#' @examples
#' output <- ep_companies_ei_activities_at_company_level(ep_companies_ei_activities)
#' output
ep_companies_ei_activities_at_company_level <- function(data) {
  data |>
    select("companies_id", "company_name", "country", "ep_product", "activity_uuid_product_uuid") |>
    distinct()
}
