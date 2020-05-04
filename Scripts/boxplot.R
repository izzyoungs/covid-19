# library(tidyverse)
# library(dplyr)
# library(magrittr)
# library(here)
# library(forcats)

variables <- read_csv("Analysis results/variable_validation_2.csv")

var_plot <- variables %>%
  mutate(Variable = fct_reorder(Variable, Validation, .fun = median)) %>%
  ggplot(mapping = aes(x = Variable, y = Validation, size = 1)) + 
  geom_boxplot(outlier.shape=20, outlier.size=.5) +
  theme(axis.title.x = element_text(face="bold", color="#000000", size=14) +
  coord_flip()

plot(var_plot)

ggsave(var_plot, width = 7 , height = 7 * 2.5, filename = "Photos/test.png")
