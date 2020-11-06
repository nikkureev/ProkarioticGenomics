install.packages("genoPlotR")
library(genoPlotR)
library(tools)
library(data.table)

setwd("")

# Загружаем таблицы с генами
files <- list.files(pattern="\\.txt$") 

# Создаем списки
n = length(files)
seg_names = vector("list", n)
ann_dna_segs = vector("list", n)
file_names = gsub(files, pattern=".txt$", replacement="")

for (f in 1:n) {
  name = paste("data_",gsub("[^0-9]","",file_path_sans_ext(files[[f]])),sep="")
  assign(name, fread(files[f])) 
  df_dna = get(name)
  # Создаем таблицы с генами и свойствами
  seg_name = paste("dna_seg_",gsub("[^0-9]","",file_path_sans_ext(files[[f]])),sep="")
  assign(seg_name, dna_seg(df_dna)) 
  dna_seg = get(seg_name)
  dna_seg$fill <- "azure4"
  dna_seg$col <- "azure4"
  dna_seg$fill[10] <- "brown2"
  dna_seg$col[10] <- "brown2"
  seg_names[[f]] = dna_seg
  # Подписываем гены
  ann_name = paste("ann_dna_seg_",gsub("[^0-9]","",file_path_sans_ext(files[[f]])),sep="")
  assign(ann_name, annotation(x1=middle(dna_seg), text=dna_seg$name, rot = 40, col = "black")) 
  ann_dna_segs[[f]] = get(ann_name)
  assign(seg_name, dna_seg, envir= .GlobalEnv)
}

# Рисуем картинку
plot_gene_map(dna_segs = seg_names, 
              gene_type = "arrows", 
              annotations = ann_dna_segs,
              arrow_head_len=250,
              dna_seg_scale=TRUE, 
              limit_to_longest_dna_seg = TRUE,
              scale=TRUE,
              annotation_cex = 0.5, 
              #annotation_height = 1, 
              #cex =1,
              dna_seg_labels= file_names)
