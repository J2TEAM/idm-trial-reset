RequestExecutionLevel none

!include "MUI.nsh"
!include "StrFunc.nsh"
!include "Registry.nsh"




!define PRODUCT_NAME "IDMPwn"
!define PRODUCT_VERSION "0.1"
!define PRODUCT_PUBLISHER "Cyfrost"
!define PRODUCT_WEB_SITE "https://cyfrost.github.io"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define MAIN_EXECUTABLE_FILENAME "IDMPwn.exe"




; Replace the constants bellow to hit suite your project
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"

OutFile "setup_${PRODUCT_NAME}-${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
BrandingText "Cyfrost"
ShowInstDetails show
ShowUnInstDetails show




!define MUI_ABORTWARNING
!define "MUI_ICON" "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define "MUI_UNICON" "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"
!define "MUI_HEADERIMAGE_RIGHT"
!define "MUI_HEADERIMAGE_BITMAP" "${NSISDIR}\Contrib\Graphics\Header\orange-r.bmp"
!define "MUI_HEADERIMAGE_UNBITMAP" "${NSISDIR}\Contrib\Graphics\Header\orange-uninstall-r.bmp"
!define "MUI_WELCOMEFINISHPAGE_BITMAP" "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"
!define "MUI_UNWELCOMEFINISHPAGE_BITMAP" "${NSISDIR}\Contrib\Graphics\Wizard\orange-uninstall.bmp"

!define MUI_FINISHPAGE_SHOWREADME ""
!define MUI_FINISHPAGE_SHOWREADME_CHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Create desktop shortcut"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION createshortcut
!define MUI_FINISHPAGE_RUN "$INSTDIR\${MAIN_EXECUTABLE_FILENAME}"
!define MUI_LICENSEPAGE_BUTTON "I Agree"
!define MUI_WELCOMEPAGE_TITLE_3LINES

; Wizard pages

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "res\LICENSE.txt"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Section "MainSection" SEC01

  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  
  ;add installation resources here
  File res\IDMPwn.exe
  File res\LICENSE.txt
  
SetShellVarContext current
CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${MAIN_EXECUTABLE_FILENAME}"
CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall ${PRODUCT_NAME}.lnk" "$INSTDIR\uninst.exe"
  
SectionEnd


;tentative section
Function createshortcut

SetShellVarContext current
CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${MAIN_EXECUTABLE_FILENAME}" ""


FunctionEnd




Section -Post
 
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${MAIN_EXECUTABLE_FILENAME}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  
 SectionEnd

 
Function .onInit
  ;display a language selection dialog 
 ; !insertmacro MUI_LANGDLL_DISPLAY
StrCpy $INSTDIR "$PROGRAMFILES64\${PRODUCT_NAME}"
Call CheckIfPreviouslyInstalled
FunctionEnd

Function CheckIfPreviouslyInstalled

ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString"
StrCmp $R0 "" NoPrevInstallation

MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION "Installer has detected a previous installation of ${PRODUCT_NAME}.$\n$\nClick `OK` to remove the previous installation$\nor$\nClick `Cancel` to retain the previous installation and proceed with install." IDOK finishUninstalling
goto NoPrevInstallation
	
finishUninstalling:
ClearErrors
nsExec::Exec `$R0 /S _?=$INSTDIR`

NoPrevInstallation:
;good that we can bail immediately to installation
FunctionEnd


Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove ${PRODUCT_NAME} and all of its components?" IDYES +2
  Abort
FunctionEnd



Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "${PRODUCT_NAME} was successfully removed from your computer."
FunctionEnd



;tentative section
Section Uninstall
	
   
  ClearErrors
 
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
  
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall ${PRODUCT_NAME}.lnk"
  
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  
  
  
  Delete "$INSTDIR\IDMPwn.exe"
  Delete "$INSTDIR\LICENSE.txt"
  Delete "$INSTDIR\uninst.exe"
   
  RMDir "$INSTDIR"
  ;RMDir "$INSTDIR\.."
  
 

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
 
  SetAutoClose true
  
SectionEnd