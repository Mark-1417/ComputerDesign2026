# 计组实验项目说明


## 1. 项目总体结构

- `new_pl/`：单周期 CPU 的设计与仿真代码目录。
- `newsc/`：多周期 CPU（或复杂控制 CPU）设计与仿真代码目录。
- `.git/`：版本控制目录。
- `readme.md`：本说明文档。

## 2. `new_pl/` 目录说明（单周期 CPU）

`new_pl/` 包含单周期 CPU 实现的源码、约束、仿真测试和 Vivado 工程文件。

- `source_pl/`
  - 包含单周期 CPU 的关键 Verilog 源文件，如 `PLCPU.v`、`plcpu_top.v`、`RF.v`、`alu.v`、`ctrl.v` 等。
  - 包含测试用例和仿真相关文件，如 `plcomp_tb.v`、`pl_final.out`、`Test_30_Instr.asm`、`riscv_sidascsorting_sim.asm` 等。
- `constraints/`
  - FPGA 约束文件，常用于 Vivado 综合和实现：
    - `Nexys4DDR_CPU.xdc`
    - `Nexys4DDR.xdc`
- `iverilog-tests/`
  - iverilog 仿真测试目录。
  - `score.py`：用于运行全部评分的 Python 脚本，这样就不用一个一个运行了
- `scripts/`
  - Vivado 自动化脚本，如：
    - `create_vivado_project.tcl`
    - `run_bitstream_check.tcl`
    - `run_synthesis_check.tcl`
- `vivado/`
  - Vivado 工程目录，用于 FPGA 设计与综合。当前包含 `plcpu_project/` 子目录。
- `work/`
  - Vivado 或综合工具生成的中间文件目录。
- `run_both_pl.bat`：用于运行单周期 CPU 和多周期 CPU 的综合和实现的批处理文件。(modelsim仿真用)
- `run_both_sc.bat`：用于运行多周期 CPU 和简化控制 CPU 的综合和实现的批处理文件。（同上）
    

## 3. `newsc/` 目录说明（多周期/流水线 CPU）

`newsc/` 包含多周期 CPU 或更复杂控制 CPU 的源码、仿真、约束及工具文件。

- `source-sc/`
  - 包含多周期 CPU 的关键 Verilog/SystemVerilog 源文件，如 `SCCPU.v`、`sccomp.v`、`sccomp_top.sv`、`RF.v`、`alu.v`、`ctrl.v` 等。
  - 包含测试和汇编程序，如 `sccomp_tb.v`、`rv32_sid_sort_sim.asm`、`Test_30_Instr.asm` 等。
  - 包含构建脚本 `build.bat`、`build.py`、`Makefile`。
- `constraints/`
  - FPGA 约束文件，常用于 Vivado 综合和实现：
    - `Nexys4DDR_CPU.xdc`
    - `Nexys4DDR.xdc`
- `iverilog-tests/`
  - iverilog 仿真测试目录。
  - `tb/`：测试平台文件。
  - `tests/`：仿真测试输入与期望结果。
  - 其他文件如 `score.py`、`QUESTIONS.md`、`README.md`。
- `scripts/`
  - Vivado 自动化脚本，与单周期目录对应：
    - `create_vivado_project.tcl`
    - `run_bitstream_check.tcl`
    - `run_synthesis_check.tcl`
- `vivado/`
  - Vivado 工程目录，当前包含 `sccpu_project/` 子目录。
- `work/`
  - Vivado 或综合工具生成的中间文件目录。
