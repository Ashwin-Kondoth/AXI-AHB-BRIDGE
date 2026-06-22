class ahb_rst_driver extends uvm_driver #(ahb_rst_xtn);
	`uvm_component_utils(ahb_rst_driver)

	function new (string name = "ahb_rst_driver",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	ahb_config cfg;
	ahb_rst_config rst_cfg;
	virtual ahb_rst_if.AHB_RST_DRV_MP rst_vif;
	virtual ahb_if.AHB_DRV_MP vif;

	function  void build_phase(uvm_phase phase);
		if(!uvm_config_db #(ahb_rst_config)::get(this,"","ahb_rst_config",rst_cfg))
			`uvm_fatal("AHB_RST_DRV","Get failed for ahb_rst_cfg")
		if(!uvm_config_db #(ahb_config)::get(this,"","ahb_config",cfg))
			`uvm_fatal("AHB_RST_DRV","Get failed for ahb_cfg")
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		rst_vif = rst_cfg.vif;
		vif = cfg.vif;
	endfunction : connect_phase

	task run_phase(uvm_phase phase);
		forever 
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask : run_phase

	task send_to_dut(ahb_rst_xtn xtn);
		$display("AHB DRIVER");
		@(rst_vif.ahb_rst_drv_cb);
		rst_vif.ahb_rst_drv_cb.hresetn <= xtn.hresetn;
		xtn.print();
		repeat(2)
		@(rst_vif.ahb_rst_drv_cb);
		rst_vif.ahb_rst_drv_cb.hresetn <= 1'b1;
	endtask : send_to_dut

endclass : ahb_rst_driver



class ahb_driver extends uvm_driver #(ahb_xtn);
	`uvm_component_utils(ahb_driver)

	function new (string name = "ahb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : ahb_driver