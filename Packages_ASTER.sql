CREATE OR REPLACE PACKAGE ASTER_VAR IS
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_VAR
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 27/02/2002
-- ---------------------------------------------------------------------------
-- Role          : Package pour la gestion des variables utilisé par les batchs
--
-- Type 		 : PACKAGE
-- ---------------------------------------------------------------------------
--  Version        : @(#) Aster_var.sql version 3.0-1.0
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) Aster_var.sql 3.0-1.0	|27/02/2002 | SGN	| Création
---------------------------------------------------------------------------------------
*/

-- Variables

-- fonctions / procedure

/*
---------------------------------------------------------------------------------------
-- Nom           : CREE_VAR
-- Date creation : 27/02/2002
-- Creee par     : SGN
-- Role          : Cree une variable aster si elle n existe pas, mise a jour sinon => Alimentation
--                 de B_TRAITEMENT et B_PARAMTRT
-- Parametres    : p_type 	  - type de variable aster a ajouter
-- 				   p_nom      - nom de la variable aster a ajouter
-- 				   p_val	  - valeur de la variable aster a ajouter
--
-- Valeurs retournees
--
---------------------------------------------------------------------------------------
*/
  PROCEDURE CREE_VAR(p_type VARCHAR2,
		  			 p_nom VARCHAR2,
					 p_val VARCHAR2);


/*
---------------------------------------------------------------------------------------
-- Nom           : GET_VAR
-- Date creation : 27/02/2002
-- Creee par     : SGN
-- Role          : Recuperation de la valeur d'une variable aster et de son numero de traitement
-- Parametres    : p_type 	  	  - type de la variable
-- 				   p_nom      - nom de la variable aster a ajouter
--                 p_val    - valeur de la variable
--                 p_numtrt  - numero de traitement associe a la variable
--
-- Valeurs retournees
--
---------------------------------------------------------------------------------------
*/
  PROCEDURE GET_VAR(p_type VARCHAR2,
                    p_nom VARCHAR2,
					p_val IN OUT VARCHAR2,
					p_numtrt IN OUT VARCHAR2);

/*
---------------------------------------------------------------------------------------
-- Nom           : SUPP_VAR
-- Date creation : 27/02/2002
-- Creee par     : SGN
-- Role          : Suppression d'une variable aster et des ses valeurs
-- Parametres    : p_type 	- type de la variable
--
-- Valeurs retournees : p_val - valeur de la variable
--                      p_numtrt - numero du traitement associe a la variable
--
---------------------------------------------------------------------------------------
*/
  PROCEDURE SUPP_VAR(p_type VARCHAR2);

/*
---------------------------------------------------------------------------------------
-- Nom           : SUPP_VAR
-- Date creation : 27/02/2002
-- Creee par     : SGN
-- Role          : Suppression d'une valeur de variable aster
-- Parametres    : p_type 	- type de la variable
-- 				   p_nom    - nom de la variable
--
-- Valeurs retournees
--
---------------------------------------------------------------------------------------
*/
  PROCEDURE SUPP_VAL_VAR(p_type VARCHAR2,
		  			 p_nom VARCHAR2);
END;

/

