class sb extends uvm_scoreboard;
	`uvm_component_utils(sb)
	
	uvm_tlm_analysis_fifo #(ahb_xtn) ahb_fifo;
	uvm_tlm_analysis_fifo #(axi_xtn) axi_fifo;

	function new(string name = "sb",uvm_component parent);
		super.new(name,parent);
		ahb_fifo = new("ahb_fifo",this);
		axi_fifo = new("axi_fifo",this);
	endfunction : new

endclass : sb
