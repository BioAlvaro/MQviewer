
#' Compares the type of identification of each sample
#'
#' @param peptides  The peptides.txt table from  MaxQuant Output.
#'
#' @return Plots the compares of the type of identification of each sample. It will not work if in MaxQuant the Match Between Run was not selected.
#' @export
#'
#' @examples
PlotIdentificationType <- function(peptides, proteinGroups, font_size=12,  long_names = FALSE, sep_names = '-', palette = 'Set2'){

  value <- variable <- NULL

  #Peptide Identification type
  ide_type <- peptides %>% select(contains('Identification type'))

  #NAs <- sapply(ide_type, function(x) sum(is.na(x)))
  By_MS_MS  <- str_count(ide_type, 'By MS/MS')
  By_matching <- str_count(ide_type, 'By matching')

  #ide_data <- data.frame(By_MS_MS, By_matching,NAs)
  ide_data <- data.frame( By_matching,By_MS_MS)
  rownames(ide_data) <- colnames(ide_type)
  ide_data$sample <- rownames(ide_data)
  ide_data_melted <- melt(ide_data)

  ide_data_melted$sample <- gsub("Identification type", "", paste(ide_data_melted$sample))

  a <- ggplot(ide_data_melted, aes(x=sample, y=value, fill=variable))+
          geom_col()+
          ggtitle('Peptide Identification type')+
          geom_bar(stat = 'identity',position='stack',size=0.5,col="black")+
          theme(axis.title.y = element_text(margin = margin(r = 20)))+
          theme_bw(base_size = font_size)+
          scale_fill_brewer(palette = palette)

  if (long_names == TRUE) {
    a <- a + scale_x_discrete(labels = function(x) stringr::str_wrap(gsub(sep_names,' ',x), 3))

  } else{
    a
  }


   #Protein Identification Type

  prot_ide_type <- proteinGroups %>% select(contains('Identification type'))

  #NAs <- sapply(ide_type, function(x) sum(is.na(x)))
  by_MS_MS  <- str_count(prot_ide_type, 'By MS/MS')
  by_matching <- str_count(prot_ide_type, 'By matching')

  #ide_data <- data.frame(By_MS_MS, By_matching,NAs)
  prot_data <- data.frame( by_matching,by_MS_MS)
  rownames(prot_data) <- colnames(prot_ide_type)
  prot_data$sample <- rownames(prot_data)
  prot_data_melted <- melt(prot_data)

  prot_data_melted$sample <- gsub("Identification type", "", paste(prot_data_melted$sample))

  b <- ggplot(prot_data_melted, aes(x=sample, y=value, fill=variable))+
    geom_col()+
    ggtitle('Protein Identification type')+
    geom_bar(stat = 'identity',position='stack',size=0.5,col="black")+
    theme(axis.title.y = element_text(margin = margin(r = 20)))+
    theme_bw(base_size = font_size)+
    scale_fill_brewer(palette = palette)

  if (long_names == TRUE) {
    b <- b + scale_x_discrete(labels = function(x) stringr::str_wrap(gsub(sep_names,' ',x), 3))

  } else{
    b
  }

  plot_grid(
    b, a,
    ncol = 1
  )



}


