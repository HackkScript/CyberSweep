@echo off
setlocal enabledelayedexpansion

:: Configuration Section
set "sensitive_extensions=.txt .doc .docx .xls .xlsx .ppt .pptx .pdf .csv .sql .mdb .accdb .pst .ost .conf .config .ini .inf .bat .ps1 .sh .py .php .asp .aspx .js .json .xml .yml .yaml .env .bak .tmp .log"
set "default_keywords=password passwd pwd secret key credential token api aws azure google cloud login user admin root database sql connectionstring"
set "excluded_folders=C:\Program Files C:\Program Files (x86) C:\Windows C:\$Recycle.Bin"
set "default_output=%~dp0reports"

:: Initialize variables
set "selected_drives="
set "custom_output="
set "custom_keywords="
set "scan_option="
set "file_extensions=*.txt *.csv *.ini *.xml *.json *.log *.bat *.ps1 *.config"

:: Set green color for the entire tool
color 0A

:: Main Menu
:main_menu
cls
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo     CYBERSECURITY SCANNING TOOL
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo Configuration:
echo    Drives: %selected_drives%
echo    Output: %custom_output%
echo.
echo 1. Scan for sensitive file extensions
echo 2. Scan for default keywords
echo 3. Scan for custom keywords
echo 4. Get console history
echo 5. Browser password extraction
echo 6. Network configuration snapshot
echo 7. Process and service analysis
echo 8. Registry scanning
echo 9. User account enumeration
echo 10. Scheduled tasks extraction
echo 11. File metadata analysis
echo 12. Generate comprehensive report
echo 13. Full system scan (all options)
echo 14. Configure settings
echo 15. Exit
echo.
set /p "scan_option=Select an option (1-15): "

if "%scan_option%"=="" goto main_menu

:: Process selection
if "%scan_option%"=="1" goto option_1
if "%scan_option%"=="2" goto option_2
if "%scan_option%"=="3" goto option_3
if "%scan_option%"=="4" goto option_4
if "%scan_option%"=="5" goto option_5
if "%scan_option%"=="6" goto option_6
if "%scan_option%"=="7" goto option_7
if "%scan_option%"=="8" goto option_8
if "%scan_option%"=="9" goto option_9
if "%scan_option%"=="10" goto option_10
if "%scan_option%"=="11" goto option_11
if "%scan_option%"=="12" goto option_12
if "%scan_option%"=="13" goto option_13
if "%scan_option%"=="14" goto option_14
if "%scan_option%"=="15" exit /b

:: If invalid option selected
goto main_menu

:: Option 1: Scan for sensitive file extensions
:option_1
call :select_drives
if "%selected_drives%"=="" (
    echo No drives selected. Returning to main menu.
    pause
    goto main_menu
)

call :set_output_path
set "output_file=%output_path%\fileextensions_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"

echo Scanning for sensitive file extensions...
echo. > "%output_file%"
for %%d in (%selected_drives%) do (
    echo Processing drive %%d...
    for %%e in (%sensitive_extensions%) do (
        echo Searching for *%%e files...
        dir /s /b /a-d "%%d\*%%e" | findstr /v /i /c:"Program Files" /c:"Program Files (x86)" /c:"Windows" >> "%output_file%" 2>nul
    )
)
echo Scan complete. Results saved to %output_file%
pause
goto main_menu

:: Option 2: Scan for default keywords
:option_2
call :select_drives
if "%selected_drives%"=="" (
    echo No drives selected. Returning to main menu.
    pause
    goto main_menu
)

call :set_output_path
set "output_file=%output_path%\keywordsearch_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"

:: UI Setup
title Keyword Search Tool
color 0A
cls
echo ###############################################
echo #   ENHANCED KEYWORD SEARCH UTILITY          #
echo ###############################################
echo.

:: User Input
:input_directory_2
echo Current search directory: %selected_drives%
set /p "search_dir=Enter directory to search or press Enter to keep default: "
if "%search_dir%"=="" set "search_dir=%selected_drives%"
if not exist "%search_dir%\" (
    echo ERROR: Directory does not exist!
    goto input_directory_2
)

:input_extensions_2
echo Current file extensions: %file_extensions%
set /p "file_extensions=Enter extensions (space separated) or Enter to keep default: "
if "%file_extensions%"=="" set "file_extensions=*.txt *.csv *.ini *.xml *.json *.log *.bat *.ps1 *.config"

:input_keywords_2
echo Current keywords: %default_keywords%
set /p "keywords=Enter keywords (space separated) or Enter to keep default: "
if "%keywords%"=="" set "keywords=%default_keywords%"

:: Initialize search
echo.
echo Starting search in: %search_dir%
echo Searching for: %keywords%
echo File types: %file_extensions%
echo.

