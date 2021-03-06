#' Protein coverage and degradation
#'
#' @param peptides
#'
#' @return
#' @export
#'
#' @examples
PlotProteinCoverage <- function(peptides,proteinGroups, UniprotID = NULL, log_base = 2, segment_width =1,
                                palette = 'Set2'){


  table_peptides <- peptides %>%
        select(contains(c('Intensity ', 'Start position',
                          'End position', 'Proteins', 'Gene names')))%>%
    select(-contains('Unique')) %>%
    select(-starts_with('LFQ'))# %>%
    #select(-'Intensity')

  #Select rows for the protein selected
  table_peptides <- table_peptides[grepl(UniprotID, table_peptides$Proteins ),]

  if(nrow(table_peptides) == 0){
    print(paste0('The protein: ',UniprotID ,' provided was not identified in any of the samples.'))
  } else{

  #Total protein coverage

   prot_info <- proteinGroups[grepl(UniprotID, proteinGroups$`Protein IDs` ),]
   prot_cov <- prot_info$`Sequence coverage [%]`[1]

   prot_len <- prot_info$`Sequence length`[1]



  #table_peptides <- table_peptides[1,]

  pep_melt <- melt(table_peptides, id.vars = c('Start position', 'End position', 'Proteins', 'Gene names'))


  # If intensity is 0, remove it.

  pep_melt <- pep_melt[!pep_melt$value==0,]


  a <- ggplot(pep_melt)+
            geom_segment(aes(x = `Start position`,
                             xend = `End position`,
                             y = `Start position`,
                             yend = `End position`,
                             colour = variable),
                             size = segment_width)+
            theme_bw()+
            facet_wrap(.~ variable, ncol =1)+
            ylab('End position')+
            theme(legend.position = 'none')+
            scale_colour_brewer(palette = palette)



  #Create a plot for the protein lenght vs the coverage

  if(log_base == 10){
    b <- ggplot(pep_melt )+
              geom_segment(aes(x=`Start position`,
                               xend=`End position`,
                               y = log10(value),
                               yend =log10(value),
                               colour = variable), size = segment_width )+
              theme_bw()+
              ylab(expression('Log'[10]*'(Intensity)'))+
              facet_wrap(.~ variable, ncol =1)+
              #scale_x_continuous(limits = c(1, prot_length))+
              theme(legend.position = 'none')+
              scale_colour_brewer(palette = palette)

  } else{
    b <- ggplot(pep_melt )+
              geom_segment(aes(x=`Start position`,
                               xend=`End position`,
                               y = log2(value),
                               yend =log2(value),
                               colour = variable),size = segment_width )+
              theme_bw()+
              ylab(expression('Log'[2]*'(Intensity)'))+
              facet_wrap(.~ variable, ncol =1)+
              #scale_x_continuous(limits = c(1, prot_length))+
              theme(legend.position = 'none')+
              scale_colour_brewer(palette = palette)
  }





  #Plot them together
   c <- plot_grid(a,b)
   #Make a title
   title <- ggdraw()+ draw_label(paste0('The Protein Coverage of: ', UniprotID, ' (',prot_len,' amino acids)',
                                        ', Gene: ', pep_melt$`Gene names`[1],
                                        '\n is: ', prot_cov, '%'))

   plot_grid( title, c, ncol = 1, rel_heights=c(0.1, 1))


}
}
