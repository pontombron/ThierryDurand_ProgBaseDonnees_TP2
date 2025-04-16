-- PAQUETAGE

--Créez un paquetage pour la gestion des réservations nommé pkg_gestion_réservation.vLe paquetage doit contenir la
-- définition de deux type RECORD
-- r_reservation_type : servira à encapsuler les informations suivantes provenant des tables ACTIVITES et
-- RESERVATIONS: id_reservation, date_reservation, nom_activite, capacite_max, nombre_inscrits.

-- r_membre_type : servira à encapsuler les informations suivantes : le nom et le prénom du membre ainsi que la date
-- d’une réservation qu’il a effectuée.

--De plus, le paquetage doit contenir les fonctions et les procédures stockées dédiées à la gestion des réservations
-- et qui sont décrites dans la section suivante.
drop package PKG_GESTION_RESERVATION;

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
    PROCEDURE ajouter_reservation(p_id_membre number, p_id_activite number);
    procedure modifier_reservation(p_date_reservation date, p_id_membre number, p_id_activite_actuelle number, p_id_nouvelle_Activite number);
    procedure annuler_reservation(p_id_reservation number);
    FUNCTION get_reservation_membre(p_id_membre number) RETURN t_reservation;
    PROCEDURE afficher_reservation_membre(p_id_membre number);
    FUNCTION get_membres_activite(p_id_activite number) RETURN t_membre;
end pkg_gestion_reservation;


--FONCTIONS/ PROCÉDURES STOCKÉES

create or replace package body pkg_gestion_reservation as

    --activite_est_disponible : permet de vérifier si une activité dont l’identifiant est passé en paramètre est
-- disponible ou non en comparant le nombre de réservations à la capacité maximale. Cette fonction retourne un
-- résultat booléen.
    FUNCTION activite_est_disponible(p_id_activite number) return boolean is
        v_est_disponible boolean := false;
        v_capacite_maximale ACTIVITIES.CAPACITE_MAX%type := 0;
        v_nb_reservation_actuelle number := 0;
    BEGIN
        BEGIN
            SELECT CAPACITE_MAX
            INTO v_capacite_maximale
            FROM ACTIVITIES
            WHERE ID_ACTIVITE = p_id_activite;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20002, 'Id activité ' || p_id_activite || ' introuvable');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erreur SQL : ' || SQLCODE || ' - ' || SQLERRM);
                RAISE;
        END;

        BEGIN
            SELECT COUNT(ID_ACTIVITE)
            INTO v_nb_reservation_actuelle
            FROM RESERVATIONS
            WHERE ID_ACTIVITE = p_id_activite;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_nb_reservation_actuelle := 0;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erreur SQL : ' || SQLCODE || ' - ' || SQLERRM);
                RAISE;
        END;

        IF v_capacite_maximale > v_nb_reservation_actuelle THEN
            v_est_disponible := TRUE;
        END IF;

        RETURN v_est_disponible;
    END activite_est_disponible;

--ajouter_reservation : Pour un membre et une activité donnée, cette procédure permet d’ajouter une nouvelle réservation
-- après avoir vérifié si l’activité est disponible. Pensez à utiliser la fonction précédente. Affichez dans la console
-- de sortie un message confirmant la réservation ou bien informant l’utilisateur qu’il n’y a pas de places disponibles.
    PROCEDURE ajouter_reservation(p_id_membre number, p_id_activite number) is
        v_est_disponible boolean := false;

    begin
        v_est_disponible := activite_est_disponible(p_id_activite);

        if v_est_disponible then
            Insert Into RESERVATIONS(ID_RESERVATION, DATE_RESERVATION,ID_MEMBRE,ID_ACTIVITE)
            values (SEQ_GENERATEUR_ID.nextval, SYSDATE,
                    p_id_membre,p_id_activite);
            DBMS_OUTPUT.PUT_LINE('reservation effecutée avec succès');
            commit;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Il ne reste plus de place pour cette activité');
        end if;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur SQL : ' || SQLCODE || ' - ' || SQLERRM);
            RAISE;
    end;


--modifier_reservation : Pour une réservation et une activité données, cette procédure permet de modifier une réservation
-- existante pour une nouvelle activité après avoir vérifié que l’activité est disponible. Pensez à utiliser la fonction
-- activite_est_disponible . Affichez dans la console de sortie un message confirmant la modification de la réservation
-- ou bien informant l’utilisateur qu’il n’y a pas de places disponibles dans la nouvelle activité.
    procedure modifier_reservation(p_date_reservation date, p_id_membre number, p_id_activite_actuelle number, p_id_nouvelle_Activite number) is
        v_est_disponible boolean := false;
    begin
        v_est_disponible := activite_est_disponible(p_id_nouvelle_Activite);

        if v_est_disponible then
            Update RESERVATIONS
            set ID_ACTIVITE = p_id_nouvelle_activite
            Where date_reservation = p_date_reservation
              and id_membre = p_id_membre
              and id_activite = p_id_activite_actuelle;

            DBMS_OUTPUT.PUT_LINE('La modification a été effectuée avec succès');
            commit;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Il ne reste plus de place pour cette activité.');
        end if;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur SQL : ' || SQLCODE || ' - ' || SQLERRM);
            RAISE;
    end;

