# Crear archivo PopART
 
> Aplicación se encuentra disponible en la siguiente url [Crear archivo de PopART](https://andres-snchz.shinyapps.io/create_popartfile/)

> Este respositorio contiene el código de shiny y función `R` relacionada.
  
Esta aplicación de `Shiny` facilita la creación de archivos de entrada del programa [PopART](http://popart.otago.ac.nz/index.shtml) (Population Analysis with Reticulate Trees; Leigh & Bryant 2015) para la reconstrucción de redes de haplotipos. Para usarlo se necesita un archivo fasta con las secuencias y una tabla con la información de las poblaciones o traits. La tabla debe contener al menos cuatro columnas llamadas: **code** (nombre único de las secuencias), **traits** (nombres de la población o *traits*), **lon** (longitud en grados decimales), **lat** (latitud en grados decimales). Los nombres de las secuencias deben coincidir con las de la columna code de la tabla. Por favor cite las [referencias relacionadas](http://popart.otago.ac.nz/howtocite.shtml).
 
- *Nota 1*: las coordenadas de las polaciones (o *traits*) son calculadas como el centroide o el punto medio.
- *Nota 2*: la aplicación esta hecha para casos particulares y podría generar errores para casos no probados durante su desarrollo. Por lo tanto, se debe revisar detalladamente si el archivo generado contiene la estructura esperada.
- *Nota 4*: en caso de no querer ingresar las coordenadas se deben incluir las columnas lat y lon vacías, de lo contrario generará un error. Luego de generado el archivo deberá eliminar el bloque GeoTags.
- *Nota 3*: esta versión no incorpora la posibilidad de añadir un bloque con los árboles para inferir redes de parsimonia ancestral (pendiente a incluir).

 
*El resultado final es un archivo nexus (.nex) con los bloques necesarios para elaborar las redes de haplotipos en PopArt.*
  
Desarrollada en `R` con los paquetes `seqinr`, `ape`, y `geosphere` en `Shiny`.
 
Por *Andrés F. Sánchez Restrepo*, 2021. 
 
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5334306.svg)](https://doi.org/10.5281/zenodo.5334306)
 
### Referencias
Leigh, JW, Bryant D (2015). PopART: Full-feature software for haplotype network construction. Methods Ecol Evol 6(9):1110–1116.

---
This `Shiny` app facilitates the creation of [PopART](http://popart.otago.ac.nz/index.shtml) input files (Population Analysis with Reticulate Trees; Leigh & Bryant 2015) for the reconstruction of haplotype networks. To use it, a fasta file with the sequences and a table with the population or trait information are needed. The table must contain at least four columns named: **code** (unique name of the sequences), **traits** (population names or *traits*), **lon** (longitude in decimal degrees), **lat** (latitude in decimal degrees). The sequence names must match those in the code column of the table. Please cite the [related references](http://popart.otago.ac.nz/howtocite.shtml).  

- Note 1*: the coordinates of the poles (or *traits*) are calculated as the centroid or the midpoint.
- Note 2*: the application is made for particular cases and could generate errors for cases not tested during its development. Therefore, you should check in detail if the generated file contains the expected structure.
- Note 4*: in case you do not want to enter the coordinates you must include the empty lat and lon columns, otherwise it will generate an error. After generating the file you must delete the GeoTags block.
- Note 3*: this version does not include the possibility of adding a block with the trees to infer ancestral parsimony networks (to be included). 

*The final result is a nexus (.nex) file with the necessary blocks to build the haplotype networks in PopArt. 
  
Developed in `R` with the `seqinr`, `ape`, and `geosphere` packages in `Shiny`. 
 
By *Andrés F. Sánchez Restrepo*, 2021. 

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5334306.svg)](https://doi.org/10.5281/zenodo.5334306)