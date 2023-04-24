;wkeMouseFlags enum
WKE_LBUTTON equ 1
WKE_RBUTTON equ 2
WKE_SHIFT equ 4
WKE_CONTROL equ 8
WKE_MBUTTON equ 16
;wkeMouseFlags ende

;wkeKeyFlags enum
WKE_EXTENDED equ 256
WKE_REPEAT equ 16384
;wkeKeyFlags ende

;wkeMouseMsg enum
WKE_MSG_MOUSEMOVE equ 512
WKE_MSG_LBUTTONDOWN equ 513
WKE_MSG_LBUTTONUP equ 514
WKE_MSG_LBUTTONDBLCLK equ 515
WKE_MSG_RBUTTONDOWN equ 516
WKE_MSG_RBUTTONUP equ 517
WKE_MSG_RBUTTONDBLCLK equ 518
WKE_MSG_MBUTTONDOWN equ 519
WKE_MSG_MBUTTONUP equ 520
WKE_MSG_MBUTTONDBLCLK equ 521
WKE_MSG_MOUSEWHEEL equ 522
;wkeMouseMsg ende

;wkeProxyType enum
WKE_PROXY_NONE equ 0
WKE_PROXY_HTTP equ 1
WKE_PROXY_SOCKS4 equ 2
WKE_PROXY_SOCKS4A equ 3
WKE_PROXY_SOCKS5 equ 4
WKE_PROXY_SOCKS5HOSTNAME equ 5
;wkeProxyType ende

;wkeSettingMask enum
WKE_SETTING_PROXY equ 1
WKE_SETTING_EXTENSION equ 4
;wkeSettingMask ende

;wkeMenuItemId enum
kWkeMenuSelectedAllId equ 2
kWkeMenuSelectedTextId equ 4
kWkeMenuUndoId equ 8
kWkeMenuCopyImageId equ 16
kWkeMenuInspectElementAtId equ 32
kWkeMenuCutId equ 64
kWkeMenuPasteId equ 128
kWkeMenuPrintId equ 256
kWkeMenuGoForwardId equ 512
kWkeMenuGoBackId equ 1024
kWkeMenuReloadId equ 2048
kWkeMenuSaveImageId equ 4096
;wkeMenuItemId ende

;wkeCookieCommand enum
wkeCookieCommandClearAllCookies equ 0
wkeCookieCommandClearSessionCookies equ 1
wkeCookieCommandFlushCookiesToFile equ 2
wkeCookieCommandReloadCookiesFromFile equ 3
;wkeCookieCommand ende

;wkeNavigationType enum
WKE_NAVIGATION_TYPE_LINKCLICK equ 0
WKE_NAVIGATION_TYPE_FORMSUBMITTE equ 1
WKE_NAVIGATION_TYPE_BACKFORWARD equ 2
WKE_NAVIGATION_TYPE_RELOAD equ 3
WKE_NAVIGATION_TYPE_FORMRESUBMITT equ 4
WKE_NAVIGATION_TYPE_OTHER equ 5
;wkeNavigationType ende

;WkeCursorInfoType enum
WkeCursorInfoPointer equ 0
WkeCursorInfoCross equ 1
WkeCursorInfoHand equ 2
WkeCursorInfoIBeam equ 3
WkeCursorInfoWait equ 4
WkeCursorInfoHelp equ 5
WkeCursorInfoEastResize equ 6
WkeCursorInfoNorthResize equ 7
WkeCursorInfoNorthEastResize equ 8
WkeCursorInfoNorthWestResize equ 9
WkeCursorInfoSouthResize equ 10
WkeCursorInfoSouthEastResize equ 11
WkeCursorInfoSouthWestResize equ 12
WkeCursorInfoWestResize equ 13
WkeCursorInfoNorthSouthResize equ 14
WkeCursorInfoEastWestResize equ 15
WkeCursorInfoNorthEastSouthWestResize equ 16
WkeCursorInfoNorthWestSouthEastResize equ 17
WkeCursorInfoColumnResize equ 18
WkeCursorInfoRowResize equ 19
WkeCursorInfoMiddlePanning equ 20
WkeCursorInfoEastPanning equ 21
WkeCursorInfoNorthPanning equ 22
WkeCursorInfoNorthEastPanning equ 23
WkeCursorInfoNorthWestPanning equ 24
WkeCursorInfoSouthPanning equ 25
WkeCursorInfoSouthEastPanning equ 26
WkeCursorInfoSouthWestPanning equ 27
WkeCursorInfoWestPanning equ 28
WkeCursorInfoMove equ 29
WkeCursorInfoVerticalText equ 30
WkeCursorInfoCell equ 31
WkeCursorInfoContextMenu equ 32
WkeCursorInfoAlias equ 33
WkeCursorInfoProgress equ 34
WkeCursorInfoNoDrop equ 35
WkeCursorInfoCopy equ 36
WkeCursorInfoNone equ 37
WkeCursorInfoNotAllowed equ 38
WkeCursorInfoZoomIn equ 39
WkeCursorInfoZoomOut equ 40
WkeCursorInfoGrab equ 41
WkeCursorInfoGrabbing equ 42
WkeCursorInfoCustom equ 43
;WkeCursorInfoType ende

