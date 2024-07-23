;=========================================================================
; Folders_scheme.lsp
; Create by Jakub Tomecko
;
; Vytvorenie struktry priecinkov projektu
;-------------------------------------------------------------------------

(defun c:JTFolder () 

  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Folders_scheme.dcl"))

  ;test ecistencie dialogu
  (if (not (new_dialog "Folders_scheme" dcl_id)) 
    (exit)
  )

  ;definovanie tlacidla cancel
  (action_tile "cancel" 
               "(UkoncenieFoldersScheme)"
  )

  ;definovanie tlacidla nacitat
  (action_tile "vytvorit" 
               "(VytvorenieFoldersScheme)(done_dialog)"
  )

  ;spustenie dialogu
  (start_dialog)

  ;unload dialogu
  (unload_dialog dcl_id)

  ;vyhodnotenie spustenia vytvorenia struktury "Studie uskutocnitelnosti"
  (if (= studiaUskutocnitelnosti "1") 
    (progn 
      (setq ListOfPath '("\\STU"
                         "\\STU\\A Sprievodna sprava"
                         "\\STU\\B Technicka cast"
                         "\\STU\\C Ekonomicka cast"
                         "\\STU\\C Ekonomicka cast\\C1 Naklady"
                         "\\STU\\C Ekonomicka cast\\C2 Nakladovo-vynosova analyza (CBA)"
                         "\\STU\\D Graficka cast"
                         "\\STU\\D Graficka cast\\D1 Vseobecne vykresy a pisomnosti"
                         "\\STU\\D Graficka cast\\D1 Vseobecne vykresy a pisomnosti\\D11 Prehladne situacie"
                         "\\STU\\D Graficka cast\\D1 Vseobecne vykresy a pisomnosti\\D12 Celkove situacie"
                         "\\STU\\D Graficka cast\\D1 Vseobecne vykresy a pisomnosti\\D13 Pozdlzne profily"
                         "\\STU\\D Graficka cast\\D1 Vseobecne vykresy a pisomnosti\\D14 Ortofotomapy"
                         "\\STU\\D Graficka cast\\D1 Vseobecne vykresy a pisomnosti\\D15 Propagacia"
                         "\\STU\\D Graficka cast\\D2 Vykresy a pisomnosti objektov"
                         "\\STU\\D Graficka cast\\D2 Vykresy a pisomnosti objektov\\100 Pozemne komunikacie"
                         "\\STU\\D Graficka cast\\D2 Vykresy a pisomnosti objektov\\200 Mostne objekty"
                         "\\STU\\D Graficka cast\\D2 Vykresy a pisomnosti objektov\\400 Tunely"
                         "\\STU\\E Doklady a povolenia"
                         "\\STU\\E Doklady a povolenia\\E1 Doklady"
                         "\\STU\\E Doklady a povolenia\\E2 Povolenia, rozhodnitia, stanoviska"
                         "\\STU\\F prieskumy a studie"
                         "\\STU\\F prieskumy a studie\\F1 Dopravnoinzinierske prieskumy a studie"
                         "\\STU\\F prieskumy a studie\\F2 Environmentalne prieskumy a studie"
                         "\\STU\\F prieskumy a studie\\F3 Geologicke prieskumy a studie"
                         ))
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )

  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentacie stavebneho zameru"
  (if (= dokumentaciaStavebnehoZameru "1") 
    (progn 
      (setq ListOfPath '("\\DSZ"
                         "\\DSZ\\A Sprievodna sprava"
                         "\\DSZ\\B Technicka sprava"
                         "\\DSZ\\C Ekonomicka sprava"
                         "\\DSZ\\D Vykresy pre pozemne komunikacie"
                         "\\DSZ\\E Doklady a povolenia"
                         ))
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )

  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentacie pre uzemne rozhodnutie"
  (if (= dokumentaciaPreUzemneRozhodnutie "1") 
    (progn 
      (setq ListOfPath '("\\DUR"
                         "\\DUR\\A Sprievodna sprava"
                         "\\DUR\\B Suhrna technicka sprava"
                         "\\DUR\\C Ekonomicka sprava"
                         "\\DUR\\C Ekonomicka sprava\\C1 Naklady"
                         "\\DUR\\C Ekonomicka sprava\\C2 Nakladovo-vynosova analyza (CBA)"
                         "\\DUR\\D Pisomnosti a vykresy objektov"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D11 Prehladna situacia"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D12 Celkova situacia stavby"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D13 Ortofotomapa (celkova situacia)"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D14 Ortofotomapa (na KN podklade)"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D15 Koordinacne vykresy"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D16 Demolacie"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D17 Propagacia"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D2 Pozemne komunikacie"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D3 Mostne objekty"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D4 Tunely"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D5 Geotechnicke konstrukcie"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D6 Obsluzne dopravne zariadenia"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D7 Prevadzkove prvky"
                         "\\DUR\\D Pisomnosti a vykresy objektov\\D8 Ostatne objekty"
                         "\\DUR\\E Doklady a povolenia"
                         "\\DUR\\F Prieskumy a studie"
                         "\\DUR\\F Prieskumy a studie\\F1 Dopravnoinzinierske prieskumy a studie"
                         "\\DUR\\F Prieskumy a studie\\F2 Environmentalne prieskumy a studie"
                         "\\DUR\\F Prieskumy a studie\\F3 Geologicke prieskumy"
                         "\\DUR\\F Prieskumy a studie\\F4 Ostatne prieskumy"
                         "\\DUR\\G Suvisiaca dokumentacia"
                         "\\DUR\\G Suvisiaca dokumentacia\\G1 Zabery pozemkov"
                         "\\DUR\\G Suvisiaca dokumentacia\\G2 Dokumentacia pre vynatie pozemkov z LP a odnatie z PP"
                         "\\DUR\\G Suvisiaca dokumentacia\\G3 Bezpecnost"
                         "\\DUR\\G Suvisiaca dokumentacia\\G4 Specialna dokumentacia pre tunely"
                         "\\DUR\\G Suvisiaca dokumentacia\\G5 Monitoring"
                         "\\DUR\\G Suvisiaca dokumentacia\\G6 Dokumentacia pre ZSR"
                         "\\DUR\\G Suvisiaca dokumentacia\\G7 Podklady k ziadosti o usporiadanie cestnej siete"
                         ))
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )

  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentacie na stavebne pov"
  (if (= dokumentaciaNaStavebnePovolenie "1") 
    (progn 
      (setq ListOfPath '("\\DSP"
                         "\\DSP\\A Sprievodna sprava"
                         "\\DSP\\B Technicka sprava"
                         "\\DSP\\C Ekonomica sprava"
                         "\\DSP\\C Ekonomica sprava\\C1 Naklady"
                         "\\DSP\\C Ekonomica sprava\\C2 Nakladovo-vynosova analyza (CBA)"
                         "\\DSP\\D Pisomnosti a vykresy objektov"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D11 Prehladna situacia"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D12 Celkova situacia stavby"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D13 Pozdlzny profil"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D14 Ortofotomapa (celkova situacia)"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D15 Ortofotomapa (na KN podklade)"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D16 Koordinacne vykresy"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D17 Ostatne vseobecne stavebne pisomnosti a vykresy"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D18 Dopravne znacenie"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D19 Propagacia"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D2 Pozemne komunikacie"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D3 Mostne objekty"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D4 Tunely"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D5 Geotechnicke konstrukcie"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D6 Protihlukove opatrenia"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D7 Oblusne dopravne zariadenia a objekty udrzby"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D8 Prevadzkove prvky"
                         "\\DSP\\D Pisomnosti a vykresy objektov\\D9 Ostatne objekty"
                         "\\DSP\\E Dokladova cast"
                         "\\DSP\\F Prieskumy a studie"
                         "\\DSP\\F Prieskumy a studie\\F1 Dopravnoinzinierske prieskumy a studie"
                         "\\DSP\\F Prieskumy a studie\\F2 Environmentalne prieskumy a studie"
                         "\\DSP\\F Prieskumy a studie\\F3 Geologicke prieskumy"
                         "\\DSP\\F Prieskumy a studie\\F4 Ostatne prieskumy"
                         "\\DSP\\G Suvisiaca dokumentacia"
                         "\\DSP\\G Suvisiaca dokumentacia\\G1 Dokumentacia merackych prac"
                         "\\DSP\\G Suvisiaca dokumentacia\\G2 Dokumentacia na majetkopravne vysporiadanie"
                         "\\DSP\\G Suvisiaca dokumentacia\\G3 Dokumentacia pre vynatie z LP a z PP"
                         "\\DSP\\G Suvisiaca dokumentacia\\G4 Bezpecnost"
                         "\\DSP\\G Suvisiaca dokumentacia\\G5 Specialna dokumentacia pre tunely"
                         "\\DSP\\G Suvisiaca dokumentacia\\G6 Monitoring"
                         "\\DSP\\G Suvisiaca dokumentacia\\G7 Dokumentacia pre ZSR"
                         "\\DSP\\G Suvisiaca dokumentacia\\G8 Podklady k ziadosti o usporiadanie cestnej siete"
                         ))
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )

  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentacie na ohlasenie stavby"
  (if (= dokumentaciaNaOhlasenieStavby "1") 
    (progn 
      (setq ListOfPath '("\\DOS"
                         "\\DOS\\A Sprievodna sprava"
                         "\\DOS\\B Technicka cast"
                         "\\DOS\\C Ekonomicka sprava"
                         "\\DOS\\C Ekonomicka sprava\\C1 Naklady"
                         "\\DOS\\C Ekonomicka sprava\\C2 Nakladovo-vynosova analyza (CBA)"
                         "\\DOS\\D Pisomnosti a vykresy objektov"
                         "\\DOS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy"
                         "\\DOS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D11 Prehladna situacia"
                         "\\DOS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D12 Celkova situacia stavby"
                         "\\DOS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D13 Ortofotomapa "
                         "\\DOS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D14 Ostatne vseobecne stavebne pisomnosti a vykresy"
                         "\\DOS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D15 Dopravne znacenie"
                         "\\DOS\\D Pisomnosti a vykresy objektov\\D2 Pozemne komunikacie"
                         "\\DOS\\D Pisomnosti a vykresy objektov\\D3 Prevadzkove prvky"
                         "\\DOS\\D Pisomnosti a vykresy objektov\\D4 Ostatne plochy"
                         "\\DOS\\E Dokladova cast"
                         "\\DOS\\F Prieskumy a studie"
                         "\\DOS\\F Prieskumy a studie\\F1 Dopravnoinzinierske prieskumy a studie"
                         "\\DOS\\F Prieskumy a studie\\F2 Environmentalne prieskumy a studie"
                         "\\DOS\\F Prieskumy a studie\\F3 Geologicke prieskumy"
                         "\\DOS\\F Prieskumy a studie\\F4 Bezpecnost"
                         "\\DOS\\F Prieskumy a studie\\F5 Monitoring"
                         ))
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )

  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentacie na uzemne rozhodnutie a stavebne povolenie"
  (if (= dokumentaciaNaUzemneRozhodnutieStavebnePovenie "1") 
    (progn 
      (setq ListOfPath '("\\DURSP"
                         "\\DURSP\\A Sprievodna sprava"
                         "\\DURSP\\B Technicka sprava"
                         "\\DURSP\\C Ekonomicka sprava"
                         "\\DURSP\\C Ekonomicka sprava\\C1 Naklady"
                         "\\DURSP\\C Ekonomicka sprava\\C2 Nakladovo-vynosova analyza (CBA)"
                         "\\DURSP\\D Pisomnosti a vykresy objektov"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D11 Prehladna situacia"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D12 Celkova situacia stavby"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D13 Pozdlzny profil"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D14 Ortofotomapa (celkova situacia)"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D15 Ortofotomapa (na KN podklade)"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\F16 Koordinacne vykresy"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\F17 Ostatne vseobecne stavebne pisomnosti a vykresy"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D18 Dopravne znacenie"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D19 Propagacia"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D2 Pozemne komunikacie"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D3 Mostne objekty"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D4 Tunely"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D5 Geotechnicke konstrukcia"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D6 Protihlukove opatrenia"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D7 Obsluzne dopravne zariadenia a objekty udrzby"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D8 Prevadzkove prvky"
                         "\\DURSP\\D Pisomnosti a vykresy objektov\\D9 Ostatne objekty"
                         "\\DURSP\\E Doklady a povolenia"
                         "\\DURSP\\E Doklady a povolenia\\E1 Doklady"
                         "\\DURSP\\E Doklady a povolenia\\E2 Cestny bezpecnostny audit"
                         "\\DURSP\\F Prieskumy a studie"
                         "\\DURSP\\F Prieskumy a studie\\F1 Dopravnoinzinierske prieskumy a studie"
                         "\\DURSP\\F Prieskumy a studie\\F2 Environmentalne prieskumy a studie"
                         "\\DURSP\\F Prieskumy a studie\\F3 Geologicke prieskumy"
                         "\\DURSP\\F Prieskumy a studie\\F4 Ostatne prieskumy"
                         "\\DURSP\\G Suvisiaca dokumentacia"
                         "\\DURSP\\G Suvisiaca dokumentacia\\G1 Dokumentacia merackych prac"
                         "\\DURSP\\G Suvisiaca dokumentacia\\G2 Dokumentacia na majetkopravne vysporiadanie"
                         "\\DURSP\\G Suvisiaca dokumentacia\\G3 Dokumentacia pre odnatie pody"
                         "\\DURSP\\G Suvisiaca dokumentacia\\G4 Bezpecnost"
                         "\\DURSP\\G Suvisiaca dokumentacia\\G5 Monitoring"
                         "\\DURSP\\G Suvisiaca dokumentacia\\G6 Dokumentacia pre ZSR"
                         "\\DURSP\\G Suvisiaca dokumentacia\\G7 Podklady k ziadosti o usporiadanie cestnej siete"
                         ))  
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )

  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentacia na realizaciu stavby"
  (if (= dokumentaciaNaRealizaciuStavby "1") 
    (progn 
      (setq ListOfPath '("\\DRS"
                         "\\DRS\\A Sprievodna sprava"
                         "\\DRS\\B Technicka sprava"
                         "\\DRS\\C Ekonomicka sprava"
                         "\\DRS\\C Ekonomicka sprava\\C1 Naklady"
                         "\\DRS\\C Ekonomicka sprava\\C2 Nakladovo-vynosova analyza (CBA)"
                         "\\DRS\\D Pisomnosti a vykresy objektov"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D11 Prehladna situacia"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D12 Celkova situacia stavby"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D13 Pozdlzny profil"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D14 Ortofotomapa (celkova situacia)"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D15 Ortofotomapa (na KN podklade)"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D16 Koordinacne vykresy"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D17 Ostatne vseobecne stavebne pisomnosti a vykresy"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D18 Dopravne znacenie"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D2 Pozemne komunikacie"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D3 Mostne objekty"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D4 Tunely"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D5 Geotechnicke konstrukcie"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D6 Protihlukove opatrenia"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D7 Obsluzne dopravne zariadenia a objekty udrzby"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D8 Prevadzkove prvky"
                         "\\DRS\\D Pisomnosti a vykresy objektov\\D9 Ostatne objekty"
                         "\\DRS\\E Doklady a povolenia"
                         "\\DRS\\F Prieskumy a studie"
                         "\\DRS\\G Suvisiaca dokumentacia"
                         "\\DRS\\G Suvisiaca dokumentacia\\G1 Dokumentacia meracskych prac"
                         "\\DRS\\G Suvisiaca dokumentacia\\G2 Bezpecnost"
                         "\\DRS\\G Suvisiaca dokumentacia\\G3 Specialna dokumentacia pre tunely"
                         "\\DRS\\G Suvisiaca dokumentacia\\G4 Monitoring"
                         "\\DRS\\G Suvisiaca dokumentacia\\G5 Dokumentacia pre ZSR"
                         "\\DRS\\G Suvisiaca dokumentacia\\G6 Podklady k ziadosti o usporiadanie cestnej siete"
                         ))
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )

  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentacia na stavebne povolenia a realizaciu stavby"
  (if (= dokumentaciaNaStavebnePovolenieRealizaciuStavby "1") 
    (progn 
      (setq ListOfPath '("\\DSPRS"
                         "\\DSPRS\\A Sprievodana sprava"
                         "\\DSPRS\\B Technicka sprava"
                         "\\DSPRS\\C Ekonomicka sprava"
                         "\\DSPRS\\C Ekonomicka sprava\\C1 Naklady"
                         "\\DSPRS\\C Ekonomicka sprava\\C2 Nakladovo-vynosova analyza (CBA)"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D11 Prehladna situacia"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D12 Celkova situacia stavby"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D13 Ortofotomapa (na KN podklade)"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D14 Koordinacne vykresy"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D15 Ostatne vseobecne stavebne pisomnosti a vykresy"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D1 Vseobecne vykresy\\D16 Dopravne znacenie"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D2 Pozemne komunikacie"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D3 Mostne objektu"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D4 Tunely"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D5 Geotechnicke konstrukcie"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D6 Protihlukove opatrenia"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D7 Obsluzne dopravne zariadenia a objekty udrzby"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D8 Prevadzkove prvky"
                         "\\DSPRS\\D Pisomnosti a vykresy objektov\\D9 Ostatne objekty"
                         "\\DSPRS\\E Dokladova cast"
                         "\\DSPRS\\F Prieskumy a studie"
                         "\\DSPRS\\F Prieskumy a studie\\F1 Dopravnoinzinierske prieskumy a studie"
                         "\\DSPRS\\F Prieskumy a studie\\F2 Environmentalne prieskumy a studie"
                         "\\DSPRS\\F Prieskumy a studie\\F3 Geologicke prieskumy"
                         "\\DSPRS\\F Prieskumy a studie\\F4 Ostatne prieskumy"
                         "\\DSPRS\\G Suvisiaca dokumentacia"
                         "\\DSPRS\\G Suvisiaca dokumentacia\\G1 Dokumentacia meracskych prac"
                         "\\DSPRS\\G Suvisiaca dokumentacia\\G2 Dokumentacia na majetkopravne vysporiadanie"
                         "\\DSPRS\\G Suvisiaca dokumentacia\\G3 Dokumentacia pre vynatie z LP a z PP"
                         "\\DSPRS\\G Suvisiaca dokumentacia\\G4 Bezpecnost"
                         "\\DSPRS\\G Suvisiaca dokumentacia\\G5 Monitoring"
                         "\\DSPRS\\G Suvisiaca dokumentacia\\G6 Dokumentacia pre ZSR"
                         "\\DSPRS\\G Suvisiaca dokumentacia\\G7 Podklady k ziadnosti o usporiadanie cestnej siete"
                         ))
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )

  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentacia na vykonanie prac"
  (if (= dokumentaciaNaVykonanieprac "1") 
    (progn 
      (setq ListOfPath '("\\DVP"
                         "\\DVP\\D Pisomnosti a vykresy objektov"
                         "\\DVP\\D Pisomnosti a vykresy objektov\\D1 Pozemne komunikacie"
                         "\\DVP\\D Pisomnosti a vykresy objektov\\D2 Mostne objekty, tunely a ostatne objekty"
                         ))
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )

  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentacie skutocneho realizovania stavby"
  (if (= dokumentaciaSkutocnehoRealizovaniaStavby "1") 
    (progn 
      (setq ListOfPath '("\\DSRS"
                         "\\DSRS\\D Dokumentacia objektov"
                         "\\DSRS\\D Dokumentacia objektov\\D1 Vseobecne"
                         "\\DSRS\\D Dokumentacia objektov\\D2 Geodeticka dokumentacia GD-DSRS objektov"
                         "\\DSRS\\D Dokumentacia objektov\\D3 Pisomnosti a vykresy objektov"
                         "\\DSRS\\D Dokumentacia objektov\\D3 Pisomnosti a vykresy objektov\\D31 Pozemne komunikacie"
                         "\\DSRS\\D Dokumentacia objektov\\D3 Pisomnosti a vykresy objektov\\D32 Mosty"
                         "\\DSRS\\D Dokumentacia objektov\\D3 Pisomnosti a vykresy objektov\\D33 Tunely"
                         "\\DSRS\\D Dokumentacia objektov\\D3 Pisomnosti a vykresy objektov\\D34 Geotechnicke konstrukcie"
                         "\\DSRS\\D Dokumentacia objektov\\D3 Pisomnosti a vykresy objektov\\D35 Protihlukove opatrenia"
                         "\\DSRS\\D Dokumentacia objektov\\D3 Pisomnosti a vykresy objektov\\D36 Obsluzne dopravne zariadenia a objekty udrzby"
                         "\\DSRS\\D Dokumentacia objektov\\D3 Pisomnosti a vykresy objektov\\D37 Prevadzkove prvky"
                         "\\DSRS\\D Dokumentacia objektov\\D3 Pisomnosti a vykresy objektov\\D38 Ostatne objekty"
                         "\\DSRS\\G Suvisiaca dokumentacia"
                         "\\DSRS\\G Suvisiaca dokumentacia\\G1 Manualy uzivania stavby"
                         "\\DSRS\\G Suvisiaca dokumentacia\\G2 Prevadzkova dokumentacie"
                         "\\DSRS\\G Suvisiaca dokumentacia\\G3 Bezpecnostna dokumentacia pre tunely"
                         "\\DSRS\\G Suvisiaca dokumentacia\\G4 Tunelovy list"
                         "\\DSRS\\G Suvisiaca dokumentacia\\G5 Dokumentacia monitorovania betonoveho ostenia tunelov"
                         "\\DSRS\\G Suvisiaca dokumentacia\\G6 Geotechnicky monitoring pocas prevadzkty"
                         "\\DSRS\\G Suvisiaca dokumentacia\\G7 Dokumentacia monitorovania ochrannych opatreni pre obmedzenie vplyvu bludnych prudov"
                         ));
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )
  
  ;vyhodnotenie spustenia vytvorenia struktury "Vyhledavaci studie (CZ)"                              
  (if (= vyhledavaciStudie_CZ "1") 
    (progn 
      (setq ListOfPath '("\\VST"
                         "\\VST\\A Pruvodni zprava"
                         "\\VST\\B Vykresy"
                         "\\VST\\B Vykresy\\B1 Prehledna situace"
                         "\\VST\\B Vykresy\\B2 Situace variant"
                         "\\VST\\B Vykresy\\B3 Podelne profily variant"
                         "\\VST\\B Vykresy\\B4 Vzorove pricne rezy variant"
                         "\\VST\\C Podklady a pruzkumy"
                         "\\VST\\D Doklady"
                         ));
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )
  
  ;vyhodnotenie spustenia vytvorenia struktury "Technicej studie (CZ)"                              
  (if (= technickaStudie_CZ "1") 
    (progn 
      (setq ListOfPath '("\\TST"
                         "\\TST\\A Pruvodni zprava"
                         "\\TST\\B Vykresy"
                         "\\TST\\B Vykresy\\B1 Prehledna situace"
                         "\\TST\\B Vykresy\\B2 Situace"
                         "\\TST\\B Vykresy\\B3 Podelne profily variant"
                         "\\TST\\B Vykresy\\B4 Vzorove pricne rezy"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Mimourovnove krizovatky"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Mostni objekty"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Mostni objekty\\A Pruvodni zprava"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Mostni objekty\\B Vykresy"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Mostni objekty\\B Vykresy\\B1 Prehledna situace"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Mostni objekty\\B Vykresy\\B2 Mapa se zakreslenim ekologickeho vyhodnoceni zajmoveho uzemi"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Mostni objekty\\B Vykresy\\B3 Pudorys"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Mostni objekty\\B Vykresy\\B4 Podelny rez"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Mostni objekty\\B Vykresy\\B5 Dalsi prehledne vykresy"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Mostni objekty\\C Souvisici dokumentace"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Mostni objekty\\D Dokaldy"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Tunely"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Tunely\\A Pruvodni zprava"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Tunely\\B Vykresy"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Tunely\\B Vykresy\\B1 Prehledna situace"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Tunely\\B Vykresy\\B2 Vzorove pricne rezy"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Tunely\\B Vykresy\\B3 Situace variant"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Tunely\\B Vykresy\\B4 Podelne rezy"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Tunely\\B Vykresy\\B5 Synteticka mapa"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Tunely\\C Souvisici dokumentace"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Tunely\\D Doklady"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Galerie"
                         "\\TST\\B Vykresy\\B5 Vykresy dulezitych objektu stavby\\Zdi"
                         "\\TST\\C Souvisici dokumentace"
                         "\\TST\\C Souvisici dokumentace\\C1 Dopravne inzenyrske udaje"
                         "\\TST\\C Souvisici dokumentace\\C2 Zivotni prostredi - pozadavky EIA"
                         "\\TST\\C Souvisici dokumentace\\C3 Vazba na uzemne planovaci podklady"
                         "\\TST\\C Souvisici dokumentace\\C4 Odhad nakladu stavby"
                         "\\TST\\C Souvisici dokumentace\\C5 Zabory"
                         "\\TST\\C Souvisici dokumentace\\C6 Orientacni geotechnicky-inzenyrskogeologicky pruzkum"
                         "\\TST\\C Souvisici dokumentace\\C7 Predbezny harmonogram pripravy a realizace stavby"
                         "\\TST\\D Doklady"
                         ));
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )
  
  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentace pro vydani uzemniho rozhodnuti (CZ)"                              
  (if (= dokumentaceProVydaniUzemnihoRozhodnuti_CZ "1") 
    (progn 
      (setq ListOfPath '("\\DUR"
                         "\\DUR\\A Pruvodni zprava"
                         "\\DUR\\B Souhrnna technicka zprava"
                         "\\DUR\\C Situacni vykresy"
                         "\\DUR\\C Situacni vykresy\\C1 Situacni vykres sirsich vztahu"
                         "\\DUR\\C Situacni vykresy\\C2 Katastralni situacni vykres"
                         "\\DUR\\C Situacni vykresy\\C3 Koordinacni situacni vykres"
                         "\\DUR\\C Situacni vykresy\\C4 Specialni vykresy"
                         "\\DUR\\D Dokumentace objektu"
                         "\\DUR\\D Dokumentace objektu\\D1 Stavebni cast"
                         "\\DUR\\D Dokumentace objektu\\D1 Stavebni cast\\D11 Objekty pozemnich komunikaci"
                         "\\DUR\\D Dokumentace objektu\\D1 Stavebni cast\\D12 Mostni objekty a zdi"
                         "\\DUR\\D Dokumentace objektu\\D1 Stavebni cast\\D13 Vodohospodarske objekty"
                         "\\DUR\\D Dokumentace objektu\\D1 Stavebni cast\\D14 Elektro a sdelovaci objekty"
                         "\\DUR\\D Dokumentace objektu\\D1 Stavebni cast\\D15 Objkety trubnich vedeni"
                         "\\DUR\\D Dokumentace objektu\\D1 Stavebni cast\\D16 Objekty podzemnich staveb"
                         "\\DUR\\D Dokumentace objektu\\D1 Stavebni cast\\D17 Objekty drah"
                         "\\DUR\\D Dokumentace objektu\\D1 Stavebni cast\\D18 Objekty pozemnich staveb"
                         "\\DUR\\D Dokumentace objektu\\D1 Stavebni cast\\D19 Objekty upravy uzemi"
                         "\\DUR\\D Dokumentace objektu\\D1 Stavebni cast\\D110 Ostatni stavebni objekty"
                         "\\DUR\\D Dokumentace objektu\\D2 Technologicka cast"
                         "\\DUR\\Dokladova cast"
                         "\\DUR\\Dokladova cast\\1 Zavazna stanoviska, stanoviska, rozhodnuti, vyjadreni dotcenych organu"
                         "\\DUR\\Dokladova cast\\2 Dokumentace vlivu zameru na zivotni prostredi"
                         "\\DUR\\Dokladova cast\\3 Doklad podle zvlastniho pravniho predpisu"
                         "\\DUR\\Dokladova cast\\4 Stanoviska vlastniku verejne dopravni a technicke infrastruktury"
                         "\\DUR\\Dokladova cast\\5 Geodeticky podklad pro projektovou cinnost zpracovany podle jinych pravnich predpisu"
                         "\\DUR\\Dokladova cast\\6 Inzenyrskogeologicke, diagnosticke a dopravni pruzkumy"
                         "\\DUR\\Dokladova cast\\7 Ostatni stanoviska, vyjadreni, posudky, studie a vysledky jednani"
                         "\\DUR\\Souvisici dokumentace"
                         "\\DUR\\Souvisici dokumentace\\1 Pruzkumy zajistovane v ramci DUR"
                         "\\DUR\\Souvisici dokumentace\\2 Hlukova studie"
                         "\\DUR\\Souvisici dokumentace\\3 Rozptylova (exhalacni) studie"
                         "\\DUR\\Souvisici dokumentace\\4 Bilancie zemin a ornice"
                         "\\DUR\\Souvisici dokumentace\\5 Podklady pro odneti ze ZPF a PUPFL"
                         "\\DUR\\Souvisici dokumentace\\6 Dokumentace pro projednani s prislusnymi utvary drahy"
                         "\\DUR\\Souvisici dokumentace\\7 Odhad stavebnich nakladu"
                         "\\DUR\\Souvisici dokumentace\\8 Projekt odpadoveho hospodarstvi"
                         ));
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )
  
  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentace pro vydani spolecneho povoleni (CZ)"                              
  (if (= dokumentaceProVydaniSpolocnehoPovoleni_CZ "1") 
    (progn 
      (setq ListOfPath '("\\DUSP"
                         "\\DUSP\\A Pruvodni zprava"
                         "\\DUSP\\B Souhrnna technicka zprava"
                         "\\DUSP\\C Situacni vykresy"
                         "\\DUSP\\C Situacni vykresy\\C1 Situacni vykres sirsich vztahu"
                         "\\DUSP\\C Situacni vykresy\\C2 Katastralni situacni vykres"
                         "\\DUSP\\C Situacni vykresy\\C3 Koordinacni situacni vykres"
                         "\\DUSP\\C Situacni vykresy\\C4 Specialni vykresy"
                         "\\DUSP\\D Dokumentace objektu a technickych a technologickych zarizeni"
                         "\\DUSP\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast"
                         "\\DUSP\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D11 Objekty pozemnich komunikaci vcetne propustku"
                         "\\DUSP\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D12 Mostni objekty a zdi"
                         "\\DUSP\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D13 Vodohospodarske objekty"
                         "\\DUSP\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D14 Objekty osvetleni pozemni komunikace"
                         "\\DUSP\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D15 Objekty podzemnich staveb"
                         "\\DUSP\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D16 objekty zarizeni pro provozni informace a telematiku"
                         "\\DUSP\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D17 Objekty drah"
                         "\\DUSP\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D18 objekty pozemnich staveb"
                         "\\DUSP\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D19 Ostatni stavebni objekty"
                         "\\DUSP\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D110 Pozarnebezpecnostni reseni"
                         "\\DUSP\\D Dokumentace objektu a technickych a technologickych zarizeni\\D2 Technologicka cast"
                         "\\DUSP\\Dokladova cast"
                         "\\DUSP\\Dokladova cast\\1 Zavazna stanoviska, stanoviska, rozhodnuti, vyjadreni dotcenych organu"
                         "\\DUSP\\Dokladova cast\\2 Dokumentace vlivu zameru na zivotni prostredi"
                         "\\DUSP\\Dokladova cast\\3 Doklad podle jineho pravniho predpisu"
                         "\\DUSP\\Dokladova cast\\4 Stanoviska vlastniku verejne dopravni a technicke infrastruktury"
                         "\\DUSP\\Dokladova cast\\5 Geodeticky podklad pro projektovou cinnost zpracovany podle jinych pravnich predpisu"
                         "\\DUSP\\Dokladova cast\\6 Projekt zpracovany banskym projektantem"
                         "\\DUSP\\Dokladova cast\\7 Prukaz energeticke narocnosti budovy podle zakona a o hospodareni s energii"
                         "\\DUSP\\Dokladova cast\\8 Inzenyrskogeologicke, diagnosticke a dopravni pruzkumy"
                         "\\DUSP\\Dokladova cast\\9 Ostatni stanoviska, vyjadreni, posudky, studie a vysledky jednani"
                         "\\DUSP\\Souvisici dokumentace"
                         "\\DUSP\\Souvisici dokumentace\\1 Ucinky stavby"
                         "\\DUSP\\Souvisici dokumentace\\2 Podklady a pruzkumy"
                         "\\DUSP\\Odhad stavebnich nakladu"
                         ));
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )
  
  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentace pro vydani spolocneho povoleni u staveb dopravni infrastruktury (CZ)"                              
  (if (= dokumentaceProVydaniSpolocnehoPovoleniUStavebDopravniInfrastruktury_CZ "1") 
    (progn 
      (setq ListOfPath '("\\DUSP-DI"
                         "\\DUSP-DI\\A Pruvodni zprava"
                         "\\DUSP-DI\\B Souhrnna technicka zprava"
                         "\\DUSP-DI\\C Situacni vykresy"
                         "\\DUSP-DI\\C Situacni vykresy\\C1 Situacni vykres sirsich vztahu"
                         "\\DUSP-DI\\C Situacni vykresy\\C2 Katastralni situacni vykres"
                         "\\DUSP-DI\\C Situacni vykresy\\C3 Koordinacni situacni vykres"
                         "\\DUSP-DI\\C Situacni vykresy\\C4 Specialni vykresy"
                         "\\DUSP-DI\\C Situacni vykresy\\C5 Situacni vykres zaboru"
                         "\\DUSP-DI\\D Dokumentace objketu"
                         "\\DUSP-DI\\D Dokumentace objketu\\D1 Stavebni cast"
                         "\\DUSP-DI\\D Dokumentace objketu\\D1 Stavebni cast\\D11 Objekty pozemnich komunikaci vcetne porpustku"
                         "\\DUSP-DI\\D Dokumentace objketu\\D1 Stavebni cast\\D12 Mostni objekty a zdi"
                         "\\DUSP-DI\\D Dokumentace objketu\\D1 Stavebni cast\\D13 Vodohospodarske objekty"
                         "\\DUSP-DI\\D Dokumentace objketu\\D1 Stavebni cast\\D14 Objekty osvetleni pozemni komunikace"
                         "\\DUSP-DI\\D Dokumentace objketu\\D1 Stavebni cast\\D15 objekty podzemnich staveb"
                         "\\DUSP-DI\\D Dokumentace objketu\\D1 Stavebni cast\\D16 Objekty zarizeni pro provozni informace a telematiku"
                         "\\DUSP-DI\\D Dokumentace objketu\\D1 Stavebni cast\\D17 Objekty drah"
                         "\\DUSP-DI\\D Dokumentace objketu\\D1 Stavebni cast\\D18 Objekty pozemnich staveb"
                         "\\DUSP-DI\\D Dokumentace objketu\\D1 Stavebni cast\\D19 Ostatni stavebni objekty"
                         "\\DUSP-DI\\D Dokumentace objketu\\D2 Technologicka cast"
                         "\\DUSP-DI\\Dokladova cast"
                         "\\DUSP-DI\\Dokladova cast\\1 Zavazna stanoviska, stanoviska, rozhodnuti a vyjadreni dotcenych organu"
                         "\\DUSP-DI\\Dokladova cast\\2 Dokumentace vlivu zameru na zivotne prostredi"
                         "\\DUSP-DI\\Dokladova cast\\3 Doklad podle jineho pravniho predpisu"
                         "\\DUSP-DI\\Dokladova cast\\4 Stanoviska vlastniku verejne dopravni a technicke infrastruktury"
                         "\\DUSP-DI\\Dokladova cast\\5 Geodeticky podklad pro projektovou cinnost zpracovany podle jinych pravnich predpisu"
                         "\\DUSP-DI\\Dokladova cast\\6 Projekt zpracovany banskym projektantem"
                         "\\DUSP-DI\\Dokladova cast\\7 Prukaz energeticke narocnosti budoby"
                         "\\DUSP-DI\\Dokladova cast\\8 Inzenyrskogeologicke, diagnosticke a dopravni pri"
                         "\\DUSP-DI\\Dokladova cast\\9 Ostatni stanoviska, vyjadreni, posudky, studie e                                                          xcx"
                         "\\DUSP-DI\\Souvisici dokumentace"
                         "\\DUSP-DI\\Souvisici dokumentace\\1 Ucinky stavby"
                         "\\DUSP-DI\\Souvisici dokumentace\\2 Podklady a pruzkumy"
                         "\\DUSP-DI\\Odhad stavebnich nakladu"
                         ));
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )
  
  ;vyhodnotenie spustenia vytvorenia struktury "Projektove dokumentace pro vydani stavebniho povoleni (CZ)"                              
  (if (= projektovaDokumentaceProVydaniStavebnihoPovoleni_CZ "1") 
    (progn 
      (setq ListOfPath '("\\DSP"
                         "\\DSP\\A Pruvodni zprava"
                         "\\DSP\\B Souhrnna technicka zprava"
                         "\\DSP\\C Situacni vykresy"
                         "\\DSP\\C Situacni vykresy\\C1 Situacni vykres sirsich vztahu"
                         "\\DSP\\C Situacni vykresy\\C2 Katastralni situacni vykres"
                         "\\DSP\\C Situacni vykresy\\C3 Koordinacni situacni vykres"
                         "\\DSP\\C Situacni vykresy\\C4 Specialni situacni vykres"
                         "\\DSP\\D Sokumentace objektu a technickych a technologickych zarizeni"
                         "\\DSP\\D Sokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast"
                         "\\DSP\\D Sokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D11 Objekty pozemnich komunikaci vcetne propustku"
                         "\\DSP\\D Sokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D12 Mostni objekty a zdi"
                         "\\DSP\\D Sokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D13 Vodohospodarske objekty"
                         "\\DSP\\D Sokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D14 Objekty osvetleni pozemni komunikace"
                         "\\DSP\\D Sokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D15 Objkety podzemnich staveb"
                         "\\DSP\\D Sokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D16 Objekty zarizeni pro provozni informace"
                         "\\DSP\\D Sokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D17 Objkety drah"
                         "\\DSP\\D Sokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D18 Objkety pozemnich staveb"
                         "\\DSP\\D Sokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D19 Ostatni stavebni objekty"
                         "\\DSP\\D Sokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\D110 Pozarnebezpecnostni reseni"
                         "\\DSP\\D Sokumentace objektu a technickych a technologickych zarizeni\\D2 Technologicka cast"
                         "\\DSP\\Dokladova cast"
                         "\\DSP\\Dokladova cast\\1 Zavazna stanoviska, stanoviska, rozhodnuti, vyjadreni dotcenych organu"
                         "\\DSP\\Dokladova cast\\2 Doklad podle jineho pravniho predpisu"
                         "\\DSP\\Dokladova cast\\3 Stanovisko  vlastniku verejne dopravni a technicke infrastruktu"
                         "\\DSP\\Dokladova cast\\4 Geodeticky podklad pro projektovou cinnost zpracovany podle jinych pravnich predpisu"
                         "\\DSP\\Dokladova cast\\5 Projekt zpracovany banskychm projektantem"
                         "\\DSP\\Dokladova cast\\6 Inzenyrskogeologicke, diagnositcke a dopravni pruzkumy"
                         "\\DSP\\Dokladova cast\\7 Ostatni stanoviska, vyjadreni, posudky a vysledky jednani vedenych v prubehu zpracovani dokumentace"
                         "\\DSP\\Souvisici dokumentace"
                         "\\DSP\\Souvisici dokumentace\\1 Ucinky stavby"
                         "\\DSP\\Souvisici dokumentace\\2 Podklady a pruzkumy"
                         "\\DSP\\Odhad stavebnich nakladu"
                         ));
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )
  
  ;vyhodnotenie spustenia vytvorenia struktury "Projektove dokumentace pro provadeni stavby (CS)"                              
  (if (= projektovaDokumentaceProProvadeniStavby_CZ "1") 
    (progn 
      (setq ListOfPath '("\\PDPS"
                         "\\PDPS\\A Pruvodni zprava"
                         "\\PDPS\\B Souhrnna technicka zprava"
                         "\\PDPS\\C Situacni vykresy"
                         "\\PDPS\\C Situacni vykresy\\C1 Situacni vykres sirsich vzthau"
                         "\\PDPS\\C Situacni vykresy\\C2 Koordinacni situacni vykres"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\000 Objekty pripravy staveniste"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\100 Objekty pozemnich komunikaca"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\200 Mostni objekty a zdi"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\300 Vodohospodarske objekty"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\400 Elektro a sdelovaci objekty"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\500 Objekty trubnich vedeni"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\600 Objekty podzemnich staveb"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\650 Objekty drah"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\700 Objekty pozemnich staveb"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\800 Objekty upravy uzemi"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\900 Volna rada objektu"
                         "\\PDPS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D2 Technologicka cast"
                         "\\PDPS\\Dokladova cast"
                         "\\PDPS\\Dokladova cast\\1 Projekt zpracovany banskym projektantem"
                         "\\PDPS\\Dokladova cast\\2 Geodeticka dokumentace"
                         ));
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )
  
  ;vyhodnotenie spustenia vytvorenia struktury "Vybrane dokumenty zadavaci dokumentace stavby (CZ)"                              
  (if (= vybraneDokumentyZadavaciDokumentaceStavby_CZ "1") 
    (progn 
      (setq ListOfPath '("\\VD-ZDS"
                         "\\VD-ZDS\\A Pruvodni zprava"
                         "\\VD-ZDS\\B Souhrnna technicka zprava"
                         "\\VD-ZDS\\C Situacni vykresy"
                         "\\VD-ZDS\\C Situacni vykresy\\C1 Situacni vykres sirsich vzthau"
                         "\\VD-ZDS\\C Situacni vykresy\\C2 Koordinacni situacni vykres"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\000 Objekty pripravy staveniste"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\100 Objekty pozemnich komunikaca"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\200 Mostni objekty a zdi"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\300 Vodohospodarske objekty"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\400 Elektro a sdelovaci objekty"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\500 Objekty trubnich vedeni"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\600 Objekty podzemnich staveb"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\650 Objekty drah"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\700 Objekty pozemnich staveb"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\800 Objekty upravy uzemi"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D1 Stavebni cast\\900 Volna rada objektu"
                         "\\VD-ZDS\\D Dokumentace objektu a technickych a technologickych zarizeni\\D2 Technologicka cast"
                         "\\VD-ZDS\\Dokladova cast"
                         "\\VD-ZDS\\Dokladova cast\\1 Projekt zpracovany banskym projektantem"
                         "\\VD-ZDS\\Dokladova cast\\2 Geodeticka dokumentace"
                         ));
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )
  
  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentace bouracich praci (CZ)"                              
  (if (= dokumentaceBouracichPraci_CZ "1") 
    (progn 
      (setq ListOfPath '("\\DBP"
                         "\\DBP\\A Pruvodni zprava"
                         "\\DBP\\B Souhrnna technicka zprava"
                         "\\DBP\\C Situacni vykresy"
                         "\\DBP\\C Situacni vykresy\\C1 Situacni vykres sirsich vztahu"
                         "\\DBP\\C Situacni vykresy\\C2 Katastralni situacni vykres"
                         "\\DBP\\D Dokumentace objektu a technickych a technologickych zarizeni"
                         "\\DBP\\Dokladova cast"
                         "\\DBP\\Dokladova cast\\1 Zavazna stanoviska, stanoviska, rozhodnuti, vyjadreni dotcenych organu"
                         "\\DBP\\Dokladova cast\\2 Stanoviska vlastnoku verejne dopravni a technicke infrastruktury"
                         "\\DBP\\Dokladova cast\\3 Projekt zpracovany banskym projektantem"
                         "\\DBP\\Dokladova cast\\4 Ostatni stanoviska, vyjadreni, posudky, studie a vysledky jednani"
                         ));
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )
  
  ;vyhodnotenie spustenia vytvorenia struktury "Realizacni dokumentace stavby (CZ)"                              
  (if (= realizacniDokumentaceStavby_CZ "1") 
    (progn 
      (setq ListOfPath '("\\RDS"
                         "\\RDS\\A Vyrobne technicka dokumentace pro zhotovovaci prace"
                         "\\RDS\\B Vyrobne technicka dokumentace pro pomocne prace"
                         "\\RDS\\C Dokumentace vyrobku dodanych na stavbu"
                         "\\RDS\\D Technologicke celky"
                         ));
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )
  
  ;vyhodnotenie spustenia vytvorenia struktury "Dokumentace skutecneho provedeni stavby (CZ)"                              
  (if (= dokumentaceSkutocnehoProvedeniStavby_CZ"1") 
    (progn 
      (setq ListOfPath '("\\DSPS"
                         "\\DSPS\\A Pruvodni zprava"
                         "\\DSPS\\B Souhrnna technicka zprava"
                         "\\DSPS\\C Situacni vykresy"
                         "\\DSPS\\C Situacni vykresy\\C1 Katastralni situacni vykres"
                         "\\DSPS\\C Situacni vykresy\\C2 Koordinacni situacni vykres"
                         "\\DSPS\\D Vykresova dokumentace"
                         ));
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )

  ;vyhodnotenie spustenia vytvorenia vlastnej struktury
  (if (= vlastnaStruktura "1") 
    (progn 
      (SearchFilepath)
      ;vytvorenie priecinkov
      (CreateFoldersScheme)
    )
  )

  ;hlaska ukoncenia
  (princ "\nVytvorena struktura dokumentacie.\n")
  (princ)
)

