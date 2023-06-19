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

module spram_18x1024_2x (   
    WEN0_i,
    REN0_i,
    clock0,
    WR_ADDR0_i,
    RD_ADDR0_i,
    WDATA0_i,
    RDATA0_o,
    
    WEN1_i,
    REN1_i,
    clock1,
    WR_ADDR1_i,
    RD_ADDR1_i,
    WDATA1_i,
    RDATA1_o
);

parameter WR_ADDR_WIDTH0 = 10;
parameter RD_ADDR_WIDTH0 = 10;
parameter WR_DATA_WIDTH0 = 18;
parameter RD_DATA_WIDTH0 = 18;
parameter BE_WIDTH0 = 2;

parameter WR_ADDR_WIDTH1 = 10;
parameter RD_ADDR_WIDTH1 = 10;
parameter WR_DATA_WIDTH1 = 18;
parameter RD_DATA_WIDTH1 = 18;
parameter BE_WIDTH1 = 2;

input wire WEN0_i;
input wire REN0_i;
input wire clock0;
input wire [WR_ADDR_WIDTH0-1 :0] WR_ADDR0_i;
input wire [RD_ADDR_WIDTH0-1 :0] RD_ADDR0_i;
input wire [WR_DATA_WIDTH0-1 :0] WDATA0_i;
output wire [RD_DATA_WIDTH0-1 :0] RDATA0_o;

