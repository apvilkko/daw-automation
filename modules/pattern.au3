Func _Generic_Pattern($sType, $nMinPitch = 0, $nMaxPitch = 0)
  Local $aPattern[16][2]
  Local $nPitch = Random($nMinPitch, $nMaxPitch, 1)
  For $i = 0 To UBound($aPattern) - 1
    $aPattern[$i][1] = $nPitch
    If ($sType = "kick" And Mod($i, 4) = 0) Or _
      ($sType = "hihat" And Mod($i + 2, 4) = 0) Or _
      ($sType = "clap" And Mod($i + 4, 8) = 0) Then
      $aPattern[$i][0] = 127
    Else
      $aPattern[$i][0] = 0
    EndIf
  Next
  Return $aPattern
EndFunc

Func _Pattern_Kick($nMinPitch = 0, $nMaxPitch = 0)
  Return _Generic_Pattern("kick", $nMinPitch, $nMaxPitch)
EndFunc

Func _Pattern_Hihat($nMinPitch = 0, $nMaxPitch = 0)
  Return _Generic_Pattern("hihat", $nMinPitch, $nMaxPitch)
EndFunc

Func _Pattern_Clap($nMinPitch = 0, $nMaxPitch = 0)
  Return _Generic_Pattern("clap", $nMinPitch, $nMaxPitch)
EndFunc
