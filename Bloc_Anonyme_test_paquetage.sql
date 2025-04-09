--3 - Fournissez le bloc anonyme qui servira à tester les fonctions que vous venez de définir
DECLARE
v_reservations PKG_GESTION_RESERVATION.t_reservation;
    v_membres PKG_GESTION_RESERVATION.t_membre;
BEGIN
    PKG_GESTION_RESERVATION.ajouter_reservation(TO_DATE('2025-12-31', 'YYYY-MM-DD'), 11, 26);
    PKG_GESTION_RESERVATION.modifier_reservation(TO_DATE('2025-12-31', 'YYYY-MM-DD'), 11, 26, 25);

    v_reservations := PKG_GESTION_RESERVATION.get_reservation_membre(26);

FOR i IN 1..v_reservations.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Id réservation: ' || v_reservations(i).id ||
                                 ', Date de réservation: ' || v_reservations(i).date_reservation ||
                                 ', Nom de l''activité: ' || v_reservations(i).nom_activite ||
                                 ', Capacité maximale: ' || v_reservations(i).capacite_max ||
                                 ', Nombre d''inscrits: ' || v_reservations(i).nombre_inscrits);
END LOOP;

    v_membres := PKG_GESTION_RESERVATION.get_membres_activite(26);

FOR j IN 1..v_membres.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Nom: ' || v_membres(j).nom ||
                                 ', Prénom: ' || v_membres(j).prenom ||
                                 ', Date de réservation: ' || v_membres(j).date_reservation);
END LOOP;

    PKG_GESTION_RESERVATION.annuler_reservation(46);
END;