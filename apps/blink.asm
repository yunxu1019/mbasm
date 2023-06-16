

.386
.model flat,stdcall
include wke.inc
include windows.inc


miniblink_4949_x32_ struct
    wkeInitializeEx dword ?
    wkeCreateWebWindow dword ?
    wkeOnWindowClosing dword ?
    wkeDestroyWebWindow dword ?
    wkeShowWindow dword ?
    wkeSetZoomFactor dword ?
    wkeMoveToCenter dword ?
    wkeSetWindowTitle dword ?
    wkeOnLoadingFinish dword ?
    wkeGetTitle dword ?
    wkeLoadURL dword ?
miniblink_4949_x32_ ends
shcore_ struct
    SetProcessDpiAwareness dword ?
shcore_ ends
user32_ struct
    GetMessageW dword ?
    TranslateMessage dword ?
    DispatchMessageW dword ?
    GetSystemMetrics dword ?
    PostQuitMessage dword ?
user32_ ends

.data
miniblink_4949_x32@ dw "miniblink_4949_x32.dll",0
miniblink_4949_x32$ dword ?
wkeInitializeEx@ byte "wkeInitializeEx",0
wkeCreateWebWindow@ byte "wkeCreateWebWindow",0
wkeOnWindowClosing@ byte "wkeOnWindowClosing",0
wkeDestroyWebWindow@ byte "wkeDestroyWebWindow",0
wkeShowWindow@ byte "wkeShowWindow",0
wkeSetZoomFactor@ byte "wkeSetZoomFactor",0
wkeMoveToCenter@ byte "wkeMoveToCenter",0
wkeSetWindowTitle@ byte "wkeSetWindowTitle",0
wkeOnLoadingFinish@ byte "wkeOnLoadingFinish",0
wkeGetTitle@ byte "wkeGetTitle",0
wkeLoadURL@ byte "wkeLoadURL",0
miniblink_4949_x32 miniblink_4949_x32_<0,0,0,0,0,0,0,0,0,0,0>
shcore@ dw 'shcore.dll',0
shcore$ dword ?
SetProcessDpiAwareness@ byte "SetProcessDpiAwareness",0
shcore shcore_<0>
user32@ dw "user32.dll",0
user32$ dword ?
GetMessageW@ byte "GetMessageW",0
TranslateMessage@ byte "TranslateMessage",0
DispatchMessageW@ byte "DispatchMessageW",0
GetSystemMetrics@ byte "GetSystemMetrics",0
PostQuitMessage@ byte "PostQuitMessage",0
user32 user32_<0,0,0,0,0>
______ db "正在加载...",0,0
http__ db "http://efront.cc/",0,0
w_ dword 800
h_ dword 600
factor real4 1.0
msg MSG<>
_1 dword ?
x dword ?
y dword ?
x1 dword ?
y1 dword ?
w dword ?

.code

quit proc 
enter 0,0
    ;miniblink_4949_x32.wkeDestroyWebWindow(w);
    push w
    call miniblink_4949_x32.wkeDestroyWebWindow
    ;user32.PostQuitMessage(null)
    push 0
    call user32.PostQuitMessage
leave
ret
quit endp
onload proc 
    local __1,t
enter 0,0
    ;t = miniblink_4949_x32.wkeGetTitle(w);
    push w
    call miniblink_4949_x32.wkeGetTitle
    mov t,eax
    ;miniblink_4949_x32.wkeSetWindowTitle(w, t)
    push t
    push w
    call miniblink_4949_x32.wkeSetWindowTitle
leave
ret
onload endp

