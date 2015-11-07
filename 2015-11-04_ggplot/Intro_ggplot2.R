---
    title: "Sevillarusers - ggplot2 intro"
author: "Raúl Ortiz"
date: "Tuesday, October 27, 2015"
output: pdf_document
---
    
    # Introducción al paquete gráfico "ggplot2".
    
    ## Establezco el directorio de trabajo.
    ```{r}
setwd("~/Expression/Expression Encoder/Archivos presentaciones/Intro ggplot2")
```

## Instalo y cargo el paquete ggplot2.
```{r,warning=FALSE}
#install.packages("ggplot2")
library(ggplot2)
```

## Cargo los datos del df "diamonds".
```{r}
data("diamonds")
View(diamonds)
help(diamonds)
head(diamonds)
```

## Scatter plot. Para representar dos variables de una misma observación.
```{r}
ggplot(data=diamonds, aes(x=carat, y=price)) +  #qué quiero representar
    geom_point()                                #cómo lo quiero representar

# Se puede observar que existe cierta relacion entre el incremento del precio y el incremento del tamaño.

# Borrar gráfico

p = ggplot(data=diamonds, aes(x=carat, y=price)) +  #qué quiero representar
    geom_point()                                    #cómo lo quiero representar
print(p)
p

summary(p)
```

## Introducir una tercera variable en la representación. Aesthetic.
```{r}
ggplot(data=diamonds, aes(x=carat, y=price, color=clarity)) + #El color de los puntos cambia en f(variable)
    geom_point()

#No confundir con:
ggplot(data=diamonds, aes(x=carat, y=price)) +  
    geom_point(color="steelblue", size=4, alpha=1/2) #Ahora color es definido por una constante.

# Muchos aspectos se reprsentan siguiendo los parámetros predefinidos por defecto, como son los colores asignados a cada variable, la aparición de la leyenda con un formato y en una posición determinada, etc...

# Al introducir una tercera variable en el gráfico podemos ver cómo la claridad de los diamantes también influye en el precio, así se aprecia que los de claridad VVS1 alcanzan precios mas altos que los de la claridad I1, cuando aún cuando el peso del diamante es el mismo, p.e.1.

# En el lugar de "clarity" se puede introducir otras variables cualitativas como "color" o "cut".
```

## Podemos introducir aún un cuarta e incluso una quinta variable. Aesthetic.
```{r}
ggplot(data=diamonds, aes(x=carat, y=price, color=clarity, size=color)) +  
    geom_point()

ggplot(data=diamonds, aes(x=carat, y=price, color=clarity, size=color, shape=cut)) +  
    geom_point()

# Demasiado confuso.
```

## Añadimos una capa más al gráfico (geom_), que a su vez sea un resumen estadístico.
```{r}
ggplot(data=diamonds, aes(x=carat, y=price)) +  
    geom_point()

# Representamos la curva que mejor se adapta a los datos.
ggplot(data=diamonds, aes(x=carat, y=price)) +  
    geom_point() +
    geom_smooth() #El sombreado representa el error estándar.

# Si en vez de la curva, preferimos la recta, pediremos que se calcule mediante una regresión linear "lm".
ggplot(data=diamonds, aes(x=carat, y=price)) +  
    geom_point() +
    geom_smooth(method="lm", se=FALSE) #Quito el sombreado

# Como curiosidad, si utilizamos la estética color, se creará una recta para cada variable de color.
ggplot(data=diamonds, aes(x=carat, y=price, color=clarity)) +  
    geom_point() +
    geom_smooth(method="lm", se=FALSE) 

# Podemos quitar la capa de puntos para tener una mejor imágen.
ggplot(data=diamonds, aes(x=carat, y=price, color=clarity)) +  
    geom_smooth(method="lm", se=FALSE)

# Se puede modificar el tipo de línea
ggplot(data=diamonds, aes(x=carat, y=price, color=clarity)) +  
    geom_smooth(size=3, linetype=2, method="lm", se=FALSE)
```

