--4 Avec l’utilisateur USR_ADMIN :
-- Affichez la liste des activités.
select * from ACTIVITIES;

-- Ajoutez un nouveau membre avec une requête SQL.
insert into MEMBRES (ID_MEMBRE,PRENOM_MEMBRE,NOM_MEMBRE,COURRIEL_MEMBRE,TELEPHONE_MEMBRE,DATE_INSCRIPTION,
                     ID_ABONNEMENT)
values (999,'Paul','Daraîche','paul@gmail.com',
        '4188333333','2025-05-12',2);

-- Créez un bloc anonyme dans lequel vous tenterez d’ajouter, de modifier puis d’annuler une réservation en
-- exécutant les fonctions PL/SQL créée à cet effet dans la section précédente.
Begin
    ajouter_reservation(2025-12-31,11,26);
    modifier_reservation(2025-12-31,11,26,25);
    annuler_reservation(46);
end;

-- Créez un deuxième bloc anonyme dans lequel vous tenterez d’afficher la liste des membres inscrits à une activité
-- donnée en exécutant la fonction PL/SQL get_membres_activites.
BEGIN
    get_membre_activite(26);
end;

--4 Avec l’utilisateur USR_COACH :
-- Affichez la liste des activités.
select * from ACTIVITIES;

-- Ajoutez un nouveau membre avec une requête SQL.
insert into MEMBRES (ID_MEMBRE,PRENOM_MEMBRE,NOM_MEMBRE,COURRIEL_MEMBRE,TELEPHONE_MEMBRE,DATE_INSCRIPTION,
                     ID_ABONNEMENT)
values (999,'Paul','Daraîche','paul@gmail.com',
        '4188333333','2025-05-12',2);

