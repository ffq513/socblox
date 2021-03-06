/****************************************************************************
 * a23_mini_sys_tb.sv
 ****************************************************************************/

/**
 * Module: a23_mini_sys_tb
 * 
 * TODO: Add module documentation
 */
module a23_mini_sys_tb(input clk);
	import svf_pkg::*;
	reg[15:0]			rst_cnt = 0;
	reg					rstn = 0;
	
`ifndef VERILATOR
	reg clk_r = 0;
	assign clk = clk_r;
	
	initial begin
		forever begin
			#10;
			clk_r <= 1;
			#10;
			clk_r <= 0;
		end
	end
	initial begin
		svf_runtest();
	end
`endif
	
	always @(posedge clk) begin
		if (rst_cnt == 100) begin
			rstn <= 1;
		end else begin
			rst_cnt <= rst_cnt + 1;
		end
	end
	
	/* verilator tracing_off */
	initial begin
		string TB_ROOT;
		$display("TB_ROOT=%m");
		$sformat(TB_ROOT, "%m");
		set_config_string("*", "TB_ROOT", TB_ROOT);
	end
	/* verilator tracing_on */

	// TODO: instantiate DUT, BFMs
	
	reg sw1=0, sw2=0, sw3=0, sw4=0;
	wire led0, led1, led2, led3;
	
	a23_mini_sys u_mini_sys (
		.clk_i  (clk   ),
/*
		.sw1    (sw1   ), 
		.sw2    (sw2   ), 
		.sw3    (sw3   ), 
		.sw4    (sw4   ), 
 */
		.led0   (led0  ), 
		.led1   (led1  ), 
		.led2   (led2  ), 
		.led3   (led3  ));

/**	
	bind axi4_monitor axi4_monitor_bfm #(
		.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
		.AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
		.AXI4_ID_WIDTH(AXI4_ID_WIDTH)) 
		u_axi4_monitor_bfm (
		.clk(clk),
		.rst_n(rst_n),
		.monitor(monitor)
		);
 */
	
	bind a23_tracer a23_tracer_bfm u_tracer_bfm (
			.i_clk                    (i_clk                   ), 
			.i_fetch_stall            (i_fetch_stall           ), 
			.i_instruction            (i_instruction           ), 
			.i_instruction_valid      (i_instruction_valid     ), 
			.i_instruction_undefined  (i_instruction_undefined ), 
			.i_instruction_execute    (i_instruction_execute   ), 
			.i_interrupt              (i_interrupt             ), 
			.i_interrupt_state        (i_interrupt_state       ), 
			.i_instruction_address    (i_instruction_address   ), 
			.i_pc_sel                 (i_pc_sel                ), 
			.i_pc_wen                 (i_pc_wen                ), 
			.i_write_enable           (i_write_enable          ), 
			.fetch_stall              (fetch_stall             ), 
			.i_data_access            (i_data_access           ), 
			.pc_nxt                   (pc_nxt                  ), 
			.i_address                (i_address               ), 
			.i_write_data             (i_write_data            ), 
			.i_byte_enable            (i_byte_enable           ), 
			.i_read_data              (i_read_data             ),
			.i_r0_r15_user            (i_r0_r15_user           )
			);	
	
	
endmodule



