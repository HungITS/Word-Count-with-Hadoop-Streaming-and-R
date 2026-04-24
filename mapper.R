#!/usr/bin/env Rscript
con <- file("stdin", open = "r")
while (length(line <- readLines(con, n = 1, warn = FALSE)) > 0) {
  line <- tolower(line)
  words <- unlist(strsplit(line, "\\W+"))
  words <- words[words != ""]
  for (w in words) cat(w, "1", sep = "\t", fill = TRUE)
}
close(con)