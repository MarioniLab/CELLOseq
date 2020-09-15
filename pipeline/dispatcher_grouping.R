template.file <- "grouping.Rmd"
template.content <- readLines(template.file)

sample.list <- list.files(pattern="\\.rds$")
for (sample in sample.list) {
  script <- gsub("INDEX", deparse(gsub(".rds", "", sample)), template.content)
  sample.prefix <- gsub("\\..*", "", gsub(".*_", "", sample))
  writeLines(text = script, con = paste0("grouping_", sample.prefix, ".Rmd"))
}