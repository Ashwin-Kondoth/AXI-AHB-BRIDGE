class axi_reset_sequence extends uvm_sequence #(axi_rst_xtn);

    `uvm_object_utils(axi_reset_sequence)

    function new (string name = "ahb_reset_sequence");
        super.new(name);
    endfunction : new

    task body;
        req = axi_rst_xtn::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {aresetn == 1'b0;})
            `uvm_fatal("AXI_RST_SEQ","Randomize failed")
        finish_item(req);
    endtask : body

endclass : axi_reset_sequence

class axi_base_sequence extends uvm_sequence #(axi_xtn);
	
	`uvm_object_utils(axi_base_sequence)
	
	function new(string name = "axi_base_sequence");
		super.new(name);
	endfunction : new

endclass : axi_base_sequence

class axi_INCR_write_sequence extends axi_base_sequence;
	
	`uvm_object_utils(axi_INCR_write_sequence)
	
	function new(string name = "axi_INCR_write_sequence");
		super.new(name);
	endfunction : new

	task body;
		req = axi_xtn::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {awvalid == 1'b1; wvalid == 1'b1; arvalid == 1'b0; awburst == 2'b01; awlen inside {[0:15]}; awsize inside {[0:3]}; arburst == 2'b01; arlen inside {[0:15]} ; arsize inside {[0:3]};})
            `uvm_fatal("AXI_WR_SEQ","Randomize failed")
        finish_item(req);
    endtask : body
endclass : axi_INCR_write_sequence


class axi_INCR_read_sequence extends axi_base_sequence;
	
	`uvm_object_utils(axi_INCR_read_sequence)
	
	function new(string name = "axi_INCR_read_sequence");
		super.new(name);
	endfunction : new

	task body;
		req = axi_xtn::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {awvalid == 1'b0; wvalid == 1'b0; arvalid == 1'b1; arburst == 2'b01; arlen inside {[0:15]}; arsize inside {[0:3]}; awburst == 2'b01; awlen inside {[0:15]}; awsize inside {[0:3]};})
            `uvm_fatal("AXI_RD_SEQ","Randomize failed")
        finish_item(req);
    endtask : body
endclass : axi_INCR_read_sequence


class axi_WRAP_write_sequence extends axi_base_sequence;
	
	`uvm_object_utils(axi_WRAP_write_sequence)
	
	function new(string name = "axi_WRAP_write_sequence");
		super.new(name);
	endfunction : new

	task body;
		req = axi_xtn::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {awvalid == 1'b1; wvalid == 1'b1; arvalid == 1'b0; awburst == 2'b10; awlen inside {[0:15]}; awsize inside {[0:3]}; arburst == 2'b10; arlen inside {[0:15]} ; arsize inside {[0:3]};})
            `uvm_fatal("AXI_WR_SEQ","Randomize failed")
        finish_item(req);
    endtask : body
endclass : axi_WRAP_write_sequence


class axi_WRAP_read_sequence extends axi_base_sequence;
	
	`uvm_object_utils(axi_WRAP_read_sequence)
	
	function new(string name = "axi_WRAP_read_sequence");
		super.new(name);
	endfunction : new

	task body;
		req = axi_xtn::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {awvalid == 1'b0; wvalid == 1'b0; arvalid == 1'b1; arburst == 2'b10; arlen inside {[0:15]}; arsize inside {[0:3]}; awburst == 2'b10; awlen inside {[0:15]}; awsize inside {[0:3]};})
            `uvm_fatal("AXI_RD_SEQ","Randomize failed")
        finish_item(req);
    endtask : body
endclass : axi_WRAP_read_sequence

