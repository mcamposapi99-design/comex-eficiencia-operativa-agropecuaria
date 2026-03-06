--create or replace view `agroexportador-argentina.exportacion_oleaginosas_cereales_carnes.marts_produccion_rendimiento_provincia` as
with total_sembrado_cosechado_x_provincia as (
SELECT 
campania_estimada,
provincia,
cultivo,
sum(superficie_sembrada) as total_sembrado,
sum(superficie_cosechada) as total_cosechado,
sum(produccion_total_de_grano_obtenido)as total_granos
FROM `agroexportador-argentina.exportacion_oleaginosas_cereales_carnes.stg_produccion_cultivos`
group by provincia, cultivo,campania_estimada
having cultivo not in ('soja total', 'trigo total')
),
eficiencia_x_provincia_x_cultivo as (
SELECT
  campania_estimada,
  left(campania_estimada, 4) as fecha_de_siembra,
  replace(right(campania_estimada, 2),'25','2025') as fecha_de_cosecha,
  provincia,
  cultivo,
  total_sembrado,
  total_cosechado,
  total_granos,
  round((total_cosechado/total_sembrado),3) as rendimiento_de_tierra_ha,
  round(total_granos *1000 /total_cosechado,3) as rendimiento_kg_por_ha
FROM
  total_sembrado_cosechado_x_provincia
  where total_cosechado != 0
  AND total_granos != 0
) 


select 
*,
rank() over(partition by fecha_de_cosecha order by rendimiento_de_tierra_ha desc, rendimiento_kg_por_ha desc) as ranking
from eficiencia_x_provincia_x_cultivo 