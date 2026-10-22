import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_scoreboard extends uvm_scoreboard;

    // =========================================================
    // ANALYSIS IMPLEMENTATION
    // =========================================================

    uvm_analysis_imp #(apb_sequence_item, apb_scoreboard) analysis_export;


    // =========================================================
    // REFERENCE MODEL / EXPECTED MEMORY
    // =========================================================

    logic [7:0] expected_mem [0:3];


    // =========================================================
    // SCOREBOARD COUNTERS
    // =========================================================

    int total_transactions;
    int pass_count;
    int fail_count;


    // =========================================================
    // UVM FACTORY REGISTRATION
    // =========================================================

    `uvm_component_utils(apb_scoreboard)


    // =========================================================
    // CONSTRUCTOR
    // =========================================================

    function new(
        string name = "apb_scoreboard",
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
        // Create analysis implementation
        // -----------------------------------------------------

        analysis_export = new(
            "analysis_export",
            this
        );


        // -----------------------------------------------------
        // Initialize expected memory
        // -----------------------------------------------------

        foreach (expected_mem[i]) begin

            expected_mem[i] = 8'h00;

        end


        // -----------------------------------------------------
        // Initialize counters
        // -----------------------------------------------------

        total_transactions = 0;
        pass_count         = 0;
        fail_count         = 0;

    endfunction


    // =========================================================
    // WRITE METHOD
    // =========================================================
    //
    // The monitor calls this automatically through:
    //
    // monitor.ap.write(transaction)
    //
    // =========================================================

    function void write(apb_sequence_item trans);

        int index;
        logic [7:0] expected_data;


        // -----------------------------------------------------
        // Count transaction
        // -----------------------------------------------------

        total_transactions++;


        // -----------------------------------------------------
        // Convert APB address to memory index
        // -----------------------------------------------------

        index = trans.addr >> 2;


        // -----------------------------------------------------
        // Ignore invalid addresses
        // -----------------------------------------------------

        if (index < 0 || index > 3) begin

            `uvm_error(
                "APB_SCOREBOARD",
                $sformatf(
                    "Invalid address received: %0h",
                    trans.addr
                )
            );

            fail_count++;

            return;

        end


        // =====================================================
        // WRITE TRANSACTION
        // =====================================================

        if (trans.write) begin

            expected_mem[index] = trans.wdata;


            `uvm_info(
                "APB_SCOREBOARD",
                $sformatf(
                    "WRITE ADDR=%0h DATA=%0h",
                    trans.addr,
                    trans.wdata
                ),
                UVM_MEDIUM
            );

        end


        // =====================================================
        // READ TRANSACTION
        // =====================================================

        else begin

            expected_data = expected_mem[index];


            if (trans.rdata === expected_data) begin

                pass_count++;


                `uvm_info(
                    "APB_SCOREBOARD",
                    $sformatf(
                        "READ PASS: ADDR=%0h EXPECTED=%0h ACTUAL=%0h",
                        trans.addr,
                        expected_data,
                        trans.rdata
                    ),
                    UVM_MEDIUM
                );

            end

            else begin

                fail_count++;


                `uvm_error(
                    "APB_SCOREBOARD",
                    $sformatf(
                        "READ FAIL: ADDR=%0h EXPECTED=%0h ACTUAL=%0h",
                        trans.addr,
                        expected_data,
                        trans.rdata
                    )
                );

            end

        end

    endfunction


    // =========================================================
    // REPORT
    // =========================================================

    function void report_phase(uvm_phase phase);

        super.report_phase(phase);


        `uvm_info(
            "APB_SCOREBOARD",
            "========================================",
            UVM_NONE
        );

        `uvm_info(
            "APB_SCOREBOARD",
            "        APB SCOREBOARD SUMMARY",
            UVM_NONE
        );

        `uvm_info(
            "APB_SCOREBOARD",
            "========================================",
            UVM_NONE
        );

        `uvm_info(
            "APB_SCOREBOARD",
            $sformatf(
                "Transactions : %0d",
                total_transactions
            ),
            UVM_NONE
        );

        `uvm_info(
            "APB_SCOREBOARD",
            $sformatf(
                "PASS         : %0d",
                pass_count
            ),
            UVM_NONE
        );

        `uvm_info(
            "APB_SCOREBOARD",
            $sformatf(
                "FAIL         : %0d",
                fail_count
            ),
            UVM_NONE
        );

        `uvm_info(
            "APB_SCOREBOARD",
            "========================================",
            UVM_NONE
        );

    endfunction

endclass
