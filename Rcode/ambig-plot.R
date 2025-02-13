library(here)
library(glue)
library(tidyverse)
library(colorspace)
library(drlib)
library(dbplyr)
library(RPostgreSQL)
library(CSCI)
library(patchwork)



# function in 2.1 ---------------------------------------------------------

data_ready <- c()
for(i in seq_along(site_list)){
  data_ready[[i]] <- summarising_ambig_tidied_data(site_list[i])
}

sum_dat <- bind_rows(data_ready)
#save(sum_dat, file = 'stations/sum-ambig.RData')

dat <- sum_dat %>% 
  group_by(StationCode) %>% 
  select(
    Site = StationCode, 
    av = CSCI_mean, 
    sd = CSCI_sd, 
    Pcnt_Replaced, 
    Count_mean,
    Pcnt_Ambiguous_Taxa_mean
  ) %>% 
  mutate(
    cv = sd/av,
    ambi = Pcnt_Ambiguous_Taxa_mean/100
  ) %>% 
  ungroup()

dat %>% 
  ggplot(aes(group = Site, x = ambi, y = cv, color = Site)) +
  geom_point() +
  geom_smooth(method = 'auto', se = F) +
  scale_x_continuous(labels=scales::percent) +
  labs(x = 'ambiguous', 
       y = 'cv',
       fill = "Station Code") +
  theme_bw()