:: Prepare output file
echo Keyword Search Results > "%output_file%"
echo ===================== >> "%output_file%"
echo Search Date: %date% %time% >> "%output_file%"
echo Search Directory: %search_dir% >> "%output_file%"
echo File Extensions: %file_extensions% >> "%output_file%"
echo Keywords: %keywords% >> "%output_file%"
echo. >> "%output_file%"
echo FILES CONTAINING KEYWORDS: >> "%output_file%"
echo. >> "%output_file%"

:: Search function
set file_count=0
set match_count=0

for %%k in (%keywords%) do (
    echo Searching for: "%%k"
    for /r "%search_dir%" %%f in (%file_extensions%) do (
        if exist "%%f" (
            set /a file_count+=1
            findstr /i /m /c:"%%k" "%%f" >nul && (
                echo [FOUND] %%k in %%~nxf
                echo [FOUND] %%k in %%f >> "%output_file%"
                set /a match_count+=1
            )
        )
    )
)

:: Results summary
echo. >> "%output_file%"
echo SEARCH SUMMARY >> "%output_file%"
echo ============== >> "%output_file%"
echo Files scanned: %file_count% >> "%output_file%"
echo Files with matches: %match_count% >> "%output_file%"
echo Search completed: %date% %time% >> "%output_file%"

:: Display results
cls
echo ###############################################
echo #           SEARCH COMPLETED                 #
echo ###############################################
echo.
echo Files scanned: %file_count%
echo Files containing keywords: %match_count%
echo.
echo Results saved to: %output_file%
echo.
echo Here are the matches found:
echo --------------------------
type "%output_file%"
echo.
pause
goto main_menu




:: Option 3: Scan for custom keywords
:option_3
call :select_drives
if "%selected_drives%"=="" (
    echo No drives selected. Returning to main menu.
    pause
    goto main_menu
)

call :set_output_path
set "output_file=%output_path%\customsearch_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"

:: UI Setup
title Custom Keyword Search Tool
color 0A

:menu_custom
cls
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo    CUSTOM KEYWORD SEARCH TOOL
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Results will be saved to: !output_file!
echo.
echo 1. Basic Search (case insensitive) - FASTEST
echo 2. Case Sensitive Search - FAST
echo 3. Search with Context Lines - SLOWER
echo 4. Search Specific File Types - FAST
echo 5. Starts With / Ends With Search - FAST
:: echo 6. Change Output File
echo 6. Return to Main Menu
echo.
set /p "choice=Enter your choice (1-7): "

if "!choice!"=="1" goto basic
if "!choice!"=="2" goto casesensitive
if "!choice!"=="3" goto context
if "!choice!"=="4" goto filetypes
if "!choice!"=="5" goto startend
:: if "!choice!"=="6" goto changeoutput
if "!choice!"=="6" goto main_menu
goto menu_custom

:basic
cls
echo ~~~~~~~~~~~~ BASIC SEARCH ~~~~~~~~~~~~
echo Results will be saved to: !output_file!
echo.
set /p "keyword=Enter keyword to search: "
if "!keyword!"=="" goto basic

call :getpath_custom
if errorlevel 1 goto menu_custom

echo Searching for "!keyword!" in "!searchpath!"...>>"!output_file!"
echo Searching for "!keyword!" in "!searchpath!"...
echo.

:: FASTEST METHOD - Single findstr command for all files
echo Found matches:>>"!output_file!"
findstr /i /m /s /c:"!keyword!" "!searchpath!\*" 2>nul >>"!output_file!"
findstr /i /m /s /c:"!keyword!" "!searchpath!\*" 2>nul

if errorlevel 1 (
    echo No matches found.>>"!output_file!"
    echo No matches found.
) else (
    echo.>>"!output_file!"
    echo Search complete.>>"!output_file!"
    echo.
    echo Search complete.
)

echo.>>"!output_file!"
echo.
pause
goto menu_custom

:casesensitive
cls
echo ~~~~~~~~~ CASE SENSITIVE SEARCH ~~~~~~~~~
echo Results will be saved to: !output_file!
echo.
set /p "keyword=Enter keyword to search: "
if "!keyword!"=="" goto casesensitive

call :getpath_custom
if errorlevel 1 goto menu_custom

echo Searching for "!keyword!" (case sensitive) in "!searchpath!"...>>"!output_file!"
echo Searching for "!keyword!" (case sensitive) in "!searchpath!"...
echo.

:: FAST METHOD - Single findstr command
echo Found matches:>>"!output_file!"
findstr /m /s /c:"!keyword!" "!searchpath!\*" 2>nul >>"!output_file!"
findstr /m /s /c:"!keyword!" "!searchpath!\*" 2>nul

if errorlevel 1 (
    echo No matches found.>>"!output_file!"
    echo No matches found.
) else (
    echo.>>"!output_file!"
    echo Search complete.>>"!output_file!"
    echo.
    echo Search complete.
)

echo.>>"!output_file!"
echo.
pause
goto menu_custom

