# Plot SIMANFOR simulation results and create a short video ####
#
# Aitor Vázquez Veloso, 2024-02-01
# 
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#


# Basic steps ====

library(ggplot2)
library(viridis)
library(dplyr)
library(stringr)
library(av)

# working directory
setwd('cajon_desastre/R/simanfor/video_from_graphs/')

# load simulation results
load('data/simulation_results.RData')

# select df
df <- stand_evolution

# Graph Density among treatments ====

# counters for graph number and management alternatives
count <- 10
man_count <- 0

# management alternatives groups
manage_groups <- list('0', c('0', '1', '2'), c('0', '1', '2', '3', '4'))

# loop for each management alternative
for(manage in manage_groups){
  
  # select management
  man_count <- man_count + 1
  man_tmp_df <- df[df$n_scnr %in% manage, ]
  
  # reset count
  count <- 10
  
  # loop for each step (time of simulation)
  for(step in unique(man_tmp_df$T)){
    
    # select data
    tmp_df <- man_tmp_df[man_tmp_df$T <= step, ]
    count <- count + 1
    if(count == 11){next}
    
    # graph
    graph <- 
      ggplot(tmp_df, aes(x = T, y = dg, 
                         group = n_scnr, colour = n_scnr)) +  # group by scnr
      
      # text
      labs(title = "Stand quadratic mean diameter evolution",  
           # subtitle = "",  
           x = "Stand age (years)",  
           y = "Quadratic mean diameter (cm)"   
      ) +
      
      # text position and size
      theme(plot.title = element_text(size = 20, hjust = 0.5), # title  
            # plot.subtitle = element_text(size = 15, hjust = 0.5),  
            axis.title = element_text(size = 15),  # axis
            legend.title = element_text(size = 15),  # legend title
            legend.text = element_text(size = 12)) +  # legend content
      
      # set colors and legend name manually
      scale_color_viridis('Scenario', discrete = TRUE, option = "D")+
      scale_fill_viridis(discrete = TRUE) +
      
      # plot data
      geom_point() +  # points
      geom_line()  # lines
    
    # save graph
    ggsave(filename = paste('graphs/DG_', man_count, '_', count, '.png', sep = ''), device = 'png', dpi = 300, width = 16, height = 9)
    
  }
}


# Create video from graphs ====

# path to all the images
all_paths <- 'graphs/'

# create a temporal list of paths to all the images
images <- list()

# get image paths
for(path in all_paths){
  
  # if the path is the image...
  if(grepl('.png', path)){
    
    # copy path to image
    images_path <- path
    
  } else {
    
    # copy path of each graph
    images_path <- list.files(path, pattern = "\\.png$", full.names = TRUE)
    
  }
  
  # images in list
  images <- c(images, images_path)
}

# convert list to character
images <- as.character(images)

# create video
av_encode_video(input = images, 
                framerate = 1,
                #audio = music,  
                output = "video/DG_video.mp4",
                verbose = FALSE)

# watch video
utils::browseURL("video/DG_video.mp4")
