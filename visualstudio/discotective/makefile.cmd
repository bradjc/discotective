@echo OFF
setlocal EnableDelayedExpansion


rem check that the given file exists
IF NOT EXIST "..\..\test\%1" GOTO ERR_BAD_INPUT

SET jpegname=%1
SET musicname=%jpegname:~0,-4%
SET txtname=%jpegname:~0,-5%

rem loop through and delete all old outimages
echo Deleting all old outimages
FOR /f %%a IN ('dir "outimage*.png" /b') DO (
	del %%a
)

echo Running Discotective
"./Debug/discotective.exe" "..\..\test\%jpegname%" > out_%musicname%.txt

echo Process output
"..\..\tools\sed.exe" -n "/^@\t.*/p" < out_%musicname%.txt | "..\..\tools\sed.exe" "s/^..//" > notes_%musicname%.txt
"..\..\tools\sed.exe" -n "/^@@\t.*/p" < out_%musicname%.txt | "..\..\tools\sed.exe" "s/^...//" > abc_%musicname%.txt

echo Create MIDI
"..\..\tools\abc2midi.exe" abc_%musicname%.txt -o %musicname%.mid

echo Create Sheet music PDF
"..\..\tools\abcm2ps.exe" abc_%musicname%.txt -O %musicname%.ps
"C:\Program Files (x86)\Adobe\Acrobat 9.0\Acrobat\acrodist.exe" --deletelog:on /N /Q /O %cd%/%musicname%.pdf %cd%/%musicname%.ps
del %musicname%.ps

echo Compare Notes to Correct Values
fc /n notes_%musicname%.txt "../../test/%txtname%.txt"

fc notes_%musicname%.txt "../../test/%txtname%.txt" | find "FC: no differences" > nul
if errorlevel 0 goto fcequal
"C:\Program Files (x86)\Adobe\Acrobat 9.0\Acrobat\Acrobat.exe" %musicname%.pdf
:fcequal

GOTO END





set imgname=lkfd
for /f %%a IN ('dir "..\..\test\*.jpg" /b') do (
	set musicname=%%a
	set musicname=!musicname:~0,-4!

rem	"./Debug/discotective.exe" "C:\Users\Brad\Desktop\eecs452\test\%%a" | "C:\Program Files\GnuWin32\bin\tee.exe" out_!musicname!.txt
	"./Debug/discotective.exe" "C:\Users\Brad\Desktop\eecs452\test\%%a" > out_!musicname!.txt
	
	"C:\Program Files\GnuWin32\bin\sed.exe" -n "/@@*/p" < out_!musicname!.txt | "C:\Program Files\GnuWin32\bin\sed.exe" "s/^...//" > notes_!musicname!.txt
	
rem	for /f "tokens=*" %%b in ('echo "../../test/!musicname!.txt" | "C:\Program Files\GnuWin32\bin\sed.exe" "s/\([\""\.\/a-z]*\)[0-9]*/\1/"') do (
rem		set num_stripped=%%b
rem	)

	
	fc notes_!musicname!.txt "../../test/!musicname:~0,-1!.txt"
	
	
)


rem "./Debug/discotective.exe" "C:\Users\Brad\Desktop\eecs452\test\sun1.jpg" | "C:\Program Files\GnuWin32\bin\tee.exe" out.txt

rem "C:\Program Files\GnuWin32\bin\sed.exe" -n "/@@*/p" < out.txt | "C:\Program Files\GnuWin32\bin\sed.exe" "s/^...//" > notes.txt

rem fc notes.txt "../../test/sun.txt"


:ERR_BAD_INPUT
echo %1 does not exist

:END
