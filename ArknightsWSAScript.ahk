#Requires AutoHotkey v2.0
;Arknights Hotkeys
Arknights_PID:=0
Arknights_Title:="明日方舟"
^1::
{
    global Arkginghts_PID
    ;use your username instead, or any other path
    Run "C:\Users\<username>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\明日方舟.lnk",,,&Arkginghts_PID
}

#HotIf WinActive("ahk_class com.hypergryph.arknights")
;resolution(h/w), and proportions of 3 functions under it
ratio1:=1040/1920
;skill
SkillBtn_wRatio1:=0.65
SkillBtn_hRatio1:=0.56
;pause
PauseBtn_wRatio1:=0.94
PauseBtn_hRatio1:=0.1
;retreat
RetreatBtn_wRatio1:=0.47
RetreatBtn_hRatio1:=0.34

;Event constant
EVENT_SYSTEM_MOVESIZEEND := 0x000B
EVENT_SYSTEM_MOVESIZESTART := 0x000A
WINEVENT_OUTOFCONTEXT := 0x0
WINEVENT_SKIPOWNPROCESS := 0x2

s::
{
    global Arkginghts_PID
    MsgBox Format("The PID is: {1}", Arkginghts_PID)
}

RBUTTON::SetClick(SkillBtn_wRatio1,SkillBtn_hRatio1)
Space::SetClick(PauseBtn_wRatio1,PauseBtn_hRatio1)
XButton2::SetClick(RetreatBtn_wRatio1,RetreatBtn_hRatio1)

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

Resize(WinTitle,hwRatio)
{
    WinGetClientPos &old_X, &old_Y, &old_Width, &old_Height, WinTitle
    WinMove ,,,old_Width*hwRatio,WinTitle
}
#HotIf
