PopArt.blocks <- function(fasta_data, trait_data){
  
  # obtener los nombres de las secuencias de una archivo fasta
  seq_data <- as.data.frame(names(fasta_data), col.names = C)
  colnames(seq_data) <- "code"
  
  # combinar los datos y dejar solo las columnas que coinciden
  seq_data <- dplyr::left_join(seq_data, trait_data, by = "code")
  seq_data$traits <- factor(seq_data$traits)
  
  # separar a una lista por cada cluster
  coord_data <- split(seq_data, seq_data$traits)
  
  for (i in seq_along(coord_data)) {
    
    if ((anyDuplicated(coord_data[[i]]$lat) >= 0) == FALSE) {
      
      if (nrow(coord_data[[i]]) >= 3) {
        
        # obtener los centroides
        coords <- coord_data[[i]][,c("lon","lat")]
        centro <- geosphere::centroid(coords)
        
        # agregarlos a cada cluster
        coord_data[[i]]$lat_traits <- centro[2]
        coord_data[[i]]$lon_traits <- centro[1]
        
      } else if (nrow(coord_data[[i]]) == 2) {
        
        # obtener punto medio
        coords <- coord_data[[i]][,c("lon","lat")]
        coords_mid <- geosphere::midPoint(coords[1,], coords[2,])
        coord_data[[i]]$lat_traits <- coords_mid[2]
        coord_data[[i]]$lon_traits <- coords_mid[1]
        
      } else {
        
        coord_data[[i]]$lat_traits <- coord_data[[i]]$lat
        coord_data[[i]]$lon_traits <- coord_data[[i]]$lon
      }
      
    } else if ((anyDuplicated(coord_data[[i]]$lat) >= 0) == TRUE) {
      
      
      if (nrow(dplyr::distinct(coord_data[[i]], lat, .keep_all = TRUE)) > 3) {
        
        # dejar los distintos
        coords <- dplyr::distinct(coord_data[[i]], lat, .keep_all = TRUE)
        coords <- subset(coords, select = c("lon", "lat"))
        
        # obtener los centroides
        centro <- geosphere::centroid(coords)
        
        # agregarlos a cada cluster
        coord_data[[i]]$lat_traits <- centro[2]
        coord_data[[i]]$lon_traits <- centro[1]
        
      } else if (nrow(dplyr::distinct(coord_data[[i]], lat, .keep_all = TRUE)) == 2) {
        
        # dejar los distintos
        coords <- dplyr::distinct(coord_data[[i]], lat, .keep_all = TRUE)
        coords <- subset(coords, select = c("lon", "lat"))
        
        # obtener punto medio
        coords_mid <- geosphere::midPoint(coords[1,], coords[2,])
        coord_data[[i]]$lat_traits <- coords_mid[2]
        coord_data[[i]]$lon_traits <- coords_mid[1]
        
      } else {
        
        coord_data[[i]]$lat_traits <- coord_data[[i]]$lat
        coord_data[[i]]$lon_traits <- coord_data[[i]]$lon
      }
      
    } else {
      print("check coordinates")
    }
  }
  
  
  # volver a pasar la lista al dataframe
  seq_data <- do.call(rbind.data.frame, coord_data)
  
  # crear tabla binaria de las "traits"
  bin_data <- aggregate(model.matrix(~ traits -1, seq_data), seq_data["code"], max)
  
  # crear listado de coordenadas, reemplazar espacios por "_", organizar como filas y dar formato.
  traits_data <- as.data.frame(levels(seq_data$traits))
  traits_data <- dplyr::distinct(seq_data, traits, .keep_all = TRUE)
  traits_data <- subset(traits_data, select = c("traits", "lat_traits", "lon_traits"))
  traits_data$traits <- gsub(" ", "_", traits_data$traits)
  traits_data <- as.data.frame(t(traits_data))
  row.names(traits_data) <- c("  TraitLabels  ", "  TraitLatitude  ", "  TraitLongitude  ")
  traits_data[,ncol(traits_data)] <- paste(traits_data[,ncol(traits_data)], ";", sep = "")
  
  # crear tabla de coordenadas
  coor_data <- data.frame(seq_data$code, seq_data$lat, seq_data$lon)
  
  output_list <- list(seq_data = seq_data,
                      bin_data = bin_data,
                      traits_data = traits_data,
                      coor_data = coor_data)
  
  
  return(output_list)
}