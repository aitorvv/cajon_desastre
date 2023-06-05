# test new graphs - boxplot

library(ggdist)
library(tidyquant)
library(tidyverse)

execute it by groups#

mpg %>% # test data
  filter(cyl %in% c(4, 6, 8)) %>%
  ggplot(aes(x = factor(cyl), y = hwy, fill = factor(cyl))) +
  
  # add half-violin from ggdist package
  ggdist::stat_halfeye(
    ## custom bandwidth
    adjust = 0.5,
    ## move geom to the right
    justification = -.2,
    ## remove slab interval
    .width = 0,
    point_colour = NA
  ) +
  geom_boxplot(
    width = .12,
    ## remove outliers
    outlier.color = NA,
    alpha = 0.5
  ) + 
  # add dot plots from ggdist package
  ggdist::stat_dots(
    ## orientation to the left
    side = 'left',
    ## move geom to the left
    justification = 1.1,
    ## adjust grouping (binning) of observations
    binwidth = .25
  ) + 
  # adjust theme
  scale_fill_tq() +
  theme_tq() + 
  labs(
    title = 'Raincloud Plot',
    subtitle = 'Showing the Bi-Modal Distribution of 6 Cylinder Vehicles',
    x = 'Engine Size (N0. of Cylinders)',
    y = 'Highway Fuel Economy (MPG)',
    fill = 'Cylinders'
  ) +
  coord_flip()