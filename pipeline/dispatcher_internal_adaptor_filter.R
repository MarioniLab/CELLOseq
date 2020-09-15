template.file <- "internal_adaptor_filter.Rmd"
template.content <- readLines(template.file)

sample.list <- list.files(pattern="\\.fastq$")
for (sample in sample.list) {
  script <- gsub("INDEX", deparse(sample), template.content)
  sample.prefix <- gsub("\\..*", "", gsub(".*_", "", sample))
  writeLines(text = script, con = paste0("internal_adaptor_filter_", sample.prefix, ".Rmd"))
}