CREATE OR REPLACE PROCEDURE AFF_MESS
(
   p_typ IN varchar2,
   p_num IN NUMBER,
   p_prog IN varchar2,
   p_chaine1 varchar2 := NULL,
   p_chaine2 varchar2 := NULL,
   p_chaine3 varchar2 := NULL
) IS

---------------------------------------------------------------------------------------
-- Nom           : AFF_MESS
-- Date creation : --/--/2000
-- Creee par     : - (SEMA GROUP)
-- Role          : Extraction, formatage et affichage d'un message d'erreur
-- Parametres    :
-- 				   p_typ  - Type du message d'erreur a afficher
-- 				   p_num  - Numero du message
-- 				   p_prog  - Nom du programme appelant
--                 p_chaine1      - Premier parametre eventuel (parametre optionnel)
--                 p_chaine2      - Second parametre eventuel  (parametre optionnel)
--                 p_chaine3      - Troisieme parametre eventuel  (parametre optionnel)
--
-- Valeurs retournees
--                   - Message formate (brut) affichable a l'utilisateur (sans information
--					   		   sur le type ou la gravité du message ni la date de l'evenement generateur
-- Version       : 2.1-1.1
-- Historique    : @(#) v1.0 : --/--/2000 : Creation
-- Historique    : @(#) v1.1 : 28/08/2001 : SNE - Simplification du code
---------------------------------------------------------------------------------------
/* def variables standards */
   s_nomsql varchar2(40) ;

/* def variables locales */
   v_sysdate VARCHAR2(30);
   v_libl sr_mess_err.libl%TYPE;
   v_cod_typ_err sr_mess_err.cod_typ_err%TYPE;
   pos1 number;
   pos2 number;
   pos3 number;
   taille number;

BEGIN

   /* recuperation de la date du traitement */
   IF p_typ IN ('I','E','F')
   THEN
        s_nomsql := 'SR_MESS_ERR';
       /* affichage du message */
       dbms_output.put_line('#'||p_typ||'#'||p_prog||EXT_MESS(p_num, p_chaine1, p_chaine2, p_chaine3));
   ELSE
      dbms_output.put_line('#E#'||p_prog||'('||v_sysdate||') : Le type doit être ''E'', ''F'' ou ''I''');
   END IF;

EXCEPTION

   WHEN NO_DATA_FOUND THEN
      v_libl := 'Message numéro '||p_num||' non trouve';
      dbms_output.put_line('#E#'||p_prog||'('||v_sysdate||') : '||v_libl);

   WHEN OTHERS THEN
      dbms_output.put_line('exception ordre SQL : '||s_nomsql);
      dbms_output.put_line('exception code      : '||sqlcode);
      dbms_output.put_line('exception mess      : '||sqlerrm);

END AFF_MESS;

/

CREATE OR REPLACE PROCEDURE AFF_TRACE(p_nom_programme IN VARCHAR2
	   	  		  					   , p_niveau_trace IN NUMBER := 3
	   	  		  		   			   , p_num_mess in number := NULL
	  		   						   , p_param1 in varchar2 := null
									   , p_param2 in varchar2 := null
									   , p_param3 in varchar2 := null
	   	  		  					   , p_fichier_trace IN VARCHAR2 := GLOBAL.fichier_trace
									   , p_type_trace IN VARCHAR2 := 'I'
										)  IS

										/*
---------------------------------------------------------------------------------------
-- Nom           : AFF_TRACE
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 20/04/2001
-- ---------------------------------------------------------------------------
-- Role          : Sortie de trace a partir de la procédure en cours
--
-- Parametres    :
--  			 1 - p_fichier_trace 	  - Nom du fichier de trace
--  			 2 - p_niveau_trace	  - niveau de trace en cours d'affichage
--  			 3 - p_type_trace		  - type de trace (E : erreur, I = Information, A = Avertissement)
--  			 4 - p_num_mess 		  - Numero du message d'erreur a affichier
--  			 5 - p_chaine1  - Premier parametre eventuel (parametre optionnel)
--  			 6 - p_chaine2  - Second parametre eventuel
--  			 7 - p_chaine3  - Troisieme parametre eventuel
--
-- Remarques importantes:
--                 Si le numero du message d'erreur n'est pas fourni alors le premier parametre doit correspondre
--                 a un message sous la forma de texte libre a afficher. On peut ainsi constituer les fichier de
--                 debogage de l'application
--
-- Valeurs retournees
--                   - Message formate affichable a l'utilisateur
--					 - Si le message commence par la balise '#E#' alors une erreur est survenue
-- Appels		 : PIAF_ecrit_fichier (librairie externe PIAF_system)
-- ---------------------------------------------------------------------------
--  Version        : @(#) AFF_TRACE.sql version 3.0-1.2
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) AFF_TRACE.sql 2.1-1.0	|21/04/2001 | SNE	| Création
-- @(#) AFF_TRACE.sql 3.0-1.1	|16/04/2002 | SNE	| Bug/taille de la zone de formattage du texte à afficher
-- @(#) AFF_TRACE.sql 3.0-1.2	|27/08/2002 | SNE	| Suppression de l'affichage systématique a l'écran (cf. code)
---------------------------------------------------------------------------------------
*/

  v_libl_mess varchar2(1000);
  v_ret number;
  v_exc_err_appel exception;
  v_niveau_trace_global number := NVL(GLOBAL.niveau_trace, 0);
  BEGIN
    IF (p_num_mess IS NOT NULL OR p_param1 IS NOT NULL)  THEN
	    IF p_num_mess IS NOT NULL THEN
		 	v_libl_mess := SUBSTR(p_nom_programme ||' : '||EXT_MESS(p_num_mess, p_param1 , p_param2 , p_param3), 1, 1000);
		ELSE
		    v_libl_mess := SUBSTR(p_nom_programme ||' : '||'(' || to_char(sysdate, Get_DateTime_Format) ||') :  ' || p_param1, 1, 1000);
		END IF;

/*
--		SNE, 27/08/2002 : Suppression de l'affichage systématique a l'écran par ajout d'un "else"
--			Cela evite de surcharger le buffer de dbms_output surtout sir la trace se trouve dans un fichier
*/
		IF v_niveau_trace_global >= p_niveau_trace THEN
		    IF p_fichier_trace IS NOT NULL THEN
			 	v_ret := PIAF_ecrit_fichier(v_libl_mess, p_fichier_trace, 'at+', 'F', p_type_trace);
			ELSE
				dbms_output.put_line('#'||p_type_trace || '# ' || v_libl_mess);
			END IF;
		END IF;
	END IF;
  EXCEPTION
   WHEN OTHERS THEN
   		RAISE;
  END;

/

CREATE OR REPLACE PROCEDURE ASTER_DDL(p_ordre IN VARCHAR2) IS
/*
---------------------------------------------------------------------------------------
-- Nom           : ASTER_DDL
-- ---------------------------------------------------------------------------
--  Auteur         : SNE
--  Date creation  : 10/08/2001
-- ---------------------------------------------------------------------------
-- Role          : Execute des ordres de type DDL (ou autre) dans un bloc PL/SQL
--
-- Parametres    :
-- 				 1 - p_ordre : Ordre SQL à exécuter
--
-- Valeur retournee : Aucun
--
-- Appels		 : PACKAGE DBMS_SQL
-- ---------------------------------------------------------------------------
--  Version        : @(#) ASTER_DDL.sql version 2.1-1.0 : SNE : 10/08/2001
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) ASTER_DDL.sql 2.1-1.0	|10/08/2001 | SNE	| Création
-- @(#) ASTER_DDL.sql 2.1-1.1	|13/09/2001 | SNE	| Correction ano./normes
---------------------------------------------------------------------------------------
*/
v_curseur INTEGER;
v_ret INTEGER;
BEGIN
   v_curseur := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(v_curseur, p_ordre, DBMS_SQL.native);
   v_ret := DBMS_SQL.EXECUTE(v_curseur);
   DBMS_SQL.CLOSE_CURSOR(v_curseur);
END;

/

CREATE OR REPLACE PROCEDURE Build_Select(
p_mt IN PE_PAR_CGE.ide_champ%TYPE, p_flg_where OUT BOOLEAN,
v_mt_cad_car_mtdeg IN VARCHAR2, --ISA modif du  16/10/2006
v_mt_cad_car_mtdhb IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtdsb IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtehb IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mteng IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtesb IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mthbo IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtmvt IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtoah IN VARCHAR2, --ISA modif du  16/10/2006
v_mt_cad_car_mtoas IN VARCHAR2, --ISA modif du  16/10/2006
v_mt_cad_car_mtod  IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtoda IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtohb IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtor  IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtora IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtorh IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtors IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtosb IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtrct IN VARCHAR2, --ISA modif du  16/10/2006
v_mt_cad_car_mtsbo IN VARCHAR2, --ISA modif du  16/10/2006
v_mt_cge_mt        IN VARCHAR2, --ISA modif du  16/10/2006
v_mt_cge_mtdbc     IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cge_mtecr     IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cge_mtedb     IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cge_mtscr     IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cge_mtsdb     IN VARCHAR2,--ISA modif du  16/10/2006
v_mt_cad_car_mtror IN VARCHAR2,--ISA modif du  16/10/2006
v_type_mvt_c       IN VARCHAR2,--ISA modif du  16/10/2006
v_type_mvt_i       IN VARCHAR2,--ISA modif du  16/10/2006
v_type_mvt_d       IN VARCHAR2,--ISA modif du  16/10/2006
v_type_piece_or    IN VARCHAR2,--ISA modif du  16/10/2006
v_type_piece_ar    IN VARCHAR2,--ISA modif du  16/10/2006
v_type_piece_od    IN VARCHAR2,--ISA modif du  16/10/2006
v_type_piece_ad    IN VARCHAR2,--ISA modif du  16/10/2006
v_oui_non_oui      IN VARCHAR2,--ISA modif du  16/10/2006
v_sens_c           IN VARCHAR2,--ISA modif du  16/10/2006
v_sens_d           IN VARCHAR2,--ISA modif du  16/10/2006
v_oui_non_non      IN VARCHAR2,--ISA modif du  16/10/2006
v_statut_piece_v   IN VARCHAR2,--ISA modif du  16/10/2006
v_statut_mess_tr   IN VARCHAR2,--ISA modif du  16/10/2006
v_flg_replace      OUT BOOLEAN,--ISA modif du  16/10/2006
v_clause_select    OUT VARCHAR2,--ISA modif du  16/10/2006
v_clause_from      OUT VARCHAR2,--ISA modif du  16/10/2006
v_clause_joint     OUT VARCHAR2--ISA modif du  16/10/2006

)
IS

    BEGIN
      p_flg_where := TRUE;
      IF p_mt = v_mt_cad_car_mtdeg THEN
        v_clause_select := 'SUM(t1.mt)';
        v_clause_from   := 'FROM fb_ligne_eng t1, fb_eng t2';
        v_clause_joint  := 'WHERE t1.ide_poste = t2.ide_poste'
                   || ' AND t1.ide_gest = t2.ide_gest AND t1.ide_ordo = t2.ide_ordo'
                   || ' AND t1.cod_bud = t2.cod_bud AND t1.ide_eng = t2.ide_eng'
--LSA-20061010-D
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || ''''
--LSA-20061010-F
                   || ' AND t2.cod_typ_mvt = ''' || v_type_mvt_d || '''';
      ELSIF p_mt = v_mt_cad_car_mtdhb THEN
        v_clause_select := 'SUM(t1.mt - t1.mt_bud)';
        v_clause_from   := 'FROM fb_ligne_eng t1, fb_eng t2';
        v_clause_joint  := 'WHERE t1.ide_poste = t2.ide_poste'
                   || ' AND t1.ide_gest = t2.ide_gest AND t1.ide_ordo = t2.ide_ordo'
                   || ' AND t1.cod_bud = t2.cod_bud AND t1.ide_eng = t2.ide_eng'
--LSA-20061010-D
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || ''''
--LSA-20061010-F
                   || ' AND t2.cod_typ_mvt = ''' || v_type_mvt_d || '''';
      ELSIF p_mt = v_mt_cad_car_mtdsb THEN
        v_clause_select := 'SUM(t1.mt_bud)';
        v_clause_from   := 'FROM fb_ligne_eng t1, fb_eng t2';
        v_clause_joint  := 'WHERE t1.ide_poste = t2.ide_poste'
                   || ' AND t1.ide_gest = t2.ide_gest AND t1.ide_ordo = t2.ide_ordo'
                   || ' AND t1.cod_bud = t2.cod_bud AND t1.ide_eng = t2.ide_eng'
--LSA-20061010-D
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || ''''
--LSA-20061010-F
                   || ' AND t2.cod_typ_mvt = ''' || v_type_mvt_d || '''';
      ELSIF p_mt = v_mt_cad_car_mtehb THEN
        v_clause_select := 'SUM(t1.mt - t1.mt_bud)';
        v_clause_from   := 'FROM fb_ligne_eng t1, fb_eng t2';
        v_clause_joint  := 'WHERE t1.ide_poste = t2.ide_poste'
                   || ' AND t1.ide_gest = t2.ide_gest AND t1.ide_ordo = t2.ide_ordo'
                   || ' AND t1.cod_bud = t2.cod_bud AND t1.ide_eng = t2.ide_eng'
--LSA-20061010-D
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || ''''
--LSA-20061010-F
                   || ' AND t2.cod_typ_mvt IN (''' || v_type_mvt_i || ''', ''' || v_type_mvt_c || ''')';
      ELSIF p_mt = v_mt_cad_car_mteng THEN
        v_clause_select := 'SUM(t1.mt)';
        v_clause_from   := 'FROM fb_ligne_eng t1, fb_eng t2';
        v_clause_joint  := 'WHERE t1.ide_poste = t2.ide_poste'
                   || ' AND t1.ide_gest = t2.ide_gest AND t1.ide_ordo = t2.ide_ordo'
                   || ' AND t1.cod_bud = t2.cod_bud AND t1.ide_eng = t2.ide_eng'
--LSA-20061010-D
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || ''''
--LSA-20061010-F
                   || ' AND t2.cod_typ_mvt IN (''' || v_type_mvt_i || ''', ''' || v_type_mvt_c || ''')';
      ELSIF p_mt = v_mt_cad_car_mtesb THEN
        v_clause_select := 'SUM(t1.mt_bud)';
        v_clause_from   := 'FROM fb_ligne_eng t1, fb_eng t2';
        v_clause_joint  := 'WHERE t1.ide_poste = t2.ide_poste'
                   || ' AND t1.ide_gest = t2.ide_gest AND t1.ide_ordo = t2.ide_ordo'
                   || ' AND t1.cod_bud = t2.cod_bud AND t1.ide_eng = t2.ide_eng'
--LSA-20061010-D
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || ''''
--LSA-20061010-F
                   || ' AND t2.cod_typ_mvt IN (''' || v_type_mvt_i || ''', ''' || v_type_mvt_c || ''')';
      ELSIF p_mt = v_mt_cad_car_mthbo THEN
        v_clause_select := 'SUM(t1.mt - t1.mt_bud)';
--LSA-20061010-D
--        v_clause_from   := 'FROM fb_ligne_piece t1';
--        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_od || '''';
        v_clause_from   := 'FROM fb_ligne_piece t1, fb_piece t2';
        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_od || ''''
                   || ' AND t1.ide_poste = t2.ide_poste AND t1.ide_gest = t2.ide_gest'
                   || ' AND t1.ide_ordo = t2.ide_ordo AND t1.cod_bud = t2.cod_bud'
                   || ' AND t1.ide_piece = t2.ide_piece AND t1.cod_typ_piece = t2.cod_typ_piece'
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cad_car_mtmvt THEN
        v_clause_select := 'SUM(t1.mt)';
--LSA-20061204-D
--        v_clause_from   := 'FROM fb_mvt_bud t1';
--        p_flg_where := FALSE;
	    v_clause_from   := 'FROM fb_mvt_bud t1, fm_rnl_me t2';
        v_clause_joint  := 'WHERE t1.ide_poste = t2.ide_nd_dest'
                   || ' AND t1.cod_typ_nd_emet = t2.cod_typ_nd_emet AND t1.ide_nd_emet = t2.ide_nd_emet'
                   || ' AND t1.ide_mess = t2.ide_mess AND t1.flg_emis_recu = t2.flg_emis_recu'
                   || ' AND t2.cod_statut = ''' || v_statut_mess_tr || '''';
--LSA-20061204-F
      ELSIF p_mt = v_mt_cad_car_mtoah THEN
        v_clause_select := 'SUM(t1.mt - t1.mt_bud)';
--LSA-20061010-D
--        v_clause_from   := 'FROM fb_ligne_piece t1';
--        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_ad || '''';
        v_clause_from   := 'FROM fb_ligne_piece t1, fb_piece t2';
        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_ad || ''''
                   || ' AND t1.ide_poste = t2.ide_poste AND t1.ide_gest = t2.ide_gest'
                   || ' AND t1.ide_ordo = t2.ide_ordo AND t1.cod_bud = t2.cod_bud'
                   || ' AND t1.ide_piece = t2.ide_piece AND t1.cod_typ_piece = t2.cod_typ_piece'
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cad_car_mtoas THEN
        v_clause_select := 'SUM(t1.mt_bud)';
--LSA-20061010-D
--        v_clause_from   := 'FROM fb_ligne_piece t1';
--        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_ad || '''';
        v_clause_from   := 'FROM fb_ligne_piece t1, fb_piece t2';
        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_ad || ''''
                   || ' AND t1.ide_poste = t2.ide_poste AND t1.ide_gest = t2.ide_gest'
                   || ' AND t1.ide_ordo = t2.ide_ordo AND t1.cod_bud = t2.cod_bud'
                   || ' AND t1.ide_piece = t2.ide_piece AND t1.cod_typ_piece = t2.cod_typ_piece'
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cad_car_mtod THEN
        v_clause_select := 'SUM(t1.mt)';
--LSA-20061010-D
--        v_clause_from   := 'FROM fb_ligne_piece t1';
--        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_od || '''';
        v_clause_from   := 'FROM fb_ligne_piece t1, fb_piece t2';
        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_od || ''''
                   || ' AND t1.ide_poste = t2.ide_poste AND t1.ide_gest = t2.ide_gest'
                   || ' AND t1.ide_ordo = t2.ide_ordo AND t1.cod_bud = t2.cod_bud'
                   || ' AND t1.ide_piece = t2.ide_piece AND t1.cod_typ_piece = t2.cod_typ_piece'
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cad_car_mtoda THEN
        v_clause_select := 'SUM(t1.mt)';
--LSA-20061010-D
--        v_clause_from   := 'FROM fb_ligne_piece t1';
--        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_ad || '''';
        v_clause_from   := 'FROM fb_ligne_piece t1, fb_piece t2';
        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_ad || ''''
                   || ' AND t1.ide_poste = t2.ide_poste AND t1.ide_gest = t2.ide_gest'
                   || ' AND t1.ide_ordo = t2.ide_ordo AND t1.cod_bud = t2.cod_bud'
                   || ' AND t1.ide_piece = t2.ide_piece AND t1.cod_typ_piece = t2.cod_typ_piece'
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cad_car_mtohb THEN
        v_clause_select := 'SUM(t1.mt - t1.mt_bud)';
--LSA-20061010-D
--        v_clause_from   := 'FROM fb_ligne_piece t1';
--        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_ar || '''';
        v_clause_from   := 'FROM fb_ligne_piece t1, fb_piece t2';
        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_ar || ''''
                   || ' AND t1.ide_poste = t2.ide_poste AND t1.ide_gest = t2.ide_gest'
                   || ' AND t1.ide_ordo = t2.ide_ordo AND t1.cod_bud = t2.cod_bud'
                   || ' AND t1.ide_piece = t2.ide_piece AND t1.cod_typ_piece = t2.cod_typ_piece'
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cad_car_mtor THEN
        v_clause_select := 'SUM(t1.mt)';
--LSA-20061010-D
--        v_clause_from   := 'FROM fb_ligne_piece t1';
--        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_or || '''';
        v_clause_from   := 'FROM fb_ligne_piece t1, fb_piece t2';
        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_or || ''''
                   || ' AND t1.ide_poste = t2.ide_poste AND t1.ide_gest = t2.ide_gest'
                   || ' AND t1.ide_ordo = t2.ide_ordo AND t1.cod_bud = t2.cod_bud'
                   || ' AND t1.ide_piece = t2.ide_piece AND t1.cod_typ_piece = t2.cod_typ_piece'
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cad_car_mtora THEN
        v_clause_select := 'SUM(t1.mt)';
--LSA-20061010-D
--        v_clause_from   := 'FROM fb_ligne_piece t1';
--        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_ar || '''';
        v_clause_from   := 'FROM fb_ligne_piece t1, fb_piece t2';
        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_ar || ''''
                   || ' AND t1.ide_poste = t2.ide_poste AND t1.ide_gest = t2.ide_gest'
                   || ' AND t1.ide_ordo = t2.ide_ordo AND t1.cod_bud = t2.cod_bud'
                   || ' AND t1.ide_piece = t2.ide_piece AND t1.cod_typ_piece = t2.cod_typ_piece'
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cad_car_mtorh THEN
        v_clause_select := 'SUM(t1.mt - t1.mt_bud)';
--LSA-20061010-D
--        v_clause_from   := 'FROM fb_ligne_piece t1';
--        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_or || '''';
        v_clause_from   := 'FROM fb_ligne_piece t1, fb_piece t2';
        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_or || ''''
                   || ' AND t1.ide_poste = t2.ide_poste AND t1.ide_gest = t2.ide_gest'
                   || ' AND t1.ide_ordo = t2.ide_ordo AND t1.cod_bud = t2.cod_bud'
                   || ' AND t1.ide_piece = t2.ide_piece AND t1.cod_typ_piece = t2.cod_typ_piece'
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cad_car_mtors THEN
        v_clause_select := 'SUM(t1.mt)';
--LSA-20061010-D
--        v_clause_from   := 'FROM fb_ligne_piece t1';
--        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_or || '''';
        v_clause_from   := 'FROM fb_ligne_piece t1, fb_piece t2';
        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_or || ''''
                   || ' AND t1.ide_poste = t2.ide_poste AND t1.ide_gest = t2.ide_gest'
                   || ' AND t1.ide_ordo = t2.ide_ordo AND t1.cod_bud = t2.cod_bud'
                   || ' AND t1.ide_piece = t2.ide_piece AND t1.cod_typ_piece = t2.cod_typ_piece'
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cad_car_mtosb THEN
        v_clause_select := 'SUM(t1.mt_bud)';
--LSA-20061010-D
--        v_clause_from   := 'FROM fb_ligne_piece t1';
--        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_ar || '''';
        v_clause_from   := 'FROM fb_ligne_piece t1, fb_piece t2';
        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_ar || ''''
                   || ' AND t1.ide_poste = t2.ide_poste AND t1.ide_gest = t2.ide_gest'
                   || ' AND t1.ide_ordo = t2.ide_ordo AND t1.cod_bud = t2.cod_bud'
                   || ' AND t1.ide_piece = t2.ide_piece AND t1.cod_typ_piece = t2.cod_typ_piece'
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cad_car_mtrct THEN
        v_clause_select := 'SUM(t1.mt_encaiss)';
        v_clause_from   := 'FROM fb_encaissement t1';
        v_clause_joint  := 'WHERE t1.flg_rec_comptant = ''' || v_oui_non_oui || '''';
      ELSIF p_mt = v_mt_cad_car_mtror THEN
        v_clause_select := 'SUM(t1.mt_encaiss)';
        v_clause_from   := 'FROM fb_encaissement t1';
        v_clause_joint  := 'WHERE t1.flg_rec_comptant = ''' || v_oui_non_non || '''';
      ELSIF p_mt = v_mt_cad_car_mtsbo THEN
        v_clause_select := 'SUM(t1.mt_bud)';
--LSA-20061010-D
--        v_clause_from   := 'FROM fb_ligne_piece t1';
--        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_od || '''';
        v_clause_from   := 'FROM fb_ligne_piece t1, fb_piece t2';
        v_clause_joint  := 'WHERE t1.cod_typ_piece = ''' || v_type_piece_od || ''''
                   || ' AND t1.ide_poste = t2.ide_poste AND t1.ide_gest = t2.ide_gest'
                   || ' AND t1.ide_ordo = t2.ide_ordo AND t1.cod_bud = t2.cod_bud'
                   || ' AND t1.ide_piece = t2.ide_piece AND t1.cod_typ_piece = t2.cod_typ_piece'
                   || ' AND t2.cod_statut = ''' || v_statut_piece_v || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cge_mt THEN
        v_clause_select := 'SUM(t1.mt)';
        v_clause_from   := 'FROM fc_ligne t1';
--LSA-20061010-D
--        p_flg_where := FALSE;
        v_clause_joint  := 'WHERE t1.flg_cptab = ''' || v_oui_non_oui || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cge_mtdbc THEN
        v_clause_select := 'SUM(t1.mt)';
        v_clause_from   := 'FROM fc_ligne t1';
--LSA-20061010-D
        -- v_clause_joint  := 'WHERE t1.cod_sens = ''@TO_REPLACE@''';
        v_clause_joint  := 'WHERE t1.cod_sens = ''@TO_REPLACE@'''
                   	   || ' AND t1.flg_cptab = ''' || v_oui_non_oui || '''';
--LSA-20061010-F
        v_flg_replace := TRUE;
      ELSIF p_mt = v_mt_cge_mtecr THEN
        v_clause_select := 'SUM(t1.mt)';
        v_clause_from   := 'FROM fc_ligne t1';
--LSA-20061010-D
--        v_clause_joint  := 'WHERE t1.cod_sens = ''' || v_sens_c || '''';
        v_clause_joint  := 'WHERE t1.cod_sens = ''' || v_sens_c || ''''
                   	   || ' AND t1.flg_cptab = ''' || v_oui_non_oui || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cge_mtedb THEN
        v_clause_select := 'SUM(t1.mt)';
        v_clause_from   := 'FROM fc_ligne t1';
--LSA-20061010-D
--        v_clause_joint  := 'WHERE t1.cod_sens = ''' || v_sens_d || '''';
        v_clause_joint  := 'WHERE t1.cod_sens = ''' || v_sens_d || ''''
                   	   || ' AND t1.flg_cptab = ''' || v_oui_non_oui || '''';
--LSA-20061010-F
      ELSIF p_mt = v_mt_cge_mtscr THEN
        v_clause_select := 'SUM(t1.mt)';
        v_clause_from   := 'FROM fc_ligne t1';
--LSA-20061010-D
--        v_clause_joint  := 'WHERE t1.cod_sens = ''@TO_REPLACE@''';
        v_clause_joint  := 'WHERE t1.cod_sens = ''@TO_REPLACE@'''
                   	   || ' AND t1.flg_cptab = ''' || v_oui_non_oui || '''';
--LSA-20061010-F
        v_flg_replace := TRUE;
      ELSIF p_mt = v_mt_cge_mtsdb THEN
        v_clause_select := 'SUM(t1.mt)';
        v_clause_from   := 'FROM fc_ligne t1';
--LSA-20061010-D
--        v_clause_joint  := 'WHERE t1.cod_sens = ''@TO_REPLACE@''';
        v_clause_joint  := 'WHERE t1.cod_sens = ''@TO_REPLACE@'''
                   	   || ' AND t1.flg_cptab = ''' || v_oui_non_oui || '''';
--LSA-20061010-F
        v_flg_replace := TRUE;
      END IF;

	  -- MODIF SGN FCT38 ajout d une trace de debug
	  --trace('Dans Build select : select:'||v_clause_select||' from:'||v_clause_from||' joint:'||v_clause_joint);
	  -- Fin modif sgn

    EXCEPTION
      WHEN OTHERS THEN
        RAISE;
    END Build_Select;

/

CREATE OR REPLACE PROCEDURE CAL_Autpro ( p_ide_poste IN rm_poste.ide_poste%TYPE,
                                         p_ide_ordo IN rb_ordo.ide_ordo%TYPE,
                                         p_cod_bud IN fb_autpro.cod_bud%TYPE,
                                         p_ide_lig_prev IN fb_autpro.ide_lig_prev%TYPE,
                                         p_ouv_ap OUT fb_autpro.mt%TYPE,
                                         p_deleg_e OUT fb_autpro.mt%TYPE,
                                         p_dispo_ap OUT fb_autpro.mt%TYPE,
                                         p_reserv OUT fb_autpro.mt%TYPE,
                                         p_dispo_res OUT fb_autpro.mt%TYPE,
                                         p_retour OUT NUMBER ) IS

/* Paramètres en entrée :				 		  	  		   */
/* 			  p_ide_poste : poste comptable       	  		   */
/*  		  p_ide_ordo : ordonnateur            	  		   */
/* 			  p_cod_bud : code budget             	  		   */
/* 			  p_ide_lig_prev : ligne budgétaire de prévision   */
/* Paramètres en sortie :  									   */
/* 			  p_ouv_ap : montant des AP ouvertes			   */
/* 			  p_deleg_e : montant des délégations émises	   */
/* 			  p_dispo_ap : montant des AP disponibles		   */
/* 			  p_reserv : montant des AP reservees			   */
/* 			  p_eng : montant des engagements                  */
/* 			  p_dispo_res : montant disponible pour reserver   */
/*			  p_retour : code retour de la procédure : 1 si OK         */
/*			  		   	 	  		 	   			   0 si pas trouve */
/*			  		   	 	  		 	   			   -1 si KO        */

/* Declaration et initialisation des variables de sortie */
v_ouv_ap fb_autpro.mt%TYPE := 0 ;
v_deleg_e fb_autpro.mt%TYPE := 0;
v_dispo_ap fb_autpro.mt%TYPE := 0;
v_reserv fb_autpro.mt%TYPE := 0;
v_dispo_res fb_autpro.mt%TYPE := 0;

/* Declaration du curseur de parcours de la table fb_autpro */
CURSOR c_autpro IS
SELECT a.cod_mt, a.mt
FROM fb_autpro A
WHERE
  A.ide_poste = p_ide_poste
  AND A.ide_ordo = p_ide_ordo
  AND A.cod_bud = p_cod_bud
  AND A.ide_lig_prev = p_ide_lig_prev;

BEGIN

  p_retour := 0;
  FOR v_autpro IN c_autpro LOOP
    /* Le curseur a ramene au moins un enregistrement */
    p_retour := 1;
    IF v_autpro.cod_mt = 'OUVER' OR v_autpro.cod_mt = 'VIRAPR' OR v_autpro.cod_mt = 'DEREC' THEN
      v_ouv_ap := v_ouv_ap + v_autpro.mt;
      v_dispo_ap := v_dispo_ap + v_autpro.mt;
      v_dispo_res := v_dispo_res + v_autpro.mt;
    ELSIF v_autpro.cod_mt = 'VIRAPE' THEN
      v_ouv_ap := v_ouv_ap - v_autpro.mt;
      v_dispo_ap := v_dispo_ap - v_autpro.mt;
      v_dispo_res := v_dispo_res - v_autpro.mt;
    ELSIF v_autpro.cod_mt = 'DEEMI' THEN
      v_deleg_e := v_deleg_e + v_autpro.mt;
      v_dispo_ap := v_dispo_ap - v_autpro.mt;
      v_dispo_res := v_dispo_res - v_autpro.mt;
    ELSIF v_autpro.cod_mt = 'RESERE' THEN
      v_reserv := v_reserv + v_autpro.mt;
      v_dispo_res := v_dispo_res - v_autpro.mt;
    ELSE
      Null;
    END IF;
  END LOOP;
  /* Affectation des paramètres de sortie */
  p_ouv_ap := v_ouv_ap;
  p_dispo_ap := v_dispo_ap;
  p_dispo_res := v_dispo_res;
  p_deleg_e := v_deleg_e;
  p_reserv := v_reserv ;

EXCEPTION
  WHEN OTHERS THEN
    /* en cas d'erreur les montants retournés sont tous égaux à zéro */
    p_ouv_ap := 0;
    p_dispo_ap := 0;
    p_dispo_res := 0;
    p_deleg_e := 0;
    p_reserv := 0;
	p_retour := -1;

END CAL_Autpro;

/

CREATE OR REPLACE PROCEDURE CAL_Credi (
            p_ide_poste IN rm_poste.ide_poste%TYPE,
            p_ide_ordo IN rb_ordo.ide_ordo%TYPE,
            p_cod_bud IN fb_crepa.cod_bud%TYPE,
            p_var_bud IN fb_crepa.var_bud%TYPE,
            p_ide_lig_prev IN fb_crepa.ide_lig_prev%TYPE,
            p_ide_gest IN fb_crepa.ide_gest%TYPE,
            p_ouv_cr OUT fb_credi.mt%TYPE,
            p_autor_cr OUT fb_credi.mt%TYPE,
            p_deleg_e OUT fb_credi.mt%TYPE,
            p_dispo_cr OUT fb_credi.mt%TYPE,
            p_eng OUT fb_credi.mt%TYPE,
            p_sdeleg_eng OUT fb_credi.mt%TYPE,
            p_deleg_eng OUT fb_credi.mt%TYPE,
            p_dispo_eng OUT fb_credi.mt%TYPE,
            p_ordo OUT fb_credi.mt%TYPE,
            p_dso OUT fb_credi.mt%TYPE,
            p_dispo_ordo OUT fb_credi.mt%TYPE,
            p_tx_autor OUT fn_ligne_bud_prev.tx_autor%TYPE,
            p_deleng_r OUT fb_credi.mt%TYPE,
            p_retour OUT NUMBER ) IS

/* Paramètres en entrée :                                                */
/*          p_ide_poste : poste comptable                                */
/*          p_ide_ordo : ordonnateur                                     */
/*          p_cod_bud : code budget                                      */
/*          p_var_bud : variation budgetaire                             */
/*          p_ide_lig_prev : ligne budgétaire de prévision               */
/*          p_ide_gest : gestion                                         */
/* Paramètres en sortie :                                                */
/*          p_ouv_cr : montant des ouvertures de credit                  */
/*          p_autor_cr : montant des credits autorisés	                 */
/*          p_deleg_e : montant des délégations émises	                 */
/*          p_dispo_cr : montant des credits disponibles                 */
/*          p_eng : montant des engagements                              */
/*          p_sdeleg_eng : montant des engagements sur delegation        */
/*          p_deleg_eng : montant des engagements delegues               */
/*          p_dispo_eng : montant disponible pour engager                */
/*          p_ordo : montant des ordonnances	                         */
/*          p_dso : montant DSO                                          */
/*          p_dispo_ordo : montant disponible pour ordonnancer           */
/*          p_tx_autor : taux d'autorisation                             */
/*          p_deleng_r : montant des délégations de crédits engagés recus*/
/*          p_retour : code retour de la procédure : 1 si OK             */
/*                                                   0 si pas trouve     */
/*                                                   -1 si KO            */


/* Déclaration des variables locales */
v_tx_autor NUMBER(7,4);
err_tx_autor EXCEPTION;

/* Declaration et initialisation des variables de sortie */
v_ouv_cr fb_credi.mt%TYPE := 0;
v_autor_cr fb_credi.mt%TYPE := 0;
v_deleg_e fb_credi.mt%TYPE := 0;
v_dispo_cr fb_credi.mt%TYPE := 0;
v_eng fb_credi.mt%TYPE := 0;
v_sdeleg_eng fb_credi.mt%TYPE := 0;
v_deleg_eng fb_credi.mt%TYPE := 0;
v_dispo_eng fb_credi.mt%TYPE := 0;
v_ordo fb_credi.mt%TYPE := 0;
v_dso fb_credi.mt%TYPE := 0;
v_dispo_ordo fb_credi.mt%TYPE := 0;
v_deleng_r fb_credi.mt%TYPE := 0;

/* Declaration du curseur de parcours de la table fb_credi */
CURSOR c_credi IS
SELECT A.cod_mt, A.mt, A.cod_ss_code
FROM fb_credi A
WHERE
  A.ide_poste = p_ide_poste
  AND A.ide_ordo = p_ide_ordo
  AND A.cod_bud = p_cod_bud
  AND A.ide_lig_prev = p_ide_lig_prev
  AND A.ide_gest = p_ide_gest;

BEGIN

  p_retour := 0;

  /* Recherche du taux d'autorisation dans la table fn_ligne_bud_prev */
  BEGIN
    SELECT (B.tx_autor/100) INTO v_tx_autor
    FROM fn_ligne_bud_prev B
    WHERE
      B.var_bud = p_var_bud
      AND B.ide_lig_prev = p_ide_lig_prev;
    IF v_tx_autor IS NULL THEN
    /* si le taux d'autorisation n'est pas renseigné on interrompt le traitement */
      RAISE err_tx_autor;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE err_tx_autor;
  END;

  FOR v_credi IN c_credi LOOP
    /* Le curseur a ramene au moins un enregistrement */
    p_retour := 1;
    IF v_credi.cod_mt = 'DOTAT' OR v_credi.cod_mt = 'VIRCRR' THEN
      v_ouv_cr := v_ouv_cr + v_credi.mt;
      v_autor_cr := v_autor_cr + ( v_credi.mt * v_tx_autor );
      v_dispo_cr := v_dispo_cr + ( v_credi.mt * v_tx_autor );
      v_dispo_eng := v_dispo_eng + ( v_credi.mt * v_tx_autor );
    ELSIF v_credi.cod_mt = 'DEREC' THEN
      v_ouv_cr := v_ouv_cr + v_credi.mt;
      v_autor_cr := v_autor_cr + v_credi.mt;
      v_dispo_cr := v_dispo_cr + v_credi.mt;
      v_dispo_eng := v_dispo_eng + v_credi.mt;
    ELSIF v_credi.cod_mt = 'VIRCRE' THEN
      v_ouv_cr := v_ouv_cr - v_credi.mt;
      v_autor_cr := v_autor_cr - ( v_credi.mt * v_tx_autor );
      v_dispo_cr := v_dispo_cr - ( v_credi.mt * v_tx_autor );
      v_dispo_eng := v_dispo_eng - ( v_credi.mt * v_tx_autor );
    ELSIF v_credi.cod_mt = 'DENGR' THEN
      IF v_credi.cod_ss_code = 'E' THEN
	v_ouv_cr := v_ouv_cr + v_credi.mt;
	v_autor_cr := v_autor_cr + v_credi.mt;
        v_dispo_cr := v_dispo_cr + v_credi.mt;
        v_dispo_eng := v_dispo_eng + v_credi.mt;
        v_deleng_r := v_deleng_r + v_credi.mt;
      END IF;
    ELSIF v_credi.cod_mt = 'ENGAG' THEN
      v_eng := v_eng + v_credi.mt;
      v_dispo_eng := v_dispo_eng - v_credi.mt;
      v_dispo_ordo := v_dispo_ordo + v_credi.mt;
    ELSIF v_credi.cod_mt = 'ENGAD' THEN
      v_dispo_eng := v_dispo_eng - v_credi.mt;
      v_deleg_eng := v_deleg_eng + v_credi.mt;
    ELSIF v_credi.cod_mt = 'ENGASD' THEN
      IF v_credi.cod_ss_code = 'E' THEN
        v_sdeleg_eng := v_sdeleg_eng + v_credi.mt;
      END IF;
      v_dispo_eng := v_dispo_eng - v_credi.mt;
      v_dispo_ordo := v_dispo_ordo + v_credi.mt;
    ELSIF v_credi.cod_mt = 'DEEMI' THEN
      v_deleg_e := v_deleg_e + v_credi.mt;
      v_dispo_cr := v_dispo_cr - v_credi.mt;
      v_dispo_eng := v_dispo_eng - v_credi.mt;
    ELSIF v_credi.cod_mt = 'ORDON' THEN
      v_ordo := v_ordo + v_credi.mt;
      v_dispo_ordo := v_dispo_ordo - v_credi.mt;
    ELSIF v_credi.cod_mt = 'DSO' THEN
	  v_dso := v_dso + v_credi.mt;
	  v_dispo_ordo := v_dispo_ordo - v_credi.mt;
    -- MODIF SGN ANOVA 13,14,36 : ajout des nouveaux codes
	ELSIF v_credi.cod_mt = 'RESCRE' THEN
	  v_dispo_eng := v_dispo_eng + v_credi.mt;
	ELSIF v_credi.cod_mt = 'ORDSE' THEN
	  v_dispo_eng := v_dispo_eng - v_credi.mt;
      v_ordo := v_ordo + v_credi.mt;
	-- fin modif sgn
    ELSE
      Null;
    END IF;
  END LOOP;
  /* Affectation des paramètres de sortie */
  p_ouv_cr := v_ouv_cr;
  p_autor_cr := v_autor_cr;
  p_deleg_e := v_deleg_e;
  p_dispo_cr := v_dispo_cr;
  p_eng := v_eng;
  p_sdeleg_eng := v_sdeleg_eng;
  p_deleg_eng := v_deleg_eng;
  p_dispo_eng := v_dispo_eng;
  p_ordo := v_ordo;
  p_dso := v_dso;
  p_dispo_ordo := v_dispo_ordo;
  p_tx_autor := v_tx_autor;
  p_deleng_r := v_deleng_r;

EXCEPTION
  WHEN err_tx_autor THEN
    /* Si le traitement est interrompu en raison d'un problème      */
    /* lors de la recuperation du taux d'autorisation, les montants */
    /* retournés sont tous egaux a zero et le code retour vaut -1   */
    p_ouv_cr := 0;
    p_autor_cr := 0;
    p_deleg_e := 0;
    p_dispo_cr := 0;
    p_eng := 0;
    p_sdeleg_eng := 0;
    p_deleg_eng := 0;
    p_dispo_eng := 0;
    p_ordo := 0;
    p_dso := 0;
    p_dispo_ordo := 0;
    p_tx_autor := 0;
    p_deleng_r := 0;
    p_retour := -1;
  WHEN OTHERS THEN
    /* en cas d'erreur les montants retournés sont tous égaux à zéro */
    p_ouv_cr := 0;
    p_autor_cr := 0;
    p_deleg_e := 0;
    p_dispo_cr := 0;
    p_eng := 0;
    p_sdeleg_eng := 0;
    p_deleg_eng := 0;
    p_dispo_eng := 0;
    p_ordo := 0;
    p_dso := 0;
    p_dispo_ordo := 0;
    p_tx_autor := 0;
    p_deleng_r := 0;
    p_retour := -1;

END CAL_Credi;

/

CREATE OR REPLACE PROCEDURE CAL_Crepa (
          p_ide_poste IN rm_poste.ide_poste%TYPE,
          p_ide_ordo IN rb_ordo.ide_ordo%TYPE,
          p_cod_bud IN fb_crepa.cod_bud%TYPE,
          p_var_bud IN fb_crepa.var_bud%TYPE,
          p_ide_lig_prev IN fb_crepa.ide_lig_prev%TYPE,
          p_ide_gest IN fb_crepa.ide_gest%TYPE,
          p_ouv_cp OUT fb_crepa.mt%TYPE,
          p_autor_cp OUT fb_crepa.mt%TYPE,
          p_deleg_e OUT fb_crepa.mt%TYPE,
          p_dispo_cp OUT fb_crepa.mt%TYPE,
          p_ordo OUT fb_crepa.mt%TYPE,
          p_dispo_ordo OUT fb_crepa.mt%TYPE,
          p_tx_autor OUT NUMBER,
          p_retour OUT NUMBER ) IS

/* Paramètres en entrée :                                          */
/*        p_ide_poste : poste comptable                            */
/*        p_ide_ordo : ordonnateur                                 */
/*        p_cod_bud : code budget                                  */
/*        p_var_bud : variation budgetaire                         */
/*        p_ide_lig_prev : ligne budgétaire de prévision           */
/*        p_ide_gest : gestion	                                   */
/* Paramètres en sortie :                                          */
/*        p_ouv_cp : montant des ouvertures de CP                  */
/*        p_autor_cp : montant des CP autorisés                    */
/*        p_deleg_e : montant des délégations émises               */
/*        p_dispo_cp : montant des CP disponibles                  */
/*        p_ordo : montant des ordonnances                         */
/*        p_dispo_ordo : montant disponible pour ordonnancer       */
/*        p_tx_autor : taux d'autorisation                         */
/*        p_retour : code retour de la procédure : 1 si OK         */
/*                                                 0 si pas trouve */
/*                                                 -1 si KO        */
/* @(#) CAL_Crepa.sql 02/01/2001 MMA modifications anomalie 150    */


/* Déclaration des variables locales */
v_tx_autor NUMBER(7,4);
err_tx_autor EXCEPTION;

/* Declaration et initialisation des variables de sortie */
v_ouv_cp fb_crepa.mt%TYPE := 0;
v_autor_cp fb_crepa.mt%TYPE := 0;
v_deleg_e fb_crepa.mt%TYPE := 0;
v_dispo_cp fb_crepa.mt%TYPE := 0;
v_ordo fb_crepa.mt%TYPE := 0;
v_dispo_ordo fb_crepa.mt%TYPE := 0;

/* Declaration du curseur de parcours de la table fb_crepa */
CURSOR c_crepa IS
SELECT A.cod_mt, A.mt
FROM fb_crepa A
WHERE
  A.ide_poste = p_ide_poste
  AND A.ide_ordo = p_ide_ordo
  AND A.cod_bud = p_cod_bud
  AND A.ide_lig_prev = p_ide_lig_prev
  AND A.ide_gest = p_ide_gest;

BEGIN

  p_retour := 0;

  /* Recherche du taux d'autorisation dans la table fn_ligne_bud_prev */
  BEGIN
    SELECT (B.tx_autor/100) INTO v_tx_autor
    FROM fn_ligne_bud_prev B
    WHERE
      B.var_bud = p_var_bud
      AND B.ide_lig_prev = p_ide_lig_prev;
    IF v_tx_autor IS NULL THEN
      /* si le taux d'autorisation n'est pas renseigné on interrompt le traitement */
      RAISE err_tx_autor;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE err_tx_autor;
  END;

  FOR v_crepa IN c_crepa LOOP
    /* Le curseur a ramene au moins un enregistrement */
    p_retour := 1;
    IF v_crepa.cod_mt = 'DOTAT' OR v_crepa.cod_mt = 'VIRCPR' THEN
      v_ouv_cp := v_ouv_cp + v_crepa.mt;
      v_autor_cp := v_autor_cp + ( v_crepa.mt * v_tx_autor );
      v_dispo_cp := v_dispo_cp + ( v_crepa.mt * v_tx_autor );
      v_dispo_ordo := v_dispo_ordo + ( v_crepa.mt * v_tx_autor );
    ELSIF v_crepa.cod_mt = 'DEREC' THEN
      v_ouv_cp := v_ouv_cp + v_crepa.mt;
      v_autor_cp := v_autor_cp + v_crepa.mt;
      v_dispo_cp := v_dispo_cp + v_crepa.mt;
      v_dispo_ordo := v_dispo_ordo + v_crepa.mt;
    ELSIF v_crepa.cod_mt = 'VIRCPE' THEN
      v_ouv_cp := v_ouv_cp - v_crepa.mt;
      v_autor_cp := v_autor_cp - ( v_crepa.mt * v_tx_autor );
      v_dispo_cp := v_dispo_cp - ( v_crepa.mt * v_tx_autor );
      v_dispo_ordo := v_dispo_ordo - ( v_crepa.mt * v_tx_autor );
    ELSIF v_crepa.cod_mt = 'ORDON' THEN
      v_ordo := v_ordo + v_crepa.mt;
      v_dispo_ordo := v_dispo_ordo - v_crepa.mt;
    ELSIF v_crepa.cod_mt = 'DEEMI' THEN
      v_deleg_e := v_deleg_e + v_crepa.mt;
      v_dispo_cp := v_dispo_cp - v_crepa.mt;
      v_dispo_ordo := v_dispo_ordo - v_crepa.mt;
    ELSE
      Null;
    END IF;
  END LOOP;
  /* Affectation des paramètres de sortie */
  p_ouv_cp := v_ouv_cp;
  p_autor_cp := v_autor_cp;
  p_deleg_e := v_deleg_e;
  p_dispo_cp := v_dispo_cp;
  p_ordo := v_ordo;
  p_dispo_ordo := v_dispo_ordo;
  p_tx_autor := v_tx_autor;

EXCEPTION
  WHEN err_tx_autor THEN
    /* Si le traitement est interrompu en raison d'un problème      */
    /* lors de la recuperation du taux d'autorisation, les montants */
    /* retournés sont tous egaux a zero et le code retour vaut -1   */
    p_ouv_cp := 0;
    p_autor_cp := 0;
    p_deleg_e := 0;
    p_dispo_cp := 0;
    p_ordo := 0;
    p_dispo_ordo := 0;
    p_tx_autor := 0;
    p_retour := -1;
  WHEN OTHERS THEN
    /* en cas d'erreur les montants retournés sont tous égaux à zéro */
    p_ouv_cp := 0;
    p_autor_cp := 0;
    p_deleg_e := 0;
    p_dispo_cp := 0;
    p_ordo := 0;
    p_dispo_ordo := 0;
    p_tx_autor := 0;
    p_retour := -1;

END CAL_Crepa;

/

CREATE OR REPLACE PROCEDURE CAL_Dephb ( p_ide_poste IN rm_poste.ide_poste%TYPE,
                                         p_ide_ordo IN rb_ordo.ide_ordo%TYPE,
                                         p_cod_bud IN fb_dephb.cod_bud%TYPE,
                                         p_ide_ope IN fb_dephb.ide_ope%TYPE,
                                         p_finan OUT fb_dephb.mt%TYPE,
                                         p_deleg_e OUT fb_dephb.mt%TYPE,
						 p_dispo_finan OUT fb_dephb.mt%TYPE,
						 p_eng_vise OUT fb_dephb.mt%TYPE,
						 p_eng OUT fb_dephb.mt%TYPE,
						 p_eng_deleg OUT fb_dephb.mt%TYPE,
                                         p_dispo_eng OUT fb_dephb.mt%TYPE,
						 p_sdeleg_eng OUT fb_dephb.mt%TYPE,
                                         p_ordo OUT fb_dephb.mt%TYPE,
                                         p_dispo_ordo OUT fb_dephb.mt%TYPE,
					 p_deleng_r OUT fb_dephb.mt%TYPE,
                                         p_retour OUT NUMBER ) IS

/* Paramètres en entrée :				 		  	  		   */
/* 			  p_ide_poste : poste comptable       	  		   */
/*  		  p_ide_ordo : ordonnateur            	  		   */
/* 			  p_cod_bud : code budget             	  		   */
/* 			  p_ide_ope : code opération 					   */
/* Paramètres en sortie :  									   */
/* 			  p_finan : montant des financements		   	   */
/* 			  p_deleg_e : montant des délégations émises	   */
/* 			  p_dispo_finan : montant des financements disponibles */
/*			  p_eng_vise : montant des engagement visés			   */
/*			  p_eng : montant des engagements	  				   */
/*			  p_eng_deleg : montant des engagements délégués	   */
/*			  p_dispo_eng : montant disponible pour engager		   */
/*			  p_sdeleg_eng : montant des engagements sur délégation	 */
/* 			  p_ordo : montant des ordonnances				   */
/*			  p_dispo_ordo : montant disponible pour ordonnancer */
/*			  p_deleng_r : montant des délégations de crédits engagés reçus */
/*			  p_retour : code retour de la procédure : 1 si OK         */
/*			  		   	 	  		 	   			   0 si pas trouve */
/*			  		   	 	  		 	   			   -1 si KO        */



/* Declaration et initialisation des variables de sortie */
v_finan fb_dephb.mt%TYPE := 0;
v_deleg_e fb_dephb.mt%TYPE := 0;
v_dispo_finan fb_dephb.mt%TYPE := 0;
v_eng_vise fb_dephb.mt%TYPE := 0;
v_eng fb_dephb.mt%TYPE := 0;
v_eng_deleg fb_dephb.mt%TYPE := 0;
v_dispo_eng fb_dephb.mt%TYPE := 0;
v_sdeleg_eng fb_dephb.mt%TYPE := 0;
v_ordo fb_dephb.mt%TYPE := 0;
v_dispo_ordo fb_dephb.mt%TYPE := 0;
v_deleng_r fb_dephb.mt%TYPE :=0;

/* Declaration du curseur de parcours de la table fb_dephb */
CURSOR c_dephb IS
SELECT A.cod_mt, A.mt, A.cod_ss_code
FROM fb_dephb A
WHERE
  A.ide_poste = p_ide_poste
  AND A.ide_ordo = p_ide_ordo
  AND A.cod_bud = p_cod_bud
  AND A.ide_ope = p_ide_ope;

BEGIN

  p_retour := 0;

  FOR v_dephb IN c_dephb LOOP
    /* Le curseur a ramene au moins un enregistrement */
    p_retour := 1;
    IF v_dephb.cod_mt = 'PREVI' OR v_dephb.cod_mt = 'DEREC' THEN
      v_finan := v_finan + v_dephb.mt;
      v_dispo_finan := v_dispo_finan + v_dephb.mt;
      v_dispo_eng := v_dispo_eng + v_dephb.mt;
    ELSIF v_dephb.cod_mt = 'DEEMI' THEN
      v_deleg_e := v_deleg_e + v_dephb.mt;
      v_dispo_finan := v_dispo_finan + v_dephb.mt;
      v_dispo_eng := v_dispo_eng - v_dephb.mt;
    ELSIF v_dephb.cod_mt = 'ENGAG' THEN
      v_eng := v_eng + v_dephb.mt;
	  v_dispo_eng := v_dispo_eng - v_dephb.mt;
	  v_dispo_ordo := v_dispo_ordo + v_dephb.mt;
	  v_eng_vise := v_eng_vise + v_dephb.mt;
    ELSIF v_dephb.cod_mt = 'ENGAD' THEN
      v_eng := v_eng + v_dephb.mt;
	  v_dispo_eng := v_dispo_eng - v_dephb.mt;
	  v_eng_deleg := v_eng_deleg + v_dephb.mt;
	ELSIF v_dephb.cod_mt = 'ENGASD' THEN
	  IF v_dephb.cod_ss_code = 'E' THEN
	    v_eng := v_eng + v_dephb.mt;
		v_sdeleg_eng := v_sdeleg_eng + v_dephb.mt;
	  END IF;
	  v_dispo_eng := v_dispo_eng - v_dephb.mt;
	  v_dispo_ordo := v_dispo_ordo + v_dephb.mt;
    ELSIF v_dephb.cod_mt = 'DENGR' THEN
	  IF v_dephb.cod_ss_code = 'E' THEN
	    v_finan := v_finan + v_dephb.mt;
        v_dispo_finan := v_dispo_finan + v_dephb.mt;
		v_dispo_eng := v_dispo_eng + v_dephb.mt;
            v_deleng_r := v_deleng_r + v_dephb.mt;
	  END IF;
	ELSIF v_dephb.cod_mt = 'ORDON' THEN
	  v_ordo := v_ordo + v_dephb.mt;
	  v_dispo_ordo := v_dispo_ordo - v_dephb.mt;
    ELSE
      Null;
    END IF;
  END LOOP;

  /* Affectation des paramètres de sortie */
p_finan := v_finan;
p_deleg_e := v_deleg_e;
p_dispo_finan := v_dispo_finan;
p_eng_vise := v_eng_vise;
p_eng := v_eng;
p_eng_deleg := v_eng_deleg;
p_dispo_eng := v_dispo_eng;
p_sdeleg_eng := v_sdeleg_eng;
p_ordo := v_ordo;
p_dispo_ordo := v_dispo_ordo;
p_deleng_r := v_deleng_r;

EXCEPTION
  WHEN OTHERS THEN
    /* en cas d'erreur les montants retournés sont tous égaux à zéro */
    p_finan := 0;
	p_deleg_e := 0;
	p_dispo_finan := 0;
	p_eng_vise := 0;
	p_eng := 0;
	p_eng_deleg := 0;
	p_dispo_eng := 0;
	p_sdeleg_eng := 0;
	p_ordo := 0;
	p_dispo_ordo := 0;
        p_deleng_r := 0;
	p_retour := -1;

END CAL_Dephb;

/

CREATE OR REPLACE PROCEDURE CAL_Excre (
                 p_ide_poste IN rm_poste.ide_poste%TYPE,
                 p_ide_ordo IN rb_ordo.ide_ordo%TYPE,
                 p_cod_bud IN fb_excre.cod_bud%TYPE,
                 p_ide_lig_exec IN fb_excre.ide_lig_exec%TYPE,
                 p_ide_gest IN fb_excre.ide_gest%TYPE,
                 p_ordo OUT fb_excre.mt%TYPE,
                 p_dso OUT fb_excre.mt%TYPE,
				 p_ordse OUT fb_excre.mt%TYPE,  -- MODIF SGN ANOVA 13,14,36
                 p_retour OUT NUMBER ) IS

/* Paramètres en entree :                                       */
/*     p_ide_poste : poste comptable                            */
/*     p_ide_ordo : ordonnateur                                 */
/*     p_cod_bud : code budget                                  */
/*     p_ide_lig_exec : ligne budgetaire d'execution            */
/*     p_ide_gest : gestion                                     */
/* Paramètres en sortie :                                       */
/*     p_ordo : montant des ordonnances                         */
/*     p_dso : montant DSO                                      */
/*     p_ordse : montant des ordonnances sans engagement        */
/*     p_retour : code retour de la procedure : 1 si OK         */
/*                                              0 si pas trouve */
/*                                              -1 si KO        */

/*-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_EXCRE.sql version 3.0-1.0
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) CAL_EXCRE.sql 1.1-1.0	|--/--/1999 | ---	| Création
-- @(#) CAL_EXCRE.sql 3.0-1.0	|04/10/2002 | SGN	| ANOVA13,14,36 : Prise en compte des
-- @(#) CAL_EXCRE.sql 3.0-1.0	ORDSE  pour le calcul des montants
---------------------------------------------------------------------------------------
*/


/* Declaration et initialisation des variables de sortie */
v_ordo fb_excre.mt%TYPE := 0;
v_dso fb_excre.mt%TYPE := 0;
v_ordse fb_excre.mt%TYPE := 0;  -- Modif SGN ANOVA 13,14,36

/* Declaration du curseur de parcours de la table fb_excre */
CURSOR c_excre IS
SELECT A.cod_mt, A.mt
FROM fb_excre A
WHERE
  A.ide_poste = p_ide_poste
  AND A.ide_ordo = p_ide_ordo
  AND A.cod_bud = p_cod_bud
  AND A.ide_lig_exec = p_ide_lig_exec
  AND A.ide_gest = p_ide_gest;

BEGIN

  p_retour := 0;

  FOR v_excre IN c_excre LOOP
    /* Le curseur a ramene au moins un enregistrement */
    p_retour := 1;
    IF v_excre.cod_mt = 'ORDON' THEN
      v_ordo := v_ordo + v_excre.mt;

    ELSIF v_excre.cod_mt = 'DSO' THEN
      v_dso := v_dso + v_excre.mt;

    -- Modif SGN ANOVA 13,14,36 : Ajout du code montant ORDSE
    ELSIF v_excre.cod_mt = 'ORDSE' THEN
      v_ordse := v_ordse + v_excre.mt;
	-- Fin modif SGN

    ELSE
      Null;
    END IF;
  END LOOP;

  /* Affectation des parametres de sortie */
  p_ordo := v_ordo;
  p_dso := v_dso;
  p_ordse := v_ordse;  -- Modif SGN ANOVA 13,14,36

EXCEPTION

  WHEN OTHERS THEN
    /* en cas d'erreur les montants retournes sont tous égaux à zero */
    p_ordo := 0;
    p_dso := 0;
	p_ordse := 0;  -- Modif SGN ANOVA 13,14,36
    p_retour := -1;

END CAL_Excre;

/

CREATE OR REPLACE PROCEDURE CAL_Execp (
                          p_ide_poste IN rm_poste.ide_poste%TYPE,
                          p_ide_ordo IN rb_ordo.ide_ordo%TYPE,
                          p_cod_bud IN fb_execp.cod_bud%TYPE,
                          p_ide_lig_exec IN fb_execp.ide_lig_exec%TYPE,
                          p_ide_gest IN fb_execp.ide_gest%TYPE,
                          p_ordo OUT fb_execp.mt%TYPE,
                          p_retour OUT NUMBER ) IS

/* Paramètres en entrée :                                       */
/*     p_ide_poste : poste comptable                            */
/*     p_ide_ordo : ordonnateur                                 */
/*     p_cod_bud : code budget                                  */
/*     p_ide_lig_exec : ligne budgétaire d'execution            */
/*     p_ide_gest : gestion                                     */
/* Paramètres en sortie :                                       */
/*     p_ordo : montant des ordonnances                         */
/*     p_retour : code retour de la procédure : 1 si OK         */
/*                                              0 si pas trouve */
/*                                              -1 si KO        */


/* Declaration et initialisation des variables de sortie */
v_ordo fb_execp.mt%TYPE := 0;

/* Declaration du curseur de parcours de la table fb_execp */
CURSOR c_execp IS
SELECT A.cod_mt, A.mt
FROM fb_execp A
WHERE
  A.ide_poste = p_ide_poste
  AND A.ide_ordo = p_ide_ordo
  AND A.cod_bud = p_cod_bud
  AND A.ide_lig_exec = p_ide_lig_exec
  AND A.ide_gest = p_ide_gest;

BEGIN

  p_retour := 0;

  FOR v_execp IN c_execp LOOP
    /* Le curseur a ramene au moins un enregistrement */
    p_retour := 1;
    IF v_execp.cod_mt = 'ORDON' THEN
      v_ordo := v_ordo + v_execp.mt;
    ELSE
      Null;
    END IF;
  END LOOP;

  /* Affectation des paramètres de sortie */
  p_ordo := v_ordo;

EXCEPTION
  WHEN OTHERS THEN
    /* en cas d'erreur les montants retournés sont tous égaux à zéro */
    p_ordo := 0;
    p_retour := -1;

END CAL_Execp;

/

CREATE OR REPLACE PROCEDURE CAL_Exere (
                      p_ide_poste IN rm_poste.ide_poste%TYPE,
                      p_ide_ordo IN rb_ordo.ide_ordo%TYPE,
                      p_cod_bud IN fb_exere.cod_bud%TYPE,
                      p_ide_lig_exec IN fb_exere.ide_lig_exec%TYPE,
                      p_ide_gest IN fb_exere.ide_gest%TYPE,
                      p_ordre_rec OUT fb_exere.mt%TYPE,
                      p_enc_rec OUT fb_exere.mt%TYPE,
					  p_ordo OUT fb_exere.mt%TYPE,  -- MODIF SGN ANOVA 13,14,36
                      p_retour OUT NUMBER
					   ) IS

/* Paramètres en entrée :                                      */
/*           p_ide_poste : poste comptable                     */
/*           p_ide_ordo : ordonnateur                          */
/*           p_cod_bud : code budget                           */
/*           p_ide_lig_exec : ligne budgétaire d'execution     */
/*           p_ide_gest : gestion                              */
/* Paramètres en sortie :                                      */
/*           p_ordre_rec : montant des ordres de recette enregistrés                */
/*           p_enc_rec : montant des encaissements de recette comptabilisés         */
/*           p_ordo : montant des ordonnance enregistrées                           */
/*           p_retour : code retour de la procédure : 1 si OK                       */
/*                                                    0 si pas trouve               */
/*                                                    -1 si KO                      */
/*-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_EXERE.sql version 3.0-1.0
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) CAL_EXERE.sql 1.1-1.0	|--/--/1999 | ---	| Création
-- @(#) CAL_EXERE.sql 3.0-1.0	|04/10/2002 | SGN	| ANOVA13,14,36 : Prise en compte des
-- @(#) CAL_EXERE.sql 3.0-1.0	ORDON  pour le calcul des montants
---------------------------------------------------------------------------------------
*/


/* Declaration et initialisation des variables de sortie */
v_ordre_rec fb_exere.mt%TYPE := 0;
v_enc_rec fb_exere.mt%TYPE := 0;
v_ordo fb_exere.mt%TYPE := 0;  -- Modif SGN ANOVA 13,14,36

/* Declaration du curseur de parcours de la table fb_exere */
CURSOR c_exere IS
SELECT A.cod_mt, A.mt
FROM fb_exere A
WHERE
  A.ide_poste = p_ide_poste
  AND A.ide_ordo = p_ide_ordo
  AND A.cod_bud = p_cod_bud
  AND A.ide_lig_exec = p_ide_lig_exec
  AND A.ide_gest = p_ide_gest;

BEGIN

  p_retour := 0;

  FOR v_exere IN c_exere LOOP
    /* Le curseur a ramene au moins un enregistrement */
    p_retour := 1;
    IF v_exere.cod_mt = 'ORDRE' THEN
      v_ordre_rec := v_ordre_rec + v_exere.mt;
    ELSIF v_exere.cod_mt = 'ENCREC' THEN
      v_enc_rec := v_enc_rec + v_exere.mt;
    -- Modif SGN ANOVA 13,14,36 : Ajout du code montant ORDON
    ELSIF v_exere.cod_mt = 'ORDON' THEN
      v_ordo := v_ordo + v_exere.mt;
	-- Fin modif SGN
    ELSE
      Null;
    END IF;
  END LOOP;

  /* Affectation des paramètres de sortie */
  p_ordre_rec := v_ordre_rec;
  p_enc_rec := v_enc_rec;
  p_ordo := v_ordo;  -- Modif SGN ANOVA 13,14,36

EXCEPTION
  WHEN OTHERS THEN
    /* en cas d'erreur les montants retournés sont tous égaux à zéro */
    p_ordre_rec := 0;
    p_enc_rec := 0;
	p_ordo := 0;  -- Modif SGN ANOVA 13,14,36
    p_retour := -1;

END CAL_Exere;

/

CREATE OR REPLACE PROCEDURE CAL_Exres ( p_ide_poste IN rm_poste.ide_poste%TYPE,
                                        p_ide_ordo IN rb_ordo.ide_ordo%TYPE,
                                        p_cod_bud IN fb_exres.cod_bud%TYPE,
                                        p_ide_lig_exec IN fb_exres.ide_lig_exec%TYPE,
                                        p_ide_ope IN fb_exres.ide_ope%TYPE,
                                        p_ordo OUT fb_exres.mt%TYPE,
                                        p_retour OUT NUMBER ) IS

/* Paramètres en entrée :                                                             */
/*       p_ide_poste : poste comptable                                                */
/*       p_ide_ordo : ordonnateur                                                     */
/*       p_cod_bud : code budget                                                      */
/*       p_ide_lig_exec : ligne budgétaire d'execution                                */
/*       p_ide_ope : code operation                                                   */
/* Paramètres en sortie :                                                             */
/*       p_ordo : montant des ordonnances                                             */
/*       p_retour : code retour de la procédure : 1 si OK                             */
/*                                                0 si pas trouve                     */
/*                                                -1 si KO                            */

/* Declaration et initialisation des variables de sortie */
v_ordo fb_exres.mt%TYPE := 0;

/* Declaration du curseur de parcours de la table fb_exres */
CURSOR c_exres IS
SELECT A.cod_mt, A.mt
FROM fb_exres A
WHERE
  A.ide_poste = p_ide_poste
  AND A.ide_ordo = p_ide_ordo
  AND A.cod_bud = p_cod_bud
  AND A.ide_ope = p_ide_ope
  AND A.ide_lig_exec = p_ide_lig_exec;

BEGIN

  p_retour := 0;

  FOR v_exres IN c_exres LOOP
    /* Le curseur a ramene au moins un enregistrement */
    p_retour := 1;
    IF v_exres.cod_mt = 'ORDON' THEN
      v_ordo := v_ordo + v_exres.mt;
    ELSE
      Null;
    END IF;
  END LOOP;

  /* Affectation des paramètres de sortie */
  p_ordo := v_ordo;


EXCEPTION
  WHEN OTHERS THEN
    /* en cas d'erreur les montants retournés sont tous égaux à zéro */
    p_ordo := 0;
    p_retour := -1;

END CAL_Exres;

/

CREATE OR REPLACE PROCEDURE CAL_Num_Trait (
      p_ide_poste IN rm_poste.ide_poste%TYPE,
      p_ide_gest IN fn_gestion.ide_gest%TYPE,
      p_ide_trt OUT NUMBER,
      p_retour OUT NUMBER ) IS

/* Paramètres en entrée :                     */
/*    p_ide_poste : poste comptable           */
/*    p_ide_ordo : gestion                    */
/* Paramètres en sortie :                     */
/*    p_ide_trt : numero de traitement        */
/*    p_retour : code retour de la procédure: */
/*               1 si OK                      */
/*               -1 sinon                     */


CURSOR c_fc_num_trait IS
SELECT ide_trt
FROM FC_NUM_TRAIT
WHERE ide_poste = p_ide_poste
  AND ide_gest = p_ide_gest
FOR UPDATE OF ide_trt
NOWAIT;

r_fc_num_trait c_fc_num_trait%ROWTYPE;
v_cod_util fc_num_trait.uti_maj%TYPE := USER;
v_terminal fc_num_trait.terminal%TYPE;


BEGIN

  SELECT NVL(USERENV('terminal'),'unknown')
  INTO v_terminal
  FROM dual;

  IF c_fc_num_trait%ISOPEN THEN
    CLOSE c_fc_num_trait;
  END IF;

  OPEN c_fc_num_trait;
  FETCH c_fc_num_trait INTO r_fc_num_trait;

  IF c_fc_num_trait%NOTFOUND THEN
    /* Pas trouve : on le crée */
    INSERT INTO FC_NUM_TRAIT
    VALUES ( p_ide_poste, p_ide_gest, 1,
             SYSDATE, v_cod_util, SYSDATE, v_cod_util, v_terminal );
    p_ide_trt := 1;

  ELSE
    /* Trouve, on le met a jour */
    UPDATE FC_NUM_TRAIT
    SET ide_trt = r_fc_num_trait.ide_trt + 1
    WHERE CURRENT OF c_fc_num_trait;
    p_ide_trt := r_fc_num_trait.ide_trt + 1;

  END IF;

  CLOSE c_fc_num_trait;

  p_retour := 1;

EXCEPTION
  WHEN OTHERS THEN
    p_retour := -1;

END CAL_Num_Trait;

/

CREATE OR REPLACE PROCEDURE CAL_Preop (
                      p_ide_poste IN rm_poste.ide_poste%TYPE,
                      p_ide_ordo IN rb_ordo.ide_ordo%TYPE,
                      p_cod_bud IN fb_preop.cod_bud%TYPE,
					  p_ide_ope IN fb_preop.ide_ope%TYPE,
                      p_ide_lig_prev IN fb_preop.ide_lig_prev%TYPE,
                      p_prev OUT fb_preop.mt%TYPE,
                      p_ord_rec_enreg OUT fb_preop.mt%TYPE,
                      p_enc_rec OUT fb_preop.mt%TYPE,
                      p_retour OUT NUMBER ) IS

/*
---------------------------------------------------------------------------------------
-- Nom           : CAL_Preop
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 17/09/2001
-- ---------------------------------------------------------------------------
-- Role          : Calcul des montants stockes dans la table des situations
-- 				   		  par opération (FB_PREOP)
--
-- Parametres    :
-- Paramètres en entrée :
--           p_ide_poste : poste comptable
--           p_ide_ordo : ordonnateur
--           p_cod_bud : code budget
--           p_ide_ope : identifiant d operation
--           p_ide_lig_prev : ligne budgétaire de prevision
--
-- Paramètres en sortie :
--           p_prev : montant des previsions de recette
--           p_ord_rec_enreg : montant des ordres de recette enregistrés
--           p_enc_rec : montant des encaissements de recette comptabilisés
--           p_retour : code retour de la procédure : 1 si OK
--                                                    0 si pas trouve
--                                                    -1 si KO
-- Valeur retournee : Aucun
--
-- Appels		 : PACKAGE DBMS_SQL
-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_Preop.sql version 2.1-1.0 : SNE : 17/09/2001
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	 |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) CAL_Preop.sql 2.1-1.0	|17/09/2001 | SGN	| Création
---------------------------------------------------------------------------------------
*/




/* Declaration et initialisation des variables de sortie */
v_prev fb_preop.mt%TYPE := 0;
v_ord_rec_enreg fb_preop.mt%TYPE := 0;
v_enc_rec fb_preop.mt%TYPE := 0;

/* Declaration du curseur de parcours de la table fb_preop */
CURSOR c_preop IS
SELECT A.cod_mt, A.mt
FROM fb_preop A
WHERE
  A.ide_poste = p_ide_poste
  AND A.ide_ordo = p_ide_ordo
  AND A.cod_bud = p_cod_bud
  AND A.ide_lig_prev = p_ide_lig_prev
  AND A.ide_ope = p_ide_ope;

BEGIN

  p_retour := 0;

  FOR v_preop IN c_preop LOOP
    /* Le curseur a ramene au moins un enregistrement */
    p_retour := 1;
    IF v_preop.cod_mt = 'PREVI' THEN
      v_prev := v_prev + v_preop.mt;
    ELSIF v_preop.cod_mt = 'ORDRE' THEN
      v_ord_rec_enreg := v_ord_rec_enreg + v_preop.mt;
    ELSIF v_preop.cod_mt = 'ENCREC' THEN
      v_enc_rec := v_enc_rec + v_preop.mt;
    ELSE
      Null;
    END IF;
  END LOOP;

  /* Affectation des paramètres de sortie */
  p_prev := v_prev;
  p_ord_rec_enreg := v_ord_rec_enreg;
  p_enc_rec := v_enc_rec;

EXCEPTION
  WHEN OTHERS THEN
    /* en cas d'erreur les montants retournés sont tous égaux à zéro */
    p_prev := 0;
    p_ord_rec_enreg := 0;
    p_enc_rec := 0;
    p_retour := -1;
	RAISE;

END CAL_Preop;

/

CREATE OR REPLACE PROCEDURE CAL_Prere (
                      p_ide_poste IN rm_poste.ide_poste%TYPE,
                      p_ide_ordo IN rb_ordo.ide_ordo%TYPE,
                      p_cod_bud IN fb_prere.cod_bud%TYPE,
                      p_ide_lig_prev IN fb_prere.ide_lig_prev%TYPE,
                      p_ide_gest IN fb_prere.ide_gest%TYPE,
                      p_previ_rec OUT fb_prere.mt%TYPE,
                      p_ordre_rec OUT fb_prere.mt%TYPE,
                      p_enc_rec OUT fb_prere.mt%TYPE,
					  p_ordo OUT fb_prere.mt%TYPE,  -- MODIF SGN ANOVA 13,14,36
                      p_retour OUT NUMBER
					   ) IS

/* Paramètres en entrée :                                      */
/*           p_ide_poste : poste comptable                     */
/*           p_ide_ordo : ordonnateur                          */
/*           p_cod_bud : code budget                           */
/*           p_ide_lig_prev : ligne budgétaire de prevision    */
/*           p_ide_gest : gestion                              */
/* Paramètres en sortie :                                      */
/*           p_previ_rec : montant des previsions de recette                        */
/*           p_ordre_rec : montant des ordres de recette enregistrés                */
/*           p_enc_rec : montant des encaissements de recette comptabilisés         */
/*           p_ordo : montant des ordonnance enregistrées                           */
/*           p_retour : code retour de la procédure : 1 si OK                       */
/*                                                    0 si pas trouve               */
/*                                                    -1 si KO                      */
/*-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_PRERE.sql version 3.0-1.0
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) CAL_PRERE.sql 1.1-1.0	|--/--/1999 | ---	| Création
-- @(#) CAL_PRERE.sql 3.0-1.0	|04/10/2002 | SGN	| ANOVA13,14,36 : Prise en compte des
-- @(#) CAL_PRERE.sql 3.0-1.0	ORDON  pour le calcul des montants
---------------------------------------------------------------------------------------
*/


/* Declaration et initialisation des variables de sortie */
v_previ_rec fb_prere.mt%TYPE := 0;
v_ordre_rec fb_prere.mt%TYPE := 0;
v_enc_rec fb_prere.mt%TYPE := 0;
v_ordo fb_prere.mt%TYPE := 0;  -- Modif SGN ANOVA 13,14,36;

/* Declaration du curseur de parcours de la table fb_dephb */
CURSOR c_prere IS
SELECT A.cod_mt, A.mt
FROM fb_prere A
WHERE
  A.ide_poste = p_ide_poste
  AND A.ide_ordo = p_ide_ordo
  AND A.cod_bud = p_cod_bud
  AND A.ide_lig_prev = p_ide_lig_prev
  AND A.ide_gest = p_ide_gest;

BEGIN

  p_retour := 0;

  FOR v_prere IN c_prere LOOP
    /* Le curseur a ramene au moins un enregistrement */
    p_retour := 1;
    IF v_prere.cod_mt = 'PREVI' THEN
      v_previ_rec := v_previ_rec + v_prere.mt;
    ELSIF v_prere.cod_mt = 'ORDRE' THEN
      v_ordre_rec := v_ordre_rec + v_prere.mt;
    ELSIF v_prere.cod_mt = 'ENCREC' THEN
      v_enc_rec := v_enc_rec + v_prere.mt;
    -- Modif SGN ANOVA 13,14,36 : Ajout du code montant ORDON
    ELSIF v_prere.cod_mt = 'ORDON' THEN
      v_ordo := v_ordo + v_prere.mt;
	-- Fin modif SGN
    ELSE
      Null;
    END IF;
  END LOOP;

  /* Affectation des paramètres de sortie */
  p_previ_rec := v_previ_rec;
  p_ordre_rec := v_ordre_rec;
  p_enc_rec := v_enc_rec;
  p_ordo := v_ordo;  -- Modif SGN ANOVA 13,14,36

EXCEPTION
  WHEN OTHERS THEN
    /* en cas d'erreur les montants retournés sont tous égaux à zéro */
    p_previ_rec := 0;
    p_ordre_rec := 0;
    p_enc_rec := 0;
	p_ordo := 0;  -- Modif SGN ANOVA 13,14,36
    p_retour := -1;

END CAL_Prere;

/

CREATE OR REPLACE PROCEDURE CAL_Rechb ( p_ide_poste IN rm_poste.ide_poste%TYPE,
                      p_ide_ordo IN rb_ordo.ide_ordo%TYPE,
                      p_cod_bud IN fb_rechb.cod_bud%TYPE,
                      p_ide_ope IN fb_rechb.ide_ope%TYPE,
                      p_previ_rec OUT fb_rechb.mt%TYPE,
		      p_ordre_rec OUT fb_rechb.mt%TYPE,
                      p_enc_rec OUT fb_rechb.mt%TYPE,
                      p_retour OUT NUMBER ) IS

/* Paramètres en entrée :				 		  	         */
/* 			  p_ide_poste : poste comptable       	  		         */
/*  		  p_ide_ordo : ordonnateur            	  		                 */
/* 			  p_cod_bud : code budget             	  		         */
/* 			  p_ide_ope : code opération 					 */
/* Paramètres en sortie :  								 */
/* 			  p_previ_rec : montant des previsions de recette                */
/* 			  p_ordre_rec : montant des ordres de recette enregistrés 	 */
/* 			  p_enc_rec : montant des encaissements de recette comptabilisés */
/*			  p_retour : code retour de la procédure : 1 si OK        	 */
/*			  	 		 		   0 si pas trouve 	 */
/*			  		     			   -1 si KO     	 */



/* Declaration et initialisation des variables de sortie */
v_previ_rec fb_rechb.mt%TYPE := 0;
v_ordre_rec fb_rechb.mt%TYPE := 0;
v_enc_rec fb_rechb.mt%TYPE := 0;

/* Declaration du curseur de parcours de la table fb_dephb */
CURSOR c_rechb IS
SELECT A.cod_mt, A.mt
FROM fb_rechb A
WHERE
  A.ide_poste = p_ide_poste
  AND A.ide_ordo = p_ide_ordo
  AND A.cod_bud = p_cod_bud
  AND A.ide_ope = p_ide_ope;

BEGIN

  p_retour := 0;

  FOR v_rechb IN c_rechb LOOP
    /* Le curseur a ramene au moins un enregistrement */
    p_retour := 1;
    IF v_rechb.cod_mt = 'PREVI' THEN
      v_previ_rec := v_previ_rec + v_rechb.mt;
    ELSIF v_rechb.cod_mt = 'ORDRE' THEN
      v_ordre_rec := v_ordre_rec + v_rechb.mt;
    ELSIF v_rechb.cod_mt = 'ENCREC' THEN
      v_enc_rec := v_enc_rec + v_rechb.mt;
    ELSE
      Null;
    END IF;
  END LOOP;

  /* Affectation des paramètres de sortie */
p_previ_rec := v_previ_rec;
p_ordre_rec := v_ordre_rec;
p_enc_rec := v_enc_rec;

EXCEPTION
  WHEN OTHERS THEN
    /* en cas d'erreur les montants retournés sont tous égaux à zéro */
    p_previ_rec := 0;
    p_ordre_rec := 0;
    p_enc_rec := 0;
	p_retour := -1;

END CAL_Rechb;

/

CREATE OR REPLACE PROCEDURE Cal_Reser (
           p_ide_poste IN RM_POSTE.ide_poste%TYPE,
           p_ide_ordo IN RB_ORDO.ide_ordo%TYPE,
           p_cod_bud IN FB_RESER.cod_bud%TYPE,
           p_ide_ope IN FB_RESER.ide_ope%TYPE,
           p_ide_lig_prev IN FB_RESER.ide_lig_prev%TYPE,
           p_reserv OUT FB_RESER.mt%TYPE,
           p_deleg_e OUT FB_RESER.mt%TYPE,
           p_dispo_res OUT FB_RESER.mt%TYPE,
           p_eng OUT FB_RESER.mt%TYPE,
           p_eng_deleg OUT FB_RESER.mt%TYPE,
           p_dispo_eng OUT FB_RESER.mt%TYPE,
           p_sdeleg_eng OUT FB_RESER.mt%TYPE,
           p_ordo OUT FB_RESER.mt%TYPE,
           p_dispo_ordo OUT FB_RESER.mt%TYPE,
           p_deleng_r OUT FB_RESER.mt%TYPE,
           p_retour OUT NUMBER ) IS

/* Paramètres en entrée :                                                      */
/*         p_ide_poste : poste comptable                                       */
/*         p_ide_ordo : ordonnateur                                            */
/*         p_cod_bud : code budget                                             */
/*         p_ide_ope : code operation                                          */
/*         p_ide_lig_prev : ligne budgétaire de prévision                      */
/* Paramètres en sortie :                                                      */
/*         p_reserv : montant des reservations	                               */
/*         p_deleg_e : montant des délégations émises                          */
/*         p_dispo_res : montant des reservations disponibles                  */
/*         p_eng : montant des engagements                                     */
/*         p_eng_deleg : montant des engagements delegues                      */
/*         p_dispo_eng : montant disponible a engager                          */
/*         p_sdeleg_eng : montant des engagements sur delegation               */
/*         p_ordo : montant des ordonnances                                    */
/*         p_dispo_ordo : montant disponible pour ordonnancer                  */
/*         p_deleng_r : montant des délégations de crédits engagés reçus       */
/*         p_retour : code retour de la procédure : 1 si OK                    */
/*                                                  0 si pas trouve            */
/*                                                  -1 si KO                   */

/* Declaration et initialisation des variables de sortie */
v_reserv FB_RESER.mt%TYPE := 0;
v_deleg_e FB_RESER.mt%TYPE := 0;
v_dispo_res FB_RESER.mt%TYPE := 0;
v_eng FB_RESER.mt%TYPE := 0;
v_eng_deleg FB_RESER.mt%TYPE :=0;
v_dispo_eng FB_RESER.mt%TYPE := 0;
v_sdeleg_eng FB_RESER.mt%TYPE := 0;
v_ordo FB_RESER.mt%TYPE := 0;
v_dispo_ordo FB_RESER.mt%TYPE := 0;
v_deleng_r FB_RESER.mt%TYPE := 0;

/* Declaration du curseur de parcours de la table fb_reser */
CURSOR c_reser IS
SELECT A.cod_mt, A.mt, A.cod_ss_code
FROM FB_RESER A
WHERE
  A.ide_poste = p_ide_poste
  AND A.ide_ordo = p_ide_ordo
  AND A.cod_bud = p_cod_bud
  AND A.ide_ope = p_ide_ope
  AND A.ide_lig_prev = p_ide_lig_prev;

BEGIN

  p_retour := 0;

  FOR v_reser IN c_reser LOOP
    /* Le curseur a ramene au moins un enregistrement */
    p_retour := 1;
    IF v_reser.cod_mt = 'RESERR' OR v_reser.cod_mt = 'DEREC' THEN
      v_reserv := v_reserv + v_reser.mt;
      v_dispo_eng := v_dispo_eng + v_reser.mt;
      v_dispo_res := v_dispo_res + v_reser.mt;

    ELSIF v_reser.cod_mt = 'DEEMI' THEN
      v_deleg_e := v_deleg_e + v_reser.mt;
      v_dispo_eng := v_dispo_eng - v_reser.mt;
      v_dispo_res := v_dispo_res - v_reser.mt;

    ELSIF v_reser.cod_mt = 'ENGAG' THEN
      v_eng := v_eng + v_reser.mt;
      v_dispo_eng := v_dispo_eng - v_reser.mt;
      v_dispo_ordo := v_dispo_ordo + v_reser.mt;

    ELSIF v_reser.cod_mt = 'ENGAD' THEN
      v_eng := v_eng + v_reser.mt;
      v_dispo_eng := v_dispo_eng - v_reser.mt;
      v_eng_deleg := v_eng_deleg + v_reser.mt;

    ELSIF v_reser.cod_mt = 'ENGASD' THEN
      IF v_reser.cod_ss_code = 'E' THEN
        v_eng := v_eng + v_reser.mt;
        v_sdeleg_eng := v_sdeleg_eng + v_reser.mt;
      END IF;
      v_dispo_eng := v_dispo_eng - v_reser.mt;
      v_dispo_ordo := v_dispo_ordo + v_reser.mt;

    ELSIF v_reser.cod_mt = 'DENGR' THEN
      IF v_reser.cod_ss_code = 'E' THEN
        v_reserv := v_reserv + v_reser.mt;
        v_dispo_res := v_dispo_res + v_reser.mt;
        v_dispo_eng := v_dispo_eng + v_reser.mt;
        v_deleng_r := v_deleng_r + v_reser.mt;
      END IF;

    ELSIF v_reser.cod_mt = 'ORDON' THEN
      v_ordo := v_ordo + v_reser.mt;
      v_dispo_ordo := v_dispo_ordo - v_reser.mt;

    ELSE
      NULL;
    END IF;
  END LOOP;

  /* Affectation des paramètres de sortie */
  p_reserv := v_reserv;
  p_deleg_e := v_deleg_e;
  p_dispo_res := v_dispo_res ;
  p_eng := v_eng;
  p_eng_deleg := v_eng_deleg;
  p_dispo_eng := v_dispo_eng;
  p_sdeleg_eng := v_sdeleg_eng;
  p_ordo := v_ordo;
  p_dispo_ordo := v_dispo_ordo;
  p_deleng_r := v_deleng_r;

EXCEPTION
  WHEN OTHERS THEN
    /* en cas d'erreur les montants retournés sont tous égaux à zéro */
    p_reserv := 0;
    p_deleg_e := 0;
    p_dispo_res := 0;
    p_eng := 0;
    p_eng_deleg := 0;
    p_dispo_eng := 0;
    p_sdeleg_eng := 0;
    p_ordo := 0;
    p_dispo_ordo := 0;
    p_deleng_r := 0;
    p_retour := -1;

END Cal_Reser;

/

CREATE OR REPLACE PROCEDURE CTL_MASQ_CPT_BQ (
                              p_cpt_bq IN FB_COORD_BANC.cpt_bq%TYPE,
                              p_caract IN VARCHAR2,
                              p_masque IN SR_PARAM.val_param%TYPE,
                              p_retour OUT NUMBER )
IS
/*--------------------------------------------------------------------------*/
/* Contrôle de validité de la saisie du compte bancaire                     */
/* ENTREE : le compte                                                       */
/* SORTIE : le masque à respecter                                           */
/*          le code retour : 	1 = tout va bien                              */
/*                           -1 = saisie incorrecte                         */
/*--------------------------------------------------------------------------*/
v_number	NUMBER(1);
v_car_vide VARCHAR2(1);

BEGIN
  /* si l'un des paramètres pays est vide */
  /* si le masque ne comporte qu'un caractère non significatif, aucun contrôle à faire */
  IF p_masque IS NULL
     OR p_cpt_bq IS NULL
     OR p_caract IS NULL
     OR (LENGTH(p_masque) = 1
         AND p_masque <> '9'
         AND p_masque <> p_caract)
  THEN
    p_retour := 1;
    RETURN;
  END IF;

  /* si le masque est plus court que la saisie : erreur */
  IF LENGTH(p_masque) < LENGTH(p_cpt_bq) THEN
    p_retour := -1;
    RETURN;
  END IF;

  /* si le masque est plus long que la saisie :	*/
  /*   si les caractères en dépassement dans le masque sont des caractères génériques	*/
  /*   alors pas encore d'anomalie	*/
  /* sinon on est déjà en anomalie	*/
  IF LENGTH(p_masque) > LENGTH(p_cpt_bq) THEN
    FOR i IN (LENGTH(p_cpt_bq)+1)..LENGTH(p_masque)
    LOOP
      IF SUBSTR(p_masque, i, 1) <> p_caract THEN
        p_retour := -1;
      END IF;
      EXIT WHEN p_retour = -1;
    END LOOP;
    IF p_retour = -1 THEN
      RETURN;
    END IF;
  END IF;

  /* Pour la longueur commune au masque et au compte bancaire	*/
  /*	contrôle de chaque caractère	*/
  FOR i IN 1..LENGTH(p_cpt_bq)
  LOOP
    IF SUBSTR(p_masque, i, 1) <> p_caract
       AND SUBSTR(p_masque, i, 1) <> '9'
    THEN
      IF SUBSTR(p_cpt_bq, i, 1) <> SUBSTR(p_masque, i, 1)	THEN
        p_retour := -1;
      END IF;
    ELSIF SUBSTR(p_masque, i, 1) = '9'
    THEN
      v_car_vide := SUBSTR(p_cpt_bq, i, 1);
      IF v_car_vide = ' ' THEN
        p_retour := -1;
      ELSE
        BEGIN
          v_number := to_number(SUBSTR(p_cpt_bq, i, 1));
        EXCEPTION
          WHEN OTHERS THEN
            p_retour := -1;
        END;
      END IF;
    END IF;
    EXIT WHEN p_retour = -1;
  END LOOP;
  IF p_retour <> -1 THEN
    p_retour := 1;
  END IF;

EXCEPTION
  WHEN others THEN
    p_retour := -1;
END CTL_MASQ_CPT_BQ;

/

CREATE OR REPLACE PROCEDURE DELETE_VAR_CPTA (
    p_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
    p_ret OUT NUMBER)
IS
/*---------------------------------------------------------------------------------------
-- Nom           : DELETE_VAR_CPTA
-- --------------------------------------------------------------------------------------
--  Auteur       : FBT
--  Date creation: 24/09/2007
-- ---------------------------------------------------------------------------
-- Role          : Supprimer une variation comptable existante non diffusé
-- Parametres    :
--      1 - p_var_cpta_orig 	- variation comptable a supprimer ex: VLOLF
--      2 - p_ret				- Code retour (0->OK, autre erreur)
-- --------------------------------------------------------------------
-- Fonction         	   |Version	|Date     	|Initiales 	|Commentaires
-- --------------------------------------------------------------------
-- @(#) DELETE_VAR_CPTA    |V4220	|24/09/2007	|FBT 		|Création
---------------------------------------------------------------------------------------*/

BEGIN
	DELETE FROM PC_PEC_ECART_CHANGE WHERE var_cpta=p_var_cpta;
	DELETE FROM PC_PEC_REGLEMENT WHERE var_cpta=p_var_cpta;
	DELETE FROM FN_CPT_PLAN WHERE var_cpta=p_var_cpta;
	DELETE FROM PC_PRISE_CHARGE WHERE var_cpta=p_var_cpta;
	DELETE FROM SR_CPT_TRT WHERE var_cpta=p_var_cpta;
	DELETE FROM PR_CRITERE_CENTRA WHERE var_cpta=p_var_cpta;
	DELETE FROM PR_ACTION_CENTRA WHERE var_cpta=p_var_cpta;
	DELETE FROM PR_GROUPE_ACTION WHERE var_cpta=p_var_cpta;
	DELETE FROM RC_MODELE_LIGNE WHERE var_cpta=p_var_cpta;
	DELETE FROM RC_SCHEMA_CPTA WHERE var_cpta=p_var_cpta;
	DELETE FROM RC_DROIT_COMPTE WHERE var_cpta=p_var_cpta;
	DELETE FROM RC_DROIT_JOURNAL WHERE var_cpta=p_var_cpta;
	DELETE FROM RC_SPEC WHERE var_cpta=p_var_cpta;
	DELETE FROM RC_LISTE_COMPTE WHERE var_cpta=p_var_cpta;
	DELETE FROM FC_JOURNAL WHERE var_cpta=p_var_cpta;
	DELETE FROM FN_COMPTE WHERE var_cpta=p_var_cpta;
	DELETE FROM PN_VAR_CPTA WHERE var_cpta=p_var_cpta;
    p_ret:=0;
EXCEPTION
    WHEN OTHERS THEN
    p_ret:=1;
END;

/

CREATE OR REPLACE PROCEDURE DUPLIQUER_DATA (
    p_var_cpta_orig IN VARCHAR2,
    p_var_cpta_cible IN VARCHAR2,
    p_tablename IN VARCHAR2,
	p_date_perime IN DATE,
    p_nb_ligne_dup OUT NUMBER,
    p_nb_ligne_ano OUT NUMBER,
    p_ret OUT NUMBER)
IS

/*---------------------------------------------------------------------------------------
-- Nom           : DUPLIQUER_DATA
-- --------------------------------------------------------------------------------------
--  Auteur       : FBT
--  Date creation: 18/04/2007
-- ---------------------------------------------------------------------------
-- Role          : Dupliquer les lignes d'une variation comptable pour en créer de nouvelle sur une table données
--
-- Parametres    :
--      1 - p_var_cpta_orig 	- variation comptable a dupliquer ex: VLOLF
--      2 - p_var_cpta_cible 	- variation comptable a créer     ex: VLOLA
--      3 - p_tablename 		- Table a traiter
--      4 - p_nb_ligne_dup 		- Nombre de ligne traitées (non utilisé)
--      5 - p_nb_ligne_ano      - Nombre de ligne en annomalies (non utilisé)
--      6 - p_ret				- Code retour (0->OK, autre erreur)
--  --------------------------------------------------------------------
--  Fonction         	|Version	|Date     	|Initiales 	|Commentaires
--  --------------------------------------------------------------------
-- @(#) DUPLIQUER_DATA 	|V4200	 	|18/04/2007 	|FBT 		|Création
-- @(#) DUPLIQUER_DATA 	|V4220	 	|25/09/2007 	|FBT 		|Mise à jour suite à l'évolution DI44_CC2007_09
---------------------------------------------------------------------------------------*/

  --exception spécial
  ObjectExists EXCEPTION;
  PRAGMA EXCEPTION_INIT(ObjectExists,-955);
  ItemExists EXCEPTION;
  PRAGMA EXCEPTION_INIT(ItemExists,-1);

  --la requette de copie
  v_req VARCHAR2(2000) ;

BEGIN

   --retour par défaut de procédure
   p_ret:=0;
   p_nb_ligne_ano:=0;
   p_nb_ligne_dup:=0;

   --Copie des données de la table permanente vers la table temporaire
   IF p_date_perime IS NOT NULL THEN
   	  -- FBT, 25/09/2007 - Filtrage par date pour l'evol DI44_CC2007_09
   	  v_req:='CREATE TABLE TempData AS SELECT * FROM '||p_tablename||' WHERE var_cpta='''||p_var_cpta_orig||''' AND (dat_fval IS NULL OR trunc(dat_fval) > trunc(to_date('''||to_char(p_date_perime)||''')))';
	  EXECUTE IMMEDIATE v_req;
   ELSE
   	  v_req:='CREATE TABLE TempData AS SELECT * FROM '||p_tablename||' WHERE var_cpta='''||p_var_cpta_orig||'''';
   	  EXECUTE IMMEDIATE v_req;
   END IF;

   --modification des données en table temporaires (variation comptable)
   v_req:='UPDATE TempData SET var_cpta='''||p_var_cpta_cible||'''';
   EXECUTE IMMEDIATE v_req;

   --injection des données de la table temporaire vers la table permanente
   v_req:='INSERT INTO '||p_tablename||' SELECT * FROM TempData';
   EXECUTE IMMEDIATE v_req;

   --suppresion table temporaire
   v_req:='DROP TABLE PIAF_ADM.TempData';
   EXECUTE IMMEDIATE v_req;

EXCEPTION
   --violation de contraintes clé unique
   WHEN ItemExists THEN
	  p_ret:=3;
	  v_req:='DROP TABLE PIAF_ADM.TempData';
   	  EXECUTE IMMEDIATE v_req;
   --table deja existante
   WHEN ObjectExists THEN
      v_req:='DROP TABLE PIAF_ADM.TempData';
   	  EXECUTE IMMEDIATE v_req;
	  p_ret:=2;
   --autre
   WHEN OTHERS THEN
   	  v_req:='DROP TABLE PIAF_ADM.TempData';
   	  EXECUTE IMMEDIATE v_req;
	  p_ret:=1;
END;

/

CREATE OR REPLACE PROCEDURE EXT_CODEXT (p_typ_codif IN SR_Codif.cod_typ_codif%TYPE,
                                        p_ide_codif IN SR_Codif.ide_codif%TYPE,
                                        p_libl OUT SR_Codif.libl%TYPE,
                                        p_cod_codif OUT SR_Codif.cod_codif%TYPE,
                                        p_ret OUT NUMBER ) IS

/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_CODEXT
-- ---------------------------------------------------------------------------
--  Auteur         : ---
--  Date creation  : --/--/1999
-- ---------------------------------------------------------------------------
-- Role          : Recherche dans la table SR_CODIF de la valeur du code externe
--
-- Parametres    :
-- 		En Entree
-- 				 1 - p_cod_typ_codif
--				 2 - p_ide_codif
-- 		En Sortie
--		   		 3 - p_libl
--				 4 - p_cod_codif
--				 5 - p_ret : 0 si non trouvé
--                                1 si trouve et valide
--    			    2 si trouve et non valide
--					Autres erreurs liées à la base : remontées (exception) et p_ret = -1

--
-- Valeur retournee : Aucun
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_CODEXT.sql version 2.1-1.1
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) EXT_CODEXT.sql 1.1-1.0	|--/--/1999 | ---	| Création
-- @(#) EXT_CODEXT.sql 2.1-1.1	|26/09/2001 | SNE	| Mise aux normes (traitement des erreurs)
---------------------------------------------------------------------------------------
*/
  v_dat_fval sr_codif.dat_fval%TYPE;

BEGIN
      SELECT cod_codif, libl, dat_fval
      INTO   p_cod_codif, p_libl, v_dat_fval
      FROM   SR_CODIF
      WHERE  cod_typ_codif = p_typ_codif
      AND    ide_codif      = p_ide_codif;
	  IF ( TRUNC(v_dat_fval) >= TRUNC(sysdate) OR v_dat_fval IS NULL )THEN
	    p_ret := 1;
	  ELSE
	    p_ret := 2;
	  END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         p_ret := 0;
      WHEN OTHERS THEN
         p_ret := -1;
		 RAISE;
END EXT_CODEXT;

/

CREATE OR REPLACE PROCEDURE EXT_CODEXT_BO (p_typ_codif IN VARCHAR2,
                         p_ide_codif IN VARCHAR2,
                         p_libl OUT VARCHAR2,
                         p_cod_codif OUT VARCHAR2,
                         p_ret OUT NUMBER ) IS


/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_CODEXT
-- ---------------------------------------------------------------------------
--  Auteur         : ---
--  Date creation  : Nov/Dec 2000
-- ---------------------------------------------------------------------------
-- Role          : Recherche dans la table SR_CODIF (déportée) de la valeur du code externe
--
-- Parametre en entrée :
-- 			 		   1 - p_typ_codif
--                     2 - p_ide_codif
--
-- Parametre en sortie :
-- 			 		   3 - p_libl
--                     4 - p_cod_codif
--                     5 - p_ret : 0 si non trouvé
--                                 -1 si autre erreur (exception levée)
--                                 1 si trouve et valide
--					   2 si trouve et non valide
-- Valeur retournee : Aucune
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_CODEXT.sql version 2.1-1.2
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) EXT_CODEXT.sql 1.1-1.0	|--/--/1999 | ---	| Création
-- @(#) EXT_CODEXT.sql 2.0-1.1	|15/12/2000 | SNE	| Intégration aux scripts de création
-- @(#) EXT_CODEXT.sql 2.1-1.2	|26/09/2001 | SNE	| Mise aux normes (traitement des erreurs)
---------------------------------------------------------------------------------------
*/


  v_dat_fval DATE;

BEGIN

  SELECT cod_codif, libl, dat_fval
  INTO   p_cod_codif, p_libl, v_dat_fval
  FROM   SR_CODIF@BO_ASTER
  WHERE  cod_typ_codif = p_typ_codif
    AND  ide_codif      = p_ide_codif;

  IF ( TRUNC(v_dat_fval) >= TRUNC(sysdate) OR v_dat_fval IS NULL )THEN
    p_ret := 1;
  ELSE
    p_ret := 2;
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    p_ret := 0;
  WHEN OTHERS THEN
    p_ret := -1;
	RAISE;
END EXT_CODEXT_BO;

/

CREATE OR REPLACE PROCEDURE EXT_CODINT (p_cod_typ_codif IN SR_Codif.cod_typ_codif%TYPE,
                                        p_cod_codif IN SR_Codif.cod_codif%TYPE,
                                        p_libl OUT SR_Codif.libl%TYPE,
                                        p_ide_codif OUT SR_Codif.ide_codif%TYPE,
                                        p_ret OUT NUMBER ) IS
/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_CODINT
-- ---------------------------------------------------------------------------
--  Auteur         : ---
--  Date creation  : --/--/1999
-- ---------------------------------------------------------------------------
-- Role          : Recherche dans la table SR_CODIF de la valeur du code interne
--
-- Parametres    :
-- 		En Entree
-- 				 1 - p_cod_typ_codif
--				 2 - p_cod_codif
-- 		En Sortie
--		   		 3 - p_libl
--				 4 - p_ide_codif
--				 5 - p_ret : 0 si non trouvé
--                                1 si trouve et valide
--    			    2 si trouve et non valide
--					Autres erreurs liées à la base : remontées (exception) et p_ret = -1

--
-- Valeur retournee : Aucun
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_CODINT.sql version 2.1-1.1
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) EXT_CODINT.sql 1.1-1.0	|--/--/1999 | ---	| Création
-- @(#) EXT_CODINT.sql 2.1-1.1	|26/09/2001 | SNE	| Mise aux normes (traitement des erreurs)
---------------------------------------------------------------------------------------
*/
  v_dat_fval sr_codif.dat_fval%TYPE;

BEGIN
      SELECT ide_codif, libl, dat_fval
      INTO   p_ide_codif, p_libl, v_dat_fval
      FROM   SR_CODIF
      WHERE  cod_typ_codif = p_cod_typ_codif
      AND    cod_codif      = p_cod_codif;
	  IF ( TRUNC(v_dat_fval) >= TRUNC(sysdate) OR v_dat_fval IS NULL )THEN
	    p_ret := 1;
	  ELSE
	    p_ret := 2;
	  END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         p_ret := 0;
      WHEN OTHERS THEN
         p_ret := -1;
		 RAISE;
END EXT_CODINT;

/

CREATE OR REPLACE PROCEDURE EXT_CODINT_D (p_cod_typ_codif IN SR_Codif.cod_typ_codif%TYPE,
                                          p_cod_codif IN SR_Codif.cod_codif%TYPE,
                                          p_date IN SR_Codif.dat_fval%TYPE,
                                          p_libl OUT SR_Codif.libl%TYPE,
                                          p_ide_codif OUT SR_Codif.ide_codif%TYPE,
                                          p_ret OUT NUMBER ) IS
/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_CODINT_D
-- ---------------------------------------------------------------------------
--  Auteur         : ---
--  Date creation  : --/--/1999
-- ---------------------------------------------------------------------------
-- Role          : Recherche dans la table SR_CODIF de la valeur, à une date particulière
-- 				   du code interne correspondant à un code externe
--
-- Parametres    :
-- 		En Entree
-- 				 1 - p_cod_typ_codif : Type de codification
--				 2 - p_cod_codif : code externe
--				 3 - p_date    : date de reference
-- 		En Sortie
--		   		 3 - p_libl  : Libellé correspondant au code
--				 4 - p_ide_codif  : code interne
--				 5 - p_ret : 0 si non trouvé
--                                1 si trouve et valide
--    			    2 si trouve et non valide
--					Autres erreurs liées à la base : remontées (exception) et p_ret = -1

--
-- Valeur retournee : Aucun
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_CODINT_D.sql version 2.1-1.1
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) EXT_CODINT_D.sql 1.1-1.0	|--/--/1999 | ---	| Création
-- @(#) EXT_CODINT_D.sql 2.1-1.1	|26/09/2001 | SNE	| Mise aux normes (traitement des erreurs)
---------------------------------------------------------------------------------------
*/
  v_dat_fval sr_codif.dat_fval%TYPE;
  v_date DATE;

BEGIN

  /* Si p_date est null, on initialise v_date a la date du jour */
  IF p_date IS NULL THEN
    v_date := TRUNC(SYSDATE);
  ELSE
    v_date := p_date;
  END IF;

  SELECT ide_codif, libl, dat_fval
  INTO   p_ide_codif, p_libl, v_dat_fval
  FROM   SR_CODIF
  WHERE  cod_typ_codif = p_cod_typ_codif
    AND  cod_codif      = p_cod_codif;
  IF ( TRUNC(v_dat_fval) >= TRUNC(v_date) OR v_dat_fval IS NULL )THEN
    p_ret := 1;
  ELSE
    p_ret := 2;
  END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_ret := 0;
    WHEN OTHERS THEN
      p_ret := -1;
	  RAISE;
END EXT_CODINT_D;

/

CREATE OR REPLACE PROCEDURE Ext_Compte_Sens (P_cod_typ_piece  IN FC_ECRITURE.cod_typ_piece%TYPE,
											 P_ide_ss_type    IN FB_PIECE.IDE_SS_TYPE%TYPE,
									 		 P_ide_typ_poste  IN RM_POSTE.IDE_TYP_POSTE%TYPE,
									 		 P_var_cpta 	  IN FC_ECRITURE.var_cpta%TYPE,
									 		 P_Cod_Sens_Bud   OUT RC_MODELE_LIGNE.val_sens%TYPE,
											 P_Ide_Cpt        OUT RC_MODELE_LIGNE.val_cpt%TYPE,
									 		 P_Cod_Sens_HB    OUT RC_MODELE_LIGNE.val_sens%TYPE ,
									 		 P_Ide_Cpt_HB     OUT RC_MODELE_LIGNE.val_cpt%TYPE,
									 		 P_Cod_Sens_Tiers OUT RC_MODELE_LIGNE.val_sens%TYPE,
									 		 P_Ide_Cpt_Tiers  OUT RC_MODELE_LIGNE.val_cpt%TYPE,
											 P_retour         OUT Number
											 )
									 		IS
/*
-- ----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : CAD
-- Nom           : Ext_Compte_Sens
-- ---------------------------------------------------------------------------
--  Auteur         : MYI
--  Date creation  : 09/04/2002
-- ---------------------------------------------------------------------------
-- Role          : Extraction des comptes et sens Paramétrés dans
-- 				  les modèles de lignes du shéma attaché au sous-type de pièce
--
-- Parametres :
--                 1- P_cod_typ_piece  : Code type pièce
--                 2- P_ide_ss_type    : Sous type pièce
--				   3- P_ide_typ_poste  : Type poste comptable
--                 4- P_var_cpta       : Variation comptable
--
-- Valeurs retournees :
--                     P_Cod_Sens_Bud   : Sens du compte sur budget de la ligne budgétaire
--					   P_Ide_Cpt        : Compte de la ligne budgétaire
--					   P_Cod_Sens_HB    : Sens du compte hors budget
--					   P_Ide_Cpt_HB     : Compte hors budget
--					   P_Cod_Sens_Tiers : Sens de la ligne tiers
--					   P_Ide_Cpt_Tiers  : Compte de la ligne tiers
--					   P_retour : 0   si erreur base
--					             -1   si autre erreur
-- 								 1    OK
--
--
-- Appels :
-- ---------------------------------------------------------------------------
--  Version        : @(#) Ext_Compte_Sens 3.0-1.0
-- ---------------------------------------------------------------------------
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) Ext_Compte_Sens.sql  3.0-1.0    |09/04/2002 |MYI | création (Fonction 11 )
-- @(#) Ext_Compte_Sens.sql  V4260      |16/05/2008 |PGE | evol_DI44_2008_014 Controle sur les dates de validité de RC_MODELE_LIGNE
--------------------------------------------------------------------------------
*/

v_Budget 		SR_CODIF.Cod_Codif%Type;
v_Hors_Bud		SR_CODIF.Cod_Codif%Type;
v_Tiers			SR_CODIF.Cod_Codif%Type;
v_libl   		SR_CODIF.Libl%Type;
v_ret    		Number;
v_ret1	 Number;
v_ret2   Number;
v_ret3	 Number;


v_ide_jal     pc_prise_charge.ide_jal%Type;
v_ide_schema  pc_prise_charge.ide_schema%Type;

Erreur_Parametrage1 EXCEPTION;
Erreur_Parametrage2 EXCEPTION;
Erreur_Parametrage3 EXCEPTION;

-- Cursuer sur la modèle des lignes
CURSOR c_modele_ligne ( P_ide_jal IN RC_MODELE_LIGNE.Ide_jal%Type ,
						P_ide_schema IN RC_MODELE_LIGNE.Ide_schema%Type)
is Select Cod_Typ_Pec,
          val_sens,
          val_cpt
From RC_MODELE_LIGNE
Where
     Var_Cpta   = P_var_cpta
 AND Ide_Jal    = P_ide_jal
 AND Ide_Schema = P_ide_schema
 AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
 AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008

BEGIN
-- Recherche journal et shéma d'ériture à utiliser
  BEGIN
	  SELECT ide_jal , ide_schema
	  INTO   v_ide_jal , v_ide_schema
	  FROM pc_prise_charge
	  WHERE cod_typ_piece  = P_cod_typ_piece
	  AND var_cpta         = P_var_cpta
	  AND Ide_Typ_Poste    = P_Ide_Typ_Poste    -- Type poste comptable
	  AND Ide_SS_Type      = P_Ide_SS_Type;     -- Code du sous-type de pièce
  EXCEPTION
  When No_data_found Then
       P_retour := 0;
  When Others Then
       Raise;
  END;
  IF  v_ide_jal    is not null Or
  	  v_ide_schema is not Null Then
	  Ext_codext('TYPE_PEC','B' , v_libl ,v_Budget, v_ret1);
	  If v_ret1 != 1 Then
	  	 Raise Erreur_Parametrage1;
	  End if;

	  Ext_codext('TYPE_PEC','H' , v_libl ,v_Hors_Bud, v_ret2);
	  If v_ret2 != 1 Then
	  	 Raise Erreur_Parametrage2;
	  End if;

	  Ext_codext('TYPE_PEC','I' , v_libl ,v_Tiers, v_ret3);
	  If v_ret3 != 1 Then
	  	  Raise Erreur_Parametrage3;
	  End if;

	  FOR v_modele_ligne IN c_modele_ligne ( v_ide_jal ,v_ide_schema)  LOOP
	 	   If  v_modele_ligne.Cod_Typ_Pec = v_Budget Then -- modèle de ligne avec le type de la ligne = 'B'
		       -- compte sur budget et son sens
		       P_Cod_Sens_Bud := v_modele_ligne.val_sens;
			   P_Ide_Cpt      := v_modele_ligne.val_cpt;
	 	   Elsif  v_modele_ligne.Cod_Typ_Pec = v_Hors_Bud Then -- modèle de ligne avec le type de la ligne = 'H'
	 	   	   -- Compte hors budget et son sens
	 	   	   P_Cod_Sens_HB := v_modele_ligne.val_sens;
	           P_Ide_Cpt_HB  := v_modele_ligne.val_cpt;
	 	   Elsif v_modele_ligne.Cod_Typ_Pec = v_Tiers     Then -- modèle de ligne avec le type de la ligne = 'I'
	 	   	   -- Compte  et le sens de la ligne tiers
	 	   	   P_Cod_Sens_Tiers := v_modele_ligne.val_sens;
	           P_Ide_Cpt_Tiers := v_modele_ligne.val_cpt;
	 	   End if;
	  End loop;
	  P_retour :=1;
   End if;
Exception
When Erreur_Parametrage1 Then
     P_retour :=-2;
When Erreur_Parametrage2 Then
     P_retour :=-3;
When Erreur_Parametrage3 Then
     P_retour :=-4;
When No_data_Found Then
     P_Cod_Sens_Bud 	:=Null;
     P_Cod_Sens_HB  	:=Null;
     P_Ide_Cpt_HB   	:=Null;
     P_Cod_Sens_Tiers   :=Null;
     P_Ide_Cpt_Tiers 	:=Null;
	 P_retour :=1;
When Others Then
    P_retour :=-1;
	Raise;
END Ext_Compte_Sens;

/

CREATE OR REPLACE PROCEDURE EXT_Date_JC_Max( p_ide_poste IN rm_poste.ide_poste%TYPE,
                           p_ide_gest IN fn_gestion.ide_gest%TYPE,
                           p_dateJC_in IN fc_calend_hist.dat_jc%TYPE,
                           p_dateJC_out OUT fc_calend_hist.dat_jc%TYPE,
                           p_ide_ferm OUT sr_codif.ide_codif%TYPE,
						   p_cloturee IN fc_calend_hist.cod_ferm%TYPE:=NULL ) IS
/* Recherche dans fc_calend_hist,la plus grande des dates JC <= date passée en paramètre */
/* Retourne null si cette date n'existe pas				  	 		 		   			 */
/* sinon retourne la date trouvée et le code interne à l'état de cette journée 			 */

v_cod_ferm fc_calend_hist.cod_ferm%TYPE;
v_lib sr_codif.libl%TYPE;
v_ret NUMBER;

BEGIN


  If p_cloturee IS NULL then

    SELECT MAX(TRUNC(dat_jc))
      INTO p_dateJC_out
    FROM FC_CALEND_HIST
    WHERE ide_poste = p_ide_poste
      AND   ide_gest = p_ide_gest
      AND   TRUNC(dat_jc) <= TRUNC(p_dateJC_in);

  else

	SELECT MAX(TRUNC(dat_jc))
      INTO p_dateJC_out
    FROM FC_CALEND_HIST
    WHERE ide_poste = p_ide_poste
      AND   ide_gest = p_ide_gest
      AND   TRUNC(dat_jc) <= TRUNC(p_dateJC_in)
	  AND cod_ferm = p_cloturee;

  end if;



  SELECT cod_ferm INTO v_cod_ferm
  FROM FC_CALEND_HIST
  WHERE ide_poste = p_ide_poste
  AND   ide_gest = p_ide_gest
  AND   TRUNC(dat_jc) = p_dateJC_out;




  /* Recherche code interne */
  EXT_CODINT('STATUT_JOURNEE',v_cod_ferm,v_lib,p_ide_ferm,v_ret);
  IF v_ret < 1 THEN
    p_ide_ferm := Null;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    p_dateJC_out := Null;
    p_ide_ferm := Null;
END EXT_Date_JC_Max;

/

CREATE OR REPLACE PROCEDURE EXT_FORMAT_DATE(P_date_format OUT nls_instance_parameters.value%type  ) IS

/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_FORMAT_DATE
-- ---------------------------------------------------------------------------
--  Auteur         : FBO
--  Date creation  : 09/04/2002
-- ---------------------------------------------------------------------------
-- Role          :
--
-- Parametres    :
-- Paramètres en entrée :
--
--
-- Paramètres en sortie
--            p_date_format format de la date:
--           p_retour : code retour de la procédure :
--                      -1 si KO

--
-- Valeur retournee : Aucun
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_FORMAT_DATE.sql version 3.0-1.0 : FBO : 09/04/2002
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	 |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) EXT_FORMAT_DATE.sql version 3.0-1.0	|09/04/2002 | FBO	| Création
---------------------------------------------------------------------------------------
*/

  v_date_format VARCHAR2(50) := null;
  v_date_format_db VARCHAR2(50) := null;


BEGIN

	/* Le to_date en librairie prend le format de nls_database_parameters */
	/* Si nls_instance_parameters est defini, probleme d'incompatibilite de format */

	SELECT value
	INTO v_date_format_db
	FROM nls_database_parameters
	WHERE parameter = 'NLS_DATE_FORMAT';
	SELECT NVL(value,v_date_format_db)
	INTO v_date_format
	FROM nls_instance_parameters
	WHERE parameter = 'NLS_DATE_FORMAT';

    p_date_format := v_date_format;


 EXCEPTION

 WHEN OTHERS THEN

   RAISE;


END EXT_FORMAT_DATE;

/

CREATE OR REPLACE PROCEDURE EXT_LIB_NOEUD(p_ide_nd IN RM_NOEUD.ide_nd%TYPE,
	   	  		  		   				 p_cod_typ_nd IN RM_NOEUD.cod_typ_nd%TYPE,
										 p_libn OUT RM_NOEUD.libn%TYPE,
										 p_libc OUT RM_NOEUD.libc%TYPE,
										 p_ret OUT NUMBER) IS
/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_LIB_NOEUD
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 07/06/2002
-- ---------------------------------------------------------------------------
-- Role          : Ramene les libelles d un noeud
--
-- Parametres    :
-- 				 1 - p_ide_nd : identifiant du noeud
-- 				 2 - p_cod_typ_nd : identifiant du type de noeud
-- 				 3 - p_libn : lib long du noeud
-- 				 4 - p_ide_nd : lib court du noeud
-- 				 5 - p_ret : cod retour
--
-- Valeur retournee : type du poste comptable passé en parametre
--
-- Appels		 :  RM_POSTE
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_LIB_NOEUD.sql version 3.0-1.1
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction				|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) EXT_LIB_NOEUD.sql 3.0-1.0	|07/06/2002 | SGN	| Création
-- @(#) EXT_LIB_NOEUD.sql 3.0-1.1	|14/08/2002 | SNE	| Ajout d'un '/' a la fin du script (important!!!) + suppression appel 'AFF_MESS'
---------------------------------------------------------------------------------------
*/
BEGIN

  -- Recuperation des libelles
  SELECT libn, libc
  INTO p_libn, p_libc
  FROM rm_noeud
  WHERE ide_nd = p_ide_nd
	AND cod_typ_nd = p_cod_typ_nd;

  p_ret := 0;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
	  -- en fonction du type de noeud on retourne le message correspondant
	  IF p_cod_typ_nd = 'P' THEN
--	  	 AFF_MESS(820,p_ide_nd,'','');
	  	 p_ret := -1;
	  ELSIF p_cod_typ_nd = 'O' THEN
--	  	 AFF_MESS(821, p_ide_nd, '','');
		 p_ret := -1;
	  ELSIF p_cod_typ_nd = 'X' THEN
--	  	 AFF_MESS(825, p_ide_nd, '', '');
		 p_ret := -1;
	  ELSE
--	  	 AFF_MESS(828, p_ide_nd, '', '');
		 p_ret := -1;
	  END IF;
	WHEN OTHERS THEN
	  RAISE;
END;

/

CREATE OR REPLACE PROCEDURE EXT_NOEUD ( p_typ_nd IN RM_Noeud.cod_typ_nd%TYPE,
                                        p_ide_nd IN RM_Noeud.ide_nd%TYPE,
                                        p_row_rm_noeud OUT RM_Noeud%ROWTYPE,
                                        p_ret OUT NUMBER ) IS

/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_NOEUD
-- ---------------------------------------------------------------------------
--  Auteur         : ---
--  Date creation  : Nov/Dec 2000
-- ---------------------------------------------------------------------------
-- Role          : Procedure de recherche d'infos sur un noeud logique
--
-- Parametre en entrée :
-- 			 		   1 - p_typ_nd : Code type de noeud
--                     2 - p_ide_nd : Identifiant du poste
--
-- Parametre en sortie :
-- 			 		   3 - p_row_rm_noeud : Enregistrement de RM_NOEUD correspondant
--                     4 - p_cod_codif
--                     5 - p_ret : 0 si non trouvé
--                                 -1 si autre erreur (exception levée)
--                                 1 si trouve et valide
--					   2 si trouve et non valide
-- Valeur retournee : Aucune
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_NOEUD.sql version 2.1-1.2
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) EXT_NOEUD.sql 1.1-1.0	|--/--/1999 | ---	| Création
-- @(#) EXT_NOEUD.sql 2.1-1.1	|26/09/2001 | SNE	| Mise aux normes (traitement des erreurs)
---------------------------------------------------------------------------------------
*/


BEGIN

  SELECT * INTO p_row_rm_noeud
  FROM RM_Noeud
  WHERE
    RM_Noeud.cod_typ_nd = p_typ_nd
    AND RM_Noeud.ide_nd = p_ide_nd;
  p_ret := 1;

EXCEPTION
  WHEN No_Data_Found THEN
    p_ret := 0;
  WHEN OTHERS THEN
    p_ret := -1;
	RAISE;
END EXT_NOEUD;

/

CREATE OR REPLACE PROCEDURE EXT_PARAM (p_ide_param IN SR_PARAM.ide_param%TYPE,
                                       p_val_param OUT SR_PARAM.val_param%TYPE,
                                       p_ret OUT NUMBER ) IS
/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_PARAM
-- ---------------------------------------------------------------------------
--  Auteur         : ---
--  Date creation  : Nov/Dec 2000
-- ---------------------------------------------------------------------------
-- Role          : Recherche dans la table SR_PARAM de la valeur du parametre transmis
--
-- Parametre en entrée :
-- 			 		   1 - p_ide_param : Code du pramètre
--
-- Parametre en sortie :
-- 			 		   2 - p_val_param: Valeur du paramétre
--                     4 - p_ret : 0 si non trouvé
--                                 -1 si autre erreur (exception levée)
--                                 1 si trouve et valide
-- Valeur retournee : Aucune
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_PARAM.sql version 2.1-1.2
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) EXT_PARAM.sql 1.1-1.0	|--/--/1999 | ---	| Création
-- @(#) EXT_PARAM.sql 2.1-1.1	|26/09/2001 | SNE	| Mise aux normes (traitement des erreurs)
---------------------------------------------------------------------------------------
*/

  v_val_param SR_PARAM.val_param%TYPE;
  v_codint_param SR_CODIF.ide_codif%TYPE;
  v_cod_typ_codif SR_PARAM.cod_typ_codif%TYPE;
  v_cod_param_liste SR_TYPE_CODIF.cod_param_liste%TYPE;
  v_libl SR_CODIF.libl%TYPE;
  v_ret NUMBER;

BEGIN

   SELECT SR_PARAM.val_param
   		  , SR_PARAM.cod_typ_codif
		  , SR_TYPE_CODIF.cod_param_liste
		  , 1
   INTO   v_val_param
   		  , v_cod_typ_codif
		  , v_cod_param_liste
		  , p_ret
   FROM   SR_PARAM, SR_TYPE_CODIF
   WHERE  SR_PARAM.ide_param = p_ide_param
   AND ( TRUNC(SR_PARAM.dat_dval) <= TRUNC(SYSDATE) OR SR_PARAM.dat_dval IS NULL)
   AND ( TRUNC(SR_PARAM.dat_fval) >= TRUNC(SYSDATE) OR SR_PARAM.dat_fval IS NULL )
   AND SR_TYPE_CODIF.cod_typ_codif = SR_PARAM.cod_typ_codif;

   /* Si le parametre est lie a une liste de valeurs,            */
   /* alors on extrait le code interne de la valeur du parametre */
   IF v_cod_param_liste IN ('L','X') THEN
      Ext_Codint(v_cod_typ_codif,v_val_param,v_libl,v_codint_param,v_ret);
      IF v_ret < 1 THEN
         p_ret := v_ret;
      ELSE
         p_val_param := v_codint_param;
      END IF;
   ELSE
      p_val_param := v_val_param;
   END IF;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         p_ret := 0;
      WHEN OTHERS THEN
         p_ret := -1;
		 RAISE;
END ext_param;

/

CREATE OR REPLACE PROCEDURE EXT_TYPE_BUDGET( P_Cod_Typ_Piece IN  PB_SS_TYPE_PIECE.Cod_Typ_Piece%Type,
										      P_Ide_SS_Type      IN  PB_SS_TYPE_PIECE.Ide_SS_Type%Type,
										      P_Type_Budget      OUT SR_CODIF.IDE_CODIF%Type,
										      P_retour        OUT Number
										    ) IS
/*
---------------------------------------------------------------------------------------
-- Nom           : EXT_TYPE_BUDGET
-- ---------------------------------------------------------------------------
--  Auteur         : MYI
--  Date creation  : 11/04/2002
-- ---------------------------------------------------------------------------
-- Role          : Recherche le type de budget en fonction du sous-type pièce
--               :
-- Parametres    :
-- 				 1 - P_Cod_Typ_Piece : Code type piece
--				 2 - P_Ide_SS_Type   : sous-type pièce
--
-- Valeur retournee :
--               1 - P_Type_budget  : budget de recette (R) ou budget de dépense  (D)
--				 3 - P_retour :  0   si erreur base
--					            -1   si autre erreur
-- 								1    OK
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) EXT_TYPE_BUDGET.sql version 3.0-1.0 : MYI: 11/04/2002
-- ---------------------------------------------------------------------------
--
-- 	--------------------------------------------------------------------
-- 	Fonction				|Date	    |Initiales	|Commentaires
-- 	--------------------------------------------------------------------
-- @(#) EXT_TYPE_BUDGET.sql  3.0-1.0	|11/04/2002 | MYI	| Création
---------------------------------------------------------------------------------------
*/
-- Déclaration des variables
v_ret Number;
Erreur_Codint Exception;
Erreur_Parametrage  Exception;

v_codint1 SR_CODIF.IDE_CODIF%TYPE;
v_codint2 SR_CODIF.IDE_CODIF%TYPE;
v_flag_depense PB_SS_TYPE_PIECE.FLG_DEPENSE%Type;
v_flag_recette  PB_SS_TYPE_PIECE.FLG_RECETTE%Type;

v_libl    SR_CODIF.LIBL%TYPE;

BEGIN
	Select Flg_Recette , Flg_Depense into 	v_flag_recette , v_flag_depense
	From PB_SS_TYPE_PIECE
	Where
	    Cod_Typ_Piece = P_Cod_Typ_Piece
		And Ide_SS_Type   = P_Ide_SS_Type ;

	 -- Contrôle de cohérence code interne pour flag recette
	 EXT_Codint('OUI_NON',v_flag_recette,v_libl,v_codint1,v_ret);
	 IF v_ret != 1 THEN
	     Raise Erreur_Codint;
	 END IF;

	 -- Contrôle de cohérence code interne pour flag depense
	 EXT_Codint('OUI_NON', v_flag_depense,v_libl,v_codint2,v_ret);
	 IF v_ret != 1 THEN
	    Raise Erreur_Codint;
	 END IF;

	 If ( v_codint1 = 'O' And v_codint2 = 'O' ) or    -- la pièce impute le budget en recette et le budget en dépense
	    ( v_codint1 = 'N' And v_codint2 = 'N' ) Then  -- la pièce n'impute ni  e budget en recette  ni le budget en dépense
	 	Raise Erreur_Parametrage;
	 Elsif  v_codint1 = 'O' Then
	 	P_Type_Budget := 'R';
     Elsif  v_codint2 = 'O' Then
	  	P_Type_Budget := 'D';
	 End if;
	 P_retour := 1;
EXCEPTION
WHEN No_data_found THEN
    P_Type_Budget := Null;
	P_retour :=0;
WHEN Erreur_Codint THEN
	P_Type_Budget := Null;
    P_retour := -1 ;
WHEN  Erreur_Parametrage THEN
    P_Type_Budget := Null;
    P_retour :=-2;
WHEN Others THEN
    P_Type_Budget := Null;
	RAISE;
END EXT_TYPE_BUDGET;

/

CREATE OR REPLACE PROCEDURE GES_EDITION (P_cod_typ_nd IN RM_POSTE.cod_typ_nd%TYPE,
					   P_ide_nd_emet IN RM_POSTE.ide_poste%TYPE,
					   P_flag_edition OUT VARCHAR2,
					   P_retour out number) IS

/* parametres en entrée */

/* P_cod_typ_nd      = Type de poste comptable destinataire du message de notification */
/* P_ide_nd_emet  	 = Poste destinataire du message /*

/* parametres en sortie */
/* P_flag_edition = Flag d'édition */
/* P_retour       = Code retour de la procédure */
/*                = 0 poste comptable non trouvé */
/*                = 1 OK */
/*                = -1 autres erreurs pour le poste comptable */
/*                = -2 code interne non trouvé */
/*                = -3 noeud non trouvé */

  v_cod_edit_bord RM_TYPE_POSTE.cod_edit_bord%TYPE;
  v_libl sr_codif.libl%TYPE;
  v_codint SR_CODIF.cod_codif%TYPE;
  p_row_rm_noeud RM_NOEUD%ROWTYPE;
  v_retour number;
  err_retour_codint EXCEPTION;
  err_retour_noeud EXCEPTION;

BEGIN

  P_flag_edition := 'N';

  SELECT cod_edit_bord INTO v_cod_edit_bord
  FROM RM_POSTE A , RM_TYPE_POSTE B
  WHERE ide_poste =  GLOBAL.ide_poste
  AND A.ide_typ_poste = B.ide_typ_poste;

  EXT_Codint('EDIT_BDX',v_cod_edit_bord,v_libl,v_codint,v_retour);

  IF V_retour IN (0,-1)  THEN
    RAISE err_retour_codint;
  END IF;

  IF v_codint = 'S' THEN
    P_flag_edition := 'O';
  ELSIF v_codint = 'J' THEN
    P_flag_edition := 'N';
  ELSIF v_codint = 'N' THEN
    /* le poste comptable destinataire est il informatisé ? */
    EXT_noeud (P_cod_typ_nd,P_ide_nd_emet,p_row_rm_noeud,v_retour);
    IF v_retour = 1 THEN
	IF p_row_rm_noeud.ide_site is null THEN
        P_flag_edition := 'O';
	ELSE
	  P_flag_edition := 'N';
	END IF;
    ELSE
	RAISE err_retour_noeud;
    END IF;
  END IF;

  p_retour := 1;

EXCEPTION
  WHEN No_Data_Found THEN
    p_retour := 0;
  WHEN err_retour_codint THEN
    p_retour := -2;
  WHEN err_retour_noeud THEN
    p_retour := -3;
  WHEN OTHERS THEN
    p_retour := -1;
END GES_EDITION;

/

CREATE OR REPLACE PROCEDURE GES_U110_140F(p_action IN NUMBER,
					p_tiers  IN VARCHAR2,
					p_error  OUT NUMBER,
					p_commentaire OUT VARCHAR2) IS


/*
---------------------------------------------------------------------------------------
-- Nom           : GES_U110_040F
-- Date creation : Nov/Dec. 2000
-- Créée par     : XXX (SEMA GROUP)
--
-- Logiciel       : ASTER
-- Sous-systeme   : Base
-- Description    : Procedure de traitement de restauration des données du paramétrage
--
-- Parametres    :  p_action
--                  p_tiers
--                  p_error
--                  p_commentaire
--
-- Valeur retournee :
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) GES_U110_040F.sql  version 2.2-1.0
-- ---------------------------------------------------------------------------
--
-- --------------------------------------------------------------------
-- Fonction				|Date	    |Initiales	|Commentaires
-- --------------------------------------------------------------------
-- @(#) GES_U110_040F 1.0-1.0	|--/12/2000 | XXX	| Creation
-- @(#) GES_U110_040F 1.0-1.0	|15/12/2000 | SNE	| SNE :Intégration au script de création
-- @(#) GES_U110_040F 2.2-1.0	|18/01/2002 | NDY	| Correction ano 89 (utilisation de la table SM_TABLE_BUFFER - desactivation des constraintes) pour Version 2.2
---------------------------------------------------------------------------------------
*/


	C_DELETE CONSTANT NUMBER := 1;
	C_INSERT CONSTANT NUMBER := 2;
	C_REACTIV CONSTANT NUMBER := 3;
	C_FIN_OK CONSTANT NUMBER := 0;
	C_EXT_PARAM CONSTANT NUMBER := -2;
	C_INTEGRITY CONSTANT NUMBER := -2292;
	C_DBLINK CONSTANT NUMBER := -2019;
	C_USER CONSTANT NUMBER := -1017;

	integrity_error	EXCEPTION;
	dblink_error		EXCEPTION;
	user_error		EXCEPTION;
	param_error		EXCEPTION;
	end_ok			EXCEPTION;

	--PRAGMA EXCEPTION_INIT(integrity_error, -2292);
	/* on laisse l'erreur ORACLE : message plus exploitable */
	PRAGMA EXCEPTION_INIT(dblink_error, -2019);
	PRAGMA EXCEPTION_INIT(user_error, -1017);

	v_ret NUMBER;
	v_chaine VARCHAR2(120);

	CURSOR cur_contraintes_etrangeres IS
		SELECT constraint_name, table_name
		FROM all_constraints
		WHERE constraint_type = 'R';


BEGIN


	/* Remarque : la table des tiers n'est à diffuser que si le fichier tiers est national */
	/* (cad : p_tiers = IB0019 = 'O')                        */


	IF p_action = C_DELETE THEN


		-- Desactivation des contraintes etrangeres
		FOR v_contrainte IN cur_contraintes_etrangeres LOOP
			v_chaine := 'ALTER TABLE '||v_contrainte.table_name||' DISABLE CONSTRAINT '||v_contrainte.constraint_name;
			ASTER_DDL(v_chaine);
		END LOOP;


		-- Liste des tables diffusées (SM_TABLE_BUFFER)
		DELETE FROM RC_CALEND_TRAIT;
		DELETE FROM PC_PEC_ECART_CHANGE;
		DELETE FROM RB_TXCHANGE;
		DELETE FROM PC_MDR_STP;
		DELETE FROM FN_TIT_ACT;
		DELETE FROM SR_PARAM;
		DELETE FROM SR_CODIF;
		DELETE FROM RC_DECLENCHE;
		DELETE FROM SR_CPT_TRT;
		DELETE FROM RC_SPEC;
		DELETE FROM RC_LISTE_COMPTE;
		DELETE FROM RC_DROIT_COMPTE;
		DELETE FROM PR_CRITERE_CENTRA;
		DELETE FROM FN_LIGNE_BUD_EXEC;
		DELETE FROM FN_CPT_PLAN;
		DELETE FROM FN_COMPTE;
		DELETE FROM RN_TYPE_COMPTE;
		DELETE FROM RC_MODELE_LIGNE;
		DELETE FROM RC_SCHEMA_CPTA;
		DELETE FROM RC_DROIT_JOURNAL;
		DELETE FROM FC_JOURNAL;
		DELETE FROM RC_TYPE_JOURNAL;
		DELETE FROM FH_SFO_PU;
		DELETE FROM SH_FONCTION;
		DELETE FROM PC_PRISE_CHARGE;
		DELETE FROM PB_SERVICE;
		DELETE FROM FN_CPT_AUX;
		DELETE FROM FN_PLAN_AUX;
		DELETE FROM FN_LP_RPO;
		DELETE FROM RM_POSTE;
		DELETE FROM PR_ACTION_CENTRA;
		DELETE FROM PR_GROUPE_ACTION;
		DELETE FROM PC_PEC_REGLEMENT;
		DELETE FROM RC_CALEND_EXPL;
		DELETE FROM RH_DROIT_PROFIL;
		DELETE FROM RM_TYPE_POSTE;
		DELETE FROM RP_CHAINE_TRT;
		DELETE FROM RN_DROIT_BUDGET;
		DELETE FROM FN_VAR_GEST_BUD;
		DELETE FROM RN_BUDGET;
		DELETE FROM RM_ROUTAGE;
		DELETE FROM RB_ORDO;
		DELETE FROM RM_NOEUD;
		DELETE FROM RM_SITE_PHYSIQUE;
		DELETE FROM FB_COORD_BANC;
		DELETE FROM RB_ORDO_MVT_BUD;
		DELETE FROM RB_NAT_MVT_BUD;
		DELETE FROM PN_STRUCT_ZONE;
		DELETE FROM FN_LIGNE_BUD_PREV;
		DELETE FROM PN_VAR_BUD;
		DELETE FROM FN_GESTION;
		DELETE FROM PN_VAR_CPTA;
		DELETE FROM PE_PAR_ENTITE;
		DELETE FROM PE_ENTITE;
		DELETE FROM PE_ELEM_AXE;
		DELETE FROM PE_AXE;
		DELETE FROM PC_REMISE;
		DELETE FROM PC_MODE_REGLT;
		IF p_tiers = 'O' THEN
			DELETE FROM RB_TIERS;
		END IF;
		DELETE FROM PB_VAR_TIERS;
		DELETE FROM PB_ORDO_SSTPIECE;
		DELETE FROM PB_SS_TYPE_PIECE;
		DELETE FROM FH_PROFIL_UTIL;
		DELETE FROM B_PARAMBAT;
		DELETE FROM B_BATCH;


		RAISE end_ok;


	ELSIF p_action = C_INSERT THEN


		-- Liste des tables diffusées (SM_TABLE_BUFFER)
		INSERT INTO B_BATCH
			SELECT * FROM B_BATCH@RESTORE;
		INSERT INTO B_PARAMBAT
			SELECT * FROM B_PARAMBAT@RESTORE;
		INSERT INTO FH_PROFIL_UTIL
			SELECT * FROM FH_PROFIL_UTIL@RESTORE;
		INSERT INTO PB_SS_TYPE_PIECE
			SELECT * FROM PB_SS_TYPE_PIECE@RESTORE;
		INSERT INTO PB_ORDO_SSTPIECE
			SELECT * FROM PB_ORDO_SSTPIECE@RESTORE;
		INSERT INTO PB_VAR_TIERS
			SELECT * FROM PB_VAR_TIERS@RESTORE;
		IF p_tiers = 'O' THEN
			INSERT INTO RB_TIERS
				SELECT * FROM RB_TIERS@RESTORE;
		END IF;
		INSERT INTO PC_MODE_REGLT
			SELECT * FROM PC_MODE_REGLT@RESTORE;
		INSERT INTO PC_REMISE
			SELECT * FROM PC_REMISE@RESTORE;
		INSERT INTO PE_AXE
			SELECT * FROM PE_AXE@RESTORE;
		INSERT INTO PE_ELEM_AXE
			SELECT * FROM PE_ELEM_AXE@RESTORE;
		INSERT INTO PE_ENTITE
			SELECT * FROM PE_ENTITE@RESTORE;
		INSERT INTO PE_PAR_ENTITE
			SELECT * FROM PE_PAR_ENTITE@RESTORE;
		INSERT INTO PN_VAR_CPTA
			SELECT * FROM PN_VAR_CPTA@RESTORE;
		INSERT INTO FN_GESTION
			SELECT * FROM FN_GESTION@RESTORE;
		INSERT INTO PN_VAR_BUD
			SELECT * FROM PN_VAR_BUD@RESTORE;
		INSERT INTO FN_LIGNE_BUD_PREV
			SELECT * FROM FN_LIGNE_BUD_PREV@RESTORE;
		INSERT INTO PN_STRUCT_ZONE
			SELECT * FROM PN_STRUCT_ZONE@RESTORE;
		INSERT INTO RB_NAT_MVT_BUD
			SELECT * FROM RB_NAT_MVT_BUD@RESTORE;
		INSERT INTO RB_ORDO_MVT_BUD
			SELECT * FROM RB_ORDO_MVT_BUD@RESTORE;
		INSERT INTO FB_COORD_BANC
			SELECT * FROM FB_COORD_BANC@RESTORE;
		INSERT INTO RM_SITE_PHYSIQUE
			SELECT * FROM RM_SITE_PHYSIQUE@RESTORE;
		INSERT INTO RM_NOEUD
			SELECT * FROM RM_NOEUD@RESTORE;
		INSERT INTO RB_ORDO
			SELECT * FROM RB_ORDO@RESTORE;
		INSERT INTO RM_ROUTAGE
			SELECT * FROM RM_ROUTAGE@RESTORE;
		INSERT INTO RN_BUDGET
			SELECT * FROM RN_BUDGET@RESTORE;
		INSERT INTO FN_VAR_GEST_BUD
			SELECT * FROM FN_VAR_GEST_BUD@RESTORE;
		INSERT INTO RN_DROIT_BUDGET
			SELECT * FROM RN_DROIT_BUDGET@RESTORE;
		INSERT INTO RP_CHAINE_TRT
			SELECT * FROM RP_CHAINE_TRT@RESTORE;
		INSERT INTO RM_TYPE_POSTE
			SELECT * FROM RM_TYPE_POSTE@RESTORE;
		INSERT INTO RH_DROIT_PROFIL
			SELECT * FROM RH_DROIT_PROFIL@RESTORE;
		INSERT INTO RC_CALEND_EXPL
			SELECT * FROM RC_CALEND_EXPL@RESTORE;
		INSERT INTO PC_PEC_REGLEMENT
			SELECT * FROM PC_PEC_REGLEMENT@RESTORE;
		INSERT INTO PR_GROUPE_ACTION
			SELECT * FROM PR_GROUPE_ACTION@RESTORE;
		INSERT INTO PR_ACTION_CENTRA
			SELECT * FROM PR_ACTION_CENTRA@RESTORE;
		INSERT INTO RM_POSTE
			SELECT * FROM RM_POSTE@RESTORE;
		INSERT INTO FN_LP_RPO
			SELECT * FROM FN_LP_RPO@RESTORE;
		INSERT INTO FN_PLAN_AUX
			SELECT * FROM FN_PLAN_AUX@RESTORE;
		INSERT INTO FN_CPT_AUX
			SELECT * FROM FN_CPT_AUX@RESTORE;
		INSERT INTO PB_SERVICE
			SELECT * FROM PB_SERVICE@RESTORE;
		INSERT INTO PC_PRISE_CHARGE
			SELECT * FROM PC_PRISE_CHARGE@RESTORE;
		INSERT INTO SH_FONCTION
			SELECT * FROM SH_FONCTION@RESTORE;
		INSERT INTO FH_SFO_PU
			SELECT * FROM FH_SFO_PU@RESTORE;
		INSERT INTO RC_TYPE_JOURNAL
			SELECT * FROM RC_TYPE_JOURNAL@RESTORE;
		INSERT INTO FC_JOURNAL
			SELECT * FROM FC_JOURNAL@RESTORE;
		INSERT INTO RC_DROIT_JOURNAL
			SELECT * FROM RC_DROIT_JOURNAL@RESTORE;
		INSERT INTO RC_SCHEMA_CPTA
			SELECT * FROM RC_SCHEMA_CPTA@RESTORE;
		INSERT INTO RC_MODELE_LIGNE
			SELECT * FROM RC_MODELE_LIGNE@RESTORE;
		INSERT INTO RN_TYPE_COMPTE
			SELECT * FROM RN_TYPE_COMPTE@RESTORE;
		INSERT INTO FN_COMPTE
			SELECT * FROM FN_COMPTE@RESTORE;
		INSERT INTO FN_CPT_PLAN
			SELECT * FROM FN_CPT_PLAN@RESTORE;
		INSERT INTO FN_LIGNE_BUD_EXEC
			SELECT * FROM FN_LIGNE_BUD_EXEC@RESTORE;
		INSERT INTO PR_CRITERE_CENTRA
			SELECT * FROM PR_CRITERE_CENTRA@RESTORE;
		INSERT INTO RC_DROIT_COMPTE
			SELECT * FROM RC_DROIT_COMPTE@RESTORE;
		INSERT INTO RC_LISTE_COMPTE
			SELECT * FROM RC_LISTE_COMPTE@RESTORE;
		INSERT INTO RC_SPEC
			SELECT * FROM RC_SPEC@RESTORE;
		INSERT INTO SR_CPT_TRT
			SELECT * FROM SR_CPT_TRT@RESTORE;
		INSERT INTO RC_DECLENCHE
			SELECT * FROM RC_DECLENCHE@RESTORE;
		INSERT INTO SR_CODIF
			SELECT * FROM SR_CODIF@RESTORE;
		INSERT INTO SR_PARAM
			SELECT * FROM SR_PARAM@RESTORE;
		INSERT INTO FN_TIT_ACT
			SELECT * FROM FN_TIT_ACT@RESTORE;
		INSERT INTO PC_MDR_STP
			SELECT * FROM PC_MDR_STP@RESTORE;
		INSERT INTO RC_CALEND_TRAIT
			SELECT * FROM RC_CALEND_TRAIT@RESTORE;
		INSERT INTO PC_PEC_ECART_CHANGE
			SELECT * FROM PC_PEC_ECART_CHANGE@RESTORE;
		INSERT INTO RB_TXCHANGE
			SELECT * FROM RB_TXCHANGE@RESTORE;


		-- Reactivation des contraintes etrangeres
		FOR v_contrainte IN cur_contraintes_etrangeres LOOP
			v_chaine := 'ALTER TABLE '||v_contrainte.table_name||' ENABLE CONSTRAINT '||v_contrainte.constraint_name;
			ASTER_DDL(v_chaine);
		END LOOP;


		RAISE end_ok;


	ELSIF p_action = C_REACTIV THEN


		-- Reactivation des contraintes etrangeres
		FOR v_contrainte IN cur_contraintes_etrangeres LOOP
			v_chaine := 'ALTER TABLE '||v_contrainte.table_name||' ENABLE CONSTRAINT '||v_contrainte.constraint_name;
			ASTER_DDL(v_chaine);
		END LOOP;


	END IF;


	EXCEPTION
		WHEN end_ok THEN
			p_error := C_FIN_OK;
			p_commentaire := null;
		WHEN integrity_error THEN
			p_error := C_INTEGRITY;
			p_commentaire := null;
			ROLLBACK;
		WHEN dblink_error THEN
			p_error := C_DBLINK;
			p_commentaire := null;
			ROLLBACK;
		WHEN user_error THEN
			p_error := C_USER;
			p_commentaire := null;
			ROLLBACK;
		WHEN param_error THEN
			p_error := C_EXT_PARAM;
			p_commentaire := null;
			ROLLBACK;
		WHEN others THEN
			p_error := -1;
			p_commentaire := SUBSTR(sqlerrm, 1, 120);
			ROLLBACK;


END;

/

CREATE OR REPLACE PROCEDURE MAJ_DUP_NOMEN_BUD(p_var_bud_orig IN PN_VAR_BUD.var_bud%TYPE,
                                              p_var_bud IN PN_VAR_BUD.var_bud%TYPE,
                                              p_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                                              p_nb_ligne_dup OUT NUMBER,
                                              p_nb_ligne_ano OUT NUMBER,
                                              p_ret OUT NUMBER)
IS
/*
---------------------------------------------------------------------------------------
-- Nom           : AFF_TRACE
-- Date creation : 20/09/2000
-- Creee par     : Valérie LACAZE (SEMA)
-- Role          : Sortie de trace a partir de la procédure en cours
-- Parametres    :
-- 				 P_VAR_BUD_ORIG - variation budgétaire d'origine
-- 				 P_VAR_BUD		- nouvelle variation budgétaire
--
-- Remarques importantes:
--                 Si le numero du message d'erreur n'est pas fourni alors le premier parametre doit correspondre
--                 a un message sous la forma de texte libre a afficher. On peut ainsi constituer les fichier de
--                 debogage de l'application
--
-- Valeurs retournees
-- 		   		 P_nb_ligne_dup	- nombre de lignes dupliquees
--				 P_nb_ligne_ano - nombre de lignes en anomalie
--				 P_RET       	- code retour de la procedure : 1 si OK, < 0 si KO
-- Version       : 1.0
-- Historique    : @(#) v1.0 : 20/09/2000 : VLA - Creation
-- Historique    : @(#) v1.1 : 11/06/2001 : SNE - Evols Lot 5 (suppression de colonnes)
---------------------------------------------------------------------------------------
*/

v_ret NUMBER := 1;
v_nb_ligne_dup NUMBER := 0;
v_nb_ligne_ano NUMBER := 0;
exit_error EXCEPTION;

PROCEDURE trace(pp_chaine IN VARCHAR2) IS
BEGIN
  --dbms_output.put_line(pp_chaine);
	AFF_TRACE('MAJ_DUP_NOMEN_BUD', 1, NULL, pp_chaine);
--  null;
END;

/* ***************************************************************************************** */
/* ***************************************************************************************** */
/*                            declaration des procedures internes                            */
/* ***************************************************************************************** */
/* ***************************************************************************************** */

/* Procedure d'insertion dans la table FM_ERREUR */
PROCEDURE MAJ_FM_ERREUR ( pp_ide_entite IN FM_ERREUR.ide_entite%TYPE,
                          pp_par_entite IN FM_ERREUR.par_entite%TYPE,
                          pp_ide_mess_err IN FM_ERREUR.ide_mess_err%TYPE,
                          pp_par_mess IN FM_ERREUR.par_mess%TYPE) IS
BEGIN
  INSERT INTO fm_erreur
    (cod_typ_nd,ide_nd_emet,ide_mess,flg_emis_recu,ide_entite,
     par_entite,ide_mess_err,par_mess)
  VALUES
    ('-','-',-1,'-',
     pp_ide_entite,
     pp_par_entite,
     pp_ide_mess_err,
     pp_par_mess);
END;

/* ***************************************************************************************** */
/* Procedure de recopie de la structure des ligne */
PROCEDURE MAJ_PN_STRUCT_ZONE ( w_var_bud_orig IN PN_VAR_BUD.var_bud%TYPE,
                              w_var_bud IN PN_VAR_BUD.var_bud%TYPE,
                              w_nb_lig_dup OUT NUMBER,
                              w_nb_lig_ano OUT NUMBER,
                              w_ret OUT NUMBER) IS
  CURSOR c_struct IS
  SELECT  COD_NAT_LIG,
          IDE_ZONE,
          NBR_POS,
          FLG_ABSENT,
          COD_SEP,
          LIBC
  FROM PN_STRUCT_ZONE
  WHERE
  var_bud = w_var_bud_orig;

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  /* on insere les lignes */
  FOR v_struct IN c_struct LOOP
    INSERT INTO PN_STRUCT_ZONE
    (VAR_BUD,
     COD_NAT_LIG,
     IDE_ZONE,
     NBR_POS,
     FLG_ABSENT,
     COD_SEP,
     LIBC)
    VALUES
    (w_var_bud,
     v_struct.cod_nat_lig,
     v_struct.ide_zone,
     v_struct.nbr_pos,
     v_struct.flg_absent,
     v_struct.cod_sep,
     v_struct.libc);
    /* incrementation du nombre d'enreg en dupliques */
    w_nb_lig_dup := w_nb_lig_dup + 1;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    w_ret := -1;
END;


/*
*****************************************************************************************
-- Procedure de recopie des lignes de prevision
-- Historique    : 11/06/2001 : SNE - Evols Lot 5 (suppression de colonnes)
*****************************************************************************************
*/
PROCEDURE MAJ_FN_LIGNE_BUD_PREV( w_var_bud_orig IN PN_VAR_BUD.var_bud%TYPE,
                                 w_var_bud IN PN_VAR_BUD.var_bud%TYPE,
                                 w_nb_lig_dup OUT NUMBER,
                                 w_nb_lig_ano OUT NUMBER,
                                 w_ret OUT NUMBER) IS
  CURSOR c_lig_prev IS
  SELECT ide_lig_prev,
         libn,
         cod_nat_cr,
  --       flg_ctl,
         flg_ap,
         cod_nat_bud,
         flg_imput,
         cod_cat_ap,
--         ide_lig_prev_ctl,
         libl,
         dat_fval,
         tx_autor,
         libc,
         ide_lig_pere
  FROM FN_LIGNE_BUD_PREV
  WHERE
  var_bud = w_var_bud_orig
  AND ( trunc(dat_fval) > trunc(sysdate) OR dat_fval IS NULL );

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  /* on insere les lignes */
/*
	SNE, 11/06/2001 : Suppression de colonnes dans la table FN_LGNE_PREV
*/
  FOR v_lig_prev IN c_lig_prev LOOP
    INSERT INTO FN_LIGNE_BUD_PREV
    (var_bud,ide_lig_prev,
     libn,
     cod_nat_cr,
--     flg_ctl,
     flg_ap,
     cod_nat_bud,
     flg_imput,
     cod_cat_ap,
--   ide_lig_prev_ctl,
     libl,
     dat_fval,
     tx_autor,
     libc,
     ide_lig_pere)
    VALUES
    (w_var_bud,
     v_lig_prev.ide_lig_prev,
     v_lig_prev.libn,
     v_lig_prev.cod_nat_cr,
--     v_lig_prev.flg_ctl,
     v_lig_prev.flg_ap,
     v_lig_prev.cod_nat_bud,
     v_lig_prev.flg_imput,
     v_lig_prev.cod_cat_ap,
--     v_lig_prev.ide_lig_prev_ctl,
     v_lig_prev.libl,
     v_lig_prev.dat_fval,
     v_lig_prev.tx_autor,
     v_lig_prev.libc,
     v_lig_prev.ide_lig_pere);
    /* incrementation du nombre d'enreg en dupliques */
    w_nb_lig_dup := w_nb_lig_dup + 1;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
	IF GLOBAL.FICHIER_TRACE IS NOT NULL THEN
		AFF_TRACE('MAJ_DUP_NOMEN_BUD.MAJ_FN_LIGNE_BUD_PREV', 0, 105, sqlerrm, null, null, GLOBAL.Fichier_Trace, 'E');
	END IF;
    w_ret := -1;
END;

/* ***************************************************************************************** */
/* Procedure de recopie des lignes de prevision */
PROCEDURE MAJ_FN_LIGNE_BUD_EXEC( w_var_bud_orig IN PN_VAR_BUD.var_bud%TYPE,
                                 w_var_bud IN PN_VAR_BUD.var_bud%TYPE,
                                 w_nb_lig_dup OUT NUMBER,
                                 w_nb_lig_ano OUT NUMBER,
                                 w_ret OUT NUMBER) IS

  CURSOR c_lig_exec IS
  SELECT  ide_lig_prev,
          ide_lig_exec,
          ide_lig_pere,
          libn,
          var_cpta,
          ide_cpt_ana,
          ide_cpt_pat,
          libc,
          libl,
          flg_imput,
          dat_fval
  FROM FN_LIGNE_BUD_EXEC
  WHERE var_bud = w_var_bud_orig
  AND ( trunc(dat_fval) > trunc(sysdate) OR dat_fval IS NULL );

  FUNCTION CTL_cpt(pp_ide_cpt IN FN_COMPTE.ide_cpt%TYPE) RETURN NUMBER IS
    v_res CHAR(1);
  BEGIN
    IF pp_ide_cpt IS NULL THEN
	  RETURN(1);
	END IF;
    SELECT 'X' INTO v_res
    FROM FN_COMPTE
    WHERE var_cpta = p_var_cpta AND ide_cpt = pp_ide_cpt
    AND ( trunc(dat_fval) > trunc(sysdate) OR dat_fval IS NULL );
    RETURN(1);
  EXCEPTION
    WHEN No_Data_Found THEN
      RETURN(-1);
  END;

  FUNCTION CTL_ide_lig_prev(pp_ide_lig_prev IN FN_LIGNE_BUD_PREV.ide_lig_prev%TYPE) RETURN NUMBER IS
    v_res CHAR(1);
  BEGIN
    IF pp_ide_lig_prev IS NULL THEN
	  RETURN(1);
	END IF;
    SELECT 'X' INTO v_res
    FROM FN_LIGNE_BUD_PREV
    WHERE var_bud = w_var_bud AND ide_lig_prev = pp_ide_lig_prev
    AND ( trunc(dat_fval) > trunc(sysdate) OR dat_fval IS NULL );
    RETURN(1);
  EXCEPTION
    WHEN No_Data_Found THEN
      RETURN(-1);
  END;

BEGIN
  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;
  FOR v_lig_exec IN c_lig_exec LOOP
    IF CTL_cpt(v_lig_exec.ide_cpt_ana) = 1 THEN
	  IF CTL_cpt(v_lig_exec.ide_cpt_pat) = 1 THEN
        IF CTL_ide_lig_prev(v_lig_exec.ide_lig_prev) = 1 THEN
          /* on insere */
          INSERT INTO FN_LIGNE_BUD_EXEC
          ( var_bud,ide_lig_exec,ide_lig_prev,ide_lig_pere,libn,var_cpta,ide_cpt_ana,ide_cpt_pat,libc,libl,flg_imput,dat_fval )
          VALUES
          ( p_var_bud, v_lig_exec.ide_lig_exec,
            v_lig_exec.ide_lig_prev,
            v_lig_exec.ide_lig_pere,
            v_lig_exec.libn,
            p_var_cpta,
            v_lig_exec.ide_cpt_ana,
            v_lig_exec.ide_cpt_pat,
            v_lig_exec.libc,
            v_lig_exec.libl,
            v_lig_exec.flg_imput,
            v_lig_exec.dat_fval );
          /* incrementation du nombre d'enreg en dupliques */
          w_nb_lig_dup := w_nb_lig_dup + 1;
        ELSE
          /* ligne de previsiov inexistante sur cette variation budgetaire */
          MAJ_FM_ERREUR(20,RPAD(w_var_bud,5)||RPAD(v_lig_exec.ide_lig_exec,30),
                        704,'+@+'||v_lig_exec.ide_lig_prev||'+@+'||p_var_bud||'+@++@+');
          /* incrementation du nombre d'enreg en ano*/
          w_nb_lig_ano := w_nb_lig_ano + 1;
        END IF;
      ELSE
        /* compte patrimonial inexistant sur cette variation comptable */
        MAJ_FM_ERREUR(20,RPAD(w_var_bud,5)||RPAD(v_lig_exec.ide_lig_exec,30),
                      706,'+@+'||v_lig_exec.ide_cpt_pat||'+@+'||p_var_cpta||'+@++@+');
        /* incrementation du nombre d'enreg en ano*/
        w_nb_lig_ano := w_nb_lig_ano + 1;
      END IF;
    ELSE
      /* compte analytique inexistant sur cette variation comptable */
      MAJ_FM_ERREUR(20,RPAD(w_var_bud,5)||RPAD(v_lig_exec.ide_lig_exec,30),
                    705,'+@+'||v_lig_exec.ide_cpt_ana||'+@+'||p_var_cpta||'+@++@+');
      /* incrementation du nombre d'enreg en ano*/
      w_nb_lig_ano := w_nb_lig_ano + 1;
    END IF;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    w_ret := -1;
	IF GLOBAL.FICHIER_TRACE IS NOT NULL THEN
		AFF_TRACE('MAJ_DUP_NOMEN_BUD.MAJ_FN_LIGNE_BUD_EXEC', 0, 105, sqlerrm, null, null, GLOBAL.Fichier_Trace, 'E');
	END IF;
END;

/* ***************************************************************************************** */
/* ***************************************************************************************** */
/*                                   Programme principal                                     */
/* ***************************************************************************************** */
/* ***************************************************************************************** */

BEGIN

  /* initialisations */
  p_ret := 1;
  p_nb_ligne_dup := 0;
  p_nb_ligne_ano := 0;


  MAJ_PN_STRUCT_ZONE(p_var_bud_orig,p_var_bud,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -4;
    RAISE exit_error;
  END IF;
  trace('apres pn_struct_zone '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_FN_LIGNE_BUD_PREV(p_var_bud_orig,p_var_bud,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -2;
    RAISE exit_error;
  END IF;
  trace('apres fn_ligne_bud_prev '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_FN_LIGNE_BUD_EXEC(p_var_bud_orig,p_var_bud,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -3;
    RAISE exit_error;
  END IF;
  trace('apres fn_ligne_bud_exec '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  /* validation */
  COMMIT;

EXCEPTION
  WHEN EXIT_ERROR THEN
    ROLLBACK;
    p_nb_ligne_dup := 0;
    p_nb_ligne_ano := 0;
  WHEN OTHERS THEN
    ROLLBACK;
    p_ret := -1;
    p_nb_ligne_dup := 0;
    p_nb_ligne_ano := 0;
	IF GLOBAL.FICHIER_TRACE IS NOT NULL THEN
		AFF_TRACE('MAJ_DUP_NOMEN_BUD', 0, 105, sqlerrm, null, null, GLOBAL.Fichier_Trace, 'E');
	END IF;

END MAJ_DUP_NOMEN_BUD;

/

CREATE OR REPLACE PROCEDURE MAJ_DUP_NOMEN_CPTA(p_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                                               p_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
											   p_date_perime IN DATE,
                                               p_nb_ligne_dup OUT NUMBER,
                                               p_nb_ligne_ano OUT NUMBER,
                                               p_ret OUT NUMBER)
IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : MES
-- Nom           : MAJ_DUP_NOMEN_CPTA
-- ---------------------------------------------------------------------------
--  Auteur         : VLA
--  Date creation  : 18/09/2000
-- ---------------------------------------------------------------------------
-- Role          : Recopie d'une nomenclature comptable
--
-- Parametres    :
--         Entrée
--		      	 1 - P_VAR_CPTA_ORIG: variation comptable d'origine
--				 2 - P_VAR_CPTA: nouvelle variation comptable
--     Sortie
--				 3 - P_nb_ligne_dup : nombre de lignes dupliquees
--				 4 - P_nb_ligne_ano : nombre de lignes en anomalie
--				 5 - P_RET       : code retour de la procedure : 1 si OK
--                                                             < 0 si KO
--
-- Valeurs retournees :
-- 		   			   				   1  Pas d'erreur
--                                    <0 Erreur lors de l'execution
-- 		   Parametres 3, 4, et 5 modifiés en sortie
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) MAJ_DUP_NOMEN_CPTA.sql version 2.1-1.1 : SNE : 11/09/2001
-- ---------------------------------------------------------------------------
--
-- -----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- -----------------------------------------------------------------------------------------------------
-- @(#) MAJ_DUP_NOMEN_CPTA.sql 1.0-1.0	|18/09/2000| VLA	| Création
-- @(#) MAJ_DUP_NOMEN_CPTA.sql 2.1-1.1	|11/09/2001| SNE	| Lot 3 V2.1 - Suppression FLG_DSO_ASSIGN
-- @(#) MAJ_DUP_NOMEN_CPTA.sql 2.2-1.2	|13/12/2001| LGD	| V2.2 - Changement de taille de zones + Constantes
-- @(#) MAJ_DUP_NOMEN_CPTA.sql 3.5B-2.0	|08/11/2005| RDU	| V3.5B - Changement de la taille de la zone ide_Critere (de 2 à 3)
-- @(#) MAJ_DUP_NOMEN_CPTA.sql v4200	|18/04/2007| FBT	| Mise à jour suite à l'évolution DI44_CC2007_04
-- @(#) MAJ_DUP_NOMEN_CPTA.sql v4200	|29/05/2007| FBT	| Mise à jour suite à l'évolution DI44_CC2007_03
-- @(#) MAJ_DUP_NOMEN_CPTA.sql v4220	|25/09/2007| FBT	| Mise à jour suite à l'évolution DI44_CC2007_09 (on remplace le filtre date du jour par date passé en paramètre)
-- @(#) MAJ_DUP_NOMEN_CPTA.sql v4230	|04/10/2007| FBT	| Evol DI44_CC2007_06 (Gestion de nouvelles colonnes sur RC_SPEC, RC_MODELE_LIGNE,RC_SCHEMA_CPTA)
-- @(#) MAJ_DUP_NOMEN_CPTA.sql v4231	|14/03/2008| FBT	| Ano Mantis 218.
-- @(#) MAJ_DUP_NOMEN_CPTA.sql v4260    |16/05/2008| PGE    | evol_DI44_2008_014 Controle sur les dates de validité de RC_MODELE_LIGNE
-- @(#) MAJ_DUP_NOMEN_CPTA.sql v4261    |15/10/2008| PGE    | ANO 296 : non prise en compte des dates de début et fin validité de RC_SPEC
-- @(#) MAJ_DUP_NOMEN_CPTA.sql v4270    |19/11/2008| PGE    | Evol_2008_17 : Ajout du champ FC_JOURNAL.flg_rectif
-- @(#) MAJ_DUP_NOMEN_CPTA.sql v4270    |03/12/2008| PGE    | Evol_2008_18 : Ajout du champ FN_COMPTE.gain_perte
-- @(#) MAJ_DUP_NOMEN_CPTA.sql v4281    |25/06/2009| PGE    | Ano 383 : Prise en compte des dates de fin de validité de PC_PEC_REGLEMENT
-- ---------------------------------------------------------------------------------------------------------
*/
v_ret NUMBER := 1;
v_nb_ligne_dup NUMBER := 0;
v_nb_ligne_ano NUMBER := 0;
v_cod_non SR_CODIF.cod_codif%TYPE;
v_lib SR_CODIF.libl%TYPE;
v_ret_codext NUMBER;
exit_error EXCEPTION;

/* Constantes pour les tailles de champ */
cst_Taille_var_cpta       CONSTANT NUMBER := 5;
cst_Taille_ide_cpt        CONSTANT NUMBER := 15;
cst_Taille_ide_jal        CONSTANT NUMBER := 10;
cst_Taille_cod_typ_regle  CONSTANT NUMBER := 1;
cst_Taille_ide_typ_poste  CONSTANT NUMBER := 5;
cst_Taille_cod_sens       CONSTANT NUMBER := 1;
cst_Taille_ide_critere    CONSTANT NUMBER := 3; --- RDU(Unilog), 08/11/2005 - Extension "ide_critere" de 2 à 3
cst_Taille_cod_traitement CONSTANT NUMBER := 10;
cst_Taille_cod_list_cpt   CONSTANT NUMBER := 5;
cst_Taille_ide_spec       CONSTANT NUMBER := 4;
cst_Taille_cod_signe	  CONSTANT NUMBER := 1;
cst_Taille_cod_typ_piece  CONSTANT NUMBER := 2;
cst_Taille_ide_schema     CONSTANT NUMBER := 15;
cst_Taille_ide_modele_lig CONSTANT NUMBER := 15; --- LGD, 13/12/2001 - Extension "ide_mode_lig" de 5 à 15
cst_Taille_ide_grp_action CONSTANT NUMBER := 4;
cst_Taille_num_ligne      CONSTANT NUMBER := 2;


PROCEDURE trace(pp_chaine IN VARCHAR2) IS
BEGIN
  --dbms_output.put_line(pp_chaine);
  null;
END;

/* ***************************************************************************************** */
/* ***************************************************************************************** */
/*                            declaration des procedures internes                            */
/* ***************************************************************************************** */
/* ***************************************************************************************** */

/* Procedure d'insertion dans la table FM_ERREUR */
PROCEDURE MAJ_FM_ERREUR ( pp_ide_entite IN FM_ERREUR.ide_entite%TYPE,
                          pp_par_entite IN FM_ERREUR.par_entite%TYPE,
                          pp_ide_mess_err IN FM_ERREUR.ide_mess_err%TYPE,
                          pp_par_mess IN FM_ERREUR.par_mess%TYPE) IS
BEGIN
  INSERT INTO fm_erreur
    (cod_typ_nd,ide_nd_emet,ide_mess,flg_emis_recu,ide_entite,
     par_entite,ide_mess_err,par_mess)
  VALUES
    ('-','-',-1,'-',
     pp_ide_entite,
     pp_par_entite,
     pp_ide_mess_err,
     pp_par_mess);
END;

/* ***************************************************************************************** */
/* Procedure de duplication des comptes */
/* ***************************************************************************************** */
PROCEDURE MAJ_FN_COMPTE( w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_nb_ligne_dup OUT NUMBER,
                         w_nb_ligne_ano OUT NUMBER,
                         w_ret OUT NUMBER) IS

  no_parent EXCEPTION ;
  PRAGMA EXCEPTION_INIT(no_parent,-02291);

  CURSOR c_fn_compte IS
  SELECT * FROM FN_COMPTE
  WHERE var_cpta = w_var_cpta_orig
  AND (dat_fval IS NULL OR trunc(dat_fval) > trunc(p_date_perime));

  CURSOR c_fn_compte_new IS
  SELECT
  CNEW.var_cpta,
  CNEW.ide_cpt,
  DECODE(CBE.ide_cpt,null,'KO','OK') trouve,
  COLD.ide_cpt_be
  FROM FN_COMPTE CNEW, FN_COMPTE COLD, FN_COMPTE CBE
  WHERE CNEW.var_cpta = w_var_cpta
  AND COLD.var_cpta = w_var_cpta_orig
  AND COLD.ide_cpt = CNEW.ide_cpt
  AND CBE.var_cpta(+) = w_var_cpta
  AND CBE.ide_cpt(+) = COLD.ide_cpt_be;

  PROCEDURE f_delete_fils_cpt( pp_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                                pp_ide_cpt IN FN_COMPTE.ide_cpt%TYPE) IS
    /* procedure recursive qui permet, avt d'effacer un compte, d'effacer ces "fils" */
    v_var_cpta_be PN_VAR_CPTA.var_cpta%TYPE;
    v_ide_cpt_be FN_COMPTE.ide_cpt%TYPE;
    CURSOR c_compte IS
    SELECT var_cpta,ide_cpt, rowid AS ROW_ID
    FROM FN_COMPTE
    WHERE var_cpta_be = pp_var_cpta AND ide_cpt_be = pp_ide_cpt
    AND ( var_cpta != pp_var_cpta OR ide_cpt != pp_ide_cpt )
    FOR UPDATE;

  BEGIN
    FOR v_compte IN c_compte LOOP
      f_delete_fils_cpt(v_compte.var_cpta,v_compte.ide_cpt);
      delete fn_compte where var_cpta = v_compte.var_cpta and ide_cpt = v_compte.ide_cpt;
      /* insertion de l'ano dans FM_ERREUR */
      MAJ_FM_ERREUR(6,RPAD(v_compte.var_cpta,cst_Taille_var_cpta)||RPAD(v_compte.ide_cpt,cst_Taille_ide_cpt),688,'+@++@++@+');
      /* incrementation du nombre d'enreg en ano */
      w_nb_ligne_ano := w_nb_ligne_ano + 1;
    END LOOP;
  END;

BEGIN

  /* initialisation des variables OUT */
  w_ret := 1;
  w_nb_ligne_ano := 0;
  w_nb_ligne_dup := 0;

  FOR v_fn_compte IN c_fn_compte LOOP
    /* on insere les compte avec un compte de reprise egal au compte */
    INSERT INTO FN_COMPTE( var_cpta
		   				   , ide_cpt
                           , var_cpta_be
						   , ide_cpt_be
                           , libn
                           , ide_typ_cpt
						   , dat_dval
						   , dat_fval
                           , cod_typ_be
						   , cod_sens_solde
                           , flg_acentra
						   , flg_atrans
						   , flg_rtrans
						   , flg_rgrp
                           , flg_simp
						   , flg_bequille
						   , flg_justif
						   , flg_justif_tiers
						   , flg_justif_cpt
						   , libl
						   , flg_aux_loc
						   , flg_devise
						   , flg_annul_dcst
						   , gain_perte)-- PGE V4270 Evol_2008_018
    VALUES (w_var_cpta
		   , v_fn_compte.ide_cpt
           , w_var_cpta
		   , v_fn_compte.ide_cpt
           , v_fn_compte.libn
           , v_fn_compte.ide_typ_cpt
		   , v_fn_compte.dat_dval
		   , v_fn_compte.dat_fval
           , v_fn_compte.cod_typ_be
		   , v_fn_compte.cod_sens_solde
           , v_fn_compte.flg_acentra
		   , v_fn_compte.flg_atrans
		   , v_fn_compte.flg_rtrans
		   , v_fn_compte.flg_rgrp
           , v_fn_compte.flg_simp
		   , v_fn_compte.flg_bequille
		   , v_fn_compte.flg_justif
		   , v_fn_compte.flg_justif_tiers
		   , v_fn_compte.flg_justif_cpt
		   , v_fn_compte.libl
		   , v_fn_compte.flg_aux_loc
		   , v_fn_compte.flg_devise
		   , v_fn_compte.flg_annul_dcst
		   , v_fn_compte.gain_perte);-- PGE V4270 Evol_2008_018
  END LOOP;

  /* Pour chq compte que l'on a insere, on recherche le compte de reprise indiqué sur la variation d'origine */
  FOR v_fn_compte IN c_fn_compte_new LOOP

    IF v_fn_compte.trouve = 'OK' THEN
      /* le compte de reprise existe sur la nouvelle variation */
      BEGIN
        UPDATE FN_COMPTE
        SET ide_cpt_be = v_fn_compte.ide_cpt_be
        WHERE var_cpta = v_fn_compte.var_cpta
        AND ide_cpt = v_fn_compte.ide_cpt;
        /* incrementation du nombre d'enreg dupliques */
        w_nb_ligne_dup := w_nb_ligne_dup + 1;
      EXCEPTION
        WHEN no_parent THEN
          /* le compte de reprise a deja ete efface par la suite ( ELSE ) */
          /* on efface ce compte egalement puisque le compte de reprise n'existe plus */
          f_delete_fils_cpt(v_fn_compte.var_cpta,v_fn_compte.ide_cpt);
          DELETE FN_COMPTE
          WHERE var_cpta = v_fn_compte.var_cpta
          AND ide_cpt = v_fn_compte.ide_cpt;
          /* insertion de l'ano dans FM_ERREUR */
          MAJ_FM_ERREUR(6,RPAD(w_var_cpta,cst_Taille_var_cpta)||RPAD(v_fn_compte.ide_cpt,cst_Taille_ide_cpt),688,'+@++@++@+');
          /* incrementation du nombre d'enreg en ano */
          w_nb_ligne_ano := w_nb_ligne_ano + 1;
      END;
    ELSE
      /* le compte de reprise n'existe pas sur la nouvelle variation */
      /* on efface les fils eventuels  puis le compte */
      f_delete_fils_cpt(v_fn_compte.var_cpta,v_fn_compte.ide_cpt);
      DELETE FN_COMPTE
      WHERE var_cpta = v_fn_compte.var_cpta
      AND ide_cpt = v_fn_compte.ide_cpt;
      /* insertion de l'ano dans FM_ERREUR */
      MAJ_FM_ERREUR(6,RPAD(w_var_cpta,cst_Taille_var_cpta)||RPAD(v_fn_compte.ide_cpt,cst_Taille_ide_cpt),688,'+@++@++@+');
      /* incrementation du nombre d'enreg en ano */
      w_nb_ligne_ano := w_nb_ligne_ano + 1;
    END IF;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    trace(sqlcode||'-'||sqlerrm);
    w_ret := -1;
END;

/* ***************************************************************************************** */
/* Procedure de duplication des journaux */
/* ***************************************************************************************** */
PROCEDURE MAJ_FC_JOURNAL(w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_nb_lig_dup OUT NUMBER,
                         w_nb_lig_ano OUT NUMBER,
                         w_ret OUT NUMBER) IS

  CURSOR c_fc_journal IS
  SELECT * FROM FC_JOURNAL
  WHERE var_cpta = w_var_cpta_orig
  AND ( TRUNC(dat_fval) > TRUNC(p_date_perime) OR dat_fval IS NULL );

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  FOR v_fc_journal IN c_fc_journal LOOP

    DECLARE
      no_parent EXCEPTION;
      PRAGMA EXCEPTION_INIT(no_parent, -02291);
    BEGIN
      INSERT INTO FC_JOURNAL
      (var_cpta,ide_jal,ide_typ_jal,dat_dval,dat_fval,
       flg_saisi,flg_annul,flg_be,flg_centra,flg_repsolde,flg_fingest,flg_reflexion,libn,flg_rectif)/* PGE evol_2008_17 V4270 Ajout flg_rectif*/
      VALUES (w_var_cpta, v_fc_journal.ide_jal, v_fc_journal.ide_typ_jal,
            v_fc_journal.dat_dval, v_fc_journal.dat_fval,
            v_fc_journal.flg_saisi,
            v_fc_journal.flg_annul,
            v_fc_journal.flg_be,
            v_fc_journal.flg_centra,
            v_fc_journal.flg_repsolde,
            v_fc_journal.flg_fingest,
            v_fc_journal.flg_reflexion,
            v_fc_journal.libn,
			v_fc_journal.flg_rectif);/* PGE evol_2008_17 V4270 Ajout flg_rectif*/
      /* incrementation du nombre d'enreg en dupliques */
      w_nb_lig_dup := w_nb_lig_dup + 1;

    EXCEPTION
      WHEN no_parent THEN
        /* insertion de l'erreur dans FM_ERREUR */
        MAJ_FM_ERREUR(7,RPAD(w_var_cpta,cst_Taille_var_cpta)||RPAD(v_fc_journal.ide_jal,cst_Taille_ide_jal)
,690,'+@++@++@++@+');
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
      WHEN OTHERS THEN
        /* insertion de l'erreur dans FM_ERREUR */
        MAJ_FM_ERREUR(7,RPAD(w_var_cpta,cst_Taille_var_cpta)||RPAD(v_fc_journal.ide_jal,cst_Taille_ide_jal)
,105,'+@+'||sqlerrm||'+@++@++@+');
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
    END;

  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    w_ret := -1;
END;

/* ***************************************************************************************** */
/* Procedure de duplication de la table RC_LISTE_COMPTE */
/* ***************************************************************************************** */
PROCEDURE MAJ_RC_LISTE_COMPTE (w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_nb_lig_dup OUT NUMBER,
                         w_nb_lig_ano OUT NUMBER,
                         w_ret OUT NUMBER) IS

  CURSOR c_rc_liste_compte IS
  SELECT
  cod_list_cpt,ide_cpt,dat_fval
  FROM RC_LISTE_COMPTE
  WHERE var_cpta = w_var_cpta_orig
  AND ( dat_fval IS NULL OR TRUNC(dat_fval) > TRUNC(p_date_perime));

  PROCEDURE GES_no_parent(w_cod_list_cpt IN RC_LISTE_COMPTE.cod_list_cpt%TYPE
                          ,w_ide_cpt IN FN_COMPTE.ide_cpt%TYPE) IS
    v_res CHAR(1) := '';
  BEGIN
    SELECT 'X' INTO v_res
    FROM FN_COMPTE
    WHERE var_cpta = w_var_cpta
    AND ide_cpt = w_ide_cpt;
    MAJ_FM_ERREUR(8,RPAD(w_cod_list_cpt,cst_Taille_cod_list_cpt)||
                    RPAD(w_var_cpta,cst_Taille_var_cpta)||
                    RPAD(w_ide_cpt,cst_Taille_ide_cpt),
                    690,'+@++@++@++@+');
  EXCEPTION
    WHEN no_data_found THEN
      MAJ_FM_ERREUR(8,RPAD(w_cod_list_cpt,cst_Taille_cod_list_cpt)||
                      RPAD(w_var_cpta,cst_Taille_var_cpta)||
                      RPAD(w_ide_cpt,cst_Taille_ide_cpt),
                      694,
                      '+@+'||w_ide_cpt||'+@+'||w_var_cpta||'+@++@+');
  END;

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  FOR v_rc_liste_compte IN c_rc_liste_compte LOOP

    DECLARE
      no_parent EXCEPTION;
      PRAGMA EXCEPTION_INIT (no_parent,-02291);
    BEGIN
      INSERT INTO RC_LISTE_COMPTE (cod_list_cpt,var_cpta,ide_cpt,dat_fval)
      VALUES (v_rc_liste_compte.cod_list_cpt,
              w_var_cpta,
              v_rc_liste_compte.ide_cpt,
              v_rc_liste_compte.dat_fval);
      /* incrementation du nombre d'enreg en dupliques */
      w_nb_lig_dup := w_nb_lig_dup + 1;
    EXCEPTION
      WHEN no_parent THEN
        /* insertion de l'erreur dans FM_ERREUR */
        GES_no_parent(v_rc_liste_compte.cod_list_cpt,v_rc_liste_compte.ide_cpt);
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
      WHEN OTHERS THEN
        /* insertion de l'erreur dans FM_ERREUR */
        MAJ_FM_ERREUR(8,RPAD(v_rc_liste_compte.cod_list_cpt,cst_Taille_cod_list_cpt)||
    	                  RPAD(w_var_cpta,cst_Taille_var_cpta)||
    	                  RPAD(v_rc_liste_compte.ide_cpt,cst_Taille_ide_cpt),105,'+@+'||sqlerrm||'+@++@++@+');
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
    END;

  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    w_ret := -1;
END;

/* ***************************************************************************************** */
/* Procedure de duplication des specifications */
/* ***************************************************************************************** */
PROCEDURE MAJ_RC_SPEC (w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                       w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                       w_nb_lig_dup OUT NUMBER,
                       w_nb_lig_ano OUT NUMBER,
                       w_ret OUT NUMBER) IS

  CURSOR c_rc_spec IS
  SELECT
  ide_cpt,cod_sens,cod_signe,ide_spec,mas_spec1,mas_spec2,mas_spec3,dat_dval,dat_fval
  FROM RC_SPEC
  WHERE var_cpta = w_var_cpta_orig
  AND CTL_DATE(p_date_perime,dat_fval)='O';--PGE 15/10/2008 V4261 ANO 296-

  PROCEDURE GES_no_parent(w_cod_sens IN RC_SPEC.cod_sens%TYPE,
  	                      w_cod_signe IN RC_SPEC.cod_signe%TYPE,
  	                      w_ide_spec IN RC_SPEC.ide_spec%TYPE,
                          w_ide_cpt IN FN_COMPTE.ide_cpt%TYPE) IS
    v_res CHAR(1) := '';
  BEGIN
    SELECT 'X' INTO v_res
    FROM FN_COMPTE
    WHERE var_cpta = w_var_cpta
    AND ide_cpt = w_ide_cpt;
    MAJ_FM_ERREUR(9,RPAD(w_var_cpta,cst_Taille_var_cpta)||
                    RPAD(w_ide_cpt,cst_Taille_ide_cpt)||
                    RPAD(w_cod_sens,cst_Taille_cod_sens)||
                    RPAD(w_cod_signe,cst_Taille_cod_signe) ||
                    RPAD(TO_CHAR(w_ide_spec),cst_Taille_ide_spec),
                    690,'+@++@++@++@+');
  EXCEPTION
    WHEN no_data_found THEN
      MAJ_FM_ERREUR(9,RPAD(w_var_cpta,cst_Taille_var_cpta)||
                      RPAD(w_ide_cpt,cst_Taille_ide_cpt)||
                      RPAD(w_cod_sens,cst_Taille_cod_sens)||
                      RPAD(w_cod_signe,cst_Taille_cod_signe) ||
                      RPAD(TO_CHAR(w_ide_spec),cst_Taille_ide_spec),
                      694,
                      '+@+'||w_ide_cpt||'+@+'||w_var_cpta||'+@++@+');
  END;

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  FOR v_rc_spec IN c_rc_spec LOOP

    DECLARE
      no_parent EXCEPTION;
      PRAGMA EXCEPTION_INIT(no_parent,-02291);
    BEGIN
      INSERT INTO RC_SPEC (var_cpta,ide_cpt,cod_sens,cod_signe,ide_spec,mas_spec1,mas_spec2,mas_spec3,dat_dval,dat_fval)
      VALUES (w_var_cpta,
  	        v_rc_spec.ide_cpt,
  	        v_rc_spec.cod_sens,
  	        v_rc_spec.cod_signe,
  	        v_rc_spec.ide_spec,
  	        v_rc_spec.mas_spec1,
  	        v_rc_spec.mas_spec2,
  	        v_rc_spec.mas_spec3,
		v_rc_spec.dat_dval,
		v_rc_spec.dat_fval);
      /* incrementation du nombre d'enreg en dupliques */
      w_nb_lig_dup := w_nb_lig_dup + 1;
    EXCEPTION
      WHEN no_parent THEN
        /* insertion de l'erreur dans FM_ERREUR */
        GES_no_parent(v_rc_spec.cod_sens,
                      v_rc_spec.cod_signe,
                      v_rc_spec.ide_spec,
                      v_rc_spec.ide_cpt);
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
      WHEN OTHERS THEN
        /* insertion de l'erreur dans FM_ERREUR */
        MAJ_FM_ERREUR(9,  RPAD(w_var_cpta,cst_Taille_var_cpta)||
    	                  RPAD(v_rc_spec.ide_cpt,cst_Taille_ide_cpt)||
    	                  RPAD(v_rc_spec.cod_sens,cst_Taille_cod_sens)||
    	                  RPAD(v_rc_spec.cod_signe,cst_Taille_cod_signe)||
    	                  RPAD(TO_CHAR(v_rc_spec.ide_spec),cst_Taille_ide_spec),105,'+@+'||sqlerrm||'+@++@++@+');
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
    END;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    w_ret := -1;
END;

/* ***************************************************************************************** */
/* Procedure de recopie des droits aux journaux */
/* ***************************************************************************************** */
PROCEDURE MAJ_RC_DROIT_JOURNAL (w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                                w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                                w_nb_lig_dup OUT NUMBER,
                                w_nb_lig_ano OUT NUMBER,
                                w_ret OUT NUMBER) IS

  CURSOR c_rc_droit_journal IS
  SELECT
  ide_jal,ide_typ_poste,dat_fval
  FROM RC_DROIT_JOURNAL
  WHERE var_cpta = w_var_cpta_orig
  AND ( dat_fval IS NULL OR TRUNC(dat_fval) > TRUNC(p_date_perime));

  PROCEDURE GES_no_parent(w_ide_typ_poste IN RC_DROIT_JOURNAL.ide_typ_poste%TYPE
                          ,w_ide_jal IN FC_JOURNAL.ide_jal%TYPE) IS
    v_res CHAR(1) := '';
  BEGIN
    SELECT 'X' INTO v_res
    FROM FC_JOURNAL
    WHERE var_cpta = w_var_cpta
    AND ide_jal = w_ide_jal;
    MAJ_FM_ERREUR(10,RPAD(w_var_cpta,cst_Taille_var_cpta)||
                     RPAD(w_ide_jal,cst_Taille_ide_jal)||
                     RPAD(w_ide_typ_poste,cst_Taille_ide_typ_poste),
                     690,'+@++@++@++@+');
  EXCEPTION
    WHEN no_data_found THEN
      MAJ_FM_ERREUR(10,RPAD(w_var_cpta,cst_Taille_var_cpta)||
                       RPAD(w_ide_jal,cst_Taille_ide_jal)||
                       RPAD(w_ide_typ_poste,cst_Taille_ide_typ_poste),
                       695,
                       '+@+'||w_ide_jal||'+@+'||w_var_cpta||'+@++@+');
  END;

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  FOR v_rc_droit_journal IN c_rc_droit_journal LOOP

    DECLARE
      no_parent EXCEPTION;
      PRAGMA EXCEPTION_INIT(no_parent,-02291);
    BEGIN
      INSERT INTO RC_DROIT_JOURNAL (var_cpta,ide_jal,ide_typ_poste,dat_fval)
      VALUES (w_var_cpta,
              v_rc_droit_journal.ide_jal,
              v_rc_droit_journal.ide_typ_poste,
              v_rc_droit_journal.dat_fval);
      /* incrementation du nombre d'enreg en dupliques */
      w_nb_lig_dup := w_nb_lig_dup + 1;
    EXCEPTION
      WHEN no_parent THEN
        /* insertion de l'erreur dans FM_ERREUR */
        GES_no_parent(v_rc_droit_journal.ide_typ_poste,v_rc_droit_journal.ide_jal);
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
      WHEN OTHERS THEN
        /* insertion de l'erreur dans FM_ERREUR */
        MAJ_FM_ERREUR(10,RPAD(w_var_cpta,cst_Taille_var_cpta)||
                         RPAD(v_rc_droit_journal.ide_jal,cst_Taille_ide_jal)||
                         RPAD(v_rc_droit_journal.ide_typ_poste,cst_Taille_ide_typ_poste),105,'+@+'||sqlerrm||'+@++@++@+');
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
    END;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    w_ret := -1;
END;

/* ***************************************************************************************** */
/* procedure de recopie des droits aux comptes */
/* ***************************************************************************************** */
PROCEDURE MAJ_RC_DROIT_COMPTE (w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                               w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                               w_nb_lig_dup OUT NUMBER,
                               w_nb_lig_ano OUT NUMBER,
                               w_ret OUT NUMBER) IS

  CURSOR c_rc_droit_compte IS
  SELECT
  ide_cpt,ide_typ_poste,dat_fval,cod_sens_ope,cod_sens_solde,cod_sens_be,flg_imput_be,flg_imput_comp
  FROM RC_DROIT_COMPTE
  WHERE var_cpta = w_var_cpta_orig
  AND ( dat_fval IS NULL OR TRUNC(dat_fval) > TRUNC(p_date_perime));

  PROCEDURE GES_no_parent(w_ide_typ_poste IN RC_DROIT_COMPTE.ide_typ_poste%TYPE
                          ,w_ide_cpt IN FN_COMPTE.ide_cpt%TYPE) IS
    v_res CHAR(1) := '';
  BEGIN
    SELECT 'X' INTO v_res
    FROM FN_COMPTE
    WHERE var_cpta = w_var_cpta
    AND ide_cpt = w_ide_cpt;
    MAJ_FM_ERREUR(11,RPAD(w_var_cpta,cst_Taille_var_cpta)||
                     RPAD(w_ide_cpt,cst_Taille_ide_cpt)||
                     RPAD(w_ide_typ_poste,cst_Taille_ide_typ_poste),
                     690,'+@++@++@++@+');
  EXCEPTION
    WHEN no_data_found THEN
      MAJ_FM_ERREUR(11,RPAD(w_var_cpta,cst_Taille_var_cpta)||
                       RPAD(w_ide_cpt,cst_Taille_ide_cpt)||
                       RPAD(w_ide_typ_poste,cst_Taille_ide_typ_poste),
                       694,
                       '+@+'||w_ide_cpt||'+@+'||w_var_cpta||'+@++@+');
  END;

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  FOR v_rc_droit_compte IN c_rc_droit_compte LOOP

    DECLARE
      no_parent EXCEPTION;
      PRAGMA EXCEPTION_INIT(no_parent,-02291);
    BEGIN
      INSERT INTO RC_DROIT_COMPTE
         (var_cpta,
          ide_cpt,
          ide_typ_poste,
          dat_fval,
          cod_sens_ope,
          cod_sens_solde,
          cod_sens_be,
          flg_imput_be,
          flg_imput_comp)
      VALUES (w_var_cpta,
          v_rc_droit_compte.ide_cpt,
          v_rc_droit_compte.ide_typ_poste,
          v_rc_droit_compte.dat_fval,
          v_rc_droit_compte.cod_sens_ope,
          v_rc_droit_compte.cod_sens_solde,
          v_rc_droit_compte.cod_sens_be,
          v_rc_droit_compte.flg_imput_be,
          v_rc_droit_compte.flg_imput_comp);
      /* incrementation du nombre d'enreg en dupliques */
      w_nb_lig_dup := w_nb_lig_dup + 1;
    EXCEPTION
      WHEN no_parent THEN
        /* insertion de l'erreur dans FM_ERREUR */
        GES_no_parent(v_rc_droit_compte.ide_typ_poste,v_rc_droit_compte.ide_cpt);
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
      WHEN OTHERS THEN
        /* insertion de l'erreur dans FM_ERREUR */
        MAJ_FM_ERREUR(11,RPAD(w_var_cpta,cst_Taille_var_cpta)||
                         RPAD(v_rc_droit_compte.ide_cpt,cst_Taille_ide_cpt)||    --- LGD 10 à 15 / à la base
                         RPAD(v_rc_droit_compte.ide_typ_poste,cst_Taille_ide_typ_poste),105,'+@+'||sqlerrm||'+@++@++@+');
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
    END;

  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    w_ret := -1;
END;

/* ***************************************************************************************** */
/* Procedure de recopie des schemas comptables */
/* ***************************************************************************************** */
PROCEDURE MAJ_RC_SCHEMA_CPTA (w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_nb_lig_dup OUT NUMBER,
                         w_nb_lig_ano OUT NUMBER,
                         w_ret OUT NUMBER) IS

  CURSOR c_rc_schema_cpta IS
  SELECT
  ide_jal
  ,ide_schema
  ,libn
  ,dat_dval
  ,dat_fval
  ,des_schema
  ,cod_typ_schema
  ,ide_fct
  ,flg_dat_valeur
  ,flg_annul_ecr
  ,typ_ecriture
  FROM RC_SCHEMA_CPTA
  WHERE var_cpta = w_var_cpta_orig
  AND ( dat_fval IS NULL OR trunc(dat_fval) > trunc(p_date_perime) );

  PROCEDURE GES_no_parent(w_ide_jal IN FC_JOURNAL.ide_jal%TYPE
                          ,w_ide_schema IN RC_SCHEMA_CPTA.ide_schema%TYPE) IS
    v_res CHAR(1) := '';
  BEGIN
    SELECT 'X' INTO v_res
    FROM FC_JOURNAL
    WHERE var_cpta = w_var_cpta
    AND ide_jal = w_ide_jal;
    MAJ_FM_ERREUR(12,RPAD(w_var_cpta,cst_Taille_var_cpta)||
                     RPAD(w_ide_jal,cst_Taille_ide_jal)||
                     RPAD(w_ide_schema,cst_Taille_ide_schema),
                     690,'+@++@++@++@+');
  EXCEPTION
    WHEN no_data_found THEN
      MAJ_FM_ERREUR(12,RPAD(w_var_cpta,cst_Taille_var_cpta)||
                       RPAD(w_ide_jal,cst_Taille_ide_jal)||
                       RPAD(w_ide_schema,cst_Taille_ide_schema),
                       695,
                       '+@+'||w_ide_jal||'+@+'||w_var_cpta||'+@++@+');
  END;

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  FOR v_rc_schema_cpta IN c_rc_schema_cpta LOOP

    DECLARE
      no_parent EXCEPTION;
      PRAGMA EXCEPTION_INIT(no_parent,-02291);
    BEGIN
      INSERT INTO RC_SCHEMA_CPTA (var_cpta
	  		 	  				 ,ide_jal
								 ,ide_schema
								 ,libn,dat_dval
								 ,dat_fval
								 ,des_schema
								 ,cod_typ_schema
								 ,ide_fct
								 ,flg_dat_valeur
								 ,flg_annul_ecr
								 ,typ_ecriture
								 )
      VALUES (w_var_cpta
              , v_rc_schema_cpta.ide_jal
              , v_rc_schema_cpta.ide_schema
              , v_rc_schema_cpta.libn
              , v_rc_schema_cpta.dat_dval
              , v_rc_schema_cpta.dat_fval
              , v_rc_schema_cpta.des_schema
              , v_rc_schema_cpta.cod_typ_schema
	      	  , v_rc_schema_cpta.ide_fct
              , v_rc_schema_cpta.flg_dat_valeur
	      	  , v_rc_schema_cpta.flg_annul_ecr
			  , v_rc_schema_cpta.typ_ecriture);
      /* incrementation du nombre d'enreg en dupliques */
      w_nb_lig_dup := w_nb_lig_dup + 1;
    EXCEPTION
      WHEN no_parent THEN
        /* insertion de l'erreur dans FM_ERREUR */
        GES_no_parent(v_rc_schema_cpta.ide_jal,v_rc_schema_cpta.ide_schema);
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
      WHEN OTHERS THEN
        /* insertion de l'erreur dans FM_ERREUR */
        MAJ_FM_ERREUR(12,RPAD(w_var_cpta,cst_Taille_var_cpta)||
                         RPAD(v_rc_schema_cpta.ide_jal,cst_Taille_ide_jal)||
    	                   RPAD(v_rc_schema_cpta.ide_schema,cst_Taille_ide_schema),105,'+@+'||sqlerrm||'+@++@++@+');
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
    END;
  END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      w_ret := -1;
END;

/* ***************************************************************************************** */
/* Procedure de recopie des schemas comptables */
/* ***************************************************************************************** */
PROCEDURE MAJ_RC_MODELE_LIGNE (w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_nb_lig_dup OUT NUMBER,
                         w_nb_lig_ano OUT NUMBER,
                         w_ret OUT NUMBER) IS

  CURSOR c_rc_modele_ligne IS
  SELECT
  IDE_JAL,IDE_SCHEMA,IDE_MODELE_LIG, RANG_LIG,
  COD_REF_PIECE,
  FLG_LIG_AUTO, FLG_MAJ_CPT, FLG_MAJ_SENS,
  FLG_MAJ_SPEC1, FLG_MAJ_SPEC2, FLG_MAJ_SPEC3,
  FLG_MAJ_ORDO, FLG_MAJ_BUD, FLG_MAJ_LIG_BUD,
  FLG_MAJ_OPE, COD_SIGNE, VAL_SENS,
  VAL_CPT, VAL_SPEC1, VAL_SPEC2,
  VAL_SPEC3, VAL_ORDO, VAL_BUD,
  VAL_LIG_BUD, VAL_OPE, MAS_CPT,
  MAS_SPEC1, MAS_SPEC2, MAS_SPEC3,
  MAS_ORDO, MAS_BUD, MAS_LIG_BUD,
  MAS_OPE,
  MAS_TIERS,
  MAS_REF_PIECE,
  COD_TYP_BUD,
  IDE_PLAN_AUX,
  IDE_CPT_AUX,
  COD_ANNUL_ECR,
  COD_TYP_PEC,
  FLG_ANNUL_CREANCE,
  DAT_DVAL,
  DAT_FVAL,
  COD_FORMAT
  FROM RC_MODELE_LIGNE
  WHERE var_cpta = w_var_cpta_orig
  AND ( dat_fval IS NULL OR TRUNC(dat_fval) > TRUNC(p_date_perime));--PGE V4260 EVOL_DI44_2008_014 16/05/2008

  PROCEDURE GES_no_parent(w_ide_jal IN RC_MODELE_LIGNE.ide_jal%TYPE,
                          w_ide_schema IN RC_MODELE_LIGNE.ide_schema%TYPE,
                          w_ide_modele_lig IN RC_MODELE_LIGNE.ide_modele_lig%TYPE) IS
    v_res CHAR(1) := '';
  BEGIN
    SELECT 'X' INTO v_res
    FROM RC_SCHEMA_CPTA
    WHERE var_cpta = w_var_cpta
    AND ide_jal = w_ide_jal
    AND ide_schema = w_ide_schema;
    MAJ_FM_ERREUR(13,RPAD(w_var_cpta,cst_Taille_var_cpta)||
                     RPAD(w_ide_jal,cst_Taille_ide_jal)||
                     RPAD(w_ide_schema,cst_Taille_ide_schema)||
                     RPAD(w_ide_modele_lig,cst_Taille_ide_modele_lig),690,'+@++@++@++@+');
  EXCEPTION
    WHEN no_data_found THEN
      MAJ_FM_ERREUR(13,RPAD(w_var_cpta,cst_Taille_var_cpta)||
                       RPAD(w_ide_jal,cst_Taille_ide_jal)||
                       RPAD(w_ide_schema,cst_Taille_ide_schema)||
                       RPAD(w_ide_modele_lig,cst_Taille_ide_modele_lig),
                       696,
                       '+@+'||w_ide_schema||'+@+'||w_ide_jal||'+@+'||w_var_cpta||'+@+');
  END;

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  FOR v_rc_modele_ligne IN c_rc_modele_ligne LOOP

    DECLARE
      no_parent EXCEPTION;
      PRAGMA EXCEPTION_INIT(no_parent,-02291);
    BEGIN
      INSERT INTO RC_MODELE_LIGNE (VAR_CPTA,
                                   IDE_JAL,
                                   IDE_SCHEMA,
                                   IDE_MODELE_LIG,
                                   RANG_LIG,
                                   COD_REF_PIECE, FLG_LIG_AUTO,
                                   FLG_MAJ_CPT, FLG_MAJ_SENS,
                                   FLG_MAJ_SPEC1, FLG_MAJ_SPEC2,
                                   FLG_MAJ_SPEC3, FLG_MAJ_ORDO,
                                   FLG_MAJ_BUD, FLG_MAJ_LIG_BUD,
                                   FLG_MAJ_OPE, COD_SIGNE, VAL_SENS,
                                   VAL_CPT, VAL_SPEC1, VAL_SPEC2, VAL_SPEC3,
                                   VAL_ORDO, VAL_BUD,
                                   VAL_LIG_BUD, VAL_OPE,
                                   MAS_CPT, MAS_SPEC1, MAS_SPEC2, MAS_SPEC3,
                                   MAS_ORDO,MAS_BUD,
                                   MAS_LIG_BUD,MAS_OPE,
                                   MAS_TIERS,MAS_REF_PIECE,COD_TYP_BUD,
				   IDE_PLAN_AUX,IDE_CPT_AUX,COD_ANNUL_ECR,COD_TYP_PEC,FLG_ANNUL_CREANCE,DAT_DVAL,DAT_FVAL,COD_FORMAT)
      VALUES (w_var_cpta,
            v_rc_modele_ligne.ide_jal,
            v_rc_modele_ligne.ide_schema,
            v_rc_modele_ligne.ide_modele_lig,
            v_rc_modele_ligne.rang_lig,
            v_rc_modele_ligne.cod_ref_piece, v_rc_modele_ligne.flg_lig_auto,
            v_rc_modele_ligne.flg_maj_cpt, v_rc_modele_ligne.flg_maj_sens,
            v_rc_modele_ligne.flg_maj_spec1,v_rc_modele_ligne.flg_maj_spec2,
            v_rc_modele_ligne.flg_maj_spec3,v_rc_modele_ligne.flg_maj_ordo,
            v_rc_modele_ligne.flg_maj_bud,v_rc_modele_ligne.flg_maj_lig_bud,
            v_rc_modele_ligne.flg_maj_ope,v_rc_modele_ligne.cod_signe,v_rc_modele_ligne.val_sens,
            v_rc_modele_ligne.val_cpt,v_rc_modele_ligne.val_spec1,v_rc_modele_ligne.val_spec2,v_rc_modele_ligne.val_spec3,
            v_rc_modele_ligne.val_ordo,v_rc_modele_ligne.val_bud,
            v_rc_modele_ligne.val_lig_bud,v_rc_modele_ligne.val_ope,
            v_rc_modele_ligne.mas_cpt,v_rc_modele_ligne.mas_spec1,v_rc_modele_ligne.mas_spec2,v_rc_modele_ligne.mas_spec3,
            v_rc_modele_ligne.mas_ordo,v_rc_modele_ligne.mas_bud,
            v_rc_modele_ligne.mas_lig_bud,v_rc_modele_ligne.mas_ope,
            v_rc_modele_ligne.mas_tiers,v_rc_modele_ligne.mas_ref_piece,v_rc_modele_ligne.cod_typ_bud,
	    v_rc_modele_ligne.ide_plan_aux,v_rc_modele_ligne.ide_cpt_aux,v_rc_modele_ligne.cod_annul_ecr,v_rc_modele_ligne.cod_typ_pec,v_rc_modele_ligne.FLG_ANNUL_CREANCE,
	    v_rc_modele_ligne.DAT_DVAL,v_rc_modele_ligne.DAT_FVAL,
            v_rc_modele_ligne.COD_FORMAT);
      /* incrementation du nombre d'enreg en dupliques */
      w_nb_lig_dup := w_nb_lig_dup + 1;
    EXCEPTION
      WHEN no_parent THEN
        /* insertion de l'erreur dans FM_ERREUR */
        GES_no_parent(v_rc_modele_ligne.ide_jal,v_rc_modele_ligne.ide_schema,v_rc_modele_ligne.ide_modele_lig);
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
      WHEN OTHERS THEN
        /* insertion de l'erreur dans FM_ERREUR */
        MAJ_FM_ERREUR(13,RPAD(w_var_cpta,cst_Taille_var_cpta)||
    	                 RPAD(v_rc_modele_ligne.ide_jal,cst_Taille_ide_jal)||
    	                 RPAD(v_rc_modele_ligne.ide_schema,cst_Taille_ide_schema)||
    	                 RPAD(v_rc_modele_ligne.ide_modele_lig,cst_Taille_ide_modele_lig),105,'+@+'||sqlerrm||'+@++@++@+');
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
    END;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    w_ret := -1;
END;

/* ***************************************************************************************** */
/* procedure de recopie des groupes d'actions */
/* ***************************************************************************************** */
PROCEDURE MAJ_PR_GROUPE_ACTION (w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_nb_lig_dup OUT NUMBER,
                         w_nb_lig_ano OUT NUMBER,
                         w_ret OUT NUMBER)  IS

  CURSOR c_pr_groupe_action IS
  SELECT
  COD_TYP_REGLE,
  IDE_TYP_POSTE,
  VAR_CPTA,
  IDE_GRP_ACTION,
  FLG_SUPPRIME
  FROM PR_GROUPE_ACTION
  WHERE var_cpta = w_var_cpta_orig
  AND flg_supprime = v_cod_non;

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  FOR v_pr_groupe_action IN c_pr_groupe_action LOOP

    DECLARE
      no_parent EXCEPTION;
      PRAGMA EXCEPTION_INIT(no_parent,-02291);
    BEGIN
      INSERT INTO PR_GROUPE_ACTION (COD_TYP_REGLE,
                                    IDE_TYP_POSTE,
                                    VAR_CPTA,
                                    IDE_GRP_ACTION,
                                    FLG_SUPPRIME)
      VALUES (v_pr_groupe_action.cod_typ_regle,
              v_pr_groupe_action.ide_typ_poste,
              w_var_cpta,
              v_pr_groupe_action.ide_grp_action,
              v_pr_groupe_action.flg_supprime);
      /* incrementation du nombre d'enreg en dupliques */
      w_nb_lig_dup := w_nb_lig_dup + 1;
    EXCEPTION
      WHEN no_parent THEN
        /* insertion de l'erreur dans FM_ERREUR */
        MAJ_FM_ERREUR(14,RPAD(v_pr_groupe_action.cod_typ_regle,cst_Taille_cod_typ_regle)||
    	                  RPAD(v_pr_groupe_action.ide_typ_poste,cst_Taille_ide_typ_poste)||
    	                  RPAD(w_var_cpta,cst_Taille_var_cpta)||
    	                  RPAD(to_char(v_pr_groupe_action.ide_grp_action),cst_Taille_ide_grp_action),690,'+@++@++@++@+');
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
      WHEN OTHERS THEN
        /* insertion de l'erreur dans FM_ERREUR */
        MAJ_FM_ERREUR(14,RPAD(v_pr_groupe_action.cod_typ_regle,cst_Taille_cod_typ_regle)||
    	                  RPAD(v_pr_groupe_action.ide_typ_poste,cst_Taille_ide_typ_poste)||
    	                  RPAD(w_var_cpta,cst_Taille_var_cpta)||
    	                  RPAD(to_char(v_pr_groupe_action.ide_grp_action),cst_Taille_ide_grp_action),105,'+@+'||sqlerrm||'+@++@++@+');
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
    END;
  END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      w_ret := -1;
END;


/* ***************************************************************************************** */
/* Procedure de recopie des actions */
/* ***************************************************************************************** */
PROCEDURE MAJ_PR_ACTION_CENTRA ( w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_nb_lig_dup OUT NUMBER,
                         w_nb_lig_ano OUT NUMBER,
                         w_ret OUT NUMBER) IS

  CURSOR c_pr_action_centra IS
  SELECT
  COD_TYP_REGLE,
  IDE_TYP_POSTE,
  IDE_GRP_ACTION,
  NUM_LIG,
  FLG_SUPPRIME,
  VAR_CPTA_CONTREP,
  IDE_CPT_CONTREP,
  IDE_POSTE_BENEF,
  FLG_CUMUL,
  IDE_JAL,
  IDE_SCHEMA,
  IDE_MODELE_LIG,
  IDE_CPT,
  VAL_SENS,
  VAL_MT,
  VAL_VAR_TIERS,
  VAL_TIERS,
  VAL_REF_PIECE,
  VAL_SPEC1,
  VAL_SPEC2,
  VAL_SPEC3,
  VAL_ORDO,
  VAL_BUD,
  VAL_TYP_BUD,
  VAL_LIG_EXEC,
  VAL_OPE,
  VAL_CPT_AUX
  FROM PR_ACTION_CENTRA
  WHERE var_cpta = w_var_cpta_orig
  AND flg_supprime = v_cod_non;

  PROCEDURE GES_no_parent(w_cod_typ_regle IN PR_ACTION_CENTRA.cod_typ_regle%TYPE,
    	                    w_ide_typ_poste IN PR_ACTION_CENTRA.ide_typ_poste%TYPE,
    	                    w_ide_grp_action IN PR_ACTION_CENTRA.ide_grp_action%TYPE,
    	                    w_num_lig IN PR_ACTION_CENTRA.num_lig%TYPE) IS
    v_res CHAR(1) := '';
  BEGIN
    SELECT 'X' INTO v_res
    FROM PR_GROUPE_ACTION
    WHERE cod_typ_regle = w_cod_typ_regle
    AND ide_typ_poste = w_ide_typ_poste
    AND var_cpta = w_var_cpta
    AND ide_grp_action = w_ide_grp_action;
    MAJ_FM_ERREUR(15,RPAD(w_cod_typ_regle,cst_Taille_cod_typ_regle)||
                     RPAD(w_ide_typ_poste,cst_Taille_ide_typ_poste)||
                     RPAD(w_var_cpta,cst_Taille_var_cpta)||
                     RPAD(to_char(w_ide_grp_action),cst_Taille_ide_grp_action)||
                     RPAD(to_char(w_num_lig),cst_Taille_num_ligne),690,'+@++@++@++@+');
  EXCEPTION
    WHEN no_data_found THEN
      MAJ_FM_ERREUR(15,RPAD(w_cod_typ_regle,cst_Taille_cod_typ_regle)||
                       RPAD(w_ide_typ_poste,cst_Taille_ide_typ_poste)||
                       RPAD(w_var_cpta,cst_Taille_var_cpta)||
                       RPAD(to_char(w_ide_grp_action),cst_Taille_ide_grp_action)||
                       RPAD(to_char(w_num_lig),cst_Taille_num_ligne),
                       697,
                       '+@+'||w_ide_grp_action||'+@++@++@+');
  END;

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  FOR v_pr_action_centra IN c_pr_action_centra LOOP

    DECLARE
      no_parent EXCEPTION;
      PRAGMA EXCEPTION_INIT(no_parent,-02291);
    BEGIN
      INSERT INTO PR_ACTION_CENTRA (COD_TYP_REGLE,
                                    IDE_TYP_POSTE,
                                    VAR_CPTA,
                                    IDE_GRP_ACTION,
                                    NUM_LIG,
                                    FLG_SUPPRIME,
                                    VAR_CPTA_CONTREP,
                                    IDE_CPT_CONTREP,
                                    IDE_POSTE_BENEF,
                                    FLG_CUMUL,
                                    IDE_JAL,
                                    IDE_SCHEMA,
                                    IDE_MODELE_LIG,
                                    IDE_CPT,
                                    VAL_SENS,
                                    VAL_MT,
                                    VAL_VAR_TIERS,
                                    VAL_TIERS,
                                    VAL_REF_PIECE,
                                    VAL_SPEC1, VAL_SPEC2, VAL_SPEC3,
                                    VAL_ORDO,
                                    VAL_BUD,
                                    VAL_TYP_BUD,
                                    VAL_LIG_EXEC,
                                    VAL_OPE,
									VAL_CPT_AUX)
      VALUES (v_pr_action_centra.cod_typ_regle,
            v_pr_action_centra.ide_typ_poste,
            w_var_cpta,
            v_pr_action_centra.ide_grp_action,
            v_pr_action_centra.num_lig,
            v_pr_action_centra.flg_supprime,
            v_pr_action_centra.var_cpta_contrep,
            v_pr_action_centra.ide_cpt_contrep,
            v_pr_action_centra.ide_poste_benef,
            v_pr_action_centra.flg_cumul,
            v_pr_action_centra.ide_jal,
            v_pr_action_centra.ide_schema,
            v_pr_action_centra.ide_modele_lig,
            v_pr_action_centra.ide_cpt,
            v_pr_action_centra.val_sens,
            v_pr_action_centra.val_mt,
            v_pr_action_centra.val_var_tiers,
            v_pr_action_centra.val_tiers,
            v_pr_action_centra.val_ref_piece,
            v_pr_action_centra.val_spec1,v_pr_action_centra.val_spec2,v_pr_action_centra.val_spec3,
            v_pr_action_centra.val_ordo,
            v_pr_action_centra.val_bud,
            v_pr_action_centra.val_typ_bud,
            v_pr_action_centra.val_lig_exec,
            v_pr_action_centra.val_ope,
			v_pr_action_centra.val_cpt_aux);
      /* incrementation du nombre d'enreg en dupliques */
      w_nb_lig_dup := w_nb_lig_dup + 1;
    EXCEPTION
      WHEN no_parent THEN
        /* insertion de l'erreur dans FM_ERREUR */
        GES_no_parent(v_pr_action_centra.cod_typ_regle,
                      v_pr_action_centra.ide_typ_poste,
                      v_pr_action_centra.ide_grp_action,
                      v_pr_action_centra.num_lig);
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
      WHEN OTHERS THEN
        /* insertion de l'erreur dans FM_ERREUR */
        MAJ_FM_ERREUR(15,RPAD(v_pr_action_centra.cod_typ_regle,cst_Taille_cod_typ_regle)||
                         RPAD(v_pr_action_centra.ide_typ_poste,cst_Taille_ide_typ_poste)||
                         RPAD(w_var_cpta,cst_Taille_var_cpta)||
                         RPAD(to_char(v_pr_action_centra.ide_grp_action),cst_Taille_ide_grp_action)||
                         RPAD(to_char(v_pr_action_centra.num_lig),cst_Taille_num_ligne),105,'+@+'||sqlerrm||'+@++@++@+');
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
    END;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    w_ret := -1;
END;

/* ***************************************************************************************** */
/* Procedure de recopie des criteres de centralisation ou de transfert */
/* ***************************************************************************************** */
PROCEDURE MAJ_PR_CRITERE_CENTRA ( w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_nb_lig_dup OUT NUMBER,
                         w_nb_lig_ano OUT NUMBER,
                         w_ret OUT NUMBER) IS

  CURSOR c_pr_critere_centra IS
  SELECT
  COD_TYP_REGLE,
  IDE_TYP_POSTE,
  VAR_CPTA,
  IDE_CPT,
  COD_SENS,
  IDE_CRITERE,
  FLG_SUPPRIME,
  IDE_GRP_ACTION,
  NUM_ORDRE,
  CND_ECR_ANNULATION,
  CND_ECR_ANNULE,
  CND_CUMULE,
  CND_SIGNE,
  CND_TYP_BUD,
  CND_COD_JAL,
  CND_COD_SCHEMA,
  CND_MODELE_LIG,
  CND_VAR_TIERS,
  CND_COD_TIERS,
  CND_REF_PIECE,
  CND_SPEC1,
  CND_SPEC2,
  CND_SPEC3,
  CND_ORDO,
  CND_BUD,
  CND_LIG_EXEC,
  CND_OPE,
  CND_REP_SOLDE,
  CND_CPT_AUX,
  COD_PERT
  FROM PR_CRITERE_CENTRA
  WHERE var_cpta = w_var_cpta_orig
  AND flg_supprime = v_cod_non;

  PROCEDURE GES_no_parent(w_cod_typ_regle IN PR_CRITERE_CENTRA.cod_typ_regle%TYPE,
    	                    w_ide_typ_poste IN PR_CRITERE_CENTRA.ide_typ_poste%TYPE,
    	                    w_ide_cpt IN PR_CRITERE_CENTRA.ide_cpt%TYPE,
    	                    w_cod_sens IN PR_CRITERE_CENTRA.cod_sens%TYPE,
    	                    w_ide_critere IN PR_CRITERE_CENTRA.ide_critere%TYPE,
    	                    w_ide_grp_action IN PR_CRITERE_CENTRA.ide_grp_action%TYPE) IS
    v_res CHAR(1) := '';
    ano_traitee EXCEPTION;
  BEGIN
    BEGIN
      /* contrainte sur le compte */
      SELECT 'X' INTO v_res
      FROM FN_COMPTE
      WHERE var_cpta = w_var_cpta
      AND ide_cpt = w_ide_cpt;
    EXCEPTION
      WHEN no_data_found THEN
        MAJ_FM_ERREUR(16,RPAD(w_cod_typ_regle,cst_Taille_cod_typ_regle)||
                        RPAD(w_ide_typ_poste,cst_Taille_ide_typ_poste)||
                        RPAD(w_var_cpta,cst_Taille_var_cpta)||
                        RPAD(w_ide_cpt,cst_Taille_ide_cpt)||
                        RPAD(w_cod_sens,cst_Taille_cod_sens)||
                        RPAD(to_char(w_ide_critere),cst_Taille_ide_critere),
                        694,
                        '+@+'||w_ide_cpt||'+@+'||w_var_cpta||'+@++@+');
        RAISE ano_traitee;
    END;
    BEGIN
      /* contrainte sur le groupe d'action */
      SELECT 'X' INTO v_res
      FROM PR_GROUPE_ACTION
      WHERE cod_typ_regle = w_cod_typ_regle
      AND ide_typ_poste = w_ide_typ_poste
      AND var_cpta = w_var_cpta
      AND ide_grp_action = w_ide_grp_action;
    EXCEPTION
      WHEN no_data_found THEN
        MAJ_FM_ERREUR(16,RPAD(w_cod_typ_regle,cst_Taille_cod_typ_regle)||
    	                  RPAD(w_ide_typ_poste,cst_Taille_ide_typ_poste)||
    	                  RPAD(w_var_cpta,cst_Taille_var_cpta)||
    	                  RPAD(w_ide_cpt,cst_Taille_ide_cpt)||
    	                  RPAD(w_cod_sens,cst_Taille_cod_sens)||
    	                  RPAD(to_char(w_ide_critere),cst_Taille_ide_critere),
    	                  697,
    	                  '+@+'||to_char(w_ide_critere)||'+@++@++@+');
      RAISE ano_traitee;
    END;
    /* autre contrainte */
    MAJ_FM_ERREUR(16,RPAD(w_cod_typ_regle,cst_Taille_cod_typ_regle)||
                     RPAD(w_ide_typ_poste,cst_Taille_ide_typ_poste)||
                     RPAD(w_var_cpta,cst_Taille_var_cpta)||
                     RPAD(w_ide_cpt,cst_Taille_ide_cpt)||
                     RPAD(w_cod_sens,cst_Taille_cod_sens)||
                     RPAD(to_char(w_ide_critere),cst_Taille_ide_critere),
                     690,
                     '+@++@++@++@+');
  EXCEPTION
    WHEN ano_traitee THEN
      null;
  END;

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  FOR v_pr_critere_centra IN c_pr_critere_centra LOOP

    DECLARE
      no_parent EXCEPTION;
      PRAGMA EXCEPTION_INIT(no_parent,-02291);
    BEGIN
      INSERT INTO PR_CRITERE_CENTRA (COD_TYP_REGLE,
    	                               IDE_TYP_POSTE,
    	                               VAR_CPTA,
    	                               IDE_CPT,
    	                               COD_SENS,
    	                               IDE_CRITERE,
    	                               FLG_SUPPRIME,
    	                               IDE_GRP_ACTION,
    	                               NUM_ORDRE,
    	                               CND_ECR_ANNULATION,
    	                               CND_ECR_ANNULE,
    	                               CND_CUMULE,
    	                               CND_SIGNE,
    	                               CND_TYP_BUD,
    	                               CND_COD_JAL,
    	                               CND_COD_SCHEMA,
    	                               CND_MODELE_LIG,
    	                               CND_VAR_TIERS,
    	                               CND_COD_TIERS,
    	                               CND_REF_PIECE,
    	                               CND_SPEC1,CND_SPEC2,CND_SPEC3,
    	                               CND_ORDO,
    	                               CND_BUD,
    	                               CND_LIG_EXEC,
    	                               CND_OPE,
    	                               CND_REP_SOLDE,
									   CND_CPT_AUX,
  									   COD_PERT )
      VALUES (v_pr_critere_centra.cod_typ_regle,
              v_pr_critere_centra.ide_typ_poste,
              w_var_cpta,
              v_pr_critere_centra.ide_cpt,
              v_pr_critere_centra.cod_sens,
              v_pr_critere_centra.ide_critere,
              v_pr_critere_centra.flg_supprime,
              v_pr_critere_centra.ide_grp_action,
              v_pr_critere_centra.num_ordre,
              v_pr_critere_centra.cnd_ecr_annulation,
              v_pr_critere_centra.cnd_ecr_annule,
              v_pr_critere_centra.cnd_cumule,
              v_pr_critere_centra.cnd_signe,
              v_pr_critere_centra.cnd_typ_bud,
              v_pr_critere_centra.cnd_cod_jal,
              v_pr_critere_centra.cnd_cod_schema,
              v_pr_critere_centra.cnd_modele_lig,
              v_pr_critere_centra.cnd_var_tiers,
              v_pr_critere_centra.cnd_cod_tiers,
              v_pr_critere_centra.cnd_ref_piece,
              v_pr_critere_centra.cnd_spec1,v_pr_critere_centra.cnd_spec2,v_pr_critere_centra.cnd_spec3,
              v_pr_critere_centra.cnd_ordo,
              v_pr_critere_centra.cnd_bud,
              v_pr_critere_centra.cnd_lig_exec,
              v_pr_critere_centra.cnd_ope,
              v_pr_critere_centra.cnd_rep_solde,
			  v_pr_critere_centra.cnd_cpt_aux,
              v_pr_critere_centra.cod_pert);
      /* incrementation du nombre d'enreg en dupliques */
      w_nb_lig_dup := w_nb_lig_dup + 1;
    EXCEPTION
      WHEN no_parent THEN
        /* insertion de l'erreur dans FM_ERREUR */
        GES_no_parent(v_pr_critere_centra.cod_typ_regle,
                      v_pr_critere_centra.ide_typ_poste,
                      v_pr_critere_centra.ide_cpt,
                      v_pr_critere_centra.cod_sens,
                      v_pr_critere_centra.ide_critere,
                      v_pr_critere_centra.ide_grp_action);
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
      WHEN OTHERS THEN
        /* insertion de l'erreur dans FM_ERREUR */
        MAJ_FM_ERREUR(16,RPAD(v_pr_critere_centra.cod_typ_regle,cst_Taille_cod_typ_regle)||
                         RPAD(v_pr_critere_centra.ide_typ_poste,cst_Taille_ide_typ_poste)||
                         RPAD(w_var_cpta,cst_Taille_var_cpta)||
                         RPAD(v_pr_critere_centra.ide_cpt,cst_Taille_ide_cpt)||
                         RPAD(v_pr_critere_centra.cod_sens,cst_Taille_cod_sens)||
                         RPAD(to_char(v_pr_critere_centra.ide_critere),cst_Taille_ide_critere),105,'+@+'||sqlerrm||'+@++@++@+');
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
    END;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    w_ret := -1;
END;


/* ***************************************************************************************** */
/* procedure de recopie de SR_CPT_TRT */
/* ***************************************************************************************** */
PROCEDURE MAJ_SR_CPT_TRT ( w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_nb_lig_dup OUT NUMBER,
                         w_nb_lig_ano OUT NUMBER,
                         w_ret OUT NUMBER) IS
  CURSOR c_sr_cpt_trt IS
  SELECT
  COD_TRAITEMENT,
  IDE_TYP_POSTE,
  VAR_CPTA,
  IDE_JAL,
  IDE_SCHEMA,
  IDE_MODELE_LIG_GEN,
  IDE_MODELE_LIG_CNT,
  IDE_CPT_CNT
  FROM SR_CPT_TRT
  WHERE var_cpta = w_var_cpta_orig;

  PROCEDURE GES_no_parent(w_cod_traitement IN SR_CPT_TRT.cod_traitement%TYPE,
    	                    w_ide_typ_poste IN SR_CPT_TRT.ide_typ_poste%TYPE,
    	                    w_ide_jal IN SR_CPT_TRT.ide_jal%TYPE,
    	                    w_ide_schema IN SR_CPT_TRT.ide_schema%TYPE,
    	                    w_ide_modele_lig_gen IN SR_CPT_TRT.ide_modele_lig_gen%TYPE,
    	                    w_ide_modele_lig_cnt IN SR_CPT_TRT.ide_modele_lig_cnt%TYPE,
                            w_ide_cpt IN FN_COMPTE.ide_cpt%TYPE) IS
    v_ide_modele_lig RC_MODELE_LIGNE.ide_modele_lig%TYPE := null;
    v_flg_m1 NUMBER := 0;
    v_flg_m2 NUMBER := 0;
    v_res CHAR(1);
    CURSOR c_modele IS
    SELECT ide_modele_lig
    FROM RC_MODELE_LIGNE
    WHERE var_cpta = w_var_cpta
    AND ide_jal = w_ide_jal
    AND ide_schema = w_ide_schema
    AND ide_modele_lig IN (w_ide_modele_lig_gen,w_ide_modele_lig_gen)
    AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
    AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008
    ano_traitee EXCEPTION;
  BEGIN
    IF w_ide_cpt IS NOT NULL THEN
      SELECT 'X' INTO v_res FROM FN_COMPTE
      WHERE var_cpta = w_var_cpta
      AND ide_cpt = w_ide_cpt;
    END IF;
    FOR v_ide_modele_lig IN c_modele LOOP
      IF v_ide_modele_lig.ide_modele_lig = w_ide_modele_lig_gen THEN
        v_flg_m1 := 1;
      ELSIF v_ide_modele_lig.ide_modele_lig = w_ide_modele_lig_cnt AND w_ide_modele_lig_cnt IS NOT NULL THEN
        v_flg_m2 := 1;
      END IF;
    END LOOP;
    IF v_flg_m1 = 0 THEN
      /* on n'a pas trouve le modele w_ide_modele_lig_gen */
      MAJ_FM_ERREUR(17,RPAD(w_cod_traitement,cst_Taille_cod_traitement)||
                       RPAD(w_ide_typ_poste,cst_Taille_ide_typ_poste)||
                       RPAD(w_var_cpta,cst_Taille_var_cpta),
                       698,'+@+'||w_ide_modele_lig_gen||'+@+'||w_var_cpta||'+@++@+');
    END IF;
    IF v_flg_m2 = 0 AND w_ide_modele_lig_cnt IS NOT NULL THEN
      /* on n'a pas trouve le modele w_ide_modele_lig_cnt */
      MAJ_FM_ERREUR(17,RPAD(w_cod_traitement,cst_Taille_cod_traitement)||
                       RPAD(w_ide_typ_poste,cst_Taille_ide_typ_poste)||
                       RPAD(w_var_cpta,cst_Taille_var_cpta),
                       698,'+@+'||w_ide_modele_lig_cnt||'+@+'||w_var_cpta||'+@++@+');
    END IF;
    IF v_flg_m1 = 1 AND v_flg_m2 = 1 THEN
      /* il s'agit d'une autre contraite */
      MAJ_FM_ERREUR(17,RPAD(w_cod_traitement,cst_Taille_cod_traitement)||
                       RPAD(w_ide_typ_poste,cst_Taille_ide_typ_poste)||
                       RPAD(w_var_cpta,cst_Taille_var_cpta),
                       690,'+@++@++@++@+');
    END IF;
  EXCEPTION
    WHEN No_data_found THEN
      /* Contrainte sur le compte */
      MAJ_FM_ERREUR(17,RPAD(w_cod_traitement,cst_Taille_cod_traitement)||
                       RPAD(w_ide_typ_poste,cst_Taille_ide_typ_poste)||
                       RPAD(w_var_cpta,cst_Taille_var_cpta),
                       694,'+@+'||w_ide_cpt||'+@+'||w_var_cpta||'+@++@+');
  END;

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  FOR v_sr_cpt_trt IN c_sr_cpt_trt LOOP

    DECLARE
      no_parent EXCEPTION;
      PRAGMA EXCEPTION_INIT(no_parent,-02291);
    BEGIN
      INSERT INTO SR_CPT_TRT (COD_TRAITEMENT,
                              IDE_TYP_POSTE,
                              VAR_CPTA,
                              IDE_JAL,
                              IDE_SCHEMA,
                              IDE_MODELE_LIG_GEN,
                              IDE_MODELE_LIG_CNT,
                              IDE_CPT_CNT)
      VALUES (v_sr_cpt_trt.cod_traitement,
              v_sr_cpt_trt.ide_typ_poste,
              w_var_cpta,
              v_sr_cpt_trt.ide_jal,
              v_sr_cpt_trt.ide_schema,
              v_sr_cpt_trt.ide_modele_lig_gen,
              v_sr_cpt_trt.ide_modele_lig_cnt,
              v_sr_cpt_trt.ide_cpt_cnt);
      /* incrementation du nombre d'enreg en dupliques */
      w_nb_lig_dup := w_nb_lig_dup + 1;
    EXCEPTION
      WHEN no_parent THEN
        /* insertion de l'erreur dans FM_ERREUR */
        GES_no_parent(v_sr_cpt_trt.cod_traitement,
    	                v_sr_cpt_trt.ide_typ_poste,
    	                v_sr_cpt_trt.ide_jal,
    	                v_sr_cpt_trt.ide_schema,
    	                v_sr_cpt_trt.ide_modele_lig_gen,
    	                v_sr_cpt_trt.ide_modele_lig_cnt,
                      v_sr_cpt_trt.ide_cpt_cnt);
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
      WHEN OTHERS THEN
        /* insertion de l'erreur dans FM_ERREUR */
        MAJ_FM_ERREUR(17,RPAD(v_sr_cpt_trt.cod_traitement,cst_Taille_cod_traitement)||
    	                  RPAD(v_sr_cpt_trt.ide_typ_poste,cst_Taille_ide_typ_poste)||
    	                  RPAD(w_var_cpta,cst_Taille_var_cpta),105,'+@+'||sqlerrm||'+@++@++@+');
        /* incrementation du nombre de lignes en ano */
        w_nb_lig_ano := w_nb_lig_ano +1;
    END;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    w_ret := -1;
END;


/* ***************************************************************************************** */
/* procedure de recopie de PC_PRISE_CHARGE */
/* ***************************************************************************************** */
PROCEDURE MAJ_PC_PRISE_CHARGE ( w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                         w_nb_lig_dup OUT NUMBER,
                         w_nb_lig_ano OUT NUMBER,
                         w_ret OUT NUMBER) IS

  CURSOR c_pc_prise_charge IS
  SELECT
  COD_TYP_PIECE,
  IDE_JAL,
  IDE_SCHEMA,
  IDE_TYP_POSTE,
  IDE_SS_TYPE,
  DAT_FVAL
  FROM PC_PRISE_CHARGE
  WHERE var_cpta = w_var_cpta_orig
  AND (dat_fval IS NULL OR trunc(dat_fval) > trunc(p_date_perime));

  PROCEDURE GES_no_parent(w_ide_schema IN RC_SCHEMA_CPTA.ide_schema%TYPE
                         ,w_ide_jal IN FC_JOURNAL.ide_jal%TYPE
                         ,w_cod_typ_piece IN PC_PRISE_CHARGE.cod_typ_piece%TYPE
                          ) IS
    v_res CHAR(1) := '';
    ano_traitee EXCEPTION;
  BEGIN
    MAJ_FM_ERREUR(18,RPAD(w_cod_typ_piece,cst_Taille_cod_typ_piece)||
                     RPAD(w_var_cpta,cst_Taille_var_cpta),
                     690,
                     '+@++@++@++@+');
  EXCEPTION
    WHEN ano_traitee THEN
      null;
  END;

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  FOR v_pc_prise_charge IN c_pc_prise_charge LOOP

    DECLARE
      no_parent EXCEPTION;
      PRAGMA EXCEPTION_INIT(no_parent,-02291);
    BEGIN
      INSERT INTO PC_PRISE_CHARGE (COD_TYP_PIECE,
                                   VAR_CPTA,
                                   IDE_JAL,
                                   IDE_SCHEMA,
								   IDE_TYP_POSTE,
								   IDE_SS_TYPE,
								   DAT_FVAL)
      VALUES (v_pc_prise_charge.cod_typ_piece,
              w_var_cpta,
              v_pc_prise_charge.ide_jal,
              v_pc_prise_charge.ide_schema,
			  v_pc_prise_charge.ide_typ_poste,
			  v_pc_prise_charge.ide_ss_type,
			  v_pc_prise_charge.dat_fval);
      /* incrementation du nombre d'enreg en dupliques */
      w_nb_lig_dup := w_nb_lig_dup + 1;
    EXCEPTION
      WHEN no_parent THEN
      /* insertion de l'erreur dans FM_ERREUR */
      GES_no_parent(v_pc_prise_charge.ide_schema,
                    v_pc_prise_charge.ide_jal,
                    v_pc_prise_charge.cod_typ_piece);
      /* incrementation du nombre de lignes en ano */
      w_nb_lig_ano := w_nb_lig_ano +1;
    WHEN OTHERS THEN
      /* insertion de l'erreur dans FM_ERREUR */
      MAJ_FM_ERREUR(18,RPAD(v_pc_prise_charge.cod_typ_piece,cst_Taille_cod_typ_piece)||
                       RPAD(w_var_cpta,cst_Taille_var_cpta),
                       105,'+@+'||sqlerrm||'+@++@++@+');
      /* incrementation du nombre de lignes en ano */
      w_nb_lig_ano := w_nb_lig_ano +1;
    END;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    w_ret := -1;
END;


/* ***************************************************************************************** */
/* procedure de recopie de FN_CPT_PLAN*/
/* ***************************************************************************************** */
PROCEDURE MAJ_FN_CPT_PLAN ( w_var_cpta_orig IN PN_VAR_CPTA.var_cpta%TYPE,
                          w_var_cpta IN PN_VAR_CPTA.var_cpta%TYPE,
                          w_nb_lig_dup OUT NUMBER,
                          w_nb_lig_ano OUT NUMBER,
                          w_ret OUT NUMBER) IS

  CURSOR c_fn_cpt_plan IS
  SELECT
  IDE_PLAN_AUX,
  VAR_CPTA,
  IDE_CPT,
  IDE_POSTE,
  FLG_CENTRAL,
  DAT_FVAL
  FROM FN_CPT_PLAN
  WHERE var_cpta = w_var_cpta_orig
  AND (dat_fval IS NULL OR trunc(dat_fval) > trunc(p_date_perime));

  PROCEDURE GES_no_parent(w_ide_schema IN RC_SCHEMA_CPTA.ide_schema%TYPE
                         ,w_ide_jal IN FC_JOURNAL.ide_jal%TYPE
                         ,w_cod_typ_piece IN PC_PRISE_CHARGE.cod_typ_piece%TYPE
                          ) IS
    v_res CHAR(1) := '';
    ano_traitee EXCEPTION;
  BEGIN
    MAJ_FM_ERREUR(18,RPAD(w_cod_typ_piece,cst_Taille_cod_typ_piece)||
                     RPAD(w_var_cpta,cst_Taille_var_cpta),
                     690,
                     '+@++@++@++@+');
  EXCEPTION
    WHEN ano_traitee THEN
      null;
  END;

BEGIN

  /* initialisation des variables OUT */
  w_nb_lig_ano := 0;
  w_nb_lig_dup := 0;
  w_ret := 1;

  FOR v_fn_cpt_plan IN c_fn_cpt_plan LOOP

    DECLARE
      no_parent EXCEPTION;
      PRAGMA EXCEPTION_INIT(no_parent,-02291);
    BEGIN
      INSERT INTO FN_CPT_PLAN (IDE_PLAN_AUX,
							  VAR_CPTA,
							  IDE_CPT,
							  IDE_POSTE,
							  FLG_CENTRAL,
							  DAT_FVAL)
      VALUES (v_fn_cpt_plan.IDE_PLAN_AUX,
              w_var_cpta,
              v_fn_cpt_plan.IDE_CPT,
              v_fn_cpt_plan.IDE_POSTE,
			  v_fn_cpt_plan.FLG_CENTRAL,
			  v_fn_cpt_plan.DAT_FVAL);
      /* incrementation du nombre d'enreg en dupliques */
      w_nb_lig_dup := w_nb_lig_dup + 1;
    EXCEPTION
      WHEN no_parent THEN
      /* insertion de l'erreur dans FM_ERREUR */
      GES_no_parent(v_fn_cpt_plan.IDE_PLAN_AUX,
                    v_fn_cpt_plan.IDE_CPT,
                    v_fn_cpt_plan.IDE_POSTE);
      /* incrementation du nombre de lignes en ano */
      w_nb_lig_ano := w_nb_lig_ano +1;
    WHEN OTHERS THEN
      /* insertion de l'erreur dans FM_ERREUR */
      MAJ_FM_ERREUR(18,RPAD(v_fn_cpt_plan.IDE_PLAN_AUX,v_fn_cpt_plan.IDE_CPT)||
                       RPAD(w_var_cpta,cst_Taille_var_cpta),
                       105,'+@+'||sqlerrm||'+@++@++@+');
      /* incrementation du nombre de lignes en ano */
      w_nb_lig_ano := w_nb_lig_ano +1;
    END;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    w_ret := -1;
END;


/* ***************************************************************************************** */
/* ***************************************************************************************** */
/*                                   Programme principal                                     */
/* ***************************************************************************************** */
/* ***************************************************************************************** */

BEGIN

  /* initialisations */
  p_ret := 1;
  p_nb_ligne_dup := 0;
  p_nb_ligne_ano := 0;

  EXT_Codext('OUI_NON','N',v_lib,v_cod_non,v_ret_codext);
  IF v_ret_codext < 1 THEN
    p_ret :=0;
    RAISE exit_error;
  END IF;

  trace('apres codext');

  MAJ_FN_COMPTE(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -2;
    RAISE exit_error;
  END IF;
  trace('apres fn_compte '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_FC_JOURNAL(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -3;
    RAISE exit_error;
  END IF;
  trace('apres fc_journal '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_RC_LISTE_COMPTE(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -4;
    RAISE exit_error;
  END IF;
  trace('apres rc_liste_compte '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_RC_SPEC(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -5;
    RAISE exit_error;
  END IF;
  trace('apres rc_spec '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_RC_DROIT_JOURNAL(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -6;
    RAISE exit_error;
  END IF;
  trace('apres rc_droit_journal '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_RC_DROIT_COMPTE(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -7;
    RAISE exit_error;
  END IF;
  trace('apres rc_droit_compte '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_RC_SCHEMA_CPTA(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -8;
    RAISE exit_error;
  END IF;
  trace('apres rc_schema_cpta '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_RC_MODELE_LIGNE(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -9;
    RAISE exit_error;
  END IF;
  trace('apres rc_modele_ligne '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_PR_GROUPE_ACTION(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -10;
    RAISE exit_error;
  END IF;
  trace('apres pr_groupe_action '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_PR_ACTION_CENTRA(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -11;
    RAISE exit_error;
  END IF;
  trace('apres pr_action_centra '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_PR_CRITERE_CENTRA(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -12;
    RAISE exit_error;
  END IF;
  trace('apres pr_critere_centra '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_SR_CPT_TRT(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -13;
    RAISE exit_error;
  END IF;
  trace('apres sr_cpt_trt '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  MAJ_PC_PRISE_CHARGE(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -14;
    RAISE exit_error;
  END IF;
  trace('apres pc_prise_charge '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  -- DEBUT -- FBT -- 18/04/2007 -- Evolution DI44-CC-2007-04--------------------------

  MAJ_FN_CPT_PLAN(p_var_cpta_orig,p_var_cpta,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret = -1 THEN
    p_ret := -14;
    RAISE exit_error;
  END IF;
  trace('apres fn_cpt_plan '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  p_nb_ligne_ano := p_nb_ligne_ano + v_nb_ligne_ano;

  -- PGE ANO 383 V4281 Gestion de  dat_fval -- DUPLIQUER_DATA(p_var_cpta_orig,p_var_cpta,'PC_PEC_REGLEMENT',NULL,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  DUPLIQUER_DATA(p_var_cpta_orig,p_var_cpta,'PC_PEC_REGLEMENT',p_date_perime,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret <> 0 THEN
    p_ret := -16;
    RAISE exit_error;
  END IF;
  SELECT count(*) INTO v_nb_ligne_dup
  FROM PC_PEC_REGLEMENT
  WHERE var_cpta=p_var_cpta;
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  trace('apres pc_pec_reglement '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);

  DUPLIQUER_DATA(p_var_cpta_orig,p_var_cpta,'PC_PEC_ECART_CHANGE',NULL,v_nb_ligne_dup,v_nb_ligne_ano,v_ret);
  IF v_ret <> 0 THEN
    p_ret := -17;
    RAISE exit_error;
  END IF;
  SELECT count(*) INTO v_nb_ligne_dup
  FROM PC_PEC_ECART_CHANGE
  WHERE var_cpta=p_var_cpta;
  p_nb_ligne_dup := p_nb_ligne_dup + v_nb_ligne_dup;
  trace('apres pc_pec_ecart_change '||v_nb_ligne_dup||'*'||v_nb_ligne_ano);

  -- FIN -- FBT -- 18/04/2007 -- Evolution DI44-CC-2007-04--------------------------

  /* validation */
  COMMIT;

EXCEPTION
  WHEN EXIT_ERROR THEN
    ROLLBACK;
    p_nb_ligne_dup := 0;
    p_nb_ligne_ano := 0;
  WHEN OTHERS THEN
    ROLLBACK;
    p_ret := -1;
    p_nb_ligne_dup := 0;
    p_nb_ligne_ano := 0;

END MAJ_DUP_NOMEN_CPTA;

/

CREATE OR REPLACE procedure MAJ_ins_ecriture(
                                   P_cod_typ_piece IN FC_ECRITURE.cod_typ_piece%TYPE,
								   -- Modif MYI : fonction 11
								   P_ide_ss_type   IN FB_PIECE.IDE_SS_TYPE%TYPE,
								   P_ide_typ_poste IN RM_POSTE.IDE_TYP_POSTE%TYPE,
								   -- Fin Modif MYI
                                   P_ide_poste IN FC_ECRITURE.ide_poste%TYPE,
                                   P_ide_piece IN FB_PIECE.ide_piece%TYPE,
                                   P_ide_gest IN FC_ECRITURE.ide_gest%TYPE,
                                   P_ide_ordo IN FB_PIECE.ide_ordo%TYPE,
                                   P_cod_bud IN FB_PIECE.cod_bud%TYPE,
                                   P_var_cpta IN FC_ECRITURE.var_cpta%TYPE,
                                   P_dat_jc IN DATE,
                                   P_objet IN FB_PIECE.objet%TYPE,
                                   P_dat_cad IN FC_ECRITURE.dat_saisie%TYPE,
                                   P_ret OUT NUMBER,
                                   P_ide_ecr OUT FC_ECRITURE.ide_ecr%TYPE,
                                   P_ide_jal OUT FC_ECRITURE.ide_jal%TYPE,
                                   P_dat_ecr OUT FC_ECRITURE.dat_ecr%TYPE )
IS

/*
-- ----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : CAD
-- Nom           : MAJ_ins_Ecriture
-- ---------------------------------------------------------------------------
--  Auteur         : V COUNORD (SEMA GROUP)
--  Date creation  : 13/12/1999
-- ---------------------------------------------------------------------------
-- Role          : Génération d'une écriture de prise en charge
--
-- Parametres    :

-- Valeurs retournees :
--                     1- P_ret :
--					   2- P_ide_ecr :
--					   3- P_ide_jal :
--					   4- P_dat_ecr :
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) MAJ_ins_ecriture.sql version 1.0-1.0
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) MAJ_ins_ecriture.sql   1.0-1.0	|3/12/1999 |V COUNORD| création
-- @(#) MAJ_ins_ecriture.sql  3.0-2.0	|04/04/2002 |MYI| Fonction 11 : Paramétrage des sous-types de pièce budgétaire
-- @(#) MAJ_ins_ecriture.sql  V4240		|07/01/2008 |FBT| Correction de l'ano 181
--------------------------------------------------------------------------------
*/


   p_libl            	  SR_CODIF.libl%TYPE;
   v_retour 		  number := 0;
   p_retour 		  number := 0;
   v_uti_cre              FC_ECRITURE.uti_cre%TYPE := GLOBAL.cod_util;
   v_dat_cre              FC_ECRITURE.dat_cre%TYPE := sysdate;
   v_uti_maj              FC_ECRITURE.uti_maj%TYPE := GLOBAL.cod_util;
   v_dat_maj              FC_ECRITURE.dat_maj%TYPE := sysdate;
   v_terminal             FC_ECRITURE.terminal%TYPE := GLOBAL.terminal;
   v_ide_schema           FC_ECRITURE.ide_schema%TYPE;
   v_dat_fval             FC_ECRITURE.dat_ecr%TYPE;
   v_dat_dval             FC_ECRITURE.dat_ecr%TYPE;
   v_flg_cptab            FC_ECRITURE.flg_cptab%TYPE;
   v_cod_statut           FC_ECRITURE.cod_statut%TYPE;
   v_flg_ecr_somme        FC_ECRITURE.flg_ecr_somme%TYPE;

   ext_codext_error        EXCEPTION;

BEGIN
   -- Modif MYI Le 04/04/2002 : Ajout de ide_ss_type et ide_typ_poste à la clause WHERE
   SELECT ide_jal, ide_schema
   INTO P_ide_jal, v_ide_schema
   FROM pc_prise_charge
   WHERE cod_typ_piece = P_cod_typ_piece
   AND var_cpta        = P_var_cpta
   AND ide_ss_type     = P_ide_ss_type
   AND ide_typ_poste   = P_ide_typ_poste;
   -- Fin Modif MYI
   SELECT dat_fval, dat_dval
   INTO v_dat_fval, v_dat_dval
   FROM fn_gestion
   WHERE ide_gest = P_ide_gest;

   /* VLA : 07/09/2000 : prise en compte de la question 151 */
   IF TRUNC(P_dat_jc) > TRUNC(v_dat_fval) THEN
      P_dat_ecr := v_dat_fval;
   ELSIF TRUNC(P_dat_jc) < TRUNC(v_dat_dval) THEN
      P_dat_ecr := v_dat_dval + 1;
   ELSE
      P_dat_ecr := P_dat_jc;
   END IF;


   EXT_CODEXT('OUI_NON', 'O', p_libl, v_flg_cptab, p_retour);
   IF p_retour != 1 THEN
      RAISE ext_codext_error;
   END IF;

   EXT_CODEXT('STATUT_ECR', 'V', p_libl, v_cod_statut, p_retour);
   IF p_retour != 1 THEN
      RAISE ext_codext_error;
   END IF;

   -- DEBUT - FBT le 07/01/2008 - ANO181
   /*EXT_CODEXT('OUI_NON', 'N', p_libl, v_flg_ecr_somme, p_retour);
   IF p_retour != 1 THEN
      RAISE ext_codext_error;
   END IF;*/

   v_flg_ecr_somme := NULL;

   -- FIN  - FBT le 07/01/2008 - ANO181



   SELECT NVL(MAX(A.ide_ecr),0)+1 INTO P_ide_ecr
   FROM fc_ecriture A
   WHERE A.ide_poste = P_ide_poste
   AND A.ide_gest = P_ide_gest
   AND A.ide_jal = P_ide_jal
   AND A.flg_cptab = v_flg_cptab;


   INSERT INTO fc_ecriture ( ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr, dat_jc
   , var_cpta, ide_schema, libn, dat_saisie, dat_ecr, cod_statut, flg_ecr_somme
   , cod_bud, ide_ordo, ide_piece, cod_typ_piece, dat_cre, uti_cre, dat_maj
   , uti_maj, terminal )
   VALUES ( P_ide_poste, P_ide_gest, P_ide_jal, v_flg_cptab, P_ide_ecr, P_dat_jc,
   P_var_cpta, v_ide_schema, SUBSTR(P_objet,1,45), P_dat_cad, P_dat_ecr, v_cod_statut,
   v_flg_ecr_somme, P_cod_bud, P_ide_ordo, P_ide_piece, P_cod_typ_piece,
   v_dat_cre, v_uti_cre, v_dat_maj, v_uti_maj, v_terminal );

   p_ret := 1;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      P_ret := 0;
   WHEN ext_codext_error THEN
      P_ret := 0;
   WHEN OTHERS THEN
      P_ret := -1;
END MAJ_ins_ecriture;

/

CREATE OR REPLACE PROCEDURE MAJ_ins_reglement(
                                   p_ide_poste IN FC_REGLEMENT.ide_poste%TYPE,
								   p_ide_gest  IN FC_REGLEMENT.ide_gest%TYPE,
								   p_cod_typ_nd IN FC_REGLEMENT.COD_TYP_ND%TYPE,
								   p_ide_nd_emet IN FC_REGLEMENT.ide_nd_emet%TYPE,
								   p_ide_mess  IN FC_REGLEMENT.ide_mess%TYPE,
								   p_flg_emis_recu IN FC_REGLEMENT.flg_emis_recu%TYPE,
								   p_ide_mod_reglt IN FC_REGLEMENT.ide_mod_reglt%TYPE,
                                   p_cod_bud IN FC_REGLEMENT.cod_bud%TYPE,
                                   p_ide_ordo IN FC_REGLEMENT.ide_ordo%TYPE,
--CBI-20050811-D - FA0043
--                                   p_ide_piece IN FC_REGLEMENT.ide_piece%TYPE,
                                   p_cod_ref_piece IN FC_REGLEMENT.cod_ref_piece%TYPE,
--CBI-20050811-F - FA0043

                                   p_var_tiers IN FC_REGLEMENT.var_tiers%TYPE,
                                   p_ide_tiers IN FC_REGLEMENT.ide_tiers%TYPE,
								   p_var_tiers_regl IN FC_REGLEMENT.var_tiers_regl%TYPE,
                                   p_ide_tiers_regl IN FC_REGLEMENT.ide_tiers_regl%TYPE,
								   p_nom_bq    IN FC_REGLEMENT.NOM_BQ%TYPE,
								   p_cpt_bq    IN FC_REGLEMENT.CPT_BQ%TYPE,
								   p_mt  IN  FC_REGLEMENT.mt%TYPE,
								   p_ide_devise IN FC_REGLEMENT.ide_devise%TYPE,
								   p_mt_dev IN FC_REGLEMENT.mt_dev%TYPE,
  								   p_dat_reference IN FC_REGLEMENT.dat_reference%TYPE,
								   p_ide_jal IN FC_REGLEMENT.ide_jal%TYPE,
								   p_ide_ecr IN FC_REGLEMENT.ide_ecr%TYPE,
								   p_dat_jc IN FC_ECRITURE.dat_jc%TYPE,
--CBI-20050331-D - LOLF
								   p_ide_cpt IN FC_REGLEMENT.ide_cpt%TYPE,
								   p_spec1 IN FC_REGLEMENT.spec1%TYPE,
								   p_lib_objet_piece IN FC_REGLEMENT.lib_objet_reglt%TYPE,
--CBI-20050331-F - LOLF
--CBI-20050811-D - FA0043
								   p_ide_plan_aux IN FC_REGLEMENT.ide_plan_aux%TYPE,
								   p_ide_cpt_aux IN FC_REGLEMENT.ide_cpt_aux%TYPE,
--CBI-20050811-F - FA0043
                                   p_ide_reglt OUT FC_REGLEMENT.ide_reglt%TYPE,
                                   p_ret OUT NUMBER)
IS

/*
-- ----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : Reglement
-- Nom           : MAJ_ins_reglement
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 01/07/2002
-- ---------------------------------------------------------------------------
-- Role          : Génération du reglement
--
-- Parametres    : Entree :
-- 				 1 - p_ide_poste 		  :
-- 				 2 - p_ide_gest			  :
-- 				 3 - p_cod_typ_nd		  :
-- 				 4 - p_ide_nd_emet		  :
-- 				 5 - p_ide_mess			  :
-- 				 6 - p_flg_emis_recu	  :
-- 				 7 - p_ide_mod_reglt	  :
-- 				 8 - p_cod_bud			  :
-- 				 9 - p_ide_ordo			  :
-- 				10 - p_ide_piece		  :
-- 				11 - p_var_tiers		  :
-- 				12 - p_ide_tiers		  :
-- 				13 - p_var_tiers_regl	  :
-- 				14 - p_ide_tiers_regl	  :
-- 				15 - p_nom_bq			  :
-- 				16 - p_cpt_bq			  :
-- 				17 - p_mt				  :
-- 				18 - p_ide_devise		  :
-- 				19 - p_mt_dev			  :
-- 				20 - p_dat_reference	  :
-- 				21 - p_ide_jal			  :
-- 				22 - p_ide_ecr			  :
-- 				23 - p_dat_jc			  :
--                              24 - p_lib_objet_piece            :
--                              25 - p_ide_cpt                    :
--                              26 - p_spec1                      :
--                              27 - p_lib_objet_piece            :
--                              28 - p_ide_plan_aux               :
--                              29 - p_ide_cpt_aux               :
--
--
--                 Sortie : p_ide_reglt : identifiant du reglement cree
--                          p_ret : retour de la fonction
--                                 1 : Traitement OK
--                                -1 : Probleme de recuperation du code externe
--                                -2 : Probleme lors de la recuperation du param des mode de reglt
-- Valeurs retournees :
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) MAJ_ins_reglement.sql version 3.0-1.0
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) MAJ_ins_reglement.sql   3.0-1.0	|01/07/2002 |SGN| création
-- @(#) MAJ_ins_reglement.sql   3.5-1.1	|31/03/2005 |CBI| Ajout de 3 nouveaux paramètres qui alimentent FC_REGLEMENT
-- @(#) MAJ_ins_reglement.sql   3.5A-1.2|11/08/2005 |CBI| FA0043
--                                                        Ajout de 2 nouveaux paramètres en entrée pour IDE8pLAN_AUX et IDE_CPT_AUX
--                                                        Rrmplacement de ide_piece par cod_ref_piece dans FC_REGLEMENT
--------------------------------------------------------------------------------
*/


   v_libl            	  SR_CODIF.libl%TYPE;
   v_ret 		  	      NUMBER := 0;
   v_uti_cre              FC_REGLEMENT.uti_cre%TYPE := GLOBAL.cod_util;
   v_dat_cre              FC_REGLEMENT.dat_cre%TYPE := sysdate;
   v_uti_maj              FC_REGLEMENT.uti_maj%TYPE := GLOBAL.cod_util;
   v_dat_maj              FC_REGLEMENT.dat_maj%TYPE := sysdate;
   v_terminal             FC_REGLEMENT.terminal%TYPE := GLOBAL.terminal;

   v_cod_etat_reglt_V     SR_CODIF.cod_codif%TYPE;
   v_flg_cptab_O          SR_CODIF.cod_codif%TYPE;
   v_cod_orig_reglt_O     SR_CODIF.cod_codif%TYPE;

   v_dat_ech 			  FC_REGLEMENT.dat_echeance%TYPE;
   v_num_reglt            FC_HISTO_REGLT.num_reglt%TYPE;

   EXT_CODEXT_ERROR       EXCEPTION;
   EXT_MODREG_ERROR       EXCEPTION;

BEGIN

   -- Le retour est initialise a OK
   p_ret := 1;

   -- Recuperation de la valeur (cod externe) des codifications
   EXT_CODEXT('OUI_NON', 'O', v_libl, v_flg_cptab_O, v_ret);
   IF v_ret != 1 THEN
      RAISE EXT_CODEXT_ERROR;
   END IF;

   EXT_CODEXT('ETAT_REGLT', 'V', v_libl, v_cod_etat_reglt_V, v_ret);
   IF v_ret != 1 THEN
      RAISE EXT_CODEXT_ERROR;
   END IF;

   EXT_CODEXT('ORIG_REGLT', 'O', v_libl, v_cod_orig_reglt_O, v_ret);
   IF v_ret != 1 THEN
      RAISE EXT_CODEXT_ERROR;
   END IF;


   -- Calcule de l'ide reglement (max + 1)
   BEGIN
   		SELECT NVL(MAX(A.ide_reglt),0)+1
   		INTO p_ide_reglt
   		FROM fc_reglement A
   		WHERE A.ide_poste = p_ide_poste
		  AND A.ide_gest = p_ide_gest;
   EXCEPTION
   		WHEN NO_DATA_FOUND THEN
			 p_ide_reglt := 1;
		WHEN OTHERS THEN
			 RAISE;
   END;

   -- Calcul de la date d echeance du reglement
   BEGIN
   		v_ret := CAL_DAT_ECH_REGLT(p_dat_reference, p_ide_mod_reglt, v_dat_ech);

		IF v_ret = -1 THEN
		   RAISE EXT_MODREG_ERROR;
		ELSIF v_ret = -2 THEN
		   RAISE EXT_CODEXT_ERROR;
		END IF;
   EXCEPTION
   		WHEN OTHERS THEN
			 RAISE;
   END;

   -- Insertion dans FC_REGLEMENT
   INSERT INTO fc_reglement
   ( ide_poste,
     ide_gest,
	 ide_reglt,
	 ide_lot,
	 cod_typ_nd,
	 ide_nd_emet,
	 ide_mess,
	 flg_emis_recu,
	 ide_mod_reglt,
	 ide_remise,
	 cod_orig_reglt,
	 cod_bud,
	 ide_ordo,
--CBI-20050811-D - FA0043
--	 ide_piece,
         cod_ref_piece,
--CBI-20050811-F - FA0043
	 var_tiers,
	 ide_tiers,
	 var_tiers_regl,
	 ide_tiers_regl,
	 nom_bq,
	 cpt_bq,
	 mt,
	 ide_devise,
	 mt_dev,
	 dat_reference,
	 dat_echeance,
	 cod_etat_reglt,
	 dat_remise,
	 ide_jal,
	 flg_cptab,
	 ide_ecr,
	 motif_inc,
	 dat_cre,
	 uti_cre,
	 dat_maj,
	 uti_maj,
	 terminal,
-- CBI-20050331-D - LOLF
         ide_cpt,
         spec1,
         lib_objet_reglt
-- CBI-20050331-F - LOLF
-- CBI-20050811-D - FA0043
         ,ide_plan_aux,
         ide_cpt_aux
-- CBI-20050811-F - FA0043
	)VALUES(
     p_ide_poste,
     p_ide_gest,
	 p_ide_reglt,
	 null, --ide_lot,
	 p_cod_typ_nd,
	 p_ide_nd_emet,
	 p_ide_mess,
	 p_flg_emis_recu,
	 p_ide_mod_reglt,
	 null, -- ide_remise
	 v_cod_orig_reglt_O,
	 p_cod_bud,
	 p_ide_ordo,
--CBI-20050811-D - FA0043
--	 p_ide_piece,
         p_cod_ref_piece,
--CBI-20050811-F - FA0043
	 p_var_tiers,
	 p_ide_tiers,
	 p_var_tiers_regl,
	 p_ide_tiers_regl,
	 p_nom_bq,
	 p_cpt_bq,
	 p_mt,
	 p_ide_devise,
	 p_mt_dev,
	 p_dat_reference,
	 v_dat_ech,
	 v_cod_etat_reglt_V,
	 null, --dat_remise,
	 p_ide_jal,
	 --v_flg_cptab_O,  -- Mise en commentaire par M'BOUKE: 
	 null,
	 p_ide_ecr,
	 null, --motif_inc,
	 v_dat_cre,
	 v_uti_cre,
	 v_dat_maj,
	 v_uti_maj,
	 v_terminal,
-- CBI-20050331-D - LOLF
         p_ide_cpt,
         p_spec1,
         p_lib_objet_piece
-- CBI-20050331-F - LOLF
-- CBI-20050811-D - FA0043
         ,p_ide_plan_aux,
         p_ide_cpt_aux
-- CBI-20050811-F - FA0043
	);

   -- Recuperation du dernier num_reglt dans histo
   SELECT NVL(max(num_reglt),0)
   INTO v_num_reglt
   FROM Fc_HISTO_REGLT
   WHERE ide_poste = p_ide_poste
	 AND ide_gest = p_ide_gest
	 AND ide_reglt = p_ide_reglt;

   -- Mise a jour de la dat_evt avec le parametre DAT_JC. on est obliger de faire
   -- comme ca car dat_jc n est pas present dans le trigger de FC_REGLEMENT qui aliment histo_reglt
   -- et parceque l or doit alimenter dat_evt avec la dat_jc lorsque le reglement est genere
   -- lors du visa d une ordonnance
   UPDATE FC_HISTO_REGLT
   SET dat_evt = p_dat_jc
   WHERE ide_poste = p_ide_poste
	 AND ide_gest = p_ide_gest
	 AND ide_reglt = p_ide_reglt
	 AND num_reglt = v_num_reglt;


   p_ret := 1;

EXCEPTION
   WHEN EXT_CODEXT_ERROR THEN
      p_ret := -1;
   WHEN EXT_MODREG_ERROR THEN
   	  p_ret := -2;
   WHEN OTHERS THEN
      RAISE;
END MAJ_ins_reglement;

/

CREATE OR REPLACE PROCEDURE          PB_GENERE_ECART_CHANGE (v_ide_poste FC_ECRITURE.ide_poste%TYPE,v_gest FN_GESTION.ide_gest%TYPE, v_jal FC_JOURNAL.ide_jal%TYPE, v_ecriture FC_ECRITURE.ide_ecr%TYPE, v_dat_jc FC_ECRITURE.dat_jc%TYPE)IS

  v_libn                    FC_ECRITURE.libn%TYPE;
  v_observ                  FC_LIGNE.observ%TYPE;
  v_ide_plan_aux            FN_CPT_PLAN.ide_plan_aux%TYPE;
  v_ide_cpt_aux             FN_CPT_AUX.ide_plan_aux%TYPE;
  v_retour                  NUMBER;
  v_libl                    SR_CODIF.libl%TYPE;
  v_mt_dev                  FC_LIGNE.mt_dev%TYPE;
  v_mt_dev_piece            FC_REF_PIECE.mt_dev%TYPE;
  v_ide_cpt                 FN_COMPTE.IDE_CPT%TYPE;
  v_ide_ref_piece           FC_REF_PIECE.ide_ref_piece%TYPE;
  v_val_ref_piece           FC_REF_PIECE.ide_ref_piece%TYPE;
  v_val_cod_piece           FC_REF_PIECE.cod_ref_piece%TYPE;
  v_ecriture_ecart          FC_LIGNE.mt%TYPE;
  v_ecriture_ecart_tmp      FC_LIGNE.mt%TYPE;
  v_ide_jrnal               FC_JOURNAL.ide_jal%TYPE;
  v_ecr                     FC_ECRITURE.ide_ecr%TYPE;
  v_val_ide_plan_aux        FN_PLAN_AUX.ide_plan_aux%TYPE;
  v_val_ide_cpt_aux         FN_CPT_AUX.ide_cpt_aux%TYPE;
  v_modele_ligne            RC_MODELE_LIGNE.IDE_MODELE_LIG%TYPE;
  v_val_sens                RC_MODELE_LIGNE.VAL_SENS%TYPE;
  v_val_cpt                 RC_MODELE_LIGNE.VAL_CPT%TYPE;
  v_val_spec1               RC_MODELE_LIGNE.val_spec1%TYPE;
  v_val_spec2               RC_MODELE_LIGNE.val_spec2%TYPE;
  v_val_spec3               RC_MODELE_LIGNE.val_spec3%TYPE;
  v_mas_spec1               RC_MODELE_LIGNE.mas_spec1%TYPE;
  v_mas_spec2               RC_MODELE_LIGNE.mas_spec2%TYPE;
  v_mas_spec3               RC_MODELE_LIGNE.mas_spec3%TYPE;
  v_mas_cpt                 RC_MODELE_LIGNE.mas_cpt%TYPE;
  v_t_ref_piece             RC_MODELE_LIGNE.COD_REF_PIECE%TYPE;
  v_mt                      FC_LIGNE.mt%TYPE;
  v_ide_mas_cpt             SR_CODIF.cod_codif%TYPE;
  v_flg_ligne_cpt           NUMBER := 0;
  --v_taux_pec                FC_LIGNE.val_taux%TYPE;
  v_ide_jal_p               PC_PEC_ECART_CHANGE.IDE_JAL_P%TYPE;
  v_ide_schema_p            PC_PEC_ECART_CHANGE.ide_schema_p%TYPE;
  v_ide_jal_n               PC_PEC_ECART_CHANGE.ide_jal_n%TYPE;
  v_ide_schema_n            PC_PEC_ECART_CHANGE.ide_schema_n%TYPE;
  --v_ide_jal                 PC_PEC_ECART_CHANGE.IDE_JAL_P%TYPE;
  --v_ide_schema              PC_PEC_ECART_CHANGE.ide_schema_p%TYPE;
  v_schema VARCHAR2(100);
  v_var_cpta                FN_GESTION.VAR_CPTA%TYPE;
  v_cod_signe               RC_MODELE_LIGNE.cod_signe%TYPE;
  v_ide_lig                 FC_LIGNE.IDE_LIG%TYPE;
  v_flg_be                  FC_JOURNAL.FLG_BE%TYPE;
  v_non                     FC_JOURNAL.FLG_BE%TYPE;
  v_oui                     FC_JOURNAL.FLG_BE%TYPE;
  v_t_ref_piece_c           RC_MODELE_LIGNE.COD_REF_PIECE%TYPE;
  v_sens_debit              RC_MODELE_LIGNE.val_sens%TYPE;
  v_sens_credit             RC_MODELE_LIGNE.val_sens%TYPE;
  v_typ_poste               RM_POSTE.ide_typ_poste%TYPE;
  v_jal_init_piece          FC_JOURNAL.ide_jal%TYPE;
  v_ecr_init_piece          FC_ECRITURE.ide_ecr%TYPE;
  v_lig_init_piece          FC_LIGNE.ide_lig%TYPE;
  v_gest_init_piece         FC_LIGNE.ide_gest%TYPE;
  v_taux_pec                RB_TXCHANGE.val_taux%TYPE;
  mt_pec                    FC_LIGNE.mt%TYPE;
  mt_dev_pec                FC_LIGNE.mt_dev%TYPE;


  EXIT_ERROR EXCEPTION;
  EXT_CODEXT_ERROR EXCEPTION;
  EXT_CODINT_ERROR EXCEPTION;
  EXT_PARAM_ERROR EXCEPTION;
  CAL_NUM_TRT_ERROR EXCEPTION;
  EXT_EQUILIBRE_ERROR EXCEPTION;
  EXT_PARAMETRAGE_ERREUR EXCEPTION;
  CAL_IDE_REF_PIECE_ERREUR EXCEPTION;
  CRE_REF_PIECE_ERREUR EXCEPTION;
  MAJ_ECR_REF_PIECE_ERREUR EXCEPTION;
   ERREUR_ARRONDI        EXCEPTION;
  MASQUE_ERROR EXCEPTION;
  EXT_MT_CAL_CHANGE_ERREUR EXCEPTION;

  CURSOR c_rc_modele_ligne(v_var_cpta FN_GESTION.VAR_CPTA%TYPE,v_schema RC_SCHEMA_CPTA.ide_schema%TYPE, v_ide_jal FC_JOURNAL.ide_jal%TYPE) IS
  SELECT ide_modele_lig,val_sens,val_cpt
         , cod_signe
         , mas_cpt
         , cod_ref_piece
         , val_spec1
         , val_spec2
         , val_spec3
         , mas_spec1
         , mas_spec2
         , mas_spec3
  FROM  RC_MODELE_LIGNE
  WHERE  var_cpta  = v_var_cpta
  AND    ide_jal   =  v_ide_jal
  AND    ide_schema  = v_schema
  ORDER BY var_cpta, ide_jal, ide_schema;

  CURSOR c_ligne IS
  SELECT a.ide_cpt,mt,mt_dev,ide_devise,val_taux, a.var_cpta,a.ide_ref_piece, a.cod_ref_piece, a.cod_sens,a.ide_lig FROM FC_LIGNE a, RC_MODELE_LIGNE b, RC_LISTE_COMPTE c WHERE
  a.ide_poste = v_ide_poste
  AND a.ide_gest = v_gest
  AND a.ide_ecr =v_ecriture
  AND a.flg_cptab ='O'
  AND a.ide_jal = v_jal
  AND a.ide_cpt = c.ide_cpt
  AND a.VAR_CPTA = c.var_cpta
  AND a.ide_modele_lig = b.ide_modele_lig
  AND a.ide_jal = b.ide_jal
  AND a.ide_schema = b.ide_schema
  AND a.VAR_CPTA = b.var_cpta
  AND c.COD_LIST_CPT = 'DEVAL'
  AND (c.DAT_FVAL IS NULL OR TO_CHAR(c.DAT_FVAL,'YYYYMMDD') >= TO_CHAR(v_dat_jc,'YYYYMMDD'))
  AND b.cod_ref_piece ='A';



  /*   SELECT val_taux INTO v_taux_mt_initial
     FROM FC_LIGNE a, RC_MODELE_LIGNE b
     WHERE ide_piece = :BL_FB_LIGNE_TIERS_PIECE.ide_piece
     AND ide_poste =  v_poste_centra
     AND ide_gest = v_gest;*/

FUNCTION GET_VAL_MASQUE_SPEC(p_masque IN RC_MODELE_LIGNE.mas_spec1%TYPE,
                               p_val OUT RC_MODELE_LIGNE.val_spec1%TYPE,
                               p_val_sens IN RC_MODELE_LIGNE.val_sens%TYPE -- MODIF SGN ANOVA305
                              ) RETURN NUMBER IS

  v_libl SR_CODIF.libl%TYPE;
  v_ide_masque SR_MASQUE.cod_masque%TYPE;
  v_ret NUMBER;
  v_format_date VARCHAR2(50);
  
  EXT_CODINT_ERROR EXCEPTION;
      
      
  v_date_jc                 FC_CALEND_HIST.DAT_JC%TYPE;
  v_date_jc_cal             FC_CALEND_HIST.DAT_JC%TYPE;
  v_code_ferm               FC_CALEND_HIST.COD_FERM%TYPE;
  v_statjour_o              FC_CALEND_HIST.COD_FERM%TYPE;

--  v_cod_sens_d              FC_LIGNE.COD_SENS%TYPE;
--  v_cod_sens_c              FC_LIGNE.COD_SENS%TYPE;
  v_cod_be                  FC_LIGNE.COD_BE%TYPE;
  v_ide_cpt                 FC_LIGNE.ide_cpt%TYPE;

  V_mt_debit                FC_LIGNE.mt%TYPE;
  V_mt_credit               FC_LIGNE.mt%TYPE;

  V_ide_devise              FC_LIGNE.ide_devise%TYPE;
  V_ide_poste               FC_LIGNE.ide_poste%TYPE;
  V_ide_gest                FC_LIGNE.ide_gest%TYPE;

  V_mt_dev_debit            FC_LIGNE.mt%TYPE;
  V_mt_dev_credit           FC_LIGNE.mt%TYPE;
  V_mt_devise_debit         FC_LIGNE.mt%TYPE;
  V_mt_devise_credit        FC_LIGNE.mt%TYPE;

  /* LGD - ANOGAR588 - erreur de 0,01c sur le calcul des écarts de change */
  v_new_mt_debit            NUMBER;--FC_LIGNE.mt%TYPE;-- MODIF SGN ANOVA291 : v_new_mt_dev_debit        FC_LIGNE.mt%TYPE;
  v_new_mt_credit           NUMBER;--FC_LIGNE.mt%TYPE;-- MODIF SGN ANOVA291 : v_new_mt_dev_credit       FC_LIGNE.mt%TYPE;
  /* Fin de modification */

  v_ecart_debit             FC_LIGNE.mt%TYPE;
  v_ecart_credit            FC_LIGNE.mt%TYPE;
  v_ecriture_ecart          FC_LIGNE.mt%TYPE;
  v_ecriture_ecart_devise   FC_LIGNE.mt%TYPE;
  --v_cod_sens               FC_LIGNE.COD_SENS%TYPE;

  v_poste                   RM_POSTE.IDE_POSTE%TYPE;
  v_typ_poste               RM_POSTE.IDE_TYP_POSTE%TYPE;


  v_cod_list_cpt            RC_LISTE_COMPTE.COD_LIST_CPT%TYPE;

  v_taux_change             RB_TXCHANGE.VAL_TAUX%TYPE;
  v_ide_dev                 RB_TXCHANGE.IDE_DEVISE%TYPE;


   v_val_param               SR_PARAM.val_param%TYPE;

  v_ide_jal_p               PC_PEC_ECART_CHANGE.IDE_JAL_P%TYPE;
  v_ide_schema_p            PC_PEC_ECART_CHANGE.ide_schema_p%TYPE;
  v_ide_jal_n               PC_PEC_ECART_CHANGE.ide_jal_n%TYPE;
  v_ide_schema_n            PC_PEC_ECART_CHANGE.ide_schema_n%TYPE;
  v_ide_jal                 PC_PEC_ECART_CHANGE.IDE_JAL_P%TYPE;
  v_ide_schema              PC_PEC_ECART_CHANGE.ide_schema_p%TYPE;

  v_ide_trt                 FC_NUM_TRAIT.ide_trt%TYPE;
  v_ide_ecr                 FC_ECRITURE.IDE_ECR%TYPE;

  v_modele_ligne            RC_MODELE_LIGNE.IDE_MODELE_LIG%TYPE;
  v_val_sens                RC_MODELE_LIGNE.VAL_SENS%TYPE;
  v_val_cpt                 RC_MODELE_LIGNE.VAL_CPT%TYPE;
  v_libn                    RC_SCHEMA_CPTA.LIBN%TYPE;

  v_valeur_param            NUMBER;
  v_retour                  NUMBER;
  v_ide_lig                 FC_LIGNE.IDE_LIG%TYPE;
  v_date                    RB_TXCHANGE.dat_application%TYPE;
  v_existe_journee          BOOLEAN;

  -- MODIF SGN ANO204 V3 : Gestion correct de la trace
  -- Variable pour la trace
  v_niveau_trace NUMBER := NULL;
  v_num_trt NUMBER;

  v_schema VARCHAR2(100); -- MODIF SGN ANOVA181

  v_cod_signe               RC_MODELE_LIGNE.cod_signe%TYPE; -- MODIF SGN ANOVA177, 193
  v_mas_cpt                 RC_MODELE_LIGNE.mas_cpt%TYPE;   -- MODIF LGD ANOVA186
  v_ide_mas_cpt             SR_CODIF.cod_codif%TYPE;         -- MODIF LGD ANOVA186

  v_mt                      NUMBER;
  v_flg_be                  FC_JOURNAL.FLG_BE%TYPE; -- MODIF LGD ANO187
  v_t_ref_piece             RC_MODELE_LIGNE.COD_REF_PIECE%TYPE; -- MODIF LGD ANO187
  v_t_ref_piece_c           RC_MODELE_LIGNE.COD_REF_PIECE%TYPE; -- MODIF LGD ANO187
  v_ide_ref_piece             FC_REF_PIECE.ide_ref_piece%TYPE; -- MODIF LGD ANO187
  v_sens_debit              RC_MODELE_LIGNE.val_sens%TYPE;   -- MODIF LGD ANO187
  v_sens_credit             RC_MODELE_LIGNE.val_sens%TYPE;   -- MODIF LGD ANO187
  v_non                     FC_JOURNAL.FLG_BE%TYPE; --MODIF LGD ANO187
  v_oui                     FC_JOURNAL.FLG_BE%TYPE; --MODIF LGD ANO187

  -- MODIF SGN ANOVA192
  v_val_spec1               RC_MODELE_LIGNE.val_spec1%TYPE;
  v_val_spec2               RC_MODELE_LIGNE.val_spec2%TYPE;
  v_val_spec3               RC_MODELE_LIGNE.val_spec3%TYPE;
  v_mas_spec1               RC_MODELE_LIGNE.mas_spec1%TYPE;
  v_mas_spec2               RC_MODELE_LIGNE.mas_spec2%TYPE;
  v_mas_spec3               RC_MODELE_LIGNE.mas_spec3%TYPE;
  -- MODIF SGN ANOVA291
  v_last_mt_cal_change      NUMBER;
  -- MODIF SGN ANOVA297
  v_solde_mt_dev            NUMBER;
  v_solde_mt                NUMBER;
  -- MODIF SGN EVO41 : 3.3-1.19
  v_ide_plan_aux            FN_PLAN_AUX.ide_plan_aux%TYPE;
  v_ide_cpt_aux             FN_CPT_AUX.ide_cpt_aux%TYPE;
  v_val_ide_plan_aux            FN_PLAN_AUX.ide_plan_aux%TYPE;
  v_val_ide_cpt_aux             FN_CPT_AUX.ide_cpt_aux%TYPE;


      
      


  BEGIN

    -- Si le masque est null on ne fait rien
    IF p_masque IS NULL THEN
      RETURN 1;
    END IF;

    -- Recuperation du code interne du masque
    Ext_Codint('MASQUE',p_masque , v_libl, v_ide_masque, v_ret);
    IF  v_ret != 1 THEN
      --trace('get_val_masque_spec : codint : '||p_masque);
      RAISE EXT_CODINT_ERROR;
    END IF;

    -- Recuperation des valeurs en fonction des masques
    -- DTCAL
    IF v_ide_masque = 'DTCAL' THEN
      -- Recuperation du format de la date
      Ext_Format_Date(v_format_date);

      p_val := TO_CHAR(v_dat_jc, v_format_date);

    -- DEV
    ELSIF v_ide_masque = 'DEV' THEN
      p_val := v_ide_devise;

    -- ASOLD
    ELSIF v_ide_masque = 'ASOLD' THEN
      p_val := NVL(v_mt_debit,0) - NVL(v_mt_credit,0);

    -- NSOLD
    ELSIF v_ide_masque = 'NSOLD' THEN
      -- MODIF SGN ANOVA305 : Prise en compte du sens de la ligne generee pour le calcul du NSOLD
      -- p_val := NVL(v_mt_debit,0) - NVL(v_mt_credit,0) + NVL(v_mt, 0);
      -- D => Ancien solde + ecart de change
      IF p_val_sens = 'D' THEN
        p_val := NVL(v_mt_debit,0) - NVL(v_mt_credit,0) + NVL(v_mt, 0);

      -- C => Ancien solde - ecart de change
      ELSE
        p_val := NVL(v_mt_debit,0) - NVL(v_mt_credit,0) - NVL(v_mt, 0);
      END IF;
      -- Fin modif sgn

    END IF;

    --trace('get_val_masque_spec : val = '||p_val);
    --trace('get_val_masque_spec : '||TO_CHAR(:BL_CTRL.t_dat_jc)||'-'||v_ide_devise||'-'||TO_CHAR(NVL(v_mt_debit,0) - NVL(v_mt_credit,0))||'-'||TO_CHAR(NVL(v_mt_debit,0) - NVL(v_mt_credit,0) + NVL(v_mt, 0)));

    RETURN 1;

  EXCEPTION
    WHEN EXT_CODINT_ERROR THEN
      RETURN -1;
    WHEN OTHERS THEN
      RAISE;
  END;
  -- Fin modif sgn




BEGIN

        BEGIN
         SELECT ide_typ_poste
         INTO   v_typ_poste
         FROM   RM_POSTE
         WHERE  ide_poste = v_ide_poste;

       EXCEPTION
         WHEN NO_DATA_FOUND THEN
              Aff_Mess('E',316,'U215_010B.sql',NULL,NULL,NULL);
         RAISE EXIT_ERROR;
       END;


 FOR v_c_ligne IN c_ligne LOOP
 
    SELECT ide_jal,ide_ecr, ide_lig, ide_gest, mt_dev INTO v_jal_init_piece, v_ecr_init_piece, v_lig_init_piece, v_gest_init_piece, v_mt_dev_piece FROM FC_REF_PIECE
    WHERE ide_poste = v_ide_poste
    AND   ide_ref_piece = v_c_ligne.ide_ref_piece;
    
    SELECT val_taux,mt,mt_dev INTO v_taux_pec,mt_pec,mt_dev_pec FROM FC_LIGNE 
    WHERE ide_poste = v_ide_poste
    AND ide_gest = v_gest_init_piece
    AND ide_jal = v_jal_init_piece
    AND ide_ecr = v_ecr_init_piece
    AND ide_lig = v_lig_init_piece
    AND flg_cptab = 'O';

     IF v_c_ligne.val_taux <> v_taux_pec THEN
     
        --v_retour := CAL_MT_DEVISE(v_c_ligne.ide_devise,v_taux_pec,1,v_ecriture_ecart,v_c_ligne.mt_dev);
        IF v_mt_dev_piece = 0 THEN
                            
                         select sum(decode(cod_sens,'C',mt,-mt)) into v_ecriture_ecart_tmp from fc_ligne where ide_poste = v_ide_poste
                         and ide_ref_piece = v_c_ligne.ide_ref_piece
                         and ide_jal not in (select ide_jal from fc_journal where flg_repsolde='O');
                            
        ELSE
        
     
                IF v_c_ligne.cod_sens ='D' THEN

                   
                    v_ecriture_ecart_tmp := v_c_ligne.mt_dev * v_taux_pec - v_c_ligne.mt_dev * v_c_ligne.val_taux;
                    
                                               
                ELSE
                 
                  v_ecriture_ecart_tmp := - v_c_ligne.mt_dev * v_taux_pec + v_c_ligne.mt_dev * v_c_ligne.val_taux;
                 
                END IF;
                
         END IF;

         v_retour := CAL_ROUND_MT(v_ecriture_ecart_tmp, v_ecriture_ecart);
         
         v_ide_cpt := v_c_ligne.ide_cpt;

               BEGIN

                    SELECT ide_jal_p,ide_schema_p,ide_jal_n,ide_schema_n
                        INTO   v_ide_jal_p,v_ide_schema_p,v_ide_jal_n,v_ide_schema_n
                        FROM   PC_PEC_ECART_CHANGE
                        WHERE  ide_typ_poste = v_typ_poste
                        AND    var_cpta = v_c_ligne.var_cpta;

               EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                            Aff_Mess('E',316,'U215_010B.sql',NULL,NULL,NULL);
                            RAISE EXIT_ERROR;
               END;

               IF v_ecriture_ecart >= 0 THEN
                  v_ide_jrnal := v_ide_jal_p;
                  v_schema := v_ide_schema_p;
               ELSE
                  v_ide_jrnal := v_ide_jal_n;
                  v_schema := v_ide_schema_n;
               END IF;


                            --      trace('RECHERCHE DU LIBELLE DANS TABLE RC_SCHEMA_CPTA POUR LIGNE ECRITURE');
               v_var_cpta := v_c_ligne.var_cpta;

               SELECT libn
               INTO v_libn
               FROM  RC_SCHEMA_CPTA
               WHERE var_cpta = v_var_cpta
               AND   ide_jal = v_ide_jrnal
               AND   ide_schema = v_schema;

                   --     trace('CREATION D UNE ECRITURE');

                BEGIN

                  SELECT NVL(MAX(ide_ecr),0) + 1  INTO v_ecr
                  FROM FC_ECRITURE
                  WHERE ide_poste = v_ide_poste
                  AND   ide_gest = v_gest
                  AND   ide_jal = v_ide_jrnal
                  AND   FLG_CPTAB = 'O';
                END;



                 /* LGD - 06/12/2002 - ANO VA V3 173 : Date d'écriture inexistante pour les écritures d'écarts de change */
              INSERT INTO FC_ECRITURE
              (IDE_POSTE, IDE_GEST, IDE_JAL, FLG_CPTAB, IDE_ECR, DAT_JC, VAR_CPTA, IDE_SCHEMA,
               LIBN, DAT_SAISIE, COD_STATUT, DAT_ECR)
              VALUES
               (v_ide_poste,v_gest,v_ide_jrnal,'O',v_ecr,v_dat_jc,v_var_cpta,v_schema,v_libn,SYSDATE,'CO',v_dat_jc);
              /* Fin de modification */


            --    CREATION DES LIGNES


         --       trace('CREATION DES LIGNES');

              -- MODIF SGN EVO41 : 3.3-1.19 : Initialisation des valeurs plan aux et cpt aux
              -- MODIF SGN EVO41 : 3.3-1.21 : Les valeur seront determinees au moment ou l on passera sur la ligne qui contient le parametrage @CPT
              v_val_ide_plan_aux := NULL;
              v_val_ide_cpt_aux := NULL;
              -- fin modif sgn 3.3-1.19

              OPEN  c_rc_modele_ligne(v_var_cpta,v_schema,v_ide_jrnal);

                      LOOP
                            -- MODIF SGN ANOVA177, 193 : recuperation du cod_signe
                        FETCH c_rc_modele_ligne INTO v_modele_ligne,v_val_sens,v_val_cpt, v_cod_signe, v_mas_cpt, v_t_ref_piece,
                                  -- MODIF SGN ANOVA192
                                  v_val_spec1,
                                  v_val_spec2,
                                  v_val_spec3,
                                  v_mas_spec1,
                                  v_mas_spec2,
                                  v_mas_spec3;
                                  -- fin modif sgn
                                v_val_ref_piece := null;
                                v_val_cod_piece := null;
                                                 
                        IF    c_rc_modele_ligne%NOTFOUND THEN
                               EXIT;
                        ELSE
                                                   
                            -- MODIF SGN ANOVA177, 193 : formatage de l'ecart en fonction du signe attendu
                            -- On veut des montants positif
                            IF v_cod_signe = 'P' THEN
                                v_mt := ABS(v_ecriture_ecart);

                            -- On veut des montants negatifs
                            ELSIF v_cod_signe = 'N' THEN
                                v_mt := ABS(v_ecriture_ecart) * -1;

                            -- non parametre ou indiferent
                            ELSE
                                v_mt := v_ecriture_ecart;
                            END IF;
                            -- Fin modif sgn


                            -- Modif LGD ANOVA186 : Prise en compte du masque @CPT

                            -- Recherche du code interne du masque @CPT
                              Ext_Codint('MASQUE',v_mas_cpt , v_libl, v_ide_mas_cpt, v_retour);
                                      IF  v_retour != 1 THEN
                                        RAISE EXT_CODINT_ERROR;
                                      END IF;

                            IF v_val_cpt IS NULL THEN
                                   IF v_ide_mas_cpt <> 'CPT' THEN
                                     RAISE EXT_PARAMETRAGE_ERREUR;
                                   ELSE
                                     -- MODIF SGN ANOVA265 : v_val_cpt :=p_compte;
                                     v_val_cpt := v_ide_cpt;

                                     -- MODIF SGN EVO41 : 3.3-1.19 : On se trouve sur la ligne de contrepartie parametree avec (@CPT)
                                                 --   => recuperation des info plan et compte auxiliaire de la ligne
                                                 v_val_ide_plan_aux := v_ide_plan_aux;
                                                 v_val_ide_cpt_aux  := v_ide_cpt_aux;
                                                 -- fin modif sgn

                                                 v_flg_ligne_cpt := 1; -- MODIF SGN EVO41 : 3.3-1.21 : ajout indic ligne @CPT
                                                 v_val_ref_piece := v_c_ligne.ide_ref_piece;
                                                 v_val_cod_piece := v_c_ligne.cod_ref_piece;

                                   END IF;


                                      -- MODIF SGN EVO41 3.3-1.21 : suppression des modifs precedentes + ajout indicateur ligne @CPT
                             ELSE
                                        v_flg_ligne_cpt := 0;

                            END IF;
                            -- Fin modif LGD

                                      -- MODIF SGN ANOVA192 : recuperation des valeurs des specifications
                                      -- SPEC1
                                      IF v_val_spec1 IS NULL THEN
                                        v_retour := get_val_masque_spec(v_mas_spec1, v_val_spec1, v_val_sens);
                                        IF v_retour != 1 THEN
                                         -- trace('pb recup spec1 : '||v_mas_spec1);
                                          RAISE MASQUE_ERROR;
                                        END IF;
                                      END IF;

                                      -- SPEC2
                                      IF v_val_spec2 IS NULL THEN
                                        v_retour := get_val_masque_spec(v_mas_spec2, v_val_spec2, v_val_sens);
                                        IF v_retour != 1 THEN
                                         -- trace('pb recup spec2 : '||v_mas_spec2);
                                          RAISE MASQUE_ERROR;
                                        END IF;
                                      END IF;

                                      -- SPEC3
                                      IF v_val_spec3 IS NULL THEN
                                        v_retour := get_val_masque_spec(v_mas_spec3, v_val_spec3, v_val_sens);
                                        IF v_retour != 1 THEN
                                         -- trace('pb recup spec3 : '||v_mas_spec3);
                                          RAISE MASQUE_ERROR;
                                        END IF;
                                      END IF;

                                      -- fin modif sgn


                                     SELECT NVL(MAX(ide_lig),0) + 1 INTO v_ide_lig
                                      FROM FC_LIGNE
                                      WHERE ide_poste = v_ide_poste
                                      AND   ide_gest = v_gest
                                      AND   ide_jal = v_ide_jrnal
                                      AND   flg_cptab = 'O';
                                      
                             IF v_val_cpt = v_c_ligne.ide_cpt AND v_val_sens <> v_c_ligne.cod_sens THEN 
                             
                             /* on s'aasure que le compte sera imputé dans le sens d'abondement de la piece */
                             
                                v_val_sens := v_c_ligne.cod_sens;
                                
                                v_mt := v_mt* -1 ;
                             
                                                        
                             END IF;

                                v_observ := 'Ecart de change - '||v_jal||' - '||to_char(v_ecriture)||' - '||v_c_ligne.ide_lig;
                            /* LGD - 20/11/2002 - ANO VA V3 173 : Date d'écriture inexistante pour les écritures d'écarts de change */
                            INSERT INTO FC_LIGNE
                            (
                                        IDE_POSTE, IDE_GEST, IDE_JAL, FLG_CPTAB, IDE_ECR, IDE_LIG, VAR_CPTA,IDE_CPT, COD_SENS, MT, OBSERV, IDE_SCHEMA,
                              COD_TYP_SCHEMA, IDE_MODELE_LIG, FLG_ANNUL_DCST,DAT_ECR,
                                        -- MODIF SGN ANOVA192 : Ajout des info specification
                                        spec1,
                                        spec2,
                                        spec3,
                                        -- MODIF SGN EVO41 : ajout info comptabilite auxiliaire
                                        ide_plan_aux,
                                        ide_cpt_aux,
                                        ide_ref_piece,
                                        cod_ref_piece
                                        -- fin modif sgn
                                      )
                            VALUES
                                      (
                                        v_ide_poste,v_gest,v_ide_jrnal,'O',v_ecr,v_ide_lig,v_var_cpta,v_val_cpt,
                              v_val_sens,
                              v_mt,  -- MODIF SGN ANOVA177, 193 : v_ecriture_ecart,
                              v_observ,
                              v_schema,'A',v_modele_ligne,'N',v_dat_jc,
                                        -- MODIF SGN ANOVA192 : Ajout des info specification
                                        v_val_spec1,
                                        v_val_spec2,
                                        v_val_spec3,
                                        -- MODIF SGN EVO41 : ajout info comptabilite auxiliaire
                                        -- MODIF SGN EVO41 : 3.3-1.21 : si on est sur la ligne qui a le masque @CPT on insere les info cpt aux sinon on met null
                                        -- v_val_ide_plan_aux,
                                        --v_val_ide_cpt_aux,
                                        DECODE(v_flg_ligne_cpt, 1, v_val_ide_plan_aux, NULL),
                                        DECODE(v_flg_ligne_cpt, 1, v_val_ide_cpt_aux, NULL),
                                        v_val_ref_piece,
                                        v_val_cod_piece
                                        -- fin modif sgn 3.3-1.21
                                        -- fin modif sgn
                                      );
                                      
                                 IF v_c_ligne.cod_sens ='D' THEN
                                 
                                    UPDATE FC_REF_PIECE SET mt_db = mt_db + v_mt
                                    WHERE ide_poste = v_ide_poste
                                    AND  ide_ref_piece = v_val_ref_piece;
                                 
                                 ELSE
                                 
                                    UPDATE FC_REF_PIECE SET mt_cr = mt_cr + v_mt
                                    WHERE ide_poste = v_ide_poste
                                    AND  ide_ref_piece = v_val_ref_piece;
                                    
                                 
                                 END IF;     
                              
                            /* Fin de modification */

                                  -- ANO 187 - Création de la référence pièce -
                                --1) Recherche si le journal a le flag "flg_be"
                                SELECT flg_be INTO v_flg_be
                                FROM  FC_JOURNAL
                                WHERE ide_jal = v_ide_jrnal AND
                                      var_cpta = v_var_cpta;
                                --2) Création de la pièce
                               IF v_flg_be = v_non AND
                                   v_t_ref_piece = v_t_ref_piece_c THEN

                                  --2.1) - Calcul du prochain numéro de piece */
                                 BEGIN
                                    SELECT DISTINCT ide_ref_piece+1 INTO v_ide_ref_piece
                                    FROM FC_REF_PIECE
                                    WHERE ide_poste = v_ide_poste
                                    AND   ide_ref_piece >= ALL (SELECT A.ide_ref_piece
                                                                FROM FC_REF_PIECE A
                                                                WHERE A.ide_poste = v_ide_poste);
                                 EXCEPTION
                                   WHEN NO_DATA_FOUND THEN
                                     v_ide_ref_piece := 1;
                                   WHEN OTHERS THEN
                                     RAISE CAL_IDE_REF_PIECE_ERREUR;
                                 END;


                                    --2.2) - Création d'une référence pièce */
                                  BEGIN
                                    IF v_val_sens = v_sens_debit THEN
                                        INSERT INTO FC_REF_PIECE
                                          (ide_poste,ide_ref_piece,cod_ref_piece,var_tiers,ide_tiers,ide_gest,flg_cptab,
                                           mt_db,mt_cr,dat_der_mvt,flg_solde,ide_jal,ide_ecr,ide_lig,ide_devise , val_taux , mt_dev,
                                           ide_plan_aux, ide_cpt_aux
                                            )
                                        VALUES
                                            ( v_ide_poste,
                                            v_ide_ref_piece,
                                            v_ide_ref_piece,
                                            NULL,
                                            NULL,
                                            v_gest,
                                            v_oui,
                                            v_mt,
                                            0,
                                            SYSDATE,
                                            v_non,
                                            v_ide_jrnal,
                                            v_ecr,
                                            v_ide_lig,
                                            NULL ,NULL , NULL ,
                                          -- MODIF SGN EVO41 : 3.3-1.19 : ajout info comptabilite auxiliaire
                                                      --null,
                                                --null
                                                      -- MODIF SGN EVO41 : 3.3-1.21 : si on est sur la ligne qui a le masque @CPT on insere les info cpt sinon on met null
                                                      -- v_val_ide_plan_aux,
                                                      -- v_val_ide_cpt_aux,
                                                      DECODE(v_flg_ligne_cpt, 1, v_val_ide_plan_aux, NULL),
                                                      DECODE(v_flg_ligne_cpt, 1, v_val_ide_cpt_aux, NULL)
                                                      -- fin modif sgn 3.3-1.21
                                                      -- fin modif sgn 3.3-1.19
                                           );
                                    ELSIF v_val_sens = v_sens_credit THEN
                                    INSERT INTO FC_REF_PIECE
                                          (ide_poste,ide_ref_piece,cod_ref_piece,var_tiers,ide_tiers,ide_gest,flg_cptab,
                                           mt_db,mt_cr,dat_der_mvt,flg_solde,ide_jal,ide_ecr,ide_lig,ide_devise , val_taux , mt_dev,
                                           ide_plan_aux, ide_cpt_aux
                                            )
                                        VALUES
                                            ( v_ide_poste,
                                            v_ide_ref_piece,
                                            v_ide_ref_piece,
                                            NULL,
                                            NULL,
                                            v_gest,
                                            v_oui,
                                            0,
                                            v_mt,
                                            SYSDATE,
                                            v_non,
                                            v_ide_jrnal,
                                            v_ecr,
                                            v_ide_lig,
                                            NULL ,NULL , NULL ,
                                          -- MODIF SGN EVO41 : 3.3-1.19 : ajout info comptabilite auxiliaire
                                                      --null,
                                                --null
                                                      -- MODIF SGN EVO41 : 3.3-1.21 : si on est sur la ligne qui a le masque @CPT on insere les info cpt sinon on met null
                                                      -- v_val_ide_plan_aux,
                                                      -- v_val_ide_cpt_aux,
                                                      DECODE(v_flg_ligne_cpt, 1, v_val_ide_plan_aux, NULL),
                                                      DECODE(v_flg_ligne_cpt, 1, v_val_ide_cpt_aux, NULL)
                                                      -- fin modif sgn 3.3-1.21
                                                      -- fin modif sgn 3.3-1.19
                                           );
                                  END IF;
                                  EXCEPTION
                                    WHEN OTHERS THEN
                                      RAISE CRE_REF_PIECE_ERREUR;
                                  END;

                                    --2.3) - Mise a jour de la ligne d'ecriture  */
                                 BEGIN
                                    UPDATE FC_LIGNE
                                      SET ide_ref_piece = v_ide_ref_piece,
                                    cod_ref_piece  = v_ide_ref_piece
                                      WHERE    ide_poste = v_ide_poste
                                     AND ide_gest =  v_gest
                                     AND ide_jal =   v_ide_jrnal
                                     AND flg_cptab = v_oui
                                     AND ide_ecr =   v_ecr
                                     AND ide_lig =   v_ide_lig;
                                    EXCEPTION
                                    WHEN OTHERS THEN
                                      RAISE MAJ_ECR_REF_PIECE_ERREUR;
                                                                  
                                  END;
                                
                             END IF;

                        END IF;

                    END LOOP;
               CLOSE c_rc_modele_ligne;
               
     
              v_retour := Ctl_Equilibre_Ecr(v_ide_poste,v_gest,v_ide_jrnal,'O',v_ecr);

                 -- Si l ecriture n est pas equilibree
               IF v_retour = 0 THEN
                  v_schema := v_var_cpta||'-'||v_ide_jrnal||'-'||v_schema;
                  --  trace('ecr non equi ('||v_ide_poste||'-'||v_gest||'-'||v_ide_jrnal||'-'||v_ecr||')');
                  RAISE EXT_EQUILIBRE_ERROR;
               ELSIF v_retour = -1 THEN
                  --  trace('pb recup cod externe ('||v_retour||')');
                  RAISE EXT_CODEXT_ERROR;
               ELSIF v_retour = -2 THEN
                  --  trace('pb recup cod externe ('||v_retour||')');
                  RAISE EXT_CODEXT_ERROR;
               ELSIF v_retour = -3 THEN
                 -- trace('pb recup cod externe ('||v_retour||')');
                  RAISE EXT_CODEXT_ERROR;
               END IF;

     END IF;

 END LOOP;


 EXCEPTION
  WHEN EXIT_ERROR THEN
    Aff_Mess('E', 0179, 'U215_010B.sql', 'U215_010B.sql', NULL, NULL);
    ROLLBACK;
  WHEN EXT_CODEXT_ERROR THEN
    Aff_Mess('E', 0188, 'U215_010B.sql', NULL, NULL, NULL);
    Aff_Mess('E', 0179, 'U215_010B.sql', 'U215_010B.sql', NULL, NULL);
    ROLLBACK;
  WHEN EXT_CODINT_ERROR THEN
    Aff_Mess('E', 0188, 'U215_010B.sql', NULL, NULL, NULL);
    Aff_Mess('E', 0179, 'U215_010B.sql', 'U215_010B.sql', NULL, NULL);
    ROLLBACK;
  WHEN EXT_PARAM_ERROR THEN
    Aff_Mess('E', 0159, 'U215_010B.sql', NULL, NULL, NULL);
    Aff_Mess('E', 0179, 'U215_010B.sql', 'U215_010B.sql', NULL, NULL);
    ROLLBACK;
  WHEN CAL_NUM_TRT_ERROR    THEN
    Aff_Mess('E', 0181, 'U215_010B.sql', NULL, NULL, NULL);
    Aff_Mess('E', 0179, 'U215_010B.sql', 'U215_010B.sql', NULL, NULL);
    ROLLBACK;
  -- MODIF SGN ANOVA181 : ajout controle equilibre
  WHEN EXT_EQUILIBRE_ERROR    THEN
    Aff_Mess('E', 0331, 'U215_010B.sql', NULL, NULL, NULL);
    Aff_Mess('E', 0874, 'U215_010B.sql', v_schema, NULL, NULL);
    Aff_Mess('E', 0179, 'U215_010B.sql', 'U215_010B.sql', NULL, NULL);
    ROLLBACK;
  -- fin modif sgn
  -- MODIF LGD ANOVA186 : Prise en compte du masque @CPT
  WHEN EXT_PARAMETRAGE_ERREUR THEN
-- Début HPEJ le 09/03/2006 - Correction de l'anomalie V35-DIT44-049
--    Aff_Mess('E', 0879, 'U215_010B.sql', v_schema, v_modele_ligne , NULL);
    v_schema := v_var_cpta||'-'||v_ide_jrnal||'-'||v_schema;
    Aff_Mess('E', 1123, 'U215_010B.sql', v_modele_ligne, v_schema, NULL);
-- Fin HPEJ le 09/03/2006 - Correction de l'anomalie V35-DIT44-049
    ROLLBACK;
  -- fin modif lgd
  -- MODIF LGD ANOVA187 : Création de la référence pièce
  WHEN CAL_IDE_REF_PIECE_ERREUR THEN
    Aff_Mess('E', 0371, 'U215_010B.sql', NULL, NULL , NULL);
    ROLLBACK;
  WHEN CRE_REF_PIECE_ERREUR THEN
    Aff_Mess('E', 0370, 'U215_010B.sql', NULL, NULL , NULL);
    ROLLBACK;
  WHEN MAJ_ECR_REF_PIECE_ERREUR THEN
    Aff_Mess('E', 0366, 'U215_010B.sql', NULL, NULL , NULL);
    ROLLBACK;
  -- fin modif lgd
  -- Modif LGD ANOVAV3 262
  WHEN ERREUR_ARRONDI THEN
    Aff_Mess('E', 0879, 'U215_010B.sql', NULL, NULL , NULL);
    ROLLBACK;
  -- MODIF SGN ANOVA192
  WHEN MASQUE_ERROR THEN
    Aff_Mess('E', 0633, 'U215_010B.sql', NULL, NULL , NULL);
    ROLLBACK;
  -- MODIF SGN ANOVA291
  WHEN EXT_MT_CAL_CHANGE_ERREUR THEN
    Aff_Mess('E', 0888, 'U215_010B.sql', NULL, NULL , NULL);
    ROLLBACK;
  -- fin modif sgn
  WHEN OTHERS THEN
    Aff_Mess('E', 0105, 'U215_010B.sql', SQLERRM, NULL, NULL);
    Aff_Mess('E', 0179, 'U215_010B.sql', 'U215_010B.sql', NULL, NULL);
    ROLLBACK;
  END;

/

CREATE OR REPLACE PROCEDURE PURGE_TIERS (
  p_out_retour       OUT       NUMBER,
  p_out_text_retour1 OUT       VARCHAR2,
  p_out_text_retour2 OUT       VARCHAR2,
  p_out_text_retour3 OUT       VARCHAR2
)
IS
--=========================== PURGE_TIERS =====================================================
--  Sujet     Procédure permettant de purger les tables de tiers IB_TIERS et IB_COOR_BANC
--	      une fois l'acceptation ou le refus d'un tiers en provenance de l'interface
--	      FI_TIERS
--  Instance  TIERS
--  Créé le   05052008 par FBT
--  Version   v4260
--  Entrée   Aucune
--  Sortie   p_retour (0  OK, X  Erreurs, numéro du message a afficher )
--           p_text_retour1 (text du paramètre1 de message de retour)
--           p_text_retour2 (text du paramètre2 de message de retour)
--           p_text_retour3 (text du paramètre3 de message de retour)
--
--  Table des codes retour
--       1  - Message 27
--
--====================== HISTORIQUE DES MODIFICATIONS =============================================
--  Date        Version  Aut. Evolution Sujet
--  -----------------------------------------------------------------------------------------------
--  05052008 v4260    FBT  Création de la procédure pour l'évolution DI44-2007-12
--=================================================================================================

	v_codif_libl   VARCHAR2(200);
	v_temp    	   NUMBER :=0;
	v_codif_recu   VARCHAR2(200);
	v_codif_ac     VARCHAR2(200);
	v_codif_rf     VARCHAR2(200);

BEGIN

        --récupération des codifications
	EXT_CODEXT ( 'EMIS_RECU', 'R', v_codif_libl, v_codif_recu, v_temp );
	EXT_CODEXT ( 'STATUT_MESS', '10', v_codif_libl, v_codif_ac, v_temp );
	EXT_CODEXT ( 'STATUT_MESS', '11', v_codif_libl, v_codif_rf, v_temp );

	--suppression des enregistrement invalide dans IB_TIERS
	DELETE FROM ib_tiers c
	WHERE (c.ide_tiers,c.cod_typ_nd,c.ide_nd_emet,c.ide_mess,c.flg_emis_recu) IN (
	    SELECT a.ide_tiers,a.cod_typ_nd,a.ide_nd_emet,a.ide_mess,a.flg_emis_recu
	    FROM ib_tiers a
	        INNER JOIN fm_rnl_me b
	            ON  a.cod_typ_nd=b.cod_typ_nd_emet
	            AND a.ide_nd_emet=b.ide_nd_emet
	            AND a.ide_mess=b.ide_mess
	            AND a.flg_emis_recu=b.flg_emis_recu
	    WHERE b.flg_emis_recu=v_codif_recu
	    AND b.cod_statut IN (v_codif_ac,v_codif_rf)
	);

	--suppression des enregistrement invalide dans IB_COORD_BANC
	DELETE FROM ib_coord_banc c
	WHERE (c.ide_tiers,c.cod_typ_nd,c.ide_nd_emet,c.ide_mess,c.flg_emis_recu,c.cpt_bq) IN (
        SELECT a.ide_tiers,a.cod_typ_nd,a.ide_nd_emet,a.ide_mess,a.flg_emis_recu,a.cpt_bq
    	FROM ib_coord_banc a
            INNER JOIN fm_rnl_me b
                ON  a.cod_typ_nd=b.cod_typ_nd_emet
            	AND a.ide_nd_emet=b.ide_nd_emet
            	AND a.ide_mess=b.ide_mess
            	AND a.flg_emis_recu=b.flg_emis_recu
        WHERE b.flg_emis_recu=v_codif_recu
    	AND b.cod_statut IN (v_codif_ac,v_codif_rf)
	);

    --retour OK
    p_out_retour:=0;
    p_out_text_retour1:='';
    p_out_text_retour2:='';
    p_out_text_retour3:='';

EXCEPTION
    WHEN OTHERS THEN
        p_out_retour:=1; --alert 27
        p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
    RAISE;
END PURGE_TIERS;

/

CREATE OR REPLACE PROCEDURE TEST_DEVISE ( P_Ide_Poste        IN  FC_REF_PIECE.ide_poste%TYPE ,
														 -- Evo FA0043 - Début FDUB le 17/08/2005
														  -- P_ide_ref_piece    IN  FC_REGLEMENT.ide_piece%TYPE ,
														 P_ide_ref_piece    IN  FC_REGLEMENT.cod_ref_piece%TYPE ,
														 -- Evo FA0043 - Fin FDUB le 17/08/2005
														 P_ide_devise       IN  FC_REF_PIECE.ide_devise%TYPE,    -- Devise de la ligne de l'écriture
														 P_Ref_piece        OUT FC_REF_PIECE%ROWTYPE,            -- ligne de fc_ref_piece
-- Début HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048 : Renommage du paramètre. Il ne sert pas à savoir si on doit créer
--                                                                une nouvelle ligne mais à savoir si la devise est différente
--														 P_Creation_Ligne   OUT BOOLEAN,                          -- variable boolean :
														 P_Autre_Devise     OUT BOOLEAN,                          -- variable boolean :
-- Fin HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048
														 																												 -- TRUE : création d'une ligne dans FC_REF_PIECE
																																										 -- FALSE: Modif de la ligne qui existe déja
														 P_sens             OUT FC_LIGNE.cod_sens%TYPE,           -- sens de la reference piece d'origine
														 P_cod_orig_reglt   IN  FC_REGLEMENT.cod_orig_reglt%TYPE,
														 -- MODIF SGN ANOVA403 : 3.2a-1.17 : ajout des info concernant le tiers du reglement
														 P_var_tiers_reglt  IN  FC_REGLEMENT.var_tiers%TYPE,
														 P_ide_tiers_reglt  IN  FC_REGLEMENT.ide_tiers%TYPE,
														 -- MODIF SGN ANOVSR490 : 3.3-1.24 : Ajout des infos concernant le compte
														 P_var_cpta         IN FN_COMPTE.var_cpta%TYPE,
														 P_ide_cpt          IN FN_COMPTE.ide_cpt%TYPE,
														 P_ide_gest         IN FN_GESTION.ide_gest%TYPE,
														 P_ide_plan_aux     IN FN_CPT_AUX.ide_plan_aux%TYPE,
														 P_ide_cpt_aux      IN FN_CPT_AUX.ide_cpt_aux%TYPE,
														 -- MODIF SGN ANOVSR509 : 3.3-1.25 : ajout info ordo + bg
														 P_ide_ordo         IN FC_REGLEMENT.ide_ordo%TYPE,
														 P_cod_bud          IN FC_REGLEMENT.cod_bud%TYPE,
														 -- fin modif sgn
														 P_ide_reglt          IN FC_REGLEMENT.ide_reglt%TYPE ,
														 P_ide_lot_m      IN FC_REGLEMENT.ide_lot%TYPE
														)IS

-- MODIF SGN ANOVSR490 : 3.3-1.24 : Prise en compte des regles sur la justfication des comptes
--Cursor c_ref_piece_dso  is Select *
--											From FC_REF_PIECE
--											Where
--											    ide_poste      = P_Ide_Poste
-- 									  AND ide_ref_piece  = TO_NUMBER(P_ide_ref_piece)
-- 									  -- MODIF SGN ANOVA403 : ajout info tiers + piece non soldée
--  									  AND NVL(var_tiers, '@#@#-') = NVL(p_var_tiers_reglt, '@#@#-')
--  									  AND NVL(ide_tiers, '@#@#-') = NVL(p_ide_tiers_reglt, '@#@#-')
--  									  AND flg_solde = alertCTRL.t_extnon;
--  									  -- fin modif sgn
--
--Cursor c_ref_piece_ord is Select *
--											From FC_REF_PIECE
--											Where
--											    ide_poste      = P_Ide_Poste
--  									  AND ide_piece  = P_ide_ref_piece
--  									  -- MODIF SGN ANOVA403 : ajout info tiers
--  									  AND NVL(var_tiers, '@#@#-') = NVL(p_var_tiers_reglt, '@#@#-')
--  									  AND NVL(ide_tiers, '@#@#-') = NVL(p_ide_tiers_reglt, '@#@#-')
--  									  AND flg_solde = alertCTRL.t_extnon;
--  									  -- fin modif sgn
--
Cursor c_ref_piece_dso (p_flg_justif VARCHAR2, p_flg_justif_tiers VARCHAR2, p_flg_justif_cpt VARCHAR2) IS
                      SELECT *
											FROM FC_REF_PIECE
											WHERE
											    ide_poste      = P_Ide_Poste
  									  AND ide_ref_piece  = TO_NUMBER(P_ide_ref_piece)
  									  -- non solde
  									  AND flg_solde = 'N'
  									  -- justifie par piece
  									  AND p_flg_justif = 'O'
/* MODIF SGN ANOVSR490 : 3.3-1.26 : suppression des modifs de la 3.3-1.25
  									  -- gestion de la justification par tiers
  									  -- si le compte est suivi par tiers, on ne doit abonder la piece que si elle concerne une reference piece
                      -- dont le tiers est = du tiers parametré dans le modele de ligne
  									  AND ( p_flg_justif_tiers = alertCTRL.t_extnon OR
  									        ( p_flg_justif_tiers = alertCTRL.t_extoui AND
  									          var_tiers = p_var_tiers_reglt AND
  									          ide_tiers = p_ide_tiers_reglt
  									        )
  									      )
                      -- gestion de la justification par compte
                      -- si le compte est suivi par compte, on ne doit abonder la piece que si elle concerne une ligne d ecriture
                      -- dont le compte est = au compte parametré dans le modele de ligne
  									  AND ( p_flg_justif_cpt = alertCTRL.t_extnon OR
  									        ( p_flg_justif_cpt = alertCTRL.t_extoui AND
  									          --*ide_ref_piece IN ( SELECT ide_ref_piece
  									                             FROM fc_ligne
  									                             WHERE ide_poste = P_ide_poste
  									                               AND ide_gest = P_ide_gest
  									                               AND flg_cptab = alertCTRL.t_extoui
  									                               AND var_cpta = P_var_cpta
  									                               AND ide_cpt = P_ide_cpt
  									                           )--*
  									          -- On regarde s'il existe une ligne d ecriture
  									          -- referencée par la reference qu'on est en train de traiter, possedant une ligne
  									          -- sur le meme compte que celui du modele de ligne
  									          EXISTS (SELECT 1
  									                  FROM fc_ligne lig
                                      WHERE lig.ide_poste = P_ide_poste
                                        AND lig.ide_gest = P_ide_gest
                                        AND lig.ide_jal = fc_ref_piece.ide_jal
                                        AND lig.flg_cptab = alertCTRL.t_extoui
                                        AND lig.ide_ref_piece = fc_ref_piece.ide_ref_piece
                                        AND lig.var_cpta = P_var_cpta
                                        AND lig.ide_cpt = P_ide_cpt
                                      )
  									                   -- les comptes auxiliaires
  									          AND ( (P_ide_plan_aux IS NULL AND P_ide_cpt_aux IS NULL)
  									                OR ( ide_plan_aux = P_ide_plan_aux
  									                      AND ide_cpt_aux = P_ide_cpt_aux
  									                    )
									                )
  									         )
  									      )*/;


CURSOR c_ref_piece_ord (p_flg_justif VARCHAR2, p_flg_justif_tiers VARCHAR2, p_flg_justif_cpt VARCHAR2) IS
                      SELECT
                      DISTINCT --CBI-20050721-Ano LM08
                      FC_REF_PIECE.*
											FROM FC_REF_PIECE, FC_REGLEMENT
											WHERE
											    FC_REF_PIECE.ide_poste      = P_Ide_Poste
-- CBI-20041222-D-2
--  									  AND FC_REF_PIECE.ide_piece  = P_ide_ref_piece
  									  AND ((FC_REF_PIECE.ide_piece  = P_ide_ref_piece)
  									  OR (FC_REF_PIECE.cod_ref_piece = P_ide_ref_piece))
  									  -- MODIF SGN ANOVSR509 : 3.3-1.25 : on inclue le cod ref piece dans les critere de recherche
--  									  AND FC_REF_PIECE.cod_ref_piece = p_ide_ordo||'-'||p_cod_bud||'-'||p_ide_gest||'-'||'OD'||'-'||P_ide_ref_piece


/* il faut tenir compte de l'ajout de NUMLIG dans le code référence pièce*/
--CBI-20050502-D LOLF
--  									  AND FC_REF_PIECE.cod_ref_piece = p_ide_ordo||'-'||p_cod_bud||'-'||p_ide_gest||'-'||'OD'||'-'||P_ide_ref_piece
--  									  AND ((FC_REF_PIECE.cod_ref_piece = p_ide_ordo||'-'||p_cod_bud||'-'||p_ide_gest||'-'||'OD'||'-'||P_ide_ref_piece)
                      AND ((INSTR(FC_REF_PIECE.cod_ref_piece, p_ide_ordo||'-'||p_cod_bud||'-'||p_ide_gest||'-'||'OD'||'-'||P_ide_ref_piece) > 0)
--CBI-20050502-F LOLF
  									  OR (FC_REF_PIECE.cod_ref_piece = P_ide_ref_piece))
-- CBI-20041222-F-2
  									  -- non solde
  									  AND FC_REF_PIECE.flg_solde = 'N'
  									  -- justifie par piece
  									  AND p_flg_justif = 'O'
  									  /* LGD - 07/01/2004 - ANOGAR572 - Pb de gestion des lots. */
  									  AND FC_REGLEMENT.ide_tiers = FC_REF_PIECE.ide_tiers
                      AND FC_REGLEMENT.var_tiers = FC_REF_PIECE.var_tiers
-- CBI-20041214-D-1
-- Evo FA0043 - Début FDUB le 17/08/2005
                      -- AND ((FC_REF_PIECE.ide_piece  = FC_REGLEMENT.ide_piece)
                      AND ((FC_REF_PIECE.ide_piece  = FC_REGLEMENT.cod_ref_piece)
-- Evo FA0043 - Fin FDUB le 17/08/2005
-- CBI-20041222-D-2
-- Evo FA0043 - Début FDUB le 17/08/2005
                      -- OR (FC_REF_PIECE.cod_ref_piece = FC_REGLEMENT.ide_piece))
                      OR (FC_REF_PIECE.cod_ref_piece = FC_REGLEMENT.cod_ref_piece))
-- Evo FA0043 - Fin FDUB le 17/08/2005
-- CBI-20041222-F-2
-- CBI-20041214-F-1
                      AND FC_REGLEMENT.ide_lot =P_ide_lot_m
											/* MODIF SGN ANOVSR490 : 3.3-1.26 :  suppression des modifs de la 3.3-1.25
  									  -- gestion de la justification par tiers
  									  -- si le compte est suivi par tiers, on ne doit pas abonder la piece que si elle concerne une reference piece
                      -- dont le tiers est = au tiers parametré dans le modele de ligne
  									  AND ( p_flg_justif_tiers = 'N' OR
  									        ( p_flg_justif_tiers = 'O' AND
  									          var_tiers = p_var_tiers_reglt AND
  									          ide_tiers = p_ide_tiers_reglt
  									        )
  									      )
                      -- gestion de la justification par compte
											-- si le compte est suivi par compte, on ne doit abonder la piece que si elle concerne une ligne d ecriture
                      -- dont le compte est = au compte parametré dans le modele de ligne
                      AND ( p_flg_justif_cpt = 'N' OR
  									        ( p_flg_justif_cpt = 'O' AND
  									          --*ide_ref_piece IN ( SELECT ide_ref_piece
  									                             FROM fc_ligne
  									                             WHERE ide_poste = P_ide_poste
  									                               AND ide_gest = P_ide_gest
  									                               AND flg_cptab = 'O'
  									                               AND var_cpta = P_var_cpta
  									                               AND ide_cpt = P_ide_cpt
  									                           )
  									          --*
  									          -- On regarde s'il existe une ligne d ecriture
  									          -- referencée par la reference qu'on est en train de traiter, possedant une ligne
  									          -- sur le meme compte que celui du modele de ligne

   									          EXISTS (SELECT 1
  									                  FROM fc_ligne lig
                                      WHERE lig.ide_poste = P_ide_poste
                                        AND lig.ide_gest = P_ide_gest
                                        AND lig.ide_jal = fc_ref_piece.ide_jal
                                        AND lig.flg_cptab = 'O'
                                        AND lig.ide_ref_piece = fc_ref_piece.ide_ref_piece
                                        AND lig.var_cpta = P_var_cpta
                                        AND lig.ide_cpt = P_ide_cpt
                                      )
  									          -- les comptes auxiliaires
  									          AND ( (P_ide_plan_aux IS NULL AND P_ide_cpt_aux IS NULL)
  									                OR ( ide_plan_aux = P_ide_plan_aux
  									                      AND ide_cpt_aux = P_ide_cpt_aux
  									                    )
									                )
  									         )
  									      )*/
  									      -- MCE le 31/10/2007 :ANO121 : ajout identifiant reglement dans appel CTL_GESTION _DEVISE
  									      AND fc_reglement.ide_reglt = p_ide_reglt;


v_flg_justif SR_CODIF.cod_codif%TYPE;
v_flg_justif_tiers SR_CODIF.cod_codif%TYPE;
v_flg_justif_cpt SR_CODIF.cod_codif%TYPE;

v_lig_flg_justif_tiers SR_CODIF.cod_codif%TYPE;
v_lig_flg_justif_cpt SR_CODIF.cod_codif%TYPE;

v_lig_ide_tiers FC_LIGNE.ide_tiers%TYPE;
v_lig_var_tiers FC_LIGNE.var_tiers%TYPE;
v_lig_ide_cpt FC_LIGNE.ide_cpt%TYPE;
v_lig_var_cpta FC_LIGNE.var_cpta%TYPE;
v_lig_ide_plan_aux FC_LIGNE.ide_plan_aux%TYPE;
v_lig_ide_cpt_aux FC_LIGNE.ide_cpt_aux%TYPE;
v_test    FC_REGLEMENT.ide_tiers%TYPE;

v_ret NUMBER;
-- Fin modif sgn ANOVSR490 : 3.3-1.24


v_extDS SR_CODIF.cod_codif%TYPE;
v_extO SR_CODIF.cod_codif%TYPE;



BEGIN

-- Début HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048 : Suppression de l'initialisation
-- P_Creation_Ligne := TRUE;
-- Fin HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048

-- Si aucune reference piece n est trouve, on devra retourner null comme sens
-- de maniere a recupere le sens de la ligne
P_sens := NULL;

-- MODIF SGN ANOVSR490 : 3.3-1.24 : prise en compte des justification piece, tiers et compte lors
-- de la recuperation de la piece
BEGIN
  SELECT flg_justif, flg_justif_tiers, flg_justif_cpt
  INTO v_flg_justif, v_flg_justif_tiers, v_flg_justif_cpt
  FROM fn_compte
  WHERE var_cpta = P_var_cpta
    AND ide_cpt = P_ide_cpt;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
	--  v_ret := alert_fonctionnelle(631, '', '', '');
	  RAISE;
	WHEN OTHERS THEN
	 -- v_ret := alert_fonctionnelle (105, sqlerrm, '', '');
	  RAISE;
END;


-- fin modif sgn 3.3-1.24

IF P_cod_orig_reglt = 'DSO' THEN

--alert_message(1, 'SGN: reglement suite a dso ');

  For v_ref_piece in c_ref_piece_dso(v_flg_justif, v_flg_justif_tiers, v_flg_justif_cpt)
  Loop

    P_Ref_piece := v_ref_piece;

   -- If v_ref_piece.ide_devise = P_ide_devise Then  -- Devise de la pièce = devise de la ligne de l'écriture
	if nvl(v_ref_piece.ide_devise,'EUR') = nvl(P_ide_devise,'EUR') Then

--alert_message(1, 'SGN: devise existante');

      -- MODIF SGN ANOVSR490 : 3.3-1.26 : on controle la justification du compte de la piece a abonder
     -- ANO 121 :message 916 : ajout récupération des variables v_lig_ide_cpt_aux		et v_lig_ide_cpt_aux dans le SELECT							--

      BEGIN
        SELECT lig.ide_tiers, lig.var_tiers, lig.ide_cpt, lig.var_cpta, cpt.flg_justif_cpt, cpt.flg_justif_tiers, lig.ide_cpt_aux, lig.ide_plan_aux
        INTO v_lig_ide_tiers, v_lig_var_tiers, v_lig_ide_cpt, v_lig_var_cpta, v_lig_flg_justif_cpt, v_lig_flg_justif_tiers, v_lig_ide_cpt_aux, v_lig_ide_plan_aux
  	    FROM fc_ligne lig, fn_compte cpt
        WHERE lig.ide_poste = v_ref_piece.ide_poste
          AND lig.ide_gest = v_ref_piece.ide_gest
          AND lig.ide_jal = v_ref_piece.ide_jal
          AND lig.flg_cptab = 'O'
          AND lig.ide_ref_piece = v_ref_piece.ide_ref_piece
          AND lig.ide_ecr = v_ref_piece.ide_ecr
          AND lig.ide_lig = v_ref_piece.ide_lig
          AND lig.var_cpta = cpt.var_cpta
          AND lig.ide_cpt = cpt.ide_cpt;
      EXCEPTION
      	WHEN OTHERS THEN
      	--  v_ret := alert_fonctionnelle (105, sqlerrm, '', '');
      	  RAISE;
      END;

      -- Verif justif compte du compte de la ligne a abonder et du compte du modele de ligne associe au reglement
      IF v_lig_flg_justif_cpt = 'O' OR
      	 v_flg_justif_cpt = 'O' THEN
      	IF v_lig_var_cpta != P_var_cpta OR
      		 v_lig_ide_cpt != P_ide_cpt OR
      		 NVL(v_lig_ide_cpt_aux,'NULL') != NVL(v_ref_piece.ide_cpt_aux, 'NULL') OR
      		 NVL(v_lig_ide_plan_aux,'NULL') != NVL(v_ref_piece.ide_plan_aux,'NULL') THEN

      		-- v_ret := alert_fonctionnelle(916, '', '', '');
      		 NULL;
      	END IF;
      END IF;

      -- Verif justif tiers du compte de la ligne a abonder et de la ligne qui abonde
      IF v_lig_flg_justif_tiers = 'O' OR
      	 v_flg_justif_tiers = 'O' THEN
      	IF v_lig_var_tiers != P_var_tiers_reglt OR
      		 v_lig_ide_tiers != P_ide_tiers_reglt THEN
      		-- v_ret := alert_fonctionnelle(917, '', '', '');
      		 NULL;
      	END IF;
      END IF;

      -- Fin modif sgn ANOVSR490 : 3.3-1.26


      -- MODIF SGN ANOVA145 : Recuperation du sens de la reference piece deja existante pour
      -- cette devise,
      -- Si le montant credit est superieur ou egal au montant debit alors le sens est Credit
      -- sinon le sens est debit.
--      IF v_ref_piece.mt_cr >= v_ref_piece.mt_db THEN
--        P_sens := alertCTRL.t_extcr;
--      ELSE
--        P_sens := alertCTRL.t_extdb;
--      END IF;
      -- fin modif sgn

-- Début HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048 : Renommage du paramètre
--      P_Creation_Ligne   := FALSE;
      P_Autre_Devise := FALSE;
-- Fin HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048

--alert_message(1, 'SGN: p_creation = false');
--      Exit;

-- Début HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048 : Rajout de l'affectation à TRUE si la devise est différente
    ELSE
      P_Autre_Devise := TRUE;
-- Fin HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048

    End if;

 		-- Début VBA le 06/04/2006 - Correction anomalie V35b-3E-LM033 : Déplacement de ce bout de code. Il est commun et
		--                                                                doit être exécuté que la devise soit la même ou pas
    -- MODIF SGN ANOVA145 : Recuperation du sens de la reference piece deja existante pour
    -- cette devise,
    -- Si le montant credit est superieur ou egal au montant debit alors le sens est Credit
    -- sinon le sens est debit.
    IF v_ref_piece.mt_cr >= v_ref_piece.mt_db THEN
      P_sens := 'C';
    ELSE
      P_sens := 'D';
    END IF;
    -- fin modif sgn
		-- Fin VBA le 06/04/2006 - Correction anomalie V35b-3E-LM033 : Déplacement de ce bout de code. Il est commun et

  End loop;

-- Dans tous les autres cas (saisie, mes, ordonnance)
ELSE

--alert_message(1, 'SGN: reglement autre');

  For v_ref_piece in c_ref_piece_ord(v_flg_justif, v_flg_justif_tiers, v_flg_justif_cpt)
  Loop

    P_Ref_piece := v_ref_piece;

    If nvl(v_ref_piece.ide_devise,'EUR') = nvl(P_ide_devise,'EUR') Then  -- Devise de la pièce = devise de la ligne de l'écriture

--alert_message(1, 'SGN: devise existante');

      -- MODIF SGN ANOVSR490 : 3.3-1.26 : on controle la justification du compte de la piece a abonder
      -- ANO 121 :message 916 : ajout récupération des variables v_lig_ide_cpt_aux		et v_lig_ide_cpt_aux dans le SELECT							--

      BEGIN
        SELECT lig.ide_tiers, lig.var_tiers, lig.ide_cpt, lig.var_cpta, cpt.flg_justif_cpt, cpt.flg_justif_tiers, lig.ide_cpt_aux, lig.ide_plan_aux
        INTO v_lig_ide_tiers, v_lig_var_tiers, v_lig_ide_cpt, v_lig_var_cpta, v_lig_flg_justif_cpt, v_lig_flg_justif_tiers, v_lig_ide_cpt_aux,v_lig_ide_plan_aux
  	    FROM fc_ligne lig, fn_compte cpt
        WHERE lig.ide_poste = v_ref_piece.ide_poste
          AND lig.ide_gest = v_ref_piece.ide_gest
          AND lig.ide_jal = v_ref_piece.ide_jal
          AND lig.flg_cptab = 'O'
          AND lig.ide_ref_piece = v_ref_piece.ide_ref_piece
          AND lig.ide_ecr = v_ref_piece.ide_ecr
          AND lig.ide_lig = v_ref_piece.ide_lig
          AND lig.var_cpta = cpt.var_cpta
          AND lig.ide_cpt = cpt.ide_cpt;
      EXCEPTION
      	WHEN OTHERS THEN
      	--  v_ret := alert_fonctionnelle (105, sqlerrm, '', '');
      	  NULL;
      END;

      -- Verif justif compte du compte de la ligne a abonder et du compte du modele de ligne associe au reglement
      IF v_lig_flg_justif_cpt = 'O' OR
      	 v_flg_justif_cpt = 'O' THEN
      	IF v_lig_var_cpta != P_var_cpta OR
      		 v_lig_ide_cpt != P_ide_cpt OR
      		 NVL(v_lig_ide_cpt_aux,'NULL') != NVL(v_ref_piece.ide_cpt_aux, 'NULL') OR
      		 NVL(v_lig_ide_plan_aux,'NULL') != NVL(v_ref_piece.ide_plan_aux,'NULL') THEN

      		-- v_ret := alert_fonctionnelle(916, '', '', '');
      		 NULL;
      	END IF;
      END IF;

      -- Verif justif tiers du compte de la ligne a abonder et de la ligne qui abonde
      IF v_lig_flg_justif_tiers = 'O' OR
      	 v_flg_justif_tiers = 'O' THEN

      	IF v_lig_var_tiers != P_var_tiers_reglt OR
      		 v_lig_ide_tiers != P_ide_tiers_reglt THEN
      		-- v_ret := alert_fonctionnelle(917, '', '', '');
      		 v_test:=P_var_tiers_reglt;
      	END IF;
      END IF;

      -- Fin modif sgn ANOVSR490 : 3.3-1.26

      -- MODIF SGN ANOVA145 : Recuperation du sens de la reference piece deja existante pour
      -- cette devise,
      -- Si le montant credit est superieur ou egal au montant debit alors le sens est Credit
      -- sinon le sens est debit.
--
-- Début HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048 : Déplacement de ce bout de code. Il est commun et
--                                                                doit être exécuté que la devise soit la même ou pas
--      IF v_ref_piece.mt_cr >= v_ref_piece.mt_db THEN
--        P_sens := alertCTRL.t_extcr;
--      ELSE
--        P_sens := alertCTRL.t_extdb;
--      END IF;
-- Fin HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048
--
      -- fin modif sgn

-- Début HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048 : Renommage du paramètre
--      P_Creation_Ligne   := FALSE;
      P_Autre_Devise := FALSE;
-- Fin HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048

--alert_message(1, 'SGN: p_creation = false');
-- Début VBA le 05/04/2006 - Correction anomalie V35b-3E-LM033 : Pb d'abondement d'une piece, P_sens doit être renseigné
--      Exit;
-- Fin VBA le 05/04/2006 - Correction anomalie V35b-3E-LM033 : Pb d'abondement d'une piece, P_sens doit être renseigné


-- Début HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048 : Rajout de l'affectation à TRUE si la devise est différente
    ELSE
      P_Autre_Devise   := TRUE;
-- Fin HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048

    End if;

-- Début HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048 : Déplacement de ce bout de code. Il est commun et
--                                                                doit être exécuté que la devise soit la même ou pas
    IF v_ref_piece.mt_cr >= v_ref_piece.mt_db THEN
      P_sens := 'C';
    ELSE
      P_sens := 'D';
    END IF;
-- Fin HPEJ le 20/02/2006 - Correction anomalie V35-DIT44-048


  End loop;

END IF;

--alert_message(1, 'fin ctl_piece devise');
END TEST_DEVISE;

/

CREATE OR REPLACE PROCEDURE          TEST_MES IS


 v_retour NUMBER;
 v_nummess FM_MESSAGE.IDE_MESS%TYPE;
 v_num_lig_mess number;


 BEGIN
 /* Initialisation des globales nécessaires aux fonctions du MES */
	 	-- v_retour := MES.FINI_PACKAGE('P','503','2016','14/04/2016');
         v_retour := MES.FINI_PACKAGE('P','603C','2016','14/04/2016');
		/* IF v_retour < 0 THEN
			aff_mess('E', 0307, 'u621_010b.sql', null, null, null);
			RAISE EXIT_ERROR;
	     END IF;   */

		 /* récupération du numéro de message */
		 v_nummess :=MES.FBOR_INI(3,'O','DF24001',null,100,'2016','Ordonnances 603C du 14/04/2016');
         
         --v_nummess := MES.FBOR_INI(3,100);
	   /*  IF v_nummess  < 0 THEN
			aff_mess('E', 0313, 'u621_010b.sql',null, null, null);
			RAISE EXIT_ERROR;
	     END IF;   */
		 v_num_lig_mess := 0; 	-- SNE, 10/08/2001 : On initialise le compteur de ligne pour le message
		-- trace('N° de message d''ordonnance = '||'<'||v_nummess||'>');

		 /* Association du destinataire à l'émetteur du message */
	  	 --v_retour := MES.FDEST_ADD('P','503',v_nummess,'R','P','503');
         v_retour := MES.FDEST_ADD('P','603C',v_nummess,'R','P','603');
         
	    /* IF v_retour != 0 THEN
			aff_mess('E', 0307, 'u621_010b.sql', null, null, null);
			RAISE EXIT_ERROR;
		 END IF;  */

END; 

/

CREATE OR REPLACE PROCEDURE U420_110B(p_ide_poste    rm_poste.ide_poste%TYPE,
                                      p_ide_gest     fn_gestion.ide_gest%TYPE,
									  p_ide_lot      FC_REGLEMENT.ide_lot%TYPE,
									  p_ret          IN OUT NUMBER) IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : REF
-- Nom           : U420_110B
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 26/06/2002
-- ---------------------------------------------------------------------------
-- Role          : Génération du fichier standard des reglements apres la mise en
--                 reglement d'un lot et appel du module de mise en forme associé
--                 au mode de règlement. Le repertoire qui recoit le fichier doit
--                 avoir les droit en ecriture.
--
-- Parametres  entree  :
-- 				 1 - p_ide_poste : identifiant du poste comptable du contexte
--				 2 - p_ide_gest : identifiant de la gestion du contexte
--				 3 - p_ide_lot : identifiant du lot de reglement a traiter
--
-- Parametre sorties :
--				 3 - p_ret : le retour  1 => OK
--				   	 	   	 		   -1 => probleme de parametre (SR_PARAM)
-- 									   -2 => probleme de recuperation du module de mise en forme
-- 									   -3 => probleme lors de l execution module de mise en forme
--                                                       -4 => probleme lors du calcul de l arrondi
--
-- ---------------------------------------------------------------------------
--  Version        : @(#) U420_110B.sql version 3.5-1.3  SGN
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) U420_110B.sql 3.0-1.0	|25/06/2002| SGN	| Création
-- @(#) U420_110B.sql 3.0-1.1	|22/07/2002| SGN	| FCT47 : Lors de l'appel a ASTERè_ENV_PARAM, les separateurs
--                                                retournés ont un espace. On utilise ltrim et rtrim pour les supprimer
-- @(#) U420_110B.sql 3.0d-1.2|03/01/2003| SGN	| ANOVA262 : Les montants en devise doivent avoir 3 decimales
-- @(#) U420_110B.sql 3.5-1.3 |24/11/2003| SGN	| ANOGAR524 : Le fichier des reglement doit etre genere en mode ecriture
-- 	----------------------------------------------------------------------------------------------------------
*/

/*****************************************************************************************
-- UNILOG                                                                               --
-- ************************************************************************************ --
-- Composant : U420_110B                                                                --
-- Remarque  : Depuis l'utilisation de WinCVS pour la gestion de  configuration, les    --
--             composants repartent en version 1.1                                      --
-- Version utilisée : v1.1 ou ASTER v3.4 (non modifié par patch)                        --
-- ------------------------------------------------------------------------------------ --
-- Date : 31/01/2005                Auteur : HPEJ               Version : v1.2          --
--                                                                                      --
-- Modification : Correction anomalie DI44-117                                          --
--                Si la base contient 2 gestions différentes qui ont toutes les deux un --
--                même numéro de lot, la mise en règlement d¿un lot prend, à tort, les  --
--                règlements des 2 lots quelle que soit la gestion.                     --
--                Il faut donc rajouter, dans le curseur c_reglt, les critères sur le   --
--                poste et la gestion.                                                  --
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --
-- 08/08/2005 (UNILOG - RDU) - V3.5A-1.1 : Ajout des zones LIB_OBJET_REGLT, NOM, PRENOM, ADR1, ADR2, ADR3, ADR4, VILLE, CP, BP, PAYS lors de la constitution de « v_ligne_std_reglt »
-- Evo FA0043
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --
*****************************************************************************************/

	   v_ret NUMBER;
	   v_ligne_std_reglt VARCHAR2(1024);
	   v_nom_fichier VARCHAR2(120);
	   v_rep VARCHAR2(120);
   	   v_command VARCHAR2(1024);
	   v_mod_reglt FC_REGLEMENT.ide_mod_reglt%TYPE;
	   v_ide_remise FC_REGLEMENT.ide_remise%TYPE;
	   v_module PC_REMISE.lib_trait%TYPE;
	   v_param1 VARCHAR2(120);
   	   v_param2 VARCHAR2(120);
	   v_param3 VARCHAR2(120);
	   v_param4 VARCHAR2(120);
	   v_param5 VARCHAR2(120);
	   v_separateur VARCHAR2(2);
  	   v_sep_path VARCHAR2(2);
         -- MODIF SGN ANOVA262
         v_mt FC_REGLEMENT.mt%TYPE;
         v_mt_dev FC_REGLEMENT.mt_dev%TYPE;
         -- fin modif sgn

       PARAM_EXCEPTION EXCEPTION;
       REMISE_EXCEPTION EXCEPTION;
       EXEC_EXCEPTION EXCEPTION;
       -- MODIF SGN ANOVA262
       ROUND_EXCEPTION EXCEPTION;


	   -- Recuperation des reglements du lot passe en parametre
	   CURSOR c_reglt IS
		   SELECT t1.*,
		   -- RDU-20050812-debut FA0043 : Récupération des paramètres liés au tiers
		   t2.nom, t2.prenom, t2.adr1, t2.adr2, t2.adr3, t2.adr4,
		   t2.ville, t2.cp, t2.bp, t2.pays
		   -- RDU-20050812-Fin
		 FROM FC_REGLEMENT t1
		     ,RB_TIERS t2 --RDU-20050812-evo FA0043: ajout
		 WHERE t1.ide_lot = p_ide_lot
-- RDU-20050812-debut FA0043 : Récupération des paramètres liés au tiers
   		   AND t1.var_tiers = t2.var_tiers
   		   AND t1.ide_tiers = t2.ide_tiers
-- RDU-20050812-Fin
-- Début HPEJ - correction anomalie DI44-117 : Rajout des critères de sélection sur le poste et la gestion
		   AND t1.ide_gest = p_ide_gest
		   AND t1.ide_poste = p_ide_poste;
-- Fin HPEJ - correction anomalie DI44-117


	v_existe NUMBER := 0; -- MODIF SGN ANOGAR524 : 3.5-1.3 :

BEGIN

	 -- Recuperation du repertoire qui recevra le fichier reglement standard
	 EXT_PARAM('IR0050', v_rep, v_ret);
	 IF v_ret != 1 THEN
	 	RAISE PARAM_EXCEPTION;
	 END IF;

	 -- Recuperation du separateur de fichier
	 v_ret := ASTER_ENV_PARAM(v_separateur, v_sep_path);
     -- MODIF SGN FCT47 : Suppression des eventuels espace avant et apres les separateurs
	 v_separateur := ltrim(rtrim(v_separateur));
 	 v_sep_path := ltrim(rtrim(v_sep_path));

 	 -- Determination du nom du fichier
	 v_nom_fichier := v_rep||v_separateur||p_ide_poste||'_'||p_ide_gest||'_'||p_ide_lot;
	 --dbms_output.put_line ('file:'||v_nom_fichier);

	 -- Parcour des reglements pour constitution du fichier

       v_existe := 0; -- MODIF SGN ANOGAR524 : 3.5-1.3 :

	 FOR cur_reglt in c_reglt
	 LOOP

          -- MODIF SGN ANOVA262
          v_ret := CAL_round_mt(cur_reglt.mt, v_mt);
          IF v_ret != 1 THEN
            RAISE ROUND_EXCEPTION;
          END IF;

          v_ret := CAL_round_mt_dev(cur_reglt.mt_dev, v_mt_dev);
          IF v_ret != 1 THEN
            RAISE ROUND_EXCEPTION;
          END IF;
          -- Fin modif sgn

		-- Recuperation des infos
	    v_ligne_std_reglt := '"'||cur_reglt.ide_poste||'"@'||
						   	  '"'||cur_reglt.ide_gest||'"@'||
							  '"'||cur_reglt.ide_lot||'"@'||
							  '"'||cur_reglt.ide_reglt||'"@'||
							  '"'||cur_reglt.ide_mod_reglt||'"@'||
							  '"'||cur_reglt.ide_remise||'"@'||
							  '"'||cur_reglt.cod_orig_reglt||'"@'||
							  '"'||cur_reglt.cod_bud||'"@'||
							  '"'||cur_reglt.ide_ordo||'"@'||
							  '"'||cur_reglt.ide_tiers||'"@'||
							  '"'||cur_reglt.nom_bq||'"@'||
							  '"'||cur_reglt.cpt_bq||'"@'||
							  '"'||v_mt||'"@'|| -- MODIF SGN ANOVA262 : '"'||cur_reglt.mt||'"@'||
							  '"'||cur_reglt.ide_devise||'"@'||
							  '"'||v_mt_dev||'"@'|| -- MODIF SGN ANOVA262 : '"'||cur_reglt.mt_dev||'"@'||
							  '"'||cur_reglt.dat_echeance||'"@'||
							  -- RDU-20050808-D : evo FA0043 : Remplacement ide_piece par cod_ref_piece
							  '"'||cur_reglt.cod_ref_piece||'"@'||
							  -- '"'||cur_reglt.ide_piece||'"@'||
							  -- RDU-20050808-F
							  '"'||cur_reglt.dat_reference||'"@'||
							  -- RDU-20050808-D : evo FA0043 : Ajout d'une nouvelle zone
							  '"'||cur_reglt.lib_objet_reglt||'"@'||
							  -- RDU-20050808-F
							  -- RDU-20050808-D : evo FA0043 : Ajout de 10 nouvelles zones
							  '"'||cur_reglt.nom||'"@'||
							  '"'||cur_reglt.prenom||'"@'||
							  '"'||cur_reglt.adr1||'"@'||
							  '"'||cur_reglt.adr2||'"@'||
							  '"'||cur_reglt.adr3||'"@'||
							  '"'||cur_reglt.adr4||'"@'||
							  '"'||cur_reglt.ville||'"@'||
							  '"'||cur_reglt.cp||'"@'||
							  '"'||cur_reglt.bp||'"@'||
							  '"'||cur_reglt.pays||'"@';
							  -- RDU-20050808-F

		-- Recuperation du mode de reglement et de l etablissement de remise
		v_mod_reglt := cur_reglt.ide_mod_reglt;
		v_ide_remise := cur_reglt.ide_remise;

		-- Enregistrement dans le fichier
		-- MODIF SGN ANOGAR524 : 3.5-1.3 : on doit ecraser le fichier s'il existe et s'il s'agit de la premiere ligne : v_ret := piaf_ecrit_fichier(v_ligne_std_reglt, v_nom_fichier);
            IF v_existe = 0 THEN
              v_ret := piaf_ecrit_fichier(v_ligne_std_reglt, v_nom_fichier, 'w+');
              v_existe := 1;
            ELSE
              v_ret := piaf_ecrit_fichier(v_ligne_std_reglt, v_nom_fichier);
            END IF;
            -- fin modif sgn 3.5-1.3


		--dbms_output.put_line ('ret:'||v_ret);


	 END LOOP;

	 -- Gestion de la mise en forme du reglement standard

	 -- Recuperation du module de mise en forme et ses parametres.
	 BEGIN
	 	   SELECT lib_trait, libn1, libn2, libn3, libn4, libn5
		   INTO v_module, v_param1, v_param2, v_param3, v_param4, v_param5
		   FROM PC_REMISE
		   WHERE ide_mod_reglt = v_mod_reglt
		     AND ide_remise = v_ide_remise;
	 EXCEPTION
	 	   WHEN NO_DATA_FOUND THEN
--	 	   WHEN OTHERS THEN
		   		RAISE REMISE_EXCEPTION;
	 END;
	 --dbms_output.put_line('mod reg:'||v_mod_reglt||' ide_rem:'||v_ide_remise);

	 -- Recuperation des parametre si on a %f il s agit du fichier std genere
	 IF v_param1 = '%f' THEN
	 	v_param1 := v_nom_fichier;
	 END IF;

	 IF v_param2 = '%f' THEN
	 	v_param2 := v_nom_fichier;
	 END IF;

	 IF v_param3 = '%f' THEN
	 	v_param3 := v_nom_fichier;
	 END IF;

	 IF v_param4 = '%f' THEN
	 	v_param4 := v_nom_fichier;
	 END IF;

	 IF v_param5 = '%f' THEN
	 	v_param5 := v_nom_fichier;
	 END IF;

	 -- Lancement du module

	 -- Constitution de la commande
	 v_command := v_module||' '||v_param1||' '||v_param2||' '||v_param3||' '||v_param4||' '||v_param5;
	 --dbms_output.put_line('command:'||v_command);

	 -- Execution de la commande (coté serveur)
	/*v_ret := ASTER_executer_commande(v_command, '', v_nom_fichier||'.log');
	 IF v_ret != 0 THEN
	 	RAISE EXEC_EXCEPTION;
	 END IF;
	 --dbms_output.put_line(' ret:'||v_ret);*/

	 p_ret := 1;

EXCEPTION
     WHEN PARAM_EXCEPTION THEN
	 	  p_ret := -1;
     WHEN REMISE_EXCEPTION THEN
	 	  p_ret := -2;
     WHEN EXEC_EXCEPTION THEN
	 	  p_ret := -3;
     WHEN ROUND_EXCEPTION THEN
	 	  p_ret := -4;
     WHEN OTHERS THEN
		  raise;
END;

/

CREATE OR REPLACE PROCEDURE U521_010B_MAIN(p_ide_poste    rm_poste.ide_poste%TYPE := NULL,
                                           p_ide_gest     fn_gestion.ide_gest%TYPE := NULL,
                                           p_dat_jc       fc_calend_hist.dat_jc%TYPE := NULL,
                                           p_cod_typ_nd   rm_poste.cod_typ_nd%TYPE := NULL) IS

/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : MES
-- Nom           : U521_010B
-- ---------------------------------------------------------------------------
--  Auteur         : Sofiane NEKERE (Sema)
--  Date creation  : 23/12/1999
-- ---------------------------------------------------------------------------
-- Role          : Diffusion des mouvements budgetaires
--
-- Parametres    :
 P_IDE_POSTE
--                  1.- p_ide_poste : Poste comptable
--                  1.- P_IDE_GEST  : Gestion
--                  2.- P_DAT_JC  : Journee comptable
--                  3.- P_COD_TYP_ND  : Type de noeud
--
--
-- Valeurs retournees :
--
-- Appels		 :
-- ---------------------------------------------------------------------------
--  Version        : @(#) U521_010B.sql version 2.1-1.4 : SGN : 03/10/2001
-- ---------------------------------------------------------------------------
--
-- -----------------------------------------------------------------------------------------------------
-- Fonction			|Date	     |Initiales	|Commentaires
-- -----------------------------------------------------------------------------------------------------
-- @(#) U521_010B.sql 1.0-1.0	|-23/12/1999 | SNE	| Création
-- @(#) U521_010B.sql 1.0-1.0	|06/01/2000  | SNE	| Prise en compte de la fiche de question 104
-- @(#) U521_010B.sql 1.0-1.0	|24/01/2000  | SNE	| Implantation de l'édition du bordereau des mvts transmis
-- @(#) U521_010B.sql 2.0-1.1	|13/04/2000  | LMA	| Traiter diffusion message par message
-- @(#) U521_010B.sql 2.1-1.2	|13/09/2001  | SNE	| Modification appel FDATA_ADD Suite à ano 13 et 14
-- @(#) U521_010B.sql 2.1-1.3	|20/09/2001  | SGN	| Correction ANO217 Ajout du controle de la table des assignations pour la gestion recuperee.
-- @(#) U521_010B.sql 2.1-1.4 	|03/10/2001  | SGN	| Correction ANO011 Changement de l'appel a GES_LANCER_TRAITEMENT on utilise le separateur '(#$#)'
-- @(#) U521_010B.sql 2.1-1.5 	|04/09/2002  | LGD	| Ajout de nouveaux champs de la table FB_MVT_BUD
-- @(#) U521_010B.sql 4.0-1.0	|24/10/2005  | RDU	| Modification appel FDATA_ADD Suite à anomalie lors du portage	vers Oracle 9i
-- @(#) U521_010B.sql 4241	|04/04/2008  | FBT	| Correction de l'ano 244 - on diffuse uniquement les mouvements visé.
-- @(#) U521_010B.sql v4260     |15/05/2008  | PGE      | evol_DI44_2008_014 Controle sur les dates de validité de fn_lp_rpo
-- ----------------------------------------------------------------------------------------------------------
*/

  CURSOR c_mvt_a_diffuser(pc_codtypposte   rm_poste.cod_typ_nd%TYPE,
                          pc_statut        fm_rnl_me.cod_statut%TYPE,
			  pc_statut_vi 	   fb_mvt_bud.cod_statut%TYPE ) IS
    SELECT MVT.ide_poste,
           MVT.cod_typ_nd_emet,
           MVT.ide_nd_emet,
           MVT.ide_mess,
           MVT.flg_emis_recu,
           MVT.num_mvt_bud,
           MVT.num_lig,
           MVT.ide_ope,
           MVT.ide_gest,
           MVT.cod_bud,
           MVT.cod_typ_bud,
           MVT.ide_poste_assig,
           MVT.ide_ordo,
           MVT.cod_nat_mvt,
           MVT.var_bud,
           MVT.ide_lig_prev,
           MVT.cod_ope,
           MVT.mt,
           MVT.dat_ref,
           MVT.dat_diff,
           MVT.support,
           MVT.num_mvt_init,
           MVT.cod_orig_benef,
           MVT.ide_mess_dest,
           MVT.dat_cre,
           MVT.uti_cre,
           MVT.dat_maj,
           MVT.uti_maj,
           MVT.terminal,
		   /*
           -- LGD,04/09/2002 : Ajout de nouveaux champs de la table FB_MVT_BUD
           */
		   MVT.ide_service,
		   MVT.dat_p_compte,
		   /*
           -- Fin de modification
           */
           EXT_poste_assign(MVT.ide_ordo,
                            MVT.cod_bud,
                            MVT.cod_typ_bud,
                            MVT.ide_gest,
                            MVT.ide_lig_prev)   AS POSTE_ASSIGN,
           MVT.ROWID                            AS ROW_ID
    FROM fb_mvt_bud MVT,fm_rnl_me RNLME
    WHERE RNLME.cod_typ_nd_emet = MVT.cod_typ_nd_emet
      AND RNLME.ide_nd_emet = MVT.ide_nd_emet
      AND RNLME.ide_mess = MVT.ide_mess
      AND RNLME.flg_emis_recu = MVT.flg_emis_recu
      AND RNLME.cod_typ_nd_dest = pc_codtypposte
      AND RNLME.ide_nd_dest = MVT.ide_poste
      AND RNLME.cod_statut = pc_statut
      AND MVT.ide_poste_assig IS NULL
      AND MVT.dat_diff is null
      -- FBT le 04/04/2008 - ANO 244 - Uniquement les mouvements visés
      AND MVT.cod_statut = pc_statut_vi
    ORDER BY MVT.cod_typ_nd_emet,
             MVT.ide_nd_emet,
             MVT.ide_mess,
             MVT.flg_emis_recu,
             EXT_poste_assign(MVT.ide_ordo,
                              MVT.cod_bud,
                              MVT.cod_typ_bud,
                              MVT.ide_gest,
                              MVT.ide_lig_prev);

/*
  Variables locales a la procedure U521_010B
*/
  v_user                     fb_mvt_bud.uti_maj%TYPE;
  v_terminal                 fb_mvt_bud.terminal%TYPE;
  v_datediff                 DATE := SYSDATE;

  v_poste_assignataire       fn_lp_rpo.ide_poste%TYPE := NULL;
  v_mess_codtypnd            fm_message.cod_typ_nd%TYPE := NULL;
  v_mess_idendemet           fm_message.ide_nd_emet%TYPE := NULL;
  v_mess_idemess             fm_message.ide_mess%TYPE := NULL;
  v_mess_flgemisrecu         fm_message.flg_emis_recu%TYPE := NULL;

  v_ligne_mvt_bud            fb_mvt_bud%ROWTYPE;
  v_poste_assig_courant      fn_lp_rpo.ide_poste%TYPE;
  v_rowid_courant            ROWID;

  v_ide_mess                 fb_mvt_bud.ide_mess_dest%TYPE;
  v_flg_poste_informatise    NUMBER;
  v_cod_typ_nd_assign        rm_poste.cod_typ_nd%TYPE;
  v_cod_typ_nd               rm_poste.cod_typ_nd%TYPE;
  v_retour                   NUMBER;
  v_nbr_piece                NUMBER := 0;
  v_mt_cr                    fb_mvt_bud.mt%TYPE := 0;

  v_libl                     sr_codif.libl%TYPE;
  v_statuttrt                sr_codif.cod_codif%TYPE;
  v_codif_vi   		     VARCHAR2(200);

  v_dummy					 NUMBER;  -- MODIF SGN ano217
  v_indic_traitement		 BOOLEAN := FALSE;

/*
  Constantes utilisees dans la procedure
*/
  cst_Flag_Emis             CONSTANT      CHAR(01) := 'E';
  cst_Prog_Name             CONSTANT      VARCHAR2(10) := 'U521_010B';
  cst_Edit_Bdx_Mvt          CONSTANT      VARCHAR2(10) := 'U521_020E';
  cst_Nom_Table             CONSTANT      VARCHAR2(15) := 'FB_MVT_BUD';
/*
  -- SNE, 10/08/2001 : Correction anos 13 et 14 - Impacts modif package MES : Varirables et Constantes
*/
  v_num_lig_mess      FM_BUFFER_DIFF.IDE_LIG%TYPE;

/*
  Exception
*/
  Erreur_Ext_Code           EXCEPTION;
  Erreur_No_Assign			EXCEPTION;  -- MODIF SGN ANO217
  Erreur_No_MVTBUD          EXCEPTION;  -- MODIF SGN ANO217

/*
  Fonctions et procedure internes
*/
------------------------------------------------------------------------------------------------
FUNCTION CTL_est_informatise(p_ide_poste              fn_lp_rpo.ide_poste%TYPE,
                             p_cod_typ_poste  IN OUT  rm_noeud.cod_typ_nd%TYPE) RETURN NUMBER IS

  CURSOR c_informatise(pc_ide_poste   rm_noeud.ide_nd%TYPE) IS
    SELECT N.ide_site,N.cod_typ_nd
    FROM rm_poste P,rm_noeud N
    WHERE N.cod_typ_nd = P.cod_typ_nd
      AND N.ide_nd     = P.ide_poste
      AND P.ide_poste  = pc_ide_poste;

  /* Variables locales */
  l_ide_site   rm_noeud.ide_site%TYPE;
  l_retour     NUMBER;

BEGIN
  OPEN c_informatise(p_ide_poste);
  FETCH c_informatise INTO l_ide_site,p_cod_typ_poste;

  IF c_informatise%NOTFOUND THEN
    AFF_MESS('E',316,cst_prog_Name||' - CTL_est_informatise','','','');
    l_retour := -1;
  ELSIF l_ide_site IS NULL THEN
    l_retour := 0;
  ELSE
    l_retour := 1;
  END IF;

  CLOSE c_informatise;

  Return(l_retour);

EXCEPTION
  WHEN Others THEN
    AFF_MESS('E',105,cst_prog_Name||' - CTL_est_informatise',SQLERRM,'','');
    Return(-2);
END;

------------------------------------------------------------------------------------------------

FUNCTION MAJ_mvt_bud(p_rowid              ROWID,
                     p_dat_diff           fb_mvt_bud.dat_diff%TYPE := NULL,
                     p_ide_poste_assign   fb_mvt_bud.ide_poste_assig%TYPE := NULL,
                     p_ide_mess           fb_mvt_bud.ide_mess_dest%TYPE := NULL) RETURN NUMBER IS

BEGIN
  /* Avant de mettre a jour la table FB_MVT_BUD, on ferme le curseur */
  IF c_mvt_a_diffuser%ISOPEN THEN
    CLOSE c_mvt_a_diffuser;
  END IF;

  IF p_ide_mess IS NOT NULL THEN
    UPDATE fb_mvt_bud
      SET dat_diff = p_dat_diff,
          ide_poste_assig = p_ide_poste_assign,
          ide_mess_dest = p_ide_mess,
          dat_maj = SYSDATE,
          uti_maj = v_user,
          terminal = v_terminal
    WHERE ROWID = p_rowid;
  ELSE
    UPDATE fb_mvt_bud
      SET dat_diff = p_dat_diff,
          ide_poste_assig = p_ide_poste_assign,
          dat_maj = SYSDATE,
          uti_maj = v_user,
          terminal = v_terminal
    WHERE ROWID = p_rowid;
  END IF;

  IF NOT c_mvt_a_diffuser%ISOPEN THEN
    OPEN c_mvt_a_diffuser(v_cod_typ_nd,v_statuttrt,v_codif_vi);
  END IF;

  Return(1);

EXCEPTION
  WHEN Others THEN
    AFF_MESS('E',105,cst_prog_Name||' - CTL_est_informatise',SQLERRM,'','');
    Return(0);
END;

------------------------------------------------------------------------------------------------

PROCEDURE U521_010B_RUPTURE IS
BEGIN
  IF v_flg_poste_informatise = 1 AND
     v_ide_mess <> -1 THEN
    /* Si poste informatise */
    v_retour := MES.FMSG_END(v_cod_typ_nd,
                             p_ide_poste,
                             v_ide_mess,
                             v_nbr_piece,
                             v_mt_cr,
                             0);
  END IF;

  /* On lance les traitements de rupture sur les dernieres valeurs traitees */
  /* MODIF SGN ANO011 On utilise (#$#) comme separateur au lieu de l espace
  v_retour := GES_LANCER_TRAITEMENT(cst_Edit_Bdx_Mvt,
                                    'P_MD_ND_EMET='||p_ide_poste||
                                    ' P_MD_IDE_MESS='||v_ide_mess||
                                    ' P_MD_DATE='||to_char(trunc(sysdate))||
                                    ' P_IDE_POSTE='||v_poste_assignataire);*/
  v_retour := GES_LANCER_TRAITEMENT(cst_Edit_Bdx_Mvt,
                                    'P_MD_ND_EMET='||p_ide_poste||
                                    '(#$#)P_MD_IDE_MESS='||v_ide_mess||
                                    '(#$#)P_MD_DATE='||to_char(trunc(sysdate))||
                                    '(#$#)P_IDE_POSTE='||v_poste_assignataire,1,'(#$#)' );

END;

------------------------------------------------------------------------------------------------

PROCEDURE U521_010B_TRAITER_LIGNES IS
BEGIN
  IF v_poste_assig_courant IS NOT NULL THEN
    /* Traitement de rupture ? */
    IF (v_poste_assignataire IS NULL) OR
       (v_poste_assignataire <> v_poste_assig_courant) OR
       (v_mess_codtypnd <> v_ligne_mvt_bud.cod_typ_nd_emet) OR
       (v_mess_idendemet <> v_ligne_mvt_bud.ide_nd_emet) OR
       (v_mess_idemess <> v_ligne_mvt_bud.ide_mess) OR
       (v_mess_flgemisrecu <> v_ligne_mvt_bud.flg_emis_recu) THEN

      /* La premiere fois ? */
      IF (v_poste_assignataire IS NOT NULL) THEN
        U521_010B_RUPTURE;
      END IF;

      /* (Re-)Initialisations */
      v_nbr_piece := 0;
      v_mt_cr := 0;
      v_poste_assignataire := v_poste_assig_courant;
      v_mess_codtypnd      := v_ligne_mvt_bud.cod_typ_nd_emet;
      v_mess_idendemet     := v_ligne_mvt_bud.ide_nd_emet;
      v_mess_idemess       := v_ligne_mvt_bud.ide_mess;
      v_mess_flgemisrecu   := v_ligne_mvt_bud.flg_emis_recu;

      v_flg_poste_informatise := CTL_EST_INFORMATISE(v_poste_assig_courant,v_cod_typ_nd_assign);
      IF v_flg_poste_informatise = 1 THEN    /* Si poste informatise */
        v_ide_mess := MES.FMSG_INI('7', '100');
        IF v_ide_mess <> -1 THEN
		   v_num_lig_mess := 0; 		-- SNE, 14/09/2001 : Anos 13 et 14 Modif FDATA_ADD
          v_retour := MES.FDEST_ADD(v_cod_typ_nd,
                                    p_ide_poste,
                                    v_ide_mess,
                                    cst_Flag_Emis,       /* 'E' */
                                    v_cod_typ_nd_assign,
                                    v_poste_assig_courant);
        ELSE
          AFF_MESS('E',313,cst_Prog_Name||' - U521_010B_TRAITER_LIGNES','','','');
        END IF;
      END IF;
    END IF;	   /* Fin traitement de rupture */

    /* Traitement de chaque ligne */
    IF v_flg_poste_informatise = 1 THEN        /* Si poste informatise */
      IF v_ide_mess <> -1 THEN        /* Si on n'a pas eu d'erreur a la creation du msg */
        /* Prise en compte de la fiche question numero 104 */
        v_nbr_piece := v_nbr_piece + 1;
        v_mt_cr := v_mt_cr + v_ligne_mvt_bud.mt;

        v_retour := MAJ_MVT_BUD(v_rowid_courant,
                                v_datediff,
                                v_poste_assig_courant,
                                v_ide_mess);
        IF v_retour = 1 THEN
          /* Prise en compte de la fiche numero 104 */
          v_ligne_mvt_bud.ide_poste := v_poste_assig_courant;
          v_ligne_mvt_bud.ide_mess := v_ide_mess;
          v_ligne_mvt_bud.dat_diff := v_datediff;

          /* Fin traitement fiche 104 */
	  -- SNE, 14/09/2001 : Anos 13 et 14 Modif FDATA_ADD
          -- RDU, 24/10/2005 : Adaptation de l''appel a la fonction FDATA_ADD pour portage Oracle 9i');
          -- v_num_lig_mess := MES.FDATA_ADD(v_ide_mess, cst_Nom_Table, v_ligne_mvt_bud, NULL, v_num_lig_mess);
          v_num_lig_mess := MES.FDATA_ADD_FB_MVT_BUD(v_ide_mess, cst_Nom_Table, v_ligne_mvt_bud, NULL, v_num_lig_mess);
          -- RDU, 24/10/2005 : Fin
          IF v_num_lig_mess < 0 THEN
            AFF_MESS('E',315,cst_Prog_Name||' - U521_010B_TRAITER_LIGNES','','','');
          END IF;        /* v_retour = 1 */
        END IF;
      END IF; /* v_ide_mess <> -1 */

    ELSIF v_flg_poste_informatise = 0 THEN        /* Si poste non informatise */
      v_retour := MAJ_MVT_BUD(v_rowid_courant,
                              v_datediff,
                              v_poste_assig_courant);
    END IF;
  END IF;
END;

/**********************************************************************************************/
--  Programme principal
/**********************************************************************************************/

BEGIN
	 -- SNE, 26/06/2001 : Ajout de trace
     IF GLOBAL.FICHIER_TRACE IS NULL THEN
	 	GLOBAL.INI_FICHIER_TRACE(CAL_NOM_FICHIER_TRACE(cst_Prog_Name));
	 	GLOBAL.INI_NIVEAU_TRACE(1);
	 END IF;
	 AFF_TRACE(cst_Prog_Name, 1, NULL, 'DEBUT');

  /* Récupération des identifiants(user et terminal) de la personne demandant le traitement */
  SELECT SUBSTR(NVL(userenv('TERMINAL'), 'U521_010B'),1,10)
    INTO v_terminal
  FROM DUAL;
  v_user := USER;

  -- Recupération statut message traité
  EXT_Codext('STATUT_MESS','12',v_libl,v_statuttrt,v_retour);
  IF (v_retour != 1) THEN
    RAISE Erreur_Ext_Code;
  END IF;

  -- Récupération statut mouvement visé
  EXT_CODEXT ( 'STATUT_PIECE', 'V', v_libl, v_codif_vi, v_retour);
  IF (v_retour != 1) THEN
    RAISE Erreur_Ext_Code;
  END IF;

  --
  IF p_cod_typ_nd IS NULL THEN
    v_retour := CTL_EST_INFORMATISE(p_ide_poste,v_cod_typ_nd);
  ELSE
    v_cod_typ_nd := p_cod_typ_nd;
  END IF;

  v_retour := MES.FINI_PACKAGE(v_cod_typ_nd,p_ide_poste,p_ide_gest,p_dat_jc);
  IF v_retour = 0 THEN

    OPEN c_mvt_a_diffuser(v_cod_typ_nd,v_statuttrt,v_codif_vi);
    LOOP

      FETCH c_mvt_a_diffuser INTO v_ligne_mvt_bud.ide_poste,
                                  v_ligne_mvt_bud.cod_typ_nd_emet,
                                  v_ligne_mvt_bud.ide_nd_emet,
                                  v_ligne_mvt_bud.ide_mess,
                                  v_ligne_mvt_bud.flg_emis_recu,
                                  v_ligne_mvt_bud.num_mvt_bud,
                                  v_ligne_mvt_bud.num_lig,
                                  v_ligne_mvt_bud.ide_ope,
                                  v_ligne_mvt_bud.ide_gest,
                                  v_ligne_mvt_bud.cod_bud,
                                  v_ligne_mvt_bud.cod_typ_bud,
                                  v_ligne_mvt_bud.ide_poste_assig,
                                  v_ligne_mvt_bud.ide_ordo,
                                  v_ligne_mvt_bud.cod_nat_mvt,
                                  v_ligne_mvt_bud.var_bud,
                                  v_ligne_mvt_bud.ide_lig_prev,
                                  v_ligne_mvt_bud.cod_ope,
                                  v_ligne_mvt_bud.mt,
                                  v_ligne_mvt_bud.dat_ref,
                                  v_ligne_mvt_bud.dat_diff,
                                  v_ligne_mvt_bud.support,
                                  v_ligne_mvt_bud.num_mvt_init,
                                  v_ligne_mvt_bud.cod_orig_benef,
                                  v_ligne_mvt_bud.ide_mess_dest,
                                  v_ligne_mvt_bud.dat_cre,
                                  v_ligne_mvt_bud.uti_cre,
                                  v_ligne_mvt_bud.dat_maj,
                                  v_ligne_mvt_bud.uti_maj,
                                  v_ligne_mvt_bud.terminal,
								  /*
                                  -- LGD,04/09/2002 : Ajout de nouveaux champs de la table FB_MVT_BUD
                                  */
								  v_ligne_mvt_bud.ide_service,
                                  v_ligne_mvt_bud.dat_p_compte,
								  /*
                                  -- Fin de modification
                                  */
                                  v_poste_assig_courant,
                                  v_rowid_courant;

      IF c_mvt_a_diffuser%NOTFOUND THEN
        Exit;
      END IF;
      v_indic_traitement := TRUE;
	  /* Modif SGN ano217 On verifie que la table des assignation est renseignee */
	  BEGIN
	  	   SELECT 1
		   INTO v_dummy
		   FROM fn_lp_rpo
		   WHERE ide_gest = v_ligne_mvt_bud.ide_gest
                     AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
                     AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008;

	  EXCEPTION
	  	   WHEN NO_DATA_FOUND THEN
		   	   RAISE Erreur_No_Assign;
		   WHEN TOO_MANY_ROWS THEN
		   	   NULL;
		   WHEN OTHERS THEN
			   RAISE;
	  END;
	  /* Fin modif sgn */
      U521_010B_TRAITER_LIGNES;
    END LOOP;

	/* Modif SGN ANO217 */
    IF v_indic_traitement = TRUE THEN
       U521_010B_RUPTURE;
	ELSE
	   RAISE Erreur_No_MVTBUD;
	END IF;
	/* Fin modif ANO217 */

    IF c_mvt_a_diffuser%ISOPEN THEN
      CLOSE c_mvt_a_diffuser;
    END IF;

    COMMIT;
    AFF_MESS('I',107,cst_Prog_Name,cst_Prog_Name,'','');
  ELSE
    AFF_MESS('E',108,cst_Prog_Name||' - Main',cst_Prog_Name||' FINI_PACKAGE = '||to_char(v_retour),'','');
  END IF;
  AFF_TRACE(cst_Prog_Name, 1, NULL, 'FIN');

EXCEPTION
  /* Modif SGN ANO217 */
  WHEN Erreur_No_MVTBUD THEN
    AFF_MESS('E',767,cst_Prog_Name,'','','');
    AFF_MESS('E',108,cst_Prog_Name,cst_Prog_Name,'','');
    ROLLBACK;
  WHEN Erreur_No_Assign THEN
    AFF_MESS('E',766,cst_Prog_Name,'','','');
    AFF_MESS('E',108,cst_Prog_Name,cst_Prog_Name,'','');
    ROLLBACK;
  /* MODIF SGN */
  WHEN Erreur_Ext_Code THEN
    AFF_MESS('E',58,cst_Prog_Name||' - Main','','','');
    AFF_MESS('E',108,cst_Prog_Name,cst_Prog_Name,'','');
    ROLLBACK;
  WHEN Others THEN
    AFF_MESS('E',105,cst_Prog_Name||' - Main',SQLERRM,'','');
    ROLLBACK;
    RAISE;
END; /* U521_010B_MAIN */

/

CREATE OR REPLACE PROCEDURE ZERVICE44  (  p_trait            IN number,
                                        p_code_retour      OUT boolean,
                                        p_mess1_retour     OUT varchar2,
 										p_mess2_retour     OUT varchar2,
 										p_mess3_retour     OUT varchar2,
 										p_mess4_retour     OUT varchar2,
 										p_mess5_retour     OUT varchar2
                                          ) IS
----------------------------------------------------------------------------------
-- Procédure spécifique développée par le DI44                                 ---
-- le 28/04/2006 --                                                            ---
--                                                                             ---
--                                                                             ---
-- procédure exécutée à partir du bouton 'divers' du menu restitution          ---
--                                                                             ---
-- la procédure est lancée une première fois avec p_trait = 1                  ---
-- puis une seconde fois avec p_trait = 2 suivant la valeur du code retour     ---
-- du premier traitement                                                       ---
--                                                                             ---
-- Le premier traitement permet d'envoyer un ou des messages à l'utilisateur   ---
-- lui indiquant la nature du traitement avant le 2ème lancement du script     ---
--                                                                             ---
--                                                                             ---
--                                                                             ---
--  lancement avec p_trait = 1                                                 ---
--  ==========================                                                 ---
--                                                                             ---
-- code retour de la procédure  ZERVICE44 avec p_trait = 1                     ---
--                                                                             ---
-- p_code_retour = true   affiche les messages et lance ZERVICE44 avec         ---
--                         p_trait = 2 -                                       ---
-- p_code_retour = false  affiche les messages sans lancer une 2ème fois la    ---
--                        procédure ZERVICE44  avec p_trait = 2 -              ---
--                                                                             ---
--                                                                             ---
--  lancement avec p_trait = 2                                                 ---
--  ==========================                                                 ---
--                                                                             ---
--                                                                             ---
-- si la procédure ZERVICE44 avec p_trait = 1 a renvoyé true                   ---
-- la procédure ZERVICE44 avec p_trait = 2 est exécutée sinon elle ne l'est pas---
--                                                                             ---
-- la valeur de p_code_retour n'est pas exploitée lors du passage avec         ---
-- p_trait = 2                                                                 ---
--                                                                             ---
-- La forms qui appelle cette procédure affiche les messages qu'elle a recus   ---
--                                                                             ---
--                                                                             ---
----------------------------------------------------------------------------------


Erreur1 EXCEPTION;
Erreur2 EXCEPTION;
Erreur3 EXCEPTION;
Erreur4 EXCEPTION;
Erreur5 EXCEPTION;


BEGIN

-- initialisation des paramètres ----------------
p_code_retour := false;
p_mess1_retour := null;
p_mess2_retour := null;
p_mess3_retour := null;
p_mess4_retour := null;
p_mess5_retour := null;


-- début de la procédure ----------------------------------

----------------------------------------------------------------
-------------- début traitement 1 ------------------------------
----------------------------------------------------------------
if p_trait = 1 then

   p_code_retour := false; -- si = false, la procédure ZERVICE44 ne sera pas exécutée une 2ème fois

   -- messages à envoyer à l'utilisateur, jusqu'à 5 possibles --
   P_mess1_retour := 'Bouton inactif';

----------------------------------------------------------------
-------------- fin traitement 1 --------------------------------
----------------------------------------------------------------

elsif p_trait = 2 then
----------------------------------------------------------------
-------------- début traitement 2 ------------------------------
----------------------------------------------------------------
      null;  -- traitement à définir --
---------------------------------------------------------------
-------------- fin traitement 2 ------------------------------
---------------------------------------------------------------
end if;

EXCEPTION

  WHEN  Erreur1 THEN
        P_mess1_retour :=  'Message à définir' ;

  WHEN  Others THEN
        P_mess1_retour := 'Message à définir';
		P_mess2_retour := null;
		P_mess3_retour := null;
		P_mess4_retour := null;
		P_mess5_retour := null;

END ZERVICE44;

/

CREATE OR REPLACE PROCEDURE Z_MES_DEP (p_ide_gest VARCHAR2,p_ide_poste VARCHAR2,p_lib VARCHAR2,p_fic VARCHAR2)
    IS
    ----------------------------------------------------------------------------------
    -- FICHIER        : FUNCTION Z_MES_DEP_CG
    -- DATE CREATION  : 05/01/2007
    -- AUTEUR         : ISABELLE LARONDE
    --
    -- LOGICIEL       : ASTER
    -- SOUS-SYSTEME   : NOM
    -- DESCRIPTION    : CREATION DES DEPECHES DE BASCULE CHANGEMENT DE GESTION CAD

    ----------------------------------------------------------------------------------
    --                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
    ----------------------------------------------------------------------------------
    -- Z_MES_DEP_CG         | 1.0        |05/01/2007| IL          |
    ----------------------------------------------------------------------------------

    -- PARAMETRES ------------
    -- P_IDE_GEST : GESTION
    -- P_IDE_POSTE  :  POSTE
    -- P_LIB  : LIBELLE DES DEPECHES
    -- P_FIC : TYPE DE FICHIER CG OU RENUM
    ----------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------
    -- VARIABLES D'IDENTIFICATION
    ----------------------------------------------------------------------------------------------
    P_MES_DIR             VARCHAR2(50);
    V_IDE_SITE_DEST       VARCHAR2(5);
    P_IDE_SITE            VARCHAR2(5);
    P_VERSION             VARCHAR2(50);
    P_COD_TYP_ND_EMET     CHAR(1):='O';
    P_COD_TYP_ND_DEST     CHAR(1):='P';
    v_ide_poste           VARCHAR2(6);
    P_COD_BUD             VARCHAR2(5):='BGDEP';
    v_cpt                 NUMBER(6);
    V_ERROR_CODE          NUMBER;
    V_ERROR_MESSAGE       VARCHAR2(255);
    v_unite               CHAR(1);
    v_base                VARCHAR2(10);
    V_CPT_MANDAT          NUMBER(6);
    V_IDE_SITE_EMET      VARCHAR2(5);
    V_NO_IDE_MES         NUMBER(8) :=1;
    V_NO_LIGNE_TOTAL     NUMBER(5) :=0;
    V_NBRE_LIGNE_TOTAL   NUMBER(5) :=0;
    V_NO_LIGNE           NUMBER(6) :=0;
    V_DATE_SAISIE_OLD    DATE      := NULL;
    V_SITE_OLD           VARCHAR2(5):=' ';
    V_NBRE_ECRITURES     NUMBER(5);
    V_DER_IDE_DEPECHE    NUMBER(6);
    V_DER_IDE_MESSAGE    NUMBER(8);
    V_NBR_MES_MVT        NUMBER(5):=0;
    V_NBR_MES_ENG        NUMBER(5):=0;
    V_NBR_MES_MANDAT     NUMBER(5):=0;
    V_NBR_MES_MANDAT_BA  NUMBER(5):=0;
    V_MES_NOM            VARCHAR2(100);
    V_MES                UTL_FILE.FILE_TYPE; --FICHIER MES
    V_REP_DEP_LOG1       UTL_FILE.FILE_TYPE; --LISTE DES DEPECHES
    V_NO                 NUMBER(6); -- POUR REPERER UNE CASSURE PAR LOT DE MANDATS
    V_PART1              CHAR(25):='copy %unite%:\%base%\mes\';
    V_PART2              CHAR(31):=' %unite%:\astersrv\exp\bal\rec\';
    v_ref                VARCHAR2(15):=NULL;
    v_liste2             VARCHAR2(20);

    -- DESCRIPTIONS DES TYPES D'ARTICLES NECESSAIRES A LA CONFECTION D'UN MES
    TYPE DEPECHE_TYPE IS RECORD(
    IDE_ENV       CHAR(1)    :='X',
    IDE_SITE_EMET VARCHAR2(5),
    IDE_SITE_DEST VARCHAR2(5),
    IDE_DEPECHE   NUMBER(6)  ,
    DATE_CRE      CHAR(8)    :=TO_CHAR(SYSDATE,'YYYYMMDD') ,
    DAT_EMIS      CHAR(8)    :=TO_CHAR(SYSDATE,'YYYYMMDD'),
    COD_SUPPORT   NUMBER(6)  :=NULL , --FACULTATIF
    NBR_MES       NUMBER(5)  ,
    FLG_MES_APPLI CHAR(1)    :='O');
    V_DEPECHE          DEPECHE_TYPE;

    TYPE MESSAGE_TYPE IS RECORD(
    IDE_MESS      NUMBER(8),
    COD_TYP_ND    VARCHAR2(1)   ,
    IDE_ND_EMET   VARCHAR2(15)  ,
    COD_TYP_MESS  NUMBER(2)     ,
    LIBL          VARCHAR2(120) ,
    REF_MESS      NUMBER(8)     ,
    IDE_GEST      VARCHAR2(7)   ,
    NUM_PRIO      NUMBER(5,2)   :=100,
    NBR_LIGNE     NUMBER(6)     ,
    COMMENTAIRE   VARCHAR2(120) :=NULL,--FACULTATIF
    FLG_EMIS_RECU2 VARCHAR2(1)  :=NULL,--FACULTATIF
    IDE_ENV       VARCHAR2(1)   :=NULL,--FACULTATIF
    IDE_SITE_EMET VARCHAR2(5)   :=NULL,--FACULTATIF
    IDE_SITE_DEST VARCHAR2(5)   :=NULL,--FACULTATIF
    IDE_DEPECHE   NUMBER(6)     :=NULL,--FACULTATIF
    FLG_EMIS_RECU1 VARCHAR2(1)  :=NULL,--FACULTATIF
    COD_TYP_ND1   VARCHAR2(1)   :=NULL,--FACULTATIF
    IDE_ND_EMET1  VARCHAR2(15)  :=NULL,--FACULTATIF
    IDE_MESS1     NUMBER(8)     :=NULL,--FACULTATIF
    COD_STATUT    VARCHAR2(2)   :=NULL,--FACULTATIF
    NBR_PIECE     NUMBER(6)     ,
    COD_VERSION   VARCHAR2(15)  ,
    MT_CR         NUMBER(18,3)  ,
    MT_DB         NUMBER(18,3)  ,
    NBR_DEST      NUMBER(6)     :=1);
    V_MESSAGE          MESSAGE_TYPE;

    TYPE DESTINATAIRE_TYPE IS RECORD(
    COD_TYP_ND_EMET     CHAR(1)     ,
    IDE_ND_EMET         VARCHAR2(15),
    IDE_MESS            NUMBER(8)   ,
    IDE_TYP_ND_DEST     CHAR(1)    ,
    IDE_ND_DEST         VARCHAR2(15));
    V_DESTINATAIRE      DESTINATAIRE_TYPE;

    TYPE EFB_MVTBUD_TYPE IS RECORD(
    COD_TYP_ND          CHAR(1)      :=P_COD_TYP_ND_EMET,
    IDE_ND_EMET         VARCHAR2(15) ,
    IDE_MESS            NUMBER(8) ,
    IDE_LIG             NUMBER(5) ,
    TYP_BUFFER          VARCHAR2(32) :='EFB_MVT_BUD',
    COD_TYPE_OPE        CHAR(1)      :='I',
    IDE_POSTE           VARCHAR2(15) :=P_IDE_POSTE,
    CODE_TYP_ND_EMET    CHAR(1)      :=P_COD_TYP_ND_EMET,
    IDE_ND_EMET1        VARCHAR2(15) ,
    IDE_MESS1           NUMBER(8)    ,
    NUM_MVT             VARCHAR2(20),
    NUM_LIG             NUMBER(4)    ,
    NUM_MVT_INIT        NUMBER(20)    :=NULL,
    IDE_GEST            VARCHAR2(7)  ,
    COD_BUD             VARCHAR2(5)  := P_COD_BUD,
    IDE_ORDO            VARCHAR2(15) ,
    IDE_LIG_PREV        VARCHAR2(30) ,
    COD_NAT_MVT         VARCHAR2(10) ,
    COD_ORIG_BENEF      CHAR(1)      :='B',
    IDE_OPE             VARCHAR2(20) ,
    MT                  NUMBER(18,3) ,
    DAT_REF             CHAR(8),
    SUPPORT             VARCHAR2(45) := NULL,
    FLG_CENTRA          CHAR(1):= NULL);
    V_EFB_MVTBUD        EFB_MVTBUD_TYPE;

    TYPE EFB_ENG_TYPE IS RECORD(
    COD_TYP_ND      CHAR(1)      ,
    IDE_ND_EMET     VARCHAR2(15) ,
    IDE_MESS        NUMBER(8) ,
    IDE_LIG         NUMBER(5) ,
    TYP_BUFFER      VARCHAR2(32) :='EFB_ENG',
    COD_TYPE_OPE    CHAR(1)      :='I',
    IDE_POSTE       VARCHAR2(15) ,
    IDE_GEST        VARCHAR2 (7) ,
    IDE_ORDO        VARCHAR2 (15),
    COD_BUD         VARCHAR2 (5) ,
    IDE_ENG         VARCHAR2 (20) ,
    IDE_MESS1       NUMBER (8)   ,
    COD_ENG         CHAR (1)     ,
    COD_TYP_MVT     CHAR (1)     ,
    COD_NAT_DELEG   CHAR(1),
    IDE_ENG_INIT    VARCHAR2 (20),
    DAT_EMIS        CHAR(8)   ,
    DAT_CF          CHAR(8),
    IDE_OPE         VARCHAR2 (20),
    IDE_DEVISE      VARCHAR2(5),
    MT              NUMBER (18,3) ,
    LIBN            VARCHAR2 (45),
    IDE_OPE_RENUM   VARCHAR2(20):= NULL,
    IDE_ENG_RENUM   VARCHAR2(20):= NULL,
    FLG_CENTRA      CHAR(1) := NULL);
    V_EFB_ENG       EFB_ENG_TYPE;

    TYPE EFB_LIGNE_ENG_TYPE IS RECORD(
    COD_TYP_ND      CHAR(1)      ,
    IDE_ND_EMET     VARCHAR2(15) ,
    IDE_MESS        NUMBER(8) ,
    IDE_LIG         NUMBER(5) ,
    TYP_BUFFER      VARCHAR2(32) :='EFB_LIGNE_ENG',
    COD_TYPE_OPE    CHAR(1)      :='I',
    IDE_POSTE       VARCHAR2(15) ,
    IDE_GEST        VARCHAR2 (7) ,
    IDE_ORDO        VARCHAR2 (15),
    COD_BUD         VARCHAR2 (5) ,
    IDE_ENG         VARCHAR2 (20) ,
    NUM_LIG         NUMBER(4),
    IDE_LIG_PREV    VARCHAR2(30),
    MT              NUMBER(18,3),
    MT_BUD          NUMBER(18,3),
    COD_TICAT       NUMBER(7),
    COD_ACT_SSACT   NUMBER(7));
    V_EFB_LIGNE_ENG EFB_LIGNE_ENG_TYPE;

    ----------------------------------------------------------------------------------------------
    --CURSEURS
    ----------------------------------------------------------------------------------------------
    -- DETERMINATION DES ORDONNATEUR CONCERNES PAR LA REPRISE

       -- PREMIER ENVOI : DEGAGEMENTS N-1
       --------------------------------------------------
        CURSOR C_LISTE_DEPECHE IS

        SELECT DISTINCT 'DEPEN' ide_site,ide_ordo,ide_gest
        FROM(
             SELECT  rm.ide_site ide_site ,ide_ordo,ide_gest FROM ZB_ENG_RENUM zb,RM_NOEUD rm
             WHERE rm.ide_nd=zb.ide_ordo AND rm.cod_typ_nd='O'AND UPPER(p_fic)='RENUM'
             UNION ALL
             SELECT    rm.ide_site ide_site ,IDE_ORDO ,ide_gest FROM ZB_MVT_BUD_RENUM zb,RM_NOEUD rm
             WHERE  rm.ide_nd=zb.ide_ordo AND rm.cod_typ_nd='O'and zb.mt!=0 AND UPPER(p_fic)='RENUM'
             UNION ALL
             SELECT  rm.ide_site ide_site ,ide_ordo,ide_gest FROM ZB_ENG_CG zb,RM_NOEUD rm
             WHERE rm.ide_nd=zb.ide_ordo AND rm.cod_typ_nd='O'AND UPPER(p_fic)='CG'
             UNION ALL
             SELECT    rm.ide_site ide_site ,IDE_ORDO ,ide_gest FROM ZB_MVT_BUD_CG zb,RM_NOEUD rm
             WHERE  rm.ide_nd=zb.ide_ordo AND rm.cod_typ_nd='O'AND UPPER(p_fic)='CG'
       )	ORDER BY ide_site,ide_ordo,ide_gest	;


    ----------------------------------------------------------------------------------------------
    -- FUNCTIONS
    ----------------------------------------------------------------------------------------------
    --RECHERCHE DU DERNIER NUMERO DE MESSAGE
    FUNCTION Z_cg_DER_MESSAGE(P_IDE_ND_EMET VARCHAR2,P_COD_TYP_ND_EMET CHAR)
    RETURN NUMBER
    IS
    V_DER_MESSAGE NUMBER(6);
    BEGIN
        SELECT NVL(MAX(IDE_MESS),0)
              INTO V_DER_MESSAGE
              FROM FM_MESSAGE
              WHERE IDE_ND_EMET=P_IDE_ND_EMET AND COD_TYP_ND=P_COD_TYP_ND_EMET;
        RETURN(V_DER_MESSAGE);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN(-1);
    END Z_cg_DER_MESSAGE;

    --RECHERCHE DU DERNIER NUMERO DE DEPECHE
    FUNCTION Z_cg_deR_DEPECHE(
         P_IDE_ENV             CHAR,
         P_IDE_SITE_EMET       VARCHAR2,
         P_IDE_SITE_DEST       VARCHAR2)
    RETURN NUMBER
    IS
    V_DER_DEPECHE NUMBER(6);
    BEGIN
        SELECT NVL(MAX(IDE_DEPECHE),0)
             INTO V_DER_DEPECHE
             FROM FM_DEPECHE
             WHERE IDE_ENV=P_IDE_ENV AND IDE_SITE_EMET=P_IDE_SITE_EMET AND IDE_SITE_DEST=P_IDE_SITE_DEST;
        RETURN(V_DER_DEPECHE);
    END Z_cg_deR_DEPECHE;

    ------------------------------------------------------------------------------
    --                       PROGRAMME PRINCIPAL
    ------------------------------------------------------------------------------
    BEGIN

        DELETE  ZB_CG_DER_DEPECHES;

        -- IDENTIFICATION DU POSTE

        SELECT DISTINCT IDE_POSTE INTO v_ide_poste FROM FH_UT_PU;
        SELECT VAL_PARAM INTO P_VERSION FROM SR_PARAM WHERE  COD_TYP_CODIF='VERSION';
        SELECT IDE_SITE INTO V_IDE_SITE_DEST FROM RM_NOEUD WHERE COD_TYP_ND='P' AND IDE_ND=v_ide_poste;
        SELECT IDE_SITE INTO P_IDE_SITE FROM RM_NOEUD WHERE COD_TYP_ND='P' AND IDE_ND=v_ide_poste;
        SELECT REPLACE(VAL_PARAM,' ',NULL) INTO P_MES_DIR FROM SR_PARAM WHERE COD_TYP_CODIF='NOM_REP' AND IDE_PARAM='IR0011';
        SELECT val_param INTO v_base FROM SR_PARAM WHERE ide_param='IR0044';
        SELECT SUBSTR(val_param,1,1)INTO v_unite FROM SR_PARAM WHERE ide_param='IR0011';

        -- DONNéES FIXES POUR LES ARTICLES DES MESSAGES

        V_DEPECHE.IDE_SITE_EMET              :=P_IDE_SITE;
        V_DEPECHE.IDE_SITE_DEST              :=P_IDE_SITE;
        V_MESSAGE.COD_TYP_ND                 :=P_COD_TYP_ND_EMET;
        V_MESSAGE.COD_VERSION                :=P_VERSION;
        V_DESTINATAIRE.COD_TYP_ND_EMET       :=P_COD_TYP_ND_EMET;
        V_DESTINATAIRE.IDE_TYP_ND_DEST       :=P_COD_TYP_ND_DEST;
        V_DESTINATAIRE.IDE_ND_DEST           :=v_ide_poste;
        V_EFB_ENG.COD_TYP_ND                 :=P_COD_TYP_ND_EMET;
        V_EFB_ENG.IDE_POSTE                  :=v_IDE_POSTE;
        V_EFB_ENG.COD_BUD                    :=P_COD_BUD;
        V_EFB_LIGNE_ENG.COD_TYP_ND           :=P_COD_TYP_ND_EMET;
        V_EFB_LIGNE_ENG.IDE_POSTE            :=v_IDE_POSTE;
        V_EFB_LIGNE_ENG.COD_BUD              :=P_COD_BUD;

        -- PREPARATION DES FICHIERS RECAPITULATIFS

        V_REP_DEP_LOG1:=UTL_FILE.FOPEN(P_MES_DIR,REPLACE(REPLACE(p_lib,' ',NULL)||'.BAT',' ',NULL),'W');--pour vider
        UTL_FILE.FCLOSE(V_REP_DEP_LOG1);
        V_REP_DEP_LOG1:=UTL_FILE.FOPEN(P_MES_DIR,REPLACE(REPLACE(p_lib,' ',NULL)||'.BAT',' ',NULL),'A');

        --INITIALISATION DU BAT DU PREMIER LOT DE DEPECHES
        UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,':DEBUT');
        UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,'CLS');
        UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,'SET UNITE='||REPLACE(v_unite,' ',NULL));
        UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,'SET BASE='||REPLACE(v_base,' ',NULL));
        UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,':TRAIT');

        -- ***************************************************************
        -- TRAITEMENT DE LA PREMIERE DEPECHE : DEGAGEMENTS  BNAPA ET RNAPA SUR N-1
        -- ***************************************************************

        FOR v_liste IN c_liste_depeche LOOP
            -- UNE OU DEUX DEPECHE PAR ORDONNATEUR : CREATION D'UN MES
            -- CHANGEMENT DE SITE EMETTEUR : INITIALISATION DES NUMEROS DE DEPECHE
            IF V_ref IS NULL OR V_ref<>V_LISTE.ide_SITE THEN
                V_DER_IDE_DEPECHE:=z_cg_der_depeche('X',V_LISTE.ide_SITE,V_IDE_SITE_DEST);
                V_ref:=V_LISTE.ide_SITE;
            END IF;
            V_DER_IDE_DEPECHE:=V_DER_IDE_DEPECHE+1;
            V_DEPECHE.IDE_DEPECHE:=V_DER_IDE_DEPECHE;
            INSERT INTO ZB_CG_DER_DEPECHES (SITE_EMET,SITE_DEST,IDE_DEPECHE)
            VALUES (V_LISTE.ide_SITE,V_IDE_SITE_DEST,V_DER_IDE_DEPECHE);
            COMMIT;

            --LISTE PREMIER ENVOI
            V_MES_NOM:= REPLACE('X_'||V_LISTE.ide_SITE||'_'||V_IDE_SITE_DEST||'_'||LPAD(V_DER_IDE_DEPECHE,5,'0')||'.INV',' ',NULL);
            UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,V_PART1||V_MES_NOM||V_PART2||REPLACE(V_MES_NOM,'.INV','.DAT'));
            V_MES:=UTL_FILE.FOPEN(P_MES_DIR,V_MES_NOM,'W');
                           V_DEPECHE.IDE_SITE_EMET:=V_LISTE.ide_SITE;
                           V_DEPECHE.IDE_SITE_DEST:=V_IDE_SITE_DEST;

            -- ARTICLE : DEPECHE
            V_DEPECHE.IDE_DEPECHE:= V_DER_IDE_DEPECHE;

            --NBRE ORDO POUR LES  :  DEGAGEMENTS+ BNAPA+RNAPA SUR P_IDE_GEST
            IF UPPER(p_fic)='RENUM' THEN
                SELECT COUNT(DISTINCT ide_ordo)  INTO    V_NBR_MES_ENG
                      FROM ZB_ENG_renum
                      WHERE v_liste.ide_ordo=ide_ordo
                      AND ide_gest=v_liste.ide_gest;

                SELECT COUNT(DISTINCT ide_ordo)  INTO    V_NBR_MES_mvt
                      FROM ZB_MVT_BUD_renum
                      WHERE v_liste.ide_ordo=ide_ordo
                      AND ide_gest=v_liste.ide_gest
                      and mt!=0;
            ELSE
                SELECT COUNT(DISTINCT ide_ordo)  INTO    V_NBR_MES_ENG
                      FROM ZB_ENG_cg
                      WHERE v_liste.ide_ordo=ide_ordo
                      AND ide_gest=v_liste.ide_gest;

                SELECT COUNT(DISTINCT ide_ordo)  INTO    V_NBR_MES_mvt
                      FROM ZB_MVT_BUD_cg
                      WHERE v_liste.ide_ordo=ide_ordo
                      AND ide_gest=v_liste.ide_gest;
            END IF;

            V_DEPECHE.NBR_MES:=V_NBR_MES_MVT+V_NBR_MES_ENG;
            V_DEPECHE.NBR_MES:=V_NBR_MES_MVT+V_NBR_MES_ENG;
            UTL_FILE.PUT_LINE(V_MES,	'DEPECHE : "' ||
                           V_DEPECHE.IDE_ENV       ||'"@"'||
                           V_DEPECHE.IDE_SITE_EMET ||'"@"'||
                           V_DEPECHE.IDE_SITE_DEST ||'"@"'||
                           V_DEPECHE.IDE_DEPECHE   ||'"@"'||
                           V_DEPECHE.DATE_CRE      ||'"@"'||
                           V_DEPECHE.DAT_EMIS      ||'"@"'||
                           V_DEPECHE.COD_SUPPORT   ||'"@"'||
                           V_DEPECHE.NBR_MES       ||'"@"'||
                           V_DEPECHE.FLG_MES_APPLI ||'"');

            -- --   ***************************
            -- --   TRAITEMENT DE L'ORDONNATEUR
            -- --   ***************************--
             V_MESSAGE.IDE_ND_EMET:=v_liste.ide_ordo;
             V_DER_IDE_MESSAGE :=z_cg_der_message(V_MESSAGE.IDE_ND_EMET,P_COD_TYP_ND_EMET);
            --    ********************************************************************
            --          TRAITEMENT DES MVT_BUD : NAPA ET DES CP DE L'ORDONNATEUR
            --    ********************************************************************
               DECLARE

                 CURSOR C_MVT IS
                     SELECT * FROM   ZB_MVT_BUD_cg
                      WHERE IDE_ORDO=v_liste.ide_ordo
                      AND ide_gest=v_liste.ide_gest
                      AND UPPER(p_fic)='CG'
                      UNION ALL
                      SELECT     SEQ,
                                  IDE_POSTE,
                                  NUM_MVT,
                                  NUM_MVT_INIT,
                                  IDE_GEST,
                                  IDE_ORDO,
                                  IDE_LIG_PREV,
                                  COD_NAT_MVT,
                                  IDE_OPE ,
                                  MT   ,
                                  DAT_REF,
                                  SUPPORT ,
                                  DAT_CRE,
                                  UTI_CRE ,
                                  DAT_MAJ ,
                                  UTI_MAJ ,
                                  TERMINAL ,
                                  flg_centra
                      FROM   ZB_MVT_BUD_renum
                      WHERE IDE_ORDO=v_liste.ide_ordo
                      AND ide_gest=v_liste.ide_gest and mt!=0 AND UPPER(p_fic)='RENUM' ;

                V_REF_OLD CHAR(6):=NULL;
                V_MVT         ZB_MVT_BUD_cg%ROWTYPE;
                BEGIN

                    V_CPT:=0;
                    FOR V_MVT IN C_MVT LOOP
                       V_CPT:=V_CPT+1;
                           -- CREATION D'UN NOUVEAU MESSAGE
                       IF V_CPT=1 THEN
                       V_DER_IDE_MESSAGE:=V_DER_IDE_MESSAGE+1;
                       V_MESSAGE.LIBL:=(REPLACE(p_lib,' ',NULL)||'_AFFECTATIONS SUR LA GESTION '|| v_mvt.ide_gest||' : '|| V_MVT.IDE_ORDO);
                              -- NOMBRE DE LIGNES DETAILS DU MESSAGE DE TYPE EFB_MVTBUD
                              IF UPPER(p_fic)='RENUM' THEN
                                   SELECT COUNT(*) INTO V_NBRE_LIGNE_TOTAL
                                          FROM ZB_mvt_bud_renum
                                          WHERE IDE_ORDO=V_MVT.IDE_ORDO
                                          AND IDE_GEST=v_mvt.ide_gest
                                          and mt!=0;

                                  -- MONTANT TOTAL DES LIGNES DU MESSAGE EN DEBIT ET EN CREDIT
                                   SELECT SUM(MT),SUM(mt)INTO V_MESSAGE.MT_CR,V_MESSAGE.MT_DB
                                          FROM ZB_MVT_BUD_renum
                                          WHERE IDE_ORDO=V_MVT.IDE_ORDO
                                          AND IDE_GEST=V_MVT.IDE_gest
                                          and mt!=0;
                              ELSE
                                     SELECT COUNT(*) INTO V_NBRE_LIGNE_TOTAL
                                      FROM ZB_mvt_bud_cg
                                      WHERE IDE_ORDO=V_MVT.IDE_ORDO
                                      AND IDE_GEST=v_mvt.ide_gest ;

                                      -- MONTANT TOTAL DES LIGNES DU MESSAGE EN DEBIT ET EN CREDIT
                                       SELECT SUM(MT),SUM(mt)INTO V_MESSAGE.MT_CR,V_MESSAGE.MT_DB
                                              FROM ZB_MVT_BUD_cg
                                              WHERE IDE_ORDO=V_MVT.IDE_ORDO
                                              AND IDE_GEST=V_MVT.IDE_gest ;
                              END IF;

                               V_MESSAGE.NBR_PIECE:= V_NBRE_LIGNE_TOTAL;
                               V_MESSAGE.NBR_LIGNE:= V_MESSAGE.NBR_PIECE;
                               V_MESSAGE.IDE_MESS:= V_DER_IDE_MESSAGE;
                               V_MESSAGE.REF_MESS:=V_MESSAGE.IDE_MESS;
                               V_MESSAGE.COD_TYP_MESS:='7';
                               V_MESSAGE.IDE_GEST := v_mvt.ide_gest;

                               UTL_FILE.PUT_LINE(V_MES,	 'MESSAGE : "'            ||
                                                         V_MESSAGE.IDE_MESS       ||'"@"'||
                                                         V_MESSAGE.COD_TYP_ND     ||'"@"'||
                                                         V_MESSAGE.IDE_ND_EMET    ||'"@"'||
                                                         V_MESSAGE.COD_TYP_MESS   ||'"@"'||
                                                         V_MESSAGE.LIBL           ||'"@"'||
                                                         V_MESSAGE.REF_MESS       ||'"@"'||
                                                         V_MESSAGE.IDE_GEST       ||'"@"'||
                                                         V_MESSAGE.NUM_PRIO       ||'"@"'||
                                                         V_MESSAGE.NBR_LIGNE      ||'"@"'||
                                                         V_MESSAGE.COMMENTAIRE    ||'"@"'||
                                                         V_MESSAGE.FLG_EMIS_RECU2 ||'"@"'||
                                                         V_MESSAGE.IDE_ENV        ||'"@"'||
                                                         V_MESSAGE.IDE_SITE_EMET  ||'"@"'||
                                                         V_MESSAGE.IDE_SITE_DEST  ||'"@"'||
                                                         V_MESSAGE.IDE_DEPECHE    ||'"@"'||
                                                         V_MESSAGE.FLG_EMIS_RECU1 ||'"@"'||
                                                         V_MESSAGE.COD_TYP_ND1    ||'"@"'||
                                                         V_MESSAGE.IDE_ND_EMET1   ||'"@"'||
                                                         V_MESSAGE.IDE_MESS1      ||'"@"'||
                                                         V_MESSAGE.COD_STATUT     ||'"@"'||
                                                         V_MESSAGE.NBR_PIECE      ||'"@"'||
                                                         V_MESSAGE.COD_VERSION    ||'"@"'||
                                                         V_MESSAGE.MT_CR          ||'"@"'||
                                                         V_MESSAGE.MT_DB          ||'"@"'||
                                                         V_MESSAGE.NBR_DEST       ||'"' );
                               -- ARTICLE : DESTINATAIRE
                               V_DESTINATAIRE.IDE_MESS:=V_MESSAGE.IDE_MESS;
                               V_DESTINATAIRE.IDE_ND_EMET :=V_MVT.IDE_ORDO;
                               UTL_FILE.PUT_LINE(V_MES,	 'DESTINATAIRE : "'              ||
                                                         V_DESTINATAIRE.COD_TYP_ND_EMET  ||'"@"'||
                                                         V_DESTINATAIRE.IDE_ND_EMET      ||'"@"'||
                                                         V_DESTINATAIRE.IDE_MESS         ||'"@"'||
                                                         V_DESTINATAIRE.IDE_TYP_ND_DEST  ||'"@"'||
                                                         V_DESTINATAIRE.IDE_ND_DEST      ||'"'   );

                        END IF;

                           -- TRAITEMENT DES LIGNES DETAIL DU MESSAGE
                               V_NO_LIGNE:=V_NO_LIGNE+1;
                               V_EFB_MVTBUD.IDE_LIG:=V_NO_LIGNE;
                               V_EFB_MVTBUD.IDE_ND_EMET:=V_MVT.IDE_ORDO;
                               V_EFB_MVTBUD.IDE_ND_EMET1:=V_MVT.IDE_ORDO;
                               V_EFB_MVTBUD.IDE_MESS:=V_MESSAGE.IDE_MESS;
                               V_EFB_MVTBUD.IDE_MESS1:=V_MESSAGE.IDE_MESS;
                               V_EFB_MVTBUD.NUM_MVT:=V_MVT.NUM_MVT;
                               V_EFB_MVTBUD.IDE_GEST := v_mvt.ide_gest;
                               V_EFB_MVTBUD.IDE_GEST:=V_MESSAGE.IDE_GEST;
                               V_EFB_MVTBUD.IDE_ORDO:=V_MVT.IDE_ORDO;
                               V_EFB_MVTBUD.IDE_LIG_PREV:=V_MVT.IDE_LIG_PREV;
                               V_EFB_MVTBUD.COD_NAT_MVT:=V_MVT.COD_NAT_MVT;
                               V_EFB_MVTBUD.MT:=V_MVT.MT;
                               V_EFB_MVTBUD.NUM_MVT_INIT:=V_MVT.NUM_MVT_INIT;
                               V_EFB_MVTBUD.NUM_LIG:=1;
                               V_EFB_MVTBUD.DAT_REF:=v_MVT.DAT_REF;
                               V_EFB_MVTBUD.IDE_OPE:=V_MVT.IDE_OPE;
                               V_EFB_MVTBUD.support:=V_MVT.support;
                               V_EFB_MVTBUD.FLG_CENTRA:=V_MVT.flg_centra;

                               UTL_FILE.PUT_LINE(V_MES,  'EFB_MVT_BUD : "'||
                                                      V_EFB_MVTBUD.COD_TYP_ND          ||'"@"'||
                                                      V_EFB_MVTBUD.IDE_ND_EMET         ||'"@"'||
                                                      V_EFB_MVTBUD.IDE_MESS            ||'"@"'||
                                                      V_EFB_MVTBUD.IDE_LIG             ||'"@"'||
                                                      V_EFB_MVTBUD.TYP_BUFFER          ||'"@"'||
                                                      V_EFB_MVTBUD.COD_TYPE_OPE        ||'"@"'||
                                                      V_EFB_MVTBUD.IDE_POSTE           ||'"@"'||
                                                      V_EFB_MVTBUD.CODE_TYP_ND_EMET    ||'"@"'||
                                                      V_EFB_MVTBUD.IDE_ND_EMET1        ||'"@"'||
                                                      V_EFB_MVTBUD.IDE_MESS1           ||'"@"'||
                                                      V_EFB_MVTBUD.NUM_MVT             ||'"@"'||
                                                      V_EFB_MVTBUD.NUM_LIG             ||'"@"'||
                                                      V_EFB_MVTBUD.NUM_MVT_INIT        ||'"@"'||
                                                      V_EFB_MVTBUD.IDE_GEST            ||'"@"'||
                                                      V_EFB_MVTBUD.COD_BUD             ||'"@"'||
                                                      V_EFB_MVTBUD.IDE_ORDO            ||'"@"'||
                                                      V_EFB_MVTBUD.IDE_LIG_PREV        ||'"@"'||
                                                      V_EFB_MVTBUD.COD_NAT_MVT         ||'"@"'||
                                                      V_EFB_MVTBUD.COD_ORIG_BENEF      ||'"@"'||
                                                      V_EFB_MVTBUD.IDE_OPE             ||'"@"'||
                                                      V_EFB_MVTBUD.MT                  ||'"@"'||
                                                      V_EFB_MVTBUD.DAT_REF             ||'"@"'||
                                                      V_EFB_MVTBUD.SUPPORT             ||'"@"'||
                                                      V_EFB_MVTBUD.FLG_CENTRA          ||'"');

                        END LOOP; --TRAITEMENT DES MVT DE L'ORDONNATEUR

                END;-- FIN DE TRAITEMENT DES MVT_BUD DE L'ORDONNATEUR

            -- --    *****************************************************
            -- --    TRAITEMENT DES DEGAGEMENTS DE L'ORDONNATEUR : ZB_ENG_'%P_FIC'
            -- --    *****************************************************
               DECLARE
                    V_REF_OLD     VARCHAR2(5):=NULL;
                    CURSOR C_ENG IS
                         SELECT * FROM(
                          SELECT SEQ,IDE_POSTE,IDE_ORDO,IDE_OPE,COD_TYP_MVT,COD_BUD,DLIG,IDE_LIG_PREV,MT,IDE_ENG,IDE_ENG_INIT,DAT_EMIS,LIBN,iDE_GEST,
                              COD_NAT_DELEG,COD_TITCAT,COD_ACT_SSACT ,  DAT_CRE,
                              UTI_CRE ,
                              DAT_MAJ,
                              UTI_MAJ,
                              TERMINAL ,
                              flg_centra,
                              null ide_ope_anc,
                              null ide_eng_anc
                          FROM   ZB_ENG_cg
                          WHERE ide_ordo=v_liste.ide_ordo
                          AND   ide_gest=v_liste.ide_gest
                          AND UPPER(p_fic)='CG'
                          UNION ALL
                          SELECT   SEQ,IDE_POSTE,IDE_ORDO,IDE_OPE,COD_TYP_MVT,COD_BUD,DLIG,IDE_LIG_PREV,MT,IDE_ENG,IDE_ENG_INIT,DAT_EMIS,LIBN,iDE_GEST,
                              COD_NAT_DELEG,COD_TITCAT,COD_ACT_SSACT ,  DAT_CRE,
                              UTI_CRE ,
                              DAT_MAJ,
                              UTI_MAJ,
                              TERMINAL ,
                              flg_centra,
                              ide_ope_anc,
                              ide_eng_anc
                          FROM   ZB_ENG_renum
                          WHERE ide_ordo=v_liste.ide_ordo
                          AND   ide_gest=v_liste.ide_gest
                          AND UPPER(p_fic)='RENUM'
                           )ORDER BY ide_ordo,ide_eng,DLIG  ;
                    V_ENG         ZB_ENG_cg%ROWTYPE;
               BEGIN
                    FOR v_eng IN c_eng LOOP
                       -- CREATION D'UN NOUVEAU MESSAGE

                            IF V_ENG.COD_TYP_MVT<>V_REF_OLD OR V_REF_OLD IS NULL THEN
                               V_DER_IDE_MESSAGE:=V_DER_IDE_MESSAGE+1;
                               V_REF_OLD:= V_ENG.COD_TYP_MVT;
                               V_NO_LIGNE:=0;
                               V_MESSAGE.LIBL:=REPLACE(p_lib,' ',NULL)||'_ENGAGEMENTS SUR LA GESTION '||V_ENG.ide_gEST||' : '|| V_ENG.ide_ordo;

                                IF UPPER(p_fic)='RENUM' THEN

                                       -- NOMBRE DE PIECES : EFB_ENG

                                       SELECT COUNT(*) INTO V_MESSAGE.NBR_PIECE
                                              FROM ZB_ENG_RENUM
                                              WHERE ide_ordo=V_ENG.ide_ordo
                                              AND COD_TYP_MVT=V_ENG.COD_TYP_MVT
                                              AND DLIG=1
                                              AND ide_gest=v_eng.ide_gest;

                                       -- NOMBRE DE LIGNES DETAIL + LIGNE DE TêTES
                                       SELECT COUNT(*) INTO V_MESSAGE.NBR_LIGNE
                                              FROM ZB_ENG_RENUM
                                              WHERE ide_ordo=V_ENG.ide_ordo
                                              AND COD_TYP_MVT=V_ENG.COD_TYP_MVT
                                              AND ide_gest=v_eng.ide_gest;

                                      -- MONTANT TOTAL DES LIGNES DU MESSAGE EN DEBIT ET EN CREDIT
                                       SELECT SUM(mt)INTO V_MESSAGE.MT_CR FROM ZB_ENG_RENUM
                                              WHERE ide_ordo=V_ENG.ide_ordo
                                              AND COD_TYP_MVT=V_ENG.COD_TYP_MVT
                                              AND ide_gest=v_eng.ide_gest;
                                       SELECT SUM(mt) INTO V_MESSAGE.MT_DB FROM ZB_ENG_RENUM
                                              WHERE ide_ordo=V_ENG.ide_ordo
                                              AND COD_TYP_MVT=V_ENG.COD_TYP_MVT
                                              AND ide_gest=v_eng.ide_gest;
                                ELSE
                                       -- NOMBRE DE PIECES : EFB_ENG

                                       SELECT COUNT(*) INTO V_MESSAGE.NBR_PIECE
                                              FROM ZB_ENG_CG
                                              WHERE ide_ordo=V_ENG.ide_ordo
                                              AND COD_TYP_MVT=V_ENG.COD_TYP_MVT
                                              AND DLIG=1
                                              AND ide_gest=v_eng.ide_gest;

                                       -- NOMBRE DE LIGNES DETAIL + LIGNE DE TêTES
                                       SELECT COUNT(*) INTO V_MESSAGE.NBR_LIGNE
                                              FROM ZB_ENG_CG
                                              WHERE ide_ordo=V_ENG.ide_ordo
                                              AND COD_TYP_MVT=V_ENG.COD_TYP_MVT
                                              AND ide_gest=v_eng.ide_gest;

                                      -- MONTANT TOTAL DES LIGNES DU MESSAGE EN DEBIT ET EN CREDIT
                                       SELECT SUM(mt)INTO V_MESSAGE.MT_CR FROM ZB_ENG_CG
                                              WHERE ide_ordo=V_ENG.ide_ordo
                                              AND COD_TYP_MVT=V_ENG.COD_TYP_MVT
                                              AND ide_gest=v_eng.ide_gest;
                                       SELECT SUM(mt) INTO V_MESSAGE.MT_DB FROM ZB_ENG_CG
                                              WHERE ide_ordo=V_ENG.ide_ordo
                                              AND COD_TYP_MVT=V_ENG.COD_TYP_MVT
                                              AND ide_gest=v_eng.ide_gest;
                                END IF;

                               V_MESSAGE.NBR_LIGNE:=V_MESSAGE.NBR_LIGNE+V_MESSAGE.NBR_PIECE;
                               V_MESSAGE.IDE_MESS:= V_DER_IDE_MESSAGE;
                               V_MESSAGE.REF_MESS:=V_MESSAGE.IDE_MESS;
                               V_MESSAGE.COD_TYP_MESS:='2';
                               V_MESSAGE.IDE_GEST := V_ENG.ide_GEST;
                               UTL_FILE.PUT_LINE(V_MES,	 'MESSAGE : "'            ||
                                                         V_MESSAGE.IDE_MESS       ||'"@"'||
                                                         V_MESSAGE.COD_TYP_ND     ||'"@"'||
                                                         V_MESSAGE.IDE_ND_EMET    ||'"@"'||
                                                         V_MESSAGE.COD_TYP_MESS   ||'"@"'||
                                                         V_MESSAGE.LIBL           ||'"@"'||
                                                         V_MESSAGE.REF_MESS       ||'"@"'||
                                                         V_MESSAGE.IDE_GEST       ||'"@"'||
                                                         V_MESSAGE.NUM_PRIO       ||'"@"'||
                                                         V_MESSAGE.NBR_LIGNE      ||'"@"'||
                                                         V_MESSAGE.COMMENTAIRE    ||'"@"'||
                                                         V_MESSAGE.FLG_EMIS_RECU2 ||'"@"'||
                                                         V_MESSAGE.IDE_ENV        ||'"@"'||
                                                         V_MESSAGE.IDE_SITE_EMET  ||'"@"'||
                                                         V_MESSAGE.IDE_SITE_DEST  ||'"@"'||
                                                         V_MESSAGE.IDE_DEPECHE    ||'"@"'||
                                                         V_MESSAGE.FLG_EMIS_RECU1 ||'"@"'||
                                                         V_MESSAGE.COD_TYP_ND1    ||'"@"'||
                                                         V_MESSAGE.IDE_ND_EMET1   ||'"@"'||
                                                         V_MESSAGE.IDE_MESS1      ||'"@"'||
                                                         V_MESSAGE.COD_STATUT     ||'"@"'||
                                                         V_MESSAGE.NBR_PIECE      ||'"@"'||
                                                         V_MESSAGE.COD_VERSION    ||'"@"'||
                                                         V_MESSAGE.MT_CR          ||'"@"'||
                                                         V_MESSAGE.MT_DB          ||'"@"'||
                                                         V_MESSAGE.NBR_DEST       ||'"' );
                               -- ARTICLE : DESTINATAIRE
                               V_DESTINATAIRE.IDE_MESS:=V_MESSAGE.IDE_MESS;
                               V_DESTINATAIRE.IDE_ND_EMET :=V_ENG.ide_ordo;
                               UTL_FILE.PUT_LINE(V_MES,	 'DESTINATAIRE : "'              ||
                                                         V_DESTINATAIRE.COD_TYP_ND_EMET  ||'"@"'||
                                                         V_DESTINATAIRE.IDE_ND_EMET      ||'"@"'||
                                                         V_DESTINATAIRE.IDE_MESS         ||'"@"'||
                                                         V_DESTINATAIRE.IDE_TYP_ND_DEST  ||'"@"'||
                                                         V_DESTINATAIRE.IDE_ND_DEST      ||'"'   );

                           END IF;

                        --
                           -- TRAITEMENT DES LIGNES DETAIL DU MESSAGE
                        IF V_ENG.DLIG=1 THEN

                             V_EFB_ENG.IDE_ND_EMET:=V_ENG.ide_ordo;
                             V_EFB_ENG.IDE_MESS:=V_MESSAGE.IDE_MESS;
                             V_NO_LIGNE:=V_NO_LIGNE+1;
                             V_EFB_ENG.IDE_LIG:=V_NO_LIGNE;
                             V_EFB_ENG.IDE_GEST:=V_MESSAGE.IDE_GEST;
                             V_EFB_ENG.IDE_ORDO:=V_ENG.ide_ordo;
                             V_EFB_ENG.IDE_ENG:=REPLACE(V_ENG.ide_eng,' ',NULL);
                             V_EFB_ENG.IDE_MESS1:=V_MESSAGE.IDE_MESS;
                             V_EFB_ENG.COD_ENG:='P';
                             V_EFB_ENG.COD_TYP_MVT:=V_ENG.COD_TYP_MVT;
                             V_EFB_ENG.COD_NAT_DELEG:=V_ENG.COD_NAT_DELEG;
                             V_EFB_ENG.IDE_ENG_INIT:=REPLACE(V_ENG.ide_eng_INIT,' ',NULL);
                             V_EFB_ENG.DAT_EMIS:=V_ENG.DAT_EMIS;
                             V_EFB_ENG.DAT_CF:=NULL;
                             V_EFB_ENG.IDE_OPE:=V_ENG.ide_ope;
                             V_EFB_ENG.IDE_DEVISE:='EUR';
                             IF UPPER(p_fic)='RENUM' THEN
                             SELECT SUM(mt) INTO V_EFB_ENG.MT FROM ZB_ENG_renum
                                    WHERE ide_eng=V_ENG.ide_eng
                                    AND ide_ordo=V_ENG.ide_ordo
                                    AND NVL(ide_ope,' ')=NVL(V_ENG.ide_ope,' ');
                                ELSE
                                     SELECT SUM(mt) INTO V_EFB_ENG.MT FROM ZB_ENG_cg
                                    WHERE ide_eng=V_ENG.ide_eng
                                    AND ide_ordo=V_ENG.ide_ordo
                                    AND NVL(ide_ope,' ')=NVL(V_ENG.ide_ope,' ');
                                END IF;
                             V_EFB_ENG.LIBN:=V_ENG.LIBN;
                             V_EFB_ENG.FLG_CENTRA:=V_ENG.FLG_CENTRA;
                             V_EFB_ENG.IDE_OPE_RENUM:=V_ENG.IDE_OPE_ANC;
                             V_EFB_ENG.IDE_ENG_RENUM:=V_ENG.IDE_ENG_ANC;

                             UTL_FILE.PUT_LINE(V_MES,  'EFB_ENG : "'||
                                V_EFB_ENG.COD_TYP_ND      ||'"@"'||
                                V_EFB_ENG.IDE_ND_EMET     ||'"@"'||
                                V_EFB_ENG.IDE_MESS        ||'"@"'||
                                V_EFB_ENG.IDE_LIG         ||'"@"'||
                                V_EFB_ENG.TYP_BUFFER      ||'"@"'||
                                V_EFB_ENG.COD_TYPE_OPE    ||'"@"'||
                                V_EFB_ENG.IDE_POSTE       ||'"@"'||
                                V_EFB_ENG.IDE_GEST        ||'"@"'||
                                V_EFB_ENG.IDE_ORDO        ||'"@"'||
                                V_EFB_ENG.COD_BUD         ||'"@"'||
                                V_EFB_ENG.IDE_ENG         ||'"@"'||
                                V_EFB_ENG.IDE_MESS1       ||'"@"'||
                                V_EFB_ENG.COD_ENG         ||'"@"'||
                                V_EFB_ENG.COD_TYP_MVT     ||'"@"'||
                                V_EFB_ENG.COD_NAT_DELEG   ||'"@"'||
                                V_EFB_ENG.IDE_ENG_INIT    ||'"@"'||
                                V_EFB_ENG.DAT_EMIS        ||'"@"'||
                                V_EFB_ENG.DAT_CF          ||'"@"'||
                                V_EFB_ENG.IDE_OPE         ||'"@"'||
                                V_EFB_ENG.IDE_DEVISE      ||'"@"'||
                                V_EFB_ENG.MT              ||'"@"'||
                                V_EFB_ENG.LIBN            ||'"@"'||
                                V_EFB_ENG.IDE_OPE_RENUM   ||'"@"'||
                                V_EFB_ENG.IDE_ENG_RENUM   ||'"@"'||
                                V_EFB_ENG.FLG_CENTRA      ||'"');
                        END IF;

                             V_EFB_LIGNE_ENG.IDE_ND_EMET :=V_EFB_ENG.IDE_ND_EMET;
                             V_EFB_LIGNE_ENG.IDE_MESS  :=V_EFB_ENG.IDE_MESS;
                             V_NO_LIGNE:=V_NO_LIGNE+1;
                             V_EFB_LIGNE_ENG.IDE_LIG  :=V_NO_LIGNE;
                             V_EFB_LIGNE_ENG.IDE_GEST:=V_MESSAGE.IDE_GEST;
                             V_EFB_LIGNE_ENG.IDE_ORDO:=V_ENG.ide_ordo;
                             V_EFB_LIGNE_ENG.IDE_ENG :=REPLACE(V_EFB_ENG.IDE_ENG,' ',NULL);
                             V_EFB_LIGNE_ENG.NUM_LIG  :=V_ENG.DLIG;
                             V_EFB_LIGNE_ENG.IDE_LIG_PREV :=V_ENG.IDE_LIG_PREV;
                             V_EFB_LIGNE_ENG.MT  :=V_ENG.mt;
                             V_EFB_LIGNE_ENG.MT_BUD   :=V_ENG.mt;
                             V_EFB_LIGNE_ENG.COD_TICAT:=V_ENG.COD_TITCAT;
                             V_EFB_LIGNE_ENG.COD_ACT_SSACT:=V_ENG.COD_ACT_SSACT;

                          UTL_FILE.PUT_LINE(V_MES,  'EFB_LIGNE_ENG : "'||
                                V_EFB_LIGNE_ENG.COD_TYP_ND      ||'"@"'||
                                V_EFB_LIGNE_ENG.IDE_ND_EMET     ||'"@"'||
                                V_EFB_LIGNE_ENG.IDE_MESS        ||'"@"'||
                                V_EFB_LIGNE_ENG.IDE_LIG         ||'"@"'||
                                V_EFB_LIGNE_ENG.TYP_BUFFER      ||'"@"'||
                                V_EFB_LIGNE_ENG.COD_TYPE_OPE    ||'"@"'||
                                V_EFB_LIGNE_ENG.IDE_POSTE       ||'"@"'||
                                V_EFB_LIGNE_ENG.IDE_GEST        ||'"@"'||
                                V_EFB_LIGNE_ENG.IDE_ORDO        ||'"@"'||
                                V_EFB_LIGNE_ENG.COD_BUD         ||'"@"'||
                                V_EFB_LIGNE_ENG.IDE_ENG         ||'"@"'||
                                V_EFB_LIGNE_ENG.NUM_LIG         ||'"@"'||
                                V_EFB_LIGNE_ENG.IDE_LIG_PREV    ||'"@"'||
                                V_EFB_LIGNE_ENG.MT              ||'"@"'||
                                V_EFB_LIGNE_ENG.MT_BUD          ||'"@"'||
                                V_EFB_LIGNE_ENG.COD_TICAT       ||'"@"'||
                                V_EFB_LIGNE_ENG.COD_ACT_SSACT||'"');


                       END LOOP;

               END;-- FIN DE TRAITEMENT DES ENG DE L'ORDONNATEUR

               --FERMETURE DE LA DEPECHE
               UTL_FILE.FCLOSE(V_MES);
           END LOOP; --FIN DU TRAITEMENT DE L'ORDONNATEUR

        UTL_FILE.FCLOSE(V_REP_DEP_LOG1);

           EXCEPTION
           WHEN UTL_FILE.INVALID_PATH           THEN DBMS_OUTPUT.PUT_LINE('INVALID PATH');
           WHEN UTL_FILE.INVALID_MODE           THEN DBMS_OUTPUT.PUT_LINE('INVALID MODE');
           WHEN UTL_FILE.INVALID_FILEHANDLE     THEN DBMS_OUTPUT.PUT_LINE('INVALID_FILEHANDLE');
           WHEN UTL_FILE.INVALID_OPERATION      THEN DBMS_OUTPUT.PUT_LINE('INVALID_OPERATION');
           WHEN UTL_FILE.WRITE_ERROR            THEN DBMS_OUTPUT.PUT_LINE('WRITE_ERROR');
           WHEN UTL_FILE.INTERNAL_ERROR         THEN DBMS_OUTPUT.PUT_LINE('INTERNAL_ERROR');
           WHEN OTHERS                          THEN
               V_ERROR_CODE:=SQLCODE;V_ERROR_MESSAGE:=SQLERRM;
              DBMS_OUTPUT.PUT_LINE (V_ERROR_CODE||' : '||V_ERROR_MESSAGE);
       END Z_MES_DEP;

/

CREATE OR REPLACE PROCEDURE Z_MES_DEP_CG (p_ide_gest VARCHAR2,p_ide_poste VARCHAR2,p_lib VARCHAR2)
IS
----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_MES_DEP_CG
-- DATE CREATION  : 05/01/2007
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : CREATION DES DEPECHES DE BASCULE CHANGEMENT DE GESTION CAD

----------------------------------------------------------------------------------
--                            |VERSION     |DATE      |INITIALES    |COMMENTAIRES
----------------------------------------------------------------------------------
-- Z_MES_DEP_CG         | 1.0        |05/01/2007| IL          |
----------------------------------------------------------------------------------

-- PARAMETRES ------------
-- P_IDE_GEST : GESTION
-- P_IDE_POSTE  :  POSTE
-- P_LIB  : LIBELLE DES DEPECHES
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- VARIABLES D'IDENTIFICATION
----------------------------------------------------------------------------------------------
P_MES_DIR             VARCHAR2(50);
V_IDE_SITE_DEST       VARCHAR2(5);
P_IDE_SITE            VARCHAR2(5);
P_VERSION             VARCHAR2(50);
P_COD_TYP_ND_EMET     CHAR(1):='O';
P_COD_TYP_ND_DEST     CHAR(1):='P';
v_ide_poste           VARCHAR2(6);
P_COD_BUD             VARCHAR2(5):='BGDEP';
v_cpt                 NUMBER(6);
V_ERROR_CODE          NUMBER;
V_ERROR_MESSAGE       VARCHAR2(255);
v_unite               CHAR(1);
v_base                VARCHAR2(10);
V_CPT_MANDAT          NUMBER(6);
V_LISTE_SITE         VARCHAR2(5);
V_IDE_SITE_EMET      VARCHAR2(5);
V_NO_IDE_MES         NUMBER(8) :=1;  -- A CALCULER
V_NO_LIGNE_TOTAL     NUMBER(5) :=0;
V_NBRE_LIGNE_TOTAL   NUMBER(5) :=0;
V_NO_LIGNE           NUMBER(6) :=0;
V_DATE_SAISIE_OLD    DATE      := NULL;
V_SITE_OLD           VARCHAR2(5):=' ';
V_NBRE_ECRITURES     NUMBER(5);
V_DER_IDE_DEPECHE    NUMBER(6);
V_DER_IDE_MESSAGE    NUMBER(8);
V_NBR_MES_MVT        NUMBER(5):=0;
V_NBR_MES_ENG        NUMBER(5):=0;
V_NBR_MES_MANDAT     NUMBER(5):=0;
V_NBR_MES_MANDAT_BA  NUMBER(5):=0;
V_MES_NOM            VARCHAR2(100);
V_MES                UTL_FILE.FILE_TYPE; --FICHIER MES
V_REP_DEP_LOG1       UTL_FILE.FILE_TYPE; --LISTE DES DEPECHES
V_REP_DEP_LOG2       UTL_FILE.FILE_TYPE; --LISTE DES DEPECHES
V_NO                 NUMBER(6); -- POUR REPERER UNE CASSURE PAR LOT DE MANDATS
V_PART1              CHAR(25):='copy %unite%:\%base%\mes\';
V_PART2              CHAR(31):=' %unite%:\astersrv\exp\bal\rec\';


-- DESCRIPTIONS DES TYPES D'ARTICLES NECESSAIRES A LA CONFECTION D'UN MES
TYPE DEPECHE_TYPE IS RECORD(
IDE_ENV       CHAR(1)    :='X',
IDE_SITE_EMET VARCHAR2(5),
IDE_SITE_DEST VARCHAR2(5),
IDE_DEPECHE   NUMBER(6)  ,
DATE_CRE      CHAR(8)    :=TO_CHAR(SYSDATE,'YYYYMMDD') ,
DAT_EMIS      CHAR(8)    :=TO_CHAR(SYSDATE,'YYYYMMDD'),
COD_SUPPORT   NUMBER(6)  :=NULL , --FACULTATIF
NBR_MES       NUMBER(5)  ,
FLG_MES_APPLI CHAR(1)    :='O');
V_DEPECHE          DEPECHE_TYPE;
TYPE MESSAGE_TYPE IS RECORD(
IDE_MESS      NUMBER(8),
COD_TYP_ND    VARCHAR2(1)   ,
IDE_ND_EMET   VARCHAR2(15)  ,
COD_TYP_MESS  NUMBER(2)     ,
LIBL          VARCHAR2(120) ,
REF_MESS      NUMBER(8)     ,
IDE_GEST      VARCHAR2(7)   ,
NUM_PRIO      NUMBER(5,2)   :=100,
NBR_LIGNE     NUMBER(6)     ,
COMMENTAIRE   VARCHAR2(120) :=NULL,--FACULTATIF
FLG_EMIS_RECU2 VARCHAR2(1)  :=NULL,--FACULTATIF
IDE_ENV       VARCHAR2(1)   :=NULL,--FACULTATIF
IDE_SITE_EMET VARCHAR2(5)   :=NULL,--FACULTATIF
IDE_SITE_DEST VARCHAR2(5)   :=NULL,--FACULTATIF
IDE_DEPECHE   NUMBER(6)     :=NULL,--FACULTATIF
FLG_EMIS_RECU1 VARCHAR2(1)  :=NULL,--FACULTATIF
COD_TYP_ND1   VARCHAR2(1)   :=NULL,--FACULTATIF
IDE_ND_EMET1  VARCHAR2(15)  :=NULL,--FACULTATIF
IDE_MESS1     NUMBER(8)     :=NULL,--FACULTATIF
COD_STATUT    VARCHAR2(2)   :=NULL,--FACULTATIF
NBR_PIECE     NUMBER(6)     ,
COD_VERSION   VARCHAR2(15)  ,
MT_CR         NUMBER(18,3)  ,
MT_DB         NUMBER(18,3)  ,
NBR_DEST      NUMBER(6)     :=1);
V_MESSAGE          MESSAGE_TYPE;
TYPE DESTINATAIRE_TYPE IS RECORD(
COD_TYP_ND_EMET     CHAR(1)     ,
IDE_ND_EMET         VARCHAR2(15),
IDE_MESS            NUMBER(8)   ,
IDE_TYP_ND_DEST     CHAR(1)    ,
IDE_ND_DEST         VARCHAR2(15));
V_DESTINATAIRE      DESTINATAIRE_TYPE;
TYPE EFB_MVTBUD_TYPE IS RECORD(
COD_TYP_ND          CHAR(1)      :=P_COD_TYP_ND_EMET,
IDE_ND_EMET         VARCHAR2(15) ,
IDE_MESS            NUMBER(8) ,
IDE_LIG             NUMBER(5) ,
TYP_BUFFER          VARCHAR2(32) :='EFB_MVT_BUD',
COD_TYPE_OPE        CHAR(1)      :='I',
IDE_POSTE           VARCHAR2(15) :=P_IDE_POSTE,
CODE_TYP_ND_EMET    CHAR(1)      :=P_COD_TYP_ND_EMET,
IDE_ND_EMET1        VARCHAR2(15) ,
IDE_MESS1           NUMBER(8)    ,
NUM_MVT             VARCHAR2(20),
NUM_LIG             NUMBER(4)    ,
NUM_MVT_INIT        NUMBER(20)    :=NULL,
IDE_GEST            VARCHAR2(7)  ,
COD_BUD             VARCHAR2(5)  := P_COD_BUD,
IDE_ORDO            VARCHAR2(15) ,
IDE_LIG_PREV        VARCHAR2(30) ,
COD_NAT_MVT         VARCHAR2(10) ,
COD_ORIG_BENEF      CHAR(1)      :='B',
IDE_OPE             VARCHAR2(20) ,
MT                  NUMBER(18,3) ,
DAT_REF             CHAR(8),
SUPPORT             VARCHAR2(45) := NULL);
V_EFB_MVTBUD        EFB_MVTBUD_TYPE;
TYPE EFB_ENG_TYPE IS RECORD(
COD_TYP_ND      CHAR(1)      ,
IDE_ND_EMET     VARCHAR2(15) ,
IDE_MESS        NUMBER(8) ,
IDE_LIG         NUMBER(5) ,
TYP_BUFFER      VARCHAR2(32) :='EFB_ENG',
COD_TYPE_OPE    CHAR(1)      :='I',
IDE_POSTE       VARCHAR2(15) ,
IDE_GEST        VARCHAR2 (7) ,
IDE_ORDO        VARCHAR2 (15),
COD_BUD         VARCHAR2 (5) ,
IDE_ENG         VARCHAR2 (20) ,
IDE_MESS1       NUMBER (8)   ,
COD_ENG         CHAR (1)     ,
COD_TYP_MVT     CHAR (1)     ,
COD_NAT_DELEG   CHAR(1),
IDE_ENG_INIT    VARCHAR2 (20),
DAT_EMIS        CHAR(8)   ,
DAT_CF          CHAR(8),
IDE_OPE         VARCHAR2 (20),
IDE_DEVISE      VARCHAR2(5),
MT              NUMBER (18,3) ,
LIBN            VARCHAR2 (45) );
V_EFB_ENG       EFB_ENG_TYPE;
TYPE EFB_LIGNE_ENG_TYPE IS RECORD(
COD_TYP_ND      CHAR(1)      ,
IDE_ND_EMET     VARCHAR2(15) ,
IDE_MESS        NUMBER(8) ,
IDE_LIG         NUMBER(5) ,
TYP_BUFFER      VARCHAR2(32) :='EFB_LIGNE_ENG',
COD_TYPE_OPE    CHAR(1)      :='I',
IDE_POSTE       VARCHAR2(15) ,
IDE_GEST        VARCHAR2 (7) ,
IDE_ORDO        VARCHAR2 (15),
COD_BUD         VARCHAR2 (5) ,
IDE_ENG         VARCHAR2 (20) ,
NUM_LIG         NUMBER(4),
IDE_LIG_PREV    VARCHAR2(30),
MT              NUMBER(18,3),
MT_BUD          NUMBER(18,3),
COD_TICAT       NUMBER(7),
COD_ACT_SSACT   NUMBER(7));
V_EFB_LIGNE_ENG EFB_LIGNE_ENG_TYPE;

v_liste_ide_ordo     ZB_ENG_CG.ide_ordo%TYPE;


----------------------------------------------------------------------------------------------
--CURSEURS
----------------------------------------------------------------------------------------------
-- DETERMINATION DES ORDONNATEUR CONCERNES PAR LA REPRISE

   -- PREMIER ENVOI : DEGAGEMENTS N-1
   --------------------------------------------------
    CURSOR C_LISTE_DEPECHE IS

		SELECT DISTINCT site,ordo FROM(
    SELECT  rm.ide_site site ,ide_ordo ordo FROM ZB_ENG_CG zb,RM_NOEUD rm
	WHERE COD_TYP_MVT='D' AND rm.ide_nd=zb.ide_ordo AND rm.cod_typ_nd='O'
	UNION
	SELECT    rm.ide_site site ,IDE_ORDO  ordo FROM ZB_MVT_BUD_CG zb,RM_NOEUD rm
	WHERE IDE_GEST=p_ide_gest AND rm.ide_nd=zb.ide_ordo AND rm.cod_typ_nd='O');



   -- DEUXIEME ENVOI : ENGAGEMENT INITIAUX N
   -------------------------------------------------------------------------------
	CURSOR C_LISTE_DEPECHE_2 IS

	SELECT DISTINCT site,ordo FROM(
    SELECT   rm.ide_site site ,ide_ordo ordo FROM ZB_ENG_CG zb,RM_NOEUD rm
	WHERE COD_TYP_MVT='I'AND rm.ide_nd=zb.ide_ordo AND rm.cod_typ_nd='O'
	UNION
	SELECT    rm.ide_site site ,IDE_ORDO ORDO FROM ZB_MVT_BUD_CG zb,RM_NOEUD rm
	WHERE IDE_GEST=p_ide_gest+1 AND rm.ide_nd=zb.ide_ordo AND rm.cod_typ_nd='O');

----------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------
--RECHERCHE DU DERNIER NUMERO DE MESSAGE
FUNCTION Z_cg_DER_MESSAGE(P_IDE_ND_EMET VARCHAR2,P_COD_TYP_ND_EMET CHAR)
RETURN NUMBER
IS
V_DER_MESSAGE NUMBER(6);
BEGIN
SELECT NVL(MAX(IDE_MESS),0)
      INTO V_DER_MESSAGE
      FROM FM_MESSAGE
      WHERE IDE_ND_EMET=P_IDE_ND_EMET AND COD_TYP_ND=P_COD_TYP_ND_EMET;
RETURN(V_DER_MESSAGE);
EXCEPTION
WHEN NO_DATA_FOUND THEN RETURN(-1);
END Z_cg_DER_MESSAGE;

--RECHERCHE DU DERNIER NUMERO DE DEPECHE
FUNCTION Z_cg_deR_DEPECHE(
     P_IDE_ENV             CHAR,
     P_IDE_SITE_EMET       VARCHAR2,
     P_IDE_SITE_DEST       VARCHAR2)
RETURN NUMBER
IS
V_DER_DEPECHE NUMBER(6);
BEGIN
SELECT NVL(MAX(IDE_DEPECHE),0)
     INTO V_DER_DEPECHE
     FROM FM_DEPECHE
     WHERE IDE_ENV=P_IDE_ENV AND IDE_SITE_EMET=P_IDE_SITE_EMET AND IDE_SITE_DEST=P_IDE_SITE_DEST;
RETURN(V_DER_DEPECHE);
END Z_cg_deR_DEPECHE;






BEGIN
-- IDENTIFICATION DU POSTE

SELECT DISTINCT IDE_POSTE INTO v_ide_poste FROM FH_UT_PU;
SELECT VAL_PARAM INTO P_VERSION FROM SR_PARAM WHERE  COD_TYP_CODIF='VERSION';
SELECT IDE_SITE INTO V_IDE_SITE_DEST FROM RM_NOEUD WHERE COD_TYP_ND='P' AND IDE_ND=v_ide_poste;
SELECT IDE_SITE INTO P_IDE_SITE FROM RM_NOEUD WHERE COD_TYP_ND='P' AND IDE_ND=v_ide_poste;
SELECT REPLACE(VAL_PARAM,' ',NULL) INTO P_MES_DIR FROM SR_PARAM WHERE COD_TYP_CODIF='NOM_REP' AND IDE_PARAM='IR0011';
SELECT val_param INTO v_base FROM SR_PARAM WHERE ide_param='IR0044';
SELECT SUBSTR(val_param,1,1)INTO v_unite FROM SR_PARAM WHERE ide_param='IR0011';

-- DONNéES FIXES POUR LES ARTICLES DES MESSAGES

V_DEPECHE.IDE_SITE_EMET              :=P_IDE_SITE;
V_DEPECHE.IDE_SITE_DEST              :=P_IDE_SITE;
V_MESSAGE.COD_TYP_ND                 :=P_COD_TYP_ND_EMET;
V_MESSAGE.COD_VERSION                :=P_VERSION;
V_DESTINATAIRE.COD_TYP_ND_EMET       :=P_COD_TYP_ND_EMET;
V_DESTINATAIRE.IDE_TYP_ND_DEST       :=P_COD_TYP_ND_DEST;
V_DESTINATAIRE.IDE_ND_DEST           :=v_ide_poste;
V_EFB_ENG.COD_TYP_ND                 :=P_COD_TYP_ND_EMET;
V_EFB_ENG.IDE_POSTE                  :=v_IDE_POSTE;
V_EFB_ENG.COD_BUD                    :=P_COD_BUD;
V_EFB_LIGNE_ENG.COD_TYP_ND           :=P_COD_TYP_ND_EMET;
V_EFB_LIGNE_ENG.IDE_POSTE            :=v_IDE_POSTE;
V_EFB_LIGNE_ENG.COD_BUD              :=P_COD_BUD;

-- PREPARATION DES 3 FICHIERS RECAPITULATIFS

V_REP_DEP_LOG1:=UTL_FILE.FOPEN(P_MES_DIR,REPLACE(REPLACE(p_lib,' ',NULL)||'_1.BAT',' ',NULL),'W');
V_REP_DEP_LOG2:=UTL_FILE.FOPEN(P_MES_DIR,REPLACE(REPLACE(p_lib,' ',NULL)||'_2.BAT',' ',NULL),'W');
UTL_FILE.FCLOSE(V_REP_DEP_LOG1);
UTL_FILE.FCLOSE(V_REP_DEP_LOG2);
V_REP_DEP_LOG1:=UTL_FILE.FOPEN(P_MES_DIR,REPLACE(REPLACE(p_lib,' ',NULL)||'_1.BAT',' ',NULL),'A');
V_REP_DEP_LOG2:=UTL_FILE.FOPEN(P_MES_DIR,REPLACE(REPLACE(p_lib,' ',NULL)||'_2.BAT',' ',NULL),'A');

--INITIALISATION DU BAT DU PREMIER LOT DE DEPECHES
UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,':DEBUT');
UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,'CLS');








UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,'SET UNITE='||REPLACE(v_unite,' ',NULL));
UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,'SET BASE='||REPLACE(v_base,' ',NULL));
UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,':TRAIT');


--INITIALISATION DU BAT DU PREMIER LOT DE DEPECHES
UTL_FILE.PUT_LINE(V_REP_DEP_LOG2,':DEBUT');
UTL_FILE.PUT_LINE(V_REP_DEP_LOG2,'CLS');
UTL_FILE.PUT_LINE(V_REP_DEP_LOG2,'SET UNITE='||REPLACE(v_unite,' ',NULL));
UTL_FILE.PUT_LINE(V_REP_DEP_LOG2,'SET BASE='||REPLACE(v_base,' ',NULL));
UTL_FILE.PUT_LINE(V_REP_DEP_LOG2,':TRAIT');


-- ***************************************************************
-- TRAITEMENT DE LA PREMIERE DEPECHE : DEGAGEMENTS  BNAPA ET RNAPA SUR N-1
-- ***************************************************************





OPEN C_LISTE_DEPECHE;--BOUCLE DES ORDONNATEURS
LOOP  --BOUCLE DES ORDONNATEURS
FETCH C_LISTE_DEPECHE INTO V_LISTE_SITE,v_liste_ide_ordo;
EXIT WHEN C_LISTE_DEPECHE%NOTFOUND;

-- UNE OU DEUX DEPECHE PAR ORDONNATEUR : CREATION D'UN MES
-- CHANGEMENT DE SITE EMETTEUR : INITIATION DES NUMEROS DE DEPECHE
IF V_SITE_OLD='' OR V_SITE_OLD<>V_LISTE_SITE THEN
V_DER_IDE_DEPECHE:=z_cg_der_depeche('X',V_LISTE_SITE,V_IDE_SITE_DEST);
V_SITE_OLD:=V_LISTE_SITE;
END IF;
V_DER_IDE_DEPECHE:=V_DER_IDE_DEPECHE+1;
V_DEPECHE.IDE_DEPECHE:=V_DER_IDE_DEPECHE;
INSERT INTO ZB_CG_DER_DEPECHES (SITE_EMET,SITE_DEST,IDE_DEPECHE)
VALUES (V_LISTE_SITE,V_IDE_SITE_DEST,V_DER_IDE_DEPECHE);
COMMIT;
--LISTE PREMIER ENVOI
V_MES_NOM:= REPLACE('X_'||V_LISTE_SITE||'_'||V_IDE_SITE_DEST||'_'||LPAD(V_DER_IDE_DEPECHE,5,'0')||'.INV',' ',NULL);

UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,V_PART1||V_MES_NOM||V_PART2||REPLACE(V_MES_NOM,'.INV','.DAT'));


V_MES:=UTL_FILE.FOPEN(P_MES_DIR,V_MES_NOM,'W');
               V_DEPECHE.IDE_SITE_EMET:=V_LISTE_SITE;
               V_DEPECHE.IDE_SITE_DEST:=V_IDE_SITE_DEST;
-- ARTICLE : DEPECHE
V_DEPECHE.IDE_DEPECHE:= V_DER_IDE_DEPECHE;

--NBRE ORDO POUR LES  :  DEGAGEMENTS+ BNAPA+RNAPA SUR P_IDE_GEST
SELECT COUNT(DISTINCT ide_ordo)  INTO    V_NBR_MES_ENG
      FROM ZB_ENG_CG
	  WHERE v_liste_ide_ordo=ide_ordo
	  AND ide_gest=p_ide_gest;

SELECT COUNT(DISTINCT ide_ordo)  INTO    V_NBR_MES_mvt
      FROM ZB_MVT_BUD_CG
	  WHERE v_liste_ide_ordo=ide_ordo
	  AND ide_gest=p_ide_gest;
V_DEPECHE.NBR_MES:=V_NBR_MES_MVT+V_NBR_MES_ENG;

V_DEPECHE.NBR_MES:=V_NBR_MES_MVT+V_NBR_MES_ENG;
UTL_FILE.PUT_LINE(V_MES,	'DEPECHE : "' ||
               V_DEPECHE.IDE_ENV       ||'"@"'||
               V_DEPECHE.IDE_SITE_EMET ||'"@"'||
               V_DEPECHE.IDE_SITE_DEST ||'"@"'||
               V_DEPECHE.IDE_DEPECHE   ||'"@"'||
               V_DEPECHE.DATE_CRE      ||'"@"'||
               V_DEPECHE.DAT_EMIS      ||'"@"'||
               V_DEPECHE.COD_SUPPORT   ||'"@"'||
               V_DEPECHE.NBR_MES       ||'"@"'||
               V_DEPECHE.FLG_MES_APPLI ||'"');


-- --   ***************************
-- --   TRAITEMENT DE L'ORDONNATEUR
-- --   ***************************--
 V_MESSAGE.IDE_ND_EMET:=v_liste_ide_ordo;
 V_DER_IDE_MESSAGE :=z_cg_der_message(V_MESSAGE.IDE_ND_EMET,P_COD_TYP_ND_EMET);
--    ********************************************************************
--          TRAITEMENT DES MVT_BUD : NAPA ET DES CP DE L'ORDONNATEUR
--    ********************************************************************
   DECLARE
     CURSOR C_MVT IS
          SELECT *
   	      FROM   ZB_MVT_BUD_CG
		  WHERE IDE_ORDO=v_liste_ide_ordo
		  AND IDE_GEST=p_ide_gest;
    V_MVT         ZB_MVT_BUD_CG%ROWTYPE;
	V_REF_OLD CHAR(6):=NULL;

    BEGIN

V_CPT:=0;
    OPEN C_MVT;
    LOOP --TRAITEMENT DES MVT D'UN ORDONNATEUR
    FETCH C_MVT INTO V_MVT;
    EXIT WHEN C_MVT%NOTFOUND;


 V_CPT:=V_CPT+1;
   -- CREATION D'UN NOUVEAU MESSAGE
   IF V_CPT=1 THEN
   V_DER_IDE_MESSAGE:=V_DER_IDE_MESSAGE+1;

   V_MESSAGE.LIBL:=(REPLACE(p_lib,' ',NULL)||'_AFFECTATIONS SUR LA GESTION '|| v_mvt.ide_gest||' : '|| V_MVT.IDE_ORDO);



      -- NOMBRE DE LIGNES DETAILS DU MESSAGE DE TYPE EFB_MVTBUD
       SELECT COUNT(*) INTO V_NBRE_LIGNE_TOTAL
	          FROM ZB_MVT_BUD_CG
              WHERE IDE_ORDO=V_MVT.IDE_ORDO
	          AND IDE_GEST=p_ide_gest ;
	   V_MESSAGE.NBR_PIECE:= V_NBRE_LIGNE_TOTAL;
	   V_MESSAGE.NBR_LIGNE:= V_MESSAGE.NBR_PIECE;
      -- MONTANT TOTAL DES LIGNES DU MESSAGE EN DEBIT ET EN CREDIT
       SELECT SUM(MT),SUM(mt)INTO V_MESSAGE.MT_CR,V_MESSAGE.MT_DB
	          FROM ZB_MVT_BUD_CG
              WHERE IDE_ORDO=V_MVT.IDE_ORDO
	          AND IDE_GEST=p_ide_gest ;

       V_MESSAGE.IDE_MESS:= V_DER_IDE_MESSAGE;
	   V_MESSAGE.REF_MESS:=V_MESSAGE.IDE_MESS;
	   V_MESSAGE.COD_TYP_MESS:='7';
	   V_MESSAGE.IDE_GEST := p_ide_gest;

   UTL_FILE.PUT_LINE(V_MES,	 'MESSAGE : "'            ||
                             V_MESSAGE.IDE_MESS       ||'"@"'||
                             V_MESSAGE.COD_TYP_ND     ||'"@"'||
                             V_MESSAGE.IDE_ND_EMET    ||'"@"'||
                             V_MESSAGE.COD_TYP_MESS   ||'"@"'||
                             V_MESSAGE.LIBL           ||'"@"'||
                             V_MESSAGE.REF_MESS       ||'"@"'||
                             V_MESSAGE.IDE_GEST       ||'"@"'||
                             V_MESSAGE.NUM_PRIO       ||'"@"'||
                             V_MESSAGE.NBR_LIGNE      ||'"@"'||
                             V_MESSAGE.COMMENTAIRE    ||'"@"'||
                             V_MESSAGE.FLG_EMIS_RECU2 ||'"@"'||
                             V_MESSAGE.IDE_ENV        ||'"@"'||
                             V_MESSAGE.IDE_SITE_EMET  ||'"@"'||
                             V_MESSAGE.IDE_SITE_DEST  ||'"@"'||
                             V_MESSAGE.IDE_DEPECHE    ||'"@"'||
                             V_MESSAGE.FLG_EMIS_RECU1 ||'"@"'||
                             V_MESSAGE.COD_TYP_ND1    ||'"@"'||
                             V_MESSAGE.IDE_ND_EMET1   ||'"@"'||
                             V_MESSAGE.IDE_MESS1      ||'"@"'||
                             V_MESSAGE.COD_STATUT     ||'"@"'||
                             V_MESSAGE.NBR_PIECE      ||'"@"'||
                             V_MESSAGE.COD_VERSION    ||'"@"'||
                             V_MESSAGE.MT_CR          ||'"@"'||
                             V_MESSAGE.MT_DB          ||'"@"'||
                             V_MESSAGE.NBR_DEST       ||'"' );
   -- ARTICLE : DESTINATAIRE
   V_DESTINATAIRE.IDE_MESS:=V_MESSAGE.IDE_MESS;
   V_DESTINATAIRE.IDE_ND_EMET :=V_MVT.IDE_ORDO;
   UTL_FILE.PUT_LINE(V_MES,	 'DESTINATAIRE : "'              ||
                             V_DESTINATAIRE.COD_TYP_ND_EMET  ||'"@"'||
                             V_DESTINATAIRE.IDE_ND_EMET      ||'"@"'||
							 V_DESTINATAIRE.IDE_MESS         ||'"@"'||
                             V_DESTINATAIRE.IDE_TYP_ND_DEST  ||'"@"'||
                             V_DESTINATAIRE.IDE_ND_DEST      ||'"'   );

END IF;


   -- TRAITEMENT DES LIGNES DETAIL DU MESSAGE
       V_NO_LIGNE:=V_NO_LIGNE+1;
       V_EFB_MVTBUD.IDE_LIG:=V_NO_LIGNE;
       V_EFB_MVTBUD.IDE_ND_EMET:=V_MVT.IDE_ORDO;
	   V_EFB_MVTBUD.IDE_ND_EMET1:=V_MVT.IDE_ORDO;
	   V_EFB_MVTBUD.IDE_MESS:=V_MESSAGE.IDE_MESS;
	   V_EFB_MVTBUD.IDE_MESS1:=V_MESSAGE.IDE_MESS;
	   V_EFB_MVTBUD.NUM_MVT:=V_MVT.NUM_MVT;
	   V_EFB_MVTBUD.IDE_GEST := p_ide_gest;
	   V_EFB_MVTBUD.IDE_GEST:=V_MESSAGE.IDE_GEST;
	   V_EFB_MVTBUD.IDE_ORDO:=V_MVT.IDE_ORDO;
	   V_EFB_MVTBUD.IDE_LIG_PREV:=V_MVT.IDE_LIG_PREV;
	   V_EFB_MVTBUD.COD_NAT_MVT:=V_MVT.COD_NAT_MVT;
	   V_EFB_MVTBUD.MT:=V_MVT.MT;
	   V_EFB_MVTBUD.NUM_MVT_INIT:=V_MVT.NUM_MVT_INIT;
	   V_EFB_MVTBUD.NUM_LIG:=1;
	   V_EFB_MVTBUD.DAT_REF:=v_MVT.DAT_REF;
	   V_EFB_MVTBUD.IDE_OPE:=V_MVT.IDE_OPE;
       V_EFB_MVTBUD.support:=V_MVT.support;
	   UTL_FILE.PUT_LINE(V_MES,  'EFB_MVT_BUD : "'||
	                          V_EFB_MVTBUD.COD_TYP_ND          ||'"@"'||
                              V_EFB_MVTBUD.IDE_ND_EMET         ||'"@"'||
                              V_EFB_MVTBUD.IDE_MESS            ||'"@"'||
                              V_EFB_MVTBUD.IDE_LIG             ||'"@"'||
                              V_EFB_MVTBUD.TYP_BUFFER          ||'"@"'||
                              V_EFB_MVTBUD.COD_TYPE_OPE        ||'"@"'||
                      	      V_EFB_MVTBUD.IDE_POSTE           ||'"@"'||
                              V_EFB_MVTBUD.CODE_TYP_ND_EMET    ||'"@"'||
							  V_EFB_MVTBUD.IDE_ND_EMET1        ||'"@"'||
                              V_EFB_MVTBUD.IDE_MESS1           ||'"@"'||
                              V_EFB_MVTBUD.NUM_MVT             ||'"@"'||
							  V_EFB_MVTBUD.NUM_LIG             ||'"@"'||
                              V_EFB_MVTBUD.NUM_MVT_INIT        ||'"@"'||
                              V_EFB_MVTBUD.IDE_GEST            ||'"@"'||
                              V_EFB_MVTBUD.COD_BUD             ||'"@"'||
                              V_EFB_MVTBUD.IDE_ORDO            ||'"@"'||
                              V_EFB_MVTBUD.IDE_LIG_PREV        ||'"@"'||
                              V_EFB_MVTBUD.COD_NAT_MVT         ||'"@"'||
                              V_EFB_MVTBUD.COD_ORIG_BENEF      ||'"@"'||
                              V_EFB_MVTBUD.IDE_OPE             ||'"@"'||
                              V_EFB_MVTBUD.MT                  ||'"@"'||
                              V_EFB_MVTBUD.DAT_REF             ||'"@"'||
                              V_EFB_MVTBUD.SUPPORT             ||'"');
-- --
    END LOOP; --TRAITEMENT DES MVT DE L'ORDONNATEUR
    CLOSE C_MVT;
    END;-- FIN DE TRAITEMENT DES MVT DE L'ORDONNATEUR
-- --    *****************************************************
-- --    TRAITEMENT DES DEGAGEMENTS DE L'ORDONNATEUR : ZB_ENG_CG
-- --    *****************************************************
   DECLARE
     CURSOR C_ENG IS
          SELECT *
   	      FROM   ZB_ENG_CG
		  WHERE ide_ordo=v_liste_ide_ordo AND COD_TYP_MVT='D'
		  ORDER BY COD_TYP_MVT,ide_ordo,ide_ope,ide_eng,DLIG ;
    V_ENG         ZB_ENG_CG%ROWTYPE;
	V_REF_OLD VARCHAR2(5):=NULL;

   BEGIN


   OPEN C_ENG;
   LOOP
   FETCH C_ENG INTO V_ENG;
   EXIT WHEN C_ENG%NOTFOUND;

   -- CREATION D'UN NOUVEAU MESSAGE

    IF V_ENG.COD_TYP_MVT<>V_REF_OLD OR V_REF_OLD IS NULL THEN


   V_DER_IDE_MESSAGE:=V_DER_IDE_MESSAGE+1;

   V_ENG.COD_TYP_MVT :='D';
   V_MESSAGE.LIBL:=REPLACE(p_lib,' ',NULL)||'_ENGAGEMENTS SUR LA GESTION '||V_ENG.ide_gEST||' : '|| V_ENG.ide_ordo;



       -- NOMBRE DE PIECES : EFB_ENG

       SELECT COUNT(*) INTO V_MESSAGE.NBR_PIECE
	   FROM ZB_ENG_CG
       WHERE ide_ordo=V_ENG.ide_ordo AND COD_TYP_MVT=V_ENG.COD_TYP_MVT AND DLIG=1;

	   -- NOMBRE DE LIGNES DETAIL + LIGNE DE TêTES
	   SELECT COUNT(*) INTO V_MESSAGE.NBR_LIGNE
	   FROM ZB_ENG_CG
       WHERE ide_ordo=V_ENG.ide_ordo AND COD_TYP_MVT=V_ENG.COD_TYP_MVT;

	   V_MESSAGE.NBR_LIGNE:=V_MESSAGE.NBR_LIGNE+V_MESSAGE.NBR_PIECE;

      -- MONTANT TOTAL DES LIGNES DU MESSAGE EN DEBIT ET EN CREDIT
       SELECT SUM(mt)INTO V_MESSAGE.MT_CR FROM ZB_ENG_CG
	          WHERE ide_ordo=V_ENG.ide_ordo  AND COD_TYP_MVT=V_ENG.COD_TYP_MVT ;--AND V_ENG.DDAT=DDAT;?????????????????
       SELECT SUM(mt) INTO V_MESSAGE.MT_DB FROM ZB_ENG_CG
	          WHERE ide_ordo=V_ENG.ide_ordo  AND COD_TYP_MVT=V_ENG.COD_TYP_MVT ;--AND V_ENG.DDAT=DDAT;????????????????????

       V_MESSAGE.IDE_MESS:= V_DER_IDE_MESSAGE;
	   V_MESSAGE.REF_MESS:=V_MESSAGE.IDE_MESS;
	   V_MESSAGE.COD_TYP_MESS:='2';

       V_MESSAGE.IDE_GEST := V_ENG.ide_GEST;
   UTL_FILE.PUT_LINE(V_MES,	 'MESSAGE : "'            ||
                             V_MESSAGE.IDE_MESS       ||'"@"'||
                             V_MESSAGE.COD_TYP_ND     ||'"@"'||
                             V_MESSAGE.IDE_ND_EMET    ||'"@"'||
                             V_MESSAGE.COD_TYP_MESS   ||'"@"'||
                             V_MESSAGE.LIBL           ||'"@"'||
                             V_MESSAGE.REF_MESS       ||'"@"'||
                             V_MESSAGE.IDE_GEST       ||'"@"'||
                             V_MESSAGE.NUM_PRIO       ||'"@"'||
                             V_MESSAGE.NBR_LIGNE      ||'"@"'||
                             V_MESSAGE.COMMENTAIRE    ||'"@"'||
                             V_MESSAGE.FLG_EMIS_RECU2 ||'"@"'||
                             V_MESSAGE.IDE_ENV        ||'"@"'||
                             V_MESSAGE.IDE_SITE_EMET  ||'"@"'||
                             V_MESSAGE.IDE_SITE_DEST  ||'"@"'||
                             V_MESSAGE.IDE_DEPECHE    ||'"@"'||
                             V_MESSAGE.FLG_EMIS_RECU1 ||'"@"'||
                             V_MESSAGE.COD_TYP_ND1    ||'"@"'||
                             V_MESSAGE.IDE_ND_EMET1   ||'"@"'||
                             V_MESSAGE.IDE_MESS1      ||'"@"'||
                             V_MESSAGE.COD_STATUT     ||'"@"'||
                             V_MESSAGE.NBR_PIECE      ||'"@"'||
                             V_MESSAGE.COD_VERSION    ||'"@"'||
                             V_MESSAGE.MT_CR          ||'"@"'||
                             V_MESSAGE.MT_DB          ||'"@"'||
                             V_MESSAGE.NBR_DEST       ||'"' );
   -- ARTICLE : DESTINATAIRE
   V_DESTINATAIRE.IDE_MESS:=V_MESSAGE.IDE_MESS;
   V_DESTINATAIRE.IDE_ND_EMET :=V_ENG.ide_ordo;
   UTL_FILE.PUT_LINE(V_MES,	 'DESTINATAIRE : "'              ||
                             V_DESTINATAIRE.COD_TYP_ND_EMET  ||'"@"'||
                             V_DESTINATAIRE.IDE_ND_EMET      ||'"@"'||
							 V_DESTINATAIRE.IDE_MESS         ||'"@"'||
                             V_DESTINATAIRE.IDE_TYP_ND_DEST  ||'"@"'||
                             V_DESTINATAIRE.IDE_ND_DEST      ||'"'   );
   V_REF_OLD:= V_ENG.COD_TYP_MVT;
   V_NO_LIGNE:=0;
   END IF;

--
   -- TRAITEMENT DES LIGNES DETAIL DU MESSAGE
IF V_ENG.DLIG=1 THEN

     V_EFB_ENG.IDE_ND_EMET:=V_ENG.ide_ordo;
	 V_EFB_ENG.IDE_MESS:=V_MESSAGE.IDE_MESS;
     V_NO_LIGNE:=V_NO_LIGNE+1;
     V_EFB_ENG.IDE_LIG:=V_NO_LIGNE;
     V_EFB_ENG.IDE_GEST:=V_MESSAGE.IDE_GEST;
	 V_EFB_ENG.IDE_ORDO:=V_ENG.ide_ordo;
     V_EFB_ENG.IDE_ENG:=REPLACE(V_ENG.ide_eng,' ',NULL);
	 V_EFB_ENG.IDE_MESS1:=V_MESSAGE.IDE_MESS;
     V_EFB_ENG.COD_ENG:='P';
	 V_EFB_ENG.COD_TYP_MVT:=V_ENG.COD_TYP_MVT;
	 V_EFB_ENG.COD_NAT_DELEG:=V_ENG.COD_NAT_DELEG;
	 V_EFB_ENG.IDE_ENG_INIT:=REPLACE(V_ENG.ide_eng_INIT,' ',NULL);
	 V_EFB_ENG.DAT_EMIS:=V_ENG.DAT_EMIS;
	 V_EFB_ENG.DAT_CF:=NULL;
	 V_EFB_ENG.IDE_OPE:=V_ENG.ide_ope;
	 V_EFB_ENG.IDE_DEVISE:='EUR';
	 SELECT SUM(mt) INTO V_EFB_ENG.MT FROM ZB_ENG_CG
	        WHERE ide_eng=V_ENG.ide_eng
			AND ide_ordo=V_ENG.ide_ordo
			AND NVL(ide_ope,' ')=NVL(V_ENG.ide_ope,' ');
     V_EFB_ENG.LIBN:=V_ENG.LIBN;

 	 UTL_FILE.PUT_LINE(V_MES,  'EFB_ENG : "'||
        V_EFB_ENG.COD_TYP_ND      ||'"@"'||
        V_EFB_ENG.IDE_ND_EMET     ||'"@"'||
        V_EFB_ENG.IDE_MESS        ||'"@"'||
        V_EFB_ENG.IDE_LIG         ||'"@"'||
        V_EFB_ENG.TYP_BUFFER      ||'"@"'||
        V_EFB_ENG.COD_TYPE_OPE    ||'"@"'||
        V_EFB_ENG.IDE_POSTE       ||'"@"'||
	    V_EFB_ENG.IDE_GEST        ||'"@"'||
        V_EFB_ENG.IDE_ORDO        ||'"@"'||
        V_EFB_ENG.COD_BUD         ||'"@"'||
        V_EFB_ENG.IDE_ENG         ||'"@"'||
        V_EFB_ENG.IDE_MESS1       ||'"@"'||
        V_EFB_ENG.COD_ENG         ||'"@"'||
        V_EFB_ENG.COD_TYP_MVT     ||'"@"'||
        V_EFB_ENG.COD_NAT_DELEG   ||'"@"'||
		V_EFB_ENG.IDE_ENG_INIT    ||'"@"'||
        V_EFB_ENG.DAT_EMIS        ||'"@"'||
        V_EFB_ENG.DAT_CF          ||'"@"'||
		V_EFB_ENG.IDE_OPE         ||'"@"'||
        V_EFB_ENG.IDE_DEVISE      ||'"@"'||
		V_EFB_ENG.MT              ||'"@"'||
        V_EFB_ENG.LIBN            ||'"');
END IF;


     V_EFB_LIGNE_ENG.IDE_ND_EMET :=V_EFB_ENG.IDE_ND_EMET;
	 V_EFB_LIGNE_ENG.IDE_MESS  :=V_EFB_ENG.IDE_MESS;
     V_NO_LIGNE:=V_NO_LIGNE+1;
     V_EFB_LIGNE_ENG.IDE_LIG  :=V_NO_LIGNE;
     V_EFB_LIGNE_ENG.IDE_GEST:=V_MESSAGE.IDE_GEST;
	 V_EFB_LIGNE_ENG.IDE_ORDO:=V_ENG.ide_ordo;
	 V_EFB_LIGNE_ENG.IDE_ENG :=REPLACE(V_EFB_ENG.IDE_ENG,' ',NULL);
	 V_EFB_LIGNE_ENG.NUM_LIG  :=V_ENG.DLIG;
	 V_EFB_LIGNE_ENG.IDE_LIG_PREV :=V_ENG.IDE_LIG_PREV;
	 V_EFB_LIGNE_ENG.MT  :=V_ENG.mt;
	 V_EFB_LIGNE_ENG.MT_BUD   :=V_ENG.mt;
	 V_EFB_LIGNE_ENG.COD_TICAT:=V_ENG.COD_TITCAT;
	 V_EFB_LIGNE_ENG.COD_ACT_SSACT:=V_ENG.COD_ACT_SSACT;



  UTL_FILE.PUT_LINE(V_MES,  'EFB_LIGNE_ENG : "'||
	    V_EFB_LIGNE_ENG.COD_TYP_ND      ||'"@"'||
        V_EFB_LIGNE_ENG.IDE_ND_EMET     ||'"@"'||
        V_EFB_LIGNE_ENG.IDE_MESS        ||'"@"'||
        V_EFB_LIGNE_ENG.IDE_LIG         ||'"@"'||
        V_EFB_LIGNE_ENG.TYP_BUFFER      ||'"@"'||
        V_EFB_LIGNE_ENG.COD_TYPE_OPE    ||'"@"'||
		V_EFB_LIGNE_ENG.IDE_POSTE       ||'"@"'||
	    V_EFB_LIGNE_ENG.IDE_GEST        ||'"@"'||
        V_EFB_LIGNE_ENG.IDE_ORDO        ||'"@"'||
        V_EFB_LIGNE_ENG.COD_BUD         ||'"@"'||
        V_EFB_LIGNE_ENG.IDE_ENG         ||'"@"'||
		V_EFB_LIGNE_ENG.NUM_LIG         ||'"@"'||
		V_EFB_LIGNE_ENG.IDE_LIG_PREV    ||'"@"'||
		V_EFB_LIGNE_ENG.MT              ||'"@"'||
		V_EFB_LIGNE_ENG.MT_BUD          ||'"@"'||
		V_EFB_LIGNE_ENG.COD_TICAT       ||'"@"'||
		V_EFB_LIGNE_ENG.COD_ACT_SSACT||'"');

--
--
--
--
   END LOOP;
   CLOSE C_ENG;
   END;-- FIN DE TRAITEMENT DES ENG DE L'ORDONNATEUR
--
--
   --FERMETURE DE LA DEPECHE
   UTL_FILE.FCLOSE(V_MES);



   END LOOP; --FIN DU TRAITEMENT DE L'ORDONNATEUR
   CLOSE C_LISTE_DEPECHE;-- FERMETURE DE LA LISTE DES ORDO A TRAITER


   -- *******************************************************************************************
   -- TRAITEMENT DE LA DEUXIEME DEPECHE : ENGAGEMENT INITIAL N
   -- *******************************************************************************************


OPEN C_LISTE_DEPECHE_2;--BOUCLE DES ORDONNATEURS
LOOP  --BOUCLE DES ORDONNATEURS
FETCH C_LISTE_DEPECHE_2 INTO V_LISTE_SITE,v_liste_ide_ordo;
EXIT WHEN C_LISTE_DEPECHE_2%NOTFOUND;

-- UNE OU DEUX DEPECHE PAR ORDONNATEUR : CREATION D'UN MES
-- CHANGEMENT DE SITE EMETTEUR : INITIATION DES NUMEROS DE DEPECHE
IF V_SITE_OLD='' OR V_SITE_OLD<>V_LISTE_SITE THEN
   SELECT MAX(IDE_DEPECHE) INTO V_DER_IDE_DEPECHE FROM ZB_CG_DER_DEPECHES
   WHERE SITE_EMET=V_LISTE_SITE AND SITE_DEST=V_IDE_SITE_DEST;
   V_SITE_OLD:=V_LISTE_SITE;
END IF;
V_DER_IDE_DEPECHE:=V_DER_IDE_DEPECHE+1;
V_DEPECHE.IDE_DEPECHE:=V_DER_IDE_DEPECHE;

INSERT INTO ZB_CG_DER_DEPECHES (SITE_EMET,SITE_DEST,IDE_DEPECHE)
VALUES (V_LISTE_SITE,V_IDE_SITE_DEST,V_DER_IDE_DEPECHE);
COMMIT;





V_MES_NOM:= REPLACE('X_'||V_LISTE_SITE||'_'||V_IDE_SITE_DEST||'_'||LPAD(V_DER_IDE_DEPECHE,5,'0')||'.INV',' ',NULL);
UTL_FILE.PUT_LINE(V_REP_DEP_LOG2,V_PART1||V_MES_NOM||V_PART2||REPLACE(V_MES_NOM,'.INV','.DAT'));
V_MES:=UTL_FILE.FOPEN(P_MES_DIR,V_MES_NOM,'W');

               V_DEPECHE.IDE_SITE_EMET:=V_LISTE_SITE;
               V_DEPECHE.IDE_SITE_DEST:=V_IDE_SITE_DEST;
-- ARTICLE : DEPECHE

V_DEPECHE.IDE_DEPECHE:= V_DER_IDE_DEPECHE;



SELECT  COUNT(DISTINCT ide_ordo)  INTO  V_NBR_MES_ENG
       FROM ZB_ENG_CG
	   WHERE v_liste_ide_ordo=ide_ordo
	   AND ide_gest=p_ide_gest+1;
SELECT  COUNT(DISTINCT ide_ordo)  INTO  V_NBR_MES_mvt
       FROM ZB_MVT_BUD_CG
	   WHERE v_liste_ide_ordo=ide_ordo
	   AND ide_gest=p_ide_gest+1;

V_DEPECHE.NBR_MES:=V_NBR_MES_MVT+V_NBR_MES_ENG+V_NBR_MES_MANDAT;


UTL_FILE.PUT_LINE(V_MES,	'DEPECHE : "' ||
               V_DEPECHE.IDE_ENV       ||'"@"'||
               V_DEPECHE.IDE_SITE_EMET ||'"@"'||
               V_DEPECHE.IDE_SITE_DEST ||'"@"'||
               V_DEPECHE.IDE_DEPECHE   ||'"@"'||
               V_DEPECHE.DATE_CRE      ||'"@"'||
               V_DEPECHE.DAT_EMIS      ||'"@"'||
               V_DEPECHE.COD_SUPPORT   ||'"@"'||
               V_DEPECHE.NBR_MES       ||'"@"'||
               V_DEPECHE.FLG_MES_APPLI ||'"');


-- --   ***************************
-- --   TRAITEMENT DE L'ORDONNATEUR
-- --   ***************************
--
 V_MESSAGE.IDE_ND_EMET:=v_liste_ide_ordo;
 V_DER_IDE_MESSAGE :=z_cg_der_message(V_MESSAGE.IDE_ND_EMET,P_COD_TYP_ND_EMET);

--    ********************************************************************
--          TRAITEMENT DES MVT_BUD : NAPA ET DES CP DE L'ORDONNATEUR
--    ********************************************************************
   DECLARE
     CURSOR C_MVT IS
          SELECT *
   	      FROM   ZB_MVT_BUD_CG
		  WHERE IDE_ORDO=v_liste_ide_ordo
		  AND IDE_GEST=p_ide_gest+1;
    V_MVT         ZB_MVT_BUD_CG%ROWTYPE;
	V_REF_OLD CHAR(6):=NULL;

    BEGIN
V_CPT:=0;
    OPEN C_MVT;
    LOOP --TRAITEMENT DES MVT D'UN ORDONNATEUR
    FETCH C_MVT INTO V_MVT;
    EXIT WHEN C_MVT%NOTFOUND;


 V_CPT:=V_CPT+1;
   -- CREATION D'UN NOUVEAU MESSAGE
   IF V_CPT=1 THEN
   V_DER_IDE_MESSAGE:=V_DER_IDE_MESSAGE+1;

   V_MESSAGE.LIBL:=(REPLACE(p_lib,' ',NULL)||'_AFFECTATIONS SUR LA GESTION '|| v_mvt.ide_gest||' : '|| V_MVT.IDE_ORDO);

      -- NOMBRE DE LIGNES DETAILS DU MESSAGE DE TYPE EFB_MVTBUD
       SELECT COUNT(*) INTO V_NBRE_LIGNE_TOTAL
	          FROM ZB_MVT_BUD_CG
              WHERE IDE_ORDO=V_MVT.IDE_ORDO
	          AND IDE_GEST=p_ide_gest ;
	   V_MESSAGE.NBR_PIECE:= V_NBRE_LIGNE_TOTAL;
	   V_MESSAGE.NBR_LIGNE:= V_MESSAGE.NBR_PIECE;
      -- MONTANT TOTAL DES LIGNES DU MESSAGE EN DEBIT ET EN CREDIT
       SELECT SUM(MT),SUM(mt)INTO V_MESSAGE.MT_CR,V_MESSAGE.MT_DB
	          FROM ZB_MVT_BUD_CG
              WHERE IDE_ORDO=V_MVT.IDE_ORDO
	          AND IDE_GEST=p_ide_gest ;

       V_MESSAGE.IDE_MESS:= V_DER_IDE_MESSAGE;
	   V_MESSAGE.REF_MESS:=V_MESSAGE.IDE_MESS;
	   V_MESSAGE.COD_TYP_MESS:='7';
	   V_MESSAGE.IDE_GEST := p_ide_gest;

   UTL_FILE.PUT_LINE(V_MES,	 'MESSAGE : "'            ||
                             V_MESSAGE.IDE_MESS       ||'"@"'||
                             V_MESSAGE.COD_TYP_ND     ||'"@"'||
                             V_MESSAGE.IDE_ND_EMET    ||'"@"'||
                             V_MESSAGE.COD_TYP_MESS   ||'"@"'||
                             V_MESSAGE.LIBL           ||'"@"'||
                             V_MESSAGE.REF_MESS       ||'"@"'||
                             V_MESSAGE.IDE_GEST       ||'"@"'||
                             V_MESSAGE.NUM_PRIO       ||'"@"'||
                             V_MESSAGE.NBR_LIGNE      ||'"@"'||
                             V_MESSAGE.COMMENTAIRE    ||'"@"'||
                             V_MESSAGE.FLG_EMIS_RECU2 ||'"@"'||
                             V_MESSAGE.IDE_ENV        ||'"@"'||
                             V_MESSAGE.IDE_SITE_EMET  ||'"@"'||
                             V_MESSAGE.IDE_SITE_DEST  ||'"@"'||
                             V_MESSAGE.IDE_DEPECHE    ||'"@"'||
                             V_MESSAGE.FLG_EMIS_RECU1 ||'"@"'||
                             V_MESSAGE.COD_TYP_ND1    ||'"@"'||
                             V_MESSAGE.IDE_ND_EMET1   ||'"@"'||
                             V_MESSAGE.IDE_MESS1      ||'"@"'||
                             V_MESSAGE.COD_STATUT     ||'"@"'||
                             V_MESSAGE.NBR_PIECE      ||'"@"'||
                             V_MESSAGE.COD_VERSION    ||'"@"'||
                             V_MESSAGE.MT_CR          ||'"@"'||
                             V_MESSAGE.MT_DB          ||'"@"'||
                             V_MESSAGE.NBR_DEST       ||'"' );
   -- ARTICLE : DESTINATAIRE
   V_DESTINATAIRE.IDE_MESS:=V_MESSAGE.IDE_MESS;
   V_DESTINATAIRE.IDE_ND_EMET :=V_MVT.IDE_ORDO;
   UTL_FILE.PUT_LINE(V_MES,	 'DESTINATAIRE : "'              ||
                             V_DESTINATAIRE.COD_TYP_ND_EMET  ||'"@"'||
                             V_DESTINATAIRE.IDE_ND_EMET      ||'"@"'||
							 V_DESTINATAIRE.IDE_MESS         ||'"@"'||
                             V_DESTINATAIRE.IDE_TYP_ND_DEST  ||'"@"'||
                             V_DESTINATAIRE.IDE_ND_DEST      ||'"'   );

END IF;


   -- TRAITEMENT DES LIGNES DETAIL DU MESSAGE
       V_NO_LIGNE:=V_NO_LIGNE+1;
       V_EFB_MVTBUD.IDE_LIG:=V_NO_LIGNE;
       V_EFB_MVTBUD.IDE_ND_EMET:=V_MVT.IDE_ORDO;
	   V_EFB_MVTBUD.IDE_ND_EMET1:=V_MVT.IDE_ORDO;
	   V_EFB_MVTBUD.IDE_MESS:=V_MESSAGE.IDE_MESS;
	   V_EFB_MVTBUD.IDE_MESS1:=V_MESSAGE.IDE_MESS;
	   V_EFB_MVTBUD.NUM_MVT:=V_MVT.NUM_MVT;
	   V_EFB_MVTBUD.IDE_GEST := p_ide_gest;
	   V_EFB_MVTBUD.IDE_GEST:=V_MESSAGE.IDE_GEST;
	   V_EFB_MVTBUD.IDE_ORDO:=V_MVT.IDE_ORDO;
	   V_EFB_MVTBUD.IDE_LIG_PREV:=V_MVT.IDE_LIG_PREV;
	   V_EFB_MVTBUD.COD_NAT_MVT:=V_MVT.COD_NAT_MVT;
	   V_EFB_MVTBUD.MT:=V_MVT.MT;
	   V_EFB_MVTBUD.NUM_MVT_INIT:=V_MVT.NUM_MVT_INIT;
	   V_EFB_MVTBUD.NUM_LIG:=1;
	   V_EFB_MVTBUD.DAT_REF:=V_MVT.DAT_REF;
	   V_EFB_MVTBUD.IDE_OPE:=V_MVT.IDE_OPE;
       V_EFB_MVTBUD.support:=V_MVT.support;
	   UTL_FILE.PUT_LINE(V_MES,  'EFB_MVT_BUD : "'||
	                          V_EFB_MVTBUD.COD_TYP_ND          ||'"@"'||
                              V_EFB_MVTBUD.IDE_ND_EMET         ||'"@"'||
                              V_EFB_MVTBUD.IDE_MESS            ||'"@"'||
                              V_EFB_MVTBUD.IDE_LIG             ||'"@"'||
                              V_EFB_MVTBUD.TYP_BUFFER          ||'"@"'||
                              V_EFB_MVTBUD.COD_TYPE_OPE        ||'"@"'||
                      	      V_EFB_MVTBUD.IDE_POSTE           ||'"@"'||
                              V_EFB_MVTBUD.CODE_TYP_ND_EMET    ||'"@"'||
							  V_EFB_MVTBUD.IDE_ND_EMET1        ||'"@"'||
                              V_EFB_MVTBUD.IDE_MESS1           ||'"@"'||
                              V_EFB_MVTBUD.NUM_MVT             ||'"@"'||
							  V_EFB_MVTBUD.NUM_LIG             ||'"@"'||
                              V_EFB_MVTBUD.NUM_MVT_INIT        ||'"@"'||
                              V_EFB_MVTBUD.IDE_GEST            ||'"@"'||
                              V_EFB_MVTBUD.COD_BUD             ||'"@"'||
                              V_EFB_MVTBUD.IDE_ORDO            ||'"@"'||
                              V_EFB_MVTBUD.IDE_LIG_PREV        ||'"@"'||
                              V_EFB_MVTBUD.COD_NAT_MVT         ||'"@"'||
                              V_EFB_MVTBUD.COD_ORIG_BENEF      ||'"@"'||
                              V_EFB_MVTBUD.IDE_OPE             ||'"@"'||
                              V_EFB_MVTBUD.MT                  ||'"@"'||
                              V_EFB_MVTBUD.DAT_REF             ||'"@"'||
                              V_EFB_MVTBUD.SUPPORT             ||'"');
-- --
    END LOOP; --TRAITEMENT DES MVT DE L'ORDONNATEUR
    CLOSE C_MVT;
    END;-- FIN DE TRAITEMENT DES MVT DE L'ORDONNATEUR

-- --    *****************************************************
-- --    TRAITEMENT DES ENG DE L'ORDONNATEUR : TC_DEP_ENG
-- --    *****************************************************
   DECLARE
     CURSOR C_ENG IS

          SELECT *
   	      FROM   ZB_ENG_CG
		  WHERE ide_ordo=v_liste_ide_ordo AND COD_TYP_MVT='I'
		  ORDER BY COD_TYP_MVT,ide_ordo,ide_eng_init,ide_eng,DLIG ;

    V_ENG         ZB_ENG_CG%ROWTYPE;
	V_REF_OLD VARCHAR2(5):=NULL;

   BEGIN


   OPEN C_ENG;
   LOOP
   FETCH C_ENG INTO V_ENG;
   EXIT WHEN C_ENG%NOTFOUND;

   -- CREATION D'UN NOUVEAU MESSAGE

    IF V_ENG.COD_TYP_MVT<>V_REF_OLD OR V_REF_OLD IS NULL THEN


   V_DER_IDE_MESSAGE:=V_DER_IDE_MESSAGE+1;
   V_ENG.COD_TYP_MVT :='I';
   V_MESSAGE.LIBL:=REPLACE(p_lib,' ',NULL)||'_ENGAGEMENTS SUR LA GESTION '||V_ENG.ide_GEST||' : '|| V_ENG.ide_ordo;

       -- NOMBRE DE PIECES : EFB_ENG
       SELECT COUNT(*) INTO V_MESSAGE.NBR_PIECE
	   FROM ZB_ENG_CG
       WHERE ide_ordo=V_ENG.ide_ordo AND COD_TYP_MVT=V_ENG.COD_TYP_MVT AND DLIG=1;

	   -- NOMBRE DE LIGNES DETAIL + LIGNE DE TêTES
	   SELECT COUNT(*) INTO V_MESSAGE.NBR_LIGNE
	   FROM ZB_ENG_CG
       WHERE ide_ordo=V_ENG.ide_ordo AND COD_TYP_MVT=V_ENG.COD_TYP_MVT;

	   V_MESSAGE.NBR_LIGNE:=V_MESSAGE.NBR_LIGNE+V_MESSAGE.NBR_PIECE;
	   -- NOMBRE DE LIGNES DETAIL + LIGNE DE TêTES
	   SELECT COUNT(*) INTO V_MESSAGE.NBR_LIGNE
	   FROM ZB_ENG_CG
       WHERE ide_ordo=v_eng.ide_ordo AND COD_TYP_MVT=V_ENG.COD_TYP_MVT;
	   V_MESSAGE.NBR_LIGNE:=V_MESSAGE.NBR_LIGNE+V_MESSAGE.NBR_PIECE;

      -- MONTANT TOTAL DES LIGNES DU MESSAGE EN DEBIT ET EN CREDIT
       SELECT SUM(mt)INTO V_MESSAGE.MT_CR FROM ZB_ENG_CG
	          WHERE ide_ordo=v_eng.ide_ordo  AND COD_TYP_MVT=V_ENG.COD_TYP_MVT ;--AND V_ENG.DDAT=DDAT;?????????????????
       SELECT SUM(mt) INTO V_MESSAGE.MT_DB FROM ZB_ENG_CG
	          WHERE ide_ordo=v_eng.ide_ordo  AND COD_TYP_MVT=V_ENG.COD_TYP_MVT ;--AND V_ENG.DDAT=DDAT;?????????????????

       V_MESSAGE.IDE_MESS:= V_DER_IDE_MESSAGE;
	   V_MESSAGE.REF_MESS:=V_MESSAGE.IDE_MESS;
	   V_MESSAGE.COD_TYP_MESS:='2';

       V_MESSAGE.IDE_GEST := v_eng.ide_gest;

   UTL_FILE.PUT_LINE(V_MES,	 'MESSAGE : "'            ||
                             V_MESSAGE.IDE_MESS       ||'"@"'||
                             V_MESSAGE.COD_TYP_ND     ||'"@"'||
                             V_MESSAGE.IDE_ND_EMET    ||'"@"'||
                             V_MESSAGE.COD_TYP_MESS   ||'"@"'||
                             V_MESSAGE.LIBL           ||'"@"'||
                             V_MESSAGE.REF_MESS       ||'"@"'||
                             V_MESSAGE.IDE_GEST       ||'"@"'||
                             V_MESSAGE.NUM_PRIO       ||'"@"'||
                             V_MESSAGE.NBR_LIGNE      ||'"@"'||
                             V_MESSAGE.COMMENTAIRE    ||'"@"'||
                             V_MESSAGE.FLG_EMIS_RECU2 ||'"@"'||
                             V_MESSAGE.IDE_ENV        ||'"@"'||
                             V_MESSAGE.IDE_SITE_EMET  ||'"@"'||
                             V_MESSAGE.IDE_SITE_DEST  ||'"@"'||
                             V_MESSAGE.IDE_DEPECHE    ||'"@"'||
                             V_MESSAGE.FLG_EMIS_RECU1 ||'"@"'||
                             V_MESSAGE.COD_TYP_ND1    ||'"@"'||
                             V_MESSAGE.IDE_ND_EMET1   ||'"@"'||
                             V_MESSAGE.IDE_MESS1      ||'"@"'||
                             V_MESSAGE.COD_STATUT     ||'"@"'||
                             V_MESSAGE.NBR_PIECE      ||'"@"'||
                             V_MESSAGE.COD_VERSION    ||'"@"'||
                             V_MESSAGE.MT_CR          ||'"@"'||
                             V_MESSAGE.MT_DB          ||'"@"'||
                             V_MESSAGE.NBR_DEST       ||'"' );

   -- ARTICLE : DESTINATAIRE
   V_DESTINATAIRE.IDE_MESS:=V_MESSAGE.IDE_MESS;
   V_DESTINATAIRE.IDE_ND_EMET :=v_eng.ide_ordo;
   UTL_FILE.PUT_LINE(V_MES,	 'DESTINATAIRE : "'              ||
                             V_DESTINATAIRE.COD_TYP_ND_EMET  ||'"@"'||
                             V_DESTINATAIRE.IDE_ND_EMET      ||'"@"'||
							 V_DESTINATAIRE.IDE_MESS         ||'"@"'||
                             V_DESTINATAIRE.IDE_TYP_ND_DEST  ||'"@"'||
                             V_DESTINATAIRE.IDE_ND_DEST      ||'"'   );
   V_REF_OLD:= V_ENG.COD_TYP_MVT;
   V_NO_LIGNE:=0;
   END IF;

      -- TRAITEMENT DES LIGNES DETAIL DU MESSAGE
IF V_ENG.DLIG=1 THEN

     V_EFB_ENG.IDE_ND_EMET:=v_eng.ide_ordo;
	 V_EFB_ENG.IDE_MESS:=V_MESSAGE.IDE_MESS;
     V_NO_LIGNE:=V_NO_LIGNE+1;
     V_EFB_ENG.IDE_LIG:=V_NO_LIGNE;
     V_EFB_ENG.IDE_GEST:=V_MESSAGE.IDE_GEST;
	 V_EFB_ENG.IDE_ORDO:=v_eng.ide_ordo;
     V_EFB_ENG.IDE_ENG:=REPLACE(v_eng.ide_eng,' ',NULL);
	 V_EFB_ENG.IDE_MESS1:=V_MESSAGE.IDE_MESS;
     V_EFB_ENG.COD_ENG:='P';
	 V_EFB_ENG.COD_TYP_MVT:=V_ENG.COD_TYP_MVT;
	 V_EFB_ENG.COD_NAT_DELEG:=V_ENG.COD_NAT_DELEG;
	 V_EFB_ENG.IDE_ENG_INIT:=REPLACE(V_ENG.ide_eng_init,' ',NULL);
	 V_EFB_ENG.DAT_EMIS:=V_ENG.DAT_EMIS;
	 V_EFB_ENG.DAT_CF:=NULL;
	 V_EFB_ENG.IDE_OPE:=V_ENG.ide_ope;
	 V_EFB_ENG.IDE_DEVISE:='EUR';
	 SELECT SUM(mt) INTO V_EFB_ENG.MT FROM ZB_ENG_CG
	        WHERE ide_eng=v_eng.ide_eng
			AND ide_ordo=v_eng.ide_ordo
			AND NVL(ide_ope,' ')=NVL(V_ENG.ide_ope,' ');
     V_EFB_ENG.LIBN:=V_ENG.LIBN;
 	 UTL_FILE.PUT_LINE(V_MES,  'EFB_ENG : "'||
        V_EFB_ENG.COD_TYP_ND      ||'"@"'||
        V_EFB_ENG.IDE_ND_EMET     ||'"@"'||
        V_EFB_ENG.IDE_MESS        ||'"@"'||
        V_EFB_ENG.IDE_LIG         ||'"@"'||
        V_EFB_ENG.TYP_BUFFER      ||'"@"'||
        V_EFB_ENG.COD_TYPE_OPE    ||'"@"'||
        V_EFB_ENG.IDE_POSTE       ||'"@"'||
	    V_EFB_ENG.IDE_GEST        ||'"@"'||
        V_EFB_ENG.IDE_ORDO        ||'"@"'||
        V_EFB_ENG.COD_BUD         ||'"@"'||
        V_EFB_ENG.IDE_ENG         ||'"@"'||
        V_EFB_ENG.IDE_MESS1       ||'"@"'||
        V_EFB_ENG.COD_ENG         ||'"@"'||
        V_EFB_ENG.COD_TYP_MVT     ||'"@"'||
        V_EFB_ENG.COD_NAT_DELEG   ||'"@"'||
		V_EFB_ENG.IDE_ENG_INIT    ||'"@"'||
        V_EFB_ENG.DAT_EMIS        ||'"@"'||
        V_EFB_ENG.DAT_CF          ||'"@"'||
		V_EFB_ENG.IDE_OPE         ||'"@"'||
        V_EFB_ENG.IDE_DEVISE      ||'"@"'||
		V_EFB_ENG.MT              ||'"@"'||
        V_EFB_ENG.LIBN            ||'"');
END IF;


     V_EFB_LIGNE_ENG.IDE_ND_EMET :=V_EFB_ENG.IDE_ND_EMET;
	 V_EFB_LIGNE_ENG.IDE_MESS  :=V_EFB_ENG.IDE_MESS;
     V_NO_LIGNE:=V_NO_LIGNE+1;
     V_EFB_LIGNE_ENG.IDE_LIG  :=V_NO_LIGNE;
     V_EFB_LIGNE_ENG.IDE_GEST:=V_MESSAGE.IDE_GEST;
	 V_EFB_LIGNE_ENG.IDE_ORDO:=v_eng.ide_ordo;
	 V_EFB_LIGNE_ENG.IDE_ENG :=REPLACE(V_EFB_ENG.IDE_ENG,' ',NULL);
	 V_EFB_LIGNE_ENG.NUM_LIG  :=V_ENG.DLIG;
	 V_EFB_LIGNE_ENG.IDE_LIG_PREV :=V_ENG.IDE_LIG_PREV;
	 V_EFB_LIGNE_ENG.MT  :=V_ENG.mt;
	 V_EFB_LIGNE_ENG.MT_BUD   :=V_ENG.mt;
	 V_EFB_LIGNE_ENG.COD_TICAT:=V_ENG.COD_TITCAT;
	 V_EFB_LIGNE_ENG.COD_ACT_SSACT:=V_ENG.COD_ACT_SSACT;


  UTL_FILE.PUT_LINE(V_MES,  'EFB_LIGNE_ENG : "'||
	    V_EFB_LIGNE_ENG.COD_TYP_ND      ||'"@"'||
        V_EFB_LIGNE_ENG.IDE_ND_EMET     ||'"@"'||
        V_EFB_LIGNE_ENG.IDE_MESS        ||'"@"'||
        V_EFB_LIGNE_ENG.IDE_LIG         ||'"@"'||
        V_EFB_LIGNE_ENG.TYP_BUFFER      ||'"@"'||
        V_EFB_LIGNE_ENG.COD_TYPE_OPE    ||'"@"'||
		V_EFB_LIGNE_ENG.IDE_POSTE       ||'"@"'||
	    V_EFB_LIGNE_ENG.IDE_GEST        ||'"@"'||
        V_EFB_LIGNE_ENG.IDE_ORDO        ||'"@"'||
        V_EFB_LIGNE_ENG.COD_BUD         ||'"@"'||
        V_EFB_LIGNE_ENG.IDE_ENG         ||'"@"'||
		V_EFB_LIGNE_ENG.NUM_LIG         ||'"@"'||
		V_EFB_LIGNE_ENG.IDE_LIG_PREV    ||'"@"'||
		V_EFB_LIGNE_ENG.MT              ||'"@"'||
		V_EFB_LIGNE_ENG.MT_BUD          ||'"@"'||
		V_EFB_LIGNE_ENG.COD_TICAT       ||'"@"'||
		V_EFB_LIGNE_ENG.COD_ACT_SSACT||'"');

   END LOOP;
   CLOSE C_ENG;
   END;-- FIN DE TRAITEMENT DES ENG DE L'ORDONNATEUR




   --FERMETURE DE LA DEPECHE
   UTL_FILE.FCLOSE(V_MES);

   END LOOP; --FIN DU TRAITEMENT DE L'ORDONNATEUR
   CLOSE C_LISTE_DEPECHE_2;-- FERMETURE DE LA LISTE DES ORDO A TRAITER

   -- FIN DE TRAITEMENT DU DEUXIèME ENVOI

UTL_FILE.FCLOSE(V_REP_DEP_LOG1);
UTL_FILE.FCLOSE(V_REP_DEP_LOG2);


   EXCEPTION
   WHEN UTL_FILE.INVALID_PATH           THEN DBMS_OUTPUT.PUT_LINE('INVALID PATH');
   WHEN UTL_FILE.INVALID_MODE           THEN DBMS_OUTPUT.PUT_LINE('INVALID MODE');
   WHEN UTL_FILE.INVALID_FILEHANDLE     THEN DBMS_OUTPUT.PUT_LINE('INVALID_FILEHANDLE');
   WHEN UTL_FILE.INVALID_OPERATION      THEN DBMS_OUTPUT.PUT_LINE('INVALID_OPERATION');
   WHEN UTL_FILE.WRITE_ERROR            THEN DBMS_OUTPUT.PUT_LINE('WRITE_ERROR');
   WHEN UTL_FILE.INTERNAL_ERROR         THEN DBMS_OUTPUT.PUT_LINE('INTERNAL_ERROR');
  WHEN OTHERS                          THEN
  V_ERROR_CODE:=SQLCODE;V_ERROR_MESSAGE:=SQLERRM;
  DBMS_OUTPUT.PUT_LINE (V_ERROR_CODE||' : '||V_ERROR_MESSAGE);
   END Z_MES_DEP_CG;

/

CREATE OR REPLACE PROCEDURE Z_MES_DEP_INTER (p_ide_poste VARCHAR2,p_lib VARCHAR2,p_prog_origine VARCHAR2)
IS
----------------------------------------------------------------------------------
-- FICHIER        : FUNCTION Z_MES_DEP_INTER
-- DATE CREATION  : 18/03/2008
-- AUTEUR         : ISABELLE LARONDE
--
-- LOGICIEL       : ASTER
-- SOUS-SYSTEME   : NOM
-- DESCRIPTION    : CREATION DU FICHIER RETOUR VERS COREGE UAG SIFAA
----------------------------------------------------------------------------------------------------
--                                                    |VERSION     |DATE      |INITIALES    |COMMENTAIRES
---------------------------------------------------------------------------------------------------
-- Z_MES_DEP_INTER              | 1.0        |28/05/2007| ILE         |
----------------------------------------------------------------------------------
-- PARAMETRES ------------
-- P_IDE_POSTE  :  POSTE
-- P_LIB  : LIBELLE DES DEPECHES
-- P_PROG_ORIGINE : UDEP_009B (ENGAGEMENTS) UDEP_012B (NAPAS) UDEP_013B(CRéDITS)
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- VARIABLES D'IDENTIFICATION
----------------------------------------------------------------------------------------------
P_MES_DIR             VARCHAR2(50);
V_IDE_SITE_DEST       VARCHAR2(5);
P_IDE_SITE            VARCHAR2(5);
P_VERSION             VARCHAR2(50);
P_COD_TYP_ND_EMET     CHAR(1):='O';
P_COD_TYP_ND_DEST     CHAR(1):='P';
v_ide_poste           VARCHAR2(6);
P_COD_BUD             VARCHAR2(5):='BGDEP';
v_cpt                 NUMBER(6);
V_ERROR_CODE          NUMBER;
V_ERROR_MESSAGE       VARCHAR2(255);
v_unite               CHAR(1);
v_base                VARCHAR2(10);
V_CPT_MANDAT          NUMBER(6);
V_IDE_SITE_EMET      VARCHAR2(5);
V_NO_IDE_MES         NUMBER(8) :=1;
V_NO_LIGNE_TOTAL     NUMBER(5) :=0;
V_NBRE_LIGNE_TOTAL   NUMBER(5) :=0;
V_NO_LIGNE           NUMBER(6) :=0;
V_DATE_SAISIE_OLD    DATE      := NULL;
V_SITE_OLD           VARCHAR2(5):=' ';
V_NBRE_ECRITURES     NUMBER(5);
V_DER_IDE_DEPECHE    NUMBER(6);
V_DER_IDE_MESSAGE    NUMBER(8);
V_NBR_MES_MVT        NUMBER(5):=0;
V_NBR_MES            NUMBER(5):=0;
V_MES_NOM            VARCHAR2(100);
V_MES                UTL_FILE.FILE_TYPE; --FICHIER MES
V_REP_DEP_LOG1       UTL_FILE.FILE_TYPE; --LISTE DES DEPECHES
V_NO                 NUMBER(6); -- POUR REPERER UNE CASSURE PAR LOT DE MANDATS
V_PART1              CHAR(25):='copy %unite%:\%base%\mes\';
V_PART2              CHAR(31):=' %unite%:\astersrv\exp\bal\rec\';
v_ref                VARCHAR2(15):=NULL;
v_liste2             VARCHAR2(20);

-- DESCRIPTIONS DES TYPES D'ARTICLES NECESSAIRES A LA CONFECTION D'UN MES
TYPE DEPECHE_TYPE IS RECORD(
IDE_ENV       CHAR(1)    :='X',
IDE_SITE_EMET VARCHAR2(5),
IDE_SITE_DEST VARCHAR2(5),
IDE_DEPECHE   NUMBER(6)  ,
DATE_CRE      CHAR(8)    :=TO_CHAR(SYSDATE,'YYYYMMDD') ,
DAT_EMIS      CHAR(8)    :=TO_CHAR(SYSDATE,'YYYYMMDD'),
COD_SUPPORT   NUMBER(6)  :=NULL , --FACULTATIF
NBR_MES       NUMBER(5)  ,
FLG_MES_APPLI CHAR(1)    :='O');
V_DEPECHE          DEPECHE_TYPE;

TYPE MESSAGE_TYPE IS RECORD(
IDE_MESS      NUMBER(8),
COD_TYP_ND    VARCHAR2(1)   ,
IDE_ND_EMET   VARCHAR2(15)  ,
COD_TYP_MESS  NUMBER(2)     ,
LIBL          VARCHAR2(120) ,
REF_MESS      NUMBER(8)     ,
IDE_GEST      VARCHAR2(7)   ,
NUM_PRIO      NUMBER(5,2)   :=100,
NBR_LIGNE     NUMBER(6)     ,
COMMENTAIRE   VARCHAR2(120) :=NULL,--FACULTATIF
FLG_EMIS_RECU2 VARCHAR2(1)  :=NULL,--FACULTATIF
IDE_ENV       VARCHAR2(1)   :=NULL,--FACULTATIF
IDE_SITE_EMET VARCHAR2(5)   :=NULL,--FACULTATIF
IDE_SITE_DEST VARCHAR2(5)   :=NULL,--FACULTATIF
IDE_DEPECHE   NUMBER(6)     :=NULL,--FACULTATIF
FLG_EMIS_RECU1 VARCHAR2(1)  :=NULL,--FACULTATIF
COD_TYP_ND1   VARCHAR2(1)   :=NULL,--FACULTATIF
IDE_ND_EMET1  VARCHAR2(15)  :=NULL,--FACULTATIF
IDE_MESS1     NUMBER(8)     :=NULL,--FACULTATIF
COD_STATUT    VARCHAR2(2)   :=NULL,--FACULTATIF
NBR_PIECE     NUMBER(6)     ,
COD_VERSION   VARCHAR2(15)  ,
MT_CR         NUMBER(18,3)  ,
MT_DB         NUMBER(18,3)  ,
NBR_DEST      NUMBER(6)     :=1);
V_MESSAGE          MESSAGE_TYPE;

TYPE DESTINATAIRE_TYPE IS RECORD(
COD_TYP_ND_EMET     CHAR(1)     ,
IDE_ND_EMET         VARCHAR2(15),
IDE_MESS            NUMBER(8)   ,
IDE_TYP_ND_DEST     CHAR(1)    ,
IDE_ND_DEST         VARCHAR2(15));
V_DESTINATAIRE      DESTINATAIRE_TYPE;

TYPE EFB_MVTBUD_TYPE IS RECORD(
COD_TYP_ND          CHAR(1)      :=P_COD_TYP_ND_EMET,
IDE_ND_EMET         VARCHAR2(15) ,
IDE_MESS            NUMBER(8) ,
IDE_LIG             NUMBER(5) ,
TYP_BUFFER          VARCHAR2(32) :='EFB_MVT_BUD',
COD_TYPE_OPE        CHAR(1)      :='I',
IDE_POSTE           VARCHAR2(15) :=P_IDE_POSTE,
CODE_TYP_ND_EMET    CHAR(1)      :=P_COD_TYP_ND_EMET,
IDE_ND_EMET1        VARCHAR2(15) ,
IDE_MESS1           NUMBER(8)    ,
NUM_MVT             VARCHAR2(20),
NUM_LIG             NUMBER(4)    ,
NUM_MVT_INIT        NUMBER(20)    :=NULL,
IDE_GEST            VARCHAR2(7)  ,
COD_BUD             VARCHAR2(5)  := P_COD_BUD,
IDE_ORDO            VARCHAR2(15) ,
IDE_LIG_PREV        VARCHAR2(30) ,
COD_NAT_MVT         VARCHAR2(10) ,
COD_ORIG_BENEF      CHAR(1)      :='B',
IDE_OPE             VARCHAR2(20) ,
MT                  NUMBER(18,3) ,
DAT_REF             CHAR(8),
SUPPORT             VARCHAR2(45) := NULL,
FLG_CENTRA          CHAR(1):= NULL);
V_EFB_MVTBUD        EFB_MVTBUD_TYPE;

TYPE EFB_ENG_TYPE IS RECORD(
COD_TYP_ND      CHAR(1)      ,
IDE_ND_EMET     VARCHAR2(15) ,
IDE_MESS        NUMBER(8) ,
IDE_LIG         NUMBER(5) ,
TYP_BUFFER      VARCHAR2(32) :='EFB_ENG',
COD_TYPE_OPE    CHAR(1)      :='I',
IDE_POSTE       VARCHAR2(15) ,
IDE_GEST        VARCHAR2 (7) ,
IDE_ORDO        VARCHAR2 (15),
COD_BUD         VARCHAR2 (5) ,
IDE_ENG         VARCHAR2 (20) ,
IDE_MESS1       NUMBER (8)   ,
COD_ENG         CHAR (1)     ,
COD_TYP_MVT     CHAR (1)     ,
COD_NAT_DELEG   CHAR(1),
IDE_ENG_INIT    VARCHAR2 (20),
DAT_EMIS        CHAR(8)   ,
DAT_CF          CHAR(8),
IDE_OPE         VARCHAR2 (20),
IDE_DEVISE      VARCHAR2(5),
MT              NUMBER (18,3) ,
LIBN            VARCHAR2 (45),
IDE_OPE_RENUM   VARCHAR2(20):= NULL,
IDE_ENG_RENUM   VARCHAR2(20):= NULL,
FLG_CENTRA      CHAR(1) := NULL);
V_EFB_ENG       EFB_ENG_TYPE;
TYPE EFB_LIGNE_ENG_TYPE IS RECORD(
COD_TYP_ND      CHAR(1)      ,
IDE_ND_EMET     VARCHAR2(15) ,
IDE_MESS        NUMBER(8) ,
IDE_LIG         NUMBER(5) ,
TYP_BUFFER      VARCHAR2(32) :='EFB_LIGNE_ENG',
COD_TYPE_OPE    CHAR(1)      :='I',
IDE_POSTE       VARCHAR2(15) ,
IDE_GEST        VARCHAR2 (7) ,
IDE_ORDO        VARCHAR2 (15),
COD_BUD         VARCHAR2 (5) ,
IDE_ENG         VARCHAR2 (20) ,
NUM_LIG         NUMBER(4),
IDE_LIG_PREV    VARCHAR2(30),
MT              NUMBER(18,3),
MT_BUD          NUMBER(18,3),
COD_TICAT       NUMBER(7),
COD_ACT_SSACT   NUMBER(7));
V_EFB_LIGNE_ENG EFB_LIGNE_ENG_TYPE;
----------------------------------------------------------------------------------------------
--CURSEURS
----------------------------------------------------------------------------------------------
-- DETERMINATION DES ORDONNATEUR CONCERNES PAR LA REPRISE
   -- PREMIER ENVOI : DEGAGEMENTS N-1
   --------------------------------------------------
    CURSOR C_LISTE_DEPECHE IS
	SELECT DISTINCT ide_site,ide_ordo,ide_gest FROM(
	--INTERFACE DES CRéDITS
	SELECT  'ACC01' ide_site ,ide_ordo,ide_gest FROM ZB_INTERFACE_CRED zb
	WHERE  p_prog_origine='UDEP_013B' AND code_ret_4 ='E' AND cani IS NULL
	UNION ALL
	--INTERFACE DES NAPAS
	SELECT   DISTINCT 'ACC02' ide_site ,IDE_ORDO ,ide_gest FROM ZB_INTERFACE_NAPA zb
	WHERE   p_prog_origine='UDEP_012B' AND code_ret_4 ='E' AND cani IS NULL
	UNION ALL
	--INTERFACE DES ENGAGEMENTS
	SELECT  DISTINCT 'COR02' ide_site ,ide_ordo,ide_gest FROM ZB_INTERFACE_ENG zb
	WHERE  p_prog_origine='UDEP_009B'	AND code_ret_2 ='E' AND cani IS NULL
			)	ORDER BY ide_site,ide_ordo,ide_gest	;

----------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------
--RECHERCHE DU DERNIER NUMERO DE MESSAGE
    FUNCTION Z_cg_DER_MESSAGE(P_IDE_ND_EMET VARCHAR2,P_COD_TYP_ND_EMET CHAR)
    RETURN NUMBER
    IS
    V_DER_MESSAGE NUMBER(6);
    BEGIN
        SELECT NVL(MAX(IDE_MESS),0)
              INTO V_DER_MESSAGE
              FROM FM_MESSAGE
              WHERE IDE_ND_EMET=P_IDE_ND_EMET AND COD_TYP_ND=P_COD_TYP_ND_EMET;
        RETURN(V_DER_MESSAGE);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN(-1);
    END Z_cg_DER_MESSAGE;

--RECHERCHE DU DERNIER NUMERO DE DEPECHE
    FUNCTION Z_cg_deR_DEPECHE(
         P_IDE_ENV             CHAR,
         P_IDE_SITE_EMET       VARCHAR2,
         P_IDE_SITE_DEST       VARCHAR2)
    RETURN NUMBER
    IS
    V_DER_DEPECHE NUMBER(6);
    BEGIN
        SELECT NVL(MAX(IDE_DEPECHE),0)
             INTO V_DER_DEPECHE
             FROM FM_DEPECHE
             WHERE IDE_ENV=P_IDE_ENV AND IDE_SITE_EMET=P_IDE_SITE_EMET AND IDE_SITE_DEST=P_IDE_SITE_DEST;
        RETURN(V_DER_DEPECHE);
    END Z_cg_deR_DEPECHE;
-------------------------------------------------------------------------------------------------------------
--                                     PROCEDURE GENERALE
-------------------------------------------------------------------------------------------------------------
BEGIN
    -- IDENTIFICATION DU POSTE
    SELECT DISTINCT IDE_POSTE INTO V_IDE_POSTE FROM FH_UT_PU;
    SELECT VAL_PARAM INTO P_VERSION FROM SR_PARAM WHERE  COD_TYP_CODIF='VERSION';
    SELECT IDE_SITE INTO V_IDE_SITE_DEST FROM RM_NOEUD WHERE COD_TYP_ND='P' AND IDE_ND=V_IDE_POSTE;
    SELECT IDE_SITE INTO P_IDE_SITE FROM RM_NOEUD WHERE COD_TYP_ND='P' AND IDE_ND=V_IDE_POSTE;
    SELECT REPLACE(VAL_PARAM,' ',NULL) INTO P_MES_DIR FROM SR_PARAM WHERE COD_TYP_CODIF='NOM_REP' AND IDE_PARAM='IR0011';
    SELECT VAL_PARAM INTO V_BASE FROM SR_PARAM WHERE IDE_PARAM='IR0044';
    SELECT SUBSTR(VAL_PARAM,1,1)INTO V_UNITE FROM SR_PARAM WHERE IDE_PARAM='IR0011';

    -- DONNéES FIXES POUR LES ARTICLES DES MESSAGES
    V_DEPECHE.IDE_SITE_EMET              :=P_IDE_SITE;
    V_DEPECHE.IDE_SITE_DEST              :=P_IDE_SITE;
    V_MESSAGE.COD_TYP_ND                 :=P_COD_TYP_ND_EMET;
    V_MESSAGE.COD_VERSION                :=SUBSTR(P_VERSION,1,15);
    V_DESTINATAIRE.COD_TYP_ND_EMET       :=P_COD_TYP_ND_EMET;
    V_DESTINATAIRE.IDE_TYP_ND_DEST       :=P_COD_TYP_ND_DEST;
    V_DESTINATAIRE.IDE_ND_DEST           :=V_IDE_POSTE;
    V_EFB_ENG.COD_TYP_ND                 :=P_COD_TYP_ND_EMET;
    V_EFB_ENG.IDE_POSTE                  :=V_IDE_POSTE;
    V_EFB_ENG.COD_BUD                    :=P_COD_BUD;
    V_EFB_LIGNE_ENG.COD_TYP_ND           :=P_COD_TYP_ND_EMET;
    V_EFB_LIGNE_ENG.IDE_POSTE            :=V_IDE_POSTE;
    V_EFB_LIGNE_ENG.COD_BUD              :=P_COD_BUD;

    -- PREPARATION DES 3 FICHIERS RECAPITULATIFS

    V_REP_DEP_LOG1:=UTL_FILE.FOPEN(P_MES_DIR,REPLACE(REPLACE(P_LIB,' ',NULL)||'.BAT',' ',NULL),'W');

    UTL_FILE.FCLOSE(V_REP_DEP_LOG1);
    V_REP_DEP_LOG1:=UTL_FILE.FOPEN(P_MES_DIR,REPLACE(REPLACE(P_LIB,' ',NULL)||'.BAT',' ',NULL),'A');

    --INITIALISATION DU BAT DU PREMIER LOT DE DEPECHES
    UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,':DEBUT');
    UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,'CLS');
    UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,'SET UNITE='||REPLACE(V_UNITE,' ',NULL));
    UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,'SET BASE='||REPLACE(V_BASE,' ',NULL));
    UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,':TRAIT');

    -- ***************************************************************
    -- TRAITEMENT DE LA PREMIERE DEPECHE : DEGAGEMENTS  BNAPA ET RNAPA SUR N-1
    -- ***************************************************************
    FOR V_LISTE IN C_LISTE_DEPECHE LOOP
        -- UNE OU DEUX DEPECHE PAR ORDONNATEUR : CREATION D'UN MES
        -- CHANGEMENT DE SITE EMETTEUR : INITIALISATION DES NUMEROS DE DEPECHE
        IF V_REF IS NULL OR V_REF<>V_LISTE.IDE_SITE THEN
            V_DER_IDE_DEPECHE:=Z_CG_DER_DEPECHE('X',V_LISTE.IDE_SITE,V_IDE_SITE_DEST);
            V_REF:=V_LISTE.IDE_SITE;
        END IF;

        V_DER_IDE_DEPECHE:=V_DER_IDE_DEPECHE+1;
        V_DEPECHE.IDE_DEPECHE:=V_DER_IDE_DEPECHE;

        --LISTE PREMIER ENVOI
        IF p_prog_origine='UDEP_009B' THEN
            V_MES_NOM:= REPLACE('X_'||V_LISTE.IDE_SITE||'_'||V_IDE_SITE_DEST||'_'||LPAD(V_DER_IDE_DEPECHE,5,'0')||'.ENG',' ',NULL);
            UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,V_PART1||V_MES_NOM||V_PART2||REPLACE(V_MES_NOM,'.ENG','.DAT'));
        ELSIF p_prog_origine='UDEP_012B' THEN
            V_MES_NOM:= REPLACE('X_'||V_LISTE.IDE_SITE||'_'||V_IDE_SITE_DEST||'_'||LPAD(V_DER_IDE_DEPECHE,5,'0')||'.NAPA',' ',NULL);
            UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,V_PART1||V_MES_NOM||V_PART2||REPLACE(V_MES_NOM,'.NAPA','.DAT'));
        ELSIF p_prog_origine='UDEP_013B' THEN
            V_MES_NOM:= REPLACE('X_'||V_LISTE.IDE_SITE||'_'||V_IDE_SITE_DEST||'_'||LPAD(V_DER_IDE_DEPECHE,5,'0')||'.CRED',' ',NULL);
            UTL_FILE.PUT_LINE(V_REP_DEP_LOG1,V_PART1||V_MES_NOM||V_PART2||REPLACE(V_MES_NOM,'.CRED','.DAT'));
        END IF;

        V_MES:=UTL_FILE.FOPEN(P_MES_DIR,V_MES_NOM,'W');
                       V_DEPECHE.IDE_SITE_EMET:=V_LISTE.IDE_SITE;
                       V_DEPECHE.IDE_SITE_DEST:=V_IDE_SITE_DEST;
        -- ARTICLE : DEPECHE
        V_DEPECHE.IDE_DEPECHE:= V_DER_IDE_DEPECHE;

        --NBRE ORDO POUR LES  :  DEGAGEMENTS+ BNAPA+RNAPA SUR P_IDE_GEST
        V_NBR_MES_MVT:=NULL;
        IF p_prog_origine='UDEP_009B' THEN
            SELECT COUNT(DISTINCT IDE_ORDO)  INTO    V_NBR_MES
                  FROM ZB_INTERFACE_ENG
                  WHERE V_LISTE.IDE_ORDO=IDE_ORDO
                  AND IDE_GEST=V_LISTE.IDE_GEST;
        ELSIF p_prog_origine='UDEP_012B' THEN
            SELECT COUNT(DISTINCT IDE_ORDO)  INTO    V_NBR_MES
                  FROM ZB_INTERFACE_NAPA
                  WHERE V_LISTE.IDE_ORDO=IDE_ORDO
                  AND IDE_GEST=V_LISTE.IDE_GEST;
        ELSIF p_prog_origine='UDEP_013B' THEN
            SELECT COUNT(DISTINCT IDE_ORDO)  INTO    V_NBR_MES
                  FROM ZB_INTERFACE_CRED
                  WHERE V_LISTE.IDE_ORDO=IDE_ORDO
                  AND IDE_GEST=V_LISTE.IDE_GEST;
        END IF;

        V_DEPECHE.NBR_MES:=V_NBR_MES;
        UTL_FILE.PUT_LINE(V_MES,	'DEPECHE : "' ||
                       V_DEPECHE.IDE_ENV       ||'"@"'||
                       V_DEPECHE.IDE_SITE_EMET ||'"@"'||
                       V_DEPECHE.IDE_SITE_DEST ||'"@"'||
                       V_DEPECHE.IDE_DEPECHE   ||'"@"'||
                       V_DEPECHE.DATE_CRE      ||'"@"'||
                       V_DEPECHE.DAT_EMIS      ||'"@"'||
                       V_DEPECHE.COD_SUPPORT   ||'"@"'||
                       V_DEPECHE.NBR_MES       ||'"@"'||
                       V_DEPECHE.FLG_MES_APPLI ||'"');

        -- --   ***************************
        -- --   TRAITEMENT DE L'ORDONNATEUR
        -- --   ***************************--
         V_MESSAGE.IDE_ND_EMET:=V_LISTE.IDE_ORDO;
         V_DER_IDE_MESSAGE :=Z_CG_DER_MESSAGE(V_MESSAGE.IDE_ND_EMET,P_COD_TYP_ND_EMET);
        --    ********************************************************************
        --          TRAITEMENT DES MVT_BUD : NAPA ET DES CP DE L'ORDONNATEUR
        --    ********************************************************************
           DECLARE

             CURSOR C_MVT IS
             SELECT * FROM(
             SELECT
             noseq,
             IDE_POSTE,
             NUM_MVT_BUD,
             NULL NUM_MVT_INIT,
             IDE_GEST,
             IDE_ORDO,
             IDE_LIG_PREV,
             COD_NAT_MVT,
             IDE_OPE ,
             MT   ,
             DAT_REF,
             SUPPORT
             FROM   ZB_INTERFACE_CRED
             WHERE IDE_ORDO=V_LISTE.IDE_ORDO
             AND IDE_GEST=V_LISTE.IDE_GEST AND P_PROG_ORIGINE='UDEP_013B' AND CODE_RET_4 ='E' AND CANI IS NULL
             UNION ALL
             SELECT
             noseq,
             IDE_POSTE,
             NUM_MVT_BUD,
             NUM_MVT_INIT,
             IDE_GEST,
             IDE_ORDO,
             IDE_LIG_PREV,
             COD_NAT_MVT,
             IDE_OPE ,
             MT   ,
             DAT_REF,
             SUPPORT
             FROM   ZB_INTERFACE_NAPA
             WHERE IDE_ORDO=V_LISTE.IDE_ORDO
             AND IDE_GEST=V_LISTE.IDE_GEST AND P_PROG_ORIGINE='UDEP_012B' AND CODE_RET_4 ='E' AND CANI IS NULL
             )ORDER BY NOSEQ;

            V_REF_OLD CHAR(6):=NULL;
            BEGIN

                V_CPT:=0;
                FOR V_MVT IN C_MVT LOOP
                    V_CPT:=V_CPT+1;
                   -- CREATION D'UN NOUVEAU MESSAGE
                    IF V_CPT=1 THEN
                           V_NO_LIGNE:=0;
                           V_DER_IDE_MESSAGE:=V_DER_IDE_MESSAGE+1;

                           IF P_PROG_ORIGINE='UDEP_012B' THEN
                              V_MESSAGE.LIBL:=(REPLACE(P_LIB,' ',NULL)||'_ACCORD (NAPA) SUR LA GESTION '|| V_MVT.IDE_GEST||' : '|| V_MVT.IDE_ORDO);
                           ELSIF P_PROG_ORIGINE='UDEP_013B' THEN
                              V_MESSAGE.LIBL:=(REPLACE(P_LIB,' ',NULL)||'_ACCORD (CREDITS) SUR LA GESTION '|| V_MVT.IDE_GEST||' : '|| V_MVT.IDE_ORDO);
                           END IF;



                          -- NOMBRE DE LIGNES DETAILS DU MESSAGE DE TYPE EFB_MVTBUD
                          IF P_PROG_ORIGINE='UDEP_012B' THEN--INTERFACE DES NAPA
                                SELECT COUNT(*) INTO V_NBRE_LIGNE_TOTAL
                                      FROM ZB_INTERFACE_NAPA
                                      WHERE IDE_ORDO=V_MVT.IDE_ORDO
                                      AND IDE_GEST=V_MVT.IDE_GEST
                                      AND cani IS NULL AND code_ret_4='E';
                              -- MONTANT TOTAL DES LIGNES DU MESSAGE EN DEBIT ET EN CREDIT
                               SELECT SUM(MT),SUM(MT)INTO V_MESSAGE.MT_CR,V_MESSAGE.MT_DB
                                      FROM ZB_INTERFACE_NAPA
                                      WHERE IDE_ORDO=V_MVT.IDE_ORDO
                                      AND IDE_GEST=V_MVT.IDE_GEST
                                      AND cani IS NULL AND code_ret_4='E';
                          ELSIF P_PROG_ORIGINE='UDEP_013B' THEN --INTERFACE DES CREDITS
                                 SELECT COUNT(*) INTO V_NBRE_LIGNE_TOTAL
                                  FROM ZB_INTERFACE_CRED
                                  WHERE IDE_ORDO=V_MVT.IDE_ORDO
                                  AND IDE_GEST=V_MVT.IDE_GEST
                                  AND cani IS NULL AND code_ret_4='E';
                                  -- MONTANT TOTAL DES LIGNES DU MESSAGE EN DEBIT ET EN CREDIT
                                   SELECT SUM(MT),SUM(MT)INTO V_MESSAGE.MT_CR,V_MESSAGE.MT_DB
                                          FROM ZB_INTERFACE_CRED
                                          WHERE IDE_ORDO=V_MVT.IDE_ORDO
                                          AND IDE_GEST=V_MVT.IDE_GEST
                                          AND cani IS NULL AND code_ret_4='E';
                          END IF;

                           V_MESSAGE.NBR_PIECE:= V_NBRE_LIGNE_TOTAL;
                           V_MESSAGE.NBR_LIGNE:= V_MESSAGE.NBR_PIECE;
                           V_MESSAGE.IDE_MESS:= V_DER_IDE_MESSAGE;
                           V_MESSAGE.REF_MESS:=V_MESSAGE.IDE_MESS;
                           V_MESSAGE.COD_TYP_MESS:='7';
                           V_MESSAGE.IDE_GEST := V_MVT.IDE_GEST;
                           UTL_FILE.PUT_LINE(V_MES,	 'MESSAGE : "'            ||
                                                     V_MESSAGE.IDE_MESS       ||'"@"'||
                                                     V_MESSAGE.COD_TYP_ND     ||'"@"'||
                                                     V_MESSAGE.IDE_ND_EMET    ||'"@"'||
                                                     V_MESSAGE.COD_TYP_MESS   ||'"@"'||
                                                     V_MESSAGE.LIBL           ||'"@"'||
                                                     V_MESSAGE.REF_MESS       ||'"@"'||
                                                     V_MESSAGE.IDE_GEST       ||'"@"'||
                                                     V_MESSAGE.NUM_PRIO       ||'"@"'||
                                                     V_MESSAGE.NBR_LIGNE      ||'"@"'||
                                                     V_MESSAGE.COMMENTAIRE    ||'"@"'||
                                                     V_MESSAGE.FLG_EMIS_RECU2 ||'"@"'||
                                                     V_MESSAGE.IDE_ENV        ||'"@"'||
                                                     V_MESSAGE.IDE_SITE_EMET  ||'"@"'||
                                                     V_MESSAGE.IDE_SITE_DEST  ||'"@"'||
                                                     V_MESSAGE.IDE_DEPECHE    ||'"@"'||
                                                     V_MESSAGE.FLG_EMIS_RECU1 ||'"@"'||
                                                     V_MESSAGE.COD_TYP_ND1    ||'"@"'||
                                                     V_MESSAGE.IDE_ND_EMET1   ||'"@"'||
                                                     V_MESSAGE.IDE_MESS1      ||'"@"'||
                                                     V_MESSAGE.COD_STATUT     ||'"@"'||
                                                     V_MESSAGE.NBR_PIECE      ||'"@"'||
                                                     V_MESSAGE.COD_VERSION    ||'"@"'||
                                                     V_MESSAGE.MT_CR          ||'"@"'||
                                                     V_MESSAGE.MT_DB          ||'"@"'||
                                                     V_MESSAGE.NBR_DEST       ||'"' );
                           -- ARTICLE : DESTINATAIRE
                           V_DESTINATAIRE.IDE_MESS:=V_MESSAGE.IDE_MESS;
                           V_DESTINATAIRE.IDE_ND_EMET :=V_MVT.IDE_ORDO;
                           UTL_FILE.PUT_LINE(V_MES,	 'DESTINATAIRE : "'              ||
                                                     V_DESTINATAIRE.COD_TYP_ND_EMET  ||'"@"'||
                                                     V_DESTINATAIRE.IDE_ND_EMET      ||'"@"'||
                                                     V_DESTINATAIRE.IDE_MESS         ||'"@"'||
                                                     V_DESTINATAIRE.IDE_TYP_ND_DEST  ||'"@"'||
                                                     V_DESTINATAIRE.IDE_ND_DEST      ||'"'   );

                    END IF;


                   -- TRAITEMENT DES LIGNES DETAIL DU MESSAGE
                       V_NO_LIGNE:=V_NO_LIGNE+1;
                       V_EFB_MVTBUD.IDE_LIG:=V_NO_LIGNE;
                       V_EFB_MVTBUD.IDE_ND_EMET:=V_MVT.IDE_ORDO;
                       V_EFB_MVTBUD.IDE_ND_EMET1:=V_MVT.IDE_ORDO;
                       V_EFB_MVTBUD.IDE_MESS:=V_MESSAGE.IDE_MESS;
                       V_EFB_MVTBUD.IDE_MESS1:=V_MESSAGE.IDE_MESS;
                       V_EFB_MVTBUD.NUM_MVT:=V_MVT.NUM_MVT_bud;
                       V_EFB_MVTBUD.IDE_GEST := V_MVT.IDE_GEST;
                       V_EFB_MVTBUD.IDE_GEST:=V_MESSAGE.IDE_GEST;
                       V_EFB_MVTBUD.IDE_ORDO:=V_MVT.IDE_ORDO;
                       V_EFB_MVTBUD.IDE_LIG_PREV:=V_MVT.IDE_LIG_PREV;
                       V_EFB_MVTBUD.COD_NAT_MVT:=V_MVT.COD_NAT_MVT;
                       V_EFB_MVTBUD.MT:=V_MVT.MT;
                       V_EFB_MVTBUD.NUM_MVT_INIT:=V_MVT.NUM_MVT_INIT;
                       V_EFB_MVTBUD.NUM_LIG:=1;
                       V_EFB_MVTBUD.DAT_REF:=V_MVT.DAT_REF;
                       V_EFB_MVTBUD.IDE_OPE:=V_MVT.IDE_OPE;
                       V_EFB_MVTBUD.SUPPORT:=V_MVT.SUPPORT;
                       UTL_FILE.PUT_LINE(V_MES,  'EFB_MVT_BUD : "'||
                                              V_EFB_MVTBUD.COD_TYP_ND          ||'"@"'||
                                              V_EFB_MVTBUD.IDE_ND_EMET         ||'"@"'||
                                              V_EFB_MVTBUD.IDE_MESS            ||'"@"'||
                                              V_EFB_MVTBUD.IDE_LIG             ||'"@"'||
                                              V_EFB_MVTBUD.TYP_BUFFER          ||'"@"'||
                                              V_EFB_MVTBUD.COD_TYPE_OPE        ||'"@"'||
                                              V_EFB_MVTBUD.IDE_POSTE           ||'"@"'||
                                              V_EFB_MVTBUD.CODE_TYP_ND_EMET    ||'"@"'||
                                              V_EFB_MVTBUD.IDE_ND_EMET1        ||'"@"'||
                                              V_EFB_MVTBUD.IDE_MESS1           ||'"@"'||
                                              V_EFB_MVTBUD.NUM_MVT             ||'"@"'||
                                              V_EFB_MVTBUD.NUM_LIG             ||'"@"'||
                                              V_EFB_MVTBUD.NUM_MVT_INIT        ||'"@"'||
                                              V_EFB_MVTBUD.IDE_GEST            ||'"@"'||
                                              V_EFB_MVTBUD.COD_BUD             ||'"@"'||
                                              V_EFB_MVTBUD.IDE_ORDO            ||'"@"'||
                                              V_EFB_MVTBUD.IDE_LIG_PREV        ||'"@"'||
                                              V_EFB_MVTBUD.COD_NAT_MVT         ||'"@"'||
                                              V_EFB_MVTBUD.COD_ORIG_BENEF      ||'"@"'||
                                              V_EFB_MVTBUD.IDE_OPE             ||'"@"'||
                                              V_EFB_MVTBUD.MT                  ||'"@"'||
                                              V_EFB_MVTBUD.DAT_REF             ||'"@"'||
                                              V_EFB_MVTBUD.SUPPORT             ||'"@"'||
                                              V_EFB_MVTBUD.FLG_CENTRA||'"');

                    END LOOP; --TRAITEMENT DES MVT DE L'ORDONNATEUR

            END;-- FIN DE TRAITEMENT DES MVT_BUD DE L'ORDONNATEUR

        --    *****************************************************
        --    TRAITEMENT DES DEGAGEMENTS DE L'ORDONNATEUR
        --    *****************************************************

        DECLARE
        CURSOR liste_eng IS
            SELECT * FROM ZB_INTERFACE_ENG
            WHERE code_ret_2='E'
            AND   IDE_GEST=V_LISTE.IDE_GEST
            AND    P_PROG_ORIGINE='UDEP_009B'
            AND cani IS NULL
            AND ide_ordo=V_LISTE.ide_ordo
            ORDER BY noseq;
        BEGIN
            FOR V_eng IN LISTE_ENG LOOP --BOUCLE DES ENGAGEMENT DE L'ORDONNATEUR EN COURS
                 V_CPT:=V_CPT+1;
                   -- CREATION D'UN NOUVEAU MESSAGE
                   IF V_CPT=1 THEN
                    V_DER_IDE_MESSAGE:=V_DER_IDE_MESSAGE+1;
                     V_MESSAGE.LIBL:=(REPLACE(P_LIB,' ',NULL)||'_'|| V_eng.IDE_GEST||' : '|| V_eng.IDE_ORDO);
                      -- NOMBRE DE LIGNES DETAILS DU MESSAGE DE TYPE EFB_MVTBUD
                       SELECT COUNT(*) INTO V_NBRE_LIGNE_TOTAL
                              FROM ZB_INTERFACE_ENG
                              WHERE IDE_ORDO=V_eng.IDE_ORDO
                              AND IDE_GEST=V_eng.IDE_GEST
                              AND cani IS NULL AND code_ret_2='E' ;
                      -- MONTANT TOTAL DES LIGNES DU MESSAGE EN DEBIT ET EN CREDIT
                       SELECT SUM(MT),SUM(MT)INTO V_MESSAGE.MT_CR,V_MESSAGE.MT_DB
                              FROM ZB_INTERFACE_ENG
                              WHERE IDE_ORDO=V_eng.IDE_ORDO
                              AND IDE_GEST=V_eng.IDE_GEST
                              AND cani IS NULL AND code_ret_2='E' ;
                       V_MESSAGE.NBR_PIECE:= V_NBRE_LIGNE_TOTAL;
                       V_MESSAGE.NBR_LIGNE:= V_MESSAGE.NBR_PIECE*2;
                       V_MESSAGE.IDE_MESS:= V_DER_IDE_MESSAGE;
                       V_MESSAGE.REF_MESS:=V_MESSAGE.IDE_MESS;
                       V_MESSAGE.COD_TYP_MESS:='2';
                       V_MESSAGE.IDE_GEST := V_eng.IDE_GEST;
                       UTL_FILE.PUT_LINE(V_MES,	 'MESSAGE : "'            ||
                                                 V_MESSAGE.IDE_MESS       ||'"@"'||
                                                 V_MESSAGE.COD_TYP_ND     ||'"@"'||
                                                 V_MESSAGE.IDE_ND_EMET    ||'"@"'||
                                                 V_MESSAGE.COD_TYP_MESS   ||'"@"'||
                                                 V_MESSAGE.LIBL           ||'"@"'||
                                                 V_MESSAGE.REF_MESS       ||'"@"'||
                                                 V_MESSAGE.IDE_GEST       ||'"@"'||
                                                 V_MESSAGE.NUM_PRIO       ||'"@"'||
                                                 V_MESSAGE.NBR_LIGNE      ||'"@"'||
                                                 V_MESSAGE.COMMENTAIRE    ||'"@"'||
                                                 V_MESSAGE.FLG_EMIS_RECU2 ||'"@"'||
                                                 V_MESSAGE.IDE_ENV        ||'"@"'||
                                                 V_MESSAGE.IDE_SITE_EMET  ||'"@"'||
                                                 V_MESSAGE.IDE_SITE_DEST  ||'"@"'||
                                                 V_MESSAGE.IDE_DEPECHE    ||'"@"'||
                                                 V_MESSAGE.FLG_EMIS_RECU1 ||'"@"'||
                                                 V_MESSAGE.COD_TYP_ND1    ||'"@"'||
                                                 V_MESSAGE.IDE_ND_EMET1   ||'"@"'||
                                                 V_MESSAGE.IDE_MESS1      ||'"@"'||
                                                 V_MESSAGE.COD_STATUT     ||'"@"'||
                                                 V_MESSAGE.NBR_PIECE      ||'"@"'||
                                                 V_MESSAGE.COD_VERSION    ||'"@"'||
                                                 V_MESSAGE.MT_CR          ||'"@"'||
                                                 V_MESSAGE.MT_DB          ||'"@"'||
                                                 V_MESSAGE.NBR_DEST       ||'"' );
                       -- ARTICLE : DESTINATAIRE
                       V_DESTINATAIRE.IDE_MESS:=V_MESSAGE.IDE_MESS;
                       V_DESTINATAIRE.IDE_ND_EMET :=V_eng.IDE_ORDO;
                       UTL_FILE.PUT_LINE(V_MES,	 'DESTINATAIRE : "'              ||
                                                 V_DESTINATAIRE.COD_TYP_ND_EMET  ||'"@"'||
                                                 V_DESTINATAIRE.IDE_ND_EMET      ||'"@"'||
                                                 V_DESTINATAIRE.IDE_MESS         ||'"@"'||
                                                 V_DESTINATAIRE.IDE_TYP_ND_DEST  ||'"@"'||
                                                 V_DESTINATAIRE.IDE_ND_DEST      ||'"'   );

                END IF;

                   -- TRAITEMENT DES LIGNES DETAIL DU MESSAGE
                     V_EFB_ENG.IDE_ND_EMET:=V_ENG.IDE_ORDO;
                     V_EFB_ENG.IDE_MESS:=V_MESSAGE.IDE_MESS;
                     V_NO_LIGNE:=V_NO_LIGNE+1;
                     V_EFB_ENG.IDE_LIG:=V_NO_LIGNE;
                     V_EFB_ENG.IDE_GEST:=V_MESSAGE.IDE_GEST;
                     V_EFB_ENG.IDE_ORDO:=V_ENG.IDE_ORDO;
                     V_EFB_ENG.IDE_ENG:=REPLACE(V_ENG.IDE_ENG,' ',NULL);
                     V_EFB_ENG.IDE_MESS1:=V_MESSAGE.IDE_MESS;
                     V_EFB_ENG.COD_ENG:='P';
                     V_EFB_ENG.COD_TYP_MVT:=V_ENG.COD_TYP_MVT;
                     V_EFB_ENG.COD_NAT_DELEG:=V_ENG.COD_NAT_DELEG;
                     V_EFB_ENG.IDE_ENG_INIT:=REPLACE(V_ENG.IDE_ENG_INIT,' ',NULL);
                     V_EFB_ENG.DAT_EMIS:=V_ENG.DAT_EMIS;
                     V_EFB_ENG.DAT_CF:=NULL;
                     V_EFB_ENG.IDE_OPE:=V_ENG.IDE_OPE;
                     V_EFB_ENG.IDE_DEVISE:='EUR';
                     V_EFB_ENG.MT :=v_eng.mt;
                     V_EFB_ENG.LIBN:=V_ENG.LIBN;
                     UTL_FILE.PUT_LINE(V_MES,  'EFB_ENG : "'||
                        V_EFB_ENG.COD_TYP_ND      ||'"@"'||
                        V_EFB_ENG.IDE_ND_EMET     ||'"@"'||
                        V_EFB_ENG.IDE_MESS        ||'"@"'||
                        V_EFB_ENG.IDE_LIG         ||'"@"'||
                        V_EFB_ENG.TYP_BUFFER      ||'"@"'||
                        V_EFB_ENG.COD_TYPE_OPE    ||'"@"'||
                        V_EFB_ENG.IDE_POSTE       ||'"@"'||
                        V_EFB_ENG.IDE_GEST        ||'"@"'||
                        V_EFB_ENG.IDE_ORDO        ||'"@"'||
                        V_EFB_ENG.COD_BUD         ||'"@"'||
                        V_EFB_ENG.IDE_ENG         ||'"@"'||
                        V_EFB_ENG.IDE_MESS1       ||'"@"'||
                        V_EFB_ENG.COD_ENG         ||'"@"'||
                        V_EFB_ENG.COD_TYP_MVT     ||'"@"'||
                        V_EFB_ENG.COD_NAT_DELEG   ||'"@"'||
                        V_EFB_ENG.IDE_ENG_INIT    ||'"@"'||
                        V_EFB_ENG.DAT_EMIS        ||'"@"'||
                        V_EFB_ENG.DAT_CF          ||'"@"'||
                        V_EFB_ENG.IDE_OPE         ||'"@"'||
                        V_EFB_ENG.IDE_DEVISE      ||'"@"'||
                        V_EFB_ENG.MT              ||'"@"'||
                        V_EFB_ENG.LIBN            ||'"@"'||
                        V_EFB_ENG.IDE_OPE_RENUM   ||'"@"'||
                        V_EFB_ENG.IDE_ENG_RENUM   ||'"@"'||
                        V_EFB_ENG.FLG_CENTRA      ||'"');

                     V_EFB_LIGNE_ENG.IDE_ND_EMET :=V_EFB_ENG.IDE_ND_EMET;
                     V_EFB_LIGNE_ENG.IDE_MESS  :=V_EFB_ENG.IDE_MESS;
                     V_NO_LIGNE:=V_NO_LIGNE+1;
                     V_EFB_LIGNE_ENG.IDE_LIG  :=V_NO_LIGNE;
                     V_EFB_LIGNE_ENG.IDE_GEST:=V_MESSAGE.IDE_GEST;
                     V_EFB_LIGNE_ENG.IDE_ORDO:=V_ENG.IDE_ORDO;
                     V_EFB_LIGNE_ENG.IDE_ENG :=REPLACE(V_EFB_ENG.IDE_ENG,' ',NULL);
                     V_EFB_LIGNE_ENG.NUM_LIG  :=1;
                     V_EFB_LIGNE_ENG.IDE_LIG_PREV :=V_ENG.IDE_LIG_PREV;
                     V_EFB_LIGNE_ENG.MT  :=V_ENG.MT;
                     V_EFB_LIGNE_ENG.MT_BUD   :=V_ENG.MT;
                     V_EFB_LIGNE_ENG.COD_TICAT:=V_ENG.COD_TITCAT;
                     V_EFB_LIGNE_ENG.COD_ACT_SSACT:=V_ENG.COD_ACT_SSACT;

                  UTL_FILE.PUT_LINE(V_MES,  'EFB_LIGNE_ENG : "'||
                        V_EFB_LIGNE_ENG.COD_TYP_ND      ||'"@"'||
                        V_EFB_LIGNE_ENG.IDE_ND_EMET     ||'"@"'||
                        V_EFB_LIGNE_ENG.IDE_MESS        ||'"@"'||
                        V_EFB_LIGNE_ENG.IDE_LIG         ||'"@"'||
                        V_EFB_LIGNE_ENG.TYP_BUFFER      ||'"@"'||
                        V_EFB_LIGNE_ENG.COD_TYPE_OPE    ||'"@"'||
                        V_EFB_LIGNE_ENG.IDE_POSTE       ||'"@"'||
                        V_EFB_LIGNE_ENG.IDE_GEST        ||'"@"'||
                        V_EFB_LIGNE_ENG.IDE_ORDO        ||'"@"'||
                        V_EFB_LIGNE_ENG.COD_BUD         ||'"@"'||
                        V_EFB_LIGNE_ENG.IDE_ENG         ||'"@"'||
                        V_EFB_LIGNE_ENG.NUM_LIG         ||'"@"'||
                        V_EFB_LIGNE_ENG.IDE_LIG_PREV    ||'"@"'||
                        V_EFB_LIGNE_ENG.MT              ||'"@"'||
                        V_EFB_LIGNE_ENG.MT_BUD          ||'"@"'||
                        V_EFB_LIGNE_ENG.COD_TICAT       ||'"@"'||
                        V_EFB_LIGNE_ENG.COD_ACT_SSACT||'"');
           END LOOP;--FIN DE LA BOUCLE DES ENGAGEMENT DE L'ORDONNATEUR EN COURS
         END;
       --FERMETURE DE LA DEPECHE
       UTL_FILE.FCLOSE(V_MES);
   END LOOP; --FIN DU TRAITEMENT DE L'ORDONNATEUR
   UTL_FILE.FCLOSE(V_REP_DEP_LOG1);
   EXCEPTION
   WHEN UTL_FILE.INVALID_PATH           THEN DBMS_OUTPUT.PUT_LINE('INVALID PATH');
   WHEN UTL_FILE.INVALID_MODE           THEN DBMS_OUTPUT.PUT_LINE('INVALID MODE');
   WHEN UTL_FILE.INVALID_FILEHANDLE     THEN DBMS_OUTPUT.PUT_LINE('INVALID_FILEHANDLE');
   WHEN UTL_FILE.INVALID_OPERATION      THEN DBMS_OUTPUT.PUT_LINE('INVALID_OPERATION');
   WHEN UTL_FILE.WRITE_ERROR            THEN DBMS_OUTPUT.PUT_LINE('WRITE_ERROR');
   WHEN UTL_FILE.INTERNAL_ERROR         THEN DBMS_OUTPUT.PUT_LINE('INTERNAL_ERROR');
   WHEN OTHERS                          THEN
   V_ERROR_CODE:=SQLCODE;V_ERROR_MESSAGE:=SQLERRM;
   DBMS_OUTPUT.PUT_LINE (V_ERROR_CODE||' : '||V_ERROR_MESSAGE);
   END Z_Mes_Dep_inter;

/

CREATE OR REPLACE PROCEDURE CAL_TX_CHANGE_DEVISE(p_ide_devise       RB_TXCHANGE.ide_devise%TYPE,
                                                p_date   RB_TXCHANGE.dat_application%TYPE,
												p_val_taux          IN OUT RB_TXCHANGE.val_taux%TYPE,
												p_dat_application   IN OUT RB_TXCHANGE.dat_application%TYPE
                                          ) IS
/*
-- 	----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : REF
-- Nom           : CAL_TX_CHANGE_DEVISE
-- ---------------------------------------------------------------------------
--  Auteur         : SGN
--  Date creation  : 18/03/2002
-- ---------------------------------------------------------------------------
-- Role          : Calcul d un taux de change. Si la devise n est pas renseigne
--                 on prend la devise de reference
--
-- Parametres  entree  :
-- 				 1 - p_ide_devise : identifiant interne de la devise dont on veut le taux
--				 2 - p_date : date pour laquelle on veut le taux de change
--
-- Parametre sorties :
--				 3 - p_val_taux : taux de change a retourner
--				 4 - p_dat_application : dat application de la devise a retourner
--
-- ---------------------------------------------------------------------------
--  Version        : @(#) CAL_TX_CHANGE_DEVISE.sql version 3.0-1.0
-- ---------------------------------------------------------------------------
--
-- 	-----------------------------------------------------------------------------------------------------
-- 	Fonction					   	|Date	    |Initiales	|Commentaires
-- 	-----------------------------------------------------------------------------------------------------
-- @(#) CAL_TX_CHANGE_DEVISE.sql 3.0-1.0	|18/03/2002| SGN	| Création
-- 	----------------------------------------------------------------------------------------------------------
*/
  v_codext_devise_ref SR_CODIF.cod_codif%TYPE;
  v_codint_devise_ref SR_CODIF.ide_codif%TYPE;
  v_libl_devise_ref SR_CODIF.libl%TYPE;

  v_ret NUMBER;

  PARAM_EXCEPTION EXCEPTION;
  CODIF_EXCEPTION EXCEPTION;

  -- Variable pour la trace
  v_niveau_trace NUMBER := NULL;
  v_num_trt NUMBER;
BEGIN

	 -- Recuperation du niveau de trace en passant par les variables ASTER
	 ASTER_VAR.get_var('NIVEAU_TRACE_VAR','P_NIV_TRACE', v_niveau_trace, v_num_trt);
	 GLOBAL.INI_NIVEAU_TRACE(NVL(v_niveau_trace,0));

 	 AFF_TRACE('CAL_TX_CHANGE_DEVISE', 2, NULL, 'Debut traitement');


	 -- Recuperation du code interne de la devise de reference
     EXT_PARAM('IC0026', v_codint_devise_ref, v_ret);
	 IF v_ret != 1 THEN
		RAISE PARAM_EXCEPTION;
     END IF;

     AFF_TRACE('CAL_TX_CHANGE_DEVISE', 2, NULL, 'devise:'||p_ide_devise);
     AFF_TRACE('CAL_TX_CHANGE_DEVISE', 2, NULL, 'Code interne dev ref:'||v_codint_devise_ref);

	 -- si le taux recherche et celui de la devise de reference, on retournera un
	 -- taux de change = 1
	 IF p_ide_devise IS NULL OR p_ide_devise = v_codint_devise_ref THEN
		 p_val_taux := 1;
		 p_dat_application := SYSDATE;
	 ELSE
	 	 -- Recuperation de la date d application
		 BEGIN
	 	 	  SELECT max(dat_application)
	 	 	  INTO p_dat_application
	 	 	  FROM RB_TXCHANGE
	 	  	  WHERE ide_devise = p_ide_devise
	   	        AND dat_application <= p_date;
	 	 EXCEPTION
	 	 	  WHEN OTHERS THEN
		  	  	  -- AFF_MESS('E', 105, 'CAL_TX_CHANGE_DEVISE - recup max dat appli', '', '', '');
			  	  RAISE;
	 	 END;

     	 AFF_TRACE('CAL_TX_CHANGE_DEVISE', 2, NULL, 'date application : '||to_char(p_dat_application));

		 -- Recuperation du taux de change
		 BEGIN
		 	  SELECT val_taux
		 	  INTO p_val_taux
		 	  FROM RB_TXCHANGE
		 	  WHERE ide_devise = p_ide_devise
		   	    AND dat_application = p_dat_application;
		 EXCEPTION
		 	  WHEN OTHERS THEN
			  	  --AFF_MESS('E', 105, 'CAL_TX_CHANGE_DEVISE - recup val taux', '', '', '');
				  RAISE;
		  	  END;

	 END IF; -- IF p_ide_devise = v

	 AFF_TRACE('CAL_TX_CHANGE_DEVISE', 2, NULL, 'val_taux : '||to_char(p_val_taux));

	 AFF_TRACE('CAL_TX_CHANGE_DEVISE', 2, NULL, 'Fin traitement');

EXCEPTION
  WHEN PARAM_EXCEPTION THEN
  	  --AFF_MESS('E', 792, 'CAL_TX_CHANGE_DEVISE', '', '', '');
	  p_val_taux := NULL;
	  p_dat_application := NULL;
	  RAISE;
  WHEN CODIF_EXCEPTION THEN
  	  --AFF_MESS('E', 59, 'CAL_TX_CHANGE_DEVISE', v_codext_devise_ref, '', '');
	  p_val_taux := NULL;
	  p_dat_application := NULL;
	  RAISE;
  WHEN OTHERS THEN
  	  --AFF_MESS('E', 105, 'CAL_TX_CHANGE_DEVISE : ', sqlerrm, '', '');
 	  RAISE;
END CAL_TX_CHANGE_DEVISE;

/

CREATE OR REPLACE PROCEDURE CDL_CDE(        p_poste      FB_PIECE.ide_poste%TYPE,
                                            p_trim           VARCHAR2,
                                            p_annee          VARCHAR2,
											p_retour     OUT number
                                          ) IS
-------------------------------------------------------------
-- procédure spécifique développée par le DI44            ---
-- le 24/09/2004                                          ---
-------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- proc modifiée le 13/05/2005 : prise en compte des mandats de la période complémentaire --
-- proc modifiée le 02/06/2005 : suite à modif du 13/05/2005 le trim et le mois du fichier étaient erronés --
--                               pour les mandats de la période complémentaire --
-- proc modifiée le 13/09/2005 : adaptation lolf ajout de l'article de regroupement --
-- proc modifiée le 15/09/2008 : MPS - rectification dans la récup du n° op MANTIS n° 323 --
-- proc modifiée le 16/12/2008 : MPS - ajout du n° de mandat en position 157 à 169 - MANTIS n° 340 --
-- proc modifiée le 03/09/2009 : MPS - ajout date pos 90 à 97, code service pos 139 à 148 et 0 en pos 170 - MANTIS n° 510 --
-- proc modifiée le 21/09/2009 : MPS - ajout de zéros en pos 139-142 et pos 149-156 - MANTIS n° 515 --
----------------------------------------------------------------------------------------------------------------------------

--P_poste FB_PIECE.ide_poste%TYPE := '184000';
P_mois  VARCHAR2(2) := '03';
--P_annee VARCHAR2(4) := '2004';

CURSOR c_edm IS
SELECT fb.ide_poste, fb.ide_gest , fb.ide_ordo, fb.ide_piece,
       fbl.ide_lig_prev,                                               --ajout lolf mps 13/09/2005
       fbl.ide_lig_exec, fb.ide_ope, fbl.mt, fb.dat_cpta,
       CHAP_CLASSEMENT(fb.ide_poste, fb.ide_gest, fb.ide_ordo, fb.cod_bud, fb.ide_piece, fb.cod_typ_piece, fb.ide_piece_init,
	                   fb.dat_cpta, fbl.ide_lig_exec, fbl.num_lig, 'M') chap_clt,
	   decode(substr(fb.ide_piece,1,3),614,613,617,613,993,613,994,613,substr(fb.ide_piece,1,3)) typ_evt,
	--   decode(substr(fb.ide_ordo, 1, 1), '2', substr(fb.ide_ope, 3, 2), '4', substr(fb.ide_ope, 3, 2), '00') annee_ope,  -- supp MPS 15/09/2008 mantis 323
	   decode(substr(fb.ide_ordo, 1, 1), '2', substr(fb.ide_ope, 12, 2), '4', substr(fb.ide_ope, 12, 2), '00') annee_ope,  -- ajout MPS 15/09/2008 mantis 323
	--   decode(substr(fb.ide_ordo, 1, 1), '2', substr(fb.ide_ope, 5, 16), '4', substr(fb.ide_ope, 5, 16), '000000') num_ope, -- supp MPS 15/09/2008 mantis 323
	   decode(substr(fb.ide_ordo, 1, 1), '2', substr(fb.ide_ope, 14, 16), '4', substr(fb.ide_ope, 14, 16), '000000') num_ope, -- ajout MPS 15/09/2008 mantis 323
	   decode(SIGN(fbl.mt), -1, '-', '+') signe,
	   decode(TO_CHAR(dat_cpta, 'YYYY'),(P_annee +1),'4',    --ajout du decode MPS 02/06/2005 --
	   decode(TO_CHAR(dat_cpta, 'MM'), '01','1', '02','1', '03','1', '04','2', '05','2', '06','2', '07','3', '08','3', '09','3',
												'10','4', '11','4', '12','4')) trim  --ajout de la 2ème parenthèse MPS 02/06/2005 --
FROM fb_piece fb, fb_ligne_piece fbl
WHERE fb.ide_poste = fbl.ide_poste
      and fb.ide_gest  = fbl.ide_gest
      and fb.cod_bud   = fbl.cod_bud
      and fb.ide_ordo   = fbl.ide_ordo
      and fb.ide_piece = fbl.ide_piece
      and fb.cod_typ_piece = fbl.cod_typ_piece
	  and fb.cod_statut = 'VI'
	  and fb.cod_typ_piece in ('OD', 'AD')
	  and fb.ide_poste = P_poste
	  and fb.dat_cpta != to_date('01/01'||P_annee)
	 -- and to_char(fb.dat_cpta,'MM/YYYY') = P_mois || '/' || P_annee                            -- modif MPS 13/05/2005 supp ligne
	  and fb.ide_gest = P_annee                                                                  -- modif MPS 13/05/2005 ajout ligne
	  and (                                                                                      -- modif MPS 13/05/2005 ajout ligne
	        (to_char(fb.dat_cpta,'MM/YYYY') =  P_mois || '/' || P_annee)                         -- modif MPS 13/05/2005 ajout ligne
			OR                                                                                   -- modif MPS 13/05/2005 ajout ligne
			(P_mois = '12' and to_char(fb.dat_cpta,'MM/YYYY') = '01' || '/' || (P_annee + 1))    -- modif MPS 13/05/2005 ajout ligne
		  )
ORDER BY fb.ide_poste, fb.ide_ordo, substr(fbl.ide_lig_exec,4,4), typ_evt, substr(fb.ide_piece,8,6), substr(fbl.ide_lig_exec,9,5);


v_ligne_edm     VARCHAR2(1024);
v_nomfic_edm    VARCHAR2(512);
v_prem_ligne    BOOLEAN := true;
v_rep           VARCHAR2(256);
v_separateur    VARCHAR2(2);
v_sep_path      VARCHAR2(2);
v_fin           BOOLEAN := false;
v_mois          VARCHAR2(2);   -- ajout MPS 02/06/2005 --

v_ret NUMBER;

--  Constantes utilisees dans la procedure
cst_Prog_Name             CONSTANT      VARCHAR2(10) := 'U621_540B';

--  Exceptions

Erreur_Acces_Fichier EXCEPTION;
PARAM_EXCEPTION EXCEPTION;


BEGIN

    P_retour := 0;

    -- Recuperation du repertoire qui recevra le fichier EDM
	EXT_PARAM('IR0025', v_rep, v_ret);
	v_rep := v_rep || '\EDM';
	IF v_ret != 1 THEN
		RAISE PARAM_EXCEPTION;
	END IF;

	 -- Recuperation du separateur de fichier
	 v_ret := ASTER_ENV_PARAM(v_separateur, v_sep_path);
     -- MODIF SGN FCT47 : Suppression des eventuels espace avant et apres les separateurs
	 v_separateur := ltrim(rtrim(v_separateur));
 	 v_sep_path := ltrim(rtrim(v_sep_path));

	 if p_trim = '1' then
	    p_mois := '01';
	 elsif p_trim = '2' then
	    p_mois := '04';
	 elsif p_trim = '3' then
	    p_mois := '07';
     else
	    p_mois := '10';
	 end if;

 While v_fin = false loop

   For v_edm in c_edm loop

		-- à la premiere ligne récupérée, on calcule le nom du fichier et on ouvre le fichier
	   if v_prem_ligne = true then
	       v_nomfic_edm := v_rep||v_separateur ||
					'R' || TRIM(v_edm.ide_poste) || '.' || TRIM(substr(v_edm.ide_gest,3,2)) || TRIM(P_trim);
	       v_prem_ligne := false;
		  v_ret := ASTER_efface_fichier(v_nomfic_edm);
		   if  v_ret not in (0, -2) then
			   RAISE Erreur_Acces_Fichier;
		   end if;
		end if;

		-- début ajout MPS 02/06/2005 --
		if TO_CHAR(v_edm.dat_cpta, 'YYYY') = (P_annee +1) then
		   v_mois := '12';
		else
		   v_mois := to_char(v_edm.dat_cpta,'MM');
		end if;
		-- fin ajout MPS 02/06/2005 --

	    v_ligne_edm := rpad(substr(v_edm.ide_poste,1,6),6,0) ||
		               rpad(substr(v_edm.ide_ordo,1,9),9,0) ||
					   rpad(v_edm.typ_evt,3,0)||
					   rpad(substr(v_edm.ide_gest,3,2),2,0) ||
					   rpad(substr(v_edm.ide_piece,8,6),6,0) ||
					   '00000' ||  -- cst
					   rpad(v_edm.annee_ope,2,0) ||
					   rpad(v_edm.num_ope,6,0)||
					   '00000000' ||
					   rpad(substr(v_edm.ide_lig_exec,4,4),4,0) ||
					   rpad(substr(v_edm.ide_lig_exec,9,2),2,0) ||
					   rpad(substr(v_edm.ide_lig_exec,12,2),2,0) ||
					   lpad(abs(v_edm.mt)*100,13,0) ||
					   v_edm.signe ||
					   v_edm.trim ||
					   lpad(v_mois,2,0) || -- ajout MPS 06/02/2005 --
					   --to_char(v_edm.dat_cpta,'MM') || -- supp MPS 02/06/2005 --
					   to_char(v_edm.dat_cpta,'YYYY') || to_char(v_edm.dat_cpta,'MM') || to_char(v_edm.dat_cpta,'DD') ||
					   rpad(v_edm.chap_clt,4,0) ||
					   --rpad (' ',29, ' ') ||                      -- mise en commentaire mps lolf 13/09/2005
					   rpad (' ',3, ' ') ||                         -- ajout MPS  lolf 13/09/2005 -
					   lpad(substr(v_edm.ide_lig_prev,9,2),2,0)||   -- ajout MPS  lolf 13/09/2005 -
					   to_char(v_edm.dat_cpta,'YYYY') || to_char(v_edm.dat_cpta,'MM') || to_char(v_edm.dat_cpta,'DD') || -- ajout MPS Mantis 510 -
					  -- rpad (' ',24, ' ') ||                        -- ajout MPS  lolf 13/09/2005 - -- supp MPS Mantis 510 -
					   rpad (' ',16, ' ') ||
					   '00000000' ||
					   rpad (' ',6, ' ') ||
					   '0000000000' ||
					  -- rpad (' ',5, ' ')||                                -- ajout MPS Mantis 510 -  -- supp MPS Mantis 515 -
					   rpad (' ',1, ' ')||                                -- ajout MPS Mantis 515 -
					   '0000'||                                           -- ajout MPS Mantis 515 -
					   rpad(substr(v_edm.ide_ordo,4,6),6,0) ||            -- ajout MPS Mantis 510 -
					   --rpad (' ',8, ' ')||                                -- ajout MPS Mantis 510 -  -- supp MPS Mantis 515 -
					   '00000000'||                                       -- ajout MPS Mantis 515 -
					   --  rpad (' ',33, ' ')                             -- supp MPS Mantis 340 -
					  -- rpad (' ',19, ' ')||                               -- ajout MPS Mantis 340 -  -- supp MPS Mantis 510 -
					   '0000' ||                                          -- ajout MPS Mantis 340 -
					   rpad(substr(v_edm.ide_piece,8,6),6,0) ||           -- ajout MPS Mantis 340 -
					 --  '000 '                                             -- ajout MPS Mantis 340 -
					   '0000'                                             -- ajout MPS Mantis 340 -   -- supp MPS Mantis 510 -
					    ;


		-- concaténation formattée de chacune des zones du fichier EDM
		v_ret       := PIAF_ecrit_fichier(v_ligne_edm, v_nomfic_edm, 'at+', '', '');
		IF v_ret != 0 THEN
		   RAISE Erreur_Acces_Fichier;
		END IF;

   end loop;  -- du for

		if p_mois = '01' then
		   p_mois := '02';
		elsif p_mois = '02' then
		   p_mois := '03';
		elsif p_mois = '04' then
		   p_mois := '05';
		elsif p_mois = '05' then
		   p_mois := '06';
		elsif p_mois = '07' then
		   p_mois := '08';
		elsif p_mois = '08' then
		   p_mois := '09';
		elsif p_mois = '10' then
		   p_mois := '11';
		elsif p_mois = '11' then
		   p_mois := '12';
		else
		   v_fin := true;
		end if;

 end loop; -- du while

EXCEPTION

  WHEN Erreur_Acces_Fichier THEN
        P_retour := -1;
		AFF_TRACE(cst_Prog_Name, 0, 744, cst_Prog_Name, v_nomfic_edm, NULL, GLOBAL.fichier_trace, 'E' );

		AFF_TRACE(cst_Prog_Name, 0, 108, cst_Prog_Name, NULL, NULL, GLOBAL.fichier_trace, 'E' );
		AFF_MESS('E', 108, cst_Prog_Name, NULL, NULL, NULL );

  WHEN PARAM_EXCEPTION THEN
        P_retour := -2;
		AFF_TRACE(cst_Prog_Name, 0, 159, 'IR0025', NULL, NULL, GLOBAL.fichier_trace, 'E' );
  	    AFF_MESS('E', 159, cst_Prog_Name, 'IR0025', NULL, NULL);

		AFF_TRACE(cst_Prog_Name, 0, 108, cst_Prog_Name, NULL, NULL, GLOBAL.fichier_trace, 'E' );
		AFF_MESS('E', 108, cst_Prog_Name, NULL, NULL, NULL );

  WHEN Others THEN
        P_retour := -3;
        AFF_TRACE(cst_Prog_Name,0, 105,cst_Prog_Name, SQLERRM, NULL, GLOBAL.fichier_trace, 'E' );

		AFF_TRACE(cst_Prog_Name, 0, 108, cst_Prog_Name, NULL, NULL, GLOBAL.fichier_trace, 'E' );
		AFF_MESS('E', 108, cst_Prog_Name, NULL, NULL, NULL );

END CDL_CDE;

/

CREATE OR REPLACE PROCEDURE CTL_JC_Connexion ( p_ide_poste IN rm_poste.ide_poste%TYPE,
                            p_ide_gest IN fn_gestion.ide_gest%TYPE,
                            p_dat_jc IN fc_calend_hist.dat_jc%TYPE,
                            p_res OUT VARCHAR2,
                            p_retour OUT NUMBER )  IS

/* Cette procedure vérifie l'état de la journée comptable passée en paramètre */
/* Entrée : p_ide_poste : poste comptable                                     */
/*          p_ide_gest : gestion                                              */
/*          p_dat_jc : journée comptable                                      */
/* Sortie : p_res : OK si la journée n'est pas considérée comme close         */
/*                  KO si la journée est considérée comme close               */
/*                  Null si une erreur est survenue                           */
/*          p_retour : 1 si pas d'erreur                                      */
/*                     0 si journée comptable inexistante                     */
/*                     -2 si problème de codification                         */
/*                     -1 si autre erreur                                     */

  v_cod_codif fc_calend_hist.cod_ferm%TYPE;
  v_ide_ferm sr_codif.ide_codif%TYPE;
  v_libl sr_codif.libl%TYPE;
  v_ret NUMBER;
  err_ext_codint EXCEPTION;

BEGIN

  /* Extraction du code externe du statut de la journée */
  SELECT cod_ferm INTO v_cod_codif
  FROM fc_calend_hist
  WHERE
    ide_poste = p_ide_poste
    AND ide_gest = p_ide_gest
    AND dat_jc = p_dat_jc;

  /* Transformation en code interne */
  EXT_Codint('STATUT_JOURNEE',v_cod_codif,v_libl,v_ide_ferm,v_ret);
  IF v_ret >= 1 THEN
    IF v_ide_ferm = 'E' OR v_ide_ferm = 'C' THEN
      /* Journee considérée comme cloturée */
      p_res := 'KO';
    ELSE
      p_res := 'OK';
    END IF;
  ELSE
    RAISE err_ext_codint;
  END IF;

  p_retour := 1;

EXCEPTION
  WHEN No_Data_Found THEN
    p_res := Null;
    p_retour := 0;
  WHEN err_ext_codint THEN
    p_res := Null;
    p_retour := -2;
  WHEN OTHERS THEN
    p_res := Null;
    p_retour := -1;
END CTL_JC_Connexion;

/

CREATE OR REPLACE PROCEDURE Ctl_Sais_Masque(p_ut     IN  VARCHAR2,
                          p_zone   IN  VARCHAR2,
                          p_valeur IN  VARCHAR2,
                          p_masque OUT VARCHAR2,
                          p_retour OUT NUMBER)
IS

/*
   Parametre en sortie : p_masque : Valeur du masque analysé
                         p_retour : 0 si non trouvé
                                    -1 si autre erreur
                                    1 si OK

Modif : 25/10/99 Fiche anomalie
        Si masque commence par @, alors recherche EXT_CODINT
        en majuscules

-- @(#) CTL_U41A_050B.sql 3.3-1.1	|03/09/2003| SGN	| ANOVA545 : le masque doit etre au format de sr_codif et on initialise p_masque a NULL plutot qu'a p_valeur qui peut avoir une valeur trop grande pour le champ.
-- @(#) CTL_U41A_050B.sql 3.3-1.1	|03/07/2007| FBT	| ANO 57 : correction de la lecture de la table SR_MASQUE.

*/

   v_masque SR_CODIF.ide_codif%TYPE; -- MODIF SGN ANOVA454 : 3.3-1.1 : VARCHAR2(100);
   v_reserve_deb SR_PARAM.val_param%TYPE;
   v_reserve_fin SR_PARAM.val_param%TYPE;

   v_retour NUMBER;

   v_libl SR_Codif.libl%TYPE;
   v_ide_codif SR_Codif.ide_codif%TYPE;

   v_cdeb      VARCHAR2(1);
   v_cfin      VARCHAR2(1);
   v_temp	   NUMBER:=0 ;

   CURSOR c_masque(p_msq VARCHAR2) IS
   SELECT cod_masque
   FROM   sr_masque
   WHERE  cod_role=p_ut
   AND    cod_zone=p_zone
   AND    cod_masque=p_msq;

   r_masque c_masque%ROWTYPE;

BEGIN
/*  Valeurs par défaut*/
   p_masque := NULL; -- MODIF SGN ANOVA454 : 3.3-1.1 : p_valeur;
   p_retour := -1;
   v_masque := '@VIDE';
/* Premier et dernier caractères */
   v_cdeb := SUBSTR(p_valeur,1,1);  /*  Si p_valeur null, retourne null */
   v_cfin := SUBSTR(p_valeur,-1,1); /*  Pareil */

   IF p_valeur IS NOT NULL THEN
   	/*  On ramene les caracteres reserves de debut et de fin */
      Ext_Param('IR0029',v_reserve_deb,v_retour);
      IF v_retour <> 1 THEN
         p_retour := -1;
         RETURN;
      END IF;
      Ext_Param('IR0030',v_reserve_fin,v_retour);
      IF v_retour <> 1 THEN
         p_retour := -1;
         RETURN;
      END IF;
      IF v_cdeb=v_reserve_deb THEN
      	 /*  Dans ce cas on fait le recherche en Majuscules */
         Ext_Codint('MASQUE',Upper(p_valeur),v_libl,v_ide_codif,v_retour);
         IF v_retour =1 THEN
            v_masque:=v_ide_codif;
         ELSE
            p_retour := 0;
            RETURN;
         END IF;
      ELSE  /* Ne commence pas par v_reserve_deb (i.e "@") */
         IF p_valeur=	v_reserve_fin THEN  /* p_valeur=* */
            v_masque := '*';
         ELSE
            IF v_cfin=v_reserve_fin THEN
               v_masque := 'Chai*';
            ELSE
               v_masque := 'Chai';
            END IF;
         END IF;
      END IF;
   END IF;

/* Nous avons fabriqué V_MASQUE                                        */
/* Il est obligatoirement dans l'ensemble suivant (Ici en tout cas):   */
/* {'@VIDE','*','Chai','Chai*','@DATE','@PC','@MREG'}                   */


   -- DEBUT - FBT - 03/07/2007 - ANO 57 ----------------------------------------------------------
   p_masque := v_masque;
   p_retour := -1;
   IF c_masque%ISOPEN THEN
      CLOSE c_masque;
   END IF;

   v_temp:=0;
   FOR r_masque IN c_masque(v_masque)  LOOP
   	   v_temp:=v_temp+1;
   End LOOP;

   IF v_temp>0 THEN
      p_retour :=1;
   ELSE
      p_retour :=0;
   END IF;

  /* FETCH c_masque INTO r_masque;
   		 v_temp:=v_temp	+1;
   IF c_masque%FOUND THEN
      p_retour :=1;
   ELSE
      p_retour :=0;
   END IF;
   CLOSE c_masque;*/

   -- FIN - FBT - 03/07/2007 - ANO 57 ----------------------------------------------------------

END Ctl_Sais_Masque;

/

CREATE OR REPLACE PROCEDURE EXT_Cod_Ope (
            p_cod_type IN VARCHAR2,
            p_ide_ope IN fb_rechb.ide_ope%TYPE,
            p_lig_prev IN fb_reser.ide_lig_prev%TYPE,
            p_mt IN fb_rechb.mt%TYPE,
            p_mt_bud IN fb_rechb.mt%TYPE,
            p_cod_ope1 OUT sr_param.val_param%TYPE,
            p_cod_ope2 OUT sr_param.val_param%TYPE,
            p_mt_ope1 OUT fb_rechb.mt%TYPE,
            p_mt_ope2 OUT fb_rechb.mt%TYPE,
            p_retour OUT NUMBER,
            p_ide_ss_type IN pb_ss_type_piece.ide_ss_type%TYPE := NULL  -- MODIF SGN ANOVA 13,14,36
 ) IS

/*
-- --------------------------------------------------------------------
--  Fichier        : EXT_Cod_Ope.sql
--  Auteur         : Sofiane NEKERE (SchlumbergerSema)
--  Date création  : 09/08/2002
--
--  Logiciel       : ASTER
--  sous-systeme   : Base
--  Description    :
--
-- Paramètres en entrée :
--       p_cod_type : code nature de délégation ou type de pièce
--                    ou code opération du mouvement budgétaire
--       p_ide_ope : numéro d'opération (facultatif)
--       p_ide_lig_prev : ligne budgétaire de prévision (facultatif)
--       p_mt : montant total ligne
--       p_mt_bud : montant ligne imputé sur budget (facultatif)
-- Paramètres en sortie :
--       p_cod_ope1 : code operation 1 pour mt imputé au budget
--       p_cod_ope2 : code operation 2 pour le montant hors budget
--       p_mt_ope1 : montant associé au code opération 1
--       p_mt_ope2 : montant associé au code opération 2
--       p_retour : code retour de la procédure :
--                  1 si déroulement OK
--                  0 si paramètre non trouvé
--                  -2 si paramètres en entrée sont incorrects
--                  -1 si autre erreur
--       p_ide_ss_type : ide sous type de piece  : MODIF SGN ANOVA 13,14,36
--
-- --------------------------------------------------------------------
--  Version        : @(#) EXT_Cod_Ope.sql  version 3.0-1.2
-- --------------------------------------------------------------------
--
-- ---------------------------------------------------------------
--  Fonction	    	|Date	    |Initiales	|Commentaires
-- ---------------------------------------------------------------
-- Modifications: - elargissement des tests pour traiter les conditions
--                  non bloquantes
--      @(#) MODIF SGN du 28/08/01 Evol Lot 3
--                 MAJ de fb_preop et fb_exeop sur les encaissement
--                   recette EC et les ordre de recette OR
--      @(#) MODIF SGN du 24/09/02 --MODIF SGN FCT11 ANOVA13, 14, 36
-- Ajout des nouveaux parametres IB0049, IB0051, IB0052
--                 MAJ de fb_preop et fb_exeop sur les encaissement
--                   recette EC et les ordre de recette OR
-- ---------------------------------------------------------------
-- @(#)EXT_Cod_Ope.sql  3.0-1.1	|24/09/2002	|SGN	| MODIF SGN FCT11 ANOVA13, 14, 36 : ajout de
-- @(#)EXT_Cod_Ope.sql  3.0-1.1	|24/09/2002	|SGN	| commentaire et prise en compte des codes
-- @(#)EXT_Cod_Ope.sql  3.0-1.1	|24/09/2002	|SGN	| IB0049 IB0051, IB0052, pour cela on ajoute
--                                                      le ss type de piece aux parametres de maniere
--                                                      determiner le type d OR ou OD
-- @(#)EXT_Cod_Ope.sql  3.0-1.2 |05/10/2002	|SGN	| Pour IB0049 (rescre) si l'ordre de recette est
-- @(#)EXT_Cod_Ope.sql  3.0-1.2 |05/10/2002	|SGN	| sur le budget dépense, aucune des maj. des
-- @(#)EXT_Cod_Ope.sql  3.0-1.2 |05/10/2002	|SGN	| situations prévue pour les ordre de recette
-- @(#)EXT_Cod_Ope.sql  3.0-1.2 |05/10/2002	|SGN	| classiques (budget recette) ne doivent être mis en oeuvre
-- --------------------------------------------------------------------
*/


v_diff fb_rechb.mt%TYPE;
v_libl sr_codif.libl%TYPE;

/* Variables de reception des identifiant des parametres */
v_ide_param1 sr_param.ide_param%TYPE := Null;
v_ide_param2 sr_param.ide_param%TYPE := Null;
/* Variable de reception des codes externes des operations */
v_val_ope1 sr_param.val_param%TYPE;
v_val_ope2 sr_param.val_param%TYPE;

-- MODIF SGN ANOVA 13, 14, 36
v_flg_depense PB_SS_TYPE_PIECE.flg_depense%TYPE;
v_flg_recette PB_SS_TYPE_PIECE.flg_recette%TYPE;
v_flg_engagt PB_SS_TYPE_PIECE.flg_engagt%TYPE;

-- Fin modif SGN


v_ret NUMBER;

err_param EXCEPTION;
err_codint EXCEPTION;
err_appel EXCEPTION;



BEGIN

 /* Différence entre le montant hors budget et le montant imputé sur le budget */
  v_diff := p_mt - NVL(p_mt_bud,0);

 /* ******************************************************************************************** */
 /* MODIF SGN ANOVA 13, 14, 36 :
 /*    Recherche du type de budget recette ou depense et du flg engagement pour les ordonnances */
 /*    et les ordres de recettes */
 /* ********************************************************************************************/
  IF p_cod_type IN ('OR','AR','OD','AD') THEN
  	BEGIN
		SELECT flg_depense, flg_recette, flg_engagt
		INTO v_flg_depense, v_flg_recette, v_flg_engagt
		FROM pb_ss_type_piece
	 	WHERE cod_typ_piece = p_cod_type
		  AND ide_ss_type = p_ide_ss_type;
	EXCEPTION
		WHEN OTHERS THEN
			RAISE;
	END;
  END IF;
 /** Fin modif SGN **/

  --
  -- ENGAGEMENT NORMAL
  --
  IF p_cod_type = 'N' THEN

    -- Le montant a imputer au budget impute la totalite du budget et il n existe
    -- pas d operation
    IF v_diff = 0 AND p_ide_ope IS NULL THEN

      -- Si aucune ligne de prevision definie => erreur
      IF p_lig_prev IS NULL THEN
        RAISE err_appel;

      -- Sinon s il existe une ligne de prevision
      --    => il s agit d un ENGCRE (engagement normal sur credit)
      ELSE
        v_ide_param1 := 'IB0030';  -- <=> ENGCRE
        p_mt_ope1 := p_mt_bud;
        p_mt_ope2:= 0;
        p_retour := 1;
      END IF;

    -- Le montant a imputer au budget impute la totalite du budget et il existe
    -- une operation
    ELSIF v_diff = 0 AND p_ide_ope IS NOT NULL THEN

      -- Si aucune ligne de prevision definie => erreur
      IF p_lig_prev IS NULL THEN
        RAISE err_appel;

      -- Sinon s il existe une ligne de prevision
      --    => il s agit d un ENGRES (engagement normal sur reservation)
      ELSE
        v_ide_param1 := 'IB0031';  -- <=> ENGRES
        p_mt_ope1 := p_mt_bud;
        p_mt_ope2:= 0;
        p_retour := 1;
      END IF;

    -- Le montant du budget est null
    ELSIF v_diff = p_mt THEN

      -- Si aucune operation definie => erreur
      IF p_ide_ope IS NULL THEN
        RAISE err_appel;

	-- Sinon s il existe une operation
      --    => il s agit d un ENGENV (engagement normal sur enveloppe hors budget)
      ELSE
        v_ide_param1 := 'IB0032';  -- <=> ENGENV
        p_mt_ope1 := p_mt;
        p_mt_ope2:= 0;
        p_retour := 1;
      END IF;

    -- Le montant a imputer au budget n impute pas la totalite du budget et le budget
    -- est different de 0
    ELSIF v_diff != 0 AND v_diff != p_mt THEN

      -- Si l operation ou la ligne de prevision est nulle => erreur
      IF p_ide_ope IS NULL OR p_lig_prev IS NULL THEN
        RAISE err_appel;

      -- Sinon, s il existe une operation et une ligne de prevision
      --    => il s agit a la fois d un ENGRES (engagement normal sur reservation) et
      --       d un ENGENV (engagement normal sur enveloppe hors budget)
      ELSE
        v_ide_param1 := 'IB0031';  -- <=> ENGRES
        v_ide_param2 := 'IB0032';  -- <=> ENGENV
        p_mt_ope1 := p_mt_bud;
        p_mt_ope2:= p_mt - p_mt_bud;
        p_retour := 1;
      END IF;
    ELSE
      RAISE err_appel;
    END IF;

  --
  -- ENGAGEMENT SUR DELEGATION
  --
  ELSIF p_cod_type = 'S' THEN

    -- Le montant a imputer au budget impute la totalite du budget et il n existe pas
    -- d operation
    IF v_diff = 0 AND p_ide_ope IS NULL THEN

      -- Si aucune ligne de prevision definie => erreur
      IF p_lig_prev IS NULL THEN
        RAISE err_appel;

      -- Sinon s il existe une ligne de prevision
      --    => il s agit d un ENGDELCRE (engagement vise sur delegation d engagement)
      ELSE
        v_ide_param1 := 'IB0033'; -- <=> ENGDELCRE
        p_mt_ope1 := p_mt_bud;
        p_mt_ope2:= 0;
        p_retour := 1;
      END IF;

    -- Le montant a imputer au budget impute la totalite du budget et il existe
    -- une operation
    ELSIF v_diff = 0 AND p_ide_ope IS NOT NULL THEN

      -- Si aucune ligne de prevision definie => erreur
      IF p_lig_prev IS NULL THEN
        RAISE err_appel;

      -- Sinon s il existe une ligne de prevision
      --    => il s agit d un ENGDELRES (engagement vise sur delegation de reservation)
      ELSE
        v_ide_param1 := 'IB0034'; -- <=> ENGDELRES
        p_mt_ope1 := p_mt_bud;
        p_mt_ope2:= 0;
        p_retour := 1;
      END IF;

    -- Le montant du budget est null
    ELSIF v_diff = p_mt THEN

      -- Si aucune operation definie => erreur
      IF p_ide_ope IS NULL THEN
        RAISE err_appel;

	-- Sinon s il existe une operation
      --    => il s agit d un ENGDELENV (engagement sur delegation d enveloppe hors budget)
      ELSE
        v_ide_param1 := 'IB0035';  -- <=> ENGDELENV
        p_mt_ope1 := p_mt;
        p_mt_ope2:= 0;
        p_retour := 1;
      END IF;

    -- Le montant a imputer au budget n impute pas la totalite du budget et le budget
    -- est different de 0
    ELSIF v_diff != 0 AND v_diff != p_mt THEN

      -- Si l operation ou la ligne de prevision est nulle => erreur
      IF p_ide_ope IS NULL OR p_lig_prev IS NULL THEN
        RAISE err_appel;

      -- Sinon, s il existe une operation et une ligne de prevision
      --    => il s agit a la fois d un ENGDELRES (engagement delegue sur reservation) et
      --       d un ENGDELENV (engagement delegue sur enveloppe hors budget)
      ELSE
        v_ide_param1 := 'IB0034'; -- <=> ENGDELRES
        v_ide_param2 := 'IB0035'; -- <=> ENGDELENV
        p_mt_ope1 := p_mt_bud;
        p_mt_ope2:= p_mt - p_mt_bud;
        p_retour := 1;
      END IF;
    ELSE
      RAISE err_appel;
    END IF;


  --
  -- ENGAGEMENT DELEGUE
  --
  ELSIF p_cod_type = 'D' THEN

    -- Le montant a imputer au budget impute la totalite du budget et il n existe pas
    -- d operation
    IF v_diff = 0 AND p_ide_ope IS NULL THEN

      -- Si aucune ligne de prevision definie => erreur
      IF p_lig_prev IS NULL THEN
        RAISE err_appel;

      -- Sinon s il existe une ligne de prevision
      --    => il s agit d un ENGDCRE (engagement delegue sur credit vise)
      ELSE
        v_ide_param1 := 'IB0036'; -- <=> ENGDCRE
        p_mt_ope1 := p_mt_bud;
        p_mt_ope2:= 0;
        p_retour := 1;
      END IF;

    -- Le montant a imputer au budget impute la totalite du budget et il existe
    -- une operation
    ELSIF v_diff = 0 AND p_ide_ope IS NOT NULL THEN

      -- Si aucune ligne de prevision definie => erreur
      IF p_lig_prev IS NULL THEN
        RAISE err_appel;

      -- Sinon s il existe une ligne de prevision
      --    => il s agit d un ENGDRES (engagement delegue vise sur reservation)
      ELSE
        v_ide_param1 := 'IB0037';
        p_mt_ope1 := p_mt_bud;
        p_mt_ope2:= 0;
        p_retour := 1;
      END IF;

    -- Le montant du budget est null
    ELSIF v_diff = p_mt THEN

      -- Si aucune operation definie => erreur
      IF p_ide_ope IS NULL THEN
        RAISE err_appel;

	-- Sinon s il existe une operation
      --    => il s agit d un ENGDENV (engagement delegue sur enveloppe hors budget)
      ELSE
        v_ide_param1 := 'IB0038';
        p_mt_ope1 := p_mt;
        p_mt_ope2:= 0;
        p_retour := 1;
      END IF;

    -- Le montant a imputer au budget n impute pas la totalite du budget et le budget
    -- est different de 0
    ELSIF v_diff != 0 AND v_diff != p_mt THEN

      -- Si l operation ou la ligne de prevision est nulle => erreur
      IF p_ide_ope IS NULL OR p_lig_prev IS NULL THEN
        RAISE err_appel;

      -- Sinon, s il existe une operation et une ligne de prevision
      --    => il s agit a la fois d un ENGDRES (engagement delegue sur reservation) et
      --       d un ENGDENV (engagement delegue sur enveloppe hors budget)
      ELSE
        v_ide_param1 := 'IB0037'; -- <=> ENGDRES
        v_ide_param2 := 'IB0038'; -- <=> ENGDENV
        p_mt_ope1 := p_mt_bud;
        p_mt_ope2:= p_mt - p_mt_bud;
        p_retour := 1;
      END IF;
    ELSE
      RAISE err_appel;
    END IF;

  --
  -- ORDONNANCE ou ANNULATION D ORDONNANCE
  --
  ELSIF p_cod_type = 'OD' OR p_cod_type = 'AD' THEN

    -- Le montant a imputer au budget impute la totalite du budget et il n existe pas
    -- d operation
    IF v_diff = 0 AND p_ide_ope IS NULL THEN

      -- Si aucune ligne de prevision definie => erreur
      IF p_lig_prev IS NULL THEN
        RAISE err_appel;

      -- Sinon s il existe une ligne de prevision
      --    => il s agit d un ORDCRE (ordonnance ou annulation d ordonnance sur credit)
	--       ou d un ORDREC (Ordonnance sur budget recette)
      ELSE


      -- MODIF SGN ANOVA 13,14,36
	  -- Si le sous type de piece est parametre pour un budget recette
	  --   et que le sous type de piece est aussi parametre sans engagemnt
	  --   => il s'agit d'un ORDREC (Ordonnance sur budget recette)
	  --      et d'un ORDSEN (Ordonnance sans engagement)

	  IF v_flg_recette = 'O' AND v_flg_engagt = 'N' THEN
	      v_ide_param1 := 'IB0051';  -- <=> ORDREC
		  v_ide_param2 := 'IB0052';  -- <=> ORDSEN
      	  p_mt_ope1 := p_mt_bud;
	      p_mt_ope2:= p_mt_bud;
	      p_retour := 1;



	  -- Si le sous type de piece est parametre pour un budget recette
	  --   => il s'agit d'un ORDREC (Ordonnance sur budget recette)
	  ELSIF v_flg_recette = 'O' THEN


	      v_ide_param1 := 'IB0051';  -- <=> ORDREC
      	  p_mt_ope1 := p_mt_bud;
	      p_mt_ope2:= 0;
	      p_retour := 1;

	  -- Si le sous type de piece est parametre sans engagemnt
	  --   => il s'agit d'un ORDSEN (Ordonnance sans engagement)
	  ELSIF v_flg_engagt = 'N' THEN


		v_ide_param1 := 'IB0052';  -- <=> ORDSEN
		p_mt_ope1 := p_mt_bud;
		p_mt_ope2:= 0;
		p_retour := 1;
	  -- Fin modif SGN

	  -- Sinon il s'agit d'un ORDCRE (ordonnance ou annulation d ordonnance sur credit)
	  ELSE


		v_ide_param1 := 'IB0039';  -- <=> ORDCRE
		p_mt_ope1 := p_mt_bud;
		p_mt_ope2:= 0;
		p_retour := 1;
	  END IF;
      END IF;

    -- Le montant a imputer au budget impute la totalite du budget et il existe
    -- une operation
    ELSIF v_diff = 0 AND p_ide_ope IS NOT NULL THEN


      -- Si aucune ligne de prevision definie => erreur
      IF p_lig_prev IS NULL THEN
        RAISE err_appel;

      -- Sinon s il existe une ligne de prevision
      --    => il s agit d un ORDCP (ordonnance ou annulation sur credit de paiement)
      ELSE


        v_ide_param1 := 'IB0040';  -- <=> ORDCP
        p_mt_ope1 := p_mt_bud;
        p_mt_ope2:= 0;
        p_retour := 1;
      END IF;

    -- Le montant du budget est null
    ELSIF v_diff = p_mt THEN


      -- Si aucune operation definie => erreur
      IF p_ide_ope IS NULL THEN
        RAISE err_appel;

	-- Sinon s il existe une operation
      --    => il s agit d un ORDENV (ordonnance ou annulation sur enveloppe hors budget)
      ELSE


        v_ide_param1 := 'IB0041';
        p_mt_ope1 := p_mt;
        p_mt_ope2:= 0;
        p_retour := 1;
      END IF;

    -- Le montant a imputer au budget n impute pas la totalite du budget et le budget
    -- est different de 0
    ELSIF v_diff != 0 AND v_diff != p_mt THEN


      -- Si l operation ou la ligne de prevision est nulle => erreur
      IF p_ide_ope IS NULL OR p_lig_prev IS NULL THEN
        RAISE err_appel;

      -- Sinon, s il existe une operation et une ligne de prevision
      --    => il s agit a la fois d un ORDCP (ordonnance ou annulation sur credit de paiment) et
      --       d un ORDENV (ordonnance ou annulation sur enveloppe hors budget)
      ELSE


        v_ide_param1 := 'IB0040';  -- <=> ORDCP
        v_ide_param2 := 'IB0041';  -- <=> ORDENV
        p_mt_ope1 := p_mt_bud;
        p_mt_ope2:= p_mt - p_mt_bud;
        p_retour := 1;
      END IF;
    ELSE
      RAISE err_appel;
    END IF;

  --
  -- ORDRE DE RECETTE ou ANNULATION D ORDRE DE RECETTE
  --
  ELSIF p_cod_type = 'OR' OR p_cod_type = 'AR' THEN

    -- MODIF SGN ANOVA14 du 05/11/2002
    -- Si le sous type de piece est parametre pour un budget depense
	--   => il s'agit d'un OREDEP (Restitution de crédits)
    IF v_flg_depense = 'O' THEN

        -- Si aucune ligne de prevision definie => erreur
        IF p_lig_prev IS NULL THEN
          RAISE err_appel;
        ELSE
	  	  v_ide_param1 := 'IB0049';  -- <=> OREDEP
	      p_mt_ope1 := p_mt_bud;
	      p_mt_ope2:= 0;
	  	  p_retour := 1;
		END IF;
	ELSE
    -- Fin modif SGN

      -- Le budget est imputee, une operation est renseignee ainsi que la ligne de prevision
      --    => il s agit d un ORERECOP (ordre de recette ou annulation sur operation)
      -- MODIF SGN DU 22.08.01
      IF p_mt_bud != 0 AND p_ide_ope IS NOT NULL AND p_lig_prev IS NOT NULL THEN
  		v_ide_param1 := 'IB0047';  -- <=> ORERECOP
      	p_mt_ope1 := p_mt_bud;
		p_mt_ope2:= 0;
		p_retour := 1;
	  -- Fin modif SGN

      -- Si le montant a imputer au budget impute la totalite du budget
      ELSIF v_diff = 0 THEN

        -- Si aucune ligne de prevision definie => erreur
        IF p_lig_prev IS NULL THEN
          RAISE err_appel;

        -- Sinon s il existe une ligne de prevision
        --    => il s agit d un OREREC (ordre de recette ou annulation)
        ELSE

		  v_ide_param1 := 'IB0042';  -- <=> OREREC
      	  p_mt_ope1 := p_mt_bud;
      	  p_mt_ope2:= 0;
      	  p_retour := 1;
        END IF;

      -- Le montant du budget est null
      ELSIF v_diff = p_mt THEN

        -- Si aucune operation definie => erreur
        IF p_ide_ope IS NULL THEN
          RAISE err_appel;

	    -- Sinon s il existe une operation
        --    => il s agit d un OREENV (ordre de recette ou annulation sur recette hors budget)
        ELSE
          v_ide_param1 := 'IB0043';  -- <=> OREENV
          p_mt_ope1 := p_mt;
          p_mt_ope2:= 0;
          p_retour := 1;
        END IF;

      -- Le montant a imputer au budget n impute pas la totalite du budget et le budget
      -- est different de 0
      ELSIF v_diff != 0 AND v_diff != p_mt THEN

        -- Si l operation ou la ligne de prevision est nulle => erreur
        IF p_ide_ope IS NULL OR p_lig_prev IS NULL THEN
          RAISE err_appel;

        -- Sinon, s il existe une operation et une ligne de prevision
        --    => il s agit a la fois d un OREREC (ordre de recette ou annulation) et
        --       d un OREENV (ordre de recette ou annulation sur recette hors budget)
        ELSE
          v_ide_param1 := 'IB0042';  -- <=> OREREC
          v_ide_param2 := 'IB0043';  -- <=> OREENV
          p_mt_ope1 := p_mt_bud;
          p_mt_ope2:= p_mt - p_mt_bud;
          p_retour := 1;
        END IF;
      ELSE
        RAISE err_appel;
      END IF;
    END IF;
  --
  -- DSO
  --
  ELSIF p_cod_type = 'DS' THEN
    v_ide_param1 := 'IB0044';  -- DSO
    p_mt_ope1 := p_mt;
    p_mt_ope2:= 0;
    p_retour := 1;

  --
  -- Encaissement
  --
  ELSIF p_cod_type = 'EC' THEN
    IF v_diff = p_mt AND p_ide_ope IS NULL AND p_lig_prev IS NOT NULL THEN
      v_ide_param1 := 'IB0045';  -- OREENC (Encaissement de recette)
      p_mt_ope1 := p_mt;
      p_mt_ope2:= 0;
      p_retour := 1;
    ELSIF v_diff = p_mt AND p_ide_ope IS NOT NULL AND p_lig_prev IS NULL THEN
      v_ide_param1 := 'IB0046';  -- ORENVENC (Encaissement de recette hors budget)
      p_mt_ope1 := p_mt;
      p_mt_ope2:= 0;
      p_retour := 1;
    ELSIF v_diff = p_mt AND p_ide_ope IS NOT NULL AND p_lig_prev IS NOT NULL THEN
	  v_ide_param1 := 'IB0048';  -- Modif SGN du 28.08.01  -- OREENCOP (Encaissement de recette sur operation)
        p_mt_ope1 := p_mt;
	  p_mt_ope2:= 0;
	  p_retour := 1;
	ELSE
      RAISE err_appel;
    END IF;

  ELSIF p_cod_type != 'N'
        AND p_cod_type != 'S'
        AND p_cod_type != 'D'
        AND p_cod_type != 'OD'
        AND p_cod_type != 'AD'
        AND p_cod_type != 'OR'
        AND p_cod_type != 'AR'
        AND p_cod_type != 'DS'
        AND p_cod_type != 'EC' THEN
    p_cod_ope1 := p_cod_type;
    p_mt_ope1 := p_mt;
    p_mt_ope2:= 0;
    p_retour := 1;

  ELSE
    RAISE err_appel;
  END IF;

  /* Extraction de la valeur des paramètres et tranformation en code interne */
  IF v_ide_param1 IS NOT NULL THEN
    EXT_PARAM(v_ide_param1,p_cod_ope1,v_ret);
    IF v_ret != 1 THEN
      RAISE err_param;
    END IF;
  END IF;
  IF v_ide_param2 IS NOT NULL THEN
    EXT_PARAM(v_ide_param2,p_cod_ope2,v_ret);
    IF v_ret != 1 THEN
      RAISE err_param;
    END IF;
  END IF;

EXCEPTION
  WHEN err_codint THEN
    p_retour := v_ret;
    p_cod_ope1 := Null;
    p_cod_ope2 := Null;
  WHEN err_appel THEN
    p_retour := -2;
    p_cod_ope1 := Null;
    p_cod_ope2 := Null;
  WHEN err_param THEN
    p_retour := v_ret;
    p_cod_ope1 := Null;
    p_cod_ope2 := Null;
  WHEN OTHERS THEN
    p_retour := -1;
    p_cod_ope1 := Null;
    p_cod_ope2 := Null;

END ext_cod_ope;

/

CREATE OR REPLACE procedure MAJ_ins_ligne_bud(
                                     P_cod_typ_piece IN FC_ECRITURE.cod_typ_piece%TYPE,
          -- MODIF MYI Le 04/04/2002 : fonction 11
          P_ide_ss_type   IN FB_PIECE.IDE_SS_TYPE%TYPE,
          P_ide_typ_poste IN RM_POSTE.IDE_TYP_POSTE%TYPE,
          -- FIN MODIF MYI
                                     P_ide_poste IN FB_PIECE.ide_poste%TYPE,
                                     P_ide_piece IN FB_PIECE.ide_piece%TYPE,
                                     P_ide_gest IN FB_PIECE.ide_gest%TYPE,
                                     P_ide_ordo IN FB_PIECE.ide_ordo%TYPE,
                                     P_cod_bud IN FB_PIECE.cod_bud%TYPE,
                                     P_var_cpta IN FC_ECRITURE.var_cpta%TYPE,
                                     P_dat_jc IN DATE,
                                     P_ide_ecr IN FC_ECRITURE.ide_ecr%TYPE,
                                     P_num_lig IN FC_LIGNE.ide_lig%TYPE,
                                     P_ide_jal IN FC_ECRITURE.ide_jal%TYPE,
                                     P_ide_cpt IN FB_LIGNE_PIECE.ide_cpt%TYPE,
                                     P_ide_cpt_hb IN FB_LIGNE_PIECE.ide_cpt_hb%TYPE,
                                     P_dat_ecr IN FC_ECRITURE.dat_ecr%TYPE,
                                     P_var_bud IN FB_LIGNE_PIECE.var_bud%TYPE,
                                     P_ide_lig_exec IN FB_LIGNE_PIECE.ide_lig_exec%TYPE,
          -- Modif MYI le 10/04/2002
          P_ide_lig_prev   IN FB_LIGNE_PIECE.ide_lig_prev%TYPE,
          P_dat_emis       IN FB_PIECE.DAT_EMIS%TYPE,
          P_dat_reception  IN FB_PIECE.DAT_EMIS%TYPE,
          P_ide_piece_init IN FB_PIECE.IDE_PIECE_INIT%TYPE,
          P_Ide_Eng        IN FB_LIGNE_PIECE.IDE_ENG%TYPE,
          -- Fin Modif MYI
                                     P_ide_ope IN FB_LIGNE_PIECE.ide_ope%TYPE,
                                     P_mt IN FB_LIGNE_PIECE.mt%TYPE,
                                     P_mt_bud IN FB_LIGNE_PIECE.mt_bud%TYPE,
          -- MODIF MYI le 15/05/2002 : Fonction 48
          P_mt_dev      IN FB_LIGNE_PIECE.mt_dev%TYPE,
          P_mt_bud_dev  IN FB_LIGNE_PIECE.mt_bud_dev%TYPE,
          P_ide_devise  IN FC_LIGNE.ide_devise%TYPE,
          P_val_taux    IN FC_LIGNE.VAL_TAUX%TYPE,
          -- FIN MODIF MYI Le 15/05/2002
          P_ret OUT NUMBER,
                                     P_num_lig_s OUT FC_LIGNE.ide_lig%TYPE )
IS
/*
-- ----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : CAD
-- Nom           : MAJ_ins_ligne_bud
-- ---------------------------------------------------------------------------
--  Auteur         : ---
--  Date creation  : --/--/----
-- ---------------------------------------------------------------------------
-- Role          : Génération des lignes pour l'écriture de prise en charge
--
-- Parametres    :
--                 1- P_cod_typ_piece  : Code type pièce
--                 2- P_ide_ss_type    :
--       3- P_ide_typ_poste  :
--                 4- P_ide_poste      :
--                 5- P_ide_piece   :
--                 6- P_ide_gest   :
--                 7- P_ide_ordo   :
--                 8- P_cod_bud   :
--                 9- P_var_cpta   :
--                 10- P_dat_jc   :
--                 11- P_ide_ecr   :
--                 12- P_num_lig   :
--                 13- P_ide_jal   :
--                 14- P_ide_cpt   :
--                 15- P_ide_cpt_hb  :
--                 16- P_dat_ecr   :
--                 17- P_var_bud   :
--                 18- P_ide_lig_exec  :
--                 19- P_ide_ope   :
--                 20- P_mt    :
--                 21- P_mt_bud   :
-- Valeurs retournees :
--                     P_ret :  < 0 => erreur
--                              1   => OK
--                              2   => OK mais modification a cause du parametrage
--        P_num_lig_s
--  -----------------------------------------------------------------------------------------------------
--  Fonction         |Date     |Initiales |Commentaires
--  -----------------------------------------------------------------------------------------------------
-- @(#) MAJ_ins_ligne_bud.sql  1.0-1.0 |3/12/1999 |---| création
-- @(#) MAJ_ins_ligne_bud.sql  3.0-2.0 |04/04/2002 |MYI| Fonction 11 : Paramétrage des sous-types de pièce budgétaire
-- @(#) MAJ_ins_ligne_bud.sql  3.0-2.1 |17/05/2002 |MYI| Fonction 48 : Gestion des opérations en devises
-- @(#) MAJ_ins_ligne_bud.sql  3.0-2.2 |19/06/2002 |MYI| Fonction 11 : Ajout des contrôles sur le paramétrage du schéma comptable
-- @(#) MAJ_ins_ligne_bud.sql  3.3-1.4 |04/09/2003 |SGN| ANOVA420 ANOVA421 : La valeur du compte saisie doit tenir compte du parametrage du modele de ligne
-- @(#) MAJ_ins_ligne_bud.sql  3.3-1.4                      La gestion des erreur lors du controle sur les masques est affinée
-- @(#) MAJ_ins_ligne_bud.sql  3.3-1.5  |14/10/2003 |SGN| Lors de l'insertion dans Fc_ligne on prend v_cpt si non nul sinon on prend P_ide_cpt ou p_ide_cpt_hb + prise en compte du ret = 2
-- @(#) MAJ_ins_ligne_bud.sql  4101-1.2 |06/06/2006 |CBI| Suppression de la fonction length
-- @(#) MAJ_ins_ligne_bud.sql  4200  |23/06/2007 |FBT| Evolution 03-2007 - Alimentation du champ FLG_ANNUL_DCST
-- @(#) MAJ_ins_ligne_bud.sql  4210  |01/08/2007 |FBT| Evolution 01-2007 - Gestion du type de ligne H dans RC_MODELE_LIGNE pour le champ FLG_ANNUL_DCST
-- @(#) MAJ_ins_ligne_bud.sql  4211  |29/11/2007 |FBT| Ano 108 - Controle du masque compte du modele de ligne
-- @(#) MAJ_ins_ligne_bud.sql  v4260 |16/05/2008 |PGE| evol_DI44_2008_014 Controle sur les dates de validité de RC_MODELE_LIGNE
-- @(#) MAJ_ins_ligne_bud.sql  v4261 |27/10/2008 |PGE| ANO 298 :  Vérification du paramétrage des modèles de lignes du mandat.
-- @(#) MAJ_ins_ligne_bud.sql  v4300 |03/11/2009 |FBT| ANO 394 : on ne doit pas générer d'incohérence CAD / CGE - On passe du message 915 informatif au 914 bloquant
--------------------------------------------------------------------------------
*/

   v_FLG_ANNUL_CREANCE    CHAR(1);
   v_FLG_ANNUL_DROIT    CHAR(1);
   v_FLG_ANNUL_DCST        CHAR(1);
   v_cod_typ_piece         FC_ECRITURE.cod_typ_piece%TYPE;
   v_libl                SR_CODIF.libl%TYPE;
   v_retour         number := 0;
   v_flg_cptab             FC_LIGNE.flg_cptab%TYPE;
   v_ide_schema            FC_LIGNE.ide_schema%TYPE;
   v_uti_cre               FC_LIGNE.uti_cre%TYPE := GLOBAL.cod_util;
   v_dat_cre               FC_LIGNE.dat_cre%TYPE := sysdate;
   v_uti_maj               FC_LIGNE.uti_maj%TYPE := GLOBAL.cod_util;
   v_dat_maj               FC_LIGNE.dat_maj%TYPE := sysdate;
   v_terminal              FC_LIGNE.terminal%TYPE := GLOBAL.terminal;
   v_mt_ligne              FC_LIGNE.mt%TYPE;
   v_cod_typ_bud           FC_LIGNE.cod_typ_bud%TYPE;
   v_cod_typ_schema        FC_LIGNE.cod_typ_schema%TYPE;
   v_codint_cod_sens       SR_CODIF.ide_codif%TYPE;
   v_num_lig               FC_LIGNE.ide_lig%TYPE;
   Increment               BOOLEAN := FALSE;
   v_codif_oui      VARCHAR2(200);
   v_codif_non      VARCHAR2(200);
   v_codif_libl      VARCHAR2(200);
   v_temp                  NUMBER := 0;

   -- Modif MYI Le 10/04/2002
    v_Spec1     FC_LIGNE.spec1%Type;
 v_Spec2     FC_LIGNE.spec2%Type;
 v_Spec3     FC_LIGNE.spec3%Type;
 v_cpt  FC_LIGNE.ide_cpt%Type;
 v_ordo  FC_LIGNE.ide_ordo%Type;
 v_bud  FC_LIGNE.cod_bud%Type;
 v_lig_bud FC_LIGNE.ide_lig_exec%Type;
 v_ope  FC_LIGNE.ide_ope%Type;
    v_codint_type_budget SR_CODIF.ide_codif%TYPE;

 -- MODIF MYI Le 15/05/2002 ( Fonction 48 )
 v_mt_ligne_dev FC_LIGNE.mt_dev%TYPE;
 v_Insert_Hors_Budget Boolean :=FALSE;
 v_Insert_Budget Boolean :=FALSE;

 	v_nb_B number := 0;
	v_nb_H number := 0;
   ----------------------------------------------------------------------
   -- Crétaion curseur sur RC_MODELE_LIGNE
   ----------------------------------------------------------------------
   Cursor c_Rc_Modele_Ligne ( P_ide_Shema IN  Rc_Modele_Ligne.Ide_schema%Type)
   Is Select *
   From RC_MODELE_LIGNE
   Where
     var_cpta   = P_var_cpta   And
  ide_jal    = P_ide_jal    And
  ide_schema = P_ide_Shema
  AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
  AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008
   v_Cod_Typ_Pec Rc_Modele_Ligne.Cod_Typ_Pec%TYPE;
   ----------------------------------------------------------------------

   donnee_absente          EXCEPTION;
   ext_codext_error        EXCEPTION;
   ext_codint_error        EXCEPTION;
   Erreur_Parametrage      EXCEPTION; -- erreur de paramétrage
   Erreur_Param_Shema      EXCEPTION; -- Shéma comptable attaché au sous-type de pièce n'existe pas ou n'est pas valide.
   Erreur_Modele_Ligne     EXCEPTION; -- Erreur de paramétrage de modèle de ligne
   Erreur_Type_Shema       EXCEPTION; -- Type shéma n'existe pas ou n'est pas valide
   -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4
   Erreur_maj_cpt          EXCEPTION; -- Le compte est modifie alors que le schema indique qu il n est pas modifiable.
   Erreur_val_masque_cpt   EXCEPTION; -- La valeur du masque du compte saisie n est pas conforme au parametrage
   -- Erreur lors du controle du masque, incoherence avec avec le parametrage de la saisie des ecr
   Erreur_ctl_masque_spec1 EXCEPTION;
   Erreur_ctl_masque_spec2 EXCEPTION;
   Erreur_ctl_masque_spec3 EXCEPTION;
   Erreur_ctl_masque_cpt   EXCEPTION;
   Erreur_ctl_masque_ordo  EXCEPTION;
   Erreur_ctl_masque_bud   EXCEPTION;
   Erreur_ctl_masque_ligbud EXCEPTION;
   Erreur_ctl_masque_ope   EXCEPTION;

   v_non SR_CODIF.cod_codif%TYPE;
   -- modif sgn 3.3-1.4

  v_flg_err915 NUMBER;  -- MODIF SGN ANOVSR420 : 3.3-1.5

  ----------------------------------------------------------------------------------
  -- Fonction Contrôle de paramétrage :
  ----------------------------------------------------------------------------------
  FUNCTION CTL_PARAM_PRISE_CHARGE (P_Nomchamp  IN RC_MODELE_LIGNE.VAL_SPEC1%TYPE,
               P_valmasque IN RC_MODELE_LIGNE.MAS_SPEC1%TYPE,
          P_retour    OUT Number
         ) Return Varchar2 IS

   v_res  RC_MODELE_LIGNE.MAS_SPEC1%TYPE;
   v_libl SR_CODIF.LIBL%Type;
   v_ret Number;
   v_codint_masque  SR_CODIF.IDE_CODIF%Type;
   ext_codint_error EXCEPTION;

        -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4
        ext_mask_error EXCEPTION;
        v_zone SR_MASQUE.cod_zone%TYPE;
        -- fin modif sgn : 3.3-1.4

  BEGIN

  -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : Recuperation du code masque de la zone
  --Ext_Codint('MASQUE',P_valmasque ,v_libl,v_codint_masque , v_ret);
  --IF v_retour != 1 THEN
  --       RAISE ext_codint_error;
  --END IF;
  --

  -- Recuperation du code zone en fonction du nomchamp
  SELECT DECODE (P_Nomchamp, 'MAS_CPT', 'Compte',
                             'MAS_TIERS', 'Tiers',
         'MAS_ORDO', 'Ordo',
          'MAS_BUD', 'Budget',
         'MAS_LIG_BUD', 'Lig_bud',
         'MAS_OPE', 'Ope',
                             'MAS_SPEC1', 'Spec',
                             'MAS_SPEC2', 'Spec',
                             'MAS_SPEC3', 'Spec',
                             'MAS_REF_PIECE', 'Refpiece',
                             NULL)
  INTO v_zone
  FROM dual;

  -- Verification du masque, et recuperation du code interne en fonction de la zone, on va chercher les valeurs
  --  autorisées pour la saisie des ecritures comptables. Permet ensuite de pouvoir controler les masques Chai et Chai*
  CTL_SAIS_MASQUE('U212_011F', v_zone, P_valmasque, v_codint_masque, v_ret);

  -- Si le controle est OK
  IF v_ret = 1 THEN
  -- fin modif sgn 3.3-1.4

    Select Decode (P_Nomchamp, 'MAS_CPT', Decode(v_codint_masque, 'CPT', P_ide_cpt,
                 '@CHB', P_ide_cpt_hb,
                 Null),
         'MAS_ORDO'   ,Decode(v_codint_masque, '@ORDO', P_ide_ordo,
                        Null),
          'MAS_BUD'    ,Decode(v_codint_masque, '@BUDG', P_cod_bud,
               Null),
         'MAS_LIG_BUD',Decode(v_codint_masque, '@LEXE',P_ide_lig_exec,
                  Null),
         'MAS_OPE'    ,Decode(v_codint_masque, '@OPE',P_ide_ope,
              Null),
                   Decode (v_codint_masque, '@PC', P_ide_poste,
              '@GEST'      , P_ide_gest ,
         '@ORDO'      , P_ide_ordo ,
         '@BUDG'      , P_cod_bud  ,
         '@LEXE'      , P_ide_lig_exec ,
         '@LPRV'      , P_ide_lig_prev ,
         '@PIEC'      , P_ide_piece ,
         '@OPE'       , P_ide_ope ,
         '@DEMI'      , to_char(P_dat_emis,'DD/MM/RRRR'),
         '@DREC'      , to_char(P_dat_reception,'DD/MM/RRRR'),
         '@PORI'      , P_ide_piece_init ,
         'CPT'        , P_ide_cpt ,
         '@ENG'       , P_Ide_Eng ,
         '@CHB'       , P_ide_cpt_hb ,
         Null) )
      into v_res From Dual;

  -- MODIF SGN 3.3-1.4 : ANOVSR420 ANOVSR421
  ELSE
    raise ext_mask_error;
  END IF;  -- if v_ret = 1 then
  -- fin modif sgn 3.3-1.4

  P_retour := 1;
  Return (v_res);

  EXCEPTION
  When ext_codint_error Then
      P_retour:=0;
   Return Null;
  -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4
  When ext_mask_error Then
      P_retour:=-1;
   Return Null;
  -- fin modif sgn 3.3-1.4
  END CTL_PARAM_PRISE_CHARGE;
  ----------------------------------------------------------------------------------
BEGIN

   -- MODIF SGN ANOVSR420 : 3.3-1.5 : initialisation de v_flg_err915 a 0 et p_ret a 1
   v_flg_err915 := 0;
   p_ret := 1;
   -- fin modif sgn 3.3-1.5

   BEGIN
   ----------------------------------------------------------------------------------------------------
   -- Modif MYI Le 04/04/2002 :
   --    1) Suppression des champs  cod_sens_bud, ide_modele_lig_bud ,  v_cod_sens et v_ide_modele_lig
   --    2) Ajout de ide_typ_poste et ide_ss_type dans le clause WHERE de l'ordre select
    SELECT ide_schema
    INTO v_ide_schema
    FROM pc_prise_charge
    WHERE cod_typ_piece = P_cod_typ_piece
      AND var_cpta      = P_var_cpta
   AND Ide_Typ_Poste = P_Ide_Typ_Poste    -- Type poste comptable
  -- AND ctl_date(
   AND Ide_SS_Type   = P_Ide_SS_Type;     -- Code du sous-type de pièce
   -- FIN MODIF MYI Le 04/04/2002
   ----------------------------------------------------------------------------------------------------
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
          RAISE  Erreur_Param_Shema; -- shéma comptable attaché au sous-type de pièce %1 n'existe pas ou n'est pas valide ( message N° 797) .
       WHEN OTHERS THEN
          RAISE;
   END;
   ------------------------------------------------------------------------------
   -- Rechercher le code type schéma
   ------------------------------------------------------------------------------
   BEGIN
    SELECT cod_typ_schema
 INTO v_cod_typ_schema
 FROM rc_schema_cpta
 WHERE var_cpta     = P_var_cpta
 AND   ide_jal      = P_ide_jal
 AND   ide_schema   = v_ide_schema;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
   RAISE Erreur_Type_Shema; -- Type shéma n'existe pas ou n'est pas valide ( Message N° 802 )
   WHEN OTHERS THEN
   RAISE;
   END;

   ------------------------------------------------------------------------------
   -- MODIF MYI Le 09/04/2002 : Fonction 11
   ------------------------------------------------------------------------------
    EXT_CODINT('TYPE_PIECE', P_cod_typ_piece, v_libl, v_cod_typ_piece, v_retour);
    IF v_retour != 1 THEN
       RAISE ext_codint_error;
    END IF;

    EXT_CODEXT('OUI_NON', 'O', v_libl, v_flg_cptab, v_retour);
    IF v_retour != 1 THEN
       RAISE ext_codext_error;
    END IF;

         -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4
         EXT_CODEXT('OUI_NON', 'N', v_libl, v_non, v_retour);
    IF v_retour != 1 THEN
       RAISE ext_codext_error;
    END IF;
         -- fin modif sgn 3.3-1.4

    ------------------------------------------------------------------------------
    -- Déterminer le type budget en fonction du sous type pièce
    ------------------------------------------------------------------------------
    EXT_TYPE_BUDGET(P_Cod_Typ_Piece => P_cod_typ_piece ,
        P_Ide_SS_Type   => P_Ide_SS_Type   ,
        P_Type_Budget   => v_codint_type_budget ,
        P_retour        => v_retour
       );
    If v_retour = 0 Then
       Raise donnee_absente;
    Elsif v_retour = -1 Then
       Raise ext_codint_error;
    Elsif v_retour = -2 Then
       Raise Erreur_Parametrage; -- Pour le sous-type de pièce budgétaire %1 l'ordonnance impute
           -- le budget en dépense ou le budget en recette  (message N° 795 )
    End if;
    ------------------------------------------------------------------------------
    -- extraction code interne de type budget
    ------------------------------------------------------------------------------
    IF v_codint_type_budget = 'R' Then
       EXT_CODEXT('TYPE_BUDGET', 'R', v_libl, v_cod_typ_bud, v_retour);
       IF v_retour != 1 THEN
          RAISE ext_codext_error;
       END IF;
    Elsif v_codint_type_budget = 'D' Then
       EXT_CODEXT('TYPE_BUDGET', 'D', v_libl, v_cod_typ_bud, v_retour);
       IF v_retour != 1 THEN
          RAISE ext_codext_error;
       END IF;
    End if;

	---------------------------------------------------------------------------------
	--
	---------------------------------------------------------------------------------
	--Début PGE 21/10/2008 ANO 301.

    FOR v_modele_ligne IN c_Rc_Modele_Ligne (v_ide_schema)  LOOP

		EXT_CODINT('TYPE_PEC',v_modele_ligne.Cod_Typ_Pec, v_libl ,v_Cod_Typ_Pec, v_retour);
		IF v_retour != 1 THEN
		    RAISE ext_codint_error;
		END IF;

		IF v_Cod_Typ_Pec IN ('B') THEN
		   v_nb_B := 1;
		END IF;

		IF v_Cod_Typ_Pec IN ('H') THEN
		   v_nb_H := 1;
		END IF;

	END LOOP;

	--Si ce n'est pas du budgétaire, alors p_mt_bud =0 sinon erreur de paramétrage
	IF v_nb_B = 0  and P_mt_bud <> 0 THEN
	   raise Erreur_Modele_Ligne;
	END IF;

	-- Si ce n'est pas de l'hors budget alors P_mt_bud = p_mt, sinon erreur de paramérage.
	IF v_nb_H = 0  and (P_mt_bud <> p_mt) THEN
	   raise Erreur_Modele_Ligne;
	END IF;
	--Fin PGE 21/10/2008 ANO 301.
   ------------------------------------------------------------------------------

    v_num_lig:=P_num_lig;
   ----------------------------------------------------------------------------
   --  Génération des lignes des écritures
   ----------------------------------------------------------------------------
    FOR v_modele_ligne IN c_Rc_Modele_Ligne (v_ide_schema)  LOOP
   ----------------------------------------------------------------------------------
   -- Teste cohérence code interne TYPE_PEC
   ----------------------------------------------------------------------------------
   EXT_CODINT('TYPE_PEC',v_modele_ligne.Cod_Typ_Pec, v_libl ,v_Cod_Typ_Pec, v_retour);
      IF v_retour != 1 THEN
          RAISE ext_codint_error;
      END IF;
   -----------------------------------------------------------------------------
   -- CONTROLE MASQUE DE PARAMETRAGE  :  MYI LE 11/04/2002
   -----------------------------------------------------------------------------
   -- Initialisation des variables
    v_Spec1    :=Null;
    v_Spec2    :=Null;
    v_Spec3    :=Null;
    v_cpt      :=Null;
    v_ordo     :=Null;
    v_bud      :=Null;
    v_lig_bud  :=Null;
    v_ope   :=Null;

         -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : on ne teste les masques que si on se trouve sur le bon modele de ligne
         IF v_Cod_Typ_Pec IN ('B', 'H') THEN

   --------------------------------------------------------------------------------
   --1) Contrôle sur le masque de contrôle spec1
   --------------------------------------------------------------------------------
   IF v_modele_ligne.mas_spec1 Is not Null Then
     v_Spec1 :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_SPEC1' ,
                 P_valmasque => v_modele_ligne.mas_spec1,
                     P_retour    => v_retour
                     );
      -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                     IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                       Raise Erreur_ctl_masque_spec1;
                     --  If v_retour <> 1 Then
                     ELSIF v_retour <> 1 Then
                     -- fin modif sgn 3.3-1.4
          Raise ext_codint_error;
      End if;
      If v_Spec1 is null  And   v_modele_ligne.val_spec1 is not null Then
      v_Spec1 :=v_modele_ligne.val_spec1; -- si valeur par défaul <> null et la masque <> null
                    -- alors v_spec1 initialiser à  val_spec1
      End if;
   END IF;
   --------------------------------------------------------------------------------
   --2) Contrôle sur le masque de contrôle spec2
   --------------------------------------------------------------------------------
   IF v_modele_ligne.mas_spec2 Is not Null Then
   v_Spec2 :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_SPEC2',
                 P_valmasque => v_modele_ligne.mas_spec2 ,
                      P_retour    => v_retour
               );
   -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                  IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                    Raise Erreur_ctl_masque_spec2;
                    --  If v_retour <> 1 Then
                  ELSIF v_retour <> 1 Then
                    -- fin modif sgn 3.3-1.4
      Raise ext_codint_error;
   End if;

   If v_Spec2 is null  And   v_modele_ligne.val_spec2 is not null Then
      v_Spec2 :=v_modele_ligne.val_spec2; -- si valeur par défaul <> null et la masque <> null
                       -- alors v_spec2 initialiser à  val_spec2
   End if;
    END IF;
    --------------------------------------------------------------------------------
    --3) Contrôle sur le masque de contrôle spec3
    --------------------------------------------------------------------------------
    IF v_modele_ligne.mas_spec3 Is not Null Then
    v_Spec3 :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_SPEC3',
                 P_valmasque => v_modele_ligne.mas_spec3,
                       P_retour    => v_retour
               );
    -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                   IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                     Raise Erreur_ctl_masque_spec3;
                   --  If v_retour <> 1 Then
                   ELSIF v_retour <> 1 Then
                   -- fin modif sgn 3.3-1.4
       Raise ext_codint_error;
    End if;

    If v_Spec3 is null  And   v_modele_ligne.val_spec3 is not null Then
    v_Spec3 :=v_modele_ligne.val_spec3; -- si valeur par défaul <> null et la masque <> null
                     -- alors v_spec3 initialiser à  val_spec3
    End if;
    END IF;
    --------------------------------------------------------------------------------
    --4) Contrôle sur le masque du compte
    --------------------------------------------------------------------------------
    IF v_modele_ligne.mas_cpt Is not Null Then
--CBI-20060706-D
-- Lors du passage en V4 le code posait pb et retournait blanc au lieu d'une valeur
/*
    v_cpt:=substr(CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_CPT',
                        P_valmasque => v_modele_ligne.mas_cpt,
               P_retour    => v_retour
                     ),1,length(v_cpt));
*/

    v_cpt:=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_CPT',
                        P_valmasque => v_modele_ligne.mas_cpt,
               P_retour    => v_retour
                     );

--CBI-20060706-F
    -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                   IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                     Raise Erreur_ctl_masque_cpt;
                   --  If v_retour <> 1 Then
                   ELSIF v_retour <> 1 Then
                     -- fin modif sgn 3.3-1.4
       Raise ext_codint_error;
    End if;

                   -- Si valeur par défaut = null et le masque <> null
    -- alors v_cpt initialisé à  val_cpt
                   If v_cpt is null  And   v_modele_ligne.val_cpt is not null THEN -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : And P_ide_cpt is null Then

                     -- Si une valeur est renseignée et que la modification est possible
                     IF p_ide_cpt IS NOT NULL AND v_modele_ligne.flg_maj_cpt != v_non THEN
                       v_cpt := p_ide_cpt;

                     -- sinon on applique le schema
                     ELSE
         v_cpt :=v_modele_ligne.val_cpt;
                       -- MODIF SGN ANOVSR420 : 3.3-1.5 : en cas de modification du au parametrage p_ret = 2 => on pourra prevenir le user
                       IF v_cpt != p_ide_cpt THEN
			 --FBT - 03/11/2009 - ANO 394 - on ne doit pas générer d'incohérence CAD / CGE
			 -- on passe du message 915 informatif au 914 bloquant
                         --v_flg_err915 := 1;
			 RAISE Erreur_val_masque_cpt;
                       END IF;
                       -- fin modif sgn 3.3-1.5
                     END IF;
                   END IF;

                   -- FBT - le 29/07/2007 - ANO 108
				   IF v_cpt is not null THEN
                     v_retour := CTL_VAL_MASQUE(v_modele_ligne.mas_cpt, v_cpt, SYSDATE);
                     IF v_retour != 1 THEN
                       RAISE Erreur_val_masque_cpt;
                     END IF;
				   END IF;

                   -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : Gestion de la coche flg_maj_cpt
                   -- dans le cas ou elle est a non, on ne doit pas pouvoir modifier le compte
                   IF v_modele_ligne.flg_maj_cpt = v_non THEN
                     IF v_cpt != v_modele_ligne.val_cpt THEN
                       Raise Erreur_maj_cpt;
                     END IF;
                   END IF;
                   -- fin modif sgn

     END IF;
     --------------------------------------------------------------------------------
     -- 5) Contrôle sur le masque de l'ordonnateur
     -------------------------------------------------------------------------------
   IF v_modele_ligne.mas_ordo Is not Null Then
--CBI-20060706-D
-- Lors du passage en V4 le code posait pb et retournait blanc au lieu d'une valeur
/*
      v_ordo :=substr(CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_ORDO',
                         P_valmasque => v_modele_ligne.mas_ordo ,
                P_retour    => v_retour
                        ),1,length(v_ordo));

*/
      v_ordo :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_ORDO',
                         P_valmasque => v_modele_ligne.mas_ordo ,
                P_retour    => v_retour
                        );

--CBI-20060706-F

      -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                     IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                       Raise Erreur_ctl_masque_ordo;
                     --  If v_retour <> 1 Then
                     ELSIF v_retour <> 1 Then
                     -- fin modif sgn 3.3-1.4
          Raise ext_codint_error;
      End if;

      If v_ordo is null  And   v_modele_ligne.val_ordo is not null and  P_ide_ordo is null Then
      v_ordo :=v_modele_ligne.val_ordo;    -- si valeur par défaul <> null et la masque <> null
                      -- alors v_ordo initialiser à  val_ordo
      End if;
   END IF;
   --------------------------------------------------------------------------------
   --6) Contrôle sur le masque budget
   --------------------------------------------------------------------------------
   IF v_modele_ligne.mas_bud Is not Null Then
--CBI-20060706-D
-- Lors du passage en V4 le code posait pb et retournait blanc au lieu d'une valeur
/*

      v_bud :=substr(CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_BUD',
                        P_valmasque => v_modele_ligne.mas_bud ,
               P_retour    => v_retour
                        ),1,length(v_bud));
*/


      v_bud :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_BUD',
                        P_valmasque => v_modele_ligne.mas_bud ,
               P_retour    => v_retour
                        );
--CBI-20060706-F
      -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                     IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                       Raise Erreur_ctl_masque_bud;
                     --  If v_retour <> 1 Then
                     ELSIF v_retour <> 1 Then
                     -- fin modif sgn 3.3-1.4

          Raise ext_codint_error;
      End if;

      If v_bud is null  And   v_modele_ligne.val_bud is not null and  P_cod_bud is null Then
      v_bud :=v_modele_ligne.val_bud;    -- si valeur par défaul <> null et la masque <> null
                    -- alors v_bud initialiser à  val_bud
      End if;
   END IF;
   --------------------------------------------------------------------------------
   --7) Contrôle sur le masque ligne budget
   --------------------------------------------------------------------------------
   IF v_modele_ligne.mas_bud Is not Null Then
      v_lig_bud :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_LIG_BUD',
                     P_valmasque => v_modele_ligne.mas_lig_bud ,
               P_retour    => v_retour
              );

      -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                     IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                       Raise Erreur_ctl_masque_ligbud;
                     --  If v_retour <> 1 Then
                     ELSIF v_retour <> 1 Then
                     -- fin modif sgn 3.3-1.4
          Raise ext_codint_error;
      End if;

                     If v_lig_bud  is null  And   v_modele_ligne.val_lig_bud is not null and  P_ide_lig_exec is null Then
      v_lig_bud :=v_modele_ligne.val_lig_bud ;     -- si valeur par défaul <> null et la masque <> null
                              -- alors v_bud initialiser à  val_bud
      End if;
   END IF;
   --------------------------------------------------------------------------------
   --8) Contrôle sur le masque de l'opération
   --------------------------------------------------------------------------------
   IF v_modele_ligne.mas_ope Is not Null Then
--CBI-20060706-D
-- Lors du passage en V4 le code posait pb et retournait blanc au lieu d'une valeur
/*
      v_ope :=substr(CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_OPE',
                        P_valmasque => v_modele_ligne.mas_ope,
               P_retour    => v_retour
                                  ),1,length(v_ope));
*/

      v_ope :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_OPE',
                        P_valmasque => v_modele_ligne.mas_ope,
               P_retour    => v_retour
                                  );


--CBI-20060706-F

      -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                     IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                       Raise Erreur_ctl_masque_ope;
                     --  If v_retour <> 1 Then
                     ELSIF v_retour <> 1 Then
                     -- fin modif sgn 3.3-1.4
           Raise ext_codint_error;
      End if;

                        If v_ope  is null  And   v_modele_ligne.val_ope is not null and  P_ide_ope is null Then
       v_ope :=v_modele_ligne.val_ope ;     -- si valeur par défaul <> null et la masque <> null
                       -- alors v_ope initialiser à  val_ope
    End if;
   END IF;

        END IF;  -- if v_cod_typ_pec in ( 'h', 'b' ) THEN -- fin modif sgn 3.3-1.4



  -----------------------------------------------------------------------------
  -- Recherche le sens de la ligne d'écriture
  -----------------------------------------------------------------------------
  EXT_CODINT('SENS',v_modele_ligne.val_sens , v_libl ,v_codint_cod_sens, v_retour);
  IF v_retour != 1 THEN
           RAISE ext_codint_error;
      END IF;


  -----------------------------------------------------------------------------
  --valeur du champ FLG_ANNUL_DCST
  -----------------------------------------------------------------------------
  -- FBT - 01/08/2007 - Evol DI44-01-2007
  EXT_CODEXT ( 'OUI_NON', 'O', v_codif_libl, v_codif_oui, v_temp );
  EXT_CODEXT ( 'OUI_NON', 'N', v_codif_libl, v_codif_non, v_temp );
  --recherche du flag annulation droits constatés sur le compte budgétaire
  SELECT FLG_ANNUL_DCST INTO v_FLG_ANNUL_DROIT
  FROM FN_COMPTE
  WHERE VAR_CPTA=P_var_cpta
  AND IDE_CPT=DECODE(v_cpt,null,P_ide_cpt,v_cpt);
  --recherche du flag annulation de créance sur le modele de ligne budgétaire du schéma
  SELECT FLG_ANNUL_CREANCE INTO v_FLG_ANNUL_CREANCE
  FROM RC_MODELE_LIGNE
  WHERE VAR_CPTA=P_var_cpta
  AND IDE_JAL=P_ide_jal
  AND IDE_SCHEMA=v_ide_schema
  AND RANG_LIG=v_modele_ligne.rang_lig
  AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
  AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008
  --test valeur du champ
  IF v_FLG_ANNUL_DROIT=v_codif_oui AND v_FLG_ANNUL_CREANCE=v_codif_oui THEN
      v_FLG_ANNUL_DCST:=v_codif_oui;
  ELSE
   v_FLG_ANNUL_DCST:=v_codif_non;
  END IF;

   -------------------------------------------------------------------------------------
   --1 Test si Si le shéma attaché au sous-type de pièce pour le modèle de ligne dont le
   --  type de ligne = 'B'
   -------------------------------------------------------------------------------------
   If v_Cod_Typ_Pec = 'B' And   nvl(P_mt_bud,0) != 0  And Not v_Insert_Budget THEN  -- génération des lignes budgétaires
         BEGIN
      --recherche du signe
   IF  (( v_cod_typ_piece IN ( 'OR', 'AD' ) AND (v_codint_cod_sens = 'C' )) OR
              ( v_cod_typ_piece IN ( 'AR', 'OD' ) AND (v_codint_cod_sens = 'D' ))) THEN
              v_mt_ligne     := P_mt_bud;
          v_mt_ligne_dev := P_mt_bud_dev;
        ELSE
               v_mt_ligne    := P_mt_bud * (-1);
       v_mt_ligne_dev := P_mt_bud_dev * (-1);
            END IF;

   IF Increment = TRUE THEN
          v_num_lig := v_num_lig + 1;
        END IF;

   --insertion dans la table FC_LIGNE
   INSERT INTO fc_ligne ( ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr, ide_lig
            , var_cpta, ide_cpt, cod_sens, var_bud, ide_lig_exec, ide_ope, ide_ordo
            , cod_bud, cod_typ_bud, mt,spec1 ,spec2 ,spec3, ide_schema, cod_typ_schema, ide_modele_lig
            , dat_ecr, dat_cre, uti_cre, dat_maj, uti_maj, terminal
       , Ide_devise ,mt_dev , val_taux, FLG_ANNUL_DCST )
        VALUES ( P_ide_poste, P_ide_gest, P_ide_jal, v_flg_cptab, P_ide_ecr, v_num_lig,P_var_cpta,
                  DECODE(v_cpt,null,P_ide_cpt,v_cpt),
                  v_modele_ligne.val_sens, P_var_bud, DECODE(P_ide_lig_exec,null,v_lig_bud,P_ide_lig_exec), decode(P_ide_ope,null,v_ope,P_ide_ope),
           decode(P_ide_ordo,null,v_ordo,P_ide_ordo), decode(P_cod_bud,null,v_bud,P_cod_bud), v_cod_typ_bud, v_mt_ligne,v_spec1 , v_spec2 , v_spec3 , v_ide_schema,
           v_cod_typ_schema, v_modele_ligne.ide_modele_lig, P_dat_ecr, v_dat_cre, v_uti_cre, v_dat_maj,
           v_uti_maj, v_terminal ,P_ide_devise ,v_mt_ligne_dev , P_val_taux,v_FLG_ANNUL_DCST);

      v_Insert_Budget := TRUE;
         Increment := TRUE;
         P_num_lig_s := v_num_lig;

            -- p_ret = 2 uniquement si la modif du param est inserée en base
            IF v_flg_err915 = 1 THEN
              p_ret := 2;
            END IF;

       EXCEPTION
          WHEN OTHERS THEN
             RAISE;
       END;
     ELSIF  v_Cod_Typ_Pec = 'B' And   nvl(P_mt_bud,0) != 0  And v_Insert_Budget THEN
      RAISE Erreur_Modele_Ligne;
  ELSIF  v_Cod_Typ_Pec = 'H' And   nvl(P_mt_bud,0) != nvl(P_mt,0)  And Not v_Insert_Hors_Budget THEN

    BEGIN

       ------------------------------------------------------------------------
    -- Recherche le montant
    ------------------------------------------------------------------------
    IF  (( v_cod_typ_piece IN ('OR','AD' ) AND (v_codint_cod_sens = 'C' )) OR
           ( v_cod_typ_piece IN  ('AR','OD' ) AND (v_codint_cod_sens = 'D' ))) THEN
             v_mt_ligne   := ( P_mt - P_mt_bud);
    -- MODIF MYI Le 15/05/2002 : Fonction 48
    v_mt_ligne_dev  := ( P_mt_dev - P_mt_bud_dev );
    -- FIN MODIF MYI
       ELSE
             v_mt_ligne   := ( P_mt     - P_mt_bud ) * (-1);
    -- MODIF MYI Le 15/05/2002 : Fonction 48
    v_mt_ligne_dev  := ( P_mt_dev - P_mt_bud_dev ) * (-1);
    -- FIN MODIF MYI
       END IF;
       ------------------------------------------------------------------------
    IF Increment = TRUE THEN
          v_num_lig := v_num_lig + 1;
       END IF;



       INSERT INTO fc_ligne ( ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr, ide_lig
       , var_cpta, ide_cpt, cod_sens, ide_ope, ide_ordo
       , cod_bud, cod_typ_bud, mt ,spec1 ,spec2 ,spec3, ide_schema, cod_typ_schema, ide_modele_lig
       , dat_ecr, dat_cre, uti_cre, dat_maj, uti_maj, terminal
     -- MODIF MYI Le 15/05/2002 : Fonction 48
    , Ide_devise ,mt_dev , val_taux,FLG_ANNUL_DCST  )
   -- FIN MODIF MYI
       VALUES ( P_ide_poste, P_ide_gest, P_ide_jal, v_flg_cptab, P_ide_ecr, v_num_lig,
       P_var_cpta,
            DECODE(v_cpt,null,P_ide_cpt_hb,v_cpt), -- MODIF SGN ANOVSR420 : 3.3-1.5 : DECODE(P_ide_cpt_hb,null,v_cpt,P_ide_cpt_hb),
            v_modele_ligne.val_sens, decode(P_ide_ope,null,v_ope,P_ide_ope),
       decode(P_ide_ordo,null,v_ordo,P_ide_ordo), decode(P_cod_bud,null,v_bud,P_cod_bud), v_cod_typ_bud, v_mt_ligne ,v_spec1 , v_spec2 , v_spec3 , v_ide_schema,
       v_cod_typ_schema, v_modele_ligne.ide_modele_lig, P_dat_ecr, v_dat_cre, v_uti_cre, v_dat_maj,
       v_uti_maj, v_terminal ,P_ide_devise ,v_mt_ligne_dev, P_val_taux,v_FLG_ANNUL_DCST); -- MODIF MYI Fonction 48 ( Ajout notion de devise )
          v_Insert_Hors_Budget := TRUE;
    Increment := TRUE;
       P_num_lig_s := v_num_lig;

            -- MODIF SGN ANOVSR420 : 3.3-1.5 : On ne p_ret = 2 uniquement si la modif du param est inserée en base
            IF v_flg_err915 = 1 THEN
              p_ret := 2;
            END IF;
            -- fin modif sgn 3.3-1.5

       EXCEPTION
       WHEN OTHERS THEN
           RAISE;
       END;
       ELSIF  v_Cod_Typ_Pec = 'H' And   nvl(P_mt_bud,0) != nvl(P_mt,0)  And v_Insert_Hors_Budget Then
       RAISE Erreur_Modele_Ligne;
    END IF;
   End LOOP;
   -----------------------------------------------------------
   -- MODIF MYI le 18/06/2002 : Fonction 11
   -----------------------------------------------------------
      /*If ( Not v_Insert_Budget And nvl(P_mt_bud,0) != 0 ) OR
       ( Not v_Insert_Hors_Budget And   nvl(P_mt_bud,0) != nvl(P_mt,0) )
    Then
       RAISE Erreur_Modele_Ligne;
    End if;*/

      -- MODIF SGN ANOVSR420 : 3.3-1.5 : p_ret est initialise au debut :  p_ret := 1;

 EXCEPTION
   WHEN donnee_absente      THEN
      P_ret := 0;
   WHEN ext_codext_error    THEN
      P_ret := -1;
   WHEN ext_codint_error    THEN
      P_ret := -2;
   WHEN Erreur_Parametrage  THEN
      P_ret := -3;
   WHEN Erreur_Param_Shema  THEN
      P_ret := -4;
   WHEN Erreur_Modele_Ligne THEN
      P_ret :=-5;
   WHEN Erreur_Type_Shema   THEN
      P_ret :=-6;
   -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4
   WHEN Erreur_maj_cpt THEN
        P_ret := -8;
   WHEN Erreur_val_masque_cpt THEN
        P_ret := -9;
   WHEN Erreur_ctl_masque_spec1 THEN
      P_ret := -10;
   WHEN Erreur_ctl_masque_spec2 THEN
      P_ret := -11;
   WHEN Erreur_ctl_masque_spec3 THEN
      P_ret := -12;
   WHEN Erreur_ctl_masque_cpt THEN
      P_ret := -13;
   WHEN Erreur_ctl_masque_ordo THEN
      P_ret := -14;
   WHEN Erreur_ctl_masque_bud THEN
      P_ret := -15;
   WHEN Erreur_ctl_masque_ligbud THEN
      P_ret := -16;
   WHEN Erreur_ctl_masque_ope THEN
      P_ret := -17;
   -- fin modif sgn 3.3-1.4
   WHEN OTHERS       THEN
      RAISE;
      P_ret := -7;
END MAJ_ins_ligne_bud;

/

CREATE OR REPLACE procedure MAJ_ins_ligne_bud_Cons(
                                     P_cod_typ_piece IN FC_ECRITURE.cod_typ_piece%TYPE,
          -- MODIF MYI Le 04/04/2002 : fonction 11
          P_ide_ss_type   IN FB_PIECE.IDE_SS_TYPE%TYPE,
          P_ide_typ_poste IN RM_POSTE.IDE_TYP_POSTE%TYPE,
          -- FIN MODIF MYI
                                     P_ide_poste IN FB_PIECE.ide_poste%TYPE,
                                     P_ide_piece IN FB_PIECE.ide_piece%TYPE,
                                     P_ide_gest IN FB_PIECE.ide_gest%TYPE,
                                     P_ide_ordo IN FB_PIECE.ide_ordo%TYPE,
                                     P_cod_bud IN FB_PIECE.cod_bud%TYPE,
                                     P_var_cpta IN FC_ECRITURE.var_cpta%TYPE,
                                     P_dat_jc IN DATE,
                                     P_ide_ecr IN FC_ECRITURE.ide_ecr%TYPE,
                                     P_num_lig IN FC_LIGNE.ide_lig%TYPE,
                                     P_ide_jal IN FC_ECRITURE.ide_jal%TYPE,
                                     P_ide_cpt IN FB_LIGNE_PIECE.ide_cpt%TYPE,
                                     P_ide_cpt_hb IN FB_LIGNE_PIECE.ide_cpt_hb%TYPE,
                                     P_dat_ecr IN FC_ECRITURE.dat_ecr%TYPE,
                                     P_var_bud IN FB_LIGNE_PIECE.var_bud%TYPE,
                                     P_ide_lig_exec IN FB_LIGNE_PIECE.ide_lig_exec%TYPE,
          -- Modif MYI le 10/04/2002
          P_ide_lig_prev   IN FB_LIGNE_PIECE.ide_lig_prev%TYPE,
          P_dat_emis       IN FB_PIECE.DAT_EMIS%TYPE,
          P_dat_reception  IN FB_PIECE.DAT_EMIS%TYPE,
          P_ide_piece_init IN FB_PIECE.IDE_PIECE_INIT%TYPE,
          P_Ide_Eng        IN FB_LIGNE_PIECE.IDE_ENG%TYPE,
          -- Fin Modif MYI
                                     P_ide_ope IN FB_LIGNE_PIECE.ide_ope%TYPE,
                                     P_mt IN FB_LIGNE_PIECE.mt%TYPE,
                                     P_mt_bud IN FB_LIGNE_PIECE.mt_bud%TYPE,
          -- MODIF MYI le 15/05/2002 : Fonction 48
          P_mt_dev      IN FB_LIGNE_PIECE.mt_dev%TYPE,
          P_mt_bud_dev  IN FB_LIGNE_PIECE.mt_bud_dev%TYPE,
          P_ide_devise  IN FC_LIGNE.ide_devise%TYPE,
          P_val_taux    IN FC_LIGNE.VAL_TAUX%TYPE,
          -- FIN MODIF MYI Le 15/05/2002
          P_ret OUT NUMBER,
                                     P_num_lig_s OUT FC_LIGNE.ide_lig%TYPE )
IS
/*
-- ----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : CAD
-- Nom           : MAJ_ins_ligne_bud
-- ---------------------------------------------------------------------------
--  Auteur         : ---
--  Date creation  : --/--/----
-- ---------------------------------------------------------------------------
-- Role          : Génération des lignes pour l'écriture de prise en charge
--
-- Parametres    :
--                 1- P_cod_typ_piece  : Code type pièce
--                 2- P_ide_ss_type    :
--       3- P_ide_typ_poste  :
--                 4- P_ide_poste      :
--                 5- P_ide_piece   :
--                 6- P_ide_gest   :
--                 7- P_ide_ordo   :
--                 8- P_cod_bud   :
--                 9- P_var_cpta   :
--                 10- P_dat_jc   :
--                 11- P_ide_ecr   :
--                 12- P_num_lig   :
--                 13- P_ide_jal   :
--                 14- P_ide_cpt   :
--                 15- P_ide_cpt_hb  :
--                 16- P_dat_ecr   :
--                 17- P_var_bud   :
--                 18- P_ide_lig_exec  :
--                 19- P_ide_ope   :
--                 20- P_mt    :
--                 21- P_mt_bud   :
-- Valeurs retournees :
--                     P_ret :  < 0 => erreur
--                              1   => OK
--                              2   => OK mais modification a cause du parametrage
--        P_num_lig_s
--  -----------------------------------------------------------------------------------------------------
--  Fonction         |Date     |Initiales |Commentaires
--  -----------------------------------------------------------------------------------------------------
-- @(#) MAJ_ins_ligne_bud.sql  1.0-1.0 |3/12/1999 |---| création
-- @(#) MAJ_ins_ligne_bud.sql  3.0-2.0 |04/04/2002 |MYI| Fonction 11 : Paramétrage des sous-types de pièce budgétaire
-- @(#) MAJ_ins_ligne_bud.sql  3.0-2.1 |17/05/2002 |MYI| Fonction 48 : Gestion des opérations en devises
-- @(#) MAJ_ins_ligne_bud.sql  3.0-2.2 |19/06/2002 |MYI| Fonction 11 : Ajout des contrôles sur le paramétrage du schéma comptable
-- @(#) MAJ_ins_ligne_bud.sql  3.3-1.4 |04/09/2003 |SGN| ANOVA420 ANOVA421 : La valeur du compte saisie doit tenir compte du parametrage du modele de ligne
-- @(#) MAJ_ins_ligne_bud.sql  3.3-1.4                      La gestion des erreur lors du controle sur les masques est affinée
-- @(#) MAJ_ins_ligne_bud.sql  3.3-1.5  |14/10/2003 |SGN| Lors de l'insertion dans Fc_ligne on prend v_cpt si non nul sinon on prend P_ide_cpt ou p_ide_cpt_hb + prise en compte du ret = 2
-- @(#) MAJ_ins_ligne_bud.sql  4101-1.2 |06/06/2006 |CBI| Suppression de la fonction length
-- @(#) MAJ_ins_ligne_bud.sql  4200  |23/06/2007 |FBT| Evolution 03-2007 - Alimentation du champ FLG_ANNUL_DCST
-- @(#) MAJ_ins_ligne_bud.sql  4210  |01/08/2007 |FBT| Evolution 01-2007 - Gestion du type de ligne H dans RC_MODELE_LIGNE pour le champ FLG_ANNUL_DCST
-- @(#) MAJ_ins_ligne_bud.sql  4211  |29/11/2007 |FBT| Ano 108 - Controle du masque compte du modele de ligne
-- @(#) MAJ_ins_ligne_bud.sql  v4260 |16/05/2008 |PGE| evol_DI44_2008_014 Controle sur les dates de validité de RC_MODELE_LIGNE
-- @(#) MAJ_ins_ligne_bud.sql  v4261 |27/10/2008 |PGE| ANO 298 :  Vérification du paramétrage des modèles de lignes du mandat.
-- @(#) MAJ_ins_ligne_bud.sql  v4300 |03/11/2009 |FBT| ANO 394 : on ne doit pas générer d'incohérence CAD / CGE - On passe du message 915 informatif au 914 bloquant
--------------------------------------------------------------------------------
*/

   v_FLG_ANNUL_CREANCE    CHAR(1);
   v_FLG_ANNUL_DROIT    CHAR(1);
   v_FLG_ANNUL_DCST        CHAR(1);
   v_cod_typ_piece         FC_ECRITURE.cod_typ_piece%TYPE;
   v_libl                SR_CODIF.libl%TYPE;
   v_retour         number := 0;
   v_flg_cptab             FC_LIGNE.flg_cptab%TYPE;
   v_ide_schema            FC_LIGNE.ide_schema%TYPE;
   v_uti_cre               FC_LIGNE.uti_cre%TYPE := GLOBAL.cod_util;
   v_dat_cre               FC_LIGNE.dat_cre%TYPE := sysdate;
   v_uti_maj               FC_LIGNE.uti_maj%TYPE := GLOBAL.cod_util;
   v_dat_maj               FC_LIGNE.dat_maj%TYPE := sysdate;
   v_terminal              FC_LIGNE.terminal%TYPE := GLOBAL.terminal;
   v_mt_ligne              FC_LIGNE.mt%TYPE;
   v_cod_typ_bud           FC_LIGNE.cod_typ_bud%TYPE;
   v_cod_typ_schema        FC_LIGNE.cod_typ_schema%TYPE;
   v_codint_cod_sens       SR_CODIF.ide_codif%TYPE;
   v_num_lig               FC_LIGNE.ide_lig%TYPE;
   Increment               BOOLEAN := FALSE;
   v_codif_oui      VARCHAR2(200);
   v_codif_non      VARCHAR2(200);
   v_codif_libl      VARCHAR2(200);
   v_temp                  NUMBER := 0;

   -- Modif MYI Le 10/04/2002
    v_Spec1     FC_LIGNE.spec1%Type;
 v_Spec2     FC_LIGNE.spec2%Type;
 v_Spec3     FC_LIGNE.spec3%Type;
 v_cpt  FC_LIGNE.ide_cpt%Type;
 v_ordo  FC_LIGNE.ide_ordo%Type;
 v_bud  FC_LIGNE.cod_bud%Type;
 v_lig_bud FC_LIGNE.ide_lig_exec%Type;
 v_ope  FC_LIGNE.ide_ope%Type;
    v_codint_type_budget SR_CODIF.ide_codif%TYPE;

 -- MODIF MYI Le 15/05/2002 ( Fonction 48 )
 v_mt_ligne_dev FC_LIGNE.mt_dev%TYPE;
 v_Insert_Hors_Budget Boolean :=FALSE;
 v_Insert_Budget Boolean :=FALSE;

 	v_nb_B number := 0;
	v_nb_H number := 0;
   ----------------------------------------------------------------------
   -- Crétaion curseur sur RC_MODELE_LIGNE
   ----------------------------------------------------------------------
   Cursor c_Rc_Modele_Ligne ( P_ide_Shema IN  Rc_Modele_Ligne.Ide_schema%Type)
   Is Select *
   From RC_MODELE_LIGNE
   Where
     var_cpta   = P_var_cpta   And
  ide_jal    = P_ide_jal    And
  ide_schema = P_ide_Shema
  AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
  AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008
   v_Cod_Typ_Pec Rc_Modele_Ligne.Cod_Typ_Pec%TYPE;
   ----------------------------------------------------------------------

   donnee_absente          EXCEPTION;
   ext_codext_error        EXCEPTION;
   ext_codint_error        EXCEPTION;
   Erreur_Parametrage      EXCEPTION; -- erreur de paramétrage
   Erreur_Param_Shema      EXCEPTION; -- Shéma comptable attaché au sous-type de pièce n'existe pas ou n'est pas valide.
   Erreur_Modele_Ligne     EXCEPTION; -- Erreur de paramétrage de modèle de ligne
   Erreur_Type_Shema       EXCEPTION; -- Type shéma n'existe pas ou n'est pas valide
   -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4
   Erreur_maj_cpt          EXCEPTION; -- Le compte est modifie alors que le schema indique qu il n est pas modifiable.
   Erreur_val_masque_cpt   EXCEPTION; -- La valeur du masque du compte saisie n est pas conforme au parametrage
   -- Erreur lors du controle du masque, incoherence avec avec le parametrage de la saisie des ecr
   Erreur_ctl_masque_spec1 EXCEPTION;
   Erreur_ctl_masque_spec2 EXCEPTION;
   Erreur_ctl_masque_spec3 EXCEPTION;
   Erreur_ctl_masque_cpt   EXCEPTION;
   Erreur_ctl_masque_ordo  EXCEPTION;
   Erreur_ctl_masque_bud   EXCEPTION;
   Erreur_ctl_masque_ligbud EXCEPTION;
   Erreur_ctl_masque_ope   EXCEPTION;

   v_non SR_CODIF.cod_codif%TYPE;
   -- modif sgn 3.3-1.4

  v_flg_err915 NUMBER;  -- MODIF SGN ANOVSR420 : 3.3-1.5

  ----------------------------------------------------------------------------------
  -- Fonction Contrôle de paramétrage :
  ----------------------------------------------------------------------------------
  FUNCTION CTL_PARAM_PRISE_CHARGE (P_Nomchamp  IN RC_MODELE_LIGNE.VAL_SPEC1%TYPE,
               P_valmasque IN RC_MODELE_LIGNE.MAS_SPEC1%TYPE,
          P_retour    OUT Number
         ) Return Varchar2 IS

   v_res  RC_MODELE_LIGNE.MAS_SPEC1%TYPE;
   v_libl SR_CODIF.LIBL%Type;
   v_ret Number;
   v_codint_masque  SR_CODIF.IDE_CODIF%Type;
   ext_codint_error EXCEPTION;

        -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4
        ext_mask_error EXCEPTION;
        v_zone SR_MASQUE.cod_zone%TYPE;
        -- fin modif sgn : 3.3-1.4

  BEGIN

  -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : Recuperation du code masque de la zone
  --Ext_Codint('MASQUE',P_valmasque ,v_libl,v_codint_masque , v_ret);
  --IF v_retour != 1 THEN
  --       RAISE ext_codint_error;
  --END IF;
  --

  -- Recuperation du code zone en fonction du nomchamp
  SELECT DECODE (P_Nomchamp, 'MAS_CPT', 'Compte',
                             'MAS_TIERS', 'Tiers',
         'MAS_ORDO', 'Ordo',
          'MAS_BUD', 'Budget',
         'MAS_LIG_BUD', 'Lig_bud',
         'MAS_OPE', 'Ope',
                             'MAS_SPEC1', 'Spec',
                             'MAS_SPEC2', 'Spec',
                             'MAS_SPEC3', 'Spec',
                             'MAS_REF_PIECE', 'Refpiece',
                             NULL)
  INTO v_zone
  FROM dual;

  -- Verification du masque, et recuperation du code interne en fonction de la zone, on va chercher les valeurs
  --  autorisées pour la saisie des ecritures comptables. Permet ensuite de pouvoir controler les masques Chai et Chai*
  CTL_SAIS_MASQUE('U212_011F', v_zone, P_valmasque, v_codint_masque, v_ret);

  -- Si le controle est OK
  IF v_ret = 1 THEN
  -- fin modif sgn 3.3-1.4

    Select Decode (P_Nomchamp, 'MAS_CPT', Decode(v_codint_masque, 'CPT', P_ide_cpt,
                 '@CHB', P_ide_cpt_hb,
                 Null),
         'MAS_ORDO'   ,Decode(v_codint_masque, '@ORDO', P_ide_ordo,
                        Null),
          'MAS_BUD'    ,Decode(v_codint_masque, '@BUDG', P_cod_bud,
               Null),
         'MAS_LIG_BUD',Decode(v_codint_masque, '@LEXE',P_ide_lig_exec,
                  Null),
         'MAS_OPE'    ,Decode(v_codint_masque, '@OPE',P_ide_ope,
              Null),
                   Decode (v_codint_masque, '@PC', P_ide_poste,
              '@GEST'      , P_ide_gest ,
         '@ORDO'      , P_ide_ordo ,
         '@BUDG'      , P_cod_bud  ,
         '@LEXE'      , P_ide_lig_exec ,
         '@LPRV'      , P_ide_lig_prev ,
         '@PIEC'      , P_ide_piece ,
         '@OPE'       , P_ide_ope ,
         '@DEMI'      , to_char(P_dat_emis,'DD/MM/RRRR'),
         '@DREC'      , to_char(P_dat_reception,'DD/MM/RRRR'),
         '@PORI'      , P_ide_piece_init ,
         'CPT'        , P_ide_cpt ,
         '@ENG'       , P_Ide_Eng ,
         '@CHB'       , P_ide_cpt_hb ,
         Null) )
      into v_res From Dual;

  -- MODIF SGN 3.3-1.4 : ANOVSR420 ANOVSR421
  ELSE
    raise ext_mask_error;
  END IF;  -- if v_ret = 1 then
  -- fin modif sgn 3.3-1.4

  P_retour := 1;
  Return (v_res);

  EXCEPTION
  When ext_codint_error Then
      P_retour:=0;
   Return Null;
  -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4
  When ext_mask_error Then
      P_retour:=-1;
   Return Null;
  -- fin modif sgn 3.3-1.4
  END CTL_PARAM_PRISE_CHARGE;
  ----------------------------------------------------------------------------------
BEGIN

   -- MODIF SGN ANOVSR420 : 3.3-1.5 : initialisation de v_flg_err915 a 0 et p_ret a 1
   v_flg_err915 := 0;
   p_ret := 1;
   -- fin modif sgn 3.3-1.5

   BEGIN
   ----------------------------------------------------------------------------------------------------
   -- Modif MYI Le 04/04/2002 :
   --    1) Suppression des champs  cod_sens_bud, ide_modele_lig_bud ,  v_cod_sens et v_ide_modele_lig
   --    2) Ajout de ide_typ_poste et ide_ss_type dans le clause WHERE de l'ordre select
    SELECT ide_schema
    INTO v_ide_schema
    FROM pc_prise_charge
    WHERE cod_typ_piece = P_cod_typ_piece
      AND var_cpta      = P_var_cpta
   AND Ide_Typ_Poste = P_Ide_Typ_Poste    -- Type poste comptable
  -- AND ctl_date(
   AND Ide_SS_Type   = P_Ide_SS_Type;     -- Code du sous-type de pièce
   -- FIN MODIF MYI Le 04/04/2002
   ----------------------------------------------------------------------------------------------------
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
          RAISE  Erreur_Param_Shema; -- shéma comptable attaché au sous-type de pièce %1 n'existe pas ou n'est pas valide ( message N° 797) .
       WHEN OTHERS THEN
          RAISE;
   END;
   ------------------------------------------------------------------------------
   -- Rechercher le code type schéma
   ------------------------------------------------------------------------------
   BEGIN
    SELECT cod_typ_schema
 INTO v_cod_typ_schema
 FROM rc_schema_cpta
 WHERE var_cpta     = P_var_cpta
 AND   ide_jal      = P_ide_jal
 AND   ide_schema   = v_ide_schema;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
   RAISE Erreur_Type_Shema; -- Type shéma n'existe pas ou n'est pas valide ( Message N° 802 )
   WHEN OTHERS THEN
   RAISE;
   END;

   ------------------------------------------------------------------------------
   -- MODIF MYI Le 09/04/2002 : Fonction 11
   ------------------------------------------------------------------------------
    EXT_CODINT('TYPE_PIECE', P_cod_typ_piece, v_libl, v_cod_typ_piece, v_retour);
    IF v_retour != 1 THEN
       RAISE ext_codint_error;
    END IF;

    EXT_CODEXT('OUI_NON', 'O', v_libl, v_flg_cptab, v_retour);
    IF v_retour != 1 THEN
       RAISE ext_codext_error;
    END IF;

         -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4
         EXT_CODEXT('OUI_NON', 'N', v_libl, v_non, v_retour);
    IF v_retour != 1 THEN
       RAISE ext_codext_error;
    END IF;
         -- fin modif sgn 3.3-1.4

    ------------------------------------------------------------------------------
    -- Déterminer le type budget en fonction du sous type pièce
    ------------------------------------------------------------------------------
    EXT_TYPE_BUDGET(P_Cod_Typ_Piece => P_cod_typ_piece ,
        P_Ide_SS_Type   => P_Ide_SS_Type   ,
        P_Type_Budget   => v_codint_type_budget ,
        P_retour        => v_retour
       );
    If v_retour = 0 Then
       Raise donnee_absente;
    Elsif v_retour = -1 Then
       Raise ext_codint_error;
    Elsif v_retour = -2 Then
       Raise Erreur_Parametrage; -- Pour le sous-type de pièce budgétaire %1 l'ordonnance impute
           -- le budget en dépense ou le budget en recette  (message N° 795 )
    End if;
    ------------------------------------------------------------------------------
    -- extraction code interne de type budget
    ------------------------------------------------------------------------------
    IF v_codint_type_budget = 'R' Then
       EXT_CODEXT('TYPE_BUDGET', 'R', v_libl, v_cod_typ_bud, v_retour);
       IF v_retour != 1 THEN
          RAISE ext_codext_error;
       END IF;
    Elsif v_codint_type_budget = 'D' Then
       EXT_CODEXT('TYPE_BUDGET', 'D', v_libl, v_cod_typ_bud, v_retour);
       IF v_retour != 1 THEN
          RAISE ext_codext_error;
       END IF;
    End if;

	---------------------------------------------------------------------------------
	--
	---------------------------------------------------------------------------------
	--Début PGE 21/10/2008 ANO 301.

    FOR v_modele_ligne IN c_Rc_Modele_Ligne (v_ide_schema)  LOOP

		EXT_CODINT('TYPE_PEC',v_modele_ligne.Cod_Typ_Pec, v_libl ,v_Cod_Typ_Pec, v_retour);
		IF v_retour != 1 THEN
		    RAISE ext_codint_error;
		END IF;

		IF v_Cod_Typ_Pec IN ('B') THEN
		   v_nb_B := 1;
		END IF;

		IF v_Cod_Typ_Pec IN ('H') THEN
		   v_nb_H := 1;
		END IF;

	END LOOP;

	--Si ce n'est pas du budgétaire, alors p_mt_bud =0 sinon erreur de paramétrage
	IF v_nb_B = 0  and P_mt_bud <> 0 THEN
	   raise Erreur_Modele_Ligne;
	END IF;

	-- Si ce n'est pas de l'hors budget alors P_mt_bud = p_mt, sinon erreur de paramérage.
	IF v_nb_H = 0  and (P_mt_bud <> p_mt) THEN
	   raise Erreur_Modele_Ligne;
	END IF;
	--Fin PGE 21/10/2008 ANO 301.
   ------------------------------------------------------------------------------

    v_num_lig:=P_num_lig;
   ----------------------------------------------------------------------------
   --  Génération des lignes des écritures
   ----------------------------------------------------------------------------
    FOR v_modele_ligne IN c_Rc_Modele_Ligne (v_ide_schema)  LOOP
   ----------------------------------------------------------------------------------
   -- Teste cohérence code interne TYPE_PEC
   ----------------------------------------------------------------------------------
   EXT_CODINT('TYPE_PEC',v_modele_ligne.Cod_Typ_Pec, v_libl ,v_Cod_Typ_Pec, v_retour);
      IF v_retour != 1 THEN
          RAISE ext_codint_error;
      END IF;
   -----------------------------------------------------------------------------
   -- CONTROLE MASQUE DE PARAMETRAGE  :  MYI LE 11/04/2002
   -----------------------------------------------------------------------------
   -- Initialisation des variables
    v_Spec1    :=Null;
    v_Spec2    :=Null;
    v_Spec3    :=Null;
    v_cpt      :=Null;
    v_ordo     :=Null;
    v_bud      :=Null;
    v_lig_bud  :=Null;
    v_ope   :=Null;

         -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : on ne teste les masques que si on se trouve sur le bon modele de ligne
         IF v_Cod_Typ_Pec IN ('B', 'H') THEN
		 
		
   --------------------------------------------------------------------------------
   --1) Contrôle sur le masque de contrôle spec1
   --------------------------------------------------------------------------------
   IF v_modele_ligne.mas_spec1 Is not Null Then
     v_Spec1 :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_SPEC1' ,
                 P_valmasque => v_modele_ligne.mas_spec1,
                     P_retour    => v_retour
                     );
      -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                     IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                       Raise Erreur_ctl_masque_spec1;
                     --  If v_retour <> 1 Then
                     ELSIF v_retour <> 1 Then
                     -- fin modif sgn 3.3-1.4
          Raise ext_codint_error;
      End if;
      If v_Spec1 is null  And   v_modele_ligne.val_spec1 is not null Then
      v_Spec1 :=v_modele_ligne.val_spec1; -- si valeur par défaul <> null et la masque <> null
                    -- alors v_spec1 initialiser à  val_spec1
      End if;
   END IF;
   --------------------------------------------------------------------------------
   --2) Contrôle sur le masque de contrôle spec2
   --------------------------------------------------------------------------------
   IF v_modele_ligne.mas_spec2 Is not Null Then
   v_Spec2 :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_SPEC2',
                 P_valmasque => v_modele_ligne.mas_spec2 ,
                      P_retour    => v_retour
               );
   -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                  IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                    Raise Erreur_ctl_masque_spec2;
                    --  If v_retour <> 1 Then
                  ELSIF v_retour <> 1 Then
                    -- fin modif sgn 3.3-1.4
      Raise ext_codint_error;
   End if;

   If v_Spec2 is null  And   v_modele_ligne.val_spec2 is not null Then
      v_Spec2 :=v_modele_ligne.val_spec2; -- si valeur par défaul <> null et la masque <> null
                       -- alors v_spec2 initialiser à  val_spec2
   End if;
    END IF;
    --------------------------------------------------------------------------------
    --3) Contrôle sur le masque de contrôle spec3
    --------------------------------------------------------------------------------
    IF v_modele_ligne.mas_spec3 Is not Null Then
    v_Spec3 :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_SPEC3',
                 P_valmasque => v_modele_ligne.mas_spec3,
                       P_retour    => v_retour
               );
    -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                   IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                     Raise Erreur_ctl_masque_spec3;
                   --  If v_retour <> 1 Then
                   ELSIF v_retour <> 1 Then
                   -- fin modif sgn 3.3-1.4
       Raise ext_codint_error;
    End if;

    If v_Spec3 is null  And   v_modele_ligne.val_spec3 is not null Then
    v_Spec3 :=v_modele_ligne.val_spec3; -- si valeur par défaul <> null et la masque <> null
                     -- alors v_spec3 initialiser à  val_spec3
    End if;
    END IF;
    --------------------------------------------------------------------------------
    --4) Contrôle sur le masque du compte
    --------------------------------------------------------------------------------
    IF v_modele_ligne.mas_cpt Is not Null Then
--CBI-20060706-D
-- Lors du passage en V4 le code posait pb et retournait blanc au lieu d'une valeur
/*
    v_cpt:=substr(CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_CPT',
                        P_valmasque => v_modele_ligne.mas_cpt,
               P_retour    => v_retour
                     ),1,length(v_cpt));
*/

    v_cpt:=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_CPT',
                        P_valmasque => v_modele_ligne.mas_cpt,
               P_retour    => v_retour
                     );

--CBI-20060706-F
    -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                   IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                     Raise Erreur_ctl_masque_cpt;
                   --  If v_retour <> 1 Then
                   ELSIF v_retour <> 1 Then
                     -- fin modif sgn 3.3-1.4
       Raise ext_codint_error;
    End if;

                   -- Si valeur par défaut = null et le masque <> null
    -- alors v_cpt initialisé à  val_cpt
                   If v_cpt is null  And   v_modele_ligne.val_cpt is not null THEN -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : And P_ide_cpt is null Then

                     -- Si une valeur est renseignée et que la modification est possible
                     IF p_ide_cpt IS NOT NULL AND v_modele_ligne.flg_maj_cpt != v_non THEN
                       v_cpt := p_ide_cpt;

                     -- sinon on applique le schema
                     ELSE
         v_cpt :=v_modele_ligne.val_cpt;
                       -- MODIF SGN ANOVSR420 : 3.3-1.5 : en cas de modification du au parametrage p_ret = 2 => on pourra prevenir le user
                       IF v_cpt != p_ide_cpt THEN
			 --FBT - 03/11/2009 - ANO 394 - on ne doit pas générer d'incohérence CAD / CGE
			 -- on passe du message 915 informatif au 914 bloquant
                         --v_flg_err915 := 1;
			 RAISE Erreur_val_masque_cpt;
                      END IF;
                       -- fin modif sgn 3.3-1.5
                     END IF;
                   END IF;

                   -- FBT - le 29/07/2007 - ANO 108
				   IF v_cpt is not null THEN
                     v_retour := CTL_VAL_MASQUE(v_modele_ligne.mas_cpt, v_cpt, SYSDATE);
                     IF v_retour != 1 THEN
                       RAISE Erreur_val_masque_cpt;
                     END IF;
				   END IF;

                   -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : Gestion de la coche flg_maj_cpt
                   -- dans le cas ou elle est a non, on ne doit pas pouvoir modifier le compte
                   IF v_modele_ligne.flg_maj_cpt = v_non THEN
                     IF v_cpt != v_modele_ligne.val_cpt THEN
                       Raise Erreur_maj_cpt;
                     END IF;
                   END IF;
                   -- fin modif sgn

     END IF;
     --------------------------------------------------------------------------------
     -- 5) Contrôle sur le masque de l'ordonnateur
     -------------------------------------------------------------------------------
   IF v_modele_ligne.mas_ordo Is not Null Then
--CBI-20060706-D
-- Lors du passage en V4 le code posait pb et retournait blanc au lieu d'une valeur
/*
      v_ordo :=substr(CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_ORDO',
                         P_valmasque => v_modele_ligne.mas_ordo ,
                P_retour    => v_retour
                        ),1,length(v_ordo));

*/
      v_ordo :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_ORDO',
                         P_valmasque => v_modele_ligne.mas_ordo ,
                P_retour    => v_retour
                        );

--CBI-20060706-F

      -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                     IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                       Raise Erreur_ctl_masque_ordo;
                     --  If v_retour <> 1 Then
                     ELSIF v_retour <> 1 Then
                     -- fin modif sgn 3.3-1.4
          Raise ext_codint_error;
      End if;

      If v_ordo is null  And   v_modele_ligne.val_ordo is not null and  P_ide_ordo is null Then
      v_ordo :=v_modele_ligne.val_ordo;    -- si valeur par défaul <> null et la masque <> null
                      -- alors v_ordo initialiser à  val_ordo
      End if;
   END IF;
   --------------------------------------------------------------------------------
   --6) Contrôle sur le masque budget
   --------------------------------------------------------------------------------
   IF v_modele_ligne.mas_bud Is not Null Then
--CBI-20060706-D
-- Lors du passage en V4 le code posait pb et retournait blanc au lieu d'une valeur
/*

      v_bud :=substr(CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_BUD',
                        P_valmasque => v_modele_ligne.mas_bud ,
               P_retour    => v_retour
                        ),1,length(v_bud));
*/


      v_bud :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_BUD',
                        P_valmasque => v_modele_ligne.mas_bud ,
               P_retour    => v_retour
                        );
--CBI-20060706-F
      -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                     IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                       Raise Erreur_ctl_masque_bud;
                     --  If v_retour <> 1 Then
                     ELSIF v_retour <> 1 Then
                     -- fin modif sgn 3.3-1.4

          Raise ext_codint_error;
      End if;

      If v_bud is null  And   v_modele_ligne.val_bud is not null and  P_cod_bud is null Then
      v_bud :=v_modele_ligne.val_bud;    -- si valeur par défaul <> null et la masque <> null
                    -- alors v_bud initialiser à  val_bud
      End if;
   END IF;
   --------------------------------------------------------------------------------
   --7) Contrôle sur le masque ligne budget
   --------------------------------------------------------------------------------
   IF v_modele_ligne.mas_bud Is not Null Then
      v_lig_bud :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_LIG_BUD',
                     P_valmasque => v_modele_ligne.mas_lig_bud ,
               P_retour    => v_retour
              );

      -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                     IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                       Raise Erreur_ctl_masque_ligbud;
                     --  If v_retour <> 1 Then
                     ELSIF v_retour <> 1 Then
                     -- fin modif sgn 3.3-1.4
          Raise ext_codint_error;
      End if;

                     If v_lig_bud  is null  And   v_modele_ligne.val_lig_bud is not null and  P_ide_lig_exec is null Then
      v_lig_bud :=v_modele_ligne.val_lig_bud ;     -- si valeur par défaul <> null et la masque <> null
                              -- alors v_bud initialiser à  val_bud
      End if;
   END IF;
   --------------------------------------------------------------------------------
   --8) Contrôle sur le masque de l'opération
   --------------------------------------------------------------------------------
   IF v_modele_ligne.mas_ope Is not Null Then
--CBI-20060706-D
-- Lors du passage en V4 le code posait pb et retournait blanc au lieu d'une valeur
/*
      v_ope :=substr(CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_OPE',
                        P_valmasque => v_modele_ligne.mas_ope,
               P_retour    => v_retour
                                  ),1,length(v_ope));
*/

      v_ope :=CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_OPE',
                        P_valmasque => v_modele_ligne.mas_ope,
               P_retour    => v_retour
                                  );


--CBI-20060706-F

      -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4 : traitement plus fin des erreurs
                     IF v_retour = -1 THEN -- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
                       Raise Erreur_ctl_masque_ope;
                     --  If v_retour <> 1 Then
                     ELSIF v_retour <> 1 Then
                     -- fin modif sgn 3.3-1.4
           Raise ext_codint_error;
      End if;

                        If v_ope  is null  And   v_modele_ligne.val_ope is not null and  P_ide_ope is null Then
       v_ope :=v_modele_ligne.val_ope ;     -- si valeur par défaul <> null et la masque <> null
                       -- alors v_ope initialiser à  val_ope
    End if;
   END IF;

        END IF;  -- if v_cod_typ_pec in ( 'h', 'b' ) THEN -- fin modif sgn 3.3-1.4



  -----------------------------------------------------------------------------
  -- Recherche le sens de la ligne d'écriture
  -----------------------------------------------------------------------------
  EXT_CODINT('SENS',v_modele_ligne.val_sens , v_libl ,v_codint_cod_sens, v_retour);
  IF v_retour != 1 THEN
           RAISE ext_codint_error;
      END IF;


  -----------------------------------------------------------------------------
  --valeur du champ FLG_ANNUL_DCST
  -----------------------------------------------------------------------------
  -- FBT - 01/08/2007 - Evol DI44-01-2007
  EXT_CODEXT ( 'OUI_NON', 'O', v_codif_libl, v_codif_oui, v_temp );
  EXT_CODEXT ( 'OUI_NON', 'N', v_codif_libl, v_codif_non, v_temp );
  --recherche du flag annulation droits constatés sur le compte budgétaire
  SELECT FLG_ANNUL_DCST INTO v_FLG_ANNUL_DROIT
  FROM FN_COMPTE
  WHERE VAR_CPTA=P_var_cpta
  AND IDE_CPT=DECODE(v_cpt,null,P_ide_cpt,v_cpt);
  --recherche du flag annulation de créance sur le modele de ligne budgétaire du schéma
  SELECT FLG_ANNUL_CREANCE INTO v_FLG_ANNUL_CREANCE
  FROM RC_MODELE_LIGNE
  WHERE VAR_CPTA=P_var_cpta
  AND IDE_JAL=P_ide_jal
  AND IDE_SCHEMA=v_ide_schema
  AND RANG_LIG=v_modele_ligne.rang_lig
  AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
  AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008
  --test valeur du champ
  IF v_FLG_ANNUL_DROIT=v_codif_oui AND v_FLG_ANNUL_CREANCE=v_codif_oui THEN
      v_FLG_ANNUL_DCST:=v_codif_oui;
  ELSE
   v_FLG_ANNUL_DCST:=v_codif_non;
  END IF;

   -------------------------------------------------------------------------------------
   --1 Test si Si le shéma attaché au sous-type de pièce pour le modèle de ligne dont le
   --  type de ligne = 'B'
   -------------------------------------------------------------------------------------
   If v_Cod_Typ_Pec = 'B' And   nvl(P_mt_bud,0) != 0  And Not v_Insert_Budget THEN  -- génération des lignes budgétaires
         BEGIN
      --recherche du signe
   IF  (( v_cod_typ_piece IN ( 'OR', 'AD' ) AND (v_codint_cod_sens = 'C' )) OR
              ( v_cod_typ_piece IN ( 'AR', 'OD' ) AND (v_codint_cod_sens = 'D' ))) THEN
              v_mt_ligne     := P_mt_bud;
          v_mt_ligne_dev := P_mt_bud_dev;
        ELSE
               v_mt_ligne    := P_mt_bud * (-1);
       v_mt_ligne_dev := P_mt_bud_dev * (-1);
            END IF;

   IF Increment = TRUE THEN
          v_num_lig := v_num_lig + 1;
        END IF;

   --insertion dans la table FC_LIGNE
   INSERT INTO fc_ligne ( ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr, ide_lig
            , var_cpta, ide_cpt, cod_sens, var_bud, ide_lig_exec, ide_ope, ide_ordo
            , cod_bud, cod_typ_bud, mt,spec1 ,spec2 ,spec3, ide_schema, cod_typ_schema, ide_modele_lig
            , dat_ecr, dat_cre, uti_cre, dat_maj, uti_maj, terminal
       , Ide_devise ,mt_dev , val_taux, FLG_ANNUL_DCST )
        VALUES ( P_ide_poste, P_ide_gest, P_ide_jal, v_flg_cptab, P_ide_ecr, v_num_lig,P_var_cpta,
                  DECODE(v_cpt,null,P_ide_cpt,v_cpt),
                  v_modele_ligne.val_sens, P_var_bud, DECODE(P_ide_lig_exec,null,v_lig_bud,P_ide_lig_exec), decode(P_ide_ope,null,v_ope,P_ide_ope),
           decode(P_ide_ordo,null,v_ordo,P_ide_ordo), decode(P_cod_bud,null,v_bud,P_cod_bud), v_cod_typ_bud, v_mt_ligne,v_spec1 , v_spec2 , v_spec3 , v_ide_schema,
           v_cod_typ_schema, v_modele_ligne.ide_modele_lig, P_dat_ecr, v_dat_cre, v_uti_cre, v_dat_maj,
           v_uti_maj, v_terminal ,P_ide_devise ,v_mt_ligne_dev , P_val_taux,v_FLG_ANNUL_DCST);

      v_Insert_Budget := TRUE;
         Increment := TRUE;
         P_num_lig_s := v_num_lig;

            -- p_ret = 2 uniquement si la modif du param est inserée en base
            IF v_flg_err915 = 1 THEN
              p_ret := 2;
            END IF;

       EXCEPTION
          WHEN OTHERS THEN
             RAISE;
       END;
     ELSIF  v_Cod_Typ_Pec = 'B' And   nvl(P_mt_bud,0) != 0  And v_Insert_Budget THEN
      RAISE Erreur_Modele_Ligne;
  ELSIF  v_Cod_Typ_Pec = 'H' And   nvl(P_mt_bud,0) != nvl(P_mt,0)  And Not v_Insert_Hors_Budget THEN

    BEGIN

       ------------------------------------------------------------------------
    -- Recherche le montant
    ------------------------------------------------------------------------
    IF  (( v_cod_typ_piece IN ('OR','AD' ) AND (v_codint_cod_sens = 'C' )) OR
           ( v_cod_typ_piece IN  ('AR','OD' ) AND (v_codint_cod_sens = 'D' ))) THEN
             v_mt_ligne   := ( P_mt - P_mt_bud);
    -- MODIF MYI Le 15/05/2002 : Fonction 48
    v_mt_ligne_dev  := ( P_mt_dev - P_mt_bud_dev );
    -- FIN MODIF MYI
       ELSE
             v_mt_ligne   := ( P_mt     - P_mt_bud ) * (-1);
    -- MODIF MYI Le 15/05/2002 : Fonction 48
    v_mt_ligne_dev  := ( P_mt_dev - P_mt_bud_dev ) * (-1);
    -- FIN MODIF MYI
       END IF;
       ------------------------------------------------------------------------
    IF Increment = TRUE THEN
          v_num_lig := v_num_lig + 1;
       END IF;



       INSERT INTO fc_ligne ( ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr, ide_lig
       , var_cpta, ide_cpt, cod_sens, ide_ope, ide_ordo
       , cod_bud, cod_typ_bud, mt ,spec1 ,spec2 ,spec3, ide_schema, cod_typ_schema, ide_modele_lig
       , dat_ecr, dat_cre, uti_cre, dat_maj, uti_maj, terminal
     -- MODIF MYI Le 15/05/2002 : Fonction 48
    , Ide_devise ,mt_dev , val_taux,FLG_ANNUL_DCST  )
   -- FIN MODIF MYI
       VALUES ( P_ide_poste, P_ide_gest, P_ide_jal, v_flg_cptab, P_ide_ecr, v_num_lig,
       P_var_cpta,
            DECODE(v_cpt,null,P_ide_cpt_hb,v_cpt), -- MODIF SGN ANOVSR420 : 3.3-1.5 : DECODE(P_ide_cpt_hb,null,v_cpt,P_ide_cpt_hb),
            v_modele_ligne.val_sens, decode(P_ide_ope,null,v_ope,P_ide_ope),
       decode(P_ide_ordo,null,v_ordo,P_ide_ordo), decode(P_cod_bud,null,v_bud,P_cod_bud), v_cod_typ_bud, v_mt_ligne ,v_spec1 , v_spec2 , v_spec3 , v_ide_schema,
       v_cod_typ_schema, v_modele_ligne.ide_modele_lig, P_dat_ecr, v_dat_cre, v_uti_cre, v_dat_maj,
       v_uti_maj, v_terminal ,P_ide_devise ,v_mt_ligne_dev, P_val_taux,v_FLG_ANNUL_DCST); -- MODIF MYI Fonction 48 ( Ajout notion de devise )
          v_Insert_Hors_Budget := TRUE;
    Increment := TRUE;
       P_num_lig_s := v_num_lig;

            -- MODIF SGN ANOVSR420 : 3.3-1.5 : On ne p_ret = 2 uniquement si la modif du param est inserée en base
            IF v_flg_err915 = 1 THEN
              p_ret := 2;
            END IF;
            -- fin modif sgn 3.3-1.5

       EXCEPTION
       WHEN OTHERS THEN
           RAISE;
       END;
       ELSIF  v_Cod_Typ_Pec = 'H' And   nvl(P_mt_bud,0) != nvl(P_mt,0)  And v_Insert_Hors_Budget Then
       RAISE Erreur_Modele_Ligne;
    END IF;
  End LOOP;
   -----------------------------------------------------------
   -- MODIF MYI le 18/06/2002 : Fonction 11
   -----------------------------------------------------------
      /*If ( Not v_Insert_Budget And nvl(P_mt_bud,0) != 0 ) OR
       ( Not v_Insert_Hors_Budget And   nvl(P_mt_bud,0) != nvl(P_mt,0) )
    Then
       RAISE Erreur_Modele_Ligne;
    End if;*/

      -- MODIF SGN ANOVSR420 : 3.3-1.5 : p_ret est initialise au debut :  p_ret := 1;

 EXCEPTION
   WHEN donnee_absente      THEN
      P_ret := 0;
   WHEN ext_codext_error    THEN
      P_ret := -1;
   WHEN ext_codint_error    THEN
      P_ret := -2;
   WHEN Erreur_Parametrage  THEN
      P_ret := -3;
   WHEN Erreur_Param_Shema  THEN
      P_ret := -4;
   WHEN Erreur_Modele_Ligne THEN
      P_ret :=-5;
   WHEN Erreur_Type_Shema   THEN
      P_ret :=-6;
   -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.4
   WHEN Erreur_maj_cpt THEN
        P_ret := -8;
   WHEN Erreur_val_masque_cpt THEN
        P_ret := -9;
   WHEN Erreur_ctl_masque_spec1 THEN
      P_ret := -10;
   WHEN Erreur_ctl_masque_spec2 THEN
      P_ret := -11;
   WHEN Erreur_ctl_masque_spec3 THEN
      P_ret := -12;
   WHEN Erreur_ctl_masque_cpt THEN
      P_ret := -13;
   WHEN Erreur_ctl_masque_ordo THEN
      P_ret := -14;
   WHEN Erreur_ctl_masque_bud THEN
      P_ret := -15;
   WHEN Erreur_ctl_masque_ligbud THEN
      P_ret := -16;
   WHEN Erreur_ctl_masque_ope THEN
      P_ret := -17;
   -- fin modif sgn 3.3-1.4
   WHEN OTHERS       THEN
      RAISE;
      P_ret := -7;
END MAJ_ins_ligne_bud_Cons;

/

CREATE OR REPLACE PROCEDURE maj_ins_ligne_tiers (
   p_cod_typ_piece         IN       fc_ecriture.cod_typ_piece%TYPE,
   p_ide_ss_type           IN       fb_piece.ide_ss_type%TYPE,
   p_ide_typ_poste         IN       rm_poste.ide_typ_poste%TYPE,
   p_ide_poste             IN       fb_piece.ide_poste%TYPE,
   p_ide_piece             IN       fb_piece.ide_piece%TYPE,
   p_ide_piece_init        IN       fb_piece.ide_piece_init%TYPE,
   p_ide_gest              IN       fb_piece.ide_gest%TYPE,
   p_ide_ordo              IN       fb_piece.ide_ordo%TYPE,
   p_cod_bud               IN       fb_piece.cod_bud%TYPE,
   p_var_cpta              IN       fc_ligne.var_cpta%TYPE,
   p_dat_jc                IN       DATE,
   p_ide_ecr               IN       fc_ecriture.ide_ecr%TYPE,
   p_ide_jal               IN       fc_ligne.ide_jal%TYPE,
   p_num_lig               IN       fc_ligne.ide_lig%TYPE,
   p_dat_cad               IN       fb_piece.dat_cad%TYPE,
   p_dat_ecr               IN       fc_ecriture.dat_ecr%TYPE,
   p_var_tiers             IN       fb_ligne_tiers_piece.var_tiers%TYPE,
   p_ide_tiers             IN       fb_ligne_tiers_piece.ide_tiers%TYPE,
   p_ide_cpt               IN       fb_ligne_tiers_piece.ide_cpt%TYPE,
   p_nom_tiers             IN       fb_ligne_tiers_piece.nom%TYPE,
   p_ide_ope               IN       fb_piece.ide_ope%TYPE,
   p_prenom_tiers          IN       fb_ligne_tiers_piece.prenom%TYPE,
   p_mt_retenu_oppo        IN       fb_ligne_tiers_piece.mtt_retenue_oppo%TYPE,
   p_mt                    IN       fb_ligne_tiers_piece.mt%TYPE,
   p_mt_dev                IN       fb_ligne_tiers_piece.mt_dev%TYPE,
   p_ide_devise            IN       fc_ligne.ide_devise%TYPE,
   p_val_taux              IN       fc_ligne.val_taux%TYPE,
   p_ret                   OUT      NUMBER,
   p_ide_ref_piece         IN       fb_ligne_tiers_piece.ide_ref_piece%TYPE DEFAULT NULL,
   p_ide_devise_ref        IN       fc_ligne.ide_devise%TYPE,
   p_ide_plan_aux          IN       fb_ligne_tiers_piece.ide_plan_aux%TYPE DEFAULT NULL,
   p_ide_cpt_aux           IN       fb_ligne_tiers_piece.ide_cpt_aux%TYPE DEFAULT NULL,
   p_num_lig_ligne_tiers   IN       fb_ligne_tiers_piece.num_lig%TYPE DEFAULT NULL,
   p_ide_spec1             IN       fb_ligne_tiers_piece.spec1%TYPE DEFAULT NULL,
   p_cod_ref_piece_s       OUT      fc_reglement.cod_ref_piece%TYPE,
   p_num_lig_s             OUT      fc_ligne.ide_lig%TYPE
)
IS
/*
-- ----------------------------------------------------------------------------------------------------------
-- systeme       : ASTER
-- sous-systeme  : CAD
-- Nom           : Maj_Ins_Ligne_Tiers.sql
-- ---------------------------------------------------------------------------
-- Auteur         : -- (SEMA GROUP)
-- Date creation  : -/--/1999
-- ---------------------------------------------------------------------------
-- Role          : Mise a jour des donnees ligne tiers piece suite a un visa
-- Parametres    :
--                 1- P_cod_typ_piece  : Code type pièce
--                 2- P_ide_ss_type    :
--            3- P_ide_typ_poste  :
--                 4- P_ide_poste      :
--                 5- P_ide_piece   :
--                 6- P_ide_gest   :
--                 7- P_ide_ordo   :
--                 8- P_cod_bud   :
--                 9- P_var_cpta   :
--                 10- P_dat_jc   :
--                 11- P_ide_ecr   :
--                 12- P_num_lig   :
--                 13- P_ide_jal   :
--                 14- P_ide_cpt   :
--                 15- P_ide_cpt_hb  :
--                 16- P_dat_ecr   :
--                 17- P_var_bud   :
--                 18- P_ide_lig_exec  :
--                 19- P_ide_ope   :
--                 20- P_mt    :
--                 21- P_mt_bud   :
--
--                 30- P_ide_plan_aux           :
--                 31- P_ide_cpt_aux            :
--                 32- P_num_lig_ligne_tiers    :
--                 33- P_ide_spec1              :
-- Valeurs retournees :
--                     P_ret :  < 0 => erreur
--                              1   => OK
--                              2   => OK mais modification a cause du parametrage
--        P_num_lig_s
--  -----------------------------------------------------------------------------------------------------
--  Fonction         |Date     |Initiales |Commentaires
--  -----------------------------------------------------------------------------------------------------
-- @(#) Maj_Ins_Ligne_Tiers.sql 1.0-1.0      |--/--/1999 : --- - Creation
-- @(#) Maj_Ins_Ligne_Tiers.sql 2.1-2.0      |29/08/2001| SGN | Gestion correct de l insertion et la mise dans fc_ref_piece lors d un visa
-- @(#) MAJ_ins_ligne_bud.sql   3.0-3.0      |04/04/2002 |MYI| Fonction 11 : Paramétrage des sous-types de pièce budgétaire
-- @(#) MAJ_ins_ligne_bud.sql   3.0-3.1      |13/06/2002 |MYI| Fonction 48 : Gestion des opérations en devises
-- @(#) MAJ_ins_ligne_bud.sql   3.0-3.2      |13/06/2002 |MYI| Fonction 11 : Fiche Question Fonction 11 Réponse N° 1
-- @(#) MAJ_ins_ligne_bud.sql   3.0-3.3      |20/06/2002 |MYI| Fonction 48 : Fiche Question Fonction 48 Réponse N° 4
-- @(#) MAJ_ins_ligne_bud.sql   3.0-3.3       |26/06/2002 |MYI| Fonction 48 : Modif suite aux  réponses  ( Fiche question Fonction 48 question N° 3 )
-- @(#) MAJ_ins_ligne_bud.sql   3.0e-1.5      |20/03/2003 |LGD| ANO VA V3 282 : Erreur affectation sens du montant FC_REF_PIECE
-- @(#) MAJ_ins_ligne_bud.sql   3.1-1.7      |19/06/2003 |SGN| ANOVA304 : lors de la mise a jour de la reference piece le cod_typ_piece mis a jour depend du cod_typ_piece passé en parametre ex: OD => OD alors que AD => OD
-- @(#) MAJ_ins_ligne_Tiers.sql 3.3-1.8    |04/09/2003 |SGN| ANOVA420 ANOVA421 : La valeur du compte saisie doit tenir compte du parametrage du modele de ligne
-- @(#) MAJ_ins_ligne_Tiers.sql 3.3-1.9       |14/10/2003 |SGN| Prise en compte du cas p_ret = 2 (cpt de la ligne generee != du compte saisi)
-- @(#) MAJ_ins_ligne_Tiers.sql 3.5-1.10      |25/03/2004 |LGD| ANOGAR600 - Pb de MAJ de l'abondement suite à l'annulatiob
-- @(#) MAJ_ins_ligne_Tiers.sql 3.4-1.11      |26/10/2004 |CBI| EN cas de retenue sur mandats avec un tiers et un tiers opposant, 3 lignes sont créées dans
--                                                              FC_LIGNE : 1 pour le tiers et deux pour le tiers opposant. Modifier le test qui conditionne
--                                                 l'écriture dans FC_LIGNE pour ne créer qu'un enreg pour l'opposant. Pour un tiers normal
--                                                 MT_RETENU_OPPO est égal à 0.
-- @(#) MAJ_ins_ligne_Tiers.sql 3.4-1.12  |08/03/2005 |MPS| Modification concernant le montant en devise de l'opposition dans FC_LIGNE -- Ano DI44-106 --
-- @(#) MAJ_ins_ligne_Tiers.sql 3.5-1.13  |31/03/2005 |CBI| Ajout de 3 paramètres, d'un curseur, de l'alimentation de IDE_pLAN_AUX et IDE_CPT_AUX dans FC_LIGNE et
--                                                              modification de la déterminatation de COD_REF_PIECE en cas de création de pièce
-- @(#) MAJ_ins_ligne_Tiers.sql 3.5-1.14  |13/06/2005 |CBI| Ajout de la gestion de @SPEC1 pour le masque SPEC1
-- @(#) MAJ_ins_ligne_Tiers.sql 3.5-1.16  |23/06/2005 |RDU| Ajout du test sur le "type" de transaction : création de pièce ou abondement
--                                                         pour anomalie V35-3E-DJP01 pour gérer le cas d'un mandat avec plusieurs fois le même
--                                                         couple code tiers, numéro de compte (dans ce cas on doit créer une nouvelle pièce à
--                                                         chaque fois et non abonder la pièce existante)
-- @(#) MAJ_ins_ligne_Tiers.sql 3.5-1.17  |11/07/2005 |CBI| Anomalie V35-3E-DJP05
--                                                         Suite à la correction de l'anomalie précédente (V35-3E-DJP01) on a ajouté ce un test.
--                                                         Ce test est erronné dans le cas d'une annulation de mandat car dans ce cas v_cod_ref_piece_ext
--                                                         n'est pas valorisée et le résultat du test est faux, on a donc ajouté NVL sur le test.
-- @(#) MAJ_ins_ligne_Tiers.sql 3.5A-1.18    |11/07/2005 |CBI| FA0043 Ajout d'un nouveau paramètre en sortie afin de retourner la valeur de COD_REF_PIECE qui a pu être déterminée dans le cas d'un mandat.
-- @(#) MAJ_ins_ligne_Tiers.sql v4124     |20/02/2007 |FBT| mantis 043 - DIT44-177 modification du calcul de mt_dev, annulation du *-1
-- @(#) MAJ_ins_ligne_Tiers.sql v4124     |06/04/2007 |MCE| mantis 035 - SEN_V41_FA0006 Modification  du compte valorisé si opoosant-tiers
-- @(#) MAJ_ins_ligne_Tiers.sql v4200     |23/05/2007 |FBT| evol 03-2007 - alimentation du champ flg_annul_dcst
-- @(#) MAJ_ins_ligne_Tiers.sql v4201   |11/09/2007 |FBT| ANO 85- Gestion des signe de mt_dev
-- @(#) MAJ_ins_ligne_Tiers.sql v4210   |28/06/2007 |FBT| Evol 01-2007 - Gestion des annulations d'AD
-- @(#) MAJ_ins_ligne_Tiers.sql v4210   |27/07/2007 |FBT| ANO 051- Gestion des masques de compte des modeles de ligne tiers opposants
-- @(#) MAJ_ins_ligne_Tiers.sql v4210   |18/09/2007 |FBT| ANO 094- Annulation des ordonnances avec tiers opposant et abondement/création de pièce
-- @(#) MAJ_ins_ligne_Tiers.sql v4211   |18/09/2007 |FBT| ANO 136- Gestion des incohérences de création de piece avec un schéma en abondement
-- @(#) MAJ_ins_ligne_Tiers.sql v4211   |16/11/2007 |FBT| ANO 148- Conditionnement des création/modification de piece en fonction du RC_MODELE_LIGNE de type S/C/A
-- @(#) MAJ_ins_ligne_Tiers.sql v4211   |16/11/2007 |FBT| ANO 151- Controle de cohérence entre le comptre (FLG_JUSTIF) et le modele de ligne (COD_REF_PIECE)
-- @(#) MAJ_ins_ligne_Tiers.sql v4211   |29/11/2007 |FBT| ANO 161- Modification des curseurs de rapatriement des pièces
-- @(#) MAJ_ins_ligne_Tiers.sql v4250   |27/03/2008 |PGE| EVOL_2007_010 : Valoriser FC_REF_PIECE.dat_der_mvt avec la date de journée comptable de comptabilisation de l'écriture
-- @(#) MAJ_ins_ligne_Tiers.sql v4260   |16/05/2008 |PGE| evol_DI44_2008_014 Controle sur les dates de validité de RC_MODELE_LIGNE.
--                                                                           Valorisation de FB_LIGNE_TIERS_PIECE.IDE_REF_PIECE en corrélation avec FC_REF_PIECE.
-- @(#) MAJ_ins_ligne_Tiers.sql v4260  |03/10/2008 |FBT| ANO 281- Modification du calcul de l'ide_ref_piece en cas de création de piece
-- @(#) MAJ_ins_ligne_Tiers.sql v4281  |01/07/2009 |FBT| ANO 378- le cod_ref_piece etait modifié à tort
--  -----------------------------------------------------------------------------------------------------
*/
   v_flg_annul_creance        CHAR (1);
   v_flg_annul_droit          CHAR (1);
   v_flg_annul_dcst           CHAR (1);
   v_libl                     sr_codif.libl%TYPE;
   v_retour                   NUMBER                                     := 0;
   v_cod_typ_piece            sr_codif.ide_codif%TYPE;
   v_cod_typ_piece_ext        fb_piece.cod_typ_piece%TYPE;
   v_uti_cre                  fc_ligne.uti_cre%TYPE        := GLOBAL.cod_util;
   v_dat_cre                  fc_ligne.dat_cre%TYPE                := SYSDATE;
   v_uti_maj                  fc_ligne.uti_maj%TYPE        := GLOBAL.cod_util;
   v_dat_maj                  fc_ligne.dat_maj%TYPE                := SYSDATE;
   v_terminal                 fc_ligne.terminal%TYPE       := GLOBAL.terminal;
   v_ide_schema               fc_ligne.ide_schema%TYPE;
   v_cod_typ_schema           fc_ligne.cod_typ_schema%TYPE;
   v_var_tiers                fc_ref_piece.var_tiers%TYPE;
   v_ide_tiers                fc_ref_piece.ide_tiers%TYPE;
   v_mt_ligne                 fc_ligne.mt%TYPE;
   v_ide_ref_piece            fc_ligne.ide_ref_piece%TYPE;
   v_codint_cod_sens          sr_codif.ide_codif%TYPE;
   v_codext_cod_sens          fc_ligne.cod_sens%TYPE;
   v_flg_justif               fn_compte.flg_justif%TYPE;
   v_flg_justif_tiers         fn_compte.flg_justif_tiers%TYPE;
   v_ide_piece                fb_piece.ide_piece%TYPE;
   v_ide_piece_conc           fb_piece.ide_piece%TYPE;
   v_mt_db                    fc_ref_piece.mt_db%TYPE;
   v_mt_cr                    fc_ref_piece.mt_cr%TYPE;
   v_cod_ref_piece            fc_ref_piece.cod_ref_piece%TYPE;
   v_flg_solde                fc_ref_piece.flg_solde%TYPE;
   v_flg_cptab                fc_ref_piece.flg_cptab%TYPE;
   v_solde                    fc_ref_piece.flg_cptab%TYPE;
   v_ref_piece_exist          VARCHAR2 (1);
   v_mt_ligne_dev             fc_ligne.mt_dev%TYPE;
   v_mt_retenu_oppo           fb_ligne_tiers_piece.mtt_retenue_oppo%TYPE;
   v_mt_retenu_oppo_dev       fb_ligne_tiers_piece.mtt_retenue_oppo%TYPE;
   v_nbr_piece                NUMBER;
   v_codif_non             VARCHAR2(200);
   v_codif_libl            VARCHAR2(200);
   v_codif_ad             VARCHAR2(200);
   v_temp                     NUMBER := 0;
   v_abo_crea      rc_modele_ligne.COD_REF_PIECE%TYPE;
   v_codif_abo       VARCHAR2(200);
   v_codif_lib        VARCHAR2(200);
   v_codif_pectiers      VARCHAR2(200);
   v_tempo          NUMBER :=0;

   ----------------------------------------------------------------------
   -- Crétaion curseur sur RC_MODELE_LIGNE
   ----------------------------------------------------------------------
   CURSOR c_rc_modele_ligne (p_ide_shema IN rc_modele_ligne.ide_schema%TYPE)
   IS
      SELECT *
        FROM rc_modele_ligne
       WHERE var_cpta = p_var_cpta
         AND ide_jal = p_ide_jal
         AND ide_schema = p_ide_shema
   AND (((p_mt_retenu_oppo IS NOT NULL AND p_mt_retenu_oppo<>0) AND cod_typ_pec='O') OR ((p_mt_retenu_oppo IS NULL OR p_mt_retenu_oppo=0) AND cod_typ_pec='I'))
   AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
   AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008

   ----------------------------------------------------
   -- MODIF MYI Le 15/05/2002 : Ajout montant en devise
   ----------------------------------------------------
   CURSOR c_ref_piece (
      w_cod_typ_piece      fc_ref_piece.cod_typ_piece%TYPE,
      w_flg_justif_tiers   fn_compte.flg_justif_tiers%TYPE
   )
   IS
      SELECT ide_ref_piece, cod_ref_piece, mt_db, mt_cr, mt_dev,dat_der_mvt, dat_maj, uti_maj, terminal, ROWID
      FROM   fc_ref_piece
      WHERE  ide_poste = p_ide_poste
      AND   ide_ordo = p_ide_ordo
      AND   cod_bud = p_cod_bud
      AND   ide_gest = p_ide_gest
      AND   cod_typ_piece = w_cod_typ_piece
      AND   ide_piece = v_ide_piece
      -- AND   NVL (ide_devise, p_ide_devise_ref) = NVL (p_ide_devise, p_ide_devise_ref) FBT le 29/11/2007 Ano 161
      AND   ( ( var_tiers = p_var_tiers AND w_flg_justif_tiers = v_flg_cptab ) OR (var_tiers IS NULL) )
      AND   ( ( ide_tiers = p_ide_tiers AND w_flg_justif_tiers = v_flg_cptab ) OR (ide_tiers IS NULL) )
      FOR UPDATE OF mt_db,
                    mt_dev
                    NOWAIT;

  /* recuperation des info ref piece a partir de ide_ref_piece les donnees recuperes
  doivent etre identiques a celle recupere dans c_ref_piece de maniere a pouvoir
  utiliser un rowtype identique */
   CURSOR c_ref_piece2 (w_flg_justif_tiers fn_compte.flg_justif_tiers%TYPE)
   IS
      SELECT ide_ref_piece, cod_ref_piece, mt_db, mt_cr, mt_dev, dat_der_mvt, dat_maj, uti_maj, terminal, ROWID
      FROM   fc_ref_piece
      WHERE  ide_poste = p_ide_poste
      AND   ide_ref_piece = p_ide_ref_piece
      -- AND   NVL (ide_devise, p_ide_devise_ref) = NVL (p_ide_devise, p_ide_devise_ref) FBT le 29/11/2007 Ano 161
      AND   ( ( var_tiers = p_var_tiers AND w_flg_justif_tiers = v_flg_cptab ) OR (var_tiers IS NULL) )
      AND   ( ( ide_tiers = p_ide_tiers AND w_flg_justif_tiers = v_flg_cptab ) OR (ide_tiers IS NULL) )
      FOR UPDATE OF mt_db,
          mt_dev
                    NOWAIT;

   -- CBI-20050331-D - LOLF
   v_cod_ref_piece_ext        rc_modele_ligne.cod_ref_piece%TYPE;
   v_cod_ref_piece_calcule    rc_modele_ligne.cod_ref_piece%TYPE;
   v_cod_typ_pec_ext          rc_modele_ligne.cod_typ_pec%TYPE;

   /* Curseur pour obtenir COD_REF_PIECE  */
   CURSOR c_cod_ref_piece
   IS
      SELECT rml.cod_ref_piece
        FROM pc_prise_charge ppc, rc_modele_ligne rml
       WHERE ppc.cod_typ_piece = p_cod_typ_piece
         AND ppc.var_cpta = p_var_cpta
         AND ppc.ide_typ_poste = p_ide_typ_poste
         AND ppc.ide_ss_type = p_ide_ss_type
         AND rml.var_cpta = ppc.var_cpta
         AND rml.ide_jal = ppc.ide_jal
         AND rml.ide_schema = ppc.ide_schema
         AND rml.cod_typ_pec = v_cod_typ_pec_ext
         AND CTL_DATE(rml.dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
         AND CTL_DATE(sysdate,rml.dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008

   p_cod_ref_piece            c_cod_ref_piece%ROWTYPE;
-- CBI-20050331-F - LOLF
   r_ref_piece                c_ref_piece%ROWTYPE;
   -- Déclaration des variables
   v_spec1                    fc_ligne.spec1%TYPE;
   v_spec2                    fc_ligne.spec2%TYPE;
   v_spec3                    fc_ligne.spec3%TYPE;
   v_cpt                      fc_ligne.ide_cpt%TYPE;
   v_ordo                     fc_ligne.ide_ordo%TYPE;
   v_tiers                    fc_ligne.ide_tiers%TYPE;
   v_bud                      fc_ligne.cod_bud%TYPE;
   v_num_lig                  fc_ligne.ide_lig%TYPE;
   v_oui_non                  sr_codif.ide_codif%TYPE;
   v_cod_typ_pec              rc_modele_ligne.cod_typ_pec%TYPE;
   v_insert_tiers             BOOLEAN                                 := FALSE;
   v_insert_opposition        BOOLEAN                                 := FALSE;
   INCREMENT                  BOOLEAN                                 := FALSE;
   -- Exception
   erreur_parametrage         EXCEPTION;
   donnee_absente             EXCEPTION;
   ext_codext_error           EXCEPTION;
   ext_codint_error           EXCEPTION;
   erreur_param_shema         EXCEPTION;
   erreur_modele_ligne        EXCEPTION;
   erreur_type_shema          EXCEPTION;
   erreur_maj_cpt             EXCEPTION;
   erreur_val_masque_cpt      EXCEPTION;
   erreur_ctl_masque_spec1    EXCEPTION;
   erreur_ctl_masque_spec2    EXCEPTION;
   erreur_ctl_masque_spec3    EXCEPTION;
   erreur_ctl_masque_cpt      EXCEPTION;
   erreur_ctl_masque_ordo     EXCEPTION;
   erreur_ctl_masque_bud      EXCEPTION;
   erreur_ctl_masque_ligbud   EXCEPTION;
   erreur_ctl_masque_ope      EXCEPTION;
   erreur_abo_sans_piece   EXCEPTION;
   v_non                      sr_codif.cod_codif%TYPE;
   -- modif sgn 3.3-1.8
   v_flg_err915               NUMBER;         -- MODIF SGN ANOVSR420 : 3.3-1.9

-- DEBUT / PGE - 07/04/2008, EVOLUTION EVO_2007_010
   inversion_sens_solde  EXCEPTION;
-- FIN / PGE - 07/04/2008, EVOLUTION

----------------------------------------------------------------------------------
-- Modif MYI Le 15/04/2002 : fonction 11
-- Fonction Contrôle de paramétrage
----------------------------------------------------------------------------------
   FUNCTION ctl_param_prise_charge (
      p_nomchamp    IN       rc_modele_ligne.val_spec1%TYPE,
      p_valmasque   IN       rc_modele_ligne.mas_spec1%TYPE,
      p_retour      OUT      NUMBER
   )
      RETURN VARCHAR2
   IS
      v_res              rc_modele_ligne.mas_spec1%TYPE;
      v_libl             sr_codif.libl%TYPE;
      v_ret              NUMBER;
      v_codint_masque    sr_codif.ide_codif%TYPE;
      ext_codint_error   EXCEPTION;
      -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8
      ext_mask_error     EXCEPTION;
      v_zone             sr_masque.cod_zone%TYPE;
   -- fin modif sgn : 3.3-1.8
   BEGIN
           -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8 : Recuperation du code masque de la zone
      --Ext_Codint('MASQUE',P_valmasque ,v_libl,v_codint_masque , v_ret);
      --IF v_retour != 1 THEN
      --    RAISE ext_codint_error;
      --END IF;
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                    'Début de CTL_PARAM_PRISE_CHARGE avec P_Nomchamp = '
                 || p_nomchamp
                 || ' et P_valmasque = '
                 || p_valmasque
                );

      -- Recuperation du code zone en fonction du nomchamp
      SELECT DECODE (p_nomchamp,
                     'MAS_CPT', 'Compte',
                     'MAS_TIERS', 'Tiers',
                     'MAS_ORDO', 'Ordo',
                     'MAS_BUD', 'Budget',
                     'MAS_LIG_BUD', 'Lig_bud',
                     'MAS_OPE', 'Ope',
                     'MAS_SPEC1', 'Spec',
                     'MAS_SPEC2', 'Spec',
                     'MAS_SPEC3', 'Spec',
                     'MAS_REF_PIECE', 'Refpiece',
                     NULL
                    )
        INTO v_zone
        FROM DUAL;

      aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'v_zone = ' || v_zone);
      -- Verification du masque, et recuperation du code interne en fonction de la zone, on va chercher les valeurs
      --  autorisées pour la saisie des ecritures comptables. Permet ensuite de pouvoir controler les masques Chai et Chai*
      aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'Appel de CTL_SAIS_MASQUE');
      ctl_sais_masque ('U212_011F',
                       v_zone,
                       p_valmasque,
                       v_codint_masque,
                       v_ret
                      );
      aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'Après CTL_SAIS_MASQUE, v_codint_masque = ' || v_codint_masque || ' et v_ret = ' || v_ret);

      -- Si le controle est OK
      IF v_ret = 1
      THEN
         -- fin modif sgn 3.3-1.8
         SELECT DECODE (p_nomchamp,
                        'MAS_CPT', DECODE (v_codint_masque,
                                           '@CTRS', p_ide_cpt,
                                           NULL
                                          ),
                        'MAS_ORDO', DECODE (v_codint_masque,
                                            '@ORDO', p_ide_ordo,
                                            NULL
                                           ),
                        'MAS_BUD', DECODE (v_codint_masque,
                                           '@BUDG', p_cod_bud,
                                           NULL
                                          ),

-- CBI-20050613-D - ano V35-3E-DJP02
                        'MAS_SPEC1', DECODE (v_codint_masque,
                                             '@SP1', p_ide_spec1,
                                             NULL
                                            ),
-- CBI-20050613-F - ano V35-3E-DJP02
                        DECODE (v_codint_masque,
                                '@PC', p_ide_poste,
                                '@GEST', p_ide_gest,
                                '@BUDG', p_cod_bud,
                                '@ORDO', p_ide_ordo,
                                '@PIEC', p_ide_piece,
                                '@OPE', p_ide_ope,
                                '@PORI', p_ide_piece_init,
                                '@CTRS', p_ide_cpt,
                                '@TRS', p_ide_tiers,
                                '@NTRS', p_nom_tiers,
                                '@PTRS', p_prenom_tiers,
                                NULL
                               )
                       )
           INTO v_res
           FROM DUAL;

         aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'résultat DECODE : v_res = ' || v_res);
      -- MODIF SGN 3.3-1.8 : ANOVSR420 ANOVSR421
      ELSE
         aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'v_ret <> 1 ==> RAISE EXT_MASK_ERROR');
         RAISE ext_mask_error;
      END IF;                                             -- if v_ret = 1 then

      -- fin modif sgn 3.3-1.8
      p_retour := 1;
      aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'FIN de CTL_PARAM_PRISE_CHARGE. P_Retour = 1' );
      RETURN (v_res);
   EXCEPTION
      WHEN ext_codint_error
      THEN
         aff_trace
                ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION EXT_CODINT_ERROR ==> p_retour = 0 et RETURN NULL'
                );
         p_retour := 0;
         RETURN NULL;
      -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8
      WHEN ext_mask_error
      THEN
         aff_trace
                 ('MAJ_INS_LIGNE_TIERS',
                  0,
                  NULL,
                  'EXCEPTION EXT_MASK_ERROR ==> p_retour = -1 et RETURN NULL'
                 );
         p_retour := -1;
         RETURN NULL;
   -- fin modif sgn 3.3-1.8
   END ctl_param_prise_charge;
BEGIN
   GLOBAL.ini_niveau_trace (20);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'DEBUT MAJ_INS_LIGNE_TIERS');
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_cod_typ_piece : ' || p_cod_typ_piece);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_ss_type : ' || p_ide_ss_type);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_typ_poste : ' || p_ide_typ_poste);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_poste : ' || p_ide_poste);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_piece : ' || p_ide_piece);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_piece_init : ' || p_ide_piece_init);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_gest : ' || p_ide_gest);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_ordo : ' || p_ide_ordo);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_cod_bud : ' || p_cod_bud);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_var_cpta : ' || p_var_cpta);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_dat_jc : ' || p_dat_jc);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_ecr : ' || p_ide_ecr);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_jal : ' || p_ide_jal);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_num_lig : ' || p_num_lig);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_dat_cad : ' || p_dat_cad);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_dat_ecr : ' || p_dat_ecr);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_var_tiers : ' || p_var_tiers);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_tiers : ' || p_ide_tiers);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_cpt : ' || p_ide_cpt);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_Nom_tiers : ' || p_nom_tiers);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_ope : ' || p_ide_ope);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_Prenom_tiers : ' || p_prenom_tiers);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_mt_retenu_oppo : ' || p_mt_retenu_oppo);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_mt : ' || p_mt);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_devise : ' || p_ide_devise);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_val_taux : ' || p_val_taux);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_ref_piece : ' || p_ide_ref_piece);
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'P_ide_devise_ref : ' || p_ide_devise_ref);
   -- MODIF SGN ANOVSR420 : 3.3-1.9 : initialisation de v_flg_err915 a 0 et p_ret a 1
   v_flg_err915 := 0;
   p_ret := 1;
   -- fin modif sgn 3.3-1.9
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'Recherche du schéma dans PC_PRISE_CHARGE');

   BEGIN
      --Recherche du schéma
      SELECT ide_schema
      INTO v_ide_schema
      FROM pc_prise_charge
      WHERE cod_typ_piece = p_cod_typ_piece
      AND var_cpta = p_var_cpta
      AND ide_ss_type = p_ide_ss_type
      AND ide_typ_poste = p_ide_typ_poste;

   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'EXCEPTION NO_DATA_FOUND_1 ==> RAISE ERREUR_PARAM_SCHEMA');
         RAISE erreur_param_shema;
      WHEN OTHERS
      THEN
         aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'EXCEPTION OTHERS_1 ==> RAISE, erreur oracle : ' || SUBSTR (SQLERRM, 1, 150));
         RAISE;
   END;

   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'Recherche du code type schéma dans RC_SCHEMA_CPTA');
   BEGIN
      -- Rechercher le code type schéma
      SELECT cod_typ_schema
        INTO v_cod_typ_schema
        FROM rc_schema_cpta
       WHERE var_cpta = p_var_cpta
         AND ide_jal = p_ide_jal
         AND ide_schema = v_ide_schema;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'EXCEPTION NO_DATA_FOUND_2 ==> RAISE ERREUR_TYPE_SCHEMA');
         RAISE erreur_type_shema;
             -- Type shéma n'existe pas ou n'est pas valide ( Message N° 802 )
      WHEN OTHERS
      THEN
         aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'EXCEPTION OTHERS_2 ==> RAISE, erreur oracle : ' || SUBSTR (SQLERRM, 1, 150));
         RAISE;
   END;

------------------------------------------------------------------------------
-- MODIF MYI Le 09/04/2002 : Fonction 11
------------------------------------------------------------------------------
   ext_codint ('TYPE_PIECE',
               p_cod_typ_piece,
               v_libl,
               v_cod_typ_piece,
               v_retour
              );

   IF v_retour != 1
   THEN
      RAISE ext_codint_error;
   END IF;

   ext_codext ('OUI_NON', 'O', v_libl, v_flg_cptab, v_retour);

   IF v_retour != 1
   THEN
      RAISE ext_codext_error;
   END IF;

   ext_codext ('OUI_NON', 'N', v_libl, v_flg_solde, v_retour);

   IF v_retour != 1
   THEN
      RAISE ext_codext_error;
   END IF;

   -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8
   ext_codext ('OUI_NON', 'N', v_libl, v_non, v_retour);

   IF v_retour != 1
   THEN
      RAISE ext_codext_error;
   END IF;

   -- fin modif sgn 3.3-1.8

   ----------------------------------------------------------------------------
--  Génération des lignes des écritures
----------------------------------------------------------------------------
   v_num_lig := p_num_lig;
   aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'Ouverture du curseur C_RC_MODELE_LIGNE' );

   FOR v_modele_ligne IN c_rc_modele_ligne (v_ide_schema)
   LOOP
   ----------------------------------------------------------------------------------
-- Teste cohérence code interne TYPE_PEC
----------------------------------------------------------------------------------
      aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'v_modele_ligne.Cod_Typ_Pec : ' || v_modele_ligne.cod_typ_pec);
      ext_codint ('TYPE_PEC',
                  v_modele_ligne.cod_typ_pec,
                  v_libl,
                  v_cod_typ_pec,
                  v_retour
                 );

      IF v_retour != 1
      THEN
         RAISE ext_codint_error;
      END IF;

   -----------------------------------------------------------------------------
-- CONTROLE MASQUE DE PARAMETRAGE  : MYI LE 15/04/2002
-----------------------------------------------------------------------------
-- Initialisation des variables
      v_spec1 := NULL;
      v_spec2 := NULL;
      v_spec3 := NULL;
      v_cpt := NULL;
      v_bud := NULL;
      v_ordo := NULL;
      -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8 : on ne teste les masques que si on se trouve sur le bon modele de ligne
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'v_Cod_Typ_Pec : ' || v_cod_typ_pec
                );
      IF v_cod_typ_pec IN ('I', 'O')
      THEN
         -- fin modif sgn
         aff_trace ('MAJ_INS_LIGNE_TIERS',
                    0,
                    NULL,
                    'v_Cod_Typ_Pec = I ou = O'
                   );
--------------------------------------------------------------------------------
--1) Contrôle sur le masque de contrôle spec1
--------------------------------------------------------------------------------
         aff_trace ('MAJ_INS_LIGNE_TIERS',
                    0,
                    NULL,
                    'v_modele_ligne.mas_spec1 : ' || v_modele_ligne.mas_spec1
                   );

         IF v_modele_ligne.mas_spec1 IS NOT NULL
         THEN
            aff_trace
               ('MAJ_INS_LIGNE_TIERS',
                0,
                NULL,
                'Appel de CTL_PARAM_PRISE_CHARGE pour P_Nomchamp = MAS_SPEC1'
               );
            v_spec1 :=
               ctl_param_prise_charge
                                     (p_nomchamp       => 'MAS_SPEC1',
                                      p_valmasque      => v_modele_ligne.mas_spec1,
                                      p_retour         => v_retour
                                     );

            -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8 : traitement plus fin des erreurs
            IF v_retour = -1
            THEN
-- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Retour de CTL_PARAM_PRISE_CHARGE = -1 ==> RAISE ERREUR_CTL_MASQUE_SPEC1'
                  );
               RAISE erreur_ctl_masque_spec1;
            --  If v_retour <> 1 Then
            ELSIF v_retour <> 1
            THEN
               -- fin modif sgn 3.3-1.8
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Retour de CTL_PARAM_PRISE_CHARGE <> 1 ==> RAISE EXT_CODINT_ERROR'
                  );
               RAISE ext_codint_error;
            END IF;

            aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL,
                       'v_Spec1 = ' || v_spec1);
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                          'v_modele_ligne.val_spec1 = '
                       || v_modele_ligne.val_spec1
                      );

            IF v_spec1 IS NULL AND v_modele_ligne.val_spec1 IS NOT NULL
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'v_Spec1 :=v_modele_ligne.val_spec1'
                         );
               v_spec1 := v_modele_ligne.val_spec1;
                          -- si valeur par défaul <> null et la masque <> null
            -- alors v_spec1 initialiser à  val_spec1
            END IF;
         END IF;

--------------------------------------------------------------------------------
--2) Contrôle sur le masque de contrôle spec2
--------------------------------------------------------------------------------
         aff_trace ('MAJ_INS_LIGNE_TIERS',
                    0,
                    NULL,
                    'v_modele_ligne.mas_spec2 : ' || v_modele_ligne.mas_spec2
                   );

         IF v_modele_ligne.mas_spec2 IS NOT NULL
         THEN
            aff_trace
               ('MAJ_INS_LIGNE_TIERS',
                0,
                NULL,
                'Appel de CTL_PARAM_PRISE_CHARGE pour P_Nomchamp = MAS_SPEC2'
               );
            v_spec2 :=
               ctl_param_prise_charge
                                     (p_nomchamp       => 'MAS_SPEC2',
                                      p_valmasque      => v_modele_ligne.mas_spec2,
                                      p_retour         => v_retour
                                     );

            -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8 : traitement plus fin des erreurs
            IF v_retour = -1
            THEN
-- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Retour de CTL_PARAM_PRISE_CHARGE = -1 ==> RAISE ERREUR_CTL_MASQUE_SPEC2'
                  );
               RAISE erreur_ctl_masque_spec2;
            --  If v_retour <> 1 Then
            ELSIF v_retour <> 1
            THEN
               -- fin modif sgn 3.3-1.8
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Retour de CTL_PARAM_PRISE_CHARGE <> 1 ==> RAISE EXT_CODINT_ERROR'
                  );
               RAISE ext_codint_error;
            END IF;

            aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL,
                       'v_Spec2 = ' || v_spec2);
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                          'v_modele_ligne.val_spec2 = '
                       || v_modele_ligne.val_spec2
                      );

            IF v_spec2 IS NULL AND v_modele_ligne.val_spec2 IS NOT NULL
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'v_Spec2 :=v_modele_ligne.val_spec2'
                         );
               v_spec2 := v_modele_ligne.val_spec2;
                          -- si valeur par défaul <> null et la masque <> null
            -- alors v_spec2 initialiser à  val_spec2
            END IF;
         END IF;

--------------------------------------------------------------------------------
--3) Contrôle sur le masque de contrôle spec3
--------------------------------------------------------------------------------
         aff_trace ('MAJ_INS_LIGNE_TIERS',
                    0,
                    NULL,
                    'v_modele_ligne.mas_spec3 : ' || v_modele_ligne.mas_spec3
                   );

         IF v_modele_ligne.mas_spec3 IS NOT NULL
         THEN
            aff_trace
               ('MAJ_INS_LIGNE_TIERS',
                0,
                NULL,
                'Appel de CTL_PARAM_PRISE_CHARGE pour P_Nomchamp = MAS_SPEC3'
               );
            v_spec3 :=
               ctl_param_prise_charge
                                     (p_nomchamp       => 'MAS_SPEC3',
                                      p_valmasque      => v_modele_ligne.mas_spec3,
                                      p_retour         => v_retour
                                     );

            -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8 : traitement plus fin des erreurs
            IF v_retour = -1
            THEN
-- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Retour de CTL_PARAM_PRISE_CHARGE = -1 ==> RAISE ERREUR_CTL_MASQUE_SPEC3'
                  );
               RAISE erreur_ctl_masque_spec3;
            --  If v_retour <> 1 Then
            ELSIF v_retour <> 1
            THEN
               -- fin modif sgn 3.3-1.8
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Retour de CTL_PARAM_PRISE_CHARGE <> 1 ==> RAISE EXT_CODINT_ERROR'
                  );
               RAISE ext_codint_error;
            END IF;

            aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL,
                       'v_Spec3 = ' || v_spec3);
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                          'v_modele_ligne.val_spec3 = '
                       || v_modele_ligne.val_spec3
                      );

            IF v_spec3 IS NULL AND v_modele_ligne.val_spec3 IS NOT NULL
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'v_Spec3 :=v_modele_ligne.val_spec3'
                         );
               v_spec3 := v_modele_ligne.val_spec3;
                          -- si valeur par défaul <> null et la masque <> null
            -- alors v_spec3 initialiser à  val_spec3
            END IF;
         END IF;

--------------------------------------------------------------------------------
--4) Contrôle sur le masque du compte
--------------------------------------------------------------------------------
         aff_trace ('MAJ_INS_LIGNE_TIERS',
                    0,
                    NULL,
                    'v_modele_ligne.mas_cpt : ' || v_modele_ligne.mas_cpt
                   );

         IF v_modele_ligne.mas_cpt IS NOT NULL
         THEN
--CBI-20060706-D
-- Lors du passage en V4 la valeur retournée par v_cpt est nulle
/*
     v_cpt:=SUBSTR(CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_CPT',
                         P_valmasque => v_modele_ligne.mas_cpt,
                P_retour    => v_retour
                           ),1,LENGTH(v_cpt));
*/
            aff_trace
                 ('MAJ_INS_LIGNE_TIERS',
                  0,
                  NULL,
                  'Appel de CTL_PARAM_PRISE_CHARGE pour P_Nomchamp = MAS_CPT'
                 );
            v_cpt :=
               ctl_param_prise_charge (p_nomchamp       => 'MAS_CPT',
                                       p_valmasque      => v_modele_ligne.mas_cpt,
                                       p_retour         => v_retour
                                      );

--CBI-20060706-F
    -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8 : traitement plus fin des erreurs
            IF v_retour = -1
            THEN
-- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Retour de CTL_PARAM_PRISE_CHARGE = -1 ==> RAISE ERREUR_CTL_MASQUE_CPT'
                  );
               RAISE erreur_ctl_masque_cpt;
            --  If v_retour <> 1 Then
            ELSIF v_retour <> 1
            THEN
               -- fin modif sgn 3.3-1.8
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Retour de CTL_PARAM_PRISE_CHARGE <> 1 ==> RAISE EXT_CODINT_ERROR'
                  );
               RAISE ext_codint_error;
            END IF;

                           -- Si valeur par défaut = null et le masque <> null
            -- alors v_cpt initialisé à  val_cpt
            aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'v_cpt = ' || v_cpt);
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'v_modele_ligne.val_cpt = ' || v_modele_ligne.val_cpt
                      );

            IF v_cpt IS NULL AND v_modele_ligne.val_cpt IS NOT NULL
            THEN
       -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8 : And P_ide_cpt is null Then
               -- Si une valeur est renseignée et que la modification est possible
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                             'v_modele_ligne.flg_maj_cpt = '
                          || v_modele_ligne.flg_maj_cpt
                         );

               IF p_ide_cpt IS NOT NULL
                  AND v_modele_ligne.flg_maj_cpt != v_non
               THEN
                  aff_trace ('MAJ_INS_LIGNE_TIERS',
                             0,
                             NULL,
                             'v_cpt := p_ide_cpt'
                            );
                  v_cpt := p_ide_cpt;
               -- sinon on applique le schema
               ELSE
                  aff_trace ('MAJ_INS_LIGNE_TIERS',
                             0,
                             NULL,
                             'v_cpt :=v_modele_ligne.val_cpt'
                            );
                  v_cpt := v_modele_ligne.val_cpt;
                          -- si valeur par défaul <> null et la masque <> null
                          -- alors v_cpt initialiser à  val_cpt

                  --DEBUT - FBT - 27/07/2007 - ANO 051 -----------------------------------------------------------
      EXT_CODEXT ( 'OUI_NON', 'N', v_codif_lib, v_codif_non, v_tempo );
      --test de cohérence entre le masque imposé par le modèle et la saisie
      IF v_modele_ligne.flg_maj_cpt=v_codif_non THEN
      IF v_cpt != p_ide_cpt
                  THEN
                     aff_trace ('MAJ_INS_LIGNE_TIERS',0,NULL,'Comme v_cpt != p_ide_cpt, v_flg_err915 := 1');
                     --v_flg_err915 := 1;
      RAISE erreur_val_masque_cpt;
                  END IF;
         END IF;
      --DEBUT - FBT - 27/07/2007 - ANO 051 -----------------------------------------------------------

               END IF;
            END IF;

            -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8 : il faut
            -- verifier la valeur saisie en fonction du masque paramétré
            --ELSE
            aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                      'Appel de CTL_VAL_MASQUE pour v_modele_ligne.mas_cpt = '
                   || v_modele_ligne.mas_cpt
                  );
            v_retour :=
                       ctl_val_masque (v_modele_ligne.mas_cpt, v_cpt, SYSDATE);

            IF v_retour != 1
            THEN
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Retour de CTL_VAL_MASQUE <> 1 ==> RAISE ERREUR_VAL_MASQUE_CPT'
                  );
               RAISE erreur_val_masque_cpt;
            END IF;

            -- fin modif sgn 3.3-1.8
            --End if;

            -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8 : Gestion de la coche flg_maj_cpt
            -- dans le cas ou elle est a non, on ne doit pas pouvoir modifier le compte
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                          'v_modele_ligne.flg_maj_cpt = '
                       || v_modele_ligne.flg_maj_cpt
                      );

            IF v_modele_ligne.flg_maj_cpt = v_non
            THEN
               IF v_cpt != v_modele_ligne.val_cpt
               THEN
                  aff_trace
                     ('MAJ_INS_LIGNE_TIERS',
                      0,
                      NULL,
                      'Comme v_cpt != v_modele_ligne.val_cpt ==> RAISE ERREUR_MAJ_CPT'
                     );
                  RAISE erreur_maj_cpt;
               END IF;
            END IF;
         -- fin modif sgn
         END IF;

--------------------------------------------------------------------------------
-- 5) Contrôle sur le masque de l'ordonnateur
-------------------------------------------------------------------------------
         aff_trace ('MAJ_INS_LIGNE_TIERS',
                    0,
                    NULL,
                    'v_modele_ligne.mas_ordo : ' || v_modele_ligne.mas_ordo
                   );

         IF v_modele_ligne.mas_ordo IS NOT NULL
         THEN
--CBI-20060706-D
-- Lors du passage en V4 la valeur retournée par v_cpt est nulle
/*
       v_ordo :=SUBSTR(CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_ORDO',
                          P_valmasque => v_modele_ligne.mas_ordo,
                 P_retour    => v_retour
                         ),1,LENGTH(v_ordo));
*/
            aff_trace
                ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'Appel de CTL_PARAM_PRISE_CHARGE pour P_Nomchamp = MAS_ORDO'
                );
            v_ordo :=
               ctl_param_prise_charge (p_nomchamp       => 'MAS_ORDO',
                                       p_valmasque      => v_modele_ligne.mas_ordo,
                                       p_retour         => v_retour
                                      );

--CBI-20060706-F
       -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8 : traitement plus fin des erreurs
            IF v_retour = -1
            THEN
-- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Retour de CTL_PARAM_PRISE_CHARGE = -1 ==> RAISE ERREUR_CTL_MASQUE_ORDO'
                  );
               RAISE erreur_ctl_masque_ordo;
            --  If v_retour <> 1 Then
            ELSIF v_retour <> 1
            THEN
               -- fin modif sgn 3.3-1.8
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Retour de CTL_PARAM_PRISE_CHARGE <> 1 ==> RAISE EXT_CODINT_ERROR'
                  );
               RAISE ext_codint_error;
            END IF;

            aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'v_ordo = ' || v_ordo);
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'v_modele_ligne.val_ordo = ' || v_modele_ligne.val_ordo
                      );

            IF     v_ordo IS NULL
               AND v_modele_ligne.val_ordo IS NOT NULL
               AND p_ide_ordo IS NULL
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'v_ordo :=v_modele_ligne.val_ordo'
                         );
               v_ordo := v_modele_ligne.val_ordo;
                          -- si valeur par défaul <> null et la masque <> null
            -- alors v_ordo initialiser à  val_ordo
            END IF;
         END IF;

-------------------------------------------------------------------------------
--6) Contrôle sur le masque budget
-------------------------------------------------------------------------------
         aff_trace ('MAJ_INS_LIGNE_TIERS',
                    0,
                    NULL,
                    'v_modele_ligne.mas_bud : ' || v_modele_ligne.mas_bud
                   );

         IF v_modele_ligne.mas_bud IS NOT NULL
         THEN
--CBI-20060706-D
-- Lors du passage en V4 la valeur retournée par v_cpt est nulle
/*
       v_bud :=SUBSTR(CTL_PARAM_PRISE_CHARGE (P_Nomchamp  => 'MAS_BUD',
                         P_valmasque => v_modele_ligne.mas_bud,
                P_retour    => v_retour
                         ),1,LENGTH(v_bud));
*/
            aff_trace
                 ('MAJ_INS_LIGNE_TIERS',
                  0,
                  NULL,
                  'Appel de CTL_PARAM_PRISE_CHARGE pour P_Nomchamp = MAS_BUD'
                 );
            v_bud :=
               ctl_param_prise_charge (p_nomchamp       => 'MAS_BUD',
                                       p_valmasque      => v_modele_ligne.mas_bud,
                                       p_retour         => v_retour
                                      );

--CBI-20060706-F

            -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8 : traitement plus fin des erreurs
            IF v_retour = -1
            THEN
-- Le masque n est pas autorisé pour le champ lors de la saisie d ecriture, le parametrage n'est pas cohérent
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Retour de CTL_PARAM_PRISE_CHARGE = -1 ==> RAISE ERREUR_CTL_MASQUE_BUD'
                  );
               RAISE erreur_ctl_masque_bud;
            --  If v_retour <> 1 Then
            ELSIF v_retour <> 1
            THEN
               -- fin modif sgn 3.3-1.8
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Retour de CTL_PARAM_PRISE_CHARGE <> 1 ==> RAISE EXT_CODINT_ERROR'
                  );
               RAISE ext_codint_error;
            END IF;

            aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'v_bud = ' || v_bud);
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'v_modele_ligne.val_bud = ' || v_modele_ligne.val_bud
                      );

            IF     v_bud IS NULL
               AND v_modele_ligne.val_bud IS NOT NULL
               AND p_cod_bud IS NULL
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'v_bud :=v_modele_ligne.val_bud'
                         );
               v_bud := v_modele_ligne.val_bud;
                          -- si valeur par défaul <> null et la masque <> null
            -- alors v_bud initialiser à  val_bud
            END IF;
         END IF;
      END IF;
             -- if v_cod_typ_pec in ( 'i', 'o' ) THEN -- fin modif sgn 3.3-1.8

------------------------------------------------------------------------------------------------
-- FIN CONTROLE MASQUE DE PARAMETRAGE
-------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Recherche le sens de la ligne d'écriture
-----------------------------------------------------------------------------
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'v_modele_ligne.val_sens = ' || v_modele_ligne.val_sens
                );
      ext_codint ('SENS',
                  v_modele_ligne.val_sens,
                  v_libl,
                  v_codint_cod_sens,
                  v_retour
                 );

      IF v_retour != 1
      THEN
         RAISE ext_codint_error;
      END IF;

      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'v_codint_cod_sens = ' || v_codint_cod_sens
                );

-----------------------------------------------------------------------------
--valeur du champ FLG_ANNUL_DCST
-----------------------------------------------------------------------------
--recherche du flag annulation droits constatés sur le compte budgétaire
      SELECT flg_annul_dcst
        INTO v_flg_annul_droit
        FROM fn_compte
       WHERE var_cpta = p_var_cpta
         AND ide_cpt = DECODE (v_cpt, NULL, p_ide_cpt, v_cpt);

      --recherche du flag annulation de créance sur le modele de ligne budgétaire du schéma
      SELECT flg_annul_creance
        INTO v_flg_annul_creance
        FROM rc_modele_ligne
       WHERE var_cpta = p_var_cpta
         AND ide_jal = p_ide_jal
         AND ide_schema = v_ide_schema
         AND cod_typ_pec = 'I'
         AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
         AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008

      --test valeur du champ
      IF v_flg_annul_droit = 'O' AND v_flg_annul_creance = 'O'
      THEN
         v_flg_annul_dcst := 'O';
      ELSE
         v_flg_annul_dcst := 'N';
      END IF;

  -------------------------------------------------------------------------------------
  --1 Test si Si le shéma attaché au sous-type de pièce pour le modèle de ligne dont le
  --  type de ligne = 'I'
  -------------------------------------------------------------------------------------
-- 20042610-CBI-D
--  IF v_Cod_Typ_Pec = 'I' AND   NOT v_Insert_Tiers THEN
      IF     v_cod_typ_pec = 'I'
         AND NOT v_insert_tiers
         AND NVL (p_mt_retenu_oppo, 0) = 0
      THEN                                -- génération des lignes budgétaires
-- 20042610-CBI-F
         BEGIN
            aff_trace
               ('MAJ_INS_LIGNE_TIERS',
                0,
                NULL,
                'Dans le cas : v_Cod_Typ_Pec = ''I'' AND   NOT v_Insert_Tiers AND NVL(P_mt_retenu_oppo,0) = 0'
               );
   ----------------------------------------------------------------------
-- Recherche le montant
----------------------------------------------------------------------
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'v_cod_typ_piece = ' || v_cod_typ_piece
                      );
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'v_modele_ligne.val_sens = ' || v_modele_ligne.val_sens
                      );

            IF (   (v_cod_typ_piece = 'OR' AND v_modele_ligne.val_sens = 'D'
                   )
                OR (v_cod_typ_piece = 'AR' AND v_modele_ligne.val_sens = 'C'
                   )
                OR (v_cod_typ_piece = 'OD' AND v_modele_ligne.val_sens = 'C'
                   )
                OR (v_cod_typ_piece = 'AD' AND v_modele_ligne.val_sens = 'D'
                   )
               )
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'Cas 1');
               v_mt_ligne := p_mt - NVL (p_mt_retenu_oppo, 0);
               v_mt_ligne_dev :=p_mt_dev - NVL (p_mt_retenu_oppo / NVL (p_val_taux, 1), 0);
            ELSE
               aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'Cas 2');
               v_mt_ligne := (p_mt - NVL (p_mt_retenu_oppo, 0)) * (-1);
               --FBT-20070220-correction ano mantis023 - DIT44177-------------------------------------------
               v_mt_ligne_dev  := (P_mt_dev - NVL(P_mt_retenu_oppo/NVL(P_val_taux ,1),0)) * (-1);
               --v_mt_ligne_dev :=(p_mt_dev - NVL (p_mt_retenu_oppo / NVL (p_val_taux, 1), 0));
           --FBT-20070220-------------------------------------------------------------------------------
            END IF;

            IF INCREMENT = TRUE
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'INCREMENT = TRUE donc v_num_lig := v_num_lig + 1'
                         );
               v_num_lig := v_num_lig + 1;
            END IF;

----------------------------------------------------------------------------
/* Insertion de la ligne d'ecriture */
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'Avant INSERTION dans FC_LIGNE'
                      );

            INSERT INTO fc_ligne
                        (ide_poste, ide_gest, ide_jal, flg_cptab,
                         ide_ecr, ide_lig, var_cpta, var_tiers,
                         ide_tiers, ide_cpt,
                         ide_ordo, cod_sens, mt,
                         spec1, spec2, spec3, ide_schema,
                         cod_typ_schema, ide_modele_lig,
                         cod_bud, dat_ecr, dat_cre, uti_cre, dat_maj,
                         uti_maj, terminal, ide_devise, mt_dev,
                         val_taux, ide_plan_aux, ide_cpt_aux,
                         flg_annul_dcst
                        )
                 VALUES (p_ide_poste, p_ide_gest, p_ide_jal, v_flg_cptab,
                         p_ide_ecr, v_num_lig, p_var_cpta, p_var_tiers,
                         p_ide_tiers, DECODE (v_cpt, NULL, p_ide_cpt, v_cpt),
                         v_ordo, v_modele_ligne.val_sens, v_mt_ligne,
                         v_spec1, v_spec2, v_spec3, v_ide_schema,
                         v_cod_typ_schema, v_modele_ligne.ide_modele_lig,
                         v_bud, p_dat_ecr, v_dat_cre, v_uti_cre, v_dat_maj,
                         v_uti_maj, v_terminal, p_ide_devise, v_mt_ligne_dev,
                         p_val_taux, p_ide_plan_aux, p_ide_cpt_aux,
                         v_flg_annul_dcst
                        );

            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'Après INSERTION dans FC_LIGNE'
                      ); 
            v_insert_tiers := TRUE;
            INCREMENT := TRUE;
            p_num_lig_s := v_num_lig;
         EXCEPTION
            WHEN OTHERS
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                             'EXCEPTION OTHERS_3 ==> RAISE, erreur oracle : '
                          || SUBSTR (SQLERRM, 1, 150)
                         );
               RAISE;
         END;
-- 20042610-CBI-D
--    ELSIF v_Cod_Typ_Pec = 'I' AND  v_Insert_Tiers THEN
      ELSIF     v_cod_typ_pec = 'I'
            AND v_insert_tiers
            AND NVL (p_mt_retenu_oppo, 0) = 0
      THEN                                -- génération des lignes budgétaires
-- 20042610-CBI-F
         aff_trace
            ('MAJ_INS_LIGNE_TIERS',
             0,
             NULL,
             'Dans le cas : v_Cod_Typ_Pec = ''I'' AND  v_Insert_Tiers AND NVL(P_mt_retenu_oppo,0) = 0 ==> RAISE ERREUR_MODELE_LIGNE'
            );
         RAISE erreur_modele_ligne;
-------------------------------------------------------------------------------------
-- 1 Test si Si le shéma attaché au sous-type de pièce pour le modèle de ligne dont le
--  type de ligne = 'O'
-------------------------------------------------------------------------------------
      ELSIF     v_cod_typ_pec = 'O'
            AND NOT v_insert_opposition
            AND NVL (p_mt_retenu_oppo, 0) <> 0
      THEN             -- génération d'une ligne d'écriture imputant un compte
         -- tiers opposant si
         BEGIN
            aff_trace
               ('MAJ_INS_LIGNE_TIERS',
                0,
                NULL,
                'Dans le cas : v_Cod_Typ_Pec = ''O'' AND NOT v_Insert_Opposition AND NVL(P_mt_retenu_oppo,0) <> 0'
               );
   ----------------------------------------------------------------------
-- Recherche le montant
----------------------------------------------------------------------
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'v_cod_typ_piece = ' || v_cod_typ_piece
                      );
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'v_modele_ligne.val_sens = ' || v_modele_ligne.val_sens
                      );

            IF (   (v_cod_typ_piece = 'OR' AND v_modele_ligne.val_sens = 'D'
                   )
                OR (v_cod_typ_piece = 'AR' AND v_modele_ligne.val_sens = 'C'
                   )
                OR (v_cod_typ_piece = 'OD' AND v_modele_ligne.val_sens = 'C'
                   )
                OR (v_cod_typ_piece = 'AD' AND v_modele_ligne.val_sens = 'D'
                   )
               )
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'Cas 1');
      v_mt_retenu_oppo := p_mt_retenu_oppo;
               v_mt_retenu_oppo_dev := p_mt_dev;
      --DEBUT-FBT-20070918-correction ano mantis094 -----------------------------------------------------
      v_mt_ligne := v_mt_retenu_oppo;
      v_mt_ligne_dev := v_mt_retenu_oppo_dev;
      --FIN-FBT-20070918-correction ano mantis094 -------------------------------------------------------
            ELSE
               aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'Cas 2');
               v_mt_retenu_oppo := p_mt_retenu_oppo * (-1);
      --FBT-20070220-correction ano mantis023 - DIT44177-------------------------------------------
               --v_mt_retenu_oppo_dev := p_mt_dev;
      v_mt_retenu_oppo_dev := P_mt_dev * (-1);
      --FBT-20070220-------------------------------------------------------------------------------
      --DEBUT-FBT-20070918-correction ano mantis094 -----------------------------------------------------
      v_mt_ligne := v_mt_retenu_oppo;
      v_mt_ligne_dev := v_mt_retenu_oppo_dev;
      --FIN-FBT-20070918-correction ano mantis094 -------------------------------------------------------
  -- FIN MODIF MYI
            END IF;

            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'Avant Insertion dans FC_LIGNE'
                      );

----------------------------------------------------------------------------
/* Insertion de la ligne d'ecriture */
-- Modif MYI le 18/06/2002 Fonction 11 (le modèle ligne O fournit les règles de génération de
-- l'écriture comptable concernant le tiers opposant ( Fiche Question Fonction 11 Réponse N° 1 )
            INSERT INTO fc_ligne
                        (ide_poste, ide_gest, ide_jal, flg_cptab,
                         ide_ecr, ide_lig, var_cpta, var_tiers,
                         ide_tiers, ide_cpt,
                         ide_ordo, cod_sens, mt,
                         spec1, spec2, spec3, ide_schema,
                         cod_typ_schema, ide_modele_lig,
                         cod_bud, dat_ecr, dat_cre, uti_cre, dat_maj,
                         uti_maj, terminal
                                          -- MODIF MYI Le 15/05/2002 : Fonction 48
            ,            ide_devise,
                         mt_dev, val_taux
-- CBI-20050331-D - LOLF
            ,            ide_plan_aux,
                         ide_cpt_aux
                        )                                     -- FIN MODIF MYI
-- CBI-20050331-D - LOLF
            VALUES      (p_ide_poste, p_ide_gest, p_ide_jal, v_flg_cptab,
                         p_ide_ecr, v_num_lig, p_var_cpta, p_var_tiers,
                         p_ide_tiers,
                                     --MCE : 04/2007 ANO35 - SEN_V41_FA0006
                                     --v_modele_ligne.val_cpt,
                                     DECODE (v_cpt, NULL, p_ide_cpt, v_cpt),
                         --MCE : 04/2007 ANO35 - SEN_V41_FA0006
                         v_ordo, v_modele_ligne.val_sens, v_mt_retenu_oppo,
                         v_spec1, v_spec2, v_spec3, v_ide_schema,
                         v_cod_typ_schema, v_modele_ligne.ide_modele_lig,
                         v_bud, p_dat_ecr, v_dat_cre, v_uti_cre, v_dat_maj,
                         v_uti_maj, v_terminal, p_ide_devise,
                         v_mt_retenu_oppo_dev, p_val_taux
-- CBI-20050331-D - LOLF
            ,            p_ide_plan_aux,
                         p_ide_cpt_aux
-- CBI-20050331-F - LOLF
                        ); -- MODIF MYI Fonction 48 ( Ajout notion de devise )

            -- Modif MYI Le 15/04/2002
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'Après Insertion dans FC_LIGNE'
                      );
            v_insert_opposition := TRUE;
            INCREMENT := TRUE;
            p_num_lig_s := v_num_lig;
         EXCEPTION
            WHEN OTHERS
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                             'EXCEPTION OTHERS_4 ==> RAISE, erreur oracle : '
                          || SUBSTR (SQLERRM, 1, 150)
                         );
               RAISE;
         END;
      ELSIF     v_cod_typ_pec = 'O'
            AND v_insert_opposition
            AND NVL (p_mt_retenu_oppo, 0) <> 0
      THEN
         aff_trace
            ('MAJ_INS_LIGNE_TIERS',
             0,
             NULL,
             'Dans le cas : v_Cod_Typ_Pec = ''O'' AND  v_Insert_Opposition AND NVL(P_mt_retenu_oppo,0) <> 0 ==> RAISE ERREUR MODELE_LIGNE'
            );
         RAISE erreur_modele_ligne;
      END IF;
   END LOOP;

   -----------------------------------------------------------
   -- MODIF MYI le 18/06/2002 : Fonction 11
   -----------------------------------------------------------
-- 20042610-CBI-D
--      IF ( NOT v_Insert_Tiers ) OR
   IF    (NOT v_insert_tiers AND NVL (p_mt_retenu_oppo, 0) = 0)
      OR
-- 20042610-CBI-F
         (NOT v_insert_opposition AND NVL (p_mt_retenu_oppo, 0) <> 0)
   THEN
      aff_trace
         ('MAJ_INS_LIGNE_TIERS',
          0,
          NULL,
          'Cas ( NOT v_Insert_Tiers AND NVL(P_mt_retenu_oppo,0) = 0) OR ( NOT v_Insert_Opposition AND NVL(P_mt_retenu_oppo,0) <> 0 ==> RAISE ERREUR_MODELE_LIGNE'
         );
      RAISE erreur_modele_ligne;
   END IF;

-----------------------------------------------------------
   BEGIN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'Recherche des flg_justif dans FN_COMPTE'
                );

      SELECT flg_justif, flg_justif_tiers
        INTO v_flg_justif, v_flg_justif_tiers
        FROM fn_compte
       WHERE var_cpta = p_var_cpta AND ide_cpt = p_ide_cpt;

      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'v_flg_justif : ' || v_flg_justif
                );
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'v_flg_justif_tiers : ' || v_flg_justif_tiers
                );
      /* LGD ANO VA V3 282 - Le ses ne doi tpas être celui du dernier modèle de ligne créé
      /* Récupération du sens de la ligne d'écriture créée */
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'Recherche du code sens dans FC_LIGNE'
                );

      SELECT cod_sens
        INTO v_codext_cod_sens
        FROM fc_ligne
       WHERE ide_poste = p_ide_poste
         AND ide_gest = p_ide_gest
         AND ide_jal = p_ide_jal
         AND flg_cptab = v_flg_cptab
         AND ide_ecr = p_ide_ecr
         AND ide_lig = p_num_lig;

      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'v_codext_cod_sens : ' || v_codext_cod_sens
                );
      ext_codint ('SENS',
                  v_codext_cod_sens,
                  v_libl,
                  v_codint_cod_sens,
                  v_retour
                 );

      IF v_retour != 1
      THEN
         RAISE ext_codint_error;
      END IF;

      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'LGD v_codint_cod_sens après  ' || v_codint_cod_sens
                );

 ----------------------------------------------------------------------------------------------
 -- DEBUT - FBT - ano 151 - 16/11/2007 - controle de cohérence entre le compte et le schéma
 ext_codext ('TYPE_PEC', 'I', v_libl, v_cod_typ_pec_ext, v_retour);

 IF v_retour != 1
 THEN
    RAISE ext_codext_error;
 END IF;

 v_cod_ref_piece_calcule := NULL;

 OPEN c_cod_ref_piece;

 FETCH c_cod_ref_piece
  INTO p_cod_ref_piece;

 IF c_cod_ref_piece%NOTFOUND
 THEN
    RAISE erreur_modele_ligne;
 ELSE
  --traitement
  v_cod_ref_piece_calcule := p_cod_ref_piece.cod_ref_piece;

  FETCH c_cod_ref_piece
   INTO p_cod_ref_piece;

  IF c_cod_ref_piece%FOUND
  THEN
     RAISE erreur_modele_ligne;
  END IF;
 END IF;

 CLOSE c_cod_ref_piece;

 ext_codint ('TYPE_REF_PIECE',
          v_cod_ref_piece_calcule,
          v_libl,
          v_cod_ref_piece_ext,
          v_retour
         );

 IF v_retour != 1 THEN
    RAISE ext_codint_error;
 END IF;

 IF v_flg_justif='O' AND v_cod_ref_piece_ext='S' THEN
    RAISE erreur_abo_sans_piece;
 END IF;
 IF v_flg_justif='N' AND v_cod_ref_piece_ext IN ('C','A') THEN
    RAISE erreur_abo_sans_piece;
 END IF;
 -- FIN   - FBT - ano 151 - 16/11/2007 - controle de cohérence enter le compte et le schéma
 ----------------------------------------------------------------------------------------------

      IF v_flg_justif = v_flg_cptab
      THEN                                               -- v_flg_justif = 'O'
         aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL, 'v_flg_justif = O');

         /* Preparation des valeurs a inserer ou mettre a jour */
         IF v_cod_typ_piece IN ('OD', 'OR')
         THEN
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'v_cod_typ_piece IN (OD, OR)'
                      );
            v_ide_piece := p_ide_piece;
            v_cod_typ_piece_ext := p_cod_typ_piece;
         END IF;

         IF v_cod_typ_piece = 'AD'
         THEN
            aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL,
                       'v_cod_typ_piece = AD');
      v_ide_piece := p_ide_piece_init;
   ext_codext ('TYPE_PIECE',
                        'OD',
                        v_libl,
                        v_cod_typ_piece_ext,
                        v_retour
                       );
            IF v_retour != 1
            THEN
               RAISE ext_codext_error;
            END IF;
         END IF;

         IF v_cod_typ_piece = 'AR'
         THEN
            aff_trace ('MAJ_INS_LIGNE_TIERS', 0, NULL,
                       'v_cod_typ_piece = AR');
            v_ide_piece := p_ide_piece_init;
            ext_codext ('TYPE_PIECE',
                        'OR',
                        v_libl,
                        v_cod_typ_piece_ext,
                        v_retour
                       );

            IF v_retour != 1
            THEN
               RAISE ext_codext_error;
            END IF;
         END IF;

         aff_trace ('MAJ_INS_LIGNE_TIERS',
                    0,
                    NULL,
                    'On construit COD_REF_PIECE.'
                   );
         v_cod_ref_piece :=
               p_ide_ordo
            || '-'
            || p_cod_bud
            || '-'
            || p_ide_gest
            || '-'
            || v_cod_typ_piece_ext
            || '-'
            || v_ide_piece;
         aff_trace ('MAJ_INS_LIGNE_TIERS',
                    0,
                    NULL,
                       'On a construit COD_REF_PIECE. v_cod_ref_piece : '
                    || v_cod_ref_piece
                   );

-- CBI-20050331-D - LOLF
        --FBT 19/06/2007 -- Evol01
         IF v_cod_typ_piece = 'OD' OR v_cod_typ_piece = 'AD'
         THEN

            IF v_cod_ref_piece_ext = 'C'
             THEN
                v_cod_ref_piece :=
                      p_ide_ordo
                   || '-'
                   || p_cod_bud
                   || '-'
                   || p_ide_gest
                   || '-'
                   || v_cod_typ_piece_ext
                   || '-'
                   || v_ide_piece
                   || '-'
                   || p_num_lig_ligne_tiers;
             END IF;
          END IF;

    IF v_cod_typ_piece = 'AD' THEN
      IF v_cod_ref_piece_ext = 'C' THEN
         v_ide_piece := p_ide_piece;
      ELSE
         v_ide_piece := p_ide_piece_init;
      END IF;
      END IF;

-- CBI-20050331-F - LOLF
         IF v_flg_justif_tiers = v_flg_cptab
         THEN                                         --flg_justif_tiers = 'O'
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'v_flg_justif_tiers = O'
                      );
            v_var_tiers := p_var_tiers;
            v_ide_tiers := p_ide_tiers;
         ELSE
            v_var_tiers := NULL;
            v_ide_tiers := NULL;
         END IF;

         IF v_codint_cod_sens = 'D'
         THEN
            v_mt_db := v_mt_ligne;
         ELSE
            v_mt_db := 0;
         END IF;

         IF v_codint_cod_sens = 'C'
         THEN
            v_mt_cr := v_mt_ligne;
         ELSE
            v_mt_cr := 0;
         END IF;

         /* Recherche d'une reference piece existante */

         /* MODIF SGN du 30.08.01
            Le ide_ref piece doit etre renseigne uniquement lorsqu on cherche a viser
            une ordonnace dont la reference piece sur les ligne tiers piece a deja
            ete cree lors d une operation comptable de la CGE */
         v_ref_piece_exist := 'N';   -- Indique si r_ref_piece a ete renseigne

         IF p_ide_ref_piece IS NOT NULL
         THEN
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                          'p_ide_ref_piece = '
                       || p_ide_ref_piece
                       || ', donc non NULL. Ouverture du curseur C_REF_PIECE_2'
                      );

            OPEN c_ref_piece2 (v_flg_justif_tiers);

            FETCH c_ref_piece2
             INTO r_ref_piece;

            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'On vérifie si C_REF_PIECE_2 a ramené une pièce'
                      );

            IF c_ref_piece2%FOUND
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'C_REF_PIECE_2 a ramené une pièce.'
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                             'r_ref_piece.ide_ref_piece : '
                          || r_ref_piece.ide_ref_piece
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                             'r_ref_piece.cod_ref_piece : '
                          || r_ref_piece.cod_ref_piece
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.mt_db : ' || r_ref_piece.mt_db
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.mt_cr : ' || r_ref_piece.mt_cr
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.mt_dev : ' || r_ref_piece.mt_dev
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                             'r_ref_piece.dat_der_mvt : '
                          || r_ref_piece.dat_der_mvt
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.dat_maj : ' || r_ref_piece.dat_maj
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.uti_maj : ' || r_ref_piece.uti_maj
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.terminal : ' || r_ref_piece.terminal
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.ROWID : ' || r_ref_piece.ROWID
                         );
               v_ref_piece_exist := 'O';
            END IF;
         ELSE
            /* FIN MODIF SGN */
            aff_trace
                ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'p_ide_ref_piece est NULL. Ouverture du curseur C_REF_PIECE'
                );

            OPEN c_ref_piece (v_cod_typ_piece_ext, v_flg_justif_tiers);

            FETCH c_ref_piece
             INTO r_ref_piece;

            /* MODIF SGN DU 30.08.01 */
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'On vérifie si C_REF_PIECE a ramené une pièce'
                      );

            IF c_ref_piece%FOUND
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'C_REF_PIECE a ramené une pièce.'
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                             'r_ref_piece.ide_ref_piece : '
                          || r_ref_piece.ide_ref_piece
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                             'r_ref_piece.cod_ref_piece : '
                          || r_ref_piece.cod_ref_piece
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.mt_db : ' || r_ref_piece.mt_db
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.mt_cr : ' || r_ref_piece.mt_cr
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.mt_dev : ' || r_ref_piece.mt_dev
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                             'r_ref_piece.dat_der_mvt : '
                          || r_ref_piece.dat_der_mvt
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.dat_maj : ' || r_ref_piece.dat_maj
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.uti_maj : ' || r_ref_piece.uti_maj
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.terminal : ' || r_ref_piece.terminal
                         );
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'r_ref_piece.ROWID : ' || r_ref_piece.ROWID
                         );
               v_ref_piece_exist := 'O';
            END IF;
         END IF;

   --FBT - 16/11/2007 - ano 148 - Si RC_MODELE_LIGNE sans valeur on ne fait rien concernant les pièces
   IF NVL (v_cod_ref_piece_ext, ' ') != 'S' THEN
         /* FIN MODIF SGN */
         IF     v_ref_piece_exist =
                         'O'
                            -- MODIF SGN DU 30.08.01 IF c_ref_piece%FOUND THEN
            AND NVL (v_cod_ref_piece_ext, ' ') !=
                               'C'
                                  -- RDU-20050623-Ano V35-3E-DJP001(RLI LOLF)
                                  -- CBI-20050711-Ano V35-3E-DJP05 (ajout NVL)
         THEN
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'v_ref_piece_exist = O : une pièce a été trouvée'
                      );

            /* Mise a jour de la piece trouvee */
            IF v_codint_cod_sens = 'D'
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'Dans le cas où v_codint_cod_sens = D'
                         );

               IF r_ref_piece.mt_db + v_mt_ligne = r_ref_piece.mt_cr
               THEN
                  v_solde := v_flg_cptab;                  -- flg_solde = 'O'
               ELSE
                  v_solde := v_flg_solde;                  -- flg_solde = 'N'
               END IF;

               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'Avant MAJ de FC_REF_PIECE'
                         );

                  -- DEBUT / PGE - 07/04/2008 , EVOLUTION EVO_2007_010
                  IF CTL_VERIF_SENS(p_ide_poste,r_ref_piece.ide_ref_piece,'mt_db',NVL(v_mt_ligne,0)) = 1 THEN
                    --Update refusé dû à l'inversion du sens du solde quelle provoquerait
                    raise inversion_sens_solde;
                  END IF;
                  -- FIN / PGE - 07/04/2008 , EVOLUTION

                  UPDATE fc_ref_piece
                  SET mt_db = mt_db + v_mt_ligne,
       --FBT-11/09/07-ANO 85- Gestion des signe de mt_dev-------------------------------------------
                      --mt_dev = mt_dev - NVL (v_mt_ligne_dev, 0),
       mt_dev = mt_dev + NVL (v_mt_ligne_dev, 0),
                      val_taux =
                         DECODE (NVL (ide_devise, p_ide_devise_ref),
                                 p_ide_devise_ref, val_taux,
                                 p_val_taux
                                ),
                      flg_solde = v_solde,
                      dat_der_mvt = p_dat_jc,--pge 27/03/2008 - EVOLUTION EVO_2007_010 | "p_dat_cad" remplacé par p_dat_jc
                      /* MODIF SGN DU 30.08.01 */
                      ide_ordo = p_ide_ordo,
                      cod_bud = p_cod_bud,
                      -- MODIF SGN ANOVA304 : 3.1-1.7 : cod_typ_piece = P_cod_typ_piece,
                      cod_typ_piece = v_cod_typ_piece_ext,
                      -- fin modif sgn 3.1-1.7
                      ide_piece = v_ide_piece,
                      /* FIN MODIF SGN */
                      dat_maj = SYSDATE,
                      uti_maj = v_uti_maj,
                      terminal = v_terminal
                   /* MODIF SGN du 30.08.01 WHERE CURRENT OF c_ref_piece; */
                   WHERE  ROWID = r_ref_piece.ROWID;

               /* FIN MODIF SGN */
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'Après MAJ de FC_REF_PIECE'
                         );
            ELSIF v_codint_cod_sens = 'C'
            THEN
               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'Dans le cas où v_codint_cod_sens = C'
                         );

               IF r_ref_piece.mt_cr + v_mt_ligne = r_ref_piece.mt_db
               THEN
                  v_solde := v_flg_cptab;                  -- flg_solde = 'O'
               ELSE
                  v_solde := v_flg_solde;                  -- flg_solde = 'N'
               END IF;

               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'Avant MAJ de FC_REF_PIECE'
                         );

               -- DEBUT / PGE - 07/04/2008 , EVOLUTION EVO_2007_010
               IF CTL_VERIF_SENS(p_ide_poste,r_ref_piece.ide_ref_piece,'mt_cr',NVL(v_mt_ligne,0)) = 1 THEN
                 --Update refusé dû à l'inversion du sens du solde quelle provoquerait
                 raise inversion_sens_solde;
               END IF;
               -- FIN / PGE - 07/04/2008 , EVOLUTION

               UPDATE fc_ref_piece
                  SET mt_cr = mt_cr +  NVL (v_mt_ligne, 0),
                 --FBT-211/09/07-ANO 85- Gestion des signe de mt_dev-------------------------------------------
                      --mt_dev = mt_dev - NVL (v_mt_ligne_dev, 0),
             mt_dev = mt_dev + NVL (v_mt_ligne_dev, 0),
                      val_taux =
                         DECODE (NVL (ide_devise, p_ide_devise_ref),
                                 p_ide_devise_ref, val_taux,
                                 p_val_taux
                                ),
                      flg_solde = v_solde,
                      dat_der_mvt = p_dat_jc,--pge 27/03/2008 - EVOLUTION EVO_2007_010 | "p_dat_cad" remplacé par p_dat_jc
                      /* MODIF SGN DU 30.08.01 */
                      ide_ordo = p_ide_ordo,
                      cod_bud = p_cod_bud,
                      -- MODIF SGN ANOVA304 : 3.1-1.7 : cod_typ_piece = P_cod_typ_piece,
                      cod_typ_piece = v_cod_typ_piece_ext,
                      -- fin modif sgn 3.1-1.7
                      ide_piece = v_ide_piece,
                      /* FIN MODIF SGN */
                      dat_maj = SYSDATE,
                      uti_maj = v_uti_maj,
                      terminal = v_terminal                /* MODIF SGN du 30.08.01 WHERE CURRENT OF c_ref_piece; */
               WHERE  ROWID = r_ref_piece.ROWID;

               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'Après MAJ de FC_REF_PIECE'
                         );
            /* FIN MODIF SGN */
            END IF;

            /* Mise a jour de la reference piece sur la ligne d'ecriture */
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'Avant MAJ de la référence pièce dans FC_LIGNE'
                      );

            UPDATE fc_ligne
               SET ide_ref_piece = r_ref_piece.ide_ref_piece,
                   cod_ref_piece = r_ref_piece.cod_ref_piece,
                   dat_maj = v_dat_maj,
                   uti_maj = v_uti_maj,
                   terminal = v_terminal
             WHERE ide_poste = p_ide_poste
               AND ide_gest = p_ide_gest
               AND ide_jal = p_ide_jal
               AND flg_cptab = v_flg_cptab
               AND ide_ecr = p_ide_ecr
               AND ide_lig = p_num_lig;

            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'Après MAJ de la référence pièce dans FC_LIGNE'
                      );
         ELSE                                      /* aucune piece trouvee  */
            aff_trace
                     ('MAJ_INS_LIGNE_TIERS',
                      0,
                      NULL,
                      'v_ref_piece_exist = N : aucune pièce n''a été trouvée'
                     );
      /* insertion */
      /* Calcul du numero de la piece  */
      -------------------------------------------------------------------
-- Modif MYI Fonction 48 :
-- Si la pièce existe mais avec une devise  <> la devise saisie alors il
-- faut crée une ligne dans FC_REF_PIECE telle que : le numéro  de la pièce = P_IDE_REF_PIECE
-------------------------------------------------------------------
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'On regarde si la pièce existe avec une devise <>'
                      );

            BEGIN
               SELECT COUNT (*)
                 INTO v_nbr_piece
                 FROM fc_ref_piece
                WHERE ide_poste = p_ide_poste
                  AND ide_ref_piece = p_ide_ref_piece;
            EXCEPTION
               WHEN OTHERS
               THEN
                  aff_trace
                         ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                             'EXCEPTION OTHERS_5 ==> RAISE, erreur oracle : '
                          || SUBSTR (SQLERRM, 1, 150)
                         );
                  RAISE;
            END;

            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'v_nbr_piece = ' || v_nbr_piece
                      );

            IF NVL (v_nbr_piece, 0) = 0
            THEN
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                   'Comme v_nbr_piece = 0, on cherche le MAX + 1 dans FC_REF_PIECE'
                  );

               SELECT NVL (MAX (a.ide_ref_piece), 0) + 1
                 INTO v_ide_ref_piece
                 FROM fc_ref_piece a
                WHERE a.ide_poste = p_ide_poste;

               aff_trace ('MAJ_INS_LIGNE_TIERS',
                          0,
                          NULL,
                          'v_ide_ref_piece ramené = ' || v_ide_ref_piece
                         );
            ELSE
               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                      'Comme v_nbr_piece > 0, MAJ de FC_REF_PIECE avec cod_ref_piece = v_cod_ref_piece. Rappel, v_cod_ref_piece = '
                   || v_cod_ref_piece
                  );

               /* FBT 01/07/2009 - ANO 281 - ANO 378
		-- Modif MYI le 28/06/2002 : Modif de la code ref pièce pour les autres devises
               UPDATE fc_ref_piece
                  SET cod_ref_piece = v_cod_ref_piece
                WHERE ide_poste = p_ide_poste
                  AND ide_ref_piece = p_ide_ref_piece;
               -- FIN MODIF MYI
		*/

			   --DEBUT FBT 03-10-2008 - ANO 281- Calcul du numéro de piece à créer --------
			   SELECT NVL (MAX (a.ide_ref_piece), 0) + 1
                 INTO v_ide_ref_piece
                 FROM fc_ref_piece a
                WHERE a.ide_poste = p_ide_poste;
               --DEBUT FBT 03-10-2008 - ANO 281- Calcul du numéro de piece à créer --------

               aff_trace
                  ('MAJ_INS_LIGNE_TIERS',
                   0,
                   NULL,
                      'Après MAJ de FC_REF_PIECE. v_ide_ref_piece := P_Ide_Ref_Piece, càd : '
                   || p_ide_ref_piece
                  );
            END IF;

            -- FIN MODIF MYI
            /* insertion de la piece */
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'Avant insertion pièce dans FC_REF_PIECE'
                      );


     --DEBUT FBT 28-06-2007 - Mise a jour du code ref piece en cas d'AD --------
     EXT_CODEXT ( 'TYPE_PIECE', 'AD', v_codif_libl, v_codif_ad, v_temp );
     IF p_cod_typ_piece = v_codif_ad
            THEN
               v_cod_ref_piece :=
                     p_ide_ordo
                  || '-'
                  || p_cod_bud
                  || '-'
                  || p_ide_gest
                  || '-'||v_codif_ad||'-'
                  || p_ide_piece
                  || '-'
                  || p_num_lig_ligne_tiers;
            END IF;

   --DEBUT - FBT - 13/10/2007 - Controle incohérence création de piece avec un sous type abondement ------------
   IF v_cod_ref_piece_ext = 'A' THEN
      RAISE erreur_abo_sans_piece;
   END IF;
   --FIN   - FBT - 13/10/2007 ----------------------------------------------------------------------------------

      --FIN FBT 28-06-2007 ------------------------------------------------------
            INSERT INTO fc_ref_piece
                        (ide_poste, ide_ref_piece, ide_ordo, cod_bud,
                         cod_typ_piece, ide_piece, cod_ref_piece,
                         var_tiers, ide_tiers, ide_gest, flg_cptab,
                         mt_db,
                         mt_cr, dat_der_mvt,
                         flg_solde, ide_jal, ide_ecr, ide_lig,
                         dat_cre, uti_cre, dat_maj, uti_maj,
                         terminal, ide_devise,
                         mt_dev,
                         val_taux,
       num_lig_tiers--pge v4260 evol_2008_014 27/05/2008
                        )
          -- MODIF MYI le 15/05/2002 (ajout de ide_devise ,mt_dev et val_taux)
                 VALUES (p_ide_poste, v_ide_ref_piece, p_ide_ordo, p_cod_bud,
                         v_cod_typ_piece, v_ide_piece, v_cod_ref_piece,
                         v_var_tiers, v_ide_tiers,
-- 20042610-CBI-D
--         P_ide_gest,v_flg_cptab,v_mt_db,v_mt_cr,P_dat_cad,v_flg_solde,
--        P_ide_jal,P_ide_ecr,P_num_lig,v_dat_cre, v_uti_cre, v_dat_maj, v_uti_maj, v_terminal , P_ide_devise , v_mt_ligne_dev , P_val_taux);
                                                  p_ide_gest, v_flg_cptab,
                         NVL (v_mt_db, v_mt_retenu_oppo),
                         NVL (v_mt_cr, v_mt_retenu_oppo),
                         p_dat_jc,--pge 27/03/2008 - EVOLUTION EVO_2007_010 | "p_dat_cad" remplacé par p_dat_jc
                         v_flg_solde, p_ide_jal, p_ide_ecr, p_num_lig,
                         v_dat_cre, v_uti_cre, v_dat_maj, v_uti_maj,
                         v_terminal, p_ide_devise,
                         NVL (v_mt_ligne_dev, v_mt_retenu_oppo_dev),
                         p_val_taux,
                         p_num_lig_ligne_tiers--pge v4260 evol_2008_014 27/05/2008
                        );
-- 20042610-CBI-F

            --pge v4260 evol_2008_014 28/05/2008.
            UPDATE FB_LIGNE_TIERS_PIECE
               SET IDE_REF_PIECE = v_ide_ref_piece
             WHERE IDE_POSTE = p_ide_poste
               AND IDE_GEST = p_ide_gest
               AND IDE_ORDO = p_ide_ordo
               AND COD_BUD = p_cod_bud
               AND IDE_PIECE = v_ide_piece
               AND COD_TYP_PIECE = v_cod_typ_piece
               AND NUM_LIG = p_num_lig_ligne_tiers;
            --pge v4260 evol_2008_014 28/05/2008.




            aff_trace
               ('MAJ_INS_LIGNE_TIERS',
                0,
                NULL,
                'Après insertion pièce dans FC_REF_PIECE et avant MAJ de la référence pièce dans FC_LIGNE'
               );

            /* Mise a jour de la reference piece sur la ligne d'ecriture */
            UPDATE fc_ligne
               SET ide_ref_piece = v_ide_ref_piece,
                   cod_ref_piece = v_cod_ref_piece,
                   dat_maj = v_dat_maj,
                   uti_maj = v_uti_maj,
                   terminal = v_terminal
             WHERE ide_poste = p_ide_poste
               AND ide_gest = p_ide_gest
               AND ide_jal = p_ide_jal
               AND flg_cptab = v_flg_cptab
               AND ide_ecr = p_ide_ecr
               AND ide_lig = p_num_lig;

            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'Après MAJ de la référence pièce dans FC_LIGNE'
                      );
         END IF;

  END IF;

         /* MODIF SGN DU 30.08.01 On ferme le curseur approprie */
         IF p_ide_ref_piece IS NOT NULL
         THEN
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'Fermeture curseur C_REF_PIECE_2'
                      );

            CLOSE c_ref_piece2;
         ELSE
            aff_trace ('MAJ_INS_LIGNE_TIERS',
                       0,
                       NULL,
                       'Fermeture curseur C_REF_PIECE'
                      );

            CLOSE c_ref_piece;
         END IF;
      /* FIN MODIF SGN */
      END IF;                                         -- IF v_flg_justif = 'O'
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         aff_trace ('MAJ_INS_LIGNE_TIERS',
                    0,
                    NULL,
                    'EXCEPTION NO_DATA_FOUND_3 ==> RAISE DONNE_ABSENTE'
                   );
         RAISE donnee_absente;
      WHEN OTHERS
      THEN
         aff_trace ('MAJ_INS_LIGNE_TIERS',
                    0,
                    NULL,
                       'EXCEPTION OTHERS_6 ==> RAISE, erreur oracle : '
                    || SUBSTR (SQLERRM, 1, 150)
                   );
         RAISE;
   END;

-- CBI-20050811-D-FA0043
   IF v_cod_typ_piece = 'AD' OR v_cod_typ_piece = 'OD'
   THEN
      p_cod_ref_piece_s := v_cod_ref_piece;
   END IF;

-- CBI-20050811-F-FA0043

   -- MODIF SGN ANOVSR420 : 3.3-1.9 : p_ret = 2 uniquement si la modif du param est inserée en base
   -- p_ret := 1:
   IF v_flg_err915 = 1
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'v_flg_err915 = 1 donc p_ret = 2'
                );
      p_ret := 2;
   END IF;

   -- fin modif sgn 3.3-1.9
   aff_trace ('MAJ_INS_LIGNE_TIERS',
              0,
              NULL,
              'FIN MAJ_INS_LIGNE_TIERS. P_ret = ' || p_ret
             );

EXCEPTION
   WHEN donnee_absente
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION DONNEE_ABSENTE ==> p_ret = 0'
                );
      p_ret := 0;
   WHEN ext_codext_error
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION EXT_CODEXT_ERROR ==> p_ret = -1'
                );
      p_ret := -1;
   WHEN ext_codint_error
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION EXT_CODINT_ERROR ==> p_ret = -2'
                );
      p_ret := -2;
   -- MODIF MYI Le 15/04/2002 : Fonction 11
   WHEN erreur_modele_ligne
   THEN                            -- Erreur de paramétrage de modèle de ligne
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION ERREUR_MODELE_LIGNE ==> p_ret = -3'
                );
      p_ret := -3;
   WHEN erreur_type_shema
   THEN      -- Type shéma n'existe pas ou n'est pas valide ( Message N° 802 )
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION ERREUR_TYPE_SHEMA ==> p_ret = -4'
                );
      p_ret := -4;
   WHEN erreur_param_shema
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION ERREUR_PARAM_SHEMA ==> p_ret = -5'
                );
      p_ret := -5;
-- shéma comptable attaché au sous-type de pièce %1 n'existe pas ou n'est pas valide ( message N° 797) .
   -- MODIF SGN ANOVSR420 ANOVSR421 : 3.3-1.8
   WHEN erreur_maj_cpt
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION ERREUR_MAJ_CPT ==> p_ret = -8'
                );
      p_ret := -8;
   WHEN erreur_val_masque_cpt
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION ERREUR_VAL_MASQUE_CPT ==> p_ret = -9'
                );
      p_ret := -9;
   WHEN erreur_ctl_masque_spec1
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION ERREUR_CTL_MASQUE_SPEC1 ==> p_ret = -10'
                );
      p_ret := -10;
   WHEN erreur_ctl_masque_spec2
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION ERREUR_CTL_MASQUE_SPEC2 ==> p_ret = -11'
                );
      p_ret := -11;
   WHEN erreur_ctl_masque_spec3
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION ERREUR_CTL_MASQUE_SPEC3 ==> p_ret = -12'
                );
      p_ret := -12;
   WHEN erreur_ctl_masque_cpt
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION ERREUR_CTL_MASQUE_CPT ==> p_ret = -13'
                );
      p_ret := -13;
   WHEN erreur_ctl_masque_ordo
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION ERREUR_CTL_MASQUE_ORDO ==> p_ret = -14'
                );
      p_ret := -14;
   WHEN erreur_ctl_masque_bud
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION ERREUR_CTL_MASQUE_BUD ==> p_ret = -15'
                );
      p_ret := -15;
   -- fin modif sgn 3.3-1.8
   WHEN erreur_abo_sans_piece
   THEN
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION ERREUR_ABO_sans_piece ==> p_ret = -18'
                );
      p_ret := -18;

  -- DEBUT / PGE - 07/04/2008, EVOLUTION EVO_2007_010
  WHEN inversion_sens_solde
  THEN
    --Modification du crédit ou débit impossible car cela affecterait le sens du solde d'origine de la pièce.
      aff_trace ('MAJ_INS_LIGNE_TIERS',
                 0,
                 NULL,
                 'EXCEPTION Erreur inversion_sens_solde ==> p_ret = -19'
                );
      p_ret := -19;
  -- FIN / PGE - 07/04/2008, EVOLUTION
   WHEN OTHERS
   THEN
      aff_trace
           ('MAJ_INS_LIGNE_TIERS',
            0,
            NULL,
               'EXCEPTION OTHERS_7 ==> RAISE et p_ret = -6, erreur oracle : '
            || SUBSTR (SQLERRM, 1, 150)
           );
      RAISE;
      p_ret := -6;
END maj_ins_ligne_tiers;

/

CREATE OR REPLACE PROCEDURE MAJ_Situations_B
   ( p_cod_type IN VARCHAR2,
     p_mt IN  fb_rechb.mt%TYPE,
     p_mt_bud IN  fb_rechb.mt%TYPE,
     p_cod_orig_benef IN sb_situ.cod_orig_benef%TYPE,
     p_ide_poste IN fb_rechb.ide_poste%TYPE,
     p_ide_ordo IN fb_rechb.ide_ordo%TYPE,
     p_cod_bud IN fb_rechb.cod_bud%TYPE,
     p_var_bud IN fb_rechb.var_bud%TYPE,
     p_ide_gest IN fb_credi.ide_gest%TYPE,
     p_ide_lig_prev IN OUT fb_reser.ide_lig_prev%TYPE,
     p_ide_lig_exec IN fb_exres.ide_lig_exec%TYPE,
     p_ide_ope IN fb_rechb.ide_ope%TYPE,
     p_cod_nat_cr IN OUT sr_codif.ide_codif%TYPE,
     p_retour OUT NUMBER,
     p_ide_ss_type IN pb_ss_type_piece.ide_ss_type%TYPE := NULL  -- MODIF SGN ANOVA 13,14,36
) IS

/* Paramètres en entrée :                                                                               */
/*           p_cod_type : code nature de délégation ou type de piece ou                                 */
/*                        code opération du mouvement budgétaire                                        */
/*           p_mt : montant total ligne                                                                 */
/*           p_mt_bud : montant ligne imputé sur budget ( facultatif )	                                */
/*           p_cod_orig_benef : code origine / bénéficiaire (code interne)                              */
/*           p_ide_poste : poste comptable                                                              */
/*           p_ide_ordo : ordonnateur                                                                   */
/*           p_cod_bud : code budget                                                                    */
/*           p_var_bud : variation budgétaire                                                           */
/*           p_ide_gest : gestion ( facultatif )                                                        */
/*           p_ide_lig_prev : ligne budgétaire ( facultatif )                                           */
/*           p_ide_lig_exec : ligne budgétaire d'exécution                                              */
/*           p_ide_ope : code opération ( facultatif )                                                  */
/*           p_cod_nat_cr : nature de crédit (code interne)                                             */
/*           p_ide_ss_type : sous type de piece */
/*			  			   	 		   		  		*/
/* Paramètres en sortie :  									   	*/
/*          p_retour : code retour de la procédure : 1 si OK                                            */
/*                                                   0 si aucun enregistrement retenu dans sb_situ      */
/*                                                   -9 si erreur lors de la recuperation d'ide_lig_prev*/
/*                                                   -8 si erreur lors de la recuperation de cod_nat_cr */
/*                                                   -7 si erreur lors de l'ext_codint                  */
/*                                                   -6 si verrouillage impossible                      */
/*                                                   -5 si erreur lors de l'extraction du code operation*/
/*                                                   -4 si disponible insuffisant                       */
/*                                                   -3 si erreur lors de la mise a jour                */
/*                                                   -2 si erreur lors de l'insertion                   */
/*                                                   -1 si autre erreur                                 */

/* Modifications:
/*      @(#) MODIF SGN du 10.07.01 (Evol Lot 3) 			     */
/*               Alimentation des nouvelles table situation FB_PREOP   */
/*               et FP_EXEOP                                           */
-- ---------------------------------------------------------------
-- @(#)EXT_Cod_Ope.sql  3.0-1.1	|25/09/2002	|SGN	| MODIF SGN FCT11 ANOVA13, 14, 36 : ajout du
-- @(#)EXT_Cod_Ope.sql  3.0-1.1	|25/09/2002	|SGN	| ss type de piece en parametre, transmis
-- @(#)EXT_Cod_Ope.sql  3.0-1.1	|25/09/2002	|SGN	|  lors de l appel a ext_cod_ope
-- --------------------------------------------------------------------

/* ************************************************************************************************ */
/* Déclaration des curseurs des tables de situation */
/* ************************************************************************************************ */

CURSOR c_autpro(w_cod_mt VARCHAR2) IS
SELECT mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
FROM fb_autpro
WHERE ide_poste = p_ide_poste AND ide_ordo = p_ide_ordo AND cod_bud = p_cod_bud
      AND cod_mt = w_cod_mt
      AND ide_lig_prev = p_ide_lig_prev
FOR UPDATE OF mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
NOWAIT;

CURSOR c_credi (w_cod_mt VARCHAR2, w_cod_ss_code VARCHAR2) IS
SELECT mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
FROM fb_credi
WHERE ide_poste = p_ide_poste AND ide_ordo = p_ide_ordo AND cod_bud = p_cod_bud
      AND cod_mt = w_cod_mt
      AND ide_lig_prev = p_ide_lig_prev
      AND ide_gest = p_ide_gest
      AND cod_ss_code = w_cod_ss_code
FOR UPDATE OF mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
NOWAIT;

CURSOR c_crepa (w_cod_mt VARCHAR2) IS
SELECT mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
FROM fb_crepa
WHERE ide_poste = p_ide_poste AND ide_ordo = p_ide_ordo AND cod_bud = p_cod_bud
      AND cod_mt = w_cod_mt
      AND ide_lig_prev = p_ide_lig_prev
      AND ide_gest = p_ide_gest
FOR UPDATE OF mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
NOWAIT;

CURSOR c_dephb (w_cod_mt VARCHAR2, w_cod_ss_code VARCHAR2) IS
SELECT mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
FROM fb_dephb
WHERE ide_poste = p_ide_poste AND ide_ordo = p_ide_ordo AND cod_bud = p_cod_bud
      AND cod_mt = w_cod_mt
      AND ide_ope = p_ide_ope
      AND cod_ss_code = w_cod_ss_code
FOR UPDATE OF mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
NOWAIT;

CURSOR c_rechb (w_cod_mt VARCHAR2) IS
SELECT mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
FROM fb_rechb
WHERE ide_poste = p_ide_poste AND ide_ordo = p_ide_ordo AND cod_bud = p_cod_bud
      AND cod_mt = w_cod_mt
      AND ide_ope = p_ide_ope
FOR UPDATE OF mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
NOWAIT;

CURSOR c_reser (w_cod_mt VARCHAR2, w_cod_ss_code VARCHAR2)  IS
SELECT mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
FROM fb_reser
WHERE ide_poste = p_ide_poste AND ide_ordo = p_ide_ordo AND cod_bud = p_cod_bud
      AND cod_mt = w_cod_mt
      AND ide_lig_prev = p_ide_lig_prev
      AND ide_ope = p_ide_ope
      AND cod_ss_code = w_cod_ss_code
FOR UPDATE OF mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
NOWAIT;

CURSOR c_prere (w_cod_mt VARCHAR2) IS
SELECT mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
FROM fb_prere
WHERE ide_poste = p_ide_poste AND ide_ordo = p_ide_ordo AND cod_bud = p_cod_bud
      AND cod_mt = w_cod_mt
      AND ide_lig_prev = p_ide_lig_prev
      AND ide_gest = p_ide_gest
FOR UPDATE OF mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
NOWAIT;

CURSOR c_exres (w_cod_mt VARCHAR2) IS
SELECT mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
FROM fb_exres
WHERE ide_poste = p_ide_poste AND ide_ordo = p_ide_ordo AND cod_bud = p_cod_bud
      AND cod_mt = w_cod_mt
      AND ide_ope = p_ide_ope
      AND ide_lig_exec = p_ide_lig_exec
FOR UPDATE OF mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
NOWAIT;

CURSOR c_exere (w_cod_mt VARCHAR2) IS
SELECT mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
FROM fb_exere
WHERE ide_poste = p_ide_poste AND ide_ordo = p_ide_ordo AND cod_bud = p_cod_bud
      AND cod_mt = w_cod_mt
      AND ide_lig_exec = p_ide_lig_exec
      AND ide_gest = p_ide_gest
FOR UPDATE OF mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
NOWAIT;

CURSOR c_execp (w_cod_mt VARCHAR2) IS
SELECT mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
FROM fb_execp
WHERE ide_poste = p_ide_poste AND ide_ordo = p_ide_ordo AND cod_bud = p_cod_bud
      AND cod_mt = w_cod_mt
      AND ide_lig_exec = p_ide_lig_exec
      AND ide_gest = p_ide_gest
FOR UPDATE OF mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
NOWAIT;

CURSOR c_excre (w_cod_mt VARCHAR2) IS
SELECT mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
FROM fb_excre
WHERE ide_poste = p_ide_poste AND ide_ordo = p_ide_ordo AND cod_bud = p_cod_bud
      AND cod_mt = w_cod_mt
      AND ide_lig_exec = p_ide_lig_exec
      AND ide_gest = p_ide_gest
FOR UPDATE OF mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
NOWAIT;

/* Modif du 10.07.01 : Ajout des curseur sur FB_PREOP et FB_EXEOP */
CURSOR c_preop (w_cod_mt VARCHAR2) IS
SELECT mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
FROM fb_preop
WHERE ide_poste = p_ide_poste AND ide_ordo = p_ide_ordo AND cod_bud = p_cod_bud
      AND cod_mt = w_cod_mt
      AND ide_lig_prev = p_ide_lig_prev
      AND ide_gest = p_ide_gest
	  AND ide_ope = p_ide_ope
FOR UPDATE OF mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
NOWAIT;

CURSOR c_exeop (w_cod_mt VARCHAR2) IS
SELECT mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
FROM fb_exeop
WHERE ide_poste = p_ide_poste AND ide_ordo = p_ide_ordo AND cod_bud = p_cod_bud
      AND cod_mt = w_cod_mt
      AND ide_lig_exec = p_ide_lig_exec
      AND ide_gest = p_ide_gest
	  AND ide_ope = p_ide_ope
FOR UPDATE OF mt, dat_cre, uti_cre, dat_maj, uti_maj, terminal
NOWAIT;
/* Fin modif */

/* ************************************************************************************************ */
/* Déclaration des variables de curseur */
/* ************************************************************************************************ */
v_autpro c_autpro%ROWTYPE;
v_credi c_credi%ROWTYPE;
v_crepa c_crepa%ROWTYPE;
v_dephb c_dephb%ROWTYPE;
v_excre c_excre%ROWTYPE;
v_execp c_execp%ROWTYPE;
v_exere c_exere%ROWTYPE;
v_exres c_exres%ROWTYPE;
v_prere c_prere%ROWTYPE;
v_rechb c_rechb%ROWTYPE;
v_reser c_reser%ROWTYPE;
v_preop c_preop%ROWTYPE; -- Modfif SGN du 10.07.01
v_exeop c_exeop%ROWTYPE; -- Modfif SGN du 10.07.01

/* ************************************************************************************************ */
/* Declaration du curseur de parcours de SB_situ */
/* ************************************************************************************************ */
CURSOR c_situ(p_cod_ope sb_situ.cod_ope%TYPE) IS
SELECT UPPER(table_name) table_name, cod_typ_mt, cod_mt, cod_ss_code
FROM sb_situ
WHERE
  cod_ope = p_cod_ope
  AND cod_orig_benef = p_cod_orig_benef;

/* Variables locales */
v_cod_ope1 sb_situ.cod_ope%TYPE := Null;
v_cod_ope2 sb_situ.cod_ope%TYPE := Null;
v_mt_cod1 fb_rechb.mt%TYPE := Null;
v_mt_cod2 fb_rechb.mt%TYPE := Null;
v_cod_nat_cr sr_codif.cod_codif%TYPE;
v_ide_nat_cr sr_codif.ide_codif%TYPE;
v_libl sr_codif.libl%TYPE;

/* variable de retour des fonctions de mise a jour et d'insertion */
v_ret NUMBER;
v_ret_insert NUMBER;
/* variable de retour de la fonction de contrôle de dispo */
v_ret_ctl NUMBER;

/* exceptions */
err_ext_cod_nat_cr EXCEPTION;
err_ext_codint EXCEPTION;
err_dispo EXCEPTION;
err_maj_update EXCEPTION;
err_maj_insert EXCEPTION;
err_ext_cod_ope EXCEPTION;
err_ext_lig_bud_prev EXCEPTION;
err_pas_trouve EXCEPTION;
err_autre_ctl EXCEPTION;
err_nowait EXCEPTION;
-- MODIF SGN ANOVA 13,14,36
err_cal EXCEPTION;
err_dispo_rescre EXCEPTION;
err_mt_rescre EXCEPTION;
-- fin modif sgn

PRAGMA EXCEPTION_INIT(err_nowait, -00054);


/* ************************************************************************************************ */
/* Procédure qui ouvre le curseur pour vérouiller l'enregistrement qui va être mis à jour */
/* ************************************************************************************************ */
  PROCEDURE Lock_Table (p_table IN sb_situ.table_name%TYPE,
                        p_cod_mt IN sb_situ.cod_mt%TYPE,
                        p_cod_ss_code IN sb_situ.cod_ss_code%TYPE) IS
  BEGIN
    IF p_table = 'FB_AUTPRO' THEN
      OPEN c_autpro(p_cod_mt);
    ELSIF p_table = 'FB_CREDI' THEN
      OPEN c_credi(p_cod_mt,p_cod_ss_code);
    ELSIF p_table = 'FB_CREPA' THEN
      OPEN c_crepa(p_cod_mt);
    ELSIF p_table = 'FB_DEPHB' THEN
      OPEN c_dephb(p_cod_mt,p_cod_ss_code);
    ELSIF p_table = 'FB_EXCRE' THEN
      OPEN c_excre(p_cod_mt);
    ELSIF p_table = 'FB_EXECP' THEN
      OPEN c_execp(p_cod_mt);
    ELSIF p_table = 'FB_EXERE' THEN
      OPEN c_exere(p_cod_mt);
    ELSIF p_table = 'FB_EXRES' THEN
      OPEN c_exres(p_cod_mt);
    ELSIF p_table = 'FB_PRERE' THEN
      OPEN c_prere(p_cod_mt);
    ELSIF p_table = 'FB_RECHB' THEN
      OPEN c_rechb(p_cod_mt);
    ELSIF p_table = 'FB_RESER' THEN
      OPEN c_reser(p_cod_mt,p_cod_ss_code);
    /* Modif SGN du 10.07.01 */
    ELSIF p_table = 'FB_PREOP' THEN
      OPEN c_preop(p_cod_mt);
    ELSIF p_table = 'FB_EXEOP' THEN
      OPEN c_exeop(p_cod_mt);
    /* Fin Modif */
    END IF;
  END;


/* ******************************************************************************************** */
/* Procédure qui met à jour la situation ou l'insère si elle n'existe pas */
/* ******************************************************************************************** */
PROCEDURE MAJ_Table(w_table IN sb_situ.TABLE_NAME%TYPE,
                    w_mt IN fb_autpro.mt%TYPE,
                    w_cod_mt IN sb_situ.cod_mt%TYPE,
                    w_cod_ss_code IN sb_situ.cod_ss_code%TYPE,
                    w_cod_typ_mt IN sb_situ.cod_typ_mt%TYPE ) IS
BEGIN

  IF w_table = 'FB_AUTPRO' THEN
      FETCH c_autpro INTO v_autpro;
      IF c_autpro%FOUND THEN
        /* Mise a jour de la situation */
        BEGIN
          UPDATE fb_autpro
          SET mt = mt + w_mt, dat_maj = SYSDATE, uti_maj = GLOBAL.cod_util , terminal = GLOBAL.terminal
          WHERE CURRENT OF c_autpro;
        EXCEPTION
          WHEN OTHERS THEN
            /*RAISE err_maj_update; */
			raise;
        END;
      ELSE
        /* Insertion de la situation */
        BEGIN
          INSERT INTO fb_autpro VALUES
          (p_ide_poste, p_ide_ordo, p_cod_bud, p_ide_lig_prev, w_cod_mt, w_cod_typ_mt, p_var_bud, w_mt,
           SYSDATE, GLOBAL.cod_util, SYSDATE, GLOBAL.cod_util, GLOBAL.terminal );
        EXCEPTION
          WHEN OTHERS THEN
            /*RAISE err_maj_insert;*/
			raise;
        END;
      END IF;
      CLOSE c_autpro;

  ELSIF w_table = 'FB_CREDI' THEN
      FETCH c_credi INTO v_credi;
      IF c_credi%FOUND THEN
        /* Mise a jour de la situation */
        BEGIN
          UPDATE fb_credi
          SET mt = mt + w_mt, dat_maj = SYSDATE, uti_maj = GLOBAL.cod_util , terminal = GLOBAL.terminal
          WHERE CURRENT OF c_credi;
        EXCEPTION
          WHEN OTHERS THEN
            /*RAISE err_maj_update;*/
			raise;
        END;
      ELSE
        /* Insertion de la situation */
        BEGIN
          INSERT INTO fb_credi VALUES
          (p_ide_poste, p_ide_ordo, p_cod_bud, p_ide_lig_prev, p_ide_gest, w_cod_mt, w_cod_ss_code, w_cod_typ_mt, p_var_bud, w_mt,
           SYSDATE, GLOBAL.cod_util, SYSDATE, GLOBAL.cod_util, GLOBAL.terminal );
        EXCEPTION
          WHEN OTHERS THEN
            /*RAISE err_maj_insert;*/
			raise;
        END;
      END IF;
      CLOSE c_credi;

    ELSIF w_table = 'FB_CREPA' THEN
        FETCH c_crepa INTO v_crepa;
        IF c_crepa%FOUND THEN
          /* Mise a jour de la situation */
          BEGIN
            UPDATE fb_crepa
            SET mt = mt + w_mt, dat_maj = SYSDATE, uti_maj = GLOBAL.cod_util , terminal = GLOBAL.terminal
            WHERE CURRENT OF c_crepa;
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_update;*/
			  raise;
          END;
        ELSE
          /* Insertion de la situation */
          BEGIN
            INSERT INTO fb_crepa VALUES
            (p_ide_poste, p_ide_ordo, p_cod_bud, p_ide_lig_prev, p_ide_gest, w_cod_mt, p_var_bud, w_cod_typ_mt, w_mt,
             SYSDATE, GLOBAL.cod_util, SYSDATE, GLOBAL.cod_util, GLOBAL.terminal );
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_insert;*/
			  raise;
          END;
        END IF;
	CLOSE c_crepa;

    ELSIF w_table = 'FB_DEPHB' THEN
	FETCH c_dephb INTO v_dephb;
        IF c_dephb%FOUND THEN
          /* Mise a jour de la situation */
          BEGIN
            UPDATE fb_dephb
            SET mt = mt + w_mt, dat_maj = SYSDATE, uti_maj = GLOBAL.cod_util , terminal = GLOBAL.terminal
            WHERE CURRENT OF c_dephb;
          EXCEPTION
            WHEN OTHERS THEN
              /* RAISE err_maj_update; */
			  raise;
          END;
        ELSE
          /* Insertion de la situation */
          BEGIN
            INSERT INTO fb_dephb VALUES
            (p_ide_poste, p_ide_ordo, p_cod_bud, p_ide_ope, w_cod_mt, w_cod_ss_code, p_var_bud, w_cod_typ_mt, w_mt,
             SYSDATE, GLOBAL.cod_util, SYSDATE, GLOBAL.cod_util, GLOBAL.terminal );
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_insert;*/
			  raise;
          END;
        END IF;
	CLOSE c_dephb;

    ELSIF w_table = 'FB_EXCRE' THEN
	FETCH c_excre INTO v_excre;
        IF c_excre%FOUND THEN
          /* Mise a jour de la situation */
          BEGIN
            UPDATE fb_excre
            SET mt = mt + w_mt, dat_maj = SYSDATE, uti_maj = GLOBAL.cod_util , terminal = GLOBAL.terminal
            WHERE CURRENT OF c_excre;
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_update;*/
			  raise;
          END;
        ELSE
          /* Insertion de la situation */
          BEGIN
            INSERT INTO fb_excre VALUES
            (p_ide_poste, p_ide_ordo, p_cod_bud, p_ide_lig_exec, p_ide_gest, w_cod_mt, p_var_bud, w_cod_typ_mt, w_mt,
             SYSDATE, GLOBAL.cod_util, SYSDATE, GLOBAL.cod_util, GLOBAL.terminal );
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_insert;*/
			  raise;
          END;
        END IF;
	CLOSE c_excre;

    ELSIF w_table = 'FB_EXECP' THEN
	FETCH c_execp INTO v_execp;
        IF c_execp%FOUND THEN
          /* Mise a jour de la situation */
          BEGIN
            UPDATE fb_execp
            SET mt = mt + w_mt, dat_maj = SYSDATE, uti_maj = GLOBAL.cod_util , terminal = GLOBAL.terminal
            WHERE CURRENT OF c_execp;
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_update;*/
			  raise;
          END;
        ELSE
          /* Insertion de la situation */
          BEGIN
            INSERT INTO fb_execp VALUES
            (p_ide_poste, p_ide_ordo, p_cod_bud, p_ide_lig_exec, p_ide_gest, w_cod_mt, p_var_bud, w_cod_typ_mt, w_mt,
             SYSDATE, GLOBAL.cod_util, SYSDATE, GLOBAL.cod_util, GLOBAL.terminal );
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_insert;*/
			  raise;
          END;
        END IF;
	CLOSE c_execp;

    ELSIF w_table = 'FB_EXERE' THEN
	FETCH c_exere INTO v_exere;
        IF c_exere%FOUND THEN
          /* Mise a jour de la situation */
          BEGIN
            UPDATE fb_exere
            SET mt = mt + w_mt, dat_maj = SYSDATE, uti_maj = GLOBAL.cod_util , terminal = GLOBAL.terminal
            WHERE CURRENT OF c_exere;
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_update;*/
			  raise;
          END;
        ELSE
          /* Insertion de la situation */
          BEGIN
            INSERT INTO fb_exere VALUES
            (p_ide_poste, p_ide_ordo, p_cod_bud, p_ide_lig_exec, p_ide_gest, w_cod_mt, p_var_bud, w_cod_typ_mt, w_mt,
             SYSDATE, GLOBAL.cod_util, SYSDATE, GLOBAL.cod_util, GLOBAL.terminal );
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_insert;*/
			  raise;
          END;
        END IF;
	CLOSE c_exere;

    ELSIF w_table = 'FB_EXRES' THEN
	FETCH c_exres INTO v_exres;
        IF c_exres%FOUND THEN
          /* Mise a jour de la situation */
          BEGIN
            UPDATE fb_exres
            SET mt = mt + w_mt, dat_maj = SYSDATE, uti_maj = GLOBAL.cod_util , terminal = GLOBAL.terminal
            WHERE CURRENT OF c_exres;
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_update;*/
			  raise;
          END;
        ELSE
          /* Insertion de la situation */
          BEGIN
            INSERT INTO fb_exres VALUES
            (p_ide_poste, p_ide_ordo, p_cod_bud, p_ide_lig_exec, p_ide_ope, w_cod_mt, p_var_bud, w_cod_typ_mt, w_mt,
             SYSDATE, GLOBAL.cod_util, SYSDATE, GLOBAL.cod_util, GLOBAL.terminal );
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_insert;*/
			  raise;
          END;
        END IF;
	CLOSE c_exres;

    ELSIF w_table = 'FB_PRERE' THEN
	FETCH c_prere INTO v_prere;
        IF c_prere%FOUND THEN
          /* Mise a jour de la situation */
          BEGIN
            UPDATE fb_prere
            SET mt = mt + w_mt, dat_maj = SYSDATE, uti_maj = GLOBAL.cod_util , terminal = GLOBAL.terminal
            WHERE CURRENT OF c_prere;
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_update;*/
			  raise;
          END;
        ELSE
          /* Insertion de la situation */
          BEGIN
            INSERT INTO fb_prere VALUES
            (p_ide_poste, p_ide_ordo, p_cod_bud, p_ide_lig_prev, p_ide_gest, w_cod_mt, p_var_bud, w_cod_typ_mt, w_mt,
             SYSDATE, GLOBAL.cod_util, SYSDATE, GLOBAL.cod_util, GLOBAL.terminal );
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_insert;*/
			  raise;
          END;
        END IF;
	CLOSE c_prere;

    ELSIF w_table = 'FB_RECHB' THEN
	FETCH c_rechb INTO v_rechb;
        IF c_rechb%FOUND THEN
          /* Mise a jour de la situation */
          BEGIN
            UPDATE fb_rechb
            SET mt = mt + w_mt, dat_maj = SYSDATE, uti_maj = GLOBAL.cod_util , terminal = GLOBAL.terminal
            WHERE CURRENT OF c_rechb;
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_update;*/
			  raise;
          END;
        ELSE
          /* Insertion de la situation */
          BEGIN
            INSERT INTO fb_rechb VALUES
            (p_ide_poste, p_ide_ordo, p_cod_bud, p_ide_ope, w_cod_mt, p_var_bud, w_cod_typ_mt, w_mt,
             SYSDATE, GLOBAL.cod_util, SYSDATE, GLOBAL.cod_util, GLOBAL.terminal );
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_insert;*/
			  raise;
          END;
        END IF;
	CLOSE c_rechb;

    ELSIF w_table = 'FB_RESER' THEN
	FETCH c_reser INTO v_reser;
        IF c_reser%FOUND THEN
          /* Mise a jour de la situation */
          BEGIN
            UPDATE fb_reser
            SET mt = mt + w_mt, dat_maj = SYSDATE, uti_maj = GLOBAL.cod_util , terminal = GLOBAL.terminal
            WHERE CURRENT OF c_reser;
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_update;*/
			  raise;
	  END;
	ELSE
          /* Insertion de la situation */
          BEGIN
			INSERT INTO fb_reser VALUES
            (p_ide_poste, p_ide_ordo, p_cod_bud, p_ide_lig_prev, p_ide_ope, w_cod_mt, w_cod_ss_code, p_var_bud, w_cod_typ_mt, w_mt,
             SYSDATE, GLOBAL.cod_util, SYSDATE, GLOBAL.cod_util, GLOBAL.terminal );
		  EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_insert;*/
			  raise;
          END;
        END IF;
	CLOSE c_reser;

	/* Modif SGN du 10.07.01 Gestion de table FB_PREOP et FB_EXEOP */
	ELSIF w_table = 'FB_PREOP' THEN
    FETCH c_preop INTO v_preop;
        IF c_preop%FOUND THEN
          /* Mise a jour de la situation */
          BEGIN
            UPDATE fb_preop
            SET mt = mt + w_mt, dat_maj = SYSDATE, uti_maj = GLOBAL.cod_util , terminal = GLOBAL.terminal
            WHERE CURRENT OF c_preop;
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_update;*/
			  raise;
          END;
        ELSE
          /* Insertion de la situation */
          BEGIN
            INSERT INTO fb_preop(ide_poste, ide_ordo, cod_bud, ide_lig_prev,
			                     ide_ope, ide_gest, cod_typ_mt, cod_mt, mt,
								 dat_cre, uti_cre, dat_maj, uti_maj, terminal)
			VALUES (p_ide_poste, p_ide_ordo, p_cod_bud, p_ide_lig_prev,
			        p_ide_ope, p_ide_gest, w_cod_typ_mt, w_cod_mt, w_mt,
                    SYSDATE, GLOBAL.cod_util, SYSDATE, GLOBAL.cod_util, GLOBAL.terminal );
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_insert;*/
			  raise;
          END;
        END IF;
	CLOSE c_preop;

	ELSIF w_table = 'FB_EXEOP' THEN
    FETCH c_exeop INTO v_exeop;
        IF c_exeop%FOUND THEN
          /* Mise a jour de la situation */
          BEGIN
            UPDATE fb_exeop
            SET mt = mt + w_mt, dat_maj = SYSDATE, uti_maj = GLOBAL.cod_util , terminal = GLOBAL.terminal
            WHERE CURRENT OF c_exeop;
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_update;*/
			  raise;
          END;
        ELSE
          /* Insertion de la situation */
          BEGIN
            INSERT INTO fb_exeop(ide_poste, ide_ordo, cod_bud, ide_lig_exec,
			                     ide_ope, ide_gest, cod_typ_mt, cod_mt, mt,
								 dat_cre, uti_cre, dat_maj, uti_maj, terminal)
             VALUES(p_ide_poste, p_ide_ordo, p_cod_bud, p_ide_lig_exec,
			        p_ide_ope, p_ide_gest, w_cod_typ_mt, w_cod_mt, w_mt,
             SYSDATE, GLOBAL.cod_util, SYSDATE, GLOBAL.cod_util, GLOBAL.terminal );
          EXCEPTION
            WHEN OTHERS THEN
              /*RAISE err_maj_insert;*/
			  raise;
          END;
        END IF;
	CLOSE c_exeop;
	/* fin modif */

  END IF;

END;

/* ******************************************************************************************** */
/* ******************************************************************************************** */
/* ******************************************************************************************** */

BEGIN

  /* Initialisation de la variable retour */
  p_retour := 0;


  /* ******************************************************************************************** */
  /* Recherche de la ligne de prévision si nécessaire */
  /* ******************************************************************************************** */
  IF p_ide_lig_exec IS NOT NULL AND p_ide_lig_prev IS NULL THEN
    BEGIN
      SELECT A.ide_lig_prev INTO p_ide_lig_prev
      FROM fn_ligne_bud_exec A
      WHERE A.var_bud = p_var_bud AND A.ide_lig_exec = p_ide_lig_exec;
    EXCEPTION
      /*WHEN OTHERS THEN*/
	    WHEN NO_DATA_FOUND THEN
        RAISE err_ext_lig_bud_prev;
    END;
  END IF;


  /* ******************************************************************************************** */
  /* Recherche du code de la nature des crédits si nécessaire */
  /* ******************************************************************************************** */
  IF p_cod_nat_cr IS NULL AND p_ide_lig_prev IS NOT NULL THEN
    /* Recherche de p_cod_nat_cr dans fn_ligne_bud_prev */
    BEGIN
      SELECT cod_nat_cr INTO v_cod_nat_cr FROM fn_ligne_bud_prev
      WHERE var_bud = p_var_bud AND ide_lig_prev = p_ide_lig_prev;
    EXCEPTION
      /*WHEN OTHERS THEN*/
	    WHEN NO_DATA_FOUND THEN
        RAISE err_ext_cod_nat_cr;
    END;
    /* Transformation en code interne */
    IF v_cod_nat_cr IS NOT NULL THEN
      EXT_Codint('NAT_CREDIT',v_cod_nat_cr,v_libl,v_ide_nat_cr,v_ret);
      IF v_ret < 1 THEN
        RAISE err_ext_codint;
      END IF;
    END IF;
    p_cod_nat_cr := v_ide_nat_cr;
  END IF;

  -- MODIF SGN ANOVA 13,14,36 : Ajout du sous type de piece lors de l appel a ext_cod_ope
  /* Appel à EXT_Cod_Ope */
  EXT_Cod_Ope(p_cod_type,p_ide_ope,p_ide_lig_prev,p_mt,p_mt_bud,v_cod_ope1,v_cod_ope2,v_mt_cod1,v_mt_cod2,v_ret, p_ide_ss_type);
  IF v_ret != 1 THEN
    RAISE err_ext_cod_ope;
  END IF;
  /* ******************************************************************************************** */
  /* Parcours des enregistrements de SB_situ sélectionnés avec v_cod_ope1 et v_cod_ope2 */
  /* pour verrouillage des enregistrements à mettre à jour */
  /* ******************************************************************************************** */
  FOR v_situ IN c_situ(v_cod_ope1) LOOP
    p_retour := 1;
    Lock_Table(v_situ.table_name,v_situ.cod_mt,v_situ.cod_ss_code);
  END LOOP;
  IF p_retour != 1 THEN
    RAISE err_pas_trouve;
  END IF;

  IF v_cod_ope2 IS NOT NULL THEN
    p_retour := 0;
    FOR v_situ IN c_situ(v_cod_ope2) LOOP
	  p_retour := 1;
      Lock_Table(v_situ.table_name,v_situ.cod_mt,v_situ.cod_ss_code);
    END LOOP;
    IF p_retour != 1 THEN
      RAISE err_pas_trouve;
    END IF;
  END IF;



  /* ******************************************************************************************** */
  /* Traitement pour v_cod_ope1 */
  /* ******************************************************************************************** */
  IF p_cod_nat_cr = 'L' THEN
    /* Contrôles des disponibles */
    FOR v_situ IN c_situ(v_cod_ope1) LOOP
      v_ret_ctl := CTL_Situations( v_cod_ope1,p_cod_orig_benef,p_ide_poste,
                                   p_ide_ordo,p_cod_bud,p_var_bud,v_mt_cod1,
                                   p_ide_gest,p_ide_lig_prev,p_ide_ope,v_situ.table_name );
      IF  v_ret_ctl = -2 THEN
        RAISE err_dispo;
	  ELSIF v_ret_ctl = -3 THEN
	    RAISE err_cal;
	  ELSIF v_ret_ctl = -4 THEN
	    RAISE err_dispo_rescre;
	  ELSIF v_ret_ctl = -5 THEN
  	    RAISE err_mt_rescre;
      ELSIF v_ret_ctl != 1 THEN
        RAISE err_autre_ctl;
      END IF;
    END LOOP;
  END IF;
  FOR v_situ IN c_situ(v_cod_ope1) LOOP
    /* Mise à jour ou insertion dans les tables de situation */
    MAJ_Table(v_situ.table_name, v_mt_cod1, v_situ.cod_mt, v_situ.cod_ss_code, v_situ.cod_typ_mt );
  END LOOP;

  IF v_cod_ope2 IS NOT NULL THEN
    /* ******************************************************************************************** */
    /* Traitement pour v_cod_ope2 */
    /* ******************************************************************************************** */
    IF p_cod_nat_cr = 'L' THEN
      FOR v_situ IN c_situ(v_cod_ope2) LOOP
        /* Contrôles des disponibles */
        v_ret_ctl := CTL_Situations( v_cod_ope2,p_cod_orig_benef,p_ide_poste,
                                     p_ide_ordo,p_cod_bud,p_var_bud,v_mt_cod2,
                                     p_ide_gest,p_ide_lig_prev,p_ide_ope,v_situ.table_name );
        IF v_ret_ctl = -2 THEN
          RAISE err_dispo;
        ELSIF v_ret_ctl = -3 THEN
	      RAISE err_cal;
	    ELSIF v_ret_ctl = -4 THEN
	      RAISE err_dispo_rescre;
	    ELSIF v_ret_ctl = -5 THEN
  	      RAISE err_mt_rescre;
	    ELSIF v_ret_ctl != 1 THEN
          RAISE err_autre_ctl;
        END IF;

      END LOOP;
    END IF;
    FOR v_situ IN c_situ(v_cod_ope2) LOOP
      /* Mise à jour ou insertion dans les tables de situation */
      MAJ_Table(v_situ.table_name, v_mt_cod2, v_situ.cod_mt, v_situ.cod_ss_code, v_situ.cod_typ_mt );
    END LOOP;
  END IF;

EXCEPTION
  WHEN err_pas_trouve THEN
    /* aucun enregistrement trouvé dans sb_situ avec le code opération et le code orig/benef donné */
    p_retour := 0;
  WHEN err_autre_ctl THEN
    /* erreur lors du calcul du disponible */
    p_retour := -13;
  WHEN err_mt_rescre THEN
    /* erreur lors du calcul du disponible */
    p_retour := -12;
  WHEN err_dispo_rescre THEN
    /* erreur lors du calcul du disponible */
    p_retour := -11;
  WHEN err_cal THEN
    /* erreur lors du calcul du disponible */
    p_retour := -10;
  WHEN err_ext_lig_bud_prev THEN
    p_retour := -9;
  WHEN err_ext_cod_nat_cr THEN
    p_retour := -8;
  WHEN err_ext_codint THEN
    p_retour := -7;
  WHEN err_nowait THEN
    /* Verrouillage impossible des enregistrements à mettre à jour */
    p_retour := -6;
  WHEN err_ext_cod_ope THEN
    /* erreur lors de l'extraction des codes opérations */
    p_retour := -5;
  WHEN err_dispo THEN
    /* disponible insuffisant */
    --p_retour := -4;  /* Modification MBOUKE pour éviter Test de disponibilité par rapport a l'engagement */
	p_retour := 1;
  WHEN err_maj_update THEN
    /* erreur lors de la mise à jour de la ligne de situation  */
    p_retour := -3;
  WHEN err_maj_insert THEN
    /* erreur lors de l'insertion de la ligne de situation */
    p_retour := -2;
  WHEN OTHERS THEN
    p_retour := -1;
	raise;

END MAJ_Situations_B;

/

CREATE OR REPLACE PROCEDURE ANNUL_ORDONNANCE (
--=========================== ANNUL_ORDONNANCE=====================================================
--  Sujet    : Procédure permettant l'alimentation des tables de la base de
--      données pour une annulation totale, partielle ou une ré-imputation
--      d'ordonnance. Cette procédure doit intervenir après un controle des données
--      de l'annulation. En fin de procédure, la forme appellante a à sa charge l'appel
--      a la fonction bibliothèque MAJ_Decpiece ainsi que le repositionnement via go_item.
--      Tout les montants fournis à la procédure sont passé en devise de référence.
--  Instance : CAD
--  Créé le  : 08/06/2007 par FBT
--  Version  : v4210
--  Entrée  : p_ide_poste (identifiant du poste comptable)
--      p_ide_typ_poste (Identifiant du type de poste comptable)
--      p_ide_gest (identifiant de la gestion)
--      p_ide_ordo (identifiant de l'ordonnateur)
--      p_cod_bud (code budget)
--      p_ide_piece (identfiant de la piece)
--      p_cod_type_piece (type de piece)
--      p_flg_pec (génération ecriture de prise en chage)
--      p_ide_ss_type (identifiant du sous type de piece)
--      p_var_cpta (variation comptable)
--      p_date_jc (date de journée comptable)
--      p_date_emis (date d'emmision)
--      p_date_recp (date de réception)
--      p_date_cf
--      p_ide_piece_init (Identifiant de la piece initial)
--      p_ide_devise (Identifiant de la devise)
--      p_ide_devise_ref (Identifiant de la devise) de référence)
--      p_val_taux (Taux courant de la devise)
--      p_cod_typ_nd (identifiant du type de noeud)
--      p_no_bord_orig (numéro du bordereau d'origine : ide mes)
--      p_flg_emis_recu (flag indiquant si le reglement est emis ou recu)
--      p_flg_engagt (indicateur ordonnance indique que la pièce et rattaché à un engagement)
--      p_flg_reimp (indique si l'appel de la procédure ce fait dans le cadre d'une réimputation 'O' pour oui 'T' pour annulation totale et 'P' annulation pour partiel )
--      p_objet (objet de l'annulation)
--      p_flg_cf_oui
--      p_ide_ope (identifiant de l'opération)
--      p_flag_reglement (flag de génération d'un règlement)
--      p_lst_ligne (liste des modifs de montant en devise de référence dans le cadre d'une annulation partielle ex : 25,4-58,7-N-57,7 N pour non modifié)
--      p_lst_ligne_B (liste des modifs de montant en devise de référence hors budget dans le cadre d'une annulation partielle ex : 25,4-58,7-N-57,7 N pour non modifié)
--      p_lst_tiers (liste des modifs de montant en devise de référence sur ligne tiers dans le cadre d'une annulation partielle ex : 25,4-58,7-N-57,7 N pour non modifié)
--      p_lst_ligne_dev (liste des modifs de montant en devise local dans le cadre d'une annulation partielle ex : 25,4-58,7-N-57,7 N pour non modifié)
--      p_lst_ligne_B_dev (liste des modifs de montant en devise local hors budget dans le cadre d'une annulation partielle ex : 25,4-58,7-N-57,7 N pour non modifié)
--      p_lst_tiers_dev (liste des modifs de montant en devise local sur ligne tiers dans le cadre d'une annulation partielle ex : 25,4-58,7-N-57,7 N pour non modifié)
--      p_new_op (numero d'opération pour l'opération, null si inchangé)
--      p_new_exec (ligne d'execution pour la réimpuation, null si inchangé)
--      p_new_eng  (numero d'engagement la réimpuation, null si inchangé)
--      p_new_mt  (montant de la réimpuation, null si inchangé)
--      p_new_mt_bud (montant budget de la réimpuation, null si inchangé)
--      p_new_cpt (compte de la réimpuation, null si inchangé)
--      p_new_cpt (compte tiers de la réimpuation, null si inchangé)
--      p_new_spec1 (spécification1 de la réimputation, null si inchangé)
--      p_new_cpt_aux (compte auxiliaire de la réimputation, null si inchangé)
--      p_id_ligne (numero de ligne budgétaire à réimputer,  null si non concerné)
--      p_id_creancier (numero de créancier à réimputer,  null si non concerné)
--      p_code_util (code utilisateur)
--      p_terminal (terminal utilisé)
--
-- Sortie  : p_retour (0 : OK, X : Erreurs, numéro du message a afficher )
--      p_text_retour1 (text du paramètre1 de message de retour)
--      p_text_retour2 (text du paramètre2 de message de retour)
--      p_text_retour3 (text du paramètre3 de message de retour)
--
-- Entré/Sor:
--       p_inout_ide_ecr2 (identifiant de l'écriture d'équilibrage - pour les réimputations)
--       p_inout_ide_jal2 (journal de l'écriture d'équilibrage - pour les réimputations)
--       p_inout_dat_ecr2 (date de l'écriture d'équilibrage - pour les réimputations)
--  Table des codes retour :
--       1  -> Message 1
--       2  -> Message 472
--       3  -> Message 567
--       4  -> Message 6
--       5  -> Message 159
--       6  -> Message 314
--       7  -> Message 282
--       8  -> Message 282
--       9  -> Message 59
--       10 -> Message 872
--       11 -> Message 871
--       12 -> Message 870
--       13 -> Message 868
--       14 -> Message 869
--       15 -> Message 873
--       16 -> Message 866
--       17 -> Message 915
--       18 -> Message 796
--       19 -> Message 58
--       20 -> Message 59
--       21 -> Message 795
--       22 -> Message 797
--       23 -> Message 803
--       24 -> Message 802
--       25 -> Message 631
--       26 -> Message 914
--       27 -> Message 913
--       28 -> Message 913
--       29 -> Message 913
--       30 -> Message 913
--       31 -> Message 913
--       32 -> Message 913
--       33 -> Message 913
--       34 -> Message 913
--       35 -> Message 915
--       36 -> Message 116
--       37 -> Message 58
--       38 -> Message 59
--       39 -> Message 803
--       40 -> Message 802
--       41 -> Message 797
--       42 -> Message 631
--       43 -> Message 914
--       44 -> Message 913
--       45 -> Message 913
--       46 -> Message 913
--       47 -> Message 913
--       48 -> Message 913
--       49 -> Message 913
--       50 -> Message 913
--       51 -> Message 913
--       52 -> Message 58
--       53 -> Message 829
--       54 -> Message 105
--       55 -> Message 105
--       56 -> Message 7
--       57 -> Message 1138
--       58 -> Message 787.
--       9999 -> Message 105
--
--
--====================== HISTORIQUE DES MODIFICATIONS =============================================
--  Date        Version  Aut. Evolution Sujet
--  -----------------------------------------------------------------------------------------------
--  08/06/2007 v4210  FBT Création de la procédure pour l'évolution DI44-01-2007
--  23/10/2007 v4211  FBT Correction de l'anomalie 114
--  23/10/2007 v4211  FBT Correction de l'anomalie 116
--  24/10/2007 v4211  FBT Correction de l'anomalie 119
--  06/11/2007 v4211  FBT Correction de l'anomalie 125
--  09/11/2007 v4211  FBT EVOL_DI44_CC_2007_001
--  13/11/2007 v4211  FBT Correction de l'anomalie 132
--  13/11/2007 v4211  FBT Correction de l'anomalie 136
--  14/11/2007 v4211  FBT Correction de l'anomalie 127
--  15/11/2007 v4211  FBT Correction de l'anomalie 142
--  29/11/2007 v4211  FBT Correction de l'anomalie 159
--  29/11/2007 v4211  FBT Correction de l"anomalie 161
--  30/11/2007 V4211  FBT Correction de l'anomalie 164
--  10/12/2007 v4211  FBT Correction de l'anomalie 167
--  12/12/2007 V4211  FBT Correction de l'anomalie 171
--  27/03/2008 V4250  PGE EVOL_DI44_CC_2007_010 : Valoriser FC_REF_PIECE.dat_der_mvt avec la date de journée comptable de comptabilisation de l'écriture
--  07/04/2008 V4250  PGE EVOL_DI44_CC_2007_010 : Empeche la modification de mt_cr ou mt_db si cela inverse le sens du solde de la pièce.
--  15/05/2008 v4260  PGE EVOL_DI44_CC_2008_014 : Controle sur les dates de validité de RC_MODELE_LIGNE
--  16/02/2009 v4280  FBT EVOL_DI44_CC_2009_022 : Enregistrement du numéro exact de ligne et de tiers dans les AD afin de déterminer les disponibles ligne à ligne
--=================================================================================================

  p_ide_poste       IN        RM_POSTE.IDE_POSTE%Type,
  p_ide_typ_poste   IN        RM_POSTE.IDE_TYP_POSTE%Type,
  p_ide_gest    IN        FN_GESTION.IDE_GEST%Type,
  p_ide_ordo    IN        RB_ORDO.IDE_ORDO%Type,
  p_cod_bud    IN        RN_BUDGET.COD_BUD%Type,
  p_ide_piece    IN        FB_PIECE.IDE_PIECE%Type,
  p_cod_type_piece   IN        FB_PIECE.COD_TYP_PIECE%Type,
  p_flg_pec    IN        VARCHAR2,
  p_ide_ss_type   IN        PB_SS_TYPE_PIECE.IDE_SS_TYPE%Type,
  p_var_cpta   IN        RC_SCHEMA_CPTA.VAR_CPTA%Type,
  p_date_jc    IN        FC_ECRITURE.DAT_JC%Type,
  p_date_emis   IN        FB_PIECE.DAT_EMIS%Type,
  p_date_recp   IN        FB_PIECE.DAT_RECEPTION%Type,
  p_date_cf    IN        FB_PIECE.DAT_CF%Type,
  p_ide_piece_init  IN        FB_PIECE.IDE_PIECE_INIT%Type,
  p_ide_devise   IN        FB_PIECE.IDE_DEVISE%Type,
  p_ide_devise_ref  IN        FB_PIECE.IDE_DEVISE%Type,
  p_val_taux   IN        FB_PIECE.VAL_TAUX%Type,
  p_cod_typ_nd   IN        RM_NOEUD.COD_TYP_ND%Type,
  p_no_bord_orig  IN        FC_REGLEMENT.IDE_MESS%Type,
  p_flg_emis_recu  IN        FC_REGLEMENT.FLG_EMIS_RECU%Type,
  p_flg_engagt   IN        VARCHAR2,
  p_flg_reimp   IN        VARCHAR2,
  p_objet    IN        FB_PIECE.OBJET%Type,
  p_flg_cf_oui   IN        VARCHAR2,
  p_ide_ope    IN        FB_RESER.IDE_OPE%Type,
  p_flag_reglement  IN        VARCHAR2,
  p_lst_ligne     IN     VARCHAR2,
  p_lst_ligne_B   IN     VARCHAR2,
  p_lst_tiers    IN     VARCHAR2,
  p_lst_ligne_dev     IN     VARCHAR2,
  p_lst_ligne_B_dev   IN     VARCHAR2,
  p_lst_tiers_dev    IN     VARCHAR2,
  p_new_op    IN     VARCHAR2,
  p_new_exec   IN     VARCHAR2,
  p_new_eng    IN     VARCHAR2,
  p_new_mt    IN     NUMBER,
  p_new_mt_bud   IN OUT    NUMBER,
  p_new_cpt    IN     VARCHAR2,
  p_new_cpt_tiers  IN     VARCHAR2,
  p_new_spec1   IN     VARCHAR2,
  p_new_cpt_aux   IN     VARCHAR2,
  p_id_ligne    IN     NUMBER,
  p_id_creancier  IN     NUMBER,
  p_code_util   IN        FH_UTIL.COD_UTIL%Type,
  p_terminal   IN        VARCHAR2,
  p_out_retour       OUT       NUMBER,
  p_out_text_retour1 OUT       VARCHAR2,
  p_out_text_retour2 OUT       VARCHAR2,
  p_out_text_retour3 OUT       VARCHAR2,
  p_inout_ide_ecr2  IN OUT    FC_ECRITURE.ide_ecr%TYPE,
  p_inout_ide_jal2  IN OUT    FC_ECRITURE.ide_jal%TYPE,
  p_inout_dat_ecr2  IN OUT    FC_ECRITURE.dat_ecr%TYPE
) IS

  -------------------------------------------------------------------------------------------------
  -----------------------------------------DECLARATIONS--------------------------------------------
  -------------------------------------------------------------------------------------------------

  v_ide_ecr             FC_ECRITURE.ide_ecr%TYPE;
  v_ide_ecr2            FC_ECRITURE.ide_ecr%TYPE;
  v_ide_jal             FC_ECRITURE.ide_jal%TYPE;
  v_ide_jal2            FC_ECRITURE.ide_jal%TYPE;
  v_dat_ecr             FC_ECRITURE.dat_ecr%TYPE;
  v_dat_ecr2            FC_ECRITURE.dat_ecr%TYPE;

  v_ide_poste           FB_PIECE.ide_poste%TYPE;
  v_ide_gest            FB_PIECE.ide_gest%TYPE;
  v_ide_piece           FB_PIECE.ide_piece%TYPE;
  v_cod_typ_piece       FB_PIECE.cod_typ_piece%TYPE;
  v_ide_ordo            FB_PIECE.ide_ordo%TYPE;
  v_cod_bud             FB_PIECE.cod_bud%TYPE;
  v_dat_cf              FB_PIECE.dat_cf%TYPE;

  v_mt                  FB_LIGNE_PIECE.mt%TYPE;
  v_mt_bud              FB_LIGNE_PIECE.mt_bud%TYPE;
  v_mt_dev              FB_LIGNE_PIECE.mt_dev%TYPE;
  v_mt_bud_dev          FB_LIGNE_PIECE.mt_bud_dev%TYPE;
  v_ide_lig_prev        FB_LIGNE_PIECE.ide_lig_prev%TYPE;
  v_ide_lig_exec        FB_LIGNE_PIECE.ide_lig_exec%TYPE;
  v_var_bud             FB_LIGNE_PIECE.var_bud%TYPE;
  v_ide_cpt             FB_LIGNE_PIECE.ide_cpt%TYPE;
  v_ide_cpt_hb          FB_LIGNE_PIECE.ide_cpt_hb%TYPE;
  v_mt_f                FB_LIGNE_PIECE.mt%TYPE;
  v_mt_bud_f            FB_LIGNE_PIECE.mt_bud%TYPE;
  v_mt_dev_f            FB_LIGNE_PIECE.mt_dev%TYPE;
  v_mt_bud_dev_f        FB_LIGNE_PIECE.mt_bud_dev%TYPE;

  v_ide_ref_piece       FB_LIGNE_TIERS_PIECE.ide_ref_piece%TYPE;
  v_ide_tiers           FB_LIGNE_TIERS_PIECE.ide_tiers%TYPE;
  v_cpt_bq              FB_LIGNE_TIERS_PIECE.cpt_bq%TYPE;
  v_mtt_retenu_oppo     FB_LIGNE_TIERS_PIECE.mtt_retenue_oppo%TYPE;
  v_var_tiers           FB_LIGNE_TIERS_PIECE.var_tiers%TYPE;
  v_num_lig_ligne_tiers FB_LIGNE_TIERS_PIECE.num_lig%TYPE;
  v_num_bq              FB_LIGNE_TIERS_PIECE.cpt_bq%TYPE;
  v_spec1               FB_LIGNE_TIERS_PIECE.spec1%TYPE;
  v_nom_tiers           FB_LIGNE_TIERS_PIECE.Nom%TYPE;
  v_prenom_tiers        FB_LIGNE_TIERS_PIECE.Prenom%TYPE;
  v_ide_plan_aux        FB_LIGNE_TIERS_PIECE.ide_plan_aux%TYPE;
  v_ide_cpt_aux         FB_LIGNE_TIERS_PIECE.ide_cpt_aux%TYPE;
  v_lib_objet_piece     FB_LIGNE_TIERS_PIECE.lib_objet_reglt%TYPE;
  v_mt_dev_tiers        FB_LIGNE_TIERS_PIECE.mt_dev%Type;
  v_mtt_retenu_oppo_f   FB_LIGNE_TIERS_PIECE.mtt_retenue_oppo%TYPE;
  v_mt_dev_tiers_f      FB_LIGNE_TIERS_PIECE.mt_dev%Type;

  v_ide_mod_reglt       FC_REGLEMENT.ide_mod_reglt%TYPE;
  v_ide_reglt           FC_REGLEMENT.ide_reglt%TYPE;
  v_nom_bq              FC_REGLEMENT.nom_bq%TYPE;
  v_cod_ref_piece_s     FC_REGLEMENT.cod_ref_piece%TYPE;
  v_cod_ref_piece       FC_REGLEMENT.cod_ref_piece%TYPE;

  v_ide_eng             FB_ENG.ide_eng%TYPE;

  v_cod_nat_cr          SR_CODIF.ide_codif%TYPE;

  v_ss_typ_reimp_ab  	SR_PARAM.val_param%TYPE;
  v_journal_reimp_ab  	PC_PRISE_CHARGE.IDE_JAL%TYPE;
  v_schema_reimp_ab  	PC_PRISE_CHARGE.IDE_SCHEMA%TYPE;

  v_num_lig_s           FC_LIGNE.ide_lig%TYPE;
  v_ide_ref_piece2      FC_LIGNE.ide_ref_piece%TYPE;

  v_num_lig             NUMBER :=0;
  v_num_lig_current     NUMBER :=0;
  v_ret                 NUMBER :=0;
  v_exist               NUMBER :=0;
  v_temp                NUMBER :=0;
  v_temp3               NUMBER :=0;

  v_val_flg_cf          VARCHAR2(1);
  v_temp2               VARCHAR2(200) :='';
  v_temp4               VARCHAR2(200) :='';
  v_pec1                VARCHAR2(200);
  v_pec2                VARCHAR2(200);
  v_abo1                VARCHAR2(200);
  v_abo2                VARCHAR2(200);
  v_flg_schema_reimp    VARCHAR2(200);

  v_codif_libl          VARCHAR2(200);
  v_codif_oui           VARCHAR2(200);
  v_codif_vi            VARCHAR2(200);
  v_codif_od            VARCHAR2(200);
  v_codif_ad            VARCHAR2(200);
  v_codif_rj            VARCHAR2(200);
  v_codif_debit         VARCHAR2(200);
  v_codif_pectiers      VARCHAR2(200);
  v_codif_creation      VARCHAR2(200);
  v_codif_signe_p       VARCHAR2(200);
  v_codif_signe_n       VARCHAR2(200);
  v_codif_abo           VARCHAR2(200);
  v_codif_pecoposant    VARCHAR2(200);

  KO                    EXCEPTION;
  OTHERS_UPD            EXCEPTION;
  update_nowait         EXCEPTION;
  uniquecle             EXCEPTION;
  uniquecle2            EXCEPTION;

  PRAGMA EXCEPTION_INIT (update_nowait, -00054);
  PRAGMA Exception_Init (uniquecle, -2292);
  PRAGMA Exception_Init (uniquecle, -1);

  --CURSEUR DE PARCOURS DES TIERS DE L'ORDONNANCE
  CURSOR maj_tiers_piece IS
   SELECT ide_poste,
      ide_gest,
    ide_ordo,
      cod_bud,
    ide_piece,
    cod_typ_piece,
      var_tiers,
    ide_tiers,
    cpt_bq,
      ide_cpt,
    mt,
      mt_dev,
      num_bq,
      ide_ref_piece,
      mtt_retenue_oppo,
      Nom,
      Prenom,
      cod_mode_reglemt,
          nom_bq,
    spec1,
    lib_objet_reglt,
    ide_plan_aux,
    ide_cpt_aux,
    num_lig
   FROM   FB_LIGNE_TIERS_PIECE
   WHERE  ide_poste      = p_ide_poste
   AND   ide_gest   = p_ide_gest
   AND   ide_ordo   = p_ide_ordo
   AND   cod_bud   = p_cod_bud
   AND   ide_piece   = p_ide_piece
   AND   cod_typ_piece  = p_cod_type_piece
   FOR UPDATE OF ide_poste NOWAIT;

  --CURSEUR DE PARCOURS DES LIGNES DE L'ORDONNANCE
  CURSOR maj_ligne_piece IS
   SELECT ide_poste,
      ide_gest,
    ide_ordo,
      cod_bud,
    ide_eng,
    mt,
      mt_bud,
      mt_dev,
    mt_bud_dev,
      ide_lig_prev,
    var_bud,
      ide_lig_exec,
    ide_cpt,
    ide_cpt_hb,
    num_lig
   FROM   FB_LIGNE_PIECE
   WHERE  ide_poste     = p_ide_poste
   AND   ide_gest     = p_ide_gest
   AND   ide_ordo     = p_ide_ordo
   AND   cod_bud     = p_cod_bud
   AND   ide_piece     = p_ide_piece
   AND   cod_typ_piece = p_cod_type_piece
   FOR UPDATE OF ide_poste NOWAIT;

  BEGIN
  NULL;
  -------------------------------------------------------------------------------------------------
  ---------------------------------------INITIALISATIONS-------------------------------------------
  -------------------------------------------------------------------------------------------------
  --initialisation des codification
  EXT_CODEXT ( 'OUI_NON', 'O', v_codif_libl, v_codif_oui, v_temp );
  EXT_CODEXT ( 'STATUT_PIECE', 'V', v_codif_libl, v_codif_vi, v_temp );
  EXT_CODEXT ( 'TYPE_PIECE', 'OD', v_codif_libl, v_codif_od, v_temp );
  EXT_CODEXT ( 'TYPE_PIECE', 'AD', v_codif_libl, v_codif_ad, v_temp );
  EXT_CODEXT ( 'ETAT_REGLT', 'J', v_codif_libl, v_codif_rj, v_temp );
  EXT_CODEXT ( 'SENS', 'D', v_codif_libl, v_codif_debit, v_temp );
  EXT_CODEXT ( 'TYPE_PEC', 'I', v_codif_libl, v_codif_pectiers, v_temp );
  EXT_CODEXT ( 'TYPE_PEC', 'O', v_codif_libl, v_codif_pecoposant, v_temp );
  EXT_CODEXT ( 'TYPE_REF_PIECE', 'C', v_codif_libl, v_codif_creation, v_temp );
  EXT_CODEXT ( 'TYPE_REF_PIECE', 'A', v_codif_libl, v_codif_abo, v_temp );
  EXT_CODEXT ( 'SIGNE', 'P', v_codif_libl, v_codif_signe_p, v_temp );
  EXT_CODEXT ( 'SIGNE', 'N', v_codif_libl, v_codif_signe_n, v_temp );

  --initialisation des montants
  IF p_new_mt IS NOT NULL AND p_new_mt_bud IS NULL THEN
    p_new_mt_bud:=p_new_mt;
  END IF;

  -------------------------------------------------------------------------------------------------
  ----------------------------------------MISES A JOUR---------------------------------------------
  -------------------------------------------------------------------------------------------------

  -------------------------------------------------------------------------
  ----CREATION DES PIECES BUDGETAIRES PAR RAPPORT A L4ORDONNANCE ANNULE----
  -------------------------------------------------------------------------
 --Création de FB_PIECE par copie du FB_PIECE de l'odonnance initiale.
 INSERT INTO fb_piece (
  IDE_POSTE,
  IDE_GEST,
  IDE_ORDO,
  COD_BUD,
  IDE_PIECE,
  COD_TYP_ND,
  IDE_ND_EMET,
  IDE_MESS,
  FLG_EMIS_RECU,
  COD_STATUT,
  IDE_OPE,
  OBJET,
  DAT_EMIS,
  DAT_RECEPTION,
  MT,
  DAT_CF,
  DAT_CAD,
  DAT_CPTA,
  DAT_REFLEXION,
  IDE_PIECE_INIT,
  MOTIF_REJ,
  COD_TYP_PIECE,
  IDE_SERVICE,
  IDE_SS_TYPE,
  IDE_DEVISE,
  VAL_TAUX,
  MT_DEV)
 SELECT
   IDE_POSTE,
  IDE_GEST,
  IDE_ORDO,
  COD_BUD,
  p_ide_piece,
  COD_TYP_ND,
  IDE_ND_EMET,
  p_no_bord_orig,
  FLG_EMIS_RECU,
  v_codif_vi,
  DECODE (p_flg_reimp,v_codif_oui,DECODE(p_cod_type_piece,v_codif_od,DECODE (p_new_op,NULL,IDE_OPE,p_new_op),IDE_OPE),IDE_OPE),
  OBJET,
  DAT_EMIS,
  DAT_RECEPTION,
  DECODE (p_flg_reimp,v_codif_oui,DECODE (p_new_mt,NULL,MT,p_new_mt),MT),
  DAT_CF,
  DAT_CAD,
  DAT_CPTA,
  DAT_REFLEXION,
  p_ide_piece_init,
  MOTIF_REJ,
  p_cod_type_piece,
  IDE_SERVICE,
  p_ide_ss_type,
  p_ide_devise,
  p_val_taux,
  DECODE (p_flg_reimp,v_codif_oui,DECODE (p_new_mt,NULL,MT,p_new_mt/p_val_taux),MT_DEV)
 FROM  FB_PIECE
 WHERE  ide_poste    = p_ide_poste
 AND ide_gest    = p_ide_gest
 AND ide_ordo    = p_ide_ordo
 AND    cod_bud    = p_cod_bud
 AND  cod_typ_piece = v_codif_od
 AND ide_piece   = GET_STRING_VALUE(p_ide_piece_init,'-',1);

 --Création des FB_LIGNE_PIECE par copie des FB_LIGNE_PIECE de l'ordonnance initiale
 INSERT INTO fb_ligne_piece (
 IDE_POSTE,
 IDE_GEST,
 IDE_ORDO,
 COD_BUD,
 IDE_PIECE,
 NUM_LIG,
 COD_TYP_PIECE,
 VAR_BUD,
 IDE_LIG_EXEC,
 VAR_CPTA,
 IDE_CPT,
 IDE_OPE,
 IDE_ENG,
 COD_SENS,
 IDE_LIG_PREV,
 MT,
 MT_BUD,
 VAR_CPTA_HB,
 IDE_CPT_HB,
 COD_SENS_HB,
 MT_DEV,
 MT_BUD_DEV)
SELECT
 IDE_POSTE,
 IDE_GEST,
 IDE_ORDO,
 COD_BUD,
 p_ide_piece,
 DECODE (p_flg_reimp,v_codif_oui,DECODE(p_cod_type_piece,v_codif_od,1,p_id_ligne),NUM_LIG),
 p_cod_type_piece,
 VAR_BUD,
 DECODE (p_flg_reimp,v_codif_oui,DECODE(p_cod_type_piece,v_codif_od,DECODE (p_new_exec,NULL,IDE_LIG_EXEC,p_new_exec),IDE_LIG_EXEC),IDE_LIG_EXEC),
 VAR_CPTA,
 DECODE (p_flg_reimp,v_codif_oui,DECODE(p_cod_type_piece,v_codif_od,DECODE (p_new_cpt,NULL,IDE_CPT,p_new_cpt),IDE_CPT),IDE_CPT),
 DECODE (p_flg_reimp,v_codif_oui,DECODE(p_cod_type_piece,v_codif_od,DECODE (p_new_op,NULL,IDE_OPE,p_new_op),IDE_OPE),IDE_OPE),
 DECODE (p_flg_reimp,v_codif_oui,DECODE(p_cod_type_piece,v_codif_od,DECODE (p_new_eng,NULL,IDE_ENG,p_new_eng),IDE_ENG),IDE_ENG),
 COD_SENS,
 DECODE (p_flg_reimp,v_codif_oui,DECODE(p_cod_type_piece,v_codif_od,DECODE (p_new_exec,NULL,IDE_LIG_PREV,(SELECT IDE_LIG_PREV FROM FN_LIGNE_BUD_EXEC t2 WHERE t2.IDE_LIG_EXEC=p_new_exec AND t2.VAR_BUD=t1.VAR_BUD) ),IDE_LIG_PREV),IDE_LIG_PREV),
 DECODE (p_flg_reimp,v_codif_oui,DECODE (p_new_mt,NULL,MT,p_new_mt),DECODE (p_flg_reimp,'P',GET_STRING_VALUE(p_lst_ligne,'-',num_lig),MT)),
 DECODE (p_flg_reimp,v_codif_oui,DECODE (p_new_mt_bud,NULL,MT_BUD,p_new_mt_bud),DECODE (p_flg_reimp,'P',GET_STRING_VALUE(p_lst_ligne_b,'-',num_lig),MT_BUD)),
 VAR_CPTA_HB,
 IDE_CPT_HB,
 COD_SENS_HB,
 DECODE (p_flg_reimp,v_codif_oui,DECODE (p_new_mt,NULL,MT_DEV,p_new_mt/p_val_taux),DECODE (p_flg_reimp,'P',GET_STRING_VALUE(p_lst_ligne_dev,'-',num_lig),MT_DEV)),
 DECODE (p_flg_reimp,v_codif_oui,DECODE (p_new_mt_bud,NULL,MT_BUD_DEV,p_new_mt_bud/p_val_taux),DECODE (p_flg_reimp,'P',GET_STRING_VALUE(p_lst_ligne_b_dev,'-',num_lig),MT_BUD_DEV))
 FROM  fb_ligne_piece t1
 WHERE  ide_poste    = p_ide_poste
 AND ide_gest    = p_ide_gest
 AND ide_ordo    = p_ide_ordo
 AND    cod_bud    = p_cod_bud
 AND ide_piece   = GET_STRING_VALUE(p_ide_piece_init,'-',1)
 AND  (( GET_STRING_VALUE(p_lst_ligne,'-',num_lig)<>'N' AND p_flg_reimp='P') OR p_flg_reimp<>'P') --controle si ligne modifié qd réimputation
 AND  cod_typ_piece = v_codif_od
 AND ((p_flg_reimp=v_codif_oui AND NUM_LIG=p_id_ligne) OR (p_flg_reimp<>v_codif_oui));


 --Création des FB_LIGNE_TIERS_PIECE par copie des FB_LIGNE_TIERS_PIECE de l'ordonnance initiale
 INSERT INTO fb_ligne_tiers_piece (
 IDE_POSTE,
 IDE_GEST,
 IDE_ORDO,
 COD_BUD,
 IDE_PIECE,
 NUM_LIG,
 COD_TYP_PIECE,
 VAR_CPTA,
 IDE_CPT,
 VAR_TIERS,
 IDE_TIERS,
 COD_CAT_SOCIOP,
 COD_TYP_TIERS,
 COD_SEC,
 NOM,
 PRENOM,
 COD_RETENUE,
 FLG_OPPO,
 COD_MODE_REGLEMT,
 MT,
 MTT_RETENUE_OPPO,
 COD_SENS,
 ADR1,
 ADR2,
 ADR3,
 ADR4,
 VILLE,
 CP,
 BP,
 PAYS,
 CPT_BQ,
 NOM_BQ,
 NOM_CONTRIB,
 TELEPH,
 NUM_BQ,
 IDE_REF_PIECE,
 MT_DEV,
 SPEC1,
 IDE_PLAN_AUX,
 IDE_CPT_AUX,
 LIB_OBJET_REGLT)
 SELECT
 IDE_POSTE,
 IDE_GEST,
 IDE_ORDO,
 COD_BUD,
 p_ide_piece,
 DECODE (p_flg_reimp,v_codif_oui,DECODE(p_cod_type_piece,v_codif_od,1,p_id_creancier),NUM_LIG),
 p_cod_type_piece,
 VAR_CPTA,
 DECODE (p_flg_reimp,v_codif_oui,DECODE(p_cod_type_piece,v_codif_od,DECODE (p_new_cpt_tiers,NULL,IDE_CPT,p_new_cpt_tiers),IDE_CPT),IDE_CPT),
 VAR_TIERS,
 IDE_TIERS,
 COD_CAT_SOCIOP,
 COD_TYP_TIERS,
 COD_SEC,
 NOM,
 PRENOM,
 COD_RETENUE,
 FLG_OPPO,
 COD_MODE_REGLEMT,
 DECODE (p_flg_reimp,v_codif_oui,DECODE (p_new_mt,NULL,MT,p_new_mt),DECODE (p_flg_reimp,'P',GET_STRING_VALUE(p_lst_tiers,'-',num_lig),MT)),
 MTT_RETENUE_OPPO,
 COD_SENS,
 ADR1,
 ADR2,
 ADR3,
 ADR4,
 VILLE,
 CP,
 BP,
 PAYS,
 CPT_BQ,
 NOM_BQ,
 NOM_CONTRIB,
 TELEPH,
 NUM_BQ,
 IDE_REF_PIECE,
 DECODE (p_flg_reimp,v_codif_oui,DECODE (p_new_mt,NULL,MT_DEV,p_new_mt/p_val_taux),DECODE (p_flg_reimp,'P',GET_STRING_VALUE(p_lst_tiers_dev,'-',num_lig),MT_DEV)),
 DECODE (p_new_spec1,NULL,SPEC1,p_new_spec1),
 --DECODE (p_new_spec1,NULL,DECODE (p_flg_reimp,v_codif_oui,DECODE(p_cod_type_piece,v_codif_od,DECODE (p_new_exec,NULL,SPEC1,p_new_exec),SPEC1),SPEC1),p_new_spec1),
 IDE_PLAN_AUX,
 DECODE (p_flg_reimp,v_codif_oui,DECODE(p_cod_type_piece,v_codif_od,DECODE (p_new_cpt_aux,NULL,IDE_CPT_AUX,p_new_cpt_aux),IDE_CPT_AUX),IDE_CPT_AUX),
 LIB_OBJET_REGLT
 FROM  fb_ligne_tiers_piece
 WHERE  ide_poste    = p_ide_poste
 AND ide_gest    = p_ide_gest
 AND ide_ordo    = p_ide_ordo
 AND    cod_bud    = p_cod_bud
 AND ide_piece   = GET_STRING_VALUE(p_ide_piece_init,'-',1)
 AND  (( GET_STRING_VALUE(p_lst_tiers,'-',num_lig)<>'N' AND p_flg_reimp='P') OR p_flg_reimp<>'P') --controle si ligne modifié qd réimputation
 AND  cod_typ_piece = v_codif_od
 AND ((p_flg_reimp=v_codif_oui AND NUM_LIG=p_id_creancier) OR (p_flg_reimp<>v_codif_oui));


 --si imputation partielle ou réimputation mise a jour de l'entete
 SELECT sum(mt),sum(mt_dev) INTO v_temp, v_temp3
 FROM fb_ligne_piece
 WHERE  ide_poste    = p_ide_poste
 AND ide_gest    = p_ide_gest
 AND ide_ordo    = p_ide_ordo
 AND    cod_bud    = p_cod_bud
 AND ide_piece   = p_ide_piece
 AND  cod_typ_piece = p_cod_type_piece;
 IF p_flg_reimp='P' OR p_flg_reimp=v_codif_oui THEN
  UPDATE FB_PIECE
  SET MT = DECODE (v_temp,NULL,MT,v_temp),
  MT_DEV = DECODE (v_temp,NULL,MT,v_temp3)
 WHERE  ide_poste    = p_ide_poste
  AND  ide_gest    = p_ide_gest
  AND  ide_ordo    = p_ide_ordo
  AND     cod_bud    = p_cod_bud
  AND     ide_piece   = p_ide_piece
 AND  cod_typ_piece = p_cod_type_piece;
 END IF;

  -------------------------------------------------------------
  -------------------EN TETE DE L'ECRITURE---------------------
  -------------------------------------------------------------

   IF p_objet IS NULL THEN
    p_out_retour := 55; --Erreur 105
    p_out_text_retour1:=sqlerrm;
      p_out_text_retour2:='';
      p_out_text_retour3:='';
    RAISE KO;
 END IF;


 IF p_cod_type_piece=v_codif_ad THEN
  BEGIN
   --Recalcule le montant de la piece en devise de reférence
   UPDATE FB_PIECE
   SET   mt      = (-1) * mt,
        mt_dev     = (-1) * mt_dev,
        dat_maj    = sysdate,
        uti_maj    = p_code_util,
       terminal   = p_terminal
   WHERE    ide_poste  = p_ide_poste
   AND   ide_gest   = p_ide_gest
   AND   ide_ordo   = p_ide_ordo
   AND   cod_bud   = p_cod_bud
   AND   cod_typ_piece  = p_cod_type_piece
   AND   ide_piece   = p_ide_piece;

   --Recalcule le montant de chaque ligne en devise de référence
   UPDATE FB_LIGNE_PIECE
   SET   mt    = (-1) * mt ,
      mt_bud   = (-1) * mt_bud,
      mt_dev      = (-1) * mt_dev,
      mt_bud_dev  = (-1) * mt_bud_dev,
       dat_maj   = sysdate,
       uti_maj   = p_code_util,
       terminal   = p_terminal
   WHERE    ide_poste   = p_ide_poste
   AND      ide_gest   = p_ide_gest
   AND      ide_ordo   = p_ide_ordo
   AND      cod_bud   = p_cod_bud
   AND      cod_typ_piece  = p_cod_type_piece
   AND      ide_piece   = p_ide_piece;

   --Recalcule le montant de chaque ligne tiers en devise de référence
   UPDATE FB_LIGNE_TIERS_PIECE
   SET   mt    = (-1) * mt ,
      mt_dev    = (-1) * mt_dev,
      mtt_retenue_oppo=(-1) *mtt_retenue_oppo, -- FBT - 23/10/2007 - Ano 116
      dat_maj   = sysdate,
      uti_maj   = p_code_util,
      terminal   = p_terminal
   WHERE    ide_poste   = p_ide_poste
   AND   ide_gest   = p_ide_gest
   AND   ide_ordo   = p_ide_ordo
   AND   cod_bud   = p_cod_bud
   AND   cod_typ_piece  = p_cod_type_piece
   AND   ide_piece   = p_ide_piece;
  EXCEPTION
    WHEN OTHERS THEN
    RAISE OTHERS_UPD;
  END;
 END IF;

 --En tete de l'écriture comptable si le sous-type de pièce indique la génération d'une écriture de prise en charge
 IF p_flg_pec = v_codif_oui THEN

 	--En tete de l'écriture comptable lié a l'AD ou à l'OD
	MAJ_INS_ECRITURE(  P_cod_typ_piece  => p_cod_type_piece,
	     P_ide_ss_type    => p_ide_ss_type,
	     P_ide_typ_poste  => p_ide_typ_poste,
	     P_ide_poste      => p_ide_poste,
	                    P_ide_piece      => p_ide_piece,
	                    P_ide_gest   => p_ide_gest,
	                    P_ide_ordo   => p_ide_ordo,
	                    P_cod_bud   => p_cod_bud,
	                    P_var_cpta   => p_var_cpta,
	                    P_dat_jc   => p_date_jc,
	                    P_objet    => p_objet,
	                    P_dat_cad   => sysdate,
	                    P_ret    => v_ret,
	                    P_ide_ecr   => v_ide_ecr,
	                    P_ide_jal   => v_ide_jal,
	                    P_dat_ecr   => v_dat_ecr
	                   );
	IF v_ret != 1 THEN
	 p_out_retour := 2; --Erreur 472
	 p_out_text_retour1:='';
	 p_out_text_retour2:='';
	 p_out_text_retour3:='';
	 RAISE KO;
	END IF;

	 --test si ecriture de soldage
	 BEGIN
	  SELECT PB_SS_TYPE_PIECE.flg_pec
	  INTO v_pec1
	  FROM SR_PARAM
	  INNER JOIN PB_SS_TYPE_PIECE
	     ON PB_SS_TYPE_PIECE.IDE_SS_TYPE=SR_PARAM.VAL_PARAM
	  WHERE SR_PARAM.IDE_PARAM = 'IB0091'
	  AND PB_SS_TYPE_PIECE.COD_TYP_PIECE=v_codif_ad;

	  SELECT RC_MODELE_LIGNE.COD_REF_PIECE
	  INTO v_abo1
	  FROM SR_PARAM
	  INNER JOIN PC_PRISE_CHARGE
	     ON PC_PRISE_CHARGE.IDE_SS_TYPE=SR_PARAM.VAL_PARAM
	  INNER JOIN RC_MODELE_LIGNE
	       ON RC_MODELE_LIGNE.IDE_JAL=PC_PRISE_CHARGE.IDE_JAL
	     AND RC_MODELE_LIGNE.IDE_SCHEMA=PC_PRISE_CHARGE.IDE_SCHEMA
	     AND RC_MODELE_LIGNE.VAR_CPTA=PC_PRISE_CHARGE.VAR_CPTA
	  WHERE SR_PARAM.IDE_PARAM = 'IB0091'
	  AND PC_PRISE_CHARGE.COD_TYP_PIECE=v_codif_ad
	  AND PC_PRISE_CHARGE.VAR_CPTA=p_var_cpta
	  AND PC_PRISE_CHARGE.IDE_TYP_POSTE=p_ide_typ_poste
	  AND RC_MODELE_LIGNE.COD_TYP_PEC=v_codif_pectiers
          AND CTL_DATE(RC_MODELE_LIGNE.dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
          AND CTL_DATE(sysdate,RC_MODELE_LIGNE.dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008

	  SELECT PB_SS_TYPE_PIECE.flg_pec
	  INTO v_pec2
	  FROM SR_PARAM
	  INNER JOIN PB_SS_TYPE_PIECE
	     ON PB_SS_TYPE_PIECE.IDE_SS_TYPE=SR_PARAM.VAL_PARAM
	  WHERE SR_PARAM.IDE_PARAM = 'IB0092'
	  AND PB_SS_TYPE_PIECE.COD_TYP_PIECE=v_codif_od;

	  SELECT RC_MODELE_LIGNE.COD_REF_PIECE
	  INTO v_abo2
	  FROM SR_PARAM
	  INNER JOIN PC_PRISE_CHARGE
	     ON PC_PRISE_CHARGE.IDE_SS_TYPE=SR_PARAM.VAL_PARAM
	  INNER JOIN RC_MODELE_LIGNE
	       ON RC_MODELE_LIGNE.IDE_JAL=PC_PRISE_CHARGE.IDE_JAL
	     AND RC_MODELE_LIGNE.IDE_SCHEMA=PC_PRISE_CHARGE.IDE_SCHEMA
	     AND RC_MODELE_LIGNE.VAR_CPTA=PC_PRISE_CHARGE.VAR_CPTA
	  WHERE SR_PARAM.IDE_PARAM = 'IB0092'
	  AND PC_PRISE_CHARGE.COD_TYP_PIECE=v_codif_od
	  AND PC_PRISE_CHARGE.VAR_CPTA=p_var_cpta
	  AND PC_PRISE_CHARGE.IDE_TYP_POSTE=p_ide_typ_poste
	  AND RC_MODELE_LIGNE.COD_TYP_PEC=v_codif_pectiers
          AND CTL_DATE(RC_MODELE_LIGNE.dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
          AND CTL_DATE(sysdate,RC_MODELE_LIGNE.dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008

	 EXCEPTION
	     WHEN OTHERS THEN
	       v_pec1:='N';
	  	   v_pec2:='N';
	  	   v_abo1:='S';
	  	   v_abo2:='S';
	 END;

	 --FBT le 30/11/2007 - ANO 164
	 --En réimputation, le sous type de piece de l'ad et de l'od ne peuvent pas etre paramétré en abondement
	 IF p_flg_reimp='O' AND (v_abo1=v_codif_abo OR v_abo2=v_codif_abo) THEN
			p_out_retour := 23; --Erreur 803
	   	   	p_out_text_retour1:='le sous type de piece de l''AD et de l''OD ne peuvent pas etre paramétré en abondement';
	        p_out_text_retour2:='';
	        p_out_text_retour3:='';
			RAISE KO;
	 END IF;

	 --DEBUT - FBT ANO 136 Modification du numéro d'écriture pour que OD, AD, et ecr équilibrage soit référencés dans un ordre chronologique.
	 IF p_cod_type_piece=v_codif_od AND p_flg_pec = v_codif_oui AND p_flg_reimp=v_codif_oui AND v_pec1 = v_codif_oui AND v_pec2 = v_codif_oui AND v_abo1=v_codif_creation AND v_abo2=v_codif_creation THEN
		 UPDATE FC_ECRITURE
		 SET IDE_ECR=IDE_ECR-2
		 WHERE ide_poste = p_ide_poste
	  	 AND ide_gest = p_ide_gest
	  	 AND flg_cptab = v_codif_oui
		 AND ide_ecr=v_ide_ecr
		 AND ide_jal in( SELECT ide_jal
		 	 		     FROM pc_prise_charge
		 			     WHERE cod_typ_piece = v_codif_od
					     AND var_cpta        = p_var_cpta
					     AND ide_ss_type     = p_ide_ss_type
					     AND ide_typ_poste   = p_ide_typ_poste );

		 v_ide_ecr:=v_ide_ecr-2;
	 END IF;
	 --FIN - FBT ANO 136 ---------------------------------------------------------------------------------------------------------------------

	--Recupération du sous type de piece à utiliser pour l'ecriture d'équilibrage
	SELECT val_param INTO v_ss_typ_reimp_ab
	FROM SR_PARAM
	WHERE ide_param ='IB0093';

	 --En tete de l'écriture comptable de soldage des pieces dans le cadre d'une réimputation
	 IF p_cod_type_piece=v_codif_ad AND p_flg_pec = v_codif_oui AND p_flg_reimp=v_codif_oui AND v_pec1 = v_codif_oui AND v_pec2 = v_codif_oui AND v_abo1=v_codif_creation AND v_abo2=v_codif_creation THEN
		BEGIN

			 v_flg_schema_reimp:='O';

			--Récupération du journal et du schéma à utiliser pour l'ecriture d'équilibrage
			SELECT IDE_JAL,IDE_SCHEMA
			INTO v_journal_reimp_ab,v_schema_reimp_ab
		    FROM PC_PRISE_CHARGE
		    WHERE VAR_CPTA=p_var_cpta
			AND IDE_SS_TYPE=v_ss_typ_reimp_ab
			AND IDE_TYP_POSTE=p_ide_typ_poste
			AND COD_TYP_PIECE=v_codif_od
			AND (DAT_FVAL>SYSDATE OR DAT_FVAL IS NULL);

			--vérification de la première ligne tiers
			SELECT COUNT(IDE_MODELE_LIG)
			INTO v_ret
			FROM RC_MODELE_LIGNE
			WHERE VAR_CPTA=p_var_cpta
			AND IDE_JAL=v_journal_reimp_ab
			AND IDE_SCHEMA=v_schema_reimp_ab
			AND COD_TYP_PEC=v_codif_pectiers
			AND VAL_SENS=v_codif_debit
			AND COD_SIGNE=v_codif_signe_p
			AND COD_REF_PIECE=v_codif_abo
                        AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
                        AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008

			IF v_ret=0 THEN
			   v_flg_schema_reimp:='N';
			END IF;

			--vérification de la seconde ligne tiers
			SELECT COUNT(IDE_MODELE_LIG)
			INTO v_ret
			FROM RC_MODELE_LIGNE
			WHERE VAR_CPTA=p_var_cpta
			AND IDE_JAL=v_journal_reimp_ab
			AND IDE_SCHEMA=v_schema_reimp_ab
			AND COD_TYP_PEC=v_codif_pectiers
			AND VAL_SENS=v_codif_debit
			AND COD_SIGNE=v_codif_signe_n
			AND COD_REF_PIECE=v_codif_abo
                        AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
                        AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008

			IF v_ret=0 THEN
			   v_flg_schema_reimp:='N';
			END IF;

			--erreur de paramétrage pour le schéma de l'écriture d'équilibrage
		 	IF v_flg_schema_reimp='N' THEN
			   p_out_retour := 23; --Erreur 803
		   	   p_out_text_retour1:='';
		       p_out_text_retour2:='';
		       p_out_text_retour3:='';
		   	   RAISE KO;
			END IF;
		EXCEPTION
			WHEN OTHERS THEN
			p_out_retour := 23; --Erreur 803
	   	   	p_out_text_retour1:='';
	        p_out_text_retour2:='';
	        p_out_text_retour3:='';
			RAISE KO;
		END;
	    MAJ_INS_ECRITURE( P_cod_typ_piece  => v_codif_od,
	        P_ide_ss_type    => v_ss_typ_reimp_ab,
	        P_ide_typ_poste  => p_ide_typ_poste,
	        P_ide_poste      => p_ide_poste,
	        P_ide_piece      => p_ide_piece,
	        P_ide_gest   => p_ide_gest,
	        P_ide_ordo   => p_ide_ordo,
	        P_cod_bud   => p_cod_bud,
	        P_var_cpta   => p_var_cpta,
	        P_dat_jc   => p_date_jc,
	        P_objet    => p_objet,
	        P_dat_cad   => sysdate,
	        P_ret    => v_ret,
	        P_ide_ecr   => v_ide_ecr2,
	        P_ide_jal   => v_ide_jal2,
	        P_dat_ecr   => v_dat_ecr2
	       );
	  IF v_ret != 1 THEN
	   	 p_out_retour := 2; --Erreur 472
	   	 p_out_text_retour1:='';
	     p_out_text_retour2:='';
	     p_out_text_retour3:='';
	   RAISE KO;
	  ELSE
	     --DEBUT - FBT ANO 136 Modification du numéro d'écriture pour que OD, AD, et ecr équilibrage soit référencés dans un ordre chronologique.
		 UPDATE FC_ECRITURE
		 SET IDE_ECR=v_ide_ecr2+1
		 WHERE ide_poste = p_ide_poste
   		 AND ide_gest = p_ide_gest
   		 AND flg_cptab = v_codif_oui
		 AND ide_ecr=v_ide_ecr2
		 AND ide_jal in( SELECT ide_jal
		 	 		     FROM pc_prise_charge
		 			     WHERE cod_typ_piece = v_codif_od
					     AND var_cpta        = p_var_cpta
					     AND ide_ss_type     = v_ss_typ_reimp_ab
					     AND ide_typ_poste   = p_ide_typ_poste );
		 v_ide_ecr2:=v_ide_ecr2+1;
		 --FIN - FBT ANO 136 ---------------------------------------------------------------------------------------------------------------------

	   	 p_inout_ide_ecr2:=v_ide_ecr2;
	     p_inout_ide_jal2:=v_ide_jal2;
	     p_inout_dat_ecr2:=v_dat_ecr2;
	  END IF;

	 END IF;
 END IF;

  -------------------------------------------------------------
  ---------------------LIGNES DE LA PIECE----------------------
  -------------------------------------------------------------
     v_temp:=1;

 --Pour chaque ligne de la piece mise à jour des lignes d'engagement, des disponibles et situations, créations des écritures comptables budgétaires et hors budget
 OPEN maj_ligne_piece;
   LOOP
     FETCH maj_ligne_piece
     INTO  v_ide_poste,
     v_ide_gest,
     v_ide_ordo,
        v_cod_bud,
     v_ide_eng,
     v_mt,
        v_mt_bud,
     v_mt_dev,
     v_mt_bud_dev ,
        v_ide_lig_prev,
     v_var_bud,
        v_ide_lig_exec,
     v_ide_cpt,
     v_ide_cpt_hb,
     v_num_lig_current;
     EXIT WHEN maj_ligne_piece%NOTFOUND;

  /* FBT le 09/02/2009 - EVOL DI44_CC_2009_022 : en cas d'annulation partielle on mémorise précisement la ligne pour
  déterminer le disponible ligne à ligne
  --mise a jour de numero de ligne si annulation partielle
  IF p_flg_reimp='P' THEN
   UPDATE fb_ligne_piece
   SET num_lig=v_temp
   WHERE  ide_poste      = p_ide_poste
     AND    ide_gest   = p_ide_gest
     AND    ide_ordo   = p_ide_ordo
     AND    cod_bud    = p_cod_bud
     AND    ide_piece   = p_ide_piece
     AND    cod_typ_piece   = p_cod_type_piece
   AND    num_lig   = v_num_lig_current;
   v_temp:=v_temp+1;
  END IF; */

  --Si l'indicateur ordonnance indique que la pièce et rattaché à un engagement
  IF p_flg_engagt = v_codif_oui THEN
   BEGIN
      UPDATE  FB_LIGNE_ENG
      SET  mtt_ord   = NVL(mtt_ord,0) + NVL(v_mt,0),
        mtt_ord_bud  = NVL(mtt_ord_bud,0) + NVL(v_mt_bud,0),
           dat_maj   = sysdate,
           uti_maj   = p_code_util,
           terminal   = p_terminal
      WHERE  ide_poste   = v_ide_poste
        AND  ide_gest   = v_ide_gest
        AND  ide_ordo   = v_ide_ordo
        AND  cod_bud   = v_cod_bud
        AND  ide_lig_prev = v_ide_lig_prev
        AND  var_bud   = v_var_bud
        AND  ide_eng   = v_ide_eng;
   EXCEPTION
    WHEN OTHERS THEN
     RAISE OTHERS_UPD;
   END;
  END IF;

  --contrôles des disponibles et mises à jour des situations
  v_cod_nat_cr := null;
  MAJ_SITUATIONS_B (p_cod_type_piece,
               	   	v_mt,
					v_mt_bud,
					v_codif_oui,
					v_ide_poste,
					v_ide_ordo,
					v_cod_bud,
					v_var_bud,
 					v_ide_gest,
					v_ide_lig_prev,
					v_ide_lig_exec,
					NVL(p_new_op, p_ide_ope), -- FBT - le 15/11/2007 - Ano 142 - Ano 167
					v_cod_nat_cr,
					v_ret,
					p_ide_ss_type
                  );
     IF v_ret = 0 THEN
      p_out_retour := 3; --Erreur 567
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
    ELSIF v_ret = -6 THEN
         p_out_retour := 4; --Erreur 6
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
    ELSIF v_ret = -5 THEN
   p_out_retour := 5; --Erreur 159
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
    ELSIF v_ret = -4 THEN
      p_out_retour := 6; --Erreur 314
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
       ELSIF v_ret = -3 THEN
      p_out_retour := 7; --Erreur 282
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
       ELSIF v_ret = -2 THEN
      p_out_retour := 8; --Erreur 282
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
     ELSIF v_ret = -7 THEN
   p_out_retour := 9; --Erreur 59
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
       ELSIF v_ret = -8 THEN
   p_out_retour := 10; --Erreur 872
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
  ELSIF v_ret = -9 THEN
      p_out_retour := 11; --Erreur 871
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
    ELSIF v_ret = -10 THEN
      p_out_retour := 12; --Erreur 870
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
    ELSIF v_ret = -11 THEN
      p_out_retour := 13; --Erreur 868
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
    ELSIF v_ret = -12 THEN
      p_out_retour := 14; --Erreur 869
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
    ELSIF v_ret = -13 THEN
      p_out_retour := 15; --Erreur 873
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
    ELSIF v_ret != 1 THEN
      p_out_retour := 16; --Erreur 866
   p_out_text_retour1:='REFERENCE.PLL (MAJ_SITUATIONS)';
     p_out_text_retour2:=v_ret;
     p_out_text_retour3:='';
   RAISE KO;
    END IF;

  --Si le sous-type de pièce indique la génération d'une écriture de prise en charge générer des lignes budgétaires d'execution et hors budget
  IF p_flg_pec = v_codif_oui THEN
      v_num_lig := v_num_lig + 1;

   --Gestion des montants a insérer
   IF p_cod_type_piece = v_codif_ad THEN
               v_mt_f          := abs(v_mt);
                v_mt_bud_f      := abs(v_mt_bud);
                v_mt_dev_f      := abs(v_mt_dev) ;
       v_mt_bud_dev_f  := abs(v_mt_bud_dev);
           ELSE
               v_mt_f          := v_mt;
              v_mt_bud_f      := v_mt_bud;
              v_mt_dev_f      := v_mt_dev ;
    v_mt_bud_dev_f  := v_mt_bud_dev;
           END IF;

   --insertion
   MAJ_INS_LIGNE_BUD ( P_cod_typ_piece => p_cod_type_piece,
        P_ide_ss_type   => p_ide_ss_type,
        P_ide_typ_poste => p_ide_typ_poste,
                             P_ide_poste  => p_ide_poste,
                             P_ide_piece  => p_ide_piece,
                             P_ide_gest      => p_ide_gest,
                             P_ide_ordo      => p_ide_ordo,
                             P_cod_bud       => p_cod_bud,
                             P_var_cpta   => p_var_cpta,
                             P_dat_jc   => p_date_jc,
                             P_ide_ecr   => v_ide_ecr,
                             P_num_lig   => v_num_lig ,
                             P_ide_jal   => v_ide_jal,
                             P_ide_cpt   => v_ide_cpt,
                             P_ide_cpt_hb  => v_ide_cpt_hb,
                             P_dat_ecr   => v_dat_ecr,
                             P_var_bud   => v_var_bud,
                             P_ide_lig_exec  => v_ide_lig_exec,
        P_ide_lig_prev  => v_ide_lig_prev,
        P_dat_emis      => p_date_emis,
        P_dat_reception => p_date_recp,
        P_ide_piece_init => GET_STRING_VALUE(p_ide_piece_init,'-',1),
        P_Ide_Eng       => v_ide_eng,
        P_ide_ope   => NVL(p_new_op,p_ide_ope), -- FBT - Le 29/11/2007 - Ano 159
        P_mt    => v_mt_f,
        P_mt_bud   => v_mt_bud_f,
        P_mt_dev       => v_mt_dev_f ,
        P_mt_bud_dev   => v_mt_bud_dev_f,
        P_ide_devise   => p_ide_devise,
        P_val_taux     => p_val_taux,
        P_ret   => v_ret,
        P_num_lig_s  => v_num_lig_s
                            );
   IF v_ret = 2 THEN
      p_out_retour := 17; --Erreur 915
      p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
         ELSIF v_ret = 0 THEN
      p_out_retour := 18; --Erreur 796
      p_out_text_retour1:=p_ide_ss_type;
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
         ELSIF v_ret = -1 THEN
      p_out_retour := 19; --Erreur 58
      p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
    ELSIF v_ret  = -2 THEN
      p_out_retour := 20; --Erreur 59
      p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
      ELSIF v_ret  = -3 THEN
      p_out_retour := 21; --Erreur 795
      p_out_text_retour1:=p_ide_ss_type;
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
      ELSIF v_ret  = -4 THEN
      p_out_retour := 22; --Erreur 797
      p_out_text_retour1:=p_ide_ss_type;
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
    ELSIF v_ret  = -5 THEN
      p_out_retour := 23; --Erreur 803
      p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
    ELSIF v_ret  = -6 THEN
      p_out_retour := 24; --Erreur 802
      p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
    ELSIF v_ret = -8 THEN
      p_out_retour := 25; --Erreur 631
      p_out_text_retour1:='générée n° '||v_num_lig;
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
         ELSIF v_ret = -9 THEN
      p_out_retour := 26; --Erreur 914
      p_out_text_retour1:='';
        p_out_text_retour2:=v_num_lig;
        p_out_text_retour3:='';
      RAISE KO;
         ELSIF v_ret = -10 THEN
      p_out_retour := 27; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='SPEC1';
        p_out_text_retour3:='';
      RAISE KO;
         ELSIF v_ret = -11 THEN
      p_out_retour := 28; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='SPEC2';
        p_out_text_retour3:='';
      RAISE KO;
         ELSIF v_ret = -12 THEN
      p_out_retour := 29; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='SPEC3';
        p_out_text_retour3:='';
      RAISE KO;
         ELSIF v_ret = -13 THEN
      p_out_retour := 30; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='COMPTE';
        p_out_text_retour3:='';
      RAISE KO;
         ELSIF v_ret = -14 THEN
      p_out_retour := 31; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='ORDO';
        p_out_text_retour3:='';
      RAISE KO;
         ELSIF v_ret = -15 THEN
      p_out_retour := 32; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='BUDGET';
        p_out_text_retour3:='';
      RAISE KO;
         ELSIF v_ret = -16 THEN
      p_out_retour := 33; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='LIGBUD';
        p_out_text_retour3:='';
      RAISE KO;
         ELSIF v_ret = -17 THEN
      p_out_retour := 34; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='OPE';
        p_out_text_retour3:='';
      RAISE KO;
    END IF;
    v_num_lig:=v_num_lig_s; -- FBT - 24/10/2007 - Ano 119
  END IF;

 END LOOP;
    CLOSE maj_ligne_piece;

  -------------------------------------------------------------
  ----------------------TIERS DE LA PIECE----------------------
  -------------------------------------------------------------
 v_temp:=1;

 --Pour chaque ligne tiers : mise à jour des coordonnées bancaires, création de l'écriture comptable pour le tiers, creation du règlement pour le tiers
 OPEN maj_tiers_piece;
   LOOP
   FETCH maj_tiers_piece
   INTO  v_ide_poste,
       v_ide_gest,
      v_ide_ordo,
         v_cod_bud,
      v_ide_piece,
      v_cod_typ_piece,
         v_var_tiers,
      v_ide_tiers,
      v_cpt_bq,
         v_ide_cpt,
      v_mt,
      v_mt_dev_tiers,
         v_num_bq,
      v_ide_ref_piece,
      v_mtt_retenu_oppo,
         v_nom_tiers,
         v_prenom_tiers,
         v_ide_mod_reglt,
         v_nom_bq,
      v_spec1,
      v_lib_objet_piece,
      v_ide_plan_aux,
      v_ide_cpt_aux,
      v_num_lig_ligne_tiers;
  EXIT WHEN maj_tiers_piece%NOTFOUND;

  /* FBT le 09/02/2009 - EVOL DI44_CC_2009_022 : en cas d'annulation partielle on mémorise précisement la ligne pour
  déterminer le disponible ligne à ligne
  --mise a jour de numero de ligne si imputation partielle
  IF p_flg_reimp='P' THEN
   UPDATE fb_ligne_tiers_piece
   SET num_lig=v_temp
   WHERE  ide_poste      = p_ide_poste
     AND    ide_gest   = p_ide_gest
     AND    ide_ordo   = p_ide_ordo
     AND    cod_bud    = p_cod_bud
     AND    ide_piece   = p_ide_piece
     AND    cod_typ_piece   = p_cod_type_piece
   AND    num_lig   = v_num_lig_ligne_tiers;
   v_temp:=v_temp+1;
  END IF; */

  --mise à jour des coordonnées banquaires
  IF v_cpt_bq IS NOT NULL THEN
     BEGIN

        BEGIN
         SELECT 1 INTO v_exist
    FROM   FB_VERIF_RIB
    WHERE  ide_poste = v_ide_poste
    AND    var_tiers = v_var_tiers
    AND    ide_tiers = v_ide_tiers
    AND    num_bq = v_num_bq
    AND    dat_valid_cpta IS NOT NULL;
          EXCEPTION
         WHEN NO_DATA_FOUND THEN
          v_exist := 0;
         WHEN TOO_MANY_ROWS THEN
          v_exist := 1;
         WHEN OTHERS THEN
          RAISE OTHERS_UPD;
          END;

     IF v_exist = 0 THEN
         INSERT INTO FB_VERIF_RIB (
        ide_poste,
      var_tiers,
      ide_tiers,
      num_bq,
      dat_valid_cpta,
      dat_cre,
      uti_cre,
      dat_maj,
      uti_maj,
      terminal
      )VALUES(
      v_ide_poste,
      v_var_tiers,
      v_ide_tiers,
      v_num_bq,
      SYSDATE,
      SYSDATE,
      p_code_util,
      SYSDATE,
      p_code_util,
      p_terminal);
     END IF;

     EXCEPTION
        WHEN OTHERS THEN
         RAISE OTHERS_UPD;
     END;
  END IF;

  -- Si le sous-type de pièce indique la génération d'une écriture de prise en charge  générer des lignes tiers  qui suit le paramétrage du shéma comptable attaché au sous-type de pièce pour le modèle de ligne dont le type de ligne = 'I'
  IF p_flg_pec = v_codif_oui THEN
     v_num_lig := v_num_lig_s + 1;

    --convertion des montants
    IF p_cod_type_piece = v_codif_ad then
            v_mt_f                := abs(v_mt);
             v_mtt_retenu_oppo_f   := abs(v_mtt_retenu_oppo);
             v_mt_dev_tiers_f      := abs(v_mt_dev_tiers) ;
          ELSE
            v_mt_f                := v_mt;
             v_mtt_retenu_oppo_f   := v_mtt_retenu_oppo;
             v_mt_dev_tiers_f      := v_mt_dev_tiers ;
          END IF;

    --FBT le 29/11/2007 - Ano161
	--Si pas de piece dans la table FB_LIGNE_TIERS_PIECE
	--et que l'on se trouve en abondement, on sélectionne la pièce concerné par l'abondement
	BEGIN
	  SELECT RC_MODELE_LIGNE.COD_REF_PIECE
	  INTO v_temp2
	  FROM RC_MODELE_LIGNE
	  INNER JOIN PC_PRISE_CHARGE
		   ON PC_PRISE_CHARGE.VAR_CPTA=RC_MODELE_LIGNE.VAR_CPTA
		   AND PC_PRISE_CHARGE.IDE_JAL=RC_MODELE_LIGNE.IDE_JAL
		   AND PC_PRISE_CHARGE.IDE_SCHEMA=RC_MODELE_LIGNE.IDE_SCHEMA
	  WHERE PC_PRISE_CHARGE.VAR_CPTA=p_var_cpta
	  AND PC_PRISE_CHARGE.IDE_TYP_POSTE=p_ide_typ_poste
	  AND PC_PRISE_CHARGE.COD_TYP_PIECE=v_codif_ad
	  AND ( (RC_MODELE_LIGNE.COD_TYP_PEC=v_codif_pectiers AND v_mtt_retenu_oppo_f IS NULL) OR (RC_MODELE_LIGNE.COD_TYP_PEC=v_codif_pecoposant AND v_mtt_retenu_oppo_f IS NOT NULL))
	  AND PC_PRISE_CHARGE.IDE_SS_TYPE=p_ide_ss_type
          AND CTL_DATE(RC_MODELE_LIGNE.dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
          AND CTL_DATE(sysdate,RC_MODELE_LIGNE.dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008


		IF v_ide_ref_piece IS NULL AND v_temp2=v_codif_abo THEN
				SELECT ide_ref_piece
				INTO   v_ide_ref_piece
				FROM   fc_ref_piece
				WHERE  ide_poste = p_ide_poste
				AND    ide_ordo = p_ide_ordo
				AND    cod_bud = p_cod_bud
				AND    ide_gest = p_ide_gest
				AND    cod_typ_piece = v_codif_od
				AND    ide_piece = GET_STRING_VALUE(p_ide_piece_init,'-',1)
				AND    (( cod_ref_piece = p_ide_ordo||'-'||p_cod_bud||'-'||p_ide_gest||'-'||v_codif_od||'-'||GET_STRING_VALUE(p_ide_piece_init,'-',1)||'-'||p_id_creancier and p_flg_reimp='O' )
					   OR ((p_flg_reimp='P' OR p_flg_reimp='T') AND cod_ref_piece = p_ide_ordo||'-'||p_cod_bud||'-'||p_ide_gest||'-'||v_codif_od||'-'||GET_STRING_VALUE(p_ide_piece_init,'-',1)||'-'||v_num_lig_ligne_tiers)); --FBT - 12/12/2007 - Ano 171
		END IF;
	EXCEPTION
	    WHEN OTHERS THEN
			NULL;
	END;

    --Insertion
    MAJ_INS_LIGNE_TIERS ( P_cod_typ_piece    => p_cod_type_piece,
						P_ide_ss_type      => p_ide_ss_type,
						P_ide_typ_poste    => p_ide_typ_poste,
						P_ide_poste    => p_ide_poste,
						P_ide_piece    => p_ide_piece,
						P_ide_piece_init   => GET_STRING_VALUE(p_ide_piece_init,'-',1),
						P_ide_gest     => p_ide_gest,
						P_ide_ordo     => p_ide_ordo,
						P_cod_bud     => p_cod_bud,
						P_var_cpta     => p_var_cpta,
						P_dat_jc     => p_date_jc,
						P_ide_ecr     => v_ide_ecr,
						P_ide_jal     => v_ide_jal,
						P_num_lig     => v_num_lig,
						P_dat_cad     => p_date_jc,  --FBT - 23/10/2007 - Ano 114
						P_dat_ecr     => v_dat_ecr,
						P_var_tiers    => v_var_tiers,
						P_ide_tiers    => v_ide_tiers,
						P_ide_cpt     => v_ide_cpt,
						P_Nom_tiers    => v_nom_tiers,
						P_Prenom_tiers     => v_prenom_tiers,
						P_ide_ope          => p_ide_ope,
						P_mt_retenu_oppo   => v_mtt_retenu_oppo_f,
						P_mt     => v_mt_f,
						P_mt_dev          => v_mt_dev_tiers_f,
						P_ide_devise      => p_ide_devise,
						P_val_taux        => p_val_taux,
						P_ret              => v_ret,
						P_ide_ref_piece    => v_ide_ref_piece,
						P_ide_devise_ref   => p_ide_devise_ref,
						P_ide_plan_aux       => v_ide_plan_aux,
						P_ide_cpt_aux      => v_ide_cpt_aux,
						P_num_lig_ligne_tiers => v_num_lig_ligne_tiers,
						P_ide_spec1        => v_spec1,
						P_cod_ref_piece_s    => v_cod_ref_piece_s,
						P_num_lig_s     => v_num_lig_s);
           IF v_ret = 2 THEN
      p_out_retour := 35; --Erreur 915
      p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
    ELSIF v_ret = 0 THEN
      p_out_retour := 36; --Erreur 116
      p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
    ELSIF  v_ret = -1 THEN
      p_out_retour := 37; --Erreur 58
      p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
    ELSIF v_ret  = -2 THEN
      p_out_retour := 38; --Erreur 59
      p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
    ELSIF v_ret = -3  THEN
      p_out_retour := 39; --Erreur 803
      p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
    ELSIF v_ret = -4  THEN
      p_out_retour := 40; --Erreur 802
      p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
    ELSIF v_ret = -5  THEN
      p_out_retour := 41; --Erreur 797
      p_out_text_retour1:=p_ide_ss_type;
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
    ELSIF v_ret = -8 THEN
      p_out_retour := 42; --Erreur 631
      p_out_text_retour1:='générée n° '||v_num_lig;
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
           ELSIF v_ret = -9 THEN
      p_out_retour := 43; --Erreur 914
      p_out_text_retour1:='';
        p_out_text_retour2:=v_num_lig;
        p_out_text_retour3:='';
      RAISE KO;
            ELSIF v_ret = -10 THEN
      p_out_retour := 44; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='SPEC1';
        p_out_text_retour3:='';
      RAISE KO;
            ELSIF v_ret = -11 THEN
      p_out_retour := 45; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='SPEC2';
        p_out_text_retour3:='';
      RAISE KO;
            ELSIF v_ret = -12 THEN
      p_out_retour := 46; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='SPEC3';
        p_out_text_retour3:='';
      RAISE KO;
            ELSIF v_ret = -13 THEN
      p_out_retour := 47; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='COMPTE';
        p_out_text_retour3:='';
      RAISE KO;
            ELSIF v_ret = -14 THEN
      p_out_retour := 48; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='ORDO';
        p_out_text_retour3:='';
      RAISE KO;
            ELSIF v_ret = -15 THEN
      p_out_retour := 49; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='BUDGET';
        p_out_text_retour3:='';
      RAISE KO;
            ELSIF v_ret = -16 THEN
      p_out_retour := 50; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='LIGBUD';
        p_out_text_retour3:='';
      RAISE KO;
            ELSIF v_ret = -17 THEN
      p_out_retour := 51; --Erreur 913
      p_out_text_retour1:=v_num_lig;
        p_out_text_retour2:='OPE';
        p_out_text_retour3:='';
      RAISE KO;
	  ELSIF v_ret = -18 THEN
      	p_out_retour := 39; --Erreur 803
      	p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
      -- DEBUT / PGE - 07/04/2008, EVOLUTION EVO_2007_010.
      ELSIF v_ret = -19 THEN
      	p_out_retour := 58; --Erreur 787.
      	p_out_text_retour1:=v_cod_ref_piece_s||'('||v_ide_ref_piece||')';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
      -- FIN / PGE - 07/04/2008, EVOLUTION.
    END IF;

      v_num_lig := v_num_lig_s;

   --Ligne tiers de l'écriture comptable de soldage des pieces dans le cadre d'une réimputation
   IF p_flg_reimp=v_codif_oui AND v_pec1 = v_codif_oui AND v_pec2 = v_codif_oui AND v_abo1=v_codif_creation AND v_abo2=v_codif_creation THEN

	    SELECT ide_schema
		INTO v_temp2
		FROM pc_prise_charge
		WHERE cod_typ_piece = v_codif_od
		AND var_cpta        = p_var_cpta
		AND ide_ss_type     = v_ss_typ_reimp_ab
		AND ide_typ_poste   = p_ide_typ_poste;

		-- DEBUT - FBT - le 14/11/2007 - anomalie 136
		SELECT ide_modele_lig
		INTO v_temp4
		FROM rc_modele_ligne
		WHERE var_cpta = p_var_cpta
		AND ide_jal = p_inout_ide_jal2
		AND ide_schema = v_temp2
		AND cod_typ_pec= v_codif_pectiers
		AND ( (p_cod_type_piece=v_codif_od AND COD_SIGNE=v_codif_signe_p) OR (p_cod_type_piece=v_codif_ad AND COD_SIGNE=v_codif_signe_n) )
                AND CTL_DATE(dat_dval,sysdate)='O'   --PGE V4260 EVOL_DI44_2008_014 16/05/2008
                AND CTL_DATE(sysdate,dat_fval)='O';  --PGE V4260 EVOL_DI44_2008_014 16/05/2008
		-- FIN  - FBT - le 14/11/2007 - anomalie 136

      INSERT INTO fc_ligne (
      IDE_POSTE,
      IDE_GEST,
      IDE_JAL,
      FLG_CPTAB,
      IDE_ECR,
      IDE_LIG,
      VAR_CPTA,
      VAR_TIERS,
      IDE_TIERS,
      IDE_CPT,
      IDE_REF_PIECE,
      COD_REF_PIECE,
      VAR_BUD,
      IDE_LIG_EXEC,
      IDE_OPE,
      IDE_ORDO,
      COD_SENS,
      MT,
      SPEC1,
      SPEC2,
      SPEC3,
      OBSERV,
      DAT_CENTRA,
      DAT_TRANSF,
      IDE_SCHEMA,
      COD_TYP_SCHEMA,
      IDE_MODELE_LIG,
      DAT_ECR,
      DAT_REF,
      COD_TYP_BUD,
      COD_BUD,
      COD_BE,
      DAT_CRE,
      UTI_CRE,
      DAT_MAJ,
      UTI_MAJ,
      TERMINAL,
      FLG_ANNUL_DCST,
      IDE_PLAN_AUX,
      IDE_CPT_AUX,
      IDE_DEVISE,
      VAL_TAUX,
      MT_DEV,
      NUM_QUITTANCE,
      NOM_BQ,
      CPT_BQ
                )
    SELECT   IDE_POSTE,
       IDE_GEST,
       p_inout_ide_jal2,
       FLG_CPTAB,
       p_inout_ide_ecr2,
       (SELECT NVL(max(ide_lig)+1,1)
       		   FROM  FC_LIGNE
       		   WHERE ide_poste  = p_ide_poste
       		   AND   ide_gest   = p_ide_gest
       		   AND   ide_jal    = p_inout_ide_jal2
       		   AND   flg_cptab  = v_codif_oui
       		   AND   ide_ecr    = p_inout_ide_ecr2),
       VAR_CPTA,
       VAR_TIERS,
       IDE_TIERS,
       IDE_CPT,
       IDE_REF_PIECE,
       COD_REF_PIECE,
       VAR_BUD,
       IDE_LIG_EXEC,
       IDE_OPE,
       IDE_ORDO,
       v_codif_debit,
       MT,
       SPEC1,
       SPEC2,
       SPEC3,
       OBSERV,
       DAT_CENTRA,
       DAT_TRANSF,
	   v_temp2,
       COD_TYP_SCHEMA,
       v_temp4,
       p_inout_dat_ecr2,
       DAT_REF,
       COD_TYP_BUD,
       COD_BUD,
       COD_BE,
       DAT_CRE,
       UTI_CRE,
       DAT_MAJ,
       UTI_MAJ,
       TERMINAL,
       FLG_ANNUL_DCST,
       IDE_PLAN_AUX,
       IDE_CPT_AUX,
       IDE_DEVISE,
       VAL_TAUX,
       MT_DEV,
       NUM_QUITTANCE,
       NOM_BQ,
       CPT_BQ
    FROM   FC_LIGNE
    WHERE   ide_poste    = p_ide_poste
    AND     ide_gest    = p_ide_gest
    AND      ide_jal    = v_ide_jal
    AND   flg_cptab    = v_codif_oui
    AND   ide_ecr    = v_ide_ecr
    AND   ide_lig    = v_num_lig_s;

    --soldage des pieces
    UPDATE FC_REF_PIECE
    SET flg_solde  =v_codif_oui,
        mt_dev     =0,
        mt_db      =mt_cr,
        dat_der_mvt=p_date_jc--pge - 27/03/2008 - EVOLUTION EVO_2007_010
       WHERE  cod_ref_piece  like p_ide_ordo||'-'||p_cod_bud||'-'||p_ide_gest||'-'||p_cod_type_piece||'-'||p_ide_piece||'%';

      END IF;

  END IF;

  --si le sous-type de pièce prévoit la génération d'un règlement.
  IF p_flag_reglement = v_codif_oui THEN

     IF NVL(v_cod_ref_piece_s, ' ') != ' ' THEN
            v_cod_ref_piece := v_cod_ref_piece_s;
        ELSE
          v_cod_ref_piece := p_ide_piece;
        END IF;

      --Génération d un reglement pour chaque ligne de tiers de l'ordonnance
      MAJ_INS_REGLEMENT( p_ide_poste,
           p_ide_gest,
           p_cod_typ_nd,
           p_ide_poste,
           p_no_bord_orig,
           p_flg_emis_recu,
           v_ide_mod_reglt,
           p_cod_bud,
           p_ide_ordo,
                            v_cod_ref_piece,
           v_var_tiers,
           v_ide_tiers,
           v_var_tiers,
           v_ide_tiers,
           v_nom_bq,
           v_cpt_bq,
           v_mt,
           p_ide_devise,
           v_mt_dev_tiers,
           p_date_emis,
           v_ide_jal,
           v_ide_ecr,
           p_date_jc,
        v_ide_cpt,
        v_spec1,
        v_lib_objet_piece,
                            v_ide_plan_aux,
                            v_ide_cpt_aux,
           v_ide_reglt,
           v_ret);
   IF  v_ret = -1 Then
      p_out_retour := 52; --Erreur 58
      p_out_text_retour1:='';
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
   ELSIF v_ret  = -2 Then
      p_out_retour := 53; --Erreur 829
      p_out_text_retour1:=v_ide_mod_reglt;
        p_out_text_retour2:='';
        p_out_text_retour3:='';
      RAISE KO;
   END IF;
  END IF;

  --Mise a jour des règlement de la piece initiale
  IF p_cod_type_piece = v_codif_ad THEN
   --Test si il s'agit d'une annulation totale
         IF p_flg_reimp='T' THEN
      --Mise a jour du statut des reglements
      UPDATE FC_REGLEMENT
      SET COD_ETAT_REGLT=v_codif_rj
      WHERE cod_ref_piece LIKE p_ide_ordo||'-'||p_cod_bud||'-'||p_ide_gest||'-'||v_codif_od||'-'||GET_STRING_VALUE(p_ide_piece_init,'-',1)||'-%';
   END IF;
   --Test si il s'agit d'une annulation partielle
   IF p_flg_reimp='P' THEN
   	  IF GET_STRING_VALUE(p_lst_tiers,'-',v_num_lig_ligne_tiers)<>'N' THEN
      	 --on diminue le montant restant à régler
	  	 UPDATE FC_REGLEMENT
     	 SET MT=MT-GET_STRING_VALUE(p_lst_tiers,'-',v_num_lig_ligne_tiers),
      	 MT_DEV=MT_DEV-GET_STRING_VALUE(p_lst_tiers_dev,'-',v_num_lig_ligne_tiers)
     	 WHERE cod_ref_piece = p_ide_ordo||'-'||p_cod_bud||'-'||p_ide_gest||'-'||v_codif_od||'-'||GET_STRING_VALUE(p_ide_piece_init,'-',1)||'-'||v_num_lig_ligne_tiers;
         --on solde le règlement si celui-ci est egal à 0 - FBT le 14/11/2007 - Ano 127
		 UPDATE FC_REGLEMENT
		 SET COD_ETAT_REGLT=v_codif_rj
	  	 WHERE cod_ref_piece = p_ide_ordo||'-'||p_cod_bud||'-'||p_ide_gest||'-'||v_codif_od||'-'||GET_STRING_VALUE(p_ide_piece_init,'-',1)||'-'||v_num_lig_ligne_tiers
		 AND MT=0;
	  END IF;
    END IF;
  END IF;

  END LOOP;
 CLOSE maj_tiers_piece;


 --mise a jour de la piece annulé
 BEGIN
   SELECT flg_cf INTO v_val_flg_cf
     FROM   RM_POSTE
     WHERE  ide_poste = p_ide_poste;
 EXCEPTION
  WHEN OTHERS THEN
   p_out_retour := 54; --Erreur 105
   p_out_text_retour1:=sqlerrm;
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   RAISE KO;
 END;
 IF NVL(v_val_flg_cf, '@') = p_flg_cf_oui THEN
     v_dat_cf := TRUNC(sysdate);
  ELSE
     v_dat_cf := p_date_cf;
  END IF;
 BEGIN
    UPDATE FB_PIECE
    SET    dat_cf   = v_dat_cf,
          dat_cpta  = p_date_jc,
         dat_cad   = sysdate,
           dat_maj   = sysdate,
          uti_maj   = p_code_util,
           terminal  = p_terminal
    WHERE  ide_poste  = p_ide_poste
    AND    ide_gest  = p_ide_gest
    AND    ide_ordo  = p_ide_ordo
    AND    cod_bud   = p_cod_bud
    AND    cod_typ_piece = p_cod_type_piece
    AND    ide_piece  = p_ide_piece;
 EXCEPTION
  WHEN OTHERS THEN
   RAISE OTHERS_UPD;
 END;

  --retour de procédure
 p_out_retour:=0;
 p_out_text_retour1:='';
   p_out_text_retour2:='';
   p_out_text_retour3:='';

  -------------------------------------------------------------------------------------------------
  -----------------------------------------EXCEPTIONS----------------------------------------------
  -------------------------------------------------------------------------------------------------

 EXCEPTION
 WHEN KO THEN
     IF maj_tiers_piece%ISOPEN THEN CLOSE maj_tiers_piece; END IF;
   IF maj_ligne_piece%ISOPEN THEN CLOSE maj_ligne_piece; END IF;
    ROLLBACK;
 WHEN uniquecle THEN
    IF maj_tiers_piece%ISOPEN THEN CLOSE maj_tiers_piece; END IF;
   IF maj_ligne_piece%ISOPEN THEN CLOSE maj_ligne_piece; END IF;
      p_out_retour:=57; --alert 1138
   p_out_text_retour1:=p_ide_piece;
     p_out_text_retour2:='';
     p_out_text_retour3:='';
    ROLLBACK;
 WHEN uniquecle2 THEN
     IF maj_tiers_piece%ISOPEN THEN CLOSE maj_tiers_piece; END IF;
   IF maj_ligne_piece%ISOPEN THEN CLOSE maj_ligne_piece; END IF;
   p_out_retour:=57; --alert 1138
   p_out_text_retour1:=p_ide_piece;
     p_out_text_retour2:='';
     p_out_text_retour3:='';
    ROLLBACK;
 WHEN update_nowait THEN
     IF maj_tiers_piece%ISOPEN THEN CLOSE maj_tiers_piece; END IF;
   IF maj_ligne_piece%ISOPEN THEN CLOSE maj_ligne_piece; END IF;
    p_out_retour:=56; --alert 7
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
    ROLLBACK;
 WHEN OTHERS_UPD THEN
     IF maj_tiers_piece%ISOPEN THEN CLOSE maj_tiers_piece; END IF;
   IF maj_ligne_piece%ISOPEN THEN CLOSE maj_ligne_piece; END IF;
    p_out_retour:=1; --alert 1
   p_out_text_retour1:='';
     p_out_text_retour2:='';
     p_out_text_retour3:='';
    ROLLBACK;
 WHEN OTHERS THEN
     IF maj_tiers_piece%ISOPEN THEN CLOSE maj_tiers_piece; END IF;
   IF maj_ligne_piece%ISOPEN THEN CLOSE maj_ligne_piece; END IF;
     p_out_retour:=9999; --alert 105
   p_out_text_retour1:=sqlerrm;
     p_out_text_retour2:='';
     p_out_text_retour3:='';
   ROLLBACK;
 END ANNUL_ORDONNANCE;

/
