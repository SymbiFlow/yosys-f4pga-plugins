module \$__QLF_SDP36K (PORT_W_CLK, PORT_W_ADDR, PORT_W_WR_EN, PORT_W_WR_DATA, PORT_W_WR_BE, 
					   PORT_R_CLK, PORT_R_ADDR, PORT_R_RD_EN, PORT_R_RD_DATA);  

//parameter INIT = 0;

parameter [1024*36-1:0] INIT = 36864'b0;
parameter OPTION_SPLIT = 0;

parameter PORT_W_WIDTH = 1;
parameter PORT_W_WR_BE_WIDTH = 1;

parameter PORT_R_WIDTH = 1;

input PORT_W_CLK;
input [14:0] PORT_W_ADDR;
input PORT_W_WR_EN;
input [PORT_W_WIDTH-1:0] PORT_W_WR_DATA;
input [PORT_W_WR_BE_WIDTH-1:0] PORT_W_WR_BE;

input PORT_R_CLK;
input [14:0] PORT_R_ADDR;
input PORT_R_RD_EN;
output [PORT_R_WIDTH-1:0] PORT_R_RD_DATA;


// Fixed mode settings
localparam [ 0:0] SYNC_FIFO1_i  = 1'd0;
localparam [ 0:0] FMODE1_i      = 1'd0;
localparam [ 0:0] POWERDN1_i    = 1'd0;
localparam [ 0:0] SLEEP1_i      = 1'd0;
localparam [ 0:0] PROTECT1_i    = 1'd0;
localparam [11:0] UPAE1_i       = 12'd10;
localparam [11:0] UPAF1_i       = 12'd10;

localparam [ 0:0] SYNC_FIFO2_i  = 1'd0;
localparam [ 0:0] FMODE2_i      = 1'd0;
localparam [ 0:0] POWERDN2_i    = 1'd0;
localparam [ 0:0] SLEEP2_i      = 1'd0;
localparam [ 0:0] PROTECT2_i    = 1'd0;
localparam [10:0] UPAE2_i       = 11'd10;
localparam [10:0] UPAF2_i       = 11'd10;

// Width mode function
function [2:0] mode;
input integer width;
case (width)
1: mode = 3'b101;
2: mode = 3'b110;
4: mode = 3'b100;
8,9: mode = 3'b001;
16, 18: mode = 3'b010;
32, 36: mode = 3'b011;
default: mode = 3'b000;
endcase
endfunction

function [36863:0] pack_init;
	integer i;
	reg [35:0] ri;
	for (i = 0; i < (OPTION_SPLIT ? 512 : 1024); i = i + 1) begin
		ri = INIT[i*36 +: 36];
		pack_init[i*36 +: 36] = {ri[35], ri[26], ri[34:27], ri[25:18],
								 ri[17], ri[8], ri[16:9], ri[7:0]};
	end
	if (OPTION_SPLIT)
		pack_init[36863:18432] = 18432'b0;
endfunction

wire REN_A1_i;
wire REN_A2_i;

wire REN_B1_i;
wire REN_B2_i;

wire WEN_A1_i;
wire WEN_A2_i;

wire WEN_B1_i;
wire WEN_B2_i;

wire [1:0] BE_A1_i;
wire [1:0] BE_A2_i;

wire [1:0] BE_B1_i;
wire [1:0] BE_B2_i;

wire [14:0] ADDR_A1_i;
wire [13:0] ADDR_A2_i;

wire [14:0] ADDR_B1_i;
wire [13:0] ADDR_B2_i;

wire [17:0] WDATA_A1_i;
wire [17:0] WDATA_A2_i;

wire [17:0] WDATA_B1_i;
wire [17:0] WDATA_B2_i;

wire [17:0] RDATA_A1_o;
wire [17:0] RDATA_A2_o;

wire [17:0] RDATA_B1_o;
wire [17:0] RDATA_B2_o;


// Set port width mode (In non-split mode A2/B2 is not active. Set same values anyway to match previous behavior.)
localparam [ 2:0] RMODE_A1_i    = mode(PORT_W_WIDTH);
localparam [ 2:0] WMODE_A1_i    = mode(PORT_W_WIDTH);
localparam [ 2:0] RMODE_A2_i    = mode(PORT_W_WIDTH);
localparam [ 2:0] WMODE_A2_i    = mode(PORT_W_WIDTH);

localparam [ 2:0] RMODE_B1_i    = mode(PORT_R_WIDTH);
localparam [ 2:0] WMODE_B1_i    = mode(PORT_R_WIDTH);
localparam [ 2:0] RMODE_B2_i    = mode(PORT_R_WIDTH);
localparam [ 2:0] WMODE_B2_i    = mode(PORT_R_WIDTH);

