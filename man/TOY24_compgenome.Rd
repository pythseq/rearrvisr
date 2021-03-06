% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/TOY24_data.R
\docType{data}
\name{TOY24_compgenome}
\alias{TOY24_compgenome}
\title{\code{compgenome} example for 24 markers, created for illustrative purposes}
\format{A data frame with markers in rows and nine columns that specify the
  structure of a compared genome representation:
\tabular{ll}{
  \code{$marker} \tab unique ortholog ID of marker \cr
  \code{$orientation} \tab reading direction of marker \cr
  \code{$car} \tab CAR where marker is located \cr
  \code{$type1} \tab node type at highest level of \emph{PQ-tree} \cr
  \code{$elem1} \tab node element at highest level of \emph{PQ-tree} \cr
  \code{$type2} \tab node type at second level of \emph{PQ-tree} \cr
  \code{$elem2} \tab node element at second level of \emph{PQ-tree} \cr
  \code{$type3} \tab node type at third level of \emph{PQ-tree} \cr
  \code{$elem3} \tab node element at third level of \emph{PQ-tree} \cr
}}
\usage{
TOY24_compgenome
}
\description{
A data set illustrating a compared (ancestral or extant) genome
representation with 24 markers on four \emph{Contiguous Ancestral Regions}
(CARs), where each CAR is represented by a \emph{PQ-tree}.
}
\examples{
\dontrun{

## recreate the data set
TOY24_rawtree <- matrix(
  c(">TOY",
    "#CAR1",
    "_Q 1 2 3 4 5 -6 7 8 Q_",
    "#CAR2",
    "_Q 9 _Q 10 Q_ _Q 11 12 13 Q_ Q_",
    "#CAR3",
    "_Q 14 Q_",
    "#CAR4",
    "_Q _P 15 16 17 18 P_ _Q _Q -19 20 21 Q_ _Q -22 -23 24 Q_ Q_ Q_"),
  nrow = 9)
TOY24_compgenome <- convertPQtree(TOY24_rawtree)
}
}
\seealso{
\code{\link{computeRearrs}}, \code{\link{TOY24_focalgenome}}
}
\keyword{datasets}
