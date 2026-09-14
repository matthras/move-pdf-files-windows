@echo off
REM ============================================================
REM  copy_pdfs.bat
REM  Searches a source directory (and all its subdirectories)
REM  for PDF files and copies them into a destination directory.
REM ============================================================

REM SETLOCAL isolates variable changes so they don't leak out
REM into the parent command shell once the script finishes.
SETLOCAL

REM ---- CONFIGURATION ------------------------------------------------
REM Set SOURCE_DIR to the folder you want to search (includes subfolders).
SET "SOURCE_DIR=C:\Users\a2924658\Zotero\storage"

REM Set DEST_DIR to the folder where matching PDFs should be copied.
SET "DEST_DIR=C:\Users\a2924658\Dropbox\ZoteroPDFs"
REM ---------------------------------------------------------------------

REM Check that the source directory actually exists before doing anything.
REM If it doesn't, print an error message and exit the script.
IF NOT EXIST "%SOURCE_DIR%" (
    ECHO Source directory "%SOURCE_DIR%" does not exist.
    GOTO :END
)

REM Create the destination directory if it doesn't already exist.
REM MKDIR will fail harmlessly if the folder is already there,
REM so we guard it with an EXIST check to avoid an error message.
IF NOT EXIST "%DEST_DIR%" (
    MKDIR "%DEST_DIR%"
)

REM ---- MAIN COPY OPERATION --------------------------------------------
REM XCOPY switches used:
REM   /I  - assume destination is a directory (avoids a prompt)
REM   /Y  - suppress overwrite confirmation prompts
REM   /H  - copy hidden and system files as well
REM   *.pdf - only match files with the .pdf extension
REM   /R loop to walk every subdirectory ourselves and COPY each
REM   matching file directly into DEST_DIR, ignoring where it came from.
REM   This "flattens" all PDFs into a single, bottom-level folder.

REM Track whether we found anything, so we can report accurately at the end.
SET FOUND_ANY=0
 
REM FOR /R "%SOURCE_DIR%" %%F IN (*.pdf) recurses into every subdirectory
REM under SOURCE_DIR and iterates over each file matching *.pdf.
REM %%F is set to the FULL PATH of each matching PDF in turn.
FOR /R "%SOURCE_DIR%" %%F IN (*.pdf) DO (
    SET FOUND_ANY=1
    REM /Y suppresses the "overwrite?" prompt if a same-named file already
    REM exists in DEST_DIR (e.g. two different subfolders both had "paper.pdf").
    REM %%~nxF extracts just the file name + extension (no path) from %%F,
    REM so the destination copy always lands directly in DEST_DIR itself.
    COPY /Y "%%F" "%DEST_DIR%\%%~nxF" >NUL
    ECHO Copied: %%~nxF
)
 
REM Report whether anything was actually found and copied.
IF "%FOUND_ANY%"=="0" (
    ECHO No PDF files were found under "%SOURCE_DIR%".
) ELSE (
    ECHO.
    ECHO All PDF files copied successfully into "%DEST_DIR%" ^(flattened, no subfolders^).
)

:END
REM ENDLOCAL restores the previous environment (undoing SETLOCAL).
ENDLOCAL

REM PAUSE keeps the console window open so you can read the output
REM when the script is run by double-clicking it in Explorer.
PAUSE