;storageType enum
StorageTypeString equ 0
StorageTypeFilename equ 1
StorageTypeBinaryData equ 2
StorageTypeFileSystemFile equ 3
;storageType ende

;wkeWebDragOperation enum
wkeWebDragOperationNone equ 0
wkeWebDragOperationCopy equ 1
wkeWebDragOperationLink equ 2
wkeWebDragOperationGeneric equ 4
wkeWebDragOperationPrivate equ 8
wkeWebDragOperationMove equ 16
wkeWebDragOperationDelete equ 32
wkeWebDragOperationEvery equ 4294967295
;wkeWebDragOperation ende

;wkeResourceType enum
WKE_RESOURCE_TYPE_MAIN_FRAME equ 0
WKE_RESOURCE_TYPE_SUB_FRAME equ 1
WKE_RESOURCE_TYPE_STYLESHEET equ 2
WKE_RESOURCE_TYPE_SCRIPT equ 3
WKE_RESOURCE_TYPE_IMAGE equ 4
WKE_RESOURCE_TYPE_FONT_RESOURCE equ 5
WKE_RESOURCE_TYPE_SUB_RESOURCE equ 6
WKE_RESOURCE_TYPE_OBJECT equ 7
WKE_RESOURCE_TYPE_MEDIA equ 8
WKE_RESOURCE_TYPE_WORKER equ 9
WKE_RESOURCE_TYPE_SHARED_WORKER equ 10
WKE_RESOURCE_TYPE_PREFETCH equ 11
WKE_RESOURCE_TYPE_FAVICON equ 12
WKE_RESOURCE_TYPE_XHR equ 13
WKE_RESOURCE_TYPE_PING equ 14
WKE_RESOURCE_TYPE_SERVICE_WORKER equ 15
WKE_RESOURCE_TYPE_LAST_TYPE equ 16
;wkeResourceType ende

;wkeHttBodyElementType enum
wkeHttBodyElementTypeData equ 0
wkeHttBodyElementTypeFile equ 1
;wkeHttBodyElementType ende

;wkeRequestType enum
kWkeRequestTypeInvalidation equ 0
kWkeRequestTypeGet equ 1
kWkeRequestTypePost equ 2
kWkeRequestTypePut equ 3
;wkeRequestType ende

;wkeOtherLoadType enum
WKE_DID_START_LOADING equ 0
WKE_DID_STOP_LOADING equ 1
WKE_DID_NAVIGATE equ 2
WKE_DID_NAVIGATE_IN_PAGE equ 3
WKE_DID_GET_RESPONSE_DETAILS equ 4
WKE_DID_GET_REDIRECT_REQUEST equ 5
WKE_DID_POST_REQUEST equ 6
;wkeOtherLoadType ende

;wkeOnContextMenuItemClickType enum
kWkeContextMenuItemClickTypePrint equ 1
;wkeOnContextMenuItemClickType ende

;wkeOnContextMenuItemClickStep enum
kWkeContextMenuItemClickStepShow equ 1
kWkeContextMenuItemClickStepClick equ 2
;wkeOnContextMenuItemClickStep ende

;wkeLoadingResult enum
WKE_LOADING_SUCCEEDED equ 0
WKE_LOADING_FAILED equ 1
WKE_LOADING_CANCELED equ 2
;wkeLoadingResult ende

;wkeDownloadOpt enum
kWkeDownloadOptCancel equ 0
kWkeDownloadOptCacheData equ 1
;wkeDownloadOpt ende

;wkeConsoleLevel enum
wkeLevelDebug equ 4
wkeLevelLog equ 1
wkeLevelInfo equ 5
wkeLevelWarning equ 2
wkeLevelError equ 3
wkeLevelRevokedError equ 6
wkeLevelLast equ 5
;wkeConsoleLevel ende

