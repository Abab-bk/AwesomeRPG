set WORKSPACE=.
set LUBAN_DLL=%WORKSPACE%\Tools\Luban\Luban.dll
set CONF_ROOT=.

dotnet %LUBAN_DLL% ^
    -t all ^
    -d json ^
    -c gdscript-json ^
    --conf %CONF_ROOT%\luban.conf ^
    -x outputDataDir=..\..\src\DataBase\output ^
    -x outputCodeDir=..\..\src\DataBase\OutputCode

pause