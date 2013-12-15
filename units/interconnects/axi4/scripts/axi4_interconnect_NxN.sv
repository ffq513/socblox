/****************************************************************************
 * ${NAME}.sv
 ****************************************************************************/

/**
 * Module: ${NAME}
 * 
 * TODO: Add module documentation
 */
module ${NAME} #(
		parameter int AXI4_ADDRESS_WIDTH=32,
		parameter int AXI4_DATA_WIDTH=128,
		parameter int AXI4_ID_WIDTH=4
		) (
		input						clk,
		input						rstn,
${MASTER_PORTLIST},
${SLAVE_PORTLIST}
		);
	
	localparam int AXI4_DATA_MSB = (AXI4_DATA_WIDTH-1);
	localparam int AXI4_WSTRB_MSB = (AXI4_DATA_WIDTH/8)-1;
	localparam int N_MASTERS = ${N_MASTERS};
	localparam int N_SLAVES = ${N_SLAVES};
	localparam int N_MASTERID_BITS = $clog2(N_MASTERS);
	localparam int N_SLAVEID_BITS = $clog2(N_SLAVES+1);
	localparam bit[N_SLAVEID_BITS:0]		NO_SLAVE  = {(N_SLAVEID_BITS+1){1'b1}};
	localparam bit[N_MASTERID_BITS:0]		NO_MASTER = {(N_MASTERID_BITS+1){1'b1}};
	
	function reg[N_SLAVEID_BITS-1:0] addr2slave(reg[AXI4_ADDRESS_WIDTH-1:0] addr);
		// TODO: fill in decode logic
		return (${N_SLAVES}+1);
	endfunction
	
	bit[3:0]									write_req_state[N_MASTERS-1:0];
	wire[AXI4_ADDRESS_WIDTH-1:0]				AWADDR[N_MASTERS-1:0];
	wire[AXI4_ID_WIDTH-1:0]						AWID[N_MASTERS-1:0];
	wire[7:0]									AWLEN[N_MASTERS-1:0];
	wire[2:0]									AWSIZE[N_MASTERS-1:0];
	wire[1:0]									AWBURST[N_MASTERS-1:0];
	wire[3:0]									AWCACHE[N_MASTERS-1:0];
	wire[2:0]									AWPROT[N_MASTERS-1:0];
	wire[3:0]									AWQOS[N_MASTERS-1:0];
	wire[3:0]									AWREGION[N_MASTERS-1:0];
	wire										AWREADY[N_MASTERS-1:0];
	wire										AWVALID[N_MASTERS-1:0];

	wire[AXI4_ADDRESS_WIDTH-1:0]				ARADDR[N_MASTERS-1:0];
	wire[AXI4_ID_WIDTH-1:0]						ARID[N_MASTERS-1:0];
	wire[7:0]									ARLEN[N_MASTERS-1:0];
	wire[2:0]									ARSIZE[N_MASTERS-1:0];
	wire[1:0]									ARBURST[N_MASTERS-1:0];
	wire[3:0]									ARCACHE[N_MASTERS-1:0];
	wire[2:0]									ARPROT[N_MASTERS-1:0];
	wire[3:0]									ARREGION[N_MASTERS-1:0];
	wire										ARREADY[N_MASTERS-1:0];
	wire										ARVALID[N_MASTERS-1:0];
	
	wire[AXI4_ID_WIDTH-1:0]						BID[N_MASTERS-1:0];
	wire[1:0]									BRESP[N_MASTERS-1:0];
	wire										BVALID[N_MASTERS-1:0];
	wire										BREADY[N_MASTERS-1:0];
	
	wire[AXI4_ID_WIDTH+N_SLAVEID_BITS-1:0]		RID[N_MASTERS-1:0];
	wire[AXI4_DATA_WIDTH-1:0]					RDATA[N_MASTERS-1:0];
	wire[1:0]									RRESP[N_MASTERS-1:0];
	wire										RLAST[N_MASTERS-1:0];
	wire										RVALID[N_MASTERS-1:0];
	wire										RREADY[N_MASTERS-1:0];

	// Stored request
	reg[AXI4_ADDRESS_WIDTH-1:0]					R_AWADDR[N_MASTERS-1:0];
	reg[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		R_AWID[N_MASTERS-1:0];
	reg[7:0]									R_AWLEN[N_MASTERS-1:0];
	reg[2:0]									R_AWSIZE[N_MASTERS-1:0];
	reg[1:0]									R_AWBURST[N_MASTERS-1:0];
	reg[3:0]									R_AWCACHE[N_MASTERS-1:0];
	reg[2:0]									R_AWPROT[N_MASTERS-1:0];
	reg[3:0]									R_AWQOS[N_MASTERS-1:0];
	reg[3:0]									R_AWREGION[N_MASTERS-1:0];
	reg											R_AWVALID[N_MASTERS-1:0];

	reg[AXI4_ADDRESS_WIDTH-1:0]					R_ARADDR[N_MASTERS-1:0];
	reg[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		R_ARID[N_MASTERS-1:0];
	reg[7:0]									R_ARLEN[N_MASTERS-1:0];
	reg[2:0]									R_ARSIZE[N_MASTERS-1:0];
	reg[1:0]									R_ARBURST[N_MASTERS-1:0];
	reg[3:0]									R_ARCACHE[N_MASTERS-1:0];
	reg[2:0]									R_ARPROT[N_MASTERS-1:0];
	reg[3:0]									R_ARREGION[N_MASTERS-1:0];
	reg											R_ARVALID[N_MASTERS-1:0];
	
	reg[(AXI4_ID_WIDTH+N_MASTERID_BITS)-1:0]	R_SBID[N_SLAVES:0];
	reg[1:0]									R_SBRESP[N_SLAVES:0];
	reg											R_SBVALID[N_SLAVES:0];
	reg											R_SBREADY[N_SLAVES:0];
	
	wire[AXI4_DATA_MSB:0]						WDATA[N_MASTERS-1:0];
	wire[AXI4_WSTRB_MSB:0]						WSTRB[N_MASTERS-1:0];
	wire										WLAST[N_MASTERS-1:0];
	wire										WVALID[N_MASTERS-1:0];
	wire										WREADY[N_MASTERS-1:0];
	bit											write_request_busy[N_MASTERS-1:0];
	bit[N_SLAVEID_BITS:0]						write_selected_slave[N_MASTERS-1:0];

	wire[N_MASTERS-1:0]							aw_req[N_SLAVES:0];
	wire										aw_master_gnt[N_SLAVES:0];
	wire[$clog2(N_MASTERS)-1:0]					aw_master_gnt_id[N_SLAVES:0];
	
	wire[AXI4_ADDRESS_WIDTH-1:0]				SAWADDR[N_SLAVES:0];
	wire[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		SAWID[N_SLAVES:0];
	wire[7:0]									SAWLEN[N_SLAVES:0];
	wire[2:0]									SAWSIZE[N_SLAVES:0];
	wire[1:0]									SAWBURST[N_SLAVES:0];
	wire[3:0]									SAWCACHE[N_SLAVES:0];
	wire[2:0]									SAWPROT[N_SLAVES:0];
	wire[3:0]									SAWQOS[N_SLAVES:0];
	wire[3:0]									SAWREGION[N_SLAVES:0];
	wire										SAWREADY[N_SLAVES:0];
	wire										SAWVALID[N_SLAVES:0];
	wire[AXI4_DATA_MSB:0]						SWDATA[N_SLAVES:0];
	wire[AXI4_WSTRB_MSB:0]						SWSTRB[N_SLAVES:0];
	wire										SWLAST[N_SLAVES:0];
	wire										SWVALID[N_SLAVES:0];
	wire										SWREADY[N_SLAVES:0];
	
	wire[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		SBID[N_SLAVES:0];
	wire[1:0]									SBRESP[N_SLAVES:0];
	wire										SBVALID[N_SLAVES:0];
	wire										SBREADY[N_SLAVES:0];

	wire[AXI4_ADDRESS_WIDTH-1:0]				SARADDR[N_SLAVES:0];
	wire[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		SARID[N_SLAVES:0];
	wire[7:0]									SARLEN[N_SLAVES:0];
	wire[2:0]									SARSIZE[N_SLAVES:0];
	wire[1:0]									SARBURST[N_SLAVES:0];
	wire[3:0]									SARCACHE[N_SLAVES:0];
	wire[2:0]									SARPROT[N_SLAVES:0];
	wire[3:0]									SARREGION[N_SLAVES:0];
	wire										SARREADY[N_SLAVES:0];
	wire										SARVALID[N_SLAVES:0];	
	
	wire[AXI4_ID_WIDTH+N_SLAVEID_BITS-1:0]		SRID[N_SLAVES:0];
	wire[AXI4_DATA_WIDTH-1:0]					SRDATA[N_SLAVES:0];
	wire[1:0]									SRRESP[N_SLAVES:0];
	wire										SRLAST[N_SLAVES:0];
	wire										SRVALID[N_SLAVES:0];
	wire										SRREADY[N_SLAVES:0];
	
	// AW master assigns
${AW_MASTER_ASSIGN}
	
	// W master assigns
${W_MASTER_ASSIGN}

	// B master assigns
${B_MASTER_ASSIGN}
	
	// Slave requests
${AW_SLAVE_ASSIGN}

${W_SLAVE_ASSIGN}

${B_SLAVE_ASSIGN}	

// Read request state machine
	bit[3:0]									read_req_state[N_MASTERS-1:0];
	reg[N_SLAVEID_BITS:0]						read_selected_slave[N_MASTERS-1:0];
	wire[N_MASTERS-1:0]							ar_req[N_SLAVES:0];
	wire										ar_master_gnt[N_SLAVES:0];
	wire[$clog2(N_MASTERS)-1:0]					ar_master_gnt_id[N_SLAVES:0];
	
// Read request
${AR_MASTER_ASSIGN}	
	
${R_MASTER_ASSIGN}	
	
	// Slave requests
${AR_SLAVE_ASSIGN}	

${R_SLAVE_ASSIGN}	

	
	// Write request state machine
	generate
		genvar m_aw_i;
		for (m_aw_i=0; m_aw_i<N_MASTERS; m_aw_i++) begin
			always @(posedge clk) begin
				if (rstn == 0) begin
					write_req_state[m_aw_i] <= 'b00;
					write_selected_slave[m_aw_i] <= NO_SLAVE;
					R_AWADDR[m_aw_i] <= 0;
					R_AWBURST[m_aw_i] <= 0;
					R_AWCACHE[m_aw_i] <= 0;
					R_AWID[m_aw_i] <= 0;
					R_AWLEN[m_aw_i] <= 0;
					R_AWPROT[m_aw_i] <= 0;
					R_AWQOS[m_aw_i] <= 0;
					R_AWREGION[m_aw_i] <= 0;
					R_AWSIZE[m_aw_i] <= 0;
					R_AWVALID[m_aw_i] <= 0;
				end else begin
					case (write_req_state[m_aw_i])
					// Wait receipt of a request for an available target
						'b00: begin
							if (AWREADY[m_aw_i] && AWVALID[m_aw_i] && !write_request_busy[m_aw_i]) begin
								$display("Write request");
								R_AWADDR[m_aw_i] <= AWADDR[m_aw_i];
								// Save the master ID that this request came from
								R_AWID[m_aw_i][(N_MASTERID_BITS+AXI4_ID_WIDTH)-1:AXI4_ID_WIDTH] <= m_aw_i;
								R_AWID[m_aw_i][AXI4_ID_WIDTH-1:0] <= AWID[m_aw_i];
								R_AWLEN[m_aw_i] <= AWLEN[m_aw_i];
								R_AWSIZE[m_aw_i] <= AWSIZE[m_aw_i];
								R_AWBURST[m_aw_i] <= AWBURST[m_aw_i];
								R_AWCACHE[m_aw_i] <= AWCACHE[m_aw_i];
								R_AWPROT[m_aw_i] <= AWPROT[m_aw_i];
								R_AWQOS[m_aw_i] <= AWQOS[m_aw_i];
								R_AWREGION[m_aw_i] <= AWREGION[m_aw_i];
								write_request_busy[m_aw_i] <= 1'b1;
								write_req_state[m_aw_i] <= 'b01;
							end
						end
				
						// Decode state
						'b01: begin
							write_selected_slave[m_aw_i] <= addr2slave(R_AWADDR[m_aw_i]);
							// Initiate the transfer when the
							R_AWVALID[m_aw_i] <= 1;
							write_req_state[m_aw_i] <= 'b10;
						end

						// Wait for the targeted slave to become available
						'b10: begin
							if (aw_master_gnt[write_selected_slave[m_aw_i]] &&
									aw_master_gnt_id[write_selected_slave[m_aw_i]] == m_aw_i &&
									SAWREADY[write_selected_slave[m_aw_i]]) begin
								// Wait until the slave is granted and accepts the request
								R_AWVALID[m_aw_i] <= 0;
								write_req_state[m_aw_i] <= 'b11;
							end
						end
			
						// Wait for write data
						// TODO: could pipeline this with address phase, provided masters stay in order
						'b11: begin
							if (WVALID[m_aw_i] == 1'b1 && WREADY[m_aw_i] == 1'b1) begin
								if (WLAST[m_aw_i] == 1'b1) begin
									// We're done
									write_request_busy[m_aw_i] <= 1'b0;
									write_selected_slave[m_aw_i] <= NO_SLAVE;
									write_req_state[m_aw_i] <= 'b00;
								end
							end
						end
					endcase
				end
			end
		end
	endgenerate

	// Build the aw_req vector for each slave
	generate
		genvar aw_req_i, aw_req_j;

		for (aw_req_i=0; aw_req_i < N_SLAVES; aw_req_i++) begin
			for (aw_req_j=0; aw_req_j < N_MASTERS; aw_req_j++) begin
				assign aw_req[aw_req_i][aw_req_j] = (write_selected_slave[aw_req_j] == aw_req_i);
			end
		end
	endgenerate

	generate
		genvar aw_arb_i;
		
		for (aw_arb_i=0; aw_arb_i<(N_SLAVES+1); aw_arb_i++) begin : aw_arb
			${NAME}_arbiter #(
				.N_REQ  (N_MASTERS)
				) 
				aw_arb (
					.clk    (clk   ), 
					.rstn   (rstn  ), 
					.req    (aw_req[aw_arb_i]), 
					.gnt    (aw_master_gnt[aw_arb_i]),
					.gnt_id	(aw_master_gnt_id[aw_arb_i])
				);
		end
	endgenerate

	wire[N_MASTERID_BITS:0]					slave_active_master[N_SLAVES:0];

	generate
		genvar s_am_i;
		
		for (s_am_i=0; s_am_i<N_SLAVES+1; s_am_i++) begin
			assign slave_active_master[s_am_i] =
				(aw_master_gnt[s_am_i])?aw_master_gnt_id[s_am_i]:NO_MASTER;
		end
	endgenerate
	
	generate
		genvar m_w_i;
		
		for (m_w_i=0; m_w_i<N_MASTERS; m_w_i++) begin
			assign WREADY[m_w_i] = (write_selected_slave[m_w_i] != NO_SLAVE && 
										aw_master_gnt[write_selected_slave[m_w_i]] && 
										aw_master_gnt_id[write_selected_slave[m_w_i]] == m_w_i)?
										SWREADY[write_selected_slave[m_w_i]]:0;
			assign AWREADY[m_w_i] = (write_req_state[m_w_i] == 0);
		end
	endgenerate
	
	generate
		genvar s_w_i;
		for(s_w_i=0; s_w_i<(N_SLAVES+1); s_w_i++) begin
			assign SWDATA[s_w_i] = (slave_active_master[s_w_i] == NO_MASTER)?0:WDATA[slave_active_master[s_w_i]];
			assign SWSTRB[s_w_i] = (slave_active_master[s_w_i] == NO_MASTER)?0:WSTRB[slave_active_master[s_w_i]];
			assign SWLAST[s_w_i] = (slave_active_master[s_w_i] == NO_MASTER)?0:WLAST[slave_active_master[s_w_i]];
			assign SWVALID[s_w_i] = (slave_active_master[s_w_i] == NO_MASTER)?0:WVALID[slave_active_master[s_w_i]];
		end
	endgenerate

	generate
		genvar s_aw_i;
		for(s_aw_i=0; s_aw_i<(N_SLAVES+1); s_aw_i++) begin : SAW_assign
			assign SAWADDR[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWADDR[slave_active_master[s_aw_i]];
			assign SAWID[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWID[slave_active_master[s_aw_i]];
			assign SAWLEN[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWLEN[slave_active_master[s_aw_i]];
			assign SAWSIZE[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWSIZE[slave_active_master[s_aw_i]];
			assign SAWBURST[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWBURST[slave_active_master[s_aw_i]];
			assign SAWCACHE[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWCACHE[slave_active_master[s_aw_i]];
			assign SAWPROT[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWPROT[slave_active_master[s_aw_i]];
			assign SAWQOS[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWQOS[slave_active_master[s_aw_i]];
			assign SAWREGION[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWREGION[slave_active_master[s_aw_i]];
			assign SAWVALID[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWVALID[slave_active_master[s_aw_i]];
		end
	endgenerate

	// Write response channel
	reg [N_MASTERID_BITS:0]		write_response_selected_master[N_SLAVES:0];
	wire [N_SLAVES:0]			b_req[N_MASTERS-1:0];
	wire						b_gnt[N_MASTERS-1:0];
	wire [N_SLAVEID_BITS-1:0]	b_gnt_id[N_MASTERS-1:0];
	
	generate
		genvar b_arb_i;
		
		for (b_arb_i=0; b_arb_i<N_MASTERS; b_arb_i++) begin : b_arb
			${NAME}_arbiter #(
				.N_REQ  (N_SLAVES+1)
				) 
				b_arb (
					.clk    (clk   ), 
					.rstn   (rstn  ), 
					.req    (b_req[b_arb_i]), 
					.gnt    (b_gnt[b_arb_i]),
					.gnt_id	(b_gnt_id[b_arb_i])
				);
		end
	endgenerate
		
	generate
		genvar b_req_slave_i, b_req_master_i;

		for (b_req_slave_i=0; b_req_slave_i<N_SLAVES+1; b_req_slave_i++) begin
			for (b_req_master_i=0; b_req_master_i<N_MASTERS; b_req_master_i++) begin
				assign b_req[b_req_master_i][b_req_slave_i] = (write_response_selected_master[b_req_slave_i] == b_req_master_i);
			end
		end
	endgenerate
		
	// Write response state machine
	reg[1:0]				write_response_state[N_SLAVES:0];
	
	generate
		genvar b_state_i;
		
		for (b_state_i=0; b_state_i<N_SLAVES+1; b_state_i++) begin : b_state
			always @(posedge clk) begin
				if (rstn == 0) begin
					write_response_state[b_state_i] <= 0;
					write_response_selected_master[b_state_i] <= NO_MASTER;
				end else begin
					case (write_response_state[b_state_i])
						0: begin
							if (SBREADY[b_state_i] && SBVALID[b_state_i]) begin
								R_SBID[b_state_i] <= SBID[b_state_i];
								R_SBRESP[b_state_i] <= SBRESP[b_state_i];
								
								// Issue request for targeted master
								write_response_selected_master[b_state_i] <= SBID[b_state_i][(AXI4_ID_WIDTH+N_MASTERID_BITS-1):AXI4_ID_WIDTH];
								write_response_state[b_state_i] <= 1;
								R_SBVALID[b_state_i] <= 1;
							end
						end
						
						1: begin
							if (b_gnt[write_response_selected_master[b_state_i]] &&
									b_gnt_id[write_response_selected_master[b_state_i]] == b_state_i &&
									BREADY[write_response_selected_master[b_state_i]]) begin
								R_SBVALID[b_state_i] <= 0;
								write_response_selected_master[b_state_i] <= NO_MASTER;
								write_response_state[b_state_i] <= 0;
							end
						end
					endcase
				end
			end
		end
	endgenerate
		
	generate
		genvar b_assign_i;
	
		for (b_assign_i=0; b_assign_i<N_SLAVES+1; b_assign_i++) begin : b_assign
			assign SBREADY[b_assign_i] = (write_response_state[b_assign_i] == 0);
		end
	endgenerate
		
	wire[N_SLAVEID_BITS:0]						b_slave_master_id[N_MASTERS-1:0];

	// Determine which slave should be driven the write response channel for each master
	// based on the slave->master grant
	generate
		genvar b_slave_master_i;
		
		for (b_slave_master_i=0; b_slave_master_i<N_MASTERS; b_slave_master_i++) begin
			assign b_slave_master_id[b_slave_master_i] = 
				(b_gnt[b_slave_master_i])?b_gnt_id[b_slave_master_i]:NO_SLAVE;
		end
	endgenerate
		
	generate
		genvar b_master_assign_i;
	
		for (b_master_assign_i=0; b_master_assign_i<N_MASTERS; b_master_assign_i++) begin
			assign BID[b_master_assign_i] = (b_slave_master_id[b_master_assign_i] == NO_SLAVE)?0:R_SBID[b_slave_master_id[b_master_assign_i]];
			assign BVALID[b_master_assign_i] = (b_slave_master_id[b_master_assign_i] == NO_SLAVE)?0:R_SBVALID[b_slave_master_id[b_master_assign_i]];
			assign BRESP[b_master_assign_i] = (b_slave_master_id[b_master_assign_i] == NO_SLAVE)?0:R_SBRESP[b_slave_master_id[b_master_assign_i]];
		end
	endgenerate

		

	
	generate
		genvar m_ar_i;
		for (m_ar_i=0; m_ar_i<N_MASTERS; m_ar_i++) begin
			assign ARREADY[m_ar_i] = (read_req_state[m_ar_i] == 0);
			always @(posedge clk) begin
				if (rstn == 0) begin
					read_req_state[m_ar_i] <= 'b00;
					read_selected_slave[m_ar_i] <= NO_SLAVE;
					R_ARADDR[m_ar_i] <= 0;
					R_ARBURST[m_ar_i] <= 0;
					R_ARCACHE[m_ar_i] <= 0;
					R_ARID[m_ar_i] <= 0;
					R_ARLEN[m_ar_i] <= 0;
					R_ARPROT[m_ar_i] <= 0;
					R_ARREGION[m_ar_i] <= 0;
					R_ARSIZE[m_ar_i] <= 0;
					R_ARVALID[m_ar_i] <= 0;
				end else begin
					case (read_req_state[m_ar_i])
						// Wait receipt of a request for an available target
						'b00: begin
							if (ARREADY[m_ar_i] && ARVALID[m_ar_i]) begin
								R_ARADDR[m_ar_i] <= ARADDR[m_ar_i];
								// Save the master ID that this request came from
								R_ARID[m_ar_i][(N_MASTERID_BITS+AXI4_ID_WIDTH)-1:AXI4_ID_WIDTH] <= m_ar_i;
								R_ARID[m_ar_i][AXI4_ID_WIDTH-1:0] <= ARID[m_ar_i];
								R_ARLEN[m_ar_i] <= ARLEN[m_ar_i];
								R_ARSIZE[m_ar_i] <= ARSIZE[m_ar_i];
								R_ARBURST[m_ar_i] <= ARBURST[m_ar_i];
								R_ARCACHE[m_ar_i] <= ARCACHE[m_ar_i];
								R_ARPROT[m_ar_i] <= ARPROT[m_ar_i];
								R_ARREGION[m_ar_i] <= ARREGION[m_ar_i];
								read_req_state[m_ar_i] <= 'b01;
							end
						end
				
						// Decode state
						'b01: begin
							read_selected_slave[m_ar_i] <= addr2slave(R_ARADDR[m_ar_i]);
							// Initiate the transfer when the
							R_ARVALID[m_ar_i] <= 1;
							read_req_state[m_ar_i] <= 'b10;
						end

						// Wait for the targeted slave to become available
						'b10: begin
							if (ar_master_gnt[read_selected_slave[m_ar_i]] &&
									ar_master_gnt_id[read_selected_slave[m_ar_i]] == m_ar_i &&
									SARREADY[read_selected_slave[m_ar_i]]) begin
								// Wait until the slave is granted and accepts the request
								// After that we're done
								R_ARVALID[m_ar_i] <= 0;
								read_selected_slave[m_ar_i] <= NO_SLAVE;
								read_req_state[m_ar_i] <= 0;
							end
						end
					endcase
				end
			end
		end
	endgenerate
		
		
	// Build the ar_req vector for each slave
	generate
		genvar ar_req_i, ar_req_j;

		for (ar_req_i=0; ar_req_i < N_SLAVES; ar_req_i++) begin
			for (ar_req_j=0; ar_req_j < N_MASTERS; ar_req_j++) begin
				assign ar_req[ar_req_i][ar_req_j] = (read_selected_slave[ar_req_j] == ar_req_i);
			end
		end
	endgenerate

	generate
		genvar ar_arb_i;
		
		for (ar_arb_i=0; ar_arb_i<(N_SLAVES+1); ar_arb_i++) begin : ar_arb
			${NAME}_arbiter #(
				.N_REQ  (N_MASTERS)
				) 
				ar_arb (
					.clk    (clk   ), 
					.rstn   (rstn  ), 
					.req    (ar_req[ar_arb_i]), 
					.gnt    (ar_master_gnt[ar_arb_i]),
					.gnt_id	(ar_master_gnt_id[ar_arb_i])
					);
		end
	endgenerate		

	wire[N_MASTERID_BITS:0]					slave_active_read_master[N_SLAVES:0];

	generate
		genvar s_ar_m_i;
		
		for (s_ar_m_i=0; s_ar_m_i<N_SLAVES+1; s_ar_m_i++) begin
			assign slave_active_read_master[s_ar_m_i] =
				(ar_master_gnt[s_ar_m_i])?ar_master_gnt_id[s_ar_m_i]:NO_MASTER;
		end
	endgenerate

	generate
		genvar s_ar_i;
	
		for(s_ar_i=0; s_ar_i<(N_SLAVES+1); s_ar_i++) begin : SAR_assign
			assign SARADDR[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARADDR[slave_active_read_master[s_ar_i]];
			assign SARID[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARID[slave_active_read_master[s_ar_i]];
			assign SARLEN[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARLEN[slave_active_read_master[s_ar_i]];
			assign SARSIZE[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARSIZE[slave_active_read_master[s_ar_i]];
			assign SARBURST[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARBURST[slave_active_read_master[s_ar_i]];
			assign SARCACHE[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARCACHE[slave_active_read_master[s_ar_i]];
			assign SARPROT[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARPROT[slave_active_read_master[s_ar_i]];
			assign SARREGION[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARREGION[slave_active_read_master[s_ar_i]];
			assign SARVALID[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARVALID[slave_active_read_master[s_ar_i]];
		end
	endgenerate

	// Read response channel
	reg [N_MASTERID_BITS:0]		read_response_selected_master[N_SLAVES:0];
	wire [N_SLAVES:0]			r_req[N_MASTERS-1:0];
	wire						r_gnt[N_MASTERS-1:0];
	wire [N_SLAVEID_BITS-1:0]	r_gnt_id[N_MASTERS-1:0];
	
	generate
		genvar r_arb_i;
		
		for (r_arb_i=0; r_arb_i<N_MASTERS; r_arb_i++) begin : r_arb
			${NAME}_arbiter #(
				.N_REQ  (N_SLAVES+1)
				) 
			r_arb (
				.clk    (clk   ), 
				.rstn   (rstn  ), 
				.req    (r_req[r_arb_i]), 
				.gnt    (r_gnt[r_arb_i]),
				.gnt_id	(r_gnt_id[r_arb_i])
				);
		end
	endgenerate
		
	generate
		genvar r_req_slave_i, r_req_master_i;

		for (r_req_slave_i=0; r_req_slave_i<N_SLAVES+1; r_req_slave_i++) begin
			for (r_req_master_i=0; r_req_master_i<N_MASTERS; r_req_master_i++) begin
				assign r_req[r_req_master_i][r_req_slave_i] = (read_response_selected_master[r_req_slave_i] == r_req_master_i);
			end
		end
	endgenerate
		
	// Read response state machine
	reg[1:0]				read_response_state[N_SLAVES:0];
	
	generate
		genvar r_state_i;
		
		for (r_state_i=0; r_state_i<N_SLAVES+1; r_state_i++) begin : r_state
			always @(posedge clk) begin
				if (rstn == 0) begin
					read_response_state[r_state_i] <= 0;
					read_response_selected_master[r_state_i] <= NO_MASTER;
				end else begin
					case (read_response_state[r_state_i])
						0: begin
							if (SRVALID[r_state_i]) begin
								// Issue request for targeted master
								read_response_selected_master[r_state_i] <= SRID[r_state_i][(AXI4_ID_WIDTH+N_MASTERID_BITS-1):AXI4_ID_WIDTH];
								read_response_state[r_state_i] <= 1;
							end
						end
						
						1: begin
							if (r_gnt[read_response_selected_master[r_state_i]] &&
									r_gnt_id[read_response_selected_master[r_state_i]] == r_state_i) begin
								// Slave now connected to selected master
								read_response_state[r_state_i] <= 2;
							end
						end
						
						2: begin
							if (SRREADY[r_state_i] && SRVALID[r_state_i] && SRLAST[r_state_i]) begin
								// Done
								read_response_selected_master[r_state_i] <= NO_MASTER;
								read_response_state[r_state_i] <= 0;
							end
						end
					endcase
				end
			end
		end
	endgenerate
		
	generate
		genvar r_assign_i;
	
		for (r_assign_i=0; r_assign_i<N_SLAVES+1; r_assign_i++) begin : r_assign
			assign SRREADY[r_assign_i] = (read_response_state[r_assign_i] == 2)?RREADY[read_response_selected_master[r_assign_i]]:0;
		end
	endgenerate
		
	wire[N_SLAVEID_BITS:0]						r_slave_master_id[N_MASTERS-1:0];

	// Determine which slave should be driven the write response channel for each master
	// based on the slave->master grant
	generate
		genvar r_slave_master_i;
		
		for (r_slave_master_i=0; r_slave_master_i<N_MASTERS; r_slave_master_i++) begin
			assign r_slave_master_id[r_slave_master_i] = 
				(r_gnt[r_slave_master_i])?r_gnt_id[r_slave_master_i]:NO_SLAVE;
		end
	endgenerate
		
	generate
		genvar r_master_assign_i;
	
		for (r_master_assign_i=0; r_master_assign_i<N_MASTERS; r_master_assign_i++) begin
			assign RID[r_master_assign_i] = (r_slave_master_id[r_master_assign_i] == NO_SLAVE)?0:SRID[r_slave_master_id[r_master_assign_i]];
			assign RVALID[r_master_assign_i] = (r_slave_master_id[r_master_assign_i] == NO_SLAVE)?0:
				(SRVALID[r_slave_master_id[r_master_assign_i]] & SRREADY[r_slave_master_id[r_master_assign_i]]);
			assign RRESP[r_master_assign_i] = (r_slave_master_id[r_master_assign_i] == NO_SLAVE)?0:SRRESP[r_slave_master_id[r_master_assign_i]];
			assign RLAST[r_master_assign_i] = (r_slave_master_id[r_master_assign_i] == NO_SLAVE)?0:SRLAST[r_slave_master_id[r_master_assign_i]];
			assign RDATA[r_master_assign_i] = (r_slave_master_id[r_master_assign_i] == NO_SLAVE)?0:SRDATA[r_slave_master_id[r_master_assign_i]];
		end
	endgenerate
		
endmodule

module ${NAME}_arbiter #(
		parameter int			N_REQ=2
		) (
		input						clk,
		input						rstn,
		input[N_REQ-1:0]			req,
		output						gnt,
		output[$clog2(N_REQ)-1:0]	gnt_id
		);
	
	bit state;
	
	reg [N_REQ-1:0]	gnt_o;
	reg [N_REQ-1:0]	last_gnt;
	reg [$clog2(N_REQ)-1:0] gnt_id_o;
	assign gnt = |gnt_o;
	assign gnt_id = gnt_id_o;
	
	wire[N_REQ-1:0] gnt_ppc;
	wire[N_REQ-1:0]	gnt_ppc_next;
	
	assign gnt_ppc_next = {gnt_ppc[N_REQ-2:0], 1'b0};

	generate
		genvar gnt_ppc_i;
		
	for (gnt_ppc_i=N_REQ-1; gnt_ppc_i>=0; gnt_ppc_i--) begin
		if (gnt_ppc_i == 0) begin
			assign gnt_ppc[gnt_ppc_i] = last_gnt[0];
		end else begin
			assign gnt_ppc[gnt_ppc_i] = |last_gnt[gnt_ppc_i-1:0];
		end
	end
	endgenerate
	
		wire[N_REQ-1:0]		unmasked_gnt;
	generate
		genvar unmasked_gnt_i;
		
	for (unmasked_gnt_i=0; unmasked_gnt_i<N_REQ; unmasked_gnt_i++) begin
		// Prioritized unmasked grant vector. Grant to the lowest active grant
		if (unmasked_gnt_i == 0) begin
			assign unmasked_gnt[unmasked_gnt_i] = req[unmasked_gnt_i];
		end else begin
			assign unmasked_gnt[unmasked_gnt_i] = (req[unmasked_gnt_i] & ~(|req[unmasked_gnt_i-1:0]));
		end
	end
	endgenerate
	
		wire[N_REQ-1:0]		masked_gnt;
	generate
		genvar masked_gnt_i;
		
	for (masked_gnt_i=0; masked_gnt_i<N_REQ; masked_gnt_i++) begin
		if (masked_gnt_i == 0) begin
			assign masked_gnt[masked_gnt_i] = (gnt_ppc_next[masked_gnt_i] & req[masked_gnt_i]);
		end else begin
			// Select first request above the last grant
			assign masked_gnt[masked_gnt_i] = (gnt_ppc_next[masked_gnt_i] & req[masked_gnt_i] & 
					~(|(gnt_ppc_next[masked_gnt_i-1:0] & req[masked_gnt_i-1:0])));
		end
	end
	endgenerate
	
		wire[N_REQ-1:0] prioritized_gnt;

	// Give priority to the 'next' request
	assign prioritized_gnt = (|masked_gnt)?masked_gnt:unmasked_gnt;
	
	always @(posedge clk) begin
		if (rstn == 0) begin
			state <= 0;
			last_gnt <= 0;
			gnt_o <= 0;
			gnt_id_o <= 0;
		end else begin
			case (state) 
				0: begin
					if (|prioritized_gnt) begin
						state <= 1;
						gnt_o <= prioritized_gnt;
						last_gnt <= prioritized_gnt;
						gnt_id_o <= gnt2id(prioritized_gnt);
					end
				end
				
				1: begin
					if ((gnt_o & req) == 0) begin
						state <= 0;
						gnt_o <= 0;
					end
				end
			endcase
		end
	end

	function bit[$clog2(N_REQ)-1:0] gnt2id(bit[N_REQ-1:0] gnt);
		automatic int i;
//		static reg[$clog2(N_REQ)-1:0] result;
		reg[$clog2(N_REQ)-1:0] result;
		
		result = 0;
		
		for (i=0; i<N_REQ; i++) begin
			if (gnt[i]) begin
				result |= i;
			end
		end
	
		return result;
	endfunction

endmodule