CREATE OR REPLACE PACKAGE GLOBAL IS
/*
---------------------------------------------------------------------------------------
-- Nom           : GLOBAL
-- ---------------------------------------------------------------------------
--  Auteur         : ---
--  Date creation  : --/--/1999
-- ---------------------------------------------------------------------------
-- Role          : Package des variables Globales ASTER
--
-- Type 		 : PACKAGE
-- ---------------------------------------------------------------------------
--  Version        : @(#) GLOBAL.sql version 2.1-1.0 : SNE : 10/08/2001
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) GLOBAL.sql 1.0-1.0	|10/08/2001 | SNE	| Création
-- @(#) GLOBAL.sql 2.0-1.1	|21/04/2001 | SNE	| Ajout variables pour traces
-- @(#) GLOBAL.sql 2.1-1.2	|03/09/2001 | SNE	| Correction ano 135 : ajout de  fonction pour lecture du prochaine USERID
----------------------------------------------------------------------------------------------------------------------------
-- Suivi des modifications
-- 05/08/2005 (UNILOG - FDUB) - V3.5A-1.1 : Ajout de la variable v_ide_lot, de la fonction ide_lot et de la procédure ini_ide_lot
-- Evo FA0043
----------------------------------------------------------------------------------------------------------------------------
*/
  /* variables */
  v_ide_util FH_UTIL.IDE_UTIL%TYPE;
  v_cod_util FH_UTIL.COD_UTIL%TYPE;
  v_ide_poste RM_POSTE.IDE_POSTE%TYPE;
  v_cod_typ_nd RM_POSTE.COD_TYP_ND%TYPE;
  v_ide_site RM_SITE_PHYSIQUE.IDE_SITE%TYPE;
  v_ide_gest FN_GESTION.IDE_GEST%TYPE;
  v_dat_jc FC_CALEND_HIST.DAT_JC%TYPE;
  v_db_instance VARCHAR2(15) := null;
  v_previous_window VARCHAR2(50) := null;
  v_current_item VARCHAR2(50) := null;
  v_current_record VARCHAR2(50) := null;
  v_acces VARCHAR2(1) := 'M';
  v_cod_typ_nd_emet FM_MESSAGE.COD_TYP_ND%TYPE;
  v_ide_nd_emet FM_MESSAGE.IDE_ND_EMET%TYPE;
  v_ide_mess FM_MESSAGE.IDE_MESS%TYPE;
  v_flg_emis_recu FM_MESSAGE.FLG_EMIS_RECU%TYPE;
  v_niveau_habilitation FH_SFO_PU.cod_permis%TYPE;
  v_dat_der_diff DATE := sysdate;
  v_terminal RM_POSTE.TERMINAL%TYPE;
  v_var_cpta FN_GESTION.VAR_CPTA%TYPE;
  v_var_tiers RB_TIERS.VAR_TIERS%TYPE;
  v_ide_tiers RB_TIERS.IDE_TIERS%TYPE;
  v_ide_edition VARCHAR2(30) := null;
  v_ide_ordo FB_ENG.IDE_ORDO%TYPE := null;
  v_cod_bud FB_ENG.COD_BUD%TYPE := null;
  v_ide_eng FB_ENG.IDE_ENG%TYPE := null;
  v_contexte SH_FONCTION.COD_CTX%TYPE := null;
  v_nbr_dec NUMBER;
  v_flg_emis_recu_dep FM_DEPECHE.FLG_EMIS_RECU%TYPE := null;
  v_ide_env FM_DEPECHE.IDE_ENV%TYPE := null;
  v_ide_site_emet FM_DEPECHE.IDE_SITE_EMET%TYPE := null;
  v_ide_site_dest FM_DEPECHE.IDE_SITE_DEST%TYPE := null;
  v_ide_depeche FM_DEPECHE.IDE_DEPECHE%TYPE;
  v_ide_fct SH_FONCTION.IDE_FCT%TYPE;
 -- Début FDUB le 05/08/2005 : Déclaration de la variable v_ide_lot référençant le champ IDE_LOT de la table FC_REGLEMENT
  v_ide_lot FC_REGLEMENT.IDE_LOT%TYPE;
 -- Fin FDUB le 05/08/2005

  /*
     -- SNE, 20/04/2001 : Ajout de nouvelles variables
 */
  v_niveau_trace NUMBER := 0;
  v_fichier_trace VARCHAR2(200) := NULL;

  /*
     -- SNE, 28/08/2001 : Correction ano 135 : ajout de  fonction pour lecture du prochaine USERID
 */
  v_mes_ide_util FH_UTIL.IDE_UTIL%TYPE;
  /* accès aux variables */
  FUNCTION ide_util RETURN NUMBER;
  FUNCTION cod_util RETURN VARCHAR2;
  FUNCTION ide_poste RETURN VARCHAR2;
  FUNCTION cod_typ_nd RETURN VARCHAR2;
  FUNCTION ide_site RETURN VARCHAR2;
  FUNCTION ide_gest RETURN VARCHAR2;
  FUNCTION dat_jc RETURN DATE;
  FUNCTION db_instance RETURN VARCHAR2;
  FUNCTION previous_window RETURN VARCHAR2;
  FUNCTION current_item RETURN VARCHAR2;
  FUNCTION current_record RETURN VARCHAR2;
  FUNCTION acces RETURN VARCHAR2;
  FUNCTION cod_typ_nd_emet RETURN VARCHAR2;
  FUNCTION ide_nd_emet RETURN VARCHAR2;
  FUNCTION ide_mess RETURN NUMBER;
  FUNCTION flg_emis_recu RETURN VARCHAR2;
  FUNCTION niveau_habilitation RETURN VARCHAR2;
  FUNCTION dat_der_diff RETURN DATE;
  FUNCTION terminal RETURN VARCHAR2;
  FUNCTION var_cpta RETURN VARCHAR2;
  FUNCTION var_tiers RETURN VARCHAR2;
  FUNCTION ide_tiers RETURN VARCHAR2;
  FUNCTION ide_edition RETURN VARCHAR2;
  FUNCTION ide_ordo RETURN VARCHAR2;
  FUNCTION cod_bud RETURN VARCHAR2;
  FUNCTION ide_eng RETURN VARCHAR2;
  FUNCTION contexte RETURN VARCHAR2;
  FUNCTION nbr_dec RETURN NUMBER;
  FUNCTION flg_emis_recu_dep RETURN CHAR;
  FUNCTION ide_env RETURN CHAR;
  FUNCTION ide_site_emet RETURN VARCHAR2;
  FUNCTION ide_site_dest RETURN VARCHAR2;
  FUNCTION ide_depeche RETURN NUMBER;
  FUNCTION ide_fct RETURN NUMBER;

  /*
     -- SNE, 20/04/2001 : Ajout de nouvelles variables
 */
  FUNCTION niveau_trace RETURN NUMBER;
  FUNCTION fichier_trace RETURN VARCHAR2;
  /*
     -- SNE, 28/08/2001 : Correction ano 135 : ajout de  fonction pour lecture du prochaine USERID
 */
  FUNCTION mes_ide_util RETURN NUMBER;
 -- Début FDUB le 05/08/2005 : Déclaration de la fonction ide_lot renvoyant un type "number"
  FUNCTION ide_lot RETURN NUMBER;
 -- Fin FDUB le 05/08/2005

  /* affectation des variables */
  PROCEDURE ini_ide_util(valeur NUMBER);
  PROCEDURE ini_cod_util(valeur VARCHAR2);
  PROCEDURE ini_ide_poste(valeur VARCHAR2);
  PROCEDURE ini_cod_typ_nd(valeur VARCHAR2);
  PROCEDURE ini_ide_site(valeur VARCHAR2);
  PROCEDURE ini_ide_gest(valeur VARCHAR2);
  PROCEDURE ini_dat_jc(valeur DATE);
  PROCEDURE ini_db_instance(valeur VARCHAR2);
  PROCEDURE ini_previous_window(valeur VARCHAR2);
  PROCEDURE ini_current_item(valeur VARCHAR2);
  PROCEDURE ini_current_record(valeur VARCHAR2);
  PROCEDURE ini_acces(valeur VARCHAR2);
  PROCEDURE ini_cod_typ_nd_emet(valeur VARCHAR2);
  PROCEDURE ini_ide_nd_emet(valeur VARCHAR2);
  PROCEDURE ini_ide_mess(valeur NUMBER);
  PROCEDURE ini_flg_emis_recu(valeur VARCHAR2);
  PROCEDURE ini_niveau_habilitation(valeur VARCHAR2);
  PROCEDURE ini_dat_der_diff(valeur DATE);
  PROCEDURE ini_terminal(valeur VARCHAR2);
  PROCEDURE ini_var_cpta(valeur VARCHAR2);
  PROCEDURE ini_var_tiers(valeur VARCHAR2);
  PROCEDURE ini_ide_tiers(valeur VARCHAR2);
  PROCEDURE ini_ide_edition(valeur VARCHAR2);
  PROCEDURE ini_ide_ordo(valeur VARCHAR2);
  PROCEDURE ini_cod_bud(valeur VARCHAR2);
  PROCEDURE ini_ide_eng(valeur VARCHAR2);
  PROCEDURE ini_contexte(valeur VARCHAR2);
  PROCEDURE ini_nbr_dec(valeur NUMBER);
  PROCEDURE ini_flg_emis_recu_dep(valeur CHAR);
  PROCEDURE ini_ide_env(valeur CHAR);
  PROCEDURE ini_ide_site_emet(valeur VARCHAR2);
  PROCEDURE ini_ide_site_dest(valeur VARCHAR2);
  PROCEDURE ini_ide_depeche(valeur NUMBER);
  PROCEDURE ini_ide_fct(valeur NUMBER);
  /*
     -- SNE, 20/04/2001 : Ajout de nouvelles variables
 */
  PROCEDURE  ini_niveau_trace(valeur NUMBER);
  PROCEDURE  ini_fichier_trace(valeur VARCHAR2);
  /*
     -- SNE, 28/08/2001 : Correction ano 135 : ajout de  fonction pour lecture du prochaine USERID
 */
  PROCEDURE  ini_mes_ide_util(valeur IN NUMBER := NULL);

 -- Début FDUB le 05/08/2005 : Déclaration de la procedure ini_ide_lot avec pour paramètre d'entrée "valeur" de type "number"
  PROCEDURE ini_ide_lot(valeur NUMBER);
 -- Fin FDUB le 05/08/2005




