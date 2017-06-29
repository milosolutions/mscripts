!include MUI2.nsh

!ifndef PROJECT_NAME
    abort
!endif

; access level
RequestExecutionLevel admin

Name "${PROJECT_NAME}"
InstallDir "$PROGRAMFILES\${PROJECT_NAME}"

var StartMenuDir
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\${PROJECT_NAME}" 
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "StartMenuDir"

# setup your installation icon
#!define MUI_ICON "MainIcon.ico"
!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_WELCOME
!ifdef LICENSE_FILE
    !insertmacro MUI_PAGE_LICENSE $LICENSE_FILE
!endif
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU startmenu_page $StartMenuDir
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

Section "Install"
    SetOutPath "$INSTDIR"
    SetShellVarContext all
    
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    File /r /x *.lib ${DIR}\*.*
    
    !insertmacro MUI_STARTMENU_WRITE_BEGIN startmenu_page
        CreateDirectory "$SMPROGRAMS\$StartMenuDir"
        CreateShortcut "$SMPROGRAMS\$StartMenuDir\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
    !insertmacro MUI_STARTMENU_WRITE_END


SectionEnd

Section "Uninstall"
    SetShellVarContext all

    !insertmacro MUI_STARTMENU_GETFOLDER startmenu_page $StartMenuDir

    RMDir /r /REBOOTOK "$INSTDIR"
    
    Delete "$SMPROGRAMS\$StartMenuDir\Uninstall.lnk"
    RMDir "$SMPROGRAMS\$StartMenuDir"

    DeleteRegKey HKCU "Software\${PROJECT_NAME}"
SectionEnd

