/****************************************************************************
 * generic_rom.sv
 ****************************************************************************/

/**
 * Module: generic_rom
 * 
 * TODO: Add module documentation
 */
module generic_rom #(
			parameter int DATA_WIDTH	= 32,
			parameter int ADDRESS_WIDTH	= 32,
			parameter INIT_FILE = ""
		) (
			input						i_clk,
			input [ADDRESS_WIDTH-1:0]	i_address,
			output [DATA_WIDTH-1:0]		o_read_data
		);
	reg[DATA_WIDTH-1:0]				rom[(2**ADDRESS_WIDTH)-1:0];
	reg[ADDRESS_WIDTH-1:0]			read_addr;
	reg[DATA_WIDTH-1:0]				read_data;
	localparam OFFSET_HIGH_BIT = (ADDRESS_WIDTH + $clog2(DATA_WIDTH) - 1);

    task generic_rom_write8(
    	longint unsigned	offset,
    	int unsigned 		data);
    	automatic bit[DATA_WIDTH-1:0] tmp = rom[offset >> 2];
    	tmp &= ~('hff << offset[2:0]);
    	tmp |= (data << offset[2:0]);
    	rom[offset] = tmp;
    endtask
    export "DPI-C" task generic_rom_write8;
    
    task generic_rom_write16(
    	longint unsigned 	offset,
    	int unsigned 		data);
    	rom[offset] = data;
    endtask
    export "DPI-C" task generic_rom_write16;
    
    task generic_rom_write32(
    	longint unsigned	offset,
    	int unsigned 		data);
    	if (offset[OFFSET_HIGH_BIT:2] < (2**ADDRESS_WIDTH)-1) begin
	    	rom[offset[OFFSET_HIGH_BIT:2]] = data;
    	end else begin
	    	$display("Error: rom(32)[%0d] = 'h%08h", offset[(ADDRESS_WIDTH-1):2], data);
    	end
    endtask
    export "DPI-C" task generic_rom_write32;
	
    task generic_rom_read32(
    	longint unsigned	offset,
    	output int unsigned data);
    	if (offset[OFFSET_HIGH_BIT:2] < (2**ADDRESS_WIDTH)-1) begin
	    	data = rom[offset[OFFSET_HIGH_BIT:2]];
    	end else begin
	    	$display("Error: rom(32)[%0d]", offset[(ADDRESS_WIDTH-1):2]);
    	end
    endtask
    export "DPI-C" task generic_rom_read32;
    
    task generic_rom_read16(
    	longint unsigned 	offset,
    	output int unsigned data);
    	data = rom[offset];
    endtask
    export "DPI-C" task generic_rom_read16;
    
    task generic_rom_read8(
    	longint unsigned 	offset,
    	output int unsigned data);
    	data = rom[offset];
    endtask
    export "DPI-C" task generic_rom_read8;
    
    import "DPI-C" context task generic_rom_register();
    
    initial begin
    	$display("%m: OFFSET_HIGH_BIT=%0d", OFFSET_HIGH_BIT);
    	generic_rom_register();
    end


	always @(posedge i_clk) begin
		read_addr <= i_address;
		read_data <= rom[read_addr];
	end

	assign o_read_data = read_data;
endmodule

