#include "../utils/console.au3"
#include "../modules/live-commands.au3"
#include "../modules/fileops.au3"

Global Const $sTitle = "Live 8"
Global $hConsole
Opt("WinTitleMatchMode", 2)

Script1()

Func Script1()
  $hConsole = AttachToParentConsole()
  $asVsts = ReadVsts()
  _Log("")
  For $sVst in $asVsts
    _Log($sVst)
  Next
  Local $hWnd = WinGetHandle($sTitle)
  If Not $hWnd Then
    _Log("No Live 8 found!")
    Return
  EndIf
  WinActivate($hWnd)
  CreateMidiTrack()
  ActivateFirstMasterRow($hWnd)
  Send("{LEFT}")
  CreateMidiPattern($hWnd)
  EnterPattern($hWnd)
  Sleep(2000)
EndFunc
