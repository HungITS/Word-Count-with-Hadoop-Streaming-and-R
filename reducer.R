#!/usr/bin/env Rscript
con <- file("stdin", open = "r")
current_word <- NULL
current_count <- 0
while (length(line <- readLines(con, n = 1, warn = FALSE)) > 0) {
  parts <- unlist(strsplit(line, "\t"))
  if (length(parts) < 2) next
  word <- parts[1]
  count <- as.integer(parts[2])
  if (is.null(current_word)) {
    current_word <- word
    current_count <- count
  } else if (current_word == word) {
    current_count <- current_count + count
  } else {
    cat(current_word, current_count, sep = "\t", fill = TRUE)
    current_word <- word
    current_count <- count
  }
}
if (!is.null(current_word)) cat(current_word, current_count, sep = "\t", fill = TRUE)
close(con)