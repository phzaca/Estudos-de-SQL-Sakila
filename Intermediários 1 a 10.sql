-- QUESTÕES DE 1 A 10 
--    NÍVEL INTERMEDIÁRIO


### 1. Liste os filmes com o maior custo de substituição.
-- Condição extra: Exiba também a classificação do filme. 
SELECT * FROM filme; -- vendo a tabela pra me organizar
-- resolvendo
SELECT titulo, custo_de_substituicao, classificacao
FROM filme
ORDER BY custo_de_substituicao;

### 2. Qual a receita total de pagamentos de clientes ativos em "Brasília"?
-- Condição extra: Exiba o total agrupado por loja. 
-- visualizando a organização das tabelas
SELECT * FROM pagamento;
SELECT * FROM cliente;
SELECT * FROM endereco;
SELECT * FROM cidade;
-- resolvendo
SELECT SUM(pagamento.valor) AS receita , cliente.loja_id AS loja
FROM pagamento
JOIN cliente ON cliente.cliente_id = pagamento.cliente_id
JOIN endereco ON endereco.endereco_id = cliente.endereco_id
JOIN cidade ON cidade.cidade_id = endereco.cidade_id
WHERE cidade.cidade = 'Braslia' -- reparei q n tem Brasília, está escrito errado talvez ksakas
GROUP BY loja

 ### 3. Encontre os 5 clientes que mais realizaram aluguéis.
-- Condição extra: Exiba o nome completo e a quantidade de aluguéis. 
SELECT cliente_id, COUNT(aluguel_id) FROM aluguel GROUP BY cliente_id -- previsão
SELECT * FROM cliente;
-- resolvendo
SELECT aluguel.cliente_id AS ID ,CONCAT(cliente.primeiro_nome,' ',cliente.ultimo_nome) AS nome ,COUNT(aluguel.aluguel_id) AS quantidade
FROM aluguel
JOIN cliente ON cliente.cliente_id = aluguel.cliente_id
GROUP BY ID
ORDER BY quantidade DESC;

### 4. Liste os filmes que possuem as três maiores durações.
-- Condição extra: Inclua o ano de lançamento. 
SELECT * FROM filme; -- vendo se tem tudo em uma tabela só
-- resolvendo
SELECT titulo, duracao_do_filme AS duração , ano_de_lancamento AS lançamento
FROM filme
ORDER BY duracao_do_filme DESC
LIMIT 3;

### 5. Encontre o total de filmes em inventário por loja.
-- Condição extra: Inclua também o nome da loja. 
SELECT * FROM inventario --vendo como q vou usar a tabela
-- resolvendo 
SELECT loja_id AS loja, COUNT(inventario_id) AS quantidade
FROM inventario
GROUP BY loja;

### 6. Qual é o ator que aparece no maior número de filmes?
-- Condição extra: Exiba também a lista de filmes em que ele atua. 
-- visualizando a tabela
SELECT * FROM ator    			-- pra pegar o nome do ator
SELECT * FROM filme_ator		-- contar a quantidade de filme e retirar o id
SELECT * FROM filme 			-- pra pegar o nome dos filmes
SELECT ator_id FROM filme_ator GROUP BY ator_id ORDER BY COUNT(filme_id) DESC LIMIT 1 -- pegando o cara q mais tem filme
SELECT * FROM ator WHERE ator_id = 107 -- testando o nome 

-- resolvendo
SELECT CONCAT(ator.primeiro_nome, ' ', ator.ultimo_nome) AS nome, filme.titulo
FROM ator
JOIN filme_ator ON filme_ator.ator_id = ator.ator_id
JOIN filme ON filme.filme_id = filme_ator.filme_id
WHERE ator.ator_id = (SELECT ator_id FROM filme_ator GROUP BY ator_id ORDER BY COUNT(filme_id) DESC LIMIT 1)
ORDER BY titulo ASC; -- deixar em ordem alfabética neh kskks


### 7. Qual é a classificação de filme mais comum?
-- Condição extra: Inclua o total de filmes para cada classificação. 
SELECT * FROM filme -- tem tudo só nessa
-- resolvendo
SELECT classificacao, COUNT(titulo) AS quantidade
FROM filme
GROUP BY classificacao
ORDER BY quantidade DESC;

### 8. Liste os filmes da categoria "Aventura" que possuem duração maior que 90 minutos.
-- Condição extra: Ordene pelo título em ordem alfabética.
SELECT * FROM filme 					-- titulo, [duracao do filme (>90)], [filme_id] 
SELECT * FROM filme_categoria 			-- [categoria _ id] , [filme_id]
SELECT * FROM categoria 				-- [categoria_id], [nome (aventura)]
-- resolvendo
SELECT filme.titulo
FROM filme
JOIN filme_categoria ON filme_categoria.filme_id = filme.filme_id
JOIN categoria ON categoria.categoria_id = filme_categoria.categoria_id
WHERE (filme.duracao_do_filme > 90) AND (categoria.nome = 'Travel')
ORDER BY titulo ASC;

### 9. Encontre os 10 clientes que mais gastaram em pagamentos.
-- Condição extra: Exiba o total gasto por cliente. 
SELECT * FROM pagamento 			-- SUM(valor), [cliente_id]
SELECT * FROM cliente 				-- [cliente_id], Concat(nome inteiro)
-- resolvendo
SELECT CONCAT(cliente.primeiro_nome, ' ' ,cliente.ultimo_nome) AS nome , SUM(pagamento.valor) AS valor
FROM cliente
JOIN pagamento ON pagamento.cliente_id = cliente.cliente_id
GROUP BY cliente.cliente_id
ORDER BY valor DESC
LIMIT 10;

### 10. Liste as cidades com mais de 5 clientes registrados.
-- Condição extra: Inclua o total de clientes por cidade. 
SELECT * FROM endereco			-- [cidade_id], COUNT(endereco_id)
SELECT * FROM cidade 			-- cidade, [cidade_id]
-- resolve
SELECT cidade.cidade, COUNT(endereco.endereco_id) AS quantidade
FROM endereco
JOIN cidade ON endereco.cidade_id = cidade.cidade_id
GROUP BY endereco.cidade_id
ORDER BY quantidade DESC
LIMIT 5;





