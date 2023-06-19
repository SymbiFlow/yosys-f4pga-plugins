// Copyright 2020-2022 F4PGA Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

module spram_16x2048_32x1024 (
	clk,
	rce,
	ra,
	rq,
	wce,
	wa,
	wd
);
	input clk;
	input rce;
	input [9:0] ra;
	output reg [31:0] rq;
	input wce;
	input [10:0] wa;
	input [15:0] wd;
	(* no_rw_check = 1 *) reg [15:0] memory [0:2047];
	always @(posedge clk) begin
		if (rce) begin
			rq[15:0] <= memory[{ra, 1'b0}];
			rq[31:16] <= memory[{ra, 1'b1}];
		end
		if (wce)
			memory[wa] <= wd;
	end
endmodule

module spram_8x2048_16x1024 (
	clk,
	rce,
	ra,
	rq,
	wce,
	wa,
	wd
);
	input clk;
	input rce;
	input [9:0] ra;
	output reg [15:0] rq;
	input wce;
	input [10:0] wa;
	input [7:0] wd;
	(* no_rw_check = 1 *) reg [7:0] memory [0:2047];
	always @(posedge clk) begin
		if (rce) begin
			rq[7:0] <= memory[{ra, 1'b0}];
			rq[15:8] <= memory[{ra, 1'b1}];
		end
		if (wce)
			memory[wa] <= wd;
	end
endmodule

module spram_8x4096_16x2048 (
	clk,
	rce,
	ra,
	rq,
	wce,
	wa,
	wd
);
	input clk;
	input rce;
	input [10:0] ra;
	output reg [15:0] rq;
	input wce;
	input [11:0] wa;
	input [7:0] wd;
	(* no_rw_check = 1 *) reg [7:0] memory [0:4095];
	always @(posedge clk) begin
		if (rce) begin
			rq[7:0] <= memory[{ra, 1'b0}];
			rq[15:8] <= memory[{ra, 1'b1}];
		end
		if (wce)
			memory[wa] <= wd;
	end
endmodule

module spram_8x4096_32x1024 (
	clk,
	rce,
	ra,
	rq,
	wce,
	wa,
	wd
);
	input clk;
	input rce;
	input [9:0] ra;
	output reg [31:0] rq;
	input wce;
	input [11:0] wa;
	input [7:0] wd;
	(* no_rw_check = 1 *) reg [7:0] memory [0:4095];
	always @(posedge clk) begin
		if (rce) begin
			rq[7:0] <= memory[{ra, 2'b00}];
			rq[15:8] <= memory[{ra, 2'b01}];
			rq[23:16] <= memory[{ra, 2'b10}];
			rq[31:24] <= memory[{ra, 2'b11}];
		end
		if (wce)
			memory[wa] <= wd;
	end
endmodule