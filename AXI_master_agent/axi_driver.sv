class axi_rst_driver extends uvm_driver #(axi_rst_xtn);
	`uvm_component_utils(axi_rst_driver)

	function new (string name = "axi_rst_driver",uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : axi_rst_driver



class axi_driver extends uvm_driver #(axi_xtn);
	`uvm_component_utils(axi_driver)

	function new (string name = "axi_driver",uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : axi_driver
	

