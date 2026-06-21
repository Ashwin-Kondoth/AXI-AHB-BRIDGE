class env_config extends uvm_object;
	`uvm_object_utils(env_config)

	function new (string name = "env_config");
		super.new(name);
	endfunction : new

	bit 		 has_ahb_agent  = 1;
	bit 		 has_axi_agent  = 1;

	int unsigned num_ahb_agent  = 1;
	int unsigned num_axi_agent  = 1;

	bit 		 has_scoreboard = 1;
	
	ahb_config   ahb_cfg[];
	axi_config   axi_cfg[];
	ahb_rst_config   ahb_rst_cfg[];
	axi_rst_config   axi_rst_cfg[];

endclass : env_config
