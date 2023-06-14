`default_nettype none
`include "params.vh"

(* blackbox *)
module gold(clk1, ra1, rd1, re1, wa1, wd1, we1, be1, clk2, ra2, rd2, re2, wa2, wd2, we2, be2);

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

endmodule

(* blackbox *)
module gate(clk1, ra1, rd1, re1, wa1, wd1, we1, be1, clk2, ra2, rd2, re2, wa2, wd2, we2, be2);

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

endmodule

module miter(in_clk1, in_ra1, in_re1, in_wa1, in_wd1, in_we1, in_be1, in_clk2, in_ra2, in_re2, in_wa2, in_wd2, in_we2, in_be2);

input wire in_clk1;
input wire [ABITS-1:0] in_ra1;
input wire in_re1;
input wire [ABITS-1:0] in_wa1;
input wire [DBITS-1:0] in_wd1;
input wire in_we1;
input wire [NBYTES-1:0] in_be1;

input wire in_clk2;
input wire [ABITS-1:0] in_ra2;
input wire in_re2;
input wire [ABITS-1:0] in_wa2;
input wire [DBITS-1:0] in_wd2;
input wire in_we2;
input wire [NBYTES-1:0] in_be2;

  wire [DBITS-1:0] gate_rd1;
  wire [DBITS-1:0] gold_rd1;
  wire [DBITS-1:0] gate_rd2;
  wire [DBITS-1:0] gold_rd2;

  rand const reg [ABITS-1:0] rand_addr;

  gate gate (
    .clk1(in_clk1),
    .ra1(in_ra1),
    .rd1(gate_rd1),
    .re1(in_re1),
    .wa1(in_wa1),
    .wd1(in_wd1),
    .we1(in_we1),
    .be1(in_be1),
    .clk2(in_clk2), 
    .ra2(in_ra2),
    .rd2(gate_rd2),
    .re2(in_re2),
    .wa2(in_wa2),
    .wd2(in_wd2),
    .we2(in_we2),
    .be2(in_be2)
  );
  gold gold (
    .clk1(in_clk1),
    .ra1(in_ra1),
    .rd1(gold_rd1),
    .re1(in_re1),
    .wa1(in_wa1),
    .wd1(in_wd1),
    .we1(in_we1),
    .be1(in_be1),
    .clk2(in_clk2), 
    .ra2(in_ra2),
    .rd2(gold_rd2),
    .re2(in_re2),
    .wa2(in_wa2),
    .wd2(in_wd2),
    .we2(in_we2),
    .be2(in_be2)
  );

  reg [NBYTES-1:0] written1 = 0;
  reg [NBYTES-1:0] written2 = 0;
  genvar i;
  generate for (i = 0; i < NBYTES; i++) begin
    always @(posedge in_clk1) begin
      if(in_we1 && in_wa1 == rand_addr) begin
        written1[i] <= written1[i] | in_be1[i];
        assume property (in_we1 |-> in_wa1 != in_ra1); // no collision
      end
      assert property (written1[i] && (in_ra1 == rand_addr) && in_re1 |=> gold_rd1[i*BYTEWIDTH+:BYTEWIDTH] == gate_rd1[i*BYTEWIDTH+:BYTEWIDTH]);
      cover property (written1[i] && (in_ra1 == rand_addr) && in_re1 ##1 gold_rd1[i*BYTEWIDTH+:BYTEWIDTH] == gate_rd1[i*BYTEWIDTH+:BYTEWIDTH]);
    end

    always @(posedge in_clk2) begin
      if(in_we2 && in_wa2 == rand_addr) begin
        written2[i] <= written2[i] | in_be2[i];
        assume property (in_we2 |-> in_wa2 != in_ra2); // no collision
      end
      assert property (written2[i] && (in_ra2 == rand_addr) && in_re2 |=> gold_rd2[i*BYTEWIDTH+:BYTEWIDTH] == gate_rd2[i*BYTEWIDTH+:BYTEWIDTH]);
      cover property (written2[i] && (in_ra2 == rand_addr) && in_re2 ##1 gold_rd2[i*BYTEWIDTH+:BYTEWIDTH] == gate_rd2[i*BYTEWIDTH+:BYTEWIDTH]);
    end
  end
  endgenerate

endmodule
