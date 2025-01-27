# 1- Quais poluentes foram considerados na pesquisa?
SELECT DISTINCT(pollutant)
FROM projetosql.TB_GLOBAL_QUALIDADE_AR;


# 2- Qual foi a média de poluição ao longo do tempo provocada pelo poluente ground-level ozone (o3)?
SELECT country AS pais,
       CAST(timestamp AS DATE) AS data_coleta,
       ROUND(AVG(value) OVER(PARTITION BY country ORDER BY CAST(timestamp AS DATE)), 2) AS media_valor_poluicao
FROM projetosql.TB_GLOBAL_QUALIDADE_AR
WHERE pollutant = 'o3'
ORDER BY country, data_coleta;

# 3- Qual foi a média de poluição causada pelo poluente ground-level ozone (o3) por país medida em µg/m³ (microgramas por metro cúbico)?
SELECT country AS pais, 
       ROUND(AVG(value),2) AS media_poluicao
FROM projetosql.TB_GLOBAL_QUALIDADE_AR
WHERE pollutant = 'o3'
AND unit = 'µg/m³'
GROUP BY country
ORDER BY media_poluicao ASC;


# 4- Considerando o resultado anterior, qual país teve maior índice de poluição geral por o3 ? 
SELECT country AS pais, 
       ROUND(AVG(value),2) AS media_poluicao, 
       STDDEV(value) AS desvio_padrao, 
       MAX(value) AS valor_maximo, 
       MIN(value) AS valor_minimo,
       (STDDEV(value) / ROUND(AVG(value),2)) * 100 AS cv
FROM projetosql.TB_GLOBAL_QUALIDADE_AR
WHERE pollutant = 'o3'
AND unit = 'µg/m³'
AND country IN ('IT', 'ES') 
GROUP BY country
ORDER BY media_poluicao ASC;

# 5- Quais localidades e países tiveram média de poluição em 2020 superior a 100 µg/m³ para o poluente fine particulate matter (pm25)?
SELECT COALESCE(location, "Total") AS localidade,
	COALESCE(country, "Total") AS pais, 
       ROUND(AVG(value), 2) AS media_poluicao
FROM projetosql.TB_GLOBAL_QUALIDADE_AR
WHERE pollutant = 'pm25'
AND YEAR(timestamp) = 2020
GROUP BY location, country WITH ROLLUP
HAVING media_poluicao > 100
ORDER BY location, country;