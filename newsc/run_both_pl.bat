@echo off
rem =================================================================
rem 同时启动两个 ModelSim 窗口（流水线CPU 30指令 + 学号排序）
rem 双击此文件
rem =================================================================
setlocal

cd /d "d:\COP\newsc"

echo ========================================
echo   同时启动两个 ModelSim 窗口
echo ========================================
echo   窗口1: 流水线CPU + Test_30_Instr.dat
echo   窗口2: 流水线CPU + 学号排序
echo ========================================

where vsim >nul 2>nul
if %errorlevel%==0 (
    start "ModelSim - PL 30 Instructions" cmd /k "cd /d d:\COP\newsc && vsim -do sim_pl_30.do"
    timeout /t 2 /nobreak >nul
    start "ModelSim - PL SID Sorting" cmd /k "cd /d d:\COP\newsc && vsim -do sim_pl_sid.do"
    echo [OK] 两个 ModelSim 窗口已启动
    goto :eof
)

start "CMD - 30条指令测试" cmd /k "cd /d d:\COP\newsc && echo 在ModelSim Transcript输入: do sim_pl_30.do && pause"
timeout /t 1 /nobreak >nul
start "CMD - 学号排序测试" cmd /k "cd /d d:\COP\newsc && echo 在ModelSim Transcript输入: do sim_pl_sid.do && pause"

echo.
echo [提示] 未检测到 vsim 命令。请手动打开两个 ModelSim 窗口:
echo       1. cd d:/COP/newsc
echo       2. 窗口1: do sim_pl_30.do
echo       3. 窗口2: do sim_pl_sid.do
echo.
pause