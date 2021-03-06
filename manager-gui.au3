#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include "utils/console.au3"

Opt("GUIOnEventMode", 1) ; Change to OnEvent mode
Global $hConsole = 0

_Main()

Func _RunAU3($sFilePath, $sWorkingDir = "", $iShowFlag = @SW_SHOW, $iOptFlag = 0)
  Return Run('"' & @AutoItExe & '" /AutoIt3ExecuteScript "' & $sFilePath & '"', $sWorkingDir, $iShowFlag, $iOptFlag)
EndFunc

Func Run1()
  _RunAU3(@ScriptDir&"/scripts/script1.au3")
EndFunc

Func RestartScript()
  If @Compiled = 1 Then
    Run(FileGetShortName(@ScriptFullPath))
  Else
    Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
  EndIf
  Close()
EndFunc

Func Close()
  DllCall("kernel32.dll","bool","FreeConsole")
  Exit
EndFunc

Func _Main()
  Local $idYes, $idNo, $idExit, $iMsg, $time1 = ""
  $time1 = fileGetTime(@ScriptFullPath, 0, 1)

  $hConsole = CreateConsole()
  _Log("hello!")

  Local $hGUI = GUICreate("DAW Automation Manager", 170, 180)

  ;GUICtrlCreateLabel("Please click a button!", 10, 10)
  Local $y = 20
  $idRestart = GUICtrlCreateButton("Restart", 10, $y, 60, 20)
  $y += 25
  $idScript1 = GUICtrlCreateButton("House beat", 10, $y, 60, 20)
  $y += 40
  $idExit = GUICtrlCreateButton("Exit", 10, $y, 60, 20)

  GUICtrlSetOnEvent($idRestart, "RestartScript")
  GUICtrlSetOnEvent($idScript1, "Run1")
  GUICtrlSetOnEvent($GUI_EVENT_CLOSE, "Close")
  GUICtrlSetOnEvent($idExit, "Close")
  GUISetState(@SW_SHOW, $hGUI) ; display the GUI

  While 1
    $time0 = $time1
  	$time1 = fileGetTime(@ScriptFullPath, 0, 1)
  	if ($time1 <> "") and ($time0 <> $time1) then
  		RestartScript()
  	endif
    Sleep(500)
  WEnd
EndFunc   ;==>_Main
