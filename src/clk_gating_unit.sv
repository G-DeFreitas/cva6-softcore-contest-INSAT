// Author: Badier, De Freitas, Laidet
// Date: 25.02.2022
// Description: Unit that clock-gates modules depending on current instruction

module clock_gating import ariane_pkg::*; (
    input  logic                                     clk_i,
    input  logic                                    rst_ni,
    input  scoreboard_entry_t           sbe_clock_gating_i, 

    //gated clock
    output logic                                    clk_mult
);
  
    //disable gated clocks to sub-modules
    logic needs_mult    		=   1'b0	;
    logic [2:0] mult_counter    =   0		;

    always_comb begin
        needs_mult = (sbe_clock_gating_i.op >= MUL && sbe_clock_gating_i.op <= MULW ) ? 1'b1 : 1'b0;
	    clk_mult = (mult_counter !=0 ) ? clk_i : 1'b0;
    end

    always @ (posedge clk_i) begin
	if (needs_mult == 1) begin
	mult_counter = 1;
	end else if( mult_counter !=0) begin
	mult_counter++;
	end else begin
	mult_counter =0;
	end
    end
endmodule
