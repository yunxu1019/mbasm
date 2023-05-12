kernel32_ struct
    LoadLibrary dword ?
    FreeLibrary dword ?
    GetProcAddress dword ?
    ExitProcess dword ?
kernel32_ ends


.data
kernel32 kernel32_<0,0,0,0>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

assume fs:nothing
fun_Getkernel32_t proc
    push    edi
    mov     edi,fs:[30h]
    mov     edi,[edi + 0ch]
    mov     edi,[edi + 01ch]
@@:
    mov eax, [edi + 20h]
    cmp byte ptr[eax+0eh], '2'
    je      @F
    mov     edi,[edi]
    jmp     @B
@@:
    mov     eax,[edi + 08h]
    pop     edi
    ret
fun_Getkernel32_t endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
isGetProcAddress proc
    cmp byte ptr[ecx],'G'
    jne @F
    cmp byte ptr[ecx+3],'P'
    jne @F
    cmp byte ptr[ecx+7],'A'
    jne @F
    cmp byte ptr[ecx+13],'s'
    jne @F
    cmp byte ptr[ecx+14],0
    jne @F
    mov eax,1
    ret
@@:
    mov eax,0
    ret
isGetProcAddress endp
isLoadLibrary proc
    cmp byte ptr[ecx],'L'
    jne @F
    cmp byte ptr[ecx+4],'L'
    jne @F
    cmp byte ptr[ecx+11],'W'
    jne @F
    cmp byte ptr[ecx+12],0
    jne @F
    mov eax,1
    ret
@@:
    mov eax,0
    ret
isLoadLibrary endp
isFreeLibrary proc
    cmp byte ptr[ecx],'F'
    jne @F
    cmp byte ptr[ecx+4],'L'
    jne @F
    cmp byte ptr[ecx+10],'y'
    jne @F
    cmp byte ptr[ecx+11],0
    jne @F
    mov eax,1
    ret
@@:
    mov eax,0
    ret
isFreeLibrary endp
isExitProcess proc
    cmp byte ptr[ecx],'E'
    jne @F
    cmp byte ptr[ecx+4],'P'
    jne @F
    cmp byte ptr[ecx+10],'s'
    jne @F
    cmp byte ptr[ecx+11],0
    jne @F
    mov eax,1
    ret
@@:
    mov eax,0
    ret
isExitProcess endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fun_GetFunA proc tb,isValid,kn
    local ess,name_table,ordinal
    ;export ess table
    mov     eax,tb
    mov     eax,[eax + 1ch]
    add     eax,kn
    mov     ess,eax
    ;export name_table table
    mov     eax,tb
    mov     eax,[eax + 20h]
    add     eax,kn
    mov     name_table,eax
    ;export ordinal table
    mov     eax,tb
    mov     eax,[eax + 24h]
    add     eax,kn
    mov     ordinal,eax
    mov     edx,0
@@:
    mov     eax,name_table
    mov     ecx,[eax + edx * 4]
    add     ecx,kn
    inc     edx
    call isValid
    cmp eax,1
    jne @B
    dec edx
    mov     eax,ordinal
    xor     ecx,ecx
    mov     cx,[eax + edx * 2]
    mov     eax,ess
    mov     eax,[eax + ecx * 4]
    add     eax,kn
    ret 
fun_GetFunA endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


init_kernel32 proc
    ;查找&&存储kernel32.dll基地址
    local kernel,exportDir
    call fun_Getkernel32_t
    mov     kernel,eax

    ;查找&&存储引出目录表地址
    mov     eax,[eax + 3ch]
    add     eax,78h
    add     eax,kernel
    mov     eax,[eax]
    add     eax,kernel
    mov     exportDir,eax
   
    ;查找LoadLibraryW,GetProcAddress函数地址&&存储
    invoke fun_GetFunA,exportDir,isLoadLibrary,kernel
    mov     kernel32.LoadLibrary,eax

    invoke fun_GetFunA,exportDir,isGetProcAddress,kernel
    mov     kernel32.GetProcAddress,eax

    invoke fun_GetFunA,exportDir,isFreeLibrary,kernel
    mov     kernel32.FreeLibrary,eax
    invoke fun_GetFunA,exportDir,isExitProcess,kernel
    mov     kernel32.ExitProcess,eax
    ret
init_kernel32 endp