;funkcia tlacidla vytvorit
(defun VytvorenieFoldersScheme () 
  (setq studiaUskutocnitelnosti (get_tile "studiaUskutocnitelnosti"))
  (setq dokumentaciaStavebnehoZameru (get_tile "dokumentaciaStavebnehoZameru"))
  (setq dokumentaciaPreUzemneRozhodnutie (get_tile "dokumentaciaPreUzemneRozhodnutie"))
  (setq dokumentaciaNaStavebnePovolenie (get_tile "dokumentaciaNaStavebnePovolenie"))
  (setq dokumentaciaNaOhlasenieStavby (get_tile "dokumentaciaNaOhlasenieStavby"))
  (setq dokumentaciaNaUzemneRozhodnutieStavebnePovenie (get_tile "dokumentaciaNaUzemneRozhodnutieStavebnePovenie"))
  (setq dokumentaciaNaRealizaciuStavby (get_tile "dokumentaciaNaRealizaciuStavby"))
  (setq dokumentaciaNaStavebnePovolenieRealizaciuStavby (get_tile "dokumentaciaNaStavebnePovolenieRealizaciuStavby"))
  (setq dokumentaciaNaVykonanieprac (get_tile "dokumentaciaNaVykonanieprac"))
  (setq dokumentaciaSkutocnehoRealizovaniaStavby (get_tile "dokumentaciaSkutocnehoRealizovaniaStavby"))
  (setq vyhledavaciStudie_CZ (get_tile "vyhledavaciStudie_CZ"))
  (setq technickaStudie_CZ (get_tile "technickaStudie_CZ"))
  (setq dokumentaceProVydaniUzemnihoRozhodnuti_CZ (get_tile "dokumentaceProVydaniUzemnihoRozhodnuti_CZ"))
  (setq dokumentaceProVydaniSpolocnehoPovoleni_CZ (get_tile "dokumentaceProVydaniSpolocnehoPovoleni_CZ"))
  (setq dokumentaceProVydaniSpolocnehoPovoleniUStavebDopravniInfrastruktury_CZ (get_tile "dokumentaceProVydaniSpolocnehoPovoleniUStavebDopravniInfrastruktury_CZ"))
  (setq projektovaDokumentaceProVydaniStavebnihoPovoleni_CZ (get_tile "projektovaDokumentaceProVydaniStavebnihoPovoleni_CZ"))
  (setq projektovaDokumentaceProProvadeniStavby_CZ (get_tile "projektovaDokumentaceProProvadeniStavby_CZ"))
  (setq vybraneDokumentyZadavaciDokumentaceStavby_CZ (get_tile "vybraneDokumentyZadavaciDokumentaceStavby_CZ"))
  (setq dokumentaceBouracichPraci_CZ (get_tile "dokumentaceBouracichPraci_CZ"))
  (setq realizacniDokumentaceStavby_CZ (get_tile "realizacniDokumentaceStavby_CZ"))
  (setq okumentaceSkutocnehoProvedeniStavby_CZ (get_tile "okumentaceSkutocnehoProvedeniStavby_CZ"))
  (setq vlastnaStruktura (get_tile "vlastnaStruktura"))
)