assign WEN_A1_i = PORT_W_WR_EN;
assign {BE_A2_i, BE_A1_i} = PORT_W_WR_BE;

assign REN_B1_i = PORT_R_RD_EN;

case (PORT_W_WIDTH)
9: assign { WDATA_A1_i[16], WDATA_A1_i[7:0] } = PORT_W_WR_DATA;
18: assign { WDATA_A1_i[17], WDATA_A1_i[15:8], WDATA_A1_i[16], WDATA_A1_i[7:0] } = PORT_W_WR_DATA;
36: assign { WDATA_A2_i[17], WDATA_A2_i[15:8], WDATA_A2_i[16], WDATA_A2_i[7:0], WDATA_A1_i[17], WDATA_A1_i[15:8], WDATA_A1_i[16], WDATA_A1_i[7:0]} = PORT_W_WR_DATA;
default: assign WDATA_A1_i = PORT_W_WR_DATA; // 1,2,4
endcase

case (PORT_R_WIDTH)
9: assign PORT_R_RD_DATA = { RDATA_B1_o[16], RDATA_B1_o[7:0] };
18: assign PORT_R_RD_DATA = { RDATA_B1_o[17], RDATA_B1_o[15:8], RDATA_B1_o[16], RDATA_B1_o[7:0] };
36: assign PORT_R_RD_DATA = { RDATA_B2_o[17], RDATA_B2_o[15:8], RDATA_B2_o[16], RDATA_B2_o[7:0], RDATA_B1_o[17], RDATA_B1_o[15:8], RDATA_B1_o[16], RDATA_B1_o[7:0]};
default: assign PORT_R_RD_DATA = RDATA_B1_o; // 1,2,4
endcase

defparam _TECHMAP_REPLACE_.MODE_BITS = { 1'b0,
	UPAF2_i, UPAE2_i, PROTECT2_i, SLEEP2_i, POWERDN2_i, FMODE2_i, WMODE_B2_i, WMODE_A2_i, RMODE_B2_i, RMODE_A2_i, SYNC_FIFO2_i,
	UPAF1_i, UPAE1_i, PROTECT1_i, SLEEP1_i, POWERDN1_i, FMODE1_i, WMODE_B1_i, WMODE_A1_i, RMODE_B1_i, RMODE_A1_i, SYNC_FIFO1_i
};

