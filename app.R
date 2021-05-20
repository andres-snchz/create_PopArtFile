
# cargar paquetes
library(seqinr)
library(ape)
library(dplyr)
library(geosphere)
library(shinycssloaders)

# cargar función
source("./funciones/PopArt_blocks.R", local = TRUE)

# Shiny ui ----------------------------------------------------------------
ui <- fluidPage(
  theme = shinythemes::shinytheme("spacelab"),
  navbarPage(title= "Crear archivo PopArt"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "1) .csv",
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv"),
                buttonLabel = "Buscar...",
                placeholder = "No hay ningún archivo seleccionado"
      ),
      fileInput("file2", "2) .fasta | .fas",
                accept = c("application/fasta",
                           ".fasta",
                           ".fas"),
                buttonLabel = "Buscar...",
                placeholder = "No hay ningún archivo seleccionado"
      ),
      textInput("filename", "Nombre del archivo", "PopArt_file"),
      headerPanel(""),
      h4("Instrucciones"),
      p(style="text-align: justify;",
        "1) Cargar un archivo .csv con al menos las siguientes columnas:",
        strong("code"), "(nombre único de las secuencias), ",
        strong("traits"), "(nombres de la población o traits), ",
        strong("lon"), "(longitud en grados decimales), ",
        strong("lat"), "(latitud en grados decimales)"),
      p(style="text-align: justify;",
        "2) Cargar un archivo con secuencias en formato .fasta o .fas"),
      p(style="text-align: justify;",
        "3) Nombres en ambos archivos deben coincidir exactamente (preferiblemente sin símbolos o espacio, se puede usar guión bajo"),
      p(style="text-align: justify;",
        "4) El archivo estará listo para descargar luego de que carquen los dos archivos"),
      headerPanel(""),
      helpText("Desarrollada en ", code("R"), " con los paquetes", code("seqinr"), code("ape"), " y ", code("geosphere"), " en ", code("Shiny"), "."),
      helpText("Por Andrés F. Sánchez Restrepo. ", paste(format(Sys.Date(), "%Y")), "."),
      helpText("Código disponible en ", shiny::a(href = "https://github.com/andres-snchz/create_PopArtFile", "Github", .noWS = "outside"))
      # helpText(tags$a("Ejemplo archivo .csv", href="trait_data.csv")),
      # helpText(tags$a("Ejemplo archivo .fasta", href="lobicornis_Mit.fasta"))
    ),
    mainPanel(
      h4("Crear archivo de PopArt"),
      p(style="text-align: justify;",
        "Esta aplicación facilita la creación de archivos de entrada para el programa ",
        shiny::a(href = "http://popart.otago.ac.nz/index.shtml", "PopART", .noWS = "outside"),
        " (Leigh & Bryant 2015), para la reconstrucción de redes de haplotipos. Para usarlo se necesita un archivo fasta con las secuencias y una tabla con la información de las poblaciones o traits.",
        " La tabla debe contener al menos cuatro columnas llamadas: ",
        strong("code"), "(nombre único de las secuencias), ",
        strong("traits"), "(nombres de la población o traits), ",
        strong("lon"), "(longitud en grados decimales), ",
        strong("lat"), "(latitud en grados decimales)",
        ". Los nombres de las secuencias deben coincidir con las de la columna code de la tabla. "),
      p(style="text-align: justify;",
        em("Nota 1"), ": las coordenadas de la polaciones (o traits) son calculadas como el centroide o el punto medio."),
      p(style="text-align: justify;",
        em("Nota 2"), ": esta aplicación está hecha para casos particulares y podría generar erroes para casos no probados durante su desarrollo. ",
        "Por lo tanto debe revisar detalladamente si el archivo generado contiene la estructura esperada."),
      p(style="text-align: justify;",
        em("Nota 3"), ": esta versión no incorpora la posibilidad de añadir un bloque con los árboles para inferir redes de parsimonia ancestral."),
      headerPanel(""),
      downloadButton("downloadData", "Descargar archivo"),
      helpText("El resultado final es un archivo nexus (.nex) con los bloques necesarios para elaborar las redes
        de haplotipos en PopArt."),
      headerPanel(""),
      htmlOutput("mensaje"),
      headerPanel(""),
      h4("Tabla traits"),
      tableOutput("traits"),
      headerPanel(""),
      h4("Tabla traits binaria"),
      tableOutput("binaria")
    )
  )
)

