class ahb_rst_xtn extends uvm_sequence_item;
	`uvm_object_utils(ahb_rst_xtn)

	function new (string name = "ahb_rst_xtn");
		super.new(name);
	endfunction : new

endclass : ahb_rst_xtn



class ahb_xtn extends uvm_sequence_item;
	`uvm_object_utils(ahb_xtn)

	function new (string name = "ahb_xtn");
		super.new(name);
	endfunction : new

endclass : ahb_xtn
