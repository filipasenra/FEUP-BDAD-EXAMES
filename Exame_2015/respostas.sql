--Alinea 1
/*
SELECT Photo.caption
FROM User JOIN Photo
ON User.id = Photo.User
WHERE julianday(Photo.uploadDate) - julianday(Photo.creationDate) = 2 AND
User.name = 'Daniel Ramos';
*/
--Alinea 2
/*
SELECT User.name
FROM User
WHERE NOT EXISTS(SELECT * FROM Photo WHERE Photo.user = User.id);*/

--Alinea 3

/*
DROP VIEW IF EXISTS PHOTOS_MORE_3;

CREATE TEMP VIEW PHOTOS_MORE_3 AS
SELECT *
FROM Photo JOIN Likes
ON Photo.id = Likes.photo
GROUP BY Likes.photo
HAVING count(*) > 3;


DROP VIEW IF EXISTS NUMBER_PEOPLE;

CREATE TEMP VIEW NUMBER_PEOPLE AS
SELECT count(*) AS n_people
FROM AppearsIn, PHOTOS_MORE_3
WHERE AppearsIn.Photo = PHOTOS_MORE_3.photo
GROUP BY AppearsIn.Photo;

SELECT AVG(n_people) FROM NUMBER_PEOPLE;
*/

-- ALinea 4
/*
DROP VIEW IF EXISTS FRIENDS_;

CREATE TEMP VIEW FRIENDS_ AS
SELECT FRIEND.user2 AS IdF
FROM User, FRIEND
WHERE User.id = Friend.user1 AND
      User.name = 'Daniel Ramos';

DROP VIEW IF EXISTS FRIENDS_OF_FRIENDS;

CREATE TEMP VIEW FRIENDS_OF_FRIENDS AS
SELECT FRIEND.user2 AS IdFF
FROM FRIENDS_, FRIEND
WHERE FRIENDS_.IdF = Friend.user1;

SELECT DISTINCT Photo.caption
FROM FRIENDS_, FRIENDS_OF_FRIENDS, Photo JOIN AppearsIn
ON AppearsIn.photo = Photo.id
WHERE AppearsIn.user = FRIENDS_.IdF OR AppearsIn.user = FRIENDS_OF_FRIENDS.IdFF
ORDER BY Photo.caption;*/

--Alinea 5
/*
DROP VIEW IF EXISTS PHOTOS_LESS_2;

CREATE TEMP VIEW PHOTOS_LESS_2 AS
SELECT Photo.id
FROM Photo JOIN AppearsIn
ON Photo.id = AppearsIn.photo
GROUP BY AppearsIn.photo
HAVING count(*) < 2;

SELECT * FROM PHOTOS_LESS_2;

DELETE FROM Photo
WHERE julianday(Photo.uploadDate) < julianday('2010-01-01') AND
Photo.id IN PHOTOS_LESS_2;


SELECT * FROM PHOTOS_LESS_2;*/

--Alinea 6

DROP TRIGGER IF EXISTS LIKES_PHOTO;

CREATE TRIGGER LIKES_PHOTO AFTER INSERT ON AppearsIn
WHEN NOT EXISTS (SELECT * 
                 FROM LIKES 
                 WHERE LIKES.user = New.user AND
                 LIKES.photo = New.photo)
BEGIN
INSERT INTO LIKES VALUES (New.user, New.photo);
END;