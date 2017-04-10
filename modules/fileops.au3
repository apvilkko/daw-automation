#include <Array.au3>

Const $VSTPLUGINS_DIR = "c:\musicsw\vstplugins"

Func ReadVsts()
  Local $sFilePath = $VSTPLUGINS_DIR
  Local $sFilter = "*.dll"
  Local $sOutput = ""

  If Not StringInStr(FileGetAttrib($sFilePath), "D") Then
    Return SetError(1, 0, 0)
  EndIf

  $sFilePath = StringRegExpReplace($sFilePath, "[\\/]+\z", "") & "\"

  Local $iPID = Run(@ComSpec & ' /C DIR "' & $sFilePath & $sFilter & '" /B /S', $sFilePath, @SW_HIDE, $STDOUT_CHILD)

  While 1
    $sOutput &= StdoutRead($iPID)
    If @error Then
      ExitLoop
    EndIf
  WEnd

  StdioClose($iPID)

  Local $aArray = StringSplit(StringTrimRight(StringStripCR($sOutput), StringLen(@CRLF)), @CRLF)
  _ArrayTrim($aArray, StringLen($VSTPLUGINS_DIR) + 1)
  _ArrayTrim($aArray, 4, 1) ; trim extension
  _ArraySort($aArray)

  Local $sTmp = ''
  Local $sFolders = ''
  Local $sCurrentFolder = ''
  Local $sParent = ''
  For $i = 0 to Ubound($aArray)-1
    If Not StringRegExp($aArray[$i], "(x64|VST64|DXi)") And StringLen($aArray[$i]) > 3 Then
      Local $aMatch = StringRegExp($aArray[$i], "(.*)\\(.*)", 1)
      If @error Then
        $sTmp &= $aArray[$i] & Chr(0)
      Else
        Local $aParentMatch = StringRegExp($aMatch[0], "(.*)\\", 1)
        If @error Then
          $sParent = $aMatch[0]
        Else
          If $sParent <> $aParentMatch[0] Then
            $sFolders &= "+"&$aParentMatch[0] & Chr(0)
            $sParent = $aParentMatch[0]
          EndIf
        EndIf
        If $sCurrentFolder <> $aMatch[0] Then $sFolders &= "+"&$aMatch[0] & Chr(0)
        $sCurrentFolder = $aMatch[0]
        $sFolders &= $aMatch[1] & Chr(0)
      EndIf
    EndIf
  Next
  $aArray = StringSplit(StringTrimRight($sFolders & $sTmp, 1), Chr(0))

  _ArrayDelete($aArray, 0)
  Return $aArray
EndFunc
