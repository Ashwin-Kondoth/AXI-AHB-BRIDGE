module top;

	import uvm_pkg::*;
	import test_pkg::*;

	bit aclock;
	bit hclock;

	ahb_if HIF(hclock);
	axi_if AIF(aclock);

	ahb_rst_if HIF_rst(hclock);
	axi_rst_if AIF_rst(aclock);
	
	axi2ahb_bridge_top AXI_AHB(aclock,
						AIF_rst.aresetn,
						hclock,
						HIF_rst.hresetn,
						AIF.awid,
						AIF.awaddr,
						AIF.awlen,
						AIF.awsize,
						AIF.awburst,
						AIF.awvalid,
						AIF.awready,
						AIF.wid,
						AIF.wdata,
						AIF.wstrb,
						AIF.wlast,
						AIF.wvalid,
						AIF.wready,
						AIF.arid,
						AIF.araddr,
						AIF.arlen,
						AIF.arsize,
						AIF.arburst,
						AIF.arvalid,
						AIF.arready,
						AIF.bid,
						AIF.bresp,
						AIF.bvalid,
						AIF.bready,
						AIF.rid,
						AIF.rdata,
						AIF.rresp,
						AIF.rlast,
						AIF.rvalid,
						AIF.rready,
						HIF.haddr,
						HIF.htrans,
						HIF.hwrite,
						HIF.hsize,
						HIF.hburst,
						HIF.hwdata,
						HIF.hbusreq,
						HIF.hlock,
						HIF.hrdata,
						HIF.hready,
						HIF.hresp,
						HIF.hgrant,
						HIF.hmaster);


	initial
		begin
			aclock = 1'b0;
			forever #5 aclock = ~aclock;
		end

	initial
		begin
			hclock = 1'b0;
			forever #10 hclock = ~hclock;
		end

	initial 
		begin
			uvm_config_db #(virtual ahb_if)::set(null,"*","ahb_vif",HIF);
			uvm_config_db #(virtual axi_if)::set(null,"*","axi_vif",AIF);
			uvm_config_db #(virtual ahb_rst_if)::set(null,"*","ahb_rst_vif",HIF_rst);
			uvm_config_db #(virtual axi_rst_if)::set(null,"*","axi_rst_vif",AIF_rst);
			run_test();
		end
endmodule : top
