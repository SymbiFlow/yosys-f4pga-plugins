yosys -import

if { [info procs ql-qlf-k6n10f] == {} } { plugin -i ql-qlf }
yosys -import  ;

read_verilog $::env(DESIGN_TOP).v
design -save bram18k_tdp

select dpram_18x1024_x2
select *
synth_quicklogic -family qlf_k6n10f -top dpram_18x1024_x2 -bram_types
opt_expr -undriven
opt_clean
stat
write_verilog sim/dpram_18x1024_x2_post_synth.v
select -assert-count 2 t:TDP36K_BRAM_A1_X18_B1_X18_A2_X18_B2_X18_split 

select -clear
design -load bram18k_tdp
select dpram_9x2048_x2
select *
synth_quicklogic -family qlf_k6n10f -top dpram_9x2048_x2 -bram_types
opt_expr -undriven
opt_clean
stat
write_verilog sim/dpram_9x2048_x2_post_synth.v
select -assert-count 2 t:TDP36K_BRAM_A1_X9_B1_X9_A2_X9_B2_X9_split 

select -clear
design -load bram18k_tdp
select dpram_18x1024_9x2048
select *
synth_quicklogic -family qlf_k6n10f -top dpram_18x1024_9x2048 -bram_types
opt_expr -undriven
opt_clean
stat
write_verilog sim/dpram_18x1024_9x2048_post_synth.v
select -assert-count 1 t:TDP36K_BRAM_A1_X18_B1_X18_A2_X9_B2_X9_split
