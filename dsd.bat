@echo off
chcp 65001 >nul
color 07
setlocal

if "%~1"=="domain" goto run_domain
if "%~1"=="geo" goto run_geo
if "%~1"=="active" goto run_active
if "%~1"=="myip" goto run_myip
if "%~1"=="exif" goto run_exif
if "%~1"=="tools" goto run_tools
if "%~1"=="lan" goto run_lan

title dsd

:login
cls
echo ============================================================
echo   dsd - Вход
echo ============================================================
echo(
set /p PW=Введите пароль: 

if "%PW%"=="155d1" (
    set ROLE=admin
    goto menu
)
if "%PW%"=="14421" (
    set ROLE=user
    goto menu
)

echo(
echo Неверный пароль.
echo(
pause
goto login

:menu
cls
echo ============================================================
echo   dsd  [Роль: %ROLE%]
echo ============================================================
echo   1. Поиск по домену / IP (ping, nslookup, traceroute)
echo   2. Поиск местоположения по IP (геолокация)
echo   3. Проверка домена на активность (доступен ли узел)
echo   4. Просмотр своего внешнего IP
echo   5. Метаданные (EXIF) фото
echo   6. Список легитимных OSINT-инструментов (справка)
echo   7. Устройства в моей локальной сети (arp -a)
echo   8. Ввести промокод (+20 запросов на сегодня)
echo   0. Выход
echo ============================================================
if "%ROLE%"=="user" echo   Хотите больше запросов? Telegram: @dsdfaez - купить промо
echo(
set /p CH=Выберите пункт: 

if "%CH%"=="1" goto ask_domain
if "%CH%"=="2" goto ask_geo
if "%CH%"=="3" goto ask_active
if "%CH%"=="4" goto ask_myip
if "%CH%"=="5" goto ask_exif
if "%CH%"=="6" goto ask_tools
if "%CH%"=="7" goto ask_lan
if "%CH%"=="8" goto ask_promo
if "%CH%"=="0" goto end
goto menu

:ask_domain
cls
echo ============================================================
echo   1. Поиск по домену / IP
echo ============================================================
echo(
echo Описание: утилита выполняет ping, nslookup и traceroute
echo для указанного вами IP-адреса или домена. Все данные
echo относятся только к введённому вами адресу.
echo(
set /p Y=Запустить утилиту? (да/нет): 
if /i "%Y%"=="да" (
    if "%ROLE%"=="user" (
        call :check_quota
        if errorlevel 1 goto menu
    )
    start "dsd - Поиск по домену/IP" cmd /k "%~f0" domain
) 
goto menu

:ask_geo
cls
echo ============================================================
echo   2. Поиск местоположения по IP
echo ============================================================
echo(
echo Описание: утилита определяет страну, регион, город и
echo провайдера для введённого вами IP-адреса через публичный
echo сервис ip-api.com. Требуется подключение к интернету.
echo(
set /p Y=Запустить утилиту? (да/нет): 
if /i "%Y%"=="да" (
    if "%ROLE%"=="user" (
        call :check_quota
        if errorlevel 1 goto menu
    )
    start "dsd - Геолокация по IP" cmd /k "%~f0" geo
)
goto menu

:ask_active
cls
echo ============================================================
echo   3. Проверка домена на активность
echo ============================================================
echo(
echo Описание: утилита проверяет, отвечает ли указанный домен
echo (ping) и какой HTTP-статус возвращает его веб-сервер.
echo(
set /p Y=Запустить утилиту? (да/нет): 
if /i "%Y%"=="да" (
    if "%ROLE%"=="user" (
        call :check_quota
        if errorlevel 1 goto menu
    )
    start "dsd - Проверка активности домена" cmd /k "%~f0" active
)
goto menu

:ask_myip
cls
echo ============================================================
echo   4. Просмотр своего внешнего IP
echo ============================================================
echo(
echo Описание: утилита обращается к публичному сервису
echo ipify.org и ip-api.com, чтобы показать ваш собственный
echo внешний IP-адрес и связанную с ним информацию.
echo(
set /p Y=Запустить утилиту? (да/нет): 
if /i "%Y%"=="да" (
    if "%ROLE%"=="user" (
        call :check_quota
        if errorlevel 1 goto menu
    )
    start "dsd - Мой IP" cmd /k "%~f0" myip
)
goto menu

:ask_exif
cls
echo ============================================================
echo   5. Метаданные (EXIF) фото
echo ============================================================
echo(
echo Описание: утилита читает метаданные указанного вами файла
echo фотографии (дата съёмки, камера) и, если в файле есть
echo GPS-координаты, формирует ссылку на Google Карты для этого
echo места и автоматически открывает её в браузере. Работает
echo только с файлом, который вы сами укажете.
echo(
set /p Y=Запустить утилиту? (да/нет): 
if /i "%Y%"=="да" (
    if "%ROLE%"=="user" (
        call :check_quota
        if errorlevel 1 goto menu
    )
    start "dsd - EXIF фото" cmd /k "%~f0" exif
)
goto menu

:ask_tools
cls
echo ============================================================
echo   6. Список легитимных OSINT-инструментов
echo ============================================================
echo(
echo Описание: справочный список известных open-source
echo инструментов OSINT и ссылок на них. Ничего не скачивает
echo и не запускает автоматически.
echo(
set /p Y=Показать список? (да/нет): 
if /i "%Y%"=="да" (
    if "%ROLE%"=="user" (
        call :check_quota
        if errorlevel 1 goto menu
    )
    start "dsd - OSINT инструменты" cmd /k "%~f0" tools
)
goto menu

:ask_lan
cls
echo ============================================================
echo   7. Устройства в моей локальной сети
echo ============================================================
echo(
echo Описание: показывает устройства, видимые из вашей локальной
echo сети (Wi-Fi/LAN), через таблицу ARP вашего компьютера -
echo то же самое, что видно в настройках вашего роутера. Не
echo сканирует чужие сети и не требует интернета.
echo(
set /p Y=Запустить утилиту? (да/нет): 
if /i "%Y%"=="да" (
    if "%ROLE%"=="user" (
        call :check_quota
        if errorlevel 1 goto menu
    )
    start "dsd - Локальная сеть" cmd /k "%~f0" lan
)
goto menu

REM ============================================================
REM   Ниже - подпрограммы, которые выполняются в отдельном окне
REM ============================================================

:run_domain
title dsd - Поиск по домену/IP
:run_domain_loop
echo ============================================================
echo   Поиск по домену / IP
echo ============================================================
set /p TARGET=Введите IP-адрес или домен (или "exit"): 
if /i "%TARGET%"=="exit" exit /b
if "%TARGET%"=="" goto run_domain_loop

echo(
echo --- PING ---
ping -n 4 %TARGET%

echo(
echo --- NSLOOKUP ---
nslookup %TARGET%

echo(
echo --- TRACEROUTE ---
tracert -d -h 15 %TARGET%

echo(
echo ============================================================
echo(
goto run_domain_loop

:run_geo
title dsd - Геолокация по IP
:run_geo_loop
echo ============================================================
echo   Поиск местоположения по IP
echo ============================================================
set /p TARGET=Введите IP-адрес (или "exit"): 
if /i "%TARGET%"=="exit" exit /b
if "%TARGET%"=="" goto run_geo_loop

echo(
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $r = Invoke-RestMethod -Uri ('http://ip-api.com/json/' + '%TARGET%' + '?fields=status,message,query,country,regionName,city,zip,lat,lon,isp,org,as,timezone'); if ($r.status -eq 'success') { $r | Format-List } else { Write-Host 'Ошибка запроса:' $r.message } } catch { Write-Host 'Нет интернета или сервис недоступен.' }"

echo(
echo ============================================================
echo(
goto run_geo_loop

:run_active
title dsd - Проверка активности домена
:run_active_loop
echo ============================================================
echo   Проверка домена на активность
echo ============================================================
set /p TARGET=Введите домен (или "exit"): 
if /i "%TARGET%"=="exit" exit /b
if "%TARGET%"=="" goto run_active_loop

echo(
echo --- PING ---
ping -n 2 %TARGET%

echo(
echo --- HTTP-СТАТУС ---
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $u = '%TARGET%'; if ($u -notmatch '^https?://') { $u = 'https://' + $u }; $r = Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 8 -MaximumRedirection 5; Write-Host 'Статус:' $r.StatusCode $r.StatusDescription; Write-Host 'Сервер отвечает.' } catch { Write-Host 'Сайт не отвечает или недоступен по HTTPS.' }"

echo(
echo ============================================================
echo(
goto run_active_loop

:run_myip
title dsd - Мой IP
echo ============================================================
echo   Ваш внешний IP-адрес
echo ============================================================
echo(
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $ip = (Invoke-RestMethod -Uri 'https://api.ipify.org?format=json').ip; Write-Host 'Внешний IP:' $ip; $info = Invoke-RestMethod -Uri ('http://ip-api.com/json/' + $ip + '?fields=status,message,country,regionName,city,isp,org,as'); $info | Format-List } catch { Write-Host 'Не удалось определить IP (нет интернета).' }"
echo(
echo ============================================================
echo(
pause
exit /b

:run_exif
title dsd - EXIF фото
:run_exif_loop
echo ============================================================
echo   Метаданные (EXIF) фото
echo ============================================================
set /p PHOTO=Перетащите файл сюда или введите путь (или "exit"): 
if /i "%PHOTO%"=="exit" exit /b
if "%PHOTO%"=="" goto run_exif_loop
set PHOTO=%PHOTO:"=%

if not exist "%PHOTO%" (
    echo(
    echo Файл не найден: %PHOTO%
    echo(
    goto run_exif_loop
)

echo(
powershell -NoProfile -ExecutionPolicy Bypass -Command "$path = '%PHOTO%'; $shell = New-Object -ComObject Shell.Application; $folder = $shell.Namespace((Get-Item $path).DirectoryName); $file = $folder.ParseName((Get-Item $path).Name); $props = 0..294 | ForEach-Object { $name = $folder.GetDetailsOf($folder.Items, $_); $value = $folder.GetDetailsOf($file, $_); if ($name -and $value) { [PSCustomObject]@{Свойство=$name; Значение=$value} } }; $props | Where-Object { $_.Значение -ne '' } | Format-Table -AutoSize -Wrap"

echo(
echo(
echo --- GPS / ССЫЛКА НА КАРТУ ---

set "LAT="
set "LON="
where exiftool >nul 2>nul
if %errorlevel%==0 (
    REM exiftool проверяет координаты и в EXIF, и в XMP/IPTC
    for /f "tokens=1,2" %%A in ('exiftool -n -T -GPSLatitude -GPSLongitude "%PHOTO%" 2^>nul') do (
        set "LAT=%%A"
        set "LON=%%B"
    )
    if defined LAT if defined LON if not "%LAT%"=="-" if not "%LON%"=="-" (
        set "MAPURL=https://www.google.com/maps?q=%LAT%,%LON%"
        echo GPS найден ^(EXIF/XMP, через exiftool^): %LAT% %LON%
        echo Google Карты: %MAPURL%
        start "" "%MAPURL%"
    ) else (
        echo В файле нет координат ни в EXIF, ни в XMP/IPTC.
    )
) else (
    REM exiftool не установлен - проверяется только стандартный EXIF-GPS
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-Type -AssemblyName System.Drawing; try { $img = [System.Drawing.Image]::FromFile('%PHOTO%'); function Conv($id) { $p = $img.GetPropertyItem($id); $b = $p.Value; $vals = @(); for ($i=0; $i -lt $b.Length; $i+=8) { $num = [BitConverter]::ToUInt32($b,$i); $den = [BitConverter]::ToUInt32($b,$i+4); if ($den -eq 0) { $vals += 0 } else { $vals += ($num/$den) } }; return $vals } $latRef = [System.Text.Encoding]::ASCII.GetString($img.GetPropertyItem(1).Value).Trim([char]0); $lonRef = [System.Text.Encoding]::ASCII.GetString($img.GetPropertyItem(3).Value).Trim([char]0); $lat = Conv(2); $lon = Conv(4); $latDec = $lat[0] + $lat[1]/60 + $lat[2]/3600; $lonDec = $lon[0] + $lon[1]/60 + $lon[2]/3600; if ($latRef -eq 'S') { $latDec = -$latDec }; if ($lonRef -eq 'W') { $lonDec = -$lonDec }; $mapUrl = 'https://www.google.com/maps?q=' + $latDec + ',' + $lonDec; Write-Host 'GPS найден:' $latDec $lonDec; Write-Host ('Google Карты: ' + $mapUrl); Start-Process $mapUrl; $img.Dispose() } catch { Write-Host 'В файле нет GPS-метаданных в EXIF.' }"
    echo(
    echo Примечание: exiftool не найден в PATH - проверялся только
    echo стандартный EXIF-GPS. Чтобы также проверять XMP/IPTC
    echo ^(например, фото из Apple Photos^), установите exiftool
    echo с exiftool.org и добавьте его в PATH.
)

echo(
echo ============================================================
echo(
goto run_exif_loop

:run_tools
title dsd - OSINT инструменты
echo ============================================================
echo   Легитимные OSINT-инструменты (справочно)
echo ============================================================
echo(
echo   Этот список НЕ скачивает и НЕ запускает инструменты -
echo   только справка. Используйте их отдельно, в рамках закона
echo   и только по публичным/своим данным.
echo(
echo   [Инфраструктура и домены]
echo   - theHarvester   github.com/laramies/theHarvester
echo   - Amass          github.com/owasp-amass/amass
echo   - Recon-ng       github.com/lanmaster53/recon-ng
echo(
echo   [Соцсети / никнеймы]
echo   - Sherlock       github.com/sherlock-project/sherlock
echo   - Maigret        github.com/soxoj/maigret
echo(
echo   [Анализ связей]
echo   - Maltego        maltego.com
echo(
echo   [Каталог-справочник]
echo   - OSINT Framework   osintframework.com
echo(
echo   Легально: только публичные данные, только с законным
echo   основанием, без обхода авторизации и без публикации
echo   чужих личных данных.
echo(
pause
exit /b

:check_quota
set "QFILE=%~dp0dsd_usage.txt"
set "TODAY=%date%"
set "COUNT=0"
set "LIMIT=5"
if exist "%QFILE%" (
    for /f "tokens=1,2,3 delims=|" %%A in (%QFILE%) do (
        if "%%A"=="%TODAY%" (
            set "COUNT=%%B"
            set "LIMIT=%%C"
        )
    )
)
if %COUNT% GEQ %LIMIT% (
    echo(
    echo Достигнут дневной лимит для пользовательского доступа
    echo ^(%LIMIT% запросов в день^). Попробуйте завтра, введите
    echo промокод ^(пункт 8^) или войдите с администраторским
    echo паролем.
    echo(
    pause
    exit /b 1
)
set /a COUNT+=1
> "%QFILE%" echo %TODAY%^|%COUNT%^|%LIMIT%
exit /b 0

:ask_promo
cls
echo ============================================================
echo   Промокод
echo ============================================================
echo(
echo Введите промокод, чтобы добавить +20 запросов на сегодня.
echo Купить промокод: Telegram @dsdfaez
echo(
set /p CODE=Промокод (или "back"): 
if /i "%CODE%"=="back" goto menu

set "VALID="
if /i "%CODE%"=="prem" set "VALID=1"
if /i "%CODE%"=="sers" set "VALID=1"
if /i "%CODE%"=="walle" set "VALID=1"

if not defined VALID (
    echo(
    echo Промокод не найден.
    echo(
    pause
    goto ask_promo
)

set "QFILE=%~dp0dsd_usage.txt"
set "TODAY=%date%"
set "COUNT=0"
set "LIMIT=5"
if exist "%QFILE%" (
    for /f "tokens=1,2,3 delims=|" %%A in (%QFILE%) do (
        if "%%A"=="%TODAY%" (
            set "COUNT=%%B"
            set "LIMIT=%%C"
        )
    )
)
set /a LIMIT+=20
> "%QFILE%" echo %TODAY%^|%COUNT%^|%LIMIT%
echo(
echo Промокод принят! Лимит на сегодня теперь: %LIMIT% запросов.
echo(
pause
goto menu

:end
endlocal
exit /b 0
