class ahb_rst_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_rst_monitor)

	uvm_analysis_port #(ahb_rst_xtn) ahb_rst_monitor_port;

	ahb_config cfg;
	ahb_rst_config rst_cfg;
	virtual ahb_rst_if.AHB_RST_MON_MP rst_vif;
	virtual ahb_if.AHB_MON_MP vif;

	function new (string name = "ahb_rst_monitor",uvm_component parent);
		super.new(name,parent);
		ahb_rst_monitor_port = new("ahb_rst_monitor_port",this);
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
		ahb_rst_monitor_port.write(xtn);
	endtask : collect_data

endclass : ahb_rst_monitor


class ahb_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_monitor)
	ahb_xtn xtn;

	ahb_config cfg;
	virtual ahb_if.AHB_MON_MP vif;

	uvm_analysis_port #(ahb_xtn) monitor_port;

	function new (string name = "ahb_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction : new

	function void build_phase(uvm_phase phase);
		 if(!uvm_config_db #(ahb_config)::get(this,"","ahb_config",cfg))
			`uvm_fatal("AHB_MON","Get failed for ahb_cfg")
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction : connect_phase

	task run_phase(uvm_phase phase);
		forever 
			collect_data();
	endtask : run_phase

	task collect_data();
		xtn = ahb_xtn::type_id::create("xtn");
		begin
			wait((vif.ahb_mon_cb.hready == 1'b1) && (vif.ahb_mon_cb.htrans == 2'b10));
			xtn.haddr = vif.ahb_mon_cb.haddr;
			xtn.htrans = vif.ahb_mon_cb.htrans;
			xtn.hburst = vif.ahb_mon_cb.hburst;
			xtn.hsize = vif.ahb_mon_cb.hsize;
			xtn.hwrite = vif.ahb_mon_cb.hwrite;
			xtn.hready = vif.ahb_mon_cb.hready;
			xtn.hresp = vif.ahb_mon_cb.hresp;

			if(vif.ahb_mon_cb.hwrite == 1'b1)
				begin
					@(vif.ahb_mon_cb);
					wait(vif.ahb_mon_cb.hready == 1'b1)
					xtn.hwdata = vif.ahb_mon_cb.hwdata;
					monitor_port.write(xtn);
				end
			else	
				begin
					@(vif.ahb_mon_cb);
					wait(vif.ahb_mon_cb.hready == 1'b1)
					xtn.hrdata = vif.ahb_mon_cb.hrdata;
					monitor_port.write(xtn);
				end
		end
		`uvm_info("AHB_MON",$sformatf("ahb_trans: \n %p",xtn.sprint()),UVM_LOW)
	endtask : collect_data
endclass : ahb_monitor
	

