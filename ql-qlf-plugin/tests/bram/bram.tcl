yosys -import
if { [info procs synth_quicklogic] == {} } { plugin -i ql-qlf }
plugin -i ql-dsp
yosys -import  ;# ingest plugin commands

read_verilog $::env(DESIGN_TOP).v
design -save read
hierarchy -top BRAM_32x512
yosys proc
synth_quicklogic -family qlf_k6n10 -top BRAM_32x512
yosys cd BRAM_32x512
stat
select -assert-count 1 t:DP_RAM16K

design -load read
synth_quicklogic -family qlf_k6n10 -top BRAM_16x1024
yosys cd BRAM_16x1024
stat
select -assert-count 1 t:DP_RAM16K

design -load read
synth_quicklogic -family qlf_k6n10 -top BRAM_8x2048
yosys cd BRAM_8x2048
stat
select -assert-count 1 t:DP_RAM16K

design -load read
synth_quicklogic -family qlf_k6n10 -top BRAM_4x4096
yosys cd BRAM_4x4096
stat
select -assert-count 1 t:DP_RAM16K
