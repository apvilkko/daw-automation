#include "console.au3"
#include "live-commands.au3"

Global Const $sTitle = "Live 8"
Opt("WinTitleMatchMode", 2)

Script1()

Func Script1()
  $hConsole = AttachToParentConsole()
  Local $hWnd = WinGetHandle($sTitle)
  WinActivate($hWnd)
  CreateMidiTrack()
  ActivateFirstMasterRow($hWnd)
  Send("{LEFT}")
  CreateMidiPattern($hWnd)
  EnterPattern($hWnd)
  Sleep(2000)
EndFunc
