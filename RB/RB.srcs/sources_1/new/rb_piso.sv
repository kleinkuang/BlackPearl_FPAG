// File:    rb_piso.sv
// Author:  Lei Kuang
// Date:    20th August 2020
// @ Imperial College London

// Ring Buffer with PISO for FT601Q

module rb_piso
(
    // ----------------------------------------------------------------
    // System Port
    input  logic            sys_nrst,
    output logic            sys_ready,
    output logic            sys_error,
    output logic            sys_full,
    // ----------------------------------------------------------------
    // DDR Port
    input  logic            ddr4_clk,
    output logic            ddr4_rst,
    input  logic            ddr4_ready,
    // ----------------------------------------------------------------
    // FIFO In Port
    input  logic            in_fifo_clk,
    input  logic [31:0]     in_fifo_data,
    input  logic            in_fifo_data_valid,
    output logic            in_fifo_full,
    // ----------------------------------------------------------------
    // FIFO Out Port
    input  logic            wr_clk,
    output logic            wr_en,
    output logic [31:0]     wr_data,
    input  logic            wr_full,
    // ----------------------------------------------------------------
    // DDR4 AXI Bus
                                            // Write Address Port       --------------------------------------------------------------------------------------------------------------------------------
    output logic [30:0]    m_axi_awaddr,    // Write address.           The write address gives the address of the first transfer in a write burst transaction.
    output logic [1:0]     m_axi_awburst,   // Burst type.              The burst type and the size information, determine how the address for each transfer within the burst is calculated.
    output logic [3:0]     m_axi_awcache,   // Cache type.              X
    output logic [3:0]     m_axi_awid,      // Write address ID.        The write address gives the address of the first transfer in a write burst transaction.
    output logic [7:0]     m_axi_awlen,     // Burst length.            This information determines the number of data transfers associated with the address.
    output logic [0:0]     m_axi_awlock,    // Lock type.               This is not used in the current implementation.
    output logic [2:0]     m_axi_awprot,    // Protection type.         X
    output logic [3:0]     m_axi_awqos,     // Quality of Service.      X
    input  logic           m_axi_awready,   // Write address ready.     This signal indicates that the slave is ready to accept an address and associated control signals.
    output logic [2:0]     m_axi_awsize,    // Burst size.              This signal indicates the size of each transfer in the burst.
    output logic           m_axi_awvalid,   // Write address valid.     This signal indicates that valid write address and control information are available.
                                            // Write Data Port          --------------------------------------------------------------------------------------------------------------------------------
    output logic [511:0]   m_axi_wdata,     // Write data.              
    output logic           m_axi_wlast,     // Write last.              This signal indicates the last transfer in a write burst.
    input  logic           m_axi_wready,    // Write ready.             This signal indicates that the slave can accept the write data.
    output logic [63:0]    m_axi_wstrb,     // Write strobes.           This signal indicates which byte lanes hold valid data.
    output logic           m_axi_wvalid,    // Write valid.             This signal indicates that write data and strobe are available.
                                            // Write Response Port      --------------------------------------------------------------------------------------------------------------------------------
    input  logic [3:0]     m_axi_bid,       // Write response ID.       X
    output logic           m_axi_bready,    // Write response ready.    This signal indicates that the master can accept a write response.
    input  logic [1:0]     m_axi_bresp,     // Write response.          This signal indicates the status of the write response.
    input  logic           m_axi_bvalid,    // Write response valid.    This signal indicates that the channel is signaling a valid write response.
                                            // Read Address Port        --------------------------------------------------------------------------------------------------------------------------------
    output logic [30:0]    m_axi_araddr,    // Read address.            The read address gives the address of the first transfer in a read burst transaction.
    output logic [1:0]     m_axi_arburst,   // Burst type.              The burst type and the size information determine how the address for each transfer within the burst is calculated.
    output logic [3:0]     m_axi_arcache,   // Cache type.              X
    output logic [3:0]     m_axi_arid,      // Read address ID.         The read address gives the address of the first transfer in a read burst transaction.
    output logic [7:0]     m_axi_arlen,     // Burst length.            This signal indicates the exact number of transfers in a burst.
    output logic [0:0]     m_axi_arlock,    // Lock type.               X
    output logic [2:0]     m_axi_arprot,    // Protection type.         X
    output logic [3:0]     m_axi_arqos,     // Quality of Service.      X
    input  logic           m_axi_arready,   // Read address ready.      This signal indicates that the slave is ready to accept an address and associated control signals.
    output logic [2:0]     m_axi_arsize,    // Burst size.              This signal indicates the size of each transfer in the burst.
    output logic           m_axi_arvalid,   // Read address valid.      This signal indicates that the channel is signaling valid read address and control information.
                                            // Read Data Port           --------------------------------------------------------------------------------------------------------------------------------
    input  logic [511:0]   m_axi_rdata,     // Read data.   
    input  logic [3:0]     m_axi_rid,       // Read data ID.            X
    input  logic           m_axi_rlast,     // Read last.               This signal indicates the last transfer in a read burst.
    output logic           m_axi_rready,    // Read ready.              This signal indicates that the master can accept the read data and response information.
    input  logic [1:0]     m_axi_rresp,     // Read response.           This signal indicates the status of the read transfer.
    input  logic           m_axi_rvalid     // Read valid.              This signal indicates that the channel is signaling the required read data.
);

