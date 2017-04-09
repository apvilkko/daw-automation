#include <WinAPI.au3>

Global Const $STD_INPUT_HANDLE = -10
Global Const $STD_OUTPUT_HANDLE = -11
Global Const $STD_ERROR_HANDLE = -12

Func CreateConsole()
  DllCall("kernel32.dll", "bool", "AllocConsole")
  $aRet = DllCall("kernel32.dll","handle","GetStdHandle","int", $STD_OUTPUT_HANDLE)
  If Not @error Then Return $aRet[0]
EndFunc

Func AttachToParentConsole()
  Local $pConsole = _CmdGetConsoleProcess()
  Return _CmdAttachConsole($pConsole)
EndFunc

Func _CmdGetConsoleProcess()
  Local $WinList, $i
  Local $pCurrent = _WinApi_GetCurrentProcess()
  $WinList = WinList()
  For $i = 1 to $WinList[0][0]
    Local $pProcess = WinGetProcess($WinList[$i][1])
    Local $sClassName = _WinAPI_GetClassName($WinList[$i][1])
    If $pProcess <> $pCurrent And $sClassName == "ConsoleWindowClass" Then
      Return $pProcess
    EndIf
  Next
EndFunc

Func _CmdAttachConsole($pCmd)
    Local $aRet = DllCall("kernel32.dll", "int", "AttachConsole", "dword", $pCmd)
    If @error Then Return SetError(@error, @extended, False)
    Return _CmdGetStdHandle($STD_OUTPUT_HANDLE)
EndFunc

Func _CmdGetStdHandle($nHandle)
  Local $aRet = DllCall("kernel32.dll", "hwnd", "GetStdHandle", "dword", $nHandle)
  If Not @error Then Return $aRet[0]
EndFunc

Func _Log($sMsg, $hHandle = $hConsole)
  Local $sMessage = $sMsg&@CRLF
  DllCall("kernel32.dll","bool","WriteConsoleW","handle",$hHandle,"wstr",$sMessage,"dword",StringLen($sMessage),"dword*",0,"ptr",0)
EndFunc
