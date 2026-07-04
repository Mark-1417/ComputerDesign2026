@echo off
rem =================================================================
rem 同时启动 FOUR 个 ModelSim 窗口（完整测试）
rem   1. 单周期CPU + 30指令
rem   2. 单周期CPU + 学号排序
rem   3. 流水线CPU + 30指令
rem   4. 流水线CPU + 学号排序
rem =================================================================
setlocal

cd /d "d:\COP\newsc"

echo ========================================
echo   启动四个 ModelSim 窗口（完整测试）
echo ========================================
echo   1. 单周期CPU + 30指令
echo   2. 单周期CPU + 学号排序
echo   3. 流水线CPU + 30指令
echo   4. 流水线CPU + 学号排序
echo ========================================

where vsim >nul 2>nul
if %errorlevel%==0 (
    start "SC + 30 Instructions" cmd /k "cd /d d:\COP\newsc && vsim -do sim_sc_30.do"
    timeout /t 2 /nobreak >nul
    start "SC + SID Sort" cmd /k "cd /d d:\COP\newsc && vsim -do sim_sc_sid.do"
    timeout /t 2 /nobreak >nul
    start "PL + 30 Instructions" cmd /k "cd /d d:\COP\newsc && vsim -do sim_pl_30.do"
    timeout /t 2 /nobreak >nul
    start "PL + SID Sort" cmd /k "cd /d d:\COP\newsc && vsim -do sim_pl_sid.do"
    echo [OK] 四个 ModelSim 窗口已启动
    goto :eof
)

echo.
echo [提示] 请手动打开4个ModelSim窗口:
echo       每个窗口执行: cd d:/COP/newsc
echo       然后分别: do sim_sc_30.do / do sim_sc_sid.do / do sim_pl_30.do / do sim_pl_sid.do
echo.
pause