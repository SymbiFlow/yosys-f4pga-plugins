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

`timescale 1ps/1ps

`default_nettype none

(* lib_whitebox *)
module frac_lut6(
    input [0:5] in,
    output [0:3] lut4_out,
    output [0:1] lut5_out,
    output lut6_out
);
    parameter [0:63] LUT = 0;
    // Effective LUT input
    wire [0:5] li = in;

    // Output function
    wire [0:31] s1 = li[0] ?
    {LUT[0] , LUT[2] , LUT[4] , LUT[6] , LUT[8] , LUT[10], LUT[12], LUT[14],
     LUT[16], LUT[18], LUT[20], LUT[22], LUT[24], LUT[26], LUT[28], LUT[30],
     LUT[32], LUT[34], LUT[36], LUT[38], LUT[40], LUT[42], LUT[44], LUT[46],
     LUT[48], LUT[50], LUT[52], LUT[54], LUT[56], LUT[58], LUT[60], LUT[62]}:
    {LUT[1] , LUT[3] , LUT[5] , LUT[7] , LUT[9] , LUT[11], LUT[13], LUT[15],
     LUT[17], LUT[19], LUT[21], LUT[23], LUT[25], LUT[27], LUT[29], LUT[31],
     LUT[33], LUT[35], LUT[37], LUT[39], LUT[41], LUT[43], LUT[45], LUT[47],
     LUT[49], LUT[51], LUT[53], LUT[55], LUT[57], LUT[59], LUT[61], LUT[63]};

    wire [0:15] s2 = li[1] ?
    {s1[0] , s1[2] , s1[4] , s1[6] , s1[8] , s1[10], s1[12], s1[14],
     s1[16], s1[18], s1[20], s1[22], s1[24], s1[26], s1[28], s1[30]}:
    {s1[1] , s1[3] , s1[5] , s1[7] , s1[9] , s1[11], s1[13], s1[15],
     s1[17], s1[19], s1[21], s1[23], s1[25], s1[27], s1[29], s1[31]};

    wire [0:7] s3 = li[2] ?
    {s2[0], s2[2], s2[4], s2[6], s2[8], s2[10], s2[12], s2[14]}:
    {s2[1], s2[3], s2[5], s2[7], s2[9], s2[11], s2[13], s2[15]};

    wire [0:3] s4 = li[3] ? {s3[0], s3[2], s3[4], s3[6]}:
                            {s3[1], s3[3], s3[5], s3[7]};

    wire [0:1] s5 = li[4] ? {s4[0], s4[2]} : {s4[1], s4[3]};

    assign lut4_out[0] = s4[0];
    assign lut4_out[1] = s4[1];
    assign lut4_out[2] = s4[2];
    assign lut4_out[3] = s4[3];

    assign lut5_out[0] = s5[0];
    assign lut5_out[1] = s5[1];

    assign lut6_out = li[5] ? s5[0] : s5[1];

    specify
      (in[0] => lut6_out) = 116;
      (in[1] => lut6_out) = 116;
      (in[2] => lut6_out) = 116;
      (in[3] => lut6_out) = 116;
      (in[4] => lut6_out) = 116;
      (in[5] => lut6_out) = 116;
      (in[0] => lut5_out[0]) = 116;
      (in[1] => lut5_out[0]) = 116;
      (in[2] => lut5_out[0]) = 116;
      (in[3] => lut5_out[0]) = 116;
      (in[4] => lut5_out[0]) = 116;
      (in[0] => lut4_out[0]) = 116;
      (in[1] => lut4_out[0]) = 116;
      (in[2] => lut4_out[0]) = 116;
      (in[3] => lut4_out[0]) = 116;
    endspecify


endmodule




(* abc9_lut=1 *)
module LUT1(output O, input I0);
  parameter [1:0] INIT = 0;
  assign O = I0 ? INIT[1] : INIT[0];
  specify
    (I0 => O) = 74;
  endspecify
endmodule

