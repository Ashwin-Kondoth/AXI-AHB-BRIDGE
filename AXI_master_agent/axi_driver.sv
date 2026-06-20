class axi_driver extends uvm_driver #(axi_xtn);
	`uvm_component_utils(axi_driver)

	function new (string name = "axi_driver",uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : axi_driver
	

