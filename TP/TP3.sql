-- 1.1	Ecrire et exécuter la requête tp3exe11.sql qui donne les produits (numéro et libelle) dont le libelle contient la lettre minuscule « t ».
SELECT npro, libelle
FROM produit
WHERE BINARY libelle LIKE '%t%';

-- 1.2	Ecrire et exécuter la requête tp3exe12.sql qui extrait uniquement les clients résidants dans les villes Fès, Tanger ou Meknès.
SELECT numcli, nom, ville
FROM client
WHERE ville IN ('Fès', 'Tanger', 'Meknès');

-- 1.3	Ecrire et exécuter la requête tp3exe13.sql pour afficher les produits (numéro, libelle, prix unitaire et prix TTC avec une TVA fixée à 20%). 
-- 		Le résultat doit être classé par ordre décroissant de prix TTC et par ordre croissant des libelles des produits. 
-- 		Attribuer des alias appropriés aux colonnes résultats de la requête.
SELECT npro, libelle, prixu, prixu * 1.2 AS prix_ttc
FROM produit
ORDER BY prix_ttc DESC, libelle ASC;

-- 1.4	Ecrire et exécuter la requête tp3exe14.sql affiche les numéros et les dates, en format JJ/MM/AAAA, des commandes effectuées par le client N°2.
SELECT numcom, DATE_FORMAT(datec, '%d/%m/%Y') AS 'Date Commande'
FROM commande
WHERE numcli = 2;

-- 1.5	Ecrire et exécuter la requête tp3exe15.sql qui extrait pour chaque commande son numéro, sa date et ainsi que le nom du client en majuscule qui a effectué cette commande. 
-- 		Le résultat à trier par ordre décroissant des dates des commandes.
SELECT c.numcom, c.datec, UPPER(cl.nom) AS 'Client'
FROM commande c
JOIN client cl ON c.numcli = cl.numcli
ORDER BY c.datec DESC;

-- 1.6	Ecrire et exécuter la requête tp3exe16.sql qui donne le nom des clients et leurs commandes soumises le même jour que la commande N°2. 
-- 		Sans réafficher la commande N°2 dans le résultat.
SELECT c.numcom, cl.nom
FROM commande c
JOIN client cl ON c.numcli = cl.numcli
WHERE c.datec = (SELECT datec FROM commande WHERE numcom = 2)
AND c.numcom <> 2;

-- 1.7	Ecrire et exécuter la requête tp3exe17.sql qui extrait uniquement le numéro, le nom et la ville de chaque client ayant effectué des commandes durant l’année 2024. Afficher en plus les numéros des commandes.
SELECT cl.numcli, cl.nom, cl.ville, c.numcom, c.datec
FROM client cl
JOIN commande c ON cl.numcli = c.numcli
WHERE YEAR(c.datec) = 2024;

-- 1.8	Ecrire et exécuter la requête tp3exe18.sql qui donne le produit de prix minimum.
SELECT npro, libelle, prixu
FROM produit
WHERE prixu = (SELECT MIN(prixu) FROM produit);
-- OU
SELECT npro, libelle, prixu
FROM produit
ORDER BY prixu
LIMIT 1;

-- 2.1 Écrire et exécuter la requête qui permet d’afficher le montant total en DH hors taxes (HT) et toutes taxes comprises (TTC) de la commande N°1.
--     À noter que la TVA est fixée à 20 % pour tous les produits.
--     Les montants doivent être arrondis à deux chiffres après la virgule. Attribuer des alias appropriés aux colonnes résultantes.

SELECT 
    ROUND(SUM(p.prixu * d.Qcom), 2) AS MontantHT,
    ROUND(SUM(p.prixu * d.Qcom * 1.2), 2) AS MontantTTC
FROM detailcom d, produit p
WHERE d.npro = p.npro
AND d.numcom = 1;

-- 2.2 Écrire et exécuter la requête qui donne le montant total TTC commandé pour chaque commande (afficher également le numéro de la commande et le nom du client).
--     Trier par ordre alphabétique des noms des clients, puis par ordre décroissant des montants des commandes.
--     À noter que la TVA est fixée à 20 %. Les montants doivent être arrondis à deux chiffres après la virgule.

SELECT d.numcom, c.nom,
    ROUND(SUM(p.prixu * d.Qcom), 2) AS MontantHT,
    ROUND(SUM(p.prixu * d.Qcom * 1.2), 2) AS MontantTTC
FROM detailcom d, produit p, client c, commande co
WHERE d.npro = p.npro
AND c.numcli = co.numcli
AND co.numcom = d.numcom
GROUP BY d.numcom, c.nom
ORDER BY c.nom ASC, MontantTTC DESC;

-- 2.3 Écrire et exécuter la requête qui calcule la quantité totale commandée par produit depuis le 01/01/2024.
--     N’afficher que les produits (numéro et libellé) dont la quantité totale commandée dépasse 2 unités.

