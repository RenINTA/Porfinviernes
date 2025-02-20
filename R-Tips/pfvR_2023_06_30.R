
# Cada cultivo de grano tiene su humedad standard de recibo, por ej. el girasol se recibe a 11% de humedad.
# Ademas, el girasol puede obtener bonificaciones por el contenido de aceite, 
# esto es: para valores superiores a 42% se bonifica a razón de 2% mas de rendimiento por cada punto %.
# http://www.agro.unc.edu.ar/~wpweb/cereales/wp-content/uploads/sites/31/2018/07/TABLA-TIPIFICACION-Calidad-Comercial-de-granos.pdf

# Al presentar resultados de ensayos de girasol es común ver el rendimiento ajustado a 11% y sobre este, 
# se aplica la bonificación correspondiente según % de aceite. 

# Al tratarse de un cálculo de rutina, nos conviene tener a mano funciones que nos faciliten los cálculos 
# en algun script. Veamos como hariamos esas funciones

# (Siempre es bueno verificar en un Hoja de cálculo de excel como este link)
# https://docs.google.com/spreadsheets/d/1WqLNuOCriRdXaND7xF3OZL939WaaJl_Iy-kzc6jmoOo/edit?usp=sharing

# Paquetes
library(tidyverse)
library(ggrepel) # para evitar solapamiento de etiquetas

# Datos de prueba
dat <- tibble::tribble(
  ~trt, ~rep, ~rinde_cosecha, ~humedad_a_cosecha, ~aceite_porc,
  1,    1,           3011,                9.1,         53.2,
  2,    1,           3200,                8.8,         54.3,
  3,    1,           3004,               11.2,         53.5,
  4,    1,           2450,                 11,         53.2,
  2,    2,           2900,               11.9,         53.2,
  3,    2,           2850,               10.9,         54.3,
  4,    2,           2467,               10.8,         53.5,
  1,    2,           3001,               10.8,         53.2
)

# funcion para ajustar rinde por humedad

ajustar_por_humedad <- function(rinde_cosecha, humedad_a_cosecha, hum_recibo){
  agua <- rinde_cosecha*humedad_a_cosecha/100
  rinde_seco <- rinde_cosecha - agua 
  factor_ajuste <- 1-hum_recibo/100
  rinde_aj_comercial <- rinde_seco/factor_ajuste
}

# poniendo a prueba la funcion 
dat %>% 
  mutate(rinde_aj_humedad = ajustar_por_humedad(rinde_cosecha, humedad_a_cosecha, hum_recibo=11))



# funcion para ajustar rinde por bonificacion 

ajustar_por_aceite <- function(rinde_aj_humedad, aceite_porcen){
  bonificacion <- 1+((aceite_porcen-42)*2)/100
  rinde_bonificado <- rinde_aj_humedad * bonificacion
}

# Actualizando el set de datos
dat <- dat %>% 
  mutate(rinde_aj_humedad = ajustar_por_humedad(rinde_cosecha, humedad_a_cosecha, hum_recibo=11),
         rinde_bonificado = ajustar_por_aceite(rinde_aj_humedad, aceite_porc))


# Grafico!!!
dat %>%
  pivot_longer(starts_with("rinde")) %>% 
  ggplot() + 
  aes(x=trt, group=interaction(rep, name), linetype=factor(rep), y = value, color = name) +
  geom_point() + 
  geom_line(stat = "summary", fun = mean) +
  geom_text_repel(aes(label = after_stat(y) %>% round()), show.legend = F, size=3) +
  labs(linetype="Rep", color = "Rinde")

# Una forma práctica de disponibilizar funciones es mediante source(script_con_funciones.R), y este puede 
# estar alojado en nuestras propias PCs o bien en algun repositorio online como en este caso. Para eso 
# necesitamos tener instalado el paquete "devtools"

devtools::source_url("https://github.com/RenINTA/Porfinviernes/blob/main/R-Tips/rinde_ajustado.R")
