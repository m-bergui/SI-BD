-- =======================================================
-- 1. Création de la base de données et ses tables
-- =======================================================
-- CREATE DATABASE / CREATE TABLE : Utilisées pour créer une nouvelle base de données ou une nouvelle table dans la base de données.

-- 1.1 Créer une nouvelle base de données nommée gestion_commandes
CREATE DATABASE gestion_commandes DEFAULT CHARACTER SET UTF8;

-- 1.2 Dans la base de données gestion_commandes, créer les tables (sans contraintes) : Client, Produit, Commande et DetailCom
USE gestion_commandes;

CREATE TABLE IF NOT EXISTS client (
    numcli INT,         
    nom VARCHAR(30),   
    adresse VARCHAR(40), 
    ville VARCHAR(30)   
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS commande (
    numcom INT, 
    datec DATE,   
    numcli INT    
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS produit (
    npro INT,
    libelle VARCHAR(50),
    prixu NUMERIC(8, 2),
    qstock INT
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS detailCom (
    numcom INT,
    npro INT,
    Qcom INT
) ENGINE = InnoDB;

-- 1.3 Donner la commande SQL qui affiche tous les noms des tables ainsi créées dans la base de données gestion_commandes
SHOW TABLES FROM gestion_commandes;


-- =======================================================
-- 2. Modification de la structure d’une table
-- =======================================================
-- ALTER TABLE : Utilisée pour modifier une table existante, comme ajouter, supprimer ou modifier des colonnes.

-- 2.1 Ajouter la colonne « email » à la table Client
ALTER TABLE client
ADD COLUMN email VARCHAR(50);

-- 2.2 Supprimer la colonne email de la table Client
ALTER TABLE client 
DROP COLUMN email;

-- 2.3 Augmenter la taille de la colonne adresse de la table client à 50 caractères
ALTER TABLE client
MODIFY COLUMN adresse VARCHAR(50);

-- 2.4 Définir la date '2024-01-01' comme valeur par défaut pour la date de commande
ALTER TABLE commande
MODIFY datec DATE DEFAULT '2024-01-01';

-- 2.5 Formulez la requête SQL pour afficher la structure des quatre tables
DESCRIBE client;
DESCRIBE commande;
DESCRIBE produit;
DESCRIBE detailcom;

-- OU
SHOW COLUMNS FROM client;
SHOW COLUMNS FROM produit;
SHOW COLUMNS FROM commande;
SHOW COLUMNS FROM detailCom;


-- =======================================================
-- 3. Définition des contraintes d’intégrité
-- =======================================================
-- CONSTRAINT : Utilisée pour définir des contraintes sur les colonnes, telles que les clés primaires, les clés étrangères et les vérifications de conditions.

-- 3.1 Ajouter les contraintes suivantes avec des noms de contraintes

-- numcli de la table client : est une clé primaire.
ALTER TABLE client
ADD CONSTRAINT client_numcli_pk PRIMARY KEY (numcli);

-- nom du client de la table client : est un champ non vide toujours renseigné.
ALTER TABLE client
MODIFY nom VARCHAR(30) NOT NULL;

-- numcom de la table commande : est une clé primaire.
ALTER TABLE commande
ADD CONSTRAINT commande_numcom_pk PRIMARY KEY (numcom);

-- numcli de la table commande : est une clé étrangère.
ALTER TABLE commande
ADD CONSTRAINT commande_numcli_fk FOREIGN KEY (numcli) 
REFERENCES client(numcli);

-- la date commande : est toujours postérieure à la date courante
ALTER TABLE commande
ADD CONSTRAINT commande_datec_ck CHECK (datec >= SYSDATE());

-- npro de la table produit : est une clé primaire.
ALTER TABLE produit
ADD CONSTRAINT produit_npro_pk PRIMARY KEY (npro);

-- Le prix unitaire d’un produit : est toujours strictement positif
ALTER TABLE produit
ADD CONSTRAINT produit_prixu_ck CHECK (prixu > 0);

-- (npro, numcom) de la table detailCom : est une clé primaire.
ALTER TABLE detailCom
ADD CONSTRAINT detailCom_npro_numcom_pk PRIMARY KEY (npro, numcom);

-- npro de la table detailCom : est une clé étrangère.
ALTER TABLE detailCom
ADD CONSTRAINT detailCom_npro_fk FOREIGN KEY (npro)
REFERENCES produit(npro);

-- numcom de la table detailCom : est une clé étrangère.
ALTER TABLE detailCom
ADD CONSTRAINT detailCom_numcom_fk FOREIGN KEY (numcom)
REFERENCES commande(numcom);

-- 3.2 Formuler la commande SQL pour afficher toutes les contraintes définies dans toutes les tables
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME IN ('client', 'commande', 'produit', 'detailcom');

-- OU
SHOW CREATE TABLE client;
SHOW CREATE TABLE commande;
SHOW CREATE TABLE produit;
SHOW CREATE TABLE detailcom;


-- =======================================================
-- 4. Ajout des données à une table : INSERT
-- =======================================================
-- INSERT INTO : Utilisée pour insérer des données dans une table.

-- 4.1 Formulez les requêtes SQL pour insérer les lignes de toutes les tables (une ligne pour chaque table)
INSERT INTO client VALUES
(1, 'Alami', '9 Rue G-D La fontaine', 'Meknès'),
(2, 'Ibrahimi', '101 Boulevard Royal', 'Tanger'),
(3, 'Ibrahimi', '33 Rue de Zinzibar', NULL), -- La ville est NULL, ce qui est autorisé.
(4, 'Marzouq', '6 Rue de Paris', 'Fès'),
(5, 'Zorro', '32 Rue Alhouria', 'Rabat'),
(6, 'Aach', '1 Rue du 18 novembre', 'Marrakech');

INSERT INTO produit VALUES
(1, 'PC portable HP', 6500.00, 20),
(2, 'Ecran LCD Samsung', 800.00, 30),
(3, 'Table d’ordinateur', 1220.00, 25),
(4, 'Clé USB 8GO', 150.00, 50),
(5, 'IPAD Pro M1', 15000.00, 10);

INSERT INTO commande VALUES
(1, '2016-01-02', 2),
(2, '2016-01-02', 3), 
(3, '2016-02-05', 2), 
(4, '2016-03-03', 4); 

INSERT INTO DetailCom VALUES
(1, 1, 2),
(1, 4, 6), 
(2, 3, 2), 
(2, 4, 3),
(3, 2, 1), 
(3, 1, 2), 
(4, 4, 2); 


-- 4.2 Formulez la requête SQL pour ajouter le client suivant : (4, Alaoui, 8 Grand Rue, Fès). Est-ce qu’on peut ajouter ce client ? Justifier.
INSERT INTO client VALUES (4, 'Alami', '8 Grand Rue', 'Fès');
-- Ce client ne peut pas être ajouté car le numéro du client est une clé primaire et la valeur 4 existe dans la table.

-- 4.3 Formulez la requête SQL pour ajouter la commande suivante : (5, 5.1.2016, 10). Est-ce qu’on peut ajouter cette commande ? Justifier.
INSERT INTO commande VALUES (5, '2016-01-05', 10);
-- Cette commande ne peut pas s’exécuter car le client N°10 n’existe pas alors qu’il existe une contrainte de clé étrangère sur la colonne numcli dans la table commande qui le lie à la table client.

-- 4.4 Formulez la requête SQL pour ajouter l’enregistrement suivant (numcom=1, npro=2, qcom=2) dans la table DetailCom. Est-ce qu’on peut ajouter cet enregistrement ? Justifier.
INSERT INTO detailcom VALUES (1, 2, 2);
-- Oui l’enregistrement peut être ajouté sans problème. la clé primaire de la table detailCom est le couple (numCom, npro)

-- 4.5 Formulez la requête SQL pour ajouter le produit : (6, 'IPAD Pro M2', -1000.00, 10). Est-ce qu’on peut ajouter ce produit avec un prix négatif ? Justifier.
INSERT INTO produit VALUES (6, 'IPAD Pro M2', -1000.00, 10);
-- Oui l’enregistrement peut être ajouté sans problème même avec la contrainte CHECK qui impose à ce que les prix soient positifs, car la contrainte CHECK sous MySQL n’est pas encore opérationnelle.

-- =======================================================
-- 5. Modification des lignes d’une table : UPDATE
-- =======================================================
-- UPDATE : Utilisée pour modifier des données existantes dans une table.

-- 5.1 Formulez la requête SQL pour modifier le n° de la commande 4 en 5. Est-ce qu’on peut faire cette modification ? Justifier.
UPDATE commande 
SET numcom = 5 
WHERE numcom = 4;
-- La commande N°4 ne peut pas changer de numéro puisqu’elle est référencée dans la table detailCom avec une clé étrangère. Il faudra changer la contrainte de clé étrangère pour pouvoir propager la mise à jour.

-- 5.2 Formulez la requête SQL pour modifier l’enregistrement (numcom=1, npro=1, qcom=2) en (numcom=1, npro=1, qcom=3) dans la table DetailCom. Est-ce qu’on peut faire cette modification ?
UPDATE detailCom 
SET Qcom = 3 
WHERE numcom = 1 AND npro = 1;
-- Oui, on peut faire cette modification puisque la mise à jour ne porte pas sur une colonne concernée par une contrainte de clé étrangère.

-- 5.3 Est-ce qu’on peut remplacer dans la commande N° 2 le client N°3 par le client N° 1 ? Justifier.
UPDATE commande 
SET numcli = 1 
WHERE numcli = 3;
-- Oui. Même justification que la question précédente.


-- =======================================================
-- 6. Suppression des lignes d’une table : DELETE
-- =======================================================
-- DELETE : Utilisée pour supprimer des données dans une table.

-- 6.1 Formulez la requête SQL pour supprimer le client N° 5. Est-ce qu’on peut supprimer ce client ?
DELETE FROM client 
WHERE numcli = 5;
-- On peut supprimer ce client, car il n’a pas effectué aucune commande.

-- 6.2 Est-ce qu’on peut supprimer le client N° 4 ? Justifier.
DELETE FROM gestion_commandes.Client 
WHERE numcli = 4;
-- On ne peut pas supprimer le client N°4 car il est référencé dans la table des commandes.
