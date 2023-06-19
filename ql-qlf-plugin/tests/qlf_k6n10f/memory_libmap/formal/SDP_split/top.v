`default_nettype none
`include "params.vh"

module top(clk1, ra1, rd1, re1, wa1, wd1, we1, be1, clk2, ra2, rd2, re2, wa2, wd2, we2, be2);

input wire clk1;
input wire [ABITS-1:0] ra1;
output reg [DBITS-1:0] rd1;
input wire re1;
input wire [ABITS-1:0] wa1;
input wire [DBITS-1:0] wd1;
input wire we1;
input wire [NBYTES-1:0] be1;

input wire clk2;
input wire [ABITS-1:0] ra2;
output reg [DBITS-1:0] rd2;
input wire re2;
input wire [ABITS-1:0] wa2;
input wire [DBITS-1:0] wd2;
input wire we2;
input wire [NBYTES-1:0] be2;


(* syn_ramstyle = "block_ram" *)
reg [DBITS-1:0] mem1 [0:DEPTH-1];

(* syn_ramstyle = "block_ram" *)
reg [DBITS-1:0] mem2 [0:DEPTH-1];

always @(posedge clk1) begin

	if(we1) begin
		for (int i = 0; i < NBYTES; i++) begin
			if (be1[i]) mem1[wa1][i*BYTEWIDTH+:BYTEWIDTH] <= wd1[i*BYTEWIDTH+:BYTEWIDTH];
		end
	end

	if(re1)
		rd1 <= mem1[ra1];
end

always @(posedge clk2) begin

	if(we2) begin
		for (int i = 0; i < NBYTES; i++) begin
			if (be2[i]) mem2[wa2][i*BYTEWIDTH+:BYTEWIDTH] <= wd2[i*BYTEWIDTH+:BYTEWIDTH];
		end
	end

	if (re2)
		rd2 <= mem2[ra2];
end

endmodule
