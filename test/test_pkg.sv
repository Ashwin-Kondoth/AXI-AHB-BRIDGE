package test_pkg;
	import uvm_pkg::*;

	`include "uvm_macros.svh"
	`include "ahb_config.sv"
	`include "axi_config.sv"
	`include "env_config.sv"
	`include "ahb_xtn.sv"
	`include "axi_xtn.sv"
	`include "ahb_sequencer.sv"
	`include "ahb_driver.sv"
	`include "ahb_monitor.sv"
	`include "ahb_agent.sv"
	`include "ahb_agent_top.sv"
	`include "axi_sequencer.sv"
	`include "axi_driver.sv"
	`include "axi_monitor.sv"
	`include "axi_agent.sv"
	`include "axi_agent_top.sv"
	`include "scoreboard.sv"
	`include "env.sv"
	`include "test.sv"

endpackage : test_pkg
