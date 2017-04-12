#include <Array.au3>
#include "fileops.au3"
#include "utils.au3"

Opt("WinTitleMatchMode", 2)

Const $MASTER_ROW_1_OFFSET_X_RIGHT = 56
Const $MASTER_COL_Y = 250
Const $BOTTOM_CLEAR = 80
Const $MIDI_EDITOR_MIDDLE_Y_BOTTOM = 150
Const $SESSION_ROW_HEIGHT = 18
Const $VST_PANEL_DRAG_X = 100

; These change according to Live 8 theme, this is LightBrown
Const $COLOR_ACTIVE = 0xEDFF00
Const $COLOR_MIDI_EDITOR_GUTTER = 0xD3CBB8
Const $COLOR_BORDER_DIVIDER = 0x918561
Const $COLOR_ACTIVE_BUTTON = 0xF5F900

Const $PLUGIN_TITLE_Y_BOTTOM = 216
Const $PLUGIN_TITLE_FIRST_X = 100

Const $PLUGIN_CLASS = "AbletonVstPlugClass"

Const $aStopButton = [655, 60]

Global $asVsts = ReadVsts()
Global $nTitleRowY = 0

Func GetTitleRowY($bForce = False)
  _Log("-> GetTitleRowY")
  If $nTitleRowY <> 0 And Not $bForce Then
    _Log("<- GetTitleRowY (cached) "& $nTitleRowY)
    Return $nTitleRowY
  EndIf
  Local $aWindow = _GetWindow()
  Local $nWidth = $aWindow[2], $nHeight = $aWindow[3], $hWnd = $aWindow[4]
  ActivateMaster()
  Local $nX = $nWidth - $MASTER_ROW_1_OFFSET_X_RIGHT
  Local $aCoord = PixelSearch($nX, $MASTER_COL_Y, $nX + 1, 75, $COLOR_ACTIVE)
  If Not @error Then
    $aCoord[1] -= 10
    _Log("<- GetTitleRowY "& $aCoord[1])
    $nTitleRowY = $aCoord[1]
    Return $aCoord[1]
  Else
    _Log("GetTitleRowY: could not find "&$nX)
  EndIf
EndFunc

; Creates a new midi track at the end and returns its track number
Func CreateMidiTrack()
  _Log("CreateMidiTrack")
  Local $aWindow = _GetWindow()
  Local $nWidth = $aWindow[2], $nHeight = $aWindow[3], $hWnd = $aWindow[4]
  Local $nX = $nWidth - $MASTER_ROW_1_OFFSET_X_RIGHT;
  Local $nTrackCount = 0
  ActivateLastTrack()
  Send("^+t")
  Local $nY = GetTitleRowY(True) + $SESSION_ROW_HEIGHT
  ActivateLastTrack()
  Send("{UP}{LEFT 40}{DOWN}")
  Do
    GoRight(1)
    $nTrackCount += 1
  Until PixelGetColor($nX, $nY) == $COLOR_ACTIVE Or $nTrackCount == 100
  If $nTrackCount == 100 Then
    _Log("CreateMidiTrack could not find active master "&$nX&" "&$nY)
    SetError(1)
  EndIf
  Return $nTrackCount
EndFunc

Func ActivateMaster()
  _Log("ActivateMaster")
  Local $aWindow = _GetWindow()
  Local $nWidth = $aWindow[2], $nHeight = $aWindow[3], $hWnd = $aWindow[4]
  Local $nY = $MASTER_COL_Y
  _Click($nWidth - $MASTER_ROW_1_OFFSET_X_RIGHT, $nY)
  Send("{UP 20}")
EndFunc

Func ActivateFirstMasterRow()
  _Log("ActivateFirstMasterRow")
  ActivateMaster()
  Send("{DOWN}")
EndFunc

Func ActivateLastTrack()
  _Log("ActivateLastTrack")
  ActivateFirstMasterRow()
  Send("{LEFT}")
EndFunc

Func ActivateTrack($nTrack)
  _Log("ActivateTrack "&$nTrack)
  ActivateMaster()
  Send("{LEFT 40}")
  GoRight($nTrack - 1)
