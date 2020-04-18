CREATE OR REPLACE FUNCTION ASTER_date_systeme(p_format IN CHAR := '%d/%m/%Y %H:%M:%S',  p_resultat OUT VARCHAR2)
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_date_systeme
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 30/08/2001
-- ---------------------------------------------------------------------------
-- Role          : Renvoie la date du système d'exploitation dans un format donné
--
-- Parametres    :
-- 				 1 - p_format : Format de la date a renvoyer (format C - cf fonction strftime)
--				   	 La valeur par defaut fournit un exemple de format
-- 				 2 - p_resultat : Variable réceptacle
--
-- Valeur retournee : Aucun
--
-- Appels		 : PACKAGE DBMS_SQL
-- ---------------------------------------------------------------------------
--  Version        : @(#) ASTER_date_systeme.sql version 2.1-1.0 : SNE : 30/08/2001
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) ASTER_date_systeme.sql 2.1-1.0	|30/08/2001 | SNE	| Création
---------------------------------------------------------------------------------------
*/
   RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "COMMUN_Date_du_jour"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION ASTER_efface_fichier(p_separateur_chemin IN CHAR )
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_efface_fichier
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 01/10/2001
-- ---------------------------------------------------------------------------
-- Role          : Supprime un fichier en utilisant les services du système d'exploitation
--		       (librairie PIAF_system)
-- Parametres    : voir librairie
--
-- Valeur retournee : 0 - OK
--                    Autre - Probleme
-- Appels		 :
-- -------------------------------------------------------------------------------------
--  Version        : @(#) ASTER_efface_fichier.sql version 2.1-1.0 : SNE : 01/10/2001
-- -------------------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) ASTER_efface_fichier.sql 1.0	|08/08/2001 | SNE	| Création
---------------------------------------------------------------------------------------
*/
  RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "ASTER_efface_fichier"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION ASTER_env_param(p_separateur_chemin OUT CHAR
								, p_separateur_var_path OUT CHAR)
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_env_param
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 08/08/2001
-- ---------------------------------------------------------------------------
-- Role          : Renvoie les parametres lies a l'environnement d'exécution
--		       (librairie PIAF_system)
-- Parametres    : voir librairie
--
-- Valeur retournee : 0 - OK
--                    Autre - Probleme
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) ASTER_env_param.sql version 2.1-1.0 : SNE : 08/08/2001
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) ASTER_env_param.sql 1.0	|08/08/2001 | SNE	| Création
---------------------------------------------------------------------------------------
*/
  RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "ASTER_env_param"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION ASTER_executer_commande(p_commande IN CHAR, p_nom_fichier IN CHAR := NULL, p_fichier_sortie IN CHAR := NULL)
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_executer_commande
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 26/09/2001
-- ---------------------------------------------------------------------------
-- Role          : Execute une commande via le système d'exploitation et attend
-- 				   la fin de la commande avant de rendre la main
--				   ATTENTION : La commande est exécuté par le serveur (UNIX ou WINDOWS NT)
--
-- Parametres    : (voir librairie)
-- 				   1 - p_commande :  ligne de commande a lancer
-- 				   2 - p_nom_fichier : nom du fichier script à créer et à exécuter
--				   	    (permet de ne pas lancer des commandes avec des mots de passe décryptés)
-- 				   3 - p_fichier_sortie : fichier vers lequel des sorties doivent être redirigées
--
-- Valeur retournee :
-- 		  0 - OK
-- 		  2 - Fichier non trouvé
-- 		  13 - Fichier verrouillé (problème de permission sur le fichier à exécuter)
--         Autre - Probleme (erreur système à interpreter)
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) ASTER_executer_commande.sql version 2.1-1.0
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					            	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) ASTER_executer_commande.sql 2.1-1.0	|26/09/2001 | SNE	| Création
---------------------------------------------------------------------------------------
*/
  RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "COMMUN_lancer_commande"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION ASTER_extension_fic_shell(p_extension OUT CHAR)
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_extension_fic_shell
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 26/09/2001
-- ---------------------------------------------------------------------------
-- Role          : Renvoie l'extension des fichiers de type 'scripts shell' en fonction
-- 				   du système d'exploitation du serveur (UNIX *.sh, Windows NT *.BAT)
--		       (librairie PIAF_system)
-- Parametres    : (voir librairie)
-- 				   p_extension : variable receptacle
--
-- Valeur retournee :
-- 		  0 - OK
--                    Autre - Probleme
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) ASTER_extension_fic_shell.sql version 2.1-1.0
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------
-- 	Fonction					   	   			|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------
-- @(#) ASTER_extension_fic_shell.sql 2.1-1.0	|26/09/2001 | SNE	| Création
---------------------------------------------------------------------------------------
*/
  RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "COMMUN_Extension_Shell"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION ASTER_ext_erreur_traitement(p_fichier_log IN CHAR, p_tag_message IN CHAR, p_erreur OUT CHAR)
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_ext_erreur_traitement
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 26/09/2001
-- ---------------------------------------------------------------------------
-- Role          : Recherche d'éventuels messages d'erreur dans un fichier de
-- 				   trace (librairie PIAF_system)
--
-- Parametres    : (voir librairie)
-- 				   1- p_fichier_log : Nom du fichier de trace à scanner
-- 				   2- p_tag_message : 'Pattern' de recherche (peut contenir les caractères joker  qui sont:
--				   	  				'^' : en debut du pattern indique que la chaine recherchée doit être en début de ligne
--				   	  				'$' : à la fin du pattern indique que la chaine recherchée doit être en fin de ligne
-- 				   3- p_erreur  : libellé de l'erreur trouvée dans le fichier de trace s'il y en a
--				       			ATTENTION : Cette chaine est limitée à 100 caractères
--
-- Valeur retournee :
-- 		  0 - OK
--                    Autre - Probleme
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) ASTER_ext_erreur_traitement.sql version 2.1-1.0
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					            	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) ASTER_ext_erreur_traitement.sql 2.1-1.0	|26/09/2001 | SNE	| Création
---------------------------------------------------------------------------------------
*/
 RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "COMMUN_lire_message_erreur"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION ASTER_get_date_fichier(p_fichier CHAR,
                                                  p_type_date CHAR,
												  p_date OUT CHAR,
												  p_heure OUT CHAR)
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_get_date_fichier
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 21/02/2003
-- ---------------------------------------------------------------------------
-- Role          : Recupere la date (creation/acces/modif) d'un fichier
--		       (librairie PIAF_system)
-- Parametres    : voir librairie
--
-- Valeur retournee : 0 - OK
--                    Autre - Probleme
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) ASTER_env_param.sql version 3.0d-1.0
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) ASTER_get_date_fichier.sql 3.0d-1.0	|21/02/2002 | SGN	| Création
---------------------------------------------------------------------------------------
*/
  RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "ASTER_get_date_fichier"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION ASTER_get_passwd(p_cfg_file IN CHAR, p_instance IN CHAR, p_cod_util IN CHAR, p_mot_de_passe OUT CHAR)
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_get_passwd
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 26/09/2001
-- ---------------------------------------------------------------------------
-- Role          : Lecture du mot de passe d'un utilisateur dans le fichier de configuration des utilisateurs
--		       (librairie PIAF_system)
-- Parametres    : (voir librairie)
--	   En entrée
-- 				   1 - p_cfg_file : Nom du fichier de configuration generale (Parametre IR00048)
--				   2 - p_instance  : Nom de l'instance de la base
--				   3 - p_cod_util : Code de l'utilisateur dont on cherche le mot de passe
--	   En sortie
--				   4 - p_mot_de_passe : Variable réceptacle (recoit le mot de passe qui figure dans le fichier)
--
-- Valeur retournee :
-- 		  0 - OK
--		  -12 : Fichier de configuration non trouvé
--		  -13 : Utilisateur non trouvé dans le fichier de configuration
--
--                    Autre - Probleme
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) ASTER_get_passwd.sql version 2.1-1.0
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					    	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) ASTER_get_passwd.sql 2.1-1.0	|26/09/2001 | SNE	| Création
---------------------------------------------------------------------------------------
*/
  RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "COMMUN_get_passwd"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION ASTER_get_Version(p_version OUT CHAR)
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_get_Version
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 26/09/2001
-- ---------------------------------------------------------------------------
-- Role          : Renvoie le numéro de version interne d'ASTER
--		       (librairie PIAF_system)
-- Parametres    : (voir librairie)
-- 				   p_version : variable receptacle
--
-- Valeur retournee :
-- 		  0 - OK
--                    Autre - Probleme
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) ASTER_get_Version.sql version 2.1-1.0
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) ASTER_get_Version.sql 2.1-1.0	|26/09/2001 | SNE	| Création
---------------------------------------------------------------------------------------
*/
  RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "COMMUN_Get_Version_Aster"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION ASTER_is_fichier_perime (p_fichier CHAR,
                                                    p_date_trt CHAR,
												    p_duree_conservation CHAR )
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_get_date_fichier
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 21/02/2003
-- ---------------------------------------------------------------------------
-- Role          : Determine si un fichier est perimé
--		       (librairie PIAF_system)
-- Parametres    : voir librairie
--
-- Valeur retournee : 0 - OK
--                    Autre - Probleme
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) ASTER_env_param.sql version 3.0d-1.0
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) ASTER_is_fichier_perime.sql 3.0d-1.0	|21/02/2002 | SGN	| Création
---------------------------------------------------------------------------------------
*/
  RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "ASTER_is_fichier_perime"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION ASTER_lire_info(p_cfg_file IN CHAR, p_instance IN CHAR, p_nom_variable IN CHAR, p_valeur OUT CHAR)
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_lire_info
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 26/09/2001
-- ---------------------------------------------------------------------------
-- Role          : Recherche d'une information (variable ASTER) dans un fichier de configuration générale
--		       (librairie PIAF_system)
-- Parametres    : (voir librairie)
--	   En entrée
-- 				   1 - p_cfg_file : Nom du fichier de configuration generale (Parametre IR00048)
--				   2 - p_instance  : Nom de l'instance de la base
--				   3 - p_nom_variable : Nom de la variable ASTER (information du fichier de configuration)
--	   En sortie
--				   4 - p_valeur : Variable réceptacle (recoit la valeur de la variable recherchee)
--
-- Valeur retournee :
-- 		  0 - OK
--		  -11 : Variable non définie ou environnement non paramétrée
--		  -12 : Fichier de configuration non trouvé
--
--                    Autre - Probleme
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) ASTER_lire_info.sql version 2.1-1.0
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					    	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) ASTER_lire_info.sql 2.1-1.0	|26/09/2001 | SNE	| Création
---------------------------------------------------------------------------------------
*/
  RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "COMMUN_lire_info"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION ASTER_Purge_Liste_Fichiers(p_npm_rep CHAR,
                                                  p_ext_fic CHAR,
												  p_dat_trt CHAR,
												  p_duree_conservation CHAR)
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_Purge_Liste_Fichiers
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 26/02/2003
-- ---------------------------------------------------------------------------
-- Role          : Purge un repertoire
--		       (librairie PIAF_system)
-- Parametres    : voir librairie
--
-- Valeur retournee : 0 - OK
--                    Autre - Probleme
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) ASTER_Purge_Liste_Fichiers.sql version 3.0d-1.0
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) ASTER_Purge_Liste_Fichiers.sql 3.0d-1.0	|26/02/2002 | SGN	| Création
---------------------------------------------------------------------------------------
*/
  RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "ASTER_Purge_Liste_Fichiers"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION CAL_Bilan(P_ENTITE        ex_axe.ide_entite%TYPE,
                   P_AXE1          ex_axe.ide_elem_axe%TYPE,
                   P_AXE2          ex_axe.ide_elem_axe%TYPE,
                   P_AXE3          ex_axe.ide_elem_axe%TYPE,
                   P_FEUILLE       ex_axe.flg_feuille%TYPE,
                   P_OUI           sr_codif.cod_codif%TYPE,
                   P_BRUT          ex_axe.ide_elem_axe%TYPE,
                   P_AMORT         ex_axe.ide_elem_axe%TYPE,
                   P_NET           ex_axe.ide_elem_axe%TYPE,
                   P_VARI          ex_axe.ide_elem_axe%TYPE) RETURN NUMBER IS

  v_mtnet1     ex_valeurs.mt%TYPE;
  v_mtnet2     ex_valeurs.mt%TYPE;
  v_montantb   ex_valeurs.mt%TYPE;
  v_montanta   ex_valeurs.mt%TYPE;
  v_axe1       ex_axe.ide_elem_axe%TYPE;
  v_retour     NUMBER;
  v_oui        sr_codif.cod_codif%TYPE;
  v_libl       sr_codif.libl%TYPE;

  CURSOR c_valeur(PC_ENTITE   ex_axe.ide_entite%TYPE,
                  PC_AXE1     ex_axe.ide_elem_axe%TYPE,
                  PC_AXE2     ex_axe.ide_elem_axe%TYPE,
                  PC_AXE3     ex_axe.ide_elem_axe%TYPE) IS
    SELECT mt   Montant
    FROM ex_valeurs
    WHERE ide_entite = PC_ENTITE
      AND ide_elem_axe1 = PC_AXE1
      AND ide_elem_axe2 = PC_AXE2
      AND ide_elem_axe3 = PC_AXE3
      AND ide_elem_axe4 IS NULL
      AND ide_elem_axe5 IS NULL
      AND ide_elem_axe6 IS NULL
      AND ide_elem_axe7 IS NULL;

  CURSOR c_axe(PC_ENTITE   ex_axe.ide_entite%TYPE,
               PC_AXE1     ex_axe.ide_elem_axe%TYPE,
               PC_AXE2     ex_axe.ide_elem_axe%TYPE,
               PC_AXE3     ex_axe.ide_elem_axe%TYPE) IS
    SELECT A.ide_elem_axe    Axe1,
           B.ide_elem_axe    Axe2,
           B.flg_feuille     Feuille,
           C.ide_elem_axe    Axe3
    FROM EX_AXE A, EX_AXE B, EX_AXE C
      WHERE A.ide_entite = PC_ENTITE
        AND B.ide_entite = PC_ENTITE
        AND C.ide_entite = PC_ENTITE
        AND A.ide_num_axe = 1
        AND B.ide_num_axe = 2
        AND C.ide_num_axe = 3
        AND B.ide_pere = PC_AXE2
        AND A.ide_elem_axe = PC_AXE1
        AND C.ide_elem_axe = PC_AXE3;

  CURSOR c_gestionmin(PC_ENTITE   ex_axe.ide_entite%TYPE) IS
    SELECT ide_elem_axe    Gestion
    FROM EX_AXE
    WHERE ide_entite = PC_ENTITE
      AND ide_num_axe = 1
      AND TO_DATE(libl3) = (SELECT MIN(TO_DATE(libl3))
                            FROM ex_axe
                            WHERE ide_entite = PC_ENTITE
                              AND ide_num_axe = 1);

BEGIN

  IF P_OUI IS NULL THEN
    EXT_Codext('OUI_NON','O',v_libl,v_oui,v_retour);
    IF v_retour != 1 THEN
      Return(0);
    END IF;

  ELSE
    v_oui := P_OUI;
  END IF;

  /* ---------------------------------------------------------------------------------------- */
  IF P_FEUILLE = v_oui THEN

    IF P_AXE3 != P_NET AND
       P_AXE3 != P_VARI THEN

      -- Recuperation du montant si existe dans ex_valeurs
      ----------------------------------------------------
      v_montantb := 0;
      FOR l_valeur IN c_valeur(P_ENTITE,P_AXE1,P_AXE2,P_AXE3)
      LOOP
        v_montantb := l_valeur.Montant;
        Exit;
      END LOOP;

      Return(NVL(v_montantb,0));

    ELSIF P_AXE3 = P_VARI THEN

      -- Calcul du montant variation
      ------------------------------
      v_axe1 := NULL;
      FOR l_gestion IN c_gestionmin(P_ENTITE)
      LOOP
        v_axe1 := l_gestion.Gestion;
        Exit;
      END LOOP;

      IF v_axe1 IS NULL OR
         v_axe1 = P_AXE1 THEN

        Return(0);

      ELSE

        -- Calcul du montant net annee courante
        ---------------------------------------
        v_montantb := 0;
        FOR l_valeur IN c_valeur(P_ENTITE,P_AXE1,P_AXE2,P_BRUT)
        LOOP
          v_montantb := l_valeur.Montant;
          Exit;
        END LOOP;

        v_montanta := 0;
        FOR l_valeur IN c_valeur(P_ENTITE,P_AXE1,P_AXE2,P_AMORT)
        LOOP
          v_montanta := l_valeur.Montant;
          Exit;
        END LOOP;

        v_mtnet1 := NVL(v_montantb,0) - NVL(v_montanta,0);

        -- Calcul du montant net annee - 1
        ----------------------------------
        v_montantb := 0;
        FOR l_valeur IN c_valeur(P_ENTITE,v_axe1,P_AXE2,P_BRUT)
        LOOP
          v_montantb := l_valeur.Montant;
          Exit;
        END LOOP;

        v_montanta := 0;
        FOR l_valeur IN c_valeur(P_ENTITE,v_axe1,P_AXE2,P_AMORT)
        LOOP
          v_montanta := l_valeur.Montant;
          Exit;
        END LOOP;

        v_mtnet2 := NVL(v_montantb,0) - NVL(v_montanta,0);

        Return(NVL(v_mtnet1,0) - NVL(v_mtnet2,0));

      END IF;

    ELSE

      -- Calcul du montant net
      ------------------------
      v_montantb := 0;
      FOR l_valeur IN c_valeur(P_ENTITE,P_AXE1,P_AXE2,P_BRUT)
      LOOP
        v_montantb := l_valeur.Montant;
        exit;
      END LOOP;

      v_montanta := 0;
      FOR l_valeur IN c_valeur(P_ENTITE,P_AXE1,P_AXE2,P_AMORT)
      LOOP
        v_montanta := l_valeur.Montant;
        exit;
      END LOOP;

      Return(NVL(v_montantb,0) - NVL(v_montanta,0));

    END IF;

  ELSE

  /* ---------------------------------------------------------------------------------------- */

    /* Calcul d'un sous-total */
    IF P_AXE3 != P_NET AND
       P_AXE3 != P_VARI THEN

      v_montantb := 0;
      FOR l_axe IN c_axe(P_ENTITE,P_AXE1,P_AXE2,P_AXE3)
      LOOP
        v_montantb := v_montantb +
                      CAL_Bilan(P_ENTITE,l_axe.Axe1,l_axe.Axe2,l_axe.Axe3,
                                l_axe.Feuille,v_oui,P_BRUT,P_AMORT,P_NET,P_VARI);
      END LOOP;

      Return(NVL(v_montantb,0));

    ELSIF P_AXE3 = P_VARI THEN

      v_axe1 := NULL;
      FOR l_gestion IN c_gestionmin(P_ENTITE)
      LOOP
        v_axe1 := l_gestion.Gestion;
        Exit;
      END LOOP;

      IF v_axe1 IS NULL OR
         v_axe1 = P_AXE1 THEN

        Return(0);

      ELSE

        v_montantb := 0;
        FOR l_axe IN c_axe(P_ENTITE,P_AXE1,P_AXE2,P_AXE3)
        LOOP
          v_montantb := v_montantb +
                        CAL_Bilan(P_ENTITE,l_axe.Axe1,l_axe.Axe2,P_BRUT,
                                  l_axe.Feuille,v_oui,P_BRUT,P_AMORT,P_NET,P_VARI);
        END LOOP;

        v_montanta := 0;
        FOR l_axe IN c_axe(P_ENTITE,P_AXE1,P_AXE2,P_AXE3)
        LOOP
          v_montanta := v_montanta +
                        CAL_Bilan(P_ENTITE,l_axe.Axe1,l_axe.Axe2,P_AMORT,
                                  l_axe.Feuille,v_oui,P_BRUT,P_AMORT,P_NET,P_VARI);
        END LOOP;

        v_mtnet1 := NVL(v_montantb,0) - NVL(v_montanta,0);

        v_montantb := 0;
        FOR l_axe IN c_axe(P_ENTITE,v_axe1,P_AXE2,P_AXE3)
        LOOP
          v_montantb := v_montantb +
                        CAL_Bilan(P_ENTITE,l_axe.Axe1,l_axe.Axe2,P_BRUT,
                                  l_axe.Feuille,v_oui,P_BRUT,P_AMORT,P_NET,P_VARI);
        END LOOP;

        v_montanta := 0;
        FOR l_axe IN c_axe(P_ENTITE,v_axe1,P_AXE2,P_AXE3)
        LOOP
          v_montanta := v_montanta +
                        CAL_Bilan(P_ENTITE,l_axe.Axe1,l_axe.Axe2,P_AMORT,
                                  l_axe.Feuille,v_oui,P_BRUT,P_AMORT,P_NET,P_VARI);
        END LOOP;

        v_mtnet2 := NVL(v_montantb,0) - NVL(v_montanta,0);

        Return(NVL(v_mtnet1,0) - NVL(v_mtnet2,0));

      END IF;

    ELSE

      v_montantb := 0;
      FOR l_axe IN c_axe(P_ENTITE,P_AXE1,P_AXE2,P_AXE3)
      LOOP
        v_montantb := v_montantb +
                      CAL_Bilan(P_ENTITE,l_axe.Axe1,l_axe.Axe2,P_BRUT,
                                l_axe.Feuille,v_oui,P_BRUT,P_AMORT,P_NET,P_VARI);
      END LOOP;

      v_montanta := 0;
      FOR l_axe IN c_axe(P_ENTITE,P_AXE1,P_AXE2,P_AXE3)
      LOOP
        v_montanta := v_montanta +
                      CAL_Bilan(P_ENTITE,l_axe.Axe1,l_axe.Axe2,P_AMORT,
                                l_axe.Feuille,v_oui,P_BRUT,P_AMORT,P_NET,P_VARI);
      END LOOP;

      Return(NVL(v_montantb,0) - NVL(v_montanta,0));

    END IF;

  END IF;


EXCEPTION
  WHEN Others THEN
    Return(0);

END CAL_Bilan;

/

CREATE OR REPLACE FUNCTION Cal_Code_Rejet (
                                          p_env IN VARCHAR2,
                                          p_code IN VARCHAR2,
										  p_ide_poste FB_PIECE.ide_poste%TYPE,
										  p_ide_gest  FB_PIECE.ide_gest%TYPE,
										  p_ide_ordo  FB_PIECE.ide_ordo%TYPE,
										  p_cod_bud   FB_PIECE.cod_bud%TYPE,
										  p_param_renumetoration IN OUT SR_PARAM.IDE_PARAM%TYPE,
										  p_new_code IN OUT VARCHAR2
										  )
RETURN NUMBER IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : PARAMETRAGE
-- Nom           : CAL_CODE_REJET
-- ---------------------------------------------------------------------------
--  Auteur         : LGD
--  Date creation  : 13/05/2003
-- ---------------------------------------------------------------------------
-- Role          :
--
-- Parametres  entree  :
-- 				 1 - p_env : Environnement définissant le type du code rejet à calculer (pièce ou engagement)
--				 2 - p_code : Code pour identifier si d'autre rejet ont été déjà effectués
--               3 - p_ide_poste : Poste de la pièce ou de l'engagement
--		         4 - p_ide_gest  : Gestion de la pièce ou de l'engagement,
--				 5 - p_ide_ordo : Ordonnateur de la pièce ou de l'engagement,
--				 6 - p_cod_bud   Code budget de la pièce ou de l'engagement,
--
-- Parametres  en sortie  :
--               3 - p_param_renumerotation : N° du paramètre indiquant si la renumérotaion est à faire
--               4 - p_new_code : Nouveau code de renumérotaion
--
-- Valeur  retournée en sortie :
--                              0 => Contrôle OK : Pas besoin de Renumérotation
--				                1 => Contrôle OK : Renumérotation dejà faite. Renum +1 faite
--                              2 => Contrôle OK : Pas de rejet avant. On peut créer la renuérotation en démarrant la séquence à 01.
--                             -1 => Contrôle KO : Impossible de faire le contrôle de renumérotation
--                             -2 => Contrôle KO : Erreur lors de la récupération du paramètre indiquant si un contrôle de saisie doit être fait (paramètre %1).
--                             -3 => Contrôle KO : Le numéro -99 existe déjà, le rejet de l'ordonnance est impossible
--
-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_CODE_REJET.sql version 3.1-1.1
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) CAL_CODE_REJET.sql 3.0-1.0	|13/05/2003| LGD	| Initialisation
-- @(#) CAL_CODE_REJET.sql 3.3-1.1	|01/09/2003| LGD	| Aster V3.3 - Evolution 34 et 36
-- 	----------------------------------------------------------------------------------------------------------
*/

v_codint_param_renumerot SR_CODIF.ide_codif%TYPE;
v_ret NUMBER;
v_libl SR_CODIF.libl%TYPE;
v_cod_typ_piece SR_CODIF.ide_codif%TYPE;
v_dernier_code_rejet VARCHAR2(120);
v_sequence VARCHAR2(120);
v_val_cod_ext_od SR_CODIF.cod_codif%TYPE;
v_val_cod_ext_or SR_CODIF.cod_codif%TYPE;
v_val_cod_ext_rejete SR_CODIF.cod_codif%TYPE;


BEGIN

  --1) Contrôle des paramètres en entrée
  IF P_ENV IS NOT NULL THEN
    --- Si le code saisi est null aucun contrôle ne doit être fait
	IF P_CODE IS NULL THEN
	  --- Pas de renumérotation
	  p_new_code := p_code;
	  RETURN(0);
	END IF;
  ELSE
    --- Impossible de faire le contrôle de renumérotation
    RETURN(-1);
  END IF;


  -- 1.1) Contrôle sur la longueur du code
  IF LENGTH(p_code)>17 THEN
      --- Pas de renumérotation
	  p_new_code := p_code;
	  RETURN(0);
  END IF;



  --2) Recherche si la renumérotation est autorisée ou pas

	  --2.1) Recherche des paramètres en fonction de l'environnement

	  Ext_Codext('TYPE_PIECE','OD',v_libl,v_val_cod_ext_od,v_ret);
	  IF v_ret=-1 OR v_ret=2 THEN
	    --- Impossible de faire le contrôle de renumérotation
		RETURN(-1);
	  END IF;

	  Ext_Codext('TYPE_PIECE','OR',v_libl,v_val_cod_ext_or,v_ret);
	  IF v_ret=-1 OR v_ret=2 THEN
	    --- Impossible de faire le contrôle de renumérotation
		RETURN(-1);
	  END IF;
	  /*
	  EXT_Codext('STATUT_PIECE','J',v_libl,v_val_cod_ext_rejete,v_ret);
	  If v_ret=-1 or v_ret=2 then
	    --- Impossible de faire le contrôle de renumérotation
		RETURN(-1);
	  end if; */


	  IF P_ENV = 'IDE_ENG' THEN
	    --- prévision des prochains dev
	    p_param_renumetoration :='IB0076';
	  ELSIF P_ENV = 'IDE_ORDO' THEN
	    p_param_renumetoration :='IB0075';
		v_cod_typ_piece :=v_val_cod_ext_od;
	  ELSIF P_ENV = 'IDE_ORE7' THEN
	    --- prévision des prochains dev
	    p_param_renumetoration :='IB0077';
		v_cod_typ_piece := v_val_cod_ext_or;
	  ELSE
	    --- Impossible de faire le contrôle de renumérotation
	    RETURN(-1);
	  END IF;

	  --2.2) Recherche si la renumérotation est à faire
	  Ext_Param(p_param_renumetoration, v_codint_param_renumerot, v_ret);
	  IF v_ret != 1 THEN
	     -- Erreur lors de la récupération du paramètre indiquant si un contrôle de saisie doit être fait.
		 RETURN(-2);
	  ELSE
	    IF v_codint_param_renumerot ='N' THEN
		  --- Pas de renumérotation
		  p_new_code := p_code;
		  RETURN(0);
		END IF;
	  END IF;

  --3) Récupération du dernier code de renumératation

	IF p_env = 'IDE_ORDO' OR p_env = 'IDE_ORE7' THEN

     SELECT MAX(code) INTO v_dernier_code_rejet
       FROM
       (
       SELECT (SUBSTR(ide_piece,LENGTH(ide_piece)-1,2))  code FROM FB_PIECE
       WHERE
            ide_piece LIKE p_code||'%'
	   AND LENGTH(ide_piece)=LENGTH(p_code)+3
	   -- le premier des 3 derniers caractères doit être un '-'
	   AND (SUBSTR(ide_piece,LENGTH(ide_piece)-2,1)) = '-'
       --- Le deux derniers caractères doivent être numériques
       AND (SUBSTR(ide_piece,LENGTH(ide_piece)-1,1)) IN ('0','1','2','3','4','5','6','7','8','9')
       AND (SUBSTR(ide_piece,LENGTH(ide_piece),1)) IN ('0','1','2','3','4','5','6','7','8','9')
	   AND ide_poste = p_ide_poste
	   AND ide_gest = p_ide_gest
	   AND ide_ordo = p_ide_ordo
	   AND cod_bud = p_cod_bud
	   AND cod_typ_piece =  v_cod_typ_piece
	   );

	ELSIF p_env ='IDE_ENG' THEN
       /* En prévision des prochaines évolution */

     SELECT MAX(code) INTO v_dernier_code_rejet
       FROM
       (
       SELECT (SUBSTR(ide_eng,LENGTH(ide_eng)-1,2))  code FROM FB_ENG
       WHERE
            ide_eng LIKE p_code||'%'
	   AND LENGTH(ide_eng)=LENGTH(p_code)+3
	   -- le premier des 3 derniers caractères doit être un '-'
	   AND (SUBSTR(ide_eng,LENGTH(ide_eng)-2,1)) = '-'
       --- Le deux derniers caractères doivent être numériques
       AND (SUBSTR(ide_eng,LENGTH(ide_eng)-1,1)) IN ('0','1','2','3','4','5','6','7','8','9')
       AND (SUBSTR(ide_eng,LENGTH(ide_eng),1)) IN ('0','1','2','3','4','5','6','7','8','9')
	   AND ide_poste = p_ide_poste
	   AND ide_gest = p_ide_gest
	   AND ide_ordo = p_ide_ordo
	   AND cod_bud = p_cod_bud
	   );
	END IF;

	IF v_dernier_code_rejet IS NOT NULL THEN

	  IF v_dernier_code_rejet = '99' THEN
	    --- Le numéro -99 existe déjà, le rejet de l'ordonnance est impossible
	    RETURN(-3);
	  END IF;

	  v_sequence := LTRIM(TO_CHAR((TO_NUMBER(v_dernier_code_rejet)+1),'09'));
	  p_new_code:=p_code||'-'||v_sequence;
	  --- Renumérotation dejà faite. Renum +1 faite
	  RETURN(1);
	ELSE
	   --- Pas de rejet avant. On peut créer la renumérotation en démarrant la séquence à 01.
	   p_new_code := p_code||'-01';
	   RETURN(2);
	END IF;

EXCEPTION

  WHEN OTHERS THEN
    RAISE;
END Cal_Code_Rejet;

/

CREATE OR REPLACE FUNCTION Cal_Code_Rejet_mvt (
                                          p_env IN VARCHAR2,
                                          p_code IN VARCHAR2,
										  p_ide_poste FB_MVT_BUD.ide_poste%TYPE,
										  p_cod_typ_nd_emet  FB_MVT_BUD.cod_typ_nd_emet%TYPE,
										  p_ide_nd_emet FB_MVT_BUD.ide_nd_emet%TYPE,
										  p_ide_mess   FB_MVT_BUD.ide_mess%TYPE,
										  p_flg_emis_recu FB_MVT_BUD.flg_emis_recu%TYPE,
                         				  p_num_lig  FB_MVT_BUD.num_lig%TYPE,
										  p_param_renumetoration IN OUT SR_PARAM.IDE_PARAM%TYPE,
										  p_new_code IN OUT VARCHAR2
										  )
RETURN NUMBER IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : PARAMETRAGE
-- Nom           : CAL_CODE_REJET_MVT
-- ---------------------------------------------------------------------------
--  Auteur         : MCE
--  Date creation  : 27/12/2007
-- ---------------------------------------------------------------------------
-- Role          :
--
-- Parametres  entree  :
-- 				 1 - p_env : Environnement définissant le type du code rejet à calculer (pièce ou engagement)
--				 2 - p_code : Code pour identifier si d'autre rejet ont été déjà effectués
--               3 - p_ide_poste : Poste du mouvement budgétaire
--		         4 - p_cod_typ_nd_emet  : noeud emetteur
--				 5 - p_ide_nd_emet  : identifiant du noeud emetteur
--				 6 - p_ide_mess   : identifiant mesasge
--				 7 - p_flg_emis_recu : flag emis-reçu
--               8 - p_num_lig  : N° ligne du mouvement budgétaire
--
-- Parametres  en sortie  :
--               1 - p_param_renumerotation : N° du paramètre indiquant si la renumérotaion est à faire
--               2 - p_new_code : Nouveau code de renumérotaion
--
-- Valeur  retournée en sortie :
--                              0 => Contrôle OK : Pas besoin de Renumérotation
--				                1 => Contrôle OK : Renumérotation dejà faite. Renum +1 faite
--                              2 => Contrôle OK : Pas de rejet avant. On peut créer la renuérotation en démarrant la séquence à 01.
--                             -1 => Contrôle KO : Impossible de faire le contrôle de renumérotation
--                             -2 => Contrôle KO : Erreur lors de la récupération du paramètre indiquant si un contrôle de saisie doit être fait (paramètre %1).
--                             -3 => Contrôle KO : Le numéro -99 existe déjà, le rejet de l'ordonnance est impossible
--
-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_CODE_REJET_MVT.sql version 1
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) CAL_CODE_REJET_MVT.sql 		27/12/2007	MCE          V4240 : EVO_2007_008 : renumérotation des mouvements lors du refus du bordereau
-- 	----------------------------------------------------------------------------------------------------------
*/

v_codint_param_renumerot SR_CODIF.ide_codif%TYPE;
v_ret NUMBER;
v_libl SR_CODIF.libl%TYPE;
v_cod_typ_piece SR_CODIF.ide_codif%TYPE;
v_dernier_code_rejet VARCHAR2(120);
v_sequence VARCHAR2(120);
v_val_cod_ext_od SR_CODIF.cod_codif%TYPE;
v_val_cod_ext_or SR_CODIF.cod_codif%TYPE;
v_val_cod_ext_rejete SR_CODIF.cod_codif%TYPE;


BEGIN

  --1) Contrôle des paramètres en entrée
  IF P_ENV IS NOT NULL THEN
    --- Si le code saisi est null aucun contrôle ne doit être fait
	IF P_CODE IS NULL THEN
	  --- Pas de renumérotation
	  p_new_code := p_code;
	  RETURN(0);
	END IF;
  ELSE
    --- Impossible de faire le contrôle de renumérotation
    RETURN(-1);
  END IF;


  -- 1.1) Contrôle sur la longueur du code
  IF LENGTH(p_code)>17 THEN
      --- Pas de renumérotation
	  p_new_code := p_code;
	  RETURN(0);
  END IF;



  --2) Recherche si la renumérotation est autorisée ou pas
	  IF P_ENV = 'NUM_MVT_BUD' THEN
	    --- prévision des prochains dev
	    p_param_renumetoration :='IB0094';
	  ELSE
	    --- Impossible de faire le contrôle de renumérotation
	    RETURN(-1);
	  END IF;

	  --2.2) Recherche si la renumérotation est à faire
	  Ext_Param(p_param_renumetoration, v_codint_param_renumerot, v_ret);
	  IF v_ret != 1 THEN
	     -- Erreur lors de la récupération du paramètre indiquant si un contrôle de saisie doit être fait.
		 RETURN(-2);
	  ELSE
	    IF v_codint_param_renumerot ='N' THEN
		  --- Pas de renumérotation
		  p_new_code := p_code;
		  RETURN(0);
		END IF;
	  END IF;

  --3) Récupération du dernier code de renumératation

	IF p_env ='NUM_MVT_BUD' THEN
       /* En prévision des prochaines évolution */

     SELECT MAX(code) INTO v_dernier_code_rejet
       FROM
       (
       SELECT (SUBSTR(num_mvt_bud,LENGTH(num_mvt_bud)-1,2))  code FROM FB_MVT_BUD
       WHERE
            num_mvt_bud LIKE p_code||'%'
	   AND LENGTH(num_mvt_bud)=LENGTH(p_code)+3
	   -- le premier des 3 derniers caractères doit être un '-'
	   AND (SUBSTR(num_mvt_bud,LENGTH(num_mvt_bud)-2,1)) = '-'
       --- Le deux derniers caractères doivent être numériques
       AND (SUBSTR(num_mvt_bud,LENGTH(num_mvt_bud)-1,1)) IN ('0','1','2','3','4','5','6','7','8','9')
       AND (SUBSTR(num_mvt_bud,LENGTH(num_mvt_bud),1)) IN ('0','1','2','3','4','5','6','7','8','9')
	   AND ide_poste = p_ide_poste
	   AND cod_typ_nd_emet = p_cod_typ_nd_emet
	   AND ide_nd_emet = p_ide_nd_emet
	   AND ide_mess = p_ide_mess
	   AND flg_emis_recu = p_flg_emis_recu
	   AND num_lig = p_num_lig
	   );
	END IF;

	IF v_dernier_code_rejet IS NOT NULL THEN

	  IF v_dernier_code_rejet = '99' THEN
	    --- Le numéro -99 existe déjà, le rejet de l'ordonnance est impossible
	    RETURN(-3);
	  END IF;

	  v_sequence := LTRIM(TO_CHAR((TO_NUMBER(v_dernier_code_rejet)+1),'09'));
	  p_new_code:=p_code||'-'||v_sequence;
	  --- Renumérotation dejà faite. Renum +1 faite
	  RETURN(1);
	ELSE
	   --- Pas de rejet avant. On peut créer la renumérotation en démarrant la séquence à 01.
	   p_new_code := p_code||'-01';
	   RETURN(2);
	END IF;

EXCEPTION

  WHEN OTHERS THEN
    RAISE;
END Cal_Code_Rejet_mvt;

/

CREATE OR REPLACE FUNCTION Cal_Dat_Ech_Reglt(p_dat_ref      FC_REGLEMENT.dat_reference%TYPE,
                                             p_mod_reglt	PC_MODE_REGLT.ide_mod_reglt%TYPE,
											 p_dat_ech      IN OUT FC_REGLEMENT.dat_echeance%TYPE
                                        ) RETURN NUMBER IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : REF
-- Nom           : CAL_DAT_ECH_REGLT
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 13/06/2002
-- ---------------------------------------------------------------------------
-- Role          : Calcul de la date d'echeance d'un reglement a partir de son mode de reglement
--                 et sa date de reference
--
-- Parametres  en entree  :
-- 				 1 - p_dat_ref : La date de reference du reglement
--				 2 - p_mod_reglt : le mode de reglement du reglement
--
-- Parametres  en sortis  :
--				 3 - p_dat_ech : la date d echeance calculee
--
-- Valeur retournee :
--				 v_ret :  1 = OK
--                       -1 => impossible de recuperer le parametrage du mode de reglement
--                       -2 => incoherence code externe DEB_ECH
--
-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_DAT_ECH_REGLT.sql version 3.0-1.0
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) CAL_DAT_ECH_REGLT.sql 3.0-1.0	|13/06/2002| SGN	| Création
-- @(#) CAL_DAT_ECH_REGLT.sql 3.5-1.1	|07/05/2004| LGD	| ANOGAR604 : calcul de la date d'échéance quand la date de ref est au 30 pour le mois de février
-- 	----------------------------------------------------------------------------------------------------------
*/
  v_ret NUMBER;
  v_dat_ech FC_REGLEMENT.dat_echeance%TYPE;
  v_cod_deb_ech PC_MODE_REGLT.ide_mod_reglt%TYPE;
  v_dat_deb_ech DATE;
  v_val_delai PC_MODE_REGLT.val_delai%TYPE;
  v_ext_debech SR_CODIF.cod_codif%TYPE;
  v_libl SR_CODIF.libl%TYPE;

  -- Variable pour la trace
  v_niveau_trace NUMBER := NULL;
  v_num_trt NUMBER;

  /* LGD - 07/05/2004 - ANOGAR604 */
  V_MOIS_FEV CHAR(2);
  /* fin de modification */

BEGIN



	-- Selection du code deb echeance et de la valeur du delai a partir du mode de reglt
	BEGIN
		SELECT NVL(cod_deb_ech,0), NVL(val_delai,0)
		INTO v_cod_deb_ech, v_val_delai
		FROM PC_MODE_REGLT
		WHERE ide_mod_reglt = p_mod_reglt;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_ret := -1;
			RETURN v_ret;
		WHEN OTHERS THEN
			RAISE;
	END;



	-- Si le code deb echeance est 0, la dat_echance = dat_reference + le delai
	IF v_cod_deb_ech = '0' THEN


	   v_dat_ech := p_dat_ref + v_val_delai;


	-- Sinon calcul de la date d echeance
	ELSE

		/* LGD - 07/05/2004 - ANOGAR604 */
		-- Extraction du code externe du code debut echeance
		Ext_Codext('DEB_ECH',v_cod_deb_ech, v_libl, v_ext_debech, v_ret);
		IF v_ret != 1 THEN
		   v_ret := -2;
		   RETURN v_ret;

		ELSE
		  IF v_cod_deb_ech = '3' THEN
			  BEGIN
			  	   SELECT TO_CHAR(TO_DATE(p_dat_ref,'DD/MM/YYYY'), 'MM') INTO V_MOIS_FEV FROM dual ;
			       IF V_MOIS_FEV= '02' THEN
				     v_ext_debech :=TO_CHAR(LAST_DAY(p_dat_ref),'DD');
				   END IF;
			  EXCEPTION
					WHEN NO_DATA_FOUND THEN
						v_ret := -1;
						RETURN v_ret;
					WHEN OTHERS THEN
						RAISE;
			  END;
		  END IF;
		END IF;
		/* fin de modification */
		-- Calcul du debut de l'echeance
		v_dat_deb_ech := TO_DATE(LPAD(v_ext_debech,2,'0')||'/'||TO_CHAR(p_dat_ref,'MM/YYYY'));
		-- Si la date de debut d echeance est depassee, on prend la date de debut du mois
		-- prochain

		IF v_dat_deb_ech < p_dat_ref THEN
		   v_dat_deb_ech := ADD_MONTHS(v_dat_deb_ech,1);
		END IF;

	 	-- Calcul de la date d echeance avec le delai
		v_dat_ech := v_dat_deb_ech + v_val_delai;

	END IF;



    -- Affectation du code retour et de la date echeance a retourner
 	v_ret := 1;
	p_dat_ech := v_dat_ech;

	RETURN v_ret;

EXCEPTION
  WHEN OTHERS THEN
 	  RAISE;
END Cal_Dat_Ech_Reglt;

/

CREATE OR REPLACE FUNCTION CAL_FORMAT_MONTANT(
              p_parm_nb_decimal IN NUMBER,
              p_parm_signe_monetaire IN NUMBER :=0 ) RETURN VARCHAR2 IS

/*
---------------------------------------------------------------------------------------
-- Nom           : CAL_FORMAT_MONTANT
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 10/08/2001
-- ---------------------------------------------------------------------------
-- Role	  :  Cette fonction construit le masque de format à appliquer aux montants
-- 				   en fonction du nombre de décimale passé en paramètre, puis du parametre d'affichage
-- 				   du symbole mentaire (passe aussi en parametre)
--
-- Parametres    :
--          1 - p_parm_nb_decimal : nombre de decimales
--          2 - p_parm_signe_monetaire : place du symbole monetaire
--                                       -1 : symbole monetaire a gauche
--                                       0 : aucun symbole monetaire
--                                       1 : symbole monetaire a droite
--
-- Valeur retournee : Aucun
--
-- Appels		 : neant
--
-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_FORMAT_MONTANT.sql version 3.0-1.1
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	 |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) CAL_FORMAT_MONTANT.sql 2.1-1.0	|17/09/2001 | SGN	| Création
-- @(#) CAL_FORMAT_MONTANT.sql 3.0-1.1	|21/02/2002 | LGD	| FCT 48 Ajout d'un type de décimale pour les taux
---------------------------------------------------------------------------------------
*/

  v_format_montant VARCHAR2(50) := '999G999G999G999G990';

BEGIN

  IF p_parm_nb_decimal > 0 THEN
    -- v_format_montant := v_format_montant ||'D'||RPAD(v_format_montant, p_parm_nb_decimal, '9');
	v_format_montant := v_format_montant ||RPAD('D', p_parm_nb_decimal+1, '9');
  END IF;

  IF p_parm_signe_monetaire < 0 THEN
    v_format_montant := 'L'||v_format_montant;
  ELSIF p_parm_signe_monetaire > 0 THEN
    v_format_montant := v_format_montant || 'L';
  END IF;
  RETURN v_format_montant;

EXCEPTION

  WHEN OTHERS THEN
	--RETURN NULL;
	RAISE;
END CAL_FORMAT_MONTANT;

/

CREATE OR REPLACE FUNCTION CAL_FORMS_NUM_REC
  (
   p_table IN VARCHAR2,
   p_clause_where  IN VARCHAR2,
   p_ref_new_rec IN VARCHAR2,
   p_clause_orderby  IN VARCHAR2
  )
/*
-----------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : N/A
-- Nom           : CAL_FORMS_NUM_REC
-- --------------------------------------------------------------------
-- Auteur         : FDU
-- Date creation  : 14/12/2005
------------------------------------------------------------------------------------------------
-- Role : Récupération de la position d'un enregistrement dans une table
--        en fonction de critères de restriction et de tri
-- Type : Fonction
-- Paramètres entrée : 1 - p_table (Nom de la table où figure l'enregistrement en question)
--                     2 - p_clause_where (Clause DEFAULT_WHERE du bloc de données Forms)
--                     3 - p_ref_new_rec (Clause Where de restriction sur l'enregistrement concerné)
--                     4 - p_clause_orderby (Clause ORDER_BY du bloc de données Forms)
-- Paramètres en sortie : v_num_rec (Position de l'enregistrement au sein de la liste)
-- ---------------------------------------------------------------------------------------------
-- Version        : @(#) CAL_FORMS_NUM_REC version 3.5B
-- ---------------------------------------------------------------------
-- Objet de la modification : Evo FA0028
-- --------------------------------------------------------------------------------------------------------------------
-- Révision                   |Date     |Initiales |Commentaires
-- --------------------------------------------------------------------------------------------------------------------
-- @(#)CAL_FORMS_NUM_REC 3.5B |14/12/05 |FDU       | Création - Evo FA0028
--                                                 | Modification de l'affichage lors de la création d'un nouveau bordereau
--                                                 | Positionnement du curseur sur la ligne venant d'être insérée
-- --------------------------------------------------------------------------------------------------------------------
*/

/* Début FDU  le 14/12/2005 : Création de la fonction permettant de localiser un enregistrement via des requêtes du type
                              SELECT count(*) FROM table WHERE ...
                              AND col1 <= 'val_char1' AND col2 <= 'val_char2' AND col3 <= val_numeric
                              ORDER BY col1, col2, col3
*/
RETURN INTEGER IS
   v_req      VARCHAR2(2000) ;
   v_num_rec  INTEGER ;
BEGIN

  -- Génération de la requête de localisation de l'enregistrement en cours --

  v_req := 'SELECT COUNT(*) FROM ' || p_table ;

  IF TRIM(p_clause_where) IS NOT NULL THEN
    v_req := v_req || ' WHERE ' || p_clause_where ;
  END IF ;

  IF TRIM(p_ref_new_rec) IS NOT NULL THEN
    IF TRIM(p_clause_where) IS NOT NULL THEN
      v_req := v_req || ' AND ' || p_ref_new_rec ;
    ELSE
      v_req := v_req || ' WHERE ' || p_ref_new_rec ;
    END IF ;
  END IF ;

  IF TRIM(p_clause_orderby) IS NOT NULL THEN
    v_req := v_req || ' ORDER BY ' || p_clause_orderby ;
  END IF ;

  -- Exécution de la requête générée --

  EXECUTE IMMEDIATE v_req INTO v_num_rec ;

  -- Transmission de la position de l'enregistrement à la fonction appelante : GET_NUM_REC sous reference.pll --

  RETURN(v_num_rec) ;

  EXCEPTION
    WHEN OTHERS THEN
     RETURN(0) ;

END CAL_FORMS_NUM_REC ;

/

CREATE OR REPLACE FUNCTION CAL_jour_semaine(p_date IN date)  RETURN NUMBER IS
/*
---------------------------------------------------------------------------------------
-- Nom           : CAL_jour_semaine
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 30/08/2001
-- ---------------------------------------------------------------------------
-- Role          : Calcule une numero compris entre 1 et 7 pour le jour de la semaine correspodant
-- 				    à une date independamment des parametres NLS
--
-- Parametres    :
-- 				 1 - p_date : Date a traiter
--
-- Valeur retournee :
-- 		  			* Numero du jour 1 = Lundi, et 7 = Dimanche
--
-- Appels		 : PACKAGE DBMS_SQL
-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_jour_semaine.sql version 2.1-1.0 : SNE : 30/08/2001
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) CAL_jour_semaine.sql 2.1-1.0	|30/08/2001 | SNE	| Création
-- @(#) CAL_jour_semaine.sql 3.5B-2.0	|12/01/2006 | RDU	| Correction anomalie V32-DIT44-020 (UT Maj des traitements calendaires)
---------------------------------------------------------------------------------------
*/

   v_db_datej number;
   v_db_jour number;
   v_jour_s number;
-- RDU-12/01/2006-Ano V32-DIT44-020
--   v_jour_systeme varchar2(3);
   v_jour_systeme varchar2(20);
-- RDU-12/01/2006-Fin
   v_ret number;
 begin
-- RDU-12/01/2006-Ano V32-DIT44-020
-- v_ret := ASTER_date_systeme('%u', v_jour_systeme); -- %u ne ramenait aucune valeur
   v_ret := ASTER_date_systeme('%d/%m/%Y', v_jour_systeme);
   v_jour_systeme := to_char(to_date(v_jour_systeme), 'D');
-- RDU-12/01/2006-Fin
   v_db_datej := to_number(to_char(sysdate, 'D')) ;
   v_db_jour :=  to_number(to_char(p_date, 'D')) ;
   v_jour_s := v_db_jour + (to_number(v_jour_systeme) - v_db_datej);
   RETURN(v_jour_s);
 end;

/

CREATE OR REPLACE FUNCTION cal_next_seq_b_traitement(p_numtrt IN OUT B_TRAITEMENT.numtrt%TYPE) RETURN NUMBER IS
/*
-- ----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : Interne
-- Nom           : cal_next_seq_b_traitement
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 18/12/2002
-- ---------------------------------------------------------------------------
-- Role          : Calcule de la prochaine sequence de b_traitement (Utilise par l exploit via un dblink)
--
-- Parametres    :
-- 				  1- p_num_trt : numero de la sequence
--
-- Valeur retournee : - 0 trt OK
--          		  - != 0 trt KO
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) cal_next_seq_b_traitement.sql version 3.0c-1.0
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					         |Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) cal_next_seq_b_traitement 3.0c-1.0	|18/18/2002| SGN	| Création
-- ----------------------------------------------------------------------------------------------------------
*/
v_ret 			NUMBER;

BEGIN
  SELECT SEQ_B_TRAITEMENT.NEXTVAL
  INTO p_numtrt
  FROM DUAL;

  v_ret := 0;

  return v_ret;

EXCEPTION
   WHEN OTHERS THEN
      RAISE;
END cal_next_seq_b_traitement;

/

CREATE OR REPLACE FUNCTION CAL_NextVal_Sequence(Par_Nom_Sequence IN    ALL_SEQUENCES.Sequence_Name%TYPE,
                                                Par_NextVal      OUT   NUMBER) RETURN NUMBER IS

Var_Commande        VARCHAR2(250);

BEGIN
     -- Calcul de la prochaine valeur de la séquence
     Var_Commande := 'SELECT ' || Par_Nom_Sequence || '.NextVal FROM DUAL';
     EXECUTE IMMEDIATE Var_Commande INTO Par_NextVal;

     RETURN(1);

EXCEPTION
  WHEN OTHERS THEN
       RETURN(-1);
END CAL_NextVal_Sequence;

/

CREATE OR REPLACE FUNCTION Cal_Nom_Fichier_Trace(p_nom_programme IN VARCHAR2 := '') RETURN VARCHAR2 IS
/*
-- ---------------------------------------------------------------------------
--  Fichier        : CAL_NOM_FICHIER_TRACE.sql
--  Date creation  : 08/08/2001
--  Auteur         : Sofiane NEKERE
--
--  Logiciel       : ASTER
--  sous-systeme   : Base
--  Description    : Fonction basée de détermination du nom du fichier de trace applicative
--
--   parametres entree :
--     1- chemin des batchs du MES
--     2- chemin répertoire BATLOG
--
--   parametres sortie :
--     neant
-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_Nom_Fichier_Trace.sql  version 3.3-1.2
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					    		|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#)CAL_Nom_Fichier_Trace.sql 2.1-1.0 	|08/08/2001 | SNE	| Création
-- @(#)CAL_Nom_Fichier_Trace.sql 2.1-1.1 	|02/10/2001 | SNE	| Ajout de l'heure dans le format du nom du fichier
-- @(#)CAL_Nom_Fichier_Trace.sql 3.3-1.2 	|02/10/2003 | LGD	| ANOVSR439 : le format de l'heure pour le nom du fichier doi être sur 24h.
-- ---------------------------------------------------------------------------
*/
  cst_extension_fichier_trace CONSTANT VARCHAR2(04) := '.trc';
  v_nom_fichier VARCHAR2(500);
  v_nom_repertoire SR_PARAM.VAL_PARAM%TYPE;
  v_separateur_chemin CHAR(01) := '/';
  v_separateur_var_path CHAR(01) := ':';
  v_ret NUMBER;
BEGIN
  v_ret := Aster_Env_Param(v_separateur_chemin, v_separateur_var_path);

  IF v_ret = 0 THEN
	  Ext_Param('IR0009', v_nom_repertoire , v_ret);
	  IF v_ret = 1 THEN
	  	 v_nom_fichier := v_nom_repertoire || v_separateur_chemin  ||p_nom_programme ||'_'|| USER ||'_'||TO_CHAR(SYSDATE, 'YYYYMMDD_HH24MISS')|| cst_extension_fichier_trace;
	  END IF;
  END IF;
  RETURN(v_nom_fichier);
END;

/

CREATE OR REPLACE FUNCTION CAL_Resultat(P_ENTITE        ex_axe.ide_entite%TYPE,
                      P_AXE1          ex_axe.ide_elem_axe%TYPE,
                      P_AXE2          ex_axe.ide_elem_axe%TYPE,
                      P_FEUILLE       ex_axe.flg_feuille%TYPE,
                      P_OUI           sr_codif.cod_codif%TYPE,
                      P_TYPE          VARCHAR2) RETURN NUMBER IS

  v_montant    ex_valeurs.mt%TYPE;
  v_montantc   ex_valeurs.mt%TYPE;
  v_montantp   ex_valeurs.mt%TYPE;
  v_retour     NUMBER;
  v_oui        sr_codif.cod_codif%TYPE;
  v_libl       sr_codif.libl%TYPE;

  CURSOR c_valeur(PC_ENTITE   ex_axe.ide_entite%TYPE,
                  PC_AXE1     ex_axe.ide_elem_axe%TYPE,
                  PC_AXE2     ex_axe.ide_elem_axe%TYPE) IS
    SELECT mt   Montant
    FROM ex_valeurs
    WHERE ide_entite = PC_ENTITE
      AND ide_elem_axe1 = PC_AXE1
      AND ide_elem_axe2 = PC_AXE2
      AND ide_elem_axe3 IS NULL
      AND ide_elem_axe4 IS NULL
      AND ide_elem_axe5 IS NULL
      AND ide_elem_axe6 IS NULL
      AND ide_elem_axe7 IS NULL;

  CURSOR c_axe(PC_ENTITE   ex_axe.ide_entite%TYPE,
               PC_AXE1     ex_axe.ide_elem_axe%TYPE,
               PC_AXE2     ex_axe.ide_elem_axe%TYPE) IS
    SELECT A.ide_elem_axe    Axe1,
           B.ide_elem_axe    Axe2,
           B.flg_feuille     Feuille
    FROM EX_AXE A, EX_AXE B
      WHERE A.ide_entite = PC_ENTITE
        AND B.ide_entite = PC_ENTITE
        AND A.ide_num_axe = 1
        AND B.ide_num_axe = 2
        AND B.ide_pere = PC_AXE2
        AND A.ide_elem_axe = PC_AXE1;

  CURSOR c_total(PC_ENTITE   ex_axe.ide_entite%TYPE,
                 PC_AXE1     ex_axe.ide_elem_axe%TYPE,
                 PC_TYPE     VARCHAR2) IS
    SELECT SUM(NVL(mt,0))   Cumul_Montant
    FROM ex_valeurs
    WHERE ide_entite = PC_ENTITE
      AND ide_elem_axe1 = PC_AXE1
      AND ide_elem_axe2 LIKE PC_TYPE
      AND ide_elem_axe3 IS NULL
      AND ide_elem_axe4 IS NULL
      AND ide_elem_axe5 IS NULL
      AND ide_elem_axe6 IS NULL
      AND ide_elem_axe7 IS NULL;

BEGIN

  IF P_OUI IS NULL THEN
    EXT_Codext('OUI_NON','O',v_libl,v_oui,v_retour);
    IF v_retour != 1 THEN
      Return(0);
    END IF;

  ELSE
    v_oui := P_OUI;
  END IF;

  /* ---------------------------------------------------------------------------------------- */
  IF P_FEUILLE = v_oui THEN

    -- Recuperation du montant si existe dans ex_valeurs
    ----------------------------------------------------
    v_montant := 0;
    FOR l_valeur IN c_valeur(P_ENTITE,P_AXE1,P_AXE2)
    LOOP
      v_montant := l_valeur.Montant;
      Exit;
    END LOOP;

    Return(NVL(v_montant,0));

  ELSE

  /* ---------------------------------------------------------------------------------------- */

    /* Calcul d'un sous-total */
    IF P_AXE2 NOT IN ('C99','C991','C992','P99','P991','P992') THEN
      -- Sous-total simple

      v_montant := 0;
      FOR l_axe IN c_axe(P_ENTITE,P_AXE1,P_AXE2)
      LOOP
        v_montant := v_montant +
                      CAL_Resultat(P_ENTITE,l_axe.Axe1,l_axe.Axe2,l_axe.Feuille,
                                   v_oui,P_TYPE);
      END LOOP;

      Return(NVL(v_montant,0));

    ELSE

      -- Sous-totaux Finaux
      IF P_AXE2 IN ('C99','P99') THEN

        v_montant := 0;
        FOR l_total IN c_total(P_ENTITE,P_AXE1,P_TYPE)
        LOOP
          v_montant := l_total.Cumul_Montant;
        END LOOP;

        Return(NVL(v_montant,0));

      ELSIF P_AXE2 IN ('C991','P991') THEN

        v_montantc := 0;
        FOR l_total IN c_total(P_ENTITE,P_AXE1,'C%')
        LOOP
          v_montantc := l_total.Cumul_Montant;
        END LOOP;

        v_montantp := 0;
        FOR l_total IN c_total(P_ENTITE,P_AXE1,'P%')
        LOOP
          v_montantp := l_total.Cumul_Montant;
        END LOOP;

        IF NVL(v_montantc,0) >= NVL(v_montantp,0) THEN
          IF P_AXE2 = 'C991' THEN
            Return(0);
          ELSE
            Return(NVL(v_montantc,0) - NVL(v_montantp,0));
          END IF;
        ELSE
          IF P_AXE2 = 'P991' THEN
            Return(0);
          ELSE
            Return(NVL(v_montantp,0) - NVL(v_montantc,0));
          END IF;
        END IF;

      ELSE

        v_montantc := 0;
        FOR l_total IN c_total(P_ENTITE,P_AXE1,'C%')
        LOOP
          v_montantc := l_total.Cumul_Montant;
        END LOOP;

        v_montantp := 0;
        FOR l_total IN c_total(P_ENTITE,P_AXE1,'P%')
        LOOP
          v_montantp := l_total.Cumul_Montant;
        END LOOP;

        IF NVL(v_montantc,0) >= NVL(v_montantp,0) THEN
          Return(NVL(v_montantc,0));
        ELSE
          Return(NVL(v_montantp,0));
        END IF;

      END IF;

    END IF;

  END IF;


EXCEPTION
  WHEN Others THEN
    Return(0);

END CAL_Resultat;

/

CREATE OR REPLACE FUNCTION          CAL_ROUND_MT( p_mt_in    IN NUMBER,
                                         p_mt_out   IN OUT NUMBER
                                         ) RETURN NUMBER IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : REF
-- Nom           : CAL_ROUND_MT
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 29/01/2003
-- ---------------------------------------------------------------------------
-- Role          : Arrondi d'un montant en devise de reference en utilisant le parametre IR0001
--
-- Parametres  entree  :
--               1 - p_mt_in : mt en devise de reference a arrondir
--
-- Parametre sorties :
--               2 - p_mt_out : mt en devise de reference arrondi en fonction de IR0001
--
-- Valeur retournee : 1 : OK
--                   -1 : KO
--
-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_ROUND_MT sql version 3.0d-1.0
-- ---------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------
-- Fonction			   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) CAL_ROUND_MT.sql 3.0d-1.0	|29/01/2003 | SGN	| Création
---------------------------------------------------------------------------------------------------------
*/
  v_ret NUMBER;
  v_val_param NUMBER;

  PARAM_EXCEPTION EXCEPTION;
  CODIF_EXCEPTION EXCEPTION;

  -- Variable pour la trace
  v_niveau_trace NUMBER := NULL;
  v_num_trt NUMBER;
BEGIN

     -- Recuperation du niveau de trace en passant par les variables ASTER
     ASTER_VAR.get_var('NIVEAU_TRACE_VAR','P_NIV_TRACE', v_niveau_trace, v_num_trt);
     GLOBAL.INI_NIVEAU_TRACE(NVL(v_niveau_trace,0));
     AFF_TRACE('CAL_ROUND_MT', 2, NULL, 'Debut traitement');

     -- Recuperation du nombre de decimal parametre
     EXT_PARAM('IR0001', v_val_param, v_ret);
     IF v_ret != 1 THEN
       RAISE PARAM_EXCEPTION;
     ELSE
       AFF_TRACE('CAL_ROUND_MT', 2, NULL, 'Nombre de décimale:'||v_val_param);

       --v_val_param := 0;
       p_mt_out :=round( p_mt_in, v_val_param);
       AFF_TRACE('CAL_ROUND_MT', 2, NULL, 'Montant en devise arrondi:' || p_mt_out);

       RETURN(1);
     END IF;

     AFF_TRACE('CAL_ROUND_MT', 2, NULL, 'Fin traitement');
EXCEPTION
  WHEN PARAM_EXCEPTION THEN
      RETURN(-1);
  WHEN OTHERS THEN
      RAISE;
END CAL_ROUND_MT;

/

CREATE OR REPLACE FUNCTION CHAP_CLASSEMENT( p_ide_poste      FB_PIECE.ide_poste%TYPE,
                                            p_ide_gest       FB_PIECE.ide_gest%TYPE,
                                            p_ide_ordo       FB_PIECE.ide_ordo%TYPE,
											p_cod_bud        FB_PIECE.cod_bud%TYPE,
											p_ide_piece      FB_PIECE.ide_piece%TYPE,
											P_cod_typ_piece  FB_PIECE.cod_typ_piece%TYPE,
											p_ide_piece_init FB_PIECE.ide_piece_init%TYPE,
											P_dat_cpta       FB_PIECE.dat_cpta%TYPE,
											p_ide_lig_exec   FB_LIGNE_PIECE.ide_lig_exec%TYPE,
											p_num_lig        FB_LIGNE_PIECE.num_lig%TYPE,
											p_mens_trim      VARCHAR2 -- valeur obligatoire T= Trimestre ou M = mensuel --
                                          ) RETURN VARCHAR2 IS
--------------------------------------------------------------------
-- fonction spécifique développée par le DI44                    ---
-- créée par MPS le 24/09/2004                                   ---
-- modifiée par MPS le 22/12/2004 pb de mandat sans ligne 1      ---
-- modifiée par MPS le 28/03/2006 mandat 614 de type OD LOLF     ---
-- modifiée par MPS le 05/03/2007 mandat 994 de type OD LOLF     ---
--------------------------------------------------------------------
v_num_lig_min  FB_LIGNE_PIECE.num_lig%TYPE;   -- modif MPS du 22/12/2004 pb ligne 1 du mandat absente
---------------------------------------------------------------------------------------------------------
-- recherche le chapitre de classement dans un mandat d'origine (num_lig = plus petite ligne)     ---
---------------------------------------------------------------------------------------------------------
    CURSOR c_rech_chap_clast( P05_ide_poste      FB_PIECE.ide_poste%TYPE,
                              P05_ide_gest       FB_PIECE.ide_gest%TYPE,
                              P05_ide_ordo       FB_PIECE.ide_ordo%TYPE,
					          P05_cod_bud        FB_PIECE.cod_bud%TYPE,
					          P05_ide_piece      FB_PIECE.ide_piece%TYPE
						   ) IS
    SELECT fbl.ide_lig_exec
    FROM fb_piece fb, fb_ligne_piece fbl
    where fb.ide_poste = fbl.ide_poste
      and fb.ide_gest  = fbl.ide_gest
      and fb.cod_bud   = fbl.cod_bud
      and fb.ide_ordo   = fbl.ide_ordo
      and fb.ide_piece = fbl.ide_piece
      and fb.cod_typ_piece = fbl.cod_typ_piece
	  and fb.ide_poste = P05_ide_poste
      and fb.ide_gest  = P05_ide_gest
      and fb.cod_bud   = P05_cod_bud
      and fb.ide_ordo   = P05_ide_ordo
      and fb.ide_piece = P05_ide_piece
	  and fb.cod_statut = 'VI'
      and fb.cod_typ_piece = 'OD'
	 -- and fbl.num_lig = 1             -- supp MPS 22/12/2004
	  and fbl.num_lig = v_num_lig_min   -- ajout MPS 22/12/2004
	  ;
  v_rech_chap_clast    c_rech_chap_clast%ROWTYPE;

  v_ide_piece_orig    FB_PIECE.ide_piece%TYPE;
  v_ide_piece         FB_PIECE.ide_piece%TYPE;
  v_num_lig           VARCHAR2(1);
  v_ide_lig_exec      FB_LIGNE_PIECE.ide_lig_exec%TYPE;
  v_dat_cpta           FB_PIECE.dat_cpta%TYPE;
  v_dat_cpta_limit     FB_PIECE.dat_cpta%TYPE;
  v_chap              VARCHAR2(4);
  v_ide_piece612      FB_PIECE.ide_piece%TYPE;
  v_dat1              FB_PIECE.dat_cpta%TYPE;
  v_dat2              FB_PIECE.dat_cpta%TYPE;
  v_dat3              FB_PIECE.dat_cpta%TYPE;
  v_dat4              FB_PIECE.dat_cpta%TYPE;

----------------------------------------------------------
-- fonction pour calculer le dernier jour du trimestre  --
-----------------------------------------------------------

FUNCTION CAL_FIN_TRIM ( P07_dat_cpta     IN  FB_PIECE.dat_cpta%TYPE
                                          ) RETURN DATE IS
v_res date;
BEGIN
	 if substr(trunc(P07_dat_cpta),4,2) in ('01', '04', '07', '10') then
	    v_res := add_months(P07_dat_cpta,2);
	 elsif substr(trunc(P07_dat_cpta),4,2) in ('02', '05', '08', '11') then
	    v_res := add_months(P07_dat_cpta,1);
	 else
	    v_res := P07_dat_cpta;
	 end if;
	 return last_day(v_res);

END CAL_FIN_TRIM;

---------------------------------------------------------------------
-- fonction pour calculer le dernier jour de la période précédente --
---------------------------------------------------------------------

FUNCTION CAL_DERN_JOUR_PREC ( P08_dat_cpta     IN  FB_PIECE.dat_cpta%TYPE,
                              P08_mens_trim   VARCHAR2
                                          ) RETURN DATE IS
v_res date;
BEGIN
     if P08_mens_trim = 'M' then
	    v_res := P08_dat_cpta - to_char(P08_dat_cpta,'DD');
	 else
		 if substr(trunc(P08_dat_cpta),4,2) in ('02', '05', '08', '11') then
		    v_res := add_months(P08_dat_cpta - to_char(P08_dat_cpta,'DD'),-1);
		 elsif substr(trunc(v_dat_cpta_limit),4,2) in ('03', '06', '09', '12') then
		    v_res := add_months(P08_dat_cpta - to_char(P08_dat_cpta,'DD'),-2);
		 else
		    v_res := P08_dat_cpta - to_char(P08_dat_cpta,'DD');
		 end if;
	 end if;
	 return v_res;

END CAL_DERN_JOUR_PREC;
---------------------------------------------------------------------------------------------
-- fonction pour formater la zone ide_piece issu du mandat initial dans des cas particulier--
---------------------------------------------------------------------------------------------

FUNCTION FORM_IDE_PIECE ( P08_ide_piece      IN  FB_PIECE.ide_piece%TYPE,
                          P08_ide_piece_init IN  FB_PIECE.ide_piece%TYPE
                                          ) RETURN VARCHAR2 IS
v_res VARCHAR2(20);

BEGIN
v_res := P08_ide_piece_init;
if instr(P08_ide_piece_init,'-') > 0 then
   v_res := substr(P08_ide_piece_init,1,instr(P08_ide_piece_init,'-')-1);
end if;
if substr(P08_ide_piece,1,3) in ('993', '994') then
   v_res := '61'|| substr(P08_ide_piece,3,18);
end if;
if substr(P08_ide_piece_init,1,3) in ('993', '994') then
   v_res := '61'|| substr(P08_ide_piece_init,3,18);
end if;
	 return v_res;

END FORM_IDE_PIECE;
-----------------------------------------------------------------------
-- procédure de recherche du mandat d'origine (type 600/610)
-- reman en cascade lors de réimputations successives               --
-- ou BADEP/BRADO ayant fait l'objet de correction successive
-----------------------------------------------------------------------
PROCEDURE RECH_MAND_ORIG_CASCADE
                                          (
                                            P10_ide_poste      FB_PIECE.ide_poste%TYPE,
                                            P10_ide_gest       FB_PIECE.ide_gest%TYPE,
                                            P10_ide_ordo       FB_PIECE.ide_ordo%TYPE,
											P10_cod_bud        FB_PIECE.cod_bud%TYPE,
											P10_ide_piece      FB_PIECE.ide_piece%TYPE,
											P10_ide_piece_init FB_PIECE.ide_piece_init%TYPE,
											P10_typ_mand       VARCHAR2,
											P10_ide_piece_orig OUT FB_PIECE.ide_piece%TYPE,
											P10_dat_cpta        OUT date
                                          ) --RETURN VARCHAR2
										  IS


  -- recherche les références des mandats 612
    CURSOR c_rech_mand_origine( P15_ide_poste      FB_PIECE.ide_poste%TYPE,
                                P15_ide_gest       FB_PIECE.ide_gest%TYPE,
                                P15_ide_ordo       FB_PIECE.ide_ordo%TYPE,
					            P15_cod_bud        FB_PIECE.cod_bud%TYPE,
					            P15_ide_piece_orig FB_PIECE.ide_piece%TYPE,
								P15_ide_piece      FB_PIECE.ide_piece%TYPE
						   ) IS
    SELECT fb.ide_poste, fb.ide_gest, fb.ide_ordo, fb.cod_bud, fb.ide_piece, fb.ide_piece_init, fb.dat_cpta
    FROM fb_piece fb, fb_ligne_piece fbl
    where fb.ide_poste = fbl.ide_poste
      and fb.ide_gest  = fbl.ide_gest
      and fb.cod_bud   = fbl.cod_bud
      and fb.ide_ordo   = fbl.ide_ordo
      and fb.ide_piece = fbl.ide_piece
      and fb.cod_typ_piece = fbl.cod_typ_piece
	  and fb.ide_poste = P15_ide_poste
      and fb.ide_gest  = P15_ide_gest
      and fb.cod_bud   = P15_cod_bud
      and fb.ide_ordo   = P15_ide_ordo
      and fb.ide_piece = P15_ide_piece_orig
	  and fb.cod_statut = 'VI'
      and (
	         (fb.cod_typ_piece = 'OD' and substr(P15_ide_piece_orig,1,3) = '612')  or
	         (fb.cod_typ_piece = 'AD' and substr(P15_ide_piece,1,3) in ('993', '994', '614', '613', '617'))
		  )
	  ;

v_rech_mand_origine    c_rech_mand_origine%ROWTYPE;

  -- recherche la date CPTA du mandat d'origine
    CURSOR c_rech_datcpta       ( P18_ide_poste      FB_PIECE.ide_poste%TYPE,
                                 P18_ide_gest       FB_PIECE.ide_gest%TYPE,
                                 P18_ide_ordo       FB_PIECE.ide_ordo%TYPE,
					             P18_cod_bud        FB_PIECE.cod_bud%TYPE,
					             P18_ide_piece      FB_PIECE.ide_piece%TYPE
						   ) IS
    SELECT fb.dat_cpta
    FROM fb_piece fb
    where fb.ide_poste = P18_ide_poste
      and fb.ide_gest  = P18_ide_gest
      and fb.cod_bud   = P18_cod_bud
      and fb.ide_ordo  = P18_ide_ordo
      and fb.ide_piece = P18_ide_piece
	  and fb.cod_typ_piece = 'OD'
	  and fb.cod_statut = 'VI'

	  ;

v_rech_datcpta    c_rech_datcpta%ROWTYPE;

BEGIN

P10_ide_piece_orig := FORM_IDE_PIECE (P10_ide_piece, P10_ide_piece_init);

 IF   substr(P10_ide_piece_orig,1,3) not in ('600', '610') THEN

    WHILE substr(P10_ide_piece_orig,1,3) not in ('600', '610') LOOP
	   OPEN c_rech_mand_origine (P10_ide_poste, P10_ide_gest, P10_ide_ordo, P10_cod_bud, P10_ide_piece_orig, P10_ide_piece) ;
       FETCH c_rech_mand_origine INTO v_rech_mand_origine;
 	   CLOSE c_rech_mand_origine;
       P10_ide_piece_orig := FORM_IDE_PIECE (v_rech_mand_origine.ide_piece, v_rech_mand_origine.ide_piece_init);
	END LOOP;

  END IF;

	OPEN c_rech_datcpta (P10_ide_poste, P10_ide_gest, P10_ide_ordo, P10_cod_bud, P10_ide_piece_orig) ;
    FETCH c_rech_datcpta INTO v_rech_datcpta;
 	CLOSE c_rech_datcpta;
	P10_dat_cpta := v_rech_datcpta.dat_cpta;


END RECH_MAND_ORIG_CASCADE;
------------------------------------------------

-----------------------------------------------------------------------
-- procédure de recherche de la dernière réimputation à prendre en compte--
-----------------------------------------------------------------------
PROCEDURE RECH_DERN_REIMP
                                          (
                                            P20_ide_poste      FB_PIECE.ide_poste%TYPE,
                                            P20_ide_gest       FB_PIECE.ide_gest%TYPE,
                                            P20_ide_ordo       FB_PIECE.ide_ordo%TYPE,
											P20_cod_bud        FB_PIECE.cod_bud%TYPE,
											P20_ide_piece      FB_PIECE.ide_piece%TYPE,
											P20_dat_limit      date,
											P20_ide_lig_exec   OUT FB_LIGNE_PIECE.ide_lig_exec%TYPE,
											P20_ide_piece612   OUT FB_PIECE.ide_piece%TYPE
                                          )
										  IS


  -- recherche les références des mandats 612
    CURSOR c_rech_mand_orig612( P25_ide_poste      FB_PIECE.ide_poste%TYPE,
                                P25_ide_gest       FB_PIECE.ide_gest%TYPE,
                                P25_ide_ordo       FB_PIECE.ide_ordo%TYPE,
					            P25_cod_bud        FB_PIECE.cod_bud%TYPE,
					            P25_ide_piece      FB_PIECE.ide_piece%TYPE,
								P25_dat_limit      date
						   ) IS
    SELECT fb.ide_poste, fb.ide_gest, fb.ide_ordo, fb.cod_bud, fb.ide_piece, fb.ide_piece_init, fb.dat_cpta, fbl.ide_lig_exec
    FROM fb_piece fb, fb_ligne_piece fbl
    where fb.ide_poste = fbl.ide_poste
      and fb.ide_gest  = fbl.ide_gest
      and fb.cod_bud   = fbl.cod_bud
      and fb.ide_ordo   = fbl.ide_ordo
      and fb.ide_piece = fbl.ide_piece
      and fb.cod_typ_piece = fbl.cod_typ_piece
	  and fb.ide_poste = P25_ide_poste
      and fb.ide_gest  = P25_ide_gest
      and fb.cod_bud   = P25_cod_bud
      and fb.ide_ordo   = P25_ide_ordo
      and fb.ide_piece_init = P25_ide_piece
	  and fb.ide_piece like '612%'
	  and fb.cod_statut = 'VI'
      and fb.cod_typ_piece = 'OD'
	  and fb.dat_cpta <= P25_dat_limit
	  and to_char(fb.dat_cpta,'DD/MM') != '01/01'
	  ;

v_rech_mand_orig612    c_rech_mand_orig612%ROWTYPE;

v_typ_mand varchar2(3) := '612';
v_ide_piece FB_PIECE.ide_piece%TYPE;


BEGIN
P20_ide_lig_exec := null;
v_ide_piece := P20_ide_piece;

    WHILE v_typ_mand = '612' LOOP
	   OPEN c_rech_mand_orig612 (P20_ide_poste, P20_ide_gest, P20_ide_ordo, P20_cod_bud, v_ide_piece,  P20_dat_limit) ;
       FETCH c_rech_mand_orig612 INTO v_rech_mand_orig612;
	   if c_rech_mand_orig612%found then
 	      CLOSE c_rech_mand_orig612;
	      v_ide_piece := v_rech_mand_orig612.ide_piece;
		  P20_ide_lig_exec := v_rech_mand_orig612.ide_lig_exec;
		  P20_ide_piece612 := v_rech_mand_orig612.ide_piece;
	   else
	      CLOSE c_rech_mand_orig612;
	      v_typ_mand := '000';
	   end if;
	END LOOP;


END RECH_DERN_REIMP;
------------------------------------------------

-----------------------------------------------
-- Détermine le chapitre de classement --
-----------------------------------------------
PROCEDURE DETERMIN_CHAP_CLAST
(
      P30_ide_poste      FB_PIECE.ide_poste%TYPE,
      P30_ide_gest       FB_PIECE.ide_gest%TYPE,
      P30_ide_ordo       FB_PIECE.ide_ordo%TYPE,
	  P30_cod_bud        FB_PIECE.cod_bud%TYPE,
	  P30_ide_piece      FB_PIECE.ide_piece%TYPE,
	  P30_typ_piece      VARCHAR2,
	  P30_dat_cpta        FB_PIECE.dat_cpta%TYPE,
	  P30_dat_cpta_orig   FB_PIECE.dat_cpta%TYPE,
	  P30_num_lig        FB_LIGNE_PIECE.num_lig%TYPE,
	  P30_mens_trim      VARCHAR2,
	  P30_ide_lig_exec   FB_LIGNE_PIECE.ide_lig_exec%TYPE,
	  P30_cod_typ        FB_PIECE.cod_typ_piece%TYPE,
	  P30_ide_piece_init FB_PIECE.ide_piece%TYPE
)
IS
BEGIN

      v_ide_lig_exec := null;

      if (substr(P30_ide_piece,1,3) not in ('600','610')) or
	     (((instr(P30_ide_piece,'E') > 0 or instr(P30_ide_piece,'S') > 0) and P30_ide_piece like '610%'))  then
		  v_ide_piece := P30_ide_piece;
	  else
   	     v_ide_piece := P30_ide_piece||'-1';
	  end if;

	  -- détermination de la borne supérieure à prendre en compte dans la recherche des réimputations

	--  if   (P30_typ_piece in ('600','610','613','614', '617'))   -- supp MPS 05/03/2007 --
	  if   (P30_typ_piece in ('600','610','613','614', '617','994'))   -- ajout MPS 05/03/2007 --
	       or (P30_typ_piece = '612' and P30_cod_typ = 'OD') then
	          v_dat_cpta_limit := P30_dat_cpta;
			  if P30_mens_trim = 'M' then
			     v_dat_cpta_limit := last_day(v_dat_cpta_limit);
			  else -- 	P30_mens_trim = 'T'
			     v_dat_cpta_limit := CAL_FIN_TRIM (P30_dat_cpta);
			  end if;
	  elsif (P30_typ_piece = '612' and P30_cod_typ = 'AD')
	     --  or  (P30_typ_piece in ('993','994')) then  -- supp MPS 05/03/2007 --
		   or  (P30_typ_piece in ('993')) then    -- ajout MPS 05/03/2007 --
		      v_dat1 := last_day(P30_dat_cpta);
			  v_dat2 := last_day(P30_dat_cpta_orig);
			  v_dat3 := CAL_FIN_TRIM (P30_dat_cpta);
			  v_dat4 := CAL_FIN_TRIM (P30_dat_cpta_orig);
			 if (to_date(v_dat1) = to_date(v_dat2) and P30_mens_trim = 'M') then
			     v_dat_cpta_limit := last_day(P30_dat_cpta);
			 elsif (to_date(v_dat3) = to_date(v_dat4) and P30_mens_trim = 'T')  then
			     v_dat_cpta_limit := CAL_FIN_TRIM (P30_dat_cpta);
			 elsif P30_typ_piece = '612' then
			     if substr(P30_ide_piece_init,1,3) in ('600','610') then
				        OPEN c_rech_chap_clast (P30_ide_poste, P30_ide_gest, P30_ide_ordo, P30_cod_bud, P30_ide_piece_init) ;
                        FETCH c_rech_chap_clast INTO v_rech_chap_clast;
	                    CLOSE c_rech_chap_clast;
						v_chap := substr(v_rech_chap_clast.ide_lig_exec,4,4);
				 else
					     v_dat_cpta_limit := CAL_DERN_JOUR_PREC (P30_dat_cpta, P30_mens_trim);
					     RECH_DERN_REIMP (P30_ide_poste, P30_ide_gest, P30_ide_ordo, P30_cod_bud, v_ide_piece,  v_dat_cpta_limit, v_ide_lig_exec, v_ide_piece612);
					     if v_ide_piece612 = P30_ide_piece_init then
						    v_chap := substr(v_ide_lig_exec,4,4);
						 else
						    v_ide_lig_exec := null;
						    if P30_mens_trim = 'M' then
							   v_dat_cpta_limit := last_day(P30_dat_cpta);
							else
							   v_dat_cpta_limit := CAL_FIN_TRIM (P30_dat_cpta);
							end if;
						 end if;
				 end if;
			 else
			     v_dat_cpta_limit := P30_dat_cpta - 1;
			 end if;
	  else
	     v_dat_cpta_limit := P30_dat_cpta; -- pas de cas connu --
	  end if;

 if v_ide_lig_exec is null then

	RECH_DERN_REIMP (P30_ide_poste, P30_ide_gest, P30_ide_ordo, P30_cod_bud, v_ide_piece,  v_dat_cpta_limit, v_ide_lig_exec, v_ide_piece612);

	if v_ide_lig_exec is null then
	    v_ide_piece := P30_ide_piece;
	    if P30_ide_piece like '612%' and instr(v_ide_piece_orig,'-') > 0 then
		   v_ide_piece := substr(v_ide_piece_orig,1,instr(v_ide_piece_orig,'-')-1);
		end if;
	   -- if P30_num_lig = 1 and substr(P30_typ_piece,1,3) in ('600', '610') then            --supp MPS 22/12/2004
		if P30_num_lig = v_num_lig_min and substr(P30_typ_piece,1,3) in ('600', '610') then  -- ajout MPS 22/12/2004
		   v_chap := substr(P30_ide_lig_exec,4,4);
		else
	      OPEN c_rech_chap_clast (P30_ide_poste, P30_ide_gest, P30_ide_ordo, P30_cod_bud, v_ide_piece) ;
          FETCH c_rech_chap_clast INTO v_rech_chap_clast;
	      CLOSE c_rech_chap_clast;
	      v_chap := substr(v_rech_chap_clast.ide_lig_exec,4,4); -- le chap de classemt est celui de la ligne 1 du mandat d'origine
	    end if;
	else
	   v_chap := substr(v_ide_lig_exec,4,4);
	end if;

  end if;


END DETERMIN_CHAP_CLAST ;

---------------------------------------------------
-- DEBUT DU TRAITEMENT PRINCIPAL               ----
---------------------------------------------------
BEGIN

-- début ajout MPS 22/12/2004 ----
select min(num_lig)
into v_num_lig_min
from fb_ligne_piece
where ide_poste     = p_ide_poste
and   ide_gest      = p_ide_gest
and   ide_ordo      = p_ide_ordo
and   ide_piece     = p_ide_piece
and   cod_typ_piece = p_cod_typ_piece
and   cod_bud       = p_cod_bud;
-- fin ajout MPS 21/12/2004 ---

v_chap := '9999';

  if P_mens_trim in ('M', 'T') then

   if substr(P_ide_piece,1,3) in ('600', '610')
    --  or substr(P_ide_piece,1,3)||P_cod_typ_piece in ('614OD') then   -- MPS 28/03/2006 ajout de la 2ème condition -- supp MPS 05/03/2007 --
	  or substr(P_ide_piece,1,3)||P_cod_typ_piece in ('614OD','994OD') then   -- ajout MPS 05/03/2007 --

       DETERMIN_CHAP_CLAST(P_ide_poste, P_ide_gest, P_ide_ordo, P_cod_bud,  P_ide_piece,  substr(P_ide_piece,1,3), P_dat_cpta, v_dat_cpta, P_num_lig, P_mens_trim, P_ide_lig_exec, P_cod_typ_piece, P_ide_piece_init);

   elsif substr(p_ide_piece,1,3) in ('613', '614', '617', '993', '994') then

       RECH_MAND_ORIG_CASCADE (P_ide_poste, P_ide_gest, P_ide_ordo, P_cod_bud, P_ide_piece, P_ide_piece_init, substr(P_ide_piece,1,3), v_ide_piece_orig, v_dat_cpta);
       DETERMIN_CHAP_CLAST(P_ide_poste, P_ide_gest, P_ide_ordo, P_cod_bud, v_ide_piece_orig, substr(P_ide_piece,1,3), P_dat_cpta, v_dat_cpta, '0', P_mens_trim, P_ide_lig_exec, P_cod_typ_piece, P_ide_piece_init);

   elsif substr(P_ide_piece,1,3) in ('612') then

	   RECH_MAND_ORIG_CASCADE (P_ide_poste, P_ide_gest, P_ide_ordo, P_cod_bud, P_ide_piece, P_ide_piece_init, '612', v_ide_piece_orig, v_dat_cpta);
       DETERMIN_CHAP_CLAST(P_ide_poste, P_ide_gest, P_ide_ordo, P_cod_bud, v_ide_piece_orig, substr(P_ide_piece,1,3), P_dat_cpta, v_dat_cpta, '0', P_mens_trim, P_ide_lig_exec, P_cod_typ_piece, P_ide_piece_init);


   end if;

 end if;

 return v_chap;


  EXCEPTION

  WHEN OTHERS THEN
      RAISE;
END CHAP_CLASSEMENT;

/

CREATE OR REPLACE FUNCTION CPT_CONTREPARTIE( p_ide_poste     FC_LIGNE.ide_poste%TYPE,
                                            p_ide_gest       FC_LIGNE.ide_gest%TYPE,
											p_ide_jal        FC_LIGNE.ide_jal%TYPE,
											p_flg_cptab      FC_LIGNE.flg_cptab%TYPE,
											p_ide_ecr        FC_LIGNE.ide_ecr%TYPE,
											p_ide_lig        FC_LIGNE.ide_lig%TYPE,
											p_ide_modele_lig FC_LIGNE.ide_modele_lig%TYPE,
											p_cod_sens       FC_LIGNE.cod_sens%TYPE,
											p_mt             FC_LIGNE.mt%TYPE
                                          ) RETURN VARCHAR2 IS
--------------------------------------------------------------------
-- fonction spécifique développée par le DI44                    ---
-- créée par MPS le 03/01/2005                                  ---
--                                                              ---
--------------------------------------------------------------------



  v_cpt              VARCHAR2(15);
  v_nb_lig           FC_LIGNE.ide_lig%TYPE;
  v_max_cod_sens     FC_LIGNE.cod_sens%TYPE;
  v_min_cod_sens     FC_LIGNE.cod_sens%TYPE;


---------------------------------------------------------------------
-- Détermine le compte de contrepartie pour les modèles D1C1, D2C2 --
---------------------------------------------------------------------
PROCEDURE RECH_CPT_D1C1
(                       p1_ide_poste     FC_LIGNE.ide_poste%TYPE,
                        p1_ide_gest       FC_LIGNE.ide_gest%TYPE,
						p1_ide_jal        FC_LIGNE.ide_jal%TYPE,
						p1_flg_cptab      FC_LIGNE.flg_cptab%TYPE,
						p1_ide_ecr        FC_LIGNE.ide_ecr%TYPE,
						p1_ide_lig        FC_LIGNE.ide_lig%TYPE,
						p1_ide_modele_lig FC_LIGNE.ide_modele_lig%TYPE
)
IS

    CURSOR c_rech_cpt_D1C1(
	                    p10_ide_poste      FC_LIGNE.ide_poste%TYPE,
                        p10_ide_gest       FC_LIGNE.ide_gest%TYPE,
						p10_ide_jal        FC_LIGNE.ide_jal%TYPE,
						p10_flg_cptab      FC_LIGNE.flg_cptab%TYPE,
						p10_ide_ecr        FC_LIGNE.ide_ecr%TYPE,
						p10_ide_lig        FC_LIGNE.ide_lig%TYPE,
						p10_ide_modele_lig FC_LIGNE.ide_modele_lig%TYPE
						   ) IS
    SELECT ide_cpt
    FROM fc_ligne
    where    ide_poste = p10_ide_poste
	     and ide_gest  = p10_ide_gest
		 and ide_jal   = p10_ide_jal
		 and flg_cptab = p10_flg_cptab
		 and ide_ecr   = p10_ide_ecr
		 and ide_lig  != p10_ide_lig
		 and substr(ide_modele_lig,1,1) != substr(p10_ide_modele_lig,1,1)
		 and substr(ide_modele_lig,2,1) = substr(p10_ide_modele_lig,2,1)
	  ;
  v_rech_cpt_D1C1    c_rech_cpt_D1C1%ROWTYPE;

BEGIN

 open c_rech_cpt_D1C1(p1_ide_poste, p1_ide_gest, p1_ide_jal, p1_flg_cptab, p1_ide_ecr, p1_ide_lig, p1_ide_modele_lig);
 fetch c_rech_cpt_D1C1 into v_rech_cpt_D1C1;
 close c_rech_cpt_D1C1;

 v_cpt := v_rech_cpt_D1C1.ide_cpt;

END RECH_CPT_D1C1 ;

---------------------------------------------------------------------------------
-- Détermine le compte de contrepartie pour les écritures n'ayant que 2 lignes--
---------------------------------------------------------------------------------
PROCEDURE RECH_CPT_SIMPLE
(                       p2_ide_poste     FC_LIGNE.ide_poste%TYPE,
                        p2_ide_gest       FC_LIGNE.ide_gest%TYPE,
						p2_ide_jal        FC_LIGNE.ide_jal%TYPE,
						p2_flg_cptab      FC_LIGNE.flg_cptab%TYPE,
						p2_ide_ecr        FC_LIGNE.ide_ecr%TYPE,
						p2_ide_lig        FC_LIGNE.ide_lig%TYPE
)
IS

    CURSOR c_rech_cpt_simple(
	                    p20_ide_poste     FC_LIGNE.ide_poste%TYPE,
                        p20_ide_gest       FC_LIGNE.ide_gest%TYPE,
						p20_ide_jal        FC_LIGNE.ide_jal%TYPE,
						p20_flg_cptab      FC_LIGNE.flg_cptab%TYPE,
						p20_ide_ecr        FC_LIGNE.ide_ecr%TYPE,
						p20_ide_lig        FC_LIGNE.ide_lig%TYPE
						   ) IS
    SELECT ide_cpt
    FROM fc_ligne
    where    ide_poste = p20_ide_poste
	     and ide_gest  = p20_ide_gest
		 and ide_jal   = p20_ide_jal
		 and flg_cptab = p20_flg_cptab
		 and ide_ecr   = p20_ide_ecr
		 and ide_lig  != p20_ide_lig
	  ;
  v_rech_cpt_simple    c_rech_cpt_simple%ROWTYPE;

BEGIN

 open c_rech_cpt_simple(p2_ide_poste, p2_ide_gest, p2_ide_jal, p2_flg_cptab, p2_ide_ecr, p2_ide_lig);
 fetch c_rech_cpt_simple into v_rech_cpt_simple;
 close c_rech_cpt_simple;

 v_cpt := v_rech_cpt_simple.ide_cpt;

END RECH_CPT_SIMPLE ;

-----------------------------------------------------------------------------------
-- Détermine le compte de contrepartie pour les écritures ayant plus de 2 lignes --
-- et ayant à la fois des débits et des crédits
-----------------------------------------------------------------------------------
PROCEDURE RECH_CPT_SENS_INVER
(                       p3_ide_poste     FC_LIGNE.ide_poste%TYPE,
                        p3_ide_gest       FC_LIGNE.ide_gest%TYPE,
						p3_ide_jal        FC_LIGNE.ide_jal%TYPE,
						p3_flg_cptab      FC_LIGNE.flg_cptab%TYPE,
						p3_ide_ecr        FC_LIGNE.ide_ecr%TYPE,
						p3_ide_lig        FC_LIGNE.ide_lig%TYPE,
						p3_cod_sens       FC_LIGNE.cod_sens%TYPE
)
IS
    CURSOR c_rech_sens_inver(
	                    p30_ide_poste      FC_LIGNE.ide_poste%TYPE,
                        p30_ide_gest       FC_LIGNE.ide_gest%TYPE,
						p30_ide_jal        FC_LIGNE.ide_jal%TYPE,
						p30_flg_cptab      FC_LIGNE.flg_cptab%TYPE,
						p30_ide_ecr        FC_LIGNE.ide_ecr%TYPE,
						p30_ide_lig        FC_LIGNE.ide_lig%TYPE,
						p30_cod_sens       FC_LIGNE.cod_sens%TYPE
						   ) IS
    SELECT ide_cpt
    FROM fc_ligne
    where    ide_poste = p30_ide_poste
	     and ide_gest  = p30_ide_gest
		 and ide_jal   = p30_ide_jal
		 and flg_cptab = p30_flg_cptab
		 and ide_ecr   = p30_ide_ecr
		 and ide_lig  != p30_ide_lig
		 and cod_sens != p30_cod_sens
	  ;
  v_rech_sens_inver    c_rech_sens_inver%ROWTYPE;

BEGIN

 open c_rech_sens_inver(p3_ide_poste, p3_ide_gest, p3_ide_jal, p3_flg_cptab, p3_ide_ecr, p3_ide_lig, p3_cod_sens);
 fetch c_rech_sens_inver into v_rech_sens_inver;
 close c_rech_sens_inver;

 v_cpt := v_rech_sens_inver.ide_cpt;

END RECH_CPT_SENS_INVER ;

-----------------------------------------------------------------------------------
-- Détermine le compte de contrepartie pour les écritures ayant plus de 2 lignes --
-- et ayant soit que des débits soit que des crédits
-----------------------------------------------------------------------------------
PROCEDURE RECH_CPT_MEME_SENS
(                       p4_ide_poste      FC_LIGNE.ide_poste%TYPE,
                        p4_ide_gest       FC_LIGNE.ide_gest%TYPE,
						p4_ide_jal        FC_LIGNE.ide_jal%TYPE,
						p4_flg_cptab      FC_LIGNE.flg_cptab%TYPE,
						p4_ide_ecr        FC_LIGNE.ide_ecr%TYPE,
						p4_ide_lig        FC_LIGNE.ide_lig%TYPE,
						p4_mt             FC_LIGNE.mt%TYPE
)
IS
    CURSOR c_rech_meme_sens(
	                    p40_ide_poste      FC_LIGNE.ide_poste%TYPE,
                        p40_ide_gest       FC_LIGNE.ide_gest%TYPE,
						p40_ide_jal        FC_LIGNE.ide_jal%TYPE,
						p40_flg_cptab      FC_LIGNE.flg_cptab%TYPE,
						p40_ide_ecr        FC_LIGNE.ide_ecr%TYPE,
						p40_ide_lig        FC_LIGNE.ide_lig%TYPE,
						p40_mt             FC_LIGNE.mt%TYPE
						   ) IS
    SELECT ide_cpt
    FROM fc_ligne
    where    ide_poste = p40_ide_poste
	     and ide_gest  = p40_ide_gest
		 and ide_jal   = p40_ide_jal
		 and flg_cptab = p40_flg_cptab
		 and ide_ecr   = p40_ide_ecr
		 and ide_lig  != p40_ide_lig
		 and ((mt < 0 and p40_mt > 0) or (mt > 0 and p40_mt < 0))
	  ;
  v_rech_meme_sens    c_rech_meme_sens%ROWTYPE;

BEGIN

 open c_rech_meme_sens(p4_ide_poste, p4_ide_gest, p4_ide_jal, p4_flg_cptab, p4_ide_ecr, p4_ide_lig, p4_mt);
 fetch c_rech_meme_sens into v_rech_meme_sens;
 close c_rech_meme_sens;

 v_cpt := v_rech_meme_sens.ide_cpt;

END RECH_CPT_MEME_SENS ;



---------------------------------------------------
-- DEBUT DU TRAITEMENT PRINCIPAL               ----
---------------------------------------------------
BEGIN



   if substr(p_ide_modele_lig,1,2) in ('D1', 'D2', 'C1', 'C2') then

       RECH_CPT_D1C1(P_ide_poste, P_ide_gest, P_ide_jal, P_flg_cptab, P_ide_ecr,  P_ide_lig, p_ide_modele_lig);

   else
       select count(*), min(cod_sens), max(cod_sens)
	   	 into v_nb_lig, v_min_cod_sens, v_max_cod_sens
	     from fc_ligne
	   where ide_poste = p_ide_poste
	     and ide_gest  = p_ide_gest
		 and ide_jal   = p_ide_jal
		 and flg_cptab = p_flg_cptab
		 and ide_ecr   = p_ide_ecr;

	   if v_nb_lig = 2 then
	      RECH_CPT_SIMPLE(P_ide_poste, P_ide_gest, P_ide_jal, P_flg_cptab, P_ide_ecr,  P_ide_lig);
	   elsif v_min_cod_sens != v_max_cod_sens then
	      RECH_CPT_SENS_INVER(P_ide_poste, P_ide_gest, P_ide_jal, P_flg_cptab, P_ide_ecr,  P_ide_lig, P_cod_sens);
       else
	      RECH_CPT_MEME_SENS(P_ide_poste, P_ide_gest, P_ide_jal, P_flg_cptab, P_ide_ecr,  P_ide_lig, p_mt);
       end if;
   end if;

 return v_cpt;


  EXCEPTION

  WHEN OTHERS THEN
      RAISE;
END CPT_CONTREPARTIE;

/

CREATE OR REPLACE FUNCTION CRE_Sequence(Par_Nom_Sequence   IN   ALL_SEQUENCES.Sequence_Name%TYPE,
                                        Par_Increment      IN   ALL_SEQUENCES.Increment_By%TYPE,
                                        Par_StartWith      IN   ALL_SEQUENCES.Min_Value%TYPE,
                                        Par_MaxValue       IN   ALL_SEQUENCES.Max_Value%TYPE) RETURN NUMBER IS

Var_Commande        VARCHAR2(250);
CreSeq_Exception    EXCEPTION;
CreSyn_Exception    EXCEPTION;
Grant_Exception     EXCEPTION;

BEGIN
     -- Création de la séquence
     BEGIN
-- Début HPEJ le 10/04/2006 - Correction de la RLI V35-DIT44-083 : Rajout des options NOCACHE et NOCYCLE
--          Var_Commande := 'CREATE SEQUENCE PIAF_ADM.' || Par_Nom_Sequence || ' INCREMENT BY ' || Par_Increment || ' START WITH ' || Par_StartWith || ' MAXVALUE ' || Par_MaxValue;
          Var_Commande := 'CREATE SEQUENCE PIAF_ADM.' || Par_Nom_Sequence || ' INCREMENT BY ' || Par_Increment || ' START WITH ' || Par_StartWith || ' MAXVALUE ' || Par_MaxValue || ' NOCACHE NOCYCLE';
-- Fin HPEJ le 10/04/2006 - Correction de la RLI V35-DIT44-083
          EXECUTE IMMEDIATE Var_Commande;
     EXCEPTION
        WHEN OTHERS THEN
             RAISE CRESEQ_EXCEPTION;
     END;

     BEGIN
          Var_Commande := 'CREATE PUBLIC SYNONYM ' || Par_Nom_Sequence || ' FOR ' || Par_Nom_Sequence;
          EXECUTE IMMEDIATE Var_Commande;
     EXCEPTION
        WHEN OTHERS THEN
             RAISE CRESYN_EXCEPTION;
     END;

     BEGIN
          Var_Commande := 'GRANT SELECT,ALTER ON ' || Par_Nom_Sequence ||' TO PIAF_UTIL';
          EXECUTE IMMEDIATE Var_Commande;
     EXCEPTION
        WHEN OTHERS THEN
             RAISE GRANT_EXCEPTION;
     END;

     BEGIN
          Var_Commande := 'GRANT SELECT,ALTER ON ' || Par_Nom_Sequence ||' TO MES';
          EXECUTE IMMEDIATE Var_Commande;
     EXCEPTION
        WHEN OTHERS THEN
             RAISE GRANT_EXCEPTION;
     END;

     RETURN(1);

EXCEPTION
  WHEN CRESEQ_EXCEPTION THEN
       RETURN(-1);
  WHEN CRESYN_EXCEPTION THEN
       Var_Commande := 'DROP SEQUENCE PIAF_ADM.' || Par_Nom_Sequence;
       EXECUTE IMMEDIATE Var_Commande;
       RETURN(-1);
  WHEN GRANT_EXCEPTION THEN
       Var_Commande := 'DROP PUBLIC SYNONYM ' || Par_Nom_Sequence;
       EXECUTE IMMEDIATE Var_Commande;
       Var_Commande := 'DROP SEQUENCE PIAF_ADM.' || Par_Nom_Sequence;
       EXECUTE IMMEDIATE Var_Commande;
       RETURN(-1);
  WHEN OTHERS THEN
       RETURN(-1);
END CRE_Sequence;

/

CREATE OR REPLACE FUNCTION CTL_BalEntreeGeneree(p_ide_gest IN fn_gestion.ide_gest%TYPE,
                                                p_ide_poste IN fc_cumul.ide_poste%TYPE,
                                                p_ide_cpt IN fn_compte.ide_cpt%TYPE,
                                                p_var_cpta IN fn_compte.var_cpta%TYPE  -- MODIF SGN ANOVA200
                                               )RETURN NUMBER IS
/*
---------------------------------------------------------------------------------------
-- Nom           : CTL_BalEntreeGeneree
---------------------------------------------------------------------------------------
-- Date creation : 27/07/2001
-- Auteur        : SGN
-- Role          : Controle si un compte a fait l'objet d'une balence d entree cad il
--                 existe une ligne d ecriture pour ce compte, ce poste et cette gestion
--                 utilisant un journal flague en reprise de solde manuel (flg_be = O)
--                 et ce independament de la devise utilisee
---------------------------------------------------------------------------------------
--
-- Parametres    : p_ide_gest - la gestion en cours
--                 p_ide_poste - le poste du cpt sur lequel on veut effectuer le controle
--                 p_ide_cpt - le compte sur lequel on veut effectuer le controle
--                 p_var_cpta - variation comptable  -- MODIF SGN ANOVA200
--
-- Valeur retournee : 0 - Pas de balance d entree generee
--		          1 - Une balance d entree a ete generee
--               Les autres erreurs sont remontées et doivent être traitées par le programme appelant (SNE)
-- Appels		 :
-- 	--------------------------------------------------------------------
-- Version 		 : 3.0d-1.1
-- 	--------------------------------------------------------------------
-- 	Fonction					    	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#)CTL_BalEntreeGeneree.sql 2.1-1.0	|27/07/2001 | SGN	| Creation
-- @(#)CTL_BalEntreeGeneree.sql 3.0d-1.1	|21/01/2003 | SGN	| ANOVA200 : changement du la regle du controle ajout de la var cpta en parametre
---------------------------------------------------------------------------------------
*/
v_gestion_suiv fn_gestion%ROWTYPE;
v_ret NUMBER;
-- MODIF SGN ANOVA200 : v_dummy VARCHAR2(10);
v_dummy NUMBER;
v_libl SR_CODIF.libl%TYPE;
v_codext_oui SR_CODIF.cod_codif%TYPE;

BEGIN

  ---- Si la gestion suivante existe on regarde si on a pas d ecriture dans fc_cumul
  ---- renseignees a la date = premier jour de gestion de la gestion suivante
  --BEGIN
  --	   SELECT 'X'
  --	   INTO v_dummy
  --	   FROM fc_cumul, fn_gestion
  --	   WHERE fn_gestion.ide_gest = p_ide_gest
  --	     AND fc_cumul.ide_poste = p_ide_poste
  --	     AND fc_cumul.ide_gest = fn_gestion.ide_gest
  --		 AND fc_cumul.dat_arrete = fn_gestion.dat_dval
  --		 AND fc_cumul.ide_cpt = p_ide_cpt;
  --EXCEPTION
  --     WHEN NO_DATA_FOUND THEN -- Pas d enregistrements
  --	     RETURN(0);
  -- 	   WHEN TOO_MANY_ROWS THEN -- Des enregistrements existent
  --	   	 RETURN(1);
  --	   WHEN OTHERS THEN -- Erreur technique
  --	     RAISE;
  --END;

  -- Recuperation de la codif externe 'O'
  EXT_Codext('OUI_NON','O',v_libl,v_codext_oui,v_ret);
  IF v_ret != 1 THEN
    Return(-1);
  END IF;

  BEGIN
       SELECT 1
	 INTO v_dummy
       FROM fc_ligne, fc_journal
       WHERE fc_ligne.ide_poste = p_ide_poste
         AND fc_ligne.ide_gest = p_ide_gest
         AND fc_ligne.ide_cpt = p_ide_cpt
         AND fc_ligne.var_cpta = p_var_cpta
         AND fc_ligne.flg_cptab = v_codext_oui
         -- Jointure ligne/journal
         AND fc_ligne.ide_jal = fc_journal.ide_jal
         AND fc_ligne.var_cpta = fc_journal.var_cpta
         -- reprise de solde manuelle
         AND fc_journal.flg_be = v_codext_oui;

  EXCEPTION
       WHEN NO_DATA_FOUND THEN -- Pas d enregistrements
	     RETURN(0);
  	 WHEN TOO_MANY_ROWS THEN -- Des enregistrements existent
	     RETURN(1);
	 WHEN OTHERS THEN -- Erreur technique
	     RAISE;
  END;
  -- Fin modif sgn

  -- On a trouve un enregistrement
  RETURN(1);

EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END CTL_BalEntreeGeneree;

/

CREATE OR REPLACE FUNCTION CTL_Clotgesposte(p_ideposte   IN   rm_poste.ide_poste%TYPE,
                                            p_idegest    IN   fn_gestion.ide_gest%TYPE) RETURN VARCHAR2 IS

/*****************************************************/
/* Retour   : 'O' si la cloture de la gestion a été  */
/*                effectuée pour le poste comptable  */
/*                                                   */
/*            'N' sinon                              */
/*****************************************************/

  v_count   NUMBER;

BEGIN
  SELECT count(*) INTO v_count
  FROM sm_som_cadcar
  WHERE ide_poste = p_ideposte
    AND ide_gest  = p_idegest;

  IF NVL(v_count,0) = 0 THEN
    Return('N');
  ELSE
    Return('O');
  END IF;

EXCEPTION
  WHEN Others THEN
    Return('');
END CTL_Clotgesposte;

/

CREATE OR REPLACE FUNCTION CTL_COD_USER ( p_code_user IN fh_util.COD_UTIL%TYPE) RETURN NUMBER IS
/*---------------------------------------------------------------------------------------
-- Nom           : CTL_COD_USER
-- ---------------------------------------------------------------------------
--  Auteur         : FBT
--  Date creation  : 28/01/2008
-- ---------------------------------------------------------------------------
-- Role   :  Cette fonction a pour but de controler la validité d'un code d'utilisateur
--
-- Parametres    :
--          1 - p_ide_user : code de user proposé
--
-- Valeur retournee : 0 : Le code user proposé est valide
-- 		  			  1 : Le code user proposé est invalide
--
-- Appels   : neant
--
--  --------------------------------------------------------------------
--  Fonction         	   |Version |Date        |Initiales |Commentaires
--  --------------------------------------------------------------------
-- @(#) CTL_COD_USER.sql   |V4240  |28/01/2008  | FBT      | Création
---------------------------------------------------------------------------------------*/
 v_retour 	NUMBER :=0 ;
 p_temp 	VARCHAR2(200) := '';
BEGIN
  --parcours de la chaine
  FOR i IN 1..LENGTH(p_code_user) LOOP
  	  --Récupération du caractère en cours
	  p_temp := SUBSTR(p_code_user, i, 1 );
	  --si il ne s'agit pas d'un caractère autorisé
	  IF p_temp NOT IN ('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
	  'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
	  '-','_','0','1','2','3','4','5','6','7','8','9')
	  THEN
	  	 v_retour:=1;
	  END IF;
  END LOOP;

  --Retour de fonction
  RETURN v_retour;
END;

/

CREATE OR REPLACE FUNCTION CTL_Cpt_Bq (p_cpt_Bq IN FB_COORD_BANC.cpt_bq%TYPE) RETURN BOOLEAN IS
v_return	BOOLEAN;
BEGIN
  v_return := TRUE;
  RETURN (v_return);
END CTL_Cpt_Bq;

/

CREATE OR REPLACE FUNCTION CTL_cpt_repsolde(p_ide_poste IN rm_poste.ide_poste%TYPE,
                                            p_ide_gest IN fn_gestion.ide_gest%TYPE,
						        p_ide_cpt IN fn_compte.ide_cpt%TYPE,
							  p_var_cpta IN fn_compte.var_cpta%TYPE
							 ) RETURN NUMBER IS
/*
---------------------------------------------------------------------------------------
-- Nom           : CTL_cpt_repsolde
---------------------------------------------------------------------------------------
-- Date creation : 16/01/2003
-- Auteur        : SGN
-- Role          : Controle si un compte a fait l'objet d'une reprise de solde cad il
--                 existe une ligne d ecriture pour ce compte, ce poste et cette gestion
--                 utilisant un journal flague en reprise de solde auto (flg_repsolde = O)
--                 et ce independament de la devise utilisee
---------------------------------------------------------------------------------------
--
-- Parametres    : p_ide_poste - le poste du cpt sur lequel on veut effectuer le controle
--                 p_ide_gest - la gestion en cours
--                 p_ide_cpt - le compte sur lequel on veut effectuer le controle
--                 p_var_cpta - la variation cptable du compte sur lequel on veut effectuer le controle
--
-- Valeur retournee : 0 - Il n'y a pas eu de reprise de solde sur ce compte
--		      		  1 - Il y a eu de reprise de solde sur ce compte
--               Les autres erreurs sont remontées et doivent être traitées par le programme appelant
-- Appels		 :
-- 	--------------------------------------------------------------------
-- Version 		 : 3.0d-1.1
-- 	--------------------------------------------------------------------
-- 	Fonction					    	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#)CTL_cpt_repsolde.sql 3.0d-1.0	|16/01/2002 | SGN	| Creation
-- @(#)CTL_cpt_repsolde.sql 3.0d-1.1	|16/01/2002 | SGN	| ANOVA200 : on ne considere que le journal en reprise de solde (flg_repsolde = O)
---------------------------------------------------------------------------------------
*/
v_ret NUMBER;
v_dummy NUMBER;
v_libl SR_CODIF.libl%TYPE;
v_codext_oui SR_CODIF.cod_codif%TYPE;
v_retour NUMBER;

BEGIN

  -- Recuperation de la codif externe 'O'
  EXT_Codext('OUI_NON','O',v_libl,v_codext_oui,v_retour);
  IF v_retour != 1 THEN
    Return(-1);
  END IF;

  BEGIN
       SELECT 1
	   INTO v_dummy
       FROM fc_ligne, fc_journal
       WHERE fc_ligne.ide_poste = p_ide_poste
         AND fc_ligne.ide_gest = p_ide_gest
         AND fc_ligne.ide_cpt = p_ide_cpt
         AND fc_ligne.var_cpta = p_var_cpta
         AND fc_ligne.flg_cptab = v_codext_oui
         -- Jointure ligne/journal
         AND fc_ligne.ide_jal = fc_journal.ide_jal
         AND fc_ligne.var_cpta = fc_journal.var_cpta
         -- reprise de solde auto
         -- MODIF SGN ANOVA200 : AND (fc_journal.flg_be = v_codext_oui OR fc_journal.flg_repsolde = v_codext_oui);
         AND fc_journal.flg_repsolde = v_codext_oui;

  EXCEPTION
       WHEN NO_DATA_FOUND THEN -- Pas d enregistrements
	     RETURN(0);
  	   WHEN TOO_MANY_ROWS THEN -- Des enregistrements existent
	   	 RETURN(1);
	   WHEN OTHERS THEN -- Erreur technique
	     RAISE;
  END;

  -- On a trouve un enregistrement
  RETURN(1);

EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END CTL_cpt_repsolde;

/

CREATE OR REPLACE FUNCTION CTL_Date(datedeb date, datefin date) RETURN VARCHAR2 IS
BEGIN
  IF (datedeb IS NULL OR datefin IS NULL) THEN
    Return('O');
  ELSE
    IF TRUNC(datefin) < TRUNC(datedeb) THEN
      Return('N');
    ELSE
      Return('O');
    END IF;
  END IF;
END CTL_Date;

/

CREATE OR REPLACE FUNCTION CTL_date_correcte(p_strdate IN VARCHAR2,
                                             p_strFormat IN VARCHAR2 := NULL) RETURN NUMBER IS
/*
---------------------------------------------------------------------------------------
-- Nom           : CTL_date_correcte
-- Date creation : 23/11/1999
-- Creee par     : SOFIANE NEKERE (SEMA GROUP)
-- Role          : Controle de la validite d'une date (selon un format specifique quand
--		       celui-ci est passe en parametre ou selon les parametres 'NLS' en cours)
-- Parametres    : p_strdate - date a verifier (sous la forme d'une chaine de caracteres)
--			 p_strFormat : Parametre facultatif indiquant un eventuel format de la date
-- Valeur retournee : 0 - la valeur verifiee n'est pas une date (KO)
--			    1 - la valeur verifiee est une date valide (OK)
-- Appels		 :
-- Version 		 : 1.0
-- Historique 	 : v1.0 Creation
---------------------------------------------------------------------------------------
*/
v_date DATE;
BEGIN
  IF p_strFormat IS NOT NULL THEN
	  v_date := TO_DATE(p_strdate, p_strFormat);
  ELSE
	v_date := TO_DATE(p_strdate);
  END IF;
  RETURN 1;
EXCEPTION
  WHEN OTHERS THEN
        RETURN 0;
END CTL_date_correcte;

/

CREATE OR REPLACE FUNCTION Ctl_Diffusion ( p_dat_maj IN DATE ) RETURN CHAR IS
/* Fonction qui controle la date passee en parametre avec la date de derniere diffusion */
/* Retour : O si la donnée a fait l'objet d'une diffusion
            N si la donnee n'a pas fait l'objet d'une diffusion */
  p_ret CHAR(1);
  v_datetime_format VARCHAR2(50) := null;
BEGIN
  IF Global.dat_der_diff IS NULL THEN
     p_ret := 'N';
  ELSE
    IF p_dat_maj < Global.dat_der_diff THEN
      p_ret := 'O';
    ELSE
      p_ret := 'N';
    END IF;
  END IF;

  RETURN (p_ret);

END Ctl_Diffusion;

/

CREATE OR REPLACE FUNCTION CTL_Edition_Compte(p_nom_ut      IN   sh_fonction.cod_role%TYPE,
                                              p_typ_cpt     IN   fn_compte.ide_typ_cpt%TYPE) RETURN VARCHAR2 IS

/* ************************************************** */
/* Entree   :  Nom UT edition                         */
/* ----------  Type du compte                         */
/*                                                    */
/*                                                    */
/* Retour   :  'O' si le Type du compte est edite     */
/* ----------      par cette UT                       */
/*                                                    */
/*            'N' sinon                               */
/* ************************************************** */

  v_count   NUMBER;

BEGIN
  SELECT count(*) INTO v_count
  FROM rn_type_compte j,sh_fonction f
  WHERE f.ide_fct = j.ide_fct
    AND f.cod_role = p_nom_ut
    AND j.ide_typ_cpt = p_typ_cpt;

  IF NVL(v_count,0) = 0 THEN
    Return('N');
  ELSE
    Return('O');
  END IF;

EXCEPTION
  WHEN Others THEN
    Return('');
END CTL_Edition_Compte;

/

CREATE OR REPLACE FUNCTION CTL_Edition_Journal(p_nom_ut      IN   sh_fonction.cod_role%TYPE,
                                               p_typ_jal     IN   fc_journal.ide_typ_jal%TYPE) RETURN VARCHAR2 IS

/* ************************************************** */
/* Entree   :  Nom UT edition                         */
/* ----------  Type du journal                        */
/*                                                    */
/*                                                    */
/* Retour   :  'O' si le Type du journal est edite    */
/* ----------      par cette UT                       */
/*                                                    */
/*            'N' sinon                               */
/* ************************************************** */

  v_count   NUMBER;

BEGIN
  SELECT count(*) INTO v_count
  FROM rc_type_journal j,sh_fonction f
  WHERE f.ide_fct = j.ide_fct
    AND f.cod_role = p_nom_ut
    AND j.ide_typ_jal = p_typ_jal;

  IF NVL(v_count,0) = 0 THEN
    Return('N');
  ELSE
    Return('O');
  END IF;

EXCEPTION
  WHEN Others THEN
    Return('');
END CTL_Edition_Journal;

/

CREATE OR REPLACE FUNCTION CTL_EQUILIBRE_ECR(p_ide_poste   IN   fc_ecriture.ide_poste%TYPE,
                                         p_ide_gest        IN   fc_ecriture.ide_gest%TYPE,
                                         p_ide_jal         IN   fc_ecriture.ide_jal%TYPE,
                                         p_flg_cptab       IN   fc_ecriture.flg_cptab%TYPE,
                                         p_ide_ecr         IN   fc_ecriture.ide_ecr%TYPE) RETURN NUMBER IS

/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : CGE
-- Nom           : CTL_EQUILIBRE_ECR
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 10/10/2002
-- ---------------------------------------------------------------------------
-- Role          : Contrôle de l'equilibre d'une ligne on ne prend pas en compte
--                 les lignes agissant sur des compte en partie simple
--
-- Parametres    :
--         Entrée
--		      	 1 - P_IDE_POSTE       : poste comptable
--				 2 - P_IDE_GEST        : gestion
--				 3 - P_JAL             : journal
-- 				 4 - P_FLG_CPTAB       : flag comptabilise
--				 5 - P_IDE_ECR         : identifiant de l'ecriture
--     Sortie
--
-- Valeurs retournees :
--                                     1  ecriture equilibre
-- 		   			   				   0  ecriture non equilibre
--                                    -1 Erreur lors de la recuperation du code interne C
--                                    -2 Erreur lors de la recuperation du code interne D
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) CTL_EQUILIBRE_ECR.sql version 3.0-1.2
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	   |Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) CTL_EQUILIBRE_ECR.sql 3.0-1.0  |10/10/2002| SGN	| Création
-- @(#) CTL_EQUILIBRE_ECR.sql 3.0-1.1  |10/10/2002| SGN	| On ne doit pas prendre en compte les lignes
-- @(#) CTL_EQUILIBRE_ECR.sql 3.0-1.1       avec un compte en parti simple
-- @(#) CTL_EQUILIBRE_ECR.sql 3.0-1.2 |18/10/2002| SGN	| Ajout du / en fin de proc
-- 	----------------------------------------------------------------------------------------------------------
*/

v_mt_cr fc_ligne.mt%TYPE;
v_mt_db fc_ligne.mt%TYPE;

v_lib_C sr_codif.libl%TYPE;
v_cod_C sr_codif.cod_codif%TYPE;
v_lib_D sr_codif.libl%TYPE;
v_cod_D sr_codif.cod_codif%TYPE;
v_lib_O sr_codif.libl%TYPE;
v_cod_O sr_codif.cod_codif%TYPE;


err_codext_C EXCEPTION;
err_codext_D EXCEPTION;
err_codext_O EXCEPTION;

v_ret NUMBER;

BEGIN

	 /* Recuperation des codes internes */
	 EXT_Codext('SENS','C',v_lib_C,v_cod_C,v_ret);
	 IF v_ret != 1 THEN
	 	RAISE err_codext_C;
     END IF;

 	 EXT_Codext('SENS','D',v_lib_D,v_cod_D,v_ret);
	 IF v_ret != 1 THEN
	 	RAISE err_codext_D;
     END IF;

	 EXT_Codext('OUI_NON','O',v_lib_O,v_cod_O,v_ret);
	 IF v_ret != 1 THEN
	 	RAISE err_codext_O;
     END IF;


     -- On recupere la somme des montants des lignes au credit de l'ecriture
	 -- on ne prend pas en compte les lignes agissant sur des comptes en partie simple
	 BEGIN
	 	  SELECT NVL(SUM(mt),0)
		  INTO v_mt_cr
	 	  FROM fc_ligne l, fn_compte c
	 	  WHERE l.ide_poste = p_ide_poste
	   	    AND l.ide_jal = p_ide_jal
	 		AND l.flg_cptab = p_flg_cptab
	   		AND l.ide_ecr = p_ide_ecr
	   		AND l.cod_sens = v_cod_C
			AND l.var_cpta = c.var_cpta
			AND l.ide_cpt = c.ide_cpt
			AND c.flg_simp != v_cod_O;
	 EXCEPTION
	 	  WHEN OTHERS THEN
		  	  RAISE;
	 END;

     -- On recupere la somme des montants des lignes au debit de l'ecriture
	 -- on ne prend pas en compte les lignes agissant sur des comptes en partie simple
	 BEGIN
	 	  SELECT NVL(SUM(mt),0)
		  INTO v_mt_db
	 	  FROM fc_ligne l, fn_compte c
	 	  WHERE ide_poste = p_ide_poste
	   	    AND ide_jal = p_ide_jal
	 		AND flg_cptab = p_flg_cptab
	   		AND ide_ecr = p_ide_ecr
	   		AND cod_sens = v_cod_D
			AND l.var_cpta = c.var_cpta
			AND l.ide_cpt = c.ide_cpt
			AND c.flg_simp != v_cod_O;

	 EXCEPTION
	 	  WHEN OTHERS THEN
		  	  RAISE;
	 END;


	 -- Si la somme des montants au credit egale la somme des montants au debit
	 --    => l'ecriture est equilibree
	 IF v_mt_db = v_mt_cr THEN
	 	RETURN 1;
	 ELSE
	 	RETURN 0;
	 END IF;

EXCEPTION
     WHEN err_codext_C THEN
	      RETURN -1;
     WHEN err_codext_D THEN
	      RETURN -2;
     WHEN err_codext_O THEN
	      RETURN -3;
     WHEN OTHERS THEN
	  	  RAISE;

END;

/

CREATE OR REPLACE FUNCTION Ctl_Mvt_Bud (
                                        p_num_mvt_bud         IN FB_MVT_BUD.NUM_MVT_BUD%TYPE,
                                        p_num_mvt_bud_init    IN FB_MVT_BUD.NUM_MVT_INIT%TYPE,
										p_ide_poste           IN FB_MVT_BUD.IDE_POSTE%TYPE,
										p_ide_ordo            IN FB_MVT_BUD.IDE_ORDO%TYPE,
										p_cod_nat_mvt         IN FB_MVT_BUD.COD_NAT_MVT%TYPE,
										p_trt_unicite_mvt_bud IN VARCHAR2,
										p_param_ctrl_unimvt IN OUT SR_PARAM.IDE_PARAM%TYPE
										)
RETURN NUMBER IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : PARAMETRAGE
-- Nom           : CTL_MVT_BUD
-- ---------------------------------------------------------------------------
--  Auteur         : LGD
--  Date creation  : 22/08/2003
-- ---------------------------------------------------------------------------
-- Role          : Contrôle d'unicité du numéro de mouvement budgétaire +
--                 Contrôle si le mouvement initial est obligatoire + contrôle d'unicité du numéro de mouvement budgétaire initial
--
--
-- Parametres  entree  :
-- 				 1 - p_num_mvt_bud      : Numéro de mouvement budgétaire
--				 2 - p_num_mvt_bud_init : Numéro de mouvement budgétaire initial
--               3 - p_cod_nat_mvt      : Code de nature de mouvement  (pour déterminer si le numéro init est obligatoire)
--               4 - p_ide_poste        : Poste comptable pour la recherche d'unicité
--               5 - p_ide_ordo         : Ordonnateur pour la recherche d'unicité
--               6 - p_cod_nat_mvt      : Code nature de mouvement budgétaire
--
--
-- Parametres  en sortie  :
--               7 - p_param_ctrl_unimvt : Valeur du masque à retourner
--
--
-- Valeur  retournée en sortie :
--				                1 => Contrôle OK
--                             -1 => Contrôle KO : Erreur lors de la récupération du paramètre de contrôle d''unicité du numéro de mouvement budgétaire (paramètre %1)
--                             -2 => Contrôle KO : Le numéro de mouvement existe déjà.
                               -3 => Contrôle KO : Incohérence code interne %1 %2 pour le code RNAPA
							   -4 => Contrôle KO : Incohérence code interne %1 %2 pour le code NAPAC
                               -5 => Contrôle KO : La saisie du numéro de mouvement initial est obligatoire
							   -6 => Contrôle KO : Le numéro de mouvement initial  n'existe pas
--
-- ---------------------------------------------------------------------------
--  Version        : @(#) CTL_MVT_BUD.sql version 3.3-1.0
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) CTL_MASQ_CODE.sql 3.3-1.0	|22/08/2003| LGD	| Initialisation
-- 	----------------------------------------------------------------------------------------------------------
*/

v_ret NUMBER;
v_libl SR_CODIF.libl%TYPE;
v_rnapa_cod_int SR_CODIF.ide_codif%TYPE;
v_napac_cod_int SR_CODIF.ide_codif%TYPE;
v_codint_ctrl_unimvt SR_CODIF.ide_codif%TYPE;
v_recup VARCHAR2(120);

FUNCTION RCP_NUM_MVT_BUD RETURN NUMBER IS
  v_recup    VARCHAR2(100);
BEGIN
	  SELECT NUM_MVT_BUD INTO v_recup
	  FROM FB_MVT_BUD
	  WHERE ide_poste   = p_ide_poste AND
	        ide_ordo    = p_ide_ordo AND
			num_mvt_bud = p_num_mvt_bud;

  RETURN(-1);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN(1);
  WHEN OTHERS THEN
	RAISE;
END RCP_NUM_MVT_BUD;

FUNCTION RCP_NUM_MVT_BUD_INIT RETURN NUMBER IS
  v_recup    VARCHAR2(100);
BEGIN
  SELECT NUM_MVT_BUD INTO v_recup
  FROM FB_MVT_BUD
  WHERE ide_poste   = p_ide_poste AND
        ide_ordo    = p_ide_ordo AND
		num_mvt_bud = p_num_mvt_bud_init;

  RETURN(1);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN(-1);
  WHEN OTHERS THEN
    RAISE;
END RCP_NUM_MVT_BUD_INIT ;

BEGIN

  --1) Recherche d'unicité du mouvement budgétaire

	  --1.1 ) Recherche du paramètre d'unicité
      p_param_ctrl_unimvt := 'IB0080';
	  Ext_Param(p_param_ctrl_unimvt, v_codint_ctrl_unimvt, v_ret);
	  IF v_ret != 1 THEN
	     -- Erreur lors de la récupération du paramètre de contrôle d'unicité du numéro de mouvement budgétaire est à faire.
		 RETURN(-1);
	  ELSE
	    IF v_codint_ctrl_unimvt ='N' THEN
		  --- Le contrôle d'unicité du mouvement budgétaire n'est pas à faire
		  RETURN(1);
		END IF;
	  END IF;

     --1.2 ) Contrôle d'unicité du numéro de mouvement budgétaire
	 IF RCP_NUM_MVT_BUD = -1 AND p_trt_unicite_mvt_bud ='OK' THEN
	   --- Le numéro de mouvement existe déjà
	   RETURN(-2);
	 END IF;

  --2) Recherche si le num de mvt initial est obligatoire
  IF p_num_mvt_bud_init IS NULL AND v_codint_ctrl_unimvt ='O' THEN

      --2.1) Récupération du code interne RNAPA et NAPAC
	  Ext_Codint('OPERATION','RNAPA',v_libl,v_rnapa_cod_int,v_ret);
	  IF v_ret!=1 THEN
	    -- Incohérence code interne %1 %2 pour le RNAPA
		RETURN(-3);
	  END IF;

	  Ext_Codint('OPERATION','NAPAC',v_libl,v_napac_cod_int,v_ret);
	  IF v_ret!=1 THEN
	    -- Incohérence code interne %1 %2 pour le NAPAC
		RETURN(-4);
	  END IF;

     --2.2) Comparaison avec le cod_nat_mvt
	 IF p_cod_nat_mvt IN (v_rnapa_cod_int,v_napac_cod_int) THEN
	   --- La saisie du numéro de mouvement initial est obligatoire
	   RETURN(-5);
	 END IF;

  END IF;

  --3) Recherche sur l'unicité du mouvement initial
  IF p_num_mvt_bud_init IS NOT NULL AND v_codint_ctrl_unimvt ='O' THEN
	 IF RCP_NUM_MVT_BUD_INIT = -1 THEN
	   --- Le numéro de mouvement initial  n'existe pas
	   RETURN(-6);
	 END IF;

  END IF;

  RETURN(1);


EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END Ctl_Mvt_Bud;

/

CREATE OR REPLACE FUNCTION CTL_Situations ( p_cod_ope IN sb_situ.cod_ope%TYPE,
                          p_cod_orig_benef IN sb_situ.cod_orig_benef%TYPE,
                          p_ide_poste IN fb_rechb.ide_poste%TYPE,
                          p_ide_ordo IN fb_rechb.ide_ordo%TYPE,
                          p_cod_bud IN fb_rechb.cod_bud%TYPE,
                          p_var_bud IN fb_rechb.var_bud%TYPE,
                          p_mt IN fb_rechb.mt%TYPE,
                          p_ide_gest IN fb_credi.ide_gest%TYPE,
                          p_lig_prev IN fb_reser.ide_lig_prev%TYPE,
                          p_ide_ope IN fb_rechb.ide_ope%TYPE,
			  p_table IN sb_situ.table_name%TYPE  ) RETURN NUMBER IS

/* Variables locales */
v_retour NUMBER := 1 ;

v_ret_cal NUMBER;
v_mt1 fb_autpro.mt%TYPE;
v_mt2 fb_autpro.mt%TYPE;
v_mt3 fb_autpro.mt%TYPE;
v_mt4 fb_autpro.mt%TYPE;
v_mt5 fb_autpro.mt%TYPE;
v_mt6 fb_autpro.mt%TYPE;
v_mt7 fb_autpro.mt%TYPE;
v_mt8 fb_autpro.mt%TYPE;
v_mt9 fb_autpro.mt%TYPE;
v_dispo_res fb_autpro.mt%TYPE;
v_dispo_ordo fb_autpro.mt%TYPE;
v_dispo_eng fb_autpro.mt%TYPE;
v_sdeleg_eng fb_autpro.mt%TYPE;
v_deleng_r fb_autpro.mt%TYPE;
v_tx_autor fn_ligne_bud_prev.tx_autor%TYPE;
v_mt fb_autpro.mt%TYPE;

-- MODIF SGN ANOVA 13,14,36
v_tot_ordo fb_credi.mt%TYPE;
v_dispo_cr fb_credi.mt%TYPE;
-- fin modif sgn

/* Exceptions */
err_cal EXCEPTION;
err_dispo EXCEPTION;
-- MODIF SGN ANOVA 13,14,36
err_mt_rescre EXCEPTION;
err_dispo_rescre EXCEPTION;
-- fin modif sgn

BEGIN

  IF p_table = 'FB_AUTPRO' THEN
      CAL_Autpro(p_ide_poste,p_ide_ordo,p_cod_bud,p_lig_prev,v_mt1,v_mt2,v_mt3,v_mt4,v_dispo_res,v_ret_cal);
      IF v_ret_cal < 0 THEN
        RAISE err_cal;
      END IF;
      IF p_cod_orig_benef = 'B' AND (v_dispo_res+p_mt) < 0 THEN
        RAISE err_dispo;
      ELSIF p_cod_orig_benef <> 'B' AND (v_dispo_res-p_mt) < 0 THEN
        RAISE err_dispo;
      END IF;

  ELSIF p_table = 'FB_CREPA' THEN
      CAL_Crepa(p_ide_poste,p_ide_ordo,p_cod_bud,p_var_bud,p_lig_prev,p_ide_gest,v_mt1,v_mt2,v_mt3,v_mt4,v_mt5,v_dispo_ordo,v_tx_autor,v_ret_cal);
      IF v_ret_cal < 0 THEN
        RAISE err_cal;
      END IF;
      IF p_cod_ope = 'DOTCP' OR p_cod_ope = 'VIRCP' THEN
        v_mt := p_mt * v_tx_autor;
      ELSE
        v_mt := p_mt;
      END IF;
      IF p_cod_orig_benef = 'B' AND (v_dispo_ordo+v_mt) < 0 THEN
        RAISE err_dispo;
      ELSIF p_cod_orig_benef <> 'B' AND (v_dispo_ordo-v_mt) < 0 THEN
        RAISE err_dispo;
      END IF;

  ELSIF p_table = 'FB_RESER' AND p_cod_ope <> 'ODCPA' THEN
      CAL_Reser(p_ide_poste,p_ide_ordo,p_cod_bud,p_ide_ope,p_lig_prev,v_mt1,v_mt2,v_mt3,v_mt4,v_mt5,v_dispo_eng,v_sdeleg_eng,v_mt6,v_mt7,v_deleng_r,v_ret_cal);
      IF v_ret_cal < 0 THEN
        RAISE err_cal;
      END IF;
      IF p_cod_ope = 'GLRES' AND (v_deleng_r-v_sdeleg_eng-p_mt) < 0 THEN
        RAISE err_dispo;
      ELSIF p_cod_ope != 'GLRES' AND p_cod_orig_benef = 'B' AND (v_dispo_eng+p_mt) < 0 THEN
        RAISE err_dispo;
      ELSIF p_cod_ope != 'GLRES' AND p_cod_orig_benef != 'B' AND (v_dispo_eng-p_mt) < 0 THEN
        RAISE err_dispo;
      END IF;

  ELSIF p_table = 'FB_CREDI' AND p_cod_ope <> 'ODCRE' AND p_cod_ope <> 'DSORD' THEN
      CAL_Credi(p_ide_poste,p_ide_ordo,p_cod_bud,p_var_bud,p_lig_prev,p_ide_gest,v_mt1,v_mt2,v_mt3,v_mt4,v_mt5,v_sdeleg_eng,v_mt6,v_dispo_eng,v_tot_ordo,v_mt8,v_mt9,v_tx_autor,v_deleng_r,v_ret_cal);
      IF v_ret_cal < 0 THEN
        RAISE err_cal;
      END IF;
      IF p_cod_ope = 'GLCRE' AND (v_deleng_r-v_sdeleg_eng-p_mt) < 0 THEN
        RAISE err_dispo;
	  ELSIF p_cod_ope <> 'GLCRE' THEN
        IF p_cod_ope = 'DTCRE' OR p_cod_ope = 'VRCRE' THEN
          v_mt := p_mt * v_tx_autor;
        ELSE
          v_mt := p_mt;
        END IF;

		-- MODIF SGN ANOVA 13,14,36 : ajout des controles specifiques au RESCRE
		IF p_cod_ope = 'OREDE' THEN
		   -- Le montant ne doit pas etre superieur au mt total ordonnance
		   IF v_mt > v_tot_ordo THEN
		     RAISE err_mt_rescre;
		   END IF;

		   -- L OR ne doit pas faire que le dispo a engager soit superieur aux credits dispo
		   IF p_cod_orig_benef = 'B' AND (v_dispo_eng + v_mt ) > v_dispo_cr THEN
		     RAISE err_dispo_rescre;
           ELSIF p_cod_orig_benef <> 'B' AND (v_dispo_eng-v_mt) > v_dispo_cr THEN
             RAISE err_dispo_rescre;
           END IF;
		-- fin modif sgn
		ELSE
		   IF p_cod_orig_benef = 'B' AND (v_dispo_eng+v_mt) < 0 THEN
		     RAISE err_dispo;
           ELSIF p_cod_orig_benef <> 'B' AND (v_dispo_eng-v_mt) < 0 THEN
             RAISE err_dispo;
           END IF;
        END IF;
	  END IF;

  ELSIF p_table = 'FB_DEPHB' AND p_cod_ope <> 'ODENV' THEN
      CAL_Dephb(p_ide_poste,p_ide_ordo,p_cod_bud,p_ide_ope,v_mt1,v_mt2,v_mt3,v_mt4,v_mt5,v_mt6,v_dispo_eng,v_sdeleg_eng,v_mt7,v_mt8,v_deleng_r,v_ret_cal);
      IF v_ret_cal < 0 THEN
        RAISE err_cal;
      END IF;
      IF p_cod_ope = 'GLENV' AND v_deleng_r - v_sdeleg_eng - p_mt < 0 THEN
	-- dbms_output.put_line('cas 1');
        RAISE err_dispo;
      ELSIF p_cod_ope <> 'GLENV' AND p_cod_orig_benef = 'B' AND v_dispo_eng + p_mt < 0 THEN
	-- dbms_output.put_line('cas 2');
        RAISE err_dispo;
      ELSIF p_cod_ope <> 'GLENV' AND p_cod_orig_benef <> 'B' AND (v_dispo_eng-p_mt) < 0 THEN
	-- dbms_output.put_line('cas 3: '||v_dispo_eng);
        RAISE err_dispo;
      END IF;

  END IF;

  RETURN (v_retour);

EXCEPTION
  WHEN err_dispo THEN
    --dbms_output.put_line('err_dispo');
    RETURN (-2);
  WHEN err_cal THEN
    --dbms_output.put_line('err_cal');
    RETURN (-3);
  WHEN err_dispo_rescre THEN
    RETURN (-4);
  WHEN err_mt_rescre THEN
    RETURN (-5);
  WHEN OTHERS THEN
    RAISE;
	-- MODIF SGN ANOVA : RETURN (-1);

END CTL_Situations;

/

CREATE OR REPLACE FUNCTION CTL_Val_Masque(p_val_masque IN  VARCHAR2,
                                          p_sais_masque IN  VARCHAR2,
                                          p_date IN DATE ) RETURN NUMBER
IS
/*
---------------------------------------------------------------------------------------
-- Nom           : CTL_Val_Masque
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 23/11/1999
-- ---------------------------------------------------------------------------
-- Role          :
-- Parametres en entree    : p_val_masque - valeur du masque de controle a appliquer pour le controle
--                           p_sais_masque - valeur a verifier par rapport au masque
--                           p_date -
-- Parametre en sortie : p_retour : 0 saisie invalide pour le masque
--                                  -1 si erreur base
--                                  -2 si autre erreur
--                                  1 si la saisie est correcte par rapport au masque et valide
--                                  2 si la donnée existe mais n'est pas valide
-- ---------------------------------------------------------------------------
--  Version        : @(#) CTL_val_masque.sql version 3.3-1.10
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) CTL_val_masque.sql 1.0                    SNE       Creation
-- @(#)                    1.1                              Ajout du parametre p_date
-- @(#)                3.0-1.0	    14/11/2001    SGN       FCT01v1.2 Modif SGN V3 FCT01 Prise en compte des nouveaux masques
-- @(#)                                                     @CPT,@LIGBUD, @LOCAL
-- @(#)                3.0-1.1      11/02/2002    LGD       FCT 42 - Modification du curseur @LIGBUD
-- @(#)                3.0-1.2      11/06/2002    LGD       FCT48 - Prise en compte de nouveaux masques @CPTDE, @DEV
-- @(#)                3.0-1.3      11/06/2002    LGD       FCT47+ Correction Réponse Question F48 - Prise en compte de nouveaux masques @REMISE
-- @(#)                3.0-1.4      18/08/2002    LGD       ANO 157 - les modes de règlement ne sont pas dans SR_CODIF
-- @(#)                3.0-1.4      18/08/2002    LGD       ANO 173 - Certains masques ne sont pas définis dans CTL_VAL_MASQUE
-- @(#)                3.0-1.5      13/11/2002    LGD       ANO 71 - Contrôle sur le masque des comptes auxiliaires.
-- @(#)                3.1-1.6      07/05/2003    LGD       Aster V3.1 - Evolution 38.
-- @(#)                3.3-1.10     29/08/2003    SGN       ANOVSR454 : ajout de la prise en compte du masque @TRS.
-- @(#)                3.5A-1.1     11/08/2005    RDU       evo FA0043 : ajout prise en compte des masques @SPEC1,@SPEC2,@SPEC3 et @CPTAUX
-- @ #)		 	4.230		30/10/2007	  MCE		DGCP-ASTER-FSA_009 on doit comparer avec la valeur sr_codif.ide_codif = v_ide_masque
---------------------------------------------------------------------------------------
*/



   CURSOR c_existence(pc_valeur IN VARCHAR2) IS
	SELECT 'X'
	FROM RM_POSTE
	WHERE IDE_POSTE = pc_valeur;

   -- Modif SGN V3 FCT01
   CURSOR c_exist_cpt(p_val IN VARCHAR2) IS
	SELECT 'X'
	FROM FN_COMPTE
	WHERE IDE_CPT = p_val;

   -- Mofif LGD V3 Aster V3.1 - Evolution 38
   CURSOR c_exist_ordo(p_ordo IN VARCHAR2) IS
	SELECT 'X'
	FROM rb_ordo t1,rm_noeud t2
	WHERE t2.cod_typ_nd = t1.cod_typ_nd
	  AND t2.ide_nd = t1.ide_ordo
	  AND t1.ide_ordo = p_ordo;

   CURSOR c_exist_lig_prev(p_lig_prev IN VARCHAR2) IS
    SELECT 'X'
	FROM fn_ligne_bud_prev P
	WHERE P.ide_lig_prev = p_lig_prev;


    v_ext_oui SR_Codif.cod_codif%TYPE;

	/*
	--- Modif LGD V3 FCT 48
	CURSOR c_exist_devise(p_val IN VARCHAR2) IS
	SELECT 'X'
	FROM SR_CODIF
	WHERE COD_CODIF = p_val and
	      COD_TYP_CODIF='CODE_DEVISE';

	--- Modif LGD V3 FCT 47
    CURSOR c_exist_cpt_bq(p_val IN VARCHAR2) IS
	SELECT 'X'
	FROM FB_COORD_BANC
	WHERE CPT_BQ = p_val;

	--- Modif LGD V3 FCT 47
    CURSOR c_exist_nom_bq(p_val IN VARCHAR2) IS
	SELECT 'X'
	FROM FB_COORD_BANC
	WHERE NOM_BQ = p_val;

	*/

   -- Parcours des lignes budgetaires (prev + exec)
   /*CURSOR c_exist_ligbud(p_val IN VARCHAR2) IS
   SELECT 'X'
	FROM FN_LIGNE_BUD_EXEC
	WHERE ide_lig_exec = p_val
	UNION
	SELECT 'X'
	FROM FN_LIGNE_BUD_PREV
	WHERE ide_lig_prev = p_val;*/
   -- FIN modif SGN

   -- Modif LGD V3 FCT42
   -- Parcours des lignes budgetaires (prev + exec)

   CURSOR c_exist_ligbud(p_val IN VARCHAR2) IS
   SELECT 'X'
	FROM FN_LIGNE_BUD_EXEC
		 , fn_gestion
		 , pn_var_bud
	WHERE
	    FN_LIGNE_BUD_EXEC.VAR_CPTA = FN_GESTION.VAR_CPTA
	and FN_GESTION.IDE_GEST = GLOBAL.ide_gest
	and FN_LIGNE_BUD_EXEC.IDE_LIG_EXEC = p_val
	and PN_VAR_BUD.VAR_CPTA = FN_GESTION.VAR_CPTA
	and FN_LIGNE_BUD_EXEC.VAR_BUD = pn_var_bud.VAR_BUD
   UNION
   SELECT 'X'
	FROM FN_LIGNE_BUD_PREV
		 , fn_gestion
		 , pn_var_bud
	WHERE
		FN_GESTION.IDE_GEST = GLOBAL.ide_gest
	and PN_VAR_BUD.VAR_CPTA = FN_GESTION.VAR_CPTA
	and FN_LIGNE_BUD_PREV.IDE_LIG_PREV = p_val
	and FN_LIGNE_BUD_PREV.VAR_BUD = pn_var_bud.VAR_BUD;
    -- FIN modif LGD

	--- Modif LGD - ANO 156 - PB au niveau du mode de règlement
	CURSOR c_exist_mode_reglt(p_val IN VARCHAR2) IS
	SELECT 'X'
	FROM PC_MODE_REGLT
	WHERE
	    ide_mod_reglt=p_val;
	--- Fin de modification

  --- Modif SGN ANOVSR454 : 3.3-1.10 : prise en compte du masque @TRS
  CURSOR c_exist_trs(p_val IN VARCHAR2) IS
  SELECT 'X'
  FROM RB_TIERS
  WHERE ide_tiers = p_val;
  --- Fin de modification


   v_existence CHAR(01);
   -- Modif SGN V3 FCT01
   v_exist_cpt VARCHAR2(1);
   -- Modif LGD V3 FCT48
   v_exist_cpt_dev VARCHAR2(1);
   -- Modif LGD V3 FCT48
   v_exist_devise VARCHAR2(1);
   v_exist_ligbud VARCHAR2(1);
   v_exist_cpt_bq VARCHAR2(1);
   v_exist_nom_bq VARCHAR2(1);
   -- FIN Modif SGN

   v_ide_masque  SR_Codif.cod_codif%TYPE;
   v_ide_codif	 SR_Codif.cod_codif%TYPE;
   v_libl SR_Codif.libl%TYPE;
   v_resultat	NUMBER;
   v_retour	NUMBER;
   v_reserve_deb SR_PARAM.val_param%TYPE;
   v_reserve_fin SR_PARAM.val_param%TYPE;
   v_cdeb VARCHAR2(1) := SUBSTR(p_val_masque,1,1);  /*  Si p_val_masque null, retourne null */
   v_cfin VARCHAR2(1) := SUBSTR(p_val_masque,-1,1); /*  Pareil */


BEGIN

   /* Analyse de la saisie du masque de controle */

   IF p_val_masque IS NULL THEN
      v_ide_masque := '@VIDE';
   ELSE
      /* Recuperation des premiers et derniers caracteres */
      Ext_Param('IR0029',v_reserve_deb,v_retour);
      IF v_retour <> 1 THEN
         RETURN (-2);
      END IF;
      Ext_Param('IR0030',v_reserve_fin,v_retour);
      IF v_retour <> 1 THEN
         RETURN (-2);
      END IF;
      IF v_cdeb=v_reserve_deb THEN
      	 /*  Dans ce cas on fait le recherche en Majuscules */
         Ext_Codint_D('MASQUE',Upper(p_val_masque),p_date,v_libl,v_ide_codif,v_retour);
         IF v_retour =1 THEN
            v_ide_masque:=v_ide_codif;
            IF p_sais_masque IS NOT NULL AND v_ide_masque = '@VIDE' THEN
              RETURN(0);
            END IF;
         ELSE
            RETURN(0);
         END IF;
      ELSE  /* Ne commence pas par v_reserve_deb (i.e "@") */
         IF p_val_masque=v_reserve_fin THEN  /* p_valeur=* */
            v_ide_masque := '*';
         ELSE
            IF v_cfin=v_reserve_fin THEN
               v_ide_masque := 'Chai*';
            ELSE
               v_ide_masque := 'Chai';
            END IF;
         END IF;
      END IF;
   END IF;

   /* Test de la validité du de la saisie par rapport au masque */

   -- Si le masque est @VIDE, la saisie doit etre null
   IF v_ide_masque = '@VIDE' THEN
      IF p_sais_masque IS NULL THEN
	 v_retour := 1;
      ELSE
         v_retour := 0;
      END IF;

   -- Si le masque est non @VIDE, la saisie ne doit epas tre null
   ELSIF v_ide_masque != '@VIDE' AND p_sais_masque IS NULL THEN
      v_retour := 0;

   -- Si le masque est * toute saisie est valide
   ELSIF v_ide_masque = '*' THEN
      v_retour := 1;

   -- Gestion des masques @
   -- MODIF SGN V3 FCT01 ELSIF SUBSTR(v_ide_masque, 1, 1) = '@' THEN
   --  IF v_ide_masque = '@PC' THEN
   ELSIF v_ide_masque = '@PC' THEN
         OPEN c_existence(p_sais_masque);
         FETCH c_existence INTO v_existence;
         IF c_existence%FOUND THEN
            v_retour := 1;
         ELSE
            v_retour := 0;
         END IF;
         CLOSE c_existence;
   --  MODIF SGN V3 FCT01 END IF;

   /* MODIF LGD V3 ANO 157
	   -- MODIF SGN V3 FCT01    IF v_ide_masque = '@MREG' THEN
	   ELSIF v_ide_masque = '@MREG' THEN
	         Ext_Codint_d('MODE_REGLEMENT',p_sais_masque, p_date, v_libl, v_ide_codif, v_resultat);
	         v_retour := v_resultat;
	   --  MODIF SGN V3 FCT01   END IF;
   	   */
   ELSIF v_ide_masque = '@MREG' THEN
         OPEN c_exist_mode_reglt(p_sais_masque);
         FETCH c_exist_mode_reglt INTO v_existence;
         IF c_exist_mode_reglt%FOUND THEN
            v_retour := 1;
         ELSE
            v_retour := 0;
         END IF;
         CLOSE c_exist_mode_reglt;


   --  MODIF SGN V3 FCT01   IF v_ide_masque = '@DATE' THEN
   ELSIF v_ide_masque = '@DATE' THEN
         IF CTL_date_correcte(p_sais_masque)= 1 THEN
            v_retour := 1;
         ELSE
            v_retour := 0;
         END IF;
   --  MODIF SGN V3 FCT01   END IF;
   --  MODIF SGN V3 FCT01 Prise en compte des masques @CPT, @LIGBUD et @LOCAL
   ELSIF v_ide_masque = 'CPT' THEN
         OPEN c_exist_cpt(p_sais_masque);
         FETCH c_exist_cpt INTO v_exist_cpt;
         IF c_exist_cpt%FOUND THEN
            v_retour := 1;
         ELSE
            v_retour := 0;
         END IF;
         CLOSE c_exist_cpt;

   -- Parcours de fn_lig_bud_exec
   ELSIF v_ide_masque = 'LIGBU' THEN
         OPEN c_exist_ligbud(p_sais_masque);
         FETCH c_exist_ligbud INTO v_exist_ligbud;
         IF c_exist_ligbud%FOUND THEN
            v_retour := 1;
         ELSE
            v_retour := 0;
         END IF;
         CLOSE c_exist_ligbud;

   -- Si il s agit d une spec local, le controle est effectue dans
   -- la fonction de controle des spec local.
   ELSIF v_ide_masque = 'LOCAL' THEN
   		 v_retour := 1;

   -- Si il s'agit du masque @REMISE, aucun contrôle spécifique n'est effectué (Cf Spec U212_060F)
   ELSIF v_ide_masque='REMIS' THEN

	  /* LGD - 12/11/2002 - ANO VA V3 71 */
	  IF p_sais_masque IS NOT NULL THEN
	     v_retour := 1;
      ELSE
         v_retour := 0;
      END IF;
	  /* Fin de modification */

   ELSIF v_ide_masque='@ORDO' THEN
         --v_retour := 1;
		 --- LGD, 07/05/2003 - Aster V3.1 - Evolution 38
		 OPEN c_exist_ordo(p_sais_masque);
         FETCH c_exist_ordo INTO v_existence;
         IF c_exist_ordo%FOUND THEN
            v_retour := 1;
         ELSE
            v_retour := 0;
         END IF;
         CLOSE c_exist_ordo;

   ELSIF v_ide_masque='@TRS' THEN
         -- MODIF SGN ANOVSR454 : 3.3-1.10 : v_retour := 1;
	   OPEN c_exist_trs(p_sais_masque);
         FETCH c_exist_trs INTO v_existence;
         IF c_exist_trs%FOUND THEN
            v_retour := 1;
         ELSE
            v_retour := 0;
         END IF;
         CLOSE c_exist_trs;
         -- fin modif sgn

   ELSIF v_ide_masque='@LEXE' THEN
         v_retour := 1;

   ELSIF v_ide_masque='CPTDE' THEN
         v_retour := 1;

   ELSIF v_ide_masque='@CTRS' THEN
         v_retour := 1;

   ELSIF v_ide_masque='@CHB' THEN
         v_retour := 1;

   ELSIF v_ide_masque='@BUDG' THEN
         v_retour := 1;

   ELSIF v_ide_masque='ASOLD' THEN
         v_retour := 1;

   ELSIF v_ide_masque='NSOLD' THEN
         v_retour := 1;

   ELSIF v_ide_masque='DEV' THEN
         v_retour := 1;

   ELSIF v_ide_masque='MONT' THEN
         v_retour := 1;

   ELSIF v_ide_masque='LIBQ' THEN
         v_retour := 1;

   ELSIF v_ide_masque='CPTBQ' THEN
         v_retour := 1;

   ELSIF v_ide_masque='VARTI' THEN
         v_retour := 1;

   ELSIF v_ide_masque='ORIG' THEN
         v_retour := 1;

   ELSIF v_ide_masque='@OPE' THEN
         v_retour := 1;

   ELSIF v_ide_masque='@LPRV' THEN
         --v_retour := 1;
		 --- LGD, 07/05/2003 - Aster V3.1 - Evolution 38
		 OPEN c_exist_lig_prev(p_sais_masque);
         FETCH c_exist_lig_prev INTO v_existence;
         IF c_exist_lig_prev%FOUND THEN
            v_retour := 1;
         ELSE
            v_retour := 0;
         END IF;
         CLOSE c_exist_lig_prev;
		 --- Fin de modification


   ELSIF v_ide_masque='@PIEC' THEN
         v_retour := 1;

   ELSIF v_ide_masque='@DEMI' THEN
         v_retour := 1;

   ELSIF v_ide_masque='@DREC' THEN
         v_retour := 1;

   ELSIF v_ide_masque='@PORI' THEN
         v_retour := 1;

   ELSIF v_ide_masque='@ENG' THEN
         v_retour := 1;

   ELSIF v_ide_masque='@NTRS' THEN
         v_retour := 1;

   ELSIF v_ide_masque='@PTRS' THEN
         v_retour := 1;

   ELSIF v_ide_masque='@MREG' THEN
         v_retour := 1;

-- RDU-20050811-Debut FA0043 : Rajout de 4 valeurs de masque possibles

 -- DEBUT MCE le 30/10/2007 : on doit comparer avec la valeur sr_codif.ide_codif = v_ide_masque
 --  ELSIF v_ide_masque='@SPEC1' THEN
  ELSIF v_ide_masque='@SP1' THEN
         v_retour := 1;

   --ELSIF v_ide_masque='@SPEC2' THEN
   ELSIF v_ide_masque='@SP2' THEN
         v_retour := 1;

   --ELSIF v_ide_masque='@SPEC3' THEN
   ELSIF v_ide_masque='@SP3' THEN
         v_retour := 1;

   --ELSIF v_ide_masque='@CPTAUX' THEN
   ELSIF v_ide_masque='@CAUX' THEN
         v_retour := 1;

   -- FIN MCE le 30/10/2007 : on doit comparer avec la valeur sr_codif.ide_codif = v_ide_masque

-- RDU-20050811-Fin

   /*
   -- Modif LGD V3 FCT48
   ELSIF v_ide_masque = 'CPTDE.' THEN
		 -- Recuperation du code externe "Oui"
		 EXT_CODEXT('OUI_NON','O',v_libl,v_ext_oui,v_retour);
		 If v_retour !=1 then
		     -- Parcours de la table FN_COMPTE
			 OPEN c_exist_cpt_dev(p_sais_masque);
	         FETCH c_exist_cpt_dev INTO v_exist_cpt_dev;
	         IF c_exist_cpt_dev%FOUND THEN
	            v_retour := 1;
	         ELSE
	            v_retour := 0;

	         END IF;
	         CLOSE c_exist_cpt_dev;
		 ELSE
		   v_retour := -2;
		 END IF;

   ELSIF v_ide_masque = 'DEV' THEN
         OPEN c_exist_devise(p_sais_masque);
         FETCH c_exist_devise INTO v_exist_devise;
         IF c_exist_devise%FOUND THEN
            v_retour := 1;
         ELSE
            v_retour := 0;
         END IF;
         CLOSE c_exist_devise;

   ELSIF v_ide_masque = 'DTCAL' THEN
         IF CTL_date_correcte(p_sais_masque)= 1 THEN
            v_retour := 1;
         ELSE
            v_retour := 0;
         END IF;
   -- FIN MODIF LGD V3 FCT48
   ELSIF v_ide_masque = 'CPTBQ' THEN
         -- Parcours de la table FB_COORD_BANC
		 OPEN c_exist_cpt_bq(p_sais_masque);
         FETCH c_exist_cpt_bq INTO v_exist_cpt_bq;
         IF c_exist_cpt_bq%FOUND THEN
            v_retour := 1;
         ELSE
            v_retour := 0;

         END IF;
         CLOSE c_exist_cpt_bq;
   ELSIF v_ide_masque = 'LIBBQ' THEN
         -- Parcours de la table FB_COORD_BANC
		 OPEN c_exist_nom_bq(p_sais_masque);
         FETCH c_exist_nom_bq INTO v_exist_nom_bq;
         IF c_exist_nom_bq%FOUND THEN
            v_retour := 1;
         ELSE
            v_retour := 0;
         END IF;
         CLOSE c_exist_cpt_bq; */

   -- Si le masque fini par *
   ELSIF SUBSTR(v_ide_masque,LENGTH(v_ide_masque)) = '*' THEN
      IF SUBSTR(p_val_masque,1,LENGTH(p_val_masque)-1) = SUBSTR(p_sais_masque,1,LENGTH(p_val_masque)-1) THEN
         v_retour := 1;
      ELSE
         v_retour := 0;
      END IF;

   -- Si le masque ne fini pas par *
   ELSIF SUBSTR(v_ide_masque,LENGTH(v_ide_masque)) != '*' THEN
      IF p_val_masque = p_sais_masque THEN
         v_retour := 1;
      ELSE
         v_retour := 0;
      END IF;

   ELSE
       v_retour := -2;

   END IF;

   RETURN v_retour;

EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
END CTL_Val_Masque;

/

CREATE OR REPLACE FUNCTION CTL_verif_poste(p_site    IN  VARCHAR2 := '',
                           p_poste IN  VARCHAR2 := '') return NUMBER
IS

/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  :
-- Nom           : CTL_verif_poste
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 04/12/2001
-- ---------------------------------------------------------------------------
-- Role          :  Verifier qu au moins un poste existe dans la table des postes.
-- 				 	Si le site est renseigne => la recherche sera bornee a l existance d au
--                      moins un poste associe au site fourni en parametre
--                  Si le poste est renseigne => la recherche sera borne a l existance du
--                     poste fourni en parametre
-- Parametres    :
--                  1.- p_site : Le site pour lequel on veut restraindre les recherches
--                  2.- p_poste : Le poste pour lequel on veut restraindre les recherches
--
--
-- Valeurs retournees :
--                  1 - si le poste a ete trouve
--                  0 - sinon
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) CTL_verif_poste.sql version 3.0-1.0 : SGN : 18/12/2001
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) CTL_verif_poste.sql 3.0-1.0	| 18/12/2001 | SGN	| Création
-- @(#) CTL_verif_poste.sql 3.0-1.1	| 14/03/2002 | SGN	| Correction du au changement du nom de la procedure (check_poste -> CTL_verif_poste)
-- 	----------------------------------------------------------------------------------------------------------
*/

	v_retour 		NUMBER;
	v_curid		NUMBER;
	v_req_sql 		VARCHAR2(512);
	v_clause_select 	VARCHAR2(512);
	v_clause_from 	VARCHAR2(512);
	v_clause_where 	VARCHAR2(512);
	v_res1		NUMBER;
	v_nb_ligne 		NUMBER := 0;
	v_typ_nd_P RM_NOEUD.cod_typ_nd%TYPE;

	v_lib_ret SR_CODIF.libl%TYPE;
    v_cod_ret SR_CODIF.cod_codif%TYPE;
    v_ret     NUMBER;

BEGIN
	-- Recuperation du type de noeud poste
	EXT_CODEXT('TYPE_NOEUD','P',v_lib_ret,v_cod_ret,v_ret);
	IF v_ret != 1 THEN
	   RETURN 0;
	END IF;
	v_typ_nd_P := v_cod_ret;

	-- Construction de la requete
	v_clause_select := 'SELECT 1';
	v_clause_from := 'FROM rm_poste';
	v_clause_where := '';

	-- On traite si on doit rechercher un poste en particulier
	IF p_poste IS NOT NULL THEN
	   v_clause_where := v_clause_where || 'WHERE rm_poste.ide_poste = '''||p_poste||'''';
	END IF;

	-- On traite si on doit rechercher pour un site particulier
	IF p_site IS NOT NULL THEN
	   v_clause_from := v_clause_from ||', rm_noeud';

	   IF v_clause_where IS NOT NULL THEN
	   	  v_clause_where := v_clause_where||' AND';
	   ELSE
	      v_clause_where := v_clause_where||' WHERE';
	   END IF;

	   v_clause_where := v_clause_where ||' rm_poste.ide_poste = rm_noeud.ide_nd'||
  				 				    ' AND rm_poste.cod_typ_nd = rm_noeud.cod_typ_nd' ||
									' AND rm_noeud.cod_typ_nd = '''||v_typ_nd_P||''''||
									' AND rm_noeud.ide_site = '''||p_site||'''';
	END IF;


	-- Concatenation des elements de la requete
	v_req_sql := v_clause_select||' '||v_clause_from||' '||v_clause_where;

	-- Ouverture du curseur
	v_curid := DBMS_SQL.OPEN_CURSOR;

	-- Parcours
	DBMS_SQL.PARSE(v_curid, v_req_sql, DBMS_SQL.native);

	-- Definition des colones receptrices
	DBMS_SQL.DEFINE_COLUMN(v_curid, 1, v_res1,1024);

	-- Execution du curseur + fetch
	v_nb_ligne := DBMS_SQL.EXECUTE_AND_FETCH(v_curid);

	-- Lecture du curseur on ne recupere que le premier record si il existe.
	-- Et dans ce cas le retour  sera 1 si il n y a pas de record on retourne 0
	IF v_nb_ligne != 0 THEN
		v_retour := 1;
	ELSE
		v_retour := 0;
	END IF;

	DBMS_SQL.CLOSE_CURSOR(v_curid);

	RETURN v_retour;
EXCEPTION
	WHEN OTHERS THEN
		IF DBMS_SQL.IS_OPEN(v_curid) THEN
			DBMS_SQL.CLOSE_CURSOR(v_curid);
		END IF;
		RAISE;
END CTL_verif_poste;

/

CREATE OR REPLACE FUNCTION CTL_VERIF_SENS ( p_ide_poste IN FC_REF_PIECE.IDE_POSTE%TYPE,--- Ajout M'BOUKE
	   	  		  		   				  	p_ide_ref_piece IN FC_REF_PIECE.IDE_REF_PIECE%TYPE,
                                            p_mt_var           VARCHAR2,
                                            p_mt               NUMBER
                                           ) RETURN NUMBER IS
/*---------------------------------------------------------------------------------------
-- Nom           : CTL_VERIF_SENS.
-- --------------------------------------------------------------------------------------
--  Auteur         : PGE.
--  Date creation  : 27/03/2008.
-- --------------------------------------------------------------------------------------
-- Role   :  Cette fonction a pour but de controler le sens (Débit ou Crédit) d'une pièce.
--
-- Parametres    : 1 - p_ide_ref_piece : ide_ref_piece de la piece.
--                 2 - p_mt_var : Type de montant subissant une variation (mt_cr ou mt_db).
--                 3 - p_mt : Montant souhaité après variation.
--
-- Valeur retournée : 0 : Action autorisée.
--                    1 : Action refusée du à l'inversion du sens du solde.
--
--  -------------------------------------------------------------------------------------
--  Fonction         	   |Version |Date        |Initiales |Commentaires.
--  -------------------------------------------------------------------------------------
-- @(#) CTL_VERIF_SENS.sql |V4250   |27/03/2008  | PGE      | Création pour l'EVOL_2007_010.
---------------------------------------------------------------------------------------*/

 v_retour       NUMBER :=0 ;
 v_sens         FC_LIGNE.COD_SENS%TYPE;
 v_mt_cr        FC_ref_PIECE.MT_CR%TYPE;
 v_mt_db        FC_ref_PIECE.MT_db%TYPE;
 v_mt_dev       FC_ref_PIECE.MT_dev%TYPE;

 v_codif_libl   VARCHAR2(200);
 v_codif_credit VARCHAR2(1);
 v_codif_debit  VARCHAR2(1);
 v_temp         NUMBER :=0;


BEGIN

  EXT_CODEXT ( 'SENS', 'C', v_codif_libl, v_codif_credit, v_temp );
  EXT_CODEXT ( 'SENS', 'D', v_codif_libl, v_codif_debit, v_temp );

  --extraction du sens de la ligne corespondant à la piece.
  SELECT fcl.COD_SENS, fcr.MT_CR, fcr.MT_DB, fcr.MT_DEV
  INTO v_sens, v_mt_cr, v_mt_db, v_mt_dev
  FROM fc_ligne fcl, FC_REF_PIECE fcr
  WHERE fcl.ide_ref_piece = fcr.IDE_REF_PIECE
  AND fcr.IDE_LIG =fcl.IDE_LIG
  AND fcr.IDE_ECR = fcl.IDE_ECR
  AND fcr.FLG_CPTAB = fcl.FLG_CPTAB
  AND fcr.IDE_JAL = fcl.IDE_JAL
  AND fcr.IDE_GEST = fcl.IDE_GEST
  AND fcr.IDE_POSTE = fcl.IDE_POSTE
  AND fcr.IDE_REF_PIECE = p_ide_ref_piece
  AND fcr.IDE_POSTE = p_ide_poste;  ----Ajout M'Bouké
---------------------------------------------------------------
--             Si le montant est positif                     --
---------------------------------------------------------------
  IF v_mt_dev >= 0 THEN
    ---------------------------------------------------------------
    -- Si la ligne est en crédit : mt_cr doit être >= à mt_db.
    ---------------------------------------------------------------
    IF v_sens = v_codif_credit THEN
      --Si la maj des montants affecte mt_cr.
      IF p_mt_var = 'mt_cr' THEN
        IF v_mt_cr + p_mt >= v_mt_db THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
    --Si la maj des montants affecte mt_db.
      ELSIF p_mt_var = 'mt_db' THEN
        IF v_mt_cr >= v_mt_db + p_mt THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
      END IF;
    ---------------------------------------------------------------
    -- Si la ligne est en débit : mt_cr doit être <= à mt_db.
    ---------------------------------------------------------------
    ELSIF v_sens = v_codif_debit THEN
      --Si la maj des montants affecte mt_cr.
      IF p_mt_var = 'mt_cr' THEN
        IF v_mt_cr + p_mt <= v_mt_db THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
      --Si la maj des montants affecte mt_db.
      ELSIF p_mt_var = 'mt_db' THEN
        IF v_mt_cr <= v_mt_db + p_mt THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
      END IF;
    END IF;
---------------------------------------------------------------
--             Si le montant est négatif                     --
---------------------------------------------------------------
  ELSIF v_mt_dev < 0 THEN
    ---------------------------------------------------------------
    -- Si la ligne est en crédit : mt_cr doit être <= à mt_db.
    ---------------------------------------------------------------
    IF v_sens = v_codif_credit THEN
      --Si la maj des montants affecte mt_cr.
      IF p_mt_var = 'mt_cr' THEN
        IF v_mt_cr + p_mt <= v_mt_db THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
    --Si la maj des montants affecte mt_db.
      ELSIF p_mt_var = 'mt_db' THEN
        IF v_mt_cr <= v_mt_db + p_mt THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
      END IF;
    ---------------------------------------------------------------
    -- Si la ligne est en débit : mt_cr doit être >= à mt_db.
    ---------------------------------------------------------------
    ELSIF v_sens = v_codif_debit THEN
      --Si la maj des montants affecte mt_cr.
      IF p_mt_var = 'mt_cr' THEN
        IF v_mt_cr + p_mt >= v_mt_db THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
      --Si la maj des montants affecte mt_db.
      ELSIF p_mt_var = 'mt_db' THEN
        IF v_mt_cr >= v_mt_db + p_mt THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
      END IF;
    END IF;
  END IF;
  --Retour de fonction
  RETURN v_retour;

END;

/

CREATE OR REPLACE FUNCTION CTL_VERIF_SENS_OLD ( p_ide_ref_piece IN FC_REF_PIECE.IDE_REF_PIECE%TYPE,
                                            p_mt_var           VARCHAR2,
                                            p_mt               NUMBER
                                           ) RETURN NUMBER IS
/*---------------------------------------------------------------------------------------
-- Nom           : CTL_VERIF_SENS.
-- --------------------------------------------------------------------------------------
--  Auteur         : PGE.
--  Date creation  : 27/03/2008.
-- --------------------------------------------------------------------------------------
-- Role   :  Cette fonction a pour but de controler le sens (Débit ou Crédit) d'une pièce.
--
-- Parametres    : 1 - p_ide_ref_piece : ide_ref_piece de la piece.
--                 2 - p_mt_var : Type de montant subissant une variation (mt_cr ou mt_db).
--                 3 - p_mt : Montant souhaité après variation.
--
-- Valeur retournée : 0 : Action autorisée.
--                    1 : Action refusée du à l'inversion du sens du solde.
--
--  -------------------------------------------------------------------------------------
--  Fonction         	   |Version |Date        |Initiales |Commentaires.
--  -------------------------------------------------------------------------------------
-- @(#) CTL_VERIF_SENS.sql |V4250   |27/03/2008  | PGE      | Création pour l'EVOL_2007_010.
---------------------------------------------------------------------------------------*/

 v_retour       NUMBER :=0 ;
 v_sens         FC_LIGNE.COD_SENS%TYPE;
 v_mt_cr        FC_ref_PIECE.MT_CR%TYPE;
 v_mt_db        FC_ref_PIECE.MT_db%TYPE;
 v_mt_dev       FC_ref_PIECE.MT_dev%TYPE;

 v_codif_libl   VARCHAR2(200);
 v_codif_credit VARCHAR2(1);
 v_codif_debit  VARCHAR2(1);
 v_temp         NUMBER :=0;


BEGIN

  EXT_CODEXT ( 'SENS', 'C', v_codif_libl, v_codif_credit, v_temp );
  EXT_CODEXT ( 'SENS', 'D', v_codif_libl, v_codif_debit, v_temp );

  --extraction du sens de la ligne corespondant à la piece.
  SELECT fcl.COD_SENS, fcr.MT_CR, fcr.MT_DB, fcr.MT_DEV
  INTO v_sens, v_mt_cr, v_mt_db, v_mt_dev
  FROM fc_ligne fcl, FC_REF_PIECE fcr
  WHERE fcl.ide_ref_piece = fcr.IDE_REF_PIECE
  AND fcr.IDE_LIG =fcl.IDE_LIG
  AND fcr.IDE_ECR = fcl.IDE_ECR
  AND fcr.FLG_CPTAB = fcl.FLG_CPTAB
  AND fcr.IDE_JAL = fcl.IDE_JAL
  AND fcr.IDE_GEST = fcl.IDE_GEST
  AND fcr.IDE_POSTE = fcl.IDE_POSTE
  AND fcr.IDE_REF_PIECE = p_ide_ref_piece;
---------------------------------------------------------------
--             Si le montant est positif                     --
---------------------------------------------------------------
  IF v_mt_dev >= 0 THEN
    ---------------------------------------------------------------
    -- Si la ligne est en crédit : mt_cr doit être >= à mt_db.
    ---------------------------------------------------------------
    IF v_sens = v_codif_credit THEN
      --Si la maj des montants affecte mt_cr.
      IF p_mt_var = 'mt_cr' THEN
        IF v_mt_cr + p_mt >= v_mt_db THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
    --Si la maj des montants affecte mt_db.
      ELSIF p_mt_var = 'mt_db' THEN
        IF v_mt_cr >= v_mt_db + p_mt THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
      END IF;
    ---------------------------------------------------------------
    -- Si la ligne est en débit : mt_cr doit être <= à mt_db.
    ---------------------------------------------------------------
    ELSIF v_sens = v_codif_debit THEN
      --Si la maj des montants affecte mt_cr.
      IF p_mt_var = 'mt_cr' THEN
        IF v_mt_cr + p_mt <= v_mt_db THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
      --Si la maj des montants affecte mt_db.
      ELSIF p_mt_var = 'mt_db' THEN
        IF v_mt_cr <= v_mt_db + p_mt THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
      END IF;
    END IF;
---------------------------------------------------------------
--             Si le montant est négatif                     --
---------------------------------------------------------------
  ELSIF v_mt_dev < 0 THEN
    ---------------------------------------------------------------
    -- Si la ligne est en crédit : mt_cr doit être <= à mt_db.
    ---------------------------------------------------------------
    IF v_sens = v_codif_credit THEN
      --Si la maj des montants affecte mt_cr.
      IF p_mt_var = 'mt_cr' THEN
        IF v_mt_cr + p_mt <= v_mt_db THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
    --Si la maj des montants affecte mt_db.
      ELSIF p_mt_var = 'mt_db' THEN
        IF v_mt_cr <= v_mt_db + p_mt THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
      END IF;
    ---------------------------------------------------------------
    -- Si la ligne est en débit : mt_cr doit être >= à mt_db.
    ---------------------------------------------------------------
    ELSIF v_sens = v_codif_debit THEN
      --Si la maj des montants affecte mt_cr.
      IF p_mt_var = 'mt_cr' THEN
        IF v_mt_cr + p_mt >= v_mt_db THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
      --Si la maj des montants affecte mt_db.
      ELSIF p_mt_var = 'mt_db' THEN
        IF v_mt_cr >= v_mt_db + p_mt THEN
          v_retour := 0;
        ELSE
          v_retour := 1;
        END IF;
      END IF;
    END IF;
  END IF;
  --Retour de fonction
  RETURN v_retour;

END;

/

CREATE OR REPLACE FUNCTION EXT_CODEXTLOV(p_typ_codif      IN   SR_Codif.cod_typ_codif%TYPE,
                                         p_ide_codif      IN   SR_Codif.ide_codif%TYPE,
                                         p_indicateur     IN   NUMBER := 1) RETURN VARCHAR2 IS

/*****************************************************/
/* Retour   : si p_indicateur = 1 -> le code externe */
/*            si p_indicateur = 2 -> le libelle      */
/*                                                   */
/* Remarque : p_indicateur = 1 par défaut            */
/*****************************************************/

  v_codext   SR_Codif.cod_codif%TYPE;
  v_libl     SR_Codif.libl%TYPE;

BEGIN
  SELECT cod_codif,libl INTO v_codext,v_libl
  FROM SR_CODIF
  WHERE cod_typ_codif = p_typ_codif
    AND ide_codif = p_ide_codif;

  IF p_indicateur = 1 THEN
    Return(v_codext);
  ELSE
    Return(v_libl);
  END IF;


EXCEPTION
  WHEN OTHERS THEN
    Return('');
END EXT_CODEXTLOV;

/

CREATE OR REPLACE FUNCTION EXT_COMPOSANT_NOM(p_nom IN VARCHAR2
	   	  		  		   				, p_numero_composant IN NUMBER := 1
										, p_separateur IN VARCHAR2 := '_'
										, p_extension IN VARCHAR2 := '.DAT'
										) RETURN VARCHAR2 IS
/*
---------------------------------------------------------------------------------------
-- Nom           :  EXT_COMPOSANT_NOM
-- Date creation : 24/01/2000
-- Creee par     : SOFIANE NEKERE (SEMA GROUP)
-- Role          : Extraction d'une des composantes d'une nomenclature
--
-- Parametres    :  p_nom 	  		   : Chaine de caractère composée de plusieurs parties
--                  p_numero_composant : rang da la partie a extraire
--                  p_separateur	   : Caractère de separateur des differentes parties
--                  p_extension		   : Caractere de fin de chaine a ne pas traiter
--									   	 comme partie de la chaine
--
-- Valeur retournee : - retourne la chaine correspondant a la partie demandee
--
-- Appels		 :
-- Version 		 : @(#) 1.0
-- Historique 	 : v1.0, 24/01/2000, Creation
-- 				 : @(#) MODIF SGN ANO011 gestion d'un separateur plus complexe dont la taille est
--                 @(#)    superieur a 1
---------------------------------------------------------------------------------------
*/
v_debut NUMBER:=0;
v_fin NUMBER := -1;
v_occurrence NUMBER :=1;
v_len_sep NUMBER; -- MODIF SGN ANO011

/*
---------------------------------------------------------------------------------------
-- Nom           :  CAL_POSITION_SEPARATEUR
-- Date creation : 24/01/2000
-- Creee par     : SOFIANE NEKERE (SEMA GROUP)
-- Role          : Calcule la position (debut) de la chaine recherchee
--
-- Parametres    :  p_nom 	  		   : Chaine de caractère composée de plusieurs parties
-- 				    p_debut			   : Position a partir de laquelle la recherche se fait
--					p_separateur	   : caratere de separation
-- Valeur retournee : - retourne la position du prochain separateur a partir de
-- 		  			  	la position debut
---------------------------------------------------------------------------------------
*/
FUNCTION CAL_POSITION_SEPARATEUR(p_nom IN VARCHAR2, p_debut IN NUMBER := 1, p_separateur IN VARCHAR2 := '_') RETURN NUMBER IS
	v_prochain	NUMBER;
	v_trouve BOOLEAN := FALSE;
	v_len_sep NUMBER; -- MODIF SGN ANO011
BEGIN
  v_len_sep := LENGTH(p_separateur); -- MODIF SGN ANO011

  v_prochain := INSTR(p_nom, p_separateur, p_debut, 1);

  v_trouve := FALSE;
  WHILE NOT v_trouve AND v_prochain != 0 LOOP
  	IF v_prochain != 0 THEN
  		v_trouve := TRUE;
  	END IF;
  	IF v_prochain > 1 THEN
  		-- MODIF SGN ANO011 IF SUBSTR(p_nom, v_prochain-1, 1) = p_separateur THEN
		IF SUBSTR(p_nom, v_prochain - v_len_sep, v_len_sep) = p_separateur THEN
  			v_trouve := FALSE;
  		END IF;
  	END IF;

  	IF v_prochain < LENGTH(p_nom)  THEN
  		-- MODIF SGN ANO011 IF SUBSTR(p_nom, v_prochain+1, 1) = p_separateur THEN
  		IF SUBSTR(p_nom, v_prochain + v_len_sep, v_len_sep) = p_separateur THEN
  			v_prochain := v_prochain + 1;
  			v_trouve := FALSE;
  		END IF;
  	END IF;
  	IF NOT v_trouve THEN
  		-- MODIF SGN ANO011 v_prochain := INSTR(p_nom, p_separateur, v_prochain+1, 1);
		v_prochain := INSTR(p_nom, p_separateur, v_prochain + v_len_sep, 1);
  	END IF;

  END LOOP;
  RETURN v_prochain;
END;

/*
	Programme principal
*/
BEGIN
  v_debut := 0;
  v_len_sep := LENGTH(p_separateur); -- MODIF SGN ANO011

  IF p_numero_composant > 1 THEN
	  FOR v_occurrence IN 1..(p_numero_composant-1) LOOP
	  	-- MODIF SGN ANO011 v_debut := CAL_POSITION_SEPARATEUR(p_nom, v_debut+1, p_separateur);
		v_debut := CAL_POSITION_SEPARATEUR(p_nom, v_debut+v_len_sep, p_separateur);
	  END LOOP;
	  v_debut := v_debut + v_len_sep - 1;
  ELSIF p_numero_composant = -1 THEN
		v_debut := INSTR(p_nom, p_separateur, p_numero_composant);
		-- MODIF SGN ANO011 v_fin := LENGTH(p_nom)+1;
		v_fin := LENGTH(p_nom)+v_len_sep;
  END IF;
  IF v_fin < 0 THEN
  	-- MODIF SGN ANO011 v_fin := CAL_POSITION_SEPARATEUR(p_nom, v_debut+1, p_separateur);
	v_fin := CAL_POSITION_SEPARATEUR(p_nom, v_debut+v_len_sep, p_separateur);
  END IF;
  IF v_fin = 0 THEN
  	v_fin := LENGTH(p_nom)-LENGTH(p_extension)+1;
  END IF;
  /* MODIF SGN ANO011 IF v_debut >= 0 AND v_fin > (v_debut +1 )THEN
  	RETURN (SUBSTR(p_nom, v_debut+1, v_fin - v_debut-1));
  END IF; */
  IF v_debut >= 0 AND v_fin > (v_debut +v_len_sep )THEN
  	RETURN (SUBSTR(p_nom, v_debut + 1, v_fin - v_debut - 1));
  END IF;
  -- FIN MODIF SGN
  RETURN NULL;
EXCEPTION
  	WHEN OTHERS THEN
  		RETURN NULL;
END EXT_COMPOSANT_NOM;

/

CREATE OR REPLACE FUNCTION EXT_Date_JC_Min( p_ide_poste IN rm_poste.ide_poste%TYPE,
                           p_ide_gest IN fn_gestion.ide_gest%TYPE,
                           p_dateJC_in IN fc_calend_hist.dat_jc%TYPE,
						   p_cloturee IN fc_calend_hist.cod_ferm%TYPE:=NULL ) RETURN DATE IS
/* Recherche dans fc_calend_hist,la plus petite des date JC >= date passée en paramètre */
/* Retourne null si cette date n'existe pas 			 	   			   	  			*/
  p_dateJC_out fc_calend_hist.dat_jc%TYPE;
BEGIN


  If p_cloturee IS NULL THEN

	  SELECT MIN(TRUNC(dat_jc))
	  INTO p_dateJC_out
	  FROM FC_CALEND_HIST
	  WHERE ide_poste = p_ide_poste
	  AND   ide_gest = p_ide_gest
	  AND   TRUNC(dat_jc) >= TRUNC(p_dateJC_in);

  Else

      SELECT MIN(TRUNC(dat_jc))
	  INTO p_dateJC_out
	  FROM FC_CALEND_HIST
	  WHERE ide_poste = p_ide_poste
	  AND   ide_gest = p_ide_gest
	  AND   TRUNC(dat_jc) >= TRUNC(p_dateJC_in)
	  AND   cod_ferm = p_cloturee;

  End if;



  RETURN (p_dateJC_out);

EXCEPTION
  WHEN OTHERS THEN
    RETURN (Null);
END EXT_Date_JC_Min;

/

CREATE OR REPLACE FUNCTION EXT_GestionSuiv(p_ide_gest IN fn_gestion.ide_gest%TYPE, p_gestion_ret OUT fn_gestion%ROWTYPE) RETURN NUMBER IS
/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_GestionSuiv
-- 	------------------------------------------------------------------------------
-- Date creation : 26/07/2001
-- Auteur     : SGN
-- Role          : Recupere pour une date donnee la gestion suivante
--
-- 	------------------------------------------------------------------------------
-- Parametres    : p_ide_gest - gestion dont on cherche la gestion suivante
--                 P_gestion_ret - la gestion si elle existe ou null sinon
--
-- Valeur retournee : 0 - Pas de gestion trouvee
--		      		1 - la fonction s est achevee correctement
--                  autres - Probleme techniques (remontés au programme appelant)
-- Appels		 :
--
-- 	--------------------------------------------------------------------
-- Version 		 : 2.1-1.0
-- 	--------------------------------------------------------------------
--
-- 	------------------------------------------------------------------------------
-- 	Fonction					    	|Date	    |Initiales	|Commentaires
-- 	------------------------------------------------------------------------------
-- @(#)CTL_BalEntreeGeneree.sql 2.1-1.0	|27/07/2001 | SGN	| Creation
-- @(#)CTL_BalEntreeGeneree.sql 4230	|05/10/2007 | FBT	| Evol DI44-2007-6 ajout de la colonne dat_budget
---------------------------------------------------------------------------------------
*/
CURSOR c_fn_gestion(v_date IN DATE) IS
    SELECT *
    FROM fn_gestion
    WHERE TRUNC(dat_dval) > TRUNC(v_date)
    ORDER BY dat_dval;

v_dat_fin fn_gestion.dat_fval%TYPE;
v_ide_gest fn_gestion.ide_gest%TYPE;
v_gestion fn_gestion%ROWTYPE;

BEGIN
  /* Recuperation de la date de fin de gestion de la gestion en cours */
  BEGIN
  	   SELECT dat_fval
	   INTO v_dat_fin
	   FROM fn_gestion
	   WHERE ide_gest = p_ide_gest;
  EXCEPTION
  	   WHEN OTHERS THEN
	     RAISE;
  END;

  /* On recupere toutes les gestions dont la date de debut est strictement superieur
     a la date voulue, et on retourne la premiere
  */

  OPEN c_fn_gestion(v_dat_fin);

  FETCH c_fn_gestion
  INTO v_gestion.ide_gest,
  	   v_gestion.var_cpta,
	   v_gestion.dat_ouv,
	   v_gestion.dat_clot,
	   v_gestion.dat_dval,
   	   v_gestion.dat_fval,
	   v_gestion.libn,
   	   v_gestion.dat_cre,
	   v_gestion.uti_cre,
   	   v_gestion.dat_maj,
   	   v_gestion.uti_maj,
   	   v_gestion.terminal,
	   v_gestion.dat_budget; -- FBT - Evol DI44-2007-6 ajout de la colonne dat_budget

  IF c_fn_gestion%NOTFOUND THEN
    p_gestion_ret := NULL;
    return(0);
  ELSE
    p_gestion_ret := v_gestion;
    return(1);
  END IF;

  CLOSE c_fn_gestion;

EXCEPTION
  WHEN OTHERS THEN
    p_gestion_ret := NULL;
    RAISE;
END EXT_GestionSuiv;

/

CREATE OR REPLACE FUNCTION EXT_Libnposte(p_typ_nd IN rm_noeud.cod_typ_nd%TYPE,
                       p_ide_nd IN rm_noeud.ide_nd%TYPE) RETURN VARCHAR2 IS

v_libn RM_NOEUD.libn%TYPE;

BEGIN

  SELECT libn INTO v_libn
  FROM RM_Noeud
  WHERE cod_typ_nd = p_typ_nd
    AND ide_nd = p_ide_nd;

  RETURN(v_libn);

EXCEPTION
  WHEN No_Data_Found THEN
    RETURN(NULL);

  WHEN Others THEN
    RETURN(NULL);
END EXT_Libnposte;

/

CREATE OR REPLACE FUNCTION EXT_Montant_Annul  (p_ide_piece IN FC_REF_PIECE.IDE_PIECE%TYPE,
                                               p_ordo      IN FC_REF_PIECE.IDE_ORDO%TYPE ,
					       p_gestion   IN FC_LIGNE.IDE_GEST%TYPE     ,
					       p_poste     IN FC_LIGNE.IDE_POSTE%TYPE    ,
					       p_cod_bud   IN FB_ENCAISSEMENT.COD_BUD%TYPE DEFAULT NULL ,
					       p_var_bud   IN FB_ENCAISSEMENT.VAR_BUD%TYPE DEFAULT NULL ,
					       p_ide_ligne_exe IN FB_ENCAISSEMENT.IDE_LIG_EXEC%TYPE DEFAULT NULL ,
					       p_retour    OUT NUMBER
                                               ) RETURN Number IS

/*
-------------------------------------
-- Systeme       : ASTER
-- Sous-systeme  : CAR
-- Nom           : EXT_Montant_Annul
-- ----------------------------------
-- Auteur         : FDU
-- Date creation  : 22/02/2006
--------------------------------------------------------------------------------------------------------
-- Role : Récupération du montant total des annulations d'un ordre de recette
-- Type : Fonction
-- Paramètres entrée : 1 - p_ide_piece (Référence de l'ordre de recette)
--                     2 - p_ordo (Code de l'ordonnateur)
--                     3 - p_gestion (Année de gestion)
--                     4 - p_poste (Code du poste comptable)
--                     5 - p_cod_bud (Code budget)
--                     6 - p_var_bud ( Variation budgétaire)
--                     7 - p_ide_ligne_exe (Identifiant de la ligne d'exécution)
-- Paramètres en sortie : 1 - v_mt_annul (Valeur du montant total des annulations d'un ordre de recette)
--                        2 - p_retour (Code retour de la fontion)
-- -----------------------------------------------------------------------------------------------------
-- Version        : @(#) EXT_Montant_Annul Version 3.5B
-- -----------------------------------------------------
-- Objet de la modification : Evo V35-DI44-028
-- --------------------------------------------------------------------------------------------------------------------
-- Révision                   |Date     |Initiales |Commentaires
-- ------------------------------------------------------------------------------------------------------------------
-- @(#)CAL_FORMS_NUM_REC 3.5B |22/02/06 |FDU       | Création - Evo V35-DI44-028
--                                                 | Prise en compte du montant des annulations des ordres de recette
--                                                 | au sein de l'état U41B_105E
-- ------------------------------------------------------------------------------------------------------------------
*/

----------------------------
-- Déclaration des variables
----------------------------

 v_mt_annul       FB_LIGNE_PIECE.MT_BUD%Type := 0;
 v_libl           SR_CODIF.LIBL%Type;
 v_retour         Number;
 v_type_piece     FB_PIECE.COD_TYP_PIECE%Type;
 v_statut_piece   FB_PIECE.COD_STATUT%Type;

-----------------------------
-- Déclaration de l'exception
-----------------------------

 Ext_Cod_Ext      EXCEPTION;

-----------------------
-- Corps de la fonction
-----------------------

BEGIN

 -- Récupération de la valeur du code externe pour le statut d'une pièce au statut visé

 EXT_Codext('STATUT_PIECE','V',v_libl,v_statut_piece,v_retour);
 IF  v_retour != 1 THEN
     Raise Ext_Cod_Ext;
 END IF;

 -- Récupération de la valeur du code externe pour le type annulation d'odre de recette

 EXT_Codext('TYPE_PIECE','AR',v_libl,v_type_piece,v_retour);
 IF  v_retour != 1 THEN
     Raise Ext_Cod_Ext;
 END IF;

 -- Bloc de trace du traitement

 IF GLOBAL.FICHIER_TRACE IS NULL THEN
     GLOBAL.INI_FICHIER_TRACE(CAL_NOM_FICHIER_TRACE('EXT_Montant_Annul'));
     GLOBAL.INI_NIVEAU_TRACE(0);
 END IF;

 -- Récupération du montant total des annulations d'un ordre de recette

 BEGIN
     SELECT  NVL(SUM(ligpc.MT_BUD),0)
     INTO    v_mt_annul
     FROM    FB_PIECE pc,
             FB_LIGNE_PIECE ligpc
     WHERE   pc.IDE_POSTE = ligpc.IDE_POSTE
     AND     pc.IDE_GEST = ligpc.IDE_GEST
     AND     pc.IDE_ORDO = ligpc.IDE_ORDO
     AND     pc.COD_BUD = ligpc.COD_BUD
     AND     pc.IDE_PIECE = ligpc.IDE_PIECE
     AND     pc.COD_TYP_PIECE = ligpc.COD_TYP_PIECE
     AND     pc.IDE_POSTE = p_poste
     AND     pc.IDE_GEST = p_gestion
     AND     pc.IDE_ORDO = p_ordo
     AND     pc.COD_BUD = p_cod_bud
     AND     (ligpc.VAR_BUD = p_var_bud
          OR  p_var_bud IS NULL)
     AND     ligpc.IDE_LIG_EXEC = p_ide_ligne_exe
     AND     pc.IDE_PIECE_INIT = p_ide_piece
     AND     pc.COD_TYP_PIECE = v_type_piece
     AND     pc.COD_STATUT = v_statut_piece ;

 EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
 END;
---------------------------------
-- Affectation des valeurs retour
---------------------------------

RETURN v_mt_annul;
p_retour :=1;

----------------------------------
-- Bloc d'exception de la fonction
----------------------------------

EXCEPTION
WHEN Ext_Cod_Ext Then
    P_Retour := -1;
WHEN Others THEN
    P_Retour := 0;
END EXT_Montant_Annul;

/

CREATE OR REPLACE FUNCTION EXT_Montant_Encaiss(P_ide_piece IN FC_REF_PIECE.IDE_PIECE%TYPE,
                                               P_Ordo      IN FC_REF_PIECE.IDE_ORDO%TYPE ,
							     			   P_Gestion   IN FC_LIGNE.IDE_GEST%TYPE     ,
							     			   P_Poste     IN FC_LIGNE.IDE_POSTE%TYPE    ,
							     			   P_cod_Bud   IN FB_ENCAISSEMENT.COD_BUD%TYPE DEFAULT NULL ,
							     			   P_Var_Bud   IN FB_ENCAISSEMENT.VAR_BUD%TYPE DEFAULT NULL ,
							     			   P_Ide_Ligne_Exe IN FB_ENCAISSEMENT.IDE_LIG_EXEC%TYPE DEFAULT NULL ,
							     			   P_retour    OUT NUMBER,
                                               P_var_tiers IN FC_LIGNE.var_tiers%TYPE := NULL,
                                               P_ide_tiers IN FC_LIGNE.var_tiers%TYPE := NULL
                                               ) RETURN NUMBER IS
/*
---------------------------------------------------------------------------------------
-- Systeme       : ASTER
-- Sous-systeme  : CAR
-- Nom           : EXT_Montant_Encaiss
-- ---------------------------------------------------------------------------------------------
-- Date creation : 25/02/2002
-- Auteur     : MYI
-- Role          : Calcule du montant encaissé pour une pièce ( ordonnance , ordre de recette )
-- ---------------------------------------------------------------------------------------------
-- Parametres    : 1 - P_ide_piece  - ide pièce
--                 2 - P_Ordo    - ide de l'ordonnateur
--                 3 - P_Gestion - gestion courante
--                 4 - P_Poste - Poste comptable
--                 5 - p_ide_gest - gestion courante
--                 6 - P_cod_Bud   - code budget
--                 7 - P_Var_Bud   - Variation budgétaire
--                 8 - P_Ide_Ligne_Exe  - Ligne d'exécution
--                 10 - P_var_tiers  - variation tiers (optionnel)
--                 11 - P_ide_tiers  - identifiant du tiers (optionnel)
--
-- Valeur retournee : montant encaissé
--                    P_retour : 1 si trouve et valide
--                              -1 incohérence code externe
--                              0  si autre erreur (exception levée)
--
-- Appels		 :
--
-- -------------------------------------------------------------------------
-- Version 		 : 3.5B-1.2
-- -------------------------------------------------------------------------
--
-- ------------------------------------------------------------------------------------------
-- Fonction					    	|Date	    |Initiales	|Commentaires
-- ------------------------------------------------------------------------------------------
-- @(#)EXT_Montant_Encaiss 2.2-1.0	|25/02/2002 | MYI	| Creation
-- @(#)EXT_Montant_Encaiss 2.2-1.1	|13/03/2002 | MYI	| Retour ano 16 et 104
-- @(#)EXT_Montant_Encaiss 2.2-2.0	|14/03/2002 | MYI	| Ajout de fonction pour trace et débogage
-- @(#)EXT_Montant_Encaiss 			|14/03/2002 | MYI	| Ajout test sur flag_cptab
-- @(#)EXT_Montant_Encaiss 3.3a-1.2	|23/10/2003 | SGN	| ANOVSR419 : ajout des info tiers si le tiers est fourni on retourne le mt encaissé pour le tiers
-- @(#)EXT_Montant_Encaiss 3.5B-1.2	|13/02/2006 | CBI	| V35-DI44-028 : Calcul des montants des annulations sur l'OR passé en paramètre
-- @(#)EXT_Montant_Encaiss 3.5B-1.3	|22/02/2006 | FDU	| V35-DI44-028 : Calcul exclusif du montant des encaissements sur l'OR passé en paramètre (en cas d'appel par le Report U41B_105E)
-- @(#)EXT_Montant_Encaiss 3.5C-6.0	|12/09/2006 | ISA	| V35-DI44-158 : Absence ide_jal dans la sélection des écritures+calcul montant erroné
-- @(#)EXT_Montant_Encaiss 4135		|17/02/2007 | FBT	| V4124 : Correction d'un bug sur la prise en comptes des annulations de recette
-- @(#)EXT_Montant_Encaiss 4220		|21/09/2007 | FBT	| V4220 : Correction d'un bug sur le calcul du a une jointure inccorect
-- @(#)EXT_Montant_Encaiss 4260		|23/07/2008 | PGE	| V4260 : Correction d'un bug d'affichage U41A_105E. Une jointure a été rajouté sur l'ide_piece le 25/01/2006.
--                                                                    Mais le Gabon possède des IDE_PIECE =null, ce qui cassait la jointure
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
 -- Recherche des écritures comptable pour une pièce
 CURSOR  C_Ligne_Ecriture ( P_Flg_Cptab IN FC_LIGNE.FLG_CPTAB%TYPE)
       --IS SELECT DISTINCT L.ide_ecr  -- isa modif du 12/09/2006
	   IS SELECT DISTINCT l.ide_jal,L.ide_ecr  --isa  modif du 12/09/2006 rajout de ide_jal car sinon on sélectionne des lignes ne concernant pas la pièce
       FROM  FC_LIGNE L
       WHERE
       L.Ide_poste = P_Poste AND
       L.Ide_gest  = P_Gestion  AND
	   L.FLG_CPTAB =  P_Flg_Cptab AND
       EXISTS (SELECT 'TRUE' FROM
               FC_REF_PIECE P
               WHERE
               P.ide_piece = P_ide_piece   AND
               P.ide_ref_piece = L.ide_ref_piece AND
			   P.ide_ordo = P_Ordo AND
			   P.ide_poste = L.Ide_Poste
              )
       AND (P_var_tiers IS NULL OR L.var_tiers = P_var_tiers)
       AND (P_ide_tiers IS NULL OR L.ide_tiers = P_ide_tiers)
       ORDER BY 1;

 -- déclaraion des variables
 v_Ligne_Ecriture C_Ligne_Ecriture%ROWTYPE;
 v_mtencaissement FB_ENCAISSEMENT.MT_ENCAISS%TYPE;
 v_mtinter        FB_ENCAISSEMENT.MT_Encaiss%TYPE;
 v_libl           SR_CODIF.LIBL%TYPE;
 v_flag_cptab     FC_LIGNE.FLG_CPTAB%TYPE;
 v_retour NUMBER;
 v_type_piece     FB_PIECE.COD_TYP_PIECE%TYPE;
 v_statut_piece   FB_PIECE.COD_STATUT%TYPE;
 v_mt_an   FB_PIECE.MT%TYPE := 0;
 Ext_Cod_Ext      EXCEPTION;

BEGIN
-- Recherche code externe OUI_NON
EXT_Codext('OUI_NON','O',v_libl,v_flag_cptab,v_retour);
IF  v_retour != 1 THEN
	RAISE Ext_Cod_Ext;
END IF;

--CBI-20060213-D V35-DI44-028
EXT_Codext('STATUT_PIECE','V',v_libl,v_statut_piece,v_retour);
IF  v_retour != 1 THEN
	RAISE Ext_Cod_Ext;
END IF;
EXT_Codext('TYPE_PIECE','AR',v_libl,v_type_piece,v_retour);
IF  v_retour != 1 THEN
 	RAISE Ext_Cod_Ext;
END IF;
--CBI-20060213-F V35-DI44-028

-- MYI, 14/03/2003 : Ajout de fonctions pour trace et débigage
IF GLOBAL.FICHIER_TRACE IS NULL THEN
   GLOBAL.INI_FICHIER_TRACE(CAL_NOM_FICHIER_TRACE('EXT_Montant_Encais'));
   GLOBAL.INI_NIVEAU_TRACE(0);
END IF;
OPEN C_Ligne_Ecriture(v_flag_cptab);
LOOP
 FETCH C_Ligne_Ecriture INTO v_Ligne_Ecriture;
 EXIT WHEN C_Ligne_Ecriture%NOTFOUND ;
 -- Calcule des sommes des montants encaissés
 BEGIN

	AFF_TRACE('EXT_Montant_Encais', 1, NULL, 'eciture '||v_Ligne_Ecriture.ide_ecr||'mt encais'||v_mtencaissement);
    SELECT SUM(mt_encaiss) INTO v_mtinter
	FROM FB_ENCAISSEMENT
	WHERE
	Ide_poste = P_Poste   AND
	Ide_gest  = P_Gestion AND
	ide_ordo  = P_Ordo  AND
	ide_ecr   = v_Ligne_Ecriture.ide_ecr AND
	ide_jal   = v_Ligne_Ecriture.ide_jal AND  --isa  rajout du 12/09/2006 rajout de ide_jal car sinon on sélectionne des lignes ne concernant pas la pièce
      /*pge 23/07/2008 ano 275*/
      nvl(ide_piece,p_ide_piece) = p_ide_piece AND
      --ide_piece = p_ide_piece AND --isa  rajout du 25/10/2006 rajout de ide_piece (cas une ecriture avec 2 OR)
      /* pge 23/07/2008 ano 275*/
	( P_Cod_Bud IS NULL OR Cod_bud   = P_Cod_Bud ) AND
	( P_Var_Bud IS NULL OR var_bud   = P_Var_Bud ) AND
	( P_Ide_Ligne_Exe IS NULL OR ide_lig_exec   = P_Ide_Ligne_Exe);

	--somme pour chaque ligne de l'écriture
    v_mtencaissement := NVL(v_mtencaissement,0) + NVL(v_mtinter,0);

   EXCEPTION
   WHEN NO_DATA_FOUND THEN
     v_mtinter := 0;
   END;
END LOOP;
CLOSE C_Ligne_Ecriture;

--FBT-20070217-V4124-Correction de l'anomalie 15 du mantis - DIT44-156-------------------
IF P_Ide_Ligne_Exe IS NULL THEN
	BEGIN
		 --rapatriement des annulations d'OR
		 SELECT NVL(SUM(fb_ligne_tiers_piece.mt_dev),0)
		 INTO 	v_mt_an
		 FROM 	fb_piece
		 INNER JOIN fb_ligne_tiers_piece
		 	   ON fb_piece.IDE_GEST=fb_ligne_tiers_piece.IDE_GEST
			   AND fb_piece.IDE_ORDO=fb_ligne_tiers_piece.IDE_ORDO
			   AND fb_piece.IDE_POSTE=fb_ligne_tiers_piece.IDE_POSTE
			   AND fb_piece.COD_BUD=fb_ligne_tiers_piece.COD_BUD
			   AND fb_piece.IDE_PIECE=fb_ligne_tiers_piece.IDE_PIECE
		 WHERE  fb_piece.ide_poste = P_Poste
		 AND    fb_piece.ide_gest = P_Gestion
		 AND    fb_piece.ide_ordo = P_Ordo
		 AND    ( P_Cod_Bud IS NULL OR fb_piece.cod_bud   = P_Cod_Bud )
		 AND    fb_piece.cod_typ_piece = v_type_piece
		 AND    fb_piece.ide_piece_init = P_ide_piece
		 AND    fb_piece.cod_statut = v_statut_piece
		 --FBT-20070921-V4220-Correction de l'anomalie 88 du mantis
		 AND 	fb_ligne_tiers_piece.cod_typ_piece=v_type_piece
		 AND	fb_ligne_tiers_piece.IDE_TIERS=P_ide_tiers
		 AND 	fb_ligne_tiers_piece.VAR_TIERS=P_var_tiers	;
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		    NULL;
	END;

	--controle du montant et addition au montant encaissé des annulation d'OR
	IF NVL(v_mt_an,0)>=0 THEN
		v_mtencaissement := NVL(v_mtencaissement,0) + NVL(v_mt_an,0);
	ELSE
		v_mtencaissement := NVL(v_mtencaissement,0) - NVL(v_mt_an,0);
	END IF;
END IF;
--FBT-20070217---------------------------------------------------------------------------

--Retour de fonction
RETURN v_mtencaissement;
P_Retour :=1;
EXCEPTION
WHEN Ext_Cod_Ext THEN
    P_Retour := -1;
WHEN OTHERS THEN
    P_Retour := 0;
END EXT_Montant_Encaiss;

/

CREATE OR REPLACE FUNCTION EXT_Mtdso_U621_070E(P_IDE_POSTE          fb_dso.ide_poste%TYPE,
                                               P_IDE_GEST           fb_dso.ide_gest%TYPE,
                                               P_IDE_ORDO           fb_dso.ide_ordo%TYPE,
                                               P_COD_BUD            fb_dso.cod_bud%TYPE,
                                               P_NUM_DSO            fb_dso.num_dso%TYPE) RETURN VARCHAR2 IS

  v_montant  fb_dso.mt%TYPE;
BEGIN
  SELECT SUM(ABS(mt)) INTO v_montant
  FROM fb_dso
  WHERE ide_poste = P_IDE_POSTE
    AND ide_gest = P_IDE_GEST
    AND ide_ordo = P_IDE_ORDO
    AND cod_bud = P_COD_BUD
    AND num_dso = P_NUM_DSO;

  Return(v_montant);

EXCEPTION
  WHEN Others THEN
    Return(NULL);

END EXT_Mtdso_U621_070E;

/

CREATE OR REPLACE FUNCTION EXT_Mtecrdso_U621_070E(P_IDE_POSTE          fc_ecriture.ide_poste%TYPE,
                                                  P_IDE_GEST           fc_ecriture.ide_gest%TYPE,
                                                  P_FLG_CPTAB          fc_ecriture.flg_cptab%TYPE,
                                                  P_IDE_ORDO           fc_ecriture.ide_ordo%TYPE,
                                                  P_COD_BUD            fc_ecriture.cod_bud%TYPE,
                                                  P_IDE_PIECE          fc_ecriture.ide_piece%TYPE,
                                                  P_COD_TYP_PIECE      fc_ecriture.cod_typ_piece%TYPE,
                                                  P_SENS_DB            fc_ligne.cod_sens%TYPE) RETURN VARCHAR2 IS

  v_montant  fc_ligne.mt%TYPE;
BEGIN
  SELECT SUM(ABS(l.mt)) INTO v_montant
  FROM fc_ecriture e,fc_ligne l
  WHERE l.ide_poste = e.ide_poste
    AND l.ide_gest = e.ide_gest
    AND l.ide_jal = e.ide_jal
    AND l.flg_cptab = e.flg_cptab
    AND l.ide_ecr = e.ide_ecr
    AND e.ide_poste = P_IDE_POSTE
    AND e.ide_gest = P_IDE_GEST
    AND e.flg_cptab = P_FLG_CPTAB
    AND e.ide_piece = P_IDE_PIECE
    AND e.cod_typ_piece = P_COD_TYP_PIECE
    AND l.cod_sens = P_SENS_DB
    AND l.ide_ordo = P_IDE_ORDO
    AND l.cod_bud = P_COD_BUD
    AND l.ide_tiers IS NULL;

  Return(v_montant);

EXCEPTION
  WHEN Others THEN
    Return(NULL);

END EXT_Mtecrdso_U621_070E;

/

CREATE OR REPLACE FUNCTION EXT_Mtecr_U621_070E(P_IDE_POSTE          fc_ecriture.ide_poste%TYPE,
                                               P_IDE_GEST           fc_ecriture.ide_gest%TYPE,
                                               P_FLG_CPTAB          fc_ecriture.flg_cptab%TYPE,
                                               P_IDE_ORDO           fc_ecriture.ide_ordo%TYPE,
                                               P_COD_BUD            fc_ecriture.cod_bud%TYPE,
                                               P_IDE_PIECE          fc_ecriture.ide_piece%TYPE,
                                               P_COD_TYP_PIECE      fc_ecriture.cod_typ_piece%TYPE) RETURN VARCHAR2 IS

  v_montant  fc_ligne.mt%TYPE;
BEGIN
  SELECT SUM(ABS(l.mt)) INTO v_montant
  FROM fc_ecriture e,fc_ligne l
  WHERE l.ide_poste = e.ide_poste
    AND l.ide_gest = e.ide_gest
    AND l.ide_jal = e.ide_jal
    AND l.flg_cptab = e.flg_cptab
    AND l.ide_ecr = e.ide_ecr
    AND e.ide_poste = P_IDE_POSTE
    AND e.ide_gest = P_IDE_GEST
    AND e.flg_cptab = P_FLG_CPTAB
    AND e.ide_ordo = P_IDE_ORDO
    AND e.cod_bud = P_COD_BUD
    AND e.ide_piece = P_IDE_PIECE
    AND e.cod_typ_piece = P_COD_TYP_PIECE
    AND l.ide_tiers IS NULL;

  Return(v_montant);

EXCEPTION
  WHEN Others THEN
    Return(NULL);

END EXT_Mtecr_U621_070E;

/

CREATE OR REPLACE FUNCTION EXT_Mtenc_U621_070E(P_IDE_POSTE           fb_encaissement.ide_poste%TYPE,
                                               P_IDE_GEST            fb_encaissement.ide_gest%TYPE,
                                               P_IDE_JAL             fb_encaissement.ide_jal%TYPE,
                                               P_IDE_ECR             fb_encaissement.ide_ecr%TYPE,
                                               P_IDE_LIG             fb_encaissement.ide_lig%TYPE,
                                               P_FLG_REC_COMPTANT    fb_encaissement.flg_rec_comptant%TYPE) RETURN VARCHAR2 IS

  v_montant  fb_encaissement.mt_encaiss%TYPE;
BEGIN
  SELECT SUM(ABS(mt_encaiss)) INTO v_montant
  FROM fb_encaissement
  WHERE ide_poste = P_IDE_POSTE
    AND ide_gest = P_IDE_GEST
    AND ide_jal = P_IDE_JAL
    AND ide_ecr = P_IDE_ECR
    AND ide_lig = P_IDE_LIG
    AND flg_rec_comptant = P_FLG_REC_COMPTANT;

  Return(v_montant);

EXCEPTION
  WHEN Others THEN
    Return(NULL);

END EXT_Mtenc_U621_070E;

/

CREATE OR REPLACE FUNCTION EXT_Mtlig_U621_070E(P_IDE_POSTE          fc_ligne.ide_poste%TYPE,
                                               P_IDE_GEST           fc_ligne.ide_gest%TYPE,
                                               P_IDE_JAL            fc_ligne.ide_jal%TYPE,
                                               P_FLG_CPTAB          fc_ligne.flg_cptab%TYPE,
                                               P_IDE_ECR            fc_ligne.ide_ecr%TYPE,
                                               P_IDE_LIG            fc_ligne.ide_lig%TYPE) RETURN VARCHAR2 IS

  v_montant  fc_ligne.mt%TYPE;
BEGIN
  SELECT SUM(ABS(l.mt)) INTO v_montant
  FROM fc_ligne l
  WHERE l.ide_poste = P_IDE_POSTE
    AND l.ide_gest = P_IDE_GEST
    AND l.ide_jal = P_IDE_JAL
    AND l.flg_cptab = P_FLG_CPTAB
    AND l.ide_ecr = P_IDE_ECR
    AND l.ide_lig = P_IDE_LIG
    AND l.ide_tiers IS NULL;

  Return(v_montant);

EXCEPTION
  WHEN Others THEN
    Return(NULL);

END EXT_Mtlig_U621_070E;

/

CREATE OR REPLACE FUNCTION EXT_Mtpce_U621_070E(P_IDE_POSTE          fb_piece.ide_poste%TYPE,
                                               P_IDE_GEST           fb_piece.ide_gest%TYPE,
                                               P_IDE_ORDO           fb_piece.ide_ordo%TYPE,
                                               P_COD_BUD            fb_piece.cod_bud%TYPE,
                                               P_IDE_PIECE          fb_piece.ide_piece%TYPE,
                                               P_COD_TYP_PIECE      fb_piece.cod_typ_piece%TYPE,
                                               P_COD_STATUT         fb_piece.cod_statut%TYPE) RETURN VARCHAR2 IS

  v_montant  fb_piece.mt%TYPE;
BEGIN
  SELECT SUM(ABS(mt)) INTO v_montant
  FROM fb_piece
  WHERE ide_poste = P_IDE_POSTE
    AND ide_gest = P_IDE_GEST
    AND ide_ordo = P_IDE_ORDO
    AND cod_bud = P_COD_BUD
    AND ide_piece = P_IDE_PIECE
    AND cod_typ_piece = P_COD_TYP_PIECE
    AND cod_statut = P_COD_STATUT;

  Return(v_montant);

EXCEPTION
  WHEN Others THEN
    Return(NULL);

END EXT_Mtpce_U621_070E;

/

CREATE OR REPLACE FUNCTION EXT_NB_DEC_MT_DEVISE(p_ide_devise       SR_CODIF.ide_codif%TYPE,
                                             p_nb_dec           IN OUT NUMBER
										     ) RETURN NUMBER IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : REF
-- Nom           : EXT_NB_DEC_MT_DEVISE
-- ---------------------------------------------------------------------------
--  Auteur         : LGD
--  Date creation  : 07/02/2003
-- ---------------------------------------------------------------------------
-- Role          : Récupération du nombre de décimale pour formater les montants en devise
--
-- Parametres  entree  :
-- 				 1 - p_ide_devise : (Code externe) identifiant interne de la devise dont on veut le taux
-- Parametre sorties :
--				 2 - p_nb_dec : Nombre de décimales a retourner
-- Retourne
--               1 => OK
--              -1 => Pb sur la récupération de la devise de référence
                -2 => Pb sur la récupération du nombre de décimales
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_NB_DEC_MT_DEVISE.sql version 3.0-1.0
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	       |Initiales |Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) EXT_NB_DEC_MT_DEVISE.sql 3.0d-1.0	|07/02/2003| LGD	  | Création
-- 	----------------------------------------------------------------------------------------------------------
*/
  v_codext_devise_ref SR_CODIF.cod_codif%TYPE;
  v_codint_devise_ref SR_CODIF.ide_codif%TYPE;
  v_libl_devise_ref SR_CODIF.libl%TYPE;

  v_ret NUMBER;

  v_val_param SR_PARAM.VAL_PARAM%TYPE;

  -- Variable pour la trace
  v_niveau_trace NUMBER := NULL;
  v_num_trt NUMBER;
BEGIN

	 -- Recuperation du niveau de trace en passant par les variables ASTER
	 ASTER_VAR.get_var('NIVEAU_TRACE_VAR','P_NIV_TRACE', v_niveau_trace, v_num_trt);
	 GLOBAL.INI_NIVEAU_TRACE(NVL(v_niveau_trace,0));

 	 AFF_TRACE('EXT_DEC_MT_DEVISE', 2, NULL, 'Debut traitement');

	 -- Recuperation du code interne de la devise de reference
     EXT_PARAM('IC0026', v_codint_devise_ref, v_ret);
	 IF v_ret != 1 THEN
		RETURN(-1);
     END IF;
	 AFF_TRACE('EXT_DEC_MT_DEVISE', 2, NULL, 'Code interne dev ref:'||v_codint_devise_ref);

	  -- Récupération du nombre de décimal paramétré
      EXT_PARAM('IR0001', v_val_param, v_ret);
	  IF v_ret != 1 THEN
	      RETURN(-2);
	  END IF;
	  AFF_TRACE('EXT_DEC_MT_DEVISE', 2, NULL, 'nb de decimal param:'||v_val_param);

	 -- si la devise est null ou égale à la devise de référence
	 IF p_ide_devise IS NULL OR p_ide_devise = v_codint_devise_ref THEN
		p_nb_dec :=v_val_param;
	 ELSE
	 	 p_nb_dec :=3;
	 END IF;

	 return(1);


EXCEPTION
  WHEN OTHERS THEN
 	  RAISE;
END EXT_NB_DEC_MT_DEVISE;

/

CREATE OR REPLACE FUNCTION          EXT_NB_DEC_MT_DEVISE_TGE(p_ide_devise       SR_CODIF.ide_codif%TYPE,
                                             p_nb_dec           IN OUT NUMBER
                                             ) RETURN NUMBER IS
/*
--     ----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : REF
-- Nom           : EXT_NB_DEC_MT_DEVISE
-- ---------------------------------------------------------------------------
--  Auteur         : LGD
--  Date creation  : 07/02/2003
-- ---------------------------------------------------------------------------
-- Role          : Récupération du nombre de décimale pour formater les montants en devise
--
-- Parametres  entree  :
--                  1 - p_ide_devise : (Code externe) identifiant interne de la devise dont on veut le taux
-- Parametre sorties :
--                 2 - p_nb_dec : Nombre de décimales a retourner
-- Retourne
--               1 => OK
--              -1 => Pb sur la récupération de la devise de référence
                -2 => Pb sur la récupération du nombre de décimales
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_NB_DEC_MT_DEVISE.sql version 3.0-1.0
-- ---------------------------------------------------------------------------
--
--     -----------------------------------------------------------------------------------------------------
--     Fonction                           |Date           |Initiales |Commentaires
--     -----------------------------------------------------------------------------------------------------
-- @(#) EXT_NB_DEC_MT_DEVISE.sql 3.0d-1.0    |07/02/2003| LGD      | Création
--     ----------------------------------------------------------------------------------------------------------
*/
  v_codext_devise_ref SR_CODIF.cod_codif%TYPE;
  v_codint_devise_ref SR_CODIF.ide_codif%TYPE;
  v_libl_devise_ref SR_CODIF.libl%TYPE;

  v_ret NUMBER;

  v_val_param SR_PARAM.VAL_PARAM%TYPE;

  -- Variable pour la trace
  v_niveau_trace NUMBER := NULL;
  v_num_trt NUMBER;
BEGIN


     -- Recuperation du niveau de trace en passant par les variables ASTER
     ASTER_VAR.get_var('NIVEAU_TRACE_VAR','P_NIV_TRACE', v_niveau_trace, v_num_trt);
     GLOBAL.INI_NIVEAU_TRACE(NVL(v_niveau_trace,0));

      AFF_TRACE('EXT_DEC_MT_DEVISE', 2, NULL, 'Debut traitement');

     -- Recuperation du code interne de la devise de reference
     EXT_PARAM('IC0026', v_codint_devise_ref, v_ret);
     IF v_ret != 1 THEN
        RETURN(-1);
     END IF;
     AFF_TRACE('EXT_DEC_MT_DEVISE', 2, NULL, 'Code interne dev ref:'||v_codint_devise_ref);

      -- Récupération du nombre de décimal paramétré
      EXT_PARAM('TGE001', v_val_param, v_ret);
      IF v_ret != 1 THEN
          RETURN(-2);
      END IF;
      AFF_TRACE('EXT_DEC_MT_DEVISE', 2, NULL, 'nb de decimal param:'||v_val_param);

     -- si la devise est null ou égale à la devise de référence
     IF p_ide_devise IS NULL OR p_ide_devise = v_codint_devise_ref THEN
        p_nb_dec :=v_val_param;
     ELSE
          p_nb_dec :=3;
     END IF;

     return(1);


EXCEPTION
  WHEN OTHERS THEN
       RAISE;
END EXT_NB_DEC_MT_DEVISE_TGE;

/

CREATE OR REPLACE FUNCTION EXT_poste_assign(
	   	  		  				   p_ide_ordo IN FN_LP_RPO.IDE_ORDO%TYPE
								   , p_cod_bud IN FN_LP_RPO.COD_BUD%TYPE
								   , p_cod_typ_bud IN FN_LP_RPO.COD_TYP_BUD%TYPE
                                   , p_ide_gest IN FN_LP_RPO.IDE_GEST%TYPE
								   , p_ide_ligne IN FN_LP_RPO.MAS_LIG_PREV%TYPE
								   ) RETURN FN_LP_RPO.IDE_POSTE%TYPE IS
/*
---------------------------------------------------------------------------------------
-- Nom           :  EXT_poste_assign
-- Date creation : 24/01/2000
-- Creee par     : SOFIANE NEKERE (SEMA GROUP)
-- Role          : Extraction du poste comptable assignataire d'une ligne budgetaire
--
-- Parametres    :  p_ide_ordo : Ordonnateur
--                   p_cod_bud : Code budget
--                  p_cod_typ_bud : Code type de budget
--                  p_ide_gest	  : Gestion (identifiant)
--					p_ide_ligne	  : identifiant de la ligne budgétaire
-- Valeur retournee : - retourne le poste assignataire correspondant aux caracteristiques
-- 		  			  	passees en parametre. Si aucun poste assignatire n'est defini
--						ou si une anomalie survient en cours du traitement, la valeur NULL
--						est renvoyee.
--
-- Appels		 :
-- Version 		 : @(#) 1.0
---------------------------------------------------------------------------------------
-- Historique 	 : v1.0, 24/01/2000, Creation
--  15/05/2008  v4260    PGE  evol_DI44_2008_014 Controle sur les dates de validité de fn_lp_rpo
---------------------------------------------------------------------------------------
*/
CURSOR c_lignes_masque(
 		pc_ide_ordo IN FN_LP_RPO.IDE_ORDO%TYPE
                 , pc_cod_bud IN FN_LP_RPO.COD_BUD%TYPE
                 , pc_cod_typ_bud IN FN_LP_RPO.COD_TYP_BUD%TYPE
                 , pc_ide_gest IN FN_LP_RPO.IDE_GEST%TYPE
				 ) IS
	SELECT IDE_poste
		   , MAS_LIG_PREV
	FROM  FN_LP_RPO
	WHERE IDE_ordo = pc_ide_ordo
		  AND COD_typ_bud = pc_cod_typ_bud
		  AND COD_bud = pc_cod_bud
		  AND IDE_gest = pc_ide_gest
                  AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
                  AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008;

v_MAS_lig_prev	FN_LP_RPO.MAS_lig_prev%TYPE;
v_derniere_longueur   NUMBER;
v_ide_poste FN_LP_RPO.IDE_POSTE%TYPE;
v_poste_trouve FN_LP_RPO.IDE_POSTE%TYPE;

BEGIN
OPEN c_lignes_masque(p_ide_ordo
                         , p_cod_bud
                         , p_cod_typ_bud
                         , p_ide_gest
	 		 );
v_poste_trouve := NULL;
v_derniere_longueur := 0;
LOOP
	FETCH c_lignes_masque INTO v_IDE_poste, v_MAS_lig_prev;
	IF c_lignes_masque%NOTFOUND THEN
	   EXIT;
	END IF;
	IF v_MAS_lig_prev = p_ide_ligne THEN
		v_poste_trouve := v_ide_poste;
		EXIT;
	END IF;
	IF v_MAS_lig_prev IS NULL THEN
		IF v_derniere_longueur = 0 THEN
			v_poste_trouve := v_ide_poste;
		END IF;
	ELSIF p_ide_ligne LIKE v_MAS_lig_prev||'%' THEN
/*IF p_ide_ligne LIKE REPLACE(v_MAS_lig_prev, '*', '%') THEN*/
		IF v_derniere_longueur < LENGTH(v_MAS_lig_prev) THEN
			v_poste_trouve := v_ide_poste;
                  v_derniere_longueur := LENGTH(v_MAS_lig_prev);
		END IF;
	END IF;
END LOOP;
CLOSE c_lignes_masque;
RETURN v_poste_trouve;

EXCEPTION
    WHEN OTHERS THEN
		 RETURN NULL;
END EXT_poste_assign;

/

CREATE OR REPLACE FUNCTION EXT_Site_Courant RETURN VARCHAR2 IS
/*
-- ----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : Paramétrage
-- Nom           : EXT_Site_Courant
-- ---------------------------------------------------------------------------
--  Auteur         : Sofiane NEKERE(SchlumbergerSema)
--  Date creation  : 25/09/2002
-- ---------------------------------------------------------------------------
-- Role          : Extraction du code du site courant
--
-- Parametres    : (Aucun)
--
-- Valeurs retournees : Code site (identifiant) du site courant
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_Site_Courant.sql version 3.0-1.0
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					         |Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) EXT_Site_Courant.sql 3.0-1.0	|25/09/2002| SNE	| Création
-- ----------------------------------------------------------------------------------------------------------
*/
   v_ret NUMBER;
   v_site SR_PARAM.VAL_PARAM%TYPE;
BEGIN
   EXT_PARAM('SM0008', v_site, v_ret);
   IF v_ret != 1 THEN
   	  v_site := NULL;
   END IF;
   RETURN(v_site);
EXCEPTION
   WHEN Others THEN
      RAISE;
END EXT_Site_Courant;

/

CREATE OR REPLACE FUNCTION ext_spec_local(p_poste    IN  VARCHAR2,
                           p_var_cpta IN  VARCHAR2,
                           p_ide_cpt  IN  VARCHAR2,
                           p_masque2  IN  VARCHAR2,
                           p_masque3  IN  VARCHAR2) return ROWID
IS

/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  :
-- Nom           : ext_spec_local
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 04/12/2001
-- ---------------------------------------------------------------------------
-- Role          : Recupere le ROWID d'une specification définie localement en
--                 d'un poste comptable, une var_cpta, d'un  compte et des masques
--                 correspondant a une specification nationale. Si la specification
--                 locale correspond aux masques, la fonction retourne le rowid.
--
-- Parametres    :
 P_IDE_POSTE
--                  1.- p_poste : Poste comptable
--                  2.- p_var_cpta : Variation comptable
--                  3.- p_ide_cpt : Le compte
--                  4.- p_masque2 : Le masque de la specification national 2
--                  5.- p_masque3 : Le masque de la specification national 3
--
--
-- Valeurs retournees :
--                  1 - Le rowid de la premiere specification local.
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) ext_spec_local.sql version 3.0-1.0 : SGN : 04/12/2001
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) ext_spec_local.sql 3.0-1.0	|-04/12/2001 | SGN	| Création
-- 	----------------------------------------------------------------------------------------------------------
*/

	v_rowid 		ROWID;
	v_curid		NUMBER;
	v_req_sql 		VARCHAR2(512);
	v_clause_select 	VARCHAR2(512);
	v_clause_from 	VARCHAR2(512);
	v_clause_where1 	VARCHAR2(512);
	v_clause_where2 	VARCHAR2(512);
	v_clause_where3 	VARCHAR2(512);
	v_res1		ROWID;
	v_nb_ligne 		NUMBER := 0;

BEGIN
	-- Construction de la requete
	v_clause_select := 'SELECT rowid';
	v_clause_from := 'FROM RC_SPEC_LOCAL';
	v_clause_where1 := 'WHERE ide_poste = '''||p_poste||''' AND var_cpta = '''||p_var_cpta||''' AND ide_cpt = '''||p_ide_cpt||'''';

	-- Si les masques ont ete defini a LOCAL alors le masque local doit exister
	IF p_masque2 = 'LOCAL' THEN
	  v_clause_where2 := 'AND mas_spec2 IS NOT NULL';
	ELSE
	  v_clause_where2 := 'AND mas_spec2 IS NULL';
	END IF;
	IF p_masque3 = 'LOCAL' THEN
	  v_clause_where3 := 'AND mas_spec3 IS NOT NULL';
	ELSE
	  v_clause_where3 := 'AND mas_spec3 IS NULL';
	END IF;

	-- Concatenation des elements de la requete
	v_req_sql := v_clause_select||' '||v_clause_from||' '||v_clause_where1||' '||v_clause_where2||' '||v_clause_where3;

	-- Ouverture du curseur
	v_curid := DBMS_SQL.OPEN_CURSOR;

	-- Parcours
	DBMS_SQL.PARSE(v_curid, v_req_sql, DBMS_SQL.native);

	-- Definition des colones receptrices
	DBMS_SQL.DEFINE_COLUMN(v_curid, 1, v_res1,1024);

	-- Execution du curseur + fetch
	v_nb_ligne := DBMS_SQL.EXECUTE_AND_FETCH(v_curid);

	-- Lecture du curseur on ne recupere que le premier record si il existe.
	IF v_nb_ligne != 0 THEN
		-- Affectation des valeurs retournees aux variables locales
		DBMS_SQL.COLUMN_VALUE(v_curid, 1, v_rowid);
	ELSE
		v_rowid := NULL;
	END IF;

	DBMS_SQL.CLOSE_CURSOR(v_curid);

	RETURN v_rowid;
EXCEPTION
	WHEN OTHERS THEN
		IF DBMS_SQL.IS_OPEN(v_curid) THEN
			DBMS_SQL.CLOSE_CURSOR(v_curid);
		END IF;
		RAISE;
END ext_spec_local;

/

CREATE OR REPLACE FUNCTION EXT_Titre_Application(p_nom_programme IN VARCHAR2) RETURN VARCHAR2 IS
/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_Titre_Application
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 12/09/2001
-- ---------------------------------------------------------------------------
-- Role          : Ramene le titre d'une application (FORM, REPORTS, ...)
--
-- Parametres    :
-- 				 1 - p_nom_pogramme : Nom de l'UT correspondant au programma
--
-- Valeur retournee : Titre de l'UT.
--
-- Appels		 :  SH_FONCTION
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_Titre_Application.sql version 2.1-1.0 : SNE : 12/09/2001
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	         |Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) EXT_Titre_Application.sql 2.1-1.0	|12/09/2001 | SNE	| Création
---------------------------------------------------------------------------------------
*/
   CURSOR c_fonction (pc_nom_pogramme IN VARCHAR2) IS
   	SELECT   B.libn
	FROM  SH_FONCTION B
	WHERE B.COD_ROLE = pc_nom_pogramme;
   v_titre_application SH_FONCTION.LIBN%TYPE;
BEGIN
  OPEN c_fonction(p_nom_programme);
  FETCH c_fonction INTO v_titre_application;
  CLOSE c_fonction;
  RETURN(v_titre_application );
END;

/

CREATE OR REPLACE FUNCTION EXT_TYP_POSTE(p_ide_poste IN RM_POSTE.ide_poste%TYPE) RETURN RM_POSTE.ide_typ_poste%TYPE IS
/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_TYP_POSTE
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 22/01/2002
-- ---------------------------------------------------------------------------
-- Role          : Ramene le type d'un poste
--
-- Parametres    :
-- 				 1 - p_ide_poste : identifiant du poste comptable
--
-- Valeur retournee : type du poste comptable passé en parametre
--
-- Appels		 :  RM_POSTE
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_TYP_POSTE.sql version 2.2-1.0 : SGN : 22/01/2002
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction				|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) EXT_TYP_POSTE.sql 2.2-1.0	|22/01/2002 | SGN	| Création
---------------------------------------------------------------------------------------
*/
   CURSOR c_poste IS
   	SELECT  ide_typ_poste
	FROM  RM_POSTE
	WHERE ide_poste = p_ide_poste;

   	v_ide_typ_poste RM_POSTE.ide_typ_poste%TYPE;
BEGIN
  IF p_ide_poste IS NULL THEN
  	 RETURN null;
  END IF;

  OPEN c_poste;
  FETCH c_poste INTO v_ide_typ_poste;
  CLOSE c_poste;

  RETURN(v_ide_typ_poste);
END;

/

CREATE OR REPLACE FUNCTION Ext_User_Passwd(p_ide_site IN VARCHAR2 := GLOBAL.ide_site) RETURN VARCHAR2 IS
/*
-- ----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : Interne
-- Nom           : Ext_User_Passwd
-- ---------------------------------------------------------------------------
--  Auteur         : Sofiane NEKERE(SchlumbergerSema)
--  Date creation  : 24/01/2000
-- ---------------------------------------------------------------------------
-- Role          : Extraction du mot de passe de l'utilisateur connecté
--
-- Parametres    :
-- 				  1- p_ide_site : Code sdu site ou se trouve l'utilisateur
--				  	 Par defaut on prend le site du contexte, et si celui-ci n'est pas renseigné,
--					 le site courant
--
-- Valeur retournee : - Mot de passe decrypté de l'utilisateur connecté
--          		- NULL si l'utilisateur n'a aucune habilitation ASTER
--       			- Exception positionnée en cas d'erreur technique
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) Ext_User_Passwd.sql version 2.2-1.2
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					         |Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) Ext_User_Passwd.sql 2.0-1.0	|24/01/2000| SNE	| Création
-- @(#) Ext_User_Passwd.sql 2.0-1.1	|06/02/2000| SNE	| Correction de la requete
-- @(#) Ext_User_Passwd.sql 2.2-1.2	|27/09/2002| SNE	| Encapsulation securitaire
-- ----------------------------------------------------------------------------------------------------------
*/
v_mot_de_passe  FH_UTIL.PWD%TYPE;
v_retour        FH_UTIL.PWD%TYPE := 'NULL';
v_ret 			NUMBER;
v_Mask        	VARCHAR2(30);
v_site			RM_SITE_PHYSIQUE.IDE_SITE%TYPE;
BEGIN
   v_ret := SECURITY.SEC_PRMSK(v_Mask);
   if v_ret = 0 THEN
   	   v_site := NVL(p_ide_site, EXT_Site_Courant);
	   Select PWD INTO v_mot_de_passe FROM FH_UTIL
		   WHERE (IDE_SITE = v_site OR v_site IS NULL) AND COD_UTIL = USER;
	   v_retour := SECURITY.unencrypt(v_mot_de_passe, v_Mask);
   END IF;
   RETURN v_retour;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN NULL;
   WHEN OTHERS THEN
      RAISE;
END Ext_User_Passwd;

/

CREATE OR REPLACE FUNCTION EXT_VAL_TAUX(P_Code_Devise IN SR_CODIF.COD_CODIF%TYPE,
                                        P_Date        IN  DATE := SYSDATE
										) RETURN Number IS


/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_VAL_TAUX
-- 	------------------------------------------------------------------------------
-- Date creation : 03/06/2002
-- Auteur        : MYI
-- Role          : Calcul d un taux de change.
--
-- ---------------------------------------------------------------------------
-- Role          : Calcul d un taux de change. Si la devise n est pas renseigne
--                 on prend la devise de reference
--
-- Parametres  entree  :
-- 				 1 - p_Code_devise : Code externe de la devise dont on veut le taux
--				 2 - p_date : date pour laquelle on veut le taux de change (par defaut date du jour)
--
-- Parametre sorties :
--				 taux de change a retourner

--
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_VAL_TAUX.sql version 3.0-1.0
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) EXT_VAL_TAUX .sql 3.0-1.0	|03/06/2002| MYI| Création ( Fonction 48 )
-- @(#) EXT_VAL_TAUX .sql 3.0d-1.1	|22/01/2002| SGN| ANOVA224 : Gestion de la devise de reference
-- 	----------------------------------------------------------------------------------------------------------
*/
-- Déclaration des variables
 v_codint_devise RB_TXCHANGE.IDE_DEVISE%TYPE;
 v_libl          SR_CODIF.LIBL%TYPE;
 v_ret           NUMBER;
 v_taux_dev      RB_TXCHANGE.VAL_TAUX%TYPE;
 Erreur_CodInt EXCEPTION;
 -- MODIF SGN ANOVA224
 v_codint_dev_ref SR_CODIF.ide_codif%TYPE;
 PARAM_EXCEPTION EXCEPTION;
 -- Fin modif sgn
BEGIN

-- MODIF SGN ANOVA
IF P_code_devise is null THEN
   return 1;
ELSE
   -- Recuperation du code interne de la devise de reference
   EXT_PARAM('IC0026', v_codint_dev_ref, v_ret);
   IF v_ret != 1 THEN
      RAISE PARAM_EXCEPTION;
   END IF;

   Ext_Codint('CODE_DEVISE', P_Code_Devise ,  v_libl ,v_codint_devise, v_ret);
   IF v_ret != 1 Then
   	  Raise Erreur_CodInt;
   End if;

   -- Si la devise passee en parametre est la devise de reference le taux de change est 1
   IF v_codint_dev_ref = v_codint_devise THEN
      return 1;
   END IF;
   -- fin modif sgn

   -- Rechercher le taux de change
   Select VAL_TAUX into v_taux_dev
   From rb_txchange rbt1
   Where
   rbt1.ide_devise      = v_codint_devise and
   rbt1.dat_application = (select max(rbt2.dat_application)
						  from rb_txchange rbt2
						  where
						  ctl_date(rbt2.dat_application ,P_date) = 'O' And
						  rbt2.ide_devise = rbt1.ide_devise
						  );
   Return v_taux_dev;
-- MODIF SGN ANOVA224
--Else
--   Return 0;
-- fin modif sgn
End if;

EXCEPTION
When Erreur_CodInt Then
     Return 0;
When No_Data_Found Then
     Return 0;
-- MODIF SGN ANOVA224
When PARAM_EXCEPTION Then
     Return 0;
-- fin modif sgn
When Others Then
     Raise;
     Return 0 ;

END EXT_VAL_TAUX;

/

CREATE OR REPLACE FUNCTION F_RANG
(P_SPEC1 VARCHAR2,POSTE VARCHAR2,GEST VARCHAR2,JAL VARCHAR2,ECR NUMBER,P_MT NUMBER, P_COD_SENS VARCHAR2,LIG NUMBER)
RETURN VARCHAR2
IS
V_CPT NUMBER(6);
BEGIN

SELECT COUNT(*) INTO V_CPT FROM  TC_TCC_LIG
WHERE IDE_POSTE = POSTE
  AND IDE_GEST  = GEST
  AND IDE_JAL   = JAL
  AND IDE_ECR   = ECR
  AND nvl(SPEC1,0) = nvl(P_SPEC1,0)  -- MPS 26/06/2006 ajout des 2 NVL --
  AND MT=P_MT
  AND COD_SENS=P_COD_SENS
  AND IDE_LIG<=LIG;
-- MPS 23/06/2006 multiplication du montant par 100 pour enlever la virgule qui perturbe le tri ----
-- MPS et FC 10/05/2007 : LPAD de P_MT  pour permettre tri correct quand montants similaires
-- (ex :50 et 500 euros ayant empêché remontée enregistrements à ACCT )
-- IF P_COD_SENS = 'D'  THEN RETURN POSTE||GEST||JAL||ECR||P_SPEC1||P_MT*100||LPAD(((V_CPT*2)-1),4,0);
-- ELSIF P_COD_SENS='C'  THEN RETURN POSTE||GEST||JAL||ECR||P_SPEC1||P_MT*100||LPAD((V_CPT*2),4,0);
IF P_COD_SENS = 'D'  THEN RETURN POSTE||GEST||JAL||ECR||P_SPEC1||LPAD((P_MT*100),17,0)||LPAD(((V_CPT*2)-1),4,0);
ELSIF P_COD_SENS='C'  THEN RETURN POSTE||GEST||JAL||ECR||P_SPEC1||LPAD((P_MT*100),17,0)||LPAD((V_CPT*2),4,0);


END IF;
END;

/

CREATE OR REPLACE FUNCTION F_SCHEMA_DSO (P_POSTE CHAR,P_GEST CHAR,P_JAL CHAR,P_FLG CHAR,P_ECR NUMBER)
RETURN VARCHAR2
IS
V_IDE_SCHEMA VARCHAR2(15);
BEGIN
SELECT max(IDE_SCHEMA)
INTO V_IDE_SCHEMA
FROM FC_LIGNE
WHERE IDE_POSTE = P_POSTE
AND IDE_GEST = P_GEST
AND IDE_JAL = P_JAL
AND FLG_CPTAB = P_FLG
AND IDE_ECR = P_ECR
AND IDE_SCHEMA like 'DSO%';
--AND IDE_CPT = '90000';
RETURN(V_IDE_SCHEMA);

EXCEPTION
WHEN NO_DATA_FOUND THEN RETURN(NULL);
END;

/

CREATE OR REPLACE FUNCTION GES_LANCER_TRAITEMENT(p_nom_traitement IN VARCHAR2
                                                , p_param IN VARCHAR2 := NULL
                                                , p_nombre_exemplaires IN NUMBER := 1
                                                , p_separateur_param IN VARCHAR2 := ' '
												, p_etat_creation IN VARCHAR2 := 'D'
                                                ) RETURN NUMBER IS
/*
---------------------------------------------------------------------------------------
-- Nom           : GES_LANCER_TRAITEMENT
-- Date creation : 19/01/2000
-- Creee par     : SOFIANE NEKERE (SEMA GROUP)
-- Role          : Lancement d'un traitement par l'intermediaire du lanceur POLY-GF
-- Parametres    : p_nom_traitement  - Nom du traitement a lancer (parametre obligatoire)
--                 p_param           - chaine contenant la liste des parametres a
--                                     soumettre au traitement
--                 p_nombre_exemplaires - nombre d'exemplaires pour les editions
--                                        parametre optionnel, par defaut 1
--                 p_separateur         - caractere de separation des parametres passe
--                                        parametre optionnel, par defaut ' ' (<espace>)
--                                        (voir les remarques ci-dessous)
--
-- Valeurs retournees possibles :
--                  1 - la demande de traitement est soumise au lanceur avec succes (OK)
--                  -1 : Le traitement demande n'est pas connu du lanceur
--                  -2 : Probleme d'obtention d'un numero sequentiel pour le traitement
--                  -3 : Format de specification des parametres non conforme (voir remarques)
--                  -4 : Erreur lors de l'extrcation d'une codification
--                  -5 : Valeur du Parametre "etat de la tache" invalide; p_etat_creation doit être D ou P
-- Remarques importantes:
--                       Format de specification des parametres : les parametres sont mis les uns a la
--                       suite des autres sous forme d'une chaine de caracteres. ils sont separes les uns
--                       des autres d'un caractere appele separateur. Par defaut le separateur est UN espace.
--                       Chaque parametre a la forme : <NomParametre>=<Valeur>
--                       Dans le cas ou le separateur est <ESPACE>, il ne doit pas y avoir d'espace ni avant
--                       ni apres le signe '=', ni nom plus dans le nom ou dans la valeur. Dans le cas ou
--                       ceux-ci peuvent contenir des signes <ESPACE>, il faut utiliser un autre caractere de
--                       separation.
--                       Exemple:
--                         1.     Par defaut
--                                        'P_IDE_GEST=''g1'' P_IDE_POSTE=''P1''' (valide)
--                                        'P_IDE_GEST = ''g1'' P_IDE_POSTE=''P1''' (invalide)
--                                        !------> espace entre = et valeur
--                         2.     Si le separateur est ';' par exemple cela donnera
--                                               'P_IDE_GEST=''g1'';P_IDE_POSTE=''P1''' (valide)
--                                               'P_IDE_GEST =''g 1'';P_IDE_POSTE=''P1''' (valide)
--                                               !----!--> espace entre = et valeur : valide car ' ' n'est pas le seprateur
--                         3.     Si le separateur est '|' par exemple cela donnera
--                                        'P_IDE_GEST=''g1''|P_IDE_POSTE=''P1''' (valide)
--                                        'P_IDE_GEST = ''g1''|P_IDE_POSTE=''P1''' (valide)
--                                        !------> espace entre = et valeur : valide car ' ' n'est pas le seprateur
-- Appels                :
- ---------------------------------------------------------------------------
--  Version        : @(#) GES_LANCER_TRAITEMENT.sql version 2.1-1.1 : SNE : 10/08/2001
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   			|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) GES_LANCER_TRAITEMENT.sql 1.0-1.0	|19/01/2000| SNE| Création
-- @(#) GES_LANCER_TRAITEMENT.sql 2.1-1.1	|07/09/2001| SNE| Ajout de la possibilité de spécifier l'état de la tache
-- @(#) GES_LANCER_TRAITEMENT.sql 2.1-1.2	|11/09/2001| MYI| Ajout de la possibilité de choisir l'imprimente
-- @(#) batch à partir des utilisateurs (FH_UTIL) si elle a été définie, et à partir de la table B_BATCH sinon.
-- @(#) MODIF SGN ANO011 : prise en compte de la taille du separateur.
-- @(#) GES_LANCER_TRAITEMENT.sql 2.2-2.0 |12/02/2002| MYI| Correction de l'ano 138 ( sommation )
---------------------------------------------------------------------------------------
*/
-- v_ligne_batch B_BATCH%ROWTYPE;
 v_num_trt B_TRAITEMENT.NUMTRT%TYPE;
 -- Modif MYI le 12/02/2002  correction de l'ano 138 ( sommation )
 v_user FH_UTIL.COD_UTIL%TYPE := USER ;
 -- Fin modif MYI
 v_site FH_UTIL.Ide_Site%TYPE;
 v_res  Number;
 v_imprimante FH_UTIL.COD_IMPRIM%TYPE;

 CURSOR c_util (P_site FH_UTIL.Ide_Site%TYPE )  IS
 Select Cod_imprim From Fh_util
 where COD_UTIL=USER And
       Ide_Site =P_Site;
 -- Modif MYI le 12/02/2002 : Requetes sous-qualifées
 CURSOR c_batch IS -- (pc_util IN FH_UTIL.IDE_UTIL%TYPE) IS
 SELECT
 		NOMPROG	  	 ,
		LIBPROG      ,
		TYPE         ,
		EXECUTION    ,
		MEDIA_EDT    ,
		NATURE       ,
		EXEC_HEURE   ,
        IMPRIMANTE ,
		ORIENTATION  ,
		COD_FORMAT   ,
		RECTO_VERSO  ,
		SENS_RV      ,
		BAC          ,
		DIR_PROG     ,
		DIR_EDT      ,
		DIR_DEM      ,
		DAT_CRE      ,
		UTI_CRE      ,
		DAT_MAJ      ,
		UTI_MAJ      ,
		TERMINAL
 FROM B_BATCH
 WHERE
 NOMPROG = p_nom_traitement;
 -- Fin modif MYI
 v_position  NUMBER;
 v_1_param   VARCHAR2(255);
 v_param     VARCHAR2(1000);
 v_nom_param VARCHAR2(255);
 v_val_param VARCHAR2(255);
 v_terminal  FH_UTIL.terminal%TYPE;
 v_libl SR_CODIF.libl%TYPE;
 v_codext_L SR_CODIF.cod_codif%TYPE;
 v_codext_P SR_CODIF.cod_codif%TYPE;
 v_ret NUMBER;


/*
Exceptions
*/
Exc_Traitement_Invalide EXCEPTION;
Exc_Lect_Sequence       EXCEPTION;
Exc_Parametre_Invalide  EXCEPTION;
Exc_codext 				EXCEPTION;
Exc_Parameter		 	EXCEPTION;	--SNE, 07/09/2001 : Ajout du controle de l'etat (Demande ou Poste)
/*
Codes retours
*/
Err_Traitement_Invalide CONSTANT NUMBER := -1;
Err_Lect_Sequence       CONSTANT NUMBER := -2;
Err_Parametre_Invalide  CONSTANT NUMBER := -3;
Err_Codext              CONSTANT NUMBER := -4;
Err_Val_Param_Invalide  CONSTANT NUMBER := -5;
cst_Traitement_Ok       CONSTANT NUMBER := 1;

/*
Autres constantes utilisees
*/
cst_Signe_Egal CONSTANT VARCHAR2(01) := '=';
cst_Statut_Demande CONSTANT VARCHAR2(01) := 'D';
cst_Statut_Poste CONSTANT VARCHAR2(01) := 'P';

v_len_pos NUMBER; -- MODIF SGN ANO011
BEGIN
  IF p_etat_creation NOT IN (cst_Statut_Demande, cst_Statut_Poste) THEN
     RAISE Exc_Parameter;
  END IF;
  SELECT NVL(USERENV('TERMINAL'), 'unknown')
  INTO v_terminal
  FROM DUAL;

  EXT_Codext('ORIENTATION','L',v_libl,v_codext_L,v_ret);
  IF v_ret < 1 THEN
     RAISE Exc_codext;
  END IF;
  EXT_Codext('ORIENTATION','P',v_libl,v_codext_P,v_ret);
  IF v_ret < 1 THEN
     RAISE Exc_codext;
  END IF;
  Ext_param('SM0008',v_site , V_res );
  If V_res =  1 Then
	  OPEN c_util (v_site);
	  FETCH c_util INTO v_imprimante ;
	  CLOSE c_util;
	  -- Modif MYI le 12/02/2002 : Requetes sous-qualifées
	  FOR v_ligne_batch  IN c_batch LOOP
	  -- Fin Modif MYI
	  BEGIN
		     SELECT SEQ_B_TRAITEMENT.NEXTVAL INTO v_num_trt FROM DUAL;
		   EXCEPTION
		     WHEN OTHERS THEN
		       RAISE Exc_Lect_Sequence;
		   END;
		   BEGIN
		     INSERT INTO B_TRAITEMENT ( NUMTRT
		                              , NOMPROG
		                              , LIBPROG
		                              , TYPE
		                              , EXECUTION
		                              , MEDIA_EDT
		                              , NATURE
		                              , EXEC_HEURE
		                              , DIR_PROG
		                              , DIR_EDT
		                              , DIR_DEM
		                              , DESTINATAIRE
		                              , IMPRIMANTE
		                              , ORIENTATION
		                              , COPIES
		                              , COD_FORMAT
		                              , RECTO_VERSO
		                              , SENS_RV
		                              , BAC
		                              , CODE_FIN
		                              , LIB_ERREUR
		                              , DAT_CRE
		                              , UTI_CRE
		                              , DAT_MAJ
		                              , UTI_MAJ
		                              , TERMINAL)
		     VALUES ( v_num_trt
		            , p_nom_traitement
		            , v_ligne_batch.LIBPROG
		            , v_ligne_batch.TYPE
		            , v_ligne_batch.EXECUTION
		            , v_ligne_batch.MEDIA_EDT
		            , v_ligne_batch.NATURE
		            , v_ligne_batch.EXEC_HEURE
		            , v_ligne_batch.DIR_PROG
		            , v_ligne_batch.DIR_EDT
		            , v_ligne_batch.DIR_DEM
		            , NULL
		            , NVL(v_imprimante, v_ligne_batch.IMPRIMANTE)	  -- SNE, MYI, 11/09/20001
		            , DECODE(v_ligne_batch.ORIENTATION,'L',v_codext_L,'P',v_codext_P)
		            , p_nombre_exemplaires
		            , v_ligne_batch.COD_FORMAT
		            , v_ligne_batch.RECTO_VERSO
		            , v_ligne_batch.SENS_RV
		            , v_ligne_batch.BAC
		            , p_etat_creation  	  	  -- La tache peut être directement postee, par default elle sera demandee
		            , NULL
		            , SYSDATE
		            , v_user
		            , SYSDATE
		            , v_user
		            , v_terminal
		            );
		   END;
		 /*
		 Traitement des parametres
		 */
		   IF p_param IS NOT NULL THEN
		     /*
		     SNE, 19/01/2000 :
		     ATTENTION -- CAUTION -- ACHTUNG -- ATTENZIONNE -- BRZSKDE -- KRTZEBUD
		     La fonction 'EXT_COMPOSANT_NOM' ne detecte pas le dernier composant
		     si celui-ci n'est suivi d'un separateur
		     */
			 v_len_pos := LENGTH(p_separateur_param); -- MODIF SGN ANO011

		     -- MODIF SGN ANO011 IF SUBSTR(p_param, LENGTH(p_param), 1) != p_separateur_param THEN
			 IF SUBSTR(p_param, LENGTH(p_param)-v_len_pos+1, v_len_pos) != p_separateur_param THEN
		       v_param := p_param || p_separateur_param;
		     ELSE
		       v_param := p_param;
		     END IF;
		     v_position := 1;
		     v_1_param := EXT_COMPOSANT_NOM(v_param, v_position, p_separateur_param, '');
		     WHILE v_1_param IS NOT NULL LOOP
		       v_nom_param := RTRIM(SUBSTR(v_1_param, 1, INSTR(v_1_param, cst_Signe_Egal, 1)-1));
		       v_val_param := LTRIM(SUBSTR(v_1_param, 1+INSTR(v_1_param, cst_Signe_Egal, 1)
		                                            , LENGTH(v_1_param) - INSTR(v_1_param, cst_Signe_Egal, 1) ));
		       IF v_nom_param IS NOT NULL THEN
		         BEGIN
		           INSERT INTO B_PARAMTRT(NUMTRT, INDPAR, NOMPARAM, PARAM, DAT_CRE, UTI_CRE, DAT_MAJ, UTI_MAJ, TERMINAL)
		           VALUES (v_num_trt, v_position, v_nom_param, v_val_param, SYSDATE, USER, SYSDATE, USER, v_terminal);
		         END;
		       ELSE
		         RAISE Exc_Parametre_Invalide;
		       END IF;
		       v_position := v_position +1;
		       v_1_param := LTRIM(EXT_COMPOSANT_NOM(v_param, v_position, p_separateur_param, ''));
		     END LOOP;
		   END IF;   /* p_param IS NOT NULL */
	  END LOOP; 	 /* FOR v_lige IN c_batch(v_user) */
  END IF;
  COMMIT;
  RETURN(cst_Traitement_Ok);
EXCEPTION
  WHEN Exc_Codext THEN
    RETURN(Err_Codext);
  WHEN Exc_Traitement_Invalide THEN
    IF c_batch%ISOPEN THEN
      CLOSE c_batch;
    END IF;
    RETURN(Err_Traitement_Invalide);
  WHEN Exc_Lect_Sequence THEN
    RETURN(Err_Lect_Sequence);
  WHEN Exc_Parameter THEN
    RETURN(Err_Val_Param_Invalide);
  WHEN Exc_Parametre_Invalide THEN
    ROLLBACK;
    RETURN(Err_Parametre_Invalide);
  WHEN OTHERS THEN
    /*
    SNE, 19/01/2000 :Toute autre erreur est remontee telle qu'elle
                     et doit etre prise en charge par l'appelant
    */
    ROLLBACK;
    RAISE;
END GES_LANCER_TRAITEMENT;

/

CREATE OR REPLACE FUNCTION Get_Date_Format RETURN VARCHAR2 IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : MES
-- Nom           : Get_Date_Format
-- ---------------------------------------------------------------------------
--  Auteur         : ---
--  Date creation  : --/--/----
-- ---------------------------------------------------------------------------
-- Role          : Renvoie le format de date applicable en fonction de la langue choisie dans la base
--
-- Parametres    : Aucun
--
-- Valeurs retournees : Format de date
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) Get_Date_Format.sql version 3.0-1.1
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) Get_Date_Format.sql 2.0-1.0	|--/--/----| ---	| Création
-- @(#) Get_Date_Format.sql 3.0-1.1	|10/04/2002| SNE	| Harmonisation des fonctions
-- 	----------------------------------------------------------------------------------------------------------
*/

  FUNCTION Get_Database_Format(v_param NLS_DATABASE_PARAMETERS.parameter%TYPE) RETURN VARCHAR2 IS
    v_value NLS_DATABASE_PARAMETERS.value%TYPE;
  BEGIN
    SELECT value
    INTO v_value
    FROM nls_database_parameters
    WHERE parameter = v_param;

    RETURN (v_value);
  END Get_Database_Format;

  FUNCTION Get_Instance_Format(v_param NLS_DATABASE_PARAMETERS.parameter%TYPE) RETURN VARCHAR2 IS
    v_value NLS_DATABASE_PARAMETERS.value%TYPE;
  BEGIN
    SELECT value
    INTO v_value
    FROM nls_instance_parameters
    WHERE parameter = v_param;

    RETURN (v_value);
  END Get_Instance_Format;

BEGIN

  RETURN ( NVL(Get_Instance_Format('NLS_DATE_FORMAT'), Get_Database_Format('NLS_DATE_FORMAT')) );

EXCEPTION
  WHEN others THEN
    RAISE;
END Get_Date_Format;

/

CREATE OR REPLACE FUNCTION Get_DateTime_Format RETURN VARCHAR2 IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : MES
-- Nom           : Get_DateTime_Format
-- ---------------------------------------------------------------------------
--  Auteur         : ---
--  Date creation  : --/--/----
-- ---------------------------------------------------------------------------
-- Role          : Renvoie le format de date-Heure applicable en fonction de la langue choisie dans la base
--
-- Parametres    : Aucun
--
-- Valeurs retournees : Format de date-Heure
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) Get_DateTime_Format.sql version 3.0-1.1
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) Get_DateTime_Format.sql 2.0-1.0	|--/--/----| ---	| Création
-- @(#) Get_DateTime_Format.sql 3.0-1.1	|17/04/2002| SNE	| Harmonisation des fonctions
-- 	----------------------------------------------------------------------------------------------------------
*/

  FUNCTION Get_Database_Format(v_param NLS_DATABASE_PARAMETERS.parameter%TYPE) RETURN VARCHAR2 IS
    v_value NLS_DATABASE_PARAMETERS.value%TYPE;
  BEGIN
    SELECT value
    INTO v_value
    FROM nls_database_parameters
    WHERE parameter = v_param;

    RETURN (v_value);
  END Get_Database_Format;

  FUNCTION Get_Instance_Format(v_param NLS_DATABASE_PARAMETERS.parameter%TYPE) RETURN VARCHAR2 IS
    v_value NLS_DATABASE_PARAMETERS.value%TYPE;
  BEGIN
    SELECT value
    INTO v_value
    FROM nls_instance_parameters
    WHERE parameter = v_param;

    RETURN (v_value);
  END Get_Instance_Format;

BEGIN

  RETURN ( NVL(Get_Instance_Format('NLS_DATE_FORMAT'), Get_Database_Format('NLS_DATE_FORMAT'))
             || ' ' || NVL(Get_Instance_Format('NLS_TIME_FORMAT'), Get_Database_Format('NLS_TIME_FORMAT')));

EXCEPTION
  WHEN others THEN
    RAISE;
END Get_DateTime_Format;

/

CREATE OR REPLACE FUNCTION GET_STRING_VALUE (
--================================== GET_STRING_VALUE =============================================
--  Sujet    : Cette fonction est chargé d'analyser une chaine de caractère afin de renvoyer
--       la portion désiré dans cette chaine. Ex : pour 5,8,9,0,7. Si je demande a la
--      fonction la 4eme valeur de la chaine en conssidérant le séparateur ',' la fonction
--      me retournera 0.
--  Créé le  : 22/06/2007 par FBT
--====================== HISTORIQUE DES MODIFICATIONS =============================================
--  Date        Version  Aut. Evolution Sujet
--  -----------------------------------------------------------------------------------------------
--  22/06/2007 v4210  FBT Création Création de la fonction pour l'évolution DI44-01-2007
--=================================================================================================
    p_chaine   IN  VARCHAR2,
    p_sep      IN  VARCHAR2,
    p_position IN  INTEGER
) RETURN VARCHAR2
IS
    p_retour 	   		  	VARCHAR2(200) := '';
	p_temp 	   				VARCHAR2(200) := '';
	p_current_position		NUMBER := 1;
BEGIN
	--parcours de la chaine
    FOR i IN 1..LENGTH(p_chaine) LOOP

		--Récupération du caractère en cours
		p_temp := SUBSTR(p_chaine, i, 1 );

		--si il ne s'agit par du caractère de séparation
		IF p_temp <> p_sep THEN
			--si il s'agit de la bonne portion de chaine
			IF p_current_position = p_position THEN
			   p_retour := p_retour || SUBSTR(p_chaine, i, 1);
			END IF;
		ELSE
			--incrementation de la position
			p_current_position := p_current_position +1;
		END IF;

	END LOOP;

    --Retour de fonction
	RETURN p_retour;

EXCEPTION
    WHEN OTHERS THEN
    RETURN 'ERREUR';
END GET_STRING_VALUE;

/

CREATE OR REPLACE FUNCTION MAJ_EX_TEMPO RETURN NUMBER IS
/*
---------------------------------------------------------------------------------------
-- Nom           :  MAJ_EX_TEMPO
-- Date creation : Nov/Dec 2000
-- Creee par     : XXX (SEMA GROUP)
-- Role          : Mise à jour de la table EX_TEMPO
--
-- Parametres    :  Aucun
--
-- Valeur retournee : - 1 - Traitement OK (sans erreur)
--				Autre : Problème
--
-- Appels		 :
-- Version 		 : @(#) 1.0-1
-- Historique 	 : v1.0-0, Nov 2000, XXX : Creation
-- Historique 	 : v1.0-0, 15/12/2000, SNE : Intégration aux scripts de création
---------------------------------------------------------------------------------------
*/

  CURSOR c_all_ligne IS
    SELECT V.ide_entite      Entite,
           V.ide_elem_axe1   Axe1,
           V.ide_elem_axe2   Axe2,
           V.ide_elem_axe3   Axe3,
           V.ide_elem_axe4   Axe4,
           V.ide_elem_axe5   Axe5,
           V.ide_elem_axe6   Axe6,
           V.ide_elem_axe7   Axe7,
           V.mt              Montant,
           A.ide_pere        Pere_Axe3
    FROM ex_valeurs@ASTER_BO V,ex_axe@ASTER_BO A
    WHERE V.ide_entite IN ('DEPENSEC','DEPENSED')
      AND A.ide_entite = V.ide_entite
      AND A.ide_num_axe = 3
      AND A.ide_elem_axe = V.ide_elem_axe3;

  CURSOR c_ligne IS
    SELECT distinct V.ide_elem_axe1   Gestion,
                    V.ide_elem_axe2   Budget,
                    A2.libn1          Lib_Budget,
                    V.ide_elem_axe3   Ligne,
                    A3.libn1          Lib_Ligne
    FROM ex_valeurs@ASTER_BO V, ex_axe@ASTER_BO A2, ex_axe@ASTER_BO A3
    WHERE V.ide_entite = 'DEPENSEC'
      AND A2.ide_entite = 'DEPENSEC'
      AND A2.ide_num_axe = 2
      AND A2.ide_elem_axe = V.ide_elem_axe2
      AND A3.ide_entite = 'DEPENSEC'
      AND A3.ide_num_axe = 3
      AND A3.ide_elem_axe = V.ide_elem_axe3;

  CURSOR c_ligne_c(Pc_Gestion   ex_valeurs.ide_elem_axe1%TYPE,
                   Pc_Budget    ex_valeurs.ide_elem_axe2%TYPE,
                   Pc_Ligne     ex_valeurs.ide_elem_axe3%TYPE) IS
    SELECT ide_elem_axe4   Type_Credit,
           mt              Mt_Credit
    FROM ex_valeurs@ASTER_BO
    WHERE ide_entite = 'DEPENSEC'
      AND ide_elem_axe1 = Pc_Gestion
      AND ide_elem_axe2 = Pc_Budget
      AND ide_elem_axe3 = Pc_Ligne;

  CURSOR c_ligne_d(Pc_Gestion   ex_valeurs.ide_elem_axe1%TYPE,
                   Pc_Budget    ex_valeurs.ide_elem_axe2%TYPE,
                   Pc_Ligne     ex_valeurs.ide_elem_axe3%TYPE) IS
    SELECT ide_elem_axe4   Type_Dep,
           mt              Mt_Dep
    FROM ex_valeurs@ASTER_BO
    WHERE ide_entite = 'DEPENSED'
      AND ide_elem_axe1 = Pc_Gestion
      AND ide_elem_axe2 = Pc_Budget
      AND ide_elem_axe3 = Pc_Ligne;

  CURSOR c_ligne_pere IS
    SELECT distinct V.ide_elem_axe1       Gestion,
                    V.ide_elem_axe2       Budget,
                    A2.libn1              Lib_Budget,
                    A3.ide_elem_axe       Ligne,
                    A3.LIBL2              Lib_Ligne
    FROM ex_tempo_bis@ASTER_BO V, ex_axe@ASTER_BO A2, ex_axe@ASTER_BO A3
	WHERE V.ide_entite = 'DEPENSEC'
      AND A2.ide_entite = 'DEPENSEC'
      AND A2.ide_num_axe = 2
      AND A2.ide_elem_axe = V.ide_elem_axe2
      AND A3.ide_entite = 'DEPENSEC'
      AND A3.ide_num_axe = 3
      AND A3.ide_elem_axe = V.ide_elem_axe3
	  AND A3.FLG_FEUILLE = 'N';

  CURSOR c_ligne_pere_c(Pc_Gestion   ex_valeurs.ide_elem_axe1%TYPE,
                        Pc_Budget    ex_valeurs.ide_elem_axe2%TYPE,
                        Pc_Ligne     ex_valeurs.ide_elem_axe3%TYPE) IS
    SELECT ide_elem_axe4    Type_Credit,
           SUM(NVL(mt,0))   Mt_Credit
    FROM ex_tempo_bis@ASTER_BO
    WHERE ide_entite = 'DEPENSEC'
      AND ide_elem_axe1 = Pc_Gestion
      AND ide_elem_axe2 = Pc_Budget
      AND ide_elem_axe3 IN (SELECT ide_elem_axe
                            FROM ex_axe@ASTER_BO
                            WHERE ide_entite = 'DEPENSEC'
                              AND ide_num_axe = 3
                              AND ide_pere = Pc_Ligne)
    GROUP BY ide_elem_axe4;

  CURSOR c_ligne_pere_d(Pc_Gestion   ex_valeurs.ide_elem_axe1%TYPE,
                        Pc_Budget    ex_valeurs.ide_elem_axe2%TYPE,
                        Pc_Ligne     ex_valeurs.ide_elem_axe3%TYPE) IS
    SELECT ide_elem_axe4    Type_Dep,
           SUM(NVL(mt,0))   Mt_Dep
    FROM ex_tempo_bis@ASTER_BO
    WHERE ide_entite = 'DEPENSED'
      AND ide_elem_axe1 = Pc_Gestion
      AND ide_elem_axe2 = Pc_Budget
      AND ide_elem_axe3 IN (SELECT ide_elem_axe
                            FROM ex_axe@ASTER_BO
                            WHERE ide_entite = 'DEPENSED'
                              AND ide_num_axe = 3
                              AND ide_pere = Pc_Ligne)
    GROUP BY ide_elem_axe4;

  v_gestion            ex_tempo.gestion%TYPE;
  v_budget             ex_tempo.budget%TYPE;
  v_lib_budget         ex_tempo.lib_budget%TYPE;
  v_ligne              ex_tempo.ligne%TYPE;
  v_lib_ligne          ex_tempo.lib_ligne%TYPE;
  v_type_credit        ex_tempo.type_credit%TYPE;
  v_mt_credit          ex_tempo.mt_credit%TYPE;
  v_type_dep           ex_tempo.type_dep%TYPE;
  v_mt_dep             ex_tempo.mt_dep%TYPE;

  v_totmt_credit       ex_tempo.mt_solde%TYPE;
  v_totmt_dep          ex_tempo.mt_dep%TYPE;
  v_tottype_credit     ex_tempo.type_credit%TYPE;
  v_tottype_dep        ex_tempo.type_dep%TYPE;

  v_trouve1            NUMBER;
  v_trouve2            NUMBER;

  PROCEDURE MAJ_EX_TEMPO_BIS(PF_Entite       ex_valeurs.ide_entite%TYPE,
                             PF_Axe1         ex_valeurs.ide_elem_axe1%TYPE,
                             PF_Axe2         ex_valeurs.ide_elem_axe2%TYPE,
                             PF_Axe3         ex_valeurs.ide_elem_axe3%TYPE,
                             PF_Axe4         ex_valeurs.ide_elem_axe4%TYPE,
                             PF_Axe5         ex_valeurs.ide_elem_axe5%TYPE,
                             PF_Axe6         ex_valeurs.ide_elem_axe6%TYPE,
                             PF_Axe7         ex_valeurs.ide_elem_axe7%TYPE,
                             PF_Montant      ex_valeurs.mt%TYPE,
                             PF_Pere_Axe3    ex_axe.ide_pere%TYPE) IS

    v_pere   ex_axe.ide_pere%TYPE;
  BEGIN

    IF PF_Pere_Axe3 IS NOT NULL THEN

      SELECT ide_pere INTO v_pere
      FROM ex_axe@ASTER_BO
      WHERE ide_entite = PF_Entite
        AND ide_num_axe = 3
        AND ide_elem_axe =  PF_Pere_Axe3;

      MAJ_EX_TEMPO_BIS(PF_Entite,PF_Axe1,PF_Axe2,PF_Pere_Axe3,PF_Axe4,PF_Axe5,PF_Axe6,PF_Axe7,
                       PF_Montant,v_pere);
    END IF;

    INSERT INTO ex_tempo_bis@ASTER_BO
      (ide_entite,ide_elem_axe1,ide_elem_axe2,ide_elem_axe3,ide_elem_axe4,ide_elem_axe5,
       ide_elem_axe6,ide_elem_axe7,mt)
    VALUES
      (PF_Entite,PF_Axe1,PF_Axe2,PF_Axe3,PF_Axe4,PF_Axe5,PF_Axe6,PF_Axe7,PF_Montant);

  END MAJ_EX_TEMPO_BIS;

BEGIN

  -- Vidage tables travails
  -------------------------
  DELETE FROM ex_tempo@ASTER_BO;
  DELETE FROM ex_tempo_bis@ASTER_BO;


  -- Remplissage table travail ex_tempo_bis
  -----------------------------------------
  FOR l_all_ligne IN c_all_ligne
  LOOP
    MAJ_EX_TEMPO_BIS(l_all_ligne.Entite,l_all_ligne.Axe1,l_all_ligne.Axe2,l_all_ligne.Axe3,
                     l_all_ligne.Axe4,l_all_ligne.Axe5,l_all_ligne.Axe6,l_all_ligne.Axe7,
                     l_all_ligne.Montant,l_all_ligne.Pere_Axe3);
  END LOOP;


  -- Recherche des libelles
  -------------------------
  SELECT SUBSTR(libl,1,30) INTO v_tottype_credit
  FROM ex_libelle@ASTER_BO
  WHERE ide_entite = 'DEPENSE'
    AND ide_code = 'TOTC';

  SELECT SUBSTR(libl,1,30) INTO v_tottype_dep
  FROM ex_libelle@ASTER_BO
  WHERE ide_entite = 'DEPENSE'
    AND ide_code = 'DEPN';


  -- Remplissage niveau 1 + niveau 2
  ----------------------------------

  FOR l_ligne IN c_ligne
  LOOP

    v_gestion := l_ligne.Gestion;
    v_budget := l_ligne.Budget;
    v_lib_budget := l_ligne.Lib_Budget;
    v_ligne := l_ligne.Ligne;
    v_lib_ligne := l_ligne.Lib_Ligne;

    -- Ouverture des curseurs
    OPEN c_ligne_c(v_gestion,v_budget,v_ligne);
    OPEN c_ligne_d(v_gestion,v_budget,v_ligne);

    -- Initialisation des cumuls
    v_totmt_credit := 0;
    v_totmt_dep    := 0;

    LOOP

      v_trouve1 := 1;
      FETCH c_ligne_c INTO v_type_credit,v_mt_credit;
      IF c_ligne_c%NOTFOUND THEN
        v_trouve1 := 0;
        v_type_credit := NULL;
        v_mt_credit := NULL;
      END IF;

      v_trouve2 := 1;
      FETCH c_ligne_d INTO v_type_dep,v_mt_dep;
      IF c_ligne_d%NOTFOUND THEN
        v_trouve2 := 0;
        v_type_dep := NULL;
        v_mt_dep := NULL;
      END IF;

      EXIT WHEN v_trouve1 = 0 AND v_trouve2 = 0;

      -- Insertion niveau 1 = ligne
      INSERT INTO ex_tempo@ASTER_BO
        (gestion,budget,lib_budget,cod_ligne,ligne,lib_ligne,
         type_credit,mt_credit,type_dep,mt_dep,mt_solde)
      VALUES
        (v_gestion,v_budget,v_lib_budget,RPAD(v_ligne,30,'9'),v_ligne,v_lib_ligne,
         v_type_credit,v_mt_credit,v_type_dep,v_mt_dep,NULL);

      -- Maj des cumuls
      v_totmt_credit := v_totmt_credit + NVL(v_mt_credit,0);
      IF v_type_dep = '1OD' THEN
        v_totmt_dep := v_totmt_dep + NVL(v_mt_dep,0);
      ELSIF v_type_dep = '2AD' THEN
        v_totmt_dep := v_totmt_dep - NVL(v_mt_dep,0);
      END IF;

    END LOOP;

    -- Fermeture des curseurs
    CLOSE c_ligne_c;
    CLOSE c_ligne_d;

    -- Insertion niveau 2 = total ligne
    INSERT INTO ex_tempo@ASTER_BO
      (gestion,budget,lib_budget,cod_ligne,ligne,lib_ligne,
       type_credit,mt_credit,type_dep,mt_dep,
       mt_solde)
    VALUES
      (v_gestion,v_budget,v_lib_budget,RPAD(v_ligne,30,'9'),v_ligne,v_lib_ligne,
       v_tottype_credit,v_totmt_credit,v_tottype_dep,v_totmt_dep,
       NVL(v_totmt_credit,0) - NVL(v_totmt_dep,0));

  END LOOP;
/* ****************************************************************************************** */


  -- Remplissage niveau 3 + niveau 4
  ----------------------------------

  FOR l_ligne_pere IN c_ligne_pere
  LOOP

    v_gestion := l_ligne_pere.Gestion;
    v_budget := l_ligne_pere.Budget;
    v_lib_budget := l_ligne_pere.Lib_Budget;
    v_ligne := l_ligne_pere.Ligne;
    v_lib_ligne := l_ligne_pere.Lib_Ligne;

    -- Ouverture des curseurs
    OPEN c_ligne_pere_c(v_gestion,v_budget,v_ligne);
    OPEN c_ligne_pere_d(v_gestion,v_budget,v_ligne);

    -- Initialisation des cumuls
    v_totmt_credit := 0;
    v_totmt_dep    := 0;

    LOOP

      v_trouve1 := 1;
      FETCH c_ligne_pere_c INTO v_type_credit,v_mt_credit;
      IF c_ligne_pere_c%NOTFOUND THEN
        v_trouve1 := 0;
        v_type_credit := NULL;
        v_mt_credit := NULL;
      END IF;

      v_trouve2 := 1;
      FETCH c_ligne_pere_d INTO v_type_dep,v_mt_dep;
      IF c_ligne_pere_d%NOTFOUND THEN
        v_trouve2 := 0;
        v_type_dep := NULL;
        v_mt_dep := NULL;
      END IF;

      EXIT WHEN v_trouve1 = 0 AND v_trouve2 = 0;

      -- Insertion niveau 3 = ligne pere
      INSERT INTO ex_tempo@ASTER_BO
        (gestion,budget,lib_budget,cod_ligne,ligne,lib_ligne,
         type_credit,mt_credit,type_dep,mt_dep,mt_solde)
      VALUES
        (v_gestion,v_budget,v_lib_budget,RPAD(v_ligne,30,'9'),v_ligne,v_lib_ligne,
         v_type_credit,v_mt_credit,v_type_dep,v_mt_dep,NULL);

      -- Maj des cumuls
      v_totmt_credit := v_totmt_credit + NVL(v_mt_credit,0);
      IF v_type_dep = '1OD' THEN
        v_totmt_dep := v_totmt_dep + NVL(v_mt_dep,0);
      ELSIF v_type_dep = '2AD' THEN
        v_totmt_dep := v_totmt_dep - NVL(v_mt_dep,0);
      END IF;

    END LOOP;

    -- Fermeture des curseurs
    CLOSE c_ligne_pere_c;
    CLOSE c_ligne_pere_d;

    -- Insertion niveau 4 = total ligne pere
    INSERT INTO ex_tempo@ASTER_BO
      (gestion,budget,lib_budget,cod_ligne,ligne,lib_ligne,
       type_credit,mt_credit,type_dep,mt_dep,
       mt_solde)
    VALUES
      (v_gestion,v_budget,v_lib_budget,RPAD(v_ligne,30,'9'),v_ligne,v_lib_ligne,
       v_tottype_credit,v_totmt_credit,v_tottype_dep,v_totmt_dep,
       NVL(v_totmt_credit,0) - NVL(v_totmt_dep,0));

  END LOOP;
/* ****************************************************************************************** */


  -- Validation des insertions
  ----------------------------
  Commit;

  Return(1);


EXCEPTION
  WHEN Others THEN
    Rollback;
    Return(0);

END MAJ_EX_TEMPO;

/

CREATE OR REPLACE FUNCTION MAJ_SPEC1_D411(P_ide_poste CHAR,P_ide_gest CHAR, p_ide_jal CHAR, p_ide_ecr NUMBER , p_ide_lig NUMBER)
RETURN CHAR
IS
-------------------------
-- Fonction créée le 06/12/2004 par MPS --
-- récupère la spec1 des débits 411 absente lors de la prise en charge des OR --
------------------------

v_spec1 VARCHAR2(30);

BEGIN

select max(ide_lig_exec) into v_spec1
from fc_ligne
where ide_cpt like '3%'
and cod_sens = 'C'
and ide_jal = p_ide_jal
and ide_ecr = p_ide_ecr
and ide_lig != p_ide_lig
and ide_gest = p_ide_gest
and ide_poste = p_ide_poste
and flg_cptab = 'O';

return(v_spec1);

END MAJ_SPEC1_D411;

/

CREATE OR REPLACE FUNCTION Maj_Tc_List_Postes (
                                              p_ide_poste          IN RM_POSTE.ide_poste%TYPE,
											  p_ide_gest           IN FN_GESTION.ide_gest%TYPE,
                                              p_num_trt_report     IN NUMBER,
											  p_lib_err            IN OUT CHAR
										      )
RETURN NUMBER IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : CGE
-- Nom           : MAJ_TC_LIST_POSTES
-- ---------------------------------------------------------------------------
--  Auteur         : LGD
--  Date creation  : 16/10/2003
-- ---------------------------------------------------------------------------
-- Role          :
--
-- Parametres  entree  :
-- 				 1 - p_ide_poste : Poste utilisateur
--				 2 - p_ide_gest : Gestion du contexte
--               3 - p_num_trt_report : Numéro de traitement du report
--
--
-- Valeur  retournée en sortie :
--                              0 => MAJ OK : INSERT dans TC_LIST_POSTES OK
--				                1 => MAJ OK : Pas d'INSERT dans TC_LIST_POSTES car, il n'y a pas de poste subordonnés
--                             -1 => MAJ KO :
--
-- ---------------------------------------------------------------------------
--  Version        : @(#) MAJ_TC_LIST_POSTES.sql version 2.2-1.0
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) MAJ_TC_LIST_POSTES 2.2-1.0	|13/05/2003| LGD	| Initialisation
-- 	----------------------------------------------------------------------------------------------------------
*/

		v_min         BINARY_INTEGER;
		v_max         BINARY_INTEGER;

		v_ret NUMBER;
        v_libl SR_CODIF.libl%TYPE;
        v_val_cod_ext_clot SR_CODIF.cod_codif%TYPE;
		v_val_cod_ext_non  SR_CODIF.cod_codif%TYPE;
		v_datmaj VARCHAR2(30);
		v_test_subordo BOOLEAN :=FALSE;

		-- Definition tableau de sauvagarde des postes comptables à traiter
	TYPE rec_postes IS RECORD
		(
		num_trt_report           NUMBER,
		poste                    RM_NOEUD.ide_nd%TYPE,
		dat_dern_jc             DATE
		 );

		TYPE tab_postes IS TABLE OF rec_postes INDEX BY BINARY_INTEGER;
		v_tab_postes tab_postes;
		i    BINARY_INTEGER;
		j    BINARY_INTEGER;
		v_i_courant    BINARY_INTEGER;



           CURSOR c_poste_site (p_poste_1 RM_POSTE.ide_poste%TYPE) IS
			SELECT p.ide_poste poste, np.cod_typ_nd code_type, np.ide_site site
			FROM RM_POSTE p, RM_NOEUD np
			WHERE p.ide_poste_centra = p_poste_1
			AND   p.ide_poste = np.ide_nd
			AND   p.cod_typ_nd = np.cod_typ_nd
			AND p.ide_poste !=GLOBAL.ide_poste
			AND p.ide_poste !=p_poste_1;

	BEGIN


		Ext_Codext('STATUT_JOURNEE','C',v_libl,v_val_cod_ext_clot,v_ret);
	    IF v_ret=-1 OR v_ret=2 THEN
	      --- Impossible de faire le contrôle de renumérotation
		  p_lib_err :='STATUT_JOURNEE';
		  RETURN(-1);
		END IF;

	    Ext_Codext('OUI_NON','N',v_libl,v_val_cod_ext_non,v_ret);
	    IF v_ret=-1 OR v_ret=2 THEN
	      --- Impossible de faire le contrôle de renumérotation
		  p_lib_err :='OUI_NON';
		  RETURN(-1);
		END IF;

		i := 0 ;

		/* Alimentation du poste administrateur et des postes du site  */
		FOR c_row_poste_site IN c_poste_site(p_ide_poste) LOOP
			--v_test_subordo :=TRUE;
			i := i + 1;
			v_tab_postes(i).poste                    := c_row_poste_site.poste ;
		END LOOP;


		--IF v_test_subordo =TRUE THEN

			/* Alimentation des postes hiérarchiquement dépendants de chaque poste du site  */
	        j := 0 ;


			WHILE j < i LOOP
				j := j + 1 ;
				v_min := j ;
				v_max := i ;


				FOR indice IN v_min..v_max LOOP

					/* préparation curseur des postes dépendants du poste en cours (j)  */
					FOR c_row_poste_site IN c_poste_site(v_tab_postes(indice).poste) LOOP
							/* ajout de la ligne dans le tableau pour indice i   */
							i := i + 1 ;
							v_tab_postes(i).poste                    := c_row_poste_site.poste ;
					END LOOP;
					/* mise à niveau  indice j  */
					j := indice ;


				END LOOP ;


			END LOOP ;

		 i := i + 1 ;
	     v_tab_postes(i).poste                    := GLOBAL.ide_poste ;

		/* Affichage tableau résultat   */
			FOR indice IN 1..i LOOP
	          ---Dbms_Output.Put_Line('AU FINAL '||v_tab_postes(indice).poste);

	    	  BEGIN

				SELECT TO_CHAR(MAX(dat_JC))
			    	INTO v_datmaj
				 FROM FC_CALEND_HIST
				 WHERE ide_poste = v_tab_postes(indice).poste
			       AND ide_gest = p_ide_gest
			       AND cod_ferm = v_val_cod_ext_clot;

			  IF v_datmaj IS NULL THEN
			    v_datmaj :='00/00/0000';
			  END IF;


			  EXCEPTION

			  WHEN OTHERS THEN
			    RAISE;
			  END;

			  --- MAJ de TC_LIST_POSTES
			  INSERT INTO TC_LIST_POSTES (ide_num_trt,
			                              ide_poste,
										  dat_dern_jc,
										  flg_selec)
								VALUES(   p_num_trt_report,
								 	      v_tab_postes(indice).poste,
									      v_datmaj,
										  'O'
									  );

			END LOOP;


		  --- TRT OK, TC_LIST_POSTES MAJ
		  COMMIT;
		  RETURN(0);
		--ELSE
		  --- Pas de poste subordonnée.
		--  RETURN(1);

		--END IF;
EXCEPTION

  WHEN OTHERS THEN
    RAISE;
END Maj_Tc_List_Postes;

/

CREATE OR REPLACE FUNCTION PIAF_appel_systeme(cmd IN CHAR, fic_sortie IN VARCHAR2 := ''
						, fic_erreur IN VARCHAR2 := '')
  RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "PIAF_appel_systeme"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION PIAF_ecrit_fichier(param IN CHAR
								, fic_sortie IN CHAR
								, p_mode IN CHAR := 'at+'
								, p_type_ecriture IN CHAR := 'L'
								, p_type_trace IN CHAR := 'I')
  RETURN BINARY_INTEGER
	AS EXTERNAL LIBRARY PIAF_system
		    NAME "PIAF_ecrit_fichier"
		    LANGUAGE C;

/

CREATE OR REPLACE FUNCTION U212_210B(P_IDE_POSTE      IN        rm_poste.ide_poste%TYPE,
                                     P_IDE_GEST       IN        fn_gestion.ide_gest%TYPE,
                                     P_DAT_JC_REP     IN        fc_ecriture.dat_jc%TYPE,
                                     P_IDE_GEST_REP   IN        fn_gestion.ide_gest%TYPE,
                                     P_DAT_JC_BE      IN        fc_ecriture.dat_jc%TYPE,
                                     P_TYP_TRT_REP    IN        VARCHAR2) RETURN NUMBER IS

/*
-- ---------------------------------------------------------------------------
--  Fichier        : U212_210B.sql
--
--  Logiciel       : ASTER
--  sous-systeme   : Base
--  Description    : Génération d'écriture de balance d'entrée
--
--   parametres entree :
--     1- P_IDE_POSTE    : poste comptable
--     2- P_IDE_GEST     : gestion à reprendre
--     3- P_DAT_JC_REP   : journee comptable de reprise
--     4- P_IDE_GEST_REP : gestion de reprise
--     5- P_DAT_JC_BE    : journée comptable pour ecriture balance entrée
--     6- P_TYP_TRT_REP  : Type de reprise (Définitive ou Partielle)
--
--   parametres sortie :
--     1-  0  Pas d'erreur
--     2-  -1 Erreur
-- ---------------------------------------------------------------------------
--  Auteur         : LMA
--  Date création  : 03/08/2000
-- ---------------------------------------------------------------------------
--  Version        : @(#) U212_210B.sql  version 3.0e-1.6
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					    	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#)U212_210B.sql  1.1-1.0	 |03/08/2000 | LMA	| Création
-- @(#)U212_210B.sql  1.1-1.1    |20/09/2000 | LGD   | Maj : Date ecriture FC_LIGNE = celle FC_ECRITURE
-- @(#)U212_210B.sql  3.0-1.0	 |01/02/2002 | SGN	| FCT38 V3.0 : Pour les lignes gérés en comptabilité
-- @(#)U212_210B.sql                                  auxiliaires, la balance reprendra une ligne d ecriture
-- @(#)U212_210B.sql                                  par compte auxiliaire non soldé.
-- @(#)U212_210B.sql  3.0-1.1	 |11/04/2002 | SGN	| FCT48 : Ajout des informations devises lors de la generation
-- @(#)U212_210B.sql                                  des ecritures de BE, desormais on a un cumul par devise et par compte auxiliaire
-- @(#)U212_210B.sql                                  non soldé. + prise en compte des variables ASTER pour la gestion des trace
-- @(#)U212_210B.sql  3.0-1.2	 |17/04/2002 | SGN	| FCT48 : Tous les messages de trace envoyés sont initialisés avec un niveau à 1
-- @(#)U212_210B.sql  3.0-1.3    |25/11/2002 | SGN	| ANOVA136 : Prise en compte correcte des devises pour les comptes normaux (non suivi par piece).
-- @(#)U212_210B.sql  3.0d-1.6   |30/01/2003 | LGD	| ANOVAV3262 : Prise en compte du nombre de déciamles pour les montants en devise de référence
-- @(#)U212_210B.sql  3.0e-1.6   |27/03/2003 | SGN	| ANOVA303 : Prise en compte des devises pour la jointure avec FC_REF_PIECE lors de la recup des lignes avec reference piece
-- @(#)U212_210B.sql  4250       |06/03/2008 |FBT 	| Evolution DI44-2007-10 - Controle des soldes réèls des comptes vis à vis du cod_sens_solde_fg
-- ---------------------------------------------------------------------------
*/


-------------------------------
-- Définition des Exceptions --
-------------------------------
  Erreur_Codext         EXCEPTION;
  Erreur_Controle       EXCEPTION;
  Erreur_Traitement     EXCEPTION;
  Erreur_PARAM          EXCEPTION; -- MODIF SGN ANOVA303


---------------------------------------
-- Définition des Variables Globales --
---------------------------------------
  v_retour             NUMBER;
  v_libl               sr_codif.libl%TYPE;
  v_codcodif           sr_codif.cod_codif%TYPE;
  v_statut_journee_O   sr_codif.cod_codif%TYPE;
  v_statut_journee_C   sr_codif.cod_codif%TYPE;
  v_oui                sr_codif.cod_codif%TYPE;
  v_non                sr_codif.cod_codif%TYPE;
  v_sens_debit         sr_codif.cod_codif%TYPE;
  v_sens_credit        sr_codif.cod_codif%TYPE;
  v_trtrepsl           sr_codif.cod_codif%TYPE;
  v_modrepsl_D         sr_codif.cod_codif%TYPE;
  v_modrepsl_P         sr_codif.cod_codif%TYPE;
  v_statut_ecr_C       sr_codif.cod_codif%TYPE;
  v_typposte           rm_poste.ide_typ_poste%TYPE;
  v_varcpta            fn_gestion.var_cpta%TYPE;
  v_varcptarep         fn_gestion.var_cpta%TYPE;
  v_journalrep         sr_cpt_trt.ide_jal%TYPE;
  v_schemarep          sr_cpt_trt.ide_schema%TYPE;
  v_codtypschemarep    rc_schema_cpta.cod_typ_schema%TYPE;
  v_modeleliggenrep    sr_cpt_trt.ide_modele_lig_gen%TYPE;
  v_modeleligcntrep    sr_cpt_trt.ide_modele_lig_cnt%TYPE;
  v_comptecntrep       sr_cpt_trt.ide_cpt_cnt%TYPE;
  v_datdvalgestrep     fn_gestion.dat_dval%TYPE;
  v_libnecrrep         fc_ecriture.libn%TYPE;
  v_datejour           DATE := SYSDATE;
  v_ctltraitement      NUMBER;

  v_niveau_trace       NUMBER;  -- MODIF SGN FCT48 : Ajout trace
  v_num_trt            NUMBER;  -- MODIF SGN FCT48 : Ajout trace

  v_montant_arrondi    NUMBER;  -- MODIF LGD ANOVAV3 262

  -- MODIF SGN ANOVA303
  v_codint_devise_ref  SR_CODIF.ide_codif%TYPE;
  v_codext_devise_ref  SR_CODIF.cod_codif%TYPE;
  v_libl_dev           SR_CODIF.libl%TYPE;
  -- fin modif sgn

------------------------------
-- Définition des Fonctions --
------------------------------
/* *************** */
/* Procedure Trace */
/* *************** */
PROCEDURE Trace(PF_Message    IN    VARCHAR2) IS
BEGIN
  AFF_TRACE('U212_210B', 1, NULL, PF_message);  -- MODIF FCT48 du 17/04/2002 SGN : on place le niveau de trace de tous les messages envoyé a 1
END Trace;

/* *************************************************** */
/* Fonction de controle des paramètres avant execution */
/* *************************************************** */
FUNCTION CTL_Reprise(PF_Poste              IN        rm_poste.ide_poste%TYPE,
                     PF_Gestion            IN        fn_gestion.ide_gest%TYPE,
                     PF_Gestion_REP        IN        fn_gestion.ide_gest%TYPE,
                     PF_JC_REP             IN        fc_ecriture.dat_jc%TYPE,
                     PF_JC_BE              IN        fc_ecriture.dat_jc%TYPE,
                     PF_Journee_C          IN        fc_calend_hist.cod_ferm%TYPE,
                     PF_Journee_O          IN        fc_calend_hist.cod_ferm%TYPE,
                     PF_Trtrepsl           IN        sr_cpt_trt.cod_traitement%TYPE,
                     PF_Non                IN        fc_journal.flg_be%TYPE,
                     PF_Modrepsl           IN        VARCHAR2,
                     PF_Modrepsl_P         IN        fc_trt_hist.mod_rep%TYPE,
                     PF_Modrepsl_D         IN        fc_trt_hist.mod_rep%TYPE,
                     PF_Typposte           IN OUT    rm_poste.ide_typ_poste%TYPE,
                     PF_Varcpta            IN OUT    fn_gestion.var_cpta%TYPE,
                     PF_Varcptarep         IN OUT    fn_gestion.var_cpta%TYPE,
                     PF_Datdvalgestrep     IN OUT    fn_gestion.var_cpta%TYPE,
                     PF_Journalrep         IN OUT    sr_cpt_trt.ide_jal%TYPE,
                     PF_Schemarep          IN OUT    sr_cpt_trt.ide_schema%TYPE,
                     PF_Codtypschemarep    IN OUT    rc_schema_cpta.cod_typ_schema%TYPE,
                     PF_Modeleliggenrep    IN OUT    sr_cpt_trt.ide_modele_lig_gen%TYPE,
                     PF_Modeleligcntrep    IN OUT    sr_cpt_trt.ide_modele_lig_cnt%TYPE,
                     PF_Comptecntrep       IN OUT    sr_cpt_trt.ide_cpt_cnt%TYPE) RETURN NUMBER IS

  CURSOR cur_fn_gestion(PC_Gestion   fn_gestion.ide_gest%TYPE,
                        PC_Datdval   fn_gestion.dat_dval%TYPE) IS
    SELECT ide_gest,dat_dval,dat_fval,var_cpta
    FROM fn_gestion
    WHERE (PC_Gestion IS NOT NULL AND ide_gest = PC_Gestion)
      OR  (PC_Datdval IS NOT NULL AND dat_dval >= TRUNC(PC_Datdval))
    ORDER BY dat_dval;

  CURSOR cur_fc_calend_hist(PC_Poste     fc_calend_hist.ide_poste%TYPE,
                            PC_Gestion   fc_calend_hist.ide_gest%TYPE,
                            PC_Datjc     fc_calend_hist.dat_jc%TYPE) IS
    SELECT cod_ferm
    FROM fc_calend_hist
    WHERE ide_poste = PC_Poste
      AND ide_gest = PC_Gestion
      AND TRUNC(dat_jc) = TRUNC(PC_Datjc);

  CURSOR cur_sr_cpt_trt(PC_Poste           rm_poste.ide_poste%TYPE,
                        PC_Codtraitement   sr_cpt_trt.cod_traitement%TYPE,
                        PC_Varcpta         sr_cpt_trt.var_cpta%TYPE) IS
    SELECT t.ide_typ_poste,t.ide_jal,t.ide_schema,s.cod_typ_schema,
           t.ide_modele_lig_gen,t.ide_modele_lig_cnt,t.ide_cpt_cnt
    FROM sr_cpt_trt t,rm_poste p,rc_schema_cpta s
    WHERE t.ide_typ_poste = p.ide_typ_poste
      AND s.var_cpta = t.var_cpta
      AND s.ide_jal = t.ide_jal
      AND s.ide_schema = t.ide_schema
      AND p.ide_poste = PC_Poste
      AND t.cod_traitement = PC_Codtraitement
      AND t.var_cpta = PC_Varcpta;

  CURSOR cur_fc_journal(PC_Varcpta   fc_journal.var_cpta%TYPE,
                        PC_Idejal    fc_journal.ide_jal%TYPE) IS
    SELECT flg_repsolde,flg_be
    FROM fc_journal
    WHERE var_cpta = PC_Varcpta
      AND ide_jal = PC_Idejal;

  CURSOR cur_fc_trt_hist(PC_Poste           fc_trt_hist.ide_poste%TYPE,
                         PC_Gestion         fc_trt_hist.ide_gest%TYPE,
                         PC_Codtraitement   fc_trt_hist.cod_traitement%TYPE,
                         PC_Modrepsl_D      fc_trt_hist.mod_rep%TYPE) IS
    SELECT count(*) Nb_Repsld
    FROM fc_trt_hist
    WHERE ide_poste = PC_Poste
      AND ide_gest = PC_Gestion
      AND cod_traitement = PC_Codtraitement
      AND mod_rep = PC_Modrepsl_D;

  CURSOR cur_sm_som_cadcar(PC_Poste     sm_som_cadcar.ide_poste%TYPE,
                           PC_Gestion   sm_som_cadcar.ide_gest%TYPE) IS
    SELECT count(*) Nb_Clotgest
    FROM sm_som_cadcar
    WHERE ide_poste = PC_Poste
      AND ide_gest = PC_Gestion;

  v_datfval       fn_gestion.dat_fval%TYPE;
  v_codferm       fc_calend_hist.cod_ferm%TYPE;
  v_flgrepsolde   fc_journal.flg_repsolde%TYPE;
  v_flgbe         fc_journal.flg_be%TYPE;
  v_nbrepsld      NUMBER;
  v_nbclotgest    NUMBER;
  v_idegest       fn_gestion.ide_gest%TYPE;

BEGIN
  -- Date jc reprise >= dat_fval gestion a reprendre
  --------------------------------------------------
  v_datfval  := NULL;
  PF_Varcpta := NULL;
  FOR row1 IN cur_fn_gestion(PF_Gestion,NULL)
  LOOP
    PF_Varcpta := row1.var_cpta;
    v_datfval  := row1.dat_fval;
    Exit;
  END LOOP;

  IF v_datfval IS NULL THEN
    AFF_MESS('E',616,'U212_210B',PF_Gestion,'','');
    Return(-1);
  ELSIF TRUNC(v_datfval) > TRUNC(PF_JC_REP) THEN
    AFF_MESS('E',617,'U212_210B','','','');
    Return(-1);
  END IF;

  -- Date jc reprise doit etre close
  ----------------------------------
  v_codferm := NULL;
  FOR row2 IN cur_fc_calend_hist(PF_Poste,PF_Gestion,PF_JC_REP)
  LOOP
    v_codferm := row2.cod_ferm;
    Exit;
  END LOOP;

  IF v_codferm IS NULL OR v_codferm != PF_Journee_C THEN
    AFF_MESS('E',618,'U212_210B','','','');
    Return(-1);
  END IF;

  -- Date jc BE doit etre ouverte
  -------------------------------
  v_codferm := NULL;
  FOR row3 IN cur_fc_calend_hist(PF_Poste,PF_Gestion_REP,PF_JC_BE)
  LOOP
    v_codferm := row3.cod_ferm;
    Exit;
  END LOOP;

  IF v_codferm IS NULL OR v_codferm != PF_Journee_O THEN
    AFF_MESS('E',619,'U212_210B','','','');
    Return(-1);
  END IF;

  -- Recup et controle journal reprise
  ------------------------------------
  PF_Varcptarep     := NULL;
  PF_Datdvalgestrep := NULL;
  FOR row4 IN cur_fn_gestion(PF_Gestion_REP,NULL)
  LOOP
    PF_Varcptarep     := row4.var_cpta;
    PF_Datdvalgestrep := row4.dat_dval;
    Exit;
  END LOOP;

  IF PF_Varcptarep IS NULL THEN
    AFF_MESS('E',616,'U212_210B',PF_Gestion_REP,'','');
    Return(-1);
  END IF;

  PF_Typposte        := NULL;
  PF_Journalrep      := NULL;
  PF_Schemarep       := NULL;
  PF_Codtypschemarep := NULL;
  PF_Modeleliggenrep := NULL;
  PF_Modeleligcntrep := NULL;
  PF_Comptecntrep    := NULL;
  FOR row5 IN cur_sr_cpt_trt(PF_Poste,PF_Trtrepsl,PF_Varcptarep)
  LOOP
    PF_Typposte        := row5.ide_typ_poste;
    PF_Journalrep      := row5.ide_jal;
    PF_Schemarep       := row5.ide_schema;
    PF_Codtypschemarep := row5.cod_typ_schema;
    PF_Modeleliggenrep := row5.ide_modele_lig_gen;
    PF_Modeleligcntrep := row5.ide_modele_lig_cnt;
    PF_Comptecntrep    := row5.ide_cpt_cnt;
    Exit;
  END LOOP;

  IF PF_Journalrep IS NULL THEN
    AFF_MESS('E',620,'U212_210B','','','');
    Return(-1);
  END IF;

  v_flgrepsolde := NULL;
  v_flgbe       := NULL;
  FOR row6 IN cur_fc_journal(PF_Varcptarep,PF_Journalrep)
  LOOP
    v_flgrepsolde := row6.flg_repsolde;
    v_flgbe       := row6.flg_be;
    Exit;
  END LOOP;

  IF v_flgbe IS NULL OR (v_flgbe = PF_Non AND v_flgrepsolde = PF_Non) THEN
    AFF_MESS('E',621,'U212_210B','','','');
    Return(-1);
  END IF;

  -- Pas de traitement definitif deja effectue
  --------------------------------------------
  IF PF_Modrepsl = PF_Modrepsl_P THEN
    v_nbrepsld := 0;
    FOR row7 IN cur_fc_trt_hist(PF_Poste,PF_Gestion,PF_Trtrepsl,PF_Modrepsl_D)
    LOOP
      v_nbrepsld := row7.Nb_Repsld;
      Exit;
    END LOOP;

    IF NVL(v_nbrepsld,0) != 0 THEN
      AFF_MESS('E',622,'U212_210B','','','');
      Return(-1);
    END IF;
  END IF;

  -- Controle gestion de reprise
  ------------------------------
  v_idegest := NULL;
  FOR row8 IN cur_fn_gestion(NULL,v_datfval)
  LOOP
    v_idegest := row8.ide_gest;
    Exit;
  END LOOP;

  IF v_idegest IS NULL OR PF_Gestion_REP != v_idegest THEN
    AFF_MESS('E',623,'U212_210B','','','');
    Return(-1);
  END IF;

  v_nbclotgest := 0;
  FOR row9 IN cur_sm_som_cadcar(PF_Poste,PF_Gestion_REP)
  LOOP
    v_nbclotgest := row9.Nb_Clotgest;
    Exit;
  END LOOP;

  IF NVL(v_nbclotgest,0) != 0 THEN
    AFF_MESS('E',623,'U212_210B','','','');
    Return(-1);
  END IF;

  -- Controle OK
  --------------
  Return(0);


EXCEPTION
  WHEN Others THEN
    AFF_MESS('E',105,'U212_210B',SUBSTR('(CTL_Reprise) '||SQLERRM,1,80),'','');
    Return(-1);

END CTL_Reprise;

/* **************************************** */
/* Fonction de creation ecriture de reprise */
/* **************************************** */
FUNCTION MAJ_Ecriture_REP(PF_Poste          IN        fc_ecriture.ide_poste%TYPE,
                          PF_Gestion_REP    IN        fc_ecriture.ide_gest%TYPE,
                          PF_Journalrep     IN        fc_ecriture.ide_jal%TYPE,
                          PF_Oui            IN        fc_ecriture.flg_cptab%TYPE,
                          PF_JC_BE          IN        fc_ecriture.dat_jc%TYPE,
                          PF_Varcptarep     IN        fc_ecriture.var_cpta%TYPE,
                          PF_Schemarep      IN        fc_ecriture.ide_schema%TYPE,
                          PF_Libnecrrep     IN        fc_ecriture.libn%TYPE,
                          PF_Datecrrep      IN        fc_ecriture.dat_ecr%TYPE,
                          PF_Datejour       IN        fc_ecriture.dat_saisie%TYPE,
                          PF_Statutecr_C    IN        fc_ecriture.cod_statut%TYPE,
                          PF_Numecrrep      IN OUT    fc_ecriture.ide_ecr%TYPE) RETURN NUMBER IS

  CURSOR cur_fc_ecriture(PC_Poste        fc_ecriture.ide_poste%TYPE,
                         PC_Gestion      fc_ecriture.ide_gest%TYPE,
                         PC_Journalrep   fc_ecriture.ide_jal%TYPE,
                         PC_Oui          fc_ecriture.flg_cptab%TYPE) IS
    SELECT MAX(ide_ecr) Numecr
    FROM fc_ecriture
    WHERE ide_poste = PC_Poste
      AND ide_gest = PC_Gestion
      AND ide_jal = PC_Journalrep
      AND flg_cptab = PC_Oui;

BEGIN
  -- Recherche de ide_ecr
  -----------------------
  PF_Numecrrep := NULL;
  FOR row1 IN cur_fc_ecriture(PF_Poste,PF_Gestion_REP,PF_Journalrep,PF_Oui)
  LOOP
    PF_Numecrrep := row1.Numecr;
    Exit;
  END LOOP;
  PF_Numecrrep := NVL(PF_Numecrrep,0) + 1;

  -- Insertion ecriture reprise
  -----------------------------
  INSERT INTO fc_ecriture
    (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr,dat_jc,var_cpta,
     ide_schema,libn,dat_saisie,dat_ecr,cod_statut,
     dat_cre,dat_maj)
  VALUES
    (PF_Poste,PF_Gestion_REP,PF_Journalrep,PF_Oui,PF_Numecrrep,PF_JC_BE,PF_Varcptarep,
     PF_Schemarep,PF_Libnecrrep,PF_Datejour,PF_Datecrrep,PF_Statutecr_C,
     PF_Datejour,PF_Datejour);

  Trace('Creation ecriture reprise -> '||TO_CHAR(PF_Numecrrep));

  Return(0);


EXCEPTION
  WHEN Others THEN
    AFF_MESS('E',105,'U212_210B',SUBSTR('(MAJ_Ecriture_REP) '||SQLERRM,1,80),'','');
    Return(-1);

END MAJ_Ecriture_REP;

/* ******************************************* */
/* Fonction de suppression ecriture de reprise */
/* ******************************************* */
FUNCTION MAJ_Del_Ecriture_REP(PF_Poste              IN    fc_ligne.ide_poste%TYPE,
                              PF_Gestion_REP        IN    fc_ligne.ide_gest%TYPE,
                              PF_Journalrep         IN    fc_ligne.ide_jal%TYPE,
                              PF_Oui                IN    fc_ligne.flg_cptab%TYPE,
                              PF_Numecrrep          IN    fc_ligne.ide_ecr%TYPE) RETURN NUMBER IS
BEGIN
  -- Suppression ecriture reprise
  -------------------------------
  DELETE FROM fc_ecriture
  WHERE ide_poste = PF_Poste
    AND ide_gest = PF_Gestion_REP
    AND ide_jal = PF_Journalrep
    AND flg_cptab = PF_Oui
    AND ide_ecr = PF_Numecrrep;

  Trace('Suppression ecriture reprise -> '||TO_CHAR(PF_Numecrrep));

  Return(0);


EXCEPTION
  WHEN Others THEN
    AFF_MESS('E',105,'U212_210B',SUBSTR('(MAJ_Del_Ecriture_REP) '||SQLERRM,1,80),'','');
    Return(-1);

END MAJ_Del_Ecriture_REP;

/* ********************************************** */
/* Fonction de creation ligne ecriture de reprise */
/* ********************************************** */
FUNCTION MAJ_Ligne_REP(PF_Poste              IN    fc_ligne.ide_poste%TYPE,
                       PF_Gestion_REP        IN    fc_ligne.ide_gest%TYPE,
                       PF_Journalrep         IN    fc_ligne.ide_jal%TYPE,
                       PF_Oui                IN    fc_ligne.flg_cptab%TYPE,
                       PF_Numecrrep          IN    fc_ligne.ide_ecr%TYPE,
                       PF_Numligecrrep       IN    fc_ligne.ide_lig%TYPE,
                       PF_Varcptarep         IN    fc_ligne.var_cpta%TYPE,
                       PF_Compte_BE          IN    fc_ligne.ide_cpt%TYPE,
                       PF_Codsens            IN    fc_ligne.cod_sens%TYPE,
                       PF_Montant            IN    fc_ligne.mt%TYPE,
                       PF_Schemarep          IN    fc_ligne.ide_schema%TYPE,
                       PF_Codtypschemarep    IN    fc_ligne.cod_typ_schema%TYPE,
                       PF_Modeleliggenrep    IN    fc_ligne.ide_modele_lig%TYPE,
                       PF_Datejour           IN    fc_ligne.dat_maj%TYPE,
                       PF_Vartiers           IN    fc_ligne.var_tiers%TYPE,
                       PF_Idetiers           IN    fc_ligne.ide_tiers%TYPE,
                       PF_Iderefpiece        IN    fc_ligne.ide_ref_piece%TYPE,
                       PF_Codrefpiece        IN    fc_ligne.cod_ref_piece%TYPE,
                       PF_Observ             IN    fc_ligne.observ%TYPE,
                       PF_Datecrrep          IN    fc_ligne.dat_ecr%TYPE,
                       PF_Datref             IN    fc_ligne.dat_ref%TYPE,
			     -- MODIF SGN FCT38 du 01/02/2002 ajout des info compte auxiliaire
			     -- par defaut ces valeur sont null
			     PF_ide_plan_aux       IN    fc_ligne.ide_plan_aux%TYPE := NULL,
			     PF_ide_cpt_aux        IN    fc_ligne.ide_cpt_aux%TYPE := NULL,
                       -- MODIF SGN FCT48 : Ajout des info devise
			     PF_ide_devise         IN    fc_ligne.ide_devise%TYPE := NULL
                       ) RETURN NUMBER IS
			     -- Fin modif sgn

-- MODIF SGN FCT38
  CURSOR cur_fc_ligne(PF_Poste        fc_ligne.ide_poste%TYPE,
                      PF_Gestion_REP  fc_ligne.ide_gest%TYPE,
                      PF_Journalrep   fc_ligne.ide_jal%TYPE,
                      PF_Oui          fc_ligne.flg_cptab%TYPE,
			    PF_Numecrrep    fc_ligne.ide_ecr%TYPE) IS
    SELECT MAX(ide_lig) Numlig
    FROM fc_ligne
    WHERE ide_poste = PF_Poste
      AND ide_gest = PF_Gestion_REP
      AND ide_jal = PF_Journalrep
      AND flg_cptab = PF_Oui
	AND ide_ecr = PF_Numecrrep;

v_Numlig fc_ligne.ide_lig%TYPE;
-- FIN MODIF SGN FCT38

--- LGD ANOVAV3 262 le 30/01/2002
Erreur_Arrondi        EXCEPTION;

BEGIN
  -- MODIF SGN FCT38
  -- Recherche de ide_lig
  -----------------------
  v_Numlig := NULL;
  FOR row1 IN cur_fc_ligne(PF_Poste,PF_Gestion_REP,PF_Journalrep,PF_Oui, PF_Numecrrep)
  LOOP
    v_Numlig := row1.Numlig;
    Exit;
  END LOOP;
  v_Numlig := NVL(v_Numlig,0) + 1;

  -- Insertion ligne reprise
  --------------------------

  v_retour := CAL_ROUND_MT(PF_Montant,v_montant_arrondi);
  If v_retour =-1  then
    raise Erreur_Arrondi ;
  end if;

  INSERT INTO fc_ligne
    (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr,ide_lig,
     var_cpta,var_tiers,ide_tiers,ide_cpt,
     ide_ref_piece,cod_ref_piece,cod_sens,mt,
     observ,ide_schema,cod_typ_schema,ide_modele_lig,
     dat_ecr,dat_ref,dat_cre,dat_maj,
     ide_plan_aux, ide_cpt_aux,  -- MODIF SGN FCT38 du 01/02/2002
     ide_devise  -- MODIF SGN FCT48 : Ajout info devise
    )
  VALUES
    (PF_Poste,PF_Gestion_REP,PF_Journalrep,PF_Oui,PF_Numecrrep,v_Numlig,-- MODIF SGN FCT38 du 01/02/2002PF_Numligecrrep,
     PF_Varcptarep,PF_Vartiers,PF_Idetiers,PF_Compte_BE,
     --PF_Iderefpiece,PF_Codrefpiece,PF_Codsens,PF_Montant,
     PF_Iderefpiece,PF_Codrefpiece,PF_Codsens,v_montant_arrondi,
	 PF_Observ,PF_Schemarep,PF_Codtypschemarep,PF_Modeleliggenrep,
     PF_Datecrrep,PF_Datref,PF_Datejour,PF_Datejour,
     PF_ide_plan_aux, PF_ide_cpt_aux,  -- MODIF SGN FCT38 du 01/02/2002
     PF_ide_devise  -- MODIF SGN FCT48 : Ajout inf devise
	 );

  Trace('Creation ligne ecriture reprise -> '||TO_CHAR(PF_Numecrrep)||' - '||TO_CHAR(PF_Numligecrrep));
  Return(0);

EXCEPTION

  WHEN Erreur_Arrondi THEN
    AFF_MESS('E',879,'U212_210B',SUBSTR('(MAJ_Ligne_REP) '||SQLERRM,1,80),'','');
    Return(-1);
  WHEN Others THEN
    AFF_MESS('E',105,'U212_210B',SUBSTR('(MAJ_Ligne_REP) '||SQLERRM,1,80),'','');
    Return(-1);

END MAJ_Ligne_REP;

/* *********************************************** */
/* Fonction extraction information RC_DROIT_COMPTE */
/* *********************************************** */
FUNCTION EXT_Rc_Droit_Compte(PF_Typposte      IN        rm_poste.ide_typ_poste%TYPE,
                             PF_Varcpta       IN        rc_droit_compte.var_cpta%TYPE,
                             PF_Compte        IN        rc_droit_compte.ide_cpt%TYPE,
                             PF_Codsensbe     IN OUT    rc_droit_compte.cod_sens_be%TYPE,
                             PF_Flgimputbe    IN OUT    rc_droit_compte.flg_imput_be%TYPE) RETURN NUMBER IS

BEGIN

  SELECT cod_sens_be,flg_imput_be
    INTO PF_Codsensbe,PF_Flgimputbe
  FROM rc_droit_compte
  WHERE var_cpta = PF_Varcpta
    AND ide_cpt = PF_Compte
    AND ide_typ_poste = PF_Typposte;

  Return(0);


EXCEPTION
  WHEN Others THEN
    AFF_MESS('E',105,'U212_210B',SUBSTR('(EXT_Rc_Droit_Compte) '||SQLERRM,1,80),'','');
    Return(-1);

END EXT_Rc_Droit_Compte;

/* ***************************************************** */
/* Fonction de traitement des comptes non gere par piece */
/* ***************************************************** */
FUNCTION GES_Compte_Normal(PF_Poste              IN        rm_poste.ide_poste%TYPE,
                           PF_Typposte           IN        rm_poste.ide_typ_poste%TYPE,
                           PF_Gestion            IN        fn_gestion.ide_gest%TYPE,
                           PF_Gestion_REP        IN        fn_gestion.ide_gest%TYPE,
                           PF_JC_REP             IN        fc_ecriture.dat_jc%TYPE,
                           PF_JC_LastREP_P       IN        fc_ecriture.dat_jc%TYPE,
                           PF_JC_LastREP_D       IN        fc_ecriture.dat_jc%TYPE,
                           PF_Modrepsl_P         IN        fc_trt_hist.mod_rep%TYPE,
                           PF_Modrepsl_D         IN        fc_trt_hist.mod_rep%TYPE,
                           PF_Compte             IN        fc_ligne.ide_cpt%TYPE,
                           PF_Compte_BE          IN        fc_ligne.ide_cpt%TYPE,
                           PF_Varcpta            IN        fc_ligne.var_cpta%TYPE,
                           PF_Varcptarep         IN        fc_ligne.var_cpta%TYPE,
                           PF_Journalrep         IN        fc_ecriture.ide_jal%TYPE,
                           PF_Oui                IN        fc_ecriture.flg_cptab%TYPE,
                           PF_Schemarep          IN        fc_ecriture.ide_schema%TYPE,
                           PF_Codtypschemarep    IN        rc_schema_cpta.cod_typ_schema%TYPE,
                           PF_Modeleliggenrep    IN        sr_cpt_trt.ide_modele_lig_gen%TYPE,
                           PF_SensDB             IN        fc_ligne.cod_sens%TYPE,
                           PF_SensCR             IN        fc_ligne.cod_sens%TYPE,
                           PF_Numecrrep          IN        fc_ecriture.ide_ecr%TYPE,
                           PF_Datejour           IN        fc_ecriture.dat_saisie%TYPE,
                           PF_Datecrrep          IN        fc_ecriture.dat_ecr%TYPE,
                           PF_Lastnumlig         IN OUT    fc_ligne.ide_lig%TYPE,
                           PF_TotligMT           IN OUT    fc_ligne.mt%TYPE) RETURN NUMBER IS

  CURSOR cur_ligne_ecr(PC_Poste          fc_ecriture.ide_poste%TYPE,
                       PC_Gestion        fc_ecriture.ide_gest%TYPE,
                       PC_JC_REP         fc_ecriture.dat_jc%TYPE,
                       PC_JC_Lastrep_P   fc_ecriture.dat_jc%TYPE,
                       PC_JC_Lastrep_D   fc_ecriture.dat_jc%TYPE,
                       PC_Compte         fc_ligne.ide_cpt%TYPE,
                       PC_SensDB         fc_ligne.cod_sens%TYPE,
                       PC_Modrepsl_P     fn_compte.cod_typ_be%TYPE,
                       PC_Modrepsl_D     fn_compte.cod_typ_be%TYPE) IS
    -- MODIF SGN FCT38 du 01/02/2002 : on recupere les infos concernant le compte auxiliaire
	-- contenues au niveau de la ligne d ecriture de maniere a pouvoir les recopier lors de la
	-- création de la ligne a reprendre
    SELECT l.var_cpta, l.ide_cpt, l.ide_plan_aux, l.ide_cpt_aux,
           l.ide_devise, -- MODIF SGN FCT48 : Ajout des infos devise
	-- Fin modif sgn
          SUM(DECODE(l.cod_sens,PC_SensDB,NVL(l.mt,0),NVL(-l.mt,0))) Cumul_MT
    FROM fc_ecriture e,fc_ligne l,fn_compte c
    WHERE l.ide_poste = e.ide_poste
      AND l.ide_gest = e.ide_gest
      AND l.ide_jal = e.ide_jal
      AND l.flg_cptab = e.flg_cptab
      AND l.ide_ecr = e.ide_ecr
      AND c.var_cpta = l.var_cpta
      AND c.ide_cpt = l.ide_cpt
      AND e.ide_poste = PC_Poste
      AND e.ide_gest = PC_Gestion
      AND e.dat_jc IS NOT NULL
      AND TRUNC(e.dat_jc) <= TRUNC(PC_JC_REP)
      AND ((PC_JC_Lastrep_D IS NOT NULL AND TRUNC(e.dat_jc) > TRUNC(PC_JC_Lastrep_D))
           OR
           (PC_JC_Lastrep_D IS NULL AND ((c.cod_typ_be = PC_Modrepsl_P AND
                                          (PC_JC_Lastrep_P IS NULL OR
                                           TRUNC(e.dat_jc) > TRUNC(PC_JC_Lastrep_P)))
                                         OR
                                         c.cod_typ_be = PC_Modrepsl_D)))
      AND l.ide_cpt IS NOT NULL
      AND l.ide_cpt = PC_Compte
	  -- MODIF SGN FCT38 du 01/02/2002
      GROUP BY l.var_cpta, l.ide_cpt, l.ide_plan_aux, l.ide_cpt_aux,
               l.ide_devise; -- MODIF SGN FCT48 : Ajout des infos devise
      -- Fin modif SGN

  v_cumulmt      fc_ligne.mt%TYPE;
  v_montant      fc_ligne.mt%TYPE;
  v_sens         fc_ligne.cod_sens%TYPE;
  v_codsensbe    rc_droit_compte.cod_sens_be%TYPE;
  v_flgimputbe   rc_droit_compte.flg_imput_be%TYPE;
  -- Modif SGN FCT38 du 01/02/2002 Ajout des variables pour le cpt aux
  v_ide_plan_aux fc_ligne.ide_plan_aux%TYPE;
  v_ide_cpt_aux  fc_ligne.ide_cpt_aux%TYPE;
  v_ret NUMBER;  -- MODIF SGN FCT38 DU 04/02/2002
  -- MODIF SGN FCT48 : Ajout info devise
  v_ide_devise   FC_LIGNE.ide_devise%TYPE;
  -- Fin modif sgn

BEGIN
  Trace('Compte NON gere par PIECE');
  Trace('*************************');

  -- Calcul du montant de la ligne a genere
  -----------------------------------------
  v_cumulmt := 0;

  -- MODIF SGN ANOVA136 : initialisation du montant total et du dernier numero de ligne a 0
  PF_Lastnumlig := 0;
  PF_TotligMT := 0;

  -- fin modif sgn

  FOR row1 IN cur_ligne_ecr(PF_Poste,PF_Gestion,PF_JC_REP,PF_JC_LastREP_P,PF_JC_LastREP_D,
                            PF_Compte,PF_SensDB,PF_Modrepsl_P,PF_Modrepsl_D)
  LOOP
    v_ret := 0;  -- MODIF SGN FCT38 DU 04/02/2002

    v_cumulmt := row1.Cumul_MT;
	-- MODIF SGN FCT38 : Recuperation des infos concernant le compte auxiliaire
	v_ide_plan_aux := row1.ide_plan_aux;
	v_ide_cpt_aux := row1.ide_cpt_aux;
	-- MODIF SGN FCT48 : Gestion des devises
      v_ide_devise := row1.ide_devise;
	-- Fin modif SGN
	-- MODIF SGN FCT38 DU 04/02/2002    Exit;
	-- MODIF SGN FCT38 DU 04/02/2002 END LOOP;

	Trace('v_cumulmt             -> '||TO_CHAR(v_cumulmt));
	Trace('v_ide_plan_aux        -> '||v_ide_plan_aux);
	Trace('v_ide_cpt_aux         -> '||v_ide_cpt_aux);
	Trace('v_ide_devise          -> '||v_ide_devise);

    IF NVL(v_cumulmt,0) != 0 THEN

      -- Recherche info RC_DROIT_COMPTE
      ---------------------------------
      IF EXT_Rc_Droit_Compte(PF_Typposte,PF_Varcpta,PF_Compte,v_codsensbe,v_flgimputbe) != 0 THEN
        v_ret := -1; -- MODIF SGN FCT38 DU 04/02/2002:Return(-1);
		EXIT;
      ELSE  -- MODIF SGN FCT38 DU 04/02/2002    END IF;
     	Trace('Compte : v_codsensbe  -> '||v_codsensbe);
        Trace('Compte : v_flgimputbe -> '||v_flgimputbe);

        -- Preparation montant et sens ligne a genere
        ---------------------------------------------
        IF v_codsensbe = PF_SensDB THEN
          v_montant := v_cumulmt;
          v_sens    := PF_SensDB;
        ELSIF v_codsensbe = PF_SensCR THEN
	      v_montant := -v_cumulmt;
          v_sens    := PF_SensCR;
        ELSE
      	  IF v_cumulmt >= 0 THEN
            v_montant := v_cumulmt;
			v_sens    := PF_SensDB;
		  ELSE
            v_montant := -v_cumulmt;
        	v_sens    := PF_SensCR;
      	  END IF;
	    END IF;

        Trace('v_montant             -> '||TO_CHAR(v_montant));
        Trace('v_sens                -> '||v_sens);

        -- Creation ligne ecriture reprise
        ----------------------------------

	  IF MAJ_Ligne_REP(PF_Poste,PF_Gestion_REP,PF_Journalrep,PF_Oui,PF_Numecrrep,
                     1,PF_Varcptarep,PF_Compte_BE,v_sens,v_montant,PF_Schemarep,
                     PF_Codtypschemarep,PF_Modeleliggenrep,PF_Datejour,
                     NULL,NULL,NULL,NULL,NULL,PF_Datecrrep,NULL,
					 -- MODIF SGN FCT38 du 01/02/2002
					 v_ide_plan_aux,
					 v_ide_cpt_aux,
                               -- MODIF SGN FCT48 : ajout info devise
                               v_ide_devise
					 -- Fin modif sgn
					 ) != 0 THEN
          v_ret := -1; -- MODIF SGN FCT38 DU 04/02/2002    END IF;Return(-1);
	    EXIT;-- MODIF SGN FCT38 DU 04/02/2002
        ELSE -- MODIF SGN FCT38 DU 04/02/2002    END IF;
          -- Mise à jour variable de retour
          ---------------------------------
          -- MODIF SGN ANOVA136 :  PF_Lastnumlig := 1;
          --IF v_sens = PF_SensDB THEN
          --  PF_TotligMT := v_montant;
          --ELSE
          --  PF_TotligMT := -v_montant;
          --END IF;

	    PF_Lastnumlig := PF_Lastnumlig + 1;
          IF v_sens = PF_SensDB THEN
            PF_TotligMT := PF_TotligMT + v_montant;
          ELSE
            PF_TotligMT := PF_TotligMT - v_montant;
          END IF;
	    -- fin modif sgn


        END IF; -- IF MAJ_Ligne_REP  -- MODIF SGN FCT38 DU 04/02/2002
      END IF; -- IF EXT_Rc_Droit_Compte  -- MODIF SGN FCT38 DU 04/02/2002

    ELSE
      Trace('Ligne ecriture non generee car montant = 0');

      -- Mise à jour variable de retour
      ---------------------------------
      -- MODIF SGN ANOVA136 : PF_Lastnumlig := 0;
      -- PF_TotligMT   := 0;
      -- fin modif sgn
    END IF;

    -- Traitement OK
    ----------------
  END LOOP;

  return v_ret;  -- MODIF SGN FCT38 DU 04/02/2002

EXCEPTION
  WHEN Others THEN
    AFF_MESS('E',105,'U212_210B',SUBSTR('(GES_Compte_Normal) '||SQLERRM,1,80),'','');
    Return(-1);

END GES_Compte_Normal;

/* ************************************************* */
/* Fonction de traitement des comptes gere par piece */
/* ************************************************* */
FUNCTION GES_Compte_Piece(PF_Poste              IN        rm_poste.ide_poste%TYPE,
                          PF_Typposte           IN        rm_poste.ide_typ_poste%TYPE,
                          PF_Gestion            IN        fn_gestion.ide_gest%TYPE,
                          PF_Gestion_REP        IN        fn_gestion.ide_gest%TYPE,
                          PF_JC_REP             IN        fc_ecriture.dat_jc%TYPE,
                          PF_JC_LastREP_P       IN        fc_ecriture.dat_jc%TYPE,
                          PF_JC_LastREP_D       IN        fc_ecriture.dat_jc%TYPE,
                          PF_Modrepsl_P         IN        fc_trt_hist.mod_rep%TYPE,
                          PF_Modrepsl_D         IN        fc_trt_hist.mod_rep%TYPE,
                          PF_Compte             IN        fc_ligne.ide_cpt%TYPE,
                          PF_Compte_BE          IN        fc_ligne.ide_cpt%TYPE,
                          PF_Varcpta            IN        fc_ligne.var_cpta%TYPE,
                          PF_Varcptarep         IN        fc_ligne.var_cpta%TYPE,
                          PF_Justiftiers        IN        fn_compte.flg_justif_tiers%TYPE,
                          PF_Journalrep         IN        fc_ecriture.ide_jal%TYPE,
                          PF_Oui                IN        fc_ecriture.flg_cptab%TYPE,
                          PF_Non                IN        fc_ecriture.flg_cptab%TYPE,
                          PF_Schemarep          IN        fc_ecriture.ide_schema%TYPE,
                          PF_Codtypschemarep    IN        rc_schema_cpta.cod_typ_schema%TYPE,
                          PF_Modeleliggenrep    IN        sr_cpt_trt.ide_modele_lig_gen%TYPE,
                          PF_SensDB             IN        fc_ligne.cod_sens%TYPE,
                          PF_SensCR             IN        fc_ligne.cod_sens%TYPE,
                          PF_Numecrrep          IN        fc_ecriture.ide_ecr%TYPE,
                          PF_Datejour           IN        fc_ecriture.dat_saisie%TYPE,
                          PF_Datecrrep          IN        fc_ecriture.dat_ecr%TYPE,
                          PF_Lastnumlig         IN OUT    fc_ligne.ide_lig%TYPE,
                          PF_TotligMT           IN OUT    fc_ligne.mt%TYPE) RETURN NUMBER IS

  CURSOR cur_ligne_ecr_solde(PC_Poste          fc_ecriture.ide_poste%TYPE,
                             PC_Gestion        fc_ecriture.ide_gest%TYPE,
                             PC_JC_REP         fc_ecriture.dat_jc%TYPE,
                             PC_JC_Lastrep_P   fc_ecriture.dat_jc%TYPE,
                             PC_JC_Lastrep_D   fc_ecriture.dat_jc%TYPE,
                             PC_Compte         fc_ligne.ide_cpt%TYPE,
                             PC_SensDB         fc_ligne.cod_sens%TYPE,
                             PC_Oui            fc_ref_piece.flg_solde%TYPE,
                             PC_Modrepsl_P     fn_compte.cod_typ_be%TYPE,
                             PC_Modrepsl_D     fn_compte.cod_typ_be%TYPE
							 ) IS
    SELECT l.var_cpta, l.ide_cpt, l.ide_plan_aux, l.ide_cpt_aux, -- MODIF SGN FCT38 du 01/02/2002
           l.ide_devise, -- MODIF SGN FCT48 : Ajout info devise
	       SUM(DECODE(l.cod_sens,PC_SensDB,NVL(l.mt,0),NVL(-l.mt,0))) Cumul_MT
    FROM fc_ecriture e,fc_ligne l,fn_compte c,fc_ref_piece r
    WHERE l.ide_poste = e.ide_poste
      AND l.ide_gest = e.ide_gest
      AND l.ide_jal = e.ide_jal
      AND l.flg_cptab = e.flg_cptab
      AND l.ide_ecr = e.ide_ecr
      AND c.var_cpta = l.var_cpta
      AND c.ide_cpt = l.ide_cpt
      AND r.ide_poste = l.ide_poste
      -- MODIF SGN ANOVA303 : AND r.ide_ref_piece= l.ide_ref_piece
      AND NVL(r.ide_ref_piece,'-9999999') = NVL(l.ide_ref_piece,'-9999999')
	  -- fin modif sgn
      AND e.ide_poste = PC_Poste
      AND e.ide_gest = PC_Gestion
      AND e.dat_jc IS NOT NULL
      AND TRUNC(e.dat_jc) <= TRUNC(PC_JC_REP)
      AND ((PC_JC_Lastrep_D IS NOT NULL AND TRUNC(e.dat_jc) > TRUNC(PC_JC_Lastrep_D))
           OR
           (PC_JC_Lastrep_D IS NULL AND ((c.cod_typ_be = PC_Modrepsl_P AND
                                          (PC_JC_Lastrep_P IS NULL OR
                                           TRUNC(e.dat_jc) > TRUNC(PC_JC_Lastrep_P)))
                                         OR
                                         c.cod_typ_be = PC_Modrepsl_D)))
      AND l.ide_cpt IS NOT NULL
      AND l.ide_cpt = PC_Compte
      AND r.flg_solde = PC_Oui
	  -- MODIF SGN ANOVA303 : ajout devise
	  AND NVL(r.ide_devise,v_codext_devise_ref) = NVL(l.ide_devise, v_codext_devise_ref)
	  -- fin modif sgn
	  GROUP BY l.var_cpta, l.ide_cpt, l.ide_plan_aux, l.ide_cpt_aux,  -- MODIF SGN FCT38 du 01/02/2002
                 l.ide_devise;  -- MODIF SGN FCT48 : Ajout info devise

  CURSOR cur_ligne_ecr_non_solde(PC_Poste          fc_ecriture.ide_poste%TYPE,
                                 PC_Gestion        fc_ecriture.ide_gest%TYPE,
                                 PC_JC_REP         fc_ecriture.dat_jc%TYPE,
                                 PC_JC_Lastrep_P   fc_ecriture.dat_jc%TYPE,
                                 PC_JC_Lastrep_D   fc_ecriture.dat_jc%TYPE,
                                 PC_Compte         fc_ligne.ide_cpt%TYPE,
                                 PC_SensDB         fc_ligne.cod_sens%TYPE,
                                 PC_Non            fc_ref_piece.flg_solde%TYPE,
                                 PC_Modrepsl_P     fn_compte.cod_typ_be%TYPE,
                                 PC_Modrepsl_D     fn_compte.cod_typ_be%TYPE) IS
    SELECT DECODE(l.cod_sens,PC_SensDB,NVL(l.mt,0),NVL(-l.mt,0)) Montant,
           l.var_tiers,l.ide_tiers,
           l.ide_ref_piece,l.cod_ref_piece,
           l.observ,l.dat_ref,
		   -- MODIF SGN FCT38 on se contente de rajouter les infos du compte aux, on n a
		   -- pas de cumul a faire pour les comptes geres par piece
		   l.ide_plan_aux,
		   l.ide_cpt_aux,
               -- MODIF SGN FCT48 : ajout info devise
               l.ide_devise
		   -- fin modif sgn
    FROM fc_ecriture e,fc_ligne l,fn_compte c,fc_ref_piece r
    WHERE l.ide_poste = e.ide_poste
      AND l.ide_gest = e.ide_gest
      AND l.ide_jal = e.ide_jal
      AND l.flg_cptab = e.flg_cptab
      AND l.ide_ecr = e.ide_ecr
      AND c.var_cpta = l.var_cpta
      AND c.ide_cpt = l.ide_cpt
	  AND r.ide_poste = l.ide_poste
      -- MODIF SGN ANOVA303 :
      -- AND r.ide_ref_piece = l.ide_ref_piece
      AND NVL(r.ide_ref_piece,'-9999999') = NVL(l.ide_ref_piece,'-9999999')
	  -- fin modif sgn
      AND e.ide_poste = PC_Poste
      AND e.ide_gest = PC_Gestion
      AND e.dat_jc IS NOT NULL
      AND TRUNC(e.dat_jc) <= TRUNC(PC_JC_REP)
      AND ((PC_JC_Lastrep_D IS NOT NULL AND TRUNC(e.dat_jc) > TRUNC(PC_JC_Lastrep_D))
           OR
           (PC_JC_Lastrep_D IS NULL AND ((c.cod_typ_be = PC_Modrepsl_P AND
                                          (PC_JC_Lastrep_P IS NULL OR
                                           TRUNC(e.dat_jc) > TRUNC(PC_JC_Lastrep_P)))
                                         OR
                                         c.cod_typ_be = PC_Modrepsl_D)))
      AND l.ide_cpt IS NOT NULL
      AND l.ide_cpt = PC_Compte
      AND r.flg_solde = PC_Non
  	  -- MODIF SGN ANOVA303 : ajout devise
	  AND NVL(r.ide_devise,v_codext_devise_ref) = NVL(l.ide_devise, v_codext_devise_ref)
	  -- fin modif sgn
	  ;

  v_cumulmt       fc_ligne.mt%TYPE;
  v_montant       fc_ligne.mt%TYPE;
  v_sens          fc_ligne.cod_sens%TYPE;
  v_codsensbe     rc_droit_compte.cod_sens_be%TYPE;
  v_flgimputbe    rc_droit_compte.flg_imput_be%TYPE;
  v_vartiers      fc_ligne.var_tiers%TYPE;
  v_idetiers      fc_ligne.ide_tiers%TYPE;
  v_iderefpiece   fc_ligne.ide_ref_piece%TYPE;
  v_codrefpiece   fc_ligne.cod_ref_piece%TYPE;
  v_observ        fc_ligne.observ%TYPE;
  v_datref        fc_ligne.dat_ref%TYPE;
  v_erreur        NUMBER;
  v_ide_plan_aux  fc_ligne.ide_plan_aux%TYPE; -- MODIF SGN FCT38 du 01/02/2002
  v_ide_cpt_aux   fc_ligne.ide_cpt_aux%TYPE; -- MODIF SGN FCT38 du 01/02/2002
  v_ide_devise    FC_LIGNE.ide_devise%TYPE;  -- MODIF SGN FCT48 : Ajout info devise

BEGIN
  Trace('Compte GERE par PIECE');
  Trace('*********************');

  -- Recherche info RC_DROIT_COMPTE
  ---------------------------------
  IF EXT_Rc_Droit_Compte(PF_Typposte,PF_Varcpta,PF_Compte,v_codsensbe,v_flgimputbe) != 0 THEN
    Return(-1);
  END IF;

  Trace('Compte : v_codsensbe  -> '||v_codsensbe);
  Trace('Compte : v_flgimputbe -> '||v_flgimputbe);

  -- Initialisation variable de retour
  ------------------------------------
  PF_Lastnumlig := 0;
  PF_TotligMT   := 0;


  -----------------------------------------------
  -- Ligne ecriture avec reference piece SOLDE --
  -----------------------------------------------
  Trace('Ligne ecriture avec reference piece SOLDE');

  -- Calcul du montant de la ligne a genere
  -----------------------------------------
  v_cumulmt := 0;
  FOR row1 IN cur_ligne_ecr_solde(PF_Poste,PF_Gestion,PF_JC_REP,PF_JC_LastREP_P,
                                  PF_JC_LastREP_D,PF_Compte,PF_SensDB,PF_Oui,
                                  PF_Modrepsl_P,PF_Modrepsl_D)
  LOOP
    v_cumulmt := row1.Cumul_MT;
	-- MODIF SGN FCT38 du 01/02/2002 : Recuperation des info compte aux
	v_ide_plan_aux := row1.ide_plan_aux;
	v_ide_cpt_aux := row1.ide_cpt_aux;
      -- MODIF SGN FCT48 : Ajout info devise
      v_ide_devise := row1.ide_devise;
	-- Fin modif sgn
    Exit;
  END LOOP;

  IF NVL(v_cumulmt,0) != 0 THEN

    Trace('v_cumulmt             -> '||TO_CHAR(v_cumulmt));
    Trace('v_ide_plan_aux        -> '||v_ide_plan_aux);
    Trace('v_ide_cpt_aux         -> '||v_ide_cpt_aux);
    Trace('v_ide_devise          -> '||v_ide_devise);

    -- Preparation montant et sens ligne a genere
    ---------------------------------------------
    IF v_codsensbe = PF_SensDB THEN
      v_montant := v_cumulmt;
      v_sens    := PF_SensDB;
    ELSIF v_codsensbe = PF_SensCR THEN
      v_montant := -v_cumulmt;
      v_sens    := PF_SensCR;
    ELSE
      IF v_cumulmt >= 0 THEN
        v_montant := v_cumulmt;
        v_sens    := PF_SensDB;
      ELSE
        v_montant := -v_cumulmt;
        v_sens    := PF_SensCR;
      END IF;
    END IF;

    Trace('v_montant             -> '||TO_CHAR(v_montant));
    Trace('v_sens                -> '||v_sens);

    -- Mise à jour variable de retour
    ---------------------------------
    PF_Lastnumlig := PF_Lastnumlig + 1;

    -- Creation ligne ecriture reprise
    ----------------------------------
    IF MAJ_Ligne_REP(PF_Poste,PF_Gestion_REP,PF_Journalrep,PF_Oui,PF_Numecrrep,
                     PF_Lastnumlig,PF_Varcptarep,PF_Compte_BE,v_sens,v_montant,PF_Schemarep,
                     PF_Codtypschemarep,PF_Modeleliggenrep,PF_Datejour,
                     NULL,NULL,NULL,NULL,NULL,PF_Datecrrep,NULL,
					 -- MODIF SGN FCT38 du 01/02/2002 : ajout des info cpt aux
					 v_ide_plan_aux,
					 v_ide_cpt_aux,
                               -- MODIF SGN FCT48 : Ajout des info devise
                               v_ide_devise
					 -- Fin modif sgn
					 ) != 0 THEN
      Return(-1);
    END IF;

    -- Mise à jour variable de retour
    ---------------------------------
    IF v_sens = PF_SensDB THEN
      PF_TotligMT := PF_TotligMT + v_montant;
    ELSE
      PF_TotligMT := PF_TotligMT - v_montant;
    END IF;

  ELSE

    Trace('PAS de Ligne ecriture avec reference piece SOLDE ou montant = 0');
    Null;

  END IF;


  ---------------------------------------------------
  -- Ligne ecriture avec reference piece NON SOLDE --
  ---------------------------------------------------
  Trace('Ligne ecriture avec reference piece NON SOLDE');

  v_erreur := 0;
  FOR row2 IN cur_ligne_ecr_non_solde(PF_Poste,PF_Gestion,PF_JC_REP,PF_JC_LastREP_P,
                                      PF_JC_LastREP_D,PF_Compte,PF_SensDB,PF_Non,
                                      PF_Modrepsl_P,PF_Modrepsl_D)
  LOOP
    v_cumulmt     := row2.Montant;
    v_vartiers    := row2.var_tiers;
    v_idetiers    := row2.ide_tiers;
    v_iderefpiece := row2.ide_ref_piece;
    v_codrefpiece := row2.cod_ref_piece;
    v_observ      := row2.observ;
    v_datref      := row2.dat_ref;
	-- MODIF SGN FCT38 du 01/02/2002 Recuperation des info cpt aux
	v_ide_plan_aux := row2.ide_plan_aux;
	v_ide_cpt_aux  := row2.ide_cpt_aux;
      -- MODIF SGN FCT48 : Ajout info devise
      v_ide_devise   := row2.ide_devise;
	-- fin modif sgn

    Trace('v_cumulmt     -> '||TO_CHAR(v_cumulmt));
    Trace('v_vartiers    -> '||v_vartiers);
    Trace('v_idetiers    -> '||v_idetiers);
    Trace('v_iderefpiece -> '||TO_CHAR(v_iderefpiece));
    Trace('v_codrefpiece -> '||v_codrefpiece);
    Trace('v_observ      -> '||v_observ);
    Trace('v_datref      -> '||TO_CHAR(v_datref));
    Trace('v_ide_plan_aux -> '||v_ide_plan_aux); -- MODIF SGN FCT38
    Trace('v_ide_cpt_aux  -> '||v_ide_cpt_aux); -- MODIF SGN FCT38
    Trace('v_ide_devise  -> '||v_ide_devise); -- MODIF SGN FCT48


    -- Preparation montant et sens ligne a genere
    ---------------------------------------------
    IF v_codsensbe = PF_SensDB THEN
      v_montant := v_cumulmt;
      v_sens    := PF_SensDB;
    ELSIF v_codsensbe = PF_SensCR THEN
      v_montant := -v_cumulmt;
      v_sens    := PF_SensCR;
    ELSE
      IF v_cumulmt >= 0 THEN
        v_montant := v_cumulmt;
        v_sens    := PF_SensDB;
      ELSE
        v_montant := -v_cumulmt;
        v_sens    := PF_SensCR;
      END IF;
    END IF;

    Trace('v_montant             -> '||TO_CHAR(v_montant));
    Trace('v_sens                -> '||v_sens);

    -- Mise à jour variable de retour
    ---------------------------------
    PF_Lastnumlig := PF_Lastnumlig + 1;

    -- Creation ligne ecriture reprise
    ----------------------------------
    Trace('Ligne de reprise');
    IF MAJ_Ligne_REP(PF_Poste,PF_Gestion_REP,PF_Journalrep,PF_Oui,PF_Numecrrep,
                     PF_Lastnumlig,PF_Varcptarep,PF_Compte_BE,v_sens,v_montant,
                     PF_Schemarep,PF_Codtypschemarep,PF_Modeleliggenrep,PF_Datejour,
                     v_vartiers,v_idetiers,v_iderefpiece,v_codrefpiece,v_observ,
                     PF_Datecrrep,v_datref,
					 -- MODIF SGN FCT38 du 01/02/2002 : ajout info cpt aux
					 v_ide_plan_aux,
					 v_ide_cpt_aux,
                               -- MODIF SGN FCT48 : Ajout info devise
                               v_ide_devise
					 -- fin modif sgn
					 ) != 0 THEN
      v_erreur := 1;
      Exit;
    END IF;

    -- Mise à jour variable de retour
    ---------------------------------
    IF v_sens = PF_SensDB THEN
      PF_TotligMT := PF_TotligMT + v_montant;
    ELSE
      PF_TotligMT := PF_TotligMT - v_montant;
    END IF;

  END LOOP;

  IF v_erreur != 0 THEN
    Return(-1);
  END IF;

  -- Traitement OK
  ----------------
  Return(0);


EXCEPTION
  WHEN Others THEN
    AFF_MESS('E',105,'U212_210B',SUBSTR('(GES_Compte_Piece) '||SQLERRM,1,80),'','');
    Return(-1);

END GES_Compte_Piece;

/* ********************************** */
/* Fonction de controle du traitement */
/* ********************************** */
FUNCTION CTL_Validation(PF_Poste              IN        rm_poste.ide_poste%TYPE,
                        PF_Typposte           IN        rm_poste.ide_typ_poste%TYPE,
                        PF_Gestion_REP        IN        fn_gestion.ide_gest%TYPE,
                        PF_Varcptarep         IN        fc_ecriture.var_cpta%TYPE,
                        PF_Compte_BE          IN        fc_ligne.ide_cpt%TYPE,
                        PF_Oui                IN        fc_ecriture.flg_cptab%TYPE,
                        PF_SensDB             IN        fc_ligne.cod_sens%TYPE,
                        PF_SensCR             IN        fc_ligne.cod_sens%TYPE,
                        PF_Ctltraitement      IN OUT    NUMBER) RETURN NUMBER IS

  CURSOR cur_ligne(PC_Poste         fc_ecriture.ide_poste%TYPE,
                   PC_Gestion_REP   fc_ecriture.ide_gest%TYPE,
                   PC_Oui           fc_ecriture.flg_cptab%TYPE,
                   PC_Compte_BE     fc_ligne.ide_cpt%TYPE,
                   PC_SensDB        fc_ligne.cod_sens%TYPE,
                   PC_SensCR        fc_ligne.cod_sens%TYPE) IS
    SELECT SUM(DECODE(l.cod_sens,PC_SensDB,NVL(l.mt,0),NVL(-l.mt,0))) Cumul_Montant
    FROM fc_ligne l,fc_journal j
    WHERE j.var_cpta = l.var_cpta
      AND j.ide_jal = l.ide_jal
      AND l.ide_poste = PC_Poste
      AND l.ide_gest = PC_Gestion_REP
      AND l.flg_cptab = PC_Oui
      AND l.ide_cpt = PC_Compte_BE
      AND (j.flg_be = PC_Oui OR j.flg_repsolde = PC_Oui);

  v_sens            fc_ligne.cod_sens%TYPE;
  v_cumulmontant    fc_ligne.mt%TYPE;
  v_codsensbe       rc_droit_compte.cod_sens_be%TYPE;
  v_flgimputbe      rc_droit_compte.flg_imput_be%TYPE;

BEGIN
  Trace('Validate du Compte reprise -> '||PF_Compte_BE);

  -- Recherche info RC_DROIT_COMPTE
  ---------------------------------
  IF EXT_Rc_Droit_Compte(PF_Typposte,PF_Varcptarep,PF_Compte_BE,v_codsensbe,v_flgimputbe) != 0 THEN
    Return(-1);
  END IF;

  Trace('Compte reprise : v_codsensbe  -> '||v_codsensbe);
  Trace('Compte reprise : v_flgimputbe -> '||v_flgimputbe);

  -- Controle compte reprise imputable en balance d'entree
  --------------------------------------------------------
  IF v_flgimputbe != PF_Oui THEN
    AFF_MESS('E',624,'U212_210B',PF_Compte_BE,'','');
    PF_Ctltraitement := 1;
  END IF;

  -- Controle sens solde conforme sens autorise pour le compte
  ------------------------------------------------------------
  IF (v_codsensbe = PF_SensDB OR v_codsensbe = PF_SensCR) THEN

    v_cumulmontant := NULL;
    FOR row1 IN cur_ligne(PF_Poste,PF_Gestion_REP,PF_Oui,PF_Compte_BE,PF_SensDB,PF_SensCR)
    LOOP
      v_cumulmontant := row1.Cumul_Montant;
      Exit;
    END LOOP;

    IF NVL(v_cumulmontant,0) >= 0 THEN
      v_sens := PF_SensDB;
    ELSE
      v_sens := PF_SensCR;
    END IF;

    Trace('Compte reprise : v_montant -> '||TO_CHAR(v_cumulmontant));
    Trace('Compte reprise : v_sens    -> '||v_sens);

    IF v_sens != v_codsensbe THEN
      AFF_MESS('E',625,'U212_210B',PF_Compte_BE,'','');
      PF_Ctltraitement := 1;
    END IF;
  END IF;


  Return(0);


EXCEPTION
  WHEN Others THEN
    AFF_MESS('E',105,'U212_210B',SUBSTR('(CTL_Validation) '||SQLERRM,1,80),'','');
    Return(-1);

END CTL_Validation;

/* ********************************* */
/* Fonction de traitement de reprise */
/* ********************************* */
FUNCTION GES_Reprise(PF_Poste              IN        rm_poste.ide_poste%TYPE,
                     PF_Typposte           IN        rm_poste.ide_typ_poste%TYPE,
                     PF_Gestion            IN        fn_gestion.ide_gest%TYPE,
                     PF_Gestion_REP        IN        fn_gestion.ide_gest%TYPE,
                     PF_JC_REP             IN        fc_ecriture.dat_jc%TYPE,
                     PF_JC_BE              IN        fc_ecriture.dat_jc%TYPE,
                     PF_Trtrepsl           IN        sr_cpt_trt.cod_traitement%TYPE,
                     PF_Modrepsl           IN        VARCHAR2,
                     PF_Modrepsl_P         IN        fc_trt_hist.mod_rep%TYPE,
                     PF_Modrepsl_D         IN        fc_trt_hist.mod_rep%TYPE,
                     PF_Journalrep         IN        fc_ecriture.ide_jal%TYPE,
                     PF_Oui                IN        fc_ecriture.flg_cptab%TYPE,
                     PF_Non                IN        fc_ecriture.flg_cptab%TYPE,
                     PF_SensDB             IN        fc_ligne.cod_sens%TYPE,
                     PF_SensCR             IN        fc_ligne.cod_sens%TYPE,
                     PF_Varcpta            IN        fc_ecriture.var_cpta%TYPE,
                     PF_Varcptarep         IN        fc_ecriture.var_cpta%TYPE,
                     PF_Schemarep          IN        fc_ecriture.ide_schema%TYPE,
                     PF_Codtypschemarep    IN        rc_schema_cpta.cod_typ_schema%TYPE,
                     PF_Modeleliggenrep    IN        sr_cpt_trt.ide_modele_lig_gen%TYPE,
                     PF_Modeleligcntrep    IN        sr_cpt_trt.ide_modele_lig_cnt%TYPE,
                     PF_Comptecntrep       IN        sr_cpt_trt.ide_cpt_cnt%TYPE,
                     PF_Libnecrrep         IN        fc_ecriture.libn%TYPE,
                     PF_Datecrrep          IN        fc_ecriture.dat_ecr%TYPE,
                     PF_Datejour           IN        fc_ecriture.dat_saisie%TYPE,
                     PF_Statutecr_C        IN        fc_ecriture.cod_statut%TYPE,
                     PF_Ctltraitement      IN OUT    NUMBER) RETURN NUMBER IS

  CURSOR cur_fc_trt_hist(PC_Poste           fc_trt_hist.ide_poste%TYPE,
                         PC_Gestion         fc_trt_hist.ide_gest%TYPE,
                         PC_Codtraitement   fc_trt_hist.cod_traitement%TYPE,
                         PC_Modrepsl        fc_trt_hist.mod_rep%TYPE) IS
    SELECT dat_jc
    FROM fc_trt_hist
    WHERE ide_poste = PC_Poste
      AND ide_gest = PC_Gestion
      AND cod_traitement = PC_Codtraitement
      AND mod_rep = PC_Modrepsl
    ORDER BY dat_jc DESC;

  CURSOR cur_compte_rep(PC_Poste          fc_ecriture.ide_poste%TYPE,
                        PC_Gestion        fc_ecriture.ide_gest%TYPE,
                        PC_JC_REP         fc_ecriture.dat_jc%TYPE,
                        PC_JC_Lastrep_P   fc_ecriture.dat_jc%TYPE,
                        PC_JC_Lastrep_D   fc_ecriture.dat_jc%TYPE,
                        PC_Modrepsl       fn_compte.cod_typ_be%TYPE,
                        PC_Modrepsl_P     fn_compte.cod_typ_be%TYPE,
                        PC_Modrepsl_D     fn_compte.cod_typ_be%TYPE) IS
    SELECT distinct l.ide_cpt Compte,c.ide_cpt_be Compte_BE,
                    c.flg_justif,c.flg_justif_tiers,c.flg_justif_cpt
    FROM fc_ecriture e,fc_ligne l,fn_compte c
    WHERE l.ide_poste = e.ide_poste
      AND l.ide_gest = e.ide_gest
      AND l.ide_jal = e.ide_jal
      AND l.flg_cptab = e.flg_cptab
      AND l.ide_ecr = e.ide_ecr
      AND c.var_cpta = l.var_cpta
      AND c.ide_cpt = l.ide_cpt
      AND e.ide_poste = PC_Poste
      AND e.ide_gest = PC_Gestion
      AND e.dat_jc IS NOT NULL
      AND TRUNC(e.dat_jc) <= TRUNC(PC_JC_REP)
      AND ((PC_JC_Lastrep_D IS NOT NULL AND TRUNC(e.dat_jc) > TRUNC(PC_JC_Lastrep_D))
           OR
           (PC_JC_Lastrep_D IS NULL AND ((c.cod_typ_be = PC_Modrepsl_P AND
                                          (PC_JC_Lastrep_P IS NULL OR
                                           TRUNC(e.dat_jc) > TRUNC(PC_JC_Lastrep_P)))
                                         OR
                                         c.cod_typ_be = PC_Modrepsl_D)))
      AND l.ide_cpt IS NOT NULL
      AND ((PC_Modrepsl = PC_Modrepsl_P AND c.cod_typ_be = PC_Modrepsl_P)
           OR
           (PC_Modrepsl = PC_Modrepsl_D AND (c.cod_typ_be = PC_Modrepsl_P OR
                                             c.cod_typ_be = PC_Modrepsl_D)));

  v_jc_lastrep_P	  fc_trt_hist.dat_trt%TYPE;
  v_jc_lastrep_D      fc_trt_hist.dat_trt%TYPE;
  v_numecrrep         fc_ecriture.ide_ecr%TYPE;
  v_numligecrrep      fc_ligne.ide_lig%TYPE;
  v_erreur            NUMBER;
  v_idecpt            fn_compte.ide_cpt%TYPE;
  v_idecptbe          fn_compte.ide_cpt_be%TYPE;
  v_flgjustif         fn_compte.flg_justif%TYPE;
  v_flgjustiftiers    fn_compte.flg_justif_tiers%TYPE;
  v_flgjustifcpt      fn_compte.flg_justif_cpt%TYPE;
  v_totmtlig          fc_ligne.mt%TYPE;
  v_montantcnt        fc_ligne.mt%TYPE;
  v_senscnt           fc_ligne.cod_sens%TYPE;
  v_cod_sens_solde_fg rc_droit_compte.COD_SENS_SOLDE_FG%TYPE;
  v_cod_sens_solde_fg2 rc_droit_compte.COD_SENS_SOLDE_FG%TYPE;
  v_solde_fg		  rc_droit_compte.COD_SENS_SOLDE_FG%TYPE;
  v_codif_libl   	  VARCHAR2(200);
  v_temp    		  NUMBER :=0;
  v_codif_c 		  rc_droit_compte.COD_SENS_SOLDE_FG%TYPE;
  v_codif_n 		  rc_droit_compte.COD_SENS_SOLDE_FG%TYPE;
  v_codif_d			  rc_droit_compte.COD_SENS_SOLDE_FG%TYPE;
  v_codif_x 		  rc_droit_compte.COD_SENS_SOLDE_FG%TYPE;

BEGIN
  Trace('Traitement Reprise :');

  -- Recherche date derniere reprise partielle
  --------------------------------------------
  v_jc_lastrep_P := NULL;
  FOR row1 IN cur_fc_trt_hist(PF_Poste,PF_Gestion,PF_Trtrepsl,PF_Modrepsl_P)
  LOOP
    v_jc_lastrep_P := row1.dat_jc;
    Exit;
  END LOOP;

  -- Recherche date derniere reprise definitive
  ---------------------------------------------
  v_jc_lastrep_D := NULL;
  FOR row1 IN cur_fc_trt_hist(PF_Poste,PF_Gestion,PF_Trtrepsl,PF_Modrepsl_D)
  LOOP
    v_jc_lastrep_D := row1.dat_jc;
    Exit;
  END LOOP;

  -- Parcours des comptes à reprendre
  -----------------------------------
  PF_Ctltraitement := 0;
  v_erreur         := 0;
  FOR row2 IN cur_compte_rep(PF_Poste,PF_Gestion,PF_JC_REP,v_jc_lastrep_P,
                             v_jc_lastrep_D,PF_Modrepsl,PF_Modrepsl_P,PF_Modrepsl_D)
  LOOP
    v_idecpt         := row2.Compte;
    v_idecptbe       := row2.Compte_BE;
    v_flgjustif      := row2.flg_justif;
    v_flgjustiftiers := row2.flg_justif_tiers;
    v_flgjustifcpt   := row2.flg_justif_cpt;

    Trace('----------------------');
    Trace('Compte a reprendre -> '||v_idecpt);
    Trace('Compte de reprise  -> '||v_idecptbe);
    Trace('v_flgjustif        -> '||v_flgjustif);
    Trace('v_flgjustiftiers   -> '||v_flgjustiftiers);
    Trace('v_flgjustifcpt     -> '||v_flgjustifcpt);
    Trace('----------------------');

	-- DEBUT - FBT - 06/03/2008 - Evolution DI44-2007-10 - Controle des soldes réèls des comptes vis à vis du cod_sens_solde_fg
	EXT_CODEXT ( 'SENS_SOLDE_FG', 'C', v_codif_libl, v_codif_c, v_temp );
	EXT_CODEXT ( 'SENS_SOLDE_FG', 'N', v_codif_libl, v_codif_n, v_temp );
	EXT_CODEXT ( 'SENS_SOLDE_FG', 'D', v_codif_libl, v_codif_d, v_temp );
	EXT_CODEXT ( 'SENS_SOLDE_FG', 'X', v_codif_libl, v_codif_x, v_temp );

	SELECT cod_sens_solde_fg
	INTO v_cod_sens_solde_fg
	FROM RC_DROIT_COMPTE
	WHERE ide_cpt= row2.Compte
	AND var_cpta=PF_Varcpta
	AND ide_typ_poste=PF_Typposte;

	SELECT CASE
    	   WHEN SUM(MT_CR)>SUM(MT_DB) THEN v_codif_c
    	   WHEN SUM(MT_CR)<SUM(MT_DB) THEN v_codif_d
    	   WHEN SUM(MT_CR)=SUM(MT_DB) THEN v_codif_n
    	 END
	INTO v_cod_sens_solde_fg2
	FROM FC_CUMUL
	WHERE ide_poste=PF_Poste
	AND ide_gest = PF_Gestion
	AND ide_cpt=row2.Compte
	AND ide_devise is null;

	IF v_cod_sens_solde_fg <> v_codif_x THEN
	   IF v_cod_sens_solde_fg<>v_cod_sens_solde_fg2 THEN
	   	  Trace('----------------------');
		  Trace('ERREUR SUR LE SENS DU SOLDE');
    	  Trace('Sens du Solde du Compte a reprendre -> '||v_cod_sens_solde_fg);
    	  Trace('Sens du Solde du Compte attendue    -> '||v_cod_sens_solde_fg2);
    	  Trace('----------------------');
		  AFF_MESS('E',625,'U212_210B',row2.Compte,'','');
	   	  Return(-1);
	   END IF;
	END IF;
	-- FIN  - FBT - 06/03/2008 - Evolution DI44-2007-10 - Controle des soldes réèl des comptes vis à vis du cod_sens_solde_fg


    -- Creation ecriture reprise
    ----------------------------
    IF MAJ_Ecriture_REP(PF_Poste,PF_Gestion_REP,PF_Journalrep,PF_Oui,PF_JC_BE,
                        PF_Varcptarep,PF_Schemarep,PF_Libnecrrep,PF_Datecrrep,
                        PF_Datejour,PF_Statutecr_C,v_numecrrep) != 0 THEN
      v_erreur := 1;
      Exit;
    END IF;

    -- Creation ligne ecriture
    --------------------------
    IF v_flgjustif = PF_Oui OR
       v_flgjustiftiers = PF_Oui OR
       v_flgjustifcpt = PF_Oui THEN

      -- Compte gere par piece
      ------------------------
      IF GES_Compte_Piece(PF_Poste,PF_Typposte,PF_Gestion,PF_Gestion_REP,PF_JC_REP,
                          v_jc_lastrep_P,v_jc_lastrep_D,PF_Modrepsl_P,PF_Modrepsl_D,
                          v_idecpt,v_idecptbe,PF_Varcpta,PF_Varcptarep,v_flgjustiftiers,
                          PF_Journalrep,PF_Oui,PF_Non,PF_Schemarep,PF_Codtypschemarep,
                          PF_Modeleliggenrep,PF_SensDB,PF_SensCR,v_numecrrep,PF_Datejour,
                          PF_Datecrrep,v_numligecrrep,v_totmtlig) != 0 THEN
        v_erreur := 1;
        Exit;
      END IF;

    ELSE

      -- Compte NON gere par piece
      ----------------------------
      IF GES_Compte_Normal(PF_Poste,PF_Typposte,PF_Gestion,PF_Gestion_REP,PF_JC_REP,
                           v_jc_lastrep_P,v_jc_lastrep_D,PF_Modrepsl_P,PF_Modrepsl_D,
                           v_idecpt,v_idecptbe,PF_Varcpta,PF_Varcptarep,
                           PF_Journalrep,PF_Oui,PF_Schemarep,PF_Codtypschemarep,
                           PF_Modeleliggenrep,PF_SensDB,PF_SensCR,v_numecrrep,PF_Datejour,
                           PF_Datecrrep,v_numligecrrep,v_totmtlig) != 0 THEN
        v_erreur := 1;
        Exit;
      END IF;
    END IF;

    -- Ligne ecriture de contrepartie
    ---------------------------------
    IF NVL(v_totmtlig,0) != 0 THEN

      -- Preparation numero , montant et sens ligne contrepartie a genere
      -------------------------------------------------------------------
      v_numligecrrep := v_numligecrrep + 1;

      Trace('v_totmtlig            -> '||TO_CHAR(v_totmtlig));

      IF v_totmtlig > 0 THEN
        v_montantcnt := v_totmtlig;
        v_senscnt    := PF_SensCR;
      ELSE
        v_montantcnt := -v_totmtlig;
        v_senscnt    := PF_SensDB;
      END IF;

      Trace('v_montantcnt          -> '||TO_CHAR(v_montantcnt));
      Trace('v_senscnt             -> '||v_senscnt);

      -- Creation ligne contrepartie ecriture reprise
      -----------------------------------------------
	  -- Trace('contre partie : poste:'||PF_Poste||' gesrep:'||PF_Gestion_REP||' jrep:'||PF_Journalrep||' flg:'||PF_Oui||' ecr:'||v_numecrrep||' lign:'||v_numligecrrep);
      IF MAJ_Ligne_REP(PF_Poste,PF_Gestion_REP,PF_Journalrep,PF_Oui,v_numecrrep,
                       v_numligecrrep,PF_Varcptarep,PF_Comptecntrep,v_senscnt,
                       v_montantcnt,PF_Schemarep,PF_Codtypschemarep,
                       PF_Modeleligcntrep,PF_Datejour,NULL,NULL,NULL,NULL,NULL,
                       PF_Datecrrep,NULL) != 0 THEN
        v_erreur := 1;
        Exit;
      END IF;
    END IF;

    -- Controle presence de ligne sur ecriture reprise
    --------------------------------------------------
    IF v_numligecrrep = 0 THEN

      -- Suppression ecriture reprise sans ligne
      ------------------------------------------
      IF MAJ_Del_Ecriture_REP(PF_Poste,PF_Gestion_REP,PF_Journalrep,PF_Oui,
                              v_numecrrep) != 0 THEN
        v_erreur := 1;
        Exit;
      END IF;

    ELSE

      -- Controle Traitement
      ----------------------
      IF CTL_Validation(PF_Poste,PF_Typposte,PF_Gestion_REP,PF_Varcptarep,v_idecptbe,
                        PF_Oui,PF_SensDB,PF_SensCR,PF_Ctltraitement) != 0 THEN
        v_erreur := 1;
        Exit;
      END IF;
    END IF;

  END LOOP;

  IF v_erreur != 0 THEN
    Return(-1);
  END IF;

  -- Traitement OK
  ----------------
  Return(0);


EXCEPTION
  WHEN Others THEN
    AFF_MESS('E',105,'U212_210B',SUBSTR('(GES_Reprise) '||SQLERRM,1,80),'','');
    Return(-1);

END GES_Reprise;

/* ********************************************** */
/* Fonction de creation ligne ecriture de reprise */
/* ********************************************** */
FUNCTION MAJ_Fc_Trt_Hist(PF_Poste          IN    fc_ligne.ide_poste%TYPE,
                         PF_Gestion        IN    fc_ligne.ide_gest%TYPE,
                         PF_Gestion_REP    IN    fc_ligne.ide_gest%TYPE,
                         PF_JC_REP         IN    fc_ecriture.dat_jc%TYPE,
                         PF_JC_BE          IN    fc_ecriture.dat_jc%TYPE,
                         PF_Trtrepsl       IN    sr_cpt_trt.cod_traitement%TYPE,
                         PF_Modrepsl       IN    VARCHAR2,
                         PF_Datejour       IN    fc_ecriture.dat_saisie%TYPE) RETURN NUMBER IS

BEGIN
  -- Insertion
  ------------
  INSERT INTO fc_trt_hist
    (cod_traitement,ide_poste,ide_gest,
     dat_trt,dat_jc,
     mod_rep,ide_gest_rep,dat_jc_rep,
     dat_cre,dat_maj)
  VALUES
    (PF_Trtrepsl,PF_Poste,PF_Gestion,
     PF_Datejour,PF_JC_REP,
     PF_Modrepsl,PF_Gestion_REP,PF_JC_BE,
     PF_Datejour,PF_Datejour);

  Trace('Creation FC_TRT_HIST');

  Return(0);


EXCEPTION
  WHEN Others THEN
    AFF_MESS('E',105,'U212_210B',SUBSTR('(MAJ_Fc_Trt_Hist) '||SQLERRM,1,80),'','');
    Return(-1);

END MAJ_Fc_Trt_Hist;

/* ******************************************** */
/*                   MAIN                       */
/* ******************************************** */
BEGIN

  -- MODIF SGN FCT48 : Initialisation des traces
  ASTER_VAR.get_var('NIVEAU_TRACE_VAR','P_NIV_TRACE', v_niveau_trace, v_num_trt);
  GLOBAL.INI_NIVEAU_TRACE(NVL(v_niveau_trace,0));
  -- FIn modif SGN

  Trace('U212_210B : Debut traitement');

  -- Recuperation code externe
  ----------------------------
  EXT_Codext('STATUT_JOURNEE', 'O', v_libl, v_statut_journee_O, v_retour);
  Trace('v_statut_journee_O - '||v_statut_journee_O);
  IF (v_retour != 1) THEN
    AFF_MESS('E',159,'U212_210B','STATUT_JOURNEE - O','','');
    RAISE Erreur_Codext;
  END IF;

  EXT_Codext('STATUT_JOURNEE', 'C', v_libl, v_statut_journee_C, v_retour);
  Trace('v_statut_journee_C - '||v_statut_journee_C);
  IF (v_retour != 1) THEN
    AFF_MESS('E',159,'U212_210B','STATUT_JOURNEE - C','','');
    RAISE Erreur_Codext;
  END IF;

  EXT_Codext('OUI_NON', 'O', v_libl, v_oui, v_retour);
  Trace('v_oui - '||v_oui);
  IF (v_retour != 1) THEN
    AFF_MESS('E',159,'U212_210B','OUI_NON - O','','');
    RAISE Erreur_Codext;
  END IF;

  EXT_Codext('OUI_NON', 'N', v_libl, v_non, v_retour);
  Trace('v_non - '||v_non);
  IF (v_retour != 1) THEN
    AFF_MESS('E',159,'U212_210B','OUI_NON - N','','');
    RAISE Erreur_Codext;
  END IF;

  EXT_Codext('SENS', 'D', v_libl, v_sens_debit, v_retour);
  Trace('v_sens_debit - '||v_sens_debit);
  IF (v_retour != 1) THEN
    AFF_MESS('E',159,'U212_210B','SENS - D','','');
    RAISE Erreur_Codext;
  END IF;

  EXT_Codext('SENS', 'C', v_libl, v_sens_credit, v_retour);
  Trace('v_sens_credit - '||v_sens_credit);
  IF (v_retour != 1) THEN
    AFF_MESS('E',159,'U212_210B','SENS - C','','');
    RAISE Erreur_Codext;
  END IF;

  EXT_Codext('TRAITEMENT', 'REPSL', v_libl, v_trtrepsl, v_retour);
  Trace('v_trtrepsl - '||v_trtrepsl);
  IF (v_retour != 1) THEN
    AFF_MESS('E',159,'U212_210B','TRAITEMENT - REPSL','','');
    RAISE Erreur_Codext;
  END IF;

  EXT_Codext('REPRISE_SOLDE', 'D', v_libl, v_modrepsl_D, v_retour);
  Trace('v_modrepsl_D - '||v_modrepsl_D);
  IF (v_retour != 1) THEN
    AFF_MESS('E',159,'U212_210B','REPRISE_SOLDE - D','','');
    RAISE Erreur_Codext;
  END IF;

  EXT_Codext('REPRISE_SOLDE', 'P', v_libl, v_modrepsl_P, v_retour);
  Trace('v_modrepsl_P - '||v_modrepsl_P);
  IF (v_retour != 1) THEN
    AFF_MESS('E',159,'U212_210B','REPRISE_SOLDE - P','','');
    RAISE Erreur_Codext;
  END IF;

  EXT_Codext('STATUT_ECR', 'V', v_libl, v_statut_ecr_C, v_retour);
  Trace('v_statut_ecr_C - '||v_statut_ecr_C);
  IF (v_retour != 1) THEN
    AFF_MESS('E',159,'U212_210B','STATUT_ECR - V','','');
    RAISE Erreur_Codext;
  END IF;

  IF P_TYP_TRT_REP = v_modrepsl_D THEN
    EXT_Codext('U212_210B', 'D', v_libl, v_codcodif, v_retour);
    IF (v_retour != 1) THEN
      AFF_MESS('E',159,'U212_210B','U212_210B - D','','');
      RAISE Erreur_Codext;
    END IF;
  ELSE
    EXT_Codext('U212_210B', 'P', v_libl, v_codcodif, v_retour);
    IF (v_retour != 1) THEN
      AFF_MESS('E',159,'U212_210B','U212_210B - P','','');
      RAISE Erreur_Codext;
    END IF;
  END IF;

  -- MODIF SGN ANOVA303 : Recuperation du code interne de la devise de reference
  EXT_PARAM('IC0026', v_codint_devise_ref, v_retour);
  IF v_retour != 1 THEN
    AFF_MESS('E', 792, 'U212_210B', '', '', '');
    RAISE Erreur_Param;
  END IF;

  EXT_Codext('CODE_DEVISE', v_codint_devise_ref, v_libl_dev, v_codext_devise_ref, v_retour);
  IF (v_retour != 1) THEN
    AFF_MESS('E',159,'U212_210B','CODE_DEVISE - '||v_codint_devise_ref,'','');
    RAISE Erreur_Codext;
  END IF;
  -- fin modif sgn

  SELECT SUBSTR(REPLACE(v_libl,'%1',P_IDE_GEST),1,45) INTO v_libnecrrep FROM dual;

  Trace('v_libnecrrep - '||v_libnecrrep);


  -- Controle avant traitement
  ----------------------------
  IF CTL_Reprise(P_IDE_POSTE,P_IDE_GEST,P_IDE_GEST_REP,
                 P_DAT_JC_REP,P_DAT_JC_BE,v_statut_journee_C,
                 v_statut_journee_O,v_trtrepsl,v_non,P_TYP_TRT_REP,
                 v_modrepsl_P,v_modrepsl_D,v_typposte,v_varcpta,
                 v_varcptarep,v_datdvalgestrep,v_journalrep,v_schemarep,
                 v_codtypschemarep,v_modeleliggenrep,v_modeleligcntrep,
                 v_comptecntrep) != 0 THEN
    RAISE Erreur_Controle;
  END IF;

  Trace('Information Reprise :');
  Trace('v_varcpta         -> '||v_varcpta);
  Trace('v_varcptarep      -> '||v_varcptarep);
  Trace('v_datdvalgestrep  -> '||TO_CHAR(v_datdvalgestrep));
  Trace('v_journalrep      -> '||v_journalrep);
  Trace('v_schemarep       -> '||v_schemarep);
  Trace('v_codtypschemarep -> '||v_codtypschemarep);
  Trace('v_modeleliggenrep -> '||v_modeleliggenrep);
  Trace('v_modeleligcntrep -> '||v_modeleligcntrep);
  Trace('v_comptecntrep    -> '||v_comptecntrep);


  -- Traitement
  -------------
  IF GES_Reprise(P_IDE_POSTE,v_typposte,P_IDE_GEST,P_IDE_GEST_REP,
                 P_DAT_JC_REP,P_DAT_JC_BE,v_trtrepsl,
                 P_TYP_TRT_REP,v_modrepsl_P,v_modrepsl_D,
                 v_journalrep,v_oui,v_non,v_sens_debit,
                 v_sens_credit,v_varcpta,v_varcptarep,
                 v_schemarep,v_codtypschemarep,
                 v_modeleliggenrep,v_modeleligcntrep,
                 v_comptecntrep,v_libnecrrep,v_datdvalgestrep,
                 v_datejour,v_statut_ecr_C,v_ctltraitement) != 0 THEN
    RAISE Erreur_Traitement;
  END IF;


  IF v_ctltraitement = 0 THEN

    -- Fin normale du traitement
    ----------------------------
    Trace('U212_210B : Fin normale du traitement');

    -- Insertion FC_TRT_HIST
    ------------------------
    IF MAJ_Fc_Trt_Hist(P_IDE_POSTE,P_IDE_GEST,P_IDE_GEST_REP,P_DAT_JC_REP,
                       P_DAT_JC_BE,v_trtrepsl,P_TYP_TRT_REP,v_datejour)!= 0 THEN
      RAISE Erreur_Traitement;
    END IF;

    COMMIT;

    -- Lancement U212_230E
    ----------------------
    Trace('Edition U212_230E Soumise ');
    v_retour := GES_LANCER_TRAITEMENT('U212_230E',
                                      'P_IDE_POSTE='||P_IDE_POSTE
                                    ||'|P_IDE_GEST='||P_IDE_GEST_REP
                                    ||'|P_JL_IDE_JAL='||v_journalrep
                                    ||'|P_JL_DATE_DEB='||TO_CHAR(P_DAT_JC_BE)
                                    ||'|P_JL_DATE_FIN='||TO_CHAR(P_DAT_JC_BE)
                                      ,1      -- Un exemplaire
                                      ,'|'    -- séparateur des paramètres
            					    );

    Return(0);
  ELSE

    -- Fin ANORMALE du traitement
    -----------------------------
    RAISE Erreur_Traitement;
  END IF;

EXCEPTION
  WHEN Erreur_Codext THEN
    Trace('U212_210B : Erreur_Codext');
    Return(-1);

  WHEN Erreur_Controle THEN
    Trace('U212_210B : Erreur_Controle');
    Return(-1);

  WHEN Erreur_Traitement THEN
    ROLLBACK;
    Trace('U212_210B : Erreur_Traitement');
    Return(-1);

  WHEN Others THEN
    ROLLBACK;
    Trace('U212_210B : Others');
    AFF_MESS('E',108,'U212_210B','U212_210B','','');
    Return(-1);

END U212_210B;

/

CREATE OR REPLACE FUNCTION z_cg_or_dat_bascule(P_LIBEL VARCHAR2,P_IDE_GEST VARCHAR2,PP_IDE_GEST VARCHAR2)
RETURN VARCHAR2
IS

----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_CG_OR_DAT_BASCULE
-- DATE CREATION  : 18/09/2006
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : RECHERCHE DES DAT_EMIS ET DAT_CAD DE FB_PIECE

----------------------------------------------------------------------------------
--                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
----------------------------------------------------------------------------------
-- Z_CG_OR_DAT_BASCULE       | 1.0        |18/09/2006| IL          |
----------------------------------------------------------------------------------

-- PARAMETRES ------------
-- P_LIBEL : LIBELLé GéNéRé PAR LE PROGRAMME DE BASCULE
-- P_IDE_GEST : GESTION DU MOUVEMENT GéNéRé
-- PP_IDE_GEST : GESTION BASCULéE
----------------------------------------------------------------------------------


V_DAT_EMIS DATE;
BEGIN
IF P_LIBEL='BASCULE' THEN V_DAT_EMIS:='01/01/'||P_IDE_GEST;
ELSIF P_IDE_GEST=PP_IDE_GEST+1 THEN V_DAT_EMIS:=TRUNC(SYSDATE);
ELSE V_DAT_EMIS:='31/12/'||P_IDE_GEST;
END IF;
RETURN V_DAT_EMIS;
END z_cg_or_dat_bascule;

/

CREATE OR REPLACE FUNCTION z_cg_or_der_cpt_ligne(P_IDE_LIG_EXEC VARCHAR2,P_IDE_GEST VARCHAR2)
RETURN VARCHAR2
IS
----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_CG_OR_DER_CPT_LIGNE
-- DATE CREATION  : 18/09/2006
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : RECHERCHE DU COMPTE RATTACHE A LA PIECE

----------------------------------------------------------------------------------
--                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
----------------------------------------------------------------------------------
-- Z_CG_OR_DER_CPT_LIGNE      | 1.0        |18/09/2006| IL          |
----------------------------------------------------------------------------------

-- PARAMETRES ------------
-- P_IDE_LIG_EXEC : LIGNE D'EXéCUTION
-- P_IDE_GEST     : GESTION
----------------------------------------------------------------------------------
V_IDE_CPT VARCHAR2(20);
BEGIN
SELECT DISTINCT IDE_CPT_ANA INTO V_IDE_CPT
FROM FN_LIGNE_BUD_EXEC
WHERE  VAR_BUD='VR'||SUBSTR(P_IDE_GEST,3,2)
AND IDE_LIG_EXEC=P_IDE_LIG_EXEC;
RETURN V_IDE_CPT;
END z_cg_or_der_cpt_ligne;

/

CREATE OR REPLACE FUNCTION z_cg_or_der_cpt_tiers(P_IDE_REF_PIECE VARCHAR2,P_IDE_GEST VARCHAR2,TYP VARCHAR2)
RETURN VARCHAR2
IS

----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_CG_OR_DER_CPT_TIERS
-- DATE CREATION  : 18/09/2006
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : RECHERCHE DU COMPTE RATTACHE AU TIERS

----------------------------------------------------------------------------------
--                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
----------------------------------------------------------------------------------
-- Z_CG_OR_DER_CPT_TIERS      | 1.0        |18/09/2006| IL          |
----------------------------------------------------------------------------------

-- PARAMETRES ------------

-- P_IDE_REF_PIECE : NUMéRO DE LA PIèCE (FC_REF_PIECE)
-- P_IDE_GEST : GESTION SUR LAQUELLE LE MOUVEMENT EST CRéé
-- TYP =A LIGNE COURANTE
--     =B LIGNE SOLDéE MAIS BASCULéE CAR RATTACHéE AU N TITRE NON SOLDE DE L'ANNEE PRECEDENTE

----------------------------------------------------------------------------------------------
V_IDE_CPT VARCHAR2(20);
V_IDE_REF_PIECE NUMBER(6);
V_CPT NUMBER(6);
BEGIN
IF TYP='B' THEN V_IDE_REF_PIECE:=P_IDE_REF_PIECE;
ELSE
SELECT MIN(IDE_REF_PIECE) INTO V_IDE_REF_PIECE FROM FC_LIGNE WHERE
IDE_GEST=P_IDE_GEST
AND IDE_REF_PIECE IN(
SELECT IDE_REF_PIECE FROM FC_REF_PIECE WHERE IDE_POSTE||IDE_GEST||IDE_ORDO||COD_BUD||IDE_PIECE||COD_TYP_PIECE IN(
SELECT  IDE_POSTE||IDE_GEST||IDE_ORDO||COD_BUD||IDE_PIECE||COD_TYP_PIECE FROM FC_REF_PIECE WHERE IDE_REF_PIECE=P_IDE_REF_PIECE));
END IF;



SELECT DISTINCT IDE_CPT INTO V_IDE_CPT
FROM FC_LIGNE
WHERE  IDE_GEST=P_IDE_GEST
AND IDE_REF_PIECE=V_IDE_REF_PIECE
AND COD_SENS='D'
AND FLG_CPTAB='O'
AND DAT_MAJ IN(
SELECT MAX(DAT_MAJ)
FROM FC_LIGNE
WHERE  IDE_GEST=P_IDE_GEST
AND IDE_REF_PIECE=V_IDE_REF_PIECE
AND COD_SENS='D'
AND FLG_CPTAB='O');


RETURN V_IDE_CPT;
END z_cg_or_der_cpt_tiers;

/

CREATE OR REPLACE FUNCTION z_cg_or_der_lig_exec(P_IDE_REF_PIECE VARCHAR2,P_IDE_GEST VARCHAR2,TYP VARCHAR2)
RETURN VARCHAR2
IS
----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_CG_OR_DER_LIG_EXEC
-- DATE CREATION  : 18/09/2006
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : RECHERCHE DE LA LIGNE D'EXECUTION

----------------------------------------------------------------------------------
--                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
----------------------------------------------------------------------------------
-- Z_CG_OR_DER_LIG_EXEC       | 1.0        |18/09/2006| IL          |
----------------------------------------------------------------------------------

-- PARAMETRES ------------

-- P_IDE_REF_PIECE : NUMéRO DE LA PIèCE (FC_REF_PIECE)
-- P_IDE_GEST : GESTION SUR LAQUELLE LE MOUVEMENT EST CRéé
-- TYP =A LIGNE COURANTE
--     =B LIGNE SOLDéE MAIS BASCULéE CAR RATTACHéE AU N TITRE NON SOLDE DE L'ANNEE PRECEDENTE

----------------------------------------------------------------------------------------------

V_IDE_LIG_EXEC VARCHAR2(20);
V_IDE_REF_PIECE NUMBER(6);
V_CPT NUMBER(6);
V_IDE_GEST FC_LIGNE.IDE_GEST%TYPE;
V_IDE_ECR FC_LIGNE.IDE_GEST%TYPE;
V_IDE_JAL FC_LIGNE.IDE_GEST%TYPE;
BEGIN
IF TYP='B' THEN V_IDE_REF_PIECE:=P_IDE_REF_PIECE;
ELSE
SELECT MIN(IDE_REF_PIECE) INTO V_IDE_REF_PIECE FROM FC_LIGNE WHERE
IDE_GEST=P_IDE_GEST
AND IDE_REF_PIECE IN(
SELECT IDE_REF_PIECE FROM FC_REF_PIECE WHERE IDE_POSTE||IDE_GEST||IDE_ORDO||COD_BUD||IDE_PIECE||COD_TYP_PIECE IN(
SELECT  IDE_POSTE||IDE_GEST||IDE_ORDO||COD_BUD||IDE_PIECE||COD_TYP_PIECE FROM FC_REF_PIECE WHERE IDE_REF_PIECE=P_IDE_REF_PIECE));
END IF;

SELECT COUNT(DISTINCT SPEC1) INTO V_CPT
FROM FC_LIGNE WHERE  IDE_GEST=P_IDE_GEST
AND IDE_REF_PIECE=V_IDE_REF_PIECE
AND FLG_CPTAB='O'
AND SPEC1 IS NOT NULL AND COD_SENS='D';




IF V_CPT<>0 THEN
SELECT DISTINCT SPEC1 INTO V_IDE_LIG_EXEC FROM FC_LIGNE WHERE  IDE_GEST=P_IDE_GEST AND IDE_REF_PIECE=V_IDE_REF_PIECE AND SPEC1 IS NOT NULL AND COD_SENS='D';
END IF;

IF P_IDE_GEST<2006 AND V_CPT=0 THEN


SELECT DISTINCT IDE_GEST,IDE_JAL,IDE_ECR INTO V_IDE_GEST,V_IDE_JAL,V_IDE_ECR
FROM FC_LIGNE WHERE FLG_CPTAB='O'
AND IDE_REF_PIECE=P_IDE_REF_PIECE
AND IDE_CPT LIKE '41%'
AND IDE_GEST=P_IDE_GEST
AND COD_SENS='D' AND MT>0
AND DAT_MAJ IN(
SELECT MAX(DAT_MAJ)
FROM FC_LIGNE WHERE FLG_CPTAB='O'
AND IDE_REF_PIECE=P_IDE_REF_PIECE
AND IDE_CPT LIKE '41%'
AND IDE_GEST=P_IDE_GEST
AND COD_SENS='D' AND MT>0);



SELECT DISTINCT IDE_LIG_EXEC INTO V_IDE_LIG_EXEC FROM FC_LIGNE WHERE
IDE_GEST=V_IDE_GEST
AND IDE_JAL=V_IDE_JAL
AND IDE_ECR=V_IDE_ECR
AND IDE_LIG_EXEC IS NOT NULL
AND COD_SENS='C'
AND IDE_CPT LIKE'3%';

END IF;


RETURN V_IDE_LIG_EXEC;
END z_cg_or_der_lig_exec;

/

CREATE OR REPLACE FUNCTION Z_cg_or_IDE_TIERS
  (P_VAR_TIERS VARCHAR2,P_IDE_TIERS VARCHAR2,TYP VARCHAR2)
RETURN VARCHAR2
IS
----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_CG_OR_IDE_TIERS
-- DATE CREATION  : 18/09/2006
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : RECHERCHE D'INFORMATIONS SUR UN TIERS

----------------------------------------------------------------------------------
--                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
----------------------------------------------------------------------------------
-- Z_CG_OR_IDE_TIERS          | 1.0        |18/09/2006| IL          |
----------------------------------------------------------------------------------

-- PARAMETRES ------------
-- P_VAR_TIERS : VARIATION DES TIERS
-- P_IDE_TIERS : IDE_TIERS DU TIERS DéSIRé
-- TYP         : ZONE DéSIRéE
----------------------------------------------------------------------------------
  V_NOM             VARCHAR2 (45);
  V_PRENOM          VARCHAR2 (45);
  V_NOM_CONTRIB     VARCHAR2 (20);
  V_COD_CAT_SOCIOP  VARCHAR2 (5);
  V_COD_SEC         VARCHAR2 (5);
  V_COD_TYP_TIERS   CHAR (1);
  V_ADR1            VARCHAR2 (32);
  V_ADR2            VARCHAR2 (32);
  V_ADR3            VARCHAR2 (32);
  V_ADR4            VARCHAR2 (32);
  V_VILLE           VARCHAR2 (32);
  V_CP              VARCHAR2 (10);
  V_BP              VARCHAR2 (10);
  V_PAYS            VARCHAR2 (32);
  V_TELEPH          VARCHAR2 (15);

BEGIN
SELECT
	NOM ,
	PRENOM ,
	NOM_CONTRIB ,
	COD_CAT_SOCIOP ,
	COD_SEC ,
	COD_TYP_TIERS,
	ADR1 ,
	ADR2 ,
	ADR3 ,
	ADR4 ,
	VILLE ,
	CP ,
	BP ,
	PAYS ,
	TELEPH
	INTO
	V_NOM ,
	V_PRENOM ,
	V_NOM_CONTRIB ,
	V_COD_CAT_SOCIOP ,
	V_COD_SEC ,
	V_COD_TYP_TIERS,
	V_ADR1 ,
	V_ADR2 ,
	V_ADR3 ,
	V_ADR4 ,
	V_VILLE ,
	V_CP ,
	V_BP ,
	V_PAYS ,
	V_TELEPH
FROM RB_TIERS
WHERE
IDE_TIERS=P_IDE_TIERS;
IF TYP='NOM' THEN RETURN V_NOM;
ELSIF TYP='PRENOM' THEN RETURN V_PRENOM;
ELSIF TYP='NOM_CONTRIB' THEN RETURN V_NOM_CONTRIB;
ELSIF TYP='COD_CAT_SOCIOP' THEN RETURN V_COD_CAT_SOCIOP;
ELSIF TYP='COD_SEC' THEN RETURN V_COD_SEC;
ELSIF TYP='COD_TYP_TIERS' THEN RETURN V_COD_TYP_TIERS;
ELSIF TYP='ADR1' THEN RETURN V_ADR1;
ELSIF TYP='ADR2' THEN RETURN V_ADR2;
ELSIF TYP='ADR3' THEN RETURN V_ADR3;
ELSIF TYP='ADR4' THEN RETURN V_ADR4;
ELSIF TYP='VILLE' THEN RETURN V_VILLE;
ELSIF TYP='CP' THEN RETURN V_CP;
ELSIF TYP='BP' THEN RETURN V_BP;
ELSIF TYP='PAYS' THEN RETURN V_PAYS ;
ELSIF TYP='TELEPH' THEN RETURN V_TELEPH ;
END IF;
END Z_cg_or_IDE_TIERS;

/

CREATE OR REPLACE FUNCTION z_cg_or_SITE_ORDO(P_DORD CHAR)
RETURN VARCHAR2
IS
----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_CG_OR_SITE_ORDO
-- DATE CREATION  : 18/09/2006
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : RECHERCHE DU SITE DE L'ORDONNATEUR

----------------------------------------------------------------------------------
--                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
----------------------------------------------------------------------------------
-- Z_CG_OR_SITE_ORDO      | 1.0        |18/09/2006| IL          |
----------------------------------------------------------------------------------

-- PARAMETRES ------------
-- P_DORD : ORDONNATEUR
----------------------------------------------------------------------------------
V_SITE_ORDO VARCHAR2(5);
BEGIN

SELECT IDE_SITE INTO V_SITE_ORDO FROM RM_NOEUD WHERE IDE_ND=P_DORD;

RETURN( V_SITE_ORDO);
END z_cg_or_SITE_ORDO;

/

CREATE OR REPLACE FUNCTION z_cg_or_verif_zr_ordre_cg (
P_IDE_GEST VARCHAR2,
P_IDE_ORDO VARCHAR2,
P_DAT_CAD DATE,
P_IDE_CPT VARCHAR2,
P_IDE_LIG_EXEC VARCHAR2,
P_IDE_CPT_TIERS VARCHAR2,
P_TYP_LIG VARCHAR2,
P_COD_TYP_PIECE VARCHAR2)
RETURN VARCHAR2
IS
----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_CG_OR_VERIF_ZR_ORDRE_CG
-- DATE CREATION  : 18/09/2006
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : VERIFICATION GLOBALE DE ZR_ORDRE_CG : ORDO, IDE_CPT,IDE_LIG_EXEC
--                  PAR RAPPORT A LA NOMENCLATURE

----------------------------------------------------------------------------------
--                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
----------------------------------------------------------------------------------
-- Z_CG_OR_VERIF_ZR_ORDRE_CG  | 1.0        |18/09/2006| IL          |
----------------------------------------------------------------------------------

-- PARAMETRES ------------
-- P_IDE_GEST : GESTION
-- P_IDE_ORDO : ORDONNATEUR
-- P_DAT_CAD   : DAT_CAD
-- P_IDE_CPT   : COMPTE (LIGNE_PIECE)
-- P_IDE_LIG_EXEC : LIGNE D'EXéCUTION (LIGNE PIECE)
-- P_IDE_CPT_TIERS : IDE_CPT (LIGNE_TIERS_PIECE)
-- P_TYP_LIG : 1=FB_PIECE
--             2=FB_LIGNE_PIECE
-- 			   3=FB_LIGNE_TIERS_PIECE
-- P_COD_TYP_PIECE : AR : ANNULATION DE RECETTE
--                   OR : PRISE EN CHARGE DE RECETTE
----------------------------------------------------------------------------------
V_ANO1 NUMBER(6):=1;--ORDO-RM_NOEUD
V_ANO2 NUMBER(6):=1;--ORDO-FN_LP_RPO
V_ANO3 NUMBER(6):=1;--FN_COMPTE
V_ANO4 NUMBER(6):=1;--FN_COMPTE
V_ANO5 NUMBER(6):=1;--FN_LIGNE_BUD_EXEC
V_ANO6 NUMBER(6):=1;--RC_LISTE_COMPTE
V_LIBELLE VARCHAR2(50):=NULL;
V_RETURN VARCHAR2(2);
BEGIN
--TYP_LIG=1
IF P_TYP_LIG =1 THEN
   SELECT COUNT(*) INTO V_ANO1 FROM RM_NOEUD WHERE COD_TYP_ND='O' AND IDE_ND=P_IDE_ORDO
   AND (P_DAT_CAD<TRUNC(DAT_FVAL)OR DAT_FVAL IS NULL);
   SELECT COUNT(*) INTO V_ANO2 FROM FN_LP_RPO WHERE IDE_GEST=P_IDE_GEST AND COD_BUD='BGREC' AND IDE_ORDO=P_IDE_ORDO;

--TYP_LIG=2
ELSIF P_TYP_LIG=2 THEN
    V_ANO1:=1;
    V_ANO2:=1;
    IF P_IDE_GEST<2006 THEN
        SELECT COUNT(*) INTO V_ANO3 FROM FN_COMPTE WHERE VAR_CPTA='VCCPE' AND IDE_CPT=P_IDE_CPT AND
        (DAT_DVAL IS NULL OR '01/01/'||P_IDE_GEST>TRUNC(DAT_DVAL))
        AND (DAT_FVAL IS NULL OR '31/12'||P_IDE_GEST<TRUNC(DAT_FVAL));
        ELSE
        SELECT COUNT(*) INTO V_ANO3 FROM FN_COMPTE WHERE VAR_CPTA='VLOLF' AND IDE_CPT=P_IDE_CPT AND
        (DAT_DVAL IS NULL OR '01/01/'||P_IDE_GEST>TRUNC(DAT_DVAL))
        AND (DAT_FVAL IS NULL OR '31/12'||P_IDE_GEST<TRUNC(DAT_FVAL));
    END IF;

    SELECT COUNT(*) INTO V_ANO5 FROM FN_LIGNE_BUD_EXEC WHERE VAR_BUD='VR'||SUBSTR(P_IDE_GEST,3,2)
	AND IDE_LIG_EXEC=P_IDE_LIG_EXEC;



--TYP_LIG=3
ELSIF P_TYP_LIG=3 THEN
V_ANO1:=1;
V_ANO2:=1;

       IF P_IDE_GEST<2006 THEN
       SELECT COUNT(*) INTO V_ANO4 FROM FN_COMPTE WHERE VAR_CPTA='VCCPE' AND IDE_CPT=P_IDE_CPT_TIERS AND
       (DAT_DVAL IS NULL OR '01/01/'||P_IDE_GEST>TRUNC(DAT_DVAL))
       AND (DAT_FVAL IS NULL OR '31/12'||P_IDE_GEST<TRUNC(DAT_FVAL));

       SELECT COUNT(*) INTO V_ANO6  FROM RC_LISTE_COMPTE
       WHERE COD_LIST_CPT =P_COD_TYP_PIECE||'TIE'
       AND VAR_CPTA='VCCPE'
       AND IDE_CPT=P_IDE_CPT_TIERS;

       ELSE
       SELECT COUNT(*) INTO V_ANO4 FROM FN_COMPTE WHERE VAR_CPTA='VLOLF' AND IDE_CPT=P_IDE_CPT_TIERS AND
       (DAT_DVAL IS NULL OR '01/01/'||P_IDE_GEST>TRUNC(DAT_DVAL))
       AND (DAT_FVAL IS NULL OR '31/12'||P_IDE_GEST<TRUNC(DAT_FVAL));
       SELECT COUNT(*) INTO V_ANO6  FROM RC_LISTE_COMPTE
       WHERE COD_LIST_CPT =P_COD_TYP_PIECE||'TIE'
       AND VAR_CPTA='VLOLF'
       AND IDE_CPT=P_IDE_CPT_TIERS;

       END IF;

END IF;
--ANALYSE DU RESULTAT
IF V_ANO1=0
OR V_ANO2=0
OR V_ANO3=0
OR V_ANO4=0
OR V_ANO5=0
OR V_ANO6=0
THEN

    IF V_ANO1=0 THEN V_LIBELLE:=V_LIBELLE||' '||'ORDO-RM_NOEUD ';END IF;
	IF V_ANO2=0 THEN V_LIBELLE:=V_LIBELLE||' '||'ORDO-FN_LP_RPO ';END IF;
	IF V_ANO3=0 THEN V_LIBELLE:=V_LIBELLE||' '||'IDE_CPT-FN_COMPTE ';END IF;
	IF V_ANO4=0 THEN V_LIBELLE:=V_LIBELLE||' '||'IDE_CPT_TIERS-FN_COMPTE ';END IF;
	IF V_ANO5=0 THEN V_LIBELLE:=V_LIBELLE||' '||'FN_LIGNE_BUD_EXEC ';END IF;
	IF V_ANO6=0 THEN V_LIBELLE:=V_LIBELLE||' '||'IDE_CPT_TIERS-RC_LISTE_COMPTE ';END IF;
    RETURN 'NO '||V_LIBELLE;

ELSE
RETURN 'OK';
END IF;
END z_cg_or_verif_zr_ordre_cg;

/

CREATE OR REPLACE FUNCTION Z_Cod_Act_Ssact_Cg(p_ide_lig_exe VARCHAR2,p_ide_lig_prev_new VARCHAR2,p_cod_titcat VARCHAR2,p_var_bud_new VARCHAR2)
    RETURN NUMBER
    IS
    ----------------------------------------------------------------------------------
    -- FICHIER        : FUNCTION Z_COD_ACT_SSACT_CG
    -- DATE CREATION  : 18/09/2006
    -- AUTEUR         : ISABELLE LARONDE
    --
    -- LOGICIEL       : ASTER
    -- SOUS-SYSTEME   : NOM
    -- DESCRIPTION    : RECHERCHE DE LA CORRESPONDANS DE COD_ACT_SSACT DANS LA NOUVELLE NOMENCLATURE

    ----------------------------------------------------------------------------------
    --                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
    ----------------------------------------------------------------------------------
    -- Z_TITCAT                   | 1.0        |18/09/2006| IL          |
    ----------------------------------------------------------------------------------

    -- PARAMETRES ------------
    -- P_IDE_LIG_PREV ,P_COD_ACT_SSACT :
             -- LIGNE DE PRéVISION, CODE ACTION-SOUS ACTION
             -- POUR LESQUELS ON RECHERCHE LA CORRESPONDANCE DANS LA NOUVELLE NOMENCLATURE
    ----------------------------------------------------------------------------------
    p_ide_lig_prev_new1 VARCHAR2(6);
    v_retour NUMBER(7);
    v_cpt NUMBER(7);
    BEGIN

        p_ide_lig_prev_new1:=SUBSTR(p_ide_lig_prev_new,2,6);
        --CAS L'IMPUTATION EST SUPPRIMéE
        SELECT COUNT(DISTINCT ide_lig_exe_apres) INTO v_cpt
        FROM ZB_TRANSLAT_EXE
        WHERE ide_lig_exe_avant =p_ide_lig_exe AND ide_lig_exe_apres IS NULL;

        IF v_cpt=1 THEN
            RETURN NULL;
        END IF;

        --CAS IMPUTATION SANS CHANGEMENT (NE FIGURE PAS DANS LA TABLE DE CORRESPONDANCE)

        SELECT COUNT(DISTINCT ide_lig_exe_apres) INTO v_cpt
        FROM ZB_TRANSLAT_EXE
        WHERE ide_lig_exe_avant =p_ide_lig_exe AND SUBSTR(ide_lig_exe_apres,1,6)=p_ide_lig_prev_new1;

        IF v_cpt=0 THEN
            v_retour:=SUBSTR(p_ide_lig_exe,7,2);
            -- VERIFICATION DE LA NOM D'EXECUTION
            SELECT COUNT(*) INTO V_CPT
            FROM FN_LIGNE_BUD_EXEC
            WHERE VAR_BUD=P_VAR_BUD_NEW
            AND FLG_IMPUT='O'
            AND LIBC =REPLACE(P_IDE_LIG_PREV_NEW,'.',NULL)||'-'||LPAD(P_COD_TITCAT,2,'0')||'-'||LPAD(V_RETOUR,2,'0');

            IF V_CPT=0 THEN
                V_RETOUR:=NULL;END IF;

            RETURN v_retour;
        END IF;

        --CAS L'IMPUTATION EST ECLATéE OU FUSIONNéE AVEC D'AUTRE MAIS éGALEMENT SUR ELLE-MêME
        SELECT COUNT(DISTINCT ide_lig_exe_apres) INTO v_cpt
        FROM ZB_TRANSLAT_EXE
        WHERE ide_lig_exe_avant =p_ide_lig_exe AND ide_lig_exe_apres = p_ide_lig_exe;

         IF v_cpt=1 THEN
            v_retour:= SUBSTR(p_ide_lig_exe,7,2);
            -- VERIFICATION DE LA NOM D'EXECUTION
            SELECT COUNT(*) INTO V_CPT
            FROM FN_LIGNE_BUD_EXEC
            WHERE VAR_BUD=P_VAR_BUD_NEW
            AND FLG_IMPUT='O'
            AND LIBC =REPLACE(P_IDE_LIG_PREV_NEW,'.',NULL)||'-'||LPAD(P_COD_TITCAT,2,'0')||'-'||LPAD(V_RETOUR,2,'0');

            IF V_CPT=0 THEN
                V_RETOUR:=NULL;
            END IF;

            RETURN v_retour;
        END IF;

        --IMPUTATION MODIFIéE AVEC UNE SEULE CORRESPONDANCE SUR LA NOUVELLE GESTION
        SELECT COUNT(DISTINCT ide_lig_exe_apres) INTO v_cpt
        FROM ZB_TRANSLAT_EXE
        WHERE ide_lig_exe_avant =p_ide_lig_exe AND SUBSTR(ide_lig_exe_apres,1,6)=p_ide_lig_prev_new1;

           IF v_cpt=1 THEN
                SELECT SUBSTR( ide_lig_exe_apres,7,2) INTO v_retour
                FROM ZB_TRANSLAT_EXE
                WHERE ide_lig_exe_avant =p_ide_lig_exe AND SUBSTR(ide_lig_exe_apres,1,6)=p_ide_lig_prev_new1;

                -- VERIFICATION DE LA NOM D'EXECUTION
                SELECT COUNT(*) INTO V_CPT
                FROM FN_LIGNE_BUD_EXEC
                WHERE VAR_BUD=P_VAR_BUD_NEW
                AND FLG_IMPUT='O'
                AND LIBC =REPLACE(P_IDE_LIG_PREV_NEW,'.',NULL)||'-'||LPAD(P_COD_TITCAT,2,'0')||'-'||LPAD(V_RETOUR,2,'0');

                IF V_CPT=0 THEN
                    V_RETOUR:=NULL;
                END IF;

                RETURN v_retour;
           ELSE
               --CORRESPONDANCE NON TROUVéE
               RETURN NULL;
           END IF;
    END Z_Cod_Act_Ssact_Cg;

/

CREATE OR REPLACE FUNCTION          Z_Cod_Act_Ssact_Eng(p_ide_gest VARCHAR2,p_ide_poste VARCHAR2,p_ide_ordo VARCHAR2,p_ide_eng VARCHAR2)
RETURN VARCHAR2
IS
----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_COD_ACT_SSACT_ENG
-- DATE CREATION  : 05/01/2007
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : RECHERCHE DU CODE ACTION-SOUS ACTION  ASSOCIé à UN ENGAGEMENT SUR UNE GESTION DONNéE

----------------------------------------------------------------------------------
--                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
----------------------------------------------------------------------------------
-- Z_COD_ACT_SSACT_ENG        | 1.0        |05/01/2007| IL          |
----------------------------------------------------------------------------------

-- PARAMETRES ------------
--P_IDE_GEST   : GESTION
--P_IDE_POSTE  : POSTE
--P_IDE_ORDO   : ORDONNATEUR
--P_IDE_ENG    : NUMERO DE L'ENGAGEMENT
----------------------------------------------------------------------------------
v_cod_titcat VARCHAR2(6);
v_cpt NUMBER(6);
BEGIN

SELECT COUNT(DISTINCT fbl.COD_ACT_SSACT ) INTO v_cpt
         		FROM fb_ligne_eng fbl,fb_eng fb
         		WHERE fb.IDE_POSTE = fbl.IDE_POSTE
                AND fb.IDE_GEST = fbl.IDE_gest
                AND fb.IDE_ORDO = fbl.IDE_ordo
                AND fb.COD_BUD = fbl.cod_bud
                AND fb.IDE_ENG = fbl.IDE_eng
				AND (fb.ide_poste,fb.ide_gest,fb.ide_ordo,fb.cod_bud,fb.ide_eng)
				    NOT IN(SELECT ide_poste,ide_gest,ide_ordo,cod_bud,SUBSTR(ide_eng,1,16) FROM fb_eng WHERE ide_eng LIKE '%-AN')
     	   	   AND fb.ide_eng NOT LIKE '%AN'
		       AND (fb.ide_eng=p_ide_eng OR fb.ide_eng_init=p_ide_eng)
			   AND fb.ide_ordo=p_ide_ordo
			   AND fb.ide_poste=p_ide_poste
			   AND fb.IDE_GEST = p_IDE_gest ;

IF v_cpt=0 THEN RETURN NULL;
ELSIF v_cpt=1 THEN
SELECT DISTINCT fbl.COD_ACT_SSACT INTO v_cod_titcat
         		FROM fb_ligne_eng fbl,fb_eng fb
         		WHERE fb.IDE_POSTE = fbl.IDE_POSTE
                AND fb.IDE_GEST = fbl.IDE_gest
                AND fb.IDE_ORDO = fbl.IDE_ordo
                AND fb.COD_BUD = fbl.cod_bud
                AND fb.IDE_ENG = fbl.IDE_eng
				AND (fb.ide_poste,fb.ide_gest,fb.ide_ordo,fb.cod_bud,fb.ide_eng)
				    NOT IN(SELECT ide_poste,ide_gest,ide_ordo,cod_bud,SUBSTR(ide_eng,1,16) FROM fb_eng WHERE ide_eng LIKE '%-AN')
     	   	   AND fb.ide_eng NOT LIKE '%AN'
		       AND (fb.ide_eng=p_ide_eng OR fb.ide_eng_init=p_ide_eng)
			   AND fb.ide_ordo=p_ide_ordo
			   AND fb.ide_poste=p_ide_poste
			   AND fb.IDE_GEST = p_IDE_gest ;
			   RETURN v_cod_titcat;
ELSE

dbms_output.put_line('engagement avec plusieur cod_act_ssact possible (pas normal) : '||p_ide_gest ||'-'||p_ide_poste  ||'-'||p_ide_ordo  ||'-'||p_ide_eng);
return null;
END IF;
END  Z_Cod_Act_Ssact_Eng;

/

CREATE OR REPLACE FUNCTION          Z_Cod_Titcat_Eng(p_ide_gest VARCHAR2,p_ide_poste VARCHAR2,p_ide_ordo VARCHAR2,p_ide_eng VARCHAR2)
RETURN VARCHAR2
IS
----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_COD_TITCAT_ENG
-- DATE CREATION  : 05/01/2007
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : RECHERCHE DU TITRE-CATéGORIE ASSOCIé à UN ENGAGEMENT SUR UNE GESTION DONNéE

----------------------------------------------------------------------------------
--                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
----------------------------------------------------------------------------------
-- Z_COD_TITCAT_ENG           | 1.0        |05/01/2007| IL          |
----------------------------------------------------------------------------------

-- PARAMETRES ------------
--P_IDE_GEST   : GESTION
--P_IDE_POSTE  : POSTE
--P_IDE_ORDO   : ORDONNATEUR
--P_IDE_ENG    : NUMERO DE L'ENGAGEMENT
----------------------------------------------------------------------------------
v_cod_titcat VARCHAR2(6);
v_cpt NUMBER(6);
BEGIN
SELECT COUNT(DISTINCT fbl.cOD_TITCAT ) INTO v_cpt
         		FROM fb_ligne_eng fbl,fb_eng fb
         		WHERE fb.IDE_POSTE = fbl.IDE_POSTE
                AND fb.IDE_GEST = fbl.IDE_gest
                AND fb.IDE_ORDO = fbl.IDE_ordo
                AND fb.COD_BUD = fbl.cod_bud
                AND fb.IDE_ENG = fbl.IDE_eng
				AND (fb.ide_poste,fb.ide_gest,fb.ide_ordo,fb.cod_bud,fb.ide_eng)
				    NOT IN(SELECT ide_poste,ide_gest,ide_ordo,cod_bud,SUBSTR(ide_eng,1,16) FROM fb_eng WHERE ide_eng LIKE '%-AN')
     	   	   AND fb.ide_eng NOT LIKE '%AN'
		       AND (fb.ide_eng=p_ide_eng OR fb.ide_eng_init=p_ide_eng)
			   AND fb.ide_ordo=p_ide_ordo
			   AND fb.ide_poste=p_ide_poste
			   AND fb.IDE_GEST = p_IDE_gest;
IF v_cpt=0 THEN RETURN NULL;
ELSIF v_cpt=1 THEN
SELECT DISTINCT fbl.cOD_TITCAT  INTO v_cod_titcat
         		FROM fb_ligne_eng fbl,fb_eng fb
         		WHERE fb.IDE_POSTE = fbl.IDE_POSTE
                AND fb.IDE_GEST = fbl.IDE_gest
                AND fb.IDE_ORDO = fbl.IDE_ordo
                AND fb.COD_BUD = fbl.cod_bud
                AND fb.IDE_ENG = fbl.IDE_eng
				AND (fb.ide_poste,fb.ide_gest,fb.ide_ordo,fb.cod_bud,fb.ide_eng)
				    NOT IN(SELECT ide_poste,ide_gest,ide_ordo,cod_bud,SUBSTR(ide_eng,1,16) FROM fb_eng WHERE ide_eng LIKE '%-AN')
     	   	   AND fb.ide_eng NOT LIKE '%AN'
		       AND (fb.ide_eng=p_ide_eng OR fb.ide_eng_init=p_ide_eng)
			   AND fb.ide_ordo=p_ide_ordo
			   AND fb.ide_poste=p_ide_poste
			   AND fb.IDE_GEST = p_IDE_gest ;
			   RETURN v_cod_titcat;
ELSE
dbms_output.put_line('engagement avec plusieurs cod_titcat possibles (pas normal) : '||p_ide_gest ||'-'||p_ide_poste  ||'-'||p_ide_ordo  ||'-'||p_ide_eng);
return null;
END IF;
END  Z_Cod_Titcat_Eng;

/

CREATE OR REPLACE FUNCTION z_rech_ide_lig_prev_new(p_ide_lig_prev VARCHAR2)
RETURN VARCHAR2
IS
----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_RECH_IDE_LIG_PREV_NEW
-- DATE CREATION  : 05/01/2007
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : RECHERCHE DES DAT_EMIS ET DAT_CAD DE FB_PIECE

----------------------------------------------------------------------------------
--                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
----------------------------------------------------------------------------------
-- Z_RECH_IDE_LIG_PREV_NEW    | 1.0        |05/01/2007| IL          |
----------------------------------------------------------------------------------

-- PARAMETRES ------------
-- P_IDE_LIG_PREV : ANCIENNE LIGNE DE PREVISION
----------------------------------------------------------------------------------
v_cpt NUMBER(6);
v_ide_lig_prev VARCHAR2(10);
BEGIN
-- L'IMPUTATION EST RECONDUITE SUR LA NOUVELLE NOMENCLATURE
SELECT COUNT(*) INTO v_cpt
FROM ZB_TRANSLAT_PREV
WHERE
SUBSTR(ide_lig_prev_avant,1,8)=SUBSTR(REPLACE(p_ide_lig_prev,'.',NULL),2,8)
AND
SUBSTR(ide_lig_prev_apres,1,8)=SUBSTR(REPLACE(p_ide_lig_prev,'.',NULL),2,8) ;
IF v_cpt=1 THEN RETURN (SUBSTR(p_ide_lig_prev,1,7)||'.'||SUBSTR(p_ide_lig_prev,9,2));END IF;


SELECT COUNT(DISTINCT SUBSTR(ide_lig_prev_apres,1,8)) INTO v_cpt
FROM ZB_TRANSLAT_PREV
WHERE
SUBSTR(ide_lig_prev_avant,1,8)=SUBSTR(REPLACE(p_ide_lig_prev,'.',NULL),2,8);

IF v_cpt=0 THEN RETURN 'NO';--NON RECONDUCTION DE LA LIGNE DE PREVISION
ELSIF v_cpt=1 THEN --RECONDUCTION AVEC CHANGEMENT D'IMPUTATION
SELECT DISTINCT SUBSTR(ide_lig_prev_apres,1,8) INTO v_ide_lig_prev
FROM ZB_TRANSLAT_PREV
WHERE
SUBSTR(ide_lig_prev_avant,1,8)=SUBSTR(REPLACE(p_ide_lig_prev,'.',NULL),2,8);

RETURN (SUBSTR(p_ide_lig_prev,1,1)||SUBSTR(v_ide_lig_prev,1,6)||'.'||SUBSTR(v_ide_lig_prev,7,2) );
ELSE RETURN 'MULTI';--reconduction avec eclatement
END IF;
END z_rech_ide_lig_prev_new;

/

CREATE OR REPLACE FUNCTION z_titcat(p_sens VARCHAR2,p_type VARCHAR2,p_valeur NUMBER,p_var_bud VARCHAR2)
RETURN NUMBER
IS
----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_TITCAT
-- DATE CREATION  : 18/09/2006
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : RECHERCHE DES DAT_EMIS ET DAT_CAD DE FB_PIECE

----------------------------------------------------------------------------------
--                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
----------------------------------------------------------------------------------
-- Z_TITCAT                   | 1.0        |18/09/2006| IL          |
----------------------------------------------------------------------------------

-- PARAMETRES ------------
-- P_SENS : A :"ALLER"  : DE LA NOMENCLATURE(UTILISATEUR) VERS LA DONNéE STOCKéE DANS LES TABLES
--          R : "RETOUR" : DE  LA DONNéE STOCKéE DANS LES TABLES  VERS LA NOMENCLATURE(UTILISATEUR)
-- P_TYPE  : A :ACTION SOUS ACTION
--           T :TITRE CATéGORIE
-- P_COD_ACT_SSACT  : CODE ACTION SOUS ACTION DE L'UTILISATEUR OU DE LA TABLE SELON LE P_TYP
-- P_COD_TITCAT     : CODE TITRE CATéGORIE SOUS ACTION DE L'UTILISATEUR OU DE LA TABLE
----------------------------------------------------------------------------------

v_retour NUMBER(7);
BEGIN
IF p_valeur IS NULL THEN RETURN NULL;END IF;

IF p_sens='A' AND p_type='T' THEN
SELECT ide_assign INTO v_retour FROM FN_TIT_ACT WHERE cod_nature=1 AND cod_valeur=LPAD(p_valeur,2,'0') AND var_bud=p_var_bud;

ELSIF p_sens='A' AND p_type='A' THEN
SELECT ide_assign INTO v_retour FROM FN_TIT_ACT WHERE cod_nature=2 AND cod_valeur=LPAD(p_valeur,2,'0') AND var_bud=p_var_bud;

ELSIF p_sens='R' AND p_type='T' THEN
SELECT cod_valeur INTO v_retour FROM FN_TIT_ACT WHERE cod_nature=1 AND ide_assign=p_valeur AND var_bud=p_var_bud;

ELSIF p_sens='R' AND p_type='A' THEN
SELECT cod_valeur INTO v_retour FROM FN_TIT_ACT WHERE cod_nature=2 AND ide_assign=p_valeur AND var_bud=p_var_bud;

ELSE
RETURN NULL;
END IF;
RETURN (v_retour);

END;

/

CREATE OR REPLACE FUNCTION CAL_NOMEN_CPTA (p_nom_table IN VARCHAR2,
	   	  		  		   				  p_var_cpta IN VARCHAR2)
										   return varchar2 is
--=========================== IDENTIFICATION ==================================
--  Sujet    : Recopie nomenclature comptable
--  Module   : U219_210E.rdf
--  Instance : Paramètrage
--  Créé le  : 27/09/2007 par MCE
--  Version  : V4220
--
--====================== HISTORIQUE DES MODIFICATIONS =========================
--  Date        Version   Aut. Evolution Sujet
--  --------------------------------------------------------------------------
--  28/09/2007 V4220   MCE  EVOL_009 : recopie nomenclature comptable
--
--============================ COMMENTAIRES ===================================
--   MesCommentaires
--
--=============================================================================
  v_nbr_orig    VARCHAR2(1000) := NULL;
  v_nbr    		VARCHAR2(10) := '0';
  v_table  		VARCHAR2(50);

TYPE cur_nbr_Typ   is REF CURSOR;
cur_nbr      cur_nbr_Typ ;
  v_req    VARCHAR2 (256) := NULL;


BEGIN

 FOR i IN 1..LENGTH(p_nom_table) LOOP
  v_table := GET_STRING_VALUE(p_nom_table,'/',i);
  EXIT WHEN v_table IS NULL;

   -- construction de la requête de sélection du nombre d'enregistrement en fonction de la variation passée en paramètre
   v_req := 'select count(*) FROM  '||v_table||' WHERE var_cpta = '''||p_var_cpta||''' ';

   OPEN cur_nbr FOR  v_req  ;
      FETCH cur_nbr INTO v_nbr;
      Close cur_nbr ;


    v_nbr_orig := v_nbr_orig||nvl(v_nbr,'0')||chr(10);

  END LOOP;

  RETURN (v_nbr_orig);

EXCEPTION
 WHEN OTHERS THEN
    RETURN('KO');
END;

/

CREATE OR REPLACE FUNCTION          CAL_ROUND_MT_DEV( p_mt_in    IN NUMBER,
                                             p_mt_out   IN OUT NUMBER,
                                             p_ide_devise  RB_TXCHANGE.ide_devise%TYPE := '@@@'
                                         ) RETURN NUMBER IS
/*
--     ----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : REF
-- Nom           : CAL_ROUND_MT_DEV
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 29/01/2003
-- ---------------------------------------------------------------------------
-- Role          : Arrondi d'un montant en devise a n chiffre apres la virgule
--
-- Parametres :
--               1 - p_mt_in  : IN :  mt en devise de reference a arrondir
--               2 - p_mt_out : OUT : mt en devise de reference arrondi en fonction de IR0001
--               3 - p_ide_devise : IN : devise du montant a arrondir
--
-- Valeur retournee : 1 : OK
--                   -1 : KO
--                   -2 : KO
--
-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_ROUND_MT_DEV sql version 3.0d-1.1
-- ---------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------
-- Fonction                   |Date        |Initiales    |Commentaires
--     -----------------------------------------------------------------------------------------------------
-- @(#) CAL_ROUND_MT_DEV.sql 3.0d-1.0    |29/01/2003 | SGN    | Création
-- @(#) CAL_ROUND_MT_DEV.sql 3.0d-1.1    |11/02/2003 | SGN    | ANOVA262 prise en compte des devises
---------------------------------------------------------------------------------------------------------
*/
  v_ret NUMBER;
  v_nbr_dec NUMBER;

  PARAM_EXCEPTION EXCEPTION;
  CODIF_EXCEPTION EXCEPTION;
  NBR_DEC_EXCEPTION EXCEPTION;  -- MODIF SGN ANOVA262 du 11/02/2003

  -- Variable pour la trace
  v_niveau_trace NUMBER := NULL;
  v_num_trt NUMBER;
BEGIN
     -- Recuperation du niveau de trace en passant par les variables ASTER
     ASTER_VAR.get_var('NIVEAU_TRACE_VAR','P_NIV_TRACE', v_niveau_trace, v_num_trt);
     GLOBAL.INI_NIVEAU_TRACE(NVL(v_niveau_trace,0));
     AFF_TRACE('CAL_ROUND_MT_DEV', 2, NULL, 'Debut traitement');

     -- Recuperation du nombre de decimal parametre
     -- MODIF SGN ANOVA262 du 11/02/2003 : IF p_ide_devise IS NULL THEN
       IF p_ide_devise = '@@@' THEN
         v_nbr_dec := 3;

       ELSE
         -- MODIF SGN ANOVA262 du 11/02/2003 : traitement des devises
       IF EXT_nb_dec_mt_devise(p_ide_devise, v_nbr_dec) != 1 THEN
           RAISE NBR_DEC_EXCEPTION;
         END IF;
         -- fin modif sgn
     END IF;

     --v_nbr_dec := 0;

     p_mt_out := round( p_mt_in, v_nbr_dec);
     
     
     
     AFF_TRACE('CAL_ROUND_MT_DEV', 2, NULL, 'Montant en devise arrondi:' || p_mt_out);


     AFF_TRACE('CAL_ROUND_MT_DEV', 2, NULL, 'Fin traitement');

     RETURN(1);

EXCEPTION
  WHEN PARAM_EXCEPTION THEN
      RETURN(-1);
  WHEN NBR_DEC_EXCEPTION THEN
      RETURN(-2);
  WHEN OTHERS THEN
      RAISE;
END CAL_ROUND_MT_DEV;

/

CREATE OR REPLACE FUNCTION CTL_Assign ( p_cod_bud IN fn_lp_rpo.cod_bud%TYPE,
                      p_cod_typ_bud IN fn_lp_rpo.cod_typ_bud%TYPE,
                      p_ide_gest IN fn_lp_rpo.ide_gest%TYPE,
                      p_ide_ordo IN fn_lp_rpo.ide_ordo%TYPE,
                      p_var_bud IN fn_lp_rpo.var_bud%TYPE,
                      p_ide_poste IN fn_lp_rpo.ide_poste%TYPE,
                      p_ide_lig_prev IN fn_lp_rpo.mas_lig_prev%TYPE ) RETURN NUMBER IS

/* Fonction qui retourne :			 			      	*/
/*   1 si un masque est trouvé dans fn_lp_rpo	   	  			*/
/*   0 si aucun masque n'est trouvé dans fn_lp_rpo    				*/
/*   -1 si une erreur s'est produite lors du controle 				*/
--====================== HISTORIQUE DES MODIFICATIONS =============================================
--  Date        Version  Aut. Evolution Sujet
--  -----------------------------------------------------------------------------------------------
--  15/05/2008  v4260    PGE  evol_DI44_2008_014 Controle sur les dates de validité de fn_lp_rpo
--=================================================================================================

v_indice NUMBER;
v_retour NUMBER :=0;
v_poste RM_POSTE.ide_poste%TYPE := Null;

BEGIN

  IF p_ide_lig_prev IS NULL THEN
    v_indice := 0;
  ELSE
    v_indice := LENGTH(p_ide_lig_prev);
  END IF;
  WHILE v_indice >= 0 AND v_poste IS NULL LOOP
    DECLARE
      v_masque fn_lp_rpo.mas_lig_prev%TYPE;
    BEGIN
      v_masque := SUBSTR(p_ide_lig_prev,1,v_indice);
      SELECT ide_poste INTO v_poste
      FROM fn_lp_rpo
      WHERE cod_bud = p_cod_bud
            AND cod_typ_bud = p_cod_typ_bud
            AND ide_gest = p_ide_gest
            AND ide_ordo = p_ide_ordo
            AND var_bud = p_var_bud
            AND NVL(mas_lig_prev,'*') = NVL(v_masque,'*')
            AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
            AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        Null;
      WHEN OTHERS THEN
        v_retour := -1;
        EXIT;
    END;
    v_indice := v_indice -1;
  END LOOP;
  /* Le poste trouve doit etre egal a celui passe en paramètre */
  IF v_retour != -1 AND v_poste IS NOT NULL AND v_poste = p_ide_poste THEN
    v_retour := 1;
  ELSE
    v_retour := 0;
  END IF;

  RETURN (v_retour);

EXCEPTION
  WHEN OTHERS THEN
    RETURN (-1);
END CTL_Assign;

/

CREATE OR REPLACE FUNCTION CTL_Assign_Param ( p_cod_bud IN fn_lp_rpo.cod_bud%TYPE,
                      p_cod_typ_bud IN fn_lp_rpo.cod_typ_bud%TYPE,
                      p_ide_gest IN fn_lp_rpo.ide_gest%TYPE,
                      p_ide_ordo IN fn_lp_rpo.ide_ordo%TYPE,
                      p_var_bud IN fn_lp_rpo.var_bud%TYPE,
                      p_ide_poste IN fn_lp_rpo.ide_poste%TYPE,
                      p_ide_lig_prev IN fn_lp_rpo.mas_lig_prev%TYPE ) RETURN NUMBER IS

/* Fonction qui retourne :			 			      	*/
/*   1 si au moins un masque est trouvé dans fn_lp_rpo	   	  		*/
/*   0 si aucun masque n'est trouvé dans fn_lp_rpo    				*/
/*   -1 si une erreur s'est produite lors du controle 				*/
--====================== HISTORIQUE DES MODIFICATIONS =============================================
--  Date        Version  Aut. Evolution Sujet
--  -----------------------------------------------------------------------------------------------
--  15/05/2008  v4260    PGE  evol_DI44_2008_014 Controle sur les dates de validité de fn_lp_rpo
--=================================================================================================
v_indice NUMBER;
v_retour NUMBER :=0;
v_poste RM_POSTE.ide_poste%TYPE := Null;
v_masque fn_lp_rpo.mas_lig_prev%TYPE;

CURSOR c_lp_rpo(w_masque FN_LP_RPO.mas_lig_prev%TYPE) IS
SELECT A.ide_poste FROM FN_LP_RPO A
WHERE ( A.cod_bud = p_cod_bud OR p_cod_bud IS NULL )
  AND ( A.cod_typ_bud = p_cod_typ_bud OR p_cod_typ_bud IS NULL )
  AND ( A.ide_gest = p_ide_gest OR p_ide_gest IS NULL )
  AND ( A.ide_ordo = p_ide_ordo OR p_ide_ordo IS NULL )
  AND ( A.var_bud = p_var_bud OR p_var_bud IS NULL )
  AND ( NVL(A.mas_lig_prev,'*') = NVL(w_masque,'*'))
  AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
  AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008

BEGIN

  IF p_ide_lig_prev IS NULL THEN
    v_indice := 0;
  ELSE
    v_indice := LENGTH(p_ide_lig_prev);
  END IF;

  WHILE v_indice >= 0 AND v_poste IS NULL LOOP
    BEGIN
      v_masque := SUBSTR(p_ide_lig_prev,1,v_indice);
      IF c_lp_rpo%ISOPEN THEN
        CLOSE c_lp_rpo;
      END IF;
      OPEN c_lp_rpo(v_masque);
      FETCH c_lp_rpo INTO v_poste;
    EXCEPTION
      WHEN OTHERS THEN
        v_retour := -1;
        EXIT;
    END;
    v_indice := v_indice -1;
  END LOOP;
  /* On a trouve au moins un enregistrement dans fn_lp_rpo */
  /* Il faut maintenant verifier qu'un des postes de ces enregistrements soit egal a p_ide_poste  */
  IF v_retour != -1 AND v_poste IS NOT NULL THEN
    /* on referme le curseur */
    CLOSE c_lp_rpo;
    FOR r_lp_rpo IN c_lp_rpo(v_masque) LOOP
      IF  r_lp_rpo.ide_poste = p_ide_poste THEN
        v_retour := 1;
        EXIT;
      END IF;
    END LOOP;
  ELSE
    v_retour := 0;
  END IF;

  RETURN (v_retour);

EXCEPTION
  WHEN OTHERS THEN
    RETURN (-1);
END CTL_Assign_Param;

/

CREATE OR REPLACE FUNCTION Ctl_Masq_Code (
                                          p_env IN VARCHAR2,
                                          p_code IN VARCHAR2,
										  p_val_masque IN OUT SR_PARAM.val_param%TYPE,
										  p_param_ctl_masque IN OUT SR_PARAM.IDE_PARAM%TYPE,
										  p_param_val_masque IN OUT SR_PARAM.IDE_PARAM%TYPE
										  )
RETURN NUMBER IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : PARAMETRAGE
-- Nom           : CTL_MASQ_CODE
-- ---------------------------------------------------------------------------
--  Auteur         : LGD
--  Date creation  : 16/04/2003
-- ---------------------------------------------------------------------------
-- Role          : Contrôle du masque de saisie en fonction de l'environnement
--
-- Parametres  entree  :
-- 				 1 - p_env : Environnement définissant le masque de saisie à contrôler
--                           (Engagement, Ordonnance, ....)
--				 2 - p_code : Code saisi à contrôler
--
--
-- Parametres  en sortie  :
--               3 - p_val_masque : Valeur du masque à retourner
--               4 - p_param_ctl_masque : Valeur du paramètre indiquant si le contrôle de format doit être fait ou pas
--               5 - p_param_val_masque : Valeur du paramètre indiquant la valeur du masque de saisie.
--
-- Valeur  retournée en sortie :
--				                1 => Contrôle OK
--                             -1 => Contrôle KO : Impossible de déterminer le masque de saisie
--                             -2 => Contrôle KO : Erreur lors de la récupération du paramètre indiquant si un contrôle de saisie doit être fait (paramètre %1).
--                             -3 => Contrôle KO : Erreur lors de la récupération du masque de saisie (paramètre %1).
                               -4 => Contrôle KO : La longueur %1 saisi n'est pas la même que le masque de saisie %2
							   -5 => Contrôle KO : Le format de masque %1 est invalide (paramètre %2). Il doit être composé d'une combinaison des caractères 9,A et z
                               -6 => Contrôle KO : %1 saisi n'est pas cohérent avec le masque de saisie %2
--
-- ---------------------------------------------------------------------------
--  Version        : @(#) CTL_MASQ_CODE.sql version 3.3-1.5
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) CTL_MASQ_CODE.sql 3.0-1.0	|16/04/2003| LGD	| Initialisation
-- @(#) CTL_MASQ_CODE.sql 3.0-1.1	|17/04/2003| LGD	| Ajout d'un contôle si la valeur du masque est nul
-- @(#) CTL_MASQ_CODE.sql 3.0-1.2	|22/04/2003| LGD	| Changement des paramètres en sortie.
-- @(#) CTL_MASQ_CODE.sql 3.0-1.3	|24/04/2003| LGD	| Evolution 32 - Aster v3.1
-- @(#) CTL_MASQ_CODE.sql 3.0-1.4	|06/05/2003| LGD	| Evolution 38 - Aster v3.1
-- @(#) CTL_MASQ_CODE.sql 3.3-1.5	|20/08/2003| LGD	| Evolution 37 - Aster v3.3
-- 	----------------------------------------------------------------------------------------------------------
*/

v_codint_ctl_masque SR_CODIF.ide_codif%TYPE;
v_ret NUMBER;
v_char CHAR;
v_ret_masque_controle NUMBER;
v_libl SR_CODIF.libl%TYPE;
v_masque VARCHAR2(120);
v_val_masque_cod_int SR_CODIF.ide_codif%TYPE;


FUNCTION isnumber (
                   p_data   VARCHAR2
                   )
                   RETURN NUMBER IS
   v_number   NUMBER;
BEGIN
   BEGIN
      IF p_data =' ' THEN
	    RETURN NULL;
	  END IF;

	  v_number := p_data;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN NULL;
   END;

   RETURN v_number;
END isnumber;



FUNCTION ischar (
                 p_data   CHAR
                )
                RETURN CHAR IS
v_char   CHAR;
BEGIN
   BEGIN
      v_char := UPPER(p_data);
	  IF v_char NOT IN('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z') THEN
	    RETURN NULL;
	   END IF;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN NULL;
   END;

   RETURN v_char;
END ischar;

FUNCTION CTL_Ordo(PF_Ideordo FC_LIGNE.ide_ordo%TYPE) RETURN NUMBER IS
  v_recup    VARCHAR2(1);
BEGIN

  SELECT 'X' INTO v_recup
  FROM RB_ORDO t1,RM_NOEUD t2
  WHERE t2.cod_typ_nd = t1.cod_typ_nd
    AND t2.ide_nd = t1.ide_ordo
    AND t1.ide_ordo = PF_Ideordo;

  RETURN(1);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN(0);
  WHEN OTHERS THEN
    RAISE;
END CTL_Ordo;


FUNCTION CTL_LIG_PREV (PF_LIG_PREV FN_LIGNE_BUD_PREV.ide_lig_prev%TYPE) RETURN NUMBER IS
  v_recup    VARCHAR2(1);
BEGIN
  SELECT 'X' INTO v_recup
  FROM FN_LIGNE_BUD_PREV P
  WHERE P.ide_lig_prev = PF_LIG_PREV;

  RETURN(1);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN(0);
  WHEN OTHERS THEN
    RAISE;
END CTL_LIG_PREV;

BEGIN

  --1) Contrôle des paramètres en entrée
  IF P_ENV IS NOT NULL THEN
    --- Si le code saisi est null aucun contrôle ne doit être fait
	IF P_CODE IS NULL THEN
	  RETURN(1);
	END IF;
  ELSE
    --- Impossible de déterminer le masque de saisie
    RETURN(-1);
  END IF;


  --2) Recherche si le contrôle de masque de saisie est autoriser ou pas si oui récuprer la valeur du masque

	  --2.1) Recherche des paramètres en fonction de l'environnement
	  IF P_ENV = 'IDE_ENG' THEN
	    p_param_ctl_masque :='IB0053';
		p_param_val_masque :='IB0054';
	  ELSIF P_ENV = 'IDE_ORDO' THEN
	    p_param_ctl_masque :='IB0055';
		p_param_val_masque :='IB0056';
	  ELSIF P_ENV = 'MVT_BUD' THEN
	    p_param_ctl_masque :='IB0078';
		p_param_val_masque :='IB0079';
	  ELSIF P_ENV = 'IDE_ORE7' THEN
	    p_param_ctl_masque :='IB0057';
		p_param_val_masque :='IB0058';
	  ELSIF P_ENV = 'IDE_OPE' THEN
	    p_param_ctl_masque :='IB0059';
		p_param_val_masque :='IB0060';
	  ELSIF P_ENV = 'VAL_CHPA1' THEN
		p_param_ctl_masque :='IB0063';
		p_param_val_masque :='IB0064';
      ELSIF P_ENV = 'VAL_CHPA2' THEN
		p_param_ctl_masque :='IB0065';
		p_param_val_masque :='IB0066';
	  ELSIF P_ENV = 'VAL_CHPA3' THEN
		p_param_ctl_masque :='IB0067';
		p_param_val_masque :='IB0068';
	  ELSIF P_ENV = 'VAL_CHPA4' THEN
		p_param_ctl_masque :='IB0069';
		p_param_val_masque :='IB0070';
	  ELSIF P_ENV = 'VAL_CHPN1' THEN
		p_param_ctl_masque :='IB0071';
		p_param_val_masque :='IB0072';
	  ELSIF P_ENV = 'VAL_CHPN2' THEN
		p_param_ctl_masque :='IB0073';
		p_param_val_masque :='IB0074';
	  ELSIF P_ENV = 'SUPPORT' THEN
		p_param_ctl_masque :='IB0082';
		p_param_val_masque :='IB0083';
	  ELSE
	    --- Impossible de déterminer le masque de saisie
	    RETURN(-1);
	  END IF;

	  --2.2) Recherche si le contrôle de saisie est à faire.
	  Ext_Param(p_param_ctl_masque, v_codint_ctl_masque, v_ret);
	  IF v_ret != 1 THEN
	     -- Erreur lors de la récupération du paramètre indiquant si un contrôle de saisie doit être fait.
		 RETURN(-2);
	  ELSE
	    IF v_codint_ctl_masque ='N' THEN
		  --- Le contrôle du masque de saisie n'est pas obligatoire
		  RETURN(1);
		END IF;
	  END IF;

     -- 2.3) Récupération de la valeur du masque de saisie
	 Ext_Param(p_param_val_masque, p_val_masque, v_ret);
	 IF v_ret != 1 THEN
	    -- Erreur lors de la récupération du masque de saisie
		RETURN(-3);
	 END IF;

  --3) Test de contrôle entre la saisie et le masque

	--3.0) Si le masque est nul aucun contrôle n'est à éffectuer.
	IF p_val_masque IS NULL THEN
	  RETURN(1);
	END IF;

	---3.1) Contrôle spécifique à la MAJ de la nomenclature des opérations
	IF P_ENV IN ('VAL_CHPA1',
                 'VAL_CHPA2',
                 'VAL_CHPA3',
                 'VAL_CHPA4',
                 'VAL_CHPN1',
                 'VAL_CHPN2' ) THEN


	  --- Récupération du code interne
	  Ext_Codint('MASQUE',p_val_masque,v_libl,v_val_masque_cod_int,v_ret);
	  IF v_ret=-1 OR v_ret=2 THEN
	    -- Impossible de déterminer le masque de saisie
		RETURN(-1);
	  END IF;
	  IF v_ret=1 AND (v_val_masque_cod_int='@ORDO' OR v_val_masque_cod_int='@LPRV') THEN

		  Ctl_Sais_Masque('U415_010F',P_ENV,p_val_masque,v_masque,v_ret);
		  IF     v_ret = 0 THEN
	        --- Le format du masque %1 est invalide.
		    RETURN(-5);
		  ELSIF  v_ret = -1 THEN
	        -- Impossible de déterminer le masque de saisie
			RETURN(-1);
		  END IF;

		  v_ret := Ctl_Val_Masque(p_val_masque,p_code,GLOBAL.dat_jc);
		  IF     v_ret = -1 THEN
	        -- Impossible de déterminer le masque de saisie
			RETURN(-1);
		  ELSIF  v_ret IN (0,-2)  THEN
		    --- -- le code saisi est invalide avec le masque %1
		    RETURN(-6);
		  ELSIF v_ret = 1 THEN
		    --- Contrôle OK
		    RETURN(1);
		  END IF;
	  END IF;
	END IF;


	--3.2) Test sur le format du masque qui doit être composé d'une combinaison des caractères 9,A et z
	FOR i IN 1..LENGTH(p_val_masque)
	LOOP
	  IF    SUBSTR(p_val_masque, i, 1) NOT IN('9','A','z') THEN
	    --- Le format du masque %1 est invalide.
		RETURN(-5);
	  END IF;
	END LOOP;

	--3.3) Test sur la longueur
		IF LENGTH(p_val_masque) != LENGTH(p_code) THEN
	  --- La longueur du code saisi n'est pas la même que le masque de saisie %1
	  RETURN(-4);
	END IF;


	FOR i IN 1..LENGTH(p_val_masque)
	LOOP


	    IF    SUBSTR(p_val_masque, i, 1) = '9' THEN
	       --- Le caractère saisi doit être numérique
		   v_ret := ISNUMBER(SUBSTR(p_code, i, 1));
		   IF v_ret IS NULL THEN
		     --- le code saisi est invalide avec le masque %1
			 RETURN (-6);
		   END IF;

		ELSIF SUBSTR(p_val_masque, i, 1) = 'A' THEN
		   --- Le caractère saisi doit être une lettre ou un chiffre
		   v_char := ISCHAR(SUBSTR(p_code, i, 1));
		   v_ret := ISNUMBER(SUBSTR(p_code, i, 1));

		   IF v_char IS NULL AND v_ret IS NULL THEN
		     --- le code saisi est invalide avec le masque %1
			 RETURN (-6);
		   END IF;

		ELSIF SUBSTR(p_val_masque, i, 1) = 'z' THEN
		   --- Le caractère saisi ne doit être ni une lettre ni un chiffre.
		   v_ret := ISNUMBER(SUBSTR(p_code, i, 1));
		   IF v_ret IS NOT NULL THEN
		     --- le code saisi est invalide avec le masque %1
			 RETURN (-6);
		   END IF;
		   v_char := ISCHAR(SUBSTR(p_code, i, 1));
		   IF v_char IS NOT NULL THEN
		     --- le code saisi est invalide avec le masque %1
			 RETURN (-6);
		   END IF;
		END IF;

	END LOOP;

	RETURN(1);


EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END Ctl_Masq_Code;

/

CREATE OR REPLACE FUNCTION Ctl_U212_012e(P_IDE_POSTE       IN       FC_ECRITURE.ide_poste%TYPE,
                                         P_IDE_GEST        IN       FC_ECRITURE.ide_gest%TYPE,
                                         P_COD_TYP_ND      IN       FC_ECRITURE.cod_typ_nd%TYPE,
                                         P_IDE_ND_EMET     IN       FC_ECRITURE.ide_nd_emet%TYPE,
                                         P_IDE_MESS        IN       FC_ECRITURE.ide_mess%TYPE,
                                         P_FLG_EMIS_RECU   IN       FC_ECRITURE.flg_emis_recu%TYPE,
                                         P_DAT_JC          IN       FC_ECRITURE.dat_jc%TYPE,
                                         P_IDE_MESS_ERR    IN OUT   SR_MESS_ERR.ide_mess_err%TYPE,
                                         P_PARAM1          IN OUT   VARCHAR2,
                                         P_PARAM2          IN OUT   VARCHAR2,
                                         P_PARAM3          IN OUT   VARCHAR2) RETURN NUMBER IS

/*
--  ----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : MES
-- Nom           : CTL_U212_012E
-- ---------------------------------------------------------------------------
--  Auteur         : LMA
--  Date creation  : 28/08/2000
-- ---------------------------------------------------------------------------
-- Role          : Contrôle comptabilisation du bordereau passé en paramètre
--
-- Parametres    :
--         Entrée
--          1 - P_IDE_POSTE       : poste comptable
--     2 - P_IDE_GEST        : gestion
--     3 - P_COD_TYP_ND      : |
--      4 - P_IDE_ND_EMET     : |
--     5 - P_IDE_MESS        : |-> Identifiant bordereau
--     6 - P_FLG_EMIS_RECU   : |
--     7 - P_DAT_JC          : journée comptable
--     Sortie
--     8 - P_IDE_MESS_ERR : Numéro message erreur
--     9 - P_PARAM1       : Paramètre 1 du message erreur
--     10 - P_PARAM2       : Paramètre 2 du message erreur
--     11 - P_PARAM3       : Paramètre 3 du message erreur
--
-- Valeurs retournees :
--                   0  Pas d'erreur
--                                    -1 Erreur lors de l'execution
--      Parametres 8, 9, 10 et 11 modifiés en sortie
--
-- Appels   :
-- ---------------------------------------------------------------------------
--  Version        : @(#) CTL_U212_012E.sql version 3.1-1.9
-- ---------------------------------------------------------------------------
--
--  -----------------------------------------------------------------------------------------------------
--  Fonction         |Date     |Initiales |Commentaires
--  -----------------------------------------------------------------------------------------------------
-- @(#) CTL_U212_012E.sql 1.0-1.0 |28/08/2000| LMA | Création
-- @(#) CTL_U212_012E.sql 2.1-1.1 |11/09/2001| SNE | Lot 3 V2.1 - Suppression FLG_DSO_ASSIGN
-- @(#) CTL_U212_012E.sql 2.1-1.2 |17/09/2002| LGD | Révision correction ANO 131
-- @(#) CTL_U212_012E.sql 3.0-1.3 |08/10/2002| SGN | Correction ANOVA71 : ajout de controle sur les references piece
-- @(#) CTL_U212_012E.sql 3.0-1.4 |08/11/2002| LGD | Correction ANOVA51 : la saisie d'une référence pièce n'est pas obligatoire
                                                                            en saisie quand le modèle de ligne associé est en création
                                                 de pièce avec un compte justifié par pièce
-- @(#) CTL_U212_012E.sql 3.0-1.5 |13/11/2002| LGD | Correction ANOVA71 : prise en compte des masques sur les comptes auxiliaires
-- @(#) CTL_U212_012E.sql 3.0-1.6 |18/11/2002| LGD | Correction interne : la fonction CTL_MT_TOTAL_ABOND ne retourne aucune valeur
-- @(#) CTL_U212_012E.sql 3.0-1.7 |17/01/2003| LGD | ANOVAV3 213 : Modifcation sur le total des montants mouvementés sur une référence pièce
-- @(#) CTL_U212_012E.sql 3.0-1.8 |26/03/2003| LGD | ANOVAV3 292 : Contrôle sur les spécifications @LOCAL
-- @(#) CTL_U212_012E.sql 3.1-1.9 |03/07/2003| SGN | ANOVA406 : Correction dans le cadre la saisie de spec nationales sans utiliser de masque
-- @(#) CTL_U212_012E.sql 3.1-1.10 |14/05/2004| LGD | ANOGAR606 : Les états de contrôle ne prennent pas en compte les contrôles sur les comptes auxiliaires
-- @(#) CTL_U212_012E.sql 3.4(N)-1.2 |28/07/2005| RDU | ANO DI44-131 : report du code ayant corrigé la DI44-113-1
-- @(#) CTL_U212_012E.sql V4250      |28/02/2008| PGE | Correction ANO 210: Suppression de contrôle exécutés pour l'édition du report U212_012E
--                                                                            qui n'étaient pas exécuté lors du visa des écriture U212_012F
-- @(#) CTL_U212_012E.sql V4260      |16/05/2008| PGE | EVOL_DI44_2008_014 : Controle sur les dates de validité de RC_SPEC
-- @(#) CTL_U212_012E.sql V4270     |14/10/2008| PGE | Ano 292 : Suppression des message 653 et 657 erronés dans l'état de contrôle des écritures comptables
-- @(#) CTL_U212_012E.sql V4261     |14/10/2008| PGE | Ano 295 : Comparaison erronée des dates de début/fin validité
-- @(#) CTL_U212_012E.sql V4281     |29/05/2009| PGE | Ano 375 : anomalie 351 systématique
-- @(#) CTL_U212_012E.sql V4290    |17/09/2009| PGE | Ano 393 : Message 787 intempestif.  Calcul de la somme des montants abondés ne doit pas prendre en compte les montants des lignes d'écritures annulées
--  @(#) CTL_U212_012E.sql V4290   |17/09/2009| PGE |Ano 392 : Message 671 intempestif.  Suppression d'un contrôle absent de la procédure de visa
--  ----------------------------------------------------------------------------------------------------------
*/

-------------------------------
-- Définition des Exceptions --
-------------------------------
  Erreur_Codext         EXCEPTION;
  Erreur_Traitement     EXCEPTION;


---------------------------------------
-- Définition des Variables Globales --
---------------------------------------
  v_retour                  NUMBER;
  v_libl                    SR_CODIF.libl%TYPE;
  v_statut_journee_O        SR_CODIF.cod_codif%TYPE;
  v_oui                     SR_CODIF.cod_codif%TYPE;
  v_non                     SR_CODIF.cod_codif%TYPE;
  v_sens_debit              SR_CODIF.cod_codif%TYPE;
  v_sens_credit             SR_CODIF.cod_codif%TYPE;
  v_ecriture_S              SR_CODIF.cod_codif%TYPE;
  v_ecriture_A              SR_CODIF.cod_codif%TYPE;
  v_ecriture_R              SR_CODIF.cod_codif%TYPE;
  v_ecriture_V              SR_CODIF.cod_codif%TYPE;
  v_schema_D                SR_CODIF.cod_codif%TYPE;
  v_schema_R                SR_CODIF.cod_codif%TYPE;
  v_schema_T                SR_CODIF.cod_codif%TYPE;
  v_natcredit_E             SR_CODIF.cod_codif%TYPE;
  v_codtypbud_D             SR_CODIF.cod_codif%TYPE;
  v_codtypbud_R             SR_CODIF.cod_codif%TYPE;
  v_cpt_canbu               SR_CODIF.cod_codif%TYPE;
  v_cpt_orhbu               SR_CODIF.cod_codif%TYPE;
  v_codsensope_X            SR_CODIF.cod_codif%TYPE;
  v_codsensbe_X             SR_CODIF.cod_codif%TYPE;
  v_codrefpiece_C           SR_CODIF.cod_codif%TYPE;
  v_codrefpiece_S           SR_CODIF.cod_codif%TYPE;
  v_codrefpiece_A           SR_CODIF.cod_codif%TYPE;
  v_erreurecr               NUMBER;
  v_erreurlig               NUMBER;
  v_datejour                DATE := SYSDATE;
  v_datfgest                DATE;
  v_periodecomp             VARCHAR2(1);
  v_typposte                RM_POSTE.ide_typ_poste%TYPE;
  v_flgcadposte             RM_POSTE.flg_cad%TYPE;
  v_typeschemaecr           RC_SCHEMA_CPTA.cod_typ_schema%TYPE;
  v_flgbejournal            FC_JOURNAL.flg_be%TYPE;
  v_mascptlig               RC_MODELE_LIGNE.mas_cpt%TYPE;
  v_masspec1lig             RC_MODELE_LIGNE.mas_spec1%TYPE;
  v_masspec2lig             RC_MODELE_LIGNE.mas_spec2%TYPE;
  v_masspec3lig             RC_MODELE_LIGNE.mas_spec3%TYPE;
  v_masordolig              RC_MODELE_LIGNE.mas_ordo%TYPE;
  v_masbudlig               RC_MODELE_LIGNE.mas_bud%TYPE;
  v_masligbudlig            RC_MODELE_LIGNE.mas_lig_bud%TYPE;
  v_masopelig               RC_MODELE_LIGNE.mas_ope%TYPE;
  v_mastierslig             RC_MODELE_LIGNE.mas_tiers%TYPE;
  v_masrefpiecelig          RC_MODELE_LIGNE.mas_ref_piece%TYPE;
  v_codsignelig             RC_MODELE_LIGNE.cod_signe%TYPE;
  v_codrefpiecelig          RC_MODELE_LIGNE.cod_ref_piece%TYPE;
  /* LGD - ANO VA V3 71 : Contrôle sur le cpt auxiliaire */
  v_masidecptaux              RC_MODELE_LIGNE.ide_cpt_aux%TYPE;
  /* Fin de modification */
  v_flgjustifcompte         FN_COMPTE.flg_justif%TYPE;
  v_flgjustiftierscompte    FN_COMPTE.flg_justif_tiers%TYPE;
  v_flgjustifcptcompte      FN_COMPTE.flg_justif_cpt%TYPE;
  v_flgsimpcompte           FN_COMPTE.flg_simp%TYPE;
  v_codsensopecompte        RC_DROIT_COMPTE.cod_sens_ope%TYPE;
  v_codsensbecompte         RC_DROIT_COMPTE.cod_sens_be%TYPE;
  v_flgimputbecompte        RC_DROIT_COMPTE.flg_imput_be%TYPE;
  v_flgimputcompcompte      RC_DROIT_COMPTE.flg_imput_comp%TYPE;
  v_ideligprevligexec       FN_LIGNE_BUD_EXEC.ide_lig_prev%TYPE;
  v_idecptanaligexec        FN_LIGNE_BUD_EXEC.ide_cpt_ana%TYPE;
  v_varcptaligexec          FN_LIGNE_BUD_EXEC.var_cpta%TYPE;
  v_flgimputligexec         FN_LIGNE_BUD_EXEC.flg_imput%TYPE;
  v_flgapligprev            FN_LIGNE_BUD_PREV.flg_ap%TYPE;
  v_codnatcrligprev         FN_LIGNE_BUD_PREV.cod_nat_cr%TYPE;
  v_flgrecetteope           RB_OPE.flg_recette%TYPE;
  v_flgdepenseope           RB_OPE.flg_depense%TYPE;
  v_vartiersrefpiece        FC_REF_PIECE.var_tiers%TYPE;
  v_idetiersrefpiece        FC_REF_PIECE.ide_tiers%TYPE;
  v_nbligne                 NUMBER;
  v_codsensprec             FC_LIGNE.cod_sens%TYPE;
  v_totmtcr                 FC_LIGNE.mt%TYPE;
  v_totmtdb                 FC_LIGNE.mt%TYPE;
  v_flgerreurjc             VARCHAR2(1);


-----------------------------
-- Définition des Curseurs --
-----------------------------
  CURSOR cur_fc_ecriture(PC_Ideposte       FC_ECRITURE.ide_poste%TYPE,
                         PC_Idegest        FC_ECRITURE.ide_gest%TYPE,
                         PC_Codtypnd       FC_ECRITURE.cod_typ_nd%TYPE,
                         PC_Idendemet      FC_ECRITURE.ide_nd_emet%TYPE,
                         PC_Idemess        FC_ECRITURE.ide_mess%TYPE,
                         PC_Flgemisrecu    FC_ECRITURE.flg_emis_recu%TYPE,
                         PC_Non            FC_ECRITURE.flg_cptab%TYPE,
                         PC_Saisie         FC_ECRITURE.cod_statut%TYPE,
                         PC_Accepte        FC_ECRITURE.cod_statut%TYPE,
                         PC_Recu           FC_ECRITURE.cod_statut%TYPE) IS
    SELECT ide_poste
        ,ide_gest
     ,ide_jal
     ,flg_cptab
     ,ide_ecr
     ,var_cpta
     ,ide_schema
     -- ,          -- SNE, 13/09/2001 : Suppression du flag DSO assignee/ecritures
    FROM FC_ECRITURE
    WHERE ide_poste = PC_Ideposte
      AND ide_gest = PC_Idegest
      AND cod_typ_nd = PC_Codtypnd
      AND ide_nd_emet = PC_Idendemet
      AND ide_mess = PC_Idemess
      AND flg_emis_recu = PC_Flgemisrecu
      AND flg_cptab = PC_Non
      AND cod_statut IN (PC_Saisie,PC_Recu)
    ORDER BY ide_jal,ide_ecr;

  CURSOR cur_fc_ligne(PC_Ideposte    FC_ECRITURE.ide_poste%TYPE,
                      PC_Idegest     FC_ECRITURE.ide_gest%TYPE,
                      PC_Idejal      FC_ECRITURE.ide_jal%TYPE,
                      PC_Flgcptab    FC_ECRITURE.flg_cptab%TYPE,
                      PC_Ideecr      FC_ECRITURE.ide_ecr%TYPE) IS
    SELECT ide_lig
      ,var_cpta
     ,ide_cpt
     ,ide_modele_lig
     ,spec1
     ,spec2
     ,spec3
     ,ide_ordo
           ,var_tiers
     ,ide_tiers
     ,cod_ref_piece
     ,ide_ref_piece
     ,cod_bud
     ,cod_typ_bud
           ,var_bud
     ,ide_lig_exec
     ,ide_ope
     ,cod_sens
     ,mt
     -- MODIF SGN ANOVA71 : recuperation des info compte aux
     ,ide_plan_aux
     ,ide_cpt_aux
     ,ide_schema
     -- fin modif sgn
    FROM FC_LIGNE
    WHERE ide_poste = PC_Ideposte
      AND ide_gest = PC_Idegest
      AND ide_jal = PC_Idejal
      AND flg_cptab = PC_Flgcptab
      AND ide_ecr = PC_Ideecr
    ORDER BY ide_lig;


------------------------------
-- Définition des Fonctions --
------------------------------
/* *************** */
/* Procedure Trace */
/* *************** */
PROCEDURE Trace(PF_Message    IN    VARCHAR2) IS
BEGIN
  dbms_output.put_line(PF_Message);
  NULL;
END Trace;

/* ******************************************** */
/* Fonction Initialisation paramètres de sortie */
/* ******************************************** */
PROCEDURE MAJ_Out_Param(PF_Idemesserr    SR_MESS_ERR.ide_mess_err%TYPE,
                        PF_Param1        VARCHAR2,
                        PF_Param2        VARCHAR2,
                        PF_Param3        VARCHAR2) IS
BEGIN
  P_IDE_MESS_ERR := PF_Idemesserr;
  P_PARAM1       := SUBSTR(PF_Param1,1,120);
  P_PARAM2       := SUBSTR(PF_Param2,1,120);
  P_PARAM3       := SUBSTR(PF_Param3,1,120);
END MAJ_Out_Param;

/* ***************************************************** */
/* Fonction de Suppression info bordereau dans FM_ERREUR */
/* ***************************************************** */
FUNCTION MAJ_Del_Fm_Erreur(PF_Codtypnd       FM_ERREUR.cod_typ_nd%TYPE,
                           PF_Idendemet      FM_ERREUR.ide_nd_emet%TYPE,
                           PF_Idemess        FM_ERREUR.ide_mess%TYPE,
                           PF_Flgemisrecu    FM_ERREUR.flg_emis_recu%TYPE) RETURN NUMBER IS
BEGIN
  --Trace('Suppression FM_ERREUR');

  DELETE FROM FM_ERREUR
  WHERE cod_typ_nd = PF_Codtypnd
    AND ide_nd_emet = PF_Idendemet
    AND ide_mess = PF_Idemess
    AND flg_emis_recu = PF_Flgemisrecu
    AND ide_entite = 4;

  RETURN(0);


EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - MAJ_Del_Fm_Erreur) '||SQLERRM,'','');
    RETURN(-1);

END MAJ_Del_Fm_Erreur;

/* *************************************************** */
/* Fonction de Insertion info bordereau dans FM_ERREUR */
/* *************************************************** */
FUNCTION MAJ_Fm_Erreur(PF_Codtypnd       FM_ERREUR.cod_typ_nd%TYPE,
                       PF_Idendemet      FM_ERREUR.ide_nd_emet%TYPE,
                       PF_Idemess        FM_ERREUR.ide_mess%TYPE,
                       PF_Flgemisrecu    FM_ERREUR.flg_emis_recu%TYPE,
                       PF_Ideposte       FC_ECRITURE.ide_poste%TYPE,
                       PF_Idegest        FC_ECRITURE.ide_gest%TYPE,
                       PF_Idejal         FC_ECRITURE.ide_jal%TYPE,
                       PF_Flgcptab       FC_ECRITURE.flg_cptab%TYPE,
                       PF_Ideecr         FC_ECRITURE.ide_ecr%TYPE,
                       PF_Idemesserr     FM_ERREUR.ide_mess_err%TYPE,
                       PF_Param1         VARCHAR2,
                       PF_Param2         VARCHAR2,
                       PF_Param3         VARCHAR2) RETURN NUMBER IS
BEGIN
  --Trace('Insertion FM_ERREUR');

  INSERT INTO FM_ERREUR
    (cod_typ_nd
 ,ide_nd_emet
 ,ide_mess
 ,flg_emis_recu
 ,ide_entite
    ,par_entite
 ,ide_mess_err
 ,par_mess
 )
  VALUES
    (PF_Codtypnd
 ,PF_Idendemet
 ,PF_Idemess
 ,PF_Flgemisrecu
 ,4
 ,RPAD(PF_Ideposte,15,' ')||RPAD(PF_Idegest,7,' ')||RPAD(PF_Idejal,10,' ')||PF_Flgcptab||LPAD(TO_CHAR(PF_Ideecr),12,' ')
    , PF_Idemesserr,SUBSTR(PF_Param1||'+@+'||PF_Param2||'+@+'||PF_Param3,1,120));

  RETURN(0);


EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - MAJ_Fm_Erreur) '||SQLERRM,'','');
    RETURN(-1);

END MAJ_Fm_Erreur;

/* ****************************** */
/* Fonction Extraction info Poste */
/* ****************************** */
FUNCTION EXT_Rm_Poste(PF_Ideposte              RM_POSTE.ide_poste%TYPE,
                      PF_Typposte    IN OUT    RM_POSTE.ide_typ_poste%TYPE,
                      PF_Flgcad      IN OUT    RM_POSTE.flg_cad%TYPE) RETURN NUMBER IS
BEGIN
  --Trace('Recuperation information du poste');

  PF_Typposte := NULL;
  PF_Flgcad   := NULL;

  SELECT ide_typ_poste,flg_cad INTO PF_Typposte,PF_Flgcad
  FROM RM_POSTE
  WHERE ide_poste = PF_Ideposte;

  --Trace('PF_Typposte -> '||PF_Typposte);
  --Trace('PF_Flgcad   -> '||PF_Flgcad);

  RETURN(0);


EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - EXT_Rm_Poste) '||SQLERRM,'','');
    RETURN(-1);

END EXT_Rm_Poste;

/* *************************************** */
/* Fonction Extraction date fin de Gestion */
/* *************************************** */
FUNCTION EXT_Fval_Gest(PF_Idegest              FN_GESTION.ide_gest%TYPE,
                       PF_Datfval    IN OUT    FN_GESTION.dat_fval%TYPE) RETURN NUMBER IS
BEGIN
  --Trace('Recuperation information gestion');

  PF_Datfval := NULL;

  SELECT dat_fval INTO PF_Datfval
  FROM FN_GESTION
  WHERE ide_gest = PF_Idegest;

  --Trace('PF_Datfval -> '||TO_CHAR(PF_Datfval));

  RETURN(0);


EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - EXT_Fval_Gest) '||SQLERRM,'','');
    RETURN(-1);

END EXT_Fval_Gest;

/* ************************************* */
/* Fonction Extraction info Modele ligne */
/* ************************************* */
FUNCTION EXT_Rc_Modele_Ligne(PF_Varcpta                   RC_MODELE_LIGNE.var_cpta%TYPE,
                             PF_Idejal                    RC_MODELE_LIGNE.ide_jal%TYPE,
                             PF_Ideschema                 RC_MODELE_LIGNE.ide_schema%TYPE,
                             PF_Idemodelelig              RC_MODELE_LIGNE.ide_modele_lig%TYPE,
                             PF_Mascpt          IN OUT    RC_MODELE_LIGNE.mas_cpt%TYPE,
                             PF_Masspec1        IN OUT    RC_MODELE_LIGNE.mas_spec1%TYPE,
                             PF_Masspec2        IN OUT    RC_MODELE_LIGNE.mas_spec2%TYPE,
                             PF_Masspec3        IN OUT    RC_MODELE_LIGNE.mas_spec3%TYPE,
                             PF_Masordo         IN OUT    RC_MODELE_LIGNE.mas_ordo%TYPE,
                             PF_Masbud          IN OUT    RC_MODELE_LIGNE.mas_bud%TYPE,
                             PF_Masligbud       IN OUT    RC_MODELE_LIGNE.mas_lig_bud%TYPE,
                             PF_Masope          IN OUT    RC_MODELE_LIGNE.mas_ope%TYPE,
                             PF_Mastiers        IN OUT    RC_MODELE_LIGNE.mas_tiers%TYPE,
                             PF_Masrefpiece     IN OUT    RC_MODELE_LIGNE.mas_ref_piece%TYPE,
                             PF_Codsigne        IN OUT    RC_MODELE_LIGNE.cod_signe%TYPE,
                             PF_Codrefpiece     IN OUT    RC_MODELE_LIGNE.cod_ref_piece%TYPE,
        PF_Masidecptaux    IN OUT    RC_MODELE_LIGNE.ide_cpt_aux%TYPE) RETURN NUMBER IS
BEGIN
  --Trace('Recuperation information du modele ligne');

  PF_Mascpt      := NULL;
  PF_Masspec1    := NULL;
  PF_Masspec2    := NULL;
  PF_Masspec3    := NULL;
  PF_Masordo     := NULL;
  PF_Masbud      := NULL;
  PF_Masligbud   := NULL;
  PF_Masope      := NULL;
  PF_Mastiers    := NULL;
  PF_Masrefpiece := NULL;
  PF_Codsigne    := NULL;
  PF_Codrefpiece := NULL;
  /* LGD - ANO VA V3 71 */
  PF_Masidecptaux:= NULL;
  /*Fin de modification */

  SELECT mas_cpt,mas_spec1,mas_spec2,mas_spec3,mas_ordo,mas_bud,
         mas_lig_bud,mas_ope,mas_tiers,mas_ref_piece,cod_signe,
         cod_ref_piece, ide_cpt_aux
    INTO PF_Mascpt,PF_Masspec1,PF_Masspec2,PF_Masspec3,PF_Masordo,PF_Masbud,
         PF_Masligbud,PF_Masope,PF_Mastiers,PF_Masrefpiece,PF_Codsigne,
         PF_Codrefpiece,
   PF_Masidecptaux
  FROM RC_MODELE_LIGNE
  WHERE var_cpta = PF_Varcpta
    AND ide_jal = PF_Idejal
    AND ide_schema = PF_Ideschema
    AND ide_modele_lig = PF_Idemodelelig
    AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
    AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008

  --Trace('PF_Mascpt      -> '||PF_Mascpt);
  --Trace('PF_Masspec1    -> '||PF_Masspec1);
  --Trace('PF_Masspec2    -> '||PF_Masspec2);
  --Trace('PF_Masspec3    -> '||PF_Masspec3);
  --Trace('PF_Masordo     -> '||PF_Masordo);
  --Trace('PF_Masbud      -> '||PF_Masbud);
  --Trace('PF_Masligbud   -> '||PF_Masligbud);
  --Trace('PF_Masope      -> '||PF_Masope);
  --Trace('PF_Mastiers    -> '||PF_Mastiers);
  --Trace('PF_Masrefpiece -> '||PF_Masrefpiece);
  --Trace('PF_Codsigne    -> '||PF_Codsigne);
  --Trace('PF_Codrefpiece -> '||PF_Codrefpiece);

  RETURN(0);


EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --Trace('+++ Modele Ligne inexistant');
    RETURN(1);

  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - EXT_Rc_Modele_Ligne) '||SQLERRM,'','');
    RETURN(-1);

END EXT_Rc_Modele_Ligne;

/* ******************************* */
/* Fonction de Controle Jc Ouverte */
/* ******************************* */
FUNCTION CTL_Jc_Ouverte(PF_Ideposte     FC_ECRITURE.ide_poste%TYPE,
                        PF_Idegest      FC_ECRITURE.ide_gest%TYPE,
                        PF_Datjc        FC_ECRITURE.dat_jc%TYPE,
                        PF_Jcouverte    FC_CALEND_HIST.cod_ferm%TYPE) RETURN NUMBER IS

  v_codferm    FC_CALEND_HIST.cod_ferm%TYPE;
BEGIN
  --Trace('-> Controle JC');

  SELECT cod_ferm INTO v_codferm
  FROM FC_CALEND_HIST
  WHERE ide_poste = PF_Ideposte
    AND ide_gest = PF_Idegest
    AND dat_jc = PF_Datjc;

  IF v_codferm != PF_Jcouverte THEN
    --Trace('+++ Journee Comptable non ouverte');
    RETURN(1);
  ELSE
    RETURN(0);
  END IF;


EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --Trace('+++ Journee Comptable inexistante');
    RETURN(1);

  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Jc_Ouverte) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Jc_Ouverte;

/* **************************** */
/* Fonction de Controle Journal */
/* **************************** */
FUNCTION CTL_Journal(PF_Typposte              RM_POSTE.ide_typ_poste%TYPE,
                     PF_Varcpta               FC_ECRITURE.var_cpta%TYPE,
                     PF_Idejal                FC_ECRITURE.ide_jal%TYPE,
                     PF_Datjc                 FC_ECRITURE.dat_jc%TYPE,
                     PF_Oui                   FC_JOURNAL.flg_annul%TYPE,
                     PF_Non                   FC_JOURNAL.flg_annul%TYPE,
                     PF_Flgbe       IN OUT    FC_JOURNAL.flg_be%TYPE) RETURN NUMBER IS
BEGIN
  --Trace('- Controle du journal');

  PF_Flgbe := NULL;

  SELECT flg_be INTO PF_Flgbe
  FROM FC_JOURNAL t1,RC_DROIT_JOURNAL t2
  WHERE t2.var_cpta = t1.var_cpta
    AND t2.ide_jal = t1.ide_jal
    AND t2.ide_typ_poste = PF_Typposte
    AND t1.var_cpta = PF_Varcpta
    AND t1.ide_jal = PF_Idejal
    AND Ctl_Date(t1.dat_dval,PF_Datjc) = 'O'
    AND Ctl_Date(PF_Datjc,t1.dat_fval) = 'O'
    AND Ctl_Date(PF_Datjc,t2.dat_fval) = 'O'
    AND t1.flg_saisi = PF_Oui
    AND t1.flg_repsolde = PF_Non
    AND t1.flg_annul = PF_Non;

  --Trace('PF_Flgbe   -> '||PF_Flgbe);

  RETURN(0);


EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --Trace('+++ Journal non valide');
    RETURN(1);

  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Journal) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Journal;

/* *************************** */
/* Fonction de Controle Schema */
/* *************************** */
FUNCTION CTL_Schema(PF_Flgcad                    RM_POSTE.flg_cad%TYPE,
                    PF_Varcpta                   FC_ECRITURE.var_cpta%TYPE,
                    PF_Idejal                    FC_ECRITURE.ide_jal%TYPE,
                    PF_Ideschema                 FC_ECRITURE.ide_schema%TYPE,
                    PF_Datjc                     FC_ECRITURE.dat_jc%TYPE,
                    PF_Oui                       RM_POSTE.flg_cad%TYPE,
                    PF_Non                       RM_POSTE.flg_cad%TYPE,
                    PF_Typschemadso              RC_SCHEMA_CPTA.cod_typ_schema%TYPE,
                    PF_Typschema       IN OUT    RC_SCHEMA_CPTA.cod_typ_schema%TYPE) RETURN NUMBER IS
BEGIN
  --Trace('- Controle du schema');

  PF_Typschema := NULL;

  SELECT cod_typ_schema INTO PF_Typschema
  FROM RC_SCHEMA_CPTA
  WHERE var_cpta = PF_Varcpta
    AND ide_jal = PF_Idejal
    AND ide_schema = PF_Ideschema
    AND Ctl_Date(dat_dval,PF_Datjc) = 'O'
    AND Ctl_Date(PF_Datjc,dat_fval) = 'O'
    AND (PF_Flgcad = PF_Oui OR
         (PF_Flgcad = PF_Non AND cod_typ_schema != PF_Typschemadso));

  --Trace('PF_Typschema -> '||PF_Typschema);

  RETURN(0);


EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --Trace('+++ Schema non valide');
    RETURN(1);

  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Schema) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Schema;

/* *********************************** */
/* Fonction de Controle Saisi Ecriture */
/* *********************************** */
FUNCTION CTL_Saisiecr(PF_Codtypnd                  FM_ERREUR.cod_typ_nd%TYPE,
                      PF_Idendemet                 FM_ERREUR.ide_nd_emet%TYPE,
                      PF_Idemess                   FM_ERREUR.ide_mess%TYPE,
                      PF_Flgemisrecu               FM_ERREUR.flg_emis_recu%TYPE,
                      PF_Ideposte                  FC_ECRITURE.ide_poste%TYPE,
                      PF_Idegest                   FC_ECRITURE.ide_gest%TYPE,
                      PF_Idejal                    FC_ECRITURE.ide_jal%TYPE,
                      PF_Flgcptab                  FC_ECRITURE.flg_cptab%TYPE,
                      PF_Ideecr                    FC_ECRITURE.ide_ecr%TYPE,
                      PF_Typposte                  RM_POSTE.ide_typ_poste%TYPE,
                      PF_Flgcad                    RM_POSTE.flg_cad%TYPE,
                      PF_Varcpta                   FC_ECRITURE.var_cpta%TYPE,
                      PF_Ideschema                 FC_ECRITURE.ide_schema%TYPE,
                      PF_Datjc                     FC_ECRITURE.dat_jc%TYPE,
                      PF_Oui                       FC_JOURNAL.flg_annul%TYPE,
                      PF_Non                       FC_JOURNAL.flg_annul%TYPE,
                      PF_Typschemadso              RC_SCHEMA_CPTA.cod_typ_schema%TYPE,
                      PF_Flgbe           IN OUT    FC_JOURNAL.flg_be%TYPE,
                      PF_Typschema       IN OUT    RC_SCHEMA_CPTA.cod_typ_schema%TYPE) RETURN NUMBER IS

  v_retour    NUMBER;
BEGIN
  --Trace('-> Controle Saisi Ecriture');

  -- Controle Journal
  -------------------
  v_retour := CTL_Journal(PF_Typposte,PF_Varcpta,PF_Idejal,PF_Datjc,PF_Oui,PF_Non,PF_Flgbe);
  IF v_retour = 1 THEN
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,355,'','','') != 0 THEN
      RETURN(-1);
    END IF;
  ELSIF v_retour = -1 THEN
    RETURN(-1);
  END IF;

  -- Controle Schema
  ------------------
  v_retour := CTL_Schema(PF_Flgcad,PF_Varcpta,PF_Idejal,PF_Ideschema,PF_Datjc,PF_Oui,PF_Non,
                         PF_Typschemadso,PF_Typschema);
  IF v_retour = 1 THEN
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,356,'','','') != 0 THEN
      RETURN(-1);
    END IF;
  ELSIF v_retour = -1 THEN
    RETURN(-1);
  END IF;

  RETURN(0);


EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Saisiecr) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Saisiecr;

/* *************************** */
/* Fonction de Controle Compte */
/* *************************** */
FUNCTION CTL_Compte(PF_Typposte                    RM_POSTE.ide_typ_poste%TYPE,
                    PF_Varcpta                     FC_LIGNE.var_cpta%TYPE,
                    PF_Idecpt                      FC_LIGNE.ide_cpt%TYPE,
                    PF_Datjc                       FC_ECRITURE.dat_jc%TYPE,
                    PF_Oui                         FC_JOURNAL.flg_annul%TYPE,
                    PF_Non                         FC_JOURNAL.flg_annul%TYPE,
                    PF_Flgbe                       FC_JOURNAL.flg_be%TYPE,
                    PF_Flgjustif         IN OUT    FN_COMPTE.flg_justif%TYPE,
                    PF_Flgjustiftiers    IN OUT    FN_COMPTE.flg_justif_tiers%TYPE,
                    PF_Flgjustifcpt      IN OUT    FN_COMPTE.flg_justif_cpt%TYPE,
                    PF_Flgsimp           IN OUT    FN_COMPTE.flg_simp%TYPE,
                    PF_Codsensope        IN OUT    RC_DROIT_COMPTE.cod_sens_ope%TYPE,
                    PF_Flgimputbe        IN OUT    RC_DROIT_COMPTE.flg_imput_be%TYPE,
                    PF_Codsensbe         IN OUT    RC_DROIT_COMPTE.cod_sens_be%TYPE,
                    PF_Flgimputcomp      IN OUT    RC_DROIT_COMPTE.flg_imput_comp%TYPE) RETURN NUMBER IS
BEGIN
  --Trace('- Controle valeur du compte');

  PF_Flgjustif      := NULL;
  PF_Flgjustiftiers := NULL;
  PF_Flgjustifcpt   := NULL;
  PF_Flgsimp        := NULL;
  PF_Codsensope     := NULL;
  PF_Flgimputbe     := NULL;
  PF_Codsensbe      := NULL;
  PF_Flgimputcomp   := NULL;

  SELECT t1.flg_justif,t1.flg_justif_tiers,t1.flg_justif_cpt,t1.flg_simp,
         t2.cod_sens_ope,t2.flg_imput_be,t2.cod_sens_be,t2.flg_imput_comp
    INTO PF_Flgjustif,PF_Flgjustiftiers,PF_Flgjustifcpt,PF_Flgsimp,
         PF_Codsensope,PF_Flgimputbe,PF_Codsensbe,PF_Flgimputcomp
  FROM FN_COMPTE t1,RC_DROIT_COMPTE t2
  WHERE t2.var_cpta = t1.var_cpta
    AND t2.ide_cpt = t1.ide_cpt
    AND t2.ide_typ_poste = PF_Typposte
    AND t1.var_cpta = PF_Varcpta
    AND t1.ide_cpt = PF_Idecpt
    AND Ctl_Date(t1.dat_dval,PF_Datjc) = 'O'
    AND Ctl_Date(PF_Datjc,t1.dat_fval) = 'O'
    AND Ctl_Date(PF_Datjc,t2.dat_fval) = 'O'
    AND t1.flg_rgrp = PF_Non
    AND (PF_Flgbe = PF_Oui OR
         (PF_Flgbe = PF_Non AND t1.flg_bequille = PF_Non));

  --Trace('PF_Flgjustif      -> '||PF_Flgjustif);
  --Trace('PF_Flgjustiftiers -> '||PF_Flgjustiftiers);
  --Trace('PF_Flgjustifcpt   -> '||PF_Flgjustifcpt);
  --Trace('PF_Flgsimp        -> '||PF_Flgsimp);
  --Trace('PF_Codsensope     -> '||PF_Codsensope);
  --Trace('PF_Flgimputbe     -> '||PF_Flgimputbe);
  --Trace('PF_Codsensbe      -> '||PF_Codsensbe);
  --Trace('PF_Flgimputcomp   -> '||PF_Flgimputcomp);

  RETURN(0);


EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --Trace('+++ Compte non valide');
    RETURN(1);

  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Compte) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Compte;


/* ****************************************** */
/* Fonction de Controle des specs nationales */
/* **************************************** */
FUNCTION CTL_SPEC_NAT(PF_Varcpta IN RC_SPEC.var_cpta%TYPE,
                      PF_Idecpt IN RC_SPEC.ide_cpt%TYPE,
                      PF_cod_sens IN RC_SPEC.cod_sens%TYPE,
                      PF_cod_signe IN RC_SPEC.cod_signe%TYPE,
                      PF_spec1 IN FC_LIGNE.spec1%TYPE,
                      PF_spec2 IN FC_LIGNE.spec2%TYPE,
                      PF_spec3 IN FC_LIGNE.spec3%TYPE,
       PF_Datjc IN FC_ECRITURE.dat_jc%TYPE)RETURN NUMBER IS

 /* Fonction qui contrôle la combinaison des spec 1, 2, 3 */
  /* Retourne : 0 si échec du contrôle               */
  /*            1 si contrôle OK                     */
  /*            -1 si erreur au cours du traitement  */

  /* curseur de parcours de la table rc_spec */
  CURSOR c_spec IS
  SELECT A.mas_spec1, A.mas_spec2, A.mas_spec3 FROM RC_SPEC A
  WHERE A.var_cpta = PF_Varcpta
        AND A.ide_cpt = PF_Idecpt
        AND (A.cod_sens =  PF_cod_sens OR A.cod_sens ='X')
        AND (a.cod_signe = PF_cod_signe OR a.cod_signe ='X')
        AND CTL_DATE(a.dat_dval,P_DAT_JC)='O'--PGE V4260 EVOL_DI44_2008_014 16/05/2008  / PGE 14/10/2008 Ano 295
        AND CTL_DATE(P_DAT_JC,a.dat_fval)='O';--PGE V4260 EVOL_DI44_2008_014 16/05/2008 / PGE 14/10/2008 Ano 295
  /* variable de retour */
  v_retour NUMBER;
  /* variable de retour de la procedure CTL_Val_Masque */
  v_ret_ctl NUMBER;

BEGIN
 -- v_retour est initialise a 1 ainsi, si il n'y a pas de specification global
 --    alors on retourne 1
 v_retour := 1;

 -- Si on a des specifiations
  FOR v_spec IN c_spec LOOP
   v_retour := 0;

   IF Ctl_Val_Masque(v_spec.mas_spec1,PF_spec1 ,PF_Datjc)= 1 THEN
    -- controle de spec1 par rapport au masque 1
    -- si controle OK
     IF Ctl_Val_Masque(v_spec.mas_spec2,PF_spec2,PF_Datjc)= 1 THEN
      -- Controle de spec2 par rapport au masque 2
      -- si controle OK
       IF Ctl_Val_Masque(v_spec.mas_spec3,PF_spec3,PF_Datjc)= 1 THEN
         -- Controle de spec3 par rapport au masque 3
         -- si controle OK --> p_retour := 1 et on sort de la boucle
         v_retour := 1;
         EXIT;
       END IF;
     END IF;
   END IF;

  END LOOP;

  RETURN (v_retour);

EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_SPEC_NAT) '||SQLERRM,'','');
    RETURN(-1);
END;
/* ****************************************** */
/* Fonction de Controle des specs locales */
/* **************************************** */
FUNCTION CTL_SPEC_LOC(PF_Ideposte IN RC_SPEC_LOCAL.ide_poste%TYPE,
          PF_Varcpta IN RC_SPEC_LOCAL.var_cpta%TYPE,
                      PF_Idecpt IN RC_SPEC_LOCAL.ide_cpt%TYPE,
                      PF_cod_sens IN RC_SPEC.cod_sens%TYPE,
                      PF_cod_signe IN RC_SPEC.cod_signe%TYPE,
                      PF_spec2 IN FC_LIGNE.spec2%TYPE,
                      PF_spec3 IN FC_LIGNE.spec3%TYPE,
       PF_Datjc IN FC_ECRITURE.dat_jc%TYPE) RETURN NUMBER IS
  /* Fonction qui contrôle la combinaison des spec local 2, 3 */
  /* Retourne : 0 si échec du contrôle               */
  /*            1 si contrôle OK                     */
  /*            -1 si erreur au cours du traitement  */

  /* curseur de parcours de la table rc_spec */
  CURSOR c_spec IS
  SELECT A.mas_spec1, A.mas_spec2, A.mas_spec3
  FROM RC_SPEC A
  WHERE A.var_cpta = PF_Varcpta
        AND A.ide_cpt = PF_Idecpt
        AND (A.cod_sens = PF_cod_sens OR A.cod_sens ='X')
        AND (a.cod_signe = PF_cod_signe OR a.cod_signe ='X')
        AND CTL_DATE(a.dat_dval,P_DAT_JC)='O'--PGE V4260 EVOL_DI44_2008_014 16/05/2008 / PGE 14/10/2008 Ano 295
        AND CTL_DATE(P_DAT_JC,a.dat_fval)='O';--PGE V4260 EVOL_DI44_2008_014 16/05/2008; / PGE 14/10/2008 Ano 295

  /* curseur de parcours de la table rc_spec */
  CURSOR c_spec_loc IS
  SELECT A.mas_spec2, A.mas_spec3
  FROM RC_SPEC_LOCAL A
  WHERE A.ide_poste = PF_Ideposte
   AND A.var_cpta = PF_Varcpta
    AND A.ide_cpt = PF_Idecpt;
  /* variable de retour */
  v_retour NUMBER;

  /* Les variables utilisees pour recuperer les codifs internes */
  v_ide_masque2 RC_SPEC_LOCAL.mas_spec2%TYPE := NULL;
  v_ide_masque3 RC_SPEC_LOCAL.mas_spec3%TYPE := NULL;
  v_libl SR_CODIF.libl%TYPE;
  v_ret_codint NUMBER;
  v_ret NUMBER;
BEGIN
 -- v_retour est initialise a 1 ainsi, si il n'y a pas de specification locale
 --    alors on retourne 1
 v_retour := 1;

 FOR v_spec IN c_spec LOOP
  -- v_retour := 0;

  -- MODIF SGN Du 01/03/2002 : Reinitialisation des code internes des masques
  v_ide_masque2 := NULL;
  v_ide_masque3 := NULL;

-- MODIF SGN ANOVA406 : 3.1-1.9
--  -- MODIF SGN Du 01/03/2002 : Si le masque des spec2 est null on ne cherche pas son code
--  -- interne
--  IF v_spec.mas_spec2 IS NOT NULL THEN
--   -- Recuperation du code interne du masque de specification de spec2 et 3
--   Ext_Codint_D('MASQUE',Upper(v_spec.mas_spec2),PF_Datjc,v_libl,v_ide_masque2,v_ret_codint);
--   IF v_ret_codint != 1 THEN
--     MAJ_Out_Param(158,'(CTL_U212_012E) MASQUE ',Upper(v_spec.mas_spec2),'');
--     Return(-1);
--   END IF;
--
--  END IF;
--
--  -- MODIF SGN Du 01/03/2002 : Si le masque des spec3 est null on ne cherche pas son code
--  -- interne
--  IF v_spec.mas_spec3 IS NOT NULL THEN
--    Ext_Codint_D('MASQUE',Upper(v_spec.mas_spec3),PF_Datjc,v_libl,v_ide_masque3,v_ret_codint);
--    IF v_ret_codint != 1 THEN
--     MAJ_Out_Param(158,'(CTL_U212_012E) MASQUE ',Upper(v_spec.mas_spec3),'');
--     Return(-1);
--    END IF;
--   END IF;
--

            Ctl_Sais_Masque('U212_011F',
                              'Spec',
                              v_spec.mas_spec2,
                              v_ide_masque2,
                              v_ret);
            IF v_ret = 0 THEN
              -- masque non present pour l'ut dans sr_masque
              -- Normalement on ne doit pas arriver ici, car le controle des spec nationales elimine ce cas
              NULL;
            ELSIF v_ret != 1 THEN
              MAJ_Out_Param(357,v_spec.mas_spec2,v_ide_masque2,'');
              RETURN(-1);
            END IF;

            Ctl_Sais_Masque('U212_011F',
                              'Spec',
                              v_spec.mas_spec3,
                              v_ide_masque3,
                              v_ret);
            IF v_ret = 0 THEN
              -- masque non present pour l'ut dans sr_masque
              -- Normalement on ne doit pas arriver ici, car le controle des spec nationales elimine ce cas
              NULL;
            ELSIF v_ret != 1 THEN
              MAJ_Out_Param(357,v_spec.mas_spec3,v_ide_masque3,'');
              RETURN(-1);
            END IF;
-- fin modif sgn 3.1-1.9

  -- Si la table des specifications indique des specifications locales
  IF v_ide_masque2 = 'LOCAL' OR v_ide_masque3 = 'LOCAL' THEN
   -- Parcours de la table des specifiations locales
    FOR v_spec_loc IN c_spec_loc LOOP
     v_retour := 0;
     IF NVL(v_ide_masque2,'NULL') = 'LOCAL' AND NVL(v_ide_masque3,'NULL') = 'LOCAL' THEN
      -- Si il s agit d une specification locale, on controle les valeurs saisies en fonction de la table des
      -- specifications locales
      -- controle par rapport au masque2 de table des spec locales
      IF PF_spec2 IS NULL
      OR Ctl_Val_Masque(v_spec_loc.mas_spec2,PF_spec2,PF_Datjc)= 1
      THEN
       -- si spec3 est non null, on le controle par rapport au masque3 de table des spec locales
       IF PF_spec3 IS NULL
       OR Ctl_Val_Masque(v_spec_loc.mas_spec3,PF_spec3,PF_Datjc)= 1 THEN
        v_retour := 1;
           EXIT;
       END IF;
      END IF;
     ELSIF NVL(v_ide_masque2,'NULL') != 'LOCAL' AND NVL(v_ide_masque3,'NULL') = 'LOCAL' THEN
      -- Le masque2 des specifications locales doit etre null
      --  et le controle de spec2 doit etre fait par rapport au masque2 de la table des spec globales
      IF v_spec_loc.mas_spec2 IS NULL THEN
       -- Controle de spec2
       IF Ctl_Val_Masque(v_spec.mas_spec2,PF_spec2,PF_Datjc)= 1 THEN
        -- Controle de spec3 par rapport au masque3 de table des spec locales
        IF PF_spec3 IS NULL
        OR Ctl_Val_Masque(v_spec_loc.mas_spec3,PF_spec3,PF_Datjc)= 1 THEN
         v_retour := 1;
            EXIT;
        END IF;
       END IF;
      END IF;
    ELSIF NVL(v_ide_masque2,'NULL') = 'LOCAL' AND NVL(v_ide_masque3,'NULL') != 'LOCAL' THEN
      -- Controle de spec2 par rapport au masque2 de table des spec locales
     IF PF_spec2 IS NULL
     --OR CTL_Val_Masque(v_spec.mas_spec2,p_spec2,:BL_CTRL.t_journee)= 1 THEN
     OR Ctl_Val_Masque(v_spec_loc.mas_spec2,PF_spec2,PF_Datjc)= 1 THEN
       -- Le masque3 des specifications locales doit etre null
       -- et le controle de spec3 par rapport au masque3 de table des spec globales
       IF v_spec_loc.mas_spec3 IS NULL THEN
        --IF CTL_Val_Masque(v_spec_loc.mas_spec3,p_spec3,:BL_CTRL.t_journee)= 1 THEN
         IF Ctl_Val_Masque(v_spec.mas_spec3,PF_spec3,PF_Datjc)= 1 THEN
         v_retour := 1;
            EXIT;
          END IF;
       END IF;
      END IF; -- IF Sp_spec2 IS NULL
     END IF;
    END LOOP;

    IF v_retour = 1 THEN
     EXIT;
    END IF;
   END IF;  -- IF v_ide_masque2 = 'LOCAL' ...
  END LOOP;

  RETURN (v_retour);

EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_SPEC_NAT) '||SQLERRM,'','');
    RETURN(-1);
END;





























/* ******************************** */
/* Fonction de Controle Ordonnateur */
/* ******************************** */
FUNCTION CTL_Ordo(PF_Ideordo    FC_LIGNE.ide_ordo%TYPE) RETURN NUMBER IS

  v_recup    VARCHAR2(1);
BEGIN
  --Trace('- Controle valeur ordonnateur');

  SELECT 'X' INTO v_recup
  FROM RB_ORDO t1,RM_NOEUD t2
  WHERE t2.cod_typ_nd = t1.cod_typ_nd
    AND t2.ide_nd = t1.ide_ordo
    AND t1.ide_ordo = PF_Ideordo;

  RETURN(0);


EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --Trace('+++ Ordonnateur non valide');
    RETURN(1);

  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Ordo) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Ordo;

/* ************************** */
/* Fonction de Controle Tiers */
/* ************************** */
FUNCTION CTL_Tiers(PF_Vartiers    FC_LIGNE.var_tiers%TYPE,
                   PF_Idetiers    FC_LIGNE.ide_tiers%TYPE) RETURN NUMBER IS

  v_recup    VARCHAR2(1);
BEGIN
  --Trace('- Controle valeur tiers');

  SELECT 'X' INTO v_recup
  FROM RB_TIERS
  WHERE var_tiers = PF_Vartiers
    AND ide_tiers = PF_Idetiers;

  RETURN(0);


EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --Trace('+++ Tiers non valide');
    RETURN(1);

  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Tiers) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Tiers;

/* ************************************ */
/* Fonction de Controle Reference piece */
/* ************************************ */
FUNCTION CTL_Refpiece(PF_Ideposte                    FC_ECRITURE.ide_poste%TYPE,
                      PF_Codrefpiece                 FC_LIGNE.cod_ref_piece%TYPE,
                      PF_Iderefpiece                 FC_LIGNE.ide_ref_piece%TYPE,
                      PF_Oui                         FC_JOURNAL.flg_annul%TYPE,
                      PF_Non                         FC_JOURNAL.flg_annul%TYPE,
                      PF_Flgjustif                   FN_COMPTE.flg_justif%TYPE,
                      PF_Flgjustiftiers              FN_COMPTE.flg_justif_tiers%TYPE,
                      PF_Vartiers                    FC_LIGNE.var_tiers%TYPE,
                      PF_idetiers                    FC_LIGNE.ide_tiers%TYPE,
                      PF_Flgjustifcpt                FN_COMPTE.flg_justif_cpt%TYPE,
                      PF_Varcpta                     FC_LIGNE.var_cpta%TYPE,
                      PF_Idecpt                      FC_LIGNE.ide_cpt%TYPE,
                      PF_Vartiersret       IN OUT    FC_REF_PIECE.var_tiers%TYPE,
                      PF_Idetiersret       IN OUT    FC_REF_PIECE.ide_tiers%TYPE,
       -- MODIF SGN ANOVA71 : ajout des info compte aux dans les controles refpiece
       PF_ideplanaux                  FC_REF_PIECE.ide_plan_aux%TYPE,
         PF_idecptaux                   FC_REF_PIECE.ide_cpt_aux%TYPE,
       PF_idejal                      FC_REF_PIECE.ide_jal%TYPE,
       PF_ideschema                   RC_SCHEMA_CPTA.ide_schema%TYPE,
       PF_idemodelelig                RC_MODELE_LIGNE.ide_modele_lig%TYPE,
         PF_refpieceA                   FC_REF_PIECE.cod_ref_piece%TYPE
       -- fin modif SGN
       ) RETURN NUMBER IS

v_ref_mod RC_MODELE_LIGNE.cod_ref_piece%TYPE;  -- MODIF SGN ANOVA71

BEGIN
  --Trace('- Controle valeur reference piece');

  PF_Vartiersret := NULL;
  PF_Idetiersret := NULL;

  -- MODIF SGN ANOVA71 : ajout des info relative a la F35 dans les controles refpiece
  -- si la référence pièce a été saisie et qu'il s'agit d'une création de pièce, pas de contrôle;
  -- si la référence pièce a été saisie et qu'il s'agit d'un abondement, la référence pièce doit exister;
  BEGIN
      SELECT cod_ref_piece
    INTO v_ref_mod
    FROM RC_MODELE_LIGNE
    WHERE var_cpta = PF_varcpta
      AND ide_jal = PF_idejal
   AND ide_schema = PF_ideschema
   AND ide_modele_lig = PF_idemodelelig
   AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
   AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008
  EXCEPTION
      WHEN OTHERS THEN
      RAISE;
  END;

  IF v_ref_mod = PF_refpieceA THEN
    BEGIN
       SELECT var_tiers,ide_tiers
    INTO PF_Vartiersret,PF_Idetiersret
       FROM FC_REF_PIECE
       WHERE ide_poste = PF_Ideposte
       AND cod_ref_piece = PF_Codrefpiece
   AND ide_ref_piece = PF_Iderefpiece
   AND flg_solde = PF_Non
   AND PF_Flgjustif = PF_Oui
   AND (PF_Flgjustiftiers = PF_Non OR
                 (PF_Flgjustiftiers = PF_Oui AND
                   var_tiers = PF_Vartiers AND
                   ide_tiers = PF_Idetiers
         )
          )
         AND (PF_Flgjustifcpt = PF_Non OR
                  (PF_Flgjustifcpt = PF_Oui AND
                   ide_ref_piece IN (SELECT ide_ref_piece
                                 FROM FC_LIGNE
                                 WHERE ide_poste = PF_Ideposte
                                   AND var_cpta = PF_Varcpta
                                   AND ide_cpt = PF_Idecpt
              )
                   -- MODIF SGN FCT38 Prise en compte du comptes auxiliaire s'il est renseigner
                   AND ( (PF_ideplanaux IS NULL
                 AND PF_idecptaux IS NULL
         )
                       OR
                       (ide_plan_aux = PF_ideplanaux
                         AND ide_cpt_aux = PF_idecptaux
        )
           )
              ));
  EXCEPTION
        WHEN NO_DATA_FOUND THEN
         --Trace('+++ Reference piece non valide');
      RETURN(1);
     WHEN TOO_MANY_ROWS THEN
        RETURN(0);
      WHEN OTHERS THEN
        RAISE;
  END;
  END IF;

  --Trace('PF_Vartiersret -> '||PF_Vartiersret);
  --Trace('PF_Idetiersret -> '||PF_Idetiersret);

  RETURN(0);


EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Refpiece) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Refpiece;


/* LGD - 17/09/2002 - Aster V3.0 Correction ANO 131 (ASTER V2.2) */

/* ************************************************************** */
/* Fonction de récupération du montant initial de la pièce */
/* ****************************************************************/

FUNCTION CTL_Mt_Init_Piece(PF_Iderefpiece                    FC_LIGNE.ide_ref_piece%TYPE,
                           PF_CodrefpieceC                   RC_MODELE_LIGNE.COD_REF_PIECE%TYPE,
         PF_mt_initial_piece_db  IN OUT    NUMBER,
                           PF_mt_initial_piece_cr  IN OUT    NUMBER) RETURN NUMBER IS

BEGIN

 --- Calcul du monant inital de la pièce dans la table FC_REF_PIECE
 SELECT RP.MT_DB MT_DB, RP.MT_CR MT_CR INTO
        PF_mt_initial_piece_db, PF_mt_initial_piece_cr
 FROM FC_REF_PIECE RP, FC_LIGNE LG, RC_MODELE_LIGNE ML
 WHERE
     RP.IDE_REF_PIECE = PF_Iderefpiece
 AND RP.IDE_POSTE = LG.IDE_POSTE
 AND RP.IDE_GEST = LG.IDE_GEST
 AND RP.IDE_JAL = LG.IDE_JAL
 AND RP.FLG_CPTAB = LG.FLG_CPTAB
 AND RP.IDE_ECR = LG.IDE_ECR
 AND RP.IDE_LIG = LG.IDE_LIG
 AND LG.VAR_CPTA = ML.VAR_CPTA
 AND LG.IDE_JAL = ML.IDE_JAL
 AND LG.IDE_SCHEMA = ML.IDE_SCHEMA
 AND LG.IDE_MODELE_LIG = ML.IDE_MODELE_LIG
    AND ML.COD_REF_PIECE  = PF_CodrefpieceC
 AND CTL_DATE(ML.dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
 AND CTL_DATE(sysdate,ML.dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008

 RETURN(0);


EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --- Le montant initial de la pièce %1 est introuvable
    RETURN(-1);
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Mt_Init_Piece) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Mt_Init_Piece;


/* ************************************************************** */
/* Fonction de calcul de la somme des montants abondés comparée avec
                            montant initial de la pièce */
/* ****************************************************************/

FUNCTION CTL_Mt_Total_Abond(PF_Iderefpiece                 FC_LIGNE.ide_ref_piece%TYPE,
                            PF_CodrefpieceA                RC_MODELE_LIGNE.COD_REF_PIECE%TYPE,
       PF_CodSensCR                   RC_MODELE_LIGNE.COD_REF_PIECE%TYPE,
       PF_Ideposte                    FC_LIGNE.ide_poste%TYPE,
       PF_MT                          FC_LIGNE.mt%TYPE,
       PF_Codsens                     FC_LIGNE.cod_sens%TYPE,
       PF_mt_initial_piece_db         NUMBER,
       PF_mt_initial_piece_cr         NUMBER,
       PF_mt_abond_piece_db IN OUT    NUMBER,
       PF_mt_abond_piece_cr IN OUT    NUMBER
       ) RETURN NUMBER IS


 /*
    CURSOR c_mt_mvt_piece IS

     select LG.MT, LG.cod_sens
 from fc_ligne LG,rc_modele_ligne ML
 where
   LG.IDE_REF_PIECE = PF_Iderefpiece  AND
   LG.IDE_POSTE=PF_Ideposte AND
   LG.VAR_CPTA = ML.VAR_CPTA AND
   LG.IDE_JAL = ML.IDE_JAL AND
   LG.IDE_SCHEMA = ML.IDE_SCHEMA AND
   LG.IDE_MODELE_LIG = ML.IDE_MODELE_LIG AND
   ML.COD_REF_PIECE  = PF_CodrefpieceA ; */

   -- RDU-20050728-D : Correction anomalie DI44-131
   -- voir aussi DI44-113 dans U212_012F.fmb
   v_mt_abond_piece_cod_sens varchar2(1);
   -- RDU-20050728-F : Correction anomalie DI44-131
   v_mt_db    NUMBER;
   v_mt_cr    NUMBER;

   CURSOR c_mt_mvt_piece IS
   SELECT LG.MT, LG.cod_sens
  FROM FC_LIGNE LG,RC_MODELE_LIGNE ML
  -- MODIF LGD ANOVA213 du du 17/01/2003  : ajout de la jointure avec l ecriture
  , FC_ECRITURE EC
  WHERE
    LG.IDE_REF_PIECE = PF_Iderefpiece AND
    LG.IDE_POSTE = PF_Ideposte AND
    LG.VAR_CPTA = ML.VAR_CPTA AND
    LG.IDE_JAL = ML.IDE_JAL AND
    LG.IDE_SCHEMA = ML.IDE_SCHEMA AND
    LG.IDE_MODELE_LIG = ML.IDE_MODELE_LIG AND
    ML.COD_REF_PIECE  = PF_CodrefpieceA
    -- MODIF LGD ANOVA213 du 17/01/2003
  AND EC.IDE_POSTE = PF_Ideposte
  AND EC.ide_gest =  P_IDE_GEST
  AND EC.ide_jal =   LG.IDE_JAL
  AND EC.flg_cptab = LG.flg_cptab
  AND EC.ide_ecr   = LG.ide_ecr
  AND EC.cod_statut = v_ecriture_V
  AND CTL_DATE(ML.dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
  AND CTL_DATE(sysdate,ML.dat_fval)='O'  --PGE V4260 EVOL_DI44_2008_014 16/05/2008
  -- Début PGE V4290 17/09/2009 ANO 393 Message intempestif : on ne doit pas prendre en compte les montants des lignes d'écritures annulées
  AND LG.ide_gest = EC.ide_gest
  AND LG.ide_poste = EC.ide_poste
  AND NOT EXISTS (SELECT 1 from fc_annul_ecr
                  WHERE ide_poste = LG.IDE_POSTE
                  AND   ide_gest = LG.IDE_GEST
                  AND   ide_jal = LG.IDE_jal
                  AND   flg_cptab = LG.flg_cptab
                  AND   ide_ecr = LG.ide_ecr) ;
  -- Fin PGE V4290 17/09/2009

  -- RDU-20050728-D : Correction anomalie DI44-131
  CURSOR c_cod_sens_cre_piece IS
  select A.COD_SENS
  from FC_LIGNE A, FC_REF_PIECE B
  where B.ide_poste = PF_Ideposte
  and B.ide_ref_piece = PF_Iderefpiece
  and A.ide_poste = B.ide_poste
  and A.ide_ecr = B.ide_ecr
  and A.ide_lig = B.ide_lig
  and A.ide_gest = B.ide_gest
  and A.ide_jal = B.ide_jal
  and A.flg_cptab = 'O';
  -- RDU-20050728-F : Correction anomalie DI44-131

     BEGIN

      FOR v_mt_piece_abond IN c_mt_mvt_piece LOOP
         IF v_mt_piece_abond.cod_sens = PF_CodSensCR  THEN
          PF_mt_abond_piece_cr:=v_mt_piece_abond.mt+PF_mt_abond_piece_cr;
         ELSE
          PF_mt_abond_piece_db:=v_mt_piece_abond.mt+PF_mt_abond_piece_db;
         END IF;
      END LOOP;

        -- RDU-20050728-D : Correction anomalie DI44-131
        FOR p_cod_sens_cre_piece IN c_cod_sens_cre_piece LOOP
         v_mt_abond_piece_cod_sens := p_cod_sens_cre_piece.cod_sens;
        END LOOP;
        -- RDU-20050728-F : Correction anomalie DI44-131

 -- MODIF LGD ANOVA213 du 18/01/2003 : recuperation du montant de la ligne
        IF (PF_Codsens !=  PF_CodSensCR AND PF_MT IS NOT NULL) THEN
     v_mt_cr := 0;
     v_mt_db := PF_MT;
  ELSIF (PF_Codsens =  PF_CodSensCR AND PF_MT IS NOT NULL) THEN
     v_mt_cr := PF_MT;
     v_mt_db := 0;
  ELSE
     v_mt_cr := 0;
     v_mt_db := 0;
  END IF;
  -- Fin modif LGD


  -- RDU-20050728-D : Correction anomalie DI44-131
  IF v_mt_abond_piece_cod_sens = 'D' Then
  -- IF PF_mt_initial_piece_db!=0 THEN
  -- RDU-20050728-F : Correction anomalie DI44-131
     IF PF_mt_abond_piece_cr + v_mt_cr > PF_mt_initial_piece_db  THEN
    --- Impossible d'abonder la pièce %1 car la somme des montants des pièces doit être <= montant de la pièce initial.
      RETURN(-1);
     END IF;
    END IF;

  -- RDU-20050728-D : Correction anomalie DI44-131
  IF v_mt_abond_piece_cod_sens = 'C' Then
  -- IF PF_mt_initial_piece_cr!=0 THEN
  -- RDU-20050728-F : Correction anomalie DI44-131
   IF PF_mt_abond_piece_db + v_mt_db > PF_mt_initial_piece_cr THEN
      --- Impossible d'abonder la pièce %1 car la somme des montants des pièces doit être <= montant de la pièce initial.
      RETURN(-1);
     END IF;
  END IF;

     /* LGD - 18/11/2002 - ANO interne la fonction ne ramène aucune valeur */
  RETURN(0);
  /* Fin de modification */

 EXCEPTION
       WHEN OTHERS THEN
        MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Mt_Total_Abond) '||SQLERRM,'','');
        RETURN(-1);

END CTL_Mt_Total_Abond;
/* Fin de  modification LGD*/

/* *************************** */
/* Fonction de Controle Budget */
/* *************************** */
FUNCTION CTL_Budget(PF_Codbud       FC_LIGNE.cod_bud%TYPE,
                    PF_ideordo      FC_LIGNE.ide_ordo%TYPE,
                    PF_Idegest      FC_ECRITURE.ide_gest%TYPE,
                    PF_Codtypbud    FC_LIGNE.cod_typ_bud%TYPE,
                    PF_Datjc        FC_ECRITURE.dat_jc%TYPE) RETURN NUMBER IS

  v_recup    VARCHAR2(1);
BEGIN
  --Trace('- Controle valeur budget');

  SELECT 'X' INTO v_recup
  FROM RN_BUDGET t1,RN_DROIT_BUDGET t2,FN_VAR_GEST_BUD t3
  WHERE t2.cod_bud = t1.cod_bud
    AND t3.cod_bud = t1.cod_bud
    AND t1.cod_bud = PF_Codbud
    AND t2.ide_ordo = PF_Ideordo
    AND t3.ide_gest = PF_Idegest
    AND t3.cod_typ_bud = PF_Codtypbud
    AND Ctl_Date(PF_Datjc,t1.dat_fval) = 'O'
    AND Ctl_Date(PF_Datjc,t3.dat_fval) = 'O';

  RETURN(0);


EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --Trace('+++ Budget non valide');
    RETURN(1);

  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Budget) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Budget;

/* ************************************ */
/* Fonction de Controle Ligne execution */
/* ************************************ */
FUNCTION CTL_Ligexec(PF_Varbud                  FC_LIGNE.var_bud%TYPE,
                     PF_Ideligexec              FC_LIGNE.ide_lig_exec%TYPE,
                     PF_Ideligprev    IN OUT    FN_LIGNE_BUD_EXEC.ide_lig_prev%TYPE,
                     PF_Idecptana     IN OUT    FN_LIGNE_BUD_EXEC.ide_cpt_ana%TYPE,
                     PF_Varcpta       IN OUT    FN_LIGNE_BUD_EXEC.var_cpta%TYPE,
                     PF_Flgimput      IN OUT    FN_LIGNE_BUD_EXEC.flg_imput%TYPE,
                     PF_Flgap         IN OUT    FN_LIGNE_BUD_PREV.flg_ap%TYPE,
                     PF_Codnatcr      IN OUT    FN_LIGNE_BUD_PREV.cod_nat_cr%TYPE) RETURN NUMBER IS
BEGIN
  --Trace('- Controle valeur ligne execution');

  PF_Ideligprev := NULL;
  PF_Idecptana  := NULL;
  PF_Varcpta    := NULL;
  PF_Flgimput   := NULL;
  PF_Flgap      := NULL;
  PF_Codnatcr   := NULL;

  SELECT t1.ide_lig_prev,t1.ide_cpt_ana,t1.var_cpta,
         t2.flg_ap,t2.cod_nat_cr,t1.flg_imput
    INTO PF_Ideligprev,PF_Idecptana,PF_Varcpta,
         PF_Flgap,PF_Codnatcr,PF_Flgimput
  FROM FN_LIGNE_BUD_EXEC t1, FN_LIGNE_BUD_PREV t2
  WHERE t2.var_bud = t1.var_bud
    AND t2.ide_lig_prev = t1.ide_lig_prev
    AND t1.var_bud = PF_Varbud
    AND t1.ide_lig_exec = PF_Ideligexec;

  --Trace('PF_Ideligprev  -> '||PF_Ideligprev);
  --Trace('PF_Idecptana   -> '||PF_Idecptana);
  --Trace('PF_Varcpta     -> '||PF_Varcpta);
  --Trace('PF_Flgimput    -> '||PF_Flgimput);
  --Trace('PF_Flgap       -> '||PF_Flgap);
  --Trace('PF_Codnatcr    -> '||PF_Codnatcr);

  RETURN(0);


EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --Trace('+++ Ligne execution non valide');
    RETURN(1);

  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Ligexec) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Ligexec;

/* ****************************** */
/* Fonction de Controle Operation */
/* ****************************** */
FUNCTION CTL_Operation(PF_Ideposte                FC_LIGNE.ide_poste%TYPE,
                       PF_Ideope                  FC_LIGNE.ide_ope%TYPE,
                       PF_Flgrecette    IN OUT    RB_OPE.flg_recette%TYPE,
                       PF_Flgdepense    IN OUT    RB_OPE.flg_depense%TYPE) RETURN NUMBER IS
BEGIN
  --Trace('- Controle valeur operation');

  PF_Flgrecette := NULL;
  PF_Flgdepense := NULL;

  SELECT flg_recette,flg_depense INTO PF_Flgrecette,PF_Flgdepense
  FROM RB_OPE
  WHERE ide_poste = PF_Ideposte
    AND ide_ope = PF_Ideope;

  --Trace('PF_Flgrecette -> '||PF_Flgrecette);
  --Trace('PF_Flgdepense -> '||PF_Flgdepense);

  RETURN(0);


EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --Trace('+++ Operation non valide');
    RETURN(1);

  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Operation) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Operation;

/* ******************************** */
/* Fonction de Controle Saisi Ligne */
/* ******************************** */
FUNCTION CTL_Saisilig(PF_Codtypnd                      FM_ERREUR.cod_typ_nd%TYPE,
                      PF_Idendemet                     FM_ERREUR.ide_nd_emet%TYPE,
                      PF_Idemess                       FM_ERREUR.ide_mess%TYPE,
                      PF_Flgemisrecu                   FM_ERREUR.flg_emis_recu%TYPE,
                      PF_Ideposte                      FC_ECRITURE.ide_poste%TYPE,
                      PF_Idegest                       FC_ECRITURE.ide_gest%TYPE,
                      PF_Idejal                        FC_ECRITURE.ide_jal%TYPE,
                      PF_Flgcptab                      FC_ECRITURE.flg_cptab%TYPE,
                      PF_Ideecr                        FC_ECRITURE.ide_ecr%TYPE,
                      PF_Typposte                      RM_POSTE.ide_typ_poste%TYPE,
                      PF_Flgbe                         FC_JOURNAL.flg_be%TYPE,
                      PF_Varcpta                       FC_LIGNE.var_cpta%TYPE,
                      PF_Idelig                        FC_LIGNE.ide_lig%TYPE,
                      PF_Idemodelelig                  FC_LIGNE.ide_modele_lig%TYPE,
                      PF_Idecpt                        FC_LIGNE.ide_cpt%TYPE,
                      PF_Mascpt                        RC_MODELE_LIGNE.mas_cpt%TYPE,
                      PF_spec1                         FC_LIGNE.spec1%TYPE,
                      PF_Masspec1                      RC_MODELE_LIGNE.mas_spec1%TYPE,
                      PF_spec2                         FC_LIGNE.spec2%TYPE,
                      PF_Masspec2                      RC_MODELE_LIGNE.mas_spec2%TYPE,
                      PF_spec3                         FC_LIGNE.spec3%TYPE,
                      PF_Masspec3                      RC_MODELE_LIGNE.mas_spec3%TYPE,
                      PF_ideordo                       FC_LIGNE.ide_ordo%TYPE,
                      PF_Masordo                       RC_MODELE_LIGNE.mas_ordo%TYPE,
                      PF_Vartiers                      FC_LIGNE.var_tiers%TYPE,
                      PF_idetiers                      FC_LIGNE.ide_tiers%TYPE,
                      PF_Mastiers                      RC_MODELE_LIGNE.mas_tiers%TYPE,
                      PF_Codrefpiece                   FC_LIGNE.cod_ref_piece%TYPE,
                      PF_Iderefpiece                   FC_LIGNE.ide_ref_piece%TYPE,
                      PF_Masrefpiece                   RC_MODELE_LIGNE.mas_ref_piece%TYPE,
                      PF_Codbud                        FC_LIGNE.cod_bud%TYPE,
                      PF_Codtypbud                     FC_LIGNE.cod_typ_bud%TYPE,
                      PF_Masbud                        RC_MODELE_LIGNE.mas_bud%TYPE,
                      PF_Varbud                        FC_LIGNE.var_bud%TYPE,
                      PF_Ideligexec                    FC_LIGNE.ide_lig_exec%TYPE,
                      PF_Masligbud                     RC_MODELE_LIGNE.mas_lig_bud%TYPE,
                      PF_Ideope                        FC_LIGNE.ide_ope%TYPE,
                      PF_Masope                        RC_MODELE_LIGNE.mas_ope%TYPE,
                      PF_Datjc                         FC_ECRITURE.dat_jc%TYPE,
                      PF_Oui                           FC_JOURNAL.flg_annul%TYPE,
                      PF_Non                           FC_JOURNAL.flg_annul%TYPE,
                      PF_Flgjustif           IN OUT    FN_COMPTE.flg_justif%TYPE,
                      PF_Flgjustiftiers      IN OUT    FN_COMPTE.flg_justif_tiers%TYPE,
                      PF_Flgjustifcpt        IN OUT    FN_COMPTE.flg_justif_cpt%TYPE,
                      PF_Flgsimp             IN OUT    FN_COMPTE.flg_simp%TYPE,
                      PF_Codsensope          IN OUT    RC_DROIT_COMPTE.cod_sens_ope%TYPE,
                      PF_Flgimputbe          IN OUT    RC_DROIT_COMPTE.flg_imput_be%TYPE,
                      PF_Codsensbe           IN OUT    RC_DROIT_COMPTE.cod_sens_be%TYPE,
                      PF_Flgimputcomp        IN OUT    RC_DROIT_COMPTE.flg_imput_comp%TYPE,
                      PF_Ideligprev          IN OUT    FN_LIGNE_BUD_EXEC.ide_lig_prev%TYPE,
                      PF_Idecptana           IN OUT    FN_LIGNE_BUD_EXEC.ide_cpt_ana%TYPE,
                      PF_Varcptaligexec      IN OUT    FN_LIGNE_BUD_EXEC.var_cpta%TYPE,
                      PF_Flgimputligexec     IN OUT    FN_LIGNE_BUD_EXEC.flg_imput%TYPE,
                      PF_Flgap               IN OUT    FN_LIGNE_BUD_PREV.flg_ap%TYPE,
                      PF_Codnatcr            IN OUT    FN_LIGNE_BUD_PREV.cod_nat_cr%TYPE,
                      PF_Flgrecette          IN OUT    RB_OPE.flg_recette%TYPE,
                      PF_Flgdepense          IN OUT    RB_OPE.flg_depense%TYPE,
                      PF_Vartiersrefpiece    IN OUT    FC_REF_PIECE.var_tiers%TYPE,
                      PF_Idetiersrefpiece    IN OUT    FC_REF_PIECE.ide_tiers%TYPE,
       -- MODIF SGN ANOVA71 : Ajout des nouveaux parametres
       PF_ideplanaux          IN        FN_CPT_AUX.ide_plan_aux%TYPE,
       PF_idecptaux           IN        FN_CPT_AUX.ide_cpt_aux%TYPE,
       PF_ideschema           IN        FC_LIGNE.ide_schema%TYPE,
       PF_refpieceA           IN        FC_REF_PIECE.cod_ref_piece%TYPE,
       PF_Masidecptaux                  RC_MODELE_LIGNE.ide_cpt_aux%TYPE,
       -- fin modif sgn
       PF_COD_SIGNE           IN        RC_MODELE_LIGNE.cod_signe%TYPE,
       PF_COD_SENS            IN        FC_LIGNE.cod_sens%TYPE) RETURN NUMBER IS

  v_retour     NUMBER;
  v_retour1    NUMBER;
BEGIN
  --Trace('-> Controle Saisi Ligne');

  -- Controle Compte
  ------------------
  --Trace('- Controle du compte');
  IF PF_Idecpt IS NULL THEN
    --Trace('+++ Compte non renseigne');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,630,TO_CHAR(PF_Idelig),'','') != 0 THEN
      RETURN(-1);
    END IF;
  ELSE
    v_retour := Ctl_Val_Masque(PF_Mascpt,PF_Idecpt,PF_Datjc);
    IF v_retour = 1 THEN
      --Trace('Compte valide par rapport au masque !!!');

      v_retour1 := CTL_Compte(PF_Typposte,PF_Varcpta,PF_Idecpt,PF_Datjc,
                              PF_Oui,PF_Non,PF_Flgbe,PF_Flgjustif,PF_Flgjustiftiers,
                              PF_Flgjustifcpt,PF_Flgsimp,PF_Codsensope,PF_Flgimputbe,
                              PF_Codsensbe,PF_Flgimputcomp);
      IF v_retour1 = 1 THEN
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,631,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;

      ELSIF v_retour1 = -1 THEN
        RETURN(-1);
      END IF;

    ELSIF v_retour = 0 THEN
      --Trace('+++ Compte non valide par rapport au masque');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,632,TO_CHAR(PF_Idelig),PF_Mascpt,'') != 0 THEN
          RETURN(-1);
      END IF;

    ELSE
      MAJ_Out_Param(189,'(CTL_U212_012E - CTL_Saisilig - CTL_Val_Masque)','','');
      RETURN(-1);
    END IF;
  END IF;

  -- Controle Spec1
  -----------------
  --Trace('- Controle spec1');
  v_retour := Ctl_Val_Masque(PF_Masspec1,PF_Spec1,PF_Datjc);
  IF v_retour = 1 THEN
    NULL;
    --Trace('Spec1 valide par rapport au masque !!!');
  ELSIF v_retour = 0 THEN
    --Trace('+++ Spec1 non valide par rapport au masque');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,633,'1',TO_CHAR(PF_Idelig),PF_Masspec1) != 0 THEN
      RETURN(-1);
    END IF;

  ELSIF v_retour = 2 THEN
    --Trace('+++ Spec1 non valide');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,634,'1',TO_CHAR(PF_Idelig),'') != 0 THEN
      RETURN(-1);
    END IF;

  ELSE
    MAJ_Out_Param(189,'(CTL_U212_012E - CTL_Saisilig - CTL_Val_Masque)','','');
    RETURN(-1);
  END IF;

  -- Controle Spec2
  -----------------
  --Trace('- Controle spec2');
  v_retour := Ctl_Val_Masque(PF_Masspec2,PF_Spec2,PF_Datjc);
  IF v_retour = 1 THEN
    NULL;
    --Trace('Spec2 valide par rapport au masque !!!');
  ELSIF v_retour = 0 THEN
    --Trace('+++ Spec2 non valide par rapport au masque');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,633,'2',TO_CHAR(PF_Idelig),PF_Masspec2) != 0 THEN
      RETURN(-1);
    END IF;

  ELSIF v_retour = 2 THEN
    --Trace('+++ Spec2 non valide');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,634,'2',TO_CHAR(PF_Idelig),'') != 0 THEN
      RETURN(-1);
    END IF;

  ELSE
    MAJ_Out_Param(189,'(CTL_U212_012E - CTL_Saisilig - CTL_Val_Masque)','','');
    RETURN(-1);
  END IF;

  -- Controle Spec3
  -----------------
  --Trace('- Controle spec3');
  v_retour := Ctl_Val_Masque(PF_Masspec3,PF_Spec3,PF_Datjc);
  IF v_retour = 1 THEN
    NULL;
    --Trace('Spec3 valide par rapport au masque !!!');
  ELSIF v_retour = 0 THEN
    --Trace('+++ Spec3 non valide par rapport au masque');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,633,'3',TO_CHAR(PF_Idelig),PF_Masspec3) != 0 THEN
      RETURN(-1);
    END IF;

  ELSIF v_retour = 2 THEN
    --Trace('+++ Spec3 non valide');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,634,'3',TO_CHAR(PF_Idelig),'') != 0 THEN
      RETURN(-1);
    END IF;

  ELSE
    MAJ_Out_Param(189,'(CTL_U212_012E - CTL_Saisilig - CTL_Val_Masque)','','');
    RETURN(-1);
  END IF;

  -- Contrôle sur les spécification locales et nationales
  /* Spec1 2 et 3 doivent correspondre à une combinaison de rc_spec  */
   v_retour := CTL_Spec_Nat( PF_Varcpta ,
                              PF_Idecpt,
                              PF_COD_SENS,
                              PF_COD_SIGNE ,
                              PF_spec1,
                              PF_spec2,
                              PF_spec3,
         PF_Datjc);
   IF v_retour =0 THEN
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,332,'','','') != 0 THEN
      RETURN(-1);
    END IF;
   ELSIF v_retour =-1 THEN
     RETURN(-1);
   END IF;
   /* ******************************************************************************************************** */
   /* En cas de presence de spec local Spec 2, 3 doivent correspondre a une combinaison de rc_spec_local */
    IF v_retour = 1 THEN
  v_retour := CTL_Spec_Loc(PF_Ideposte ,
                  PF_Varcpta ,
                              PF_Idecpt ,
                              PF_cod_sens ,
                              PF_cod_signe ,
                              PF_spec2 ,
                              PF_spec3 ,
               PF_Datjc ) ;
    IF v_retour =0 THEN
     IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                      PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                      PF_Ideecr,769,PF_Idecpt,'','') != 0 THEN
       RETURN(-1);
     END IF;
    ELSIF v_retour =-1 THEN
      RETURN(-1);
    END IF;
   END IF;

  --Controle Ordo
  ----------------
  --Trace('- Controle ordonnateur');
  v_retour := Ctl_Val_Masque(PF_Masordo,PF_Ideordo,PF_Datjc);
  IF v_retour = 1 THEN
    --Trace('Ordo valide par rapport au masque !!!');

    IF PF_Ideordo IS NOT NULL THEN
      v_retour1 := CTL_Ordo(PF_Ideordo);
      IF v_retour1 = 1 THEN
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,636,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;

      ELSIF v_retour1 = -1 THEN
          RETURN(-1);
      END IF;
    END IF;

  ELSIF v_retour = 0 THEN
    --Trace('+++ Ordo non valide par rapport au masque');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,635,TO_CHAR(PF_Idelig),PF_Masordo,'') != 0 THEN
        RETURN(-1);
    END IF;

  ELSE
    MAJ_Out_Param(189,'(CTL_U212_012E - CTL_Saisilig - CTL_Val_Masque)','','');
    RETURN(-1);
  END IF;

  -- Controle Tiers
  -----------------
  --Trace('- Controle tiers');
  v_retour := Ctl_Val_Masque(PF_Mastiers,PF_Idetiers,PF_Datjc);
  IF v_retour = 1 THEN
    --Trace('Tiers valide par rapport au masque !!!');

    IF PF_Idetiers IS NOT NULL THEN
      v_retour1 := CTL_Tiers(PF_Vartiers,PF_Idetiers);
      IF v_retour1 = 1 THEN
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,638,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;

      ELSIF v_retour1 = -1 THEN
          RETURN(-1);
      END IF;
    END IF;

  ELSIF v_retour = 0 THEN
    --Trace('+++ Tiers non valide par rapport au masque');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,637,TO_CHAR(PF_Idelig),PF_Mastiers,'') != 0 THEN
        RETURN(-1);
    END IF;

  ELSE
    MAJ_Out_Param(189,'(CTL_U212_012E - CTL_Saisilig - CTL_Val_Masque)','','');
    RETURN(-1);
  END IF;

  -- Controle Reference piece
  ---------------------------
  --Trace('- Controle reference piece');
  v_retour := Ctl_Val_Masque(PF_Masrefpiece,PF_Codrefpiece,PF_Datjc);
  IF v_retour = 1 THEN
    --Trace('Reference piece valide par rapport au masque !!!');

    IF PF_Codrefpiece IS NOT NULL THEN
      v_retour1 := CTL_Refpiece(PF_Ideposte,PF_Codrefpiece,PF_Iderefpiece,PF_Oui,PF_Non,
                                PF_Flgjustif,PF_Flgjustiftiers,PF_Vartiers,PF_idetiers,
                                PF_Flgjustifcpt,PF_Varcpta,PF_Idecpt,PF_Vartiersrefpiece,
                                PF_Idetiersrefpiece,
        -- MODIF SGN ANOVA71 : ajout des nouveau parametre a CTL_REFPIECE
        PF_ideplanaux,PF_idecptaux,PF_idejal,PF_ideschema,
          PF_idemodelelig,PF_refpieceA
        -- fin modif SGN
        );
      IF v_retour1 = 1 THEN
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,640,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;

      ELSIF v_retour1 = -1 THEN
          RETURN(-1);
      END IF;
    END IF;

  ELSIF v_retour = 0 THEN
    --Trace('+++ Reference piece non valide par rapport au masque');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,639,TO_CHAR(PF_Idelig),PF_Masrefpiece,'') != 0 THEN
        RETURN(-1);
    END IF;

  ELSE
    MAJ_Out_Param(189,'(CTL_U212_012E - CTL_Saisilig - CTL_Val_Masque)','','');
    RETURN(-1);
  END IF;

  -- Controle Budget
  ------------------
  --Trace('- Controle budget');
  v_retour := Ctl_Val_Masque(PF_Masbud,PF_Codbud,PF_Datjc);
  IF v_retour = 1 THEN
    --Trace('Budget valide par rapport au masque !!!');

    IF PF_Codbud IS NOT NULL THEN
      v_retour1 := CTL_Budget(PF_Codbud,PF_Ideordo,PF_Idegest,PF_Codtypbud,
                              PF_Datjc);
      IF v_retour1 = 1 THEN
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,642,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;

      ELSIF v_retour1 = -1 THEN
          RETURN(-1);
      END IF;
    END IF;

  ELSIF v_retour = 0 THEN
    --Trace('+++ Budget non valide par rapport au masque');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,641,TO_CHAR(PF_Idelig),PF_Masbud,'') != 0 THEN
        RETURN(-1);
    END IF;

  ELSE
    MAJ_Out_Param(189,'(CTL_U212_012E - CTL_Saisilig - CTL_Val_Masque)','','');
    RETURN(-1);
  END IF;

  -- Controle ligne execution
  ---------------------------
  --Trace('- Controle ligne execution');
  v_retour := Ctl_Val_Masque(PF_Masligbud,PF_Ideligexec,PF_Datjc);
  IF v_retour = 1 THEN
    --Trace('Ligne execution valide par rapport au masque !!!');

     IF PF_Ideligexec IS NOT NULL THEN
      v_retour1 := CTL_Ligexec(PF_Varbud,PF_Ideligexec,PF_Ideligprev,PF_Idecptana,
                               PF_Varcptaligexec,PF_Flgimputligexec,PF_Flgap,PF_Codnatcr);
      IF v_retour1 = 1 THEN
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,644,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;

      ELSIF v_retour1 = -1 THEN
          RETURN(-1);
      END IF;
    END IF;

  ELSIF v_retour = 0 THEN
    --Trace('+++ Ligne execution non valide par rapport au masque');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,643,TO_CHAR(PF_Idelig),PF_Masligbud,'') != 0 THEN
        RETURN(-1);
    END IF;

  ELSE
    MAJ_Out_Param(189,'(CTL_U212_012E - CTL_Saisilig - CTL_Val_Masque)','','');
    RETURN(-1);
  END IF;

  -- Controle operation
  ---------------------
  --Trace('- Controle operation');
  v_retour := Ctl_Val_Masque(PF_Masope,PF_Ideope,PF_Datjc);
  IF v_retour = 1 THEN
    --Trace('Operation valide par rapport au masque !!!');

    IF PF_Ideope IS NOT NULL THEN
      v_retour1 := CTL_Operation(PF_Ideposte,PF_Ideope,PF_Flgrecette,PF_Flgdepense);
      IF v_retour1 = 1 THEN
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,646,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;

      ELSIF v_retour1 = -1 THEN
          RETURN(-1);
      END IF;
    END IF;

  ELSIF v_retour = 0 THEN
    --Trace('+++ Operation non valide par rapport au masque');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,645,TO_CHAR(PF_Idelig),PF_Masope,'') != 0 THEN
        RETURN(-1);
    END IF;

  ELSE
    MAJ_Out_Param(189,'(CTL_U212_012E - CTL_Saisilig - CTL_Val_Masque)','','');
    RETURN(-1);
  END IF;

  /* LGD - 12/11/2002 - ANO VA V3 */
  -- Controle sur le compte auxiliaire
  -------------------------------------
  v_retour := Ctl_Val_Masque(PF_Masidecptaux,PF_idecptaux ,PF_Datjc);
  IF v_retour != 1 THEN
    --Trace('+++ Compte auxiliaire non valide par rapport au masque');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,877,TO_CHAR(PF_Idelig),PF_Mastiers,'') != 0 THEN
        RETURN(-1);
    END IF;
  END IF;

  RETURN(0);
  /* Fin de modification */


EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Saisilig) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Saisilig;

/* ********************************** */
/* Fonction Controle sur Liste compte */
/* ********************************** */
FUNCTION CTL_Rc_Liste_Compte(PF_Varcpta       FC_LIGNE.var_cpta%TYPE,
                             PF_Idecpt        FC_LIGNE.ide_cpt%TYPE,
                             PF_Codlistcpt    RC_LISTE_COMPTE.cod_list_cpt%TYPE) RETURN NUMBER IS

  v_recup    VARCHAR2(1);
BEGIN
  --Trace('- Controle Compte + Liste compte');

  SELECT 'X' INTO v_recup
  FROM RC_LISTE_COMPTE
  WHERE var_cpta = PF_Varcpta
    AND ide_cpt = PF_Idecpt
    AND cod_list_cpt = PF_Codlistcpt;

  RETURN(0);


EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --Trace('+++ Compte + Liste compte : non valide');
    RETURN(1);

  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Rc_Liste_Compte) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Rc_Liste_Compte;

/* ************************ */
/* Fonction de Controle DSO */
/* ************************ */
FUNCTION CTL_Dso(PF_Codtypnd                    FM_ERREUR.cod_typ_nd%TYPE,
                 PF_Idendemet                   FM_ERREUR.ide_nd_emet%TYPE,
                 PF_Idemess                     FM_ERREUR.ide_mess%TYPE,
                 PF_Flgemisrecu                 FM_ERREUR.flg_emis_recu%TYPE,
                 PF_Ideposte                    FC_ECRITURE.ide_poste%TYPE,
                 PF_Idegest                     FC_ECRITURE.ide_gest%TYPE,
                 PF_Idejal                      FC_ECRITURE.ide_jal%TYPE,
                 PF_Flgcptab                    FC_ECRITURE.flg_cptab%TYPE,
                 PF_Ideecr                      FC_ECRITURE.ide_ecr%TYPE,
                 PF_Idelig                      FC_LIGNE.ide_lig%TYPE,
                 PF_CodypbudD                   FC_LIGNE.cod_typ_bud%TYPE,
                 PF_CodnatcrE                   FN_LIGNE_BUD_PREV.cod_nat_cr%TYPE,
                 PF_SensDB                      FC_LIGNE.cod_sens%TYPE,
                 PF_SensCR                      FC_LIGNE.cod_sens%TYPE,
                 PF_Oui                         VARCHAR2,  -- SNE, 13/09/2001
                 PF_Non                         FN_LIGNE_BUD_PREV.flg_ap%TYPE,
                 PF_Cptcanbu                    RC_LISTE_COMPTE.cod_list_cpt%TYPE,
--                 PF_Flgdsoassign                TYPE,  -- SNE, 13/09/2001 : Suppression du flag DSO assignee/ecritures
                 PF_Codsens                     FC_LIGNE.cod_sens%TYPE,
                 PF_Mt                          FC_LIGNE.mt%TYPE,
                 PF_Ideordo                     FC_LIGNE.ide_ordo%TYPE,
                 PF_Varbud                      FC_LIGNE.var_bud%TYPE,
                 PF_Codbud                      FC_LIGNE.cod_bud%TYPE,
                 PF_Codtypbud                   FC_LIGNE.cod_typ_bud%TYPE,
                 PF_Varcpta                     FC_LIGNE.var_cpta%TYPE,
                 PF_Idecpt                      FC_LIGNE.ide_cpt%TYPE,
                 PF_Ideligexec                  FC_LIGNE.ide_lig_exec%TYPE,
                 PF_Ideligprev                  FN_LIGNE_BUD_EXEC.ide_lig_prev%TYPE,
                 PF_Varcptaligexec              FN_LIGNE_BUD_EXEC.var_cpta%TYPE,
                 PF_Idecptana                   FN_LIGNE_BUD_EXEC.ide_cpt_ana%TYPE,
                 PF_Flgap                       FN_LIGNE_BUD_PREV.flg_ap%TYPE,
                 PF_Codnatcr                    FN_LIGNE_BUD_PREV.cod_nat_cr%TYPE,
                 PF_Nbligne                     NUMBER,
                 PF_Codsensprec       IN OUT    FC_LIGNE.cod_sens%TYPE) RETURN NUMBER IS

  v_retour    NUMBER;
BEGIN
  --Trace('-> Controle DSO');

  -- Controle 2 lignes max
  ------------------------
  --Trace('- Controle Nb ligne');
  IF PF_Nbligne = 3 THEN
    --Trace('+++ Erreur Nb ligne');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,351,'','','') != 0 THEN
      RETURN(-1);
    END IF;
  END IF;



  -- DEBUT / PGE - 29/02/2008 , ANO 210 : cohérence visa des écriture U212_012F / report associé U212_012E
  /*
  -- 2 Lignes de sens oppose
  --------------------------
  --Trace('- Controle Sens');
  IF PF_Codsensprec IS NOT NULL AND PF_Codsensprec = PF_Codsens THEN
    --Trace('+++ Erreur Sens');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,346,'','','') != 0 THEN
      RETURN(-1);
    END IF;
  END IF;
  */
  -- FIN / PGE - 29/02/2008 , ANO 210
  PF_Codsensprec := PF_Codsens;

  -- Montant > 0
  --------------
  --Trace('- Controle Mt');
  -- DEBUT / PGE - 29/02/2008 , ANO 210 : cohérence visa des écriture U212_012F / report associé U212_012E
  /*
  IF PF_Mt <= 0 THEN
    --Trace('+++ Erreur Mt');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,648,TO_CHAR(PF_Idelig),'','') != 0 THEN
      RETURN(-1);
    END IF;
  END IF;
  */
  -- FIN / PGE - 29/02/2008 , ANO 210
  -- Controle ligne Debit
  -----------------------
  IF PF_Codsensprec = PF_SensDB THEN
    --Trace('- Controle Ordo');


    -- DEBUT / PGE - 29/02/2008 , ANO 210 : cohérence visa des écriture U212_012F / report associé U212_012E
    /*
    -- Ordo renseigne
    -----------------
    IF PF_Ideordo IS NULL THEN
      --Trace('+++ Erreur Ordo');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,649,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;


    -- Budget renseigne
    -------------------
    --Trace('- Controle Budget');
    IF PF_Codbud IS NULL THEN
      --Trace('+++ Erreur Budget');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,650,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;

    -- Ligne execution renseigne
    ----------------------------
    --Trace('- Controle Ligne execution 1');
    IF PF_Ideligexec IS NULL THEN
      --Trace('+++ Erreur Ligne execution 1');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,651,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;
    */
    -- FIN / PGE - 29/02/2008 , ANO 210


    -- Controle Ligne prevision
    ---------------------------
    --Trace('- Controle Ligne prevision');
    IF PF_Flgap != PF_Non THEN
      --Trace('+++ Erreur Ligne prevision 1');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,652,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;


	--Début PGE - 13/10/2008 , ANO 292
    /*
	IF PF_Codnatcr != PF_CodnatcrE OR PF_Codnatcr IS NULL THEN
      --Trace('+++ Erreur Ligne prevision 2');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,653,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;
	*/
	--Fin PGE - 13/10/2008 , ANO 292

 /*
 -- -------------------------
 -- SNE, 13/09/2001 : Controle assignation non effectue ici
    -- Controle assignataire
    ------------------------
    --Trace('- Controle Assignataire');
    IF PF_Flgdsoassign = PF_Oui THEN
      IF CTL_Assign(PF_Codbud,PF_Codtypbud,PF_Idegest,PF_Ideordo,PF_Varbud,
                    PF_Ideposte,PF_Ideligprev) != 1 THEN
        --Trace('+++ Erreur Assignataire');
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,654,TO_CHAR(PF_Idelig),'','') != 0 THEN
          Return(-1);
        END IF;
      END IF;
    END IF;
    */

    -- DEBUT / PGE - 29/02/2008 , ANO 210 : cohérence visa des écriture U212_012F / report associé U212_012E
    /*
    -- Controle Ligne execution
    ---------------------------
    --Trace('- Controle Ligne execution 2');
    IF PF_Varcpta != PF_Varcptaligexec OR PF_Idecpt != PF_Idecptana THEN
      --Trace('+++ Erreur Ligne execution 2');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,655,TO_CHAR(PF_Idelig),
                       PF_Varcptaligexec||'-'||PF_Idecptana,'') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;
    */
    -- FIN / PGE - 29/02/2008 , ANO 210

    -- Type budget renseigne
    ------------------------
    --Trace('- Controle Type Budget');
    IF PF_Codtypbud != PF_CodypbudD THEN
      --Trace('+++ Erreur Type budget');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,656,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;


  --Début PGE - 13/10/2008 , ANO 292
  /*
  ELSIF PF_Codsensprec = PF_SensCR THEN
    -- Controle compte non canbu
    ----------------------------

    --Trace('- Controle Compte canbu');
    v_retour := CTL_Rc_Liste_Compte(PF_Varcpta,PF_Idecpt,PF_Cptcanbu);

    IF v_retour = 0 THEN
      --Trace('+++ Erreur Compte canbu');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,657,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    ELSIF v_retour = -1 THEN
      RETURN(-1);
    END IF;
	*/
	--Fin PGE - 13/10/2008 , ANO 292
  END IF;


  RETURN(0);


EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Dso) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Dso;

/* ******************************* */
/* Fonction Controle specification */
/* ******************************* */
FUNCTION CTL_Spec(PF_Varcpta     FC_LIGNE.var_cpta%TYPE,
                  PF_Idecpt      FC_LIGNE.ide_cpt%TYPE,
                  PF_Codsens     FC_LIGNE.cod_sens%TYPE,
                  PF_Codsigne    RC_MODELE_LIGNE.cod_signe%TYPE,
                  PF_Spec1       FC_LIGNE.spec1%TYPE,
                  PF_Spec2       FC_LIGNE.spec2%TYPE,
                  PF_Spec3       FC_LIGNE.spec3%TYPE,
                  PF_Datjc       FC_ECRITURE.dat_jc%TYPE)RETURN NUMBER IS

  CURSOR c_spec IS
    SELECT mas_spec1,mas_spec2,mas_spec3
    FROM RC_SPEC
    WHERE var_cpta = PF_Varcpta
      AND ide_cpt = PF_Idecpt
      AND cod_sens = PF_Codsens
      AND cod_signe = PF_Codsigne
      AND CTL_DATE(dat_dval,P_DAT_JC)='O'--PGE V4260 EVOL_DI44_2008_014 16/05/2008 / PGE 14/10/2008 Ano 295
      AND CTL_DATE(P_DAT_JC,dat_fval)='O';--PGE V4260 EVOL_DI44_2008_014 16/05/2008 / PGE 14/10/2008 Ano 295

  v_retour     NUMBER;
BEGIN

  v_retour := 1;
  FOR v_spec IN c_spec
  LOOP
    v_retour := 0;
    IF Ctl_Val_Masque(v_spec.mas_spec1,PF_Spec1,PF_Datjc)= 1 THEN
      IF Ctl_Val_Masque(v_spec.mas_spec2,PF_Spec2,PF_Datjc)= 1 THEN
        IF Ctl_Val_Masque(v_spec.mas_spec3,PF_Spec3,PF_Datjc)= 1 THEN
          v_retour := 1;
          EXIT;
        END IF;
      END IF;
    END IF;
  END LOOP;

  RETURN(v_retour);


EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Spec) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Spec;


/* LGD - ANOGAR606 - le 14/05/2004 */

/* *********************************** */
/* Fonction Controle du plan auxiliaire */
/* *********************************** */
FUNCTION CTL_CPT_PLAN(p_var_cpta FN_CPT_PLAN.var_cpta%TYPE, p_ide_cpt FN_CPT_PLAN.ide_cpt%TYPE) RETURN NUMBER IS
  v_ret NUMBER;
BEGIN
  SELECT 1
  INTO v_ret
  FROM FN_CPT_PLAN
  WHERE var_cpta = p_var_cpta
    AND ide_cpt = p_ide_cpt
    AND Ctl_Date(SYSDATE, DAT_FVAL) = 'O';

  RETURN v_ret;

EXCEPTION
 WHEN NO_DATA_FOUND THEN
   v_ret := 0;
   RETURN v_ret;
 WHEN OTHERS THEN
   MAJ_Out_Param(105,'(CTL_U212_012E - CTL_CPT_PLAN) '||SQLERRM,'','');
   RETURN(-1);
END;


/* ************************************** */
/* Fonction Controle du compte auxiliaire */
/* ************************************** */
FUNCTION CTL_CPT_AUX(p_ide_plan_aux FC_LIGNE.ide_plan_aux%TYPE, p_ide_cpt_aux FC_LIGNE.ide_cpt_aux%TYPE) RETURN NUMBER IS
  v_ret NUMBER;
BEGIN
 SELECT 1
 INTO v_ret
 FROM FN_CPT_AUX
 WHERE ide_plan_aux = p_ide_plan_aux
   AND ide_cpt_aux = p_ide_cpt_aux
   AND Ctl_Date(SYSDATE, DAT_FVAL) = 'O';

  RETURN v_ret;

EXCEPTION
 WHEN NO_DATA_FOUND THEN
   v_ret := 0;
   RETURN v_ret;
 WHEN OTHERS THEN
   MAJ_Out_Param(105,'(CTL_U212_012E - CTL_CPT_AUX) '||SQLERRM,'','');
   RETURN(-1);
END;

/* ********************************************************************* */
/* Fonction Extraction Ligne ecriture portant une reference piece donnee */
/* ********************************************************************* */
FUNCTION EXT_Ligne_Ref_Piece(PF_Ideposte                 FC_LIGNE.ide_poste%TYPE,
                             PF_Idegest                  FC_LIGNE.ide_gest%TYPE,
                             PF_Idejal                   FC_LIGNE.ide_jal%TYPE,
                             PF_Flgcptab                 FC_LIGNE.flg_cptab%TYPE,
                             PF_Ideecr                   FC_LIGNE.ide_ecr%TYPE,
                             PF_Idelig                   FC_LIGNE.ide_lig%TYPE,
                             PF_Iderefpiece              FC_LIGNE.ide_ref_piece%TYPE,
                             PF_Varcpta        IN OUT    FC_LIGNE.var_cpta%TYPE,
                             PF_Idecpt         IN OUT    FC_LIGNE.ide_cpt%TYPE) RETURN NUMBER IS

  CURSOR cur_ligne_refpiece IS
    SELECT var_cpta,ide_cpt
    FROM FC_LIGNE
    WHERE ide_poste = PF_Ideposte
      AND ide_ref_piece = PF_Iderefpiece
      AND (ide_gest != PF_Idegest OR ide_jal != PF_Idejal OR
           flg_cptab != PF_Flgcptab OR ide_ecr != PF_Ideecr OR
           ide_lig != PF_Idelig);
BEGIN
  --Trace('Recuperation information ligne ecriture avec reference piece');

  PF_Varcpta := NULL;
  PF_Idecpt  := NULL;

  FOR v_lignerefpiece IN cur_ligne_refpiece
  LOOP
    PF_Varcpta := v_lignerefpiece.var_cpta;
    PF_Idecpt  := v_lignerefpiece.ide_cpt;
    EXIT;
  END LOOP;

  --Trace('PF_Varcpta -> '||PF_Varcpta);
  --Trace('PF_Idecpt  -> '||PF_Idecpt);

  RETURN(0);


EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - EXT_Ligne_Ref_Piece) '||SQLERRM,'','');
    RETURN(-1);

END EXT_Ligne_Ref_Piece;

/* ********************************************* */
/* Fonction Extraction info variation budgetaire */
/* ********************************************* */
FUNCTION EXT_Pn_Var_Bud(PF_Varbud                 PN_VAR_BUD.var_bud%TYPE,
                        PF_Codtypbud    IN OUT    PN_VAR_BUD.cod_typ_bud%TYPE) RETURN NUMBER IS
BEGIN
  --Trace('- Recuperation information variation budgetaire');

  PF_Codtypbud := NULL;

  SELECT cod_typ_bud INTO PF_Codtypbud
  FROM PN_VAR_BUD
  WHERE var_bud = PF_Varbud;

  --Trace('PF_Codtypbud -> '||PF_Codtypbud);

  RETURN(0);


EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - EXT_Pn_Var_Bud) '||SQLERRM,'','');
    RETURN(-1);

END EXT_Pn_Var_Bud;

/* ******************************** */
/* Fonction de Controle de la Ligne */
/* ******************************** */
FUNCTION CTL_Ligne(PF_Codtypnd             FM_ERREUR.cod_typ_nd%TYPE,
                   PF_Idendemet            FM_ERREUR.ide_nd_emet%TYPE,
                   PF_Idemess              FM_ERREUR.ide_mess%TYPE,
                   PF_Flgemisrecu          FM_ERREUR.flg_emis_recu%TYPE,
                   PF_Ideposte             FC_ECRITURE.ide_poste%TYPE,
                   PF_Idegest              FC_ECRITURE.ide_gest%TYPE,
                   PF_Idejal               FC_ECRITURE.ide_jal%TYPE,
                   PF_Flgcptab             FC_ECRITURE.flg_cptab%TYPE,
                   PF_Ideecr               FC_ECRITURE.ide_ecr%TYPE,
                   PF_Idelig               FC_LIGNE.ide_lig%TYPE,
                   PF_Mt                   FC_LIGNE.mt%TYPE,
                   PF_Varcpta              FC_LIGNE.var_cpta%TYPE,
                   PF_Idecpt               FC_LIGNE.ide_cpt%TYPE,
                   PF_Codsens              FC_LIGNE.cod_sens%TYPE,
                   PF_Codsignemodlig       RC_MODELE_LIGNE.cod_signe%TYPE,
                   PF_Spec1                FC_LIGNE.spec1%TYPE,
                   PF_Spec2                FC_LIGNE.spec2%TYPE,
                   PF_Spec3                FC_LIGNE.spec3%TYPE,
                   PF_Datjc                FC_ECRITURE.dat_jc%TYPE,
                   PF_Ideope               FC_LIGNE.ide_ope%TYPE,
                   PF_Flgrecetteope        RB_OPE.flg_recette%TYPE,
                   PF_Flgdepenseope        RB_OPE.flg_depense%TYPE,
                   PF_Codtypbud            FC_LIGNE.cod_typ_bud%TYPE,
                   PF_CodtypbudD           FC_LIGNE.cod_typ_bud%TYPE,
                   PF_CodtypbudR           FC_LIGNE.cod_typ_bud%TYPE,
                   PF_Oui                  RB_OPE.flg_recette%TYPE,
                   PF_Non                  RB_OPE.flg_recette%TYPE,
                   PF_Codsensopecpt        RC_DROIT_COMPTE.cod_sens_ope%TYPE,
                   PF_CodsensopeX          RC_DROIT_COMPTE.cod_sens_ope%TYPE,
                   PF_Flgbejal             FC_JOURNAL.flg_be%TYPE,
                   PF_Flgimputbecpt        RC_DROIT_COMPTE.flg_imput_be%TYPE,
                   PF_Codsensbecpt         RC_DROIT_COMPTE.cod_sens_be%TYPE,
                   PF_CodsensbeX           RC_DROIT_COMPTE.cod_sens_be%TYPE,
                   PF_Periodecomp          VARCHAR2,
                   PF_Flgimputcompcpt      RC_DROIT_COMPTE.flg_imput_comp%TYPE,
                   PF_Ideligexec           FC_LIGNE.ide_lig_exec%TYPE,
                   PF_Flgimputligexec      FN_LIGNE_BUD_EXEC.flg_imput%TYPE,
                   PF_Flgjustifcpt         FN_COMPTE.flg_justif%TYPE,
                   PF_Codrefpiecemodlig    RC_MODELE_LIGNE.cod_ref_piece%TYPE,
                   PF_CodrefpieceC         RC_MODELE_LIGNE.cod_ref_piece%TYPE,
                   PF_CodrefpieceS         RC_MODELE_LIGNE.cod_ref_piece%TYPE,
                   PF_Flgjustiftierscpt    FN_COMPTE.flg_justif_tiers%TYPE,
                   PF_Vartiers             FC_LIGNE.var_tiers%TYPE,
                   PF_Idetiers             FC_LIGNE.ide_tiers%TYPE,
                   PF_Iderefpiece          FC_LIGNE.ide_ref_piece%TYPE,
                   PF_Codrefpiece          FC_LIGNE.cod_ref_piece%TYPE,
                   PF_CodrefpieceA         RC_MODELE_LIGNE.cod_ref_piece%TYPE,
                   PF_Vartiersrefpiece     FC_REF_PIECE.var_tiers%TYPE,
                   PF_Idetiersrefpiece     FC_REF_PIECE.ide_tiers%TYPE,
                   PF_Flgjustifcptcpt      FN_COMPTE.flg_justif_tiers%TYPE,
                   PF_Typeschemaecr        RC_SCHEMA_CPTA.cod_typ_schema%TYPE,
                   PF_TypeschemaT          RC_SCHEMA_CPTA.cod_typ_schema%TYPE,
                   PF_TypeschemaR          RC_SCHEMA_CPTA.cod_typ_schema%TYPE,
                   PF_Codcptorhbu          RC_LISTE_COMPTE.cod_list_cpt%TYPE,
                   PF_Ideordo              FC_LIGNE.ide_ordo%TYPE,
                   PF_Codbud               FC_LIGNE.cod_bud%TYPE,
                   PF_CodsensCR            FC_LIGNE.cod_sens%TYPE,
                   PF_Codcptcanbu          RC_LISTE_COMPTE.cod_list_cpt%TYPE,
                   PF_Varbud               FC_LIGNE.var_bud%TYPE,
       /* LGD - ANOGAR606 - 14/05/2004 */
       PF_Ide_plan_aux         FC_LIGNE.ide_plan_aux%TYPE,
       PF_Ide_cpt_aux          FC_LIGNE.ide_cpt_aux%TYPE
       /* Fin de modification */) RETURN NUMBER IS

  v_retour                NUMBER;
  v_varcptaligrefpiece    FC_LIGNE.var_cpta%TYPE;
  v_idecptligrefpiece     FC_LIGNE.ide_cpt%TYPE;
  v_codtypbudvarbud       PN_VAR_BUD.cod_typ_bud%TYPE;
  /* LGD correction ano n°°3 Aster V2.2 le 17/09/2002 */
  v_mt_initial_piece_db NUMBER:=0;
  v_mt_initial_piece_cr NUMBER:=0;
  v_mt_abond_piece_db   NUMBER:=0;
  v_mt_abond_piece_cr   NUMBER:=0;
  /* Fin de modification */


BEGIN
  --Trace('-> Controle Ligne');

  -- Le montant ne doit pas être egal à zéro
  ------------------------------------------
  --Trace('- Controle Montant');
  IF PF_Mt = 0 THEN
    --Trace('+++ Erreur Montant');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,658,TO_CHAR(PF_Idelig),'','') != 0 THEN
      RETURN(-1);
    END IF;
  END IF;

  -- Spec1,2 et 3 doivent correspondre à une combinaison de RC_SPEC
  -----------------------------------------------------------------
  --Trace('- Controle Spec1,2 et 3');
  IF CTL_Spec(PF_Varcpta,PF_Idecpt,PF_Codsens,PF_Codsignemodlig,PF_Spec1,PF_Spec2,
              PF_Spec3,PF_Datjc) != 1 THEN
    --Trace('+++ Erreur Spec1,2 et 3');
    IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                     PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                     PF_Ideecr,659,TO_CHAR(PF_Idelig),'','') != 0 THEN
      RETURN(-1);
    END IF;
  END IF;

  -- Controle operation
  ---------------------
  IF PF_Ideope IS NOT NULL THEN
    --Trace('- Controle Operation');
    IF PF_Flgdepenseope = PF_Oui AND
       PF_Flgrecetteope = PF_Non AND
       PF_Codtypbud != PF_CodtypbudD THEN
      --Trace('+++ Erreur Operation 1');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,660,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;
    IF PF_Flgdepenseope = PF_Non AND
       PF_Flgrecetteope = PF_Oui AND
       PF_Codtypbud != PF_CodtypbudR THEN
      --Trace('+++ Erreur Operation 2');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,661,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;
  END IF;

  -- Le sens d'imputation du compte doit être conforme
  ----------------------------------------------------
  IF PF_Codsensopecpt != PF_CodsensopeX THEN
    --Trace('- Controle Sens');
    IF PF_Codsens != PF_Codsensopecpt THEN
      --Trace('+++ Erreur Sens');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,662,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;
  END IF;

  -- Si journal reprise solde alors compte imputable balance entree et dans sens autorise
  ---------------------------------------------------------------------------------------
  IF PF_Flgbejal = PF_Oui THEN
    --Trace('- Controle Compte');
    IF PF_Flgimputbecpt != PF_Oui THEN
      --Trace('+++ Erreur Compte');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,663,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;
    IF PF_Codsensbecpt != PF_CodsensbeX THEN
      --Trace('- Controle Sens 2');
      IF PF_Codsens != PF_Codsensbecpt THEN
        --Trace('+++ Erreur Sens 2');
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,664,TO_CHAR(PF_Idelig),PF_Codsensbecpt,'') != 0 THEN
          RETURN(-1);
        END IF;
      END IF;
    END IF;
  END IF;

  -- Si periode complementaire : compte imputable en periode complementaire
  -------------------------------------------------------------------------
  IF PF_Periodecomp = 'O' THEN
    --Trace('- Controle Periode comp.');
    IF PF_Flgimputcompcpt != PF_Oui THEN
      --Trace('+++ Erreur Compte 2');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,665,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;
  END IF;

  -- Si ligne budgétaire renseigne alors elle est imputable
  ---------------------------------------------------------
  IF PF_Ideligexec IS NOT NULL THEN
    --Trace('- Controle Ligne execution');
    IF PF_Flgimputligexec != PF_Oui THEN
      --Trace('+++ Erreur Ligne execution');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,666,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;
  END IF;


  /* LGD - ANOGAR606 - le 14/05/2004 */
  -- Contrôle sur le plan auxiliaire
  ------------------------------------
  IF CTL_CPT_PLAN(PF_varcpta, PF_Idecpt) = 1 THEN
    IF PF_Ide_cpt_aux IS NULL THEN
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,921,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;
  END IF;

  -- Contrôle sur le compte auxiliaire
  ------------------------------------
  IF PF_Ide_cpt_aux IS NOT NULL THEN
 IF CTL_CPT_AUX(PF_ide_plan_aux, PF_ide_cpt_aux) !=1 THEN
   IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,922,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
 END IF;
  END IF;

/* Fin de modification */

  -- Controle reference piece
  ---------------------------
  --Trace('- Controle Reference piece 1');
  -- Si le compte est suivi par piece et le modele ligne prevoit creation piece
  -- ou modele ligne ne prevoit rien Alors
  IF (PF_Flgjustifcpt = PF_Oui AND PF_Codrefpiecemodlig = PF_CodrefpieceC) OR
     PF_Codrefpiecemodlig = PF_CodrefpieceS THEN
    -- 1) si le compte est suivi par tiers alors infos tiers obligatoire sur la ligne
    IF PF_Flgjustiftierscpt = PF_Oui THEN
      IF PF_Vartiers IS NULL OR PF_Idetiers IS NULL THEN
        --Trace('+++ Erreur Reference piece 1 1');
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,667,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;
      END IF;
    END IF;
    -- 2) les references pieces de la ligne ne doivent pas etre renseignees
    IF PF_Iderefpiece IS NOT NULL OR PF_Codrefpiece IS NOT NULL THEN
      /* LGD - 08/11/2002 - ANO VA V3 51 : La saisie d'une référence pièce n'est pas obligatoire
                                        en saisie quand le modèle de ligne associé est en création
             de pièce avec un compte justifié par pièce */
   IF PF_Codrefpiecemodlig = PF_CodrefpieceS THEN
    --Trace('+++ Erreur Reference piece 1 2');
       IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                        PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                        PF_Ideecr,668,TO_CHAR(PF_Idelig),'','') != 0 THEN
         RETURN(-1);
       END IF;
      END IF;
   /* Fin modification */
 END IF;
  END IF;
  -- -- -- -- -- -- -- -- -- -- -- -- --
  --Trace('- Controle Reference piece 2');
  -- Si le compte est suivi par piece et le modele ligne prevoit abondement piece Alors
  IF PF_Flgjustifcpt = PF_Oui AND PF_Codrefpiecemodlig = PF_CodrefpieceA THEN
    -- 1) ide_ref_piece et cod_ref_piece obligatoires sur la ligne
    IF PF_Iderefpiece IS NULL OR PF_Codrefpiece IS NULL THEN
      --Trace('+++ Erreur Reference piece 2 1');
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                       PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                       PF_Ideecr,669,TO_CHAR(PF_Idelig),'','') != 0 THEN
        RETURN(-1);
      END IF;
    END IF;
    -- 2) si le compte est suivi par tiers alors tiers de la ligne = tiers reference piece
    IF PF_Flgjustiftierscpt = PF_Oui THEN
      IF PF_Vartiers != PF_Vartiersrefpiece OR
         PF_Idetiers != PF_Idetiersrefpiece THEN
        --Trace('+++ Erreur Reference piece 2 2');
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,670,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;
      END IF;
    END IF;
    -- 3) si compte suivi par piece mono-compte alors compte ligne = compte reference piece
    IF PF_Flgjustifcptcpt = PF_Oui THEN
      IF EXT_Ligne_Ref_Piece(PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,PF_Ideecr,
                             PF_Idelig,PF_Iderefpiece,v_varcptaligrefpiece,
                             v_idecptligrefpiece) != 0 THEN
        RETURN(-1);
      END IF;

      -- Début PGE 17/09/2009 ANO 392 V4290 : Suppression du contrôle absent de la procédure de visa
/*
      IF v_varcptaligrefpiece IS NOT NULL AND
         v_idecptligrefpiece IS NOT NULL THEN
        IF PF_Varcpta != v_varcptaligrefpiece OR
           PF_Idecpt  != v_idecptligrefpiece THEN
          --Trace('+++ Erreur Reference piece 2 3');
          IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                           PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                           PF_Ideecr,671,TO_CHAR(PF_Idelig),'','') != 0 THEN
            RETURN(-1);
          END IF;
        END IF;
      END IF;
*/
      -- Fin PGE 17/09/2009 ANO 392 V4290 : Suppression du contrôle absent de la procédure de visa


    END IF;

 /* LGD - 17/09/2002 - Aster V3.0 révision correction (Aster V2.2) */
 --4) Il n'est pas possible d'abonder une pièce pour un montant supérieur et de sens opposé

 IF PF_Iderefpiece IS NOT NULL OR PF_Codrefpiece IS NOT NULL THEN

  IF CTL_Mt_Init_Piece(PF_Iderefpiece ,
                       PF_CodrefpieceC,
                       v_mt_initial_piece_db,
        v_mt_initial_piece_cr)!=0 THEN

        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                           PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                           PF_Ideecr,863,PF_Codrefpiece,'','') != 0 THEN
            RETURN(-1);
        END IF;

  ELSE

    IF CTL_Mt_Total_Abond(PF_Iderefpiece ,
                          PF_CodrefpieceA,
        PF_CodSensCR,
        PF_Ideposte,
        PF_MT,
        PF_Codsens,
        v_mt_initial_piece_db,
        v_mt_initial_piece_cr,
        v_mt_abond_piece_db,
        v_mt_abond_piece_cr
        )!=0 THEN
      IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                            PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                            PF_Ideecr,787,PF_Codrefpiece,'','') != 0 THEN
             RETURN(-1);
         END IF;
    END IF;

  END IF;

 END IF;

  END IF;
  /* Fin de modification */
  -- Controle ecriture recette
  ----------------------------
  IF PF_Typeschemaecr = PF_TypeschemaR OR PF_Typeschemaecr = PF_TypeschemaT THEN
    --Trace('- Controle Ecriture recette');

    -- Si le compte de la ligne est un compte hors budget Alors
    v_retour := CTL_Rc_Liste_Compte(PF_Varcpta,PF_Idecpt,PF_Codcptorhbu);
    IF v_retour = 0 THEN
      --Trace('- Controle Compte orhbu');
      -- 1) ide_ordo,cod_bud,ide_ope renseigne et ide_lig_exec non renseigne sur la ligne
      IF PF_Ideordo IS NULL OR PF_Codbud IS NULL OR
         PF_Ideope IS NULL OR PF_Ideligexec IS NOT NULL THEN
        --Trace('+++ Erreur Compte orhbu 1');
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,672,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;
      END IF;
      -- 2) cod_sens et cod_typ_bud sur la ligne coherents
      IF PF_Codsens = PF_CodsensCR AND PF_Codtypbud != PF_CodtypbudR THEN
        --Trace('+++ Erreur Compte orhbu 2');
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,673,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;
      END IF;
      -- 3) ide_ope tel que rb_ope.flg_recette = 'O'
      IF PF_Flgrecetteope != PF_Oui THEN
        --Trace('+++ Erreur Compte orhbu 3');
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,674,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;
      END IF;

    ELSIF v_retour = -1 THEN
      RETURN(-1);
    END IF;

    -- Si le compte de la ligne est un compte analytique budgetaire Alors
    v_retour := CTL_Rc_Liste_Compte(PF_Varcpta,PF_Idecpt,PF_Codcptcanbu);
    IF v_retour = 0 THEN
      --Trace('- Controle Compte canbu');
      -- 1) ide_ordo,cod_bud,ide_lig_exec doivent etre renseigne sur la ligne
      IF PF_Ideordo IS NULL OR PF_Codbud IS NULL OR
         PF_Ideligexec IS NULL THEN
        --Trace('+++ Erreur Compte canbu 1');
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,675,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;
      END IF;
      -- 2) cod_sens et cod_typ_bud sur la ligne coherents
      IF PF_Codsens = PF_CodsensCR AND PF_Codtypbud != PF_CodtypbudR THEN
        --Trace('+++ Erreur Compte canbu 2');
        IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                         PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                         PF_Ideecr,673,TO_CHAR(PF_Idelig),'','') != 0 THEN
          RETURN(-1);
        END IF;
      END IF;
      -- 3) si ide_ope renseigne, il doit etre tel que rb_ope.flg_recette = 'O'
      IF PF_Ideope IS NOT NULL THEN
        IF PF_Flgrecetteope != PF_Oui THEN
          --Trace('+++ Erreur Compte canbu 3');
          IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                           PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                           PF_Ideecr,674,TO_CHAR(PF_Idelig),'','') != 0 THEN
            RETURN(-1);
          END IF;
        END IF;
      END IF;
      -- 4) ide_lig_exec doit etre une ligne budgetaire d'execution en recette
      IF PF_Varbud IS NOT NULL THEN
        IF EXT_Pn_Var_Bud(PF_Varbud,v_codtypbudvarbud) != 0 THEN
          RETURN(-1);
        END IF;
        IF v_codtypbudvarbud != PF_CodtypbudR THEN
          --Trace('+++ Erreur Compte canbu 4');
          IF MAJ_Fm_Erreur(PF_Codtypnd,PF_Idendemet,PF_Idemess,PF_Flgemisrecu,
                           PF_Ideposte,PF_Idegest,PF_Idejal,PF_Flgcptab,
                           PF_Ideecr,676,TO_CHAR(PF_Idelig),'','') != 0 THEN
            RETURN(-1);
          END IF;
        END IF;
      END IF;

    ELSIF v_retour = -1 THEN
      RETURN(-1);
    END IF;
  END IF;

  RETURN(0);


EXCEPTION
  WHEN OTHERS THEN
    MAJ_Out_Param(105,'(CTL_U212_012E - CTL_Ligne) '||SQLERRM,'','');
    RETURN(-1);

END CTL_Ligne;

/* ******************************************** */
/*                   MAIN                       */
/* ******************************************** */
BEGIN
  --Trace('CTL_U212_012E : Debut Traitement');
  --Trace('********************************');
  --Trace('Parametres :');
  --Trace('P_IDE_POSTE     - '||P_IDE_POSTE);
  --Trace('P_IDE_GEST      - '||P_IDE_GEST);
  --Trace('P_COD_TYP_ND    - '||P_COD_TYP_ND);
  --Trace('P_IDE_ND_EMET   - '||P_IDE_ND_EMET);
  --Trace('P_IDE_MESS      - '||TO_CHAR(P_IDE_MESS));
  --Trace('P_FLG_EMIS_RECU - '||P_FLG_EMIS_RECU);
  --Trace('P_DAT_JC        - '||TO_CHAR(P_DAT_JC));
  --Trace('********************************');


  -- Initialisation paramètre retour
  ----------------------------------
  MAJ_Out_Param('','','','');


  -- Suppression info existante dans FM_ERREUR sur le bordereau
  -------------------------------------------------------------
  IF MAJ_Del_Fm_Erreur(P_COD_TYP_ND,P_IDE_ND_EMET,P_IDE_MESS,P_FLG_EMIS_RECU) != 0 THEN
    --Trace('@@@ Erreur Suppression FM_ERREUR @@@');
    RAISE Erreur_Traitement;
  END IF;


  -- Recuperation information du poste comptable
  ----------------------------------------------
  IF EXT_Rm_Poste(P_IDE_POSTE,v_typposte,v_flgcadposte) != 0 THEN
    RAISE Erreur_Traitement;
  END IF;


  -- Recuperation information de la gestion
  -----------------------------------------
  IF EXT_Fval_Gest(P_IDE_GEST,v_datfgest) != 0 THEN
    RAISE Erreur_Traitement;
  END IF;
  IF TRUNC(v_datfgest) < TRUNC(P_DAT_JC) THEN
    v_periodecomp := 'O';
  ELSE
    v_periodecomp := 'N';
  END IF;


  -- Recuperation code externe
  ----------------------------
  Ext_Codext('STATUT_JOURNEE', 'O', v_libl, v_statut_journee_O, v_retour);
  --Trace('v_statut_journee_O - '||v_statut_journee_O);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) STATUT_JOURNEE - O','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('OUI_NON', 'O', v_libl, v_oui, v_retour);
  --Trace('v_oui - '||v_oui);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) OUI_NON - O','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('OUI_NON', 'N', v_libl, v_non, v_retour);
  --Trace('v_non - '||v_non);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) OUI_NON - N','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('SENS', 'D', v_libl, v_sens_debit, v_retour);
  --Trace('v_sens_debit - '||v_sens_debit);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) SENS - D','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('SENS', 'C', v_libl, v_sens_credit, v_retour);
  --Trace('v_sens_credit - '||v_sens_credit);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) SENS - C','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('STATUT_ECR', 'S', v_libl, v_ecriture_S, v_retour);
  --Trace('v_ecriture_S - '||v_ecriture_S);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) STATUT_ECR - S','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('STATUT_ECR', 'A', v_libl, v_ecriture_A, v_retour);
  --Trace('v_ecriture_A - '||v_ecriture_A);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) STATUT_ECR - A','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('STATUT_ECR', 'R', v_libl, v_ecriture_R, v_retour);
  --Trace('v_ecriture_R - '||v_ecriture_R);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) STATUT_ECR - R','','');
    RAISE Erreur_Codext;
  END IF;

  --- Modif LGD ANO 213 - 18/01/2003
  Ext_Codext('STATUT_ECR', 'V', v_libl, v_ecriture_V, v_retour);
  --Trace('v_ecriture_R - '||v_ecriture_R);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) STATUT_ECR - V','','');
    RAISE Erreur_Codext;
  END IF;


  Ext_Codext('TYPE_SCHEMA', 'D', v_libl, v_schema_D, v_retour);
  --Trace('v_schema_D - '||v_schema_D);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) TYPE_SCHEMA - D','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('TYPE_SCHEMA', 'R', v_libl, v_schema_R, v_retour);
  --Trace('v_schema_R - '||v_schema_R);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) TYPE_SCHEMA - R','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('TYPE_SCHEMA', 'T', v_libl, v_schema_T, v_retour);
  --Trace('v_schema_T - '||v_schema_T);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) TYPE_SCHEMA - T','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('NAT_CREDIT', 'E', v_libl, v_natcredit_E, v_retour);
  --Trace('v_natcredit_E - '||v_natcredit_E);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) NAT_CREDIT - E','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('TYPE_BUDGET', 'D', v_libl, v_codtypbud_D, v_retour);
  --Trace('v_codtypbud_D - '||v_codtypbud_D);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) TYPE_BUDGET - D','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('TYPE_BUDGET', 'R', v_libl, v_codtypbud_R, v_retour);
  --Trace('v_codtypbud_R - '||v_codtypbud_R);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) TYPE_BUDGET - R','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('LISTE_COMPTE', 'CANBU', v_libl, v_cpt_canbu, v_retour);
  --Trace('v_cpt_canbu - '||v_cpt_canbu);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) LISTE_COMPTE - CANBU','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('LISTE_COMPTE', 'ORHBU', v_libl, v_cpt_orhbu, v_retour);
  --Trace('v_cpt_orhbu - '||v_cpt_orhbu);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) LISTE_COMPTE - ORHBU','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('SENS_OPE', 'X', v_libl, v_codsensope_X, v_retour);
  --Trace('v_codsensope_X - '||v_codsensope_X);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) SENS_OPE - X','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('SENS_BE', 'X', v_libl, v_codsensbe_X, v_retour);
  --Trace('v_codsensbe_X - '||v_codsensbe_X);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) SENS_BE - X','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('TYPE_REF_PIECE', 'C', v_libl, v_codrefpiece_C, v_retour);
  --Trace('v_codrefpiece_C - '||v_codrefpiece_C);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) TYPE_REF_PIECE - C','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('TYPE_REF_PIECE', 'S', v_libl, v_codrefpiece_S, v_retour);
  --Trace('v_codrefpiece_S - '||v_codrefpiece_S);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) TYPE_REF_PIECE - S','','');
    RAISE Erreur_Codext;
  END IF;

  Ext_Codext('TYPE_REF_PIECE', 'A', v_libl, v_codrefpiece_A, v_retour);
  --Trace('v_codrefpiece_A - '||v_codrefpiece_A);
  IF (v_retour != 1) THEN
    MAJ_Out_Param(159,'(CTL_U212_012E) TYPE_REF_PIECE - A','','');
    RAISE Erreur_Codext;
  END IF;

  ---------------------------
  -- CONTROLE DU BORDEREAU --
  ---------------------------

  -- Test journee comptable
  -------------------------
  v_flgerreurjc := 'N';
  v_retour := CTL_Jc_Ouverte(P_IDE_POSTE,P_IDE_GEST,P_DAT_JC,v_statut_journee_O);
  IF v_retour = -1 THEN
    RAISE Erreur_Traitement;
  ELSIF v_retour = 1 THEN
    v_flgerreurjc := 'O';
  END IF;

  -- Parcours des ecritures du bordereau
  --------------------------------------
  v_erreurecr := 0;
  FOR row1 IN cur_fc_ecriture(P_IDE_POSTE,P_IDE_GEST,P_COD_TYP_ND,
                              P_IDE_ND_EMET,P_IDE_MESS,P_FLG_EMIS_RECU,
                              v_non,v_ecriture_S,v_ecriture_A,v_ecriture_R)
  LOOP
    --Trace('*************************************************************************');
    --Trace('Ecriture       : '||row1.ide_poste||' - '||row1.ide_gest||' - '||row1.ide_jal||' - '||row1.flg_cptab||' - '||row1.ide_ecr);
    --Trace('var_cpta       : '||row1.var_cpta);
    --Trace('ide_schema     : '||row1.ide_schema);
    --Trace('*************************************************************************');

    -- Erreur journee comptable
    ---------------------------
    IF v_flgerreurjc = 'O' THEN
      IF MAJ_Fm_Erreur(P_COD_TYP_ND,P_IDE_ND_EMET,P_IDE_MESS,P_FLG_EMIS_RECU,
                       row1.ide_poste,row1.ide_gest,row1.ide_jal,row1.flg_cptab,
                       TO_CHAR(row1.ide_ecr),219,TO_CHAR(P_DAT_JC),'','') != 0 THEN
        v_erreurecr := 1;
        EXIT;
      END IF;
    END IF;

    -- Controle saisi ecriture
    --------------------------
    IF CTL_Saisiecr(P_COD_TYP_ND,P_IDE_ND_EMET,P_IDE_MESS,P_FLG_EMIS_RECU,
                    row1.ide_poste,row1.ide_gest,row1.ide_jal,row1.flg_cptab,
                    row1.ide_ecr,v_typposte,v_flgcadposte,row1.var_cpta,
                    row1.ide_schema,P_DAT_JC,v_oui,v_non,v_schema_D,
                    v_flgbejournal,v_typeschemaecr) != 0 THEN
      v_erreurecr := 1;
      EXIT;
    END IF;

    -- Parcours des ligne de l'ecriture courante
    --------------------------------------------
    v_codsensprec := NULL;
    v_nbligne     := 0;
    v_erreurlig   := 0;
    v_totmtcr     := 0;
    v_totmtdb     := 0;
    FOR row2 IN cur_fc_ligne(row1.ide_poste,row1.ide_gest,row1.ide_jal,row1.flg_cptab,
                             row1.ide_ecr)
    LOOP
      v_nbligne := v_nbligne + 1;

      --Trace('-------------------------------------------------------------------------');
      --Trace('Ligne Ecriture : '||row1.ide_poste||' - '||row1.ide_gest||' - '||row1.ide_jal||' - '||row1.flg_cptab||' - '||row1.ide_ecr||' - '||row2.ide_lig);
      --Trace('var_cpta ligne : '||row2.var_cpta);
      --Trace('ide_cpt        : '||row2.ide_cpt);
      --Trace('ide_modele_lig : '||row2.ide_modele_lig);
      --Trace('spec1          : '||row2.spec1);
      --Trace('spec2          : '||row2.spec2);
      --Trace('spec3          : '||row2.spec3);
      --Trace('ide_ordo       : '||row2.ide_ordo);
      --Trace('var_tiers      : '||row2.var_tiers);
      --Trace('ide_tiers      : '||row2.ide_tiers);
      --Trace('cod_ref_piece  : '||row2.cod_ref_piece);
      --Trace('ide_ref_piece  : '||TO_CHAR(row2.ide_ref_piece));
      --Trace('cod_bud        : '||row2.cod_bud);
      --Trace('cod_typ_bud    : '||row2.cod_typ_bud);
      --Trace('var_bud        : '||row2.var_bud);
      --Trace('ide_lig_exec   : '||row2.ide_lig_exec);
      --Trace('ide_ope        : '||row2.ide_ope);
      --Trace('cod_sens       : '||row2.cod_sens);
      --Trace('mt             : '||TO_CHAR(row2.mt));
      --Trace('-------------------------------------------------------------------------');

      -- Recuperation information du modele ligne
      -------------------------------------------
      /* LGD - 12/11/2002 - ANO VA V3 71
   v_retour := EXT_Rc_Modele_Ligne(row2.var_cpta,row1.ide_jal,row1.ide_schema,
                                      row2.ide_modele_lig,v_mascptlig,v_masspec1lig,
                                      v_masspec2lig,v_masspec3lig,v_masordolig,v_masbudlig,
                                      v_masligbudlig,v_masopelig,v_mastierslig,
                                      v_masrefpiecelig,v_codsignelig,v_codrefpiecelig);
       */
    v_retour := EXT_Rc_Modele_Ligne(row2.var_cpta,row1.ide_jal,row1.ide_schema,
                                      row2.ide_modele_lig,v_mascptlig,v_masspec1lig,
                                      v_masspec2lig,v_masspec3lig,v_masordolig,v_masbudlig,
                                      v_masligbudlig,v_masopelig,v_mastierslig,
                                      v_masrefpiecelig,v_codsignelig,v_codrefpiecelig,
           v_masidecptaux);
      /* Fin de modification */

      IF v_retour = 1 THEN
        IF MAJ_Fm_Erreur(P_COD_TYP_ND,P_IDE_ND_EMET,P_IDE_MESS,P_FLG_EMIS_RECU,
                         row1.ide_poste,row1.ide_gest,row1.ide_jal,row1.flg_cptab,
                         TO_CHAR(row1.ide_ecr),709,TO_CHAR(row2.ide_lig),'','') != 0 THEN
          v_erreurlig := 1;
          EXIT;
        END IF;
      ELSIF v_retour = -1 THEN
        v_erreurlig := 1;
        EXIT;
      END IF;

      -- Controle saisi ligne
      -----------------------
      IF CTL_Saisilig(P_COD_TYP_ND,P_IDE_ND_EMET,P_IDE_MESS,P_FLG_EMIS_RECU,
                      row1.ide_poste,row1.ide_gest,row1.ide_jal,row1.flg_cptab,
                      row1.ide_ecr,v_typposte,v_flgbejournal,row2.var_cpta,
                      row2.ide_lig,row2.ide_modele_lig,row2.ide_cpt,v_mascptlig,
                      row2.spec1,v_masspec1lig,row2.spec2,v_masspec2lig,
                      row2.spec3,v_masspec3lig,row2.ide_ordo,v_masordolig,
                      row2.var_tiers,row2.ide_tiers,v_mastierslig,row2.cod_ref_piece,
                      row2.ide_ref_piece,v_masrefpiecelig,row2.cod_bud,row2.cod_typ_bud,
                      v_masbudlig,row2.var_bud,row2.ide_lig_exec,v_masligbudlig,
                      row2.ide_ope,v_masopelig,P_DAT_JC,v_oui,v_non,
                      v_flgjustifcompte,v_flgjustiftierscompte,v_flgjustifcptcompte,
                      v_flgsimpcompte,v_codsensopecompte,v_flgimputbecompte,
                      v_codsensbecompte,v_flgimputcompcompte,v_ideligprevligexec,
                      v_idecptanaligexec,v_varcptaligexec,v_flgimputligexec,v_flgapligprev,
                      v_codnatcrligprev,v_flgrecetteope,v_flgdepenseope,v_vartiersrefpiece,
                      v_idetiersrefpiece,
       -- MODIF SGN ANOVA71 : Ajout des nouveau parametres
       row2.ide_plan_aux,
       row2.ide_cpt_aux,
       row2.ide_schema,
       v_codrefpiece_A,
       -- fin modif SGN
       -- MODIF LGD ANOVA71 : Contrôle sur le masque compte auxiliaire
       v_masidecptaux,
       -- fin modif LGD
       -- MODIF LGD ANOVA
       v_codsignelig,
       row2.cod_sens) != 0 THEN
        v_erreurlig := 1;
        EXIT;
      END IF;

      -- Controle DSO 1
      -----------------
      IF v_typeschemaecr = v_schema_D THEN -- PGE 29/05/2009 ANO 375 V4290
        --Trace('-> Controle DSO Ligne');
        IF CTL_Dso(P_COD_TYP_ND
                  ,P_IDE_ND_EMET
                  ,P_IDE_MESS
                  ,P_FLG_EMIS_RECU
                  , row1.ide_poste
                  ,row1.ide_gest
                  ,row1.ide_jal
                  ,row1.flg_cptab
                  , row1.ide_ecr
                  ,row2.ide_lig
                  ,v_codtypbud_D
                  ,v_natcredit_E
                  , v_sens_debit
                  ,v_sens_credit
                  ,v_oui
                  ,v_non
                  ,v_cpt_canbu
                  -- , row1.    -- SNE, 13/09/2001 : Suppression du flag DSO assignee/FB_DSO
                  ,row2.cod_sens
                  ,row2.mt
                  ,row2.ide_ordo
                  ,row2.var_bud
                  ,row2.cod_bud
                  ,row2.cod_typ_bud
                  ,row2.var_cpta
                  ,row2.ide_cpt
                  ,row2.ide_lig_exec
                  ,v_ideligprevligexec
                  ,v_varcptaligexec
                  ,v_idecptanaligexec
                  ,v_flgapligprev
                  ,v_codnatcrligprev
                  ,v_nbligne
                  ,v_codsensprec) != 0 THEN
                  v_erreurlig := 1;
          EXIT;
        END IF;
      END IF;--  PGE 29/05/2009 ANO 375 V4290

      -- Controle equilibre 1
      -----------------------
      IF v_flgsimpcompte = v_non THEN
        IF row2.cod_sens = v_sens_debit THEN
          v_totmtdb := v_totmtdb + row2.mt;
        ELSIF row2.cod_sens = v_sens_credit THEN
          v_totmtcr := v_totmtcr + row2.mt;
        END IF;
      END IF;

      -- Controle Ligne
      -----------------
      IF CTL_Ligne(P_COD_TYP_ND,P_IDE_ND_EMET,P_IDE_MESS,P_FLG_EMIS_RECU,
                   row1.ide_poste,row1.ide_gest,row1.ide_jal,row1.flg_cptab,
                   row1.ide_ecr,row2.ide_lig,row2.mt,row2.var_cpta,row2.ide_cpt,
                   row2.cod_sens,v_codsignelig,row2.spec1,row2.spec2,row2.spec3,
                   P_DAT_JC,row2.ide_ope,v_flgrecetteope,v_flgdepenseope,
                   row2.cod_typ_bud,v_codtypbud_D,v_codtypbud_R,v_oui,v_non,
                   v_codsensopecompte,v_codsensope_X,v_flgbejournal,
                   v_flgimputbecompte,v_codsensbecompte,v_codsensbe_X,v_periodecomp,
                   v_flgimputcompcompte,row2.ide_lig_exec,v_flgimputligexec,
                   v_flgjustifcompte,v_codrefpiecelig,v_codrefpiece_C,v_codrefpiece_S,
                   v_flgjustiftierscompte,row2.var_tiers,row2.ide_tiers,
                   row2.ide_ref_piece,row2.cod_ref_piece,v_codrefpiece_A,
                   v_vartiersrefpiece,v_idetiersrefpiece,v_flgjustifcptcompte,
                   v_typeschemaecr,v_schema_T,v_schema_R,v_cpt_orhbu,row2.ide_ordo,
                   row2.cod_bud,v_sens_credit,v_cpt_canbu,row2.var_bud,
       --- LGD, ANOGAR606 le 14/05/2004
       row2.ide_plan_aux, row2.ide_cpt_aux) != 0 THEN
        v_erreurlig := 1;
        EXIT;
      END IF;

    END LOOP;

    IF v_erreurlig != 0 THEN
      v_erreurecr := 1;
      EXIT;
    END IF;

    -- Controle DSO 2
    -----------------
    IF v_typeschemaecr = v_schema_D THEN
      --Trace('-> Controle DSO Ecriture');
      IF v_nbligne < 2 THEN
        --Trace('+++ Erreur Nb ligne');
        IF MAJ_Fm_Erreur(P_COD_TYP_ND,P_IDE_ND_EMET,P_IDE_MESS,P_FLG_EMIS_RECU,
                         row1.ide_poste,row1.ide_gest,row1.ide_jal,row1.flg_cptab,
                         TO_CHAR(row1.ide_ecr),351,'','','') != 0 THEN
          v_erreurecr := 1;
          EXIT;
        END IF;
      END IF;
    END IF;

    -- Controle equilibre 2
    -----------------------
    --Trace('-> Controle Equilibre');
    IF v_totmtdb != v_totmtcr THEN
      --Trace('+++ Erreur Equilibre');
      IF MAJ_Fm_Erreur(P_COD_TYP_ND,P_IDE_ND_EMET,P_IDE_MESS,P_FLG_EMIS_RECU,
                       row1.ide_poste,row1.ide_gest,row1.ide_jal,row1.flg_cptab,
                       TO_CHAR(row1.ide_ecr),331,'','','') != 0 THEN
        v_erreurecr := 1;
        EXIT;
      END IF;
    END IF;

  END LOOP;

  IF v_erreurecr != 0 THEN
    RAISE Erreur_Traitement;
  END IF;


  -- Fin NORMALE du traitement
  ----------------------------
  --Trace('CTL_U212_012E : Fin Normale Traitement');

  COMMIT;

  RETURN(0);


EXCEPTION
  WHEN Erreur_Codext THEN
    --Trace('CTL_U212_012E : Erreur_Codext');
    RETURN(-1);

  WHEN Erreur_Traitement THEN
    ROLLBACK;
    --Trace('CTL_U212_012E : Erreur_Traitement');
    RETURN(-1);

  WHEN OTHERS THEN
    ROLLBACK;
    --Trace('CTL_U212_012E : Others');
    RETURN(-1);

END Ctl_U212_012e;

/

CREATE OR REPLACE FUNCTION EXT_MESS
(
   p_num IN NUMBER,
   p_chaine1 varchar2 := NULL,
   p_chaine2 varchar2 := NULL,
   p_chaine3 varchar2 := NULL
) RETURN VARCHAR2 IS
/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_MESS
-- ---------------------------------------------------------------------------
--  Auteur         : ---
--  Date creation  : --/--/2000
-- ---------------------------------------------------------------------------
-- Role          : Extraction et formatage d'un message d'erreur
--
-- Parametres    :
-- 				 1 - p_num  	  - Numero du message
-- 				 2 - p_chaine1  - Premier parametre eventuel (parametre optionnel)
-- 				 3 - p_chaine2  - Second parametre eventuel
-- 				 4 - p_chaine3  - Troisieme parametre eventuel
--
-- Valeurs retournees
--                   - Message formate affichable a l'utilisateur
--					 - Si le message commence par la balise '#E#' alors une erreur est survenue
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_MESS..sql version 3.0-1.2
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) EXT_MESS.sql 1.0-1.0 |--/--/---- | ---	| Création
-- @(#) EXT_MESS.sql 2.1-1.1 |21/04/2001 | SNE	| Simplification du code (mise en place de traces)
-- @(#) EXT_MESS.sql 2.1-1.2 |28/08/2001 | SNE	| Centralisation de la gestion des messages d'erreur
-- @(#) EXT_MESS.sql 3.0-1.3 |28/08/2001 | SNE	| Formattage standard de l'affichage de la date
---------------------------------------------------------------------------------------
*/

/* def variables standards */
   s_nomsql varchar2(40) ;

/* def variables locales */
   v_libl_err VARCHAR2(300);
BEGIN

	 SELECT '('||to_char(sysdate,Get_DateTime_Format) ||') : '
	 		|| EXT_SR_MESS_ERR(p_num, p_chaine1, p_chaine2, p_chaine2)
			||' ==> niveau de gravité : '||cod_typ_err
	 INTO v_libl_err
	 FROM SR_MESS_ERR WHERE ide_mess_err = p_num;
   /* affichage du message */
   return(v_libl_err);

EXCEPTION

   WHEN NO_DATA_FOUND THEN
      v_libl_err := 'Message numéro '||p_num||' non trouve';
      RETURN('#E#'||'('||to_char(sysdate,Get_DateTime_Format)||') : '||v_libl_err);

   WHEN OTHERS THEN
      RETURN('#E# exception ordre SQL : '||s_nomsql||' exception code : '||sqlcode||' exception mess : '||sqlerrm);

END EXT_MESS;

/

CREATE OR REPLACE FUNCTION GES_EXEC_TRAITEMENT(p_ut IN VARCHAR2 := ''
		, p_param IN VARCHAR2 := ''
		, p_separateur_param IN VARCHAR2 := ' '
		, p_fichier_trace IN VARCHAR2 := ''
		, p_copies varchar2 := '1'
		)
RETURN NUMBER IS
	/*
	-- ==========================================================================
	-- Fonction GES_EXEC_TRAITEMENT
	--
	-- ==========================================================================
	-- Objet : Executer un batch via le lanceur d aster
	--
	-- Entrée : 1. Le nom de l ut a lancer
	--          2. Les parametres de l UT
	--          3. Le separateur permettant de separer les parametres envoyes
	--          4. Fichier de trace
	--          5. Le nombre de compie a imprimer
    --
	-- Sortie : 0 si OK
	--          -2 si le fichier dépêche n'existe pas
	--          -1 / -99 si une autre erreur est survenue
	-- ==========================================================================
	--         H I S T O R I Q U E
	-- ==========================================================================
	-- 	--------------------------------------------------------------------
	-- 	Fonction				   	|Date	    |Initiales	|Commentaires
	-- 	--------------------------------------------------------------------
	-- @(#) GES_EXEC_TRAITEMENT 3.0-1.0	|20/02/2002 | SGN	| Création
	-- @(#) GES_EXEC_TRAITEMENT 3.0-1.1	|14/03/2002 | SGN	| Ajout du traitement des editions + Gestion
	-- @(#) GES_EXEC_TRAITEMENT 3.0-1.1				  		  Gestion correcte des traces
	-- @(#) GES_EXEC_TRAITEMENT 3.0-1.2	|07/05/2002 | NDY	| Ajout recherche erreur eventuelle dans le fichier trace apres execution
	-- @(#) GES_EXEC_TRAITEMENT 3.0-1.3	|17/05/2002 | LGD	| PB dans la recherche d'erreur dans le fichier trace.
	-- @(#) GES_EXEC_TRAITEMENT 3.??????|04/12/2006| LSA	| PB dans le passage du mot de passe (quotes et guillemets en trop).
	---------------------------------------------------------------------------------------
	*/
	/*
	-- ======================================================================
	-- 							Constantes utilisées
	-- ======================================================================
	*/
	/*
	-- 				Parametres lies au systeme d'exploitation
	*/
	cst_separateur_chemin_UNIX   CONSTANT VARCHAR2(01) := '/';
	cst_cmd_chmod   			 CONSTANT VARCHAR2(07) := 'chmod';
	cst_Tous_Droits   			 CONSTANT VARCHAR2(07) := '777';
	cst_extension_fichier_trace  CONSTANT VARCHAR2(04) := '.trc';
	/*
	-- 					Parametres ASTER utilises
	*/
	cst_Param_Chemin_Des_Batches CONSTANT VARCHAR2(07) := 'IR0010';
	cst_Param_Fichier_Erreur     CONSTANT VARCHAR2(07) := 'IR0037';
	cst_Param_Admin_aster     	 CONSTANT VARCHAR2(07) := 'IR0039';
	cst_Param_Fichier_Utilisateurs CONSTANT VARCHAR2(07) := 'IR0038';
	cst_Param_Fichier_Config     CONSTANT VARCHAR2(07) := 'IR0048';
	cst_Param_Site_Courant CONSTANT VARCHAR2(07) := 'SM0008';
	cst_Param_Nom_Base CONSTANT VARCHAR2(07) := 'IR0044';
	/*
	-- 		Variables ASTER contenue dans le fichier de configuration
	*/
	--cst_Var_Admin_Mes  CONSTANT VARCHAR2(11) := 'MES_ADM';
	cst_Var_Admin_Aster  CONSTANT VARCHAR2(11) := 'PIAF_ADM';
	cst_Var_Fic_Util CONSTANT VARCHAR2(22) := 'FICHIER_UTILISATEURS';
	cst_Var_Fic_Erreur CONSTANT VARCHAR2(22) := 'FICHIER_ERREUR';
	cst_Ecraser_Fichier CONSTANT VARCHAR2(02) := 'w+';
	cst_Prg_Lanceur CONSTANT VARCHAR2(10) := 'lanceur';
	cst_SEPARATEUR CONSTANT VARCHAR2(01) := '_';
	cst_signe_egal CONSTANT VARCHAR2(01) := '=';
	/*
	-- 		Erreurs et codes retour
	*/
	cst_Appel_Fct_Lib_Ok  CONSTANT NUMBER := 0;
	cst_Exec_Command_Ok CONSTANT NUMBER := 0;
	--cst_Erreur_Technique CONSTANT NUMBER := -1;
	--cst_Erreur_Nom_Fichier CONSTANT NUMBER := -2;
	cst_Erreur_Cre_Fichier CONSTANT NUMBER := -3;
	cst_Erreur_Site_Courant CONSTANT NUMBER := -4;
	-- cst_Erreur_Var_Cfg CONSTANT NUMBER := -11;
	cst_Erreur_Fic_Cfg CONSTANT NUMBER := -12;
	-- cst_Erreur_Uti_Cfg CONSTANT NUMBER := -13;
	cst_Erreur_Uti_adm CONSTANT NUMBER := -14;
	cst_Erreur_Par_Prg CONSTANT NUMBER := -15;
	cst_Erreur_Par_Base CONSTANT NUMBER := -16;
	cst_Erreur_Exec_Command CONSTANT NUMBER := -17;
	cst_Erreur_Fic_Trace CONSTANT NUMBER := -18;
	-- cst_Erreur_Autre CONSTANT NUMBER := -99;
	/*
	-- 		Autres constantes
	*/
	cstNomProgramme VARCHAR2(20) :=  'GES_EXEC_TRAITEMENT';
	/*
	-- ======================================================================
	-- 							Variables locales
	-- ======================================================================
	*/
	-- v_commande_systeme VARCHAR2(255);
	v_extension_shell  VARCHAR2(10);
	v_chemin_des_batch VARCHAR2(255);
	v_fichier_travail  VARCHAR2(255);
	v_fic_trace        VARCHAR2(255);
	v_erreur           VARCHAR2(101) := NULL;
	-- v_repertoire_travail  VARCHAR2(255);
	v_fichier_cfg SR_PARAM.VAL_PARAM%TYPE;
	v_fichier_utilisateurs SR_PARAM.VAL_PARAM%TYPE;
	-- v_administrateur_mes SR_PARAM.VAL_PARAM%TYPE;
	v_administrateur_aster SR_PARAM.VAL_PARAM%TYPE;
	v_fichier_erreur  SR_PARAM.VAL_PARAM%TYPE;
	v_base_courante SR_PARAM.VAL_PARAM%TYPE := GLOBAL.db_instance;
	v_separateur_fichier VARCHAR2(01) ;
	v_separateur_var_path VARCHAR2(01) := NULL;
	v_site_courant SR_PARAM.VAL_PARAM%TYPE;
	--v_site_emet FM_DEPECHE.IDE_SITE_EMET%TYPE;
	--v_site_dest FM_DEPECHE.IDE_SITE_DEST%TYPE;
	--v_num_depeche FM_DEPECHE.IDE_DEPECHE%TYPE;
	--v_cod_environ FM_DEPECHE.IDE_ENV%TYPE;
	v_ret NUMBER;
	v_retour NUMBER;

	v_ide_fct SH_FONCTION.ide_fct%TYPE;
	v_ide_chaine SH_FONCTION.ide_chaine%TYPE;
	v_cod_typ_trt SH_FONCTION.cod_typ_trt%TYPE;
	v_nomprog B_BATCH.nomprog%TYPE;
	v_libprog B_BATCH.libprog%TYPE;
	v_dirprog B_BATCH.dir_prog%TYPE;
	v_media_edt B_BATCH.media_edt%TYPE;
	v_uti_maj B_BATCH.uti_maj%TYPE;
	v_dir_edt B_BATCH.dir_edt%TYPE;
    v_imprimante B_BATCH.imprimante%TYPE;
	v_orientation B_BATCH.orientation%TYPE;
	v_cod_format B_BATCH.cod_format%TYPE;
	v_recto_verso B_BATCH.recto_verso%TYPE;
	v_sens_rv B_BATCH.sens_rv%TYPE;
	v_bac B_BATCH.bac%TYPE;
	v_fic VARCHAR2(512);
	v_param_edition VARCHAR2(512);
	v_len_pos NUMBER;
    v_param     VARCHAR2(1000);
    v_position  NUMBER;
 	v_1_param   VARCHAR2(255);
 	v_val_param   VARCHAR2(255);
 	v_nom_param   VARCHAR2(255);
    v_valeurs     VARCHAR2(1000);

    -- MODIF SGN : Gestion des trace
	-- flg_trace CONSTANT VARCHAR2(3) := 'OFF'; /* valeurs : ON/OFF */
	v_niveau_trace NUMBER;
	v_num_trt NUMBER;
	-- Fin modif SGN


  -- ===========================
  --	   Gestion de la trace
  -- ===========================
  PROCEDURE trace(p_msg VARCHAR2) IS

  BEGIN
	AFF_TRACE(cstNomProgramme, 1, NULL, p_msg);	-- modif NDY 07/05/2002
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END trace;



BEGIN
	-- Gestion de la trace (initialisation)
    -- IF  flg_trace = 'ON' THEN
	-- MODIF SGN : Recuperation du niveau de trace en passant par les variables ASTER
	ASTER_VAR.get_var('NIVEAU_TRACE_VAR','P_NIV_TRACE', v_niveau_trace, v_num_trt);
	GLOBAL.INI_NIVEAU_TRACE(NVL(v_niveau_trace,0));

	TRACE('DEBUT --'||cstNomProgramme||'('||p_ut||')');

	-- Recuperation du separateur de fichier et du separateur de variable IR0010

	v_ret := ASTER_env_param(v_separateur_fichier, v_separateur_var_path);


	EXT_PARAM(cst_Param_Chemin_Des_Batches, v_chemin_des_batch, v_ret);
	IF v_ret != 1 THEN
		RETURN(cst_Erreur_Par_Prg);

	END IF;
	TRACE(cst_Param_Chemin_Des_Batches||' --'||v_chemin_des_batch);

	-- Recuperation de la base courante IR0044
	IF v_base_courante IS NULL THEN
		EXT_PARAM(cst_Param_Nom_Base, v_base_courante, v_ret);
		IF v_ret != 1 THEN
				RETURN(cst_Erreur_Par_Base);
		END IF;
	END IF;
	TRACE(cst_Param_Nom_Base||' --'||v_base_courante);

	-- Recuperation du chemin du fichier de config IR0048
	EXT_PARAM(cst_Param_Fichier_Config, v_fichier_cfg, v_ret);

	IF v_ret != 1 THEN
		RETURN(cst_Erreur_Fic_Cfg);
	END IF;
	TRACE(cst_Param_Fichier_Config||' --'||v_fichier_cfg);

	-- Recuperation de l'extension du fichier shell
	v_ret := ASTER_extension_fic_shell(v_extension_shell);

	IF v_ret != cst_Appel_Fct_Lib_Ok THEN
		RETURN(v_ret);
	END IF;
	TRACE(' ASTER_extension_fic_shell :--'||v_extension_shell);

	-- Determination du fichier de travail qui recevra les instructions a lancer
	v_fichier_travail := RTRIM(REPLACE(CAL_Nom_Fichier_Trace(cstNomProgramme), cst_extension_fichier_trace, '.'||v_extension_shell));
	TRACE('fichier de travail:'||v_fichier_travail);

	-- Recuperation de l'utilisateur admin puis verification de son existance
	-- dans le fichier de configuration

	EXT_PARAM(cst_Param_Admin_aster, v_administrateur_aster, v_ret);
	IF v_ret = 0 THEN
		v_ret := ASTER_lire_info(v_fichier_cfg,  v_base_courante, cst_Var_Admin_Aster, v_administrateur_aster);
		IF v_ret != cst_Appel_Fct_Lib_Ok THEN
		   RETURN(cst_Erreur_Uti_adm);
		END IF;
	TRACE(cst_Var_Admin_Aster||' --'||v_administrateur_aster);
	END IF;
	TRACE(cst_Param_Admin_Aster||' --'||v_administrateur_Aster);

	-- Recuperation fichier utilisateur IR0038 et verification
	-- de son parametrage dans le fichier de configuration
	EXT_PARAM(cst_Param_Fichier_Utilisateurs, v_fichier_utilisateurs, v_ret);
	IF v_ret = 0 THEN
		v_ret := ASTER_lire_info(v_fichier_cfg,  v_base_courante, cst_Var_Fic_Util, v_fichier_utilisateurs);
		IF v_ret != cst_Appel_Fct_Lib_Ok THEN
		   RETURN(v_ret);
		END IF;
		TRACE(cst_Var_Fic_Util||' --'||v_fichier_utilisateurs);
	END IF;
	TRACE(cst_Param_Fichier_Utilisateurs||' --'||v_fichier_utilisateurs);

	-- Recuperation du fichier d erreur et verification
	-- de son parametrage dans le fichier de configuration
	EXT_PARAM(cst_Param_Fichier_Erreur , v_fichier_erreur, v_ret);
	IF v_ret = 0 THEN
		v_ret := ASTER_lire_info(v_fichier_cfg,  v_base_courante, cst_Var_Fic_Erreur, v_fichier_erreur);
		IF v_ret != cst_Appel_Fct_Lib_Ok THEN
		  RETURN(v_ret);
		END IF;
		TRACE(cst_Var_Fic_Erreur||' --'||v_fichier_erreur);
	END IF;
	TRACE(cst_Param_Fichier_Erreur||' --'||v_fichier_erreur);

	-- Recuperation du site courant SM0008
	EXT_PARAM(cst_Param_Site_Courant, v_site_courant, v_ret);
	IF v_ret != 1 THEN
		RETURN(cst_Erreur_Site_Courant);
	END IF;
	TRACE(cst_Param_Site_Courant||' --'||v_site_courant);

	-- Recuperation des info concernant l'UT a lancer
	BEGIN

		 SELECT t1.ide_fct, t1.ide_chaine, t1.cod_typ_trt,
		        t2.nomprog, t2.libprog, t2.dir_prog, t2.uti_maj, t2.media_edt, t2.dir_edt,
			  t2.imprimante, DECODE(t2.orientation, 'L','LANDSCAPE', 'P', 'PORTRAIT', 'DEFAULT'), t2.cod_format, t2.recto_verso,
			  t2.sens_rv, t2.bac
		 INTO v_ide_fct, v_ide_chaine, v_cod_typ_trt,
		      v_nomprog, v_libprog, v_dirprog, v_uti_maj, v_media_edt, v_dir_edt,
			  v_imprimante, v_orientation, v_cod_format, v_recto_verso,
			v_sens_rv, v_bac
		 FROM sh_fonction t1, b_batch t2
		 WHERE t1.cod_role = p_ut
		   AND t1.cod_role = t2.nomprog;
	EXCEPTION
		WHEN OTHERS THEN
			TRACE('Select info UT:'||p_ut||' err:'||sqlerrm);
	 	  	RAISE;
	END;

	-- Initialisation/creation du fichier de travail
	IF SUBSTR(LTRIM(v_chemin_des_batch), 2, 1) = ':' THEN
		v_ret := PIAF_ecrit_fichier(SUBSTR(LTRIM(v_chemin_des_batch), 1, 2), v_fichier_travail, cst_Ecraser_Fichier);
	ELSE
		v_ret := PIAF_ecrit_fichier(' ', v_fichier_travail, cst_Ecraser_Fichier);
	END IF;
	IF v_ret != cst_Appel_Fct_Lib_Ok THEN
		RETURN(cst_Erreur_Cre_Fichier);
	END IF;

	-- Constitution du fichier de travail
	-- 1. On se deplace a l endroit ou se trouve le programme lanceur
	v_ret := PIAF_ecrit_fichier('cd '||v_chemin_des_batch, v_fichier_travail);
	IF v_ret != cst_Appel_Fct_Lib_Ok THEN
		RETURN(cst_Erreur_Cre_Fichier);
	END IF;

	-- En fonction du type de traitement B(atch) E(dition) C(haine trt)
	-- On affecte ou non des parametres d edition

	-- Si il s agit d une edition
	TRACE('Edition: cod_typ_trt:'||v_cod_typ_trt||' media_edt:'||v_media_edt);
	IF v_cod_typ_trt = 'E' THEN
		-- Si le media est un fichier
		IF v_media_edt = 'F' THEN
			v_fic := v_dir_edt
				||v_separateur_fichier
				||v_nomprog
				||'_'||user
				||'_'||v_uti_maj
				||'_'||sysdate;

			v_param_edition := ' DESTYPE=FILE'||
						   ' DESNAME='||v_fic||
						   ' DESFORMAT='||v_imprimante;
		-- sinon si c est une edition
		ELSIF v_media_edt = 'I' THEN
			v_param_edition := ' DESTYPE=printer'||
						   ' DESNAME='||v_imprimante||
						   ' DESFORMAT=dflt';
		END IF;

		-- Parametre d edition globaux
		v_param_edition := v_param_edition ||
				' ORIENTATION='||v_orientation||
				' COPIES='||p_copies||
				' "'||v_cod_format||'"'||
				' "'||v_recto_verso||'"'||
				' "'||v_sens_rv||'"'||
				' "'||v_bac||'"';
	ELSE
		v_param_edition := ' ';
	END IF;
	TRACE('Parametre specifique edition:'||substr(v_param_edition,1,100));

	-- Traitement de la chaine de parametre
	-- On veut uniquement recuperer les valeurs des parametres (v_valeur) et leur nombre (v_position)
	IF p_param IS NOT NULL THEN
	   	 TRACE('Traitement des parametres :'||p_param);
-- 	     ATTENTION -- CAUTION -- ACHTUNG -- ATTENZIONNE -- BRZSKDE -- KRTZEBUD
-- 	     La fonction 'EXT_COMPOSANT_NOM' ne detecte pas le dernier composant
-- 	     si celui-ci n'est suivi d'un separateur

		 v_len_pos := LENGTH(p_separateur_param); -- MODIF SGN ANO011

		 IF SUBSTR(p_param, LENGTH(p_param)-v_len_pos+1, v_len_pos) != p_separateur_param THEN
		 	v_param := p_param || p_separateur_param;
		 ELSE
		 	v_param := p_param;
		 END IF;
	     v_position := 1;
		 v_1_param := EXT_COMPOSANT_NOM(v_param, v_position, p_separateur_param, '');

		 WHILE v_1_param IS NOT NULL LOOP
		 	v_nom_param := RTRIM(SUBSTR(v_1_param, 1, INSTR(v_1_param, cst_Signe_Egal, 1)-1));
		    v_val_param := LTRIM(SUBSTR(v_1_param, 1+INSTR(v_1_param, cst_Signe_Egal, 1)
		                                            , LENGTH(v_1_param) - INSTR(v_1_param, cst_Signe_Egal, 1) ));
		    v_position := v_position +1;
		    v_1_param := LTRIM(EXT_COMPOSANT_NOM(v_param, v_position, p_separateur_param, ''));

			-- MODIF SGN : Si il s'agit d une edition on doit passer le parametre et sa valeur
			-- si il s agit s un traitement on ne passe que la valeur du parametre
			IF v_cod_typ_trt = 'E' THEN
			   v_valeurs := v_valeurs || ' "' ||v_nom_param||'='||v_val_param||'"';
			ELSE
			   v_valeurs := v_valeurs || ' ''"' ||v_val_param||'"''';
			END IF;
		 END LOOP;
		 TRACE('Fin traitement parametre');
		 TRACE('val:'||SUBSTR(v_valeurs,1,100));
		 TRACE(SUBSTR(v_valeurs,101,100));
	END IF;   -- p_param IS NOT NULL


    TRACE('Ecriture dans le fichier de travail');

	v_fic_trace := cal_nom_fichier_trace(p_ut);
	v_ret := PIAF_ecrit_fichier(cst_Prg_Lanceur
			||' '||v_fichier_erreur
			||' '||v_fichier_cfg
			||' '||v_base_courante
			||' '||user
-- LSA-20061204-D
	--		||' ''"'||Ext_User_Passwd(v_site_courant)||'"'''
			||' '||Ext_User_Passwd(v_site_courant)
-- LSA-20061204-F
			||' '||v_ide_fct
			||' '||v_nomprog
			||' '||v_cod_typ_trt
			||' '||v_dirprog
			||' ''"'||v_libprog||'"'''
			||' '||to_char(v_position-1)  -- nbr de parametre
			||' '||v_param_edition
			||' '||v_valeurs
			||' '||v_fic_trace
			||' '||v_administrateur_Aster
			||' '||v_fichier_utilisateurs
			, v_fichier_travail);
	TRACE('ret Piaf_ecrit_fichier:'||to_char(v_ret));

	IF v_ret != cst_Appel_Fct_Lib_Ok THEN
		RETURN(cst_Erreur_Cre_Fichier);
	END IF;
	TRACE('Fin traitement parametre');

	-- Execution du fichier de travail
	-- 1. Sous unix on effectue auparavant un chmod 777 sur le fichier de travail
	IF v_separateur_fichier = cst_separateur_chemin_UNIX THEN
		v_ret := ASTER_executer_commande(cst_cmd_chmod ||' '||cst_Tous_Droits||' '||v_fichier_travail, '', '');
	END IF;

	-- 2. Execution proprement dite
	v_ret := ASTER_executer_commande(v_fichier_travail, '', '');
	TRACE('Fin execution fichier : '||v_fichier_travail||' ret:'||to_char(v_ret));


	-- NDY, 07/05/2002 : Recherche erreur eventuelle dans le fichier trace genere
	IF v_ret != cst_Exec_Command_Ok THEN
		RETURN(cst_Erreur_Exec_Command);
	END IF;
	v_ret := ASTER_EXT_ERREUR_TRAITEMENT(v_fic_trace,'#E#',v_erreur);
	--- LGD, ASTER V3.0 - 17/05/2002 - Ano interne : Retrait des chaînes nulles
	IF rtrim(ltrim(v_erreur)) IS NOT NULL THEN
	  v_ret := cst_Erreur_Fic_Trace;
	  TRACE(v_erreur);
	ELSE
	  --- LGD, ASTER V3.0 - 17/05/2002 - Ano interne : Si v_erreur est nul alors le TRT est OK
	  v_ret :=cst_Exec_Command_Ok ;
	  TRACE('Pas d''erreur ds fichier trace');
	END IF;
	-- SNE, 16/10/2001 : Si on n'arrive pas à effacer le fichier de travail l'erreur n'est pas remontée

	-- Si les traces ne sont pas activees on efface le fichier de travail
	IF GLOBAL.niveau_trace = 0 THEN
	  v_retour := ASTER_efface_fichier(v_fichier_travail);
	END IF;
	TRACE('FIN -- '||cstNomProgramme);
	RETURN(v_ret);
EXCEPTION
	WHEN OTHERS THEN
		TRACE('ERREUR -- '||cstNomProgramme);
		TRACE(sqlerrm);
		RAISE;
END; -- GES_EXEC_TRAITEMENT

/

CREATE OR REPLACE FUNCTION z_ide_lig_prev_new (p_ide_poste VARCHAR2,p_ide_ope VARCHAR2,p_ide_lig_prev_old VARCHAR2)
RETURN VARCHAR2
IS
----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_IDE_LIG_PREV_NEW
-- DATE CREATION  : 05/01/2007
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : RECHERCHE DE LA NOUVELLE IMPUTATION SUR LA GESTION SUIVANTE

----------------------------------------------------------------------------------
--                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
----------------------------------------------------------------------------------
-- Z_IDE_LIG_PREV_NEW         | 1.0        |05/01/2007| IL          |
----------------------------------------------------------------------------------

-- PARAMETRES ------------
-- P_IDE_POSTE : POSTE
-- P_IDE_OPE  :  NUMERO DE L'OPéRATION
-- P_IDE_LIG_PREV_OLD  : ANCIENNE LIGNE DE PRéVISION
----------------------------------------------------------------------------------
v_ide_lig_prev_new VARCHAR2(15);
v_cpt NUMBER(6);
BEGIN
SELECT COUNT(*) INTO v_cpt FROM ZB_BASCULE_MODIFS WHERE ide_poste=p_ide_poste AND ide_ope=p_ide_ope AND ide_lig_prev IS NOT NULL;
IF v_cpt<>0 THEN
SELECT ide_lig_prev INTO v_ide_lig_prev_new FROM ZB_BASCULE_MODIFS WHERE ide_poste=p_ide_poste AND ide_ope=p_ide_ope AND ide_lig_prev IS NOT NULL;
ELSE
v_ide_lig_prev_new:=z_rech_ide_lig_prev_new(p_ide_lig_prev_old);
END IF;
RETURN v_ide_lig_prev_new;
END z_ide_lig_prev_new;

/

CREATE OR REPLACE FUNCTION CAL_MT_DEVISE(p_ide_devise    RB_TXCHANGE.ide_devise%TYPE,
                                         p_taux_change   RB_TXCHANGE.val_taux%TYPE,
                                         p_cal_mt_ref    NUMBER,
                                         p_mt            IN OUT NUMBER,
										 p_mt_dev        IN OUT NUMBER
                                         ) RETURN NUMBER IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : REF
-- Nom           : CAL_MT_DEVISE
-- ---------------------------------------------------------------------------
--  Auteur         : LGD
--  Date creation  : 14/10/2002
-- ---------------------------------------------------------------------------
-- Role          : Calcul du montant en devise de référence ou en devise (en fonction du type de calcul)
--                 pour un taux de devise donné. Le montant est arrondi au nombre de décimale défini dans le
--                 paramétrage
-- Parametres  entree  :
--               1 - p_ide_devise : Devise pour laquelle est établi la conversion
-- 				 2 - p_taux_change : taux de change a appliqué pour le calcul des montants à convertir
--				 3 - p_cal_mt_ref = 1 => Calcul du montant en devise de référence pour un montant en devise et un taux de change donnés
                                  = 0 => Calcul du montant en devise pour un montant en devise de référence et un taux de change donnés
--
-- Parametre sorties :
--				 4 - p_mt : calculé si p_cal_mt_ref = 1
--				 5 - p_mt_dev : calculé si p_cal_mt_ref = 0
--
-- Valeur retournee : 1 : Le traitement s'est bien passé
                     -1 : Impossible d'effectuer le traitement de conversion car le paramètre indiquant le nombre de décimal n'est pas défini.
					 -2:  Impossible de calculer le montant en devise car le taux de change est null ou égal à 0.
					 -3:  Impossible de calculer l'arrondi.
--
-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_MT_DEVISE sql version 3.0d-2.0
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) CAL_MT_DEVISE.sql 3.0-1.0	|14/10/2002| LGD	| Création
-- @(#) CAL_MT_DEVISE.sql 3.0d-1.1	|30/01/2003| LGD	| ANOVAV3 262 : Nb de décimale à 3 pour MT_DEV et fonction de IR0001 pour
                                                          les montants en devise de référence.
-- @(#) CAL_MT_DEVISE.sql 3.0d-1.2	|12/02/2003| LGD	| Retour ANOVAV3 262
-- @(#) CAL_MT_DEVISE.sql 3.0e-1.3	|19/03/2003| LGD	| ANO 293 ; Pb de calcul des montants en devise de référence.
-- 	----------------------------------------------------------------------------------------------------------
*/
  v_codint_devise_ref SR_CODIF.ide_codif%TYPE;

  v_ret NUMBER;
  v_val_param NUMBER;

  PARAM_EXCEPTION EXCEPTION;
  CODIF_EXCEPTION EXCEPTION;
  Erreur_Arrondi  EXCEPTION;

  -- Variable pour la trace
  v_niveau_trace NUMBER := NULL;
  v_num_trt NUMBER;




BEGIN

      --- LGD le 30/01/2003 - ANOVAV3 262
	  v_ret := CAL_ROUND_MT(p_mt,p_mt);
	  If v_ret !=1  then
	    raise Erreur_Arrondi ;
	  end if;

	  v_ret := CAL_ROUND_MT_DEV(p_mt_dev,p_mt_dev);
	  If v_ret !=1  then
	    raise Erreur_Arrondi ;
	  end if;
	  -- Fin de modif


	 -- Recuperation du niveau de trace en passant par les variables ASTER
	 ASTER_VAR.get_var('NIVEAU_TRACE_VAR','P_NIV_TRACE', v_niveau_trace, v_num_trt);
	 GLOBAL.INI_NIVEAU_TRACE(NVL(v_niveau_trace,0));

 	 AFF_TRACE('CAL_MT_DEVISE', 2, NULL, 'Debut traitement');


	 -- Recuperation du code interne de la devise de reference
     EXT_PARAM('IC0026', v_codint_devise_ref, v_ret);
	 IF v_ret != 1 THEN
		RAISE PARAM_EXCEPTION;
     END IF;

     AFF_TRACE('CAL_MT_DEVISE', 2, NULL, 'devise:'||p_ide_devise);
     AFF_TRACE('CAL_MT_DEVISE', 2, NULL, 'Code interne dev ref:'||v_codint_devise_ref);

	 -- si la devise à convertir est la devise de reference
	 IF p_ide_devise IS NULL OR p_ide_devise = v_codint_devise_ref THEN

		 -- Si l'on cherche à calculer le montant en devise de référence
		 If p_cal_mt_ref=1 then

		    v_ret := CAL_ROUND_MT(p_mt_dev,p_mt);
	        If v_ret !=1  then
	          raise Erreur_Arrondi ;
	        end if;
		   --p_mt:=p_mt_dev;

		 else
		 -- Si l'on cherche à calculer le montant en devise
		   v_ret := CAL_ROUND_MT_DEV(p_mt,p_mt_dev,p_ide_devise);
	       If v_ret !=1  then
	         raise Erreur_Arrondi ;
	       end if;
		   --p_mt_dev:=p_mt;
		 end if;

		 return(1);

	ELSE
	     -- Récipération du nombre de décimal paramétré
         EXT_PARAM('IR0001', v_val_param, v_ret);
	     IF v_ret != 1 THEN
	      RAISE PARAM_EXCEPTION;
	     ELSE
		  AFF_TRACE('CAL_MT_DEVISE', 2, NULL, 'Nombre de décimale:'||v_val_param);
		  -- Si l'on cherche à calculer le montant en devise de référence
		  If p_cal_mt_ref=1 then
			p_mt :=(nvl(p_mt_dev,0)*nvl(p_taux_change,0));

			  --- LGD le 30/01/2003 - ANOVAV3 262
			  v_ret := CAL_ROUND_MT(p_mt,p_mt);
			  If v_ret !=1  then
			    raise Erreur_Arrondi ;
			  end if;
			  -- Fin de modif

			AFF_TRACE('CAL_MT_DEVISE', 2, NULL, 'Montant en devise de référence:'||p_mt);
			return(1);
	      else
			-- Si l'on cherche à calculer le montant en devise
		    if nvl(p_taux_change,0)=0 then
			  return(-2);
			else
			  AFF_TRACE('CAL_MT_DEVISE', 2, NULL, 'Montant en devise:'||p_mt_dev);
			  p_mt_dev:=(nvl(p_mt,0)/p_taux_change);

			  --- LGD le 30/01/2003 - ANOVAV3 262
			  v_ret := CAL_ROUND_MT_DEV(p_mt_dev,p_mt_dev);
			  If v_ret !=1  then
			    raise Erreur_Arrondi ;
			  end if;
			  --- Fin de modif

			  return(1);
			end if;
		  end if;

		END IF;

	END	IF;
	AFF_TRACE('CAL_MT_DEVISE', 2, NULL, 'Fin traitement');

EXCEPTION
  WHEN PARAM_EXCEPTION THEN
      if p_cal_mt_ref =1 then
	    p_mt:=null;
	  else
	    p_mt_dev:=null;
	  end if;
	  return(-1);

    WHEN Erreur_Arrondi THEN
      if p_cal_mt_ref =1 then
	    p_mt:=null;
	  else
	    p_mt_dev:=null;
	  end if;
	  return(-3);

  WHEN OTHERS THEN
 	  RAISE;
END CAL_MT_DEVISE;

/
