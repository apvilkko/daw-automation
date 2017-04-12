Global Const $sPatchesDir = "D:\Audio\patches\"

Func _GetWindow($sTitle = "Live 8")
  WinWait($sTitle, "", 10)
  Local $hWnd = WinGetHandle($sTitle)
  If Not $hWnd Then
    _Log("No "&$sTitle&" found!")
    Return
  EndIf
  WinActivate($hWnd)
  Local $aInfo = WinGetPos($sTitle)
  ReDim $aInfo[5]
  $aInfo[4] = $hWnd
  ; Window coords & size are offset by 8?
  $aInfo[0] += 8
  $aInfo[1] += 8
  $aInfo[2] -= 16
  $aInfo[3] -= 16
  Return $aInfo
EndFunc

Func EnterPatch($sName)
  Send($sPatchesDir&$sName&"{ENTER}")
EndFunc

Func _Click($nX, $nY, $nTimes = 1, $aWindow = Null)
  Local $aOffset = [0, 0]
  If $aWindow <> Null Then
    $aOffset[0] = $aWindow[0]
    $aOffset[1] = $aWindow[1]
  EndIf
  Local $x = $aOffset[0] + $nX, $y = $aOffset[1] + $nY
  _Log("_Click " & $x & " " & $y & " " & $nTimes)
  MouseClick($MOUSE_CLICK_PRIMARY, $x, $y, $nTimes, 1)
EndFunc

Func _Drag($nX0, $nY0, $nX1, $nY1)
  _Log("_Drag " & $nX0 & " " & $nY0 & " -> " & $nX1 & " " & $nY1)
  MouseClickDrag($MOUSE_CLICK_PRIMARY, $nX0, $nY0, $nX1, $nY1, 1)
EndFunc

Func _PluginTitle($nTrack, $sWindowTitle)
  Return "/" & $nTrack & "-" & $sWindowTitle
EndFunc
