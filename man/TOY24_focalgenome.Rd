% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/TOY24_data.R
\docType{data}
\name{TOY24_focalgenome}
\alias{TOY24_focalgenome}
\title{\code{focalgenome} example for 24 markers, created for illustrative purposes}
\format{A data frame with markers in rows and five columns that specify the
  structure of a focal genome map:
\tabular{ll}{
  \code{$marker} \tab unique ortholog ID of marker \cr
  \code{$scaff} \tab genome segment where marker is located \cr
  \code{$start} \tab start position of marker on genome segment \cr
  \code{$end} \tab end position of marker on genome segment \cr
  \code{$strand} \tab reading direction of marker \cr
}}
\usage{
TOY24_focalgenome
}
\description{
A data set illustrating a focal (extant) genome map with 24 markers on three
genome segments (e.g., scaffolds).
}
\examples{
\dontrun{

## recreate the data set
TOY24_focalgenome <- data.frame(
  marker = as.integer(c(1,7,2,6:4,8:10,3,13:11,14,17:15,18,21,20,22:24,19)),
  scaff = as.character(rep(c(1,2,3), times = c(7,11,6))),
  start = as.integer(c(seq(10^6, by = 10^6, length.out = 7),
                       seq(10^6, by = 10^6, length.out = 11),
                       seq(10^6, by = 10^6, length.out = 6))),
  end = as.integer(c(seq(10^6+2, by = 10^6, length.out = 7),
                     seq(10^6+2, by = 10^6, length.out = 11),
                     seq(10^6+2, by = 10^6, length.out = 6))),
  strand = rep(rep(c("+", "-"), 4),
               times = c(4,2,4,3,8,1,1,1)),
  stringsAsFactors = FALSE)
}
}
\seealso{
\code{\link{computeRearrs}}, \code{\link{TOY24_compgenome}}
}
\keyword{datasets}
