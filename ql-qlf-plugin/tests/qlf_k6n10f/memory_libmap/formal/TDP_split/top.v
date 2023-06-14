`default_nettype none
`include "params.vh"

module top(clk1a, clk1b, a1a, rd1a, re1a, a1b, rd1b, re1b, wd1a, we1a, be1a, wd1b, we1b, be1b, clk2a, clk2b, a2a, rd2a, re2a, a2b, rd2b, re2b, wd2a, we2a, be2a, wd2b, we2b, be2b);

input wire clk1a;
input wire clk1b;
input wire [A1_ADDRWIDTH-1:0] a1a;
output reg [A1_DATAWIDTH-1:0] rd1a;
input wire re1a;
input wire [B1_ADDRWIDTH-1:0] a1b;
output reg [B1_DATAWIDTH-1:0] rd1b;
input wire re1b;
input wire [A1_DATAWIDTH-1:0] wd1a;
input wire we1a;
input wire [(A1_DATAWIDTH/BYTEWIDTH)-1:0] be1a;
input wire [B1_DATAWIDTH-1:0] wd1b;
input wire we1b;
input wire [(B1_DATAWIDTH/BYTEWIDTH)-1:0] be1b;

input wire clk2a;
input wire clk2b;
input wire [A2_ADDRWIDTH-1:0] a2a;
output reg [A2_DATAWIDTH-1:0] rd2a;
input wire re2a;
input wire [B2_ADDRWIDTH-1:0] a2b;
output reg [B2_DATAWIDTH-1:0] rd2b;
input wire re2b;
input wire [A2_DATAWIDTH-1:0] wd2a;
input wire we2a;
input wire [(A2_DATAWIDTH/BYTEWIDTH)-1:0] be2a;
input wire [B2_DATAWIDTH-1:0] wd2b;
input wire we2b;
input wire [(B2_DATAWIDTH/BYTEWIDTH)-1:0] be2b;


(* syn_ramstyle = "block_ram" *)
reg [A1_DATAWIDTH-1:0] mem1 [0:DEPTH1-1];

(* syn_ramstyle = "block_ram" *)
reg [A2_DATAWIDTH-1:0] mem2 [0:DEPTH2-1];

always @(posedge clk1a) begin
	if(we1a) begin
		for (int i = 0; i < (A1_DATAWIDTH/BYTEWIDTH); i++) begin
			if (be1a[i]) mem1[a1a][i*BYTEWIDTH+:BYTEWIDTH] <= wd1a[i*BYTEWIDTH+:BYTEWIDTH];
		end
	end
	rd1a <= mem1[a1a];
end

always @(posedge clk1b) begin
	if(we1b) begin
		for (int i = 0; i < (B1_DATAWIDTH/BYTEWIDTH); i++) begin
			if (be1b[i]) mem1[a1b][i*BYTEWIDTH+:BYTEWIDTH] <= wd1b[i*BYTEWIDTH+:BYTEWIDTH];
		end
	end
	rd1b <= mem1[a1b];
end

always @(posedge clk2a) begin
	if(we2a) begin
		for (int i = 0; i < (A2_DATAWIDTH/BYTEWIDTH); i++) begin
			if (be2a[i]) mem2[a2a][i*BYTEWIDTH+:BYTEWIDTH] <= wd2a[i*BYTEWIDTH+:BYTEWIDTH];
		end
	end
	rd2a <= mem2[a2a];
end

always @(posedge clk2b) begin
	if(we2b) begin
		for (int i = 0; i < (B2_DATAWIDTH/BYTEWIDTH); i++) begin
			if (be2b[i]) mem2[a2b][i*BYTEWIDTH+:BYTEWIDTH] <= wd1b[i*BYTEWIDTH+:BYTEWIDTH];
		end
	end
	rd2b <= mem2[a2b];
end

endmodule