SELECT p.npro, p.libelle, SUM(d.Qcom) AS 'Quantité totale commandée' 
FROM detailcom d, produit p, commande c
WHERE d.npro = p.npro
AND d.numcom = c.numcom
AND c.datec > '2024-01-01'
GROUP BY p.npro, p.libelle
HAVING SUM(d.Qcom) > 2;

-- 2.4 Écrire et exécuter la requête qui permet de calculer pour chaque produit la valeur hors taxes totale commandée.

SELECT p.npro, p.libelle, ROUND(SUM(d.Qcom * p.prixu), 2) AS 'MontantHT commandée' 
FROM detailcom d, produit p, commande c
WHERE d.npro = p.npro
AND d.numcom = c.numcom
GROUP BY p.npro, p.libelle;

-- 2.5 Écrire et exécuter la requête qui permet de calculer pour chaque produit la quantité en stock, la quantité commandée et la quantité restante en stock.

SELECT p.npro, p.libelle, p.qstock AS 'Stock initial', SUM(d.Qcom) AS 'Quantité commandée', p.qstock - SUM(d.Qcom) AS 'Stock restant'
FROM detailcom d, produit p
WHERE d.npro = p.npro
GROUP BY p.npro, p.libelle;

-- Cette requête affiche également les produits qui n'ont pas été commandés.

SELECT 
    p.npro, 
    p.libelle, 
    p.qstock AS 'Stock initial', 
    (SELECT IFNULL(SUM(d.Qcom), 0) 
     FROM detailCom d 
     WHERE d.npro = p.npro) AS 'Quantité commandée', 
    p.qstock - 
    (SELECT IFNULL(SUM(d.Qcom), 0) 
     FROM detailCom d 
     WHERE d.npro = p.npro) AS 'Stock restant'
FROM produit p;

-- 2.6 Écrire et exécuter la requête qui permet de calculer pour chaque année le nombre de commandes effectuées et le montant total des commandes.

SELECT 
    YEAR(c.datec) AS 'Année', 
    COUNT(DISTINCT c.numcom) AS 'Nombre de commandes', 
    ROUND(SUM(p.prixu * d.Qcom * 1.2), 2) AS 'Montant total TTC'
FROM commande c, produit p, detailcom d
WHERE c.numcom = d.numcom
AND p.npro = d.npro
GROUP BY YEAR(c.datec);

-- 2.7 On suppose qu’un produit est en rupture de stock si sa quantité restante en stock, après déduction des quantités commandées, est inférieure à 15 unités.
--     Écrire et exécuter la requête qui permet d’afficher pour chaque produit (npro et libellé) s’il est en rupture de stock ou non.

SELECT 
    p.npro, 
    p.libelle, 
    p.qstock AS 'Stock initial', 
    SUM(d.Qcom) AS 'Quantité commandée', 
    p.qstock - SUM(d.Qcom) AS 'Stock restant', 
    IF((p.qstock - SUM(d.Qcom)) < 15, 'Rupture de stock', 'Disponible') AS 'Statut'
FROM detailcom d, produit p
WHERE d.npro = p.npro
GROUP BY p.npro, p.libelle, p.qstock;

-- Cette requête affiche également les produits qui n'ont pas été commandés, mais dont le stock restant est inférieur à 15.

SELECT 
    p.npro, 
    p.libelle, 
    p.qstock AS 'Stock initial', 
    (SELECT IFNULL(SUM(d.Qcom), 0) 
     FROM detailCom d 
     WHERE d.npro = p.npro) AS 'Quantité commandée', 
    p.qstock - 
    (SELECT IFNULL(SUM(d.Qcom), 0) 
     FROM detailCom d 
     WHERE d.npro = p.npro) AS 'Stock restant',
     IF(p.qstock -
     (SELECT IFNULL(SUM(d.Qcom), 0) 
     FROM detailCom d 
     WHERE d.npro = p.npro) < 15, 'Rupture de stock', 'Disponible')  AS 'Statut'
FROM produit p;

-- 2.8 Enchaîner la requête précédente par la commande qui calcule le nombre de produits en rupture de stock.

SELECT COUNT(*) AS 'Nombre total en rupture'
FROM (
    SELECT p.npro
    FROM produit p, detailCom d
    WHERE p.npro = d.npro
    GROUP BY p.npro, p.qstock
    HAVING (p.qstock - IFNULL(SUM(d.Qcom), 0)) < 15
) AS rupture;

-- Même remarque qu’avant : il faut considérer les produits qui n'ont pas été commandés comme étant en rupture de stock si leur quantité restante est inférieure à 15.

SELECT COUNT(*) AS 'Nombre total de produits en rupture'
FROM produit p
WHERE p.qstock - 
      (SELECT IFNULL(SUM(Qcom), 0) 
       FROM detailCom 
       WHERE detailCom.npro = p.npro) < 15;