;wkeWindowType enum
WKE_WINDOW_TYPE_POPUP equ 0
WKE_WINDOW_TYPE_TRANSPARENT equ 1
WKE_WINDOW_TYPE_CONTROL equ 2
;wkeWindowType ende

wkeRect struct
    x dword ?
    y dword ?
    w dword ?
    h dword ?
wkeRect ends

wkePoint struct
    x dword ?
    y dword ?
wkePoint ends

wkeProxy struct
    type_ dword ?
    hostname byte 100 dup(?)
    port word ?
    username byte 50 dup(?)
    password byte 50 dup(?)
wkeProxy ends

wkeSettings struct
    proxy wkeProxy<?>
    mask_ dword ?
    extension dword ?
wkeSettings ends

wkeViewSettings struct
    size_ dword ?
    bgColor dword ?
wkeViewSettings ends

wkeGeolocationPosition struct
    timestamp real8 ?
    latitude real8 ?
    longitude real8 ?
    accuracy real8 ?
    providesAltitude byte ?
    altitude real8 ?
    providesAltitudeAccuracy byte ?
    altitudeAccuracy real8 ?
    providesHeading byte ?
    heading real8 ?
    providesSpeed byte ?
    speed real8 ?
wkeGeolocationPosition ends

wkeClientHandler struct
    onTitleChanged dword ?
    onURLChanged dword ?
wkeClientHandler ends

wkeWindowFeatures struct
    x dword ?
    y dword ?
    width_ dword ?
    height dword ?
    menuBarVisible byte ?
    statusBarVisible byte ?
    toolBarVisible byte ?
    locationBarVisible byte ?
    scrollbarsVisible byte ?
    resizable byte ?
    fullscreen byte ?
wkeWindowFeatures ends

wkeMemBuf struct
    unuse dword ?
    data dword ?
    length_ dword ?
wkeMemBuf ends

wkeWebDragData struct
    ; undefined ?
    m_itemList dword ?
    m_itemListLength dword ?
    m_modifierKeyState dword ?
    m_filesystemId dword ?
wkeWebDragData ends

wkeWillSendRequestInfo struct
    url dword ?
    newUrl dword ?
    resourceType dword ?
    httpResponseCode dword ?
    method dword ?
    referrer dword ?
    headers dword ?
wkeWillSendRequestInfo ends

wkePostBodyElement struct
    size_ dword ?
    type_ dword ?
    data dword ?
    filePath dword ?
    fileStart qword ?
    fileLength qword ?
wkePostBodyElement ends

wkePostBodyElements struct
    size_ dword ?
    element dword ?
    elementSize dword ?
    isDirty byte ?
wkePostBodyElements ends

wkeSlist struct
    data dword ?
    next dword ?
wkeSlist ends

wkeTempCallbackInfo struct
    size_ dword ?
    frame dword ?
    willSendRequestInfo dword ?
    url dword ?
    postBody dword ?
    job dword ?
wkeTempCallbackInfo ends

wkePdfDatas struct
    count dword ?
    sizes dword ?
    datas dword ?
wkePdfDatas ends

wkePrintSettings struct
    structSize dword ?
    dpi dword ?
    width_ dword ?
    height dword ?
    marginTop dword ?
    marginBottom dword ?
    marginLeft dword ?
    marginRight dword ?
    isPrintPageHeadAndFooter dword ?
    isPrintBackgroud dword ?
    isLandscape dword ?
    isPrintToMultiPage dword ?
wkePrintSettings ends

wkeScreenshotSettings struct
    structSize dword ?
    width_ dword ?
    height dword ?
wkeScreenshotSettings ends

wkeMediaLoadInfo struct
    size_ dword ?
    width_ dword ?
    height dword ?
    duration real8 ?
wkeMediaLoadInfo ends

wkeNetJobDataBind struct
    param dword ?
    recvCallback dword ?
    finishCallback dword ?
wkeNetJobDataBind ends

wkeDownloadBind struct
    param dword ?
    recvCallback dword ?
    finishCallback dword ?
    saveNameCallback dword ?
wkeDownloadBind ends

wkeUrlRequestCallbacks struct
    willRedirectCallback dword ?
    didReceiveResponseCallback dword ?
    didReceiveDataCallback dword ?
    didFailCallback dword ?
    didFinishLoadingCallback dword ?
wkeUrlRequestCallbacks ends

wkeWindowCreateInfo struct
    size_ dword ?
    parent dword ?
    style dword ?
    styleEx dword ?
    x dword ?
    y dword ?
    width_ dword ?
    height dword ?
    color dword ?
wkeWindowCreateInfo ends