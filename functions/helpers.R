

# dynamic height depending on how many counties selected
get_county_fig_height <- function(county) {

  n_county <- length(county)

  if(n_county == 0) {
    warning("no data to plot")
  }

  h_base <- 300
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
}