END GLOBAL;

/

CREATE OR REPLACE PACKAGE security IS
  FUNCTION encrypt(in_val VARCHAR2, crypt_mask VARCHAR2) RETURN VARCHAR2;
  FUNCTION unencrypt(in_val VARCHAR2, crypt_mask VARCHAR2) RETURN VARCHAR2;
  FUNCTION convbin(c1 char) RETURN CHAR;
  FUNCTION XORBIN(c1 char,c2 char) RETURN CHAR;
  FUNCTION sec_parki(p_param OUT CHAR) RETURN BINARY_INTEGER;
  FUNCTION sec_prmsk(p_param OUT CHAR) RETURN BINARY_INTEGER;
END;

/

CREATE OR REPLACE PACKAGE TIERS IS
  /* variables */
  v_var_tiers RB_TIERS.VAR_TIERS%TYPE := null;
  v_ide_tiers RB_TIERS.IDE_TIERS%TYPE := null;
  v_cod_cat_sociop RB_TIERS.COD_CAT_SOCIOP%TYPE := null;
  v_cod_sec RB_TIERS.COD_SEC%TYPE := null;
  v_nom_contrib RB_TIERS.NOM_CONTRIB%TYPE := null;
  v_cod_typ_tiers RB_TIERS.COD_TYP_TIERS%TYPE := null;
  v_nom RB_TIERS.NOM%TYPE := null;
  v_prenom RB_TIERS.PRENOM%TYPE := null;
  v_ville RB_TIERS.VILLE%TYPE := null;
  v_adr1 RB_TIERS.ADR1%TYPE := null;
  v_adr2 RB_TIERS.ADR2%TYPE := null;
  v_adr3 RB_TIERS.ADR3%TYPE := null;
  v_adr4 RB_TIERS.ADR4%TYPE := null;
  v_pays RB_TIERS.PAYS%TYPE := null;
  v_bp RB_TIERS.BP%TYPE := null;
  v_cp RB_TIERS.CP%TYPE := null;
  v_teleph RB_TIERS.TELEPH%TYPE := null;
  /* accès aux variables */
  FUNCTION var_tiers RETURN VARCHAR2;
  FUNCTION ide_tiers RETURN VARCHAR2;
  FUNCTION cod_cat_sociop RETURN VARCHAR2;
  FUNCTION cod_sec RETURN VARCHAR2;
  FUNCTION nom_contrib RETURN VARCHAR2;
  FUNCTION cod_typ_tiers RETURN CHAR;
  FUNCTION nom RETURN VARCHAR2;
  FUNCTION prenom RETURN VARCHAR2;
  FUNCTION ville RETURN VARCHAR2;
  FUNCTION adr1 RETURN VARCHAR2;
  FUNCTION adr2 RETURN VARCHAR2;
  FUNCTION adr3 RETURN VARCHAR2;
  FUNCTION adr4 RETURN VARCHAR2;
  FUNCTION pays RETURN VARCHAR2;
  FUNCTION bp RETURN VARCHAR2;
  FUNCTION cp RETURN VARCHAR2;
  FUNCTION teleph RETURN VARCHAR2;
  /* affectation des variables */
  PROCEDURE ini_var_tiers(valeur VARCHAR2);
  PROCEDURE ini_ide_tiers(valeur VARCHAR2);
  PROCEDURE ini_cod_cat_sociop(valeur VARCHAR2);
  PROCEDURE ini_cod_sec(valeur VARCHAR2);
  PROCEDURE ini_nom_contrib(valeur VARCHAR2);
  PROCEDURE ini_cod_typ_tiers(valeur CHAR);
  PROCEDURE ini_nom(valeur VARCHAR2);
  PROCEDURE ini_prenom(valeur VARCHAR2);
  PROCEDURE ini_ville(valeur VARCHAR2);
  PROCEDURE ini_adr1(valeur VARCHAR2);
  PROCEDURE ini_adr2(valeur VARCHAR2);
  PROCEDURE ini_adr3(valeur VARCHAR2);
  PROCEDURE ini_adr4(valeur VARCHAR2);
  PROCEDURE ini_pays(valeur VARCHAR2);
  PROCEDURE ini_bp(valeur VARCHAR2);
  PROCEDURE ini_cp(valeur VARCHAR2);
  PROCEDURE ini_teleph(valeur VARCHAR2);
END TIERS;

/
CREATE OR REPLACE PACKAGE BODY ASTER_VAR IS
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_VAR
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 27/02/2002
-- ---------------------------------------------------------------------------
-- Role          : Corps de package pour la gestion des variables utilisé par les batchs
--                 On considere les variables aster comme des traitements et la valeur de la variable
--                 comme un parametre donné a ce traitement
--
-- Type 		 : Corps de PACKAGE
-- ---------------------------------------------------------------------------
--  Version        : @(#) Aster_var_body.sql version 3.0-1.0
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) Aster_var_body.sql  3.0-1.0	|20/02/2002 | SGN	| Création
---------------------------------------------------------------------------------------
*/
PROCEDURE CREE_VAR(p_type VARCHAR2, p_nom VARCHAR2, p_val VARCHAR2) IS
/*
---------------------------------------------------------------------------------------
-- Nom           : CREE_VAR
-- Date creation : 27/02/2002
-- Creee par     : SGN
-- Role          : Cree une variable aster si elle n existe pas, mise a jour sinon => Alimentation
--                 de B_TRAITEMENT et B_PARAMTRT. La valeur ne doit pas etre null sinon c est une erreur
-- Parametres    : p_type 	  - type de variable aster a ajouter
-- 				   p_nom      - nom de la variable aster a ajouter
-- 				   p_val	  - valeur de la variable aster a ajouter
--
-- Valeurs retournees
--
---------------------------------------------------------------------------------------
*/
v_numtrt B_TRAITEMENT.numtrt%TYPE := NULL;
v_indpar B_PARAMTRT.indpar%TYPE;
v_terminal  FH_UTIL.terminal%TYPE;
v_val B_PARAMTRT.param%TYPE := NULL;
v_new_var VARCHAR2(1) := 'N';
v_new_val VARCHAR2(1) := 'N';

