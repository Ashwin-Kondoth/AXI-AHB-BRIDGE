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
		@(rst_vif.ahb_rst_drv_cb);
		rst_vif.ahb_rst_drv_cb.hresetn <= xtn.hresetn;
		vif.ahb_drv_cb.hready <= 1'b1;
		repeat(2)
		@(rst_vif.ahb_rst_drv_cb);
		rst_vif.ahb_rst_drv_cb.hresetn <= 1'b1;
		vif.ahb_drv_cb.hready <= 1'b0;
		@(rst_vif.ahb_rst_drv_cb);
	endtask : send_to_dut

endclass : ahb_rst_driver



class ahb_driver extends uvm_driver #(ahb_xtn);
	`uvm_component_utils(ahb_driver)
	ahb_config cfg;
	virtual ahb_if.AHB_DRV_MP vif;
	function new (string name = "ahb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(ahb_config)::get(this,"","ahb_config",cfg))
			`uvm_fatal("AHB_DRV","Get failed for ahb_cfg")
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

	task send_to_dut(ahb_xtn xtn);
		//$display("AHB DRIVER STARTED : %0t",$time);
		vif.ahb_drv_cb.hmaster <= 4'b0;
		if(xtn.resp == 0) //OKAY
		begin
			if(vif.ahb_drv_cb.hwrite == 1'b1)
			begin
				vif.ahb_drv_cb.hready <= 1'b1;
				vif.ahb_drv_cb.hresp <= 2'b00;
				 @(vif.ahb_drv_cb);
                vif.ahb_drv_cb.hready <= 1'b1;
                vif.ahb_drv_cb.hresp <= 2'b00;
			end
			else if(vif.ahb_drv_cb.hwrite == 1'b0)
			begin
				vif.ahb_drv_cb.hready <= 1'b1;
				vif.ahb_drv_cb.hresp <= 2'b00;
				vif.ahb_drv_cb.hrdata <= xtn.hrdata;
				@(vif.ahb_drv_cb);
			end
		end
		else if(xtn.resp == 1) //OKAY_with_wait_state
		begin
			if(vif.ahb_drv_cb.hwrite == 1'b1)
			begin
				vif.ahb_drv_cb.hready <= 1'b0;
				repeat(xtn.delay_cycles)
					@(vif.ahb_drv_cb);
				vif.ahb_drv_cb.hready <= 1'b1;
				vif.ahb_drv_cb.hresp <= 2'b00;
				@(vif.ahb_drv_cb);
				vif.ahb_drv_cb.hready <= 1'b1;
				vif.ahb_drv_cb.hresp <= 2'b00;
				@(vif.ahb_drv_cb);
				vif.ahb_drv_cb.hready <= 1'b0;
			end

			else if(vif.ahb_drv_cb.hwrite == 1'b0)
			begin
				vif.ahb_drv_cb.hready <= 1'b0;
				repeat(xtn.delay_cycles)
					@(vif.ahb_drv_cb);
				vif.ahb_drv_cb.hready <= 1'b1;
				vif.ahb_drv_cb.hresp <= 2'b00;
				vif.ahb_drv_cb.hrdata <= xtn.hrdata;
				//@(vif.ahb_drv_cb);
				//vif.ahb_drv_cb.hready <= 1'b1;
				//vif.ahb_drv_cb.hresp <= 2'b00;
				//vif.ahb_drv_cb.hrdata <= xtn.hrdata;
				@(vif.ahb_drv_cb);
				//vif.ahb_drv_cb.hready <= 1'b0;
				
			end
		end
		else if(xtn.resp == 2)
		begin
			if(vif.ahb_drv_cb.hwrite == 1'b1)
			begin
				@(vif.ahb_drv_cb);
				if(vif.ahb_drv_cb.htrans == (2'b10)) //NON_SEQ
				begin
					vif.ahb_drv_cb.hready <= 1'b0;
					vif.ahb_drv_cb.hresp <= 2'b01;
					@(vif.ahb_drv_cb);
					vif.ahb_drv_cb.hready <= 1'b1;
					vif.ahb_drv_cb.hresp <= 2'b01;
					@(vif.ahb_drv_cb);
					vif.ahb_drv_cb.hready <= 1'b0;
				end
				else
				begin
					repeat(2)
						@(vif.ahb_drv_cb);
					vif.ahb_drv_cb.hready <= 1'b1;
					vif.ahb_drv_cb.hresp <= 2'b01;
					repeat(2)
						@(vif.ahb_drv_cb);
					vif.ahb_drv_cb.hready <= 1'b0;
				end
			end
		end
	endtask : send_to_dut
endclass : ahb_driver
