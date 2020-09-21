#NoTrayIcon

#Region AutoIt3Wrapper directives section
#AutoIt3Wrapper_Icon=IDM.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=Y
#EndRegion AutoIt3Wrapper directives section

#Region Includes
#include <core.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#EndRegion Includes

_Singleton(@ScriptName)

#Region Options
Opt('MustDeclareVars', 1)
Opt('GUICloseOnESC', 0)
Opt('TrayMenuMode', 1)
#EndRegion Options

; Script Start - Add your code below here
If $CmdLine[0] = 0 Then
	GUI()
Else
	Switch $CmdLine[1]
		Case '/trial'
			TrialSilent()
			clearTemp()
		Case Else
			GUI()
	EndSwitch
EndIf

Func GUI()
	#Region ### START Koda GUI section ###
	Local $GUI = GUICreate('IDM trial reset', 325, 112)
	Local $tabMain = GUICtrlCreateTab(1, 0, 325, 112)
	Local $tabTrialReset = GUICtrlCreateTabItem('Trial reset')
	Local $btReset = GUICtrlCreateButton('Reset the IDM trial now', 78, 40, 180, 35)
	GUICtrlSetCursor(-1, 0)
	Local $cbAutorun = GUICtrlCreateCheckbox('Automatically', 128, 80, 80, 20)
	Local $tabRegister = GUICtrlCreateTabItem('Register')
	Local $btReg = GUICtrlCreateButton('Register IDM now', 78, 40, 180, 35)
	GUICtrlSetCursor(-1, 0)
	Local $lbReg = GUICtrlCreateLabel('If IDM is blocked after Register then Register again or use Trial reset', 27, 80, 282, 17)
	Local $tabHelp = GUICtrlCreateTabItem('Help')
	GUICtrlSetState(-1, $GUI_SHOW)
	Local $lbHelp = GUICtrlCreateLabel('', 15, 35, 308, 50)
	GUICtrlSetData(-1, StringFormat('Trial reset ---> Reset the IDM trial, fix blocked, fake serial...\r\nRegister -----> Register IDM'))
	Local $btForum = GUICtrlCreateButton('Chat about this tool', 45, 73, 115, 25)
	GUICtrlSetCursor(-1, 0)
	Local $btUpdate = GUICtrlCreateButton('Check for update', 166, 73, 105, 25)
	GUICtrlSetCursor(-1, 0)
	GUICtrlCreateTabItem('')
	GUICtrlSetState($cbAutorun, $isAuto ? 1 : 4)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		Local $nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				clearTemp()
				GUIDelete($GUI)
				Exit
			Case $btReset
				GUICtrlSetData($btReset, 'Please wait...')
				Trial()
				GUICtrlSetData($btReset, 'Reset the IDM trial now')
				MsgBox(262144, 'Reset IDM trial', 'You have 30 day trial now!')
			Case $cbAutorun
				If GUICtrlRead($cbAutorun) = 1 Then
					GUICtrlSetData($btReset, 'Please wait...')
					Trial()
					autorun('trial')
					GUICtrlSetData($btReset, 'Reset the IDM trial now')
					MsgBox(262144, 'Auto reset', 'The IDM trial will be reset automatically.')
				Else
					autorun('off')
					MsgBox(262144, 'Auto reset', 'The IDM trial will NOT be reset automatically.')
				EndIf
			Case $btReg
				Local $Name = InputBox('Register IDM', 'Type your name here: ', 'IDM trial reset', '', '', '130')
				If @error <> 1 Then
					If StringLen($Name) = 0 Then $Name = 'IDM trial reset'
					GUICtrlSetData($btReg, 'Please wait...')
					Register($Name)
					GUICtrlSetState($cbAutorun, 4)
					GUICtrlSetData($btReg, 'Register IDM now')
					MsgBox(262144, 'Register IDM', 'IDM is registered now!')
				EndIf
			Case $btForum
				ShellExecute($urlForum)
			Case $btUpdate
				GUICtrlSetData($btUpdate, 'Please wait...')
				If GotUpdate() Then
					Local $Download = (MsgBox(1, 'IDM trial reset', 'Update me now?') == 1)
					If $Download Then ShellExecute($urlDownload)
				Else
					MsgBox(262144, 'IDM trial reset', 'No update was found!')
				EndIf
				GUICtrlSetData($btUpdate, 'Check for update')
		EndSwitch
	WEnd
EndFunc   ;==>GUI
