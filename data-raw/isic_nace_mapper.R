isic_nace_mapper <- readxlsb::read_xlsb("inst/extdata/correspondence_tables_0223.xlsb", sheet = "nace_isic") |>
  prepare_isic_nace_mapper()

usethis::use_data(isic_nace_mapper, overwrite = TRUE)
