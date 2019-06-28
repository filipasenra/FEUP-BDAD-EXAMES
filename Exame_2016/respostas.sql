--Alinea 1
/*
SELECT Estudante.nome, Curso.nome
FROM Estudante JOIN Curso
ON Estudante.Curso = Curso.ID
WHERE Estudante.anoCurricular = 3;*/

-- Alinea 2
/*
SELECT Estudante.nome
FROM Estudante JOIN Amizade
ON Estudante.id = Amizade.ID1
GROUP BY Amizade.ID1
HAVING COUNT(*) > 3; 
*/

--Alinea 3
/*
SELECT Estudante.nome, Estudante.anoCurricular
FROM Estudante
WHERE NOT EXISTS (SELECT * FROM Amizade JOIN Estudante E1
              ON E1.id = Amizade.id2
              WHERE Amizade.ID1 = Estudante.id AND
              Estudante.anoCurricular <> E1.anoCurricular) AND
      EXISTS (SELECT * FROM Amizade
              WHERE Amizade.ID1 = Estudante.id 
              GROUP BY Amizade.ID1
              HAVING COUNT(*) <> 0)
ORDER BY Estudante.anoCurricular, Estudante.nome
*/

--Alinea 4
/*
SELECT DISTINCT A3.id2
FROM Estudante, 
Amizade A1 JOIN Amizade A2 ON A1.ID2 = A2.ID1 AND A1.ID1 <> A2.ID2 -- MIGUEL SAMPAIO DOESN'T SHOW UP
JOIN Amizade A3 ON A3.ID1 = A2.ID2
WHERE Estudante.nome = 'Miguel Sampaio' AND
      A1.ID1 = Estudante.id;

*/

--Alinea 5
/*
DROP VIEW IF EXISTS NUMBER_FRIENDS;

CREATE TEMP VIEW IF NOT EXISTS NUMBER_FRIENDS AS
SELECT COUNT(*) n_friends
FROM Estudante JOIN Amizade
ON Estudante.id = Amizade.ID1
GROUP BY Amizade.ID1;

--SELECT max(n_friends) FROM NUMBER_FRIENDS;

SELECT DISTINCT Estudante.nome, Estudante.anoCurricular
FROM Estudante JOIN Amizade
ON Estudante.id = Amizade.ID1
GROUP BY Amizade.ID1
HAVING count(*) >= (SELECT max(n_friends) FROM NUMBER_FRIENDS);

*/

--Alinea 6

DROP TRIGGER IF EXISTS FRIEND_SAME_YEAR;

CREATE TRIGGER FRIEND_SAME_YEAR 
BEFORE INSERT 
ON Estudante
BEGIN

INSERT into Amizade
SELECT NEW.id, Estudante.id
FROM Estudante
WHERE Estudante.anoCurricular = NEW.anoCurricular;

INSERT into Amizade
SELECT NEW.id, Estudante.id
FROM Estudante
WHERE Estudante.anoCurricular = NEW.anoCurricular;

END;

