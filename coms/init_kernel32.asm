kernel32_ struct
    LoadLibrary dword ?
    FreeLibrary dword ?
    GetProcAddress dword ?
    ExitProcess dword ?
kernel32_ ends


.data
LoadLibrary@_     byte "LoadLibraryW",0
FreeLibrary@_     byte "FreeLibrary",0
ExitProcess@_     byte "ExitProcess",0
GetProcAddress@_  byte "GetProcAddress",0
kernel32@_  dw      "kernel32.dll",0
kernel32 kernel32_<0,0,0,0>
kernel@$ dword ?
exportDirT@$ dword ?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;para1  kernel32_
;ret:   kernel32ess
assume fs:nothing
fun_Getkernel32_t proc
    push ebp
    mov ebp,esp
    push    edi

    mov     edi,fs:[30h]
    mov     edi,[edi + 0ch]
    mov     edi,[edi + 01ch]

fun_Getkernel32_t_l1:
    push    [edi + 20h]
    push    offset kernel32@_
    call    fun_strcmp_nocaseU
    cmp     eax,1h
    je      fun_Getkernel32_t_l2
    mov     edi,[edi]
    jmp     fun_Getkernel32_t_l1

fun_Getkernel32_t_l2:
    mov     eax,[edi + 08h]

    pop     edi
    leave
    ret 4h
fun_Getkernel32_t endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;campare string nocase unicode
;para1：string1
;para2：string2
;ret:   equal=1,not equal=0
fun_strcmp_nocaseU proc
    push    ebp
    mov     ebp,esp

    mov     eax,[ebp+0ch]
    mov     ecx,[ebp+8h]

fun_strcmp_nocaseU_loop:
    mov     dx,[eax]
    sub     dx,[ecx]
    jz      fun_strcmp_nocaseU_zero
    cmp     dx,20h
    je      fun_strcmp_nocaseU_final
    cmp     dx,-20h
    je      fun_strcmp_nocaseU_final
    jmp     fun_strcmp_nocaseU_ret0

fun_strcmp_nocaseU_zero:
    cmp     word ptr [ecx],0
    je      fun_strcmp_nocaseU_ret1

fun_strcmp_nocaseU_final:
    add     eax,2
    add     ecx,2
    jmp     fun_strcmp_nocaseU_loop

fun_strcmp_nocaseU_ret0:
    mov     eax,0
    jmp     fun_strcmp_nocaseU_ret

fun_strcmp_nocaseU_ret1:
    mov     eax,1

fun_strcmp_nocaseU_ret:
    leave
    ret 8h
fun_strcmp_nocaseU endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;get funtion ess in kernel32.dll
;para1  export directory table virtual ess
;para2: search function name string
;para3: kernel32.dll ess
;ret:   function virtual ess
fun_GetFunA proc
    push ebp
    mov ebp,esp
    sub     esp,010h

    ;export ess table
    mov     eax,[ebp+8h]
    mov     eax,[eax + 1ch]
    add     eax,[ebp + 010h]
    mov     [ebp-4h],eax
    ;export name table
    mov     eax,[ebp+8h]
    mov     eax,[eax + 20h]
    add     eax,[ebp + 010h]
    mov     [ebp-8h],eax
    ;export ordinal table
    mov     eax,[ebp+8h]
    mov     eax,[eax + 24h]
    add     eax,[ebp + 010h]
    mov     [ebp-0ch],eax
    ;i
    mov     dword ptr [ebp-010h],0h

fun_GetFunA_loop:
    mov     eax,[ebp-8h]
    mov     edx,[ebp-010h]
    mov     ecx,[eax + edx * 4]
    add     ecx,[ebp + 010h]
    push    ecx
    push    [ebp+0ch]
    call    fun_strcmp_nocase
    cmp     eax,1h
    je      fun_GetFunA_ret
    inc     dword ptr [ebp-010h]
    jmp     fun_GetFunA_loop

fun_GetFunA_ret:
    mov     eax,[ebp-0ch]
    mov     edx,[ebp-010h]
    xor     ecx,ecx
    mov     cx,[eax + edx * 2]
    mov     eax,[ebp-4h]
    mov     eax,[eax + ecx * 4]
    add     eax,[ebp + 010h]

    leave
    ret 0ch
fun_GetFunA endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;campare string nocase
;para1：string1
;para2：string2
;ret:   equal=1,not equal=0
fun_strcmp_nocase proc
    push ebp
    mov ebp,esp

    mov     eax,[ebp+0ch]
    mov     ecx,[ebp+8h]

fun_strcmp_nocase_loop:
    mov     dl,[eax]
    sub     dl,[ecx]
    jz      fun_strcmp_nocase_zero
    cmp     dl,20h
    je      fun_strcmp_nocase_final
    cmp     dl,-20h
    je      fun_strcmp_nocase_final
    jmp     fun_strcmp_nocase_ret0

fun_strcmp_nocase_zero:
    cmp     byte ptr [ecx],0
    je      fun_strcmp_nocase_ret1

fun_strcmp_nocase_final:
    inc     eax
    inc     ecx
    jmp     fun_strcmp_nocase_loop

fun_strcmp_nocase_ret0:
    mov     eax,0
    jmp     fun_strcmp_nocase_ret

fun_strcmp_nocase_ret1:
    mov     eax,1

fun_strcmp_nocase_ret:
    leave
    ret 8h

fun_strcmp_nocase endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


init_kernel32 proc
    ;查找&&存储kernel32.dll基地址
    enter 0,0
    call fun_Getkernel32_t
    mov     kernel@$,eax

    ;查找&&存储引出目录表地址
    mov     eax,[eax + 3ch]
    add     eax,78h
    add     eax,kernel@$
    mov     eax,[eax]
    add     eax,kernel@$
    mov     exportDirT@$,eax
   
    ;查找LoadLibraryW,GetProcAddress函数地址&&存储
    push  kernel@$
    push offset LoadLibrary@_
    push dword ptr exportDirT@$
    call fun_GetFunA
    mov     kernel32.LoadLibrary,eax

    push kernel@$
    push offset GetProcAddress@_
    push dword ptr exportDirT@$
    call fun_GetFunA
    mov     kernel32.GetProcAddress,eax

    push kernel@$
    push offset FreeLibrary@_
    push dword ptr exportDirT@$
    call fun_GetFunA
    mov     kernel32.FreeLibrary,eax
    push kernel@$
    push offset ExitProcess@_
    push dword ptr exportDirT@$
    call fun_GetFunA
    mov     kernel32.ExitProcess,eax
    mov eax,0
    leave
    ret
init_kernel32 endp

