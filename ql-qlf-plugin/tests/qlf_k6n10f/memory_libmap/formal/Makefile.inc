BASE_DIR=../../../../..
QL_PLUGIN=$(BASE_DIR)/build/ql-qlf.so

formal: top.new.il params.vh top.v equiv.sby
	sby -f equiv.sby

top.new.il: $(QL_PLUGIN) params.vh top.v ../make_gate.ys $(BASE_DIR)/qlf_k6n10f/libmap_brams.txt $(BASE_DIR)/qlf_k6n10f/libmap_brams_map.v
	yosys -m $(QL_PLUGIN) -ql top.log ../make_gate.ys

$(QL_PLUGIN):
	make -C $(BASE_DIR)

clean:
	rm -rf top.*.il top.new top.debug top.log top.new.v equiv equiv_bmc equiv_cover

.PHONY: formal clean
