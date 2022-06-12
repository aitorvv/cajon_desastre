#-------------------------------------------------------------------------------------------#
# Code to obtain text information from pdf files
# Aitor Vázquez Veloso, 05/05/2022
# Main source: https://www.r-bloggers.com/2018/01/how-to-extract-data-from-a-pdf-file-with-r/
# Original source of this script: https://github.com/aitorvv96/cajon_desastre
# R Version: 4.2.0  -  File encoding: WINDOWS-1252
#-------------------------------------------------------------------------------------------#

#### General steps ####

#install.packages('pdftools') # linux installation: https://docs.ropensci.org/pdftools/
library('pdftools')

# set here your directory:
wd <- ''
setwd(wd)


#### Import pdf list and content ####

# get the list of documents
file_list <- list.files(path = wd)
file_vector <- file_list

# check .pdf files
grepl(".pdf",file_list)

# remove not .pdf files
pdf_list <- file_vector[grepl(".pdf",file_list)]

# read text line by line
pdf_text("BOE-A-2003-21339-consolidado.pdf") %>% strsplit(split = "\n")


# that variable will contain each file and content
raw_files <- data.frame("pdf_name" = c(),"text" = c())

for (i in 1:length(pdf_list)){
        print(i)
        pdf_text(paste("", pdf_list[i],sep = "")) %>% 
                strsplit("\n")-> document_text
        data.frame("pdf_name" = gsub(x =pdf_list[i],pattern = ".pdf", replacement = ""), 
                   "text" = document_text, stringsAsFactors = FALSE) -> document
        
        colnames(document) <- c("pdf_name", "text")
        raw_files <- rbind(raw_files,document) 
}


#### Filter text information ####

# code as example to filter information
#raw_files %>% 
#        filter(!grepl("12.05.2017",text)) %>% 
#        filter(!grepl("business profile",text)) %>% 
#        filter(!grepl("comments",text)) %>%
#        filter(!grepl("1",text)) -> corpus



# create a new list to stock lines with the desired word
filtered_files <- data.frame("pdf_name" = c(),"text" = c())

row <- 0

for (i in raw_files$text){
        row <- row +1

        if (grepl('solicitud', i)){  # change the desired word here
                add_row <- raw_files[row, ]
                filtered_files <- rbind(filtered_files, add_row)
                }
        
        if (grepl('Alcohol', i)){  # change the desired word here
                add_row <- raw_files[row, ]
                filtered_files <- rbind(filtered_files, add_row)
        } 
        
}
