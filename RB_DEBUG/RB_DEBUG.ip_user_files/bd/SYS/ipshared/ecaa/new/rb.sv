// File:    rb.sv
// Author:  Lei Kuang
// Date:    11th August 2020
// @ Imperial College London

// Ring Buffer Interface for VCU118 DDR4

module rb
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
    input  logic            out_fifo_clk,
    input  logic            out_fifo_rd_en,
    output logic [511:0]    out_fifo_data,
    output logic            out_fifo_data_valid,
    output logic            out_fifo_empty,
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

assign ddr4_rst = ~sys_nrst;

// ----------------------------------------------------------------
// AXI Bus Configuration
// ----------------------------------------------------------------
                                // Read Address Port        --------------------------------------------------------------------------------------------------------------------------------
assign m_axi_arcache = '0;      // Cache type.
assign m_axi_arid    = '0;      // Read address ID.
assign m_axi_arlock  = '0;      // Lock type.
assign m_axi_arprot  = '0;      // Protection type.
assign m_axi_arqos   = '0;      // Quality of Service.      
                                // Write Address Port       --------------------------------------------------------------------------------------------------------------------------------
assign m_axi_awcache = '0;      // Cache type.
assign m_axi_awid    = '0;      // Write address ID.
assign m_axi_awlock  = '0;      // Lock type.               This is not used in the current implementation.
assign m_axi_awprot  = '0;      // Protection type.
assign m_axi_awqos   = '0;      // Quality of Service.
                                // Write Response Port      --------------------------------------------------------------------------------------------------------------------------------
assign m_axi_bready  = '1;      // Write response ready.
                                // Read Data Port           --------------------------------------------------------------------------------------------------------------------------------
assign m_axi_rready  = '1;      // Read ready.
                                // Write Data Port          --------------------------------------------------------------------------------------------------------------------------------
assign m_axi_wstrb   = '1;      // Write strobes.           This signal indicates which byte lanes hold valid data.

// Burst configuration
// - Write
assign m_axi_awlen   = 8'd0;    // Burst length. 1          The burst length gives the exact number of transfers in a burst.
assign m_axi_awburst = 2'b00;   // Fixed                    In a fixed burst, the address is the same for every transfer in the burst.
assign m_axi_awsize  = 3'b110;  // 2^6 = 64B (512b)

// - Read         
assign m_axi_arlen   = 8'd15;   // Burst length. 16         The burst length gives the exact number of transfers in a burst.
assign m_axi_arburst = 2'b01;   // Incrementing.            In an incrementing burst, the address for each transfer in the burst is an increment of the address for the previous transfer.
                                //                          The increment value depends on the size of the transfer. For example, the address for each transfer in a burst with a size of 
                                //                          four bytes is the previous address plus four.
                                //                          This burst type is used for accesses to normal sequential memory.
assign m_axi_arsize  = 3'b110;  // 2^6 = 64B (512b)

// ----------------------------------------------------------------
// AXI Response
// ----------------------------------------------------------------      
// Write response
logic ddr4_wr_error;

