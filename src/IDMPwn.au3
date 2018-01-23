;MIT License
;
;Copyright (c) 2016 Juno_okyo
;
;Permission is hereby granted, free of charge, to any person obtaining a copy
;of this software and associated documentation files (the "Software"), to deal
;in the Software without restriction, including without limitation the rights
;to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;copies of the Software, and to permit persons to whom the Software is
;furnished to do so, subject to the following conditions:
;
;The above copyright notice and this permission notice shall be included in all
;copies or substantial portions of the Software.
;
;THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;SOFTWARE.

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
