SELECT COUNT(*)
FROM cliente
WHERE ativo = 1

SELECT titulo 
FROM filme
order by titulo ASC;

SELECT COUNT(titulo)
FROM filme
WHERE duracao_do_filme > 120
order by titulo ASC;

SELECT *
FROM ator
WHERE ultimo_nome =' JOHANNSSON' OR ultimo_nome = 'BERRY'
ORDER BY primeiro_nome


SELECT COUNT(*) 
FROM pais
WHERE pais LIKE 'B%'
ORDER BY pais ASC;

SELECT SUM(valor), AVG(valor)
FROM pagamento

SELECT * FROM aluguel

SELECT * FROM cliente

SELECT cliente.email
FROM cliente
JOIN aluguel on aluguel.cliente_id = cliente.cliente_id
GROUP BY cliente.email

SELECT * FROM categoria

SELECT * FROM filme

SELECT * FROM filme_categoria

SELECT filme.titulo 
FROM filme
JOIN filme_categoria ON filme_categoria.filme_id = filme.filme_id
JOIN categoria ON categoria.categoria_id = filme_categoria.categoria_id
WHERE categoria.nome = 'Comedy' AND filme.ano_de_lancamento > '2000'
ORDER BY filme.ano_de_lancamento ASC;

SELECT COUNT(*),loja_id 
FROM cliente
GROUP BY loja_id

SELECT * FROM idioma
SELECT * FROM filme

SELECT filme.titulo
FROM filme
JOIN idioma ON idioma.idioma_id = filme.idioma_id
WHERE idioma.nome = 'ENGLISH'
ORDER BY filme.ano_de_lancamento ASC;

SELECT * FROM pais

SELECT cidade.cidade ,pais.pais
FROM cidade 
JOIN pais ON pais.pais_id = cidade.pais_id
WHERE cidade.cidade LIKE 'Rio%'

SELECT * FROM categoria
SELECT * FROM filme_categoria
SELECT * FROM filme

SELECT ROUND(AVG(filme.duracao_do_filme),2)
FROM filme
JOIN filme_categoria ON filme_categoria.filme_id = filme.filme_id
JOIN categoria ON categoria.categoria_id = filme_categoria.categoria_id
WHERE categoria.nome  = 'Drama'

SELECT * FROM cliente

SELECT * FROM aluguel
WHERE DATE(data_de_aluguel) >='2006-01-01'

SELECT cliente.primeiro_nome, cliente.ultimo_nome, cliente.data_criacao
FROM cliente
JOIN aluguel ON aluguel.cliente_id = cliente.cliente_id
WHERE DATE(aluguel.data_de_aluguel) >='2006-01-01'
GROUP BY cliente.cliente_id

SELECT * FROM filme

SELECT titulo , custo_de_substituicao
FROM filme
WHERE titulo LIKE 'S%'

SELECT * FROM categoria;

SELECT filme.titulo, categoria.nome
FROM filme
JOIN filme_categoria ON filme_categoria.filme_id = filme.filme_id
JOIN categoria ON categoria.categoria_id = filme_categoria.categoria_id
WHERE filme.preco_da_locacao > 2.99
ORDER BY filme.preco_da_locacao ASC

SELECT primeiro_nome, ultimo_nome FROM ator
WHERE primeiro_nome = 'TOM'

SELECT * FROM inventario
SELECT * FROM filme


SELECT filme.titulo, inventario.loja_id
FROM filme
JOIN inventario ON inventario.filme_id = filme.filme_id
WHERE filme.titulo = 'Academy Dinosaur'
GROUP BY inventario.loja_id

SELECT * FROM cliente

USE sakila;

SELECT primeiro_nome, ultimo_nome
FROM cliente
WHERE primeiro_nome LIKE 'A%'

SELECT * FROM cliente
SELECT * FROM endereco

SELECT cliente.primeiro_nome, cliente.ultimo_nome
FROM cliente
JOIN endereco ON endereco.endereco_id = cliente.endereco_id
WHERE endereco.telefone IS NOT NULL
ORDER BY cliente.data_criacao ASC;

SELECT * FROM filme

SELECT titulo, recursos_especiais
FROM filme
WHERE recursos_especiais  LIKE "%Trailers%"

SELECT * FROM inventario

SELECT inventario.inventario_id, filme.titulo
FROM inventario
JOIN filme ON filme.filme_id = inventario.filme_id
WHERE inventario.loja_id = 1

SELECT * FROM loja
SELECT * FROM cliente
SELECT * FROM funcionario

-- pego o gerente id vou pro endereço do endereço eu vou pro email q está no cliente
-- gerente id - loja (endereco id) /// endereco id - cliente *(email)*

SELECT cliente.email
FROM cliente
JOIN loja ON loja.endereco_id = cliente.endereco_id

SELECT * FROM cliente

SELECT primeiro_nome, ultimo_nome, data_criacao
FROM cliente
WHERE ativo = 0
ORDER BY data_criacao ASC

SELECT titulo 
FROM filme
WHERE classificacao = 'PG'
ORDER BY  custo_de_substituicao DESC

SELECT * FROM pais

SELECT pais.pais, COUNT(cidade.pais_id) AS cidades
FROM pais
JOIN cidade ON cidade.pais_id = pais.pais_id
GROUP BY pais.pais

SELECT filme.titulo AS titulo, filme.custo_de_substituicao AS custo, inventario.inventario_id
FROM filme
JOIN inventario ON inventario.filme_id = filme.filme_id
WHERE filme.custo_de_substituicao < "10"

SELECT categoria.nome AS CATEGORIA , COUNT(categoria.nome) AS QUANTIDADE
FROM filme
JOIN filme_categoria ON filme_categoria.filme_id = filme.filme_id
JOIN categoria ON categoria.categoria_id = filme_categoria.categoria_id
WHERE filme.duracao_do_filme > "150"
GROUP BY categoria.nome
ORDER BY QUANTIDADE ASC

SELECT aluguel.cliente_id, cliente.primeiro_nome, cliente.ultimo_nome , COUNT(aluguel.cliente_id) AS quantidade
FROM aluguel
JOIN cliente ON cliente.cliente_id = aluguel.cliente_id
GROUP BY aluguel.cliente_id
HAVING COUNT(aluguel.cliente_id) >5
ORDER BY quantidade ASC