always_ff @ (posedge ddr4_clk, negedge sys_nrst)
    if(~sys_nrst)
        ddr4_wr_error <= '0;
    else
        if(~ddr4_wr_error)
            if(m_axi_bvalid & ddr4_ready)
                if(m_axi_bresp!='0)
                    ddr4_wr_error <= '1;

// Read response
logic ddr4_rd_error;

always_ff @ (posedge ddr4_clk, negedge sys_nrst)
    if(~sys_nrst)
        ddr4_rd_error <= '0;
    else
        if(~ddr4_rd_error)
            if(m_axi_rvalid & ddr4_ready)
                if(m_axi_rresp!='0)
                    ddr4_rd_error <= '1;
                    
assign sys_error = ddr4_rd_error | ddr4_wr_error;

// ----------------------------------------------------------------
// Data Stream In
// ----------------------------------------------------------------
// FIFO
logic        in_fifo_rd_en;
logic [31:0] in_fifo_rd_dout;
logic        in_fifo_rd_valid;
logic        in_fifo_prog_empty;

afifo_32bx32 in_fifo
(
    .rst        (~sys_nrst),
    .wr_clk     (in_fifo_clk),
    .wr_en      (in_fifo_data_valid),
    .din        (in_fifo_data),
    .full       (in_fifo_full),
    
    .rd_clk     (ddr4_clk),
    .rd_en      (in_fifo_rd_en),
    .dout       (in_fifo_rd_dout),
    .empty      (),
    .prog_empty  (in_fifo_prog_empty)
);

always_ff @ (posedge ddr4_clk, negedge sys_nrst)
    if(~sys_nrst)
        in_fifo_rd_valid <= '0;
    else
        in_fifo_rd_valid <= in_fifo_rd_en;
        
// Write Controller
enum {W_Init, W_Wait, W_RD, W_ADDR, W_DATA} w_state;

// - Burst len:  1
// - Burst size: 64B
// - Beat:       64B * 1 = 64B
// - Index:      64B * 2^25 / 1024 / 1024 /1024 = 2GB

logic [3:0]   w_rd_cnt;     // Read  16x4B  (64B)

logic [24:0]  w_wr_index;
logic [511:0] w_wr_data;
logic [20:0]  w_1k_index;
logic [31:0]  w_1k_cnt;

assign in_fifo_rd_en   = w_state==W_RD;

assign m_axi_awaddr  = {w_wr_index, 6'b0};
assign m_axi_awvalid = (w_state==W_ADDR) & m_axi_awready;
assign m_axi_wvalid  = (w_state==W_DATA) & m_axi_wready;
assign m_axi_wlast   = m_axi_wvalid;
assign m_axi_wdata   = w_wr_data;

always_ff @ (posedge ddr4_clk, negedge sys_nrst)
    if(~sys_nrst) begin
        w_state   <= W_Init;
        w_wr_index <= '0;
        w_1k_index <= '0;
        w_1k_cnt   <= '0;
    end
    else
        case(w_state)
            W_Init: if(sys_ready)
                        w_state <= W_Wait;
            W_Wait: if(~in_fifo_prog_empty)
                        w_state <= W_RD;
            W_RD:   if(w_rd_cnt==4'd15)
                        w_state <= W_ADDR;
            W_ADDR: if(m_axi_awvalid)
                        w_state <= W_DATA;
            W_DATA: if(m_axi_wvalid) begin
                        w_state   <= W_Wait;
                        w_wr_index <= w_wr_index + 25'd1;
                        // 16x64B = 1KB
                        if(w_wr_index[3:0]=='1) begin
                            w_1k_index <= w_1k_index + 21'd1;
                            w_1k_cnt   <= w_1k_cnt   + 32'd1;
                        end
                    end
        endcase

always_ff @ (posedge ddr4_clk, negedge sys_nrst)
    if(~sys_nrst)
        w_rd_cnt <= '0;
    else
        if(in_fifo_rd_en)
            w_rd_cnt <= w_rd_cnt + 4'd1;
        
// SIPO
always_ff @ (posedge ddr4_clk, negedge sys_nrst)
    if(~sys_nrst)
        w_wr_data <= '0;
    else
        if(in_fifo_rd_valid)
            w_wr_data <= {in_fifo_rd_dout, w_wr_data[511:32]};
            
// Debug
logic [7:0] w_data_debug;
logic       w_data_error;

always_ff @ (posedge ddr4_clk, negedge sys_nrst)
    if(~sys_nrst) begin
        w_data_debug <= '0;
        w_data_error <= '0;
    end
    else
        if(m_axi_wvalid) begin
            w_data_debug <= w_data_debug + 8'd64;
            if(~w_data_error)
                w_data_error <= w_wr_data[7:0]!= w_data_debug;
        end

// ----------------------------------------------------------------
// Read Data from DDR4 through 1K burst
// ----------------------------------------------------------------
logic        out_fifo_prog_full;

afifo_512bx32 out_fifo
(
    .rst        (~sys_nrst),
    .wr_clk     (ddr4_clk),
    .wr_en      (m_axi_rvalid),
    .din        (m_axi_rdata),
    .full       (out_fifo_full),

    .rd_clk     (out_fifo_clk),
    .rd_en      (out_fifo_rd_en & ~out_fifo_empty),
    .dout       (out_fifo_data),
    .empty      (out_fifo_empty),
    .prog_full  (out_fifo_prog_full)
);

// Burst len:  16
// Burst size: 64B
// Beat:       64B * 16 / 1024 = 1KB
// 1K index:   1KB * 2^21 / 1024 / 1024 = 2GB

logic [20:0] r_1k_index;
logic [31:0] r_1k_cnt;         // Number of 4K beats that have been read
logic        r_1k_avail;

enum {R_ADDR, R_DATA} r_state;

// Read address
assign r_1k_avail    = r_1k_index != w_1k_index;    // r_1k_index is always smaller or equal than w_1k_index
                                                    // -> r_1k_index catches up with w_1k_index
assign m_axi_araddr  = {r_1k_index, 10'b0};
assign m_axi_arvalid = (r_state==R_ADDR) & r_1k_avail & ~out_fifo_prog_full & m_axi_arready;

// FSM
always_ff @ (posedge ddr4_clk, negedge sys_nrst)
    if(~sys_nrst) begin
        r_state    <= R_ADDR;
        r_1k_index <= '0;
        r_1k_cnt   <= '0;
    end
    else
        case(r_state)
            R_ADDR: if(m_axi_arvalid)
                        r_state    <= R_DATA;
            R_DATA: if(m_axi_rlast) begin
                        r_state    <= R_ADDR;
                        r_1k_index <= r_1k_index + 19'd1;
                        r_1k_cnt   <= r_1k_cnt + 32'd1;
                    end
        endcase
        
// Read data valid
always_ff @ (posedge out_fifo_clk, negedge sys_nrst)
    if(~sys_nrst)
        out_fifo_data_valid <= '0;
    else
        out_fifo_data_valid <= out_fifo_rd_en & ~out_fifo_empty;
        
// Debug
logic [7:0] r_data_debug;
logic       r_data_error;

always_ff @ (posedge ddr4_clk, negedge sys_nrst)
    if(~sys_nrst) begin
        r_data_debug <= '0;
        r_data_error <= '0;
    end
    else
        if(m_axi_rvalid) begin
            r_data_debug <= r_data_debug + 8'd64;
            if(~r_data_error)
                r_data_error <= m_axi_rdata[7:0]!= r_data_debug;
        end

// ----------------------------------------------------------------
// System Ready and Error
// ----------------------------------------------------------------
enum {S_RST, S_RDY} sys_state;

always_ff @ (posedge ddr4_clk, negedge sys_nrst)
    if(~sys_nrst)
        sys_state <= S_RST;
    else
        case (sys_state)
            S_RST:  if(ddr4_ready & ~out_fifo_full)
                        sys_state <= S_RDY;
            S_RDY:  sys_state <= S_RDY;
        endcase

assign sys_ready = sys_state==S_RDY;
assign sys_error = ddr4_rd_error | ddr4_wr_error;

// DDR4 Full
always_ff @ (posedge ddr4_clk, negedge sys_nrst)                    
    if(~sys_nrst)
        sys_full <= '0;
    else
        if(~sys_full)
            if(m_axi_awvalid)
                sys_full <= (w_1k_cnt != r_1k_cnt) & ~r_1k_avail;

// ----------------------------------------------------------------
// ILA
// ----------------------------------------------------------------
ila_rb i0
(
    .clk     (ddr4_clk),

    .probe0  (in_fifo_prog_empty),  // In FIFO Read
    .probe1  (w_rd_cnt[3:0]),
    .probe2  (in_fifo_rd_en),
    .probe3  (in_fifo_rd_valid),
    .probe4  (m_axi_wdata[511:0]),
    
    .probe5  (w_wr_index[24:0]),    // Write Index
    .probe6  (w_1k_index[20:0]),
    .probe7  (w_1k_cnt[31:0]),
    
    .probe8  (m_axi_awvalid),
    .probe9  (m_axi_awready),
    .probe10 (m_axi_wvalid),
    .probe11 (m_axi_wlast),
    
    .probe12 (r_1k_avail),             
    .probe13 (out_fifo_prog_full),

    .probe14 (r_1k_index[20:0]),
    .probe15 (r_1k_cnt[31:0]),

    .probe16 (m_axi_arready),
    .probe17 (m_axi_arvalid),
    .probe18 (m_axi_rvalid),
    .probe19 (m_axi_rdata[511:0]),
    .probe20 (m_axi_rlast),
    
    .probe21 (w_data_debug[7:0]),
    .probe22 (w_data_error),
    
    .probe23 (r_data_debug[7:0]),
    .probe24 (r_data_error)
);

endmodule
