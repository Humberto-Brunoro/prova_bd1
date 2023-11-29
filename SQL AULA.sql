CREATE DATABASE eleicoes;
DROP DATABASE eleicoes;
SHOW DATABASES;
USE eleicoes;
SHOW TABLES;
DROP TABLE usuarios;

-- 7. Elabore as querys de criação de tabelas, especificando chaves primárias e chaves estrangeiras.

CREATE TABLE IF NOT EXISTS partidos (
	numero INT NOT NULL 
,	nome VARCHAR(55) NOT NULL 
,	PRIMARY KEY (numero) 
);


CREATE TABLE IF NOT EXISTS cargos (
	cargo_id INT NOT NULL AUTO_INCREMENT 
,	nome_cargo VARCHAR(55)
,	PRIMARY KEY(cargo_id)
);

CREATE TABLE IF NOT EXISTS candidatos (
	numero INT NOT NULL AUTO_INCREMENT
,	nome VARCHAR(55) NOT NULL 
, 	cargo_id INT NOT NULL
,	partido_id INT NOT NULL 
,	PRIMARY KEY (numero)
,	CONSTRAINT candidatos_partidos FOREIGN KEY (partido_id) REFERENCES partidos(numero)
,	CONSTRAINT candidatos_cargos FOREIGN KEY (cargo_id) REFERENCES cargos(cargo_id)
);

CREATE TABLE IF NOT EXISTS zonas_secoes (
	zona_id INT NOT NULL AUTO_INCREMENT
,	numero_secao INT NOT NULL
,	nome_zona VARCHAR(55)
,	qtde_eleitores INT NOT NULL
,	PRIMARY KEY (zona_id)
);

CREATE TABLE IF NOT EXISTS votacoes (
    candidato_id INT NOT NULL AUTO_INCREMENT
,   zona_id INT NOT NULL
,   numero_secao INT NOT NULL
,   quantidade INT NOT NULL
,	PRIMARY KEY (candidato_id)
,	CONSTRAINT votacoes_candidatos FOREIGN KEY (candidato_id) REFERENCES candidatos(numero)
,   CONSTRAINT votacoes_zonas_secoes FOREIGN KEY (zona_id) REFERENCES zonas_secoes(zona_id)
);


-- 8. Alterar a quantidade de eleitores, somando 100, para as zonas/seções onde ocorreu votação para candidatos 
--    ao Senado (código do cargo = 2) e do Partido Democrático (código de partido = 5).

UPDATE zonas_secoes
SET qtde_eleitores = qtde_eleitores + 100 
WHERE zona_id IN (
	SELECT DISTINCT zs.zona_id 
    FROM zona_secoes zs 
    JOIN votacoes v ON zs.zona_id = v.zona_id
    JOIN candidatos c ON v.candidato_id = c.numero 
    WHERE c.cargo_id = 2 AND c.partido_id = 5
);

-- 9. Crie uma instrução usando linguagem SQL para apagar as zonas/seções que possuam menos de  1.000 eleitores. 

DELETE FROM zonas_secoes 
WHERE qtde_eleitores < 1000
;

-- 10. Crie uma instrução de consulta que retorne como resultado o número do candidato, nome 
--     nome do candidato, nome do cargo, nome do partido, e quantidade total de votos de cada candidato, apenas para
--     os candidatos que tiverem uma votação superior a 100.000 votos. 

SELECT c.numero
,	   c.nome
,	   ca.cargo
,	   p.nome
,	   SUM(v.quantidade) 
FROM candidatos c 
JOIN cargos ca ON c.cargo_id = ca.cargo_id
JOIN partidos p ON c.partido_id = p.partido_id 
JOIN votacoes v ON c.numero = v.candidato_id
GROUP BY  c.numero, c.nome, ca.nome_cargo, p.nome
HAVING SUM(v.quantidade) > 100000
;







