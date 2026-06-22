class axi_rst_driver extends uvm_driver #(axi_rst_xtn);
	`uvm_component_utils(axi_rst_driver)

	function new (string name = "axi_rst_driver",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	axi_config cfg;
	axi_rst_config rst_cfg;
	virtual axi_rst_if.AXI_RST_DRV_MP rst_vif;
	virtual axi_if.AXI_DRV_MP vif;

	function  void build_phase(uvm_phase phase);
		if(!uvm_config_db #(axi_rst_config)::get(this,"","axi_rst_config",rst_cfg))
			`uvm_fatal("AXI_RST_DRV","Get failed for axi_rst_cfg")
		if(!uvm_config_db #(axi_config)::get(this,"","axi_config",cfg))
			`uvm_fatal("AXI_RST_DRV","Get failed for axi_cfg")
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

	task send_to_dut(axi_rst_xtn xtn);
		$display("AXI DRIVER");
		@(rst_vif.axi_rst_drv_cb);
		rst_vif.axi_rst_drv_cb.aresetn <= xtn.aresetn;
		xtn.print();
		repeat(2)
		@(rst_vif.axi_rst_drv_cb);
		rst_vif.axi_rst_drv_cb.aresetn <= 1'b1;
	endtask : send_to_dut
endclass : axi_rst_driver



class axi_driver extends uvm_driver #(axi_xtn);
	`uvm_component_utils(axi_driver)

	function new (string name = "axi_driver",uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : axi_driver
	

