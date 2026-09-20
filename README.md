# JTmenu v2.0
JTmenu pre AutoCAD/Civil 3D

## Úvodne informácie
*JTmenu* je nadstavba pre AutoCAD, ktorú som vytvoril pre uľahčenie a zrýchlenie kreslenia. *JTmenu* je mix naprogramovaných nástrojov a dynamických blokov. Veľka vďaka patrí autorovi [Lee Mac](http://www.lee-mac.com), ktorý ma obrovkú knižnicu predpripravených riešení. Odporúčam pre túto nadstavbu využívať šablónu **_JTmenu template_**, ale nie je to potrebné (v šablóne sú nastavené základne veci ako jednotky, štýly kótovania alebo layout v mierke 1:1). Verím že pre niekoho to bude podobne nápomocne ako pre mňa. 🙂

## Inštalácia

JTmenu je zabalené ako štandardný AutoCAD **Application Plugin bundle** (`JTmenu.bundle`). AutoCAD si po skopírovaní priečinka sám pridá všetky potrebné priečinky (ikony, bloky, funkcie...) do Support File Search Path a pri štarte automaticky načíta menu - nič sa nemusí ručne nastavovať v Options ani cez CUILOAD.

### Najjednoduchšie: stiahnuť hotový inštalátor

Po každom pushi do vetvy `JTmenu` GitHub Actions automaticky zostaví GUI inštalátor `JTmenu-Setup.exe` (cez Inno Setup) a nahrá ho do releasu **[latest](https://github.com/tomecjak/JTmenu/releases/tag/latest)** (workflow: `.github/workflows/package-release.yml`, skript: `installer/JTmenu.iss`) - je to teda vždy aktuálna verzia z posledného commitu.

1. Stiahnite `JTmenu-Setup.exe` z [najnovšieho releasu](https://github.com/tomecjak/JTmenu/releases/tag/latest).
2. Spustite ho (dvojklik) - zobrazí sa bežné okno sprievodcu inštaláciou (Welcome > Install > Finish). **Nepotrebuje admin práva** - cieľová cesta je pevne nastavená na `%APPDATA%\Autodesk\ApplicationPlugins\JTmenu.bundle` (inštaluje len pre aktuálne prihláseného používateľa).
3. Spustite (alebo reštartujte) AutoCAD/Civil 3D.

Odinštalovanie potom cez Windows "Aplikácie a súčasti" (Add/Remove Programs) - JTmenu sa tam zaregistruje ako bežný program (len pre tohto používateľa).

> Windows môže pri prvom spustení `.exe` súboru stiahnutého z internetu zobraziť SmartScreen upozornenie ("Windows protected your PC") - je to bežné pre nepodpísané inštalátory (chýba platený certifikát na podpisovanie kódu), netreba naň admin práva, stačí "More info" > "Run anyway".

### Manuálne (bez sťahovania inštalátora)

1. Skopírujte celý priečinok `JTmenu.bundle` (aj s `PackageContents.xml` a podpriečinkom `Contents`) do jedného z týchto priečinkov:
   - `%APPDATA%\Autodesk\ApplicationPlugins\` - inštalácia len pre aktuálneho používateľa, nepotrebuje admin práva.
   - `%ProgramData%\Autodesk\ApplicationPlugins\` - inštalácia pre všetkých používateľov na počítači, vyžaduje admin práva.

   (Cestu zadáte priamo do adresového riadku v Prieskumníkovi.)
2. Spustite (alebo reštartujte) AutoCAD/Civil 3D. JTmenu sa načíta automaticky - ak bol AutoCAD spustený počas kopírovania, načíta sa do pár sekúnd bez reštartu.
3. Aktualizácia = jednoducho nahradiť priečinok `JTmenu.bundle` novou verziou.

Priečinky `ApplicationPlugins` sú v AutoCADe automaticky dôveryhodné (SECURELOAD), takže netreba riešiť ani TRUSTEDPATHS.

### Nástrojové palety (tool palettes)

Nástrojové palety dopravného značenia (priečinok `resource/toolpallete`) sú momentálne uložené ako `.xtp`/`.xpg` - to je iba *export* formát, ktorý AutoCAD vie premeniť na skutočnú paletu len cez ručný Import (Customize Palettes > Import). Bundle síce nastaví `Tool Palette File Location` na tento priečinok (`ToolPalettePath` v `PackageContents.xml`), ale AutoCAD z neho pri štarte automaticky načíta iba **`.atc`** súbory (živý formát), nie `.xtp`/`.xpg`.

Aby sa palety naimportovali automaticky pre každého, kto si nainštaluje JTmenu.bundle, treba raz (pri tvorbe/aktualizácii palety) spraviť túto konverziu:
1. Naimportujte všetky `.xtp`/`.xpg` súbory ručne ako doteraz (Customize Palettes > Import).
2. Spustite príkaz `JTToolPaletteCollect` (zo `JTmenu.legacy\Setup.lsp`) - skopíruje výsledné `.atc` súbory z profilu do vami vybraného priečinka.
3. Skopírované `.atc` súbory dajte do `JTmenu.bundle/Contents/resource/toolpallete` a commitnite - odteraz sa tieto palety pri inštalácii/aktualizácii bundlu načítajú všetkým automaticky.

**Zoskupenie paliet (skupiny "Dopravné značenie" / "Jestvujúce dopravné značenie") sa takto automatizovať nedá vôbec** - AutoCAD ani Autoloader nemajú žiadny spôsob (ani cez network path, ani cez API), ako naimportovať `.xpg` skupinu alebo `.xtp` paletu bez ručného kliknutia (potvrdené priamo Autodeskom).

Namiesto jednorazovej hlášky pri štarte AutoCADu sa preto kontrola/ponuka spúšťa priamo pri zapnutí príslušného panelu - príkazmi `JTTrafficSigns` (skupina "Dopravné značenie") a `JTTrafficSignsExisting` (skupina "Jestujúce dopravné značenie"). Pred otvorením panelu sa najprv skúsi zistiť, či už boli palety naimportované - `JT:ToolPaletteEvidence` (v `JTmenu_lib.lsp`) prehľadá `.atc` súbory v priečinkoch "Tool Palette File Location" a hľadá v nich mená paliet/skupiny. **Toto je len heuristika (textový match), nie oficiálne API overenie** - AutoCAD nič také neponúka - takže sa môže výnimočne pomýliť (napr. ak sa meno objaví v inom kontexte). Ak sa nič nenájde, otvorí sa priečinok s `.xtp`/`.xpg` súbormi a zobrazí návod (import buď celej `.xpg` skupiny naraz, alebo jednotlivých `.xtp` paliet). Znova to spustíte príkazom `JTToolPaletteImportInfo`.

### Alternatívny (ručný) spôsob

Ak z nejakého dôvodu nemôžete kopírovať do `ApplicationPlugins` (napr. firemná politika), dá sa JTmenu.bundle použiť aj postaru pomocou skriptov v `JTmenu.legacy`:
1. Otvorte AutoCAD a pretiahnite `JTmenu.legacy\Setup.lsp` do výkresu (alebo `(load "<cesta>\\JTmenu.legacy\\Setup.lsp")`).
2. Zadajte príkaz `JTMenuSetup` a vyberte priečinok `JTmenu.bundle`.
3. Skript sám pridá potrebné cesty (ACAD support path, trusted paths, Tool Palette path) a načíta CUIX.

## Krátky popis jednotlivých funkcií
- Vloženie jednotlivých značiek - *pohľady, smery, sklon, detail, symetria, rezy a podobne*
- Premenovanie blokov - *rýchle premenovanie blokov*
- Block basepoint - *rýchla upráva základného bodu bloku*
- Poznámka - *vloženie bloku pre poznámky, legendy a podobne*
- Rozpiska - *vloženie bloku rozpiska*
- Rozpiska update - *aktualizácia údajov v rozpiske a jej editácia*
- Tabuľka materiálov - *vloženie bloku tabuľky materiálov*
- Materiály update - *aktualizácia údajov v tabuľke materiálov*
- Tabuľka ohybov - *vloženie tabuľky ohybov*
- Krížik výkresu - *vloženie bloku z krížikmi podľa veľkosti layoutu*
- Viewport hranica - *vytvorenie hranice do modelu podľa vybraného viewportu*
- Výstuž/spona - *vloženie bloku výstuže/spony*
- Označenie výstuže - *vloženie bloku pre označenie výstuže/kari sieti*
- Popisok výstuže - *vloženie bloku pre popis výstuže/kari sieti*
- Schéma výstuže - *prepínanie farebnosti hladín výstuže vytvorenej pomocou JTmenu*
- Presah a kotvenie - *jednoduchá kalkulačka pre výpočet dĺžky kotvenia alebo presahu výstuže*
- Severka - *vloženie bloku severky, ktorá sa zarovná podľa WORLD UCS*
- ReNumber - *nástroj pre automatické číslovanie v texte či v blokoch*
- Polyline export - *exportovanie bodov z polyliny rovno do csv súboru*
- Značka bodu - *symbol pre označenie vytyčováneho bodu (možno použiť v kombinácii z nástrojom ReNumber)*
- Výška bodu - *symbol pre výšky bodov*
- Tabuľka výšok - *symbol pre označenie pôdorysnej výšky*
- Coordinates - *vloženie symbolu krížika z hodnotami UCS*
- Symbol ložiska
- Hektometrická sieť - *vloženie bloku pre vytvorenie hektometrickej siete*
- Geodetická značka - *vloženie blokov geodetických značiek*
- Dopravné značenie - *knižnica zvislého dopravného značenie od 100 až po 500 podľa VL 6.1*
- Jestvujúce dopravné značenie
- Zrušenie dopravného značenia - *vloží krížik na dopravnú značku*
- Mierka dopravného značenia - *nastavenie mierky pre vkladanie dopravného značenia*
- Mapy - *presmerovanie na mapy (Google maps, Mapy.cz a mapy ZBGIS)*
- Cestná databanka
- Kataster
- Dvojity offset
- Prerušenie objektu - *vytvorenie prerušovanej čiary podľa vybraných bodov alebo objektu*
- Staničenie - *nájdenie staničenia na krivky/polyline a možnosť ho zobraziť alebo zapísať do textu/bloku*
- Čiara v sklone - *vytvorenie čiary v sklone podľa dĺžky a zadných percent alebo pomeru sklonu*
- Data extraction
- Štruktúra dokumentácia - *vytvorenie štruktúru dokumentácie podľa TP alebo vlastnej šablóny*
- Filtrovanie podľa hladiny - *výber všetkých objektov podľa vybranej hladiny*
- Zoradenie podľa hladiny - *zoradenie objektov pod seba alebo nad seba podľa zoradenia jednotlivých hladín*
- Meranie uhlov - *meranie uhlov a vzdialenosti medzi dvomi zvolenými bodmi*
- Center measure
- Kolmica na krivku
- VL - *zapnutie si VL dokumentov ako PDF*
- TP - *presmerovanie na stránku z technickými predpismi*
- Slovenské/České technické predpisy - *presmerovanie na stránku ssc/pjpk*
- Hladiny - *vytvorenie hladín (klasické, výstuže, nový stav) - prefix je možné zmeniť v nastaveniach*
- Typy čiar - *načítanie čiar pre siete*
- Štýl textu - *vytvorenie štýlu textu ISOCPEUR*
- Štýl kót - *vytvorenie štýlu kót (vlastné/pevné) - možné ďalšie nastavenie v nastaveniach*
- Štýl leadru - *vytvorenie štýlu leadru*
- Preview mode - *zapínanie a vypínanie preview modu pre hatch, match properties a podobne (zrýchlenie pri dlhých polylinách, hatchoch a podobne...)*
- Nastavenie jednotiek - *nastavenie units na metre, 3 desatinné miesta a podobne*
- Zmazanie prefixu v názve hladín
- Help - *presmerovanie na stránku pomoci*
- Bugs report - *presmerovanie na formulár pre popis chyby*
- Nastavenia
