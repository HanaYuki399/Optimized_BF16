`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 04:03:05 PM
// Design Name: 
// Module Name: conv_tb
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

module tb_combined_conversion();

    // Inputs
    reg clk;
    reg reset;
    reg [3:0] operation; // Operation signal for the accelerator
    reg [31:0] operand_a;
    reg enable;
    // Outputs
    wire [31:0] result;
    wire [3:0] fpcsr; // FPCSR register

    // Instantiate the BF16 Accelerator Top Unit Under Test (UUT)
    bf16_accelerator_top uut (
        .clk(clk),
        .reset(reset),
        .enable(enable), // Always enable the accelerator for testing
        .operand_a(operand_a),
        .operand_b(16'h0), // Not used in conversion tests
        .operand_c(32'h0), // Not used in conversion tests
        .operation(operation),
        .result(result),
        .fpcsr(fpcsr),
        .valid() // Ignored in this testbench
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test cases
    initial begin
        // Initialize Inputs
        clk = 1;
        reset = 1;
        operand_a = 0;
        enable = 1'b0;
        operation = 4'b0001;
        #10
        
        //operation = 4'b0001;
        // Wait 100 ns for global reset
        #10;
        enable = 1'b1;
        reset = 0;
        
        enable = 1'b1;

        // FP32 to BF16 Conversion Tests
        operation = 4'b0001; // Operation code for FP32 to BF16 Conversion

        // Test 1: Normal number conversion
        operand_a = 32'h4049CFDB; // PI in FP32
        #10; check_result("FP32 to BF16: Normal Conversion");

        // Test 2: Zero
        operand_a = 32'h00000000; // Zero in FP32
        #10; check_result("FP32 to BF16: Zero");

        // Test 3: Infinity
        operand_a = 32'h7F800000; // Positive Infinity in FP32
        #10; check_result("FP32 to BF16: Positive Infinity");

        // Test 4: NaN
        operand_a = 32'hFFC00000; // NaN in FP32
        #10; check_result("FP32 to BF16: NaN");

        // BF16 to FP32 Conversion Tests
        operation = 4'b0001; // Operation code for BF16 to FP32 Conversion

        // Test 5: Normal number conversion
        operand_a = 32'h3C000000; // 1.0 in BF16
        #10; check_result("BF16 to FP32: Normal Conversion");

        // Test 6: Zero
        operand_a = 32'h56560000; // Zero in BF16
        #10; check_result("BF16 to FP32: Zero");

        // Test 7: Infinity
        operand_a = 32'h7F800000; // Positive Infinity in BF16
        #10; check_result("BF16 to FP32: Positive Infinity");

        // Test 8: NaN
        operand_a = 32'h7FC00000; // NaN in BF16
        #10; check_result("BF16 to FP32: NaN");
        
        // BF16 to FP32 Conversion Tests
        operation = 4'b0000; // Operation code for BF16 to FP32 Conversion

        // Test 5: Normal number conversion
        operand_a = 16'h3C00; // 1.0 in BF16
        #10; check_result("BF16 to FP32: Normal Conversion");

        // Test 6: Zero
        operand_a = 16'h4560; // Zero in BF16
        #10; check_result("BF16 to FP32: Zero");

        // Test 7: Infinity
        operand_a = 16'h7F80; // Positive Infinity in BF16
        #10; check_result("BF16 to FP32: Positive Infinity");

        // Test 8: NaN
        operand_a = 16'h7FC0; // NaN in BF16
        #10; check_result("BF16 to FP32: NaN");


        // End of test
        $finish;
    end

    // Check results and print messages
    task check_result;
        input [128*8:1] test_name;
        begin
            $display("%s: Result = %h, FPCSR = %b", test_name, result, fpcsr);
        end
    endtask

endmodule
