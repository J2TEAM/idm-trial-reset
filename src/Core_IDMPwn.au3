#RequireAdmin

#include <Date.au3>
#include <String.au3>

FileInstall('idm_reset.reg', @TempDir & '\idm_reset.reg', 1)
FileInstall('idm_trial.reg', @TempDir & '\idm_trial.reg', 1)
FileInstall('SetACLx32.exe', @TempDir & '\SetACLx32.exe', 1)
FileInstall('SetACLx64.exe', @TempDir & '\SetACLx64.exe', 1)

Global $setacl = (@OSArch = 'X86') ? '"' & @TempDir & "\SetACLx32.exe" & '"' : '"' & @TempDir & "\SetACLx64.exe" & '"'
Global Const $version = 21
Global $allkey[6]
$allkey[0] = '{6DDF00DB-1234-46EC-8356-27E7B2051192}'
$allkey[1] = '{7B8E9164-324D-4A2E-A46D-0165FB2000EC}'
$allkey[2] = '{D5B91409-A8CA-4973-9A0B-59F713D25671}'
$allkey[3] = '{5ED60779-4DE2-4E07-B862-974CA4FF2E9C}'
$allkey[4] = ''
$allkey[5] = '{07999AC3-058B-40BF-984F-69EB1E554CA7}'


Func SetOwner($owner)
	; $owner : everyone or nobody
	Switch $owner
		Case 'everyone'
			$owner = 'S-1-1-0'
		Case 'nobody'
			$owner = 'S-1-0-0'
	EndSwitch

	For $i = 0 To UBound($allkey) - 1 Step 1
		If $allkey[$i] <> '' Then
			RunWait($setacl & ' -on HKCU\Software\Classes\CLSID\' & $allkey[$i] & ' -ot reg -actn setowner -ownr "n:' & $owner & '" -silent', "", @SW_HIDE)
			RunWait($setacl & ' -on HKCU\Software\Classes\Wow6432Node\CLSID\' & $allkey[$i] & ' -ot reg -actn setowner -ownr "n:' & $owner & '" -silent', "", @SW_HIDE)
			RunWait($setacl & ' -on HKLM\Software\Classes\CLSID\' & $allkey[$i] & ' -ot reg -actn setowner -ownr "n:' & $owner & '" -silent', "", @SW_HIDE)
			RunWait($setacl & ' -on HKLM\Software\Classes\Wow6432Node\CLSID\' & $allkey[$i] & ' -ot reg -actn setowner -ownr "n:' & $owner & '" -silent', "", @SW_HIDE)
		EndIf
	Next
EndFunc   ;==>SetOwner


Func SetPermission($permission)
	; $permission : read or full
	For $i = 0 To UBound($allkey) - 1 Step 1
		If $allkey[$i] <> '' Then
			RunWait($setacl & ' -on HKCU\Software\Classes\CLSID\' & $allkey[$i] & ' -ot reg -actn ace -ace "n:everyone;p:' & $permission & '" -actn setprot -op "dacl:p_nc;sacl:p_nc" -silent', "", @SW_HIDE)
			RunWait($setacl & ' -on HKCU\Software\Classes\Wow6432Node\CLSID\' & $allkey[$i] & ' -ot reg -actn ace -ace "n:everyone;p:' & $permission & '" -actn setprot -op "dacl:p_nc;sacl:p_nc" -silent', "", @SW_HIDE)
			RunWait($setacl & ' -on HKLM\Software\Classes\CLSID\' & $allkey[$i] & ' -ot reg -actn ace -ace "n:everyone;p:' & $permission & '" -actn setprot -op "dacl:p_nc;sacl:p_nc" -silent', "", @SW_HIDE)
			RunWait($setacl & ' -on HKLM\Software\Classes\Wow6432Node\CLSID\' & $allkey[$i] & ' -ot reg -actn ace -ace "n:everyone;p:' & $permission & '" -actn setprot -op "dacl:p_nc;sacl:p_nc" -silent', "", @SW_HIDE)
		EndIf
	Next
EndFunc   ;==>SetPermission


Func Reset()
	ProcessClose("IDMan.exe")
	ProcessClose("IDMan.exe")
	ProcessClose("IDMan.exe")
	ProcessClose("IDMan.exe")
	ProcessClose("IDMan.exe")
	$allkey[4] = RegSearch('cDTvBFquXk0')
	SetOwner('everyone')
	SetPermission('full')
	; reset everything
	RunWait('reg import "' & @TempDir & "\idm_reset.reg" & '"', "", @SW_HIDE)
	If $allkey[4] <> '' Then
		RegDelete("HKEY_CURRENT_USER\Software\Classes\CLSID\" & $allkey[4])
		RegDelete("HKEY_CURRENT_USER\Software\Classes\Wow6432Node\CLSID\" & $allkey[4])
		RegDelete("HKEY_LOCAL_MACHINE\Software\Classes\CLSID\" & $allkey[4])
		RegDelete("HKEY_LOCAL_MACHINE\Software\Classes\Wow6432Node\CLSID\" & $allkey[4])
	EndIf
EndFunc   ;==>Reset


Func Trial()
	Reset()
	RunWait('reg import "' & @TempDir & "\idm_trial.reg" & '"', "", @SW_HIDE)
	SetPermission('read')
	SetOwner('nobody')
	clearTemp()
	MsgBox(262144, 'IDMPwn', 'Success!')
	;Local Const $sFilePath = "C:\Program Files (x86)\Internet Download Manager\IDMan.exe"
    ;Local $iFileExists = FileExists($sFilePath)
	;If $iFileExists Then
     ;   Run($sFilePath)
    ;EndIf
	;the above implementation spawns IDM in admin mode which causes interference from talking to browsers --admin mode browser interaction may not be supported
EndFunc   ;==>Trial


Func clearTemp()
	; Delete temp files
	FileDelete(@TempDir & "\idm_reset.reg")
	FileDelete(@TempDir & "\idm_trial.reg")
	FileDelete(@TempDir & "\idm_reg.reg")
	FileDelete(@TempDir & "\SetACLx32.exe")
	FileDelete(@TempDir & "\SetACLx64.exe")
	FileDelete(@TempDir & "\reg_query.tmp")
EndFunc   ;==>clearTemp

Func RegSearch($value = '')

	Local $key = ''
	Local $DOS = RunWait(@ComSpec & " /c reg query hkcr\clsid /s > " & @TempDir & "\reg_query.tmp", "", @SW_HIDE, 0x10000)
	Local $find = StringSplit(_getDOSOutput('findstr /N /I ' & $value & ' ' & @TempDir & "\reg_query.tmp"), ':')[1]
	$find = Number($find) - 1
	$find = _getDOSOutput('findstr /N . ' & @TempDir & "\reg_query.tmp" & ' | findstr /b ' & $find & ':')
	If StringInStr($find, "{") And StringInStr($find, "}") Then
		$key = "{" & _StringBetween($find, "{", "}")[0] & "}"
	EndIf
	Return $key

EndFunc   ;==>RegSearch

Func _getDOSOutput($command)
	Local $text = '', $Pid = Run('"' & @ComSpec & '" /c ' & $command, '', @SW_HIDE, 2 + 4)
	While 1
		$text &= StdoutRead($Pid, False, False)
		If @error Then ExitLoop
		Sleep(10)
	WEnd
	Return StringStripWS($text, 7)
EndFunc   ;==>_getDOSOutput
