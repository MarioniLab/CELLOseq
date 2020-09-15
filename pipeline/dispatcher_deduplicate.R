library(stringr)

template.file <- "deduplicate.Rmd"
template.content <- readLines(template.file)

sample.list <- list.files(pattern=".*\\.groups\\.[0-9]+\\.rds$")
for (sample in sample.list) {
  components <- unlist(str_split(sample, "[.]"))
  if (length(components) > 4) {
    prefix <- paste(components[1:(length(components)-3)], collapse=".")
  } else {
    prefix <- components[1]
  }
  
  script <- gsub("CHUNK", deparse(components[length(components)-1]), gsub("INDEX", deparse(prefix), template.content))
  sample.prefix <- gsub("\\..*", "", gsub(".*_", "", sample))
  writeLines(text <- script, con <- paste0("deduplicate_", sample.prefix, "_chunk_", components[length(components)-1], ".Rmd"))
}