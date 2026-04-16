@echo off
chcp 65001 > nul
echo ========================================================
echo 🛠 LegalHelp KZ: Глубокая очистка и нативная пересборка 
echo ========================================================
echo.

echo [1/3] Запускаю flutter clean (Удаление кэша и старых платформенных связей)...
call flutter clean
echo.

echo [2/3] Запускаю flutter pub get (Чистая загрузка всех зависимостей)...
call flutter pub get
echo.

echo ✅ Очистка завершена. Новые нативные плагины (ML Kit, ImagePicker) интегрированы.
echo [3/3] Запускаю проект с нуля...
call flutter run
