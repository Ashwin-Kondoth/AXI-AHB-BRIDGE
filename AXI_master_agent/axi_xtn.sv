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

	rand bit [7:0]  awid;
	rand bit [31:0] awaddr;
	rand bit [7:0]  awlen;
	rand bit [2:0]  awsize;
	rand bit [1:0]  awburst;
	rand bit        awvalid;
		 bit        awready;
	rand bit [7:0]  wid;
	rand bit [63:0] wdata;
		 bit [7:0]  wstrb[];
	rand bit        wlast;
	rand bit        wvalid;
		 bit        wready;
	rand bit [7:0]  arid;
	rand bit [31:0] araddr;
	rand bit [7:0]  arlen;
	rand bit [2:0]  arsize;
	rand bit [1:0]  arburst;
	rand bit        arvalid;
		 bit        arready;
	rand bit [7:0]  bid;
	rand bit [1:0]  bresp;
	rand bit        bvalid;
		 bit        bready;
	rand bit [7:0]  rid;
	rand bit [63:0] rdata;
	rand bit [1:0]  rresp;
	rand bit        rlast;
	rand bit        rvalid;
		 bit        rready;

endclass : axi_xtn
