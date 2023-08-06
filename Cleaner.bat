@echo off

REM Define variables for the log file and temporary folder
set "LogFile=delete_temp_files_log.txt"
set "TempFolder=%temp%"

REM Clear the log file if it already exists
if exist "%LogFile%" del "%LogFile%"

REM Count the number of files and calculate storage before deletion
set "InitialFiles=0"
set "InitialSize=0"
for /R "%TempFolder%" %%i in (*) do (
    set /A "InitialFiles+=1"
    set /A "InitialSize+=%%~zi"
)

REM Delete the temporary files and log the actions
echo Files deleted: > "%LogFile%"

REM Delete all files and subdirectories in %temp%
for /D %%i in ("%TempFolder%\*") do (
    rd /S /Q "%%i" > nul 2>&1
    echo [DIR] %%i >> "%LogFile%"
)

for %%i in ("%TempFolder%\*.*") do (
    del "%%i" > nul 2>&1
    echo %%~nxi >> "%LogFile%"
)

REM Count the number of files and calculate storage after deletion
set "DeletedFiles=0"
set "DeletedSize=0"
for /R "%TempFolder%" %%i in (*) do (
    set /A "DeletedFiles+=1"
    set /A "DeletedSize+=%%~zi"
)

REM Calculate the total number of files and storage deleted
set /A "TotalFiles=InitialFiles - DeletedFiles"
set /A "TotalSize=InitialSize - DeletedSize"

REM Output results to the console
echo Deleted %TotalFiles% files, freeing %TotalSize% bytes of storage.

REM Write the total number of files and storage deleted to the log file
echo Deleted %TotalFiles% files, freeing %TotalSize% bytes of storage. >> "%LogFile%"

REM Pause to see the result in the console before closing
pause
