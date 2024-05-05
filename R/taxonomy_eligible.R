#' Outputs EU Taxonomy-eligible results
#'
#' @param data A dataframe
#'
#' @return A dataframe
#' @export
#'
#' @examples
#' data <- tibble::tibble(
#'   ep_product = c("plastic", "iron"),
#'   keyword_is_present = c(TRUE, FALSE),
#'   gpt_validation = c("Yes", "No")
#' )
#' output <- taxonomy_eligible(data)
#' output
taxonomy_eligible <- function(data) {
  data |>
    filter((.data$keyword_is_present == TRUE) & (.data$gpt_validation == "Yes"))
}
