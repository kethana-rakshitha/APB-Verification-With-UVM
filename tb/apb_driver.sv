import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_driver extends uvm_driver #(apb_sequence_item);

    // =========================================================
    // VIRTUAL INTERFACE
    // =========================================================

    virtual apb_if vif;


    // =========================================================
    // UVM FACTORY REGISTRATION
    // =========================================================

    `uvm_component_utils(apb_driver)


    // =========================================================
    // CONSTRUCTOR
    // =========================================================

    function new(
        string name = "apb_driver",
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
        // Get virtual interface
        // -----------------------------------------------------

        if (!uvm_config_db#(virtual apb_if)::get(
                this,
                "",
                "vif",
                vif
            )) begin

            `uvm_fatal(
                "APB_DRIVER",
                "Virtual interface not found"
            );

        end

    endfunction


    // =========================================================
    // RUN PHASE
    // =========================================================

    task run_phase(uvm_phase phase);

        apb_sequence_item req;


        forever begin

            // -------------------------------------------------
            // Get transaction from sequencer
            // -------------------------------------------------

            seq_item_port.get_next_item(req);


            // -------------------------------------------------
            // Drive APB transaction
            // -------------------------------------------------

            drive_transfer(req);


            // -------------------------------------------------
            // Tell sequencer transaction is complete
            // -------------------------------------------------

            seq_item_port.item_done();

        end

    endtask


    // =========================================================
    // DRIVE APB TRANSFER
    // =========================================================

    task drive_transfer(apb_sequence_item req);

        // -----------------------------------------------------
        // SETUP PHASE
        // -----------------------------------------------------

        @(posedge vif.PCLK);

        vif.PSEL    <= 1'b1;
        vif.PENABLE <= 1'b0;
        vif.PWRITE  <= req.write;
        vif.PADDR   <= req.addr;
        vif.PWDATA  <= req.wdata;


        // -----------------------------------------------------
        // ACCESS PHASE
        // -----------------------------------------------------

        @(posedge vif.PCLK);

        vif.PENABLE <= 1'b1;


        // -----------------------------------------------------
        // Wait for slave
        // -----------------------------------------------------

        wait (vif.PREADY == 1'b1);


        // -----------------------------------------------------
        // Capture READ DATA
        // -----------------------------------------------------

        if (!req.write) begin

            req.rdata = vif.PRDATA;

        end


        // -----------------------------------------------------
        // Return to IDLE
        // -----------------------------------------------------

        @(posedge vif.PCLK);

        vif.PSEL    <= 1'b0;
        vif.PENABLE <= 1'b0;

    endtask

endclass
