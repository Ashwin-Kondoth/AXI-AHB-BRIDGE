class axi_rst_xtn extends uvm_sequence_item;
	`uvm_object_utils(axi_rst_xtn)

	function new (string name = "axi_rst_xtn");
		super.new(name);
	endfunction : new

endclass : axi_rst_xtn



class axi_xtn extends uvm_sequence_item;
	`uvm_object_utils(axi_xtn)

	function new (string name = "axi_xtn");
		super.new(name);
	endfunction : new

endclass : axi_xtn