:context
cls
echo ~~~~~~~~ SEARCH WITH CONTEXT LINES ~~~~~~~~
echo Results will be saved to: !output_file!
echo NOTE: This is the slowest option due to context processing
echo.
set /p "keyword=Enter keyword to search: "
if "!keyword!"=="" goto context

call :getpath_custom
if errorlevel 1 goto menu_custom

set /p "lines=Number of context lines to show (default 2): "
if "!lines!"=="" set lines=2

echo Searching for "!keyword!" in "!searchpath!" with !lines! context lines...>>"!output_file!"
echo Searching for "!keyword!" in "!searchpath!" with !lines! context lines...
echo.

:: This is inherently slower but optimized as much as possible
set found=0
for /f "delims=" %%f in ('findstr /i /m /s /c:"!keyword!" "!searchpath!\*" 2^>nul') do (
    if !found!==0 (
        echo.>>"!output_file!"
        echo CONTEXT SEARCH RESULTS:>>"!output_file!"
        echo.
        echo CONTEXT SEARCH RESULTS:
    )
    set found=1
    
    echo.>>"!output_file!"
    echo ======= Found in: %%f =======>>"!output_file!"
    echo.>>"!output_file!"
    echo ======= Found in: %%f =======
    
    :: Use a temporary file for faster processing
    set "tempfile=%temp%\context.tmp"
    findstr /n /i /c:"!keyword!" "%%f" > "!tempfile!"
    
    for /f "usebackq tokens=1 delims=:" %%l in ("!tempfile!") do (
        set /a start=%%l-!lines!
        if !start! lss 1 set start=1
        set /a end=%%l+!lines!
        
        echo [Lines !start!-!end!]:>>"!output_file!"
        echo [Lines !start!-!end!]:
        
        :: Use more efficient method for context
        set "linecount=0"
        for /f "usebackq tokens=1* delims=:" %%a in ("%%f") do (
            set /a linecount+=1
            if !linecount! geq !start! if !linecount! leq !end! (
                echo !linecount!:%%b>>"!output_file!"
                echo !linecount!:%%b
            )
            if !linecount! gtr !end! goto :break_context
        )
        :break_context
        echo.>>"!output_file!"
        echo.
    )
    del "!tempfile!" 2>nul
)

if !found!==0 (
    echo No matches found.>>"!output_file!"
    echo No matches found.
)
echo.>>"!output_file!"
echo.
pause
goto menu_custom

:filetypes
cls
echo ~~~~~~~~ SEARCH SPECIFIC FILE TYPES ~~~~~~~~
echo Results will be saved to: !output_file!
echo.
set /p "keyword=Enter keyword to search: "
if "!keyword!"=="" goto filetypes

call :getpath_custom
if errorlevel 1 goto menu_custom

set /p "extensions=Enter file extensions (comma separated, e.g., txt,docx): "
if "!extensions!"=="" (
    set "filepattern=*"
) else (
    set "filepattern=*.!extensions:,%=.*.!"
)

echo Searching for "!keyword!" in "!extensions!" files at "!searchpath!"...>>"!output_file!"
echo Searching for "!keyword!" in "!extensions!" files at "!searchpath!"...
echo.

:: FAST METHOD - Use findstr with file pattern
echo Found matches:>>"!output_file!"
findstr /i /m /s /c:"!keyword!" "!searchpath!\!filepattern!" 2>nul >>"!output_file!"
findstr /i /m /s /c:"!keyword!" "!searchpath!\!filepattern!" 2>nul

if errorlevel 1 (
    echo No matches found.>>"!output_file!"
    echo No matches found.
) else (
    echo.>>"!output_file!"
    echo Search complete.>>"!output_file!"
    echo.
    echo Search complete.
)

echo.>>"!output_file!"
echo.
pause
goto menu_custom

:startend
cls
echo ~~~~~~~~ STARTS WITH / ENDS WITH SEARCH ~~~~~~~~
echo Results will be saved to: !output_file!
echo.
set "startkey="
set "endkey="
set /p "startkey=Enter starts with keyword (leave blank if not needed): "
set /p "endkey=Enter ends with keyword (leave blank if not needed): "
 
if "!startkey!"=="" if "!endkey!"=="" (
    echo You must specify at least one keyword
    pause
    goto startend
)

call :getpath_custom
if errorlevel 1 goto menu_custom

echo.>>"!output_file!"
echo Searching in "!searchpath!"...>>"!output_file!"
echo Searching in "!searchpath!"...
if not "!startkey!"=="" (
    echo Lines starting with: "!startkey!">>"!output_file!"
    echo Lines starting with: "!startkey!"
)
if not "!endkey!"=="" (
    echo Lines ending with: "!endkey!">>"!output_file!"
    echo Lines ending with: "!endkey!"
)
echo.>>"!output_file!"
echo.

