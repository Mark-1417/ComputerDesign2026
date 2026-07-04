# ==============================================
# CPU Synthesis Check Script
# ==============================================

set script_dir [file dirname [file normalize [info script]]]
set lab_dir [file normalize [file join $script_dir ..]]
set project_dir [file join $lab_dir vivado sccpu_project]
set project_file [file join $project_dir sccpu_project.xpr]

# Check if project exists
if {![file exists $project_file]} {
    puts "ERROR: Vivado project does not exist."
    puts "Please run scripts/create_cpu_project.tcl first."
    exit 1
}

# Open project
open_project $project_file

# ==============================================
# Run Synthesis
# ==============================================
puts "INFO: Starting synthesis..."
reset_run synth_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1

# Check synthesis status
set synth_status [get_property STATUS [get_runs synth_1]]
puts "Synthesis Status: $synth_status"

# Close project
close_project

# Exit with appropriate code
if {[string match "*Complete*" $synth_status]} {
    puts "SUCCESS: Synthesis completed successfully!"
    exit 0
} else {
    puts "ERROR: Synthesis failed!"
    exit 1
}