start:
    call init_kernel32
    push offset miniblink_4949_x32@
    call kernel32.LoadLibrary
    mov miniblink_4949_x32$,eax
    push offset wkeInitializeEx@
    push miniblink_4949_x32$
    call kernel32.GetProcAddress
    mov miniblink_4949_x32.wkeInitializeEx,eax
    push offset wkeCreateWebWindow@
    push miniblink_4949_x32$
    call kernel32.GetProcAddress
    mov miniblink_4949_x32.wkeCreateWebWindow,eax
    push offset wkeOnWindowClosing@
    push miniblink_4949_x32$
    call kernel32.GetProcAddress
    mov miniblink_4949_x32.wkeOnWindowClosing,eax
    push offset wkeDestroyWebWindow@
    push miniblink_4949_x32$
    call kernel32.GetProcAddress
    mov miniblink_4949_x32.wkeDestroyWebWindow,eax
    push offset wkeShowWindow@
    push miniblink_4949_x32$
    call kernel32.GetProcAddress
    mov miniblink_4949_x32.wkeShowWindow,eax
    push offset wkeSetZoomFactor@
    push miniblink_4949_x32$
    call kernel32.GetProcAddress
    mov miniblink_4949_x32.wkeSetZoomFactor,eax
    push offset wkeMoveToCenter@
    push miniblink_4949_x32$
    call kernel32.GetProcAddress
    mov miniblink_4949_x32.wkeMoveToCenter,eax
    push offset wkeSetWindowTitle@
    push miniblink_4949_x32$
    call kernel32.GetProcAddress
    mov miniblink_4949_x32.wkeSetWindowTitle,eax
    push offset wkeOnLoadingFinish@
    push miniblink_4949_x32$
    call kernel32.GetProcAddress
    mov miniblink_4949_x32.wkeOnLoadingFinish,eax
    push offset wkeGetTitle@
    push miniblink_4949_x32$
    call kernel32.GetProcAddress
    mov miniblink_4949_x32.wkeGetTitle,eax
    push offset wkeLoadURL@
    push miniblink_4949_x32$
    call kernel32.GetProcAddress
    mov miniblink_4949_x32.wkeLoadURL,eax
    push offset shcore@
    call kernel32.LoadLibrary
    mov shcore$,eax
    push offset SetProcessDpiAwareness@
    push shcore$
    call kernel32.GetProcAddress
    mov shcore.SetProcessDpiAwareness,eax
    push offset user32@
    call kernel32.LoadLibrary
    mov user32$,eax
    push offset GetMessageW@
    push user32$
    call kernel32.GetProcAddress
    mov user32.GetMessageW,eax
    push offset TranslateMessage@
    push user32$
    call kernel32.GetProcAddress
    mov user32.TranslateMessage,eax
    push offset DispatchMessageW@
    push user32$
    call kernel32.GetProcAddress
    mov user32.DispatchMessageW,eax
    push offset GetSystemMetrics@
    push user32$
    call kernel32.GetProcAddress
    mov user32.GetSystemMetrics,eax
    push offset PostQuitMessage@
    push user32$
    call kernel32.GetProcAddress
    mov user32.PostQuitMessage,eax
    ;x = user32.GetSystemMetrics(SM_CXSCREEN);
    push SM_CXSCREEN
    call user32.GetSystemMetrics
    mov x,eax
    ;y = user32.GetSystemMetrics(SM_CYSCREEN);
    push SM_CYSCREEN
    call user32.GetSystemMetrics
    mov y,eax
    ;shcore.SetProcessDpiAwareness(1);
    push 1
    call shcore.SetProcessDpiAwareness
    ;x1 = user32.GetSystemMetrics(SM_CXSCREEN);
    push SM_CXSCREEN
    call user32.GetSystemMetrics
    mov x1,eax
    ;y1 = user32.GetSystemMetrics(SM_CYSCREEN);
    push SM_CYSCREEN
    call user32.GetSystemMetrics
    mov y1,eax
    ;_1 = x1 / x;
    fild x1
    fidiv x
    fstp _1
    ;w_ = w_ * _1;
    fild w_
    fmul _1
    fistp w_
    ;_1 = y1 / y;
    fild y1
    fidiv y
    fstp _1
    ;h_ = h_ * _1;
    fild h_
    fmul _1
    fistp h_
    ;_1 = x1 / x;
    fild x1
    fidiv x
    fstp _1
    ;factor = factor * _1;
    fld factor
    fmul _1
    fstp factor
    ;miniblink_4949_x32.wkeInitializeEx(null);
    push 0
    call miniblink_4949_x32.wkeInitializeEx
    ;w = miniblink_4949_x32.wkeCreateWebWindow(WKE_WINDOW_TYPE_POPUP, null, 0, 0, w_, h_);
    push h_
    push w_
    push 0
    push 0
    push 0
    push WKE_WINDOW_TYPE_POPUP
    call miniblink_4949_x32.wkeCreateWebWindow
    mov w,eax
    ;miniblink_4949_x32.wkeSetZoomFactor(w, factor);
    push factor
    push w
    call miniblink_4949_x32.wkeSetZoomFactor
    ;miniblink_4949_x32.wkeMoveToCenter(w);
    push w
    call miniblink_4949_x32.wkeMoveToCenter
    ;miniblink_4949_x32.wkeSetWindowTitle(w, "正在加载...");
    push offset ______
    push w
    call miniblink_4949_x32.wkeSetWindowTitle
    ;miniblink_4949_x32.wkeShowWindow(w, SW_SHOWNORMAL);
    push SW_SHOWNORMAL
    push w
    call miniblink_4949_x32.wkeShowWindow
    ;miniblink_4949_x32.wkeOnWindowClosing(w, quit, null);
    push 0
    push quit
    push w
    call miniblink_4949_x32.wkeOnWindowClosing
    ;miniblink_4949_x32.wkeOnLoadingFinish(w, onload, null);
    push 0
    push onload
    push w
    call miniblink_4949_x32.wkeOnLoadingFinish
    ;miniblink_4949_x32.wkeLoadURL(w, "http://efront.cc/");
    push offset http__
    push w
    call miniblink_4949_x32.wkeLoadURL
    label1:
    ;user32.GetMessageW(msg, null, 0, 0);
    push 0
    push 0
    push 0
    lea eax,msg
    push eax
    call user32.GetMessageW
    mov ebx,0
    cmp eax,ebx
    jz label2
    ;user32.TranslateMessage(msg);
    lea eax,msg
    push eax
    call user32.TranslateMessage
    ;user32.DispatchMessageW(msg);
    lea eax,msg
    push eax
    call user32.DispatchMessageW
    jmp label1
    label2:

    push miniblink_4949_x32$
    call kernel32.FreeLibrary
    push shcore$
    call kernel32.FreeLibrary
    push user32$
    call kernel32.FreeLibrary
    call kernel32.ExitProcess
    end start
