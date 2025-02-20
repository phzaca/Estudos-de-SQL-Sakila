-- Questões de 11 a 20
-- Nível Intermedíario
### 11. Liste os atores que aparecem em filmes de duas ou mais categorias diferentes.
-- Condição extra: Exiba os nomes das categorias.
SELECT * FROM filme_categoria		-- [filme_id] , contar categoria distintas
SELECT * FROM filme_ator			-- [filme_id],[ator_id]
SELECT * FROM ator					-- concat (nome), [ator_id]
-- resolvendo
SELECT CONCAT(ator.primeiro_nome,' ',ator.ultimo_nome) AS ator, COUNT(DISTINCT filme_categoria.categoria_id) AS quantidade
FROM filme_ator
JOIN filme_categoria ON filme_categoria.filme_id = filme_ator.filme_id
JOIN ator ON ator.ator_id = filme_ator.ator_id
GROUP BY filme_ator.ator_id
HAVING COUNT(DISTINCT filme_categoria.categoria_id) >2
ORDER BY quantidade ASC;

### 12. Encontre o total de pagamentos realizados por mês no ano de 2006.
-- Condição extra: Ordene os meses em ordem cronológica.
SELECT * FROM pagamento 			-- extrair as datas , COUNT(pagamento_id), SUM(valor) [caprixo]
-- resolvendo
SELECT COUNT(pagamento_id) AS quantidade, MONTH(data_de_pagamento) AS mês, SUM(valor) AS receita
FROM pagamento
WHERE YEAR(data_de_pagamento) = 2006
GROUP BY MONTH(data_de_pagamento)
ORDER BY MONTH(data_de_pagamento) ASC;

### 13. Liste os clientes que realizaram aluguéis em mais de uma loja.
-- Condição extra: Exiba o total de aluguéis por loja para cada cliente.
SELECT * FROM inventario		-- [inventario],COUNT(DISTINCT loja_id)
SELECT * FROM aluguel			-- [inventario],[cliente_id]
SELECT * FROM cliente			-- [cliente_id],CONCAT(nome)
-- resolvendo
SELECT CONCAT(cliente.primeiro_nome, ' ',cliente.ultimo_nome) AS nome
FROM cliente
JOIN aluguel ON aluguel.cliente_id = cliente.cliente_id
JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
GROUP BY cliente.cliente_id
HAVING COUNT(DISTINCT inventario.loja_id) > 1
ORDER BY nome ASC;

### 14. Qual a duração média dos filmes da categoria "Horror"?
-- Condição extra: Inclua o total de filmes considerados no cálculo.
SELECT * FROM filme					-- [filme_id], AVG(duracao_do_filme), COUNT(filme_id)
SELECT * FROM filme_categoria		-- [categoria_id],[filme_id]
SELECT * FROM categoria				-- nome="HORROR"
-- resolvendo
SELECT ROUND(AVG(filme.duracao_do_filme),2) AS média_de_duracao, COUNT(filme.filme_id) AS quantidade_de_filme
FROM filme
JOIN filme_categoria ON filme_categoria.filme_id = filme.filme_id
JOIN categoria ON categoria.categoria_id = filme_categoria.categoria_id
WHERE categoria.nome = 'HORROR';

### 15. Liste os funcionários que processaram mais de 50 pagamentos.
-- Condição extra: Exiba o total de pagamentos processados por cada funcionário.
SELECT * FROM pagamento			-- [funcionário_id], COUNT(pagamento_id), SUM(valor)
SELECT * FROM funcionario		-- [funcionario_id], CONCAT(NOME)
-- resolvendo
SELECT 
	CONCAT(funcionario.primeiro_nome,' ',funcionario.ultimo_nome)AS nome, 
	COUNT(pagamento.pagamento_id) AS Quantidade_de_processamento, 
    SUM(pagamento.valor) AS valor_processado
FROM pagamento
JOIN funcionario ON funcionario.funcionario_id = pagamento.funcionario_id
GROUP BY funcionario.funcionario_id
HAVING COUNT(pagamento.pagamento_id) > 50;

### 16. Liste os filmes que possuem custo de substituição acima da média.
-- Condição extra: Exiba também o custo de substituição médio.
SELECT * FROM filme				-- titulo, custo_de_substituicao, AVG(CUSTO)
-- resolvendo
SELECT titulo, custo_de_substituicao, 
	(SELECT ROUND(AVG(custo_de_substituicao),2) FROM filme) AS media_custo_sub
FROM filme
WHERE custo_de_substituicao > (SELECT AVG(custo_de_substituicao) FROM filme)
ORDER BY custo_de_substituicao ASC;

### 17. Encontre os clientes que nunca realizaram um pagamento.
-- Condição extra: Liste também a data de criação desses clientes.
SELECT * FROM  pagamento		-- [cliente_id]
SELECT * FROM  cliente			-- concat(nome), data_de_criacao, [cliente_id]
SELECT COUNT(DISTINCT cliente_id) FROM pagamento
SELECT COUNT(DISTINCT cliente_id) FROM cliente		-- fui testar pq achei estranho o resultado vazio
-- resolvendo
SELECT CONCAT(cliente.primeiro_nome,' ',cliente.ultimo_nome) AS nome , cliente.data_criacao
FROM cliente
LEFT JOIN pagamento ON cliente.cliente_id = pagamento.cliente_id
WHERE pagamento.cliente_id IS NULL;

### 18. Liste os filmes que possuem mais de um recurso especial.
-- Condição extra: Exiba os recursos especiais de cada filme.
SELECT * FROM filme			-- tive a ideia de caçar as virgulas
-- resolvendo
SELECT titulo, recursos_especiais
FROM filme
WHERE recursos_especiais LIKE '%,%';

### 19. Liste os países que possuem mais de 10 cidades registradas.
-- Condição extra: Inclua o total de cidades por país.
SELECT * FROM cidade 		-- [pais_id], count(cidade)
SELECT * FROM pais			-- [pais_id], nome
-- resolvendo
SELECT pais.pais, COUNT(cidade.cidade) AS quantidade_cidade
FROM cidade
JOIN pais ON pais.pais_id = cidade.pais_id
GROUP BY pais.pais
HAVING COUNT(cidade.cidade) > 10
ORDER BY COUNT(cidade.cidade) DESC;

### 20. Encontre o total de aluguéis realizados por categoria de filme.
-- Condição extra: Ordene o resultado em ordem decrescente pelo total de aluguéis.
SELECT * FROM aluguel			-- count(aluguel_id),[inventario_id]
SELECT * FROM iventario			-- [inventario_id], [filme_id]
SELECT * FROM filme_categoria	-- [filme_id], [categoria_id]
SELECT * FROM categoria			-- [categoria_id], nome
-- resolvendo
SELECT categoria.nome AS categoria, COUNT(aluguel.aluguel_id) AS quantidade
FROM aluguel
JOIN inventario ON inventario.inventario_id = aluguel.inventario_id
JOIN filme_categoria ON filme_categoria.filme_id = inventario.filme_id
JOIN categoria ON categoria.categoria_id = filme_categoria.categoria_id
GROUP BY categoria
ORDER BY quantidade DESC;








