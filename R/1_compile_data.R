library(dplyr)
library(here)
library(lubridate)
library(sensorstrings)
library(tgc)

# import data
dat_raw <- ss_import_data()

gc()

# station locations -------------------------------------------------------

st_locations <- dat_raw %>%
  filter(!is.na(temperature_degree_c)) %>%
  distinct(county, station, sensor_depth_at_low_tide_m, .keep_all = TRUE) %>%
  select(county, station, sensor_depth_at_low_tide_m, latitude, longitude)

saveRDS(st_locations, here("data/cmp_station_locations.RDS"))

# pull out temperature data -----------------------------------------------

dat <- dat_raw %>%
  select(
    county, station, sensor_depth_at_low_tide_m,
    timestamp_utc, temperature_degree_c
  ) %>%
  filter(!is.na(temperature_degree_c)) %>%
  group_by(county, station, sensor_depth_at_low_tide_m) %>%
  mutate(
    depl_start = as_date(min(timestamp_utc)),
    depl_end = as_date(max(timestamp_utc))
  ) %>%
  ungroup()

gc()

# data gaps ---------------------------------------------------------------

# gaps in time series
dat_gap <- dat %>%
  rename(DEPTH = sensor_depth_at_low_tide_m, TIMESTAMP = timestamp_utc) %>%
  check_for_data_gaps(
    gap_length = 72, gap_warning = 48, county, station, depl_start, depl_end
  ) %>%
  rename(
    sensor_depth_at_low_tide_m = DEPTH,
    gap_start = GAP_START, # date data ends; start of gap
    gap_length_days = GAP_LENGTH_DAYS,
    gap_length_hours = GAP_LENGTH_HOURS
  )

# continuous time series --------------------------------------------------

# to fill in the end date after the last gap
dat_end <- dat %>%
  distinct(county, station, sensor_depth_at_low_tide_m, depl_end) %>%
  rename(end_date = depl_end)

# start and end of each continuous time series
dat_out <- dat_gap %>%
  rename(end_date = gap_start) %>%  # date data ends; start of gap
  bind_rows(dat_end) %>%
  group_by(station, sensor_depth_at_low_tide_m) %>%
  mutate(
    row_id = 1:n(),
    start_date = if_else(
      row_id == 1, depl_start, lag(end_date) + lag(days(round(gap_length_days)))
    ),
    end_date = if_else(
      is.na(end_date) & row_id == 1 & gap_length_days == 0, depl_end, end_date
    )
  ) %>%
  ungroup() %>%
  filter(!is.na(start_date)) %>%  # duplication rows for stations without any gaps
  mutate(
    ts_length_weeks = difftime(end_date, start_date, units = "weeks"),
    ts_length_weeks = round(as.numeric(ts_length_weeks), digits = 2)
  ) %>%
  arrange(county, station, sensor_depth_at_low_tide_m, start_date) %>%
  select(
    county, station, sensor_depth_at_low_tide_m,
    start_date, end_date, ts_length_weeks
  )

# export data -------------------------------------------------------------

dat_gap %>%
  select(
    county, station, sensor_depth_at_low_tide_m, gap_start, gap_length_days
  ) %>%
  saveRDS(here("data/cmp_time_series_gaps.RDS"))

saveRDS(dat_out, here("data/cmp_time_series_dates.RDS"))


