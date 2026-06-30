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
		@(rst_vif.axi_rst_drv_cb);
		rst_vif.axi_rst_drv_cb.aresetn <= xtn.aresetn;
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
	
	axi_xtn q1[$], q2[$], q3[$], q4[$], q5[$];
	
	semaphore aw_w = new();
	semaphore w_b = new();
	semaphore aw = new(1);
	semaphore w = new(1);
	semaphore b = new(1);
	semaphore ar_r = new();
	semaphore ar = new(1);
	semaphore r = new(1);

	axi_config cfg;
	
	virtual axi_if.AXI_DRV_MP vif;

	function  void build_phase(uvm_phase phase);
		if(!uvm_config_db #(axi_config)::get(this,"","axi_config",cfg))
			`uvm_fatal("AXI_DRV","Get failed for axi_cfg")
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
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

	task send_to_dut(axi_xtn xtn);
		q1.push_back(xtn);
		q2.push_back(xtn);
		q3.push_back(xtn);
		q4.push_back(xtn);
		q5.push_back(xtn);

		fork
			begin
				aw.get(1);
				write_addr_channel(q1.pop_front());
				aw.put(1);
				aw_w.put(1);
			end
			
			begin
				aw_w.get(1);
				w.get(1);
				write_data_channel(q2.pop_front());
				w.put(1);
				w_b.put(1);
			end
		
			begin
				w_b.get(1);
				b.get(1);
				write_resp_channel(q3.pop_front());
				b.put(1);
			end
			
			begin
				ar.get(1);
				read_addr_channel(q4.pop_front());
				ar.put(1);
				ar_r.put(1);
			end
			
			begin
				ar_r.get(1);
				r.get(1);
				read_data_channel(q5.pop_front());
				r.put(1);
			end
		join_any
	endtask : send_to_dut

	task write_addr_channel(axi_xtn xtn);
		@(vif.axi_drv_cb)
			begin
				$display("write_addr_channel");
				vif.axi_drv_cb.awvalid <= xtn.awvalid;
				vif.axi_drv_cb.awid <= xtn.awid;
				vif.axi_drv_cb.awaddr <= xtn.awaddr;
				vif.axi_drv_cb.awlen <= xtn.awlen;
				vif.axi_drv_cb.awsize <= xtn.awsize;
				vif.axi_drv_cb.awburst <= xtn.awburst;
				wait(vif.axi_drv_cb.awready)
				@(vif.axi_drv_cb);
				vif.axi_drv_cb.awvalid <= 1'b0;
				`uvm_info("AXI_DRV",$sformatf("AW_axi_xtn: \n %p",xtn.sprint()),UVM_LOW)
				repeat (xtn.delay_cycles)
					@(vif.axi_drv_cb);
			end
	endtask : write_addr_channel

	task write_data_channel(axi_xtn xtn);
		begin
			$display("write_data_channel");
			foreach(xtn.wdata[i])
				begin
					vif.axi_drv_cb.wvalid <= xtn.wvalid;
					vif.axi_drv_cb.wid <= xtn.wid;
					vif.axi_drv_cb.wdata <= xtn.wdata[i];
					vif.axi_drv_cb.wstrb <= xtn.wstrb[i];
				
					if(i == (xtn.awlen))
						vif.axi_drv_cb.wlast <= xtn.wlast;
					else
						vif.axi_drv_cb.wlast <= xtn.wlast;
					
					wait(vif.axi_drv_cb.wready)
					@(vif.axi_drv_cb.wready);
					vif.axi_drv_cb.wvalid <= 1'b0;
					vif.axi_drv_cb.wlast <= 1'b0;
					`uvm_info("AXI_DRV",$sformatf("W_axi_xtn: \n %p",xtn.sprint()),UVM_LOW)
					@(vif.axi_drv_cb)
					repeat(xtn.delay_cycles)
					@(vif.axi_drv_cb);
				end
		end
	endtask : write_data_channel
	
	task write_resp_channel (axi_xtn xtn);
		$display("write_resp_channel");
		vif.axi_drv_cb.bready <= 1'b1;
		wait(vif.axi_drv_cb.bvalid)
		`uvm_info("AXI_DRV",$sformatf("B_axi_xtn: \n %p",xtn.sprint()),UVM_LOW)
		@(vif.axi_drv_cb);
		repeat(xtn.delay_cycles)
		@(vif.axi_drv_cb);
	endtask : write_resp_channel
	
	task read_addr_channel (axi_xtn xtn);
		@(vif.axi_drv_cb)
		begin
			$display("read_addr_channel");
			vif.axi_drv_cb.arvalid <= xtn.arvalid;
			vif.axi_drv_cb.arid <= xtn.arid;
			vif.axi_drv_cb.araddr <= xtn.araddr;
			vif.axi_drv_cb.arlen <= xtn.arlen;
			vif.axi_drv_cb.arsize <= xtn.arsize;
			vif.axi_drv_cb.arburst <= xtn.arburst;
			wait(vif.axi_drv_cb.arready)
			@(vif.axi_drv_cb);
			vif.axi_drv_cb.arvalid <= 1'b0;
			`uvm_info("AXI_DRV",$sformatf("AR_axi_xtn: \n %p",xtn.sprint()),UVM_LOW)
			repeat(xtn.delay_cycles)
			@(vif.axi_drv_cb);
		end
	endtask : read_addr_channel

	task read_data_channel (axi_xtn xtn);
		repeat(vif.axi_drv_cb.arlen + 1)
			begin
				@(vif.axi_drv_cb)
				$display("read_data_channel");
				vif.axi_drv_cb.rready <= 1'b1;
				wait(vif.axi_drv_cb.rvalid)
				@(vif.axi_drv_cb);
				vif.axi_drv_cb.rready <= 1'b0;
				`uvm_info("AXI_DRV",$sformatf("R_axi_xtn: \n %p",xtn.sprint()),UVM_LOW)
				repeat(xtn.delay_cycles)
				@(vif.axi_drv_cb);
			end
	endtask : read_data_channel
	
endclass : axi_driver
	

