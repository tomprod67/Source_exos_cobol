      ***** IDENTIFICATION DIVISION (Nom Programme, Nom Author) *****
       identification division.
        program-id. Program1 as "TestTuto.Program1".
        author. Tomprod.
      ********************************************************************************************************
      ***** ENVIRONMENT DIVISION (D�pendante de la machine et des fichiers) (INUTILE SI PAS DE FICHIERS) *****
      ********************************************************************************************************
       environment division.

      **************************************************************************
      ***** CONFIGURATION SECTION (D�crire la configuration de la machine) *****
        configuration section.

      ***** SOURCE-COMPUTER (Le nom de la machine) *****
         source-computer. SRF-EN1-16 with debugging mode.

      ***** OBJECT-COMPUTER (Pour quel machine est fait le programme + Alphabet utilis� ) *****
         object-computer. SRF-EN1-16 program collating sequence is EB-EBCDIC.

      ***** SPECIAL-NAMES (Diff�rents reglages sur le programme : choix alphabet, point d�cimal = comma (,) , currency sign) *****
         special-names.
         alphabet EB-EBCDIC is native
         decimal-point is comma
         currency sign is "�".

      **********************************************************************************************
      ***** INPUT-OUTPUT SECTION (D�crire fichiers, file-control, I-O-Control, gestion m�moire ***** 
        input-output section.

      ***** FILE-CONTROL (Controle des fichiers � importer) *****
         file-control.

      ***** SELECT (Selectionne un fichier, 1 Select par fichier, diverses options : Organization, Acces mode, Record key) *****
         select F-client assign to "C:\Users\thoma\Downloads\ListeCompteClient.csv"
         organization is line sequential.
       
      *******************************************************************************************************************************************
      ***** DATA DIVISION (D�clarations toutes les variables, 3sections standards : File section, working-storage section, linkage section) *****
      *******************************************************************************************************************************************
       data division.

      ***** FILE SECTION (traitement fichier et variable li�s au(x) fichier(s)) *****
        file section.

      ***** Ouvre fichier F-client et enregistre la longueur de fichier (la ligne du fichier (line sequential) dans la var Cobol E-CLIENT *****  
         FD F-CLIENT record varying from 0 to 255.
         01 E-CLIENT pic x(255).

      ***** WORKING-STORAGE SECTION (Stockage des variables par niveaux) *****
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
         10 RacineCompte SQL CHAR (9).
         10 TypeCompte SQL CHAR-VARYING (2).
         10 ClesRib SQL CHAR-VARYING (2).
         10 Debit PIC 999999999999999999999V99.
         10 Credit PIC 999999999999999999999V99.

      ***** D�claration dateSysteme *****
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
      ***** SCREEN SECTION (Utilis� pour d�crire ce que l'on vois � l'ecran, on indique la ligne et la colonne - UNIQUEMENT SUR VISUAL STUDIO) *****
             screen section.
      ***** Assemblage du Menu dans une variable *****
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
      *On r�cup�re le client**************************************
           exec sql
             select CodeClient into :Client.codeClient from client
             where Nom = :Client.Nom
           end-exec.
      **********************************************************************************
      *Si il n'existe pas on g�n�re un code client**************************************
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
      ******* Contr�le des cl�s RIB ****************************************
      **********************************************************************
       ControleCleRib.

      **********************************************************************
      ******* Gestion des clients ******************************************
      **********************************************************************
       GestionClient.

       end program Program1.