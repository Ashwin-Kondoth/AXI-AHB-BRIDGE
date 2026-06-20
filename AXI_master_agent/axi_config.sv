class axi_config extends uvm_object;

	`uvm_object_utils(axi_config)

	function new (string name = "axi_config");
		super.new(name);
	endfunction : new

	virtual axi_if          vif;
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;

endclass : axi_config
