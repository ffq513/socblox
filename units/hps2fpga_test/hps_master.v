// hps_master.v

// Generated using ACDS version 14.0 200 at 2015.01.02.11:07:53

`timescale 1 ps / 1 ps
module hps_master (
		input  wire        clk_clk,                         //                     clk.clk
		input  wire        reset_reset_n,                   //                   reset.reset_n
		output wire [12:0] memory_mem_a,                    //                  memory.mem_a
		output wire [2:0]  memory_mem_ba,                   //                        .mem_ba
		output wire        memory_mem_ck,                   //                        .mem_ck
		output wire        memory_mem_ck_n,                 //                        .mem_ck_n
		output wire        memory_mem_cke,                  //                        .mem_cke
		output wire        memory_mem_cs_n,                 //                        .mem_cs_n
		output wire        memory_mem_ras_n,                //                        .mem_ras_n
		output wire        memory_mem_cas_n,                //                        .mem_cas_n
		output wire        memory_mem_we_n,                 //                        .mem_we_n
		output wire        memory_mem_reset_n,              //                        .mem_reset_n
		inout  wire [7:0]  memory_mem_dq,                   //                        .mem_dq
		inout  wire        memory_mem_dqs,                  //                        .mem_dqs
		inout  wire        memory_mem_dqs_n,                //                        .mem_dqs_n
		output wire        memory_mem_odt,                  //                        .mem_odt
		output wire        memory_mem_dm,                   //                        .mem_dm
		input  wire        memory_oct_rzqin,                //                        .oct_rzqin
		input  wire        hps_0_h2f_mpu_events_eventi,     //    hps_0_h2f_mpu_events.eventi
		output wire        hps_0_h2f_mpu_events_evento,     //                        .evento
		output wire [1:0]  hps_0_h2f_mpu_events_standbywfe, //                        .standbywfe
		output wire [1:0]  hps_0_h2f_mpu_events_standbywfi, //                        .standbywfi
		input  wire [31:0] hps_0_f2h_irq0_irq,              //          hps_0_f2h_irq0.irq
		input  wire [31:0] hps_0_f2h_irq1_irq,              //          hps_0_f2h_irq1.irq
		output wire [11:0] hps_0_h2f_lw_axi_master_awid,    // hps_0_h2f_lw_axi_master.awid
		output wire [20:0] hps_0_h2f_lw_axi_master_awaddr,  //                        .awaddr
		output wire [3:0]  hps_0_h2f_lw_axi_master_awlen,   //                        .awlen
		output wire [2:0]  hps_0_h2f_lw_axi_master_awsize,  //                        .awsize
		output wire [1:0]  hps_0_h2f_lw_axi_master_awburst, //                        .awburst
		output wire [1:0]  hps_0_h2f_lw_axi_master_awlock,  //                        .awlock
		output wire [3:0]  hps_0_h2f_lw_axi_master_awcache, //                        .awcache
		output wire [2:0]  hps_0_h2f_lw_axi_master_awprot,  //                        .awprot
		output wire        hps_0_h2f_lw_axi_master_awvalid, //                        .awvalid
		input  wire        hps_0_h2f_lw_axi_master_awready, //                        .awready
		output wire [11:0] hps_0_h2f_lw_axi_master_wid,     //                        .wid
		output wire [31:0] hps_0_h2f_lw_axi_master_wdata,   //                        .wdata
		output wire [3:0]  hps_0_h2f_lw_axi_master_wstrb,   //                        .wstrb
		output wire        hps_0_h2f_lw_axi_master_wlast,   //                        .wlast
		output wire        hps_0_h2f_lw_axi_master_wvalid,  //                        .wvalid
		input  wire        hps_0_h2f_lw_axi_master_wready,  //                        .wready
		input  wire [11:0] hps_0_h2f_lw_axi_master_bid,     //                        .bid
		input  wire [1:0]  hps_0_h2f_lw_axi_master_bresp,   //                        .bresp
		input  wire        hps_0_h2f_lw_axi_master_bvalid,  //                        .bvalid
		output wire        hps_0_h2f_lw_axi_master_bready,  //                        .bready
		output wire [11:0] hps_0_h2f_lw_axi_master_arid,    //                        .arid
		output wire [20:0] hps_0_h2f_lw_axi_master_araddr,  //                        .araddr
		output wire [3:0]  hps_0_h2f_lw_axi_master_arlen,   //                        .arlen
		output wire [2:0]  hps_0_h2f_lw_axi_master_arsize,  //                        .arsize
		output wire [1:0]  hps_0_h2f_lw_axi_master_arburst, //                        .arburst
		output wire [1:0]  hps_0_h2f_lw_axi_master_arlock,  //                        .arlock
		output wire [3:0]  hps_0_h2f_lw_axi_master_arcache, //                        .arcache
		output wire [2:0]  hps_0_h2f_lw_axi_master_arprot,  //                        .arprot
		output wire        hps_0_h2f_lw_axi_master_arvalid, //                        .arvalid
		input  wire        hps_0_h2f_lw_axi_master_arready, //                        .arready
		input  wire [11:0] hps_0_h2f_lw_axi_master_rid,     //                        .rid
		input  wire [31:0] hps_0_h2f_lw_axi_master_rdata,   //                        .rdata
		input  wire [1:0]  hps_0_h2f_lw_axi_master_rresp,   //                        .rresp
		input  wire        hps_0_h2f_lw_axi_master_rlast,   //                        .rlast
		input  wire        hps_0_h2f_lw_axi_master_rvalid,  //                        .rvalid
		output wire        hps_0_h2f_lw_axi_master_rready   //                        .rready
	);

	hps_master_hps_0 #(
		.F2S_Width (0),
		.S2F_Width (0)
	) hps_0 (
		.h2f_mpu_eventi     (hps_0_h2f_mpu_events_eventi),     //    h2f_mpu_events.eventi
		.h2f_mpu_evento     (hps_0_h2f_mpu_events_evento),     //                  .evento
		.h2f_mpu_standbywfe (hps_0_h2f_mpu_events_standbywfe), //                  .standbywfe
		.h2f_mpu_standbywfi (hps_0_h2f_mpu_events_standbywfi), //                  .standbywfi
		.mem_a              (memory_mem_a),                    //            memory.mem_a
		.mem_ba             (memory_mem_ba),                   //                  .mem_ba
		.mem_ck             (memory_mem_ck),                   //                  .mem_ck
		.mem_ck_n           (memory_mem_ck_n),                 //                  .mem_ck_n
		.mem_cke            (memory_mem_cke),                  //                  .mem_cke
		.mem_cs_n           (memory_mem_cs_n),                 //                  .mem_cs_n
		.mem_ras_n          (memory_mem_ras_n),                //                  .mem_ras_n
		.mem_cas_n          (memory_mem_cas_n),                //                  .mem_cas_n
		.mem_we_n           (memory_mem_we_n),                 //                  .mem_we_n
		.mem_reset_n        (memory_mem_reset_n),              //                  .mem_reset_n
		.mem_dq             (memory_mem_dq),                   //                  .mem_dq
		.mem_dqs            (memory_mem_dqs),                  //                  .mem_dqs
		.mem_dqs_n          (memory_mem_dqs_n),                //                  .mem_dqs_n
		.mem_odt            (memory_mem_odt),                  //                  .mem_odt
		.mem_dm             (memory_mem_dm),                   //                  .mem_dm
		.oct_rzqin          (memory_oct_rzqin),                //                  .oct_rzqin
		.h2f_rst_n          (),                                //         h2f_reset.reset_n
		.h2f_lw_axi_clk     (clk_clk),                         //  h2f_lw_axi_clock.clk
		.h2f_lw_AWID        (hps_0_h2f_lw_axi_master_awid),    // h2f_lw_axi_master.awid
		.h2f_lw_AWADDR      (hps_0_h2f_lw_axi_master_awaddr),  //                  .awaddr
		.h2f_lw_AWLEN       (hps_0_h2f_lw_axi_master_awlen),   //                  .awlen
		.h2f_lw_AWSIZE      (hps_0_h2f_lw_axi_master_awsize),  //                  .awsize
		.h2f_lw_AWBURST     (hps_0_h2f_lw_axi_master_awburst), //                  .awburst
		.h2f_lw_AWLOCK      (hps_0_h2f_lw_axi_master_awlock),  //                  .awlock
		.h2f_lw_AWCACHE     (hps_0_h2f_lw_axi_master_awcache), //                  .awcache
		.h2f_lw_AWPROT      (hps_0_h2f_lw_axi_master_awprot),  //                  .awprot
		.h2f_lw_AWVALID     (hps_0_h2f_lw_axi_master_awvalid), //                  .awvalid
		.h2f_lw_AWREADY     (hps_0_h2f_lw_axi_master_awready), //                  .awready
		.h2f_lw_WID         (hps_0_h2f_lw_axi_master_wid),     //                  .wid
		.h2f_lw_WDATA       (hps_0_h2f_lw_axi_master_wdata),   //                  .wdata
		.h2f_lw_WSTRB       (hps_0_h2f_lw_axi_master_wstrb),   //                  .wstrb
		.h2f_lw_WLAST       (hps_0_h2f_lw_axi_master_wlast),   //                  .wlast
		.h2f_lw_WVALID      (hps_0_h2f_lw_axi_master_wvalid),  //                  .wvalid
		.h2f_lw_WREADY      (hps_0_h2f_lw_axi_master_wready),  //                  .wready
		.h2f_lw_BID         (hps_0_h2f_lw_axi_master_bid),     //                  .bid
		.h2f_lw_BRESP       (hps_0_h2f_lw_axi_master_bresp),   //                  .bresp
		.h2f_lw_BVALID      (hps_0_h2f_lw_axi_master_bvalid),  //                  .bvalid
		.h2f_lw_BREADY      (hps_0_h2f_lw_axi_master_bready),  //                  .bready
		.h2f_lw_ARID        (hps_0_h2f_lw_axi_master_arid),    //                  .arid
		.h2f_lw_ARADDR      (hps_0_h2f_lw_axi_master_araddr),  //                  .araddr
		.h2f_lw_ARLEN       (hps_0_h2f_lw_axi_master_arlen),   //                  .arlen
		.h2f_lw_ARSIZE      (hps_0_h2f_lw_axi_master_arsize),  //                  .arsize
		.h2f_lw_ARBURST     (hps_0_h2f_lw_axi_master_arburst), //                  .arburst
		.h2f_lw_ARLOCK      (hps_0_h2f_lw_axi_master_arlock),  //                  .arlock
		.h2f_lw_ARCACHE     (hps_0_h2f_lw_axi_master_arcache), //                  .arcache
		.h2f_lw_ARPROT      (hps_0_h2f_lw_axi_master_arprot),  //                  .arprot
		.h2f_lw_ARVALID     (hps_0_h2f_lw_axi_master_arvalid), //                  .arvalid
		.h2f_lw_ARREADY     (hps_0_h2f_lw_axi_master_arready), //                  .arready
		.h2f_lw_RID         (hps_0_h2f_lw_axi_master_rid),     //                  .rid
		.h2f_lw_RDATA       (hps_0_h2f_lw_axi_master_rdata),   //                  .rdata
		.h2f_lw_RRESP       (hps_0_h2f_lw_axi_master_rresp),   //                  .rresp
		.h2f_lw_RLAST       (hps_0_h2f_lw_axi_master_rlast),   //                  .rlast
		.h2f_lw_RVALID      (hps_0_h2f_lw_axi_master_rvalid),  //                  .rvalid
		.h2f_lw_RREADY      (hps_0_h2f_lw_axi_master_rready),  //                  .rready
		.f2h_irq_p0         (hps_0_f2h_irq0_irq),              //          f2h_irq0.irq
		.f2h_irq_p1         (hps_0_f2h_irq1_irq)               //          f2h_irq1.irq
	);

endmodule