EndFunc

Func CreateMidiPattern($nTrack, $nClip = 1)
  _Log("CreateMidiPattern "&$nTrack&" "&$nClip)
  Local $aWindow = _GetWindow()
  Local $nWidth = $aWindow[2], $nHeight = $aWindow[3], $hWnd = $aWindow[4]
  Local $aCoord = GetTrackPosition($nTrack)
  If Not @error Then
    Local $nTrackX = $aCoord[0]
    Local $nTrackY = $aCoord[1]
    Send("{DOWN "& $nClip &"}")
    $aCoord = PixelSearch($nTrackX, $nTrackY, $nTrackX + 1, $nHeight - 120, $COLOR_ACTIVE)
    If Not @error Then
      _Click($nTrackX, $aCoord[1] + 5, 2)
    Else
      _Log("CreateMidiPattern: could note find active clip "&$nTrackX&" "&$nTrackY)
    EndIf
  Else
    _Log("CreateMidiPattern: could not find track x coord")
  EndIf
  Sleep(20)
EndFunc

Func EnterNote($aDims, $x, $y)
  Local $nX = Floor($aDims[0] + ($x * ($aDims[1] - $aDims[0]) / 15))
  Local $nY = Floor($aDims[2] + ($y * ($aDims[3] - $aDims[2]) / 12))
  _Click($nX, $nY, 2)
EndFunc

Func EnterPattern($aPattern, $nShift = -24)
  _Log("EnterPattern "&$nShift)
  Local $aWindow = _GetWindow()
  Local $nWidth = $aWindow[2], $nHeight = $aWindow[3], $hWnd = $aWindow[4]
  Local $nOffset = $nHeight - $MIDI_EDITOR_MIDDLE_Y_BOTTOM
  Local $aCoord = PixelSearch(Floor($nWidth / 2), $nOffset, 0, $nOffset + 1, $COLOR_MIDI_EDITOR_GUTTER)
  If Not @error Then
    Local $nX0 = $aCoord[0] + 60, $nXLast = $nWidth - 50
    _Log("  x0 "&$nX0&" xLast "&$nXLast&" "&$nOffset)
    Local $aCoord2 = PixelSearch($nX0, $nOffset, $nX0 + 1, $nHeight, $COLOR_BORDER_DIVIDER)
    If Not @error Then
      Local $nY0 = $aCoord2[1] - 5
      Local $aCoord3 = PixelSearch($nX0, $nOffset, $nX0 + 1, $nHeight / 2, $COLOR_BORDER_DIVIDER)
      If Not @error Then
        Local $nYLast = $aCoord3[1] + 5
        _Log("  y0 "&$nY0&" yLast "&$nYLast)
        Local $aDims[] = [$nX0, $nXLast, $nY0, $nYLast, $nWidth, $nHeight]
        For $i = 0 To UBound($aPattern) - 1
          If $aPattern[$i][0] > 0 Then EnterNote($aDims, $i, $aPattern[$i][1])
        Next
      EndIf
    EndIf
  EndIf
  If $nShift < 0 Then Send("^a{DOWN "&Abs($nShift)&"}")
  If $nShift > 0 Then Send("^a{UP "&$nShift&"}")
EndFunc

Func OpenVstPanel()
  _Log("OpenVstPanel")
  _Click(18, 140)
EndFunc

Func ActivateSidePanel()
  _Log("ActivateSidePanel")
  _Click(200, 200)
EndFunc

Func GetTrackPosition($nTrack)
  _Log("-> GetTrackPosition "&$nTrack)
  Local $aWindow = _GetWindow()
  Local $nWidth = $aWindow[2], $nHeight = $aWindow[3], $hWnd = $aWindow[4]
  Local $nY = GetTitleRowY()
  ActivateTrack($nTrack)
  Local $aCoord = PixelSearch($nWidth, $nY, 0, $nY + 1, $COLOR_ACTIVE)
  If Not @error Then
    $aCoord[0] -= 10
    _Log("<- GetTrackPosition "&$aCoord[0]&" "&$aCoord[1])
    Return $aCoord
  Else
    _Log("Could not GetTrackPosition "&$nTrack&" "&$nY)
  EndIf
