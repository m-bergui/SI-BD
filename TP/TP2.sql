-- 4 Dans une nouvelle fenêtre de requête, vérifier par la commande SELECT les données insérées dans chaque table.
SELECT * 
FROM client;

SELECT * 
FROM commande;

SELECT * 
FROM produit;

SELECT * 
FROM detailcom;

-- 5 Dans une nouvelle fenêtre de requête, ajouter les deux lignes ci-dessous et citer les erreurs renvoyées par MySQL pour chaque ligne à ajouter.
INSERT INTO client 
VALUES (2,'Khaldi','Fès');
-- Error Code: 1136. Column count doesn't match value count at row 1
INSERT INTO client 
VALUES (2,'Khaldi','','Fès');
-- Error Code: 1062. Duplicate entry '2' for key 'client.PRIMARY'
-- Cet ajout n’est pas possible car la valeur de la clé primaire 2 est déjà utilisée dans la table.

INSERT INTO commande 
VALUES (5,'8-02-2023',10);
-- Error Code: 1292. Incorrect date value: '8-02-2023' for column 'datec' at row 1
INSERT INTO commande 
VALUES (5,'2023-02-08',10);
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`gestion_commandes`.`commande`, CONSTRAINT `commande_numcli_fk` FOREIGN KEY (`numcli`) REFERENCES `client` (`numcli`))
-- Cet ajout n’est pas possible car la valeur de la clé étrangère du client N°10 n’existe pas encore dans la table client.

-- 6 Créer et exécuter une nouvelle requête nommée tp1exe14.sql pour ajouter la commande numéro 6 pour le client numéro 1 et ayant comme date la date par défaut attribué à la colonne datec. Vérifier cet ajout par la commande SELECT.
INSERT INTO commande 
VALUES (6, DEFAULT, 1);

SELECT * 
FROM commande;

-- 7 Créer et exécuter une nouvelle requête nommée tp1exe15.sql pour ajouter le produit (6, 'IPAD Pro M2', -1000.00, 10). Vérifier cet ajout par la commande SELECT.
INSERT INTO produit 
VALUES (6, 'IPAD Pro M2', -1000.00, 10);
-- Error Code: 3819. Check constraint 'produit_prixu_ck' is violated. Version 8
-- Pas de probleme dans la version 5 de MySQL
SELECT * 
FROM produit;

-- 8
DELETE 
FROM produit 
WHERE npro = 6;

SELECT * 
FROM produit;

-- 9 Modifier la ville du client dont le numcli =2 par la nouvelle ville Fès. Vérifier la modification.
UPDATE client 
SET ville = 'Fès' 
WHERE numcli = 2;

SELECT * 
FROM client;

-- 10 Augmenter de 5% le prix des produits ayant un prix inférieur à 1000. Vérifier la modification.

SET SQL_SAFE_UPDATES = 0; -- sert à désactiver le mode de mise à jour sécurisée (safe update mode) dans MySQL, permet les actions sans WHERE.
UPDATE produit 
SET prixu = prixu + (prixu * 0.05)
WHERE prixu <= 1000;
SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM produit;

-- 11 Affichez la liste de tous les clients (numéro, nom, ville).
SELECT numcli, nom, ville
FROM client;

-- 12 Affichez la liste des produits (libellé, prix unitaire) dont le prix unitaire est compris entre 500 et 2000.
SELECT libelle, prixu
FROM produit
WHERE prixu >=500
AND prixu <= 2000;
-- OU
SELECT libelle, prixu
FROM produit
WHERE prixu BETWEEN 500 AND 2000;

-- 13 Affichez les commandes (numéro de commande, date) passées par le client numéro 2.
SELECT numcom, datec
FROM commande
WHERE numcli = 2;

-- 14 Affichez les détails des commandes (numéro de commande, numéro de produit, quantité commandée) pour la commande numéro 1.
SELECT *
FROM detailcom
WHERE numcom = 1;