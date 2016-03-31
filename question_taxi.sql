--# exercice : Qui conduit la voiture 503 ?
SELECT prenom	
FROM conducteur AS c
INNER JOIN assoc_vehicule_conducteur AS avc
	ON assoc_vehicule_conducteur.id_conducteur = conducteur.id_conducteur
WHERE id_vehicule = 503;


-- version imbriqué

SELECT prenom
FROM conducteur
WHERE id_conducteur = (SELECT id_conducteur
					   FROM assoc_vehicule_conducteur
					   WHERE id_vehicule = 503);
-- version jointure INTERNE AUTRE SYNTAXE

SELECT prenom
FROM conducteur c, assoc_vehicule_conducteur avc
WHERE avc.id_conducteur = c.id_conducteur
AND id_vehicule = 503;

+----------+
| prenom   |
+----------+
| Philippe |
+----------+

--# exercice : Qui conduit quoi ?
+--------+----------+
| modele | prenom   |
+--------+----------+
| 807    | Julien   |
| C8     | Morgane  |
| Cls    | Philippe |
| Touran | Amelie   |
| 807    | Philippe |
+--------+----------+
SELECT modele, prenom
FROM conducteur
INNER JOIN assoc_vehicule_conducteur
	ON conducteur.id_conducteur = assoc_vehicule_conducteur.id_conducteur
INNER JOIN vehicule
	ON 	vehicule.id_vehicule = assoc_vehicule_conducteur.id_vehicule;

--# exercice : Ajoutez vous dans la liste des conducteurs.
INSERT INTO conducteur(prenom, nom)
VALUES
	('Mathias', 'Deval');


--# exercice : Afficher tous les conducteurs avec leurs véhicules ainsi que ceux qui n'ont pas de véhicule
+--------+----------+
| modele | prenom   |
+--------+----------+
| 807    | Julien   |
| C8     | Morgane  |
| Cls    | Philippe |
| 807    | Philippe |
| Touran | Amelie   |
| NULL   | Alex     |
+--------+----------+
SELECT prenom, modele
FROM conducteur
LEFT JOIN assoc_vehicule_conducteur
	ON conducteur.id_conducteur = assoc_vehicule_conducteur.id_conducteur
LEFT JOIN vehicule
	ON 	vehicule.id_vehicule = assoc_vehicule_conducteur.id_vehicule;


--# exercice : Afficher tous les véhicules avec leur conducteur ainsi que ceux qui n'ont pas de conducteur
+---------+----------+
| modele  | prenom   |
+---------+----------+
| 807     | Julien   |
| 807     | Philippe |
| C8      | Morgane  |
| Cls     | Philippe |
| Touran  | Amelie   |
| Octavia | NULL     |
+---------+----------+
SELECT prenom, modele
FROM conducteur
RIGHT JOIN assoc_vehicule_conducteur
	ON conducteur.id_conducteur = assoc_vehicule_conducteur.id_conducteur
RIGHT JOIN vehicule
	ON 	vehicule.id_vehicule = assoc_vehicule_conducteur.id_vehicule;


--####### exercice : Faire en sorte qu'on ne puisse pas attribuer un véhicule qui n'existe pas à un conducteur qui n'existe pas (phpmyAdmin)

--####### exercice : Lorsqu'un véhicule est modifié, faire en sorte que ce soit répercuté dans la table des associations (phpmyAdmin)
#Aller dans la table qui va subir les conséquences suite au changement pour effectuer une contrainte d'intégrité relationnel

--####### exercice : Bloquer la possibilité de supprimer un conducteur tant que celui-ci conduit un véhicule (phpmyAdmin)

--####### exercice : Lorsqu'un conducteur est modifié, faire en sorte que ce soit répercuté dans la table des associations (phpmyAdmin)

--####### exercice : Si un véhicule est supprimé, faire en sorte que le conducteur reste dans la table association sans véhicule attribué (phpmyAdmin)

--# exercice : Créer une table assurance qui aura cet aspect (phpmyAdmin)
assurance
+--------------+------------------+
| id_assurance | compagnie        |
+--------------+------------------+
|            1 | Macif            |
|            2 | Maif             |
|            3 | Direct Assurance |
|            4 | BNP              |
|            5 | Lelynx           |
+--------------+------------------+ 

