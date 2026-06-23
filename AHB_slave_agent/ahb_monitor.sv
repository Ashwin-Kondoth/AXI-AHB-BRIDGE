class ahb_rst_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_rst_monitor)

	uvm_analysis_port #(ahb_rst_xtn) monitor_port;

	ahb_config cfg;
	ahb_rst_config rst_cfg;
	virtual ahb_rst_if.AHB_RST_MON_MP rst_vif;
	virtual ahb_if.AHB_MON_MP vif;

	function new (string name = "ahb_rst_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction : new

	function  void build_phase(uvm_phase phase);
		if(!uvm_config_db #(ahb_rst_config)::get(this,"","ahb_rst_config",rst_cfg))
			`uvm_fatal("AHB_RST_MON","Get failed for ahb_rst_cfg")
		if(!uvm_config_db #(ahb_config)::get(this,"","ahb_config",cfg))
			`uvm_fatal("AHB_RST_MON","Get failed for ahb_cfg")
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
		ahb_rst_xtn xtn;
		xtn = ahb_rst_xtn::type_id::create("xtn");
		wait(rst_vif.ahb_rst_mon_cb.hresetn == 1'b0)
		@(rst_vif.ahb_rst_mon_cb);
		xtn.hresetn = rst_vif.ahb_rst_mon_cb.hresetn;
		xtn.hready = vif.ahb_mon_cb.hready;
		xtn.htrans = vif.ahb_mon_cb.htrans;
		@(rst_vif.ahb_rst_mon_cb);
		`uvm_info("AHB_MON",$sformatf("%s",xtn.sprint),UVM_LOW)
	endtask : collect_data

endclass : ahb_rst_monitor


class ahb_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_monitor)

	uvm_analysis_port #(ahb_xtn) monitor_port;

	function new (string name = "ahb_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction : new

endclass : ahb_monitor
	

