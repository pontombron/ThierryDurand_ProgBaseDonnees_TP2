--RÔLES ET PRIVILÈGES

--1a: Créer le rôle ADMIN et accorder tous les privilèges à ce rôle
create role ADMIN;
GRANT all privileges to ADMIN;

--1b: Créer le rôle COACH avec les privilèges suivants:
    --Peut se connecter à la BD
    --Peut consulter la liste des membres et celle des activités
    --Peut consulter, ajouter, modifier et annuler des réservations en utilisant les fonctions PL/SQL crées auparavant
create role COACH;
GRANT connect to COACH;
GRANT select on MEMBRES to COACH;
GRANT execute on pkg_gestion_reservation to COACH;
GRANT select, insert, update, delete on RESERVATIONS to COACH;

--2a Créez le profil ci-dessous. Nous voulons apporter plus de restrictions aux profils Admin afin de le rendre plus sécurisé.
--a. « PROFIL_ADMIN_STRICT » : 3 tentatives de connexion, au-delà le compte est verrouillé durant 1 jour;
-- le mot de passe doit être changé tous les 90 jours; une seule session simultanée autorisée; après 15 minutes
-- d’inactivité le compte est désactivé;
create profile PROFIL_ADMIN_STRICT LIMIT
    failed_login_attempts 3
    password_lock_time 1
    password_life_time 90
    sessions_per_user 1
    idle_time 15;

--3 Créez les utilisateurs suivants en leur attribuant les rôles/profil tel que décrit ci-dessous
    --1. USR_ADMIN : dispose de tous les privilèges et est soumis à des restrictions strictes.
    create user USR_ADMIN identified by mdp_admin profile PROFIL_ADMIN_STRICT;
Grant ADMIN to USR_ADMIN;

--2. USR_COACH : dispose de l’accès limité du rôle coach.
create user USR_COACH identified by mdp_coach;
grant COACH to USR_COACH;