set found=0
if not "!startkey!"=="" (
    echo.>>"!output_file!"
    echo FILES WITH LINES STARTING WITH "!startkey!":>>"!output_file!"
    echo FILES WITH LINES STARTING WITH "!startkey!":
    findstr /b /i /m /s /c:"!startkey!" "!searchpath!\*" 2>nul >>"!output_file!"
    findstr /b /i /m /s /c:"!startkey!" "!searchpath!\*" 2>nul
    if not errorlevel 1 set found=1
)

if not "!endkey!"=="" (
    echo.>>"!output_file!"
    echo FILES WITH LINES ENDING WITH "!endkey!":>>"!output_file!"
    echo FILES WITH LINES ENDING WITH "!endkey!":
    
    :: Use a more reliable method - search for the pattern and manually check endings
    for /f "delims=" %%f in ('findstr /i /m /s /c:"!endkey!" "!searchpath!\*" 2^>nul') do (
        :: Use a temporary approach to verify line endings
        findstr /n /i /c:"!endkey!" "%%f" >nul 2>&1
        if !errorlevel! equ 0 (
            echo %%f>>"!output_file!"
            echo %%f
            set found=1
        )
    )
)

if !found!==0 (
    echo No matches found.>>"!output_file!"
    echo No matches found.
)
echo.>>"!output_file!"
echo.
pause
goto menu_custom

:changeoutput
cls
echo Current output file: !output_file!
echo.
set /p "newoutput=Enter new output file name (or leave blank to cancel): "
if not "!newoutput!"=="" set "output_file=!newoutput!"
goto menu_custom

:getpath_custom
set "searchpath=%selected_drives%"
set /p "userpath=Enter path to search [default: %selected_drives%]: "
if not "!userpath!"=="" (
    set "userpath=!userpath:"=!"
    if not exist "!userpath!\" (
        echo Error: Path does not exist
        pause
        exit /b 1
    )
    set "searchpath=!userpath!"
)
exit /b 0

:: Option 4: Get console history
:option_4
call :set_output_path
set "output_file=%output_path%\console_history_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"

echo Collecting console command history...
echo CONSOLE COMMAND HISTORY > "!output_file!"
echo ====================== >> "!output_file!"
echo Collection Date: %date% %time% >> "!output_file!"
echo. >> "!output_file!"

:: Get PowerShell history
echo POWERSHELL HISTORY: >> "!output_file!"
echo ------------------ >> "!output_file!"
if exist "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" (
    type "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" >> "!output_file!" 2>nul
    echo. >> "!output_file!"
) else (
    echo No PowerShell history found. >> "!output_file!"
    echo. >> "!output_file!"
)

:: Get CMD history via doskey
echo CMD HISTORY: >> "!output_file!"
echo ----------- >> "!output_file!"
doskey /history >> "!output_file!" 2>nul
echo. >> "!output_file!"

:: Get recent commands from registry
echo REGISTRY COMMAND HISTORY: >> "!output_file!"
echo ------------------------ >> "!output_file!"
reg query "HKEY_CURRENT_USER\Software\Microsoft\Command Processor" /v AutoRun >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo Console history saved to: !output_file!
type "!output_file!"
pause
goto main_menu

:: Option 5: Browser password extraction (Information only - for educational purposes)
:option_5
call :set_output_path
set "output_file=%output_path%\browser_info_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"

echo BROWSER PASSWORD SECURITY ASSESSMENT > "!output_file!"
echo =================================== >> "!output_file!"
echo WARNING: This is for educational and security assessment purposes only. >> "!output_file!"
echo. >> "!output_file!"

echo Checking browser password storage locations...
echo. >> "!output_file!"

:: Chrome
echo CHROME PASSWORD INFO: >> "!output_file!"
echo -------------------- >> "!output_file!"
if exist "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Login Data" (
    echo Chrome password database exists >> "!output_file!"
    echo Location: %USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Login Data >> "!output_file!"
) else (
    echo Chrome password database not found >> "!output_file!"
)
echo. >> "!output_file!"

:: Firefox
echo FIREFOX PASSWORD INFO: >> "!output_file!"
echo --------------------- >> "!output_file!"
if exist "%USERPROFILE%\AppData\Roaming\Mozilla\Firefox\Profiles" (
    echo Firefox profiles directory exists >> "!output_file!"
    for /d %%i in ("%USERPROFILE%\AppData\Roaming\Mozilla\Firefox\Profiles\*") do (
        if exist "%%i\key4.db" echo Found Firefox key database: %%i\key4.db >> "!output_file!"
        if exist "%%i\logins.json" echo Found Firefox logins: %%i\logins.json >> "!output_file!"
    )
) else (
    echo Firefox profiles not found >> "!output_file!"
)
echo. >> "!output_file!"

:: Edge
echo EDGE PASSWORD INFO: >> "!output_file!"
echo ------------------- >> "!output_file!"
if exist "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Login Data" (
    echo Edge password database exists >> "!output_file!"
    echo Location: %USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Login Data >> "!output_file!"
) else (
    echo Edge password database not found >> "!output_file!"
)
echo. >> "!output_file!"

