@echo off
chcp 65001 >nul 2>&1
title LegalHelp KZ — Quick Rebuild

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║        LegalHelp KZ — Quick Rebuild (без clean)             ║
echo ║        Стандарт «Золотого ноутбука» • v3.0                  ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

:: ─────────────────────────────────
:: Шаг 1: Зависимости Flutter
:: ─────────────────────────────────
echo [1/5] 📦 Зависимости Flutter (flutter pub get)...
echo ────────────────────────────────────────
call flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo ❌ ОШИБКА: flutter pub get завершился с ошибкой!
    pause
    exit /b 1
)
echo ✅ Готово.
echo.

:: ─────────────────────────────────
:: Шаг 2: Cloud Functions — TypeScript build
:: ─────────────────────────────────
echo [2/5] ☁️  Cloud Functions — компиляция TypeScript...
echo ────────────────────────────────────────
pushd functions
call npm run build
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  ПРЕДУПРЕЖДЕНИЕ: TypeScript компиляция завершилась с ошибкой.
)
popd
echo ✅ Готово.
echo.

:: ─────────────────────────────────
:: Шаг 3: Локализация
:: ─────────────────────────────────
echo [3/5] 🌍 Генерация локализации RU/KK (flutter gen-l10n)...
echo ────────────────────────────────────────
call flutter gen-l10n
echo ✅ Готово.
echo.

:: ─────────────────────────────────
:: Шаг 4: Кодогенерация Riverpod
:: ─────────────────────────────────
echo [4/5] ⚙️  Кодогенерация Riverpod (build_runner)...
echo ────────────────────────────────────────
call dart run build_runner build -d
if %ERRORLEVEL% NEQ 0 (
    echo ❌ ОШИБКА: build_runner завершился с ошибкой!
    pause
    exit /b 1
)
echo ✅ Готово.
echo.

:: ─────────────────────────────────
:: Шаг 5: Запуск
:: ─────────────────────────────────
echo [5/5] 🚀 Запуск LegalHelp KZ (flutter run)...
echo ════════════════════════════════════════
echo.
call flutter run

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║               Сессия завершена. До встречи!                 ║
echo ╚══════════════════════════════════════════════════════════════╝
pause
