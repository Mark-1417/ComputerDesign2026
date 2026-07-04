# ==============================================
# Vivado Project Creation Script for Nexys4 DDR
# Single-Cycle RISC-V CPU - Student ID Sorting
# ==============================================

set script_dir [file dirname [file normalize [info script]]]
set lab_dir [file normalize [file join $script_dir ..]]
set project_dir [file join $lab_dir vivado sccpu_project]
set source_dir [file join $lab_dir source-sc]
set constraints_dir [file join $lab_dir constraints]

# Create project directory
file mkdir $project_dir

# Create Vivado project
create_project sccpu_project $project_dir -part xc7a100tcsg324-1 -force

# Set board part if available
set board_name "digilentinc.com:nexys4_ddr:part0:1.1"
if {[llength [get_board_parts -quiet $board_name]] > 0} {
    set_property board_part $board_name [current_project]
    puts "INFO: Board part $board_name loaded successfully."
} else {
    puts "INFO: Board part $board_name not found, using device part only."
}

# ==============================================
# Add source files
# ==============================================
puts "INFO: Adding source files..."

add_files -norecurse [file join $source_dir alu.v]
add_files -norecurse [file join $source_dir ctrl.v]
add_files -norecurse [file join $source_dir dm.v]
add_files -norecurse [file join $source_dir EXT.v]
add_files -norecurse [file join $source_dir im.v]
add_files -norecurse [file join $source_dir NPC.v]
add_files -norecurse [file join $source_dir PC.v]
add_files -norecurse [file join $source_dir RF.v]
add_files -norecurse [file join $source_dir SCCPU.v]
add_files -norecurse [file join $source_dir sccomp.v]
add_files -norecurse [file join $source_dir sccomp_top.sv]
add_files -norecurse [file join $source_dir ctrl_encode_def.v]

# ==============================================
# Add constraint file
# ==============================================
puts "INFO: Adding constraint file..."
add_files -fileset constrs_1 -norecurse [file join $constraints_dir Nexys4DDR.xdc]

# ==============================================
# Set top module and update compile order
# ==============================================
puts "INFO: Setting top module..."
set_property top sccomp_top [current_fileset]
update_compile_order -fileset sources_1

# ==============================================
# Create synthesis run
# ==============================================
puts "INFO: Creating synthesis run..."
create_run synth_1 -flow {Vivado Synthesis 2023} -strategy "Flow_Quick" -report_strategy "No Reports"

# ==============================================
# Create implementation run
# ==============================================
puts "INFO: Creating implementation run..."
create_run impl_1 -parent_run synth_1 -flow {Vivado Implementation 2023} -strategy "Flow_Quick" -report_strategy "No Reports"

# ==============================================
# Final message
# ==============================================
puts "=============================================="
puts "Vivado Project Created Successfully!"
puts "Project Location: $project_dir"
puts "Top Module: sccomp_top"
puts "FPGA Part: xc7a100tcsg324-1"
puts "=============================================="

# Optional: Open the project in GUI mode
# open_project $project_dir/sccpu_project.xpr