\name{as.relative.path}
\alias{as.relative.path}
\alias{as.rel.path}
\alias{relpath}
\title{
Make a Path Relative to Another Path
}
\description{
When working with \pkg{this.path}, you will be dealing with a lot of absolute
paths. These paths are no good for saving within files, so you'll need to use
\code{as.relative.path()} to turn your absolute paths into relative paths.
}
\usage{
as.relative.path(path, relative.to = this.dir(verbose = FALSE))
as.rel.path     (path, relative.to = this.dir(verbose = FALSE))
relpath         (path, relative.to = getwd())
}
\arguments{
  \item{path}{
character vector of file / / URL paths.
  }
  \item{relative.to}{
character string; the file / / URL path to make \code{path} relative to.
  }
}
\details{
Tilde-expansion (see \code{\link[base]{path.expand}}) is first done on
\code{path} and \code{relative.to}.

If \code{path} and \code{relative.to} are equivalent, \code{"."} will be
returned. If \code{path} and \code{relative.to} have no base in common, the
\code{\link[base:normalizePath]{normalized}} \code{path} will be returned.
}
\value{
character vector of the same length as \code{path}.
}
\note{
\code{relpath} and \code{as.rel.path} are the same function with different
default arguments.
}
\examples{
#ifdef unix
\dontrun{
relpath(
    c(
        # paths which are equivalent will return "."
        "/home/effective_user/Documents/this.path/man",


        # paths which have no base in common return as themselves
        "https://raw.githubusercontent.com/ArcadeAntics/this.path/main/tests/this.path_w_URLs.R",
        "//host-name/share-name/path/to/file",


        "/home/effective_user/Documents/testing",
        "/home/effective_user",
        "/home/effective_user/Documents/R/this.path.R"
    ),
    relative.to = "/home/effective_user/Documents/this.path/man"
)
}
#endif
#ifdef windows
\dontrun{
relpath(
    c(
        # paths which are equivalent will return "."
        "C:/Users/effective_user/Documents/this.path/man",


        # paths which have no base in common return as themselves
        "https://raw.githubusercontent.com/ArcadeAntics/this.path/main/tests/this.path_w_URLs.R",
        "D:/",
        "//host-name/share-name/path/to/file",


        "C:/Users/effective_user/Documents/testing",
        "C:\\\\Users\\\\effective_user",
        "C:/Users/effective_user/Documents/R/this.path.R"
    ),
    relative.to = "C:/Users/effective_user/Documents/this.path/man"
)
}
#endif
}
