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

// DFF, asynchronous reset, enable
module \$_DFFE_PN0P_ (C, R, E, D, Q);
    input  C;
    input  R;
    input  E;
    input  D;
    output Q;
    dffre _TECHMAP_REPLACE_ (.Q(Q), .D(D), .C(C), .E(E), .R(R));
endmodule


module \$_DFFE_PN1P_ (C, R, E, D, Q);
    input  C;
    input  R;
    input  E;
    input  D;
    output Q;
	
	reg  D_int;
	reg  Q_int;
	
	assign D_int = ~D;
	
    dffre _TECHMAP_REPLACE_ (.Q(Q_int), .D(D_int), .C(C), .E(E), .R(R));
	
	assign Q = ~Q_int;	
	
endmodule

module \$_DFFE_NN0P_ (C, R, E, D, Q);
    input  C;
    input  R;
    input  E;
    input  D;
    output Q;
    dffnre _TECHMAP_REPLACE_ (.Q(Q), .D(D), .C(C), .E(E), .R(R));
endmodule

module \$_DFFE_NN1P_ (C, R, E, D, Q);
    input  C;
    input  R;
    input  E;
    input  D;
    output Q;
	
	reg  D_int;
	reg  Q_int;
	
	assign D_int = ~D;
	
    dffnre _TECHMAP_REPLACE_ (.Q(Q_int), .D(D_int), .C(C), .E(E), .R(R));
	
	assign Q = ~Q_int;	
	
endmodule

// DFF, synchronous set or reset, enable
module \$_SDFFE_PN0P_ (D, C, R, E, Q);
    input  D;
    input  C;
    input  R;
    input  E;
    output Q;
    sdffre _TECHMAP_REPLACE_ (.Q(Q), .D(D), .C(C), .E(E), .R(R));
endmodule

module \$_SDFFE_PN1P_ (D, C, R, E, Q);
    input  D;
    input  C;
    input  R;
    input  E;
    output Q;
	
	reg  D_int;
	reg  Q_int;
	
	assign D_int = ~D;
	
    sdffre _TECHMAP_REPLACE_ (.Q(Q_int), .D(D_int), .C(C), .E(E), .R(R));
	
	assign Q = ~Q_int;
endmodule

module \$_SDFFE_NN0P_ (D, C, R, E, Q);
    input  D;
    input  C;
    input  R;
    input  E;
    output Q;
    sdffnre _TECHMAP_REPLACE_ (.Q(Q), .D(D), .C(C), .E(E), .R(R));
endmodule

module \$_SDFFE_NN1P_ (D, C, R, E, Q);
    input  D;
    input  C;
    input  R;
    input  E;
    output Q;
	
	reg  D_int;
	reg  Q_int;
	
	assign D_int = ~D;
	
    sdffnre _TECHMAP_REPLACE_ (.Q(Q_int), .D(D_int), .C(C), .E(E), .R(R));
	
	assign Q = ~Q_int;	
endmodule

module \$__SHREG_DFF_P_ (D, Q, C);
    input  D;
    input  C;
    output Q;

    parameter DEPTH = 2;

    reg [DEPTH-2:0] q;

    genvar i;
    generate for (i = 0; i < DEPTH; i = i + 1) begin: slice

        // First in chain
        generate if (i == 0) begin
                 dffre #() shreg_beg (
                    .Q(q[i]),
                    .D(D),
                    .C(C),
					.E(1'b1),
					.R(1'b1)
                );
        end endgenerate
        // Middle in chain
        generate if (i > 0 && i != DEPTH-1) begin
                 dffre #() shreg_mid (
                    .Q(q[i]),
                    .D(q[i-1]),
                    .C(C),
					.E(1'b1),
					.R(1'b1)
                );
        end endgenerate
        // Last in chain
        generate if (i == DEPTH-1) begin
                 dffre #() shreg_end (
                    .Q(Q),
                    .D(q[i-1]),
                    .C(C),
					.E(1'b1),
					.R(1'b1)
                );
        end endgenerate
   end: slice
   endgenerate

endmodule

module \$__SHREG_DFF_N_ (D, Q, C);
    input  D;
    input  C;
    output Q;

    parameter DEPTH = 2;

    reg [DEPTH-2:0] q;

    genvar i;
    generate for (i = 0; i < DEPTH; i = i + 1) begin: slice

        // First in chain
        generate if (i == 0) begin
                 dffnre #() shreg_beg (
                    .Q(q[i]),
                    .D(D),
                    .C(C),
					.E(1'b1),
					.R(1'b1)
                );
        end endgenerate
        // Middle in chain
        generate if (i > 0 && i != DEPTH-1) begin
                 dffnre #() shreg_mid (
                    .Q(q[i]),
                    .D(q[i-1]),
                    .C(C),
					.E(1'b1),
					.R(1'b1)
                );
        end endgenerate
        // Last in chain
        generate if (i == DEPTH-1) begin
                 dffnre #() shreg_end (
                    .Q(Q),
                    .D(q[i-1]),
                    .C(C),
					.E(1'b1),
					.R(1'b1)
                );
        end endgenerate
   end: slice
   endgenerate

endmodule