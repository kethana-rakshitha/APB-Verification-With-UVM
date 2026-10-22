interface apb_if #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8
);

    logic PCLK;
    logic PRESETn;

    logic PSEL;
    logic PENABLE;
    logic PWRITE;

    logic [ADDR_WIDTH-1:0] PADDR;
    logic [DATA_WIDTH-1:0] PWDATA;
    logic [DATA_WIDTH-1:0] PRDATA;

    logic PREADY;
    logic PSLVERR;

endinterface
