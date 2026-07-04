# ============================================================
# ModelSim DO script: 流水线CPU + Test_30_Instr.dat
# 工作目录: d:/COP/newsc
# Usage: do sim_pl_30.do
# ============================================================

# 清除旧工程
quit -sim
.main clear

# 路径设置
set ROOT "d:/COP/newsc"
set PL_SRC "d:/COP/new_pl/source_pl"
set TB_DIR "$ROOT/iverilog-tests/tb"
set TEST_DATA "$ROOT/source-sc"

# 创建 work 库
vlib work
vmap work work

# 编译流水线CPU源文件
vlog -work work $PL_SRC/alu.v $PL_SRC/ctrl.v $PL_SRC/ctrl_encode_def.v $PL_SRC/dm.v $PL_SRC/EXT.v $PL_SRC/im.v $PL_SRC/NPC.v $PL_SRC/PC.v $PL_SRC/plcomp.v $PL_SRC/PLCPU.v $PL_SRC/pl_reg.v $PL_SRC/RF.v $TB_DIR/pl_final_tb.v

# 启动仿真
vsim -voptargs=+acc work.pl_final_tb +IMEM=$TEST_DATA/Test_30_Instr.dat +CYCLES=200

# 添加波形信号
add wave -position insertpoint sim:/pl_final_tb/clk
add wave -position insertpoint sim:/pl_final_tb/rstn
add wave -radix hexadecimal sim:/pl_final_tb/dut/*
add wave -radix hexadecimal sim:/pl_final_tb/dut/U_PLCPU/*
add wave -radix hexadecimal sim:/pl_final_tb/dut/U_PLCPU/U_RF/rf
add wave -radix hexadecimal sim:/pl_final_tb/dut/U_imem/RAM
add wave -radix hexadecimal sim:/pl_final_tb/dut/U_DM/dmem

# 打开波形窗口
view wave
view structure

# 运行仿真
run 3000ns
wave zoom full

echo "========================================"
echo " 流水线 CPU + Test_30_Instr.dat 仿真完成"
echo "========================================"