(* is_inferred = 1 *)
(* is_split = 0 *)
(* was_split_candidate = OPTION_SPLIT *)
(* port_a_width = PORT_W_WIDTH *)
(* port_b_width = PORT_R_WIDTH *)
TDP36K #(
	.RAM_INIT(pack_init()),
) _TECHMAP_REPLACE_ (
	.RESET_ni(1'b1),

	.CLK_A1_i(PORT_W_CLK),
	.ADDR_A1_i(PORT_W_ADDR),
	.WEN_A1_i(WEN_A1_i),
	.BE_A1_i(BE_A1_i),
	.WDATA_A1_i(WDATA_A1_i),
	.REN_A1_i(1'b0),
	.RDATA_A1_o(),

	.CLK_A2_i(PORT_W_CLK),
	.ADDR_A2_i(PORT_W_ADDR[13:0]),
	.WEN_A2_i(WEN_A1_i),
	.BE_A2_i(BE_A2_i),
	.WDATA_A2_i(WDATA_A2_i),
	.REN_A2_i(1'b0),
	.RDATA_A2_o(),

	.CLK_B1_i(PORT_R_CLK),
	.ADDR_B1_i(PORT_R_ADDR),
	.WEN_B1_i(1'b0),
	.BE_B1_i(2'b00),
	.WDATA_B1_i(18'h0),
	.REN_B1_i(REN_B1_i),
	.RDATA_B1_o(RDATA_B1_o),

	.CLK_B2_i(PORT_R_CLK),
	.ADDR_B2_i(PORT_R_ADDR[13:0]),
	.WEN_B2_i(1'b0),
	.BE_B2_i(2'b00),
	.WDATA_B2_i(18'h0),
	.REN_B2_i(REN_B1_i),
	.RDATA_B2_o(RDATA_B2_o),

	.FLUSH1_i(1'b0),
	.FLUSH2_i(1'b0)
);

endmodule


module \$__QLF_SDP36K_MERGED (...);

parameter INIT1 = 0;

parameter PORT_A1_WIDTH = 1;
parameter PORT_B1_WIDTH = 1;

parameter PORT_A1_WR_BE_WIDTH = 1;

input PORT_A1_CLK;
input [14:0] PORT_A1_ADDR;
input [PORT_A1_WIDTH-1:0] PORT_A1_WR_DATA;
input PORT_A1_WR_EN;
input [PORT_A1_WR_BE_WIDTH-1:0] PORT_A1_WR_BE;


input PORT_B1_CLK;
input [14:0] PORT_B1_ADDR;
input PORT_B1_RD_EN;
output [PORT_B1_WIDTH-1:0] PORT_B1_RD_DATA;

parameter INIT2 = 0;

parameter PORT_A2_WIDTH = 1;
parameter PORT_B2_WIDTH = 1;
parameter PORT_A2_WR_BE_WIDTH = 1;

input PORT_A2_CLK;
input [14:0] PORT_A2_ADDR;
input [PORT_A2_WIDTH-1:0] PORT_A2_WR_DATA;
input PORT_A2_WR_EN;
input [PORT_A2_WR_BE_WIDTH-1:0] PORT_A2_WR_BE;


input PORT_B2_CLK;
input [14:0] PORT_B2_ADDR;
input PORT_B2_RD_EN;
output [PORT_B2_WIDTH-1:0] PORT_B2_RD_DATA;


// Fixed mode settings
localparam [ 0:0] SYNC_FIFO1_i  = 1'd0;
localparam [ 0:0] FMODE1_i      = 1'd0;
localparam [ 0:0] POWERDN1_i    = 1'd0;
localparam [ 0:0] SLEEP1_i      = 1'd0;
localparam [ 0:0] PROTECT1_i    = 1'd0;
localparam [11:0] UPAE1_i       = 12'd10;
localparam [11:0] UPAF1_i       = 12'd10;

localparam [ 0:0] SYNC_FIFO2_i  = 1'd0;
localparam [ 0:0] FMODE2_i      = 1'd0;
localparam [ 0:0] POWERDN2_i    = 1'd0;
localparam [ 0:0] SLEEP2_i      = 1'd0;
localparam [ 0:0] PROTECT2_i    = 1'd0;
localparam [10:0] UPAE2_i       = 11'd10;
localparam [10:0] UPAF2_i       = 11'd10;

// Width mode function
function [2:0] mode;
input integer width;
case (width)
1: mode = 3'b101;
2: mode = 3'b110;
4: mode = 3'b100;
8,9: mode = 3'b001;
16, 18: mode = 3'b010;
default: mode = 3'b000;
endcase
endfunction

function [36863:0] pack_init;
	integer i;
	reg [35:0] ri;
	for (i = 0; i < 1024; i = i + 1) begin
		ri = {INIT2[i*18 +: 18], INIT1[i*18 +: 18]};
		pack_init[i*36 +: 36] = {ri[35], ri[26], ri[34:27], ri[25:18], ri[17], ri[8], ri[16:9], ri[7:0]};
	end
endfunction

wire REN_A1_i;
wire REN_A2_i;

wire REN_B1_i;
wire REN_B2_i;

wire WEN_A1_i;
wire WEN_A2_i;

wire WEN_B1_i;
wire WEN_B2_i;

wire [1:0] BE_A1_i;
wire [1:0] BE_A2_i;

wire [1:0] BE_B1_i;
wire [1:0] BE_B2_i;

wire [14:0] ADDR_A1_i;
wire [13:0] ADDR_A2_i;

wire [14:0] ADDR_B1_i;
wire [13:0] ADDR_B2_i;

wire [17:0] WDATA_A1_i;
wire [17:0] WDATA_A2_i;

wire [17:0] WDATA_B1_i;
wire [17:0] WDATA_B2_i;

wire [17:0] RDATA_A1_o;
wire [17:0] RDATA_A2_o;

wire [17:0] RDATA_B1_o;
wire [17:0] RDATA_B2_o;


// Set port width mode (In non-split mode A2/B2 is not active. Set same values anyway to match previous behavior.)
localparam [ 2:0] RMODE_A1_i    = mode(PORT_A1_WIDTH);
localparam [ 2:0] WMODE_A1_i    = mode(PORT_A1_WIDTH);
localparam [ 2:0] RMODE_B1_i    = mode(PORT_B1_WIDTH);
localparam [ 2:0] WMODE_B1_i    = mode(PORT_B1_WIDTH);

localparam [ 2:0] RMODE_A2_i    = mode(PORT_A2_WIDTH);
localparam [ 2:0] WMODE_A2_i    = mode(PORT_A2_WIDTH);
localparam [ 2:0] RMODE_B2_i    = mode(PORT_B2_WIDTH);
localparam [ 2:0] WMODE_B2_i    = mode(PORT_B2_WIDTH);

assign WEN_A1_i = PORT_A1_WR_EN;
assign BE_A1_i = PORT_A1_WR_BE;

assign REN_B1_i = PORT_B1_RD_EN;

assign WEN_A2_i = PORT_A2_WR_EN;
assign BE_A2_i = PORT_A2_WR_BE;

assign REN_B2_i = PORT_B2_RD_EN;

assign ADDR_A1_i = PORT_A1_ADDR;
assign ADDR_B1_i = PORT_B1_ADDR;
assign ADDR_A2_i = PORT_A2_ADDR;
assign ADDR_B2_i = PORT_B2_ADDR;

case (PORT_A1_WIDTH)
9: assign { WDATA_A1_i[16], WDATA_A1_i[7:0] } = PORT_A1_WR_DATA;
18: assign { WDATA_A1_i[17], WDATA_A1_i[15:8], WDATA_A1_i[16], WDATA_A1_i[7:0] } = PORT_A1_WR_DATA;
default: assign WDATA_A1_i = PORT_A1_WR_DATA; // 1,2,4,8,16
endcase

case (PORT_B1_WIDTH)
9: assign PORT_B1_RD_DATA = { RDATA_B1_o[16], RDATA_B1_o[7:0] };
18: assign PORT_B1_RD_DATA = { RDATA_B1_o[17], RDATA_B1_o[15:8], RDATA_B1_o[16], RDATA_B1_o[7:0] };
default: assign PORT_B1_RD_DATA = RDATA_B1_o; // 1,2,4,8,16
endcase

case (PORT_A2_WIDTH)
9: assign { WDATA_A2_i[16], WDATA_A2_i[7:0] } = PORT_A2_WR_DATA;
18: assign { WDATA_A2_i[17], WDATA_A2_i[15:8], WDATA_A2_i[16], WDATA_A2_i[7:0] } = PORT_A2_WR_DATA;
default: assign WDATA_A2_i = PORT_A2_WR_DATA; // 1,2,4,8,16
endcase

case (PORT_B2_WIDTH)
9: assign PORT_B2_RD_DATA = { RDATA_B2_o[16], RDATA_B2_o[7:0] };
18: assign PORT_B2_RD_DATA = { RDATA_B2_o[17], RDATA_B2_o[15:8], RDATA_B2_o[16], RDATA_B2_o[7:0] };
default: assign PORT_B2_RD_DATA = RDATA_B2_o; // 1,2,4,8,16
endcase

defparam _TECHMAP_REPLACE_.MODE_BITS = {1'b1,
			UPAF2_i, UPAE2_i, PROTECT2_i, SLEEP2_i, POWERDN2_i, FMODE2_i, WMODE_B2_i, WMODE_A2_i, RMODE_B2_i, RMODE_A2_i, SYNC_FIFO2_i,
			UPAF1_i, UPAE1_i, PROTECT1_i, SLEEP1_i, POWERDN1_i, FMODE1_i, WMODE_B1_i, WMODE_A1_i, RMODE_B1_i, RMODE_A1_i, SYNC_FIFO1_i
		};

(* is_inferred = 1 *)
(* is_split = 1 *)
(* port_a1_width = PORT_A1_WIDTH *)
(* port_a2_width = PORT_A2_WIDTH *)
(* port_b1_width = PORT_B1_WIDTH *)
(* port_b2_width = PORT_B2_WIDTH *)
TDP36K #(
	.RAM_INIT(pack_init()),
) _TECHMAP_REPLACE_ (
	.RESET_ni(1'b1),
	.WDATA_A1_i(WDATA_A1_i),
	.WDATA_A2_i(WDATA_A2_i),
	.RDATA_A1_o(),
	.RDATA_A2_o(),
	.ADDR_A1_i(ADDR_A1_i),
	.ADDR_A2_i(ADDR_A2_i),
	.CLK_A1_i(PORT_A1_CLK),
	.CLK_A2_i(PORT_A2_CLK),
	.REN_A1_i(1'b0),
	.REN_A2_i(1'b0),
	.WEN_A1_i(WEN_A1_i),
	.WEN_A2_i(WEN_A2_i),
	.BE_A1_i(BE_A1_i),
	.BE_A2_i(BE_A2_i),

	.WDATA_B1_i(18'h0),
	.WDATA_B2_i(18'h0),
	.RDATA_B1_o(RDATA_B1_o),
	.RDATA_B2_o(RDATA_B2_o),
	.ADDR_B1_i(ADDR_B1_i),
	.ADDR_B2_i(ADDR_B2_i),
	.CLK_B1_i(PORT_B1_CLK),
	.CLK_B2_i(PORT_B2_CLK),
	.REN_B1_i(REN_B1_i),
	.REN_B2_i(REN_B2_i),
	.WEN_B1_i(1'b0),
	.WEN_B2_i(1'b0),
	.BE_B1_i(2'b00),
	.BE_B2_i(2'b00),

	.FLUSH1_i(1'b0),
	.FLUSH2_i(1'b0)
);

endmodule