EndFunc

Func AddVstToTrack($sName, $nTrack)
  _Log("AddVstToTrack "&$sName&" "&$nTrack)
  Local $aWindow = _GetWindow()
  Local $nWidth = $aWindow[2], $nHeight = $aWindow[3], $hWnd = $aWindow[4]
  OpenVstPanel()
  Local $aPos = GetTrackPosition($nTrack)
  ActivateSidePanel()
  Send("{PGUP 20}")
  For $i = 0 To UBound($asVsts) - 1
    if $sName == $asVsts[$i] Then ExitLoop
    Send("{DOWN}")
  Next
  Local $aCoord = PixelSearch($VST_PANEL_DRAG_X, 100, $VST_PANEL_DRAG_X + 1, $nHeight, $COLOR_ACTIVE)
  If Not @error Then
    _Drag($VST_PANEL_DRAG_X, $aCoord[1] + 8, $aPos[0], $aPos[1])
  EndIf
  Local $sWindowClass = "[CLASS:"&$PLUGIN_CLASS&"]"
  WinWait($sWindowClass, "", 10)
  WinMove($sWindowClass, "", $nWidth/2, $nHeight/2)
EndFunc

Func GoRight($nCount)
  For $i = 1 to $nCount
    Send("{RIGHT}")
    Sleep(30)
  Next
EndFunc

Func GetPluginAt($nTrack, $nPlugin = 1)
  _Log("GetPluginAt "&$nTrack&" "&$nPlugin)
  Local $aWindow = _GetWindow()
  Local $nWidth = $aWindow[2], $nHeight = $aWindow[3], $hWnd = $aWindow[4]
  Local $aPos = GetTrackPosition($nTrack)
  _Click($aPos[0], $aPos[1], 2)
  Local $nY = $nHeight - $PLUGIN_TITLE_Y_BOTTOM
  _Click($PLUGIN_TITLE_FIRST_X, $nY)
  GoRight($nPlugin - 1)
  return PixelSearch(5, $nY, $nWidth - 5, $nY + 1, $COLOR_ACTIVE)
EndFunc

Func LoadPluginPreset($nTrack, $nPlugin, $sName)
  _Log("LoadPluginPreset "&$nTrack&" "&$nPlugin)
  Local $aCoord = GetPluginAt($nTrack, $nPlugin)
  If Not @error Then
    Local $nOpenX = $aCoord[0] + 15, $nOpenY = $aCoord[1] + 15
    _Click($nOpenX, $nOpenY)
    EnterPatch($sName)
  EndIf
EndFunc

Func OpenPlugin($nTrack, $nPlugin = 1, $bClose = false)
  _Log("OpenPlugin "&$nTrack&" "&$nPlugin)
  Local $aCoord = GetPluginAt($nTrack, $nPlugin)
  If Not @error Then
    Local $nOpenX = $aCoord[0] + 44, $nOpenY = $aCoord[1] - 7
    If PixelGetColor($nOpenX, $nOpenY) <> $COLOR_ACTIVE_BUTTON Then
      If Not $bClose Then _Click($nOpenX, $nOpenY)
    Else
      _Click($nOpenX, $nOpenY)
      If Not $bClose Then
        ; close and reopen brings plugin window to front
        Sleep(200)
        _Click($nOpenX, $nOpenY)
      EndIf
    EndIf
  EndIf
EndFunc

Func ClosePlugin($nTrack, $nPlugin = 1)
  _Log("ClosePlugin "&$nTrack&" "&$nPlugin)
  OpenPlugin($nTrack, $nPlugin, True)
EndFunc

Func PlayClip($nTrack, $nClip)
  _Log("PlayClip "&$nTrack&" "&$nClip)
  Local $aPos = GetTrackPosition($nTrack)
  _Click($aPos[0], $aPos[1])
  For $i = 0 to $nClip - 1
    Send("{DOWN}")
  Next
  Send("{ENTER}")
EndFunc

Func Stop()
  _Click($aStopButton[0], $aStopButton[1])
EndFunc