--annuler_resevation : Supprimer une réservation dont l’identifiant est passé en paramètre. Cette procédure ne retourne
-- aucun résultat, mais affiche dans la console de sortie que la réservation a bien été supprimée.
    procedure annuler_reservation(p_id_reservation number) is
    begin
        Delete from RESERVATIONS
        where ID_RESERVATION = p_id_reservation;

        DBMS_OUTPUT.PUT_LINE('L''activité a bien été supprimée');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur SQL : ' || SQLCODE || ' - ' || SQLERRM);
            RAISE;
    end;

--get_reservations_membre : Pour un id_membre passé en paramètre, cette fonction récupère la liste de toutes les
-- réservations qui les concerne, les stocke dans un tableau de réservations et retourne comme résultat ce tableau.
    FUNCTION get_reservation_membre(p_id_membre number) RETURN t_reservation is
        v_reservations t_reservation;
    BEGIN
        Begin
            SELECT r.id_reservation, r.date_reservation, a.nom_activite, a.capacite_max, 0 as nombre_inscrits
                    BULK COLLECT INTO v_reservations FROM RESERVATIONS r
                                                              JOIN ACTIVITIES a
                                                                   ON r.id_activite = a.id_activite
            WHERE r.id_membre = p_id_membre;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Aucune réservation trouvée pour ce membre : ' || p_id_membre);
                RETURN v_reservations;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erreur lors de la récupération des réservations : '
                    || SQLCODE || ' - ' || SQLERRM);
                RAISE;
        end;

        FOR i IN 1..v_reservations.COUNT LOOP
                begin
                    SELECT COUNT(*)
                    INTO v_reservations(i).nombre_inscrits
                    FROM RESERVATIONS
                    WHERE ID_ACTIVITE = v_reservations(i).id;

                EXCEPTION
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('Erreur lors du comptage du nombre de personnes inscrites pour la réservation '
                            || v_reservations(i).id || ' : ' || SQLCODE || ' - ' || SQLERRM);
                        v_reservations(i).nombre_inscrits := 0;
                end;
            END LOOP;
        RETURN v_reservations;
    END get_reservation_membre;



--afficher_reservations_membre : récupère la liste des réservations d’un membre dont l’identifiant est passé en paramètre
-- en appelant la fonction précédente. Pensez à utiliser BULK COLLECT… Si le résultat est nul alors affichez un message
-- personnalisé, sinon affichez dans la console de sortie les informations des différentes réservations trouvées.
    PROCEDURE afficher_reservation_membre(p_id_membre number) is
        v_reservations t_reservation := get_reservation_membre(p_id_membre);
    begin
        if v_reservations.COUNT = 0 then
            DBMS_OUTPUT.PUT_LINE('Le membre n''a pas de réservation');
        else
            for i in 1..v_reservations.COUNT loop
                    begin
                        dbms_output.PUT_LINE('Id réservation: ' || v_reservations(i).id ||
                                             'Date de réservation: ' || v_reservations(i).date_reservation ||
                                             'Nom de l''activite: ' || v_reservations(i).nom_activite ||
                                             'Capacité de l''activité ' || v_reservations(i).capacite_max ||
                                             'Nombre d''inscrits: ' || v_reservations(i).nombre_inscrits);
                    EXCEPTION
                        WHEN OTHERS THEN
                            DBMS_OUTPUT.PUT_LINE('Erreur lors de l''affichage de la réservation ' || v_reservations(i).id ||
                                                 ' : ' || SQLCODE || ' - ' || SQLERRM);
                    end;
                end loop;
        end if;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur lors de l''exécution de la procédure : ' || SQLCODE || ' - ' || SQLERRM);
            RAISE;
    end;

--get_membres_activites : Retourne la liste des membres inscrits à une activité donnée en paramètre.
    FUNCTION get_membres_activite(p_id_activite number) RETURN t_membre is
        v_membres t_membre;
    begin
        begin
            SELECT m.nom_membre, m.prenom_membre, r.date_reservation
                    BULK COLLECT INTO v_membres
            FROM MEMBRES m
                     JOIN RESERVATIONS r ON m.id_membre = r.id_membre
            WHERE r.id_activite = p_id_activite;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Aucun membre trouvé pour l''activité ID ' || p_id_activite);
                RETURN v_membres;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erreur lors de la récupération des membres pour l''activité ' || p_id_activite || ' : ' || SQLCODE || ' - ' || SQLERRM);
                RETURN v_membres;
        end;
        return v_membres;
    end get_membres_activite;
end;
