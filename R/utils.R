prepare_isic_nace_mapper <- function(data) {
  data |>
    mutate(NACE.code = str_replace_all(.data$NACE.code, ",", ".")) |>
    mutate(NACE.code = str_replace(.data$NACE.code, "^0+", "")) |>
    separate(.data$ISIC.code.and.title, sep = " ", into = c("ISIC", "ISIC_description"), extra = "merge", fill = "right") |>
    rename(NACE = "NACE.code") |>
    select(.data$NACE, .data$ISIC) |>
    add_altphabetical_prefix()
}

add_altphabetical_prefix <- function(data) {
  prefix <- ""
  for (i in seq_len(nrow(data))) {
    # If the value is not numeric, update the prefix
    if (!grepl("^\\d+\\.?\\d*$", data$NACE[i])) {
      prefix <- data$NACE[i]
    } else {
      # Add the prefix to numeric values
      data$NACE[i] <- paste0(prefix, data$NACE[i])
    }
  }
  data
}

customize_col_names <- function(data) {
  data |>
    rename_all(tolower) |>
    rename_all(~gsub(" ", "_", .))
}

prepare_taxonomy_objectives <- function(data) {
  data |>
    select(-c("...13", "Footnotes")) |>
    relocate(c("Activity"))
}
