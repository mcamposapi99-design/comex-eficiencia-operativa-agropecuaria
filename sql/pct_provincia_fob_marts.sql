create or replace view `agroexportador-argentina.exportacion_oleaginosas_cereales_carnes.marts_representacion_pct_prov` as 
WITH base_unificada AS (
  SELECT
    a.fecha_de_cosecha,
    a.provincia,
    CASE 
        WHEN cultivo IN ('girasol', 'soja 1ra', 'soja 2da') THEN 'Oleaginosas'
        WHEN cultivo IN ('trigo candeal', 'cebada cervecera', 'cebada forrajera') THEN 'Cereales'
        ELSE 'Otros'
    END AS rubro,
    SUM(a.total_granos) AS total_tn_provincia,
    -- Traemos el FOB Nacional una sola vez por rubro
    MAX(b.oleaginosas_fob_total_M_USD * 1000000) AS fob_nacional_oleaginosas,
    MAX(b.cereales_fob_total_M_USD * 1000000) AS fob_nacional_cereales
  FROM `agroexportador-argentina.exportacion_oleaginosas_cereales_carnes.marts_produccion_rendimiento_provincia` AS a 
  LEFT JOIN `agroexportador-argentina.exportacion_oleaginosas_cereales_carnes.marts_exportaciones_M_usd_fob` AS b
    ON a.fecha_de_cosecha = b.anio
  GROUP BY 1, 2, 3
),

participacion_calculada AS (
  SELECT 
    *,
    -- Calculamos el total de producción nacional por rubro y año para sacar el %
    SUM(total_tn_provincia) OVER(PARTITION BY fecha_de_cosecha, rubro) AS total_tn_nacional_rubro
  FROM base_unificada
)

SELECT
  fecha_de_cosecha,
  provincia,
  rubro,
  total_tn_provincia,
  -- 1. Sacamos el % de participación de la provincia en la producción nacional
  ROUND(SAFE_DIVIDE(total_tn_provincia, total_tn_nacional_rubro) , 2) AS pct_participacion_produccion,
  fob_nacional_oleaginosas,
  fob_nacional_cereales
FROM participacion_calculada
WHERE rubro != 'Otros'