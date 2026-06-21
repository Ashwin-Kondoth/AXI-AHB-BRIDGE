class axi_rst_agent extends uvm_agent;
	`uvm_component_utils(axi_rst_agent)

	function new(string name = "axi_rst_agent",uvm_component parent);
		super.new(name,parent);
	endfunction : new
	
	axi_rst_config cfg;
	
	axi_rst_driver drv;
	axi_rst_monitor mon;
	axi_rst_sequencer seqr;

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass : axi_rst_agent

function void axi_rst_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(axi_rst_config)::get(this,"","axi_rst_config",cfg))
		`uvm_fatal("AXI_RST_AGT","Get failed for axi_config")

	mon = axi_rst_monitor::type_id::create("mon",this);

	if(cfg.is_active == UVM_ACTIVE)
		begin
			seqr = axi_rst_sequencer::type_id::create("seqr",this);
			drv = axi_rst_driver::type_id::create("drv",this);
		end

endfunction : build_phase

function void axi_rst_agent::connect_phase(uvm_phase phase);
	if(cfg.is_active == UVM_ACTIVE)
		drv.seq_item_port.connect(seqr.seq_item_export);
endfunction : connect_phase



class axi_agent extends uvm_agent;
	`uvm_component_utils(axi_agent)

	function new(string name = "axi_agent",uvm_component parent);
		super.new(name,parent);
	endfunction : new
	
	axi_config cfg;
	
	axi_driver drv;
	axi_monitor mon;
	axi_sequencer seqr;

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass : axi_agent

function void axi_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(axi_config)::get(this,"","axi_config",cfg))
		`uvm_fatal("AXI_AGT","Get failed for axi_config")

	mon = axi_monitor::type_id::create("mon",this);

	if(cfg.is_active == UVM_ACTIVE)
		begin
			seqr = axi_sequencer::type_id::create("seqr",this);
			drv = axi_driver::type_id::create("drv",this);
		end

endfunction : build_phase

function void axi_agent::connect_phase(uvm_phase phase);
	if(cfg.is_active == UVM_ACTIVE)
		drv.seq_item_port.connect(seqr.seq_item_export);
endfunction : connect_phase
