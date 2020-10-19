yosys -import
plugin -i sdc
# Import the commands from the plugins to the tcl interpreter
yosys -import

read_verilog $::env(DESIGN_TOP).v
read_verilog -specify -lib -D_EXPLICIT_CARRY +/xilinx/cells_sim.v
read_verilog -lib +/xilinx/cells_xtra.v
hierarchy -check -auto-top

# Start flow after library reading
synth_xilinx -vpr -flatten -abc9 -nosrl -nodsp -iopad -run prepare:check

# Read the design timing constraints
read_sdc $::env(DESIGN_TOP).input.sdc

# Write out the SDC file after the clock propagation step
write_sdc $::env(DESIGN_TOP).sdc