NULL_ERREUR EXCEPTION;

BEGIN
  -- On verifie que la valeur de la variable a creer est non null
  IF p_val IS NULL THEN
    RAISE NULL_ERREUR;
  END IF;

  -- On identifie si la variable aster est deja definie
  -- Si c'est le cas, on recupere le numtrt
  ASTER_VAR.get_var(p_type, p_nom, v_val, v_numtrt);

  -- Si la variable n'est pas encore definie, on calcul le numero sequence a  affecter
  -- au numero de traitement
  IF v_numtrt IS NULL THEN
  	 v_new_var := 'O';
	 BEGIN
  	 	  SELECT SEQ_B_TRAITEMENT.NEXTVAL
		  INTO v_numtrt
	   	  FROM DUAL;
  	 EXCEPTION
     	  WHEN OTHERS THEN
			  RAISE;
     END;
  ELSE
     v_new_var := 'N';
  END IF;

  -- On determine s il s'agit ou non d une nouvelle variable
  IF v_val IS NULL THEN
    v_new_val := 'O';
  ELSE
    v_new_val := 'N';
  END IF;

  -- Recuperation de l'indice max du parametre pour le numero de traitement
  BEGIN
  	   SELECT NVL(MAX(indpar),0)+1
	   INTO v_indpar
	   FROM B_PARAMTRT
	   WHERE numtrt = v_numtrt;
  EXCEPTION
  	   WHEN OTHERS THEN
	   	   RAISE;
  END;

  -- Recuperation du terminal
  BEGIN
  	   SELECT NVL(USERENV('TERMINAL'), 'unknown')
	   INTO v_terminal
	   FROM DUAL;
  EXCEPTION
       WHEN OTHERS THEN
	   	   RAISE;
  END;

  -- Insertion de la variable aster dans B_TRAITEMENT si elle n
  IF v_new_var = 'O' THEN
  	BEGIN
    	 INSERT INTO B_TRAITEMENT ( NUMTRT
	                            , NOMPROG
 	                            , DIR_PROG
	                            , DAT_CRE
	                            , UTI_CRE
	                            , DAT_MAJ
	                            , UTI_MAJ
	                            , TERMINAL)
	     VALUES ( v_numtrt
		       , p_type
	           , 'X'
	           , SYSDATE
		       , user
		       , SYSDATE
		       , user
		       , v_terminal
		 );
	EXCEPTION
	    WHEN OTHERS THEN
			RAISE;
  	END;
  END IF;


  -- Insertion de la valeur de la variable dans B_PARAMTRT ou mise a jour
  IF v_new_val = 'O' THEN
  	 BEGIN
	   INSERT INTO B_PARAMTRT(NUMTRT,
		                      INDPAR,
							  NOMPARAM,
							  PARAM,
							  DAT_CRE,
							  UTI_CRE,
							  DAT_MAJ,
							  UTI_MAJ,
							  TERMINAL)
		VALUES (v_numtrt,
				v_indpar,
				p_nom,
				p_val,
				SYSDATE,
				USER,
				SYSDATE,
				USER,
				v_terminal);
  	EXCEPTION
		WHEN OTHERS THEN
			RAISE;
  	END;
  -- mise a jour de la variable existante
  ELSE
  	BEGIN
		 UPDATE B_PARAMTRT
		 SET param = p_val
		 WHERE numtrt = v_numtrt
		   AND nomparam = p_nom;
	EXCEPTION
		WHEN OTHERS THEN
			RAISE;
	END;
  END IF;

  -- Validation des mises a jour
  COMMIT;
EXCEPTION
      WHEN NULL_ERREUR THEN
          ROLLBACK;
	    RAISE;
	WHEN OTHERS THEN
	    ROLLBACK;
	    RAISE;
END;

PROCEDURE GET_VAR(p_type VARCHAR2, p_nom VARCHAR2, p_val IN OUT VARCHAR2, p_numtrt IN OUT VARCHAR2) IS
/*
---------------------------------------------------------------------------------------
-- Nom           : GET_VAR
-- Date creation : 27/02/2002
-- Creee par     : SGN
-- Role          : Recuperation de la valeur d'une variable aster et de son numero de traitement
-- Parametres    : p_type 	  	  - type de la variable
-- 				   p_nom      - nom de la variable aster a ajouter
--                 p_val    - valeur de la variable
--                 p_numtrt  - numero de traitement associe a la variable
--
-- Valeurs retournees : p_val - valeur de la variable
--                      p_numtrt - numero du traitement associe a la variable
--
---------------------------------------------------------------------------------------
*/
v_numtrt B_TRAITEMENT.numtrt%TYPE;
v_val B_PARAMTRT.param%TYPE;
BEGIN
  -- On identifie si la variable aster est deja definie dans B_TRAITEMENT
  -- Si c'est le cas, on recupere le numtrt
  -- On suppose que la variable ne peut être créé deux fois
  BEGIN
  	   SELECT numtrt
	   INTO v_numtrt
	   FROM B_TRAITEMENT
	   WHERE nomprog = p_type;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
	   	   v_numtrt := NULL;
       WHEN OTHERS THEN
	   	   RAISE;
  END;

  IF v_numtrt IS NULL THEN
    p_numtrt := NULL;
	p_val := NULL;
  ELSE
    -- Affectation du numero de traitement de la variable aster
	p_numtrt := v_numtrt;

	-- Recuperation de la valeur de la variable aster si elle existe
    BEGIN
		 SELECT param
		 INTO v_val
		 FROM B_PARAMTRT
		 WHERE numtrt = v_numtrt
		   AND nomparam = p_nom;

		 -- Affectation de la valeur de la variable aster
		 p_val := v_val;
	EXCEPTION
		 WHEN NO_DATA_FOUND THEN
		     p_val := NULL;
		 WHEN OTHERS THEN
		 	 RAISE;
	END;
  END IF;

EXCEPTION
	WHEN OTHERS THEN
		RAISE;
END;

