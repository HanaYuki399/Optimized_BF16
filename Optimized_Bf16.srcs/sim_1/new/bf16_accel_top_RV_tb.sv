`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 01:48:55 PM
// Design Name: 
// Module Name: bf16_accel_top_RV_tb
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


`timescale 1ns / 1ps

module tb_bf16_accelerator_top;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] operand_a;
    reg [15:0] operand_b;
    reg [31:0] operand_c;
    reg [3:0] operation; // Operation select
    reg enable;
    reg in_valid_i;
    reg out_ready_i;

    // Outputs
    wire [31:0] result;
    wire [3:0] fpcsr;
    wire in_ready_o;
    wire out_valid_o;

    // Instantiate the Unit Under Test (UUT)
    bf16_accelerator_top uut (
        .clk(clk),
        .reset(reset),
        .enable(enable), 
        .operand_a(operand_a),
        .operand_b(operand_b),
        .operand_c(operand_c),
        .operation(operation),
        .in_valid_i(in_valid_i),
        .in_ready_o(in_ready_o),
        .out_ready_i(out_ready_i),
        .out_valid_o(out_valid_o),
        .result(result),
        .fpcsr(fpcsr)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 1;
        reset = 0;
        operand_a = 0;
        operand_b = 0;
        operand_c = 0;
        //operation = 0;
        enable = 1;
        in_valid_i = 0;
        out_ready_i = 0;

        // Apply reset
        #10
        reset = 1;
        #10
        reset = 1;
        

        // Wait for global reset
        #10
        enable = 1;
        in_valid_i = 1;
        out_ready_i = 1;

        // Test case 1: Normal numbers
        operand_a = 32'h4000; // 2.0 in FP32
        operand_b = 16'h3C00; // 1.0 in BF16
        operation = 4'b0111; // min
        #10
        in_valid_i = 1;
        out_ready_i = 1;
        operand_a = 32'h78701100; // 2.0 in FP32
        operand_b = 16'h3f90; // 1.0 in BF16
        operand_c = 32'h40a00000; // 5.0 in FP32
        operation = 4'b0000; // FMA
        #10
        operation = 4'b0001;
        in_valid_i = 1;
        operand_a = 32'h10004000; // 2.0 in FP32
        operand_b = 16'h4080; // 4.0 in BF16
        operand_c = 32'h40c00000; // 6.0 in FP32
        operation = 4'b0001; // FMA
        #10

        // Test case 2: Special values (Infinity and NaN)
        operand_a = 32'h7F803810; // Infinity in FP32
        operand_b = 16'h7000; // NaN in BF16
        operation = 4'b0111; // max
        #10

        // Test case 3: Subnormal numbers
        operand_a = 32'h33800010; // Small subnormal in FP32
        operand_b = 16'h3400; // Slightly larger subnormal in BF16
        operation = 4'b0010; // min
        #10

        // Test case 4: Equal operands
        operand_a = 32'h3555; // Some FP32 number
        operand_b = 16'h3555; // Same number in BF16
        operation = 4'b0010; // max
        #10

        // Test case 5: Overflow and underflow
        operand_a = 32'h7F7F; // Largest FP32 number
        operand_b = 16'h0080; // Smallest BF16 number
        operation = 4'b0010; // max
        #10
    #100
        // Finish the simulation
        $finish;
    end
endmodule