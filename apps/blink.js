asm.head`
.386
.model flat,stdcall
include wke.inc
include windows.inc
`;
import {
    GetMessageW,
    TranslateMessage,
    DispatchMessageW,
    GetSystemMetrics,
    PostQuitMessage
} from "user32.dll";
import { SetProcessDpiAwareness } from 'shcore.dll';
import {
    wkeInitializeEx,
    wkeCreateWebWindow,
    wkeOnWindowClosing,
    wkeDestroyWebWindow,
    wkeShowWindow,
    wkeSetZoomFactor,
    wkeMoveToCenter,
    wkeLoadURL
} from "miniblink_4949_x32.dll";
function quit() {
    wkeDestroyWebWindow(w);
    PostQuitMessage(null);
}
var x = GetSystemMetrics(SM_CXSCREEN);
var y = GetSystemMetrics(SM_CYSCREEN);
SetProcessDpiAwareness(1);
var x1 = GetSystemMetrics(SM_CXSCREEN);
var y1 = GetSystemMetrics(SM_CYSCREEN);
var w_ = 800 * x1 / x;
var h_ = 600 * y1 / y;
asm.data`
factor real4 1.0`
asm.code`
fld1
fimul x1
fidiv x
fstp factor
`
wkeInitializeEx(null);
var w = wkeCreateWebWindow(WKE_WINDOW_TYPE_POPUP, null, 0, 0, w_, h_);
wkeSetZoomFactor(w, factor);
wkeMoveToCenter(w);
wkeShowWindow(w, SW_SHOWNORMAL);
wkeOnWindowClosing(w, quit, null);
wkeLoadURL(w, "https://efront.cc/");
asm.data`msg MSG<?>`;
while (true) {
    asm.code`lea ebx,msg`;
    GetMessageW(ebx, null, 0, 0);
    if (!eax) break;
    asm.code`lea ebx,msg`;
    TranslateMessage(ebx);
    asm.code`lea ebx,msg`;
    DispatchMessageW(ebx);
}
