`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2024 04:23:50 PM
// Design Name: 
// Module Name: RV_example
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Conv_Encoder_Core
(
    input wire clk,
    input wire reset,
    input wire in_bit,
    output reg out_A,
    output reg out_B,
    input wire sleep,
    // input channel
    input  wire inp_valid_i,
    output wire inp_ready_o,
    // output channel
    output reg out_valid_o,
    input  reg out_ready_i
);

reg [5:0] S;
wire S_A, S_B, clkON;
assign S_A = S[1] ^ S[2] ^ S[4] ^S[5];
assign S_B = S[0] ^ S[1] ^ S[2] ^S[5];
assign clkON = clk & !sleep;


// -- Changes start here -- //
wire wr_en;
reg full_r;

assign wr_en = ~full_r | out_ready_i;
always @(posedge clkON)begin
    if (reset) begin
        S <=0;
        full_r <=0;
    end else begin
        if (wr_en) begin
            if (inp_valid_i) begin
                full_r  <= 1;
                out_A   <= in_bit ^ S_A;
                out_B   <= in_bit ^ S_B;
                S       <= S<<1;
                S[0]    <=in_bit;
            end else begin
                full_r  <= 0;
            end
        end
    end
end

assign inp_ready_o = wr_en;
assign out_valid_o = full_r;

endmodule