`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 05:44:11 PM
// Design Name: 
// Module Name: minmax_only
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
    reg enable;
    reg [15:0] operand_a;
    reg [15:0] operand_b;
    reg [3:0] operation;

    // Outputs
    wire [15:0] result;
    wire [3:0] fpcsr;

    // Instantiate the bf16_minmax module
    bf16_minmax uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .operation(operation),
        .result(result),
        .fpcsr(fpcsr)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock with period 10 ns
    end

    // Initialize Inputs and apply test cases
    initial begin
        // Initialize Inputs
        reset = 1;
        enable = 0;
        operand_a = 0;
        operand_b = 0;
        operation = 0;

        // Wait 100 ns for global reset to finish
        #100;
        reset = 0;
        enable = 1;

        // Test Case 1: Minimum of two BF16 numbers
        operand_a = 16'h4000;  // 2.0 in BF16
        operand_b = 16'h4040;  // 3.0 in BF16
        operation = 4'b0011;  // Min operation
        #20;
        
        // Test case 1: Normal numbers
        operand_a = 16'h4000; // 2.0
        operand_b = 16'h3C00; // 1.0
        //operation = 4'b0010; // min
        #20;
        
        operand_a = 16'h4000; // 2.0
        operand_b = 16'h3f90; // 1.0
       
        //operation = 4'b0010; // fma
        #20 
        
        operand_a = 16'h4000; // 2.0
        operand_b = 16'h4080; // 1.0
        
        //operation = 4'b0010; // fma
        #20

        // Test Case 2: Maximum of two BF16 numbers
        operation = 4'b0010;  // Max operation
        #20;

        // Test Case 3: Operand A is NaN
        operand_a = 16'h7FC1;  // NaN in BF16
        operand_b = 16'h3F80;  // 1.0 in BF16
        operation = 4'b0011;  // Min operation
        #20;

        // Test Case 4: Operand B is NaN
        operand_a = 16'h3F80;  // 1.0 in BF16
        operand_b = 16'h7FC1;  // NaN in BF16
        operation = 4'b0010;  // Max operation
        #20;

        // Test Case 5: Identical operands
        operand_a = 16'h3C00;  // 1.5 in BF16
        operand_b = 16'h3C00;  // 1.5 in BF16
        operation = 4'b0011;  // Min operation
        #20;

        // Test Case 6: Edge values, smallest and largest normal numbers
        operand_a = 16'h007F;  // Smallest BF16 number > 0
        operand_b = 16'h7BFF;  // Largest BF16 number
        operation = 4'b0011;  // Min operation
        #20;

        // Test Case 7: Negative and positive number
        operand_a = 16'hC000;  // -2.0 in BF16
        operand_b = 16'h4000;  // 2.0 in BF16
        operation = 4'b0011;  // Min operation
        #20;

        // Complete Test
        $stop;
    end

endmodule

