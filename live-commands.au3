Global Const $MASTER_ROW_1_OFFSET_X_RIGHT = 80
Global Const $COLOR_ACTIVE = 0xEDFF00
Global Const $COLOR_MIDI_EDITOR_GUTTER = 0xD3CBB8
Global Const $COLOR_MIDI_EDITOR_DIVIDER = 0x918561
Global Const $BOTTOM_CLEAR = 80
Global Const $MIDI_EDITOR_MIDDLE_Y_BOTTOM = 150

Func CreateMidiTrack()
  Send("^+t")
EndFunc

Func ActivateFirstMasterRow($hWnd)
  Local $aClientSize = WinGetClientSize($hWnd)
  Local $nWidth = $aClientSize[0], $nHeight = $aClientSize[1]
  MouseClick($MOUSE_CLICK_PRIMARY, $nWidth - $MASTER_ROW_1_OFFSET_X_RIGHT, Floor($nHeight / 3), 1, 1)
  Send("{UP 20}{DOWN}")
EndFunc

Func CreateMidiPattern($hWnd)
  Local $aClientSize = WinGetClientSize($hWnd)
  Local $nWidth = $aClientSize[0], $nHeight = $aClientSize[1]
  Local $aCoord = PixelSearch(35, 90, $nWidth - 120, Floor($nHeight / 3), $COLOR_ACTIVE)
  If Not @error Then
    MouseClick($MOUSE_CLICK_PRIMARY, $aCoord[0] + 30, $aCoord[1] + 5, 2, 1)
  EndIf
EndFunc

Func EnterNote($aDims, $x, $y)
  Local $nX = Floor($aDims[0] + ($x * ($aDims[1] - $aDims[0]) / 15))
  Local $nY = Floor($aDims[2] + ($y * ($aDims[3] - $aDims[2]) / 12))
  MouseClick($MOUSE_CLICK_PRIMARY, $nX, $nY, 2, 1)
EndFunc

Func EnterPattern($hWnd)
  Local $aClientSize = WinGetClientSize($hWnd)
  Local $nWidth = $aClientSize[0], $nHeight = $aClientSize[1]
  Local $nOffset = $nHeight - $MIDI_EDITOR_MIDDLE_Y_BOTTOM
  Local $aCoord = PixelSearch(Floor($nWidth / 2), $nOffset, 0, $nOffset + 1, $COLOR_MIDI_EDITOR_GUTTER)
  If Not @error Then
    Local $nX0 = $aCoord[0] + 60, $nXLast = $nWidth - 50
    Local $aCoord2 = PixelSearch($nX0, $nOffset, $nX0 + 1, $nHeight, $COLOR_MIDI_EDITOR_DIVIDER)
    If Not @error Then
      Local $nY0 = $aCoord2[1] - 5
      Local $aCoord3 = PixelSearch($nX0, $nOffset, $nX0 + 1, $nHeight / 2, $COLOR_MIDI_EDITOR_DIVIDER)
      If Not @error Then
        Local $nYLast = $aCoord3[1] + 5;
        Local $aDims[] = [$nX0, $nXLast, $nY0, $nYLast, $nWidth, $nHeight]
        EnterNote($aDims, 0, 0)
        EnterNote($aDims, 4, 0)
        EnterNote($aDims, 8, 0)
        EnterNote($aDims, 12, 0)

        EnterNote($aDims, 2, 6)
        EnterNote($aDims, 6, 6)
        EnterNote($aDims, 10, 6)
        EnterNote($aDims, 14, 6)

        EnterNote($aDims, 4, 3)
        EnterNote($aDims, 12, 3)
      EndIf
    EndIf
  EndIf
  Send("^a{DOWN 24}")
EndFunc
