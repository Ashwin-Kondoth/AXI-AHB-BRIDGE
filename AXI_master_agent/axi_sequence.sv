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