PROCEDURE SUPP_VAR(p_type VARCHAR2) IS
/*
---------------------------------------------------------------------------------------
-- Nom           : SUPP_VAR
-- Date creation : 27/02/2002
-- Creee par     : SGN
-- Role          : Suppression d'une variable aster et des ses valeurs
-- Parametres    : p_type 	- type de la variable
--
-- Valeurs retournees
--
---------------------------------------------------------------------------------------
*/
v_numtrt B_TRAITEMENT.numtrt%TYPE;
v_val B_PARAMTRT.param%TYPE;
BEGIN
	-- Recuperation du numero de traitement de la variable
	ASTER_VAR.get_var(p_type, NULL, v_val, v_numtrt);

	-- la variable existe on la supprime
	IF v_numtrt IS NOT NULL THEN
      -- Suppression des valeurs
	  BEGIN
	  	   DELETE FROM B_PARAMTRT
	  	   WHERE numtrt = v_numtrt;
	  EXCEPTION
	       WHEN OTHERS THEN
		       RAISE;
	  END;

	  -- Suppression de la variable
	  BEGIN
	   	   DELETE FROM B_TRAITEMENT
		   WHERE numtrt = v_numtrt;
	  EXCEPTION
	       WHEN OTHERS THEN
		       RAISE;
	  END;

	  -- Validation des mises a jour
	  COMMIT;

	END IF;

EXCEPTION
	WHEN OTHERS THEN
	    ROLLBACK;
		RAISE;
END;


PROCEDURE SUPP_VAL_VAR(p_type VARCHAR2, p_nom VARCHAR2) IS
/*
---------------------------------------------------------------------------------------
-- Nom           : SUPP_VAR
-- Date creation : 27/02/2002
-- Creee par     : SGN
-- Role          : Suppression d'une valeur de variable aster
-- Parametres    : p_type 	- type de la variable
-- 				   p_nom    - nom de la variable
--
-- Valeurs retournees
--
---------------------------------------------------------------------------------------
*/
v_numtrt B_TRAITEMENT.numtrt%TYPE;
v_val B_PARAMTRT.param%TYPE;
BEGIN
	-- Recuperation du numero de traitement de la variable
	ASTER_VAR.get_var(p_type, p_nom, v_val, v_numtrt);

	-- la variable existe on la supprime
	IF v_numtrt IS NOT NULL AND v_val IS NOT NULL THEN
      -- Suppression des valeurs
	  BEGIN
	  	   DELETE FROM B_PARAMTRT
	  	   WHERE numtrt = v_numtrt
		     AND nomparam = p_nom;
	  EXCEPTION
	       WHEN OTHERS THEN
		       RAISE;
	  END;

	  -- Validation des mises a jour
	  COMMIT;

	END IF;

EXCEPTION
	WHEN OTHERS THEN
	    ROLLBACK;
		RAISE;
END;

END;

/

