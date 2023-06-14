`include "params.vh"

module top(clk, ra, wa, rd, wd, we);

input wire clk;
input wire we;
input wire [ABITS-1:0] wa;
input wire [DBITS-1:0] wd;
input wire [ABITS-3:0] ra;
output reg [4*DBITS-1:0] rd;

(* syn_ramstyle = "block_ram" *)
reg [DBITS-1:0] mem [0:DEPTH-1];

always @(posedge clk) begin

	if(we) begin
		mem[wa] <= wd;
	end

	rd[1*DBITS-1:0*DBITS] <= mem[{ra, 2'b00}];
	rd[2*DBITS-1:1*DBITS] <= mem[{ra, 2'b01}];
	rd[3*DBITS-1:2*DBITS] <= mem[{ra, 2'b10}];
	rd[4*DBITS-1:3*DBITS] <= mem[{ra, 2'b11}];
end

endmodule
