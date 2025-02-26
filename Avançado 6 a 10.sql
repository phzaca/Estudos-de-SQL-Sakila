-- Questões 6 a 10
-- Nível Avançado

### 6. Liste os atores que participaram de filmes que nunca foram alugados.
-- Condição extra: Inclua o título dos filmes.
SELECT * FROM inventario		-- [filme_id],[inventario_id]
SELECT * FROM aluguel			-- [inventario]
SELECT * FROM filme_ator		-- [filme_id],[ator_id]
SELECT * FROM ator				-- NOME, [ator_id]
SELECT * FROM filme				-- titulo,[filme_id]
-- subconsultas
SELECT inventario.inventario_id,inventario.filme_id
FROM inventario
RIGHT JOIN aluguel ON aluguel.inventario_id = inventario.inventario_id
WHERE aluguel.aluguel_id IS NULL;
#
SELECT CONCAT(ator.primeiro_nome,' ',ultimo_nome) AS ator, 
		filme.titulo, filme.filme_id
FROM filme
JOIN filme_ator ON filme_ator.filme_id = filme.filme_id
JOIN ator ON ator.ator_id = filme_ator.ator_id
-- resolvendo
SELECT sub1.ator, sub1.titulo
FROM (SELECT CONCAT(ator.primeiro_nome,' ',ultimo_nome) AS ator, 
		filme.titulo, filme.filme_id
		FROM filme
		JOIN filme_ator ON filme_ator.filme_id = filme.filme_id
		JOIN ator ON ator.ator_id = filme_ator.ator_id) AS sub1
JOIN (SELECT inventario.inventario_id,inventario.filme_id
		FROM inventario
		RIGHT JOIN aluguel ON aluguel.inventario_id = inventario.inventario_id
		WHERE aluguel.aluguel_id IS NULL) AS sub2 
        ON sub2.filme_id = sub1.filme_id

### 7. Encontre os cinco filmes com a maior quantidade de aluguéis por categoria.
-- Condição extra: Inclua o total de aluguéis e o nome da categoria.
# vou ter q fazer duas CTEs
-- coleta 
SELECT * FROM aluguel			-- COUNT(aluguel_id),[inventario]
SELECT * FROM inventario		-- [filme_id],[inventario]
SELECT * FROM filme				-- titulo, [filme_id]
SELECT * FROM filme_categoria	-- [categoria_id],[filme_id]
SELECT * FROM categoria			-- [categoria_id],nome
-- CTE1 -- colocar [categoria, titulo, aluguéis]
WITH categoria_titulo_quantidade AS (
	SELECT categoria.nome AS categoria, filme.titulo, COUNT(aluguel.aluguel_id) AS quantidade
	FROM aluguel
	JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
	JOIN filme ON filme.filme_id = inventario.filme_id
	JOIN filme_categoria ON filme_categoria.filme_id = filme.filme_id
	JOIN categoria ON categoria.categoria_id = filme_categoria.categoria_id
	GROUP BY filme.titulo, categoria.nome)
-- CTE 2
rankedfilmes AS(
	SELECT categoria, titulo, quantidade,
		ROW_NUMBER() OVER (PARTITION BY categoria ORDER BY quantidade DESC) AS rank
	FROM categoria_titulo_quantidade)
-- consulta final
SELECT categoria, titulo, quantidade
FROM rankedfilmes
WHERE rank <=5
ORDER BY categoria, rank
-- resolvendo
WITH categoria_titulo_quantidade AS (
	SELECT categoria.nome AS categoria, 
		filme.titulo, 
		COUNT(aluguel.aluguel_id) AS quantidade
	FROM aluguel
	JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
	JOIN filme ON filme.filme_id = inventario.filme_id
	JOIN filme_categoria ON filme_categoria.filme_id = filme.filme_id
	JOIN categoria ON categoria.categoria_id = filme_categoria.categoria_id
	GROUP BY filme.titulo, categoria.nome),
rankedfilmes AS(
	SELECT categoria, 
		titulo, 
        quantidade,
		ROW_NUMBER() OVER (PARTITION BY categoria ORDER BY quantidade DESC) AS rankeando
	FROM categoria_titulo_quantidade)
