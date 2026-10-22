import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_agent extends uvm_agent;

    // =========================================================
    // UVM COMPONENTS
    // =========================================================

    apb_sequencer sequencer;
    apb_driver    driver;
    apb_monitor   monitor;


    // =========================================================
    // UVM FACTORY REGISTRATION
    // =========================================================

    `uvm_component_utils(apb_agent)


    // =========================================================
    // CONSTRUCTOR
    // =========================================================

    function new(
        string name = "apb_agent",
        uvm_component parent = null
    );

        super.new(name, parent);

    endfunction


    // =========================================================
    // BUILD PHASE
    // =========================================================

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);


        // -----------------------------------------------------
        // Monitor is always created
        // -----------------------------------------------------

        monitor = apb_monitor::type_id::create(
            "monitor",
            this
        );


        // -----------------------------------------------------
        // Create driver and sequencer only for ACTIVE agent
        // -----------------------------------------------------

        if (is_active == UVM_ACTIVE) begin

            sequencer = apb_sequencer::type_id::create(
                "sequencer",
                this
            );

            driver = apb_driver::type_id::create(
                "driver",
                this
            );

        end

    endfunction


    // =========================================================
    // CONNECT PHASE
    // =========================================================

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);


        // -----------------------------------------------------
        // Connect sequencer → driver
        // -----------------------------------------------------

        if (is_active == UVM_ACTIVE) begin

            driver.seq_item_port.connect(
                sequencer.seq_item_export
            );

        end

    endfunction

endclass
