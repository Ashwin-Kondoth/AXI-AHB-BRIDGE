class ahb_rst_sequencer extends uvm_sequencer #(ahb_rst_xtn);

	`uvm_component_utils(ahb_rst_sequencer)

	function new (string name = "ahb_rst_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : ahb_rst_sequencer



class ahb_sequencer extends uvm_sequencer #(ahb_xtn);

	`uvm_component_utils(ahb_sequencer)

	function new (string name = "ahb_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : ahb_sequencer
