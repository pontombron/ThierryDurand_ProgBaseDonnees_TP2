--NOTE IMPORTANTE:
-- le générateur de id ne fonctionne pas avec le USR_COACH. Je mets donc pour celui-ci
-- un id à la main quand je dois ajouter un membre. Pour USR_ADMIN, j'ai utilisé le générateur de id.


--4 Avec l’utilisateur USR_ADMIN :
-- Affichez la liste des activités.
select * from ACTIVITIES;

-- Ajoutez un nouveau membre avec une requête SQL.
insert into MEMBRES (ID_MEMBRE,PRENOM_MEMBRE,NOM_MEMBRE,COURRIEL_MEMBRE,TELEPHONE_MEMBRE,DATE_INSCRIPTION,
                     ID_ABONNEMENT)
values (998,'nouvelUtilisateur','test','pafdul@gmail.com',
        '4188333334','2025-06-12',3);
select * from MEMBRES;

-- Créez un bloc anonyme dans lequel vous tenterez d’ajouter, de modifier puis d’annuler une réservation en
-- exécutant les fonctions PL/SQL créée à cet effet dans la section précédente.
begin
    pkg_gestion_reservation.ajouter_reservation(11,26);
    pkg_gestion_reservation.modifier_reservation(TO_DATE('2025-01-15', 'YYYY-MM-DD'),13,26,27);
    pkg_gestion_reservation.annuler_reservation(46);
end;

-- Créez un deuxième bloc anonyme dans lequel vous tenterez d’afficher la liste des membres inscrits à une activité
-- donnée en exécutant la fonction PL/SQL get_membres_activites.
DECLARE
v_membres pkg_gestion_reservation.t_membre;
BEGIN
    v_membres := pkg_gestion_reservation.get_membres_activite(29);


FOR i IN 1..v_membres.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Nom: ' || v_membres(i).nom || ', Prénom: ' || v_membres(i).prenom || ', Date de réservation: ' || TO_CHAR(v_membres(i).date_reservation, 'DD/MM/YYYY'));
END LOOP;
END;


