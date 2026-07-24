class sb extends uvm_scoreboard;
	`uvm_component_utils(sb)
	
	uvm_tlm_analysis_fifo #(ahb_xtn) ahb_fifo;
	uvm_tlm_analysis_fifo #(axi_xtn) axi_fifo;
	uvm_tlm_analysis_fifo #(ahb_rst_xtn) ahb_rst_fifo;
	uvm_tlm_analysis_fifo #(axi_rst_xtn) axi_rst_fifo;
	uvm_tlm_analysis_fifo #(axi_xtn) axi_wdata_fifo;
	uvm_tlm_analysis_fifo #(axi_xtn) axi_rdata_fifo;

	axi_xtn wdata[$],rdata[$];

	axi_rst_xtn arxtn;
	axi_rst_xtn axi_rst_cov_data;
	ahb_rst_xtn hrxtn;
	ahb_rst_xtn ahb_rst_cov_data;
	axi_xtn axtn,axi_wdata_xtn, axi_rdata_xtn;
	axi_xtn axi_cov_data;
	ahb_xtn ahb_cov_data; 
	ahb_xtn hxtn;

	int no_of_write_verified = 0;
	int no_of_read_verified = 0;
	int no_of_axi_reset_verified = 0;
	int no_of_ahb_reset_verified = 0;
	int no_of_transactions = 0;

	env_config env_cfg;

	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task axi_rst_check(axi_rst_xtn arxtn);
	extern task ahb_rst_check(ahb_rst_xtn hrxtn);
	extern task data_compare(ahb_xtn hxtn);
	extern function void report_phase(uvm_phase phase);

	covergroup axi_rst_cg;

		option.per_instance=1;
		CP_A_RESETN : coverpoint axi_rst_cov_data.aresetn{ bins RST={0};}

	endgroup

	covergroup ahb_rst_cg;

		option.per_instance=1;

		CP_H_RESETN : coverpoint ahb_rst_cov_data.hresetn{ bins RST={0};}

	endgroup

	covergroup axi_wdata_dyn_cg with function sample(int i);

		CP_W_DATA: coverpoint axi_cov_data.wdata[i] { bins wdata = {[64'h0000_0000_0000_0000:64'hffff_ffff_ffff_ffff]};}

		CP_W_STRB: coverpoint axi_cov_data.wstrb[i] { bins W_STRB[] ={1,2,4, 8,16,32,64,128,3, 12,48,192,15,240,255};}

	endgroup

	covergroup axi_rdata_dyn_cg with function sample(int i);

		CP_R_DATA: coverpoint axi_cov_data.rdata[i] { bins rdata = {[64'h0000_0000_0000_0000:64'hffff_ffff_ffff_ffff]};}

		CP_RRESP: coverpoint axi_cov_data.rresp[i] { bins RRESP[]={0};}

	endgroup

	covergroup ahb_cg;

		option.per_instance=1;
		CP_HADDR : coverpoint ahb_cov_data.haddr { bins first_slave = {[32'h0000_0000:32'h4444_4444]};
							bins second_slave ={[32'h4444_4445: 32'h8888_8888]};
							bins third_slave = {[32'h8888_8889:32'hcccc_cccc]};
							bins fourth_slave ={[32'hcccc_cccd:32'hffff_ffff]};} 
		CP_HWRITE: coverpoint ahb_cov_data.hwrite { bins HWRITE[]={0,1};}
		CP_HSIZE: coverpoint ahb_cov_data.hsize { bins H_SIZE[] ={0,1,2,3};}
		CP_HREADY: coverpoint ahb_cov_data.hready {bins H_READY[]={1};}
		CP_HRESP: coverpoint ahb_cov_data.hresp {bins H_RESP[]={0,1};}
		CP_HWDATA: coverpoint ahb_cov_data.hwdata { bins ahb_wdata = {[64'h0000_0000_0000_0000:64'hffff_ffff_ffff_ffff]};}
		CP_HRDATA: coverpoint ahb_cov_data.hrdata { bins ahb_rdata = {[64'h0000_0000_0000_0000:64'hffff_ffff_ffff_ffff]};}

	endgroup

	covergroup axi_cg;

		option.per_instance=1;
		CP_AW_ID: coverpoint axi_cov_data.awid { bins low ={[0:$]};}
		CP_AW_ADDR: coverpoint axi_cov_data.awaddr {bins first_slave = {[32'h0000_0000:32'h4444_4444]};
								bins second_slave ={[32'h4444_4445: 32'h8888_8888]};
								bins third_slave = {[32'h8888_8889:32'hcccc_cccc]};
								bins fourth_slave ={[32'hcccc_cccd:32'hffff_ffff]};}
		CP_AWLEN: coverpoint axi_cov_data.awlen { bins AW_LEN ={[1:15]};}
		CP_AWSIZE: coverpoint axi_cov_data.awsize {bins AW_SIZE[] ={0,1,2,3};}
		CP_AWBURST: coverpoint axi_cov_data.awburst {bins AW_BURST[] ={[0:2]};}
		//CP_AWVALID: coverpoint axi_cov_data.awvalid{bins AW_VALID[]={0,1};}
		// CP_AWREADY: coverpoint axi_cov_data.awready{bins AW_READY[]={0,1};}

		CP_W_ID: coverpoint axi_cov_data.wid {bins low ={[0:$]};}
		CP_W_LAST: coverpoint axi_cov_data.wlast{ bins W_LAST[]={0,1};}
		// CP_WWALID: coverpoint axi_cov_data.wvalid(bins W_VALID[]={0,1};}
		//CP_WREADY: coverpoint axi_cov_data.wready{bins W_READY[]= {0,1};}

		CP_B_ID: coverpoint axi_cov_data.bid { bins low ={[0:$]};}
		CP_BRESP: coverpoint axi_cov_data.bresp{ bins B_BRESP[]={0,1};}
		//CP_BVALID: coverpoint axi_cov_data.bvalid{bins B_VALID[]={0,1};}
		//CP_BREADY: coverpoint axi_cov_data.bready{bins B_READY[]={0,1};}

		CP_AR_ID: coverpoint axi_cov_data.arid { bins low ={[0:$]};}
		CP_AR_ADDR: coverpoint axi_cov_data.araddr { bins slave_addr = {[32'h0000_0000:32'hffff_ffff]};}
		CP_ARLEN: coverpoint axi_cov_data.arlen { bins AR_LEN ={[1:15]};}
		CP_ARSIZE: coverpoint axi_cov_data.arsize { bins AR_SIZE[] ={0,1,2,3};}
		CP_ARBURST: coverpoint axi_cov_data.arburst { bins AR_BURST[] ={[0:2]};}
		//CP_ARVALID: coverpoint axi_cov_data.arvalid{bins AR_VALID[]={0,1};}
		// CP_ARREADY: coverpoint axi_cov_data.arready{bins AR_READY[]={0,1};}

		CP_R_ID: coverpoint axi_cov_data.rid { bins low ={[0:$]};}
		CP_R_LAST: coverpoint axi_cov_data.rlast{ bins R_LAST[]={0,1};}
		// CP_RVALID: coverpoint axi_cov_data.rvalid{bins R_VALID[]={0,1};}
		// CP_RREADY: coverpoint axi_cov_data.rready(bins R_READY[]={0,1};}

	endgroup


	function new(string name = "sb",uvm_component parent);
		super.new(name,parent);
		ahb_fifo = new("ahb_fifo",this);
		axi_fifo = new("axi_fifo",this);
		ahb_rst_fifo = new("ahb_rst_fifo",this);
		axi_rst_fifo = new("axi_rst_fifo",this);
		axi_wdata_fifo = new("axi_wdata_fifo",this);
		axi_rdata_fifo = new("axi_rdata_fifo",this);

		axi_cg=new();
		axi_rst_cg=new();
		ahb_cg=new();
		ahb_rst_cg=new();
		axi_wdata_dyn_cg=new();
		axi_rdata_dyn_cg=new();
	endfunction : new
endclass : sb


function void sb::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal("SB:","get is failed")
		
endfunction

task sb::run_phase(uvm_phase phase);
	fork
		begin
		forever begin
			axi_rst_fifo.get(arxtn);
			axi_rst_check(arxtn);
			axi_rst_cov_data = new arxtn;
			axi_rst_cg.sample();
		end
		end
		begin
		forever begin
			ahb_rst_fifo.get(hrxtn);
			ahb_rst_check(hrxtn);
			ahb_rst_cov_data = new hrxtn;
			ahb_rst_cg.sample();
		end
		end
		begin
		forever begin
			axi_fifo.get(axtn);
			axi_cov_data = new axtn;
			axi_cg.sample();
			foreach(axi_cov_data.wdata[i])
			axi_wdata_dyn_cg.sample(i);
			foreach(axi_cov_data.rdata[i])
			axi_rdata_dyn_cg.sample(i);
		end
		end
		begin
		forever begin
			ahb_fifo.get(hxtn);
			data_compare(hxtn);
			ahb_cov_data = new hxtn;
			ahb_cg.sample();
		end
		end
		begin
		forever begin
			axi_wdata_fifo.get(axi_wdata_xtn);
			wdata.push_back(axi_wdata_xtn);
			no_of_transactions ++;
		end
		end
		begin
		forever begin
			axi_rdata_fifo.get(axi_rdata_xtn);
			rdata.push_back(axi_rdata_xtn);
			no_of_transactions ++;
		end
		end
	join
endtask

task sb::axi_rst_check(axi_rst_xtn arxtn);
	if(arxtn.aresetn==1'b0)
	begin
	if(arxtn.bvalid==1'b0 && arxtn.rvalid==1'b0) begin
	`uvm_info("SB_AXI_RST","axi reset passed",UVM_LOW)
	no_of_axi_reset_verified ++;
	end
	else
	`uvm_error("SB_AXI_RST","axi reset failed")
	end
endtask

task sb::ahb_rst_check(ahb_rst_xtn hrxtn);
	if(hrxtn.hresetn==1'b0)
	begin
	if(hrxtn.htrans==2'b00) begin
	`uvm_info("SB_AHB_RST","ahb reset passed",UVM_LOW)
	no_of_ahb_reset_verified ++;
	end
	else
	`uvm_error("SB_AHB_RST","ahb reset failed")
	end
endtask

task sb::data_compare(ahb_xtn hxtn);
	axi_xtn axtn;
	if(hxtn.hwrite == 1'b1)
	begin
		wait(wdata.size!=0)
		axtn=wdata.pop_front();
		if(axtn.temp_wdata==hxtn.hwdata)
		begin
		`uvm_info("SB_AXI:", "data is matched", UVM_LOW)
		`uvm_info("SB_AXI:", $sformatf("axi_temporary_wdata: %0h, ahb_hwdata: %0h",axtn.temp_wdata, hxtn.hwdata),UVM_LOW)
		no_of_write_verified ++;
		end
		else begin
		`uvm_error("SB_AXI:", "data is mismatched")
		end
	end

	else
	begin
		wait(rdata.size!=0)
		axtn=rdata.pop_front();
		if(axtn.temp_rdata==hxtn.hrdata)
		begin
		`uvm_info("SB_AXI:", "data is matched", UVM_LOW)
		`uvm_info("SB_AXI:", $sformatf("axi_temporary_rdata: %0h, ahb_hrdata: %0h",axtn.temp_rdata, hxtn.hrdata),UVM_LOW)
		no_of_read_verified ++;
		end
		else begin
		`uvm_error("SB_AXI:", "data is mismatched")
		end
	end
endtask

function void sb::report_phase(uvm_phase phase);
	$display("================================================================================================================================================================");
	$display("|\t \t \t \t \t \t \t     AXI_AHB_BRIDGE REPORT                                                                               |");
	$display("================================================================================================================================================================");
	$display("|\t \t \t \t \t \t \t No of axi write verified: %0d                                                                            |\n",no_of_write_verified);
	$display("|\t \t \t \t \t \t \t No of axi read verified:  %0d                                                                            |\n",no_of_read_verified);
	$display("|\t \t \t \t \t \t \t No of transactions: %0d                                                                       	         |\n",no_of_transactions);
	$display("|\t \t \t \t \t \t \t No of axi reset verified: %0d                                                                             |\n",no_of_axi_reset_verified);
	$display("|\t \t \t \t \t \t \t No of ahb reset verified: %0d                                                                             |\n",no_of_ahb_reset_verified);
	$display("================================================================================================================================================================");
endfunction