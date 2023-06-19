`include "params.vh"

(* blackbox *)
module gold(clk, ra, wa, rd, wd, we);

input wire clk;
input wire we;
input wire [ABITS-1:0] wa;
input wire [DBITS-1:0] wd;
input wire [ABITS-3:0] ra;
output reg [4*DBITS-1:0] rd;

endmodule

(* blackbox *)
module gate(clk, ra, wa, rd, wd, we);

input wire clk;
// input wire ce;
input wire we;
input wire [ABITS-1:0] wa;
input wire [DBITS-1:0] wd;
input wire [ABITS-3:0] ra;
output reg [4*DBITS-1:0] rd;

endmodule

module miter(in_we, in_wd, in_wa, in_ra, in_clk);

  input in_clk;
  input [ABITS-3:0] in_ra;
  input [ABITS-1:0] in_wa;
  input [DBITS-1:0] in_wd;
  input in_we;

  wire [4*DBITS-1:0] gate_rd;
  wire [4*DBITS-1:0] gold_rd;

  rand const reg [ABITS-3:0] rand_addr;
  rand const reg [1:0] rand_byte;

  gate gate (
    .clk(in_clk),
    .ra(in_ra),
    .rd(gate_rd),
    .wa(in_wa),
    .wd(in_wd),
    .we(in_we)
  );
  gold gold (
    .clk(in_clk),
    .ra(in_ra),
    .rd(gold_rd),
    .wa(in_wa),
    .wd(in_wd),
    .we(in_we)
  );

  reg [DBITS-1:0] gold_byte;
  reg [DBITS-1:0] gate_byte;
  always_comb begin
    case (rand_byte)
      2'b00 : begin
        gold_byte <= gold_rd[DBITS-1:0];
        gate_byte <= gate_rd[DBITS-1:0];
      end
      2'b01 : begin
        gold_byte <= gold_rd[2*DBITS-1:DBITS];
        gate_byte <= gate_rd[2*DBITS-1:DBITS];
      end
      2'b10 : begin
        gold_byte <= gold_rd[3*DBITS-1:2*DBITS];
        gate_byte <= gate_rd[3*DBITS-1:2*DBITS];
      end
      2'b11 : begin
        gold_byte <= gold_rd[4*DBITS-1:3*DBITS];
        gate_byte <= gate_rd[4*DBITS-1:3*DBITS];
      end
    endcase
  end


  reg written = 1'b0;
  always @(posedge in_clk) begin
    if(in_we && in_wa == {rand_addr, rand_byte}) begin
      written <= 1'b1;
    end
    assert property (written && (in_ra == rand_addr) |=> gold_byte == gate_byte);
    cover property (written && (in_ra == rand_addr) ##1 gold_byte == gate_byte);
  end

endmodule
