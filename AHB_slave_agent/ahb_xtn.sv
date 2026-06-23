class ahb_rst_xtn extends uvm_sequence_item;
	`uvm_object_utils(ahb_rst_xtn)

	function new (string name = "ahb_rst_xtn");
		super.new(name);
	endfunction : new

	rand bit hresetn;
	bit [1:0] htrans;
	bit hready;

	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field("hresetn",hresetn,1,UVM_BIN);
		printer.print_field("htrans",htrans,2,UVM_DEC);
		printer.print_field("hready",hready,1,UVM_BIN);
	endfunction : do_print

endclass : ahb_rst_xtn



class ahb_xtn extends uvm_sequence_item;
	`uvm_object_utils(ahb_xtn)

	function new (string name = "ahb_xtn");
		super.new(name);
	endfunction : new

endclass : ahb_xtn
