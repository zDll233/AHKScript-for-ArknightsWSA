#Requires AutoHotkey v2.0
;Audio Control
#include "Audio.ahk"

;Arknights Hotkeys

Arknights_PID:=0
Arknights_Title:="明日方舟"
Arknights_Class:="ahk_class com.hypergryph.arknights"
^1::Run "C:\Users\35573\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\明日方舟.lnk",,,&Arknights_PID

#HotIf WinExist(Arknights_Class)
Arknights_PID:=WinGetPID(Arknights_Class)
sav := SimpleAudioVolumeFromPid(Arknights_PID)

#HotIf WinActive(Arknights_Class)
;resolution,Proportion,etc
ratio1:=1920/1040

SkillBtn_wRatio1:=0.65 
SkillBtn_hRatio1:=0.56

PauseBtn_wRatio1:=0.94
PauseBtn_hRatio1:=0.1

AbortBtn_wRatio1:=0.47
AbortBtn_hRatio1:=0.34

;Event constant
EVENT_SYSTEM_MOVESIZEEND := 0x000B
EVENT_SYSTEM_MOVESIZESTART := 0x000A
WINEVENT_OUTOFCONTEXT := 0x0
WINEVENT_SKIPOWNPROCESS := 0x2

RBUTTON::SetClick(SkillBtn_wRatio1,SkillBtn_hRatio1)
Space::SetClick(PauseBtn_wRatio1,PauseBtn_hRatio1)
XButton2::SetClick(AbortBtn_wRatio1,AbortBtn_hRatio1)
f::SetClick(AbortBtn_wRatio1,AbortBtn_hRatio1)

^+NumpadAdd::sav.SetMasterVolume(min(sav.GetMasterVolume()+0.1,1))
^+NumpadSub::sav.SetMasterVolume(max(sav.GetMasterVolume()-0.1,0))
^+m::sav.SetMute(!sav.GetMute())

DllCall("SetWinEventHook"
    , "UInt",   EVENT_SYSTEM_MOVESIZESTART                      ;_In_  UINT eventMin
    , "UInt",   EVENT_SYSTEM_MOVESIZEEND                        ;_In_  UINT eventMax
    , "Ptr" ,   0x0                                             ;_In_  HMODULE hmodWinEventProc
    , "Ptr" ,   CallbackCreate(WinEventProc)                    ;_In_  WINEVENTPROC lpfnWinEventProc
    , "UInt",   Arknights_PID                                   ;_In_  DWORD idProcess
    , "UInt",   0x0                                             ;_In_  DWORD idThread
    , "UInt",   WINEVENT_OUTOFCONTEXT|WINEVENT_SKIPOWNPROCESS)  ;_In_  UINT dwflags

WinEventProc(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) 
{
    winTitle:=WinGetTitle("ahk_id " hwnd)   
    if(winTitle=Arknights_Title && event=EVENT_SYSTEM_MOVESIZEEND) 
    {
        Resize(winTitle,ratio1)
    }
}

SetClick(wRatio,hRatio)
{
    WinGetClientPos ,, &Width, &Height, Arknights_Title

    SetControlDelay -1
    ControlClick Format("x{1} y{2}", wRatio*Width,hRatio*Height), Arknights_Title,,,,"NA"
    KeyWait A_ThisHotkey    ; avoid hotkeys being triggered repeatedly
}

Resize(WinTitle,whRatio)
{
    WinGetClientPos &old_X, &old_Y, &old_Width, &old_Height, WinTitle
    WinMove ,,old_Height*whRatio,,WinTitle
}
#HotIf
