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
	rand bit [63:0] wdata[];
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
	rand bit [63:0] rdata[];
	rand bit [1:0]  rresp[];
	rand bit        rlast;
	rand bit        rvalid;
		 bit        rready;
		 int		delay_cycles;

	constraint write_id_con	{awid == wid ; bid == wid;}
	constraint read_id_con	{rid == arid;}

	constraint arburst_con	{arburst inside {0,1,2};}
	constraint awburst_con	{awburst inside {0,1,2};}

	constraint arsize_con	{arsize inside {0,1,2,3};}
	constraint awsize_con	{awsize inside {0,1,2,3};}

	constraint write_data_con {wdata.size == (awlen + 1);}

	constraint write_align1	{((awburst == 2'b10) && (awsize == 1)) -> awaddr%2 == 0;}
	constraint write_align2	{((awburst == 2'b10) && (awsize == 2)) -> awaddr%4 == 0;}
	constraint write_align3	{((awburst == 2'b10) && (awsize == 3)) -> awaddr%8 == 0;}
	
	constraint read_align1	{((arburst == 2'b10) && (arsize == 1)) -> araddr%2 == 0;}
	constraint read_align2	{((arburst == 2'b10) && (arsize == 2)) -> araddr%4 == 0;}
	constraint read_align3	{((arburst == 2'b10) && (arsize == 3)) -> araddr%8 == 0;}

	function void post_randomize();
		int j=0;
		bit [31:0] start_address = awaddr;
		int number_of_bytes = 2**awsize;
		int burst_length = awlen + 1;
		bit [31:0] aligned_address = (start_address/number_of_bytes) * number_of_bytes;
		wstrb = new[burst_length];

		for(int i = (start_address % 8); i < ((aligned_address % 8) + number_of_bytes); i++)
			begin
				wstrb[j][i] = 1'b1;
			end

		for(int l = 1; l < burst_length; l++)
			begin
				aligned_address = aligned_address + number_of_bytes;
				j++;
				for (int k = (aligned_address % 8); k < ((aligned_address % 8) + number_of_bytes); k++)
					wstrb[j][k] = 1'b1;
			end
	endfunction : post_randomize

	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field("awid",awid,8,UVM_HEX);
		printer.print_field("awaddr",awaddr,32,UVM_HEX);
		printer.print_field("awlen",awlen,8,UVM_HEX);
		printer.print_field("awsize",awsize,3,UVM_HEX);
		printer.print_field("awburst",awburst,2,UVM_HEX);
		printer.print_field("awvalid",arvalid,1,UVM_BIN);
		printer.print_field("awready",awready,1,UVM_BIN);
		printer.print_field("wid",wid,8,UVM_HEX);
		foreach(wdata[i])
			printer.print_field($sformatf("wdata[%0d]",i),wdata[i],64,UVM_HEX);
		printer.print_field("wlast",wlast,1,UVM_BIN);
		printer.print_field("wvalid",wvalid,1,UVM_BIN);
		printer.print_field("wready",wready,1,UVM_BIN);
		printer.print_field("arid",arid,8,UVM_HEX);
		printer.print_field("araddr",araddr,32,UVM_HEX);
		printer.print_field("arlen",arlen,8,UVM_HEX);
		printer.print_field("arsize",arsize,3,UVM_HEX);
		printer.print_field("arburst",arburst,2,UVM_HEX);
		printer.print_field("arvalid",arvalid,1,UVM_BIN);
		printer.print_field("arready",arready,2,UVM_BIN);
		printer.print_field("bid",bid,8,UVM_HEX);
		printer.print_field("bresp",bresp,2,UVM_HEX);
		printer.print_field("bvalid",bvalid,1,UVM_BIN);
		printer.print_field("bready",bready,1,UVM_BIN);		
		printer.print_field("rid",rid,8,UVM_HEX);
		foreach(rdata[i])
			printer.print_field($sformatf("rdata[%0d]",i),rdata[i],64,UVM_HEX);
		foreach(rresp[i])
			printer.print_field($sformatf("rresp[%0d]",i),rresp[i],2,UVM_HEX);
		printer.print_field("rlast",rlast,1,UVM_BIN);
		printer.print_field("rvalid",rvalid,1,UVM_BIN);
		printer.print_field("rready",rready,1,UVM_BIN);

	endfunction : do_print
endclass : axi_xtn

