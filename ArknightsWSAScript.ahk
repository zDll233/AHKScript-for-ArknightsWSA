#Requires AutoHotkey v2.0
;Audio Control
#include "Audio.ahk"

Persistent
SetTitleMatchMode 3 ;match strictly


;for Arknights Hotkeys
Arknights_PID:=0
Arknights_Title:="明日方舟"

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
EVENT_OBJECT_CREATE := 0x00008000
EVENT_OBJECT_DESTROY := 0x00008001

; init flag
bInitFlag := false

Init(){
    global Arknights_PID,sav,bInitFlag
    Arknights_PID:=WinGetPID(Arknights_Title)
    sav := SimpleAudioVolumeFromPid(Arknights_PID)
    bInitFlag:=true
}

SetClick(wRatio,hRatio){
    WinGetClientPos ,, &Width, &Height, Arknights_Title

    SetControlDelay -1
    ControlClick Format("x{1} y{2}", wRatio*Width,hRatio*Height), Arknights_Title,,,,"NA"
    KeyWait A_ThisHotkey    ; avoid hotkeys being triggered repeatedly
}

Resize(WinTitle,whRatio){
    WinGetClientPos &old_X, &old_Y, &old_Width, &old_Height, WinTitle
    WinMove ,,old_Height*whRatio,,WinTitle
}

class WinEventHook
{
    __New(eventMin, eventMax, hookProc, options := '', idProcess := 0, idThread := 0, dwFlags := 0) {
        this.pCallback := CallbackCreate(hookProc, options, 7)
        this.hHook := DllCall('SetWinEventHook', 'UInt', eventMin, 'UInt', eventMax, 'Ptr', 0, 'Ptr', this.pCallback
                                               , 'UInt', idProcess, 'UInt', idThread, 'UInt', dwFlags, 'Ptr')
    }
    __Delete() {
        DllCall('UnhookWinEvent', 'Ptr', this.hHook)
        CallbackFree(this.pCallback)
    }
}


CreateDestroyProc(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) {
    global bInitFlag
    ; create->init
    if(WinExist(Arknights_Title) && !bInitFlag)
        Init()
    ; destroy->reset flag
    if(!WinExist(Arknights_Title) && bInitFlag) 
        bInitFlag:=false
}
hCreateDestroyHook := WinEventHook(EVENT_OBJECT_CREATE, EVENT_OBJECT_DESTROY, CreateDestroyProc, "F")

ResizeProc(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) {
    WinTitle:=WinGetTitle(hwnd)   
    if(WinTitle=Arknights_Title && event=EVENT_SYSTEM_MOVESIZEEND) 
        Resize(WinTitle,ratio1)
}
hResizeHook:=WinEventHook(EVENT_SYSTEM_MOVESIZESTART, EVENT_SYSTEM_MOVESIZEEND, ResizeProc, "F",Arknights_PID)

if WinExist(Arknights_Title) 
    Init()

^1::Run "C:\Users\35573\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\明日方舟.lnk"

#HotIf WinActive(Arknights_Title)

RBUTTON::SetClick(SkillBtn_wRatio1,SkillBtn_hRatio1)
Space::SetClick(PauseBtn_wRatio1,PauseBtn_hRatio1)
XButton2::SetClick(AbortBtn_wRatio1,AbortBtn_hRatio1)
^Space::Space

^+NumpadAdd::sav.SetMasterVolume(min(sav.GetMasterVolume()+0.1,1))
^+NumpadSub::sav.SetMasterVolume(max(sav.GetMasterVolume()-0.1,0))
^+PgUp::sav.SetMasterVolume(min(sav.GetMasterVolume()+0.1,1))
^+PgDn::sav.SetMasterVolume(max(sav.GetMasterVolume()-0.1,0))
^+m::sav.SetMute(!sav.GetMute())

#HotIf
