class ahb_rst_driver extends uvm_driver #(ahb_rst_xtn);
	`uvm_component_utils(ahb_rst_driver)

	function new (string name = "ahb_rst_driver",uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : ahb_rst_driver



class ahb_driver extends uvm_driver #(ahb_xtn);
	`uvm_component_utils(ahb_driver)

	function new (string name = "ahb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : ahb_driver
	

