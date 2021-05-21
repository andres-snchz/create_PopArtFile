# Crear archivo PopART
 
> Aplicación se encuentra disponible en la siguiente url [Crear archivo de PopART](https://andres-snchz.shinyapps.io/create_popartfile/)

> Este respositorio contiene el código de shiny y función `R` relacionada.
  
Esta aplicación de `Shiny` facilita la creación de archivos de entrada del programa [PopART](http://popart.otago.ac.nz/index.shtml) (Population Analysis with Reticulate Trees; Leigh & Bryant 2015) para la reconstrucción de redes de haplotipos. Para usarlo se necesita un archivo fasta con las secuencias y una tabla con la información de las poblaciones o traits. La tabla debe contener al menos cuatro columnas llamadas: **code** (nombre único de las secuencias), **traits** (nombres de la población o *traits*), **lon** (longitud en grados decimales), **lat** (latitud en grados decimales). Los nombres de las secuencias deben coincidir con las de la columna code de la tabla. Por favor cite las [referencias relacionadas](http://popart.otago.ac.nz/howtocite.shtml).
 
- *Nota 1*: las coordenadas de las polaciones (o *traits*) son calculadas como el centroide o el punto medio.
- *Nota 2*: la aplicación esta hecha para casos particulares y podría generar errores para casos no probados durante su desarrollo. Por lo tanto, se debe revisar detalladamente si el archivo generado contiene la estructura esperada.
- *Nota 4*: en caso de no querer ingresar las coordenadas se deben incluir las columnas lat y lon vacías, de los contrario generará un error. Luego de generado el archivo deberá eliminar el bloque GeoTags.
- *Nota 3*: esta versión no incorpora la posibilidad de añadir un bloque con los árboles para inferir redes de parsimonia ancestral (pendiente a incluir).

 
*El resultado final es un archivo nexus (.nex) con los bloques necesarios para elaborar las redes de haplotipos en PopArt.*
  
Desarrollada en `R` con los paquetes `seqinr`, `ape`, y `geosphere` en `Shiny`.
 
Por *Andrés F. Sánchez Restrepo*, 2021.
 
### Referencias
Leigh, JW, Bryant D (2015). PopART: Full-feature software for haplotype network construction. Methods Ecol Evol 6(9):1110–1116.

