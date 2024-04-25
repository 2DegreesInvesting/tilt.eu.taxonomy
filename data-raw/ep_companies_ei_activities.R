ep_companies_ei_activities <- read_csv("inst/extdata/ep_companies_ei_activities.csv", show_col_types = FALSE) |>
  rename(ecoinvent_activity_name = "Activity Name", ep_product = "clustered") |>
  distinct()

usethis::use_data(ep_companies_ei_activities, overwrite = TRUE)