INSERT INTO assurance(id_assurance, compagnie)
VALUES (1, 'Macif'), (2, 'Maif'), (3, 'Direct Assurance'), (4, 'BNP'), (5, ('Lelynx');


--# exercice : Ajouter le champ id_assurance sur la table d'association pour avoir cet aspect (phpmyAdmin) : 
association_vehicule_conducteur
+----------------+-------------+---------------+--------------+
| id_association | id_vehicule | id_conducteur | id_assurance |
+----------------+-------------+---------------+--------------+
|              1 |         501 |             1 |         NULL |
|              2 |         502 |             2 |            3 |
|              3 |         503 |             3 |            5 |
|              4 |         504 |             4 |         NULL |
|              5 |         501 |             3 |            2 |
+----------------+-------------+---------------+--------------+

--# exercice : Ajoutez une Fiat Uno blanche, id 507, plaque AA-787-GF dans la table des véhicules
INSERT INTO vehicule(marque, modele, couleur, immatriculation)
	VALUES('Fiat', 'Uno', 'blanche', 'AA-787-GF');

--# exercice : Afficher toutes les personnes, avec leur véhicule, qui possèdent une assurance 
SELECT prenom, marque, modele, compagnie
FROM conducteur
	INNER JOIN assoc_vehicule_conducteur
		ON conducteur.id_conducteur = assoc_vehicule_conducteur.id_conducteur
	INNER JOIN assurance
		ON assoc_vehicule_conducteur.id_assurance = assurance.id_assurance
	INNER JOIN vehicule
		ON assoc_vehicule_conducteur.id_vehicule = vehicule.id_vehicule;

+----------+----------+--------+------------------+
| prenom   | marque   | modele | compagnie        |
+----------+----------+--------+------------------+
| Morgane  | Citroen  | C8     | Direct Assurance |
| Philippe | Mercedes | Cls    | Lelynx           |
| Philippe | Peugeot  | 807    | Maif             |
+----------+----------+--------+------------------+



--# exercice : Afficher toutes les personnes, avec leur véhicule, qui possèdent OU NON une assurance 
SELECT prenom, marque, modele, compagnie
FROM conducteur
	INNER JOIN assoc_vehicule_conducteur
		ON conducteur.id_conducteur = assoc_vehicule_conducteur.id_conducteur
	INNER JOIN vehicule
		ON assoc_vehicule_conducteur.id_assurance = assurance.id_assurance
	LEFT JOIN assurance
		ON assoc_vehicule_conducteur.id_vehicule = vehicule.id_vehicule;

+----------+------------+--------+------------------+
| prenom   | marque     | modele | compagnie        |
+----------+------------+--------+------------------+
| Julien   | Peugeot    | 807    | NULL             |
| Morgane  | Citroen    | C8     | Direct Assurance |
| Philippe | Mercedes   | Cls    | Lelynx           |
| Amelie   | Volkswagen | Touran | NULL             |
| Philippe | Peugeot    | 807    | Maif             |
+----------+------------+--------+------------------+


--###### exercice : Faire en sorte que lorsqu'on supprime une assurance (de la table assurance), dans la table d'association il apparaisse que le véhicule n'est plus assuré (NULL)

--# exercice : Quel est le véhicule que conduit Amelie ? 
SELECT prenom, marque, modele
FROM conducteur
	INNER JOIN assoc_vehicule_conducteur
		ON vehicule.id_vehicule = assoc_vehicule_conducteur.id_vehicule
	INNER JOIN conducteur
		 ON conducteur.id_conducteur = assoc_vehicule_conducteur.id_conducteur
		 WHERE prenom = 'Amelie';
+--------+------------+--------+
| prenom | marque     | modele |
+--------+------------+--------+
| Amelie | Volkswagen | Touran |
+--------+------------+--------+

--# exercice : Quel est le véhicule que conduit Morgane et par qui est-elle assurée ?
SELECT prenom, marque, modele, compagnie
FROM vehicule
	INNER JOIN assoc_vehicule_conducteur
		ON assoc_vehicule_conducteur.id_vehicule = vehicule.id_vehicule
	INNER JOIN vehicule
		ON conducteur.id_conducteur = assoc_vehicule_conducteur.id_conducteur
	INNER JOIN assurance
		ON assurance.id_assurance = assoc_vehicule_conducteur.id_assurance
WHERE prenom = 'Morgane';
+---------+---------+--------+------------------+
| prenom  | marque  | modele | compagnie        |
+---------+---------+--------+------------------+
| Morgane | Citroen | C8     | Direct Assurance |
+---------+---------+--------+------------------+