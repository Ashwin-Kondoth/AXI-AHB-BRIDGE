class axi_rst_monitor extends uvm_monitor;
	`uvm_component_utils(axi_rst_monitor)

	uvm_analysis_port #(axi_rst_xtn) monitor_port;

	function new (string name = "axi_rst_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction : new

endclass : axi_rst_monitor



class axi_monitor extends uvm_monitor;
	`uvm_component_utils(axi_monitor)

	uvm_analysis_port #(axi_xtn) monitor_port;

	function new (string name = "axi_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction : new

endclass : axi_monitor
	

