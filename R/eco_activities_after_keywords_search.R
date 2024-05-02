#' Ecoinvent activities mapped with EU Taxonomy activities after keywords search
#'
#' @param data A dataframe
#'
#' @return A dataframe
#' @export
#'
#' @examples
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
#'   eu_tax_activities_all,
#'   eu_tax_activities_keywords
#' )
#'
#' output <- eco_activities_after_keywords_search(ecoinvent_activities_eu_tax_activities(
#'   ecoinvent_activities_with_nace, eu_tax_activities_all_with_keywords
#' ))
#' output
eco_activities_after_keywords_search <- function(data) {
  data$keyword_is_present <- mapply(check_matches, data$ecoinvent_activity_name, data$tax_activity_keywords)
  return(data)
  # data |>
  #   rowwise() |>
  #   mutate(keyword_is_present = any(str_detect(.data$ecoinvent_activity_name, str_split(.data$tax_activity_keywords, ";", simplify = TRUE)))) |>
  #   ungroup()
}

check_matches <- function(sentence, words_to_search) {
  words <- unlist(str_split(words_to_search, "; "))
  pattern <- paste0("\\b", paste(words, collapse = "\\b|\\b"), "\\b")
  matches <- any(str_detect(sentence, pattern))
  return(matches)
}
