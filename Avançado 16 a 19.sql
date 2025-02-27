### 16. Liste as lojas com maior número de clientes ativos e o total de pagamentos realizados por esses clientes.
-- Condição extra: Exiba também a média de pagamentos por cliente.
SELECT * FROM cliente				-- WHERE ativo = 1, [cliente_id]
SELECT * FROM pagamento 			-- [cliente_id]
-- resolvendo 
SELECT cliente.loja_id AS loja,
	COUNT(cliente.cliente_id) AS clientes,
	SUM(pagamento.valor) AS 'total pago',
	ROUND(AVG(pagamento.valor),2) AS 'média pagamento'
FROM cliente 
JOIN pagamento ON pagamento.cliente_id = cliente.cliente_id
WHERE cliente.ativo = 1	
GROUP BY loja
					UNION ALL 
SELECT 'Total' AS loja,
	COUNT(cliente.cliente_id) AS clientes,
	SUM(pagamento.valor) AS 'total pago',
	ROUND(AVG(pagamento.valor),2) AS 'média pagamento'
FROM cliente 
JOIN pagamento ON pagamento.cliente_id = cliente.cliente_id
WHERE cliente.ativo = 1	

### 17. Encontre os clientes que realizaram mais de 10 aluguéis em um único mês.
-- Condição extra: Exiba o total de aluguéis realizados e o mês correspondente.
SELECT * FROM aluguel		-- [cliente_id], COUNT(aluguel_id), DATA(data_de_aluguel)
SELECT * FROM cliente		-- [cliente_id], NOME
-- resolvendo
SELECT CONCAT(cliente.primeiro_nome,' ',cliente.ultimo_nome) AS cliente,
	COUNT(aluguel.aluguel_id) AS aluguéis,
	DATE_FORMAT(aluguel.data_de_aluguel,'%M/%Y') AS mes_ano 
FROM cliente
JOIN aluguel ON aluguel.cliente_id = cliente.cliente_id
GROUP BY cliente.cliente_id, DATE_FORMAT(aluguel.data_de_aluguel,'%M/%Y')
HAVING COUNT(aluguel.aluguel_id) >10
ORDER BY 1 

### 18. Crie um relatório detalhado com o total de filmes em inventário por loja e por categoria.
-- Condição extra: Exiba o nome da categoria e o total geral por loja.
SELECT * FROM inventario		-- *loja_id*, [filme_id]
SELECT * FROM filme_categoria	-- [categoria_id], [filme_id]
SELECT * FROM categoria 		-- NOME
-- resolvendo
SELECT categoria.nome AS categoria,
	COUNT(CASE WHEN inventario.loja_id = 1 THEN 1 END) AS 'loja 1',
	COUNT(CASE WHEN inventario.loja_id = 2 THEN 1 END) AS 'loja 2'
FROM inventario 
JOIN filme_categoria ON filme_categoria.filme_id = inventario.filme_id
JOIN categoria ON categoria.categoria_id = filme_categoria.categoria_id
GROUP BY categoria.nome
							UNION ALL
SELECT 'Total' AS categoria,
	COUNT(CASE WHEN inventario.loja_id = 1 THEN 1 END) AS 'loja 1',
	COUNT(CASE WHEN inventario.loja_id = 2 THEN 1 END) AS 'loja 2'
FROM inventario 
JOIN filme_categoria ON filme_categoria.filme_id = inventario.filme_id
JOIN categoria ON categoria.categoria_id = filme_categoria.categoria_id

### 19. Liste os filmes que possuem classificação "PG-13" e foram alugados em mais de duas lojas.
-- Condição extra: Exiba o total de aluguéis por loja.
SELECT * FROM filme			-- [filme_id], *classificacao*,titulo
SELECT * FROM inventario 	-- [filme_id],[inventario_id], **loja_id**
SELECT * FROM aluguel 		-- [inventario_id], COUNT(aluguel_id)
-- CTE
SELECT inventario.inventario_id,
	inventario.filme_id,
	COUNT(aluguel.aluguel_id) AS qntd,
	inventario.loja_id
FROM aluguel
JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
GROUP BY inventario.inventario_id
-- resolvendo
WITH invt_film_cont AS (
	SELECT inventario.inventario_id,
		inventario.filme_id,
		COUNT(aluguel.aluguel_id) AS qntd,
		inventario.loja_id
	FROM aluguel
	JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
	GROUP BY inventario.inventario_id
)
SELECT filme.titulo,
	SUM(CASE WHEN invt_film_cont.loja_id = 1 THEN invt_film_cont.qntd END) AS 'loja 1',
	SUM(CASE WHEN invt_film_cont.loja_id = 2 THEN invt_film_cont.qntd END) AS 'loja 2'
FROM filme
JOIN invt_film_cont ON invt_film_cont.filme_id = filme.filme_id 
WHERE filme.classificacao = 'PG-13'
GROUP BY filme.titulo
		UNION ALL
SELECT 'Total' AS titulo,
	SUM(CASE WHEN invt_film_cont.loja_id = 1 THEN invt_film_cont.qntd END) AS 'loja 1',
	SUM(CASE WHEN invt_film_cont.loja_id = 2 THEN invt_film_cont.qntd END) AS 'loja 2'
FROM filme
JOIN invt_film_cont ON invt_film_cont.filme_id = filme.filme_id 
WHERE filme.classificacao = 'PG-13'






	


