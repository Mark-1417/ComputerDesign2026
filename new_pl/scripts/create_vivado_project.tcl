# ==============================================
# Vivado Project Creation Script for Nexys4 DDR
# Pipelined CPU (PLCPU) - Student ID Sorting
# ==============================================

set script_dir [file dirname [file normalize [info script]]]
set lab_dir [file normalize [file join $script_dir ..]]
set project_dir [file join $lab_dir vivado plcpu_project]
set source_dir [file join $lab_dir source_pl]
set constraints_dir [file join $lab_dir constraints]

# Create project directory
file mkdir $project_dir

# Create Vivado project
create_project plcpu_project $project_dir -part xc7a100tcsg324-1 -force

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
add_files -norecurse [file join $source_dir PLCPU.v]
add_files -norecurse [file join $source_dir pl_reg.v]
add_files -norecurse [file join $source_dir plcomp.v]
add_files -norecurse [file join $source_dir plcpu_top.v]
add_files -norecurse [file join $source_dir ctrl_encode_def.v]
add_files -norecurse [file join $source_dir hex_to_7seg.v]
add_files -norecurse [file join $source_dir scan_7seg.v]

# ==============================================
# Add constraint file
# ==============================================
puts "INFO: Adding constraint file..."
add_files -fileset constrs_1 -norecurse [file join $constraints_dir Nexys4DDR.xdc]

# ==============================================
# Set top module and update compile order
# ==============================================
puts "INFO: Setting top module..."
set_property top plcpu_top [current_fileset]
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
puts "Top Module: plcpu_top"
puts "FPGA Part: xc7a100tcsg324-1"
puts "=============================================="

# Optional: Open the project in GUI mode
# open_project $project_dir/plcpu_project.xpr