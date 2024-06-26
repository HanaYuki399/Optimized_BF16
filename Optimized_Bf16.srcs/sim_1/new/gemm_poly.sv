`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2024 01:46:59 PM
// Design Name: 
// Module Name: gemm_poly
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

module gemm_poly;
    // Parameters
    parameter N = 10;
    parameter CLK_PERIOD = 10;

    // Signals
    logic clk;
    logic reset;
    logic enable;
    logic [15:0] operand_a;
    logic [15:0] operand_b;
    logic [15:0] operand_c;
    logic [3:0] operation;
    logic in_valid_i;
    logic out_ready_i;
    logic in_ready_o;
    logic out_valid_o;
    logic [31:0] result;
    logic [3:0] fpcsr;
    logic [15:0] A_bf16 [N-1:0];
    logic [15:0] B_bf16 [N-1:0];
    logic [15:0] C_bf16_init [N-1:0];

    // Instantiate the DUT (Device Under Test)
    bf16_accelerator_top_RV dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .operand_c(operand_c),
        .operation(operation),
        .in_valid_i(in_valid_i),
        .out_ready_i(out_ready_i),
        .in_ready_o(in_ready_o),
        .out_valid_o(out_valid_o),
        .result(result),
        .fpcsr(fpcsr)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialization
        reset = 1;
        enable = 0;
        in_valid_i = 0;
        out_ready_i = 0;
        #(CLK_PERIOD*5);
        reset = 1;

        // Load input arrays with specified bfloat16 values
         A_bf16  = {
            16'h3E80, 16'h3F80, 16'h3FA0, 16'h3FC0, 
            16'h4000, 16'h4020, 16'h4040, 16'h4050, 
            16'h4060, 16'h4070
        };
        B_bf16  = {
            16'h3F40, 16'h3F80, 16'h3FA0, 16'h3FC0, 
            16'h3FE0, 16'h4000, 16'h4020, 16'h4040, 
            16'h4060, 16'h4080
        };
        C_bf16_init = {
            16'h3E80, 16'h3F80, 16'h3FA0, 16'h3FC0, 
            16'h4000, 16'h4020, 16'h4040, 16'h4050, 
            16'h4060, 16'h4070
        };

        
        operation = 4'b0111; // FMA operation

        for (int i = 0; i < N; i++) begin
            operand_a = A_bf16[i];
            operand_b = B_bf16[i];
            operand_c = C_bf16_init[i];
            in_valid_i = 1;
            out_ready_i = 1;
            #(CLK_PERIOD*3); // Wait for 4 clock cycles for the result
            in_valid_i = 0;
            out_ready_i = 0;

            // Check result (you can print or store them for comparison)
            $display("a[%0d] = %h", i, operand_a);
            $display("b[%0d] = %h", i, operand_b);
            $display("c[%0d] = %h", i, operand_c);
            $display("Result[%0d] = %h", i, result[31:0]); // Display lower 16 bits as bfloat16
            
        end

        // Finish the simulation
        $finish;
    end
endmodule

