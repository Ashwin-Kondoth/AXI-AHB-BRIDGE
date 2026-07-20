class base_test extends uvm_test;

	`uvm_component_utils(base_test)
	
	function new(string name = "base_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	env envh;
	
	env_config cfg;
	ahb_config ahb_cfg[];
	axi_config axi_cfg[];
	ahb_rst_config   ahb_rst_cfg[];
	axi_rst_config   axi_rst_cfg[];
	
	bit has_ahb_agent = 1;
	bit has_axi_agent = 1;
	
	int unsigned num_ahb_agent = 1;
	int unsigned num_axi_agent = 1;

	bit has_scoreboard = 1;
	
	ahb_reset_sequence ahb_rst_seq;
	axi_reset_sequence axi_rst_seq;
	axi_INCR_write_sequence axi_incr_wr_seq;
	axi_INCR_read_sequence axi_incr_rd_seq;
	axi_WRAP_write_sequence axi_wrap_wr_seq;
	axi_WRAP_read_sequence axi_wrap_rd_seq;
	ahb_ok_sequence ahb_ok_seq;
	ahb_ok_wait_sequence ahb_ok_wait_seq;
	ahb_error_sequence ahb_error_seq;

	extern function void build_phase(uvm_phase phase);
	extern function void configure_env;
	extern function void end_of_elaboration_phase(uvm_phase phase);

endclass : base_test

function void base_test::build_phase(uvm_phase phase);
	cfg = env_config::type_id::create("cfg");
	if(has_ahb_agent)
		begin
			ahb_cfg = new[num_ahb_agent];
			ahb_rst_cfg = new[num_ahb_agent];
			cfg.ahb_cfg = new[num_ahb_agent];
			cfg.ahb_rst_cfg = new[num_ahb_agent];
			foreach(ahb_cfg[i])
				begin
					ahb_cfg[i] = ahb_config::type_id::create($sformatf("ahb_cfg[%0d]",i),this);
					ahb_rst_cfg[i] = ahb_rst_config::type_id::create($sformatf("ahb_rst_cfg[%0d]",i),this);
					ahb_cfg[i].is_active = UVM_ACTIVE;
					ahb_rst_cfg[i].is_active = UVM_ACTIVE;
					if(!uvm_config_db #(virtual ahb_if)::get(this,"","ahb_vif",ahb_cfg[i].vif))
						`uvm_fatal("TEST","Get failed for ahb_if")
					if(!uvm_config_db #(virtual ahb_rst_if)::get(this,"","ahb_rst_vif",ahb_rst_cfg[i].vif))
						`uvm_fatal("TEST","Get failed for ahb_rst_if")
					cfg.ahb_cfg[i] = ahb_cfg[i];
					cfg.ahb_rst_cfg[i] = ahb_rst_cfg[i];
				end
		end

	if(has_axi_agent)
		begin
			axi_cfg = new[num_axi_agent];
			axi_rst_cfg = new[num_axi_agent];
			cfg.axi_cfg = new[num_axi_agent];
			cfg.axi_rst_cfg = new[num_axi_agent];
			foreach(axi_cfg[i])
				begin
					axi_cfg[i] = axi_config::type_id::create($sformatf("axi_cfg[%0d]",i),this);
					axi_rst_cfg[i] = axi_rst_config::type_id::create($sformatf("axi_rst_cfg[%0d]",i),this);
					axi_cfg[i].is_active = UVM_ACTIVE;
					axi_rst_cfg[i].is_active = UVM_ACTIVE;
					if(!uvm_config_db #(virtual axi_if)::get(this,"","axi_vif",axi_cfg[i].vif))
						`uvm_fatal("TEST","Get failed for axi_if")
					if(!uvm_config_db #(virtual axi_rst_if)::get(this,"","axi_rst_vif",axi_rst_cfg[i].vif))
						`uvm_fatal("TEST","Get failed for axi_rst_if")
					cfg.axi_cfg[i] = axi_cfg[i];
					cfg.axi_rst_cfg[i] = axi_rst_cfg[i];
				end
		end
	configure_env;
	uvm_config_db #(env_config)::set(this,"*","env_config",cfg);
	envh = env::type_id::create("envh",this);
endfunction : build_phase

function void base_test::configure_env;
	cfg.has_ahb_agent = has_ahb_agent;
	cfg.has_axi_agent = has_axi_agent;
	
	cfg.num_ahb_agent = num_ahb_agent;
	cfg.num_axi_agent = num_axi_agent;

	cfg.has_scoreboard = has_scoreboard;
endfunction : configure_env

function void base_test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction : end_of_elaboration_phase

class reset_test extends base_test;
	`uvm_component_utils(reset_test)

	function new(string name = "reset_test",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		ahb_rst_seq = ahb_reset_sequence::type_id::create("ahb_rst_seq");
		axi_rst_seq = axi_reset_sequence::type_id::create("axi_rst_seq");
		phase.raise_objection(this);
			for(int i = 0; i < num_axi_agent ; i++)
				axi_rst_seq.start(envh.axi_rst_agt_top.axi_rst_agt[i].seqr);
			for(int i = 0; i < num_ahb_agent ; i++)
				ahb_rst_seq.start(envh.ahb_rst_agt_top.ahb_rst_agt[i].seqr);
		#20;
		phase.drop_objection(this);
	endtask : run_phase
endclass : reset_test

class INCR_ok_test extends base_test;
	`uvm_component_utils(INCR_ok_test)

	function new(string name = "INCR_ok_test",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		ahb_rst_seq = ahb_reset_sequence::type_id::create("ahb_rst_seq");
		axi_rst_seq = axi_reset_sequence::type_id::create("axi_rst_seq");
		ahb_ok_seq = ahb_ok_sequence::type_id::create("ahb_ok_seq");
		axi_incr_wr_seq = axi_INCR_write_sequence::type_id::create("axi_incr_wr_seq");
		axi_incr_rd_seq = axi_INCR_read_sequence::type_id::create("axi_incr_rd_seq");
		phase.raise_objection(this);
			for(int i = 0; i < num_ahb_agent ; i++)
				ahb_rst_seq.start(envh.ahb_rst_agt_top.ahb_rst_agt[i].seqr);

			for(int i = 0; i < num_axi_agent ; i++)
				axi_rst_seq.start(envh.axi_rst_agt_top.axi_rst_agt[i].seqr);

			#20;

			for(int i = 0; i < num_axi_agent ; i++)
			begin
				axi_incr_wr_seq.start(envh.axi_agt_top.axi_agt[i].seqr);
				cfg.ahb_length.push_back(envh.axi_agt_top.axi_agt[i].drv.req.awlen);
			end
			uvm_config_db #(env_config)::set(this,"*","env_config",cfg);
			#300;
			for(int i = 0; i < num_ahb_agent ; i++)
				ahb_ok_seq.start(envh.ahb_agt_top.ahb_agt[i].seqr);

			#900;

			for(int i = 0; i < num_ahb_agent ; i++)
				ahb_rst_seq.start(envh.ahb_rst_agt_top.ahb_rst_agt[i].seqr);

			for(int i = 0; i < num_axi_agent ; i++)
				axi_rst_seq.start(envh.axi_rst_agt_top.axi_rst_agt[i].seqr);

			#20;

			for(int i = 0; i < num_axi_agent ; i++)
			begin
				axi_incr_rd_seq.start(envh.axi_agt_top.axi_agt[i].seqr);
				cfg.ahb_length.push_back(envh.axi_agt_top.axi_agt[i].drv.req.arlen);
			end
			uvm_config_db #(env_config)::set(this,"*","env_config",cfg);

			#300;
			for(int i = 0; i < num_ahb_agent ; i++)
				ahb_ok_seq.start(envh.ahb_agt_top.ahb_agt[i].seqr);

		#600;

		phase.drop_objection(this);
	endtask : run_phase
endclass : INCR_ok_test


class INCR_ok_wait_test extends base_test;
	`uvm_component_utils(INCR_ok_wait_test)

	function new(string name = "INCR_ok_wait_test",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		ahb_rst_seq = ahb_reset_sequence::type_id::create("ahb_rst_seq");
		axi_rst_seq = axi_reset_sequence::type_id::create("axi_rst_seq");
		ahb_ok_wait_seq = ahb_ok_wait_sequence::type_id::create("ahb_ok_wait_seq");
		axi_incr_wr_seq = axi_INCR_write_sequence::type_id::create("axi_incr_wr_seq");
		axi_incr_rd_seq = axi_INCR_read_sequence::type_id::create("axi_incr_rd_seq");
		phase.raise_objection(this);
			for(int i = 0; i < num_ahb_agent ; i++)
				ahb_rst_seq.start(envh.ahb_rst_agt_top.ahb_rst_agt[i].seqr);

			for(int i = 0; i < num_axi_agent ; i++)
				axi_rst_seq.start(envh.axi_rst_agt_top.axi_rst_agt[i].seqr);

			#20;

			for(int i = 0; i < num_axi_agent ; i++)
			begin
				axi_incr_wr_seq.start(envh.axi_agt_top.axi_agt[i].seqr);
				cfg.ahb_length.push_back(envh.axi_agt_top.axi_agt[i].drv.req.awlen);
			end
			uvm_config_db #(env_config)::set(this,"*","env_config",cfg);
			#300;
			for(int i = 0; i < num_ahb_agent ; i++)
				ahb_ok_wait_seq.start(envh.ahb_agt_top.ahb_agt[i].seqr);

			#300;

			for(int i = 0; i < num_ahb_agent ; i++)
				ahb_rst_seq.start(envh.ahb_rst_agt_top.ahb_rst_agt[i].seqr);

			for(int i = 0; i < num_axi_agent ; i++)
				axi_rst_seq.start(envh.axi_rst_agt_top.axi_rst_agt[i].seqr);

			#20;

			for(int i = 0; i < num_axi_agent ; i++)
			begin
				axi_incr_rd_seq.start(envh.axi_agt_top.axi_agt[i].seqr);
				cfg.ahb_length.push_back(2 * (envh.axi_agt_top.axi_agt[i].drv.req.arlen + 1));
			end
			uvm_config_db #(env_config)::set(this,"*","env_config",cfg);

			#300;
			for(int i = 0; i < num_ahb_agent ; i++)
				ahb_ok_wait_seq.start(envh.ahb_agt_top.ahb_agt[i].seqr);

		#300;

		phase.drop_objection(this);
	endtask : run_phase
endclass : INCR_ok_wait_test


