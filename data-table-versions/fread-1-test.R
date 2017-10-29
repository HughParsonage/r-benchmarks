library(devtools)
library(microbenchmark)
library(magrittr)

# all_avbl_versions <- 
#   readLines("https://cran.r-project.org/src/contrib/Archive/data.table/") %>% 
#   grep("^.*data.table_(.*?).tar.gz.*$", x = ., perl = TRUE, value = TRUE) %>%
#   gsub("^.*data.table_(.*?).tar.gz.*$", "\\1", ., perl = TRUE)

# for (ver in c("1.10.4", "1.10.4-2", "1.10.4-1", "1.10.2", "1.10.0", "1.9.8", 
#               "1.9.6", "1.9.4", "1.9.2", "1.8.10", "1.8.8", "1.8.6", "1.8.4", 
#               "1.8.2", "1.8.0", "1.7.10", "1.7.9", "1.7.8", "1.7.7", "1.7.6", 
#               "1.7.5", "1.7.4", "1.7.3", "1.7.2", "1.7.1", "1.6", "1.6.6", 
#               "1.6.5", "1.6.4", "1.6.3", "1.6.2", "1.6.1", "1.5", "1.5.3", 
#               "1.5.2", "1.5.1", "1.4.1", "1.2", "1.1", "1.0")) {
ver <- "1.10.4"
  if (requireNamespace("data.table", quietly = TRUE)) {
    remove.packages("data.table")
  }
  devtools::install_version("data.table", version = ver, 
                            repos = "https://cran.r-project.org",
                            type = "source")
  library(data.table)
  if ("fread" %in% ls("package:data.table")) {
    result <- microbenchmark(fread("fread-example.csv"), times = 3)
    result <- as.data.frame(result)
    result$Version <- ver
    result$Date <- 
      as.data.frame(devtools::session_info(pkgs = "data.table")$packages) %>%
      .[.$package == "data.table", "date"]
    
    write.table(result, 
                "./data-table-versions/fread-timings-by-version.txt",
                append = TRUE,
                col.names = FALSE)
  }
  
  detach("package:data.table", unload = TRUE)
  remove.packages("data.table")
  ver

