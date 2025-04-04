-- BLOCS ANONYMES

-- 1
-- Pour une activité donnée (choisir un id_activite), récupérez la capacité maximale et
-- le nombre de réservations existantes pour cette activité. Affichez ensuite l’état de l’activité
-- (Disponible, Presque pleine, Complète) en fonction du nombre de places disponibles. L’activité est
-- considérée comme étant presque pleine si le nombre de places disponibles est inférieur à 20% de la capacité maximale.

<<Numéro_1>>
DECLARE
k_id_activite number := 26;
    v_capacite_maximale ACTIVITIES.CAPACITE_MAX%type := 0;
    v_nb_reservation_actuelle number := 0;
    v_places_disponibles ACTIVITIES.CAPACITE_MAX%type := 0;
    v_pourcentage_capacite_max_activite number;
    v_etat_activite varchar2(50) := null;
    k_capacite_presque_pleine number := 20;
    k_capacite_pleine number := 0;
BEGIN
Select CAPACITE_MAX
Into v_capacite_maximale
from ACTIVITIES
where ID_ACTIVITE = k_id_activite;

select count(ID_ACTIVITE)
into v_nb_reservation_actuelle
from RESERVATIONS
where ID_ACTIVITE = k_id_activite;

v_places_disponibles := v_capacite_maximale - v_nb_reservation_actuelle;
    v_pourcentage_capacite_max_activite := v_places_disponibles / v_capacite_maximale * 100;

    v_etat_activite := case
        when v_pourcentage_capacite_max_activite > k_capacite_presque_pleine Then 'Disponible'
        when v_pourcentage_capacite_max_activite = k_capacite_pleine then 'Complète'
        else 'Presque pleine'
End;

    dbms_output.put_line('État activité: ' || v_etat_activite);
END Numéro_1;


-- 2
-- Écrivez un bloc anonyme qui affiche les paiements supérieurs à 50$. Vous devez effectuer les
-- traitements suivants :
    -- Créez un RECORD nommé r_paiement afin de stocker les informations sur les
    -- paiements.
--
    -- Créez une collection de type TABLE nommée t_paiements afin de stocker tous les
    -- paiements.

    -- Chargez les paiements de la table des paiements vers la collection que vous venez de
    -- créer.
-- -
    -- Parcourez ensuite la collection des paiements afin de n’afficher que les paiements qui
    -- dépassent 50$

<<Numéro_2>>
DECLARE
TYPE r_paiements_type is record(
        ID_MEMBRE number,
        MONTANT number(10,2),
        DATE_PAIEMENT date,
        TYPE_PAIEMENT varchar2(50)
       );
    r_paiements r_paiements_type;

    TYPE t_paiements_type Is TABLE OF r_paiements_type;
    t_collection_paiements t_paiements_type := t_paiements_type();
BEGIN
for paiement in (SELECT ID_MEMBRE, MONTANT, DATE_PAIEMENT, TYPE_PAIEMENT FROM PAIEMENTS) loop
        r_paiements.ID_MEMBRE := paiement.ID_MEMBRE;
        r_paiements.MONTANT := paiement.MONTANT;
        r_paiements.DATE_PAIEMENT := paiement.DATE_PAIEMENT;
        r_paiements.TYPE_PAIEMENT := paiement.TYPE_PAIEMENT;

        t_collection_paiements.extend;
        t_collection_paiements(t_collection_paiements.LAST) := r_paiements;
end loop;

for i in 1..t_collection_paiements.COUNT loop
        if t_collection_paiements(i).MONTANT > 50 then
            dbms_output.PUT_LINE('Paiment ID: ' || t_collection_paiements(i).ID_MEMBRE ||
                                    'Montant: ' || t_collection_paiements(i).MONTANT ||
                                    'Date paiement: ' || t_collection_paiements(i).DATE_PAIEMENT ||
                                    'Type paiement: ' || t_collection_paiements(i).TYPE_PAIEMENT);
end if;
end loop;
END Numéro_2;
