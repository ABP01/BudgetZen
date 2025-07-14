@echo off
echo ========================================
echo      BudgetZen Application Startup
echo ========================================
echo.

echo [1/3] Demarrage du backend...
cd /d "c:\Users\komla\Desktop\Projet\BudgetZen\backend"
start "BudgetZen Backend" cmd /k "node src/server.js"

echo [2/3] Attente du backend (3 secondes)...
timeout /t 3 /nobreak >nul

echo [3/3] Demarrage de l'application Flutter...
cd /d "c:\Users\komla\Desktop\Projet\BudgetZen\mobile\budgetzen"
echo.
echo ========================================
echo   Backend: http://localhost:3000
echo   Flutter: Demarrage en cours...
echo ========================================
echo.
flutter run

pause
