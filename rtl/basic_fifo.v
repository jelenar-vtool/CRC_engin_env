// -----------------------------------------------------------------------------
// KEYWORDS : Parametric FIFO
// -----------------------------------------------------------------------------
// PURPOSE : Generic FIFO with parametric width and depth (number
//           of stages). Output is a combinational mux of all stages.
//
////////////////////////////////////////////////////////////////////////////////
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME     RANGE    : DESCRIPTION           : DEFAULT        :  VA UNITS
// -----------------------------------------------------------------------------
// PAR_FIFO_DW     >=1     : Width of the data bus : 8             :  NA
// PAR_FIFO_DEPTH  >=1     : Depth of the FIFO     : 8             :  NA
// -----------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

module basic_fifo #(parameter PAR_FIFO_DW    = 8,  // FIFO Width 
                             PAR_FIFO_DEPTH = 8,  // FIFO depth
                             PNT_WIDTH = Clog2(PAR_FIFO_DEPTH)+1)  // Temp

(
// Inputs and outputs signals
// ============================================================================
// Clock and reset
// ============================================================================
input                        i_par_fifo_clk,          // Clock
input                        i_par_fifo_reset_b,      // General Async. Reset
input                        i_par_fifo_clr,          // Clear command

// ============================================================================
// Source Interface
// ============================================================================
input                        i_par_fifo_spush,        // source push command
input  [PAR_FIFO_DW-1:0]     i_par_fifo_swdata,       // write data
output                       o_par_fifo_sfull,        // full flag to source
output                       o_par_fifo_sfull_next,   // full next flag to source

// ============================================================================
// Destination Interface
// ============================================================================
input                        i_par_fifo_dpop,         // Destination pop command
output [PAR_FIFO_DW-1:0]     o_par_fifo_drdata,       // Destination read data
output                       o_par_fifo_dempty,       // Destination "empty" flag

output [PNT_WIDTH-1:0]       o_par_fifo_level         // FIFO level

);

// Internal registers & wires
// ============================================================================
reg  [PAR_FIFO_DW-1:0]    fifo_array[PAR_FIFO_DEPTH-1:0]; // fifo array
reg  [PNT_WIDTH-1:0]      head;                  // head pointer
reg  [PNT_WIDTH-1:0]      tail;                  // Dest tail pointer
reg  [PNT_WIDTH-1:0]      fifo_level;            // FIFO level

wire [PNT_WIDTH-1:0]      head_next;             // Next head pointer
wire [PNT_WIDTH-1:0]      head_clear_msb;        // head pointer w/o the sign
wire [PNT_WIDTH-1:0]      head_next_clear_msb;   // next head pointer w/o sign
wire [PNT_WIDTH-1:0]      head_tgl_msc_clr_cnt;  // temporary wire

wire [PNT_WIDTH-1:0]      tail_next;             // Next dest tail pointer
wire [PNT_WIDTH-1:0]      tail_clear_msb;        // tail pointer w/o the sign
wire [PNT_WIDTH-1:0]      tail_tgl_msb_clr_cnt;  // temporary wire


integer wr_ln_cnt;     // write line selector - intemmediate variable
integer rd_ln_sel;     // read line selector  - intemmediate variable


// When pointer reaches fifo depth, LSB is reset and MSB is toggled.
// Extract n-1 rightmost bits which are internal position in the FIFO
assign head_clear_msb  = ((head << 1) >> 1);

// When pointer reaches fifo depth, LSB is reset and MSB is toggled.
// Extract n-1 rightmost bits which are internal position in the FIFO
assign head_next_clear_msb  = ((head_next << 1) >> 1);