;funkcia pre nacitanie suboru vyberom
(defun SearchFilepath () 
  ;vybratie suboru z priecinku
  (setq FilePath (getfiled "Vyberte subor pre vytvorenie struktury" "" "txt" 4))
  ;otvorenie suboru a vytvorenie prazdneho listu
  (setq FilePathOpen (open FilePath "r")
        ListOfPath   '()
  )
  ;zapis kazdeho riadku do listu
  (while (setq ListLine (read-line FilePathOpen)) 
    (setq ListOfPath (cons ListLine ListOfPath))
  )
  ;zavretie suboru
  (close FilePathOpen)
  ;prevratenie listu
  (setq ListofPath (reverse ListOfPath))
)

;funkcia pre nacitanie suboru automaticky
(defun AddFilepath () 
  ;otvorenie suboru a vytvorenie prazdneho listu
  (setq FilePathOpen (open FilePath "r")
        ListOfPath   '()
  )
  ;zapis kazdeho riadku do listu
  (while (setq ListLine (read-line FilePathOpen)) 
    (setq ListOfPath (cons ListLine ListOfPath))
  )
  ;zavretie suboru
  (close FilePathOpen)
  ;prevratenie listu
  (setq ListofPath (reverse ListOfPath))
)

;funkcia pre vyvorenie priecinkov
(defun CreateFoldersScheme () 
  ;nastavenie cesty vytvorenia suborov
  (setq SelectedFolderPath (LM:browseforfolder 
                             "Vyberte cestu pre vytvorenie struktury"
                             ""
                             0
                           )
  )
  ;vytvorenie priecinkov zo zoznamu
  (foreach ListItem ListofPath 
    ;spojenie vybranej cesty a struktury priecinkov
    (setq CreateFolderPath (strcat SelectedFolderPath ListItem))
    ;vytvorenie jednotlivych priecinkov
    (LM:createdirectory CreateFolderPath)
  )
)

