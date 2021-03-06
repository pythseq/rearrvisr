## ------------------------------------------------------------------------
## check that input is correct
## ------------------------------------------------------------------------

#' Check input files
#'
#' Check input data to ensure that file format is correct
#'
#' @param myobject Data object to be tested.
#' @param myclass Name of data class. Can be one of the strings
#'   \code{"focalgenome"}, \code{"compgenome"}, \code{"SYNT"}, or
#'   \code{"BLOCKS"}.
#' @param checkorder Logical. If \code{TRUE}, the order of markers in class
#'   \code{"focalgenome"} or \code{"compgenome"} is checked; if \code{FALSE},
#'   only the file format is verified. Ignored for classes \code{"SYNT"} and
#'   \code{"BLOCKS"}.
#'
#' @details
#'
#'   Objects of the class \code{"focalgenome"} must contain the column
#'   \code{$marker}, a vector of either characters or integers giving unique IDs
#'   for orthologs. Values can be \code{NA} for markers that have no ortholog.
#'   \code{$scaff} must be a character vector giving the name of the focal
#'   genome segment (i.e., chromosome or scaffold) of origin of each marker.
#'   \code{$start} and \code{$end} must be numeric vectors giving the location
#'   of each marker on its focal genome segment. \code{$strand} must be a vector
#'   of \code{"+"} and \code{"-"} characters giving the reading direction of
#'   each marker. Additional columns are ignored and may store custom
#'   information, such as marker names. See Examples below for the
#'   \code{focalgenome} format.
#'
#'   Objects of the class \code{"compgenome"} must contain the column
#'   \code{$marker}, a vector of either characters or integers giving unique
#'   IDs for orthologs. \code{$orientation} must be a vector of \code{"+"} and
#'   \code{"-"} characters giving the reading direction of each marker in the
#'   compared genome. \code{$car} must be an integer vector giving the location
#'   of each marker on its compared genome segment (i.e., \emph{Contiguous
#'   Ancestral Region}, or CAR), analogous to contiguous sets of genetic markers
#'   on a chromosome, scaffold, or contig. Each CAR is represented by a
#'   \emph{PQ-tree} (Booth & Lueker 1976; Chauve & Tannier 2008). The \emph{PQ}
#'   structure of each CAR is defined by additional columns (at least two) that
#'   have to alternate between character vectors of node type (\code{"P"},
#'   \code{"Q"}, or \code{NA}) in even columns, and integer vectors of node
#'   elements in odd columns (missing values are permitted past the fifth
#'   column). Every set of node type and node element column reflects the
#'   hierarchical structure of each \emph{PQ-tree}, with the rightmost columns
#'   representing the lowest level of the hierarchy. \emph{P-nodes} contain
#'   contiguous markers and/or nodes in arbitrary order, while \emph{Q-nodes}
#'   contain contiguous markers and/or nodes in fixed order (including their
#'   reversal). For additional details on \emph{PQ-trees} see Booth & Lueker
#'   1976, Chauve & Tannier 2008, or the package vignette. See Examples below
#'   for the \code{compgenome} format.
#'
#'   Objects of the class \code{"SYNT"} must be a list of matrices generated by
#'   the \code{\link{computeRearrs}} function. The list stores data on different
#'   classes of rearrangements and additional information.
#'
#'   Objects of the class \code{"BLOCKS"} must be a list of lists generated by
#'   the \code{\link{summarizeBlocks}} function. The top-level list elements of
#'   the \code{"BLOCKS"} object are focal genome segments, and the lower-level
#'   list elements contain information on synteny blocks and rearrangements for
#'   each focal genome segment.
#'
#' @section References:
#'
#'   Booth, K.S. & Lueker, G.S. (1976). Testing for the consecutive ones
#'   property, interval graphs, and graph planarity using \emph{PQ}-Tree
#'   algorithms. \emph{Journal of Computer and System Sciences}, \strong{13},
#'   335--379. doi:
#'   \href{https://doi.org/10.1016/S0022-0000(76)80045-1}{10.1016/S0022-0000(76)80045-1}.
#'
#'   Chauve, C. & Tannier, E. (2008). A methodological framework for the
#'   reconstruction of contiguous regions of ancestral genomes and its
#'   application to mammalian genomes. \emph{PLOS Computational Biology},
#'   \strong{4}, e1000234. doi:
#'   \href{https://doi.org/10.1371/journal.pcbi.1000234}{10.1371/journal.pcbi.1000234}.
#'
#' @return Returns an error message when a problem has been detected, or nothing
#'   otherwise.
#'
#' @seealso \code{\link{computeRearrs}}, \code{\link{summarizeBlocks}}.
#'
#' @examples
#' checkInfile(TOY24_focalgenome, "focalgenome", checkorder = TRUE)
#'
#' ## focalgenome format:
#' TOY24_focalgenome
#'
#' ## compgenome format:
#' TOY24_compgenome
#'
#' \dontrun{
#'
#' ## markers not ordered:
#' myorder <- sample(1:nrow(TOY24_focalgenome))
#' checkInfile(TOY24_focalgenome[myorder, ], "focalgenome", checkorder = TRUE)
#' }
#'
#' @export


