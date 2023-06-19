`default_nettype none
`include "params.vh"

(* blackbox *)
module gold(clk1a, clk1b, a1a, rd1a, re1a, a1b, rd1b, re1b, wd1a, we1a, be1a, wd1b, we1b, be1b, clk2a, clk2b, a2a, rd2a, re2a, a2b, rd2b, re2b, wd2a, we2a, be2a, wd2b, we2b, be2b);

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

endmodule

(* blackbox *)
module gate(clk1a, clk1b, a1a, rd1a, re1a, a1b, rd1b, re1b, wd1a, we1a, be1a, wd1b, we1b, be1b, clk2a, clk2b, a2a, rd2a, re2a, a2b, rd2b, re2b, wd2a, we2a, be2a, wd2b, we2b, be2b);

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

endmodule

module miter(clk1a, clk1b, a1a, re1a, a1b, re1b, wd1a, we1a, be1a, wd1b, we1b, be1b, clk2a, clk2b, a2a, re2a, a2b, re2b, wd2a, we2a, be2a, wd2b, we2b, be2b);

input wire clk1a;
input wire clk1b;
input wire [A1_ADDRWIDTH-1:0] a1a;
input wire re1a;
input wire [B1_ADDRWIDTH-1:0] a1b;
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
input wire re2a;
input wire [B2_ADDRWIDTH-1:0] a2b;
input wire re2b;
input wire [A2_DATAWIDTH-1:0] wd2a;
input wire we2a;
input wire [(A2_DATAWIDTH/BYTEWIDTH)-1:0] be2a;
input wire [B2_DATAWIDTH-1:0] wd2b;
input wire we2b;
input wire [(B2_DATAWIDTH/BYTEWIDTH)-1:0] be2b;


  reg [A1_DATAWIDTH-1:0] rd1a_gold;
  reg [B1_DATAWIDTH-1:0] rd1b_gold;
  reg [A2_DATAWIDTH-1:0] rd2a_gold;
  reg [B2_DATAWIDTH-1:0] rd2b_gold;
  reg [A1_DATAWIDTH-1:0] rd1a_gate;
  reg [B1_DATAWIDTH-1:0] rd1b_gate;
  reg [A2_DATAWIDTH-1:0] rd2a_gate;
  reg [B2_DATAWIDTH-1:0] rd2b_gate;

  gate gate (
    .clk1a, 
    .clk1b, 
    .a1a, 
    .rd1a(rd1a_gate), 
    .re1a, 
    .a1b, 
    .rd1b(rd1b_gate), 
    .re1b, 
    .wd1a, 
    .we1a, 
    .be1a, 
    .wd1b, 
    .we1b, 
    .be1b, 
    .clk2a, 
    .clk2b, 
    .a2a, 
    .rd2a(rd2a_gate), 
    .re2a, 
    .a2b, 
    .rd2b(rd2b_gate), 
    .re2b, 
    .wd2a, 
    .we2a, 
    .be2a, 
    .wd2b, 
    .we2b, 
    .be2b
  );
  gold gold (
    .clk1a, 
    .clk1b, 
    .a1a, 
    .rd1a(rd1a_gold), 
    .re1a, 
    .a1b, 
    .rd1b(rd1b_gold), 
    .re1b, 
    .wd1a, 
    .we1a, 
    .be1a, 
    .wd1b, 
    .we1b, 
    .be1b, 
    .clk2a, 
    .clk2b, 
    .a2a, 
    .rd2a(rd2a_gold), 
    .re2a, 
    .a2b, 
    .rd2b(rd2b_gold), 
    .re2b, 
    .wd2a, 
    .we2a, 
    .be2a, 
    .wd2b, 
    .we2b, 
    .be2b
  );


  rand const reg [A1_ADDRWIDTH-1:0] rand_addr1;

  rand const reg [A2_ADDRWIDTH-1:0] rand_addr2;

  reg [(A1_DATAWIDTH/BYTEWIDTH)-1:0] written1a = 0;
  reg [(B1_DATAWIDTH/BYTEWIDTH)-1:0] written1b = 0;
  reg [(A2_DATAWIDTH/BYTEWIDTH)-1:0] written2a = 0;
  reg [(B2_DATAWIDTH/BYTEWIDTH)-1:0] written2b = 0;

  wire [(A1_DATAWIDTH/BYTEWIDTH)-1:0] written1 = written1a | written1b;
  wire [(A2_DATAWIDTH/BYTEWIDTH)-1:0] written2 = written2a | written2b;

  genvar i;
  generate for (i = 0; i < (A1_DATAWIDTH/BYTEWIDTH); i++) begin
    always @(posedge clk1a) begin
      if(we1a && a1a == rand_addr1) begin
        written1a[i] <= written1a[i] | be1a[i];
        assume property (we1a |-> a1a != a1b); // no collision
      end
      assert property (written1[i] && (a1a == rand_addr1) && re1a |=> rd1a_gold[i*BYTEWIDTH+:BYTEWIDTH] == rd1a_gate[i*BYTEWIDTH+:BYTEWIDTH]);
      cover property (written1[i] && (a1a == rand_addr1) && re1a ##1 rd1a_gold[i*BYTEWIDTH+:BYTEWIDTH] == rd1a_gate[i*BYTEWIDTH+:BYTEWIDTH]);
    end
  end
  endgenerate
  generate for (i = 0; i < (B1_DATAWIDTH/BYTEWIDTH); i++) begin
    always @(posedge clk1b) begin
      if(we1b && a1b == rand_addr1) begin
        written1b[i] <= written1b[i] | be1b[i];
        assume property (we1b |-> a1b != a1a); // no collision
      end
      assert property (written1[i] && (a1b == rand_addr1) && re1b |=> rd1b_gold[i*BYTEWIDTH+:BYTEWIDTH] == rd1b_gate[i*BYTEWIDTH+:BYTEWIDTH]);
      cover property (written1[i] && (a1b == rand_addr1) && re1b ##1 rd1b_gold[i*BYTEWIDTH+:BYTEWIDTH] == rd1b_gate[i*BYTEWIDTH+:BYTEWIDTH]);
    end
  end
  endgenerate
  generate for (i = 0; i < (A2_DATAWIDTH/BYTEWIDTH); i++) begin
    always @(posedge clk2a) begin
      if(we2a && a2a == rand_addr2) begin
        written2a[i] <= written2a[i] | be2a[i];
        assume property (we2a |-> a2a != a2b); // no collision
      end
      assert property (written2[i] && (a2a == rand_addr2) && re2a |=> rd2a_gold[i*BYTEWIDTH+:BYTEWIDTH] == rd2a_gate[i*BYTEWIDTH+:BYTEWIDTH]);
      cover property (written2[i] && (a2a == rand_addr2) && re2a ##1 rd2a_gold[i*BYTEWIDTH+:BYTEWIDTH] == rd2a_gate[i*BYTEWIDTH+:BYTEWIDTH]);
    end
  end
  endgenerate
  generate for (i = 0; i < (B2_DATAWIDTH/BYTEWIDTH); i++) begin
    always @(posedge clk2b) begin
      if(we2b && a2b == rand_addr2) begin
        written2b[i] <= written2b[i] | be2b[i];
        assume property (we2b |-> a2b != a2a); // no collision
      end
      assert property (written2[i] && (a2b == rand_addr2) && re2b |=> rd2b_gold[i*BYTEWIDTH+:BYTEWIDTH] == rd2b_gate[i*BYTEWIDTH+:BYTEWIDTH]);
      cover property (written2[i] && (a2b == rand_addr2) && re2b ##1 rd2b_gold[i*BYTEWIDTH+:BYTEWIDTH] == rd2b_gate[i*BYTEWIDTH+:BYTEWIDTH]);
    end
  end
  endgenerate

endmodule
