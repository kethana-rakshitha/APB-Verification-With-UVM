import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_monitor extends uvm_monitor;

    // =========================================================
    // VIRTUAL INTERFACE
    // =========================================================

    virtual apb_if vif;


    // =========================================================
    // ANALYSIS PORT
    // =========================================================

    uvm_analysis_port #(apb_sequence_item) ap;


    // =========================================================
    // UVM FACTORY REGISTRATION
    // =========================================================

    `uvm_component_utils(apb_monitor)


    // =========================================================
    // CONSTRUCTOR
    // =========================================================

    function new(
        string name = "apb_monitor",
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
        // Create analysis port
        // -----------------------------------------------------

        ap = new(
            "ap",
            this
        );


        // -----------------------------------------------------
        // Get virtual interface
        // -----------------------------------------------------

        if (!uvm_config_db#(virtual apb_if)::get(
                this,
                "",
                "vif",
                vif
            )) begin

            `uvm_fatal(
                "APB_MONITOR",
                "Virtual interface not found"
            );

        end

    endfunction


    // =========================================================
    // RUN PHASE
    // =========================================================

    task run_phase(uvm_phase phase);

        forever begin

            @(posedge vif.PCLK);


            // -------------------------------------------------
            // Detect ACCESS phase
            // -------------------------------------------------

            if (vif.PSEL &&
                vif.PENABLE &&
                vif.PREADY) begin

                apb_sequence_item trans;


                // -------------------------------------------------
                // Create transaction
                // -------------------------------------------------

                trans = apb_sequence_item::type_id::create(
                    "trans"
                );


                // -------------------------------------------------
                // Capture common signals
                // -------------------------------------------------

                trans.write = vif.PWRITE;
                trans.addr  = vif.PADDR;


                // -------------------------------------------------
                // Capture WRITE data
                // -------------------------------------------------

                if (vif.PWRITE) begin

                    trans.wdata = vif.PWDATA;

                end


                // -------------------------------------------------
                // Capture READ data
                // -------------------------------------------------

                else begin

                    trans.rdata = vif.PRDATA;

                end


                // -------------------------------------------------
                // Capture APB error
                // -------------------------------------------------

                trans.valid = !vif.PSLVERR;


                // -------------------------------------------------
                // Send transaction to scoreboard
                // -------------------------------------------------

                ap.write(trans);


                // -------------------------------------------------
                // Display transaction
                // -------------------------------------------------

                if (trans.write) begin

                    `uvm_info(
                        "APB_MONITOR",
                        $sformatf(
                            "WRITE ADDR=%0h DATA=%0h VALID=%0b",
                            trans.addr,
                            trans.wdata,
                            trans.valid
                        ),
                        UVM_MEDIUM
                    );

                end

                else begin

                    `uvm_info(
                        "APB_MONITOR",
                        $sformatf(
                            "READ ADDR=%0h DATA=%0h VALID=%0b",
                            trans.addr,
                            trans.rdata,
                            trans.valid
                        ),
                        UVM_MEDIUM
                    );

                end

            end

        end

    endtask

endclass
