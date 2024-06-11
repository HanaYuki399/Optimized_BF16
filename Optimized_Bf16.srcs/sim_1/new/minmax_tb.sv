`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 04:01:37 PM
// Design Name: 
// Module Name: minmax_tb
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
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2023 11:59:21 PM
// Design Name: 
// Module Name: bf16minmaxtb
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

module tb_bf16_minmax;

    // Inputs
    reg clk;
    reg reset;
    reg [15:0] operand_a;
    reg [15:0] operand_b;
    reg [15:0] operand_c;
    reg [3:0] operation; // Operation select: 4'b0010 for min, 4'b0011 for max
    reg enable;

    // Outputs
    wire [15:0] result;
    wire [3:0] fpcsr; // Updated for fpcsr register

    // Instantiate the Unit Under Test (UUT)
 
    bf16_accelerator_top uut (
        .clk(clk),
        .reset(reset),
        .enable(enable), // Always enable the accelerator for testing
        .operand_a(operand_a),
        .operand_b(operand_b), // Not used in conversion tests
        .operand_c(operand_c), // Not used in conversion tests
        .operation(operation),
        .result(result),
        .fpcsr(fpcsr),
        .valid() // Ignored in this testbench
    );


    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 1;
        reset = 1;
        operand_a = 0;
        operand_b = 0;
        operand_c = 0;
        operation = 0;
        enable = 0;

        // Wait for global reset
        #10;
        reset = 0;
        enable = 1;
        

        // Test case 1: Normal numbers
        operand_a = 16'h8000; // 2.0
        operand_b = 16'h3C00; // 1.0
        operation = 4'b0010; // min
        #10;
        
        operand_a = 16'h4000; // 2.0
        operand_b = 16'h3f90; // 1.0
        operand_c = 16'h40a0;
        operation = 4'b0010; // fma
        #10 
        
        operand_a = 16'h4000; // 2.0
        operand_b = 16'h4080; // 1.0
        operand_c = 16'h40c0;
        operation = 4'b0010; // fma
        #10

        // Test case 2: Special values (Infinity and NaN)
        operand_a = 16'h7C00; // Infinity
        operand_b = 16'h7E00; // NaN
        operation = 4'b0011; // max
        #10;

         //Test case 3: Subnormal numbers
        operand_a = 16'h0380; // Small subnormal
        operand_b = 16'h0400; // Slightly larger subnormal
        operation = 4'b0011; // min
        #10;

        // Test case 4: Equal operands
        operand_a = 16'h3555; // Some BF16 number
        operand_b = 16'h3555; // Same number
        operation = 4'b0011; // max
        #10;

        // Test case 5: Overflow and underflow
        operand_a = 16'h7F80; // Largest BF16 number
        operand_b = 16'h0080; // Smallest BF16 number
        operation = 4'b0011; // max
        #10;

//        // Test case 6: Sign difference
//        operand_a = 16'hC000; // -2.0
//        operand_b = 16'h4000; // 2.0
//        operation = 4'b0010; // min
//        #10;

        // Add more test cases as needed

        // Finish the simulation
        $finish;
    end
endmodule

      

