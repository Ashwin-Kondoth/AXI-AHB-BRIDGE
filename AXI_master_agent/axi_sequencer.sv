class axi_rst_sequencer extends uvm_sequencer #(axi_rst_xtn);

	`uvm_component_utils(axi_rst_sequencer)

	function new (string name = "axi_rst_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : axi_rst_sequencer



class axi_sequencer extends uvm_sequencer #(axi_xtn);

	`uvm_component_utils(axi_sequencer)

	function new (string name = "axi_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : axi_sequencer
