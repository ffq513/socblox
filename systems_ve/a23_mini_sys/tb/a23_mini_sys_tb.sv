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
			#5;
			clk_r <= 1;
			#5;
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
	
	a23_mini_sys #(
			.INIT_FILE("smoke.mem")
			) u_mini_sys (
		.clk_i  (clk   ),
		.sw1    (sw1   ), 
		.sw2    (sw2   ), 
		.sw3    (sw3   ), 
		.sw4    (sw4   ), 
		.led0   (led0  ), 
		.led1   (led1  ), 
		.led2   (led2  ), 
		.led3   (led3  ));
	
	
endmodule



