# Screenshoter
Служба скрытного создания скриншотов

- path - куда кидаем
- Interval - с каким интервалом скидываем (на основе ping)
- ScreenFormat - формат файла (jpg,png,gif)
- File - загрузка параметров из файла или со строки

Параметры по-умолчанию:
- Path: %systemdrive%
- Interval: 10
- ScreenFormat: png

Для передачи параметров в exe:
```
screen.exe -Arguments -Path "C:\new folder" -Interval "15" -ScreenFormat "jpg" 
```

Для передачи в скрипт
```
screen.ps1 -Path "C:\" -Interval "15" -ScreenFormat "jpg"
screen.ps1 -Path "C:\new folder" -Interval "15" -ScreenFormat "jpg"
```

Exe-шник без консоли, т.е. не отображается. Качество никак не регулируется.

Требуется установка Powershell, .NET Framework v4.0, рекомендуется проверка set-execultionpolicy (если выдает ошибку что запуск скриптов запрещен)

В папке лежат файлы:
- Descript.txt - описание
- screen.exe - скомпилированный exe из ps1 при помощи PowerGUI Script Editor (меню Tools > Compile Script).
	PS2EXE компилится командой:
	```
	PS C:\> ps2exe.ps1 -inputFile C:\screen.ps1 C:\screen.exe -sta -noConsole
	```
	Но скомпилированный PS2EXE  не отрбатывает обработку исключения, не работает вывод.
- screen.ps1 - оригинальный файл скрипта
- screen.exe.config - создается при компиляции
- screen_debug.exe - с консолью
- screen_debug.exe.config
- setup.ps1 - инсталлятор/деинсталлятор
- setup.bat - запуск setup.ps1
- screen.ini - файл настроек
```
C:\Users\aa\Dropbox\script\posh\SCREENSHOTER>screen.exe -Arguments -Path "\\192.168.9.15\store\SCREEN\technical" -Interval "15" -ScreenFormat "jpg"
```
