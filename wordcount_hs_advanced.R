#!/usr/bin/env Rscript
library(HadoopStreaming)

spec <- c('printDone', 'D', 0, 'logical', 'Print DONE', FALSE)
opts <- hsCmdLineArgs(spec, openConnections = TRUE)

if (opts$mapper) {
  hsLineReader(opts$incon, chunkSize = 1, FUN = function(line) {
    words <- unlist(strsplit(tolower(line), "\\W+"))
    words <- words[words != ""]
    for (w in words) cat(w, "1", sep = "\t", fill = TRUE)
  })
} else if (opts$reducer) {
    con <- opts$incon
    current_key <- NULL
    total <- 0
    hsKeyValReader(con, chunkSize = 1, FUN = function(k, v) {
        if (is.null(current_key)) {
        current_key <<- k
        total <<- as.numeric(v)
        } else if (current_key == k) {
        total <<- total + as.numeric(v)
        } else {
        cat(current_key, total, sep = "\t", fill = TRUE)
        current_key <<- k
        total <<- as.numeric(v)
        }
    })
    if (!is.null(current_key)) cat(current_key, total, sep = "\t", fill = TRUE)
}

if (!is.na(opts$infile)) close(opts$incon)
if (!is.na(opts$outfile)) close(opts$outcon)