@echo off
@setlocal

set ND_CMD=C:\cygwin\home\jcolby.PW\NaturalDocs\NaturalDocs.bat

mkdir ..\doc\html

%ND_CMD% -i ..\doc -o HTML ..\doc\html -p . -s Default GUL

@endlocal