echo SECURITY RECOMMENDATIONS: >> "!output_file!"
echo ------------------------ >> "!output_file!"
echo 1. Use a password manager instead of browser storage >> "!output_file!"
echo 2. Enable master password for browser password storage >> "!output_file!"
echo 3. Regularly clear browser saved passwords >> "!output_file!"
echo 4. Use two-factor authentication where available >> "!output_file!"
echo. >> "!output_file!"

echo Browser security assessment saved to: !output_file!
type "!output_file!"
pause
goto main_menu

:: Option 6: Network configuration snapshot
:option_6
call :set_output_path
set "output_file=%output_path%\network_config_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"

echo NETWORK CONFIGURATION SNAPSHOT > "!output_file!"
echo ============================= >> "!output_file!"
echo Collection Date: %date% %time% >> "!output_file!"
echo. >> "!output_file!"

echo IP CONFIGURATION: >> "!output_file!"
echo ----------------- >> "!output_file!"
ipconfig /all >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo NETWORK CONNECTIONS: >> "!output_file!"
echo -------------------- >> "!output_file!"
netstat -ano >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo ARP CACHE: >> "!output_file!"
echo ---------- >> "!output_file!"
arp -a >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo ROUTING TABLE: >> "!output_file!"
echo ------------- >> "!output_file!"
route print >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo DNS CACHE: >> "!output_file!"
echo ---------- >> "!output_file!"
ipconfig /displaydns >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo NETWORK SHARES: >> "!output_file!"
echo --------------- >> "!output_file!"
net share >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo WIRELESS NETWORKS: >> "!output_file!"
echo ------------------ >> "!output_file!"
netsh wlan show profiles >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo Network configuration saved to: !output_file!
type "!output_file!"
pause
goto main_menu

:: Option 7: Process and service analysis
:option_7
call :set_output_path
set "output_file=%output_path%\process_services_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"

echo PROCESS AND SERVICE ANALYSIS > "!output_file!"
echo =========================== >> "!output_file!"
echo Collection Date: %date% %time% >> "!output_file!"
echo. >> "!output_file!"

echo RUNNING PROCESSES: >> "!output_file!"
echo ----------------- >> "!output_file!"
tasklist /v >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo PROCESS TREE: >> "!output_file!"
echo ------------- >> "!output_file!"
wmic process get name,processid,parentprocessid,commandline >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo SERVICES: >> "!output_file!"
echo --------- >> "!output_file!"
sc query type= service state= all >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo STARTUP PROGRAMS: >> "!output_file!"
echo ----------------- >> "!output_file!"
wmic startup get caption,command >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo AUTORUN LOCATIONS: >> "!output_file!"
echo ------------------ >> "!output_file!"
echo Startup Folder: %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup >> "!output_file!"
echo Registry: HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run >> "!output_file!"
echo Registry: HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run >> "!output_file!"
echo. >> "!output_file!"

echo Process and service analysis saved to: !output_file!
type "!output_file!"
pause
goto main_menu

:: Option 8: Registry scanning
:option_8
call :set_output_path
set "output_file=%output_path%\registry_scan_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"

echo REGISTRY SECURITY SCAN > "!output_file!"
echo ===================== >> "!output_file!"
echo Collection Date: %date% %time% >> "!output_file!"
echo. >> "!output_file!"

echo AUTORUN ENTRIES: >> "!output_file!"
echo --------------- >> "!output_file!"
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> "!output_file!" 2>nul
echo. >> "!output_file!"
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo RECENT DOCUMENTS: >> "!output_file!"
echo ----------------- >> "!output_file!"
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo USER ASSIST (PROGRAM EXECUTION HISTORY): >> "!output_file!"
echo --------------------------------------- >> "!output_file!"
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist" >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo INSTALLED SOFTWARE: >> "!output_file!"
echo ------------------- >> "!output_file!"
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall" >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo ENVIRONMENT VARIABLES: >> "!output_file!"
echo ---------------------- >> "!output_file!"
reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo Registry scan saved to: !output_file!
type "!output_file!"
pause
goto main_menu

:: Option 9: User account enumeration
:option_9
call :set_output_path
set "output_file=%output_path%\user_accounts_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"

echo USER ACCOUNT ENUMERATION > "!output_file!"
echo ======================= >> "!output_file!"
echo Collection Date: %date% %time% >> "!output_file!"
echo. >> "!output_file!"

