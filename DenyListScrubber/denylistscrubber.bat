@echo off
:runProgram
set /p "folderPath=Enter the path to the folder you wish to clean: "
set "denyList=%~dp0denylist.txt"

REM Display purge and deny list information for confirmation.
echo Path to Folder to be Purged: "%folderPath%"
echo Deny List: "%denyList%"
echo Please note that ANY files (not folders) not included in denylist.txt WILL be deleted!

REM Prompt the user for confirmation before proceeding, safety!
set /p confirm="Do you want to proceed with deletion? (Y/N): "
if /i not "%confirm%"=="Y" (
    echo Process aborted.
    pause
    goto runProgram
)

REM Change to the specified folder path. If the folder doesn't exist, exit the script!
cd /d "%folderPath%" || (
    echo Folder not found: "%folderPath%"
    goto runProgram
)

REM Check if the deny list file exists.
if not exist "%denyList%" (
    echo Deny list file not found: "%denyList%"
    goto runProgram
)

REM Initialize a variable to count the number of deleted files.
set /a deletedCount=0

REM Loop through each file in the folder.
for %%F in (*) do (
    REM Check if the file is not in the deny list.
    findstr /i /c:"%%F" "%denyList%" >nul || (
        echo Deleting: "%%F"
        del "%%F"
        set /a deletedCount+=1
    )
)

echo %deletedCount% files deleted.

REM Count and display the number of remaining items inside the folder.
set /a remainingCount=0
for %%A in (*) do set /a remainingCount+=1

echo %remainingCount% items remaining in the folder. 

REM Prompt the user to run the program again or exit.
set /p runAgain="Do you want to run the program again? (Y/N): "
if /i "%runAgain%"=="Y" goto runProgram

echo Process complete. You may now exit.

REM Author: MaruMaru
pause