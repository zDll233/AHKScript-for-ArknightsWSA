# README

# 前言

这是一个AHK脚本，为WSA明日方舟提供热键和按键映射功能，即通过按键实现点击操作。


音量控制部分，使用了[thqby](https://github.com/thqby)的[ahk2_lib](https://github.com/thqby/ahk2_lib)中的Audio库。

---

# 使用

1. 官网安装[AutoHotkey](https://www.autohotkey.com/)

2. 窗口：长宽比被设置为了1920*1040（在我的电脑全屏下的Client大小）。高度改变后宽度会自动等比例变化。
3. 常用功能及热键：

    * 技能：鼠标右键（`RBUTTON`​​）
    * 暂停：空格（`Space`​​），以及默认的Esc
    * 撤退干员：鼠标的前进肩键（`XButton2`​）/ 按键f（​`f`​）
    * Ctrl+1:打开明日方舟
    * 音量控制：

      1. Ctrl+Shift+'+':增大明日方舟进程的音量
      2. Ctrl+Shift+'-':减小明日方舟进程的音量
      3. Ctrl+Shift+m:切换明日方舟进程是否静音

---

根据所需长宽比不同，热键设置偏好不同，更改ArknightsWSAScript.ahk。脚本修改后需要重新加载，右击脚本任务栏图标选择Reload Script。

WSA下游戏表现其实还不如模拟器，卡顿掉帧很频繁，但是也凑合能用了。
