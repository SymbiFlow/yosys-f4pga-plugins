`include "params.vh"

(* blackbox *)
module gold(clk, ra, wa, rd, wd, we, be);

input wire clk;
// input wire ce;
input wire we;
input wire [NBYTES-1:0] be;
input wire [ABITS-1:0] wa;
input wire [DBITS-1:0] wd;
input wire [ABITS-1:0] ra;
output reg [DBITS-1:0] rd;

endmodule

(* blackbox *)
module gate(clk, ra, wa, rd, wd, we, be);

input wire clk;
// input wire ce;
input wire we;
input wire [NBYTES-1:0] be;
input wire [ABITS-1:0] wa;
input wire [DBITS-1:0] wd;
input wire [ABITS-1:0] ra;
output reg [DBITS-1:0] rd;

endmodule

module miter(in_we, in_wd, in_wa, in_ra, in_clk, in_be);

  input [NBYTES-1:0] in_be;
  input in_clk;
  input [ABITS-1:0] in_ra;
  input [ABITS-1:0] in_wa;
  input [DBITS-1:0] in_wd;
  input in_we;

  wire [DBITS-1:0] gate_rd;
  wire [DBITS-1:0] gold_rd;

  rand const reg [ABITS-1:0] rand_addr;

  gate gate (
    .be(in_be),
    .clk(in_clk),
    .ra(in_ra),
    .rd(gate_rd),
    .wa(in_wa),
    .wd(in_wd),
    .we(in_we)
  );
  gold gold (
    .be(in_be),
    .clk(in_clk),
    .ra(in_ra),
    .rd(gold_rd),
    .wa(in_wa),
    .wd(in_wd),
    .we(in_we)
  );

  reg [NBYTES-1:0] written = 0;
  genvar i;
  generate for (i = 0; i < NBYTES; i++) begin
    always @(posedge in_clk) begin
      if(in_we && in_wa == rand_addr) begin
        written[i] <= written[i] | in_be[i];
      end

        assert property (written[i] && (in_ra == rand_addr) |=> gold_rd[i*BYTEWIDTH+:BYTEWIDTH] == gate_rd[i*BYTEWIDTH+:BYTEWIDTH]);
        cover property (written[i] && (in_ra == rand_addr) ##1 gold_rd[i*BYTEWIDTH+:BYTEWIDTH] == gate_rd[i*BYTEWIDTH+:BYTEWIDTH]);
      
    end
  end
  endgenerate

endmodule
