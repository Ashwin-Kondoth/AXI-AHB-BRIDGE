class ahb_config extends uvm_object;

	`uvm_object_utils(ahb_config)

	function new (string name = "ahb_config");
		super.new(name);
	endfunction : new

	virtual ahb_if          vif;
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;

endclass : ahb_config


class ahb_rst_config extends uvm_object;

	`uvm_object_utils(ahb_rst_config)

	function new (string name = "ahb_rst_config");
		super.new(name);
	endfunction : new

	virtual ahb_rst_if          vif;
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;

endclass : ahb_rst_config
