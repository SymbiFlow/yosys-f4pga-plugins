/*
 * Copyright 2020-2022 F4PGA Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 */
#include "kernel/celltypes.h"
#include "kernel/log.h"
#include "kernel/register.h"
#include "kernel/rtlil.h"

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

#define XSTR(val) #val
#define STR(val) XSTR(val)

#ifndef PASS_NAME
#define PASS_NAME synth_quicklogic
#endif

struct SynthQuickLogicPass : public ScriptPass {

    SynthQuickLogicPass() : ScriptPass(STR(PASS_NAME), "Synthesis for QuickLogic FPGAs") {}

    void help() override
    {
        log("\n");
        log("   %s [options]\n", STR(PASS_NAME));
        log("This command runs synthesis for QuickLogic FPGAs\n");
        log("\n");
        log("    -top <module>\n");
        log("         use the specified module as top module\n");
        log("\n");
        log("    -family <family>\n");
        log("        run synthesis for the specified QuickLogic architecture\n");
        log("        generate the synthesis netlist for the specified family.\n");
        log("        supported values:\n");
        log("        - pp3\n");
        log("        - qlf_k4n8\n");
        log("        - qlf_k6n10\n");
        log("        - qlf_k6n10f\n");
        log("\n");
        log("    -no_abc_opt\n");
        log("        By default most of ABC logic optimization features is\n");
        log("        enabled. Specifying this switch turns them off.\n");
        log("\n");
        log("    -edif <file>\n");
        log("        write the design to the specified edif file. Writing of an output file\n");
        log("        is omitted if this parameter is not specified.\n");
        log("\n");
        log("    -blif <file>\n");
        log("        write the design to the specified BLIF file. Writing of an output file\n");
        log("        is omitted if this parameter is not specified.\n");
        log("\n");
        log("    -verilog <file>\n");
        log("        write the design to the specified verilog file. Writing of an output\n");
        log("        file is omitted if this parameter is not specified.\n");
        log("\n");
        log("    -no_dsp\n");
        log("        By default use DSP blocks in output netlist.\n");
        log("        do not use DSP blocks to implement multipliers and associated logic\n");
        log("\n");
        log("    -use_dsp_cfg_params\n");
        log("        By default use DSP blocks with configuration bits available at module\n");
        log("        ports. Specifying this forces usage of DSP block with configuration\n");
        log("        bits available as module parameters.\n");
        log("\n");
        log("    -no_adder\n");
        log("        By default use adder cells in output netlist.\n");
        log("        Specifying this switch turns it off.\n");
        log("\n");
        log("    -no_bram\n");
        log("        By default use Block RAM in output netlist.\n");
        log("        Specifying this switch turns it off.\n");
        log("\n");
        log("    -bram_types\n");
        log("        Emit specialized BRAM cells for particular address and data width\n");
        log("        configurations.\n");
        log("\n");
        log("    -no_ff_map\n");
        log("        By default ff techmap is turned on. Specifying this switch turns it off.\n");
        log("\n");
        log("    -nosdff\n");
        log("        By default infer synchronous S/R flip-flops for architectures that\n");
        log("        support them. Specifying this switch turns it off.\n");
        log("\n");
        log("    -noopt\n");
        log("        By default all optimizations are turned on. \n");
        log("        Specifying this switch turns off all optimizations and only maps the design.\n");
        log("\n");
        log("\n");
        log("The following commands are executed by this synthesis command:\n");
        help_script();
        log("\n");
    }

    string top_opt, edif_file, blif_file, family, currmodule, verilog_file, use_dsp_cfg_params, lib_path;
    bool nodsp;
    bool inferAdder;
    bool inferBram;
    bool bramTypes;
    bool abcOpt;
    bool abc9;
    bool noffmap;
    bool nosdff;
    bool noOpt;

    void clear_flags() override
    {
        top_opt = "-auto-top";
        edif_file = "";
        blif_file = "";
        verilog_file = "";
        currmodule = "";
        family = "qlf_k4n8";
        inferAdder = true;
        inferBram = true;
        bramTypes = false;
        abcOpt = true;
        abc9 = true;
        noffmap = false;
        nodsp = false;
        nosdff = false;
	noOpt = false;
        use_dsp_cfg_params = "";
        lib_path = "+/quicklogic/";
    }