CREATE OR REPLACE PACKAGE BODY GLOBAL IS
/*
---------------------------------------------------------------------------------------
-- Nom           : GLOBAL_BODY
-- ---------------------------------------------------------------------------
--  Auteur         : ---
--  Date creation  : --/--/1999
-- ---------------------------------------------------------------------------
-- Role          : Package des variables Globales ASTER
--
-- Type 		 : Corps de PACKAGE
-- ---------------------------------------------------------------------------
--  Version        : @(#) GLOBAL_BODY.sql version 2.1-1.2 : SNE : 03/09/2001
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) GLOBAL_BODY.sql 1.0-1.0	|10/08/2001 | SNE	| Création
-- @(#) GLOBAL_BODY.sql 2.0-1.1	|21/04/2001 | SNE	| Ajout variables pour traces
-- @(#) GLOBAL_BODY.sql 2.1-1.2	|03/09/2001 | SNE	| Correction ano 135 : ajout de  fonction pour lecture du prochaine USERID
----------------------------------------------------------------------------------------------------------------------------------
-- Suivi des modifications
-- 05/08/2005 (UNILOG - FDUB) - V3.5A-1.1 : Ajout du corps de la fonction ide_lot et de la procédure ini_ide_lot
-- Evo FA0043
------------------------------------------------------------------------------------------------------------
*/
  FUNCTION ide_util RETURN NUMBER IS
  BEGIN
    return v_ide_util;
  END;
  FUNCTION cod_util RETURN VARCHAR2 IS
  BEGIN
    return v_cod_util;
  END;
  FUNCTION ide_poste RETURN VARCHAR2 IS
  BEGIN
    return v_ide_poste;
  END;
  FUNCTION cod_typ_nd RETURN VARCHAR2 IS
  BEGIN
    return v_cod_typ_nd;
  END;
  FUNCTION ide_site RETURN VARCHAR2 IS
  BEGIN
    return v_ide_site;
  END;
  FUNCTION ide_gest RETURN VARCHAR2 IS
  BEGIN
    return v_ide_gest;
  END;
  FUNCTION dat_jc RETURN DATE IS
  BEGIN
    return v_dat_jc;
  END;
  FUNCTION db_instance RETURN VARCHAR2 IS
  BEGIN
    return v_db_instance;
  END;
  FUNCTION previous_window RETURN VARCHAR2 IS
  BEGIN
    return v_previous_window;
  END;
  FUNCTION current_item RETURN VARCHAR2 IS
  BEGIN
    return v_current_item;
  END;
  FUNCTION current_record RETURN VARCHAR2 IS
  BEGIN
    return v_current_record;
  END;
  FUNCTION acces RETURN VARCHAR2 IS
  BEGIN
    return v_acces;
  END;
  FUNCTION cod_typ_nd_emet RETURN VARCHAR2 IS
  BEGIN
    return v_cod_typ_nd_emet;
  END;
  FUNCTION ide_nd_emet RETURN VARCHAR2 IS
  BEGIN
    return v_ide_nd_emet;
  END;
  FUNCTION ide_mess RETURN NUMBER IS
  BEGIN
    return v_ide_mess;
  END;
  FUNCTION flg_emis_recu RETURN VARCHAR2 IS
  BEGIN
    return v_flg_emis_recu;
  END;
  FUNCTION niveau_habilitation RETURN VARCHAR2 IS
  BEGIN
    return v_niveau_habilitation;
  END;
  FUNCTION dat_der_diff RETURN DATE IS
  BEGIN
    return v_dat_der_diff;
  END;
  FUNCTION terminal RETURN VARCHAR2 IS
  BEGIN
    return v_terminal;
  END;
  FUNCTION var_cpta RETURN VARCHAR2 IS
  BEGIN
    return v_var_cpta;
  END;
  FUNCTION var_tiers RETURN VARCHAR2 IS
  BEGIN
    return v_var_tiers;
  END;
  FUNCTION ide_tiers RETURN VARCHAR2 IS
  BEGIN
    return v_ide_tiers;
  END;
  FUNCTION ide_edition RETURN VARCHAR2 IS
  BEGIN
    return v_ide_edition;
  END;
  FUNCTION ide_ordo RETURN VARCHAR2 IS
  BEGIN
    return v_ide_ordo;
  END;
  FUNCTION cod_bud RETURN VARCHAR2 IS
  BEGIN
    return v_cod_bud;
  END;
  FUNCTION ide_eng RETURN VARCHAR2 IS
  BEGIN
    return v_ide_eng;
  END;
  FUNCTION contexte RETURN VARCHAR2 IS
  BEGIN
    return v_contexte;
  END;
  FUNCTION nbr_dec RETURN NUMBER IS
  BEGIN
    return v_nbr_dec;
  END;
  FUNCTION flg_emis_recu_dep RETURN CHAR IS
  BEGIN
    return v_flg_emis_recu_dep;
  END;
  FUNCTION ide_env RETURN CHAR IS
  BEGIN
    return v_ide_env;
  END;
  FUNCTION ide_site_emet RETURN VARCHAR2 IS
  BEGIN
    return v_ide_site_emet;
  END;
  FUNCTION ide_site_dest RETURN VARCHAR2 IS
  BEGIN
    return v_ide_site_dest;
  END;
  FUNCTION ide_depeche RETURN NUMBER IS
  BEGIN
    return v_ide_depeche;
  END;
  FUNCTION ide_fct RETURN NUMBER IS
  BEGIN
    return v_ide_fct;
  END;

  /*
  	-- SNE, 20/04/2001 : Mise en place de traces
  */
  FUNCTION niveau_trace RETURN NUMBER IS
  BEGIN
    return(v_niveau_trace);
  END;

  FUNCTION fichier_trace RETURN VARCHAR2 IS
  BEGIN
  	   return(v_fichier_trace);
  END;

  /*
     -- SNE, 28/08/2001 : Correction ano 135 : ajout de  fonction pour lecture du prochaine USERID
 */
  FUNCTION mes_ide_util RETURN NUMBER IS
  BEGIN
  	   IF v_mes_ide_util IS NULL THEN
	   	  SELECT NVL(SEQ_IDE_UTIL.CURRVAL, SEQ_IDE_UTIL.NEXTVAL)  INTO v_mes_ide_util FROM DUAL;
	   END IF;
	   RETURN(v_mes_ide_util);
  END;

 -- Début FDUB le 05/08/2005 : Déclaration du corps de la fonction ide_lot
  FUNCTION ide_lot RETURN NUMBER IS
  BEGIN
    return v_ide_lot;
  END;
 -- Fin FDUB le 05/08/2005

  /* affectation des variables */
  PROCEDURE ini_ide_util(valeur NUMBER) IS
  BEGIN
    v_ide_util := valeur;
  END;
  PROCEDURE ini_cod_util(valeur VARCHAR2) IS
  BEGIN
    v_cod_util := valeur;
  END;
  PROCEDURE ini_ide_poste(valeur VARCHAR2) IS
  BEGIN
    v_ide_poste := valeur;
  END;
  PROCEDURE ini_cod_typ_nd(valeur VARCHAR2) IS
  BEGIN
    v_cod_typ_nd := valeur;
  END;
  PROCEDURE ini_ide_site(valeur VARCHAR2) IS
  BEGIN
    v_ide_site := valeur;
  END;
  PROCEDURE ini_ide_gest(valeur VARCHAR2) IS
  BEGIN
    v_ide_gest := valeur;
  END;
  PROCEDURE ini_dat_jc(valeur DATE) IS
  BEGIN
    v_dat_jc := valeur;
  END;
  PROCEDURE ini_db_instance(valeur VARCHAR2) IS
  BEGIN
    v_db_instance := valeur;
  END;
  PROCEDURE ini_previous_window(valeur VARCHAR2) IS
  BEGIN
    v_previous_window := valeur;
  END;
  PROCEDURE ini_current_item(valeur VARCHAR2) IS
  BEGIN
    v_current_item := valeur;
  END;
  PROCEDURE ini_current_record(valeur VARCHAR2) IS
  BEGIN
    v_current_record := valeur;
  END;
  PROCEDURE ini_acces(valeur VARCHAR2) IS
  BEGIN
    v_acces := valeur;
  END;
  PROCEDURE ini_cod_typ_nd_emet(valeur VARCHAR2) IS
  BEGIN
    v_cod_typ_nd_emet := valeur;
  END;
  PROCEDURE ini_ide_nd_emet(valeur VARCHAR2) IS
  BEGIN
    v_ide_nd_emet := valeur;
  END;
  PROCEDURE ini_ide_mess(valeur NUMBER) IS
  BEGIN
    v_ide_mess := valeur;
  END;
  PROCEDURE ini_flg_emis_recu(valeur VARCHAR2) IS
  BEGIN
    v_flg_emis_recu := valeur;
  END;
  PROCEDURE ini_niveau_habilitation(valeur VARCHAR2) IS
  BEGIN
    v_niveau_habilitation := valeur;
  END;
  PROCEDURE ini_dat_der_diff(valeur DATE) IS
  BEGIN
    v_dat_der_diff := valeur;
  END;
  PROCEDURE ini_terminal(valeur VARCHAR2) IS
  BEGIN
    v_terminal := valeur;
  END;
  PROCEDURE ini_var_cpta(valeur VARCHAR2) IS
  BEGIN
    v_var_cpta := valeur;
  END;
  PROCEDURE ini_var_tiers(valeur VARCHAR2) IS
  BEGIN
    v_var_tiers := valeur;
  END;
  PROCEDURE ini_ide_tiers(valeur VARCHAR2) IS
  BEGIN
    v_ide_tiers := valeur;
  END;
  PROCEDURE ini_ide_edition(valeur VARCHAR2) IS
  BEGIN
    v_ide_edition := valeur;
  END;
  PROCEDURE ini_ide_ordo(valeur VARCHAR2) IS
  BEGIN
    v_ide_ordo := valeur;
  END;
  PROCEDURE ini_cod_bud(valeur VARCHAR2) IS
  BEGIN
    v_cod_bud := valeur;
  END;
  PROCEDURE ini_ide_eng(valeur VARCHAR2) IS
  BEGIN
    v_ide_eng := valeur;
  END;
  PROCEDURE ini_contexte(valeur VARCHAR2) IS
  BEGIN
    v_contexte := valeur;
  END;
  PROCEDURE ini_nbr_dec(valeur NUMBER) IS
  BEGIN
    v_nbr_dec := valeur;
  END;
  PROCEDURE ini_flg_emis_recu_dep(valeur CHAR) IS
  BEGIN
    v_flg_emis_recu_dep := valeur;
  END;
  PROCEDURE ini_ide_env(valeur CHAR) IS
  BEGIN
    v_ide_env := valeur;
  END;
  PROCEDURE ini_ide_site_emet(valeur VARCHAR2) IS
  BEGIN
    v_ide_site_emet := valeur;
  END;
  PROCEDURE ini_ide_site_dest(valeur VARCHAR2) IS
  BEGIN
    v_ide_site_dest := valeur;
  END;
  PROCEDURE ini_ide_depeche(valeur NUMBER) IS
  BEGIN
    v_ide_depeche := valeur;
  END;
  PROCEDURE ini_ide_fct(valeur NUMBER) IS
  BEGIN
    v_ide_fct := valeur;
  END;
  /*
  	-- SNE, 20/04/2001 : Ajout des fonctions pour traces
  */
  PROCEDURE ini_niveau_trace(valeur NUMBER) IS
  BEGIN
  	   v_niveau_trace := valeur;
  END;

  PROCEDURE ini_fichier_trace(valeur VARCHAR2) IS
  BEGIN
  	   v_fichier_trace := valeur;
  END;
  /*
     -- SNE, 28/08/2001 : Correction ano 135 : ajout de  fonction pour lecture du prochaine USERID
 */
  PROCEDURE ini_mes_ide_util(valeur NUMBER) IS
  BEGIN
  	   IF valeur IS NULL THEN
	   	  SELECT SEQ_IDE_UTIL.NEXTVAL INTO v_mes_ide_util FROM DUAL;
	   ELSE
	   	   v_mes_ide_util := valeur;
	   END IF;
  END;

 -- Début FDUB le 05/08/2005 : Déclaration du corps de la procedure ini_ide_lot
  PROCEDURE ini_ide_lot(valeur NUMBER) IS
  BEGIN
    v_ide_lot := valeur;
  END;
 -- Fin FDUB le 05/08/2005