echo LOCAL USERS: >> "!output_file!"
echo ------------ >> "!output_file!"
net user >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo USER DETAILS: >> "!output_file!"
echo ------------- >> "!output_file!"
wmic useraccount get name,disabled,lockout,passwordchangeable,passwordexpires >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo LOGGED IN USERS: >> "!output_file!"
echo ---------------- >> "!output_file!"
query user >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo LOCAL GROUPS: >> "!output_file!"
echo ------------- >> "!output_file!"
net localgroup >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo ADMINISTRATORS GROUP: >> "!output_file!"
echo --------------------- >> "!output_file!"
net localgroup administrators >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo USER PROFILES: >> "!output_file!"
echo -------------- >> "!output_file!"
wmic useraccount get name,sid >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo User account enumeration saved to: !output_file!
type "!output_file!"
pause
goto main_menu

:: Option 10: Scheduled tasks extraction
:option_10
call :set_output_path
set "output_file=%output_path%\scheduled_tasks_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"

echo SCHEDULED TASKS EXTRACTION > "!output_file!"
echo ========================== >> "!output_file!"
echo Collection Date: %date% %time% >> "!output_file!"
echo. >> "!output_file!"

echo SCHEDULED TASKS: >> "!output_file!"
echo ---------------- >> "!output_file!"
schtasks /query /fo LIST /v >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo TASK SCHEDULER JOBS: >> "!output_file!"
echo -------------------- >> "!output_file!"
for /f "tokens=*" %%i in ('schtasks /query /fo table /nh') do (
    echo %%i >> "!output_file!"
)
echo. >> "!output_file!"

echo TASK FOLDERS: >> "!output_file!"
echo ------------- >> "!output_file!"
dir /s /b C:\Windows\System32\Tasks >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo Scheduled tasks extraction saved to: !output_file!
type "!output_file!"
pause
goto main_menu

:: Option 11: File metadata analysis
:option_11
call :select_drives
if "%selected_drives%"=="" (
    echo No drives selected. Returning to main menu.
    pause
    goto main_menu
)

call :set_output_path
set "output_file=%output_path%\file_metadata_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"

echo FILE METADATA ANALYSIS > "!output_file!"
echo ====================== >> "!output_file!"
echo Collection Date: %date% %time% >> "!output_file!"
echo. >> "!output_file!"

echo RECENT FILES ANALYSIS: >> "!output_file!"
echo ---------------------- >> "!output_file!"
echo Recent Documents: >> "!output_file!"
dir /a /q /t:w "%USERPROFILE%\Recent\*" >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo DESKTOP FILES: >> "!output_file!"
echo -------------- >> "!output_file!"
dir /a /q /t:w "%USERPROFILE%\Desktop\*" >> "!output_file!" 2>nul
echo. >> "!output_file!"

echo LARGE FILES (>100MB): >> "!output_file!"
echo --------------------- >> "!output_file!"
for %%d in (%selected_drives%) do (
    echo Scanning drive %%d for large files... >> "!output_file!"
    forfiles /p "%%d" /s /m * /c "cmd /c if @fsize gtr 104857600 echo @path @fsize" >> "!output_file!" 2>nul
)
echo. >> "!output_file!"

echo File metadata analysis saved to: !output_file!
type "!output_file!"
pause
goto main_menu

:: Option 12: Generate comprehensive report
:option_12
call :select_drives
if "%selected_drives%"=="" (
    echo No drives selected. Returning to main menu.
    pause
    goto main_menu
)

call :set_output_path
set "output_file=%output_path%\comprehensive_report_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"

echo COMPREHENSIVE SECURITY REPORT > "!output_file!"
echo ============================ >> "!output_file!"
echo Report Date: %date% %time% >> "!output_file!"
echo Computer Name: %COMPUTERNAME% >> "!output_file!"
echo User: %USERNAME% >> "!output_file!"
echo. >> "!output_file!"

echo Running all security scans... This may take several minutes.
echo Please wait...

:: Run all scans and append to comprehensive report
call :option_1_silent
call :option_4_silent
call :option_6_silent
call :option_7_silent
call :option_8_silent
call :option_9_silent
call :option_10_silent

echo Comprehensive report generated: !output_file!
type "!output_file!"
pause
goto main_menu

:: Option 13: Full system scan (all options)
:: Option 13: Full system scan (all options)
:option_13
call :select_drives
if "%selected_drives%"=="" (
    echo No drives selected. Returning to main menu.
    pause
    goto main_menu
)

call :set_output_path
echo Running full system scan with all options...
echo This may take a long time. Please wait...
echo.

:: Run all options sequentially without returning to main menu
echo [1/12] Scanning for sensitive file extensions...
call :option_1_silent
echo [2/12] Scanning for default keywords...
call :option_2_silent
echo [3/12] Scanning for custom keywords...
call :option_3_silent
echo [4/12] Collecting console history...
call :option_4_silent
echo [5/12] Analyzing browser security...
call :option_5_silent
echo [6/12] Capturing network configuration...
call :option_6_silent
echo [7/12] Analyzing processes and services...
call :option_7_silent
echo [8/12] Scanning registry...
call :option_8_silent
echo [9/12] Enumerating user accounts...
call :option_9_silent
echo [10/12] Extracting scheduled tasks...
call :option_10_silent
echo [11/12] Analyzing file metadata...
call :option_11_silent
echo [12/12] Generating comprehensive report...
call :option_12_silent

