--alinea 1

/*SELECT DISTINCT Estudante.nome
FROM Estudante JOIN Curso
ON Curso.id = Estudante.curso
WHERE Estudante.nome LIKE '%a%' AND Curso.nome = 'MIEIC';*/

--alinea 2
/*
SELECT DISTINCT Estudante.nome
FROM Estudante JOIN AMIZADE
ON AMIZADE.id1 = Estudante.id
WHERE EXISTS (SELECT *
              FROM Estudante E1
              WHERE E1.id = AMIZADE.id2 AND
              E1.nome LIKE 'Gabriel%');*/

-- alinea 3

SELECT DISTINCT Estudante.nome
FROM (Estudante JOIN Amizade 
ON Estudante.id = AMIZADE.id1) JOIN Estudante E1
ON E1.id = AMIZADE.id2
GROUP BY Estudante.id
HAVING count(DISTINCT E1.anoCurricular) = 5;

-- alinea 4
/*
DROP TABLE IF EXISTS AmizadeTransitiva;
CREATE TABLE AmizadeTransitiva(ID1 int REFERENCES Estudante(ID), ID2 int REFERENCES Estudante(ID), PRIMARY KEY (ID1, ID2));

insert into AmizadeTransitiva
SELECT DISTINCT A1.ID1, A2.ID2
FROM AMIZADE A1 JOIN AMIZADE A2
ON A1.ID2 = A2.id1 AND A2.ID2 != A1.ID1 -- MAKING SURE IS NOT OURSELVES
WHERE NOT EXISTS (SELECT * 
                  FROM AMIZADE A3 
                  WHERE A3.id1 = A1.id1 AND A3.id2 = A2.id2) -- making sure friendship doesn't already exists
ORDER BY A1.ID1, A2.ID2;

SELECT * FROM AmizadeTransitiva;
*/

--alinea 5
/*
SELECT E1.nome, E2.nome
FROM (Estudante E1 JOIN AMIZADE), Estudante E2
ON AMIZADE.id1 = E1.id
WHERE AMIZADE.id2 = E2.id AND
E1.id < E2.id AND -- making sure we don't the same pairs in diferent order
E1.curso <> E2.curso;*/

-- alinea 6
/*
DROP TRIGGER IF EXISTS Mutuas_EL;

CREATE TRIGGER IF NOT EXISTS Mutuas_EL 
AFTER DELETE ON AMIZADE
BEGIN
DELETE FROM AMIZADE
WHERE AMIZADE.ID2 = OLD.id1 AND AMIZADE.ID1 = OLD.id2;
END;

DROP TRIGGER IF EXISTS Mutuas_IN;

CREATE TRIGGER IF NOT EXISTS Mutuas_IN 
AFTER insert ON AMIZADE
BEGIN
insert into Amizade values(NEW.id2, NEW.id1);
END;*/

CREATE TRIGGER IF NOT EXISTS NO_UPDATES
BEFORE UPDATE 
ON AMIZADE
BEGIN
SELECT RAISE(ABORT, 'NOT ALLOWED');
END;