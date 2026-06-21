class env extends uvm_env;
	`uvm_component_utils(env)
	
	function new(string name = "env",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	ahb_agent_top ahb_agt_top;
	axi_agent_top axi_agt_top;
	ahb_rst_agent_top ahb_rst_agt_top;
	axi_rst_agent_top axi_rst_agt_top;

	env_config cfg;
	
	sb sbh[];

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass : env

function void env::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("ENV","Get failed for env_config")

	if(cfg.has_ahb_agent)
		begin
			ahb_agt_top = ahb_agent_top::type_id::create("ahb_agt_top",this);
			ahb_rst_agt_top = ahb_rst_agent_top::type_id::create("ahb_rst_agt_top",this);
		end

	if(cfg.has_axi_agent)
		begin
			axi_agt_top = axi_agent_top::type_id::create("axi_agt_top",this);
			axi_rst_agt_top = axi_rst_agent_top::type_id::create("axi_rst_agt_top",this);
		end

	if(cfg.has_scoreboard)
		begin
			sbh = new[cfg.num_ahb_agent];
			foreach(sbh[i])
				sbh[i] = sb::type_id::create($sformatf("sbh[%0d]",i),this);
		end
endfunction : build_phase

function void env::connect_phase(uvm_phase phase);
	if(cfg.has_ahb_agent)
		begin
			if(cfg.has_scoreboard)
				foreach(sbh[i])
					begin
						ahb_agt_top.ahb_agt[i].mon.monitor_port.connect(sbh[i].ahb_fifo.analysis_export);
						ahb_rst_agt_top.ahb_rst_agt[i].mon.monitor_port.connect(sbh[i].ahb_rst_fifo.analysis_export);
					end
		end

	if(cfg.has_axi_agent)
		begin
			if(cfg.has_scoreboard)
				foreach(sbh[i])
					begin
						axi_agt_top.axi_agt[i].mon.monitor_port.connect(sbh[i].axi_fifo.analysis_export);
						axi_rst_agt_top.axi_rst_agt[i].mon.monitor_port.connect(sbh[i].axi_rst_fifo.analysis_export);
					end
		end
endfunction : connect_phase