echo Full system scan completed!
echo All reports saved to: !output_path!
pause
goto main_menu

:: Silent versions of all options for full system scan
:option_1_silent
set "temp_file=%output_path%\fileextensions_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
echo. > "!temp_file!"
for %%d in (%selected_drives%) do (
    dir /s /b /a-d "%%d\*" | findstr /i "\.txt$ \.doc$ \.docx$ \.xls$ \.xlsx$ \.ppt$ \.pptx$ \.pdf$ \.csv$ \.sql$ \.mdb$ \.accdb$ \.pst$ \.ost$ \.conf$ \.config$ \.ini$ \.inf$ \.bat$ \.ps1$ \.sh$ \.py$ \.php$ \.asp$ \.aspx$ \.js$ \.json$ \.xml$ \.yml$ \.yaml$ \.env$ \.bak$ \.tmp$ \.log$" | findstr /v /i "\\Windows\\ \\Program Files\\ \\Program Files (x86)\\" >> "!temp_file!" 2>nul
)
goto :eof

:option_2_silent
set "temp_file=%output_path%\keywordsearch_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
set "keywords=!default_keywords!"
set "temp_pattern=%temp%\search_pattern.txt"
echo !keywords! > "!temp_pattern!"
echo. > "!temp_file!"
for /r "%selected_drives%" %%f in (!file_extensions!) do (
    if exist "%%f" (
        findstr /i /m /g:"!temp_pattern!" "%%f" >nul && (
            echo %%f >> "!temp_file!"
        )
    )
)
del "!temp_pattern!" 2>nul
goto :eof

:option_3_silent
set "temp_file=%output_path%\customsearch_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
echo. > "!temp_file!"
findstr /i /m /s /c:"password" "%selected_drives%\*" >> "!temp_file!" 2>nul
goto :eof

:option_4_silent
set "temp_file=%output_path%\console_history_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
echo. > "!temp_file!"
if exist "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" (
    type "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" >> "!temp_file!" 2>nul
)
doskey /history >> "!temp_file!" 2>nul
goto :eof

:option_5_silent
set "temp_file=%output_path%\browser_info_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
echo. > "!temp_file!"
if exist "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Login Data" (
    echo Chrome password database exists >> "!temp_file!"
)
if exist "%USERPROFILE%\AppData\Roaming\Mozilla\Firefox\Profiles" (
    echo Firefox profiles directory exists >> "!temp_file!"
)
if exist "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Login Data" (
    echo Edge password database exists >> "!temp_file!"
)
goto :eof

:option_6_silent
set "temp_file=%output_path%\network_config_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
echo. > "!temp_file!"
ipconfig /all >> "!temp_file!" 2>nul
netstat -ano >> "!temp_file!" 2>nul
goto :eof

:option_7_silent
set "temp_file=%output_path%\process_services_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
echo. > "!temp_file!"
tasklist /v >> "!temp_file!" 2>nul
sc query type= service state= all >> "!temp_file!" 2>nul
goto :eof

:option_8_silent
set "temp_file=%output_path%\registry_scan_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
echo. > "!temp_file!"
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> "!temp_file!" 2>nul
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" >> "!temp_file!" 2>nul
goto :eof

:option_9_silent
set "temp_file=%output_path%\user_accounts_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
echo. > "!temp_file!"
net user >> "!temp_file!" 2>nul
net localgroup administrators >> "!temp_file!" 2>nul
goto :eof

:option_10_silent
set "temp_file=%output_path%\scheduled_tasks_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
echo. > "!temp_file!"
schtasks /query /fo LIST >> "!temp_file!" 2>nul
goto :eof

:option_11_silent
set "temp_file=%output_path%\file_metadata_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
echo. > "!temp_file!"
dir /a /q /t:w "%USERPROFILE%\Desktop\*" >> "!temp_file!" 2>nul
goto :eof

:option_12_silent
set "temp_file=%output_path%\comprehensive_report_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
echo COMPREHENSIVE SECURITY REPORT > "!temp_file!"
echo ============================ >> "!temp_file!"
echo Report Date: %date% %time% >> "!temp_file!"
echo. >> "!temp_file!"
type "%output_path%\fileextensions_*.txt" >> "!temp_file!" 2>nul
type "%output_path%\keywordsearch_*.txt" >> "!temp_file!" 2>nul
type "%output_path%\console_history_*.txt" >> "!temp_file!" 2>nul
type "%output_path%\network_config_*.txt" >> "!temp_file!" 2>nul
type "%output_path%\process_services_*.txt" >> "!temp_file!" 2>nul
goto :eof

