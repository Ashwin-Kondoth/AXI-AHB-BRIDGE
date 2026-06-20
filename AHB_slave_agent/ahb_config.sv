class ahb_config extends uvm_object;

	`uvm_object_utils(ahb_config)

	function new (string name = "ahb_config");
		super.new(name);
	endfunction : new

	virtual ahb_if          vif;
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;

endclass : ahb_config
