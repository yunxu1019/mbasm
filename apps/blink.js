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
    PostQuitMessage,
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
    wkeSetWindowTitle,
    wkeOnLoadingFinish,
    wkeGetTitle,
    wkeLoadURL
} from "miniblink_4949_x32.dll";
function quit() {
    wkeDestroyWebWindow(w);
    PostQuitMessage(null);
}
function onload() {
    var t = wkeGetTitle(w);
    wkeSetWindowTitle(w, t);
}
var x = GetSystemMetrics(SM_CXSCREEN);
var y = GetSystemMetrics(SM_CYSCREEN);
SetProcessDpiAwareness(1);
var x1 = GetSystemMetrics(SM_CXSCREEN);
var y1 = GetSystemMetrics(SM_CYSCREEN);
var w_ = 800;
w_ *= x1 / x;
var h_ = 600;
h_ *= y1 / y;
var factor = 1.0;
factor *= x1 / x;
wkeInitializeEx(null);
var w = wkeCreateWebWindow(WKE_WINDOW_TYPE_POPUP, null, 0, 0, w_, h_);
wkeSetZoomFactor(w, factor);
wkeMoveToCenter(w);
wkeSetWindowTitle(w, "正在加载...");
wkeShowWindow(w, SW_SHOWNORMAL);
wkeOnWindowClosing(w, quit, null);
wkeOnLoadingFinish(w, onload, null);

wkeLoadURL(w, "http://efront.cc/");
var msg = void MSG;
while (true) {
    GetMessageW(msg, null, 0, 0);
    if (!eax) break;
    TranslateMessage(msg);
    DispatchMessageW(msg);
}
