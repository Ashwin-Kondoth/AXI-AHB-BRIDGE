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

class ahb_ok_sequence extends uvm_sequence #(ahb_xtn);

    env_config cfg;

    `uvm_object_utils(ahb_ok_sequence)

    function new(string name = "ahb_ok_sequence");
        super.new(name);
    endfunction : new

    task body;
        req = ahb_xtn::type_id::create("req");
        if(!uvm_config_db #(env_config)::get(null,get_full_name,"env_config",cfg))
            `uvm_fatal("AHB_SEQ","get failed for env_config")
        repeat(2 * cfg.ahb_length.pop_front())
            begin
               start_item(req);
               assert(req.randomize() with {delay_cycles == 2; resp == 0;});
               finish_item(req); 
            end
    endtask : body
endclass : ahb_ok_sequence


class ahb_ok_wait_sequence extends uvm_sequence #(ahb_xtn);

    env_config cfg;

    `uvm_object_utils(ahb_ok_wait_sequence)

    function new(string name = "ahb_ok_wait_sequence");
        super.new(name);
    endfunction : new

    task body;
        req = ahb_xtn::type_id::create("req");
        if(!uvm_config_db #(env_config)::get(null,get_full_name,"env_config",cfg))
            `uvm_fatal("AHB_SEQ","get failed for env_config")
        repeat(2 * cfg.ahb_length.pop_front())
            begin
               start_item(req);
               assert(req.randomize() with {delay_cycles == 2; resp == 1;});
               finish_item(req); 
            end
    endtask : body
endclass : ahb_ok_wait_sequence


class ahb_error_sequence extends uvm_sequence #(ahb_xtn);

    `uvm_object_utils(ahb_error_sequence)

    function new(string name = "ahb_error_sequence");
        super.new(name);
    endfunction : new

    task body;
        req = ahb_xtn::type_id::create("req");

        repeat(4)
            begin
               start_item(req);
               assert(req.randomize() with {delay_cycles == 2; resp == 2;});
               finish_item(req); 
            end
    endtask : body
endclass : ahb_error_sequence