# ============================================================
# ModelSim DO script: 单周期CPU + 学号排序 (rv32_sid_sort_sim.dat)
# 工作目录: d:/COP/newsc
# Usage: do sim_sc_sid.do
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

# 编译单周期CPU源文件 + sccomp_tb.v（通过 +IMEM 参数传入程序）
vlog -work work $SC_SRC/alu.v $SC_SRC/ctrl.v $SC_SRC/ctrl_encode_def.v $SC_SRC/dm.v $SC_SRC/EXT.v $SC_SRC/im.v $SC_SRC/NPC.v $SC_SRC/PC.v $SC_SRC/sccomp.v $SC_SRC/SCCPU.v $SC_SRC/RF.v $SC_SRC/sccomp_tb.v

# 启动仿真，传入学号排序程序
vsim -voptargs=+acc work.sccomp_tb +IMEM=$TEST_DATA/rv32_sid_sort_sim.dat +CYCLES=500

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
run 5000ns
wave zoom full

echo "========================================"
echo " 单周期 CPU + 学号排序 仿真完成"
echo "========================================"