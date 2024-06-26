`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2024 04:22:26 PM
// Design Name: 
// Module Name: RV_exp_tb
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

`timescale 1 ns/1 ns
module tb();
reg  clk;
//---------------clock generator-----------------------
initial begin
    clk = 1'b0; 
    #5; 
    clk = 1'b1; 
    forever    begin
        #5 clk = ~clk;      
    end
end
//------------------ dump -----------------------
initial begin
    $dumpfile("dumpVCD.vcd");
    $dumpvars(10);  
end

localparam N_DATA=10;
reg in_bits_vec [0:N_DATA-1];
initial begin
    in_bits_vec[0] = 1'b1;
    in_bits_vec[1] = 1'b0; 
    in_bits_vec[2] = 1'b0; 
    in_bits_vec[3] = 1'b0; 
    in_bits_vec[4] = 1'b0;
    in_bits_vec[5] = 1'b0;
    in_bits_vec[6] = 1'b0;
    in_bits_vec[7] = 1'b0;
    in_bits_vec[8] = 1'b0;
    in_bits_vec[9] = 1'b1;
end
reg in_bit, reset, inp_valid, inp_ready, out_valid, out_ready;
Conv_Encoder_Core UUT(.clk(clk),
                        .reset(reset),
                        .in_bit(in_bit),
                        .out_A(out_A),
                        .out_B(out_B),
                        .sleep(1'b0),
                        // input channel
                        .inp_valid_i(inp_valid),
                        .inp_ready_o(inp_ready),
                        // output channel
                        .out_valid_o(out_valid),
                        .out_ready_i(out_ready));

//---------------- code starts here -------------------//
reg [3:0] addr;

// -- Transmitter Side -- //
always @(posedge clk) begin: ff_addr
    if (reset)begin
        addr <= 0;
    end else begin
        if (addr < 10) begin
            if (inp_valid && inp_ready) begin
                addr <= addr + 1;
            end
        end else begin
            addr <= 0;
        end
    end
end

assign inp_valid = (addr < 10) ? 1'b1 : 1'b0;

assign in_bit = in_bits_vec[addr];

// -- Receiver Side -- //
always @(posedge clk) begin: ff_ready_in
    if (reset) begin
        out_ready <= 0;
    end else begin
        out_ready <= $urandom_range(0, 1); // some randomness on the receiver, otherwise, we won't see if our DUT behaves correctly in case of ready=0
    end
end

// ----------- reset logic -----------//
reg [3:0] cnt;
initial cnt=0;
always @(negedge clk)begin
    if (cnt<5) begin
        reset = 1;
        cnt=cnt+1;
    end else  reset =0;
end

initial begin
 #1000;
$finish;
end
endmodule