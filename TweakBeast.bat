@echo off
Title Windows Registry Tweaker
:: Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell Start-Process cmd -ArgumentList '/c %~s0' -Verb runAs
    exit
)

echo Running as Administrator. Proceeding with tweaks...

:menu
cls
echo ============================
echo Windows Registry Tweaker
echo ============================
echo 1 - Disable Windows Updates
echo 2 - Enable Windows Updates
echo 3 - Disable Windows Security
echo 4 - Enable Windows Security
echo 5 - Optimize System Performance
echo 6 - Enable/Disable Microphone & Camera
echo 7 - Exit
echo ============================
set /p choice=Enter your choice:

if "%choice%"=="1" goto disable_updates
if "%choice%"=="2" goto enable_updates
if "%choice%"=="3" goto disable_security
if "%choice%"=="4" goto enable_security
if "%choice%"=="5" goto optimize_performance
if "%choice%"=="6" goto mic_camera_permissions
if "%choice%"=="7" exit

:disable_updates
echo Disabling Windows Updates...
powershell -Command "if (-not (Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU')) {New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Force}"
powershell -Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'NoAutoUpdate' -Value 1 -Type DWord"
if %errorlevel% neq 0 (
    echo Error disabling Windows Update. Check permissions.
) else (
    echo Done!
)
pause
goto menu

:enable_updates
echo Enabling Windows Updates...
powershell -Command "Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'NoAutoUpdate' -ErrorAction SilentlyContinue"
if %errorlevel% neq 0 (
    echo Error enabling Windows Update. Check permissions.
) else (
    echo Done!
)
pause
goto menu

:disable_security
echo Disabling Windows Security...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
powershell -Command "Set-MpPreference -MAPSReporting Disabled"
powershell -Command "Set-MpPreference -SubmitSamplesConsent NeverSend"
:: Commented out "ThreatDefenseForEndpoint" due to invalid parameter
:: powershell -Command "Set-MpPreference -ThreatDefenseForEndpoint Disabled"
powershell -Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Defender\Features' -Name 'TamperProtection' -Value 0 -Type DWord"
if %errorlevel% neq 0 (
    echo Error disabling Windows Security. Check permissions.
) else (
    echo Done!
)
pause
goto menu

:enable_security
echo Enabling Windows Security...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
powershell -Command "Set-MpPreference -MAPSReporting Advanced"
powershell -Command "Set-MpPreference -SubmitSamplesConsent AlwaysSend"
powershell -Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Defender\Features' -Name 'TamperProtection' -Value 1 -Type DWord"
if %errorlevel% neq 0 (
    echo Error enabling Windows Security. Check permissions.
) else (
    echo Done!
)
pause
goto menu

:optimize_performance
echo Optimizing system performance...
powershell -Command "Remove-Item -Path $env:temp\* -Force -Recurse"
powershell -Command "Remove-Item -Path 'C:\Windows\Prefetch\*' -Force -Recurse"
powershell -Command "Remove-Item -Path 'C:\Windows\SoftwareDistribution\Download\*' -Force -Recurse"
powershell -Command "Remove-Item -Path 'C:\Windows\Temp\*' -Force -Recurse"
echo Running performance commands...
tree /F /A
echo Done! Performance optimized.
pause
goto menu

:mic_camera_permissions
cls
echo ============================
echo Enable/Disable Microphone & Camera Permissions
echo ============================
echo 1 - Enable Microphone
echo 2 - Disable Microphone
echo 3 - Enable Camera
echo 4 - Disable Camera
set /p choice=Enter your choice:

if "%choice%"=="1" goto enable_mic
if "%choice%"=="2" goto disable_mic
if "%choice%"=="3" goto enable_camera
if "%choice%"=="4" goto disable_camera

:enable_mic
echo Enabling microphone...
powershell -Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone' -Name 'Value' -Value 1"
if %errorlevel% neq 0 (
    echo Error enabling microphone. Check permissions.
) else (
    echo Done!
)
pause
goto menu

:disable_mic
echo Disabling microphone...
powershell -Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone' -Name 'Value' -Value 0"
if %errorlevel% neq 0 (
    echo Error disabling microphone. Check permissions.
) else (
    echo Done!
)
pause
goto menu

:enable_camera
echo Enabling camera...
powershell -Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam' -Name 'Value' -Value 1"
if %errorlevel% neq 0 (
    echo Error enabling camera. Check permissions.
) else (
    echo Done!
)
pause
goto menu

:disable_camera
echo Disabling camera...
powershell -Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam' -Name 'Value' -Value 0"
if %errorlevel% neq 0 (
    echo Error disabling camera. Check permissions.
) else (
    echo Done!
)
pause
goto menu