;funkcia tlacidla zavriet
(defun UkoncenieFoldersScheme () 
  (done_dialog)
  (princ "\nNevytvorena ziadna struktura dokumentacie.\n")
  (exit)
)

;;----------------------------------------------------------------------;;
;;              Pomocna funkcia pre vytvorenie priecinkov               ;;
;;----------------------------------------------------------------------;;

;; Create Directory  -  Lee Mac
;; https://lee-mac.com/createdirectory.html
;; dir - [str] directory to create ("C:\\Folder1\\Folder2")
;; Returns:  T if directory creation is successful, else nil

(defun LM:createdirectory (dir) 
  ((lambda (fun) 
     ((lambda (lst) (fun (car lst) (cdr lst))) 
       (vl-remove "" (LM:str->lst (vl-string-translate "/" "\\" dir) "\\"))
     )
   ) 
    (lambda (root lst / dir) 
      (if lst 
        (if 
          (or (vl-file-directory-p (setq dir (strcat root "\\" (car lst)))) 
              (vl-mkdir dir)
          )
          (fun dir (cdr lst))
        )
      )
    )
  )
  (vl-file-directory-p dir)
)

;; String to List  -  Lee Mac
;; Separates a string using a given delimiter
;; str - [str] string to process
;; del - [str] delimiter by which to separate the string

