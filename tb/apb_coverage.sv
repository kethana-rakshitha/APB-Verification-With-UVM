import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_coverage extends uvm_subscriber #(apb_sequence_item);

    // =========================================================
    // COVERAGE VARIABLES
    // =========================================================

    bit         write_cov;
    logic [7:0] addr;


    // =========================================================
    // COVERGROUP
    // =========================================================

    covergroup apb_cg;

        // -----------------------------------------------------
        // WRITE / READ COVERAGE
        // -----------------------------------------------------

        cp_write: coverpoint write_cov {

            bins READ  = {0};
            bins WRITE = {1};

        }


        // -----------------------------------------------------
        // ADDRESS COVERAGE
        // -----------------------------------------------------

        cp_addr: coverpoint addr {

            bins ADDR_0 = {8'h00};
            bins ADDR_4 = {8'h04};
            bins ADDR_8 = {8'h08};
            bins ADDR_C = {8'h0C};

        }


        // -----------------------------------------------------
        // READ/WRITE × ADDRESS CROSS
        // -----------------------------------------------------

        write_addr_cross:
            cross cp_write, cp_addr;

    endgroup


    // =========================================================
    // UVM FACTORY REGISTRATION
    // =========================================================

    `uvm_component_utils(apb_coverage)


    // =========================================================
    // CONSTRUCTOR
    // =========================================================

    function new(
        string name = "apb_coverage",
        uvm_component parent = null
    );

        super.new(name, parent);

        apb_cg = new();

    endfunction


    // =========================================================
    // WRITE METHOD
    // =========================================================

    function void write(apb_sequence_item t);

        write_cov = t.write;
        addr      = t.addr;

        apb_cg.sample();

    endfunction


    // =========================================================
    // REPORT PHASE
    // =========================================================

    function void report_phase(uvm_phase phase);

        super.report_phase(phase);

        `uvm_info(
            "APB_COVERAGE",
            $sformatf(
                "APB FUNCTIONAL COVERAGE = %0.2f%%",
                apb_cg.get_coverage()
            ),
            UVM_NONE
        );

    endfunction

endclass
