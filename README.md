# DPmenu
DPmenu 0.10 pre AutoCAD

## Úvodne informácie
DPmenu je nadstavba pre AutoCAD, ktorú som vytvoril pre uľahčenie práce s našími štandartními značkami vo výkresoch. Nadstavba je určená pre AutoCAD 2013 a novšie. Aktuálna verzia bola testovaná v AutoCADe 2022.

## Inštalácia DPmenu
1. Skopírujte obsah archívu do ľúbovoľnej zložky na vašom počítači, napr.: `C:\DPmenu`
2. Spustite AutoCAD a otvorte okno nastavenie **Options**
3. Na záložke ***Files*** označte a rozbaľte položku ***Support File Search Path***
4. Kliknite na tlačidlo ***Add...***
5. Pomocou tlačidla ***Browse...*** definujte cesku k zložke DPmenu a podzložkám... (akým?)
6. Po definovaný ciest všetkých podzložiek, zatvoríme okno ***Option*** a nahrajeme menu súbor *DPmenu.cuix* (nachádza sa v zložke DPmenu).
7. Zadajte príkaz `_MENULOAD`, ktorým otvoríme okno ***Load/Unload Customizations***. Tlačidlom ***Browse...*** vyberieme menu súbor *DPmenu.cuix* a načítame ho tlačidlom ***Load***.
8. Pri načítanu súboru sa môže zobraziť upornenie (názov upozorneie?), ktoré potvrdíme výberom možnosti (výber možnosti)
9. Týmto postupom by mala byť inštalácia dokončená.

## Aktualizácia alebo odinštalácia DPmenu
Pri novej aktualizácii verzii DPmenu, je potrebné najpev odnačítať menu cez okno ***Load/Unload Customization*** (príkaz `_MENULOAD`), kde oznnačíme DPMENU a stalčíte tlačidlo ***Unload***. Potom odstránťe pôvodnú verzii DPmenu z disku a nahrade ju novou verziou. Nakoniec odoberte menu cez (Upravy uživatelskeho rozhrania - ang?) (príkaz `_CUI`). Teraz môžete novú verziu nainštalujete podľa už popísaného postupu.