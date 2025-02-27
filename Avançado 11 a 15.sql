### 11. Encontre os funcionários que mais processaram pagamentos.
-- Condição extra: Exiba o total de pagamentos processados e a loja onde trabalham.
SELECT * FROM pagamento			-- COUNT(pagament_id),[funcionario_id]
SELECT * FROM funcionario		-- NOME, [funcionario_id]
-- resolvendo
SELECT CONCAT(funcionario.primeiro_nome,' ',funcionario.ultimo_nome) AS 'nome do funcionário',
	COUNT(pagamento.pagamento_id) AS 'pagamentos processados'
FROM pagamento 
JOIN funcionario ON funcionario.funcionario_id = pagamento.funcionario_id
GROUP BY 1

### 12. Liste os filmes que possuem classificação "R" e foram alugados mais de 20 vezes.
-- Condição extra: Exiba também a receita total gerada por esses filmes.
SELECT * FROM filme				-- WHERE classificação = R, [filme_id ], titulo
SELECT * FROM aluguel			-- WHERE COUNT(aluguel_id), [inventario_id]
SELECT * FROM pagamento 		-- SUM(valor), [aluguel_id]
SELECT * FROM inventario		-- [filme_id], [inventario_id]
-- resolvendo
WITH filme_contador AS (
		SELECT inventario.filme_id, COUNT(aluguel.aluguel_id) AS quantidade
		FROM aluguel
		JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
		GROUP BY inventario.filme_id
),
filme_receita AS(
	SELECT inventario.filme_id,
		SUM(pagamento.valor) AS receita
	FROM inventario
	JOIN aluguel ON aluguel.inventario_id = inventario.inventario_id
	JOIN pagamento ON pagamento.aluguel_id = aluguel.aluguel_id
	GROUP BY inventario.filme_id
)
SELECT filme.titulo,
	filme_contador.quantidade,
	filme_receita.receita
FROM filme
JOIN filme_contador ON filme_contador.filme_id = filme.filme_id
JOIN filme_receita ON filme_receita.filme_id = filme.filme_id
WHERE filme_contador.quantidade > 20
	AND filme.classificacao = 'R';

### 13. Crie um relatório mostrando a receita mensal de aluguéis para cada categoria de filme.
-- Condição extra: Inclua o total de receita anual por categoria.
SELECT * FROM categoria				-- nome, [categoria_id]
SELECT * FROM filme_categoria		-- [categoria_id], [filme_id]
SELECT * FROM inventario 			-- [filme_id], [inventario_id]
SELECT * FROM aluguel				-- [inventario_id],[aluguel_id]
SELECT * FROM pagamento				-- [aluguel_id], SUM(VALOR), DATA
-- CTE
SELECT categoria.nome AS categoria, 
	DATE_FORMAT(pagamento.data_de_pagamento,'%M/%Y') AS mes_ano,
	SUM(pagamento.valor) AS receita	
FROM categoria
JOIN filme_categoria ON filme_categoria.categoria_id = categoria.categoria_id
JOIN inventario ON inventario.filme_id = filme_categoria.filme_id
JOIN aluguel ON aluguel.inventario_id = inventario.inventario_id
JOIN pagamento ON pagamento.aluguel_id = aluguel.aluguel_id
GROUP BY categoria.nome, mes_ano
ORDER BY 1, MIN(pagamento.data_de_pagamento);

### 14. Liste os clientes que realizaram aluguéis de filmes de categorias "Horror" e "Comédia" no mesmo mês.
-- Condição extra: Exiba também o número total de aluguéis de cada categoria.
SELECT * FROM aluguel			-- [inventario_id],[cliente_id], DATA 
SELECT * FROM inventario 		-- [filme_id],[inventario_id]
SELECT * FROM filme_categoria 	-- [filme_id],[categoria_id]
SELECT * FROM categoria 		-- *nome*
SELECT * FROM cliente 			-- NOMEcliente
-- CTE
SELECT inventario.inventario_id,
	categoria.nome
FROM inventario 
JOIN filme_categoria ON filme_categoria.filme_id = inventario.filme_id
JOIN categoria ON categoria.categoria_id = filme_categoria.categoria_id
#
SELECT CONCAT(cliente.primeiro_nome,' ',cliente.ultimo_nome) AS cliente,
	DATE_FORMAT(aluguel.data_de_aluguel,'%M/%Y') AS mes_ano,
	aluguel.inventario_id
FROM aluguel
JOIN cliente ON cliente.cliente_id = aluguel.cliente_id
-- resolvendo
WITH inventario_categoria AS(
	SELECT inventario.inventario_id,
		categoria.nome
	FROM inventario 
	JOIN filme_categoria ON filme_categoria.filme_id = inventario.filme_id
	JOIN categoria ON categoria.categoria_id = filme_categoria.categoria_id
),
cliente_mes_inventario AS (
	SELECT CONCAT(cliente.primeiro_nome,' ',cliente.ultimo_nome) AS cliente,
		DATE_FORMAT(aluguel.data_de_aluguel,'%M/%Y') AS mes_ano,
		aluguel.inventario_id
	FROM aluguel
	JOIN cliente ON cliente.cliente_id = aluguel.cliente_id
)
SELECT cliente_mes_inventario.cliente,
	COUNT(CASE WHEN inventario_categoria.nome  = 'Comedy' THEN 1 END) AS Comédia,
	COUNT(CASE WHEN inventario_categoria.nome  = 'Horror' THEN 1 END) AS Horror,
	cliente_mes_inventario.mes_ano
FROM cliente_mes_inventario 
JOIN inventario_categoria ON inventario_categoria.inventario_id = cliente_mes_inventario.inventario_id
GROUP BY 1 , 4
HAVING (Comédia>0) OR (Horror>0)
ORDER BY MIN(cliente_mes_inventario.mes_ano) ASC;

### 15. Encontre os filmes com duração maior que 120 minutos que nunca foram alugados.
-- Condição extra: Exiba o custo de substituição desses filmes.
SELECT * FROM filme				-- WHERE(duracao_do_filme), [filme_id],titulo
SELECT * FROM inventario		-- [filme_id],[inventario_id]
SELECT * FROM aluguel			-- [inventario_id] *****
-- resolvendo
SELECT filme.titulo
FROM filme 
JOIN inventario ON inventario.filme_id = filme.filme_id
LEFT JOIN aluguel ON aluguel.inventario_id = inventario.inventario_id
WHERE aluguel.aluguel_id IS NULL
	AND filme.duracao_do_filme > 120










