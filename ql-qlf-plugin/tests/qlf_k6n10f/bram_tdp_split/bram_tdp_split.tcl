yosys -import

if { [info procs ql-qlf-k6n10f] == {} } { plugin -i ql-qlf }
yosys -import  ;

read_verilog $::env(DESIGN_TOP).v
design -save bram_tdp_split

select BRAM_TDP_SPLIT_2x18x1024
select *
synth_quicklogic -family qlf_k6n10f -top BRAM_TDP_SPLIT_2x18x1024 -bram_types
opt_expr -undriven
opt_clean
stat
write_verilog sim/bram_tdp_split_2x18x1024_post_synth.v
select -assert-count 1 t:TDP36K_BRAM_A1_X18_B1_X18_A2_X18_B2_X18_split

select -clear
design -load bram_tdp_split
select BRAM_TDP_SPLIT_2x16x1024
select *
synth_quicklogic -family qlf_k6n10f -top BRAM_TDP_SPLIT_2x16x1024 -bram_types
opt_expr -undriven
opt_clean
stat
write_verilog sim/bram_tdp_split_2x16x1024_post_synth.v
select -assert-count 1 t:TDP36K_BRAM_A1_X18_B1_X18_A2_X18_B2_X18_split

select -clear
design -load bram_tdp_split
select BRAM_TDP_SPLIT_2x9x2048
select *
synth_quicklogic -family qlf_k6n10f -top BRAM_TDP_SPLIT_2x9x2048 -bram_types
opt_expr -undriven
opt_clean
stat
write_verilog sim/bram_tdp_split_2x9x2048_post_synth.v
select -assert-count 1 t:TDP36K_BRAM_A1_X9_B1_X9_A2_X9_B2_X9_split

select -clear
design -load bram_tdp_split
select BRAM_TDP_SPLIT_2x8x2048
select *
synth_quicklogic -family qlf_k6n10f -top BRAM_TDP_SPLIT_2x8x2048 -bram_types
opt_expr -undriven
opt_clean
stat
write_verilog sim/bram_tdp_split_2x8x2048_post_synth.v
select -assert-count 1 t:TDP36K_BRAM_A1_X9_B1_X9_A2_X9_B2_X9_split

select -clear
design -load bram_tdp_split
select BRAM_TDP_SPLIT_2x4x4096
select *
synth_quicklogic -family qlf_k6n10f -top BRAM_TDP_SPLIT_2x4x4096 -bram_types
opt_expr -undriven
opt_clean
stat
write_verilog sim/bram_tdp_split_2x4x4096_post_synth.v
select -assert-count 1 t:TDP36K_BRAM_A1_X4_B1_X4_A2_X4_B2_X4_split

select -clear
design -load bram_tdp_split
select BRAM_TDP_SPLIT_2x2x8192
select *
synth_quicklogic -family qlf_k6n10f -top BRAM_TDP_SPLIT_2x2x8192 -bram_types
opt_expr -undriven
opt_clean
stat
write_verilog sim/bram_tdp_split_2x2x8192_post_synth.v
select -assert-count 1 t:TDP36K_BRAM_A1_X2_B1_X2_A2_X2_B2_X2_split

select -clear
design -load bram_tdp_split
select BRAM_TDP_SPLIT_2x1x16384
select *
synth_quicklogic -family qlf_k6n10f -top BRAM_TDP_SPLIT_2x1x16384 -bram_types
opt_expr -undriven
opt_clean
stat
write_verilog sim/bram_tdp_split_2x1x16384_post_synth.v
select -assert-count 1 t:TDP36K_BRAM_A1_X1_B1_X1_A2_X1_B2_X1_split

