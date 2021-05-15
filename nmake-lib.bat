:: Keystone assembler engine (www.keystone-engine.org)
:: Build Keystone static library (keystone.lib) on Windows with CMake & Nmake
:: By Nguyen Anh Quynh, 2016

:: This generates .\llvm\lib\keystone.lib
:: Usage: nmake-dll.bat [x86 arm aarch64 m68k mips sparc], default build all.

@echo off

set flags="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF"

set allparams=

:loop
set str=%1
if "%str%"=="" (
    goto end
)
set allparams=%allparams% %str%
shift /0
goto loop

:end
if "%allparams%"=="" (
    goto eof
)
:: remove left, right blank
:intercept_left
if "%allparams:~0,1%"==" " set "allparams=%allparams:~1%" & goto intercept_left

:intercept_right
if "%allparams:~-1%"==" " set "allparams=%allparams:~0,-1%" & goto intercept_right

:eof

if "%allparams%"=="" (
cmake "%flags%" -DLLVM_TARGETS_TO_BUILD="all" -G "Ninja" ..
) else (
cmake "%flags%" "-DLLVM_TARGETS_TO_BUILD=%allparams%" -G "Ninja" ..
)

ninja

