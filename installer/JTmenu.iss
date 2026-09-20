; JTmenu.iss - Inno Setup skript pre GUI instalaciu JTmenu
;
; Vytvara instalatku (Setup Wizard) s dialogovymi oknami, ktora skopiruje
; JTmenu.bundle do %APPDATA%\Autodesk\ApplicationPlugins - teda len pre
; aktualneho pouzivatela, BEZ potreby administratorskych prav
; (PrivilegesRequired=lowest).
;
; Kompilacia (z korena repozitara):
;   "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" installer\JTmenu.iss
; Volitelne s vlastnou verziou:
;   ISCC.exe /DMyAppVersion=1.2.3 installer\JTmenu.iss
; Vystup: dist\JTmenu-Setup.exe

#define MyAppName "JTmenu"
#define MyAppPublisher "Jakub Tomecko"
#define MyAppURL "https://github.com/tomecjak/JTmenu"
#ifndef MyAppVersion
  #define MyAppVersion "0.0.0"
#endif

[Setup]
AppId={{2E7F6C8B-2D1A-4C7E-9C7A-3B8B7F1F5E20}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}/releases/tag/latest
DefaultDirName={userappdata}\Autodesk\ApplicationPlugins\JTmenu.bundle
DisableDirPage=yes
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=..\dist
OutputBaseFilename=JTmenu-Setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "slovak"; MessagesFile: "compiler:Languages\Slovak.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
WelcomeLabel2=Tento sprievodca nainstaluje {#MyAppName} (nadstavbu pre AutoCAD/Civil 3D) do vasho pouzivatelskeho profilu.%n%nNepotrebujete administratorske prava - AutoCAD pri dalsom spusteni JTmenu nacita automaticky.
FinishedLabel={#MyAppName} bol nainstalovany.%n%nSpustite (alebo restartujte) AutoCAD alebo Civil 3D - JTmenu sa nacita automaticky, nic dalsie netreba nastavovat.

[Files]
Source: "..\JTmenu.bundle\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion

[UninstallDelete]
Type: filesandordirs; Name: "{app}"
