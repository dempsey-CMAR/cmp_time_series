#
# # dynamic height depending on how many counties and stations selected
# # doesn't use station right now, but could once algorithm decided
# get_county_fig_height <- function(county, station) {
#
#   h_base <- 300
#
#   if ("All" %in% county) {
#     n_county <- 15
#   } else { n_county <- length(county) }
#   # n_station <- length(station)
#
#   if (n_county > 1) {
#     h <- h_base * n_county
#   }
#
#   if (n_county == 1) h <- 500
#   if (n_county == 1 && county == "Guysborough") h <- 700
#
#   h
# }
#


# dynamic height depending on how many counties selected
get_county_fig_height <- function(county) {

  h_base <- 300

  #county <- unique(county_station$county)
  n_county <- length(county)

  if (n_county > 1) {
    h <- h_base * n_county
  }

  if (n_county == 1) h <- 500
  if (n_county == 1 && county == "Guysborough") h <- 750

  h
}

# dynamic height depending on how many stations selected
get_station_fig_height <- function(station) {

  n_station <- length(station)


  if(n_station <= 36) {
    h <- 600
  } else if (n_station > 36 & n_station <= 60) {
    h <- 1000
  } else if (n_station > 60 & n_station <= 100) {
    h <- 2000
  } else h <- 3000

  h

    # if (n_station <= 4) {
  #   n_col <- n_station
  # } else n_col <- 4
  #
  # n_row <- ceiling(n_station / n_col)
  #
  # h <- n_row * h_base
  #
  # params$n_col <- n_col
  # params$h <- h
  #
  # params
}


