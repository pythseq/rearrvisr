## ------------------------------------------------------------------------
## transform genome map (in 'focalgenome' format) into a PQ-tree format
## with columns $marker, $orientation, $car, $type1 (always Q), and $elem1
## ------------------------------------------------------------------------

#' Convert a one-dimensional genome map into a two-dimensional
#' \emph{PQ-structure}
#'
#' Convert a one-dimensional genome map into a two-dimensional
#' \emph{PQ-structure} that can be used as \code{compgenome} input for the
#' functions \code{\link{computeRearrs}}, \code{\link{summarizeBlocks}}, and
#' \code{\link{genomeRearrPlot}}
#'
#' @param genomemap Data frame representing the genome map to be converted,
#'   containing the mandatory columns \code{$marker}, \code{$scaff},
#'   \code{$start}, \code{$end}, and \code{$strand}, and optional further
#'   columns. Markers need to be ordered by their map position.
#'
#' @details
#'
#'   \code{genomemap} must contain the mandatory columns \code{$marker} (a
#'   character or integer vector that gives the IDs of markers), \code{$scaff}
#'   (a character vector that gives the ID of the genome segment of origin of
#'   each marker), \code{$start} and \code{$end} (numeric vectors that specify
#'   the location of each marker on its genome segment), and \code{$strand} (a
#'   vector of \code{"+"} and \code{"-"} characters that indicate the reading
#'   direction of each marker). Additional columns are ignored and may store
#'   custom information. Markers need to be ordered by their map position within
#'   each genome segment, for example by running the
#'   \code{\link{orderGenomeMap}} function.
#'
#'   \strong{Important:} If the converted genome map is used as
#'   \code{compgenome} input for the function \code{\link{computeRearrs}}, it is
#'   crucial that all genome segments in the \code{$scaff} column of
#'   \code{genomemap} represent contiguous sets of genetic markers. Genome
#'   segments that are (potentially) overlapping, such as minor scaffolds or
#'   contigs that were not assembled into chromosomes and might in fact be part
#'   of assembled chromosomes or enclosed in other scaffolds, need to be
#'   excluded from \code{genomemap} prior to its conversion.
#'
#' @return A data frame encoding the marker order in \code{genomemap} as a
#'   two-dimensional \emph{PQ-structure} (i.e., in \emph{PQ-tree} format).
#'
#'   IDs in the \code{$car} column of the output are assigned according to the
#'   order of genome segments as they appear in the \code{$scaff} column of
#'   \code{genomemap}. Markers that are \code{NA} in the genome map are excluded
#'   from the output.
#'
#'   For additional details on the output format see the description of the
#'   \code{"compgenome"} class in the Details section of the
#'   \code{\link{checkInfile}} function, or the package vignette.
#'
#'   The unambiguously ordered genome segments in the one-dimensional genome map
#'   \code{genomemap} can be seen as a subclass of \emph{PQ-trees}, where each
#'   genome segment is encoded by a single \emph{Q-node} that only contains
#'   leaves as children. Accordingly, the returned \emph{PQ-structure} has
#'   exactly five columns: \code{$marker}, \code{$orientation}, \code{$car}, one
#'   column for node type (always \code{"Q"}), and one for node element (ranging
#'   from \code{1} to the number of non-\code{NA} markers within a genome
#'   segment).
#'
#' @seealso \code{\link{orderGenomeMap}}, \code{\link{checkInfile}},
#'   \code{\link{computeRearrs}}, \code{\link{summarizeBlocks}},
#'   \code{\link{genomeRearrPlot}}.
#'
#' @examples
#' \dontrun{
#'
#' ## Exclude potentially overlapping minor scaffolds from genome map:
#' SIM_markers_chr <- SIM_markers[is.element(SIM_markers$scaff,
#'                                           c("2L", "2R", "3L", "3R", "4", "X")), ]
#'
#' ## Convert genome map into PQ-structure:
#' SIM_compgenome <- genome2PQtree(SIM_markers_chr)
#'
#' ## Print a translation between names of genome segments and CAR IDs:
#' head(data.frame(chr = unique(SIM_markers_chr$scaff),
#'                 car = 1:length(unique(SIM_markers_chr$scaff)),
#'                 stringsAsFactors = FALSE))
#' }
#'
#' @export

genome2PQtree<-function(genomemap){

    ## checks
    ## -------------------------------------------

    ## ERRORS
    ## check focalgenome
    checkInfile(genomemap, myclass="focalgenome", checkorder = TRUE)


    ## processing
    ## -------------------------------------------

    subgenome<-genomemap[!is.na(genomemap$marker),]
    genometree<-data.frame(marker=subgenome$marker,
                           orientation=subgenome$strand,
                           car=rep(NA,nrow(subgenome)),
                           type1=rep("Q",nrow(subgenome)),
                           elem1=rep(NA,nrow(subgenome)),
                           stringsAsFactors=FALSE)


    allchr<-unique(subgenome$scaff)
    meanpos<-subgenome$start + (subgenome$end - subgenome$start)/2
    for(i in 1:length(allchr)){
        pos<-which(subgenome$scaff == allchr[i])
        genometree$car[pos]<-rep(i,length(pos))
        genometree$elem1[pos]<-order(meanpos[pos])
    }


    return(genometree)
}

## ------------------------------------------------------------------------
