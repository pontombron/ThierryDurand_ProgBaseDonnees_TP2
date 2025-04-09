--FONCTIONS/ PROCÉDURES STOCKÉES

create or replace package body pkg_gestion_reservation as

--activite_est_disponible : permet de vérifier si une activité dont l’identifiant est passé en paramètre est
-- disponible ou non en comparant le nombre de réservations à la capacité maximale. Cette fonction retourne un
-- résultat booléen.
    FUNCTION activite_est_disponible(p_id_activite number) return boolean is
        v_est_disponible boolean := false;
        v_capacite_maximale ACTIVITIES.CAPACITE_MAX%type := 0;
        v_nb_reservation_actuelle number := 0;
begin
   Select CAPACITE_MAX
   Into v_capacite_maximale
   from ACTIVITIES
   where ID_ACTIVITE = p_id_activite;

select count(ID_ACTIVITE)
into v_nb_reservation_actuelle
from RESERVATIONS
where ID_ACTIVITE = p_id_activite;

if v_capacite_maximale > v_nb_reservation_actuelle then
            v_est_disponible := true;
end if;

return v_est_disponible;
end activite_est_disponible;

--ajouter_reservation : Pour un membre et une activité donnée, cette procédure permet d’ajouter une nouvelle réservation
-- après avoir vérifié si l’activité est disponible. Pensez à utiliser la fonction précédente. Affichez dans la console
-- de sortie un message confirmant la réservation ou bien informant l’utilisateur qu’il n’y a pas de places disponibles.
    PROCEDURE ajouter_reservation(p_date_reservation date, p_id_membre number, p_id_activite number) is
        v_est_disponible boolean := false;

begin
        v_est_disponible := activite_est_disponible(p_id_activite);

        if v_est_disponible then
            Insert Into RESERVATIONS(DATE_RESERVATION,ID_MEMBRE,ID_ACTIVITE)
            values (p_date_reservation,p_id_membre,p_id_activite);
            DBMS_OUTPUT.PUT_LINE('reservation effecutée avec succès');
ELSE
            DBMS_OUTPUT.PUT_LINE('Il ne reste plus de place pour cette activité');
end if;
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
ELSE
            DBMS_OUTPUT.PUT_LINE('Il ne reste plus de place pour cette activité.');
end if;
end;

--annuler_resevation : Supprimer une réservation dont l’identifiant est passé en paramètre. Cette procédure ne retourne
-- aucun résultat, mais affiche dans la console de sortie que la réservation a bien été supprimée.
    procedure annuler_reservation(p_id_reservation number) is
begin
Delete from RESERVATIONS
where ID_RESERVATION = p_id_reservation;

DBMS_OUTPUT.PUT_LINE('L''activité a bien été supprimée');
end;

--get_reservations_membre : Pour un id_membre passé en paramètre, cette fonction récupère la liste de toutes les
-- réservations qui les concerne, les stocke dans un tableau de réservations et retourne comme résultat ce tableau.
    FUNCTION get_reservation_membre(p_id_membre number) RETURN t_reservation is
        v_reservations t_reservation;
BEGIN
SELECT r.id_reservation, r.date_reservation, a.nom_activite, a.capacite_max
    BULK COLLECT INTO v_reservations
FROM RESERVATIONS r
         JOIN ACTIVITIES a ON r.id_activite = a.id_activite
WHERE r.id_membre = p_id_membre;

FOR i IN 1..v_reservations.COUNT LOOP
SELECT COUNT(*)
INTO v_reservations(i).nombre_inscrits
FROM RESERVATIONS
WHERE ID_ACTIVITE = v_reservations(i).id;
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
                    dbms_output.PUT_LINE('Id réservation: ' || v_reservations(i).id ||
                                         'Date de réservation: ' || v_reservations(i).date_reservation ||
                                         'Nom de l''activite: ' || v_reservations(i).nom_activite ||
                                         'Capacité de l''activité ' || v_reservations(i).capacite_max ||
                                         'Nombre d''inscrits: ' || v_reservations(i).nombre_inscrits);
end loop;
end if;
end;

--get_membres_activites : Retourne la liste des membres inscrits à une activité donnée en paramètre.
    FUNCTION get_membres_activite(p_id_activite number) RETURN t_membre is
        v_membres t_membre;
begin
SELECT m.nom_membre, m.prenom_membre, r.date_reservation
    BULK COLLECT INTO v_membres
FROM MEMBRES m
         JOIN RESERVATIONS r ON m.id_membre = r.id_membre
WHERE r.id_activite = p_id_activite;

RETURN v_membres;
end get_membres_activite;
end;


