       identification division.
       program-id. Program1 as "Fdj_Statitic.Program1".

       environment division.
       input-output section.
       file-control.
               select File-Euromillion assign to "C:\Users\thoma\Desktop\Thomas\FormationCobol\exercices-travaux-Cobol\Fdj-Statistic\euromillions.txt"
               organization is line sequential.

       data division.
       file section.
       FD File-euromillion record varying from 0 to 255.
       01 File-euromillion-line pic x(255).


       working-storage section.

       77 CNXDB STRING.
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.
           EXEC SQL
             INCLUDE SQLDA
           END-EXEC.
       
       01 DateSysteme.
         10 Annee Pic 99.
         10 Mois Pic 99.
         10 Jour Pic 99.

       01 TirageEuromillionsTemp.
         10 old_id pic 9(5).
         10 date_complete SQL CHAR(10).
         10 tirage_sans_nc SQL CHAR (14).
         10 tirage_nc SQL CHAR (5).
         10 jour pic 99.

       01 TirageEuromillions.
         10 id_tirage Pic X(36).
         10 date_complete SQL CHAR (10).
         10 mois pic 99.
         10 annee pic 9(4).
         10 tirage_complet SQL CHAR(20).
         10 num1 pic 99.
         10 num2 pic 99.
         10 num3 pic 99.
         10 num4 pic 99.
         10 num5 pic 99.
         10 numC1 pic 99.
         10 numC2 pic 99.

       77 CouleurBackground Pic 99 value 8.
       77 CouleurForeground Pic 99 value 1.

      ***** Variables liès à l'affichage du menu général *****
       77 Boucleur-Affichage-MenuGeneral pic 99.
       77 Option-MenuGeneral pic 9.

      ***** Variables liès à l'affichage du menu Loto (Option 1 du menu général) *****
       77 Boucleur-Affichage-MenuLoto pic 99.
       77 Option-MenuLoto pic 9.

      ***** Variables liès à l'affichage du sous-menu Euromillions (Option 2 du menu général) *****
       77 Boucleur-Affichage-MenuEuromillions pic 99.
       77 Option-MenuEuromillions pic 9.

      ***** Variables liès à l'importation du fichier Euromillions (Option 1 du sous-menu Euromillions) *****
       77 Boucleur-Euromillions-Importation-FileToDB pic 9.
       77 Importation-Euromillions-DerniereZone pic x(2).
       77 Importation-Euromillions-LigneNo pic 9(6).
       77 Importation-Euromillions-LigneNoDivide pic 9(6).
       77 Importation-Euromillions-Loading pic X(10) value all "-".

      ***** Variables liès à l'affichage des tirages Euromillions (Option 2 du sous-menu Euromillions) *****
       77 Affichage-Euromillions-Tirage-NoLigne pic 99.
       77 Boucleur-Euromillions-Liste-Tirage pic 9.
       77 Euromillions-Liste-Tirage-ReponseOfUser pic X.

      ***** Variables liès aux statistique Euromillions (Option 3 du sous-menu Euromillions) *****
       77 Euromillions-Statistique-ReponseOfUser pic X(4).
       77 Boucleur-Euromillions-Statistique pic X.
       

       screen section.

      ********************************************************************************
      ******************** Structure de données du Menu général **********************
      ********************************************************************************
       01 MenuGeneral background-color is CouleurBackground blink foreground-color is CouleurForeground.
         10 line 3 col 25 value "Statistiques Loto/Euromillions".
         10 line 4 col 1 pic x(80) value all "_".
         10 line 6 col 30 value "Choisissez votre jeu".
         10 line 8 col 20 value "- 1 - Loto .............".
         10 line 9 col 20 value "- 2 - Euromillion ......".
         10 line 10 col 20 value "- 3 - EXIT .............".
         10 line 12 col 30 value "Choix de votre option :".
         10 line 12 col 54 from Option-MenuGeneral.

       01 General-Header-Infos background-color is CouleurBackground blink foreground-color is CouleurForeground.
         10 line 1 col 1 Blank Screen.
         10 line 1 col 60 value "By Tomprod".
         10 line 1 col 3 value "Date :".
         10 line 1 col 10 from Jour of DateSysteme.
         10 line 1 col 12 value "/".
         10 line 1 col 13 from Mois of DateSysteme.
         10 line 1 col 15 value "/".
         10 line 1 col 16 from Annee of DateSysteme.
         10 line 2 col 1 pic x(80) value all "_".

      ************************************************************************
      ***** Structure de données du Menu Loto (option 1 du menu général) *****
      ************************************************************************
       01 MenuLoto background-color is CouleurBackground blink foreground-color is CouleurForeground.
         10 line 3 col 25 value "Statistiques Loto".
         10 line 4 col 1 pic x(80) value all "_".
         10 line 6 col 30 value "Que voulez vous faire ?".
         10 line 8 col 10 value "- 1 - Importation des nouveaux tirages en BDD .....".
         10 line 9 col 10 value "- 2 - Liste des tirages ...........................".
         10 line 10 col 10 value "- 3 - Statistiques des numeros et tirages .......".
         10 line 11 col 10 value "- 4 - Calcul des probalites .....................".
         10 line 12 col 10 value "- 5 - Retour au Menu general ....................".
         10 line 14 col 30 value "Choix de votre option :".
         10 line 14 col 54 from Option-MenuLoto.

      ********************************************************************************
      ***** Structure de données du Menu Euromillions (option 2 du menu général) *****
      ********************************************************************************
       01 MenuEuromillions background-color is CouleurBackground blink foreground-color is CouleurForeground.
         10 line 3 col 25 value "Statistiques Euromillions".
         10 line 4 col 1 pic x(80) value all "_".
         10 line 6 col 30 value "Choisissez votre jeu".
         10 line 8 col 10 value "- 1 - Importation des nouveaux tirages en BDD ...".
         10 line 9 col 10 value "- 2 - Liste des tirages .........................".
         10 line 10 col 10 value "- 3 - Statistiques des numeros et tirages ......".
         10 line 11 col 10 value "- 4 - Calcul des probalites ....................".
         10 line 12 col 10 value "- 5 - Retour au Menu general ...................".
         10 line 14 col 30 value "Choix de votre option :".
         10 line 14 col 54 from Option-MenuEuromillions.

      ***************************************************************************************************
      ***** Structure de données de l'affichage "Liste tirage" (option 2 du sous-menu Euromillions) *****
      ***************************************************************************************************
       01 Euromillions-Affichage-ListeTirage-Header background-color is CouleurBackground blink foreground-color is CouleurForeground.
         10 line 3 col 25 value "Tirages Euromillions".
         10 line 4 col 1 pic x(80) value all "_".
         10 line 5 col 1 background-color is CouleurForeground foreground-color is CouleurBackground pic X(80) VALUE "    Date           Num1    Num2    Num3    Num4    Num5    NumC1    NumC2".

       01 Euromillions-Affichage-ListeTirage-Body background-color is CouleurBackground blink foreground-color is CouleurForeground.
         10 line Affichage-Euromillions-Tirage-NoLigne col 3 from date_complete of TirageEuromillions.
         10 line Affichage-Euromillions-Tirage-NoLigne col 21 from num1 of TirageEuromillions.
         10 line Affichage-Euromillions-Tirage-NoLigne col 29 from num2 of TirageEuromillions.
         10 line Affichage-Euromillions-Tirage-NoLigne col 37 from num3 of TirageEuromillions.
         10 line Affichage-Euromillions-Tirage-NoLigne col 45 from num4 of TirageEuromillions.
         10 line Affichage-Euromillions-Tirage-NoLigne col 53 from num5 of TirageEuromillions.
         10 line Affichage-Euromillions-Tirage-NoLigne col 61 from numC1 of TirageEuromillions.
         10 line Affichage-Euromillions-Tirage-NoLigne col 70 from numC2 of TirageEuromillions.
       
       01 Euromillions-Affichage-ListeTirage-Footer background-color is CouleurBackground foreground-color is CouleurForeground.
         10 line 1 Col 1 ERASE EOL.
         10 LINE 6 Col 1 ERASE EOS.

       01 Euromillions-Affichage-Statistique-Header background-color is CouleurBackground blink foreground-color is CouleurForeground.
         10 line 3 col 25 value "Statistiques Euromillions".
         10 line 4 col 1 pic x(80) value all "-".
         10 line 5 col 1 background-color is CouleurForeground foreground-color is CouleurForeground.
      *01 Euromillions-Affichage-Statistique-Body.
      *  10 line Affichage-Euromillions-Tirage-NoLigne col 3 from  of TirageEuromillions.
      *  10 line Affichage-Euromillions-Tirage-NoLigne col 21 from num1 of TirageEuromillions.
      *  10 line Affichage-Euromillions-Tirage-NoLigne col 29 from num2 of TirageEuromillions.
      *  10 line Affichage-Euromillions-Tirage-NoLigne col 37 from num3 of TirageEuromillions.
      *  10 line Affichage-Euromillions-Tirage-NoLigne col 45 from num4 of TirageEuromillions.
      *  10 line Affichage-Euromillions-Tirage-NoLigne col 53 from num5 of TirageEuromillions.
      *  10 line Affichage-Euromillions-Tirage-NoLigne col 61 from numC1 of TirageEuromillions.
      *  10 line Affichage-Euromillions-Tirage-NoLigne col 70 from numC2 of TirageEuromillions.


       procedure division.

      *************************************************************************************************************
      *===========================================================================================================*
      ********************************* Affichage du menu général *************************************************
      *===========================================================================================================*
      *************************************************************************************************************
       Affichage-MenuGeneral.
           perform Affichage-MenuGeneral-Init.
           perform Affichage-MenuGeneral-Trt until Boucleur-Affichage-MenuGeneral = 1.
           perform Affichage-MenuGeneral-Fin.

       Affichage-MenuGeneral-Init.
           
           perform DB-Connection.
           move 0 to Boucleur-Affichage-MenuGeneral.
           accept DateSysteme from date.

       Affichage-MenuGeneral-Trt.
           display General-Header-Infos.
           display MenuGeneral.
           accept Option-MenuGeneral line 12 col 54.
           evaluate Option-MenuGeneral
               when 1
                   perform Affichage-MenuLoto
               when 2
                   perform Affichage-MenuEuromillions
               when other
                   continue
           end-evaluate.

       Affichage-MenuGeneral-Fin.
           stop run.

      *************************************************************************************************************
      *===========================================================================================================*
      ****************** Affichage du sous menu Loto (Option 1 du Menu général) ***********************************
      *===========================================================================================================*
      *************************************************************************************************************
       Affichage-MenuLoto.
           perform Affichage-MenuLoto-Init.
           perform Affichage-MenuLoto-Trt until Boucleur-Affichage-MenuLoto = 1.
           perform Affichage-MenuLoto-Fin.

       Affichage-MenuLoto-Init.
           move 0 to Boucleur-Affichage-MenuLoto.
           accept DateSysteme from date.

       Affichage-MenuLoto-Trt.
           display General-Header-Infos.
           display MenuLoto.
           accept DateSysteme from date.
           evaluate Option-MenuLoto
               when 1
                   perform Loto-Importation-FileToDB
               when 2
                   perform Loto-Liste-Tirages
               when 3
                   perform Loto-Statistique
               when 4
                   perform Loto-Probalites
               when 5
                   perform Affichage-MenuGeneral
               when other
                   continue
           end-evaluate.
        
       Affichage-MenuLoto-Fin.
           continue.

      *************************************************************************************************************
      *===========================================================================================================*
      ********************* Affichage du sous menu Euromillion (Option 2 du Menu general) *************************
      *===========================================================================================================*
      *************************************************************************************************************
       Affichage-MenuEuromillions.
           perform Affichage-MenuEuromillions-Init.
           perform Affichage-MenuEuromillions-Trt until Boucleur-Affichage-MenuEuromillions = 1.
           perform Affichage-MenuEuromillions-Fin.

       Affichage-MenuEuromillions-Init.
           move 0 to Boucleur-Affichage-MenuEuromillions.
           accept DateSysteme from date.

       Affichage-MenuEuromillions-Trt.
           display General-Header-Infos.
           display MenuEuromillions.
           accept Option-MenuEuromillions line 14 col 54.
           evaluate Option-MenuEuromillions
               when 1
                   perform Euromillions-Importation-FileToDB
               when 2
                   perform Euromillions-Liste-Tirages
               when 3
                   perform Euromillions-Statistique
               when 4
                   perform Euromillion-Probalites
               when 5
                   move 1 to Boucleur-Affichage-MenuEuromillions
               when other 
                   continue
           end-evaluate.

       Affichage-MenuEuromillions-Fin.
           continue.

      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *===========================================================================================================*
      ************************* Options du sous-menu Loto (Option 1 du Menu général) ******************************
      *===========================================================================================================*
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************

       Loto-Importation-FileToDB.
       Loto-Liste-Tirages.
       Loto-Statistique.
       Loto-Probalites.

      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *===========================================================================================================*
      ********************** Options du sous-menu Euromillions (Option 2 du Menu général) *************************
      *===========================================================================================================*
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************

      ******************************************************************************************************************
      *================================================================================================================*
      ************ Euromillions : Importation du fichier vers BDD (Option 1 du Sous-Menu Euromillions) *****************
      *================================================================================================================*
      ******************************************************************************************************************
       Euromillions-Importation-FileToDB.
           perform Euromillions-Importation-FileToDB-Init.
           perform Euromillions-Importation-FileToDB-Trt until Boucleur-Euromillions-Importation-FileToDB = 1.
           perform Euromillions-Importation-FileToDB-Fin.

       Euromillions-Importation-FileToDB-Init.
           move 0 to Boucleur-Euromillions-Importation-FileToDB.
           move 0 to Importation-Euromillions-ligneNo.
           open input File-Euromillion.

       Euromillions-Importation-FileToDB-Trt.
           read File-Euromillion
               at end
                   move 1 to Boucleur-Euromillions-Importation-FileToDB
               not at end
                   perform Euromillion-Importation-LigneOfFile
           end-read.
       Euromillions-Importation-FileToDB-Fin.
           close File-Euromillion.


      ******************************************************************************
      ******************* Euromillion-Importation-LigneOfFile **********************
      ******************************************************************************
       Euromillion-Importation-LigneOfFile.
           add 1 to Importation-Euromillions-ligneNo.

      ***** Casse le ligne aux délimiteurs *****
      ***** On enferme les différentes partie dans les endroits respectifs *****
           unstring File-euromillion-line delimited by ";" into
             old_id of TirageEuromillionsTemp
             date_complete of TirageEuromillionsTemp
             tirage_sans_nc of TirageEuromillionsTemp
             tirage_nc of TirageEuromillionsTemp
           end-unstring.

           unstring date_complete of TirageEuromillionsTemp delimited by "/" into
             jour of TirageEuromillionsTemp
             mois of TirageEuromillions
             annee of TirageEuromillions
           end-unstring.

           unstring tirage_sans_nc of TirageEuromillionsTemp delimited by "-" into
             num1 of TirageEuromillions
             num2 of TirageEuromillions
             num3 of TirageEuromillions
             num4 of TirageEuromillions
             Importation-Euromillions-DerniereZone
           end-unstring.

           unstring Importation-Euromillions-DerniereZone delimited by " " into
             num5 of TirageEuromillions
           end-unstring.

           unstring tirage_nc of TirageEuromillionsTemp delimited by "-" into
             numC1 of TirageEuromillions
             Importation-Euromillions-DerniereZone
           end-unstring.

           unstring Importation-Euromillions-DerniereZone delimited by " " into
             numC2 of TirageEuromillions
           end-unstring.
      ***** Concatenation pour avoir le tirage Complet *****
           string tirage_sans_nc of TirageEuromillionsTemp "/" tirage_nc of TirageEuromillionsTemp into tirage_complet of TirageEuromillions.
      ***** On recherche l'id du tirage dans la bdd du tirage actuel du doc *****
           exec sql
              select id_tirage into :TirageEuromillions.id_tirage
              from TiragesEuromillions
              where date_complete = :TirageEuromillionsTemp.date_complete
           end-exec.
      ***** Si il existe et qu'il n'y a pas d'erreur *****
           if (sqlcode <> 0 and sqlcode <> 1) then
      ***** On met en place le chargement pendant l'importation *****
               divide Importation-Euromillions-ligneNo by 160 giving Importation-Euromillions-LigneNoDivide
               if Importation-Euromillions-ligneNo = 1 then
                   display "IMPORTATION EN COURS" line 24 col 2
               end-if
               evaluate Importation-Euromillions-LigneNoDivide
                   when = 1
                       display Importation-Euromillions-Loading line 24 col 25
                   when = 3
                       display Importation-Euromillions-Loading line 24 col 35
                   When = 5
                       display Importation-Euromillions-Loading line 24 col 45
                   when = 8
                       display Importation-Euromillions-Loading line 24 col 55
               end-evaluate
      ***** Si il n'y a pas d'erreur et que l'id du tirage n'est pas trouvé en BDD, on l'enregistre en base *****
           exec sql
                   select newid() into :TirageEuromillions.id_tirage
               end-exec
               exec sql
                   INSERT INTO [dbo].TiragesEuromillions (id_tirage, date_complete, mois, annee, tirage_complet, num1, num2, num3, num4, num5, numC1, numC2)
                   VALUES (:TirageEuromillions.id_tirage, :TirageEuromillionsTemp.date_complete, :TirageEuromillions.mois, :TirageEuromillions.annee,
                           :TirageEuromillions.tirage_complet, :TirageEuromillions.num1, :TirageEuromillions.num2, :TirageEuromillions.num3,
                           :TirageEuromillions.num4, :TirageEuromillions.num5, :TirageEuromillions.numC1, :TirageEuromillions.numC2)
               end-exec
           end-if.

      ******************************************************************************************************************
      *================================================================================================================*
      ******************** Euromillions : Liste des tirages (Option 2 du Sous-Menu Euromillions) ***********************
      *================================================================================================================*
      ******************************************************************************************************************
       Euromillions-Liste-Tirages.
       perform Euromillions-Liste-Tirages-Init.
       perform Euromillions-Liste-Tirages-Trt until Boucleur-Euromillions-Liste-Tirage = 1.
       perform Euromillions-Liste-Tirages-Fin.

       Euromillions-Liste-Tirages-Init.
           move 0 to Boucleur-Euromillions-Liste-Tirage.

           move 6 to Affichage-Euromillions-Tirage-NoLigne.

           display General-Header-Infos.
           display Euromillions-Affichage-ListeTirage-Header.

      ***** Declaration du curseur *****
           exec sql
              declare Cursor-Euromillion-ListeTirage cursor for
                  select date_complete, num1, num2, num3, num4, num5, numC1, numC2
                  from TiragesEuromillions
                  Order by annee DESC, mois DESC, date_complete DESC
          end-exec.

      ***** Ouverture du curseur *****
           exec sql
               open Cursor-Euromillion-ListeTirage
           End-exec.
           
       Euromillions-Liste-Tirages-Trt.
      ***** On recupere le resultat(la ligne) que le pointeur cible *****
           exec sql
               fetch Cursor-Euromillion-ListeTirage into :TirageEuromillions.date_complete,
               :TirageEuromillions.num1,
               :TirageEuromillions.num2,
               :TirageEuromillions.num3,
               :TirageEuromillions.num4,
               :TirageEuromillions.num5,
               :TirageEuromillions.numC1,
               :TirageEuromillions.numC2
           end-exec.
      ***** Si il y a un resultat, on passe sur le perform AffichageLigne *****
           if SqlCode = 0 or SqlCode = 1 then
               perform Euromillions-ListeTirage-Affichage-LigneCompte
      ***** Sinon on affiche la fin *****
           else
               move 1 to Boucleur-Euromillions-Liste-Tirage
               display "Fin de la liste des tirages - Tapez Entree " line 23 col 2 with no advancing
               accept Euromillions-Liste-Tirage-ReponseOfUser
           End-if.

       Euromillions-Liste-Tirages-Fin.
           exec sql
      ***** On referme le cursor *****
               close Cursor-Euromillion-ListeTirage
           end-exec.

      ****************************************************************************************
      ******************* Euromillion-ListeTirage-Affichage-LigneCompte **********************
      ****************************************************************************************
       Euromillions-ListeTirage-Affichage-LigneCompte.
           perform Euromillions-ListeTirage-Affichage-LigneCompte-Init.
           perform Euromillions-ListeTirage-Affichage-LigneCompte-Trt.
           perform Euromillions-ListeTirage-Affichage-LigneCompte-Fin.
       Euromillions-ListeTirage-Affichage-LigneCompte-Init.
      ***** Affichage de la ligne courante *****
           add 1 to Affichage-Euromillions-Tirage-NoLigne.
           move " " to Euromillions-Liste-Tirage-ReponseOfUser.
           display Euromillions-Affichage-ListeTirage-Body.
       Euromillions-ListeTirage-Affichage-LigneCompte-Trt.
      ***** * Choix des option "suivante" "précédent" "Menu" en bas de page *****
           if Affichage-Euromillions-Tirage-NoLigne = 21 then
               display "Page [S]uivant - [M]enu : " blink line 23 col 2 blank line with no advancing
               accept Euromillions-Liste-Tirage-ReponseOfUser col 28 line 23

      ***** Si on arrête, on positionne la fin de fichier *****
               if Euromillions-Liste-Tirage-ReponseOfUser = "m" then
                   move "M" to Euromillions-Liste-Tirage-ReponseOfUser
               end-if
               if Euromillions-Liste-Tirage-ReponseOfUser = "s" then
                   move "S" to Euromillions-Liste-Tirage-ReponseOfUser
               end-if

               evaluate Euromillions-Liste-Tirage-ReponseOfUser
                   when "S"
                       move 5 to Affichage-Euromillions-Tirage-NoLigne
                       display Euromillions-Affichage-ListeTirage-Footer
                   when other
                       move 1 to Boucleur-Euromillions-Liste-Tirage
               end-evaluate
           end-if.
       Euromillions-ListeTirage-Affichage-LigneCompte-Fin.
           continue.

      ******************************************************************************************************************
      *================================================================================================================*
      ******************** Euromillions : Statistique (Option 3 du Sous-Menu Euromillions) *****************************
      *================================================================================================================*
      ******************************************************************************************************************
       Euromillions-Statistique.
           perform Euromillions-Statistique-Init.
           perform Euromillions-Statistique-Trt until Boucleur-Euromillions-Statistique = 1.
           perform Euromillions-Statistique-Fin.

       Euromillions-Statistique-Init.
           move 0 to Boucleur-Euromillions-Statistique.
           move " " to Euromillions-Statistique-ReponseOfUser.
           display General-Header-Infos.
           display Euromillions-Affichage-Statistique-Header.
           display "Tapez [R] pour Retour, [A] pour ALL ou directement l'annee souhaitee: " line 7 col 2.
      *    display "Choisissez les statistiques [T]irages ou les statistiques [N]umeros :" line 7 col 2.
           accept Euromillions-Statistique-ReponseOfUser line 7 col 73.

           if Euromillions-Statistique-ReponseOfUser = "r" then
               move "R" to Euromillions-Statistique-ReponseOfUser
           end-if.
           if Euromillions-Statistique-ReponseOfUser = "a" then
               move "A" to Euromillions-Statistique-ReponseOfUser
           end-if.
           if Euromillions-Statistique-ReponseOfUser is not numeric
               move 1 to Boucleur-Euromillions-Statistique
           else
               if Euromillions-Statistique-ReponseOfUser is numeric
                   evaluate Euromillions-Statistique-ReponseOfUser
                       when >= 2004
                           perform Euromillions-Statistique-ByYear
                       when > Annee of Datesysteme
                           move 1 to Boucleur-Euromillions-Statistique
                   end-evaluate
               end-if
           end-if.

           evaluate Euromillions-Statistique-ReponseOfUser
               when "R"
                   move 1 to Boucleur-Euromillions-Statistique
               when "A"
                   perform Euromillions-Statistique-AllPeriode
           end-evaluate.

       Euromillions-Statistique-Trt.
       Euromillions-Statistique-Fin.

       Euromillions-Statistique-ByYear.
           perform Euromillions-Statistique-ByYear-Init.
           perform Euromillions-Statistique-ByYear-Trt.
           perform Euromillions-Statistique-ByYear-Fin.
       Euromillions-Statistique-ByYear-Init.
           exec sql
              declare Cursor-Euromillions-ListeTirageByYear cursor for
                  select date_complete, num1, num2, num3, num4, num5, numC1, numC2
                  from TiragesEuromillions
                  Where annee = :Euromillions-Statistique-ReponseOfUser
                  Order by annee DESC, mois DESC, date_complete DESC
          end-exec.
           exec sql
             open Cursor-Euromillions-ListeTirageByYear
           end-exec.
       Euromillions-Statistique-ByYear-Trt.
           exec sql
               fetch Cursor-Euromillions-ListeTirageByYear
               into :TirageEuromillions.date_complete,
               :TirageEuromillions.num1,
               :TirageEuromillions.num2,
               :TirageEuromillions.num3,
               :TirageEuromillions.num4,
               :TirageEuromillions.num5,
               :TirageEuromillions.numC1,
               :TirageEuromillions.numC2
           end-exec.
      ***** Si il y a un resultat, on passe sur le perform AffichageLigne *****
           if SqlCode = 0 or SqlCode = 1 then
               display "ok" line 24 col 4
               accept Boucleur-Affichage-MenuEuromillions
      ***** Sinon on affiche la fin *****
           else
               move 1 to Boucleur-Euromillions-Liste-Tirage
               display "Fin de la liste des tirages - Tapez Entree " line 23 col 2 with no advancing
               accept Euromillions-Liste-Tirage-ReponseOfUser
           End-if.
       Euromillions-Statistique-ByYear-Fin.
           continue.

       Euromillions-ListeTirageByYear-Affichage-LigneCompte.
       Euromillions-Statistique-AllPeriode.
           perform Euromillions-Statistique-AllPeriode-Init.
           perform Euromillions-Statistique-AllPeriode-Trt.
           perform Euromillions-Statistique-AllPeriode-Fin.

       Euromillions-Statistique-AllPeriode-Init.
       Euromillions-Statistique-AllPeriode-Trt.
       Euromillions-Statistique-AllPeriode-Fin.
       Euromillions-Statistique-Tirage.
           perform Euromillions-Statistique-Tirage-Init.
           perform Euromillions-Statistique-Tirage-Trt.
           perform Euromillions-Statistique-Tirage-Fin.

       Euromillions-Statistique-Tirage-Init.

       Euromillions-Statistique-Tirage-Trt.
       Euromillions-Statistique-Tirage-Fin.

       Euromillions-Statistique-Numero.
           perform Euromillions-Statistique-Numero-Init.
           perform Euromillions-Statistique-Numero-Trt.
           perform Euromillions-Statistique-Numero-Fin.

       Euromillions-Statistique-Numero-Init.
       Euromillions-Statistique-Numero-Trt.
       Euromillions-Statistique-Numero-Fin.


      ******************************************************************************************************************
      *================================================================================================================*
      ******************** Euromillions : Probalité (Option 4 du Sous-Menu Euromillions) *******************************
      *================================================================================================================*
      ******************************************************************************************************************
       Euromillion-Probalites.

      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *===========================================================================================================*
      ************************************** UTILITAIRES **********************************************************
      *===========================================================================================================*
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
      *************************************************************************************************************
       DB-Connection.
           MOVE
             "trusted_Connection=yes;Database=FDJ-STATISTIC;server=DESKTOP-JH1VHLN\SQLEXPRESS01;factory=System.Data.SqlClient;"
             TO CNXDB.
           exec sql
               Connect using :CnxDb
           end-exec
           if (SQLCODE not equal 0) then
               stop run
           end-if.
           exec sql
             SET AUTOCOMMIT ON
           end-exec.

       end program Program1.
