
# Este R-tip está relacionado con el uso de series temporales en donde tenemos datos
#diarios de una variable y queremos analizar su variabilidad.
# es decir, nos podemos preguntar: ¿a lo largo de los años como se han comportado los 
#valores diarios de mi variable? y de esta forma poder detectar valores extremos,
# la variabilidad media anual de dicha variable.

# El tema es que para este tipo de gráficos puede ser algo complicado trabajar con las 
#fechas de forma tal que podamos tener en el eje horizontal los meses y en el vertical 
# la variable y cada curva sea un año.

# Es por ello que les traemos este R-tips para facilitarles la búsqueda.
# 


library(tidyverse)
library(lubridate)

# Seguramente se les va a pedir instalar los paquetes MATRIX Y quantreg

u <- "https://raw.githubusercontent.com/juanchiem/agro_data/master/weather_africa.csv"
datos <- rio::import(u)   #HAY QUE INSTALAR EL PAQUETE RIO

datos %>% glimpse  #EXPLORAMOS LA ESTRUCTURA DEL OBJETO datos..MUY IMPORTANTE!!

#aqui vamos al gráfico
datos %>% 
  mutate(date1= update(mdy(date), year = 1800)) %>% 
  ggplot() + 
  aes(
    x=date1,
    # x=julian, 
    y=tmin)+
  geom_point(shape = 1, alpha=0.6, size =1) +
  geom_smooth(se=TRUE)+
  # scale_x_continuous(breaks = seq(0, 365, by = 20))+
  # scale_y_continuous(breaks = seq(0, 30, by = 2))+

  #le agregamos las curvas de cuartiles del paquete MATRIX, 
  # quizas les pedirá actualizar!!
  
  
  geom_quantile(method = "rqss", quantiles=0.95,lambda=20,size=1,colour= "red")+
  geom_quantile(method = "rqss", quantiles=0.05,lambda=20,size=1,colour= "red")+
  theme(axis.text.x = element_text(angle=45, hjust = 1)) + 
  labs(x="", y="Tmin (C)") + 
  scale_x_date(date_breaks="1 month", date_labels="%b")+ 
  theme_bw() + 
  theme(axis.text.x = element_text(angle=45, hjust = 1))

#ESPERAMOS LES SIRVA Y TODO COMENTARIO/SUGERENCIA ES BIENVENIDA!!!


