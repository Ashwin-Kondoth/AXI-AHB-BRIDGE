class ahb_reset_sequence extends uvm_sequence #(ahb_rst_xtn);

    `uvm_object_utils(ahb_reset_sequence)

    function new (string name = "ahb_reset_sequence");
        super.new(name);
    endfunction : new

    task body;
        req = ahb_rst_xtn::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {hresetn == 1'b0;})
            `uvm_fatal("AHB_RST_SEQ","Randomize failed")
        finish_item(req);
    endtask : body

endclass : ahb_reset_sequence

class ahb_sequence extends uvm_sequence #(ahb_xtn);

    `uvm_object_utils(ahb_sequence)

    function new(string name = "ahb_sequence");
        super.new(name);
    endfunction : new

    task body;
        req = ahb_xtn::type_id::create("req");

        repeat(4)
            begin
               start_item(req);
               assert(req.randomize() with {delay_cycles == 2; resp == 0;});
               finish_item(req); 
            end
    endtask : body
endclass : ahb_sequence