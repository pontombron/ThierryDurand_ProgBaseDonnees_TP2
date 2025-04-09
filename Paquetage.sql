-- PAQUETAGE

--Créez un paquetage pour la gestion des réservations nommé pkg_gestion_réservation.vLe paquetage doit contenir la
-- définition de deux type RECORD
-- r_reservation_type : servira à encapsuler les informations suivantes provenant des tables ACTIVITES et
-- RESERVATIONS: id_reservation, date_reservation, nom_activite, capacite_max, nombre_inscrits.

-- r_membre_type : servira à encapsuler les informations suivantes : le nom et le prénom du membre ainsi que la date
-- d’une réservation qu’il a effectuée.

--De plus, le paquetage doit contenir les fonctions et les procédures stockées dédiées à la gestion des réservations
-- et qui sont décrites dans la section suivante.
drop package pkg_gestion_reservation;

SELECT *
FROM USER_types;

create or replace package pkg_gestion_reservation As
    TYPE r_reservation_type is record(
                                         id RESERVATIONS.ID_RESERVATION%type,
                                         date_reservation RESERVATIONS.DATE_RESERVATION%type,
                                         nom_activite ACTIVITIES.NOM_ACTIVITE%type,
                                         capacite_max ACTIVITIES.CAPACITE_MAX%type,
                                         nombre_inscrits number
                                     );
    TYPE t_reservation is table of r_reservation_type;

    TYPE r_membre_type is record(
                                    nom MEMBRES.NOM_MEMBRE%type,
                                    prenom MEMBRES.PRENOM_MEMBRE%type,
                                    date_reservation date
                                );
    type t_membre is table of r_membre_type;

    FUNCTION activite_est_disponible(p_id_activite number) RETURN boolean;
    PROCEDURE ajouter_reservation(p_date_reservation date, p_id_membre number, p_id_activite number);
    procedure modifier_reservation(p_date_reservation date, p_id_membre number, p_id_activite_actuelle number, p_id_nouvelle_Activite number);
    procedure annuler_reservation(p_id_reservation number);
    FUNCTION get_reservation_membre(p_id_membre number) RETURN t_reservation;
    PROCEDURE afficher_reservation_membre(p_id_membre number);
    FUNCTION get_membres_activite(p_id_activite number) RETURN t_membre;
end pkg_gestion_reservation;