# ==============================================
# PLCPU Bitstream Generation Script
# ==============================================

set script_dir [file dirname [file normalize [info script]]]
set lab_dir [file normalize [file join $script_dir ..]]
set project_dir [file join $lab_dir vivado plcpu_project]
set project_file [file join $project_dir plcpu_project.xpr]

# Check if project exists
if {![file exists $project_file]} {
    puts "ERROR: Vivado project does not exist."
    puts "Please run scripts/create_vivado_project.tcl first."
    exit 1
}

# Open project
open_project $project_file

# ==============================================
# Step 1: Synthesis (if not already done)
# ==============================================
set synth_status [get_property STATUS [get_runs synth_1]]
if {![string match "*Complete*" $synth_status]} {
    puts "INFO: Synthesis not completed, running synthesis..."
    reset_run synth_1
    launch_runs synth_1 -jobs 4
    wait_on_run synth_1
    
    set synth_status [get_property STATUS [get_runs synth_1]]
    puts "Synthesis Status: $synth_status"
    
    if {![string match "*Complete*" $synth_status]} {
        puts "ERROR: Synthesis failed!"
        close_project
        exit 1
    }
}

# ==============================================
# Step 2: Implementation
# ==============================================
puts "INFO: Starting implementation..."
reset_run impl_1
launch_runs impl_1 -jobs 4
wait_on_run impl_1

set impl_status [get_property STATUS [get_runs impl_1]]
puts "Implementation Status: $impl_status"

if {![string match "*Complete*" $impl_status]} {
    puts "ERROR: Implementation failed!"
    close_project
    exit 1
}

# ==============================================
# Step 3: Generate Bitstream
# ==============================================
puts "INFO: Generating bitstream..."
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

set bitstream_status [get_property STATUS [get_runs impl_1]]
puts "Bitstream Status: $bitstream_status"

# Close project
close_project

# Final status
if {[string match "*Complete*" $bitstream_status]} {
    set bitstream_file [file join $project_dir plcpu_project.runs impl_1 plcpu_top.bit]
    puts "=============================================="
    puts "SUCCESS: Bitstream generated!"
    puts "Bitstream File: $bitstream_file"
    puts "=============================================="
    exit 0
} else {
    puts "ERROR: Bitstream generation failed!"
    exit 1
}