(* abc9_lut=2 *)
module LUT2(output O, input I0, I1);
  parameter [3:0] INIT = 0;
  wire [ 1: 0] s1 = I1 ? INIT[ 3: 2] : INIT[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
  specify
    (I0 => O) = 116;
    (I1 => O) = 74;
  endspecify
endmodule

(* abc9_lut=3 *)
module LUT3(output O, input I0, I1, I2);
  parameter [7:0] INIT = 0;
  wire [ 3: 0] s2 = I2 ? INIT[ 7: 4] : INIT[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
  specify
    (I0 => O) = 162;
    (I1 => O) = 116;
    (I2 => O) = 174;
  endspecify
endmodule

(* abc9_lut=3 *)
module LUT4(output O, input I0, I1, I2, I3);
  parameter [15:0] INIT = 0;
  wire [ 7: 0] s3 = I3 ? INIT[15: 8] : INIT[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
  specify
    (I0 => O) = 201;
    (I1 => O) = 162;
    (I2 => O) = 116;
    (I3 => O) = 74;
  endspecify
endmodule

(* abc9_lut=3 *)
module LUT5(output O, input I0, I1, I2, I3, I4);
  parameter [31:0] INIT = 0;
  wire [15: 0] s4 = I4 ? INIT[31:16] : INIT[15: 0];
  wire [ 7: 0] s3 = I3 ?   s4[15: 8] :   s4[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
  specify
    (I0 => O) = 228;
    (I1 => O) = 189;
    (I2 => O) = 143;
    (I3 => O) = 100;
    (I4 => O) = 55;
  endspecify
endmodule

(* abc9_lut=5 *)
module LUT6(output O, input I0, I1, I2, I3, I4, I5);
  parameter [63:0] INIT = 0;
  wire [31: 0] s5 = I5 ? INIT[63:32] : INIT[31: 0];
  wire [15: 0] s4 = I4 ?   s5[31:16] :   s5[15: 0];
  wire [ 7: 0] s3 = I3 ?   s4[15: 8] :   s4[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
  specify
    (I0 => O) = 251;
    (I1 => O) = 212;
    (I2 => O) = 166;
    (I3 => O) = 123;
    (I4 => O) = 77;
    (I5 => O) = 43;
  endspecify
endmodule

(* abc9_flop, lib_whitebox *)
module sh_dff(
    output reg Q,
    input wire D,
    (* clkbuf_sink *)
    input wire C
);

    initial Q <= 1'b0;
    always @(posedge C)
        Q <= D;
		
    specify
      (posedge C => (Q +: D)) = 0;
      $setuphold(posedge C, D, 0, 0);
    endspecify

endmodule

(* abc9_box, lib_whitebox *)
(* blackbox *)
(* keep *)
module adder_carry(
    output wire sumout,
    (* abc9_carry *)
    output wire cout,
    input wire p,
    input wire g,
    (* abc9_carry *)
    input wire cin
);
    assign sumout = p ^ cin;
    assign cout = p ? cin : g;
	
    specify
        (p => sumout) = 35;
        (g => sumout) = 35;
        (cin => sumout) = 40;
        (p => cout) = 67;
        (g => cout) = 65;
        (cin => cout) = 69;
    endspecify

endmodule

(* abc9_flop, lib_whitebox *)
module dff(
    output reg Q,
    input wire D,
    (* clkbuf_sink *)
    input wire C
);
    initial Q <= 1'b0;

    always @(posedge C)
      Q <= D;

    specify
	    (posedge C=>(Q+:D)) = 285;
	    $setuphold(posedge C, D, 56, 0);
    endspecify

endmodule

(* abc9_flop, lib_whitebox *)
module dffn(
    output reg Q,
    input wire D,
    (* clkbuf_sink *)
    input wire C
);
    initial Q <= 1'b0;

    always @(negedge C)
      Q <= D;
	  
    specify
	    (negedge C=>(Q+:D)) = 285;
	    $setuphold(negedge C, D, 56, 0);
    endspecify

endmodule

(* abc9_flop, lib_whitebox *)
module dffsre(
    output reg Q,
    input wire D,
    (* clkbuf_sink *)
    input wire C,
    input wire E,
    input wire R,
    input wire S
);
    initial Q <= 1'b0;

    always @(posedge C or negedge S or negedge R)
      if (!R)
        Q <= 1'b0;
      else if (!S)
        Q <= 1'b1;
      else if (E)
        Q <= D;

    specify
      (posedge C => (Q +: D)) = 280;
      (R => Q) = 0;
      (S => Q) = 0;
      $setuphold(posedge C, D, 56, 0);
      $setuphold(posedge C, E, 32, 0);
      $setuphold(posedge C, R, 0, 0);
      $setuphold(posedge C, S, 0, 0);
      $recrem(posedge R, posedge C, 0, 0);
      $recrem(posedge S, posedge C, 0, 0);
    endspecify

endmodule

(* abc9_flop, lib_whitebox *)
module dffnsre(
    output reg Q,
    input wire D,
    (* clkbuf_sink *)
    input wire C,
    input wire E,
    input wire R,
    input wire S
);
    initial Q <= 1'b0;

    always @(negedge C or negedge S or negedge R)
      if (!R)
        Q <= 1'b0;
      else if (!S)
        Q <= 1'b1;
      else if (E)
        Q <= D;
		
    specify
      (negedge C => (Q +: D)) = 280;
      (R => Q) = 0;
      (S => Q) = 0;
      $setuphold(negedge C, D, 56, 0);
      $setuphold(negedge C, E, 32, 0);
      $setuphold(negedge C, R, 0, 0);
      $setuphold(negedge C, S, 0, 0);
      $recrem(posedge R, negedge C, 0, 0);
      $recrem(posedge S, negedge C, 0, 0);
    endspecify

endmodule

(* abc9_flop, lib_whitebox *)
module sdffsre(
    output reg Q,
    input wire D,
    (* clkbuf_sink *)
    input wire C,
    input wire E,
    input wire R,
    input wire S
);
    initial Q <= 1'b0;

    always @(posedge C)
      if (!R)
        Q <= 1'b0;
      else if (!S)
        Q <= 1'b1;
      else if (E)
        Q <= D;
		
    specify
        (posedge C => (Q +: D)) = 280;
        $setuphold(posedge C, D, 56, 0);
        $setuphold(posedge C, R, 32, 0);
        $setuphold(posedge C, S, 0, 0);
        $setuphold(posedge C, E, 0, 0);
    endspecify

endmodule

(* abc9_flop, lib_whitebox *)
module sdffnsre(
    output reg Q,
    input wire D,
    (* clkbuf_sink *)
    input wire C,
    input wire E,
    input wire R,
    input wire S
);
    initial Q <= 1'b0;

    always @(negedge C)
      if (!R)
        Q <= 1'b0;
      else if (!S)
        Q <= 1'b1;
      else if (E)
        Q <= D;
		
    specify
        (negedge C => (Q +: D)) = 280;
        $setuphold(negedge C, D, 56, 0);
        $setuphold(negedge C, R, 32, 0);
        $setuphold(negedge C, S, 0, 0);
        $setuphold(negedge C, E, 0, 0);
    endspecify

endmodule

(* abc9_flop, lib_whitebox *)
module latchsre (
    output reg Q,
    input wire S,
    input wire R,
    input wire D,
    input wire G,
    input wire E
);
    initial Q <= 1'b0;

    always @*
      begin
        if (!R)
          Q <= 1'b0;
        else if (!S)
          Q <= 1'b1;
        else if (E && G)
          Q <= D;
      end
	  
    specify
      (posedge G => (Q +: D)) = 0;
      $setuphold(posedge G, D, 0, 0);
      $setuphold(posedge G, E, 0, 0);
      $setuphold(posedge G, R, 0, 0);
      $setuphold(posedge G, S, 0, 0);
    endspecify      

endmodule

(* abc9_flop, lib_whitebox *)
module latchnsre (
    output reg Q,
    input wire S,
    input wire R,
    input wire D,
    input wire G,
    input wire E
);
    initial Q <= 1'b0;

    always @*
      begin
        if (!R)
          Q <= 1'b0;
        else if (!S)
          Q <= 1'b1;
        else if (E && !G)
          Q <= D;
      end
	  
    specify
      (negedge G => (Q +: D)) = 0;
      $setuphold(negedge G, D, 0, 0);
      $setuphold(negedge G, E, 0, 0);
      $setuphold(negedge G, R, 0, 0);
      $setuphold(negedge G, S, 0, 0);
    endspecify 

endmodule