logic         rd_clk;
logic         rd_empty;
logic         rd_en;
logic [511:0] rd_data;

piso p0
(
    .nrst       (sys_nrst),
    // Read
    .rd_clk     (rd_clk),
    .rd_empty   (rd_empty),
    .rd_en      (rd_en),
    .rd_data    (rd_data),
    // Write
    .wr_clk     (wr_clk),
    .wr_en      (wr_en),
    .wr_data    (wr_data),
    .wr_full    (wr_full)
);

rb r0
(
    // ----------------------------------------------------------------
    // System Port
    .sys_nrst               (sys_nrst),
    .sys_ready              (sys_ready),
    .sys_error              (sys_error),
    .sys_full               (sys_full),
    // ----------------------------------------------------------------
    // DDR Port
    .ddr4_clk               (ddr4_clk),
    .ddr4_rst               (ddr4_rst),
    .ddr4_ready             (ddr4_ready),
    // ----------------------------------------------------------------
    // FIFO In Port
    .in_fifo_clk            (in_fifo_clk),
    .in_fifo_data           (in_fifo_data),
    .in_fifo_data_valid     (in_fifo_data_valid),
    .in_fifo_full           (in_fifo_full),
    // ----------------------------------------------------------------
    // FIFO Out Port
    .out_fifo_clk           (rd_clk),
    .out_fifo_rd_en         (rd_en),
    .out_fifo_data          (rd_data),
    .out_fifo_data_valid    (),
    .out_fifo_empty         (rd_empty),
    // ----------------------------------------------------------------
    // DDR4 AXI Bus
    .m_axi_awaddr           (m_axi_awaddr),
    .m_axi_awburst          (m_axi_awburst),
    .m_axi_awcache          (m_axi_awcache),
    .m_axi_awid             (m_axi_awid),
    .m_axi_awlen            (m_axi_awlen),
    .m_axi_awlock           (m_axi_awlock),
    .m_axi_awprot           (m_axi_awprot),
    .m_axi_awqos            (m_axi_awqos),
    .m_axi_awready          (m_axi_awready),
    .m_axi_awsize           (m_axi_awsize),
    .m_axi_awvalid          (m_axi_awvalid),

    .m_axi_wdata            (m_axi_wdata),           
    .m_axi_wlast            (m_axi_wlast),
    .m_axi_wready           (m_axi_wready),
    .m_axi_wstrb            (m_axi_wstrb),
    .m_axi_wvalid           (m_axi_wvalid),

    .m_axi_bid              (m_axi_bid),
    .m_axi_bready           (m_axi_bready),
    .m_axi_bresp            (m_axi_bresp),
    .m_axi_bvalid           (m_axi_bvalid),

    .m_axi_araddr           (m_axi_araddr),
    .m_axi_arburst          (m_axi_arburst),
    .m_axi_arcache          (m_axi_arcache),
    .m_axi_arid             (m_axi_arid),
    .m_axi_arlen            (m_axi_arlen),
    .m_axi_arlock           (m_axi_arlock),
    .m_axi_arprot           (m_axi_arprot),
    .m_axi_arqos            (m_axi_arqos),
    .m_axi_arready          (m_axi_arready),
    .m_axi_arsize           (m_axi_arsize),
    .m_axi_arvalid          (m_axi_arvalid),

    .m_axi_rdata            (m_axi_rdata),
    .m_axi_rid              (m_axi_rid),
    .m_axi_rlast            (m_axi_rlast),
    .m_axi_rready           (m_axi_rready),
    .m_axi_rresp            (m_axi_rresp),
    .m_axi_rvalid           (m_axi_rvalid)
);

endmodule