    void execute(std::vector<std::string> args, RTLIL::Design *design) override
    {
        string run_from, run_to;
        clear_flags();
        lib_path = design->scratchpad_get_string("ql.lib_path", lib_path);
        size_t argidx;
        for (argidx = 1; argidx < args.size(); argidx++) {
            if (args[argidx] == "-run" && argidx + 1 < args.size()) {
                size_t pos = args[argidx + 1].find(':');
                if (pos == std::string::npos) {
                    run_from = args[++argidx];
                    run_to = args[argidx];
                } else {
                    run_from = args[++argidx].substr(0, pos);
                    run_to = args[argidx].substr(pos + 1);
                }
                continue;
            }
            if (args[argidx] == "-top" && argidx + 1 < args.size()) {
                top_opt = "-top " + args[++argidx];
                continue;
            }
            if (args[argidx] == "-edif" && argidx + 1 < args.size()) {
                edif_file = args[++argidx];
                continue;
            }

            if (args[argidx] == "-family" && argidx + 1 < args.size()) {
                family = args[++argidx];
                continue;
            }
            if (args[argidx] == "-blif" && argidx + 1 < args.size()) {
                blif_file = args[++argidx];
                continue;
            }
            if (args[argidx] == "-verilog" && argidx + 1 < args.size()) {
                verilog_file = args[++argidx];
                continue;
            }
            if (args[argidx] == "-no_dsp") {
                nodsp = true;
                continue;
            }
            if (args[argidx] == "-use_dsp_cfg_params") {
                use_dsp_cfg_params = " -use_dsp_cfg_params";
                continue;
            }
            if (args[argidx] == "-no_adder") {
                inferAdder = false;
                continue;
            }
            if (args[argidx] == "-no_bram") {
                inferBram = false;
                continue;
            }
            if (args[argidx] == "-bram_types") {
                bramTypes = true;
                continue;
            }
            if (args[argidx] == "-no_abc_opt") {
                abcOpt = false;
                continue;
            }
            if (args[argidx] == "-no_abc9") {
                abc9 = false;
                continue;
            }
            if (args[argidx] == "-no_ff_map") {
                noffmap = true;
                continue;
            }
            if (args[argidx] == "-nosdff") {
                nosdff = true;
                continue;
            }
            if (args[argidx] == "-no_opt") {
                noOpt = true;
		abcOpt = false;
                continue;
            }

            break;
        }
        extra_args(args, argidx, design);

        if (!design->full_selection())
            log_cmd_error("This command only operates on fully selected designs!\n");

        if (family != "pp3" && family != "qlf_k4n8" && family != "qlf_k6n10" && family != "qlf_k6n10f")
            log_cmd_error("Invalid family specified: '%s'\n", family.c_str());

        //if (family != "pp3") {
        //    abc9 = false;
        //}

        if (family == "qlf_k4n8") {
            nosdff = true;
        }

        if (abc9 && design->scratchpad_get_int("abc9.D", 0) == 0) {
            log_warning("delay target has not been set via SDC or scratchpad; assuming 12 MHz clock.\n");
            if (family == "pp3") {
		design->scratchpad_set_int("abc9.D", 41666); // 12MHz = 83.33.. ns; divided by two to allow for interconnect delay.
	    }
            if (family == "qlf_k6n10f") {
                design->scratchpad_set_int("abc9.W", 1000);  //set interconnet delay as 1ns 
	    }
        }

        log_header(design, "Executing SYNTH_QUICKLOGIC pass.\n");
        log_push();

        run_script(design, run_from, run_to);

        log_pop();
    }

