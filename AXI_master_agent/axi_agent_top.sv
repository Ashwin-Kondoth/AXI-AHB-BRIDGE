class axi_agent_top extends uvm_env;
	`uvm_component_utils(axi_agent_top)

	function new(string name = "axi_agent_top",uvm_component parent);
		super.new(name, parent);
	endfunction : new

	env_config cfg;
	
	axi_agent axi_agt[];
	
	extern function void build_phase(uvm_phase phase);	

endclass : axi_agent_top

	
function void axi_agent_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("axi_AGT_TOP","Get failed for env_config")
	
	axi_agt = new[cfg.num_axi_agent];	
		
	foreach(axi_agt[i])
		begin
			uvm_config_db #(axi_config)::set(this,$sformatf("axi_agt[%0d]*",i),"axi_config",cfg.axi_cfg[i]);
			axi_agt[i] = axi_agent::type_id::create($sformatf("axi_agt[%0d]",i),this);
		end
endfunction : build_phase
