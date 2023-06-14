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

module dpram_36x1024 (
    clock0,
    WEN1_i,
    REN1_i,
    ADDR1_i,
    WDATA1_i,
    RDATA1_o,
    
    clock1,
    WEN2_i,
    REN2_i,
    ADDR2_i,
    WDATA2_i,
    RDATA2_o
);

parameter ADDR_WIDTH = 10;
parameter DATA_WIDTH = 36;
parameter BE1_WIDTH = 4;
parameter BE2_WIDTH = 4;

input wire clock0;
input wire WEN1_i;
input wire REN1_i;
input wire [ADDR_WIDTH-1 :0] ADDR1_i;
input wire [DATA_WIDTH-1 :0] WDATA1_i;
output wire [DATA_WIDTH-1 :0] RDATA1_o;

input wire clock1;
input wire WEN2_i;
input wire REN2_i;
input wire [ADDR_WIDTH-1 :0] ADDR2_i;
input wire [DATA_WIDTH-1 :0] WDATA2_i;
output wire [DATA_WIDTH-1 :0] RDATA2_o;

DPRAM_36K_BLK #(.PORT_A_AWIDTH(ADDR_WIDTH), .PORT_A_DWIDTH(DATA_WIDTH), .PORT_A_WR_BE_WIDTH(BE1_WIDTH), .PORT_B_AWIDTH(ADDR_WIDTH), .PORT_B_DWIDTH(DATA_WIDTH), .PORT_B_WR_BE_WIDTH(BE2_WIDTH))
    dpram_x36_inst (   
		.PORT_A_CLK_i(clock0),
		.PORT_A_WEN_i(WEN1_i),
		.PORT_A_WR_BE_i(4'b1111),
		.PORT_A_REN_i(REN1_i),
		.PORT_A_ADDR_i(ADDR1_i),
		.PORT_A_WR_DATA_i(WDATA1_i),
		.PORT_A_RD_DATA_o(RDATA1_o),
		
		.PORT_B_CLK_i(clock1),
		.PORT_B_WEN_i(WEN2_i),
		.PORT_B_WR_BE_i(4'b1111),
		.PORT_B_REN_i(REN2_i),
		.PORT_B_ADDR_i(ADDR2_i),
		.PORT_B_WR_DATA_i(WDATA2_i),
		.PORT_B_RD_DATA_o(RDATA2_o)
	);

endmodule

module dpram_18x2048 (
    clock0,
    WEN1_i,
    REN1_i,
    ADDR1_i,
    WDATA1_i,
    RDATA1_o,
    
    clock1,
    WEN2_i,
    REN2_i,
    ADDR2_i,
    WDATA2_i,
    RDATA2_o
);

parameter ADDR_WIDTH = 11;
parameter DATA_WIDTH = 18;
parameter BE1_WIDTH = 2;
parameter BE2_WIDTH = 2;

input wire clock0;
input wire WEN1_i;
input wire REN1_i;
input wire [ADDR_WIDTH-1 :0] ADDR1_i;
input wire [DATA_WIDTH-1 :0] WDATA1_i;
output wire [DATA_WIDTH-1 :0] RDATA1_o;

input wire clock1;
input wire WEN2_i;
input wire REN2_i;
input wire [ADDR_WIDTH-1 :0] ADDR2_i;
input wire [DATA_WIDTH-1 :0] WDATA2_i;
output wire [DATA_WIDTH-1 :0] RDATA2_o;

DPRAM_36K_BLK #(.PORT_A_AWIDTH(ADDR_WIDTH), .PORT_A_DWIDTH(DATA_WIDTH), .PORT_A_WR_BE_WIDTH(BE1_WIDTH), .PORT_B_AWIDTH(ADDR_WIDTH), .PORT_B_DWIDTH(DATA_WIDTH), .PORT_B_WR_BE_WIDTH(BE2_WIDTH))
    dpram_x36_inst (   
		.PORT_A_CLK_i(clock0),
		.PORT_A_WEN_i(WEN1_i),
		.PORT_A_WR_BE_i(4'b1111),
		.PORT_A_REN_i(REN1_i),
		.PORT_A_ADDR_i(ADDR1_i),
		.PORT_A_WR_DATA_i(WDATA1_i),
		.PORT_A_RD_DATA_o(RDATA1_o),
		
		.PORT_B_CLK_i(clock1),
		.PORT_B_WEN_i(WEN2_i),
		.PORT_B_WR_BE_i(4'b1111),
		.PORT_B_REN_i(REN2_i),
		.PORT_B_ADDR_i(ADDR2_i),
		.PORT_B_WR_DATA_i(WDATA2_i),
		.PORT_B_RD_DATA_o(RDATA2_o)
	);

endmodule

module dpram_9x4096 (
    clock0,
    WEN1_i,
    REN1_i,
    ADDR1_i,
    WDATA1_i,
    RDATA1_o,
    
    clock1,
    WEN2_i,
    REN2_i,
    ADDR2_i,
    WDATA2_i,
    RDATA2_o
);

parameter ADDR_WIDTH = 12;
parameter DATA_WIDTH = 9;
parameter BE1_WIDTH = 1;
parameter BE2_WIDTH = 1;

input wire clock0;
input wire WEN1_i;
input wire REN1_i;
input wire [ADDR_WIDTH-1 :0] ADDR1_i;
input wire [DATA_WIDTH-1 :0] WDATA1_i;
output wire [DATA_WIDTH-1 :0] RDATA1_o;

input wire clock1;
input wire WEN2_i;
input wire REN2_i;
input wire [ADDR_WIDTH-1 :0] ADDR2_i;
input wire [DATA_WIDTH-1 :0] WDATA2_i;
output wire [DATA_WIDTH-1 :0] RDATA2_o;

DPRAM_36K_BLK #(.PORT_A_AWIDTH(ADDR_WIDTH), .PORT_A_DWIDTH(DATA_WIDTH), .PORT_A_WR_BE_WIDTH(BE1_WIDTH), .PORT_B_AWIDTH(ADDR_WIDTH), .PORT_B_DWIDTH(DATA_WIDTH), .PORT_B_WR_BE_WIDTH(BE2_WIDTH))
    dpram_x36_inst (   
		.PORT_A_CLK_i(clock0),
		.PORT_A_WEN_i(WEN1_i),
		.PORT_A_WR_BE_i(4'b1111),
		.PORT_A_REN_i(REN1_i),
		.PORT_A_ADDR_i(ADDR1_i),
		.PORT_A_WR_DATA_i(WDATA1_i),
		.PORT_A_RD_DATA_o(RDATA1_o),
		
		.PORT_B_CLK_i(clock1),
		.PORT_B_WEN_i(WEN2_i),
		.PORT_B_WR_BE_i(4'b1111),
		.PORT_B_REN_i(REN2_i),
		.PORT_B_ADDR_i(ADDR2_i),
		.PORT_B_WR_DATA_i(WDATA2_i),
		.PORT_B_RD_DATA_o(RDATA2_o)
	);

endmodule
