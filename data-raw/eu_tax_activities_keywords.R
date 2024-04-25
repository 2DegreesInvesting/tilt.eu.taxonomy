eu_tax_activities_keywords <- read_xlsx("inst/extdata/Prototype_sample_data.xlsx") |>
  select(Activity, Keywords) |>
  rename(tax_activity = "Activity", tax_activity_keywords = "Keywords")

usethis::use_data(eu_tax_activities_keywords, overwrite = TRUE)
