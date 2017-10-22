#NoTrayIcon

#Region AutoIt3Wrapper directives section
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=Y
#EndRegion AutoIt3Wrapper directives section

#Region Includes
#include <Core_IDMPwn.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#EndRegion Includes

_Singleton(@ScriptName)

#Region Options
Opt('MustDeclareVars', 1)
Opt('GUICloseOnESC', 1)
Opt('TrayMenuMode', 1)
#EndRegion Options

; Script Start - Add your code below here
If $CmdLine[0] = 0 Then
	GUI()
Else
	Switch $CmdLine[1]
		Case '/reset'
			Trial()

	    Case Else
			GUI()
	EndSwitch
EndIf

Func GUI()
	#Region ### START Koda GUI section ###

	Local $GUI = GUICreate('IDMPwn', 250,100)
    ;Local $tabMain = GUICtrlCreateTab(1, 0, 325, 112)
	Local $btReset = GUICtrlCreateButton('Reset IDM', 50,15, 150, 25)
	Local $lbl =  GUICtrlCreateLabel('This action will unregister IDM and reset its trial period. This will fix any errors and you''ll then be able to receive updates.', 10, 50, 240, 40)
	GUICtrlSetCursor(-1, 0)

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
				GUICtrlSetState ($btReset,$GUI_DISABLE)
				Trial()
				GUICtrlSetData($btReset, 'Reset IDM')
				GUICtrlSetState ($btReset,$GUI_ENABLE)

		EndSwitch
	WEnd
 EndFunc   ;==>GUI
