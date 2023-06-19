`include "params.vh"

(* blackbox *)
module gold(clk_a, clk_b, a_a, rd_a, wd_a, we_a, a_b, rd_b, wd_b, we_b);

input wire clk_a;
input wire clk_b;

input wire [ABITS_A-1:0] a_a;
output reg [DBITS_A-1:0] rd_a;
input wire [DBITS_A-1:0] wd_a;
input wire we_a;
input wire [ABITS_B-1:0] a_b;
output reg [DBITS_B-1:0] rd_b;
input wire [DBITS_B-1:0] wd_b;
input wire we_b;

endmodule

(* blackbox *)
module gate(clk_a, clk_b, a_a, rd_a, wd_a, we_a, a_b, rd_b, wd_b, we_b);

input wire clk_a;
input wire clk_b;

input wire [ABITS_A-1:0] a_a;
output reg [DBITS_A-1:0] rd_a;
input wire [DBITS_A-1:0] wd_a;
input wire we_a;
input wire [ABITS_B-1:0] a_b;
output reg [DBITS_B-1:0] rd_b;
input wire [DBITS_B-1:0] wd_b;
input wire we_b;
endmodule

module miter(in_clk_a, in_clk_b, in_a_a, in_wd_a, in_we_a, in_a_b, in_wd_b, in_we_b);

input wire in_clk_a;
input wire in_clk_b;

input wire [ABITS_A-1:0] in_a_a;
input wire [DBITS_A-1:0] in_wd_a;
input wire in_we_a;
input wire [ABITS_B-1:0] in_a_b;
input wire [DBITS_B-1:0] in_wd_b;
input wire in_we_b;

  wire [DBITS_A-1:0] gate_rd_a;
  wire [DBITS_B-1:0] gate_rd_b;

  wire [DBITS_A-1:0] gold_rd_a;
  wire [DBITS_B-1:0] gold_rd_b;

  rand const reg [ABITS_A-1:0] rand_addr;

  gate gate (
    .clk_a(in_clk_a),
    .clk_b(in_clk_b),
    .a_a(in_a_a),
    .rd_a(gate_rd_a),
    .wd_a(in_wd_a),
    .we_a(in_we_a),
    .a_b(in_a_b),
    .rd_b(gate_rd_b),
    .wd_b(in_wd_b),
    .we_b(in_we_b)
  );
  gold gold (
    .clk_a(in_clk_a),
    .clk_b(in_clk_b),
    .a_a(in_a_a),
    .rd_a(gold_rd_a),
    .wd_a(in_wd_a),
    .we_a(in_we_a),
    .a_b(in_a_b),
    .rd_b(gold_rd_b),
    .wd_b(in_wd_b),
    .we_b(in_we_b)
  );

  reg written_a = 1'b0;
  reg written_b = 1'b0;
  wire written = written_a || written_b;

  always @(posedge in_clk_a) begin
    if(in_we_a && in_a_a == rand_addr) begin
      assume property (in_we_b |-> in_a_a != in_a_b); // no collision
      written_a <= 1'b1;
    end
    assert property (written && (in_a_a == rand_addr) && !(in_a_b == rand_addr && in_we_b) |=> gold_rd_a == gate_rd_a);
    cover property (written && (in_a_a == rand_addr) && !(in_a_b == rand_addr && in_we_b) ##1 gold_rd_a == gate_rd_a);
  end
  always @(posedge in_clk_b) begin
    if(in_we_b && in_a_b == rand_addr) begin
      assume property (in_we_a |-> in_a_a != in_a_b); // no collision
      written_b <= 1'b1;
    end
    assert property (written && (in_a_b == rand_addr) && !(in_a_a == rand_addr && in_we_a) |=> gold_rd_b == gate_rd_b);
    cover property (written && (in_a_b == rand_addr) && !(in_a_a == rand_addr && in_we_a) ##1 gold_rd_b == gate_rd_b);
  end

endmodule
