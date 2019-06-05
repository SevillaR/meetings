# Instalación de sparklyr
install.packages("sparklyr")

# Cargamos la libreria ..,
library(sparklyr)


# Para consultar las versiones de spark disponibles
spark_available_versions()

# Para instalar una versión concreta
spark_install(version = "2.0.1", hadoop_version = "2.7",verbose = T)

# Comprobamos la instalación
spark_installed_versions()


# Definición de la variables de entorno 
Sys.setenv(JAVA_HOME="")
Sys.getenv("JAVA_HOME")

Sys.setenv(HADOOP_CMD="") # en local


# cargamos las librerias y conectamos realizamos la conexión con spark
library(dplyr)
library(ggplot2)
library(tidyr)


set.seed(100)

#Conectar a versión local
sc = spark_connect(master="local")

#' Ejemplo de configuración de spark
#' config = spark_config()
#' config$spark.executor.cores = 2
#' config$spark.executor.memory = "4G"
#' sc = spark_connect(master="yarn-client", config = config,
#'                   version="2.0.1")


#Copia datos en memoria de Spark (de dplyr) y anota referencia.
import_iris = copy_to(sc,iris,"spark_iris",overwrite=TRUE)

#Define partición de los datos
partition_iris=sdf_random_split(import_iris,training=0.5,testing=0.5)

#Crea metadatos Hive para cada partición
sdf_register(partition_iris,c("spark_iris_training",
                              "spark_iris_test"))

#Seleccionamos columnas
tidy_iris = tbl(sc,"spark_iris_training") %>%
  select(Species, Petal_Length, Petal_Width)

# K-Means clustering

kmeans_model <- tidy_iris %>%
  select(Petal_Width, Petal_Length) %>%
  mutate(Species = as.factor(Species)) %>% 
  ml_kmeans(Species ~ Petal_Length + Petal_Width, k=3)

# Imprimiemos nuestro modelo
kmeans_model


#Crea referencia a tabla Spark
test_iris <- tbl(sc,"spark_iris_test")


# Lo vemos gráficamente.
ml_predict(kmeans_model) %>%
  collect() %>%
  ggplot(aes(Petal_Length, Petal_Width)) +
  geom_point(aes(Petal_Width, Petal_Length, col = factor(prediction + 1)),
             size = 2, alpha = 0.5) + 
  geom_point(data = kmeans_model$centers, aes(Petal_Width, Petal_Length),
             col = scales::muted(c("red", "green", "blue")),
             pch = 'x', size = 12) +
  scale_color_discrete(name = "Predicted Cluster",
                       labels = paste("Cluster", 1:3)) +
  labs(
    x = "Petal Length",
    y = "Petal Width",
    title = "K-Means Clustering",
    subtitle = "Use Spark.ML to predict cluster membership with the iris dataset."
  )

#Modelo random forest Spark ML
model_rf <- tidy_iris %>%
  ml_random_forest(Species ~ Petal_Length + Petal_Width, type = "classification")

#Trae datos de vuelta a memoria de R para crear gráfico
rf_predict <- ml_predict(model_rf, test_iris) %>%
  collect()

# Creemos una tabla.
table(rf_predict$Species, rf_predict$prediction)


# perceptron
model_per <- tidy_iris %>% ml_multilayer_perceptron_classifier(Species ~ Petal_Length + Petal_Width, 
                                                   c(2, 5, 3), 
                                                   seed = sample(.Machine$integer.max, 1))

#Trae datos de vuelta a memoria de R para crear gráfico
per_predict <- ml_predict(model_per, test_iris) %>%
  collect()

# Creemos una tabla.
table(per_predict$Species, per_predict$prediction)


#Desconexión
spark_disconnect(sc)
