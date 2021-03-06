context("computeRearrs - main")
library(rearrvisr)

## computeRearrs<-function(focalgenome,compgenome,doubled,remWgt = 0.05,
##                         splitnodes = TRUE)


## test results
NM1<-rbind(0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0)

NM2<-rbind(0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0)

SM<-rbind(c(0.00, 0.00, 0.0),
            c(0.95, 0.00, 0.0),
            c(0.00, 0.05, 0.0),
            c(0.00, 0.05, 0.0),
            c(0.00, 0.05, 0.0),
            c(0.00, 0.05, 0.0),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.50, 0.0),
            c(0.00, 0.00, 0.5),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.00, 0.0),
            c(0.00, 0.00, 0.0),
            c(1.00, 0.00, 0.0))

IV<-rbind(0,
          0,
          0,
          1,
          1,
          1,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0)

nodeori<-rbind(c(NA,  1,  NA,  NA),
               c(NA,  1,  NA,  NA),
               c(NA,  1,  NA,  NA),
               c(NA,  1,  NA,  NA),
               c(NA,  1,  NA,  NA),
               c(NA,  1,  NA,  NA),
               c(NA,  1,  NA,  NA),
               c(NA,  1,  NA,  NA),
               c(NA,  1,   9,  NA),
               c(NA,  9,  NA,  NA),
               c(NA,  1,  -1,  NA),
               c(NA,  1,  -1,  NA),
               c(NA,  1,  -1,  NA),
               c(NA,  9,  NA,  NA),
               c(NA,  9,  NA,  NA),
               c(NA,  9,  NA,  NA),
               c(NA,  9,  NA,  NA),
               c(NA,  9,  NA,  NA),
               c(NA,  9,   1,   1),
               c(NA,  9,   1,   1),
               c(NA,  9,   1,   1),
               c(NA,  9,   1,   1),
               c(NA,  9,   1,   1),
               c(NA,  9,   1,   9))

blockori<-rbind(c(NA,  9,  NA,  NA),
                c(NA,  9,  NA,  NA),
                c(NA,  9,  NA,  NA),
                c(NA, -1,  NA,  NA),
                c(NA, -1,  NA,  NA),
                c(NA, -1,  NA,  NA),
                c(NA,  9,  NA,  NA),
                c(NA,  1,  NA,  NA),
                c(NA,  1,   9,  NA),
                c(NA,  9,  NA,  NA),
                c(NA,  1,  -1,  NA),
                c(NA,  1,  -1,  NA),
                c(NA,  1,  -1,  NA),
                c(NA,  9,  NA,  NA),
                c(NA,  9,  NA,  NA),
                c(NA,  9,  NA,  NA),
                c(NA,  9,  NA,  NA),
                c(NA,  9,  NA,  NA),
                c(NA,  9,   1,  -1),
                c(NA,  9,   1,  -1),
                c(NA,  9,   1,   1),
                c(NA,  9,   1,   1),
                c(NA,  9,   1,   1),
                c(NA,  9,   9,   9))

blockid<-rbind(c(NA,  "1",   NA,   NA),
               c(NA,  "4.1", NA,   NA),
               c(NA,  "2.2", NA,   NA),
               c(NA,  "3.2", NA,   NA),
               c(NA,  "3.2", NA,   NA),
               c(NA,  "3.2", NA,   NA),
               c(NA,  "5",   NA,   NA),
               c(NA,  "1",   NA,   NA),
               c(NA,  "1",   "1",  NA),
               c(NA,  "1",   NA,   NA),
               c(NA,  "1",   "1",  NA),
               c(NA,  "1",   "1",  NA),
               c(NA,  "1",   "1",  NA),
               c(NA,  "1",   NA,   NA),
               c(NA,  "1",   "0",  NA),
               c(NA,  "1",   "0",  NA),
               c(NA,  "1",   "0",  NA),
               c(NA,  "1",   "0",  NA),
               c(NA,  "1",   "2",  "1.1"),
               c(NA,  "1",   "2",  "1.2"),
               c(NA,  "1",   "2",  "1"),
               c(NA,  "1",   "2",  "1"),
               c(NA,  "1",   "2",  "1"),
               c(NA,  "1",   "1",  "1"))

subnode<-rbind(c(0,  0,  0,  0),
               c(0,  1,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(1,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  1),
               c(0,  0,  0,  2),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  0,  0),
               c(0,  0,  1,  0))


rownames(NM1)<-c("1","7","2","6","5","4","8","9","10","3","13","12","11",
                  "14","17","16","15","18","21","20","22","23","24","19")
rownames(NM2)<-c("1","7","2","6","5","4","8","9","10","3","13","12","11",
                  "14","17","16","15","18","21","20","22","23","24","19")
rownames(SM)<-c("1","7","2","6","5","4","8","9","10","3","13","12","11",
                  "14","17","16","15","18","21","20","22","23","24","19")
rownames(IV)<-c("1","7","2","6","5","4","8","9","10","3","13","12","11",
                "14","17","16","15","18","21","20","22","23","24","19")
rownames(nodeori)<-c("1","7","2","6","5","4","8","9","10","3","13","12","11",
                     "14","17","16","15","18","21","20","22","23","24","19")
rownames(blockori)<-c("1","7","2","6","5","4","8","9","10","3","13","12","11",
                      "14","17","16","15","18","21","20","22","23","24","19")
rownames(blockid)<-c("1","7","2","6","5","4","8","9","10","3","13","12","11",
                     "14","17","16","15","18","21","20","22","23","24","19")
rownames(subnode)<-c("1","7","2","6","5","4","8","9","10","3","13","12","11",
                     "14","17","16","15","18","21","20","22","23","24","19")


## tests
test_that("function output of computeRearrs with test set TOY24", {
    expect_identical(computeRearrs(TOY24_focalgenome,TOY24_compgenome,
                                   doubled = TRUE,remWgt = 0.05,
                                   splitnodes = TRUE)$NM1, NM1)
    expect_identical(computeRearrs(TOY24_focalgenome,TOY24_compgenome,
                                   doubled = TRUE,remWgt = 0.05,
                                   splitnodes = TRUE)$NM2, NM2)
    expect_identical(computeRearrs(TOY24_focalgenome,TOY24_compgenome,
                                   doubled = TRUE,remWgt = 0.05,
                                   splitnodes = TRUE)$SM, SM)
    expect_identical(computeRearrs(TOY24_focalgenome,TOY24_compgenome,
                                   doubled = TRUE,remWgt = 0.05,
                                   splitnodes = TRUE)$IV, IV)
    expect_identical(computeRearrs(TOY24_focalgenome,TOY24_compgenome,
                                   doubled = TRUE,remWgt = 0.05,
                                   splitnodes = TRUE)$nodeori, nodeori)
    expect_identical(computeRearrs(TOY24_focalgenome,TOY24_compgenome,
                                   doubled = TRUE,remWgt = 0.05,
                                   splitnodes = TRUE)$blockori, blockori)
    expect_identical(computeRearrs(TOY24_focalgenome,TOY24_compgenome,
                                   doubled = TRUE,remWgt = 0.05,
                                   splitnodes = TRUE)$blockid, blockid)
    expect_identical(computeRearrs(TOY24_focalgenome,TOY24_compgenome,
                                   doubled = TRUE,remWgt = 0.05,
                                   splitnodes = TRUE)$subnode, subnode)
})

