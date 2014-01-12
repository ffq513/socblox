/****************************************************************************
 * wb_svf_master_bfm.sv
 ****************************************************************************/

/**
 * Module: wb_svf_master_bfm
 * 
 * TODO: Add module documentation
 */
module wb_svf_master_bfm #(
		parameter int			WB_ADDR_WIDTH = 32,
		parameter int			WB_DATA_WIDTH = 32
		) (
		input					clk,
		input					rstn,
		wb_if.master			master
		);

	reg							reset = 0;
	
	reg[WB_ADDR_WIDTH-1:0]		write_data_buf;
	reg[WB_ADDR_WIDTH-1:0]		read_data_buf;
	reg							req = 0;
	
	reg[WB_ADDR_WIDTH-1:0]		ADR_r;
	reg[WB_ADDR_WIDTH-1:0]		ADR_rs;
	reg[2:0]					CTI_r;
	reg[2:0]					CTI_rs;
	reg[1:0]					BTE_r;
	reg[1:0]					BTE_rs;
	reg[WB_DATA_WIDTH-1:0]		DAT_W_rs;
	reg							CYC_rs;
	reg[(WB_DATA_WIDTH/8)-1:0]	SEL_r;	
	reg[(WB_DATA_WIDTH/8)-1:0]	SEL_rs;	
	reg							STB_rs;
	reg							WE_r;
	reg							WE_rs;

	assign master.ADR = ADR_rs;
	assign master.CTI = CTI_rs;
	assign master.BTE = BTE_rs;
	assign master.DAT_W = DAT_W_rs;
	assign master.CYC = CYC_rs;
	assign master.SEL = SEL_rs;
	assign master.STB = STB_rs;
	assign master.WE  = WE_rs;
	
	reg[1:0] state;
	
	initial begin
		wb_master_bfm_register();
	end
	
	always @(posedge clk) begin
		if (rstn == 0) begin
			state <= 0;
			req = 0;
			reset <= 1;
		end else begin
			if (reset == 1) begin
				wb_master_bfm_reset();
				reset <= 0;
			end
			case (state)
				0: begin
					if (req) begin
						STB_rs <= 1;
						CYC_rs <= 1;
						ADR_rs <= ADR_r;
						CTI_rs <= CTI_r;
						BTE_rs <= BTE_r;
						WE_rs <= WE_r;
						if (WE_r) begin
							DAT_W_rs <= write_data_buf;
						end else begin
							DAT_W_rs <= 0;
						end
						SEL_rs <= SEL_r;
						state <= 1;
						req = 0;
					end
				end
				
				1: begin
					if (master.ACK) begin
						wb_master_bfm_acknowledge(master.ERR);
						if (!WE_r) begin
							read_data_buf <= master.DAT_R;
						end
						
						STB_rs <= 0;
						CYC_rs <= 0;
						ADR_rs <= 0;
						CTI_rs <= 0;
						BTE_rs <= 0;
						SEL_rs <= 0;

						state <= 0;
					end
				end
			endcase
		end
	end
		
	task wb_master_bfm_get_parameters(
		output int unsigned			ADDRESS_WIDTH,
		output int unsigned			DATA_WIDTH);
		ADDRESS_WIDTH = WB_ADDR_WIDTH;
		DATA_WIDTH = WB_DATA_WIDTH;
	endtask
	export "DPI-C" task wb_master_bfm_get_parameters;
	
	import "DPI-C" context task wb_master_bfm_register();
	
	task wb_master_bfm_set_data(
		int unsigned				idx,
		int unsigned				data);
		write_data_buf = data;
	endtask
	export "DPI-C" task wb_master_bfm_set_data;
	
	task wb_master_bfm_get_data(
		input int unsigned				idx,
		output int unsigned				data);
		data = read_data_buf;
	endtask
	export "DPI-C" task wb_master_bfm_get_data;
	
	task wb_master_bfm_request(
		longint unsigned 			ADR,
		byte unsigned				CTI,
		byte unsigned				BTE,
		int unsigned				SEL,
		byte unsigned				WE);
		ADR_r = ADR;
		CTI_r = CTI;
		BTE_r = BTE;
		SEL_r = SEL;
		WE_r = WE;
		req = 1;
	endtask
	export "DPI-C" task wb_master_bfm_request;
	
	import "DPI-C" context task wb_master_bfm_acknowledge(
			byte unsigned			ERR
			);
	
	import "DPI-C" context task wb_master_bfm_reset();
	
	
endmodule

