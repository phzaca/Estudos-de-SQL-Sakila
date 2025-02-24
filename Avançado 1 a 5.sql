-- Questões 1 a 5
-- Nível Avançado

### 1. Encontre os clientes que realizaram aluguéis consecutivos (mesmo cliente, datas de devolução e aluguel).
-- Condição extra: Exiba o ID do cliente e a quantidade de aluguéis consecutivos.
SELECT * FROM aluguel 				-- [cliente_id], [datas], COUNT(aluguel_id)
SELECT * FROM cliente				-- CONCAT(nome)  		#CAPRICHO
-- resolvendo
SELECT CONCAT(cliente.primeiro_nome,' ',cliente.ultimo_nome) AS cliente ,
		DATE(aluguel.data_de_aluguel) AS aluguel, 
        DATE(aluguel.data_de_devolucao) AS devolução , 
        COUNT(aluguel.aluguel_id) AS 'aluguéis consecutivos'
FROM aluguel
JOIN cliente ON cliente.cliente_id = aluguel.cliente_id
GROUP BY aluguel.cliente_id, aluguel, devolução
ORDER BY COUNT(aluguel.aluguel_id) DESC;

### 2. Liste os três países com o maior número de clientes registrados.
-- Condição extra: Inclua a porcentagem do total de clientes de cada país.
SELECT * FROM endereco				-- [cidade_id], COUNT(endereco_id)
SELECT * FROM cidade				-- [cidade_id],[pais_id]
SELECT * FROM pais					-- [pais_id],pais
-- resolvendo
SELECT pais.pais, COUNT(endereco.endereco_id) AS 'quantidade de clientes'
FROM endereco
JOIN cidade ON cidade.cidade_id = endereco.cidade_id
JOIN pais ON pais.pais_id = cidade.pais_id
GROUP BY pais.pais
ORDER BY 2 DESC
LIMIT 3;

### 3. Crie um relatório mostrando o total de aluguéis por gênero de filme em cada loja.
-- Condição extra: Inclua também o número de clientes por gênero.
SELECT * FROM aluguel 					-- COUNT(aluguel_id), [inventario]
SELECT * FROM inventario				-- **verificador de loja**, [filme_id], [inventario_id]
SELECT * FROM filme_categoria			-- [filme_id], [categoria_id]
SELECT * FROM categoria 				-- nome, [categoria_id]
-- resolvendo
SELECT categoria.nome AS categoria, 
		COUNT(CASE WHEN inventario.loja_id = 1 THEN 1 END) AS 'loja 1',
        COUNT(CASE WHEN inventario.loja_id = 2 THEN 1 END) AS 'loja 2'
FROM aluguel
JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
JOIN filme_categoria ON filme_categoria.filme_id = inventario.filme_id
JOIN categoria ON  categoria.categoria_id = filme_categoria.categoria_id
GROUP BY 1
ORDER BY 1 ASC;

### 4. Encontre os clientes que mais gastaram em pagamentos.
-- Condição extra: Exiba o total gasto e o nome da loja onde mais alugaram.
SELECT * FROM pagamento 			-- SUM(valor), [aluguel_id]
SELECT * FROM aluguel				-- [cliente_id],[aluguel_id], [inventario_id]
SELECT * FROM cliente				-- NOME, [cliente_id]
SELECT * FROM inventario			-- [inventario_id]
-- subconsultas, pra estudo de caso
SELECT aluguel.cliente_id, 
		COUNT(CASE WHEN inventario.loja_id = 1 THEN 1 END) AS loja_1,
        COUNT(CASE WHEN inventario.loja_id = 2 THEN 1 END) AS loja_2
FROM aluguel
JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
GROUP BY aluguel.cliente_id
-- resolvendo
SELECT CONCAT(cliente.primeiro_nome,' ',cliente.ultimo_nome) AS cliente, 
	SUM(pagamento.valor) AS valor, 
    CASE WHEN sub.loja_1 > sub.loja_2 THEN 'loja 1' 
		ELSE 'loja 2' 
	END AS 'loja predileta'
FROM (SELECT aluguel.cliente_id, 
		COUNT(CASE WHEN inventario.loja_id = 1 THEN 1 END) AS loja_1,
        COUNT(CASE WHEN inventario.loja_id = 2 THEN 1 END) AS loja_2
FROM aluguel
JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
GROUP BY aluguel.cliente_id
) AS sub
JOIN aluguel ON aluguel.cliente_id = sub.cliente_id
JOIN pagamento ON pagamento.aluguel_id = aluguel.aluguel_id
JOIN cliente ON cliente.cliente_id = sub.cliente_id
GROUP BY cliente.cliente_id
ORDER BY valor DESC;

### 5. Qual é o mês com maior receita de aluguéis?
-- Condição extra: Exiba também o total por loja.
SELECT * FROM pagamento			-- SUM(valor),[aluguel_id]
SELECT * FROM aluguel			-- [aluguel_id],[inventario_id]
SELECT * FROM inventario 		-- [inventario_id], **LOJA**
-- sub consultas de estudo
SELECT aluguel_id,DATE_FORMAT(data_de_pagamento,'%M/%Y') AS 'Mês/Ano',pagamento.valor AS valor
FROM pagamento
# 
SELECT aluguel.aluguel_id, inventario.loja_id
FROM aluguel
JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
-- resolvendo 
SELECT sub_1.mes_ano AS 'Mês/Ano', 
    SUM(CASE WHEN sub_2.loja_id = 1 THEN sub_1.valor ELSE 0 END) AS "loja 1",
    SUM(CASE WHEN sub_2.loja_id = 2 THEN sub_1.valor ELSE 0 END) AS "loja 2"
FROM (SELECT aluguel_id,DATE_FORMAT(data_de_pagamento,'%M/%Y') AS mes_ano ,pagamento.valor AS valor FROM pagamento) AS sub_1
JOIN (SELECT aluguel.aluguel_id, inventario.loja_id FROM aluguel JOIN inventario ON inventario.inventario_id = aluguel.inventario_id) AS sub_2 ON sub_2.aluguel_id = sub_1.aluguel_id
GROUP BY 1
ORDER BY SUM(sub_1.valor) DESC;
