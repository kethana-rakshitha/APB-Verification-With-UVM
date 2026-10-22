import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_sequence extends uvm_sequence #(apb_sequence_item);

    // =========================================================
    // NUMBER OF TRANSACTIONS
    // =========================================================

    int num_transactions = 100;


    // =========================================================
    // UVM FACTORY REGISTRATION
    // =========================================================

    `uvm_object_utils(apb_sequence)


    // =========================================================
    // CONSTRUCTOR
    // =========================================================

    function new(string name = "apb_sequence");

        super.new(name);

    endfunction


    // =========================================================
    // BODY
    // =========================================================

    task body();

        apb_sequence_item req;


        repeat (num_transactions) begin

            // -------------------------------------------------
            // Create transaction
            // -------------------------------------------------

            req = apb_sequence_item::type_id::create(
                "req"
            );


            // -------------------------------------------------
            // Start item
            // -------------------------------------------------

            start_item(req);


            // -------------------------------------------------
            // Randomize transaction
            // -------------------------------------------------

            if (!req.randomize()) begin

                `uvm_fatal(
                    "APB_SEQ",
                    "APB transaction randomization failed"
                );

            end


            // -------------------------------------------------
            // Finish item
            // -------------------------------------------------

            finish_item(req);

        end

    endtask

endclass