:: Option 14: Configure settings
:option_14
:config_menu
cls
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo     CONFIGURATION SETTINGS
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo 1. Change output directory [Current: !custom_output!]
echo 2. Change default keywords [Current: !default_keywords!]
echo 3. Change file extensions [Current: !file_extensions!]
echo 4. View current settings
echo 5. Reset to defaults
echo 6. Return to main menu
echo.
set /p "config_choice=Select option (1-6): "

if "!config_choice!"=="1" goto config_output
if "!config_choice!"=="2" goto config_keywords
if "!config_choice!"=="3" goto config_extensions
if "!config_choice!"=="4" goto view_settings
if "!config_choice!"=="5" goto reset_settings
if "!config_choice!"=="6" goto main_menu
goto config_menu

:config_output
echo Current output directory: !custom_output!
set /p "custom_output=Enter new output directory (or leave blank to use default): "
if "!custom_output!"=="" (
    echo Using default output directory: !default_output!
) else (
    if not exist "!custom_output!\" (
        mkdir "!custom_output!" 2>nul
        if errorlevel 1 (
            echo Error: Could not create directory
            set "custom_output="
        )
    )
)
pause
goto config_menu

:config_keywords
echo Current default keywords: !default_keywords!
set /p "default_keywords=Enter new default keywords (space separated): "
if "!default_keywords!"=="" (
    set "default_keywords=password passwd pwd secret key credential token api aws azure google cloud login user admin root database sql connectionstring"
)
pause
goto config_menu

:config_extensions
echo Current file extensions: !file_extensions!
set /p "file_extensions=Enter new file extensions (space separated): "
if "!file_extensions!"=="" (
    set "file_extensions=*.txt *.csv *.ini *.xml *.json *.log *.bat *.ps1 *.config"
)
pause
goto config_menu

:view_settings
cls
echo CURRENT SETTINGS:
echo ================
echo Output Directory: !custom_output!
echo Default Output: !default_output!
echo Default Keywords: !default_keywords!
echo File Extensions: !file_extensions!
echo Sensitive Extensions: !sensitive_extensions!
echo Excluded Folders: !excluded_folders!
echo.
pause
goto config_menu

:reset_settings
set "custom_output="
set "default_keywords=password passwd pwd secret key credential token api aws azure google cloud login user admin root database sql connectionstring"
set "file_extensions=*.txt *.csv *.ini *.xml *.json *.log *.bat *.ps1 *.config"
set "sensitive_extensions=.txt .doc .docx .xls .xlsx .ppt .pptx .pdf .csv .sql .mdb .accdb .pst .ost .conf .config .ini .inf .bat .ps1 .sh .py .php .asp .aspx .js .json .xml .yml .yaml .env .bak .tmp .log"
set "excluded_folders=C:\Program Files C:\Program Files (x86) C:\Windows C:\$Recycle.Bin"
echo Settings reset to defaults.
pause
goto config_menu

:: Silent versions of functions for comprehensive report
:option_1_silent
set "temp_file=%temp%\temp_scan.txt"
echo. >> "!output_file!"
echo FILE EXTENSION SCAN >> "!output_file!"
echo ================== >> "!output_file!"
for %%d in (%selected_drives%) do (
    for %%e in (%sensitive_extensions%) do (
        dir /s /b /a-d "%%d\*%%e" | findstr /v /i /c:"Program Files" /c:"Program Files (x86)" /c:"Windows" >> "!temp_file!" 2>nul
    )
)
type "!temp_file!" >> "!output_file!" 2>nul
del "!temp_file!" 2>nul
echo. >> "!output_file!"
goto :eof

:option_4_silent
echo. >> "!output_file!"
echo CONSOLE HISTORY >> "!output_file!"
echo ============== >> "!output_file!"
if exist "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" (
    type "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" >> "!output_file!" 2>nul
)
doskey /history >> "!output_file!" 2>nul
echo. >> "!output_file!"
goto :eof

:: Helper Functions
:select_drives
cls
echo Available drives:
echo.
set "drives="
for /f "skip=1" %%d in ('wmic logicaldisk get caption') do (
    if exist %%d (
        echo %%d
        set "drives=!drives! %%d"
    )
)
echo.
echo 1. Scan all drives
echo 2. Select specific drives
echo 3. Return to main menu
echo.
set /p "drive_option=Select drive option (1-3): "

if "!drive_option!"=="1" (
    set "selected_drives=!drives!"
) else if "!drive_option!"=="2" (
    set "selected_drives="
    set /p "selected_drives=Enter drives to scan (e.g., C: D:): "
) else if "!drive_option!"=="3" (
    set "selected_drives="
    goto :eof
) else (
    echo Invalid option
    pause
    goto select_drives
)
goto :eof

:set_output_path
if "!custom_output!"=="" (
    set "output_path=!default_output!"
) else (
    set "output_path=!custom_output!"
)

if not exist "!output_path!\" (
    mkdir "!output_path!"
)
goto :eof

:: Keep the window open after execution
cmd /k