library(data.table)
library(magrittr)
library(ggplot2)


fread("data-table-versions/fread-timings-by-version.txt") %>%
  .[, .(Date = as.Date(V5),
        `Execution time` = V3,
        major_version = sub("^1\\.([0-9]+)\\..*$", "\\1", V4))] %>%
  .[order(Date)] %>%
  .[, `Major version` := factor(major_version, levels = unique(.$major_version), ordered = TRUE)] %>%
  ggplot(aes(x = Date, y = `Execution time`)) +
  geom_smooth(method = "loess", span = 0.6, group = 1) +
  scale_color_discrete() +
  geom_point(aes(color = `Major version`)) +
  scale_y_log10(breaks = c(1e9, 1e8, 5e8), labels = c("1s", "0.1s", "0.5s")) +
  geom_blank(aes(x = as.Date(lubridate::now()), y = 5e7))
  