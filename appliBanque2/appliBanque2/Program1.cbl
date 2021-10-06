       program-id. Program1 as "AppliBanque2.Program1".

       environment division.
       input-output section.
       file-control.
           select F-CLIENT assign to "C:\Users\thoma\Downloads\ListeCompteClient.csv"
           organization is Line Sequential.

       data division.
       file section.
       FD F-CLIENT record varying from 0 to 255.
       01 E-CLIENT pic x(255).

       working-storage section.
       01 DateSysteme.
         10 Annee Pic 99.
         10 Mois Pic 99.
         10 Jour Pic 99.

       01 CLIENT.
         10 CodeClient PIC X(36).
         10 Intitule SQL CHAR-VARYING (5).
         10 Nom SQL CHAR-VARYING (30).
         10 Prenom SQL CHAR-VARYING (30).
         10 CodePostal SQL CHAR (5).
         10 Ville SQL CHAR-VARYING (30).

       01 COMPTE.
         10 CodeBanque SQL CHAR (5).
         10 CodeGuichet SQL CHAR (5).
         10 CompteComplet.
           20 RacineCompte SQL CHAR (9).
           20 TypeCompte SQL CHAR (2).
         10 CleRIB SQL CHAR (2).
         10 Debit PIC 9(12)V99.
         10 Credit PIC 9(12)V99.
         10 CodeClient PIC X(36).

       01 Banque.
         10 CodeBanque sql char (5).
         10 NomBanque SQL CHAR-VARYING (255).

       77 CouleurFondEcran pic 99 value 15.
       77 CouleurCaractere pic 99 value 0.
      *77 CouleurFondEcran         pic 99 value 1  .
      *77 CouleurCaractere         pic 99 value 14.

       77 Option pic 9.
       77 FinFichier pic 9.
       77 DerniereZone pic x(14).
       77 ListeBanque-Eof pic 9.
       77 Reponse pic X.
       77 NoLigne pic 99.

      * Déclaration des variables SQL Server
       77 CNXDB STRING.
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

           EXEC SQL
               INCLUDE SQLDA
           END-EXEC.

       Screen section.

       01 menu-client background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line 1 col 1 Blank Screen.
         10 line 3 col 32 value " GESTION BANCAIRE ".
         10 line 5 col 2 value " Date systeme :".
         10 line 5 col 18 from Jour of DateSysteme.
         10 line 5 col 20 value "/".
         10 line 5 col 21 from Mois of DateSysteme.
         10 line 5 col 23 value "/".
         10 line 5 col 24 from Annee of DateSysteme.
         10 line 5 col 69 value " Option :".
         10 line 5 col 79 pic 9 from Option.
         10 line 8 col 5 value "- 1 - Importation des comptes .................................... :".
         10 line 9 col 5 value "- 2 - Liste des banques .......................................... :".
         10 line 10 col 5 value "- 3 - Liste des comptes .......................................... :".
         10 line 11 col 5 value "- 4 - Controle des cles RIB ...................................... :".
         10 line 12 col 5 value "- 5 - Gestion des clients ........................................ :".
         10 line 14 col 5 value "- 0 - Retour au menu appelant .................................... :".

       01 ListeBanque-E background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line 1 col 1 blank screen.
         10 line 3 col 32 value "LISTE DES BANQUES".
         10 line 5 col 1 background-color is CouleurCaractere foreground-color is CouleurFondEcran pic X(80) VALUE " Code   Nom".

       01 ListeBanque-L background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line noLigne Col 2 from CodeBanque of banque.
         10 line noligne col 8 from NomBanque of banque pic X(70).

       01 ListeBanque-F background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line 1 Col 1 ERASE EOL.
         10 LINE 6 Col 1 ERASE EOS.

       procedure division.

      **********************************************************************
      ******* Gestion du menu **********************************************
      **********************************************************************
       Menu.
           perform Menu-Init.
           perform Menu-Trt until Option = 0.
           perform Menu-Fin.

       Menu-Init.
           move 1 to Option.
           accept DateSysteme from date.

      * Connexion à la base de données
           MOVE
             "Trusted_Connection=yes;Database=SCORPION;server=DESKTOP-JH1VHLN\SQLEXPRESS01;factory=System.Data.SqlClient;"
             to cnxDb.

           exec sql
               Connect using :CnxDb
           end-exec.
           if (sqlcode not equal 0) then
               stop run
           end-if.

           exec sql
               SET AUTOCOMMIT ON
           end-exec.

       Menu-Trt.
           move 0 to Option.
           display menu-client.
           accept Option line 5 col 79.

           evaluate Option
               when 1
                   perform ImportFichier
               when 2
                   perform ListeBanque
               when 3
                   perform ListeCompte
               when 4
                   perform ControleCleRib
               when 5
                   perform GestionClient
           end-evaluate.

       Menu-Fin.
           stop run.

      **********************************************************************
      ******* Importation du fichier ***************************************
      **********************************************************************
       ImportFichier.
           perform ImportFichier-init.
           perform ImportFichier-trt until FinFichier = 1.
           perform ImportFichier-fin.

       ImportFichier-init.
           move 0 to FinFichier.
           open INPUT F-Client.
           read F-Client
               at end
                   move 1 to FinFichier
           end-read.

       ImportFichier-trt.
           read F-Client
               at end
                   move 1 to FinFichier
               not at end
                   perform ImportationLigne
           end-read.

       ImportFichier-fin.
           close F-Client.

      ******* Importation de la ligne  *************************************
       ImportationLigne.
           unstring E-CLIENT delimited by ";" into
             Intitule of CLIENT
             Nom of CLIENT
             Prenom of CLIENT
             CodePostal of CLIENT
             Ville of CLIENT
             CodeBanque of Compte
             CodeGuichet of Compte
             RacineCompte of Compte
             TypeCompte of Compte
             CleRIB of Compte
             Debit of Compte
             DerniereZone
           end-unstring.

           unstring DerniereZone delimited by " " into
             Credit of Compte
           end-unstring.

      **************** On met les montants en Euros  ***********************
           divide 100 into Debit of COMPTE.
           divide Credit of COMPTE by 100 giving Credit of COMPTE.

      **************** On recupère le client ******************************
           exec sql
               select CodeClient into :Client.CodeClient from client
               where Nom = :Client.Nom
           end-exec.

      ******** S'il n'existe pas on genère un code client ******************
           if (sqlcode <> 0 and sqlcode <> 1) then
               exec sql
                   select newid() into :Client.CodeClient
               end-exec

      ************** On enregistre le client *******************************

               exec sql
                   INSERT INTO [dbo].[Client]
                       (CodeClient
                       ,[Intitule]
                       ,[Nom]
                       ,[Prenom]
                       ,[CodePostal]
                       ,[Ville])
                   VALUES
                       (:CLIENT.CodeClient
                       ,:CLIENT.Intitule
                       ,:CLIENT.Nom
                       ,:CLIENT.Prenom
                       ,:CLIENT.CodePostal
                       ,:CLIENT.Ville)
               End-exec
           end-if.

      *    Insertion de la ligne compte
           exec sql
               INSERT INTO Compte
                   (CodeBanque
                   ,CodeGuichet
                   ,RacineCompte
                   ,TypeCompte
                   ,CleRib
                   ,Debit
                   ,Credit
                   ,CodeClient)
               VALUES
                   (:Compte.CodeBanque
                   ,:Compte.CodeGuichet
                   ,:Compte.RacineCompte
                   ,:Compte.TypeCompte
                   ,:Compte.CleRib
                   ,:Compte.Debit
                   ,:Compte.Credit
                   ,:Client.CodeClient)
           end-exec.

      **********************************************************************
      ******* Liste des banques ********************************************
      **********************************************************************
      *=============================================================
      * Lecture du fichier en entrée
      *=============================================================

       ListeBanque.
           perform ListeBanque-Init.
           perform ListeBanque-Trt until ListeBanque-Eof = 1.
           perform ListeBanque-Fin.

      * Initialisation du traitement
      *----------------------------------------------------------
      *----------------- Initialisation du traitement -----------
      *----------------------------------------------------------
       ListeBanque-init.
           move 0 to ListeBanque-Eof.

      * Déclaration du curseur
           exec sql
               declare C-ListeBanque cursor for
                   select CodeBanque, NomBanque from Banque
                          Order by NomBanque
           end-exec.

      * Ouverture du curseur
           exec sql
               open C-ListeBanque
           End-exec.

      * Affichage de l'écran
           display ListeBanque-E.
           move 5 to Noligne.

      *----------------------------------------------------------
      *----------------- Boucle de traitement -------------------
      *----------------------------------------------------------
       ListeBanque-Trt.
      * Lecture d'une ligne de la table
           exec sql
               fetch C-ListeBanque into :Banque.CodeBanque,
                   :Banque.NomBanque
           end-exec.
           if SqlCode = 0 or SqlCode = 1 then
               perform AffichageLigne
           else
               move 1 to ListeBanque-Eof
               display "Fin de la liste des banques - Tapez Entree " line 1 col 1 with no advancing
               accept reponse
           End-if.

      *----------------------------------------------------------
      *----------------- Fin du traitement sur le curseur -------
      *----------------------------------------------------------
       ListeBanque-Fin.
           exec sql
               close C-ListeBanque
           end-exec.

      *----------------------------------------------------------
      *----------------- Affichage de la ligne ------------------
      *----------------------------------------------------------
       AffichageLigne.

      * Affichage de la ligne
           add 1 to NoLigne.
           display ListeBanque-L.

      * En bas de page, on pose la question si on continue
           if Noligne = 21 then
               display "Page [S]uivante - [m]enu : " line 1 Col 2 blank line with no advancing
               accept reponse

      * Si on arrête, on positionne la fin de fichier
               if reponse = "m" or reponse = "M" then
                   move 1 to ListeBanque-Eof

      * Si on continue on revient au début de la page
               else
                   move 5 to Noligne
                   display ListeBanque-F
               end-if
           end-if.

      **********************************************************************
      ******* Liste des comptes ********************************************
      **********************************************************************
       ListeCompte.

      **********************************************************************
      ******* Contrôle des clés RIB ****************************************
      **********************************************************************
       ControleCleRib.
      ***** Recuperation des compte *****
           exec sql
               SELECT
                   CodeBanque,
                   CodeGuichet,
                   RacineCompte,
                   TypeCompte,
                   CleRib,
                   Debit,
                   Credit,
                   CodeClient
               FROM Compte
           end-exec.

      **********************************************************************
      ******* Gestion des clients ******************************************
      **********************************************************************
       GestionClient.

       end program Program1.

