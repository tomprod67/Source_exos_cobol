      ***************************************************************
      ***************************************************************
      ***** IDENTIFICATION DIVISION (Nom Programme, Nom Author) *****
      ***************************************************************
      ***************************************************************
       identification division.
       program-id. Program1 as "AideTest.Program1".
       author. Tomprod.

      ********************************************************************************************************
      ********************************************************************************************************
      ********************************************************************************************************
      ***** ENVIRONMENT DIVISION (Dépendante de la machine et des fichiers) (INUTILE SI PAS DE FICHIERS) *****
      ********************************************************************************************************
      ********************************************************************************************************
      ********************************************************************************************************
       environment division.

      **************************************************************************
      ***** CONFIGURATION SECTION (Décrire la configuration de la machine) *****
      **************************************************************************
       configuration section.

      ***** SOURCE-COMPUTER (Le nom de la machine) *****
       source-computer. SRF-EN1-16 with debugging mode.

      ***** OBJECT-COMPUTER (Pour quel machine est fait le programme + Alphabet utilisé ) *****
      *object-computer. SRF-EN1-16 program collating sequence is EB-EBCDIC.

      ***** SPECIAL-NAMES (Différents réglages sur le programme : choix alphabet, point décimal = comma (,) , currency sign) *****
       special-names.
      *  alphabet ASCII is native
      *  decimal-point is comma.
      *  currency sign is X'9F'.

      ************************************************************************************************
      ***** INPUT-OUTPUT SECTION (Décrire fichier(s), file-control, I-O-Control, gestion mémoire *****
      ************************************************************************************************
       input-output section.

      ***** FILE-CONTROL (Controle des fichiers à importer) *****
       file-control.

      ***** SELECT (Selectionne un fichier, 1 Select par fichier, diverses options : Organization, Acces mode, Record key) *****

      ***** Fichier utilise pour importer les client en BDD *****
           select F-client assign to "C:\Users\thoma\Downloads\ListeCompteClient.csv"
           organization is line sequential.

      ***** Fichier utilise pour exporter le controle des cles rib *****
           select F-ControleCleRib assign to "C:\Users\thoma\Desktop\Thomas\FormationCobol\exercices-travaux-Cobol\ControleRib.txt"
           organization is line sequential access sequential.

      *******************************************************************************************************************************************
      *******************************************************************************************************************************************
      *******************************************************************************************************************************************
      ***** DATA DIVISION (Déclarations toutes les variables, 3sections standards : File section, working-storage section, linkage section) *****
      *******************************************************************************************************************************************
      *******************************************************************************************************************************************
      *******************************************************************************************************************************************

       data division.
      ***************************************************************************************
      ***** FILE SECTION (traitement fichier(s) et variable(s) lié(s) au(x) fichier(s)) *****
      ***************************************************************************************
       file section.

      ***** Ouvre fichier F-client et enregistre la longueur de fichier (la ligne du fichier (line sequential) dans la var Cobol E-CLIENT *****
      ***** Fichier servant a l'importation du fichier dans la BDD (Option 1) ***** 
       FD F-CLIENT record varying from 0 to 255.
       01 E-CLIENT pic x(255).
      
      ***** Fichier servant a l'exportation de la BDD vers fichier externe(Option 6) *****
       FD F-ControleCleRib record varying from 0 to 255.
       01 E-ControleCleRib pic x(255).

      ***** WORKING-STORAGE SECTION (Stockage des variables par niveaux) *****
       working-storage section.

      ***** INCLURE SQL et fonctions associés (nécessaire si BDD) *****
       77 CNXDB STRING.
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.
           EXEC SQL
             INCLUDE SQLDA
           END-EXEC.

      ***** Déclaration dateSysteme (Pour l'afficher par la suite sur le Menu) *****       
       01 DateSysteme.
         10 Annee Pic 99.
         10 Mois Pic 99.
         10 Jour Pic 99.

      **********************************************************
      ***** Structure de données - Client , Compte, Banque *****
      **********************************************************
       01 CLIENT.
         10 CodeClient Pic X(36).
         10 Intitule SQL CHAR-VARYING (5).
         10 Nom SQL CHAR-VARYING (15).
         10 Prenom SQL CHAR-VARYING (15).
         10 CodePostal SQL CHAR (5).
         10 Ville SQL CHAR-VARYING (15).

       01 COMPTE.
         10 CodeClient PIC X(36).
         10 CodeBanque SQL CHAR (5).
         10 CodeGuichet SQL CHAR (5).
         10 CompteComplet.
           20 RacineCompte SQL CHAR (9).
           20 TypeCompte SQL CHAR (2).
         10 CleRib SQL CHAR-VARYING (2).
         10 Debit PIC  9(6)V99.
         10 Credit PIC 9(6)V99.

       01 BANQUE.
         10 CodeBanque SQL CHAR (5).
         10 NomBanque SQL CHAR-VARYING (30).

      ***** Déclaration des variables liés à l'affichage (couleurs fond et police) *****
       77 CouleurFondEcran pic 99 value 9.
       77 CouleurCaractere pic 99 value 14.

     
      *****************************************************************************************
      ***** Structure de données - Option 5 - Controle de cles RIB (dans fichier externe) *****
      *****************************************************************************************
             
      ****** lignes de l'état de contrôle des clés RIB *****
       01 LigneEntete1.
         10 Filler Pic X(7) value " Serfa".
         10 Filler Pic X(35).
         10 Filler Pic X(28) value "Liste des clés RIB corrigées".
         10 Filler Pic X(26).
         10 Filler Pic X(7) value "Date : ".
         10 Jour Pic 99.
         10 Filler Pic X value "/".
         10 Mois Pic 99.
         10 Filler Pic X value "/".
         10 Annee Pic 99.


       01 LigneEntete2.
         10 Filler Pic X(42).
         10 Filler Pic X(28) value all "=".

       01 LigneEntete4.
         10 Filler Pic X.
         10 Filler Pic X(109) value all "-".

       01 LigneEntete6.
         10 Filler Pic X(74).
         10 Filler Pic X(36) value "Code     No de     Ancienne Nouvelle".

       01 LigneEntete7.
         10 Filler Pic X(7) Value " Client".
         10 Filler Pic X(35).
         10 Filler Pic X(6) Value "Banque".
         10 Filler Pic X(25).
         10 Filler Pic X(37) value "guichet   compte     cle RIB  cle RIB".

       01 LigneBasPage.
         10 Filler Pic X(10) value " --- Page ".
         10 NPage Pic Z9.
         10 Filler Pic X.
         10 Filler Pic X(85) value all "-".
         10 Filler Pic X(13) value " A suivre ---".

       01 DernierBasPage.
         10 Filler Pic X(10) value " --- Page ".
         10 NPage Pic Z9.
         10 Filler Pic X.
         10 Filler Pic X(97) value all "-".

       01 LigneDetail.
         10 Filler Pic X.
         10 NomClient Pic X(40).
         10 Filler Pic X.
         10 NomBanque Pic x(30).
         10 Filler Pic XX.
         10 CodeGuichet Pic x(5).
         10 Filler Pic X.
         10 CompteComplet.
           20 RacineCompte Pic X(9).
           20 Filler Pic X.
           20 TypeCompte Pic X(2).
         10 Filler Pic X(5).
         10 CleRib Pic XX.
         10 Filler Pic X(6).
         10 NouvelCleRib Pic XX.

      *****************************************************************
      ***** Structure de données - Option 6 - Gestion des clients *****
      *****************************************************************
       01 LigneEcran occurs 11.
         10 CleBase.
           15 CodeBanque SQL CHAR (5).
           15 CodeGuichet SQL CHAR (5).
           15 RacineCompte SQL CHAR (9).
           15 TypeCompte SQL CHAR (2).
         10 ValeurLigne.
           15 CodeBanque SQL CHAR (5).
           15 CodeGuichet SQL CHAR (5).
           15 RacineCompte SQL CHAR (9).
           15 TypeCompte SQL CHAR (2).
         10 CleRIB SQL CHAR (2).
         10 NomBanque SQL CHAR-VARYING (225).
         10 Debit PIC 9(12)V99.
         10 Credit PIC 9(12)V99.

       01 LigneCourante.
         10 CodeBanque SQL CHAR (5).
         10 NomBanque SQL CHAR-VARYING (255).
         10 CodeGuichet SQL CHAR (5).
         10 RacineCompte SQL CHAR (9).
         10 TypeCompte SQL CHAR (2).
         10 CleRIB SQL CHAR (2).
         10 Debit PIC 9(12)V99.
         10 Credit PIC 9(12)V99.

      ****************************************************
      ***** Déclaration des variables (Menu général) *****
      ****************************************************
       77 Option pic 9.

      *********************************************************************
      ***** Déclaration des variables (option 1 - Importation compte) *****
      *********************************************************************
       77 ImportationCompte-iterator pic 9.

      ********************************************************************
      ***** Déclaration des variables (option 2 - Liste des banques) *****
      ********************************************************************
       77 ListeBanque-iterator pic 9.
       77 NoLigne pic 99.
       77 Reponse pic X.

      ********************************************************************
      ***** Déclaration des variables (option 3 - Liste des comptes) *****
      ********************************************************************
       77 ListeCompte-iterator pic 9.

      **********************************************************************************
      ***** Déclaration des variables (option 4 - controle cles RIB direct en BDD) *****
      **********************************************************************************
       77 DerniereZone pic x(14).
       77 ControleCleRib-iterator pic 9.

      *****************************************************************************************
      ***** Déclaration des variables (option 5 - controle cles RIB dans fichier externe) *****
      *****************************************************************************************
       77 CompteCompletNum Pic 9(11).
       77 CodeBanqueNum Pic 9(5).
       77 CodeGuichetNum Pic 9(5).
       77 CleRibNum Pic 99.
       77 TotalIntermediaire Pic 9(13).
       77 TotalCalcule Pic 9(13).
       77 LigneCompte Pic 99.
       77 NoLigneTitre Pic 9 value 8.
       77 MaxLigne pic 99.
       77 MaxCompte pic 99.
       77 CleRibTrouve Pic XX.
       77 ControleCleRibExport-iterator pic 9.
       77 NbLigne pic 99.
       77 NoPage pic 99.
       77 OptionExport SQL CHAR-VARYING (20).

      **********************************************************************
      ***** Déclaration des variables (option 6 - Gestion des clients) *****
      **********************************************************************
       77 NomClientSaisie Pic X(15).
       77 PrenomClientSaisie Pic X(15).
       77 CodePostalClientSaisie Pic X(5).
       77 VilleClientSaisie Pic X(15).

       77 RechercheCompte-iterator pic 9.
       77 NoLigneEcran Pic 99.

       77 ChoixGestionClient Pic A.

       77 GestionMajOption pic X.

       77 CreateForeGround pic 99.
       77 UpdateForeGround pic 99.
       77 DeleteForeGround pic 99.
       77 ValidationForeGround pic 99.

       77 DimTableau Pic 99 value 11.
       77 valeur pic X(30).
       77 GestionUpdateEntete-iterator pic 9.
       77 OptionMaj Pic X.
       77 ValidateurPerform pic X.
       77 NbLigneTrouve Pic 9.
       77 LigneCompteAux Pic 99.
       77 MaxSupprime pic 99.

       01 LigneSupprime Occurs 11.
         15 CodeBanque SQL CHAR (5).
         15 CodeGuichet SQL CHAR (5).
         15 RacineCompte SQL CHAR (9).
         15 TypeCompte SQL CHAR (2).



      **************************************************************************************************************************************
      ***** SCREEN SECTION (UNIQUEMENT SUR VISUAL STUDIO - Pour décrire ce que l'on vois à l'ecran, on indique la ligne et la colonne) *****
      **************************************************************************************************************************************
       screen section.

      ******************************************************
      ***** Affichage du Menu stocké dans une variable *****
      ******************************************************
       01 menu background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line 1 col 1 Blank Screen.
         10 line 3 col 32 value " GESTION BANCAIRE - ACCUEIL ".
         10 line 5 col 2 value " Date :".
         10 line 5 col 18 from Jour of DateSysteme.
         10 line 5 col 20 value "/".
         10 line 5 col 21 from Mois of DateSysteme.
         10 line 5 col 23 value "/".
         10 line 5 col 24 from Annee of DateSysteme.
         10 line 5 col 69 value " Option :".
         10 line 5 col 79 pic 9 from Option.
         10 line 8 col 5 value  "- 1 - Importation des comptes .................................... :".
         10 line 9 col 5 value  "- 2 - Liste des banques .......................................... :".
         10 line 10 col 5 value "- 3 - Liste des comptes .......................................... :".
         10 line 11 col 5 value "- 4 - Controle des cles RIB (modif en BDD) ....................... :".
         10 line 12 col 5 value "- 5 - Controle des cles RIB (Modif vers fichier externe) ......... :".
         10 line 13 col 5 value "- 6 - Gestion des clients ........................................ :".
         10 line 15 col 5 value "- 0 - Retour au menu appelant .................................... :".

      ********************************************************************************
      ***** Affichage de l'option 2 "liste des banques" stocké dans une variable *****
      *********************************************************************************
       01 listeBanque-E background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line 1 col 1 Blank Screen.
         10 line 4 col 32 value "LISTE DES BANQUES".
         10 line 5 col 1 background-color is CouleurCaractere foreground-color is CouleurFondEcran pic X(80) VALUE " Code   Nom".

       01 ListeBanque-Contenu background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line noLigne Col 2 from CodeBanque of banque.
         10 line noligne col 8 from NomBanque of banque pic X(70).

       01 ListeBanque-F background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line 1 Col 1 ERASE EOL.
         10 LINE 6 Col 1 ERASE EOS.

      *********************************************************************************
      ***** Affichage de l'option 3 "liste des comptes" stocké dans une variable  *****
      *********************************************************************************
       01 listeCompte-E background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line 1 col 1 Blank Screen.
         10 line 4 col 32 value "LISTE DES COMPTES".
         10 line 5 col 1 background-color is CouleurCaractere foreground-color is CouleurFondEcran pic X(80) VALUE "Client Banque  Guichet  Racine    Type   Rib    Credit       Debit".

       01 ListeCompte-Contenu background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line noLigne Col 9 from CodeBanque of Compte.
         10 line noLigne Col 17 from CodeGuichet of Compte.
         10 line noLigne Col 25 from RacineCompte of Compte.
         10 line noLigne Col 37 from TypeCompte of Compte.
         10 line noLigne Col 43 from CleRib of Compte.
         10 line noLigne Col 48 from Credit of Compte pic Z(8)9V,99.
         10 line noLigne Col 60 from Debit of Compte pic Z(8)9V,99.

       01 ListeCompte-F background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line 1 Col 1 ERASE EOL.
         10 LINE 6 Col 1 ERASE EOS.

      ****************************************************************************
      ***** Affichage de Gestion client (Option 6) stocké dans une variable  *****
      ****************************************************************************
      ***** Menu *****
       01 MenuGestionClient.
         10 line 1 col 1 blank screen.
         10 Line 3 Col 31 value "Gestion des clients".
         10 Line 5 Col 1 Value " Nom ........... :".
         10 Line 5 Col 46 Value " Prenom ... :".
         10 Line 6 Col 1 Value " Code postal ... :".
         10 Line 6 Col 46 Value " Ville .... :".
         10 background-color is CouleurCaractere foreground-color is CouleurFondEcran.
           20 Line 8 Col 1 pic x(80).
           20 Line 8 Col 1 value "No".
           20 Line 8 Col 4 value "Banque".
           20 Line 8 Col 30 value "Guichet".
           20 Line 8 Col 38 value "Compte".
           20 Line 8 Col 51 value "Cle".
           20 Line 8 Col 56 value "Debit".
           20 Line 8 Col 68 value "Credit".

      ***** Entete *****
       01 GestionListeCompte-E.
         10 Line 5 Col 20 using Nom of Client pic X(20).
         10 Line 5 Col 60 using Prenom of Client pic X(20).
         10 Line 6 Col 20 using CodePostal of Client.
         10 Line 6 Col 60 using Ville of Client pic X(20).


      ***** Contenu *****
       01 GestionListeCompte-Contenu background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line NoLigneEcran col 1 erase EOL.
         10 Line NoLigneEcran Col 1 from LigneCompte.
         10 Line NoLigneEcran Col 4 using CodeBanque of LigneCourante.
         10 Line NoLigneEcran Col 10 from NomBanque of LigneCourante pic X(20).
         10 Line NoLigneEcran Col 30 using CodeGuichet of LigneCourante.
         10 Line NoLigneEcran Col 38 using RacineCompte of LigneCourante.
         10 Line NoLigneEcran Col 48 using TypeCompte of LigneCourante.
         10 Line NoLigneEcran Col 51 from CleRib of LigneCourante.
         10 Line NoLigneEcran Col 55 using Debit of LigneCourante pic Z(8)9V,99.
         10 Line NoLigneEcran Col 68 using Credit of LigneCourante pic Z(8)9V,99.


       01 GestionListeCompte-NotifCreate background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line 1 col 1 erase EOL.
         10 line 1 col 1 value " Voulez-vous le creer (o/N) :" background-color is CouleurCaractere foreground-color is CouleurFondEcran.

       01 GestionListeClient-NotifUpdate background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line 1 col 1 erase EOL.
         10 line 1 col 1 value " Voulez-vous terminer, le modifier ou le supprimer (T/m/s) :" background-color is CouleurCaractere foreground-color is CouleurFondEcran.

       01 M-EffaceQuestion Background-Color is CouleurFondEcran.
         10 line 1 col 1 pic x(80).

       01 GestionListeCompte-SubMenu background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line 20 col 1 erase EOS.
         10 line 20 col 1 pic x(80) value all "_".
         10 line 21 col 1 value "-1-Ajout d'un compte ...............:" foreground-color is CreateForeGround.
         10 line 22 col 1 value "-2-Modification compte, ligne No    :" foreground-color is UpdateForeGround.
         10 line 23 col 1 value "-3-Suppression compte, ligne No    .:" foreground-color is DeleteForeGround. 
         10 line 21 col 39 value "-4-Modification de l'entete :" foreground-color is UpdateForeGround.
         10 line 22 col 39 value "-A-Annulation ............. :".
         10 line 23 col 39 value "-V-Validation ............. :" foreground-color is CreateForeGround.
         10 line 23 col 69 value "Option :".

     
      *******************************************************************************************************************************************
      ***** PROCEDURE DIVISION (Action du programme) ********************************************************************************************
      *******************************************************************************************************************************************
       procedure division.

      **********************************************************************
      ******* Gestion du menu général **************************************
      **********************************************************************
       AffichageMenu.
           perform AffichageMenu-Init.
           perform AffichageMenu-Trt until Option = 0.
           perform AffichageMenu-Fin.

      ***** AffichageMenu-Init *****
       AffichageMenu-Init.
      ***** CONNEXION à la BDD à l'initialisation du menu *****
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

      ***** On initialise Option (du menu) à 1 pour pouvoir boucler dessus *****
           move 1 to Option.
      ***** On "accept" la date du système par la fonction date (format anglais)
           accept DateSysteme from date.

      ***** AffichageMenu-Trt *****
       AffichageMenu-Trt.
           move 0 to Option.
      ***** On affiche le menu *****
           display menu.
      ***** On accept de recevoir une reponse (option) de la part de l'utilisateur *****
           accept Option line 5 col 79.

      ***** On analyse l'option saisie par l'utilisateur et le redirige vers la partie du programme adéquate *****
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
                   perform ControleCleRibExportFile
               when 6
                   perform GestionClient
           end-evaluate.

       AffichageMenu-Fin.
           stop run.

      **********************************************************************
      ******* Importation du fichier (Option 1 du Menu) ********************
      **********************************************************************
       ImportFichier.
           perform ImportFichier-init.
           perform ImportFichier-trt until ImportationCompte-iterator = 1.
           perform ImportFichier-fin.

       ImportFichier-init.
           move 0 to ImportationCompte-iterator.
           open INPUT F-Client.
           read F-Client
               at end
                   move 1 to ImportationCompte-iterator
           end-read.

       ImportFichier-trt.
           read F-Client
               at end
                   move 1 to ImportationCompte-iterator
               not at end
                   perform ImportationLigne
           end-read.

       ImportFichier-fin.
           close F-Client.

      **********************************************************************
      **************** Liste des banques (Option 2 du Menu) ****************
      **********************************************************************
       ListeBanque.
           perform ListeBanque-Init.
           perform ListeBanque-Trt until ListeBanque-iterator = 1.
           perform ListeBanque-Fin.

      ***** ListeBanque-Init *****
       ListeBanque-init.
           move 0 to ListeBanque-iterator.

      ***** Déclaration du curseur *****
           exec sql
               declare C-ListeBanque cursor for
                   select CodeBanque, NomBanque
                   from Banque
                   Order by NomBanque
           end-exec.

      ***** Ouverture du curseur *****
           exec sql
               open C-ListeBanque
           End-exec.

      ***** Affichage de l'entete de la page *****
           display ListeBanque-E.
      ***** Noligne à 5 car ListeBanque-E prend 4 ligne 'on commence a écrire sur la 5iem ligne *****
           move 5 to Noligne.

      ***** ListeBanque-Trt *****
       ListeBanque-Trt.
      ***** On recupere le resultat (la ligne) que le pointeur cible *****
           exec sql
               fetch C-ListeBanque into :Banque.CodeBanque,
                   :Banque.NomBanque
           end-exec.
      ***** Si il y a un resultat, on passe sur le perform AffichageLigneBanque *****
           if SqlCode = 0 or SqlCode = 1 then
               perform AffichageLigneBanque
      ***** Sinon on affiche la fin *****
           else
               move 1 to ListeBanque-iterator
               display "Fin de la liste des banques - Tapez Entree " line 1 col 1 with no advancing
               accept reponse
           End-if.

      ***** ListeBanque-Fin *****
       ListeBanque-Fin.
           exec sql
      ***** On referme le cursor *****
               close C-ListeBanque
           end-exec.
      
      **********************************************************************
      ******* Liste des comptes (Option 3 du Menu) *************************
      **********************************************************************
       ListeCompte.
           perform ListeCompte-Init.
           perform ListeCompte-Trt until ListeCompte-iterator = 1.
           perform ListeCompte-Fin.

       ListeCompte-Init.
           move 0 to ListeCompte-iterator.

      ***** Déclaration du curseur (Pour la liste des comptes) *****
           exec sql
               declare C-ListeCompte cursor for
                   select CodeClient, CodeBanque, CodeGuichet, RacineCompte, TypeCompte, CleRib, Debit, Credit
                   from Compte
                   Order by CodeBanque
           end-exec.

      ***** Ouverture du curseur *****
           exec sql
               open C-ListeCompte
           End-exec.

      ***** Affichage de l'entete de la page *****
           display ListeCompte-E.
      ***** Noligne à 5 car ListeBanque-E prend 4 ligne 'on commence a écrire sur la 5iem ligne *****
           move 5 to Noligne.
       ListeCompte-Trt.
      ***** On recupere le resultat (la ligne) que le pointeur cible *****
           exec sql
               fetch C-ListeCompte into :Compte.CodeClient,
               :Compte.CodeBanque,
               :Compte.CodeGuichet,
               :Compte.RacineCompte,
               :Compte.TypeCompte,
               :Compte.CleRib,
               :Compte.Debit,
               :Compte.Credit
           end-exec.
      ***** Si il y a un resultat, on passe sur le perform AffichageLigne *****
           if SqlCode = 0 or SqlCode = 1 then
               perform AffichageLigneCompte
      ***** Sinon on affiche la fin *****
           else
               move 1 to ListeCompte-iterator
               display "Fin de la liste des comptes - Tapez Entree " line 1 col 1 with no advancing
               accept reponse
           End-if.

      ***** ListeBanque-Fin *****
       ListeCompte-Fin.
           exec sql
      ***** On referme le cursor *****
               close C-ListeCompte
           end-exec.

      **************************************************************************
      ******* Contrôle des clés RIB Modif direct en BDD (Option 4 du Menu) *****
      **************************************************************************
       ControleCleRib.
           perform ControleCleRib-init.
           perform ControleCleRib-trt until ControleCleRib-iterator = 1.
           perform ControleCleRib-fin.

       ControleCleRib-init.
           move 0 to ControleCleRib-iterator.
      ***** Déclaration du curseur (Pour le Controle des clès Rib) *****
           exec sql
               declare C-CleRib cursor for
                   select CodeBanque, CodeGuichet, RacineCompte, TypeCompte, CleRib from Compte
           end-exec.

           exec sql
               open C-CleRib
           End-exec.

      ** Traitement pour le parcours du curseur : récupération d'une ligne
       ControleCleRib-trt.
           exec sql
               fetch C-CleRib into :Compte.CodeBanque, :Compte.CodeGuichet,
                   :Compte.RacineCompte, :Compte.TypeCompte, :Compte.CleRib
           end-exec.
           if SQLCODE = 1 or SQLCODE = 0 then
               perform VerificationCleRib
           else
               move 1 to ControleCleRib-iterator
           end-if.

      ** Fin du parcours du curseur : Fermeture du curseur
       ControleCleRib-fin.
           exec sql
               close C-CleRib
           end-exec.

      *****************************************************************************************************
      ******* Contrôle des clés RIB (Option 5)(Façon 2 : modif en BDD et export vers fichier externe) *****
      *****************************************************************************************************
       ControleCleRibExportFile.
           perform ControleCleRibExportFile-Init.
           perform ControleCleRibExportFile-Trt until ControleCleRibExport-iterator = 1.
           perform ControleCleRibExportFile-Fin.

       ControleCleRibExportFile-Init.
           move 0 to ControleCleRibExport-iterator.

           exec sql
               declare C-CleRibExport cursor for
                   select CodeBanque, CodeGuichet, RacineCompte, TypeCompte, CleRib, PrenomNom,
                   NomBanque from ViewForRib order by nom
           end-exec.

           exec sql
               open C-CleRibExport
           End-exec.
      **********************************************************************
      * Initialisation de la pagination de la liste de controle
           Move 0 to NoPage.
           move 66 to NbLigne.
           move corresponding DateSysteme to LigneEntete1.
       ControleCleRibExportFile-Trt.
           exec sql
               fetch C-CleRibExport into :Compte.CodeBanque, :Compte.CodeGuichet,
                   :Compte.RacineCompte, :Compte.TypeCompte, :Compte.CleRib,
                   :LigneDetail.NomClient, :LigneDetail.NomBanque
           end-exec.
           if SQLCODE = 1 or SQLCODE = 0 then
               perform VerificationCleRibExport
           else
               move 1 to ControleCleRibExport-iterator
           end-if.
       ControleCleRibExportFile-Fin.
           exec sql
               close C-CleRibExport
           end-exec.

      ********** Impression du pied d'état
           if NoPage > 0 then
               move NoPage to NPage of DernierBasPage
               write E-ControleCleRib from DernierBasPage
               close F-ControleCleRib
           end-if.

       VerificationCleRibExport.
           move CompteComplet of COMPTE to CompteCompletNum.
           move CodeGuichet of COMPTE to CodeGuichetNum.
           move CodeBanque of Compte to CodeBanqueNum.

           perform CalculCleRib.

      * Mise à jour de la base de données
           move CleRibNum to CleRibTrouve.
           if CleRibTrouve <> CleRIB of COMPTE then
               exec sql
                   update compte set CleRib = :CleRibTrouve
                   where CodeBanque = :Compte.CodeBanque and
                         CodeGuichet = :Compte.CodeGuichet and
                         RacineCompte = :Compte.CompteComplet.RacineCompte and
                         TypeCompte = :Compte.CompteComplet.TypeCompte
               end-exec
           end-if.
           perform ImpressionControleCleRib.

      **********************************************************************
      ******* Gestion des clients (Option 6 du Menu) ***********************
      **********************************************************************
       GestionClient.
      *------------------------------------------------------------------------
      * Saisie du nom du client
      *------------------------------------------------------------------------
           perform SaisieNom-init.
           perform saisieNom-Trt until NomClientSaisie = "".
           perform saisieNom-Fin.

      * Initialisation de la saisie du nom
       SaisieNom-init.
           move "a" to NomClientSaisie.

      * Traitement de la saisie du nom
       saisieNom-Trt.
           move " " to NomClientSaisie.
           display MenuGestionClient.
           accept NomClientSaisie line 5 col 20.

           if NomClientSaisie <> ""
               perform RechercheCompteClient.

      * Fin de la saisie du nom
       saisieNom-Fin.
           continue.

      *------------------------------------------------------------------------
      * Recherche du client
      *------------------------------------------------------------------------
       RechercheCompteClient.
           perform RechercheCompteClient-init.
           perform RechercheCompteClient-trt until RechercheCompte-iterator = 1.
           perform RechercheCompteClient-fin.

       RechercheCompteClient-init.
           move 0 to RechercheCompte-iterator.

           exec sql
               declare C-GestionClient cursor for
                   select CodeClient, Nom, Prenom, CodePostal, Ville, CodeBanque, NomBanque,
                          CodeGuichet, RacineCompte, TypeCompte, CleRib, Debit, Credit
                   from ViewGestionClient
                   where Nom = :NomClientSaisie
                   order by CodeBanque, CodeGuichet, RacineCompte, TypeCompte
           end-exec.

           exec sql
               open C-GestionClient
           End-exec.

      * Initialisation des compteurs de gestion des lignes
           move 0 to LigneCompte.
           move 0 to MaxCompte.
           move NoLigneTitre to NoLigneEcran.
           move NoLigneTitre to MaxLigne.

      * Initialisation des informations clients
           initialize Client.

       RechercheCompteClient-trt.
           exec sql
               fetch C-GestionClient into :Client.CodeClient,
                   :Client.Nom, :Client.Prenom,
                   :Client.CodePostal, :Client.Ville,
                   :LigneCourante.CodeBanque, :LigneCourante.NomBanque,
                   :LigneCourante.CodeGuichet, :LigneCourante.RacineCompte,
                   :LigneCourante.TypeCompte, :LigneCourante.CleRib,
                   :LigneCourante.Debit, :LigneCourante.Credit
           end-exec.

           if SQLCODE = 0 or SQLCODE = 1 then
               perform GestionAffichageLigneCompte
           else
               move 1 to RechercheCompte-iterator
           end-if.

       RechercheCompteClient-fin.
           exec sql
               close C-GestionClient
           End-exec.

           perform SelectionTraitement.

      *------------------------------------------------------------------------
      * Affichage des informations du client et de son compte
      *------------------------------------------------------------------------
       GestionAffichageLigneCompte.
      * On se positionne dans le tableau et à l'écran
           add 1 to NoligneEcran.
           move NoligneEcran to MaxLigne.
           add 1 to LigneCompte.
           move LigneCompte to MaxCompte.

      * On alimente la ligne dans le tableau
           move corresponding LigneCourante to LigneEcran(LigneCompte).
           move corresponding LigneCourante to CleBase of LigneEcran(LigneCompte).
           move corresponding LigneCourante to Valeurligne of LigneEcran(LigneCompte).

      * Sur la premiere ligne on affiche l'entete de l'écran
           if LigneCompte = 1 then
               display GestionListeCompte-E
           end-if.

      * On affiche la ligne détail
           display GestionListeCompte-Contenu.

      *------------------------------------------------------------------------
      * Sélection du traitement
      *------------------------------------------------------------------------
       SelectionTraitement.

      * S'il n'y a pas de compte on propose à l'utilisateur de renseigner les données du
      * client
           if MaxCompte = 0 then
               display GestionListeCompte-NotifCreate
               move "N" to ChoixGestionClient
               accept ChoixGestionClient line 1 col 31
               if ChoixGestionClient = "o" then
                   move "O" to ChoixGestionClient
               end-if
           else
               display GestionListeClient-NotifUpdate
               move "T" to ChoixGestionClient
               accept ChoixGestionClient line 1 col 62
               if ChoixGestionClient = "m" then
                   move "M" to ChoixGestionClient
               end-if
               if ChoixGestionClient = "s" then
                   move "S" to ChoixGestionClient
               end-if
           end-if.
           display M-EffaceQuestion.

           evaluate ChoixGestionClient
               when "O"
                   move NomClientSaisie to Nom of CLIENT
                   exec sql
                       select newid() into :Client.CodeClient
                   end-exec
                   perform MajInfoClient

               when "M"
                   perform MajInfoClient
               when "S"
                   perform SuppressionClient
           end-evaluate.

      ******************************************************************
      * Mise à jour des informations du client
      ******************************************************************
       MajInfoClient.

           perform MajInfoClient-init.
           perform MajInfoClient-trt until OptionMaj = "V" or OptionMaj = "A".
           perform MajInfoClient-Fin.

       MajInfoClient-init.
           move " " to OptionMaj.
      * --------------------------------------------------------------------------------
      * Boucle sur la saisie de l'action à faire sur le client
      * Menu du bas de l'écran
      * --------------------------------------------------------------------------------
       MajInfoClient-trt.

      * Initialisation de l'affichage des options de menu
           if MaxCompte = 0 then
               move CouleurFondEcran to UpdateForeGround
               move CouleurFondEcran to ValidationForeGround
           else
               move CouleurCaractere to UpdateForeGround
               move CouleurCaractere to ValidationForeGround
           end-if.

           if MaxCompte < 2 then
               move CouleurFondEcran to DeleteForeGround
           else
               move CouleurCaractere to DeleteForeGround
           end-if.

           if MaxCompte = DimTableau then
               move CouleurFondEcran to CreateForeGround
           else
               move CouleurCaractere to CreateForeGround
           end-if.

      * Affichage du menu
           display GestionListeCompte-SubMenu.

      * Saisie de l'option de gestion
           move " " to OptionMaj.
           accept OptionMaj line 23 col 78.
           if OptionMaj = "a"
               move "A" to OptionMaj.
           if OptionMaj = "v"
               move "V" to OptionMaj.

           evaluate OptionMaj
               when "1"
                   perform AjoutLigne

               when "2"
                   perform ModificationLigne

               when "3"
                   move 0 to LigneCompte
                   if MaxCompte > 0 then
                       accept LigneCompte line 23 col 33
                       if LigneCompte > 0 and LigneCompte <= MaxCompte then
                           perform SuppressionLigne
                       end-if
                   end-if

               when "4"
                   perform MajEnteteClient

           end-evaluate.

       MajInfoClient-fin.

      *------------------------------------------------------------------
      * Ajout d'un nouveau compte
      *------------------------------------------------------------------
       AjoutLigne.
      *    on ne peut faire l'ajout que s'il y a moins de 11 lignes
           if MaxCompte < 11 then

      * Positionnement sur l'écran et il y aura une ligne de plus à l'écran
               add 1 to MaxLigne
               move MaxLigne to NoligneEcran

      * Positionnement dans le tableau et initialisation de la ligne
      * Pour mémoire, c'est la ligne saisie
               add 1 to MaxCompte
               move MaxCompte to LigneCompte
               initialize LigneEcran(LigneCompte)

      * On va saisir la ligne
               perform MiseAJourLigne
           end-if.
      *------------------------------------------------------------------
      * Modification d'un compte
      *------------------------------------------------------------------
       ModificationLigne.
      *    on ne peut faire la modification que s'il y a au moins 1 ligne
           if MaxCompte > 0 then

      * Demande à l'utilisateur de la ligne à modifier
               move 0 to LigneCompte
               accept LigneCompte line 22 col 34

      * Pour continuer le n° de ligne saisie doit être inférieur au nombre
      * de lignes utilisées dans le tableau
               if LigneCompte > 0 and LigneCompte <= MaxCompte then

      * On se positionne sur la ligne de l'écran
                   add NoLigneTitre to LigneCompte giving NoligneEcran

      * On va saisir la ligne
                   perform MiseAJourLigne
               end-if
           end-if.

      *------------------------------------------------------------------
      * Saisie des informations d'un compte
      * Paragraphe commun à l'ajout d'un compte et à la modification.
      * Avant de l'appeler, il convient d'initilaliser le n° de ligne
      * à l'écran et le numéro de ligne dans le tableau des lignes.
      * Pour mémoire :
      *    NoligneEcran = n° de ligne courante à l'écran
      *    MaxLigne = dernière ligne affichée avec un compte (les autres
      *               lignes sont vides)
      *    LigneCompte = n° de ligne courante dans le tableau
      *    MaxCompte = nombre de lignes renseignées dans le tableau
      *------------------------------------------------------------------
       MiseAJourLigne.
      * On boucle sur la mise à jour de la ligne jusqu'à ce qu'elle soit
      * correcte (tous les tests passés sans erreur).
           perform MiseAJourLigne-Init.
           perform MiseAJourLigne-Trt until ValidateurPerform = 1.
           perform MiseAJourLigne-Fin.

       MiseAJourLigne-Init.
      *    on force l'entrée dans la boucle
           move 0 to ValidateurPerform.

      * Positionnement dans le tableau et initialisation de la ligne
      * Pour mémoire, c'est la ligne saisie
           move corresponding LigneEcran(LigneCompte) to LigneCourante.
           move corresponding Valeurligne of LigneEcran(LigneCompte) to LigneCourante.

      *    Affichage de la ligne pour être sur que le buffer écran est bon
           display GestionListeCompte-Contenu.

       MiseAJourLigne-Trt.
      * Saisie des informations de la ligne
           accept GestionListeCompte-Contenu.
           display M-EffaceQuestion.

      *    Par défaut il n'y a pas d'erreur
           move 1 to ValidateurPerform.

      * Initialisation et contrôle du nom de la banque
           exec sql
               select NomBanque into :LigneCourante.NomBanque from banque
               where CodeBanque = :LigneCourante.CodeBanque
           end-exec.
           if SQLCODE <> 0 and SQLCODE <> 1 then
               move 0 to ValidateurPerform
               display " ** Code banque inexistant ** " line 25 col 1 bell blink
           end-if.

      * Code guichet obligatoire
           if CodeGuichet of LigneCourante = " "
               move 0 to ValidateurPerform
               display " ** Code guichet obligatoire ** " line 25 col 1 bell blink
           end-if.

      * Racine compte obligatoire
           if RacineCompte of LigneCourante = " "
               move 0 to ValidateurPerform
               display " ** Racine compte obligatoire ** " line 25 col 1 bell blink
           end-if.

      * Type compte obligatoire
           if TypeCompte of LigneCourante = " "
               move 0 to ValidateurPerform
               display " ** Type compte obligatoire ** " line 25 col 1 bell blink
           end-if.

      * Le compte ne doit pas exister
           exec sql
               select count(*) into :NbLigneTrouve from compte
               where CodeBanque = :LigneCourante.CodeBanque and
                   CodeGuichet = :LigneCourante.CodeGuichet and
                   RacineCompte = :LigneCourante.RacineCompte and
                   TypeCompte = :LigneCourante.TypeCompte and
                   CodeClient <> :Client.CodeClient
           end-exec.
           if NbLigneTrouve > 0 then
               move 0 to ValidateurPerform
               display " ** Compte existant pour un autre client ** " line 25 col 1 bell blink
           end-if.
      * -----------------------------------------------------------------------------------------------------------------
      * On ne doit pas avoir le compte dans les autres lignes du tableau
      * -----------------------------------------------------------------------------------------------------------------
      *    on met la ligne courante dans le tableau pour avoir la clé compléte (plus facile à manipuler).
           move corresponding LigneCourante to ValeurLigne of LigneEcran(LigneCompte).

      *    on boucle sur les lignes du tableau pour voir si on a déjà le même compte dans la liste
      *    tout en sautant la ligne courante
           perform varying LigneCompteAux from 1 by 1 until
             LigneCompteAux > MaxCompte or (
             LigneCompte <> LigneCompteAux and
             ValeurLigne of LigneEcran(LigneCompteAux) =
             ValeurLigne of LigneEcran(LigneCompte)).

      *    Si on est sorti avant la fin des lignes, c'est une erreur
           if LigneCompteAux <= MaxCompte then
               move 0 to ValidateurPerform
               display " ** Compte deja renseigne ** " line 25 col 1 bell blink
           end-if.

      * Le débit et le crédit ne peuvent pas être renseignés ensemble
           if debit of LigneEcran(LigneCompte) > 0.00 and
             Credit of LigneEcran(LigneCompte) > 0.00 then
               move 0 to ValidateurPerform
               display " ** Le compte ne peut-etre debiteur et crediteur en meme temps ** " line 25 col 1 bell blink
           end-if.

      * Fin de la mise à jour de la ligne, tout est bon
       MiseAJourLigne-Fin.

      *    On calcule la clé RIB et on l'affiche
           move CodeBanque of LigneCourante to CodeBanqueNum.
           move CodeGuichet of LigneCourante to CodeGuichetNum.
           move RacineCompte of LigneCourante to RacineCompte of CompteComplet of COMPTE.
           move TypeCompte of LigneCourante to TypeCompte of CompteComplet of COMPTE.
           move CompteComplet of COMPTE to CompteCompletNum.
           perform CalculCleRib.
           move CleRibNum to CleRib of LigneCourante.
           display GestionListeCompte-Contenu.

      *    On remet la ligne de travail dans le tableau
           move corresponding LigneCourante to LigneEcran(LigneCompte).
           move corresponding LigneCourante to Valeurligne of LigneEcran(LigneCompte).

      *------------------------------------------------------------------
      * Suppression d'un compte
      *------------------------------------------------------------------
       SuppressionLigne.
      * Si la ligne est dans la table des comptes de la base de données,
      * on la mémorise pour la supprimer ultérieurement
           if CodeBanque of CleBase of LigneEcran(LigneCompte) <> "" then
               Add 1 to MaxSupprime
               move CleBase of LigneEcran(LigneCompte) to LigneSupprime(MaxSupprime)
           end-if.

      * On calcule la ligne d'affichage
           Add LigneCompte to NoLigneTitre giving NoLigneEcran.

      * On remonte toutes les lignes
           add 1 to LigneCompte giving LigneCompteAux.
           perform DecalageLigne until LigneCompteAux > MaxCompte.

      * On efface la dernière ligne
           initialize LigneEcran(MaxCompte).
           display M-EffaceQuestion

      * on a un compte en moins dans le tableau et dans les lignes
           subtract 1 from MaxCompte.
           subtract 1 from MaxLigne.

       DecalageLigne.
           move LigneEcran(LigneCompteAux) to LigneEcran(LigneCompte).
           move corresponding LigneEcran(LigneCompte) to LigneCourante.
           move corresponding ValeurLigne of LigneEcran(LigneCompte) to LigneCourante.
           display GestionListeCompte-Contenu.
           add 1 to LigneCompte.
           add 1 to LigneCompteAux.
           add 1 to NoLigneEcran.
      *------------------------------------------------------------------
      * Mise à jour des informations d'entête du client
      *------------------------------------------------------------------
       MajEnteteClient.
           perform MajEnteteClient-Init.
           perform MajEnteteClient-Trt until ValidateurPerform = 1.
           perform MajEnteteClient-Fin.

       MajEnteteClient-init.
           move 0 to ValidateurPerform.
           display GestionListeCompte-E.

       MajEnteteClient-trt.
      * Saisie de l'entête
           accept GestionListeCompte-E.

      * Par défaut la ligne est juste
           move 1 to ValidateurPerform.
           Display M-EffaceQuestion.

      * Le Nom est obligatoire
           if nom = "" then
               move 0 to ValidateurPerform
               display " ** Nom obligatoire ** " line 25 col 1 bell blink
           else

      * On contrôle que le nom du client n'est pas déjà dans la base
               exec sql
                   select prenom into :valeur from client where nom = :Client.Nom and
                   CodeClient <> :Client.CodeClient
               end-exec
               if SQLCODE = 1 or SQLCODE = 0
                   move 0 to ValidateurPerform
                   display " ** Client deja connu ** " line 25 col 1 bell blink
               end-if
           end-if.

       MajEnteteClient-fin.

       SuppressionClient.
           
      **************************************************************************************************
      *================================================================================================*
      **************************************************************************************************
      **************************************** UTILITAIRES *********************************************
      **************************************************************************************************
      *================================================================================================*
      **************************************************************************************************

      ********************************************************************
      ***** ImportationLigne (utilisé dans ImportFichier (Option 1)) *****
      ********************************************************************
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

      ***** Divise par 100 le credit et le débit pour passer des centimes aux euros car stocker en centimes dans le fichier *****
      *****Divise par 100 pour passer des centimes à l'euro (FACON 1) *****
           divide 100 into Debit of Compte.
      *****Divise par 100 pour passer des centimes à l'euro (FACON 2) *****
           divide Credit of Compte by 100 giving Credit of Compte.

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
      ***** AffichageLigneBanque (utilisé dans ListeBanque (Option 2)) *****
      **********************************************************************
       AffichageLigneBanque.
      * Affichage de la ligne
           add 1 to NoLigne.
           display ListeBanque-Contenu.

      * En bas de page, on pose la question si on continue
           if Noligne = 21 then
               display "Page [S]uivant - [M]enu : " line 1 col 2 blank line with no advancing
               accept reponse

      * Si on arrête, on positionne la fin de fichier
               if reponse = "m" or reponse = "M" then
                   move 1 to ListeBanque-iterator

      * Si on continue on revient au début de la page
               else
                   move 5 to Noligne
                   display ListeBanque-F
               end-if
           end-if.

      ***********************************************************************
      *****  AffichageLigneCompte (utilisé dans ListeCompte (Option 3)) *****
      ***********************************************************************
       AffichageLigneCompte.
      * Affichage de la ligne
           add 1 to Noligne.
           display ListeCompte-Contenu.

      * En bas de page, on pose la question si on continue
           if Noligne = 21 then
               display "Page [S]uivant - [M]enu : " line 1 col 2 blank line with no advancing
               accept reponse

      * Si on arrête, on positionne la fin de fichier
               if reponse = "m" or reponse = "M" then
                   move 1 to ListeCompte-iterator

      * Si on continue on revient au début de la page
               else
                   move 5 to Noligne
                   display ListeCompte-F
               end-if
           end-if.

      ****************************************************************************
      ***** VerificationCleRib (Utilisé dans ControleCleRib (Option 4 et 5)) *****
      ****************************************************************************
       VerificationCleRib.

           move CodeGuichet of COMPTE to CodeGuichetNum.
           move CodeBanque of COMPTE to CodeBanqueNum.

      * Concaténation de RacineCompte et TypeCompte dans la variable CompteCompletNum *
           STRING RacineCompte of LigneCourante TypeCompte of Compte into CompteCompletNum.

           perform CalculCleRib.

           exec sql
               UPDATE COMPTE
               SET CleRib = :CleRibNum
               WHERE CodeBanque = :Compte.CodeBanque AND CodeGuichet = :Compte.CodeGuichet AND RacineCompte = :Compte.RacineCompte AND TypeCompte = :Compte.TypeCompte
           end-exec.

      ****************************************************************************************************
      ***** Impression de la liste de contrôle des clés RIB (Utilisé dans ControleCleRib (Option 5)) *****
      ****************************************************************************************************
       ImpressionControleCleRib.

      * Impression du pied de page sauf sur la page 0 où on ouvre le fichier
           if NbLigne > 60 then
               if NoPage = 0 then
                   open output F-ControleCleRib
               else
                   move NoPage to NPage of LigneBasPage
                   write E-ControleCleRib from LigneBasPage
               end-if

      * Impression de l'entête de page
               add 1 to NoPage
               write E-ControleCleRib from LigneEntete1
               write E-ControleCleRib from LigneEntete2
               write E-ControleCleRib from " "
               write E-ControleCleRib from LigneEntete4
               write E-ControleCleRib from LigneEntete6
               write E-ControleCleRib from LigneEntete7
               write E-ControleCleRib from LigneEntete4
               move 7 to NbLigne
           end-if.

      * Impression de la ligne détail
           add 1 to NbLigne.
           move corresponding COMPTE to LigneDetail.
           move CleRibTrouve to NouvelCleRib of LigneDetail.
           write E-ControleCleRib from LigneDetail.

      *****************************************************************************************************************
      ***** Fonction Calcul de clés rib (Utilisé dans le perform VerificationCleRib (ControleRib (Option4 et 5))) *****
      *****************************************************************************************************************
       CalculCleRib.
           multiply CompteCompletNum by 3 giving TotalCalcule.
           multiply CodeGuichetNum by 15 giving TotalIntermediaire.
           add TotalIntermediaire to TotalCalcule.
           multiply CodeBanqueNum by 89 giving TotalIntermediaire.
           add TotalIntermediaire to TotalCalcule.
           Divide TotalCalcule by 97 giving TotalIntermediaire remainder CleRibNum.
           subtract CleRibNum from 97 giving CleRibNum.

   
       end program Program1.