    void script() override
    {
        if (help_mode) {
            family = "<family>";
        }

        std::string noDFFArgs;
        if (check_label("begin")) {
            std::string family_path = " " + lib_path + family;
            std::string readVelArgs;

            // Read simulation library
            readVelArgs = family_path + "/cells_sim.v";
            if (family == "qlf_k6n10f") {
                readVelArgs += family_path + "/dsp_sim.v";
                readVelArgs += family_path + "/brams_sim.v";
                if (bramTypes)
                    readVelArgs += family_path + "/bram_types_sim.v";
            }

            // Use -nomem2reg here to prevent Yosys from complaining about
            // some block ram cell models. After all the only part of the cells
            // library required here is cell port definitions plus specify blocks.
            run("read_verilog -lib -specify -nomem2reg " + lib_path + "common/cells_sim.v" + readVelArgs);
            run(stringf("hierarchy -check %s", help_mode ? "-top <top>" : top_opt.c_str()));
        }

        if (check_label("prepare")) {
            run("proc");
            run("flatten");
            if (help_mode || family == "pp3") {
                run("tribuf -logic", "                   (for pp3)");
            }
            run("deminout");
	    if (!noOpt) {
            	run("opt_expr");
            	run("opt_clean");
	    }

            if (nosdff) {
                noDFFArgs += " -nosdff";
            }
            if (family == "qlf_k4n8") {
                noDFFArgs += " -nodffe";
            }

            run("check");
	    if (!noOpt) {
            	run("opt -nodffe -nosdff");
            	run("fsm");
            	run("opt" + noDFFArgs);
            	run("wreduce");
            	run("peepopt");
            	run("opt_clean");
                run("share");
	    }
        }

        if (check_label("map_dsp"), "(skip if -no_dsp)") {
            if (help_mode || family == "qlf_k6n10") {
                if (help_mode || !nodsp) {
                    run("memory_dff", "                      (for qlf_k6n10)");
	    	    if (!noOpt) {
                    	run("wreduce t:$mul", "                  (for qlf_k6n10)");
		    }
                    run("techmap -map +/mul2dsp.v -map " + lib_path + family +
                          "/dsp_map.v -D DSP_A_MAXWIDTH=16 -D DSP_B_MAXWIDTH=16 "
                          "-D DSP_A_MINWIDTH=2 -D DSP_B_MINWIDTH=2 -D DSP_Y_MINWIDTH=11 "
                          "-D DSP_NAME=$__MUL16X16",
                        "    (for qlf_k6n10)");
                    run("select a:mul2dsp", "                (for qlf_k6n10)");
                    run("setattr -unset mul2dsp", "          (for qlf_k6n10)");
	    	    if (!noOpt) {
                    	run("opt_expr -fine", "                  (for qlf_k6n10)");
                    	run("wreduce", "                         (for qlf_k6n10)");
		    }
                    run("select -clear", "                   (for qlf_k6n10)");
                    run("ql_dsp", "                          (for qlf_k6n10)");
                    run("chtype -set $mul t:$__soft_mul", "  (for qlf_k6n10)");
                }
            }
            if (help_mode || family == "qlf_k6n10f") {

                struct DspParams {
                    size_t a_maxwidth;
                    size_t b_maxwidth;
                    size_t a_minwidth;
                    size_t b_minwidth;
                    std::string type;
                };

                const std::vector<DspParams> dsp_rules = {
                  {20, 18, 11, 10, "$__QL_MUL20X18"},
                  {10, 9, 4, 4, "$__QL_MUL10X9"},
                };

                if (help_mode) {
                    run("wreduce t:$mul", "                  (for qlf_k6n10f)");
                    run("ql_dsp_macc" + use_dsp_cfg_params, "(for qlf_k6n10f)");
                    run("techmap -map +/mul2dsp.v [...]", "  (for qlf_k6n10f)");
                    run("chtype -set $mul t:$__soft_mul", "  (for qlf_k6n10f)");
                    run("techmap -map " + lib_path + family + "/dsp_map.v", "(for qlf_k6n10f)");
                    if (use_dsp_cfg_params.empty())
                        run("techmap -map " + lib_path + family + "/dsp_map.v -D USE_DSP_CFG_PARAMS=0", "(for qlf_k6n10f)");
                    else
                        run("techmap -map " + lib_path + family + "/dsp_map.v -D USE_DSP_CFG_PARAMS=1", "(for qlf_k6n10f)");
                    run("ql_dsp_simd", "                     (for qlf_k6n10f)");
                    run("techmap -map " + lib_path + family + "/dsp_final_map.v", "(for qlf_k6n10f)");
                    run("ql_dsp_io_regs", "                  (for qlf_k6n10f)");
                } else if (!nodsp) {

                    run("wreduce t:$mul");
                    run("ql_dsp_macc" + use_dsp_cfg_params);

                    for (const auto &rule : dsp_rules) {
                        run(stringf("techmap -map +/mul2dsp.v "
                                    "-D DSP_A_MAXWIDTH=%zu -D DSP_B_MAXWIDTH=%zu "
                                    "-D DSP_A_MINWIDTH=%zu -D DSP_B_MINWIDTH=%zu "
                                    "-D DSP_NAME=%s",
                                    rule.a_maxwidth, rule.b_maxwidth, rule.a_minwidth, rule.b_minwidth, rule.type.c_str()));
                        run("chtype -set $mul t:$__soft_mul");
                    }
                    if (use_dsp_cfg_params.empty())
                        run("techmap -map " + lib_path + family + "/dsp_map.v -D USE_DSP_CFG_PARAMS=0");
                    else
                        run("techmap -map " + lib_path + family + "/dsp_map.v -D USE_DSP_CFG_PARAMS=1");
                    run("ql_dsp_simd");
                    run("techmap -map " + lib_path + family + "/dsp_final_map.v");
                    run("ql_dsp_io_regs");
                }
            }
        }

        if (check_label("coarse")) {
            run("techmap -map +/cmp2lut.v -D LUT_WIDTH=4");
	    if (!noOpt) {
            	run("opt_expr");
            	run("opt_clean");
	    }
            run("alumacc");
            run("pmuxtree");
	    if (!noOpt) {
            	run("opt" + noDFFArgs);
	    }
            run("memory -nomap");
	    if (!noOpt) {
            	run("opt_clean");
	    }
        }

        if (check_label("map_bram", "(skip if -no_bram)") && (help_mode || family == "qlf_k6n10" || family == "qlf_k6n10f" || family == "pp3") && inferBram) {
            if (help_mode || family == "qlf_k6n10f") {
                run("memory_libmap -lib " + lib_path + family + "/libmap_brams.txt", "(for qlf_k6n10f)");
                run("ql_bram_merge", "(for qlf_k6n10f)");
                run("techmap -map " + lib_path + family + "/libmap_brams_map.v", "(for qlf_k6n10f)");
            }
            if (help_mode || family == "qlf_k6n10" || family == "pp3") {
                run("memory_bram -rules " + lib_path + family + "/brams.txt", "(for pp3, qlf_k6n10)");
            }
            if (help_mode || family == "pp3") {
                run("pp3_braminit", "(for pp3)");
            }
            run("techmap -autoproc -map " + lib_path + family + "/brams_map.v");
            if (family == "qlf_k6n10f") {
                run("techmap -map " + lib_path + family + "/brams_final_map.v");
            }

           
            // Perform a series of 'chtype' passess
            if (help_mode) {
                run("chtype -set TDP36K_<mode> t:TDP36K a:<mode>", "(if -bram_types)");
            }
            if (bramTypes) {
							
				for (int a_dwidth : {1, 2, 4, 9, 18, 36})
                    for (int b_dwidth: {1, 2, 4, 9, 18, 36}) {
                        auto cmd = stringf("chtype -set TDP36K_BRAM_A_X%d_B_X%d_nonsplit t:TDP36K a:is_inferred=0 %%i a:is_fifo=0 %%i a:port_a_dwidth=%d %%i a:port_b_dwidth=%d %%i",
                                            a_dwidth, b_dwidth, a_dwidth, b_dwidth);
                        run(cmd);						
						
                        auto cmd1 = stringf("chtype -set TDP36K_FIFO_ASYNC_A_X%d_B_X%d_nonsplit t:TDP36K a:is_inferred=0 %%i a:is_fifo=1 %%i a:sync_fifo=0 %%i "
                                            "a:port_a_dwidth=%d %%i a:port_b_dwidth=%d %%i",
                                            a_dwidth, b_dwidth, a_dwidth, b_dwidth);
                        run(cmd1);

                        auto cmd2 = stringf("chtype -set TDP36K_FIFO_SYNC_A_X%d_B_X%d_nonsplit t:TDP36K a:is_inferred=0 %%i a:is_fifo=1 %%i a:sync_fifo=1 %%i "
                                            "a:port_a_dwidth=%d %%i a:port_b_dwidth=%d %%i",
                                            a_dwidth, b_dwidth, a_dwidth, b_dwidth);
                        run(cmd2);
                    }

                for (int a1_dwidth : {1, 2, 4, 9, 18})
                    for (int b1_dwidth: {1, 2, 4, 9, 18})
                        for (int a2_dwidth : {1, 2, 4, 9, 18})
                            for (int b2_dwidth: {1, 2, 4, 9, 18}) {
                                auto cmd = stringf("chtype -set TDP36K_BRAM_A1_X%d_B1_X%d_A2_X%d_B2_X%d_split t:TDP36K a:is_inferred=0 %%i a:is_split=1 %%i a:is_fifo=0 %%i a:port_a1_dwidth=%d %%i a:port_b1_dwidth=%d %%i a:port_a2_dwidth=%d %%i a:port_b2_dwidth=%d %%i",
                                                    a1_dwidth, b1_dwidth, a2_dwidth, b2_dwidth, a1_dwidth, b1_dwidth, a2_dwidth, b2_dwidth);
                                run(cmd);	
										
                                auto cmd1 = stringf("chtype -set TDP36K_FIFO_ASYNC_A1_X%d_B1_X%d_A2_X%d_B2_X%d_split t:TDP36K a:is_inferred=0 %%i a:is_split=1 %%i a:is_fifo=1 %%i a:sync_fifo=0 %%i "
                                                     "a:port_a1_dwidth=%d %%i a:port_b1_dwidth=%d %%i a:port_a2_dwidth=%d %%i a:port_b2_dwidth=%d %%i",
                                                    a1_dwidth, b1_dwidth, a2_dwidth, b2_dwidth, a1_dwidth, b1_dwidth, a2_dwidth, b2_dwidth);
                                run(cmd1);

                                auto cmd2 = stringf("chtype -set TDP36K_FIFO_SYNC_A1_X%d_B1_X%d_A2_X%d_B2_X%d_split t:TDP36K a:is_inferred=0 %%i a:is_split=1 %%i a:is_fifo=1 %%i a:sync_fifo=1 %%i "
                                                    "a:port_a1_dwidth=%d %%i a:port_b1_dwidth=%d %%i a:port_a2_dwidth=%d %%i a:port_b2_dwidth=%d %%i",
                                                    a1_dwidth, b1_dwidth, a2_dwidth, b2_dwidth, a1_dwidth, b1_dwidth, a2_dwidth, b2_dwidth);
                                run(cmd2);
                            }				
				

                for (int a_width : {1, 2, 4, 9, 18, 36})
                    for (int b_width: {1, 2, 4, 9, 18, 36}) {
                        auto cmd = stringf(
                          "chtype -set TDP36K_BRAM_A_X%d_B_X%d_nonsplit t:TDP36K a:is_inferred=1 %%i a:port_a_width=%d %%i a:port_b_width=%d %%i",
                          a_width, b_width, a_width, b_width);
                        run(cmd);
                    }

                for (int a1_width : {1, 2, 4, 9, 18})
                    for (int b1_width: {1, 2, 4, 9, 18})
                        for (int a2_width : {1, 2, 4, 9, 18})
                            for (int b2_width: {1, 2, 4, 9, 18}) {
                                auto cmd = stringf(
                                "chtype -set TDP36K_BRAM_A1_X%d_B1_X%d_A2_X%d_B2_X%d_split t:TDP36K a:is_inferred=1 %%i a:port_a1_width=%d %%i a:port_b1_width=%d %%i a:port_a2_width=%d %%i a:port_b2_width=%d %%i",
                                a1_width, b1_width, a2_width, b2_width, a1_width, b1_width, a2_width, b2_width);
                                run(cmd);
                            }
            }
        }

        if (check_label("map_ffram")) {
	    if (!noOpt) {
            	run("opt -fast -mux_undef -undriven -fine" + noDFFArgs);
	    }
            run("memory_map -iattr -attr !ram_block -attr !rom_block -attr logic_block "
                "-attr syn_ramstyle=auto -attr syn_ramstyle=registers "
                "-attr syn_romstyle=auto -attr syn_romstyle=logic");
	    if (!noOpt) {
            	run("opt -undriven -fine" + noDFFArgs);
	    }
        }

        if (check_label("map_gates")) {
            if (help_mode || (inferAdder && (family == "qlf_k4n8" || family == "qlf_k6n10" || family == "qlf_k6n10f"))) {
                run("techmap -map +/techmap.v -map " + lib_path + family + "/arith_map.v","(unless -no_adder)");
            } else {
                run("techmap");
            }
	    if (!noOpt) {
            	run("opt -fast" + noDFFArgs);
	    }
            if (help_mode || family == "pp3") {
                run("muxcover -mux8 -mux4", "(for pp3)");
            }
	    if (!noOpt) {
            	run("opt_expr");
            	run("opt_merge");
            	run("opt_clean");
            	run("opt" + noDFFArgs);
	    }
        }

        if (check_label("map_ffs")) {
	    if (!noOpt) {
            	run("opt_expr");
	    }
            if (help_mode) {
                run("shregmap -minlen <min> -maxlen <max>", "(for qlf_k4n8, qlf_k6n10f)");
                run("dfflegalize -cell <supported FF types>");
                run("techmap -map " + lib_path + family + "/cells_map.v", "(for pp3)");
            }
            if (family == "qlf_k4n8") {
                run("shregmap -minlen 8 -maxlen 8");
                run("dfflegalize -cell $_DFF_P_ 0 -cell $_DFF_P??_ 0 -cell $_DFF_N_ 0 -cell $_DFF_N??_ 0 -cell $_DFFSR_???_ 0");
            } else if (family == "qlf_k6n10") {
                run("dfflegalize -cell $_DFF_P_ 0 -cell $_DFF_PP?_ 0 -cell $_DFFE_PP?P_ 0 -cell $_DFFSR_PPP_ 0 -cell $_DFFSRE_PPPP_ 0 -cell "
                    "$_DLATCHSR_PPP_ 0");
                //    In case we add clock inversion in the future.
                //    run("dfflegalize -cell $_DFF_?_ 0 -cell $_DFF_?P?_ 0 -cell $_DFFE_?P?P_ 0 -cell $_DFFSR_?PP_ 0 -cell $_DFFSRE_?PPP_ 0 -cell
                //    $_DLATCH_SRPPP_ 0");
            } else if (family == "qlf_k6n10f") {
                run("shregmap -minlen 8 -maxlen 20");
                // FIXME: dfflegalize seems to leave $_DLATCH_[NP]_ even if it
                // is not allowed. So we allow them and map them later to
                // $_DLATCHSR_[NP]NN_.
                std::string legalizeArgs = " -cell $_DFFSRE_?NNP_ 0 -cell $_DLATCHSR_?NN_ 0 -cell $_DLATCH_?_ 0";
                if (!nosdff) {
                    legalizeArgs += " -cell $_SDFFE_?N?P_ 0";
                }
                run("dfflegalize" + legalizeArgs);
            } else if (family == "pp3") {
                run("dfflegalize -cell $_DFFSRE_PPPP_ 0 -cell $_DLATCH_?_ x");
                run("techmap -map " + lib_path + family + "/cells_map.v");
            }
            std::string techMapArgs = " -map +/techmap.v -map " + lib_path + family + "/ffs_map.v";
            if (help_mode || !noffmap) {
                run("techmap " + techMapArgs, "(unless -no_ff_map)");
            }
            if (help_mode || family == "pp3") {
                run("opt_expr -mux_undef", "(for pp3)");
            }
	    if (!noOpt) {
                run("opt_merge");
                run("opt_clean");
                run("opt" + noDFFArgs);
	    }
        }

        if (check_label("map_luts")) {
            if (help_mode || abcOpt) {
                if (help_mode || family == "qlf_k6n10" || family == "qlf_k6n10f") {
                    if (abc9) {
                        run("read_verilog -lib -specify -icells +/quicklogic/pp3/abc9_model.v");
                        //run("techmap -map +/quicklogic/pp3/abc9_map.v");
                        //run("abc9 -maxlut 6 -dff");
                        run("abc9 -maxlut 6");
                        //run("techmap -map +/quicklogic/pp3/abc9_unmap.v");
                    } else {
                        run("abc -lut 6 ", "(for qlf_k6n10, qlf_k6n10f)");
		    }                    
                }
                if (help_mode || family == "qlf_k4n8") {
                    run("abc -lut 4 ", "(for qlf_k4n8)");
                }
                if (help_mode || family == "pp3") {
                    run("techmap -map " + lib_path + family + "/latches_map.v", "(for pp3)");
                    if (help_mode || abc9) {
                        run("read_verilog -lib -specify -icells " + lib_path + family + "/abc9_model.v", "(for pp3)");
                        run("techmap -map " + lib_path + family + "/abc9_map.v", "   (for pp3)");
                        run("abc9 -maxlut 4 -dff", "                             (for pp3)");
                        run("techmap -map " + lib_path + family + "/abc9_unmap.v", " (for pp3)");
                    } 
                    if (help_mode || !abc9) {
                        std::string lutDefs = "" + lib_path + family + "/lutdefs.txt";
                        rewrite_filename(lutDefs);

                        std::string abcArgs = help_mode ? "<script>" :
                                              "+read_lut," + lutDefs +
                                              ";"
                                              "strash;ifraig;scorr;dc2;dretime;strash;dch,-f;if;mfs2;" // Common Yosys ABC script
                                              "sweep;eliminate;if;mfs;lutpack;"                        // Optimization script
                                              "dress";                                                 // "dress" to preserve names

                        run("abc -script " + abcArgs, "                            (for pp3 if -no_abc9)");
                    }
                }
            }
            run("clean");
	    if (!noOpt) {
            	run("opt_lut");
	    }
        }

        if (check_label("map_cells", "(for pp3, qlf_k6n10)") && (help_mode || family == "qlf_k6n10" || family == "pp3")) {
            std::string techMapArgs;
            techMapArgs = "-map " + lib_path + family + "/lut_map.v";
            run("techmap " + techMapArgs);
            run("clean");
        }

        if (check_label("check")) {
            run("autoname");
            run("hierarchy -check");
            run("stat");
            run("check -noinit");
        }

        if (check_label("iomap", "(for pp3)") && (family == "pp3" || help_mode)) {
            run("clkbufmap -inpad ckpad Q:P");
            run("iopadmap -bits -outpad outpad A:P -inpad inpad Q:P -tinoutpad bipad EN:Q:A:P A:top");
        }

        if (check_label("finalize")) {
            if (help_mode || family == "pp3") {
                run("setundef -zero -params -undriven", "(for pp3)");
            }
            if (family == "pp3" || !edif_file.empty()) {
                run("hilomap -hicell logic_1 a -locell logic_0 a -singleton A:top", "(for pp3 or if -edif)");
            }
	    if (!noOpt) {
            	run("opt_clean -purge");
	    }
            run("check");
            run("blackbox =A:whitebox");
        }

        if (check_label("blif", "(if -blif)")) {
            if (help_mode || !blif_file.empty()) {
                run(stringf("write_blif -param %s", help_mode ? "<file-name>" : blif_file.c_str()));
            }
        }

        if (check_label("edif", "(if -edif)") && (help_mode || !edif_file.empty())) {
            run("splitnets -ports -format ()");
            run("quicklogic_eqn");

            run(stringf("write_ql_edif -nogndvcc -attrprop -pvector par %s %s", this->currmodule.c_str(), help_mode ? "<file-name>" : edif_file.c_str()));
        }

        if (check_label("verilog", "(if -verilog)")) {
            if (help_mode || !verilog_file.empty()) {
                run("write_verilog -noattr -nohex " + (help_mode ? "<file-name>" : verilog_file));
            }
        }
    }

} SynthQuicklogicPass;

PRIVATE_NAMESPACE_END
