rem "Shift+F10" call out command window

rem while installing
robocopy "C:\Users" "F:\Users" /E /COPYALL /XJ
rmdir "C:\Users" /S /Q
mklink /J "C:\Users" "F:\Users"

rem after installing
robocopy "C:\Users" "F:\Users" /E /COPYALL /XJ /XD "C:\Users\Administrator"
rmdir "C:\Users" /S /Q
mklink /J "C:\Users" "F:\Users"

rem UNSUCCESSFUL INSTALLATION
cd oobe
msoobe

rem AFTER VPN CONNECTING: CAN PING, CANNOT BROWSE
net.exe stop "network connections"
net.exe start "network connections"

rem disable windows 10 upgrade
rem erase KB3035583 + KB3065987

rem BOOTMGR
rem 1.diskpart ?
rem 2.bcdboot C:\Windows
rem 3.bootrec ?
