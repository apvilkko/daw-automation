#include "../utils/console.au3"
#include "../modules/live-commands.au3"
#include "../modules/battery3.au3"
#include "../modules/pattern.au3"

Global $hConsole

Script1()

Func Script1()
  $hConsole = AttachToParentConsole()
  _Log("")
  _Log("Script start")
  _Log("")

  Local $nTrack = 6

  $nTrack = CreateMidiTrack()
  AddVstToTrack("Battery 3", $nTrack)
  OpenPlugin($nTrack, 1)
  _Battery3_OpenPreset($nTrack, "zph_kicks_"&Random(1, 4, 1)&".kt3")
  ClosePlugin($nTrack, 1)
  AddVstToTrack("Driver", $nTrack)
  ClosePlugin($nTrack, 2)
  CreateMidiPattern($nTrack)
  EnterPattern(_Pattern_Kick(), Random(0, 36, 1) - 24)
  PlayClip($nTrack, 1)

  $nTrack = CreateMidiTrack()
  Local $nHhTrack = $nTrack
  AddVstToTrack("Battery 3", $nTrack)
  OpenPlugin($nTrack, 1)
  _Battery3_OpenPreset($nTrack, "zph_hats_"&Random(1, 4, 1)&".kt3")
  ClosePlugin($nTrack, 1)
  CreateMidiPattern($nTrack)
  EnterPattern(_Pattern_Hihat(), Random(0, 36, 1) - 24)
  PlayClip($nTrack, 1)

  $nTrack = CreateMidiTrack()
  AddVstToTrack("Battery 3", $nTrack)
  OpenPlugin($nTrack, 1)
  _Battery3_OpenPreset($nTrack, "zph_sncl_"&Random(1, 4, 1)&".kt3")
  ClosePlugin($nTrack, 1)
  CreateMidiPattern($nTrack)
  EnterPattern(_Pattern_Clap(), Random(0, 36, 1) - 24)
  PlayClip($nTrack, 1)

  AddVstToTrack("Replika", $nHhTrack)
  LoadPluginPreset($nHhTrack, 2, "replica_subtle_dotted8.fxb")
  ClosePlugin($nHhTrack, 2)

EndFunc
