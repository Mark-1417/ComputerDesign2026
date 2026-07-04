# ============================================================
# ModelSim DO script: 单周期CPU + Test_30_Instr.dat
# 工作目录: d:/COP/newsc
# Usage: do sim_sc_30.do
# ============================================================

# 清除旧工程
quit -sim
.main clear

# 路径设置
set ROOT "d:/COP/newsc"
set SC_SRC "$ROOT/source-sc"
set TEST_DATA "$ROOT/source-sc"

# 创建 work 库
vlib work
vmap work work

# 编译单周期CPU源文件 + sccomp_tb（我们自己的顶层，支持 +IMEM=）
vlog -work work $SC_SRC/alu.v $SC_SRC/ctrl.v $SC_SRC/ctrl_encode_def.v $SC_SRC/dm.v $SC_SRC/EXT.v $SC_SRC/im.v $SC_SRC/NPC.v $SC_SRC/PC.v $SC_SRC/sccomp.v $SC_SRC/SCCPU.v $SC_SRC/RF.v $SC_SRC/sccomp_tb.v

# 启动仿真
vsim -voptargs=+acc work.sccomp_tb +IMEM=$TEST_DATA/Test_30_Instr.dat +CYCLES=100

# 添加波形信号
add wave -position insertpoint sim:/sccomp_tb/clk
add wave -position insertpoint sim:/sccomp_tb/rstn
add wave -radix hexadecimal sim:/sccomp_tb/sccomp/*
add wave -radix hexadecimal sim:/sccomp_tb/sccomp/U_SCCPU/*
add wave -radix hexadecimal sim:/sccomp_tb/sccomp/U_SCCPU/U_RF/rf
add wave -radix hexadecimal sim:/sccomp_tb/sccomp/U_imem/RAM
add wave -radix hexadecimal sim:/sccomp_tb/sccomp/U_DM/dmem

# 打开波形窗口
view wave
view structure

# 运行仿真
run 2000ns
wave zoom full

echo "========================================"
echo " 单周期 CPU + Test_30_Instr.dat 仿真完成"
echo "========================================"