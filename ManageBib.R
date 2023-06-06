
install.packages("bib2df")

library(bib2df)
library(tidyverse)



path <- 
  system.file("extdata","ref.bib", package = "bib2df")



refDF <- bib2df("ref.bib")
OldDF <- bib2df("refOld.bib")

CombKey <- 
  OldDF %>% 
  select(BIBTEXKEY) %>% 
  mutate(Old = 1) %>% 
  left_join(
    refDF %>% 
      select(BIBTEXKEY) %>% 
      mutate(Ref = 1),
    by = c("BIBTEXKEY")
    )

OLDextract <- 
CombKey %>% 
  filter(Old==1&is.na(Ref)==T) %>% 
  select(BIBTEXKEY) %>% 
  as_vector()


NewRef <- 
  refDF %>% 
  bind_rows(
    OldDF %>% filter(BIBTEXKEY %in% OLDextract)
  )

df2bib(NewRef, file = "refNew.bib")

