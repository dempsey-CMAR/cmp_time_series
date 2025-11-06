
# dynamic height depending on how many counties and stations selected
get_county_fig_height <- function(county, station) {

  n_county <- length(county)
  n_station <- length(station)

  h_base <- 300

  if(n_county > 1) {
    h <- h_base * n_county
  }

  if(n_county == 1) h <- 500
  if(n_county == 1 && county == "Guysborough") h <- 700

  # if("All" %in% county && "All" %in% station) {
  #   h <- 4500
  # } else if (county == "Guysborough") {
  #   h <- 700
  # } else h <- 500

  h
}