END GLOBAL;

/

CREATE OR REPLACE PACKAGE BODY security IS

  --  Parameters :   in_val to be crypted.
  --   crypt_mask value used to crypt in_val
  --
  --  Return Values : encrypted value
  --
  --  Purpose :  Encrypts a value based on a specified input mask.
  --
  --  Dependencies :  crypt_mask must be >= in size to in_val
  --
  -- 10/03/2000 : FA --> modification car si saisie mot de passe
  --                     commencant comme crypt_mask, alors mot
  --                     de passe nul - masque commencant par azer..
  --                     trop risque : choix d'une clé plus complexe
  FUNCTION encrypt(in_val VARCHAR2, crypt_mask VARCHAR2) RETURN VARCHAR2 IS
      v_key VARCHAR2(30);
	  v_ret number;
	  v_msk VARCHAR2(30);
  BEGIN
    v_ret := sec_parki(v_key);
	if v_ret = 0 THEN
	    v_ret := sec_prmsk(v_msk);
	END IF;
	IF v_ret != 0 THEN
	   RETURN NULL;
	END IF;

    IF crypt_mask != v_msk THEN
      RETURN NULL;
    END IF;

    -- Must be greater or equal to the value that will be crypted
    IF LENGTH(v_key) < LENGTH(in_val) THEN
      RETURN NULL;
    ELSE
      RETURN (XORBIN(in_val, v_key)); /* "Crypt" */
    END IF;
  END;

  --  Parameters :  in_val to be unencrypted.
  --    crypt_mask value used to unencrypt in_val
  --
  --  Return Values : un-encrypted value
  --
  --  Purpose :  Un-encrypted in_val previously crypted with the crypt function (see above)
  --
  --  Dependencies :  used crypt function before, and mask is the same
  --
  -- 10/03/2000 : FA --> modification car si saisie mot de passe
  --                     commencant comme crypt_mask, alors mot
  --                     de passe nul - masque commencant par azer..
  --                     trop risque : choix d'une clé plus complexe
  FUNCTION unencrypt(in_val VARCHAR2, crypt_mask VARCHAR2) RETURN VARCHAR2 IS
      v_key VARCHAR2(30);
	  v_ret number;
	  v_msk VARCHAR2(30);
  BEGIN
    v_ret := sec_parki(v_key);
	if v_ret = 0 THEN
	    v_ret := sec_prmsk(v_msk);
	END IF;
	IF v_ret != 0 THEN
	   RETURN NULL;
	END IF;

    IF crypt_mask != v_msk THEN
      RETURN NULL;
    END IF;

    RETURN(XORBIN(in_val, v_key)); /* "Un-Encrypt" */
  END;

  --  Parameters :  c1, character to be converted to a binary value
  --  Return Values : binary equiv of c1
  --
  --  Purpose :  Used during crypt/unencrypt
  --
  FUNCTION convbin(c1 char) RETURN CHAR IS
    loop1 number;
    value number;
    divis number;
    r1 varchar2(30);
  BEGIN
    r1 := '';
    value := ASCII(c1);
    divis := 128;

    FOR loop1 IN 0..7 LOOP
      IF TRUNC(value/divis) = 1 THEN
        r1 := r1 || '1';
      ELSE
        r1 := r1 || '0';
      END IF;

      value := value mod divis;
      divis := divis / 2;
    END LOOP;

    RETURN r1;
  END;


  --  Parameters :  c1 and c2
  --  Return Values : xors c2 with c1
  --
  --  Purpose :  Used during encryption
  --
  --  Dependencies :  c1 and c2 similar sizes
  --
  FUNCTION XORBIN(c1 char,c2 char) RETURN CHAR IS
    loop1 NUMBER;
    loop11 NUMBER;
    r1 VARCHAR2(8);
    r2 VARCHAR2(8);
    r3 NUMBER;
    result VARCHAR2(40);
    divis NUMBER;
  BEGIN

    result := '';

    FOR loop1 IN 1..length(c1) LOOP

      r1 := convbin(substr(c1,loop1,1));
      r2 := convbin(substr(c2,loop1,1));
      divis := 128;
      r3 := 0;

      FOR loop11 IN 1..8 LOOP
        IF TO_NUMBER(substr(r1,loop11,1)) + TO_NUMBER(substr(r2,loop11,1))=1 THEN
          r3 := r3 + divis;
        END IF;
        divis := divis / 2;
      END LOOP;

      result := result || chr(r3);
    END LOOP;
    RETURN(result);
  END XORBIN;

   FUNCTION sec_prmsk(p_param OUT CHAR)
	/*
	---------------------------------------------------------------------------------------
	-- Nom           : ASTER_sec_parms
	-- ---------------------------------------------------------------------------
	--  Auteur         : SNE
	--  Date creation  : 27/09/2002
	-- ---------------------------------------------------------------------------
	-- Role          : Paramétres de sécurité ASTER
	--		       (librairie PIAF_system)
	-- Parametres    : voir librairie
	--
	-- Valeur retournee : 0 - OK
	--                    Autre - Probleme
	-- Appels		 :
	-- ---------------------------------------------------------------------------
	--  Version        : @(#) ASTER_sec_parms.sql version 2.2-1.0
	-- ---------------------------------------------------------------------------
	--
	-- 	--------------------------------------------------------------------
	-- 	Fonction					   	|Date	    |Initiales	|Commentaires
	-- 	--------------------------------------------------------------------
	-- @(#) ASTER_sec_parms.sql 1.0	|27/09/2002 | SNE	| Création
	---------------------------------------------------------------------------------------
	*/
	  RETURN BINARY_INTEGER
		AS EXTERNAL LIBRARY PIAF_system
			    NAME "ASTER_get_crypt_masque"
			    LANGUAGE C;

	FUNCTION sec_parki(p_param OUT CHAR)
	/*
	---------------------------------------------------------------------------------------
	-- Nom           : ASTER_sec_parki
	-- ---------------------------------------------------------------------------
	--  Auteur         : SNE
	--  Date creation  : 27/09/2002
	-- ---------------------------------------------------------------------------
	-- Role          : Paramétres de sécurité ASTER
	--		       (librairie PIAF_system)
	-- Parametres    : voir librairie
	--
	-- Valeur retournee : 0 - OK
	--                    Autre - Probleme
	-- Appels		 :
	-- ---------------------------------------------------------------------------
	--  Version        : @(#) ASTER_sec_parki.sql version 2.2-1.0
	-- ---------------------------------------------------------------------------
	--
	-- 	--------------------------------------------------------------------
	-- 	Fonction					   	|Date	    |Initiales	|Commentaires
	-- 	--------------------------------------------------------------------
	-- @(#) ASTER_sec_parki.sql 1.0	|27/09/2002 | SNE	| Création
	---------------------------------------------------------------------------------------
	*/
	  RETURN BINARY_INTEGER
		AS EXTERNAL LIBRARY PIAF_system
			    NAME "ASTER_get_crypt_key"
			    LANGUAGE C;
