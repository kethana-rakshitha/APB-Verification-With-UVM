import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_env extends uvm_env;

    // =========================================================
    // UVM COMPONENTS
    // =========================================================

    apb_agent      agent;
    apb_scoreboard scoreboard;
    apb_coverage   coverage;


    // =========================================================
    // FACTORY REGISTRATION
    // =========================================================

    `uvm_component_utils(apb_env)


    // =========================================================
    // CONSTRUCTOR
    // =========================================================

    function new(
        string name = "apb_env",
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
        // Create APB agent
        // -----------------------------------------------------

        agent = apb_agent::type_id::create(
            "agent",
            this
        );


        // -----------------------------------------------------
        // Create scoreboard
        // -----------------------------------------------------

        scoreboard = apb_scoreboard::type_id::create(
            "scoreboard",
            this
        );


        // -----------------------------------------------------
        // Create coverage
        // -----------------------------------------------------

        coverage = apb_coverage::type_id::create(
            "coverage",
            this
        );

    endfunction


    // =========================================================
    // CONNECT PHASE
    // =========================================================

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);


        // -----------------------------------------------------
        // Monitor → Scoreboard
        // -----------------------------------------------------

        agent.monitor.ap.connect(
            scoreboard.analysis_export
        );


        // -----------------------------------------------------
        // Monitor → Coverage
        // -----------------------------------------------------

        agent.monitor.ap.connect(
            coverage.analysis_export
        );

    endfunction

endclass
