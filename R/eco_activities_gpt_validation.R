eco_activities_gpt_validation <- function(data) {
  gpt_validation <- data |>
    mutate(gpt_validation = unlist(Map(gpt_validate, data$ecoinvent_activity_name, data$tax_activity_description)))

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
