#' ChatGPT match validation between Ecoinvent activities and EU Taxonomy activities' description
#'
#' @param data A dataframe
#'
#' @return A dataframe
#' @export
#'
#' @examples
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
#' ecoinvent_activities_eu_tax_activities(
#'   ecoinvent_activities_with_nace, eu_tax_activities_all_with_keywords
#' ))
#'
#' output <- eco_activities_gpt_validation(eco_activities_after_keywords_search)
#' output
eco_activities_gpt_validation <- function(data) {
  api_key <- readLines('/Users/kalashsinghal/git/key/access_key.txt')

  gpt_validation <- data |>
    mutate(gpt_validation = unlist(Map(gpt_validate, data$ecoinvent_activity_name, data$tax_activity_description)))

  api_key = "---"
  rm(api_key)

  return(gpt_validation)
}

gpt_validate <- function(ecoinvent, taxonomy) {
  prompt <- "We have a dataframe with columns 'ecoinvent_activity_name' and
  'taxonomy_activity_description'. Check row wise whether the ecoinvent activity
  (column 'ecoinvent_activity_name') covered by the EU Taxonomy activity description
  (column 'taxonomy_activity_description'). Please provide only one word answer
  with `Yes` or `No` without any explaination, where `Yes` means covered well and
  `No` means not covered well.

  'ecoinvent_activity_name' column = {%s}
  'taxonomy_activity_description' column = {%s}
  "

  if (is.na(ecoinvent) | is.na(taxonomy)) {
    output <- "No"
  } else {
    prompt_with_data <- sprintf(prompt, ecoinvent, taxonomy)
    output <- create_chat_completion(
      model = "gpt-4-turbo",
      messages = list(list("role" = "user", "content" = prompt_with_data))
    )$choices$message.content
  }
  output
}
