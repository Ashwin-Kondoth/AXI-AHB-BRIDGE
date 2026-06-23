class axi_rst_monitor extends uvm_monitor;
	`uvm_component_utils(axi_rst_monitor)

	uvm_analysis_port #(axi_rst_xtn) monitor_port;

	axi_config cfg;
	axi_rst_config rst_cfg;
	virtual axi_rst_if.AXI_RST_MON_MP rst_vif;
	virtual axi_if.AXI_MON_MP vif;

	function new (string name = "axi_rst_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction : new

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
			collect_data();
	endtask : run_phase

	task collect_data();
		axi_rst_xtn xtn;
		xtn = axi_rst_xtn::type_id::create("xtn");
		wait(rst_vif.axi_rst_mon_cb.aresetn == 1'b0)
		@(rst_vif.axi_rst_mon_cb);
		xtn.aresetn = rst_vif.axi_rst_mon_cb.aresetn;
		xtn.bvalid = vif.axi_mon_cb.bvalid;
		xtn.rvalid = vif.axi_mon_cb.rvalid;
		@(rst_vif.axi_rst_mon_cb);
		`uvm_info("AXI_MON",$sformatf("%s",xtn.sprint),UVM_LOW)
	endtask : collect_data

endclass : axi_rst_monitor



class axi_monitor extends uvm_monitor;
	`uvm_component_utils(axi_monitor)

	uvm_analysis_port #(axi_xtn) monitor_port;

	function new (string name = "axi_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction : new

endclass : axi_monitor
	

