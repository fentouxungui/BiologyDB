library(BiologyDB)
d <- data(package = "BiologyDB")
for (i in d$results[,"Item"]) {
  for (j in d$results[,"Item"]) {
    if ( identical(get(i),get(j)) ) {
      if (i != j) {
        print(j)
        print(i)
      }
    }
  }
}
