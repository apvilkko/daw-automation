#include-once "utils.au3"

Const $sWindowTitle = "Battery 3"
Const $aFileMenu = [320, 37]
Const $aOpenKit = [320, 74]

Func _Battery3_OpenPreset($nTrack, $sName)
  Local $aWindow = _GetWindow(_PluginTitle($nTrack, $sWindowTitle))
  _Click($aFileMenu[0], $aFileMenu[1], 1, $aWindow)
  _Click($aOpenKit[0], $aOpenKit[1], 1, $aWindow)
  Send("{ENTER}") ; overwrite warning
  EnterPatch($sName)
  Sleep(200)
EndFunc
