cat("Executing script's path:\n")
cat(sQuote(this.path::this.path(verbose = TRUE)), "\n\n", sep = "")


cat("Executing script's directory:\n")
cat(sQuote(this.path::this.dir(verbose = TRUE)), "\n\n", sep = "")


cat("Testing 'here':\n")
withAutoprint({
    this.path::here("test.R")
    this.path::here(.. = 1, "R", "this.path.R")
}, verbose = FALSE)


cat("\n\n\n\n")