## Separamos las gráficas mediante una variable. Facet.
```{r}
ggplot(data=diamonds, aes(x=carat, y=price, color=clarity)) +  
    geom_point() + #Podemos quitar esta capa añadiendo un corchete al inicio de la línea
    geom_smooth(method="lm", se=FALSE) +
    facet_wrap(~ color)

help(facet_wrap)

ggplot(data=diamonds, aes(x=carat, y=price, color=clarity)) +  
    geom_smooth(method="lm", se=FALSE) +
    facet_wrap(~ color, ncol=2)

ggplot(data=diamonds, aes(x=carat, y=price)) +  
    geom_point() +
    facet_wrap(~ color + cut, ncol=5)

ggplot(data=diamonds, aes(x=carat, y=price, color=clarity)) +  
    geom_point() +
    facet_grid(color ~ cut)
```

## Anotaciones.
```{r}
ggplot(data=diamonds, aes(x=carat, y=price, color=clarity)) +  
    geom_point()

# Añadimos título y modificamos las etiquetas de los ejes.

ggplot(data=diamonds, aes(x=carat, y=price, color=clarity)) +  
    geom_point() +
    ggtitle("Relación entre peso y precio de cada diamante") +
    xlab("Peso (ct)") +
    ylab("Precio ($)")

# Cambiamos parámetros generales del gráfico.
ggplot(data=diamonds, aes(x=carat, y=price, color=clarity)) +  
    geom_point() +
    theme_bw() + # Tema predefinido. Cambia algunos valores por defecto (color de fondo, de las fuentes..).
    ggtitle("Relación entre peso y precio de cada diamante") +
    labs(x="Peso (ct)", y="Precio ($)")

# Podemos cambiar los parámetros que nos interesen
ggplot(data=diamonds, aes(x=carat, y=price, color=clarity)) +  
    geom_point() +
    theme(text = element_text(size=14), # Tamaño de fuente del grafico por defecto
          plot.title=element_text(size=rel(2), vjust=2),
          axis.text=element_text(colour="blue"),
          axis.title.x = element_text(size=rel(1.5)),
          axis.title.y = element_text(size=rel(1.5)),
          legend.text=element_text(size=rel(0.7)),
          legend.title = element_text(size=rel(1))) +
    ggtitle("Relación entre peso y precio de cada diamante") +
    labs(x="Peso (ct)", y="Precio ($)")

help(theme)
```

## Histogramas.
```{r}
head(diamonds)

ggplot(data=diamonds, aes(x=carat)) +  
    geom_histogram()

ggplot(data=diamonds, aes(x=carat)) +  
    geom_histogram(binwidth=0.2) # Datos agrupados en diamantes que difieren en menos de 0.2 quilates.

# Para visualizar la distribución de los precios, agrupados por el tipo de corte.
ggplot(data=diamonds, aes(x=price)) +  
    geom_histogram(binwidth=1000) +
    facet_wrap(~ cut)

# Mejoramos los gráficos permitiendo que se ajuste el rango de las ordenadas en cada uno de ellos.
ggplot(data=diamonds, aes(x=price)) +  
    geom_histogram(binwidth=1000) +
    facet_wrap(~ cut, scales="free_y")

# Podemos representar una segunda variable.
ggplot(data=diamonds, aes(x=carat, fill=color)) +  
    geom_histogram(binwidth=0.2) #Observamos, por ejemplo, como los diamantes de color D disminuyen su frecuencia conforme éstos se hacen mas grandes.
```

## Gráficos de densidad.
```{r}
head(diamonds)

ggplot(data=diamonds, aes(x=carat)) +  
    geom_density()

ggplot(data=diamonds, aes(x=carat, color=color)) +  
    geom_density()
```

## Gráfico de caja y bigotes.
```{r}
head(diamonds)

ggplot(diamonds, aes(cut, price)) +
    geom_boxplot()

# Como hay muchos outlyers, transformamos la escala de ordenadas a una logarítmica.
ggplot(diamonds, aes(cut, price)) +
    geom_boxplot() +
    scale_y_log10()
```

## Gráficos de violín.
```{r}
head(diamonds)

# Este tipo de gráficos tiene una ventaja respecto a los Boxplots, y es que se muestra la frecuencia de los datos.
ggplot(diamonds, aes(cut, price)) +
    geom_violin() +
    scale_y_log10()
```

## Guardar gráficos.
```{r}
ViolinPlot = ggplot(diamonds, aes(cut, price)) +
    geom_violin() +
    scale_y_log10()

jpeg(filename="Plot00.jpeg",   # Nombre del archivo y extension
     height = 11,
     width = 18,
     res= 200,       # Resolucion
     units = "cm")   # Unidades.
ViolinPlot           # Grafico
dev.off()            # Cierre del archivo
```