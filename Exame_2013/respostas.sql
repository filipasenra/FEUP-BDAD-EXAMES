--Alinea 1 
/*
SELECT Servidor.hostname, Pessoa.nome
FROM Servidor JOIN Pessoa
ON Servidor.idResponsavel = Pessoa.idPessoa
WHERE Servidor.vulneravel = 'sim';*/

--Alinea 2
/*
SELECT Servidor.hostname, Bug.descricao, Pessoa.nome
FROM Servidor NATURAL JOIN
(AplicacaoServidor NATURAL JOIN Aplicacao), Bug, Pessoa
WHERE Bug.vulnerabilidade = 'sim' AND
	  AplicacaoServidor.idAplicacao = Bug.idAplicacao AND
	  Pessoa.idPessoa = Bug.idResponsavel
ORDER BY Servidor.hostname;
*/

--Alinea 3
/*
SELECT Servidor.hostname
FROM Servidor NATURAL JOIN
(AplicacaoServidor NATURAL JOIN Aplicacao), Bug, Pessoa
WHERE Bug.vulnerabilidade = 'sim' AND
	  AplicacaoServidor.idAplicacao = Bug.idAplicacao AND
	  Pessoa.idPessoa = Bug.idResponsavel AND
      Pessoa.mail = 'joao.almeida@cica.pt'
GROUP BY Pessoa.idPessoa
HAVING count(*) >= 1;*/

--Alinea 4
/*
DROP VIEW IF EXISTS HOW_MANY_BUGS;

CREATE TEMP VIEW HOW_MANY_BUGS AS 
SELECT count(*) as num, Aplicacao.nome AS nomeApl
FROM Aplicacao, Bug
WHERE Aplicacao.idAplicacao = Bug.idAplicacao
GROUP BY Bug.idAplicacao;

SELECT DISTINCT HOW_MANY_BUGS.nomeApl
FROM HOW_MANY_BUGS
WHERE HOW_MANY_BUGS.num >= (SELECT MAX(H1.num) FROM HOW_MANY_BUGS H1);
*/

--Alinea 5

DROP TRIGGER IF EXISTS Servidor_Vul;

CREATE TRIGGER Servidor_Vul 
AFTER INSERT ON AplicacaoServidor
WHEN EXISTS (
SELECT *
FROM Servidor, Bug, Aplicacao
WHERE Bug.vulnerabilidade = 'sim' AND
	  NEW.idAplicacao = Bug.idAplicacao)
BEGIN
UPDATE Servidor SET vulneravel = 'sim' WHERE Servidor.idServidor = new.Servidor;
END;


DROP TRIGGER IF EXISTS Servidor_Vul2;

CREATE TRIGGER Servidor_Vul2 
AFTER INSERT ON BUG
WHEN New.vulnerabilidade
BEGIN
UPDATE Servidor
    SET vulneravel = "sim"
    WHERE EXISTS (
      SELECT *
      FROM AplicacaoServidor
      WHERE AplicacaoServidor.idAplicacao = New.idAplicacao 
      AND AplicacaoServidor.idServidor = Servidor.idServidor
    );

UPDATE Bug
    SET prioridade = 1
    WHERE Bug.idBug = New.idBug;
END;

