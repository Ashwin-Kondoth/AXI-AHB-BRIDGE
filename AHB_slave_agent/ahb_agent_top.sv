class ahb_rst_agent_top extends uvm_env;
	`uvm_component_utils(ahb_rst_agent_top)

	function new(string name = "ahb_rst_agent_top",uvm_component parent);
		super.new(name, parent);
	endfunction : new

	env_config cfg;
	
	ahb_rst_agent ahb_rst_agt[];
	
	extern function void build_phase(uvm_phase phase);	

endclass : ahb_rst_agent_top

	
function void ahb_rst_agent_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("AHB_RST_AGT_TOP","Get failed for env_config")
	
	ahb_rst_agt = new[cfg.num_ahb_agent];	
		
	foreach(ahb_rst_agt[i])
		begin
			uvm_config_db #(ahb_rst_config)::set(this,$sformatf("ahb_rst_agt[%0d]*",i),"ahb_rst_config",cfg.ahb_rst_cfg[i]);
			ahb_rst_agt[i] = ahb_rst_agent::type_id::create($sformatf("ahb_rst_agt[%0d]",i),this);
		end
endfunction : build_phase



class ahb_agent_top extends uvm_env;
	`uvm_component_utils(ahb_agent_top)

	function new(string name = "ahb_agent_top",uvm_component parent);
		super.new(name, parent);
	endfunction : new

	env_config cfg;
	
	ahb_agent ahb_agt[];
	
	extern function void build_phase(uvm_phase phase);	

endclass : ahb_agent_top

	
function void ahb_agent_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("AHB_AGT_TOP","Get failed for env_config")
	
	ahb_agt = new[cfg.num_ahb_agent];	
		
	foreach(ahb_agt[i])
		begin
			uvm_config_db #(ahb_config)::set(this,$sformatf("ahb_agt[%0d]*",i),"ahb_config",cfg.ahb_cfg[i]);
			ahb_agt[i] = ahb_agent::type_id::create($sformatf("ahb_agt[%0d]",i),this);
		end
endfunction : build_phase
