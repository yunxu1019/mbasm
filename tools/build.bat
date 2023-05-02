@echo off
@chcp 65001
setlocal
pushd
cd %~dp0..
set filepath=%1
if "%filepath%"=="" set filepath="blink.asm"
if "%filepath:~1,-1%"==%filepath% set filepath=%filepath:~1,-1%
set extname=%filepath:~-3%
set filename=%filepath:~0,-3%
if "%extname%"=="asm" goto :jsend
set filename=%filename%.
call efront tools\precode.js "%filename%js"
:jsend

call efront build "apps\%filename%asm"
if not exist "public\%filename%asm" goto :end
set masm32=.\masm32
set include=.\coms;%masm32%\include;%masm32%\macros;
set lib=.\coms;%masm32%\lib;
set bin=%masm32%\bin
call %bin%\ml /c /coff "public\%filename%asm"
:mlend
if not %errorlevel% equ 0 goto :end
%bin%\link /subsystem:windows "%filename%obj"
del "public\%filename%asm"
del "%filename%obj"
move "%filename%exe" public\
copy "dlls\miniblink_4949_x32.dll" public\
set udd="d:\prog\OllyDbg\%filename%udd"
if exist "%udd%" del "%udd%"
:end
endlocal
popd