SELECT categoria, titulo, quantidade
FROM rankedfilmes
WHERE rankeando <=5
ORDER BY categoria, rankeando;

### 8. Crie um relatório detalhado mostrando a receita gerada por cada loja, agrupada por mês.
SELECT * FROM pagamento			-- **SUM(valor)**, [aluguel_id], DATA
SELECT * FROM aluguel			-- [aluguel_id],[inventario_id],
SELECT * FROM inventario		-- [inventario_id],loja1e2
-- subconsultas ou CTE
SELECT aluguel.aluguel_id, 
	DATE_FORMAT(pagamento.data_de_pagamento, '%M/%Y') AS mes_ano,
    pagamento.valor
FROM aluguel
JOIN pagamento ON pagamento.aluguel_id = aluguel.aluguel_id
#
SELECT aluguel.aluguel_id,
	inventario.loja_id
FROM aluguel
JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
-- resolvendo
WITH aluguel_mes_valor AS (
	SELECT aluguel.aluguel_id, 
		DATE_FORMAT(pagamento.data_de_pagamento, '%M/%Y') AS mes_ano,
		pagamento.valor AS valor
	FROM aluguel
	JOIN pagamento ON pagamento.aluguel_id = aluguel.aluguel_id
    ),
aluguel_loja AS(
	SELECT aluguel.aluguel_id,
		inventario.loja_id
	FROM aluguel
	JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
	)
SELECT aluguel_mes_valor.mes_ano,
	SUM(CASE WHEN aluguel_loja.loja_id = 1 THEN aluguel_mes_valor.valor ELSE 0 END) AS 'loja 1',
    SUM(CASE WHEN aluguel_loja.loja_id = 2 THEN aluguel_mes_valor.valor ELSE 0 END) AS 'loja 2'
FROM aluguel_mes_valor
JOIN aluguel_loja ON aluguel_loja.aluguel_id = aluguel_mes_valor.aluguel_id
GROUP BY 1
ORDER BY SUM(aluguel_mes_valor.valor) DESC;

### 9. Liste os filmes que possuem mais de três recursos especiais.
-- Condição extra: Exiba o nome dos recursos.
SELECT * FROM filme			-- titulo, LENGTH(CONTAR VIRGULAS),[filme_id]
-- CTEs
SELECT filme_id,
	LENGTH(recursos_especiais) - LENGTH(REPLACE(recursos_especiais, ',', '')) AS contador
FROM filme
-- resolvendo
WITH filme_virgula AS (
	SELECT filme_id,
		LENGTH(recursos_especiais) - LENGTH(REPLACE(recursos_especiais, ',', '')) AS contador
	FROM filme
    )
SELECT filme.titulo, filme.recursos_especiais
FROM filme
JOIN filme_virgula ON filme_virgula.filme_id = filme.filme_id
WHERE filme_virgula.contador >= 2

### 10. Encontre os clientes que realizaram aluguéis em mais de três lojas diferentes.
-- Condição extra: Exiba o total de lojas e aluguéis por cliente.
SELECT * FROM aluguel		-- [cliente_id],[inventario_id]
SELECT * FROM inventario	-- [inventario_id], **loja**
SELECT * FROM cliente 		-- NOME, [cliente]
-- CTEs
SELECT aluguel.cliente_id,
	COUNT(DISTINCT inventario.loja_id) AS lojas
FROM aluguel
JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
GROUP BY aluguel.cliente_id
-- resolvendo
WITH cliente_lojas AS (
	SELECT aluguel.cliente_id,
		COUNT(DISTINCT inventario.loja_id) AS lojas
	FROM aluguel
	JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
	GROUP BY aluguel.cliente_id
)
SELECT CONCAT(cliente.primeiro_nome,' ',cliente.ultimo_nome) AS cliente, 
	cliente_lojas.lojas
FROM cliente_lojas
JOIN cliente ON cliente.cliente_id = cliente_lojas.cliente_id
WHERE cliente_lojas.lojas > 3