////////////////////////////////////////////////////////////////////////////////
// Calculate next counter value or wrap-around by clearing all rightmost bits
// and toggling the MSB. This writing style is general enough for one-stage
// FIFO case (PAR_FIFO_DEPTH=1, PNT_WIDTH=1)
assign head_tgl_msc_clr_cnt = 
                 ((~head) & (({PNT_WIDTH{1'b1}}) << (PNT_WIDTH -1)));

// Calculate next head value
assign head_next  = (head_clear_msb < (PAR_FIFO_DEPTH - 1)) ?
                             (head + 1) : head_tgl_msc_clr_cnt;

////////////////////////////////////////////////////////////////////////////////
// FIFO write logic - head pointer - controls the head

// Manage the FIFO head pointer
always @(posedge i_par_fifo_clk or negedge i_par_fifo_reset_b)
if (!i_par_fifo_reset_b)
   head <= {PNT_WIDTH{1'b0}};
else if (i_par_fifo_clr)
   head <= {PNT_WIDTH{1'b0}};
else if (i_par_fifo_spush)
   head <= head_next;            

// Manage the FIFO array - write the selected stage. 
always @(posedge i_par_fifo_clk or negedge i_par_fifo_reset_b)
if (!i_par_fifo_reset_b)
   for (wr_ln_cnt = 0; wr_ln_cnt < PAR_FIFO_DEPTH; wr_ln_cnt = wr_ln_cnt + 1)
       fifo_array[wr_ln_cnt] <= {PAR_FIFO_DW{1'b0}};
else if (i_par_fifo_spush)
   fifo_array[head_clear_msb] <= i_par_fifo_swdata;

// Extract LSB bits of destination counter which point to the read location
assign tail_clear_msb  = ((tail << 1) >> 1);

// Toggle MSB of destination counter while clearing the LSB (wrap around)
assign tail_tgl_msb_clr_cnt =
                ((~tail) & (({PNT_WIDTH{1'b1}}) << (PNT_WIDTH -1)));

// Changed to acocunt for any FIFO depth:
// When pointer reaches fifo depth, LSB is reset and MSB is toggled.
assign tail_next  = (tail_clear_msb < (PAR_FIFO_DEPTH - 1)) ?
              (tail + 1) : tail_tgl_msb_clr_cnt;

// FIFO is empty when head and tail are equals.
assign o_par_fifo_dempty = (head == tail);

// Full condition is: reverse MSB and equal LSB of the FIFO head and tail
// pointers
assign o_par_fifo_sfull = (head_clear_msb == tail_clear_msb) &
            (head[PNT_WIDTH -1] == ~ tail[PNT_WIDTH -1]);

// Full next condition
assign o_par_fifo_sfull_next = 
           o_par_fifo_sfull 
           | (
             (head_next_clear_msb == tail_clear_msb)
             & (head_next[PNT_WIDTH -1] == ~tail[PNT_WIDTH -1])
             );

// FIFO Level
always @(posedge i_par_fifo_clk  or negedge i_par_fifo_reset_b)
if (!i_par_fifo_reset_b)
   fifo_level <= {PNT_WIDTH{1'b0}};
else if (i_par_fifo_clr)
   fifo_level <= {PNT_WIDTH{1'b0}};
else if (i_par_fifo_dpop & !i_par_fifo_spush)
   fifo_level <= fifo_level - 1;
else if (!i_par_fifo_dpop & i_par_fifo_spush)
   fifo_level <= fifo_level + 1;

// Output the FIFO level
assign o_par_fifo_level = fifo_level;

////////////////////////////////////////////////////////////////////////////////
// FIFO read pointer - the tail
always @(posedge i_par_fifo_clk  or negedge i_par_fifo_reset_b)
if (!i_par_fifo_reset_b)
   tail <= {PNT_WIDTH{1'b0}};
else if (i_par_fifo_clr)
   tail <= {PNT_WIDTH{1'b0}};
else if (i_par_fifo_dpop)
   tail <= tail_next;

// Mux for the read data
assign o_par_fifo_drdata = fifo_array[tail_clear_msb];

// -----------------------------------------------------------------------------
// NAME : Clog2:
//        Returns ceiling(log_base_2(n))
// TYPE : func
// -----------------------------------------------------------------------------
// PURPOSE : Returns ceiling(log_base_2(n))
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME   RANGE : DESCRIPTION             : DEFAULT : UNITS
//    N/A
// -----------------------------------------------------------------------------
// Other : N/A
// -----------------------------------------------------------------------------
function [31:0] Clog2;              // returns ceiling(log_base_2(n))
    input [31:0] n;                 // Input number
    reg   [31:0] i;                 // Index
    
    begin
        i = (n>0) ? n-1 : 0;
        for (Clog2=0; i>0; Clog2=Clog2+1)
            i = i >> 1;
    end       
endfunction // Clog2

endmodule 

