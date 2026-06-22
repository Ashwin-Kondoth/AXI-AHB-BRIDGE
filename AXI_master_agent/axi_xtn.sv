class axi_rst_xtn extends uvm_sequence_item;
	`uvm_object_utils(axi_rst_xtn)

	function new (string name = "axi_rst_xtn");
		super.new(name);
	endfunction : new

	rand bit aresetn;
	bit bvalid;
	bit rvalid;

	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field("aresetn",aresetn,1,UVM_BIN);
		printer.print_field("bvalid",bvalid,1,UVM_BIN);
		printer.print_field("rvalid",rvalid,1,UVM_BIN);
	endfunction : do_print
	
endclass : axi_rst_xtn



class axi_xtn extends uvm_sequence_item;
	`uvm_object_utils(axi_xtn)

	function new (string name = "axi_xtn");
		super.new(name);
	endfunction : new

endclass : axi_xtn
