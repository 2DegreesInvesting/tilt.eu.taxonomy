test_that("each keyword is searched as a separate keyword", {
  ep_companies_ei_activities_sample <- tibble::tibble(
    companies_id = "any",
    company_name = "any",
    country = "any",
    ep_product = "any",
    activity_uuid_product_uuid = "any",
    ecoinvent_activity_name = "ethylenediaminetetraacetic",
    isic_4digit = "2011"
  )

  ecoinvent_activities_with_nace <- ecoinvent_activities_with_nace(
    ep_companies_ei_activities_sample,
    isic_nace_mapper
  )

  eu_tax_activities_all <- eu_tax_activities_all(
    eu_tax_climate_mitigation, eu_tax_climate_adaptation,
    eu_tax_water_protection, eu_tax_circular_economy_transition,
    eu_tax_pollution_prevention, eu_tax_biodiversity_protection
  )

  eu_tax_activities_all_with_keywords <- eu_tax_activities_all_with_keywords(
    eu_tax_activities_all,
    eu_tax_activities_keywords |>
      # This activity contains keyword "ethylene".
      filter(tax_activity == "Manufacture of organic basic chemicals")
  ) |>
    filter(!is.na(tax_activity_keywords))

  output <- eco_activities_after_keywords_search(ecoinvent_activities_eu_tax_activities(
    ecoinvent_activities_with_nace, eu_tax_activities_all_with_keywords
  ))

  # The keyword "ethylene" should not be matched with "ethylenediaminetetraacetic".
  # Hence, `keyword_is_present` should have a FALSE value
  expect_false(any(output$keyword_is_present))
})