END;

/

CREATE OR REPLACE PACKAGE BODY TIERS IS
  FUNCTION var_tiers RETURN VARCHAR2 IS
  BEGIN
    RETURN v_var_tiers;
  END;
  FUNCTION ide_tiers RETURN VARCHAR2 IS
  BEGIN
    RETURN v_ide_tiers;
  END;
  FUNCTION cod_cat_sociop RETURN VARCHAR2 IS
  BEGIN
    RETURN v_cod_cat_sociop;
  END;
  FUNCTION cod_sec RETURN VARCHAR2 IS
  BEGIN
    RETURN v_cod_sec;
  END;
  FUNCTION nom_contrib RETURN VARCHAR2 IS
  BEGIN
    RETURN v_nom_contrib;
  END;
  FUNCTION cod_typ_tiers RETURN CHAR IS
  BEGIN
    RETURN v_cod_typ_tiers;
  END;
  FUNCTION nom RETURN VARCHAR2 IS
  BEGIN
    RETURN v_nom;
  END;
  FUNCTION prenom RETURN VARCHAR2 IS
  BEGIN
    RETURN v_prenom;
  END;
  FUNCTION ville RETURN VARCHAR2 IS
  BEGIN
    RETURN v_ville;
  END;
  FUNCTION adr1 RETURN VARCHAR2 IS
  BEGIN
    RETURN v_adr1;
  END;
  FUNCTION adr2 RETURN VARCHAR2 IS
  BEGIN
    RETURN v_adr2;
  END;
  FUNCTION adr3 RETURN VARCHAR2 IS
  BEGIN
    RETURN v_adr3;
  END;
  FUNCTION adr4 RETURN VARCHAR2 IS
  BEGIN
    RETURN v_adr4;
  END;
  FUNCTION pays RETURN VARCHAR2 IS
  BEGIN
    RETURN v_pays;
  END;
  FUNCTION bp RETURN VARCHAR2 IS
  BEGIN
    RETURN v_bp;
  END;
  FUNCTION cp RETURN VARCHAR2 IS
  BEGIN
    RETURN v_cp;
  END;
  FUNCTION teleph RETURN VARCHAR2 IS
  BEGIN
    RETURN v_teleph;
  END;
  PROCEDURE ini_var_tiers(valeur VARCHAR2) IS
  BEGIN
    v_var_tiers := valeur;
  END;
  PROCEDURE ini_ide_tiers(valeur VARCHAR2) IS
  BEGIN
    v_ide_tiers := valeur;
  END;
  PROCEDURE ini_cod_cat_sociop(valeur VARCHAR2) IS
  BEGIN
    v_cod_cat_sociop := valeur;
  END;
  PROCEDURE ini_cod_sec(valeur VARCHAR2) IS
  BEGIN
    v_cod_sec := valeur;
  END;
  PROCEDURE ini_nom_contrib(valeur VARCHAR2) IS
  BEGIN
    v_nom_contrib := valeur;
  END;
  PROCEDURE ini_cod_typ_tiers(valeur CHAR) IS
  BEGIN
    v_cod_typ_tiers := valeur;
  END;
  PROCEDURE ini_nom(valeur VARCHAR2) IS
  BEGIN
    v_nom := valeur;
  END;
  PROCEDURE ini_prenom(valeur VARCHAR2) IS
  BEGIN
    v_prenom := valeur;
  END;
  PROCEDURE ini_ville(valeur VARCHAR2) IS
  BEGIN
    v_ville := valeur;
  END;
  PROCEDURE ini_adr1(valeur VARCHAR2) IS
  BEGIN
    v_adr1 := valeur;
  END;
  PROCEDURE ini_adr2(valeur VARCHAR2) IS
  BEGIN
    v_adr2 := valeur;
  END;
  PROCEDURE ini_adr3(valeur VARCHAR2) IS
  BEGIN
    v_adr3 := valeur;
  END;
  PROCEDURE ini_adr4(valeur VARCHAR2) IS
  BEGIN
    v_adr4 := valeur;
  END;
  PROCEDURE ini_pays(valeur VARCHAR2) IS
  BEGIN
    v_pays := valeur;
  END;
  PROCEDURE ini_bp(valeur VARCHAR2) IS
  BEGIN
    v_bp := valeur;
  END;
  PROCEDURE ini_cp(valeur VARCHAR2) IS
  BEGIN
    v_cp := valeur;
  END;
  PROCEDURE ini_teleph(valeur VARCHAR2) IS
  BEGIN
    v_teleph := valeur;
  END;
END TIERS;

/
