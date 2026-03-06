create or replace view `agroexportador-argentina.exportacion_oleaginosas_cereales_carnes.stg_exportacion_FOB` as 
SELECT 
safe_cast(fecha as datetime) as fecha_de_exportacion,
round(safe_cast(Oleaginosas as float64),4) as oleaginosas_fob_total_M_USD,
round(safe_cast(Cereales as float64),4) as cereales_fob_total_M_USD,
round(safe_cast(carnes as float64),4) as carnes_fob_total_M_USD

FROM `agroexportador-argentina.exportacion_oleaginosas_cereales_carnes.exportaciones_agro_3anios` 