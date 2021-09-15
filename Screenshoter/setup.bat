cd %~dp0
powershell.exe Set-ExecutionPolicy RemoteSigned
start /wait powershell.exe ./setup.ps1
powershell.exe Set-ExecutionPolicy Restricted
pause