# Shiny server ------------------------------------------------------------
server <- function(input, output) {
  
  # load .csv
  data_csv <- reactive({
    
    inFile <- input$file1
    if (is.null(inFile)) {
      return(NULL)
    } else {
      read.csv(inFile$datapath, header = TRUE, sep =",")
    }
  })
  
  # load .fasta
  data_fas <- reactive({
    
    inFile <- input$file2
    if (is.null(inFile)) {
      return(NULL)
    } else {
      seqinr::read.fasta(inFile$datapath, seqtype = "DNA")
    }
  })
  
  # generar partes de los bloques
  popart_data <- reactive({
    if (is.null(data_csv())|is.null(data_fas())){
      return(NULL) 
    } else {
      PopArt.blocks(fasta_data = data_fas(), trait_data = data_csv())
    }
  })
  
  # mensaje
  output$mensaje <- renderUI({
    str1 <- paste0("Número de secuencias: ", length(data_fas()))
    str2 <- paste0("Número de poblaciones o traits: ", ncol(popart_data()$traits_data))
    HTML(paste(str1, str2, sep = '<br/>'))
  })    
  
  # tabla binaria
  output$traits <- renderTable({ popart_data()$traits_data }, colnames = FALSE, rownames = TRUE)
  
  # tabla binaria
  output$binaria <- renderTable({ popart_data()$bin_data }, colnames = FALSE, digits = 0)
  
  # generar archivo final
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$filename, ".nex", sep="")
    },
    content = function(file) {
      
      # crear archivo nexus
      ape::write.nexus.data(data_fas(), file= file, format = "DNA", interleaved = FALSE)
      
      # agregar al archivo nexus la bloque de la tabla dinaria
      write("begin traits;", file= file, append=TRUE)
      
      # crear linea del número de traits
      ntraits <- ncol(popart_data()$traits_data)
      
      # agregar linea de número de traits
      cat(c("  Dimensions NTRAITS=", ntraits, ";"), file= file, append=TRUE, sep = "")
      
      # agregar al archivo nexus la bloque de la tabla dinaria
      traits_lines1 <- "
  Format labels=yes missing=? separator=Spaces;"
      write(traits_lines1, file= file, append=TRUE)
      
      # agregar líneas de traitlabels, traitlatitude y traitlongitude
      write.table(popart_data()$traits_data, file= file, append=TRUE,
                  sep = " ",
                  row.names = TRUE,
                  col.names = FALSE,
                  quote = FALSE)
      traits_lines2 <- "matrix"
      write(traits_lines2, file= file, append=TRUE)
      
      # guardar en el archivo nexus la matriz binaria
      write.table(popart_data()$bin_data, file= file, append=TRUE,
                  sep = " ",
                  row.names = FALSE,
                  col.names = FALSE,
                  quote = FALSE)
      
      # agregar al archivo nexus el bloque de coordenadas
      coord_lines1 <- ";
end;
Begin GeoTags;"
      write(coord_lines1, file= file, append=TRUE)
      
      # agregar linea de número de traits
      cat(c("  Dimensions NClusts=", ntraits, ";"),
          file= file,
          append=TRUE, sep = "")
      
      # agregar al archivo nexus el bloque de coordenadas
      coord_lines2 <- "
  Format labels=yes separator=Spaces;
matrix"
      
      write(coord_lines2, file= file, append=TRUE)
      write.table(popart_data()$coor_data, file= file, append=TRUE,
                  sep = " ",
                  row.names = FALSE,
                  col.names = FALSE,
                  quote = FALSE)
      
      # agregar el cierre del archivo
      close_lines <- ";
end;"
      write(close_lines, file= file, append=TRUE)
    })
  
}

# Shiny app ---------------------------------------------------------------
shinyApp(ui, server)

