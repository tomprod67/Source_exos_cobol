       program-id. Program1 as "ApplicationBanque.Program1".

  
       environment division.
       input-output section.
       file-control.
           select F-CLIENT assign to
           "C:\Users\thoma\Downloads\ListeCompteClient.csv"
           organization is Line Sequential.

       data division.
       file section.
       FD F-CLIENT record varying from 0 to 255.
           01 E-CLIENT pic x(255).

       working-storage section.
       01 CLIENT.
         10 CodeClient Pic X(36).
         10 Intitule SQL CHAR-VARYING (5).
         10 Nom SQL CHAR-VARYING (30).
         10 Prenom SQL CHAR-VARYING (30).
         10 CodePostal SQL CHAR (5).
         10 Ville SQL CHAR-VARYING (30).

       01 COMPTE.
         10 CodeBanque SQL CHAR (5).
         10 CodeGuichet SQL CHAR (5).
         10 RacineCompte SQL CHAR(9).
         10 TypeCompte SQL CHAR-VARYING(2).
         10 ClesRib SQL CHAR-VARYING(2).
         10 Debit PIC 999999999999999999999V99.
         10 Credit PIC 999999999999999999999V99.



       01 DateSysteme.
         10 Annee Pic 99.
         10 Mois Pic 99.
         10 Jour Pic 99.
       77 CouleurFondEcran pic 99 value 15.
       77 CouleurCaractere pic 99 value 0.
       77 Option pic 9.
       77 FinFichier pic 9.
       77 DerniereZone pic x(14).
      *INCLURE BDD*
           77 CNXDB STRING.
           EXEC SQL
             INCLUDE SQLCA
           END-EXEC.
           EXEC SQL
             INCLUDE SQLDA
           END-EXEC.
       Screen section.
           01 menu-client  background-color is CouleurFondEcran foreground-color
             is CouleurCaractere.
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
             10 line 8 col 5 value
             "- 1 - Importation des comptes .................................... :".
             10 line 9 col 5 value
             "- 2 - Liste des banques .......................................... :".
             10 line 10 col 5 value
             "- 3 - Liste des comptes .......................................... :".
             10 line 11 col 5 value
             "- 4 - Controle des cles RIB ...................................... :".
             10 line 12 col 5 value
             "- 5 - Gestion des clients ........................................ :".
             10 line 14 col 5 value
             "- 0 - Retour au menu appelant .................................... :".

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
      *CONNEXION BDD
           MOVE
             "trusted_Connection=yes;Database=SCORPION;server=DESKTOP-JH1VHLN\SQLEXPRESS01;factory=System.Data.SqlClient;"
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
           continue.

       ImportFichier-fin.
           close F-Client.

      ******* Importation de la ligne  *************************************
       ImportationLigne.
           UNSTRING E-CLIENT delimited by ";" into
             Intitule OF CLIENT
             Nom OF CLIENT
             Prenom OF CLIENT
             CodePostal OF CLIENT
             Ville OF CLIENT
             CodeBanque OF COMPTE
             CodeGuichet OF COMPTE
             RacineCompte OF COMPTE
             TypeCompte OF COMPTE
             ClesRib OF COMPTE
             Debit OF COMPTE
             DerniereZone
           end-unstring

           UNSTRING DerniereZone delimited by " " into
             Credit OF COMPTE
           end-unstring
      *DIVISE PAR 100 POUR PASSER DES CENTIMES A L'EURO (FACON 1)
           divide 100 into
             Credit OF COMPTE
             Debit OF COMPTE
           end-divide
      ************************************************************
      *DIVISE PAR 100 POUR PASSER DES CENTIMES A L'EURO (FACON 2)*
      *divide Credit of COMPTE by 100 giving Credit Of COMPTE*****
      ************************************************************

      ************************************************************
      *On récupère le client**************************************
           exec sql
             select CodeClient into :Client.codeClient from client 
             where Nom = :Client.Nom
           end-exec.
      **********************************************************************************
      *Si il n'existe pas on génère un code client**************************************
           if (sqlcode <> 0 and SQLCODE <> 1) then
               exec sql
                 select newid() into :Client
               end-exec.

      **********************************************************************************
      *On enregistre le client *********************************************************
               exec sql
                 INSERT INTO[dbo].[Client](
                   CodeClient,
                   Intitule,
                   Nom,
                   Prenom,
                   CodePostal,
                   Ville
                 )
                 VALUES(
                   :CLIENT.CodeClient,
                   :CLIENT.Intitule,
                   :CLIENT.Nom,
                   :CLIENT.Prenom,
                   :CLIENT.CodePostal,
                   :CLIENT.Ville
                 )
               end-exec.


      **********************************************************************************
      *On enregistre le compte *********************************************************



           continue.

      **********************************************************************
      ******* Liste des banques ********************************************
      **********************************************************************
       ListeBanque.

      **********************************************************************
      ******* Liste des comptes ********************************************
      **********************************************************************
       ListeCompte.

      **********************************************************************
      ******* Contrôle des clés RIB ****************************************
      **********************************************************************
       ControleCleRib.

      **********************************************************************
      ******* Gestion des clients ******************************************
      **********************************************************************
       GestionClient.

       end program Program1.