checkInfile<-function(myobject, myclass, checkorder = NULL){

    if(myclass == "focalgenome" | myclass == "orgmarkers"){
        ## ------------
        ## check genome
        ## ------------
        if(!is.data.frame(myobject)){
            stop(paste(myclass,"needs to be a data frame"))
        }
        if(any(!is.element(c("marker","scaff","start","end","strand"),
                           colnames(myobject)))){
            stop(paste("column names in",myclass,"need to include\n    'marker', 'scaff', 'start', 'end', 'strand'"))
        }
        if(class(myobject$scaff) != "character"){
            stop(paste("class for '$scaff' in",myclass,"needs to be 'character'"))
        }
        if(!is.numeric(myobject$start) | !is.numeric(myobject$end)){
            stop(paste("'$start' and '$end' postions in",myclass,"need to be 'numeric'"))
        }
        if(sum(is.na(myobject$start)) + sum(is.na(myobject$end)) > 0){
            stop(paste("no missing values allowed for '$start' and\n    '$end' postions in",myclass))
        }
        if(sum(myobject$start <= 0) > 0){
            stop(paste("'$start' postions in",myclass,"need to be > 0"))
        }
        if(sum(myobject$start > myobject$end) > 0){
            stop(paste("'$start' postions in",myclass,"need to be <= '$end' positions"))
        }
        if(anyDuplicated(as.vector(myobject$marker[!is.na(myobject$marker)])) > 0){
            stop(paste("some marker IDs are duplicated in",myclass))
        }
        if(anyDuplicated(cbind(myobject$scaff,myobject$start,myobject$end)) > 0){
            stop(paste("some marker positions are duplicated in",myclass))
        }
        ## check strand information and marker class
        if(myclass == "focalgenome"){
            if(class(myobject$strand) != "character"){
                stop(paste("class for '$strand' in",myclass,"needs to be 'character'"))
            }
            if(sum(!is.element(myobject$strand,c("+","-"))) > 0){
                stop(paste("'$strand' for",myclass,"needs to be '+' or '-'"))
            }
            if(!is.element(class(myobject$marker),c("integer","character"))){
                stop(paste("class for '$marker' in",myclass,"need to be\n    either 'character' or 'integer'"))
            }
        }else if(myclass == "orgmarkers"){
            if(class(myobject$strand) != "character" &
               class(myobject$strand) != "integer"){
                stop(paste("class for '$strand' in",myclass,"needs to be 'character' or 'integer'"))
            }
            if((sum(!is.element(myobject$strand,c("+","-")))) > 0 &
               (sum(!is.element(myobject$strand,c(-1,1)))) > 0){
                stop(paste("'$strand' for",myclass,"need to be '+' or '-', or -1 or 1"))
            }
        }
        ## check that markers are ordered
        if(is.null(checkorder)){
            stop("checkorder needs to be TRUE or FALSE")
        }else if(checkorder == TRUE){
            needToOrder<-0
            tmpmean<-myobject$start+(myobject$end-myobject$start)/2
            for(s in unique(myobject$scaff)){
                myset<-which(myobject$scaff == s)
                if(length(myset)>1){
                    if(sum(diff(myset) != 1)){
                        needToOrder<-1
                    }
                    if(sum(diff(tmpmean[myset]) <= 0) > 0){
                        needToOrder<-1
                    }
                }
                if(needToOrder == 1){
                    stop(paste("markers in",myclass,"are not ordered:\n   consider running 'orderGenomeMap' to order them"))
                }
            }
        }

    }else if(myclass == "compgenome"){
        ## ----------------
        ## check compgenome
        ## ----------------
        if(!is.data.frame(myobject)){
            stop(paste(myclass,"needs to be a data frame"))
        }
        if(sum(c("marker","orientation","car") !=
                   colnames(myobject)[1:3]) > 0){
            stop(paste("first three column names in",myclass,"need to be\n    c('marker','orientation','car')"))
        }
        if(ncol(myobject) < 5){
            stop(paste("require at least one column for node type and one for\n    node element in",myclass))
        }
        for(i in seq(4,ncol(myobject),2)){
            if(class(myobject[,i]) != "character"){
                stop(paste("class of node types in",myclass,"needs to be 'character'"))
            }
            if(sum(!is.element(unique(myobject[,i]),c(NA,"P","Q"))) > 0){
                stop(paste("node types in",myclass,"need to be 'P', 'Q', or NA"))
            }
        }
        for(i in seq(5,ncol(myobject),2)){
            if(class(myobject[,i]) != "integer"){
                stop(paste("class of node elements in",myclass,"needs to be 'integer'"))
            }
            if(sum(myobject[!is.na(myobject[,i]),i] <=0 ) > 0){
                stop(paste("node elements in",myclass,"need to be > 0"))
            }
        }
        if(sum(is.na(myobject[,4]) * is.na(myobject[,5])) > 0){
            stop(paste("'NA's not permitted in first node type and node element\n    columns in",myclass))
        }
        for(i in seq(4,ncol(myobject),2)){
            if(sum(is.na(myobject[,i]) == is.na(myobject[,i+1])) != nrow(myobject)){
                stop(paste("'NA's in node types must match 'NA's in node elements in",myclass))
            }
        }
        if(class(myobject$car) != "integer"){
            stop(paste("class of '$car' in",myclass,"needs to be 'integer'"))
        }
        if(sum(myobject$car <= 0) > 0){
            stop(paste("car elements in",myclass,"need to be > 0"))
        }
        if(class(myobject$orientation) != "character"){
            stop(paste("class for '$orientation' in",myclass,"needs to be 'character'"))
        }
        if(sum(!is.element(myobject$orientation,c("+","-"))) > 0){
            stop(paste("'$orientation' for",myclass,"needs to be '+' or '-'"))
        }
        if(!is.element(class(myobject$marker),c("integer","character"))){
            stop(paste("class for '$marker' in",myclass,"needs to be\n    either 'character' or 'integer'"))
        }
        if(anyDuplicated(as.vector(myobject$marker)) > 0){
            stop(paste("some marker IDs are duplicated in",myclass))
        }
        if(anyDuplicated(cbind(myobject$car,myobject[,3:ncol(myobject)])) > 0){
            stop(paste("some tree elements are duplicated in",myclass))
        }
        ## check that markers are ordered
        if(is.null(checkorder)){
            stop("checkorder needs to be TRUE or FALSE")
        }else if(checkorder == TRUE){
            needToOrder<-0
            for(s in unique(myobject$car)){
                myset<-which(myobject$car == s)
                if(length(myset)>1){
                    if(sum(diff(myset) != 1)){
                        needToOrder<-1
                    }
                    for(i in seq(5,ncol(myobject),2)){
                        ## make unique tags for preceding hierarchy
                        hiercol<-seq(3,i-2,2)
                        allprev<-apply(as.matrix(myobject[myset,hiercol]),1,
                                       function(x) paste0(x,collapse="-"))
                        uniprev<-unique(allprev[!is.na(myobject[myset,i])])
                        if(length(uniprev)==0){ ## only NAs left
                            next
                        }
                        for(p in 1:length(uniprev)){
                            tmprows<-which(allprev==uniprev[p])
                            if(length(tmprows)>1){
                                if(sum(diff(tmprows) != 1)){
                                    needToOrder<-1
                                }
                                elem<-myobject[myset,i][tmprows]
                                if(sum(diff(elem) != 1 & diff(elem) != 0)){
                                    needToOrder<-1
                                }
                            }
                        }
                    }
                }
                if(needToOrder == 1){
                    stop(paste("tree elements in",myclass,"are not ordered"))
                }
            }
        }

    }else if(myclass == "SYNT"){
        ## ----------
        ## check SYNT
        ## ----------
        if(!is.list(myobject)){
            stop(paste(myclass,"needs to be a list"))
        }
        if(any(!is.element(c("NM1","NM2","SM","IV","NM1bS",
                             "NM1bE","NM2bS","NM2bE","SMbS",
                             "SMbE","IVbS","IVbE","nodeori","blockori",
                             "blockid","premask","subnode"),names(myobject)))){
            stop(paste("list objects in",myclass,"need to include\n    'NM1', 'NM2', 'SM', 'IV', 'NM1bS', 'NM1bE',\n    'NM2bS', 'NM2bE', 'SMbS', 'SMbE', 'IVbS', 'IVbE',\n    'nodeori', 'blockori', 'blockid', 'premask', 'subnode'"))
        }
        for(i in 1:length(myobject)){
            if(!is.matrix(myobject[[i]])){
                stop(paste0(myclass,"$",names(myobject)[i]," needs to be a matrix"))
            }
            if(names(myobject)[i]=="filter"){
                if(colnames(myobject[[i]])[1] != "filterMin" |
                   colnames(myobject[[i]])[2] != "filterMax"){
                    stop(paste("list object 'filter' in",myclass,"requires columns\n    'filterMin' and 'filterMax'"))
                }
                if(nrow(myobject[[i]]) != 4){
                    stop(paste("list object 'filter' in",myclass,"does not contain four rows"))
                }
                if(!(is.numeric(myobject[[i]]) | sum(is.na(myobject[[i]]))==6)){
                    stop(paste("list object 'filter' in",myclass,"needs to be a numeric matrix"))
                }
            }else{
                if(sum(rownames(myobject[[i]]) != rownames(myobject$SM))>0){
                    stop(paste("rownames in",myclass,"differ"))
                }
            }
        }
        if(anyDuplicated(rownames(myobject$SM)) > 0){
            stop(paste("some rownames are duplicated in",myclass))
        }

    }else if(myclass == "BLOCKS"){
        ## ------------
        ## check BLOCKS
        ## ------------
        if(!is.list(myobject) | length(myobject) < 1){
            stop(paste(myclass,"needs to be a list"))
        }
        if(any(!is.element(c("blocks","NM1","NM2","SM","IV","IVsm"),
                           names(myobject[[1]])))){
            stop(paste("list objects within each list in",myclass,"need to include\n    'blocks', 'NM1', 'NM2', 'SM', 'IV', 'IVsm'"))
        }
        if(!is.data.frame(myobject[[1]]$blocks)){
            stop(paste("object '$blocks' within",myclass,"needs to be a data frame"))
        }
        if(any(!is.element(c("start","end","markerS","markerE","car"),
                           colnames(myobject[[1]]$blocks)[1:5]))){
            stop(paste("first five columns in object '$blocks' within",myclass,"need\n    to include columns 'start', 'end', 'markerS', 'markerE', 'car'"))
        }
        if(!is.numeric(myobject[[1]]$blocks$start) |
           !is.numeric(myobject[[1]]$blocks$end) |
           !is.numeric(myobject[[1]]$blocks$car)){
            stop(paste("columns 'start', 'end', and 'car' in object '$blocks'\n    within",myclass,"need to be numeric"))
        }
        if(ncol(myobject[[1]]$blocks) < 14){
            stop(paste("object '$blocks' within",myclass,"needs to include at least 14 columns"))
        }
        for(i in 6:ncol(myobject[[1]]$blocks)){
            if(!is.character(myobject[[1]]$blocks[,i])){
                stop(paste("all columns past the first five in object '$blocks' within",myclass,"\n    need to be characters"))
            }
        }
        if(nrow(myobject[[1]]$blocks) != nrow(myobject[[1]]$NM1) |
           nrow(myobject[[1]]$blocks) != nrow(myobject[[1]]$NM2) |
           nrow(myobject[[1]]$blocks) != nrow(myobject[[1]]$SM) |
           nrow(myobject[[1]]$blocks) != nrow(myobject[[1]]$IV) |
           nrow(myobject[[1]]$blocks) != nrow(myobject[[1]]$IVsm) |
           nrow(myobject[[1]]$blocks) < 1){
            stop(paste("all list objects within each list in",myclass,"need to have the same number of rows"))
        }
        for(i in 2:length(myobject[[1]])){
            if(!is.matrix(myobject[[1]][[i]]) |
               (ncol(myobject[[1]][[i]])>0 & !is.numeric(myobject[[1]][[i]]))){
                stop(paste0("list object '$",names(myobject[[1]])[i],"' within ",myclass,"[[1]] needs to be a numeric matrix"))
            }
        }

    }else{
        stop(paste("unknown object class",myclass))
    }

    ##return(invisible(0))
}

## ------------------------------------------------------------------------
