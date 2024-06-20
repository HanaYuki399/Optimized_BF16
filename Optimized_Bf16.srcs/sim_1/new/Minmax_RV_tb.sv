`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2024 04:44:38 PM
// Design Name: 
// Module Name: Minmax_RV_tb
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

module tb_bf16_minmax_RV;

    // Inputs
    reg clk;
    reg reset;
    reg enable;
    reg [15:0] operand_a;
    reg [15:0] operand_b;
    reg [3:0] operation;
    reg in_valid_i;
    reg out_ready_i;

    // Outputs
    wire in_ready_o;
    wire out_valid_o;
    wire [15:0] result;
    wire [3:0] fpcsr;

    // Instantiate the Unit Under Test (UUT)
    bf16_minmax_RV uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .operation(operation),
        .in_valid_i(in_valid_i),
        .in_ready_o(in_ready_o),
        .out_valid_o(out_valid_o),
        .out_ready_i(out_ready_i),
        .result(result),
        .fpcsr(fpcsr)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 1;
        reset = 0;
        enable = 0;
        operand_a = 0;
        operand_b = 0;
        operation = 0;
        in_valid_i = 0;
        out_ready_i = 1;

        // Reset the design
        #20;
        reset = 1;
        enable = 0;

        // Test 1: Min operation with valid operands
        #10;
        operand_a = 16'h3C00; // 1.5 in BF16
        operand_b = 16'h4000; // 2.0 in BF16
        operation = 4'b0011; // Min operation
        in_valid_i = 1;
        out_ready_i = 1;
        enable = 1;

        #10;
        //in_valid_i = 0; // Lower the valid signal after one cycle

        // Wait for the output to be valid
        wait(out_valid_o);

        // Check the result
        if (result == 16'h3C00) // Expect 1.5 as min
            $display("Test 1 Passed");
        else
            $display("Test 1 Failed: result = %h", result);

        // Test 2: Max operation with valid operands
        #10;
        operand_a = 16'h3C00; // 1.5 in BF16
        operand_b = 16'h4000; // 2.0 in BF16
        operation = 4'b0010; // Max operation
        in_valid_i = 1;
        out_ready_i = 1;
        enable = 0;

        #10;
        in_valid_i = 0; // Lower the valid signal after one cycle

        // Wait for the output to be valid
        wait(out_valid_o);

        // Check the result
        if (result == 16'h4000) // Expect 2.0 as max
            $display("Test 2 Passed");
        else
            $display("Test 2 Failed: result = %h", result);

        // Test 3: NaN handling
        #10;
        operand_a = 16'h7FC0; // NaN in BF16
        operand_b = 16'h4000; // 2.0 in BF16
        operation = 4'b0011; // Min operation (should return operand B as A is NaN)
        in_valid_i = 1;
        out_ready_i = 1;

        #10;
        in_valid_i = 0; // Lower the valid signal after one cycle

        // Wait for the output to be valid
        wait(out_valid_o);

        // Check the result
        if (result == 16'h4000) // Expect 2.0 since A is NaN
            $display("Test 3 Passed");
        else
            $display("Test 3 Failed: result = %h", result);

        // Test 4: Ready/Valid handshake behavior
        #10;
        operand_a = 16'h3C00; // 1.5 in BF16
        operand_b = 16'h4000; // 2.0 in BF16
        operation = 4'b0011; // Min operation
        in_valid_i = 1;
        out_ready_i = 0; // Out ready is low, should stall the output

        #10;
        in_valid_i = 0; // Lower the valid signal after one cycle
        out_ready_i = 1; // Now make the output ready

        // Wait for the output to be valid
        wait(out_valid_o);

        // Check the result
        if (result == 16'h3C00) // Expect 1.5 as min
            $display("Test 4 Passed");
        else
            $display("Test 4 Failed: result = %h", result);

        $finish;
    end
endmodule





//`timescale 1ns / 1ps

//module tb_bf16_minmax_RV;

//  // Inputs
//  reg clk;
//  reg reset;
//  reg enable;
//  reg [15:0] operand_a;
//  reg [15:0] operand_b;
//  reg [3:0] operation;
//  reg in_valid_i;
//  reg out_ready_i;

//  // Outputs
//  wire in_ready_o;
//  wire out_valid_o;
//  wire [15:0] result;
//  wire [3:0] fpcsr;

//  // Instantiate the Unit Under Test (UUT)
//  bf16_minmax_RV uut (
//      .clk(clk),
//      .reset(reset),
//      .enable(enable),
//      .operand_a(operand_a),
//      .operand_b(operand_b),
//      .operation(operation),
//      .in_valid_i(in_valid_i),
//      .in_ready_o(in_ready_o),
//      .out_valid_o(out_valid_o),
//      .out_ready_i(out_ready_i),
//      .result(result),
//      .fpcsr(fpcsr)
//  );

//  // Clock generation
//  always #5 clk = ~clk;

//  // Task to apply inputs and check results
//  task apply_stimulus;
//    input [15:0] a;
//    input [15:0] b;
//    input [3:0] op;
//    input valid;
//    input ready;
//    begin
//      @(posedge clk);
//      operand_a <= a;
//      operand_b <= b;
//      operation <= op;
//      in_valid_i <= valid;
//      out_ready_i <= ready;
//      @(posedge clk);
//    end
//  endtask

//  initial begin
//    // Initialize Inputs
//    clk = 0;
//    reset = 0;
//    enable = 0;
//    operand_a = 0;
//    operand_b = 0;
//    operation = 0;
//    in_valid_i = 0;
//    out_ready_i = 0;

//    // Apply reset
//    @(posedge clk);
//    reset = 1;
//    @(posedge clk);
//    reset = 0;
//    enable = 1;

//    // Apply test vectors
//    // Test case 1: Min operation
//    apply_stimulus(16'h3C00, 16'h4000, 4'b0011, 1, 1);  // 1.0 vs 2.0, expect 1.0

//    // Wait for the result
//    @(posedge clk);
//    if (result != 16'h3C00) $display("Test case 1 failed");

//    // Test case 2: Max operation
//    apply_stimulus(16'h3C00, 16'h4000, 4'b0010, 1, 1);  // 1.0 vs 2.0, expect 2.0

//    // Wait for the result
//    @(posedge clk);
//    if (result != 16'h4000) $display("Test case 2 failed");

//    // Test case 3: NaN handling
//    apply_stimulus(16'h7FC0, 16'h4000, 4'b0011, 1, 1);  // NaN vs 2.0, expect 2.0

//    // Wait for the result
//    @(posedge clk);
//    if (result != 16'h4000 || fpcsr[3] != 1) $display("Test case 3 failed");

//    // Test case 4: Both NaN
//    apply_stimulus(16'h7FC0, 16'h7FC0, 4'b0011, 1, 1);  // NaN vs NaN, expect canonical NaN

//    // Wait for the result
//    @(posedge clk);
//    if (result != 16'h7FC0 || fpcsr[3] != 1) $display("Test case 4 failed");

//    // Finish simulation
//    $display("All test cases passed");
//    $stop;
//  end
//endmodule
