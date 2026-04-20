@echo off
chcp 65001 >nul 2>&1
title LegalHelp KZ — Automated Build Pipeline

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║        LegalHelp KZ — Enterprise Build Pipeline             ║
echo ║        Стандарт «Золотого ноутбука» • v3.0                  ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

:: ─────────────────────────────────
:: Шаг 1: Глубокая очистка кэша
:: ─────────────────────────────────
echo [1/7] Очистка кэша...
echo ────────────────────────────────────────
call flutter clean
if %ERRORLEVEL% NEQ 0 goto :err_clean
echo OK: Кэш очищен.
echo.

:: ─────────────────────────────────
:: Шаг 2: Загрузка зависимостей Flutter
:: ─────────────────────────────────
echo [2/7] Загрузка зависимостей Flutter...
echo ────────────────────────────────────────
call flutter pub get
if %ERRORLEVEL% NEQ 0 goto :err_pubget
echo OK: Все зависимости загружены.
echo.

:: ─────────────────────────────────
:: Шаг 3: Cloud Functions — npm install
:: ─────────────────────────────────
echo [3/7] Cloud Functions — npm install...
echo ────────────────────────────────────────
pushd functions
call npm install 2>&1
echo OK: Cloud Functions зависимости установлены.
echo.

:: ─────────────────────────────────
:: Шаг 4: Cloud Functions — TypeScript build
:: ─────────────────────────────────
echo [4/7] Cloud Functions — TypeScript build...
echo ────────────────────────────────────────
call npm run build 2>&1
echo OK: Cloud Functions скомпилированы.
popd
echo.

:: ─────────────────────────────────
:: Шаг 5: Генерация локализации
:: ─────────────────────────────────
echo [5/7] Генерация локализации RU/KK...
echo ────────────────────────────────────────
call flutter gen-l10n
echo OK: Локализация сгенерирована.
echo.

:: ─────────────────────────────────
:: Шаг 6: Кодогенерация Riverpod
:: ─────────────────────────────────
echo [6/7] Кодогенерация Riverpod...
echo ────────────────────────────────────────
call dart run build_runner build -d
if %ERRORLEVEL% NEQ 0 goto :err_buildrunner
echo OK: Все .g.dart файлы сгенерированы.
echo.

:: ─────────────────────────────────
:: Шаг 7: Запуск приложения
:: ─────────────────────────────────
echo [7/7] Запуск LegalHelp KZ...
echo ════════════════════════════════════════
echo.
call flutter run
goto :done

:err_clean
echo ОШИБКА: flutter clean завершился с ошибкой!
goto :fail

:err_pubget
echo ОШИБКА: flutter pub get завершился с ошибкой!
goto :fail

:err_buildrunner
echo ОШИБКА: build_runner завершился с ошибкой!
goto :fail

:fail
pause
exit /b 1

:done
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║               Сессия завершена. До встречи!                 ║
echo ╚══════════════════════════════════════════════════════════════╝
pause
