## Taxonomy Regulation sets out six climate and environmental objectives.
## Source: https://ec.europa.eu/sustainable-finance-taxonomy/home

## Six Objectives
# Climate change mitigation
eu_tax_climate_mitigation <- read_xlsx("inst/extdata/taxonomy.xlsx", sheet = 1) |>
  prepare_taxonomy_objectives()
# Climate change adaptation
eu_tax_climate_adaptation <- read_xlsx("inst/extdata/taxonomy.xlsx", sheet = 2) |>
  prepare_taxonomy_objectives()
# Protection of water and marine resources
eu_tax_water_protection <- read_xlsx("inst/extdata/taxonomy.xlsx", sheet = 3) |>
  prepare_taxonomy_objectives()
# Transition to a Circular Economy
eu_tax_circular_economy_transition <- read_xlsx("inst/extdata/taxonomy.xlsx", sheet = 4) |>
  prepare_taxonomy_objectives()
# Pollution Prevention
eu_tax_pollution_prevention <- read_xlsx("inst/extdata/taxonomy.xlsx", sheet = 5) |>
  prepare_taxonomy_objectives()
# Protection and restoration of Biodiversity
eu_tax_biodiversity_protection <- read_xlsx("inst/extdata/taxonomy.xlsx", sheet = 6) |>
  prepare_taxonomy_objectives()

usethis::use_data(eu_tax_climate_mitigation, overwrite = TRUE)
usethis::use_data(eu_tax_climate_adaptation, overwrite = TRUE)
usethis::use_data(eu_tax_water_protection, overwrite = TRUE)
usethis::use_data(eu_tax_circular_economy_transition, overwrite = TRUE)
usethis::use_data(eu_tax_pollution_prevention, overwrite = TRUE)
usethis::use_data(eu_tax_biodiversity_protection, overwrite = TRUE)
