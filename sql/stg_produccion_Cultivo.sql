--cultivo tenes soja total (soja de primera + 2da) trigo total trigo candeal + otros, girasol, cebada forrajera cebada cervecera incluye Soja 1ra, Soja 2da y Soja desactivada
--cosecha estimada es 2024/2025 te dice que el 2024 se planto y se cosecha y exporta 2025
create or replace view `agroexportador-argentina.exportacion_oleaginosas_cereales_carnes.stg_produccion_cultivos` as 
SELECT
replace(`campaña_estimada`, '/', '-') as campania_estimada,
safe_cast(provincia_nombre as string) as provincia,
safe_cast(provincia_id as integer) as provincia_id,
LOWER(trim(safe_cast(departamento_nombre as string))) as departamento_nombre,
safe_cast(id_cultivo as integer) as id_cultivo,
LOWER(trim(safe_cast(cultivo as string))) as cultivo,
case
  when LOWER(trim(cultivo)) like '%soja%' OR
       LOWER(trim(cultivo)) like '%girasol%' OR
       LOWER(trim(cultivo)) like '%mani%' OR
       LOWER(trim(cultivo)) like '%colza%'  then 'Oleaginosas'
  when 
       LOWER(trim(cultivo)) like '%maiz%' OR
       LOWER(trim(cultivo)) like '%maíz%' OR
       LOWER(trim(cultivo)) like '%sorgo%' OR
       LOWER(trim(cultivo)) like '%cebada%' then 'Cereales'
  Else 'otros'
end as categoria_de_cultivo, 

safe_cast(sup_sembrada as float64) as superficie_sembrada,
safe_cast(sup_cosechada as float64) as superficie_cosechada,
safe_cast(produccion as float64) as produccion_total_de_grano_obtenido,
safe_cast(rendimiento as float64) as rendimiento
FROM `agroexportador-argentina.exportacion_oleaginosas_cereales_carnes.produccion_agricola_2024_2025` 
