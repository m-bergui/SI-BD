-- ====================================================================================
-- I.	Création de la base de données
-- ====================================================================================
-- 3.	Afficher le nom des tables créées

SHOW TABLES;

-- 3.	Afficher la structure de toutes les tables

DESC Pilote;
DESC Passager;
DESC Avion;
DESC Vol;
DESC Reservation;

-- 3.	Afficher les données de chaque table

SELECT * FROM Pilote;
SELECT * FROM Passager;
SELECT * FROM Avion;
SELECT * FROM Vol;
SELECT * FROM Reservation;

-- 4.	Ajouter la contrainte à la table Vol qui impose à ce que la valeur de la colonne distance soit toujours renseignée.

ALTER TABLE Vol 
MODIFY COLUMN distance INT NOT NULL;

-- 5.	Quelle contrainte faut-il ajouter à la table Reservation pour que dans un vol donné on ne peut réserver la même place plusieurs fois ?

ALTER TABLE Reservation 
ADD CONSTRAINT reservation_numvol_numplace_uq UNIQUE(numvol, numplace);

-- 6.	Dans une fenêtre Query, écrire la commande qui sert à afficher toutes les contraintes ainsi définies dans toutes la tables. 

SELECT 
    TABLE_NAME, 
    CONSTRAINT_NAME, 
    CONSTRAINT_TYPE 
FROM 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE 
    TABLE_SCHEMA = 'gestion_compagnie';

-- ====================================================================================
--  II.	Requêtes simples : Sélection, projection, fonctions mono-lignes et jointures
-- ====================================================================================
-- 1.	Quels sont les numéros et noms des avions localisés à 'Paris' ?
SELECT numav, nomav
FROM avion
WHERE localisation = 'Paris';

-- 2.	Donnez la liste des avions dont la capacité est comprise entre 300 et 350 places. 
SELECT nomav
FROM avion
WHERE capacite BETWEEN 300 AND 350;

-- 3.	Quels sont les vols (numéro, ville de départ) effectués par les pilotes de numéro 1 et 2 ? Attribuer des alias appropriés aux colonnes résultats.
SELECT numvol as 'Numéro du vol', villedep as 'ville de départ'
FROM vol
WHERE numpilpri IN (1,2);
-- OR numcopil IN (1,2);

-- 4.	Donner la liste des passagers (nom et prénom) avec leurs numéros de place pour le vol numéro 1.
SELECT p.nom, p.prenom, r.numplace
FROM passager p, reservation r
WHERE p.numpass = r.numpass
AND numvol = 1;

-- 5.	Liste des vols (numéro, date du vol) au départ de 'Casablanca' allant à 'Paris' après 15 heures ?
SELECT numvol, datevol
FROM vol
WHERE villedep = 'Casablanca'
AND villearr = 'Paris'
AND heuredep > 15;

-- 6.	Calculer le salaire net de chaque pilote. 
SELECT nom, prenom, salaire, prime, salaire + IFNULL(prime, 0) AS 'Salaire net'
FROM pilote;
-- ====================================================================================
-- III.	Requêtes avancées : Jointures, fonctions multilignes et regroupements 
-- ====================================================================================