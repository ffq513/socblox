

class axi4_uvm_master_driver extends uvm_driver #(axi4_uvm_master_seq_item);

	`uvm_component_utils(axi4_uvm_master_driver)
	
	const string report_id = "axi4_uvm_master_driver";
	
	uvm_analysis_port #(axi4_uvm_master_seq_item)		ap;
	
	axi4_uvm_master_config								m_cfg;
	
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		ap = new("ap", this);
		
		m_cfg = axi4_uvm_master_config::get_config(this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
		axi4_uvm_master_seq_item		item;
		
		forever begin
			seq_item_port.get_next_item(item);
			// TODO: execute the sequence item
			item.print();
			
			// Send the item to the analysis port
			ap.write(item);
			
			seq_item_port.item_done();
		end
	endtask
endclass



