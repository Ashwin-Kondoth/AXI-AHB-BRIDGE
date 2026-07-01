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
			`uvm_fatal("AXI_RST_MON","Get failed for axi_rst_cfg")
		if(!uvm_config_db #(axi_config)::get(this,"","axi_config",cfg))
			`uvm_fatal("AXI_RST_MON","Get failed for axi_cfg")
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

	uvm_analysis_port #(axi_xtn) axi_monitor_port;
	uvm_analysis_port #(axi_xtn) axi_write_data_monitor_port;
	uvm_analysis_port #(axi_xtn) axi_read_data_monitor_port;

	axi_xtn xtn,xtn1,xtn2,xtn3,xtn4,axi_write_data,axi_read_data;

	axi_xtn q1[$], q2[$];

	semaphore aw_w = new();
	semaphore w_b = new();
	semaphore aw = new(1);
	semaphore w = new(1);
	semaphore b = new(1);
	semaphore ar_r = new();
	semaphore ar = new(1);
	semaphore r = new(1);

	axi_config cfg;
	virtual axi_if.AXI_MON_MP vif;
	
	function new (string name = "axi_monitor",uvm_component parent);
		super.new(name,parent);
		axi_monitor_port = new("axi_monitor_port",this);
		axi_write_data_monitor_port = new("axi_write_data_monitor_port",this);
		axi_read_data_monitor_port = new("axi_read_data_monitor_port",this);
	endfunction : new

	function  void build_phase(uvm_phase phase);
		if(!uvm_config_db #(axi_config)::get(this,"","axi_config",cfg))
			`uvm_fatal("AXI_MON","Get failed for axi_cfg")
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction : connect_phase
	
	task run_phase(uvm_phase phase);
		forever
			collect_data;
	endtask : run_phase

	task collect_data;
		xtn = axi_xtn::type_id::create("xtn");
		fork
			begin
				aw.get(1);
				wr_addr_channel();
				aw_w.put(1);
				aw.put(1);
			end

			begin
				w.get(1);
				aw_w.get(1);
				wr_data_channel(q1.pop_front());
				w_b.put(1);
				w.put(1);
			end

			begin
				b.get(1);
				w_b.get(1);
				wr_resp_channel(q1.pop_front());
				b.put(1);
			end

			begin
				ar.get(1);
				rd_addr_channel();
				ar_r.put(1);
				ar.put(1);
			end

			begin
				r.get(1);
				ar_r.get(1);
				rd_data_channel(q2.pop_front());
				r.put(1);
			end
		join_any
	endtask : collect_data

	task wr_addr_channel;
		wait((vif.axi_mon_cb.awvalid) && (vif.axi_mon_cb.awready))
		$display("MON write_addr_channel");
		xtn.awid = vif.axi_mon_cb.awid;
		xtn.awvalid = vif.axi_mon_cb.awvalid;
		xtn.awready = vif.axi_mon_cb.awready;
		xtn.awaddr = vif.axi_mon_cb.awaddr;
		xtn.awlen = vif.axi_mon_cb.awlen;
		xtn.awsize = vif.axi_mon_cb.awsize;
		xtn.awburst = vif.axi_mon_cb.awburst;
		q1.push_back(xtn);
		@(vif.axi_mon_cb);
	endtask : wr_addr_channel

	task wr_data_channel(axi_xtn xtn);
		$display("MON write_data_channel");
		xtn1 = axi_xtn::type_id::create("xtn1");
		xtn1 = xtn;
		xtn1.wdata = new[xtn.awlen + 1];
		xtn1.wstrb = new[xtn.awlen + 1];

		foreach(xtn1.wdata[i])
			begin
				wait((vif.axi_mon_cb.wvalid) && (vif.axi_mon_cb.wready))
				axi_write_data = axi_xtn::type_id::create("axi_write_data");
				xtn.wready = vif.axi_mon_cb.wready;
				xtn.wvalid = vif.axi_mon_cb.wvalid;
				xtn1.wid = vif.axi_mon_cb.wid;
				xtn1.wdata[i] = vif.axi_mon_cb.wdata;
				axi_write_data.temp_wdata[7:0] = vif.axi_mon_cb.wstrb[0] ? vif.axi_mon_cb.wdata[7:0] : 8'b00000000;
				axi_write_data.temp_wdata[15:8] = vif.axi_mon_cb.wstrb[1] ? vif.axi_mon_cb.wdata[15:8] : 8'b00000000;
				axi_write_data.temp_wdata[23:16] = vif.axi_mon_cb.wstrb[2] ? vif.axi_mon_cb.wdata[23:16] : 8'b00000000;
				axi_write_data.temp_wdata[31:24] = vif.axi_mon_cb.wstrb[3] ? vif.axi_mon_cb.wdata[31:24] : 8'b00000000;
				axi_write_data.temp_wdata[39:32] = vif.axi_mon_cb.wstrb[4] ? vif.axi_mon_cb.wdata[39:32] : 8'b00000000;
				axi_write_data.temp_wdata[47:40] = vif.axi_mon_cb.wstrb[5] ? vif.axi_mon_cb.wdata[47:40] : 8'b00000000;
				axi_write_data.temp_wdata[55:48] = vif.axi_mon_cb.wstrb[6] ? vif.axi_mon_cb.wdata[55:48] : 8'b00000000;
				axi_write_data.temp_wdata[63:56] = vif.axi_mon_cb.wstrb[7] ? vif.axi_mon_cb.wdata[63:56] : 8'b00000000;
				xtn1.wstrb[i] = vif.axi_mon_cb.wstrb;
				if(i == (xtn.wdata.size - 1))
					xtn1.wlast = vif.axi_mon_cb.wlast;
				@(vif.axi_mon_cb);
				axi_write_data_monitor_port.write(axi_write_data);
			end
		`uvm_info("AXI_MON_WD",$sformatf("axi_trans: \n %p",xtn1.sprint()),UVM_LOW)
		q1.push_back(xtn1);
	endtask : wr_data_channel

	task wr_resp_channel(axi_xtn xtn1);
		xtn2 = axi_xtn::type_id::create("xtn2");
		xtn2 = xtn1;
		wait((vif.axi_mon_cb.bvalid) && (vif.axi_mon_cb.bready))
		$display("MON write_resp_channel");
		xtn.bvalid = vif.axi_mon_cb.bvalid;
		xtn.bready = vif.axi_mon_cb.bready;
		xtn2.bid = vif.axi_mon_cb.bid;
		xtn2.bresp = vif.axi_mon_cb.bresp;
		xtn2.bvalid = vif.axi_mon_cb.bvalid;
		axi_monitor_port.write(xtn2);
		`uvm_info("AXI_MON_WB",$sformatf("axi_trans: \n %p",xtn1.sprint()),UVM_LOW)
		@(vif.axi_mon_cb);
	endtask : wr_resp_channel

	task rd_addr_channel;
		xtn3 = axi_xtn::type_id::create("xtn3");
		@(vif.axi_mon_cb);
		wait((vif.axi_mon_cb.arvalid) && (vif.axi_mon_cb.arready))
		$display("MON read_addr_channel");
		xtn3.arid = vif.axi_mon_cb.arid;
		xtn3.arready = vif.axi_mon_cb.arready;
		xtn3.arvalid = vif.axi_mon_cb.arvalid;
		xtn3.araddr = vif.axi_mon_cb.araddr;
		xtn3.arlen = vif.axi_mon_cb.arlen;
		xtn3.arsize = vif.axi_mon_cb.arsize;
		xtn3.arburst = vif.axi_mon_cb.arburst;
		@(vif.axi_mon_cb);
		q2.push_back(xtn3);
	endtask : rd_addr_channel

	task rd_data_channel (axi_xtn xtn3);
		bit a;
		xtn4 = axi_xtn::type_id::create("xtn4");
		xtn4 = xtn3;
		xtn4.rdata = new[xtn4.arlen + 1];
		$display("MON read_data_channel");
		foreach(xtn4.rdata[i])
			begin
				wait((vif.axi_mon_cb.rvalid) && (vif.axi_mon_cb.rready))
				axi_read_data = axi_xtn::type_id::create("axi_read_data");
				xtn4.rid = vif.axi_mon_cb.rid;
				xtn4.rvalid = vif.axi_mon_cb.rvalid;
				xtn4.rready = vif.axi_mon_cb.rready;
				xtn4.rdata[i] = vif.axi_mon_cb.rdata;
				xtn4.rresp[i] = vif.axi_mon_cb.rresp;
				axi_read_data.temp_rdata = vif.axi_mon_cb.rdata;
				if(i == (xtn.rdata.size - 1))
					begin
						xtn4.rlast = vif.axi_mon_cb.rlast;
						a = vif.axi_mon_cb.rlast;
					end
				@(vif.axi_mon_cb);
				axi_read_data_monitor_port.write(axi_read_data);
			end
		axi_monitor_port.write(xtn4);
		`uvm_info("AXI_MON_RD",$sformatf("axi_trans: \n %p",xtn4.sprint()),UVM_LOW)
	endtask : rd_data_channel
				
endclass : axi_monitor
	

