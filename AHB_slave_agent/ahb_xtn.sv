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

	bit hwrite;
	bit	[2:0] hsize;
	bit [1:0] htrans;
	bit [31:0] haddr;
	bit [2:0] hburst;
	bit [63:0] hwdata;
	bit hbusreq;
	bit hlock;
	rand bit [63:0] hrdata;
	bit hready;
	bit [1:0] hresp;
	bit [1:0] hmaster;
	rand bit [1:0] delay_cycles;
	rand enum {okay, okay_with_wait_state, error} resp;

	constraint delay_c {delay_cycles inside {[2:5]};}
	constraint h_resp_c {hresp inside {[0:1]};}

	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field("hwrite",hwrite,1,UVM_BIN);
		printer.print_field("hsize",hsize,3,UVM_HEX);
		printer.print_field("haddr",haddr,32,UVM_HEX);
		printer.print_field("hburst",hburst,3,UVM_HEX);
		printer.print_field("hwdata",hwdata,64,UVM_HEX);
		printer.print_field("hbusreq",hbusreq,1,UVM_BIN);
		printer.print_field("hlock",hlock,1,UVM_BIN);
		printer.print_field("hrdata",hrdata,64,UVM_HEX);
		printer.print_field("hready",hready,1,UVM_BIN);
		printer.print_field("hmaster",hmaster,2,UVM_DEC);
		printer.print_field("hresp",hresp,2,UVM_DEC);
		printer.print_field("delay_cycles",delay_cycles,2,UVM_DEC);
	endfunction : do_print
endclass : ahb_xtn