input wire WEN1_i;
input wire REN1_i;
input wire clock1;
input wire [WR_ADDR_WIDTH0-1 :0] WR_ADDR1_i;
input wire [RD_ADDR_WIDTH0-1 :0] RD_ADDR1_i;
input wire [WR_DATA_WIDTH0-1 :0] WDATA1_i;
output wire [RD_DATA_WIDTH0-1 :0] RDATA1_o;
            		  
 RAM_18K_X2_BLK  #(
      .WR1_ADDR_WIDTH(WR_ADDR_WIDTH0), 
      .RD1_ADDR_WIDTH(RD_ADDR_WIDTH0),
      .WR1_DATA_WIDTH(WR_DATA_WIDTH0), 
      .RD1_DATA_WIDTH(RD_DATA_WIDTH0),
      .BE1_WIDTH(BE_WIDTH0),
      .WR2_ADDR_WIDTH(WR_ADDR_WIDTH1), 
      .RD2_ADDR_WIDTH(RD_ADDR_WIDTH1),
      .WR2_DATA_WIDTH(WR_DATA_WIDTH1), 
      .RD2_DATA_WIDTH(RD_DATA_WIDTH1),
      .BE2_WIDTH(BE_WIDTH1)      
       ) U1
      (
      .RESET_ni(1'b1),
      
      .WEN1_i(WEN0_i),
      .REN1_i(REN0_i),
      .WR1_CLK_i(clock0),
      .RD1_CLK_i(clock0),
      .WR1_BE_i(2'b11),
      .WR1_ADDR_i(WR_ADDR0_i),
      .RD1_ADDR_i(RD_ADDR0_i),
      .WDATA1_i(WDATA0_i),
      .RDATA1_o(RDATA0_o),
      
      .WEN2_i(WEN1_i),
      .REN2_i(REN1_i),
      .WR2_CLK_i(clock1),
      .RD2_CLK_i(clock1),
      .WR2_BE_i(2'b11),
      .WR2_ADDR_i(WR_ADDR1_i),
      .RD2_ADDR_i(RD_ADDR1_i),
      .WDATA2_i(WDATA1_i),
      .RDATA2_o(RDATA1_o)
      );
              
endmodule    

module spram_9x2048_x2 (
    WEN0_i,
    REN0_i,
    clock0,
    WR_ADDR0_i,
    RD_ADDR0_i,
    WDATA0_i,
    RDATA0_o,
    
    WEN1_i,
    REN1_i,
    clock1,
    WR_ADDR1_i,
    RD_ADDR1_i,
    WDATA1_i,
    RDATA1_o
);

parameter WR_ADDR_WIDTH0 = 11;
parameter RD_ADDR_WIDTH0 = 11;
parameter WR_DATA_WIDTH0 = 9;
parameter RD_DATA_WIDTH0 = 9;
parameter BE_WIDTH0 = 1;

parameter WR_ADDR_WIDTH1 = 11;
parameter RD_ADDR_WIDTH1 = 11;
parameter WR_DATA_WIDTH1 = 9;
parameter RD_DATA_WIDTH1 = 9;
parameter BE_WIDTH1 = 1;

input wire WEN0_i;
input wire REN0_i;
input wire clock0;
input wire [WR_ADDR_WIDTH0-1 :0] WR_ADDR0_i;
input wire [RD_ADDR_WIDTH0-1 :0] RD_ADDR0_i;
input wire [WR_DATA_WIDTH0-1 :0] WDATA0_i;
output wire [RD_DATA_WIDTH0-1 :0] RDATA0_o;

input wire WEN1_i;
input wire REN1_i;
input wire clock1;
input wire [WR_ADDR_WIDTH1-1 :0] WR_ADDR1_i;
input wire [RD_ADDR_WIDTH1-1 :0] RD_ADDR1_i;
input wire [WR_DATA_WIDTH1-1 :0] WDATA1_i;
output wire [RD_DATA_WIDTH1-1 :0] RDATA1_o;
			  
 RAM_18K_X2_BLK  #(
      .WR1_ADDR_WIDTH(WR_ADDR_WIDTH0), 
      .RD1_ADDR_WIDTH(RD_ADDR_WIDTH0),
      .WR1_DATA_WIDTH(WR_DATA_WIDTH0), 
      .RD1_DATA_WIDTH(RD_DATA_WIDTH0),
      .BE1_WIDTH(BE_WIDTH0),
      .WR2_ADDR_WIDTH(WR_ADDR_WIDTH1), 
      .RD2_ADDR_WIDTH(RD_ADDR_WIDTH1),
      .WR2_DATA_WIDTH(WR_DATA_WIDTH1), 
      .RD2_DATA_WIDTH(RD_DATA_WIDTH1),
      .BE2_WIDTH(BE_WIDTH1)      
       ) U1
      (
      .RESET_ni(1'b1),
      
      .WEN1_i(WEN0_i),
      .REN1_i(REN0_i),
      .WR1_CLK_i(clock0),
      .RD1_CLK_i(clock0),
      .WR1_BE_i(1'b1),
      .WR1_ADDR_i(WR_ADDR0_i),
      .RD1_ADDR_i(RD_ADDR0_i),
      .WDATA1_i(WDATA0_i),
      .RDATA1_o(RDATA0_o),
      
      .WEN2_i(WEN1_i),
      .REN2_i(REN1_i),
      .WR2_CLK_i(clock1),
      .RD2_CLK_i(clock1),
      .WR2_BE_i(1'b1),
      .WR2_ADDR_i(WR_ADDR1_i),
      .RD2_ADDR_i(RD_ADDR1_i),
      .WDATA2_i(WDATA1_i),
      .RDATA2_o(RDATA1_o)
      );
              
endmodule    

module spram_9x2048_18x1024 (
    WEN0_i,
    REN0_i,
    clock0,
    WR_ADDR0_i,
    RD_ADDR0_i,
    WDATA0_i,
    RDATA0_o,
    
    WEN1_i,
    REN1_i,
    clock1,
    WR_ADDR1_i,
    RD_ADDR1_i,
    WDATA1_i,
    RDATA1_o
);

parameter WR_ADDR_WIDTH0 = 11;
parameter RD_ADDR_WIDTH0 = 11;
parameter WR_DATA_WIDTH0 = 9;
parameter RD_DATA_WIDTH0 = 9;
parameter BE_WIDTH0 = 1;

parameter WR_ADDR_WIDTH1 = 10;
parameter RD_ADDR_WIDTH1 = 10;
parameter WR_DATA_WIDTH1 = 18;
parameter RD_DATA_WIDTH1 = 18;
parameter BE_WIDTH1 = 2;

input wire WEN0_i;
input wire REN0_i;
input wire clock0;
input wire [WR_ADDR_WIDTH0-1 :0] WR_ADDR0_i;
input wire [RD_ADDR_WIDTH0-1 :0] RD_ADDR0_i;
input wire [WR_DATA_WIDTH0-1 :0] WDATA0_i;
output wire [RD_DATA_WIDTH0-1 :0] RDATA0_o;

input wire WEN1_i;
input wire REN1_i;
input wire clock1;
input wire [WR_ADDR_WIDTH1-1 :0] WR_ADDR1_i;
input wire [RD_ADDR_WIDTH1-1 :0] RD_ADDR1_i;
input wire [WR_DATA_WIDTH1-1 :0] WDATA1_i;
output wire [RD_DATA_WIDTH1-1 :0] RDATA1_o;
			  
 RAM_18K_X2_BLK  #(
      .WR1_ADDR_WIDTH(WR_ADDR_WIDTH0), 
      .RD1_ADDR_WIDTH(RD_ADDR_WIDTH0),
      .WR1_DATA_WIDTH(WR_DATA_WIDTH0), 
      .RD1_DATA_WIDTH(RD_DATA_WIDTH0),
      .BE1_WIDTH(BE_WIDTH0),
      .WR2_ADDR_WIDTH(WR_ADDR_WIDTH1), 
      .RD2_ADDR_WIDTH(RD_ADDR_WIDTH1),
      .WR2_DATA_WIDTH(WR_DATA_WIDTH1), 
      .RD2_DATA_WIDTH(RD_DATA_WIDTH1),
      .BE2_WIDTH(BE_WIDTH1)      
       ) U1
      (
      .RESET_ni(1'b1),
      
      .WEN1_i(WEN0_i),
      .REN1_i(REN0_i),
      .WR1_CLK_i(clock0),
      .RD1_CLK_i(clock0),
      .WR1_BE_i(1'b1),
      .WR1_ADDR_i(WR_ADDR0_i),
      .RD1_ADDR_i(RD_ADDR0_i),
      .WDATA1_i(WDATA0_i),
      .RDATA1_o(RDATA0_o),
      
      .WEN2_i(WEN1_i),
      .REN2_i(REN1_i),
      .WR2_CLK_i(clock1),
      .RD2_CLK_i(clock1),
      .WR2_BE_i(2'b11),
      .WR2_ADDR_i(WR_ADDR1_i),
      .RD2_ADDR_i(RD_ADDR1_i),
      .WDATA2_i(WDATA1_i),
      .RDATA2_o(RDATA1_o)
      );
              
endmodule    