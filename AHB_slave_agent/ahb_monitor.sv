class ahb_rst_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_rst_monitor)

	uvm_analysis_port #(ahb_rst_xtn) monitor_port;

	function new (string name = "ahb_rst_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction : new

endclass : ahb_rst_monitor


class ahb_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_monitor)

	uvm_analysis_port #(ahb_xtn) monitor_port;

	function new (string name = "ahb_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction : new

endclass : ahb_monitor
	

