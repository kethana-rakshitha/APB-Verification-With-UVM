import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_test extends uvm_test;

    // =========================================================
    // ENVIRONMENT
    // =========================================================

    apb_env env;


    // =========================================================
    // UVM FACTORY REGISTRATION
    // =========================================================

    `uvm_component_utils(apb_test)


    // =========================================================
    // CONSTRUCTOR
    // =========================================================

    function new(
        string name = "apb_test",
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
        // Create environment
        // -----------------------------------------------------

        env = apb_env::type_id::create(
            "env",
            this
        );

    endfunction


    // =========================================================
    // RUN PHASE
    // =========================================================

    task run_phase(uvm_phase phase);

        apb_sequence seq;


        // -----------------------------------------------------
        // Raise objection
        // -----------------------------------------------------

        phase.raise_objection(this);


        `uvm_info(
            "APB_TEST",
            "Starting APB UVM test",
            UVM_MEDIUM
        );


        // -----------------------------------------------------
        // Create sequence
        // -----------------------------------------------------

        seq = apb_sequence::type_id::create(
            "seq"
        );


        // -----------------------------------------------------
        // Start sequence
        // -----------------------------------------------------

        seq.start(
            env.agent.sequencer
        );


        `uvm_info(
            "APB_TEST",
            "APB UVM sequence completed",
            UVM_MEDIUM
        );


        // -----------------------------------------------------
        // Allow final transactions to complete
        // -----------------------------------------------------

        #100;


        // -----------------------------------------------------
        // Drop objection
        // -----------------------------------------------------

        phase.drop_objection(this);

    endtask

endclass