(defun LM:str->lst (str del / pos) 
  (if (setq pos (vl-string-search del str)) 
    (cons (substr str 1 pos) (LM:str->lst (substr str (+ pos 1 (strlen del))) del))
    (list str)
  )
)

;; Browse for Folder  -  Lee Mac
;; Displays a dialog prompting the user to select a folder.
;; https://lee-mac.com/directorydialog.html
;; msg - [str] message to display at top of dialog
;; dir - [str] [optional] root directory (or nil)
;; bit - [int] bit-coded flag specifying dialog display settings
;; Returns: [str] Selected folder filepath, else nil.
 
(defun LM:browseforfolder (msg dir bit / err fld pth shl slf) 
  (setq err (vl-catch-all-apply 
              (function 
                (lambda (/ app hwd) 
                  (if 
                    (setq app (vlax-get-acad-object)
                          shl (vla-getinterfaceobject app "shell.application")
                          hwd (vl-catch-all-apply 'vla-get-hwnd (list app))
                          fld (vlax-invoke-method shl 
                                                  'browseforfolder
                                                  (if (vl-catch-all-error-p hwd) 
                                                    0
                                                    hwd
                                                  )
                                                  msg
                                                  bit
                                                  dir
                              )
                    )
                    (setq slf (vlax-get-property fld 'self)
                          pth (vlax-get-property slf 'path)
                          pth (vl-string-right-trim "\\" 
                                                    (vl-string-translate "/" 
                                                                         "\\"
                                                                         pth
                                                    )
                              )
                    )
                  )
                )
              )
            )
  )
  (if slf (vlax-release-object slf))
  (if fld (vlax-release-object fld))
  (if shl (vlax-release-object shl))
  (if (vl-catch-all-error-p err) 
    (prompt (vl-catch-all-error-message err))
    pth
  )
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ 
  (strcat 
    "\nFolders_scheme.lsp | "
    (JTmenuVersion)
    " | Jakub Tomecko | "
    (menucmd "m=$(edtime,0,yyyy)")
  )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;