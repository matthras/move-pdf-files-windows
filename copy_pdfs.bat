@echo off
REM ============================================================
REM  copy_pdfs.bat
REM  Searches a source directory (and all its subdirectories)
REM  for PDF files and copies them into a destination directory.
REM  Generated using Claude.ai
REM ============================================================

REM SETLOCAL isolates variable changes so they don't leak out
REM into the parent command shell once the script finishes.
SETLOCAL

REM ---- CONFIGURATION ------------------------------------------------
REM Set SOURCE_DIR to the folder you want to search (includes subfolders).
SET "SOURCE_DIR=C:\path\to\source\directory"

REM Set DEST_DIR to the folder where matching PDFs should be copied.
SET "DEST_DIR=C:\path\to\destination\directory"
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
REM   /S  - copy files from subdirectories too (but skips empty folders)
REM   /I  - assume destination is a directory (avoids a prompt)
REM   /Y  - suppress overwrite confirmation prompts
REM   /H  - copy hidden and system files as well
REM   *.pdf - only match files with the .pdf extension
XCOPY "%SOURCE_DIR%\*.pdf" "%DEST_DIR%" /S /I /Y /H

REM Check the error level XCOPY returned.
REM 0 means success, anything else indicates a problem (e.g. no files found).
IF ERRORLEVEL 1 (
    ECHO No PDF files were found or an error occurred during copying.
) ELSE (
    ECHO PDF files copied successfully to "%DEST_DIR%".
)

:END
REM ENDLOCAL restores the previous environment (undoing SETLOCAL).
ENDLOCAL

REM PAUSE keeps the console window open so you can read the output
REM when the script is run by double-clicking it in Explorer.
PAUSE
