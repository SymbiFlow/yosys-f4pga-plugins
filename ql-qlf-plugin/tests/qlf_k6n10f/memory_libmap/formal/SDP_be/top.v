`include "params.vh"

module top(clk, ra, wa, rd, wd, we, be);

input wire clk;
input wire we;
input wire [NBYTES-1:0] be;
input wire [ABITS-1:0] wa;
input wire [DBITS-1:0] wd;
input wire [ABITS-1:0] ra;
output reg [DBITS-1:0] rd;

(* syn_ramstyle = "block_ram" *)
reg [DBITS-1:0] mem [0:DEPTH-1];

always @(posedge clk) begin

	if(we) begin
		for (int i = 0; i < NBYTES; i++) begin
			if (be[i]) mem[wa][i*BYTEWIDTH+:BYTEWIDTH] <= wd[i*BYTEWIDTH+:BYTEWIDTH];
		end
	end

	rd <= mem[ra];
end


endmodule
