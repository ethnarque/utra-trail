# install.packages(c("dplyr", "ggplot2", "lubridate"))
library(dplyr)
library(ggplot2)
library(lubridate)

ultra_rankings <- read.csv("ultra_rankings.csv")
race <- read.csv("race.csv")


combined_data <- inner_join(ultra_rankings, race, by = "race_year_id")

combined_data$year <- year(as.Date(combined_data$date, format="%Y-%m-%d"))

avg_speed_by_gender <- combined_data %>%
  group_by(year, gender) %>%
  filter(gender == "M" | gender == "W") %>%
  summarise(
    avg_speed = mean(distance / (time_in_seconds / 3600), na.rm = TRUE),
    .groups = "drop"
  ) %>%
  ungroup()

ggplot(avg_speed_by_gender, aes(x=year, y=avg_speed, color=gender)) +
  geom_line() +
  labs(
    title="Vitesse moyenne par genre et année",
    x="Année",
    y="Vitesse moyenne (km/h)",
    color="Genre"
  )

