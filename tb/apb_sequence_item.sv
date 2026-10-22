import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_sequence_item extends uvm_sequence_item;

    // =========================================================
    // APB TRANSACTION FIELDS
    // =========================================================

    rand bit        write;
    rand logic [7:0] addr;
    rand logic [7:0] wdata;

    logic [7:0] rdata;

    bit valid;


    // =========================================================
    // ADDRESS CONSTRAINT
    // =========================================================

    constraint valid_addr {

        addr inside {
            8'h00,
            8'h04,
            8'h08,
            8'h0C
        };

    }


    // =========================================================
    // UVM FACTORY REGISTRATION
    // =========================================================

    `uvm_object_utils(apb_sequence_item)


    // =========================================================
    // CONSTRUCTOR
    // =========================================================

    function new(string name = "apb_sequence_item");

        super.new(name);

    endfunction


    // =========================================================
    // PRINT TRANSACTION
    // =========================================================

    function void do_print(uvm_printer printer);

        super.do_print(printer);

        printer.print_field(
            "write",
            write,
            1,
            UVM_BIN
        );

        printer.print_field(
            "addr",
            addr,
            8,
            UVM_HEX
        );

        printer.print_field(
            "wdata",
            wdata,
            8,
            UVM_HEX
        );

        printer.print_field(
            "rdata",
            rdata,
            8,
            UVM_HEX
        );

        printer.print_field(
            "valid",
            valid,
            1,
            UVM_BIN
        );

    endfunction

endclass
