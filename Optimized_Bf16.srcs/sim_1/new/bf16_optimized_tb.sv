`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2024 02:36:41 PM
// Design Name: 
// Module Name: bf16_optimized_tb
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




module bf16_optimized_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [15:0] operand_a;
    reg [15:0] operand_b;
    reg [15:0] operand_c;
    reg enable;
    reg [3:0] operation;

    // Outputs
    wire [15:0] result;
    wire [3:0] fpcsr;
    
    // Instantiate the Unit Under Test (UUT)
    bf16_fma_op uut (
        .clk(clk),
        .reset(reset),
        .en(enable),
        .op_a(operand_a),
        .op_b(operand_b),
        .op_c(operand_c),
        .oper(operation),
        .result(result),
        .fpcsr(fpcsr)
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
        enable = 0;
        operation = 4'b1000; // Assuming operation code for FMA is 0111

        // Wait for global reset
        #10;

        reset = 0;
        enable = 1;
        #10

        // Test case 1: Normal operation
        operand_a = 16'h3f80; // 1.0
        operand_b = 16'h4000; // 2.0
        operand_c = 16'h40a0; // 5.0
        #10; // Result should be 1.0*2.0 + 5.0 = 7.0 (0x40e0)

        //operation = 4'b1000;
        operand_a = 16'h3f80; // 1.0
        operand_b = 16'h4000; // 2.0
        operand_c = 16'h41a0; // 5.0
        #10; // Result should be 1.0*2.0 + 5.0 = 7.0 (0x40e0)
        

        
        
        // Test case 2: Underflow
        operand_a = 16'h0001; // Smallest subnormal number
        operand_b = 16'h0001; // Smallest subnormal number
        operand_c = 16'h0001; // Smallest subnormal number
        #10; // Result should be underflow to zero

        // Test case 3: Overflow
        operand_a = 16'h3C00; // Infinity
        operand_b = 16'h3C00; // 1.0
        operand_c = 16'h4200; // 3.0
        #10; // Result should be infinity (0x7F80)

        // Test case 4: Zero multiplication
        operand_a = 16'h0000; // 0.0
        operand_b = 16'h4000; // 2.0
        operand_c = 16'h4200; // 3.0
        #10; // Result should be 3.0 (0x4200)

        // Test case 5: Negative number multiplication
        operand_a = 16'hC000; // -2.0
        operand_b = 16'h4000; // 2.0
        operand_c = 16'h4200; // 3.0
        #10; // Result should be -4.0 + 3.0 = -1.0 (0xBF80)

        // Test case 6: NaN operand
        operand_a = 16'h7FC0; // NaN
        operand_b = 16'h4000; // 2.0
        operand_c = 16'h4200; // 3.0
        #10; // Result should be NaN (0x7FC0)

        // Test case 7: Rounding up
        operand_a = 16'h3EAA; // 0.33325
        operand_b = 16'h3EAA; // 0.33325
        operand_c = 16'h3EAA; // 0.33325
        #10; // Result should round down

        // Test case 8: Rounding down
        operand_a = 16'h3EAB; // 0.33350
        operand_b = 16'h3EAB; // 0.33350
        operand_c = 16'h3EAB; // 0.33350
        #10; // Result should round down
        
        operand_a = 16'h3EAA; // 
        operand_b = 16'h3EAB; // 
        operand_c = 16'h3EAB; // 
        #10; // Result should round up
      
        // Test case 9: Mixed sign operands
        operand_a = 16'hC000; // -2.0
        operand_b = 16'hC000; // -2.0
        operand_c = 16'h4000; // 2.0
        #10; // Result should be 4.0 + 2.0 = 6.0 (0x40C0)

        // Test case 10: Large magnitude operands
        operand_a = 16'h7BFF; // Largest positive number
        operand_b = 16'h7BFF; // Largest positive number
        operand_c = 16'h7BFF; // Largest positive number
        #10; // Result should handle large magnitude numbers
        
        operand_a = 16'h7BFF; // Largest positive number
        operand_b = 16'h7BFF; // Largest positive number
        operand_c = 16'h7BFF; // Largest positive number
        #10; // Result should handle large magnitude numbers
        
        // Test case 9: Mixed sign operands
        operand_a = 16'hC046; // -2.0
        operand_b = 16'hF2DF; // -2.0
        operand_c = 16'h4080; // 2.0
        #10; // Result should be 4.0 + 2.0 = 6.0 (0x40C0)
        
        // Test case 9: Mixed sign operands
        operand_a = 16'h9856; // -2.0
        operand_b = 16'hC000; // -2.0
        operand_c = 16'hC890; // 2.0
        #10; // Result should be 4.0 + 2.0 = 6.0 (0x40C0)
        
        // Test case 9: Mixed sign operands
        operand_a = 16'hD678; // -2.0
        operand_b = 16'hABC0; // -2.0
        operand_c = 16'h8769; // 2.0
        #10; // Result should be 4.0 + 2.0 = 6.0 (0x40C0)
        
        // Test case 9: Mixed sign operands
        operand_a = 16'h0987; // -2.0
        operand_b = 16'h1356; // -2.0
        operand_c = 16'h4000; // 2.0
        #10; // Result should be 4.0 + 2.0 = 6.0 (0x40C0)
        #30
        // Finish the simulation
        $finish;
    end

endmodule

