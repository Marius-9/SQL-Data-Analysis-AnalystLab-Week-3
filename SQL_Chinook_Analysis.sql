-- =====================================
-- Projet : Analyse SQL - Chinook Database
-- Auteur : Marius Mawaba BODJONA
-- Objectif : Explorer les données musicales
-- =====================================
--Séléctionner la base de donnée Chinook
USE Chinook;
GO


-- =====================================
-- 1. Exploration des tables principales
-- =====================================
-- 1.1 Exploration de la table Artist
-- Cette requête affiche tous les artistes
SELECT *
FROM dbo.Artist; 

-- Compter le nombre total d'artistes
SELECT COUNT(*) AS Nombre_Artistes
FROM dbo.Artist;

-- Afficher les 10 premiers artistes
SELECT TOP 10 *
FROM dbo.Artist;

-- Claser les artistes de A à Z
SELECT *
FROM dbo.Artist
ORDER BY name ASC;

-- Selectionner les 10 derniers artistes par ordre alphabétique
SELECT TOP 10 *
FROM dbo.Artist
ORDER BY Name DESC;

-- Filtrer les artistes dont le nom commence par A
SELECT *
FROM dbo.Artist
WHERE Name LIKE 'A%';

-- Filtrer les artistes dont le nom contient "Black" 
SELECT *
FROM dbo.Artist
WHERE Name LIKE '%Black%'; -- le % avant et après signifie : peut importe ce qu'il y a avant ou après 

-- 1.2 Exporation de la table Track
-- Explorer les informations des morceaux
SELECT *
FROM dbo.Track; 

-- Compter le nombre total de morceaux
SELECT COUNT (*) AS Nombre_Morceaux 
FROM dbo.Track;

-- Analyser les statistiques de durée des morceaux
SELECT 
	MIN(Milliseconds) AS Durée_Miminale,
	MAX(Milliseconds) AS Durée_Maximale,
	AVG(Milliseconds) AS Durée_Moyenne
FROM dbo.Track;

-- ======================================
-- 2. Fonction d'agrégation
-- ======================================
-- Calculer le nombre de fonction musicale par genre
SELECT GenreId,
	COUNT (*) AS Nombre_Morceaux
FROM dbo.Track
GROUP BY GenreId
ORDER BY Nombre_Morceaux DESC;

-- =====================================
-- Jointures
-- Calculer le nombre de morceaux musical par genre musical (ici on a le nom de chaque genre)
SELECT 
	g.Name AS Genre,
	COUNT (*) AS Nombre_Morceaux
FROM dbo.Track t
INNER JOIN dbo.Genre g
	ON t.GenreId = g.GenreId 
GROUP BY g.Name
ORDER BY Nombre_Morceaux DESC;

-- Afficher tous les artistes, ayant un album
SELECT 
	a.Name AS Artiste,
	al.Title AS Album
FROM dbo.Artist a 
INNER JOIN dbo.Album al
	ON a.ArtistId = al.ArtistId;


-- Afficher tous les artistes, même ceux sans album
SELECT 
	a.Name AS Artiste,
	al.Title AS Album
FROM dbo.Artist a 
LEFT JOIN dbo.Album al
	ON a.ArtistId = al.ArtistId;


-- Afficher tous les artistes, même ceux sans album
SELECT 
	a.Name AS Artiste,
	al.Title AS Album
FROM dbo.Artist a 
INNER JOIN dbo.Album al
	ON a.ArtistId = al.ArtistId;

-- ===================================
-- Les sous-requêtes

-- Afficher les morceaux dont le prix est supérieur au prix moyen
SELECT *
FROM dbo.Track
WHERE UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM dbo.Track
);

-- Afficher les morceaux dont la durée est supérieur à la durée moyenne
SELECT *
FROM dbo.Track
WHERE Milliseconds > (
    SELECT AVG(Milliseconds)
    FROM dbo.Track
);

-- Afficher le ou les morceaux les plus longs
SELECT *
FROM dbo.Track
WHERE Milliseconds = (
    SELECT MAX(Milliseconds)
    FROM dbo.Track
);

-- Afficher les morceaux ayant le prix le plus faible
SELECT *
FROM dbo.Track
WHERE UnitPrice = (
    SELECT MIN(UnitPrice)
    FROM dbo.Track
);

-- Afficher les albums de l'artiste AC/DC
SELECT *
FROM dbo.Album
WHERE ArtistId = (
    SELECT ArtistId
    FROM dbo.Artist
    WHERE Name = 'AC/DC'
);

-- Attribuer un numéro à chaque morceau selon son nom
SELECT
    ROW_NUMBER() OVER (ORDER BY Name) AS Numero,
    TrackId,
    Name
FROM dbo.Track;

-- Classer les morceaux selon leur durée
SELECT
    RANK() OVER (ORDER BY Milliseconds DESC) AS Rang,
    Name,
    Milliseconds
FROM dbo.Track;

-- Classer les morceaux par durée à l'intérieur de chaque genre
SELECT
    GenreId,
    Name,
    Milliseconds,
    ROW_NUMBER() OVER (
        PARTITION BY GenreId
        ORDER BY Milliseconds DESC
    ) AS Rang_Dans_Le_Genre
FROM dbo.Track;
