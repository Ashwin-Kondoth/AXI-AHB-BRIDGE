class ahb_agent extends uvm_agent;
	`uvm_component_utils(ahb_agent)

	function new(string name = "ahb_agent",uvm_component parent);
		super.new(name,parent);
	endfunction : new
	
	ahb_config cfg;
	
	ahb_driver drv;
	ahb_monitor mon;
	ahb_sequencer seqr;

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass : ahb_agent

function void ahb_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(ahb_config)::get(this,"","ahb_config",cfg))
		`uvm_fatal("AHB_AGT","Get failed for ahb_config")

	mon = ahb_monitor::type_id::create("mon",this);

	if(cfg.is_active == UVM_ACTIVE)
		begin
			seqr = ahb_sequencer::type_id::create("seqr",this);
			drv = ahb_driver::type_id::create("drv",this);
		end

endfunction : build_phase

function void ahb_agent::connect_phase(uvm_phase phase);
	if(cfg.is_active == UVM_ACTIVE)
		drv.seq_item_port.connect(seqr.seq_item_export);
endfunction : connect_phase
