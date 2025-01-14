\name{wrap.source}
\alias{wrap.source}
\alias{inside.source}
\title{
Implement \code{this.path()} For Arbitrary \code{source}-Like Functions
}
\description{
A \code{source}-like function is any function which evaluates code from a file.

Currently, \code{\link{this.path}()} is implemented to work with
\sourceandlist{}.

\code{wrap.source()} and \code{inside.source()} can be used to implement
\code{this.path()} for any other \code{source}-like functions.
}
\usage{
wrap.source(expr,
    path.only = FALSE,
    character.only = path.only,
    file.only = path.only,
    conv2utf8 = FALSE,
    allow.blank.string = FALSE,
    allow.clipboard = !file.only,
    allow.stdin = !file.only,
    allow.url = !file.only,
    allow.file.uri = !path.only,
    allow.unz = !path.only,
    allow.pipe = !file.only,
    allow.terminal = !file.only,
    allow.textConnection = !file.only,
    allow.rawConnection = !file.only,
    allow.sockconn = !file.only,
    allow.servsockconn = !file.only,
    allow.customConnection = !file.only,
    ignore.all = FALSE,
    ignore.blank.string = ignore.all,
    ignore.clipboard = ignore.all,
    ignore.stdin = ignore.all,
    ignore.url = ignore.all,
    ignore.file.uri = ignore.all)

inside.source(file,
    path.only = FALSE,
    character.only = path.only,
    file.only = path.only,
    conv2utf8 = FALSE,
    allow.blank.string = FALSE,
    allow.clipboard = !file.only,
    allow.stdin = !file.only,
    allow.url = !file.only,
    allow.file.uri = !path.only,
    allow.unz = !path.only,
    allow.pipe = !file.only,
    allow.terminal = !file.only,
    allow.textConnection = !file.only,
    allow.rawConnection = !file.only,
    allow.sockconn = !file.only,
    allow.servsockconn = !file.only,
    allow.customConnection = !file.only,
    ignore.all = FALSE,
    ignore.blank.string = ignore.all,
    ignore.clipboard = ignore.all,
    ignore.stdin = ignore.all,
    ignore.url = ignore.all,
    ignore.file.uri = ignore.all)
}
\arguments{
  \item{expr}{
an (unevaluated) call to a \code{source}-like function.
  }
  \item{file}{
a \code{\link[base:connections]{connection}} or a character string giving the
pathname of the file or URL to read from.
  }
  \item{path.only}{
must \code{file} be an existing path? This implies \code{character.only} and
\code{file.only} are \code{TRUE} and implies \code{allow.file.uri} and
\code{allow.unz} are \code{FALSE}, though these can be manually changed.
  }
  \item{character.only}{
must \code{file} be a character string?
  }
  \item{file.only}{
must \code{file} refer to an existing file?
  }
  \item{conv2utf8}{
if \code{file} is a character string, should it be converted to UTF-8?
  }
  \item{allow.blank.string}{
may \code{file} be a blank string, i.e. \code{""}?
  }
  \item{allow.clipboard}{
may \code{file} be \code{"clipboard"} or a clipboard connection?
  }
  \item{allow.stdin}{
may \code{file} be \code{"stdin"}? Note that \code{"stdin"} refers to the
C-level \sQuote{standard input} of the process, differing from
\code{\link[base:showConnections]{stdin}()} which refers to the R-level
\sQuote{standard input}.
  }
  \item{allow.url}{
may \code{file} be a URL pathname or a connection of class \code{"url-libcurl"}
/ / \code{"url-wininet"}?
  }
  \item{allow.file.uri}{
may \code{file} be a \samp{file://} URI?
  }
  \item{allow.unz, allow.pipe, allow.terminal, allow.textConnection,
        allow.rawConnection, allow.sockconn, allow.servsockconn}{
may \code{file} be a connection of class \code{\link[base:connections]{"unz"}}
/ / \code{"pipe"} / / \code{"terminal"} / / \code{"textConnection"} / /
\code{"rawConnection"} / / \code{"sockconn"} / / \code{"servsockconn"}?
  }
  \item{allow.customConnection}{
may \code{file} be a custom connection?
  }
  \item{ignore.all, ignore.blank.string, ignore.clipboard, ignore.stdin,
        ignore.url, ignore.file.uri}{
ignore the special meaning of these types of strings, treating it as a path
instead?
  }
}
\details{
\code{inside.source()} should be added to the body of your \code{source}-like
function before reading / / evaluating the expressions.

\code{wrap.source()}, unlike \code{inside.source()}, does not accept an
argument \code{file}. Instead, an attempt is made to extract the file from
\code{expr}, after which \code{expr} is evaluated. It is assumed that the file
is the first argument of the function, as is the case with \sourceandlist{}.
The function of the call is evaluated, its \code{\link[base]{formals}()} are
retrieved, and then the arguments of \code{expr} are searched for a name
matching the name of the first formal argument. If a match cannot be found by
name, the first unnamed argument is taken instead. If no such argument exists,
the file is assumed missing.

\code{wrap.source()} does non-standard evaluation and does some guess work to
determine the file. As such, it is less desirable than \code{inside.source()}
when the option is available. I can think of exactly one scenario in which
\code{wrap.source()} might be preferable: suppose there is a \code{source}-like
function \code{sourcelike()} in a foreign package (a package for which you do
not have write permission). Suppose that you write your own function in which
the formals are \code{(\dots)} to wrap \code{sourcelike()}:

\preformatted{wrapper <- function (...)
{
    # possibly more args to wrap.source()
    wrap.source(sourcelike(...))
}}

This is the only scenario in which \code{wrap.source()} is preferable, since
extracting the file from the \code{\dots} list would be a pain. Then again,
you could simply change the formals of \code{wrapper()} from \code{(\dots)} to
\code{(file, \dots)}. If this does not describe your exact scenario, use
\code{inside.source()} instead.
}
\value{
for \code{wrap.source}, the result of evaluating \code{expr}.

for \code{inside.source}, if \code{file} is a path, then the normalized path
with the same attributes, otherwise \code{file} itself. The return value of
\code{inside.source()} should be assigned to a variable before use, something
like:

\preformatted{
{
    file <- inside.source(file, ...)
    sourcelike(file)
}
}
}
\note{
Both functions should only be called within another function.

Suppose that the functions \sourceandlist{} were not implemented with
\code{this.path()}. You could use \code{inside.source()} to implement each of
them as follows:

\describe{
  \item{\sourcelink{}}{
\preformatted{
wrapper <- function(file, ...) {
    file <- inside.source(file)
    source(file = file, ...)
}
}
  }
  \item{\syssourcelink{}}{
\preformatted{
wrapper <- function(file, ...) {
    file <- inside.source(file, path.only = TRUE)
    sys.source(file = file, ...)
}
}
  }
  \item{\debugSource{}}{
\preformatted{
wrapper <- function(fileName, ...) {
    fileName <- inside.source(fileName, character.only = TRUE,
        conv2utf8 = TRUE, allow.blank.string = TRUE)
    debugSource(fileName = fileName, ...)
}
}
  }
  \item{\sourcefilelink{}}{
\preformatted{
wrapper <- function(path, ...) {
    # before testthat_3.1.2, source_file() used base::readLines() to
    # read the input lines. changed in 3.1.2, source_file() uses
    # brio::read_lines() which normalizes 'path' before reading,
    # disregarding the special meaning of the strings listed above
    path <- inside.source(path, path.only = TRUE,
        ignore.all = as.numeric_version(getNamespaceVersion("testthat")) >= "3.1.2")
    testthat::source_file(path = path, ...)
}
}
  }
  \item{\knitlink{}}{
\preformatted{
wrapper <- function(input, ...) {
    # this works for the most part, but won't work in child mode
    input <- inside.source(input)
    knitr::knit(input = input, ...)
}
}
  }
}
}
\examples{
FILE <- tempfile(fileext = ".R")
this.path:::write.code({
    this.path::this.path(verbose = TRUE)
}, FILE)


# here we have a source-like function, suppose this
# function is in a package for which you have write permission
sourcelike <- function (file, envir = parent.frame())
{
    file <- inside.source(file)
    envir <- as.environment(envir)
    exprs <- parse(n = -1, file = file, srcfile = NULL, keep.source = FALSE)
    # this prints nicely
    source(local = envir, echo = TRUE, exprs = exprs,
        spaced = TRUE, verbose = FALSE, max.deparse.length = Inf)
    # you could alternatively do:
    # 'for (i in seq_along(exprs)) eval(exprs[i], envir)'
    # which does no pretty printing
}


sourcelike(FILE)
sourcelike(con <- file(FILE)); close(con)


# here we have another source-like function, suppose this function
# is in a foreign package for which you do not have write permission
sourcelike2 <- function (pathname, envir = globalenv())
{
    if (!(is.character(pathname) && file.exists(pathname)))
        stop(gettextf("'\%s' is not an existing file",
             pathname, domain = "R-base"))
    envir <- as.environment(envir)
    exprs <- parse(n = -1, file = pathname, srcfile = NULL, keep.source = FALSE)
    source(local = envir, echo = TRUE, exprs = exprs,
        spaced = TRUE, verbose = FALSE, max.deparse.length = Inf)
}


# the above function is similar to sys.source(), and it
# expects a character string referring to an existing file
#
# with the following, you should be able to use 'this.path()' within 'FILE':
wrap.source(sourcelike2(FILE), path.only = TRUE)


# with R >= 4.1.0, use the forward pipe operator '|>' to
# make calls to 'wrap.source' more intuitive:
# sourcelike2(FILE) |> wrap.source(path.only = TRUE)


# 'wrap.source' can recognize arguments by name, so they
# do not need to appear in the same order as the formals
wrap.source(sourcelike2(envir = new.env(), pathname = FILE), path.only = TRUE)


# it it much easier to define a new function to do this
sourcelike3 <- function (...)
wrap.source(sourcelike2(...), path.only = TRUE)


# the same as before
sourcelike3(FILE)


# however, this is preferable:
sourcelike4 <- function (pathname, ...)
{
    # pathname is now normalized
    pathname <- inside.source(pathname, path.only = TRUE)
    sourcelike2(pathname = pathname, ...)
}
sourcelike4(FILE)
\dontshow{unlink(FILE)}}
