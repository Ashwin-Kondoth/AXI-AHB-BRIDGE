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

class axi_write_sequence extends axi_base_sequence;
	
	`uvm_object_utils(axi_write_sequence)
	
	function new(string name = "axi_write_sequence");
		super.new(name);
	endfunction : new

	task body;
		req = axi_xtn::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {awvalid == 1'b1; wvalid == 1'b1;})
            `uvm_fatal("AXI_WR_SEQ","Randomize failed")
        finish_item(req);
    endtask : body
endclass : axi_write_sequence


class axi_read_sequence extends axi_base_sequence;
	
	`uvm_object_utils(axi_read_sequence)
	
	function new(string name = "axi_read_sequence");
		super.new(name);
	endfunction : new

	task body;
		req = axi_xtn::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {arvalid == 1'b1;})
            `uvm_fatal("AXI_RD_SEQ","Randomize failed")
        finish_item(req);
    endtask : body
endclass : axi_read_sequence

