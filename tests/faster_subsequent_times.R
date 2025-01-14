main <- function ()
{
    FILE <- tempfile(fileext = ".R")
    on.exit(unlink(FILE), add = TRUE)
    this.path:::write.code(file = FILE, {
        invisible(loadNamespace("microbenchmark"))
        invisible(loadNamespace("this.path"))
        print(this.path:::faster.subsequent.times.test())
    })
    cat("\n")
    this.path:::.Rscript(c("--default-packages=NULL", "--vanilla", FILE))


    cat("\n> source(FILE, chdir = FALSE)\n")
    source(FILE, chdir = FALSE)


    cat("\n> source(FILE, chdir = TRUE)\n")
    source(FILE, chdir = TRUE)
}


main()
