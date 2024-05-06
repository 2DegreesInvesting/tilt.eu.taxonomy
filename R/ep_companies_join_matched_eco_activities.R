ep_companies_join_matched_eco_activities <- function(companies, eco_activities_gpt_validation) {
  full_join(companies, eco_activities_gpt_validation, by = c(
    "ep_product", "activity_uuid_product_uuid"
  ), relationship = "many-to-many")
}
