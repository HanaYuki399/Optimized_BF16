`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 03:56:06 PM
// Design Name: 
// Module Name: acc_top
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


module bf16_accelerator_top(
    input logic clk,
    input logic reset,
    input logic enable, // Enable signal for the accelerator
    input logic [31:0] operand_a, // First operand
    input logic [15:0] operand_b, // Second operand
    input logic [15:0] operand_c, // Third operand for FMA operations
    input logic [3:0] operation,  // Operation type
    output logic [31:0] result,   // Result of the operation
    output logic [3:0] fpcsr,    // Floating-point control and status register
    output logic valid            // Output valid signal
);

// Internal enable signals for submodules
logic conv_enable, maxmin_enable, addmul_enable;

// Internal result and FPCSR signals from submodules
logic [31:0] conv_result;
logic [15:0] maxmin_result, addmul_result;
logic [3:0] conv_fpcsr, maxmin_fpcsr, addmul_fpcsr;

 //Instantiate the conversion module
bf16_conversion bf16_fp32_conversion_inst (
        .clk(clk),
        .reset(reset),
        .enable(conv_enable),
        .operation(operation), // Pass the operation code
        .operand(operand_a),     // Pass the operand
        .result(conv_result),       // Receive the result
        .fpcsr(conv_fpcsr)          // Receive the FPCSR status
    );

// Instantiate the max/min module
    bf16_minmax maxmin_module (
    .clk(clk),
    .reset(reset),
    .enable(maxmin_enable),
    .operand_a(operand_a),
    .operand_b(operand_b),
    .operation(operation),
    .result(maxmin_result),
    .fpcsr(maxmin_fpcsr)
);

// Instantiate the add/mul module
bf16_fma addmul_module (
    .clk(clk),
    .reset(reset),
    .enable(addmul_enable),
    .operand_a(operand_a),
    .operand_b(operand_b),
    .operand_c(operand_c),
    .operation(operation),
    .result(addmul_result),
    .fpcsr(addmul_fpcsr)
);

// Decode logic
always @(*) begin
    // Default disable all units
    if (reset) begin

    conv_enable <= 0;
    maxmin_enable <= 0;
    addmul_enable <= 0;
    end

     else if (enable) begin

//            // Conversion Operations
//            4'b0000: conv_enable = 1; // BF16 to FP32 Conversion
//            4'b0001: conv_enable = 1; // FP32 to BF16 Conversion
            
//            // Max/Min Operations
//            4'b0010: maxmin_enable = 1; // Max
//            4'b0011: maxmin_enable = 1; // Min
            
//            // Add/Mul Operations
//            4'b0100: addmul_enable = 1; // Add
//            4'b0101: addmul_enable = 1; // Mul
//            4'b0110: addmul_enable = 1; // Sub
//            4'b0111: addmul_enable = 1; // Fused Multiply-Add (FMADD)
//            4'b1000: addmul_enable = 1; // Fused Multiply-Subtract (FMSUB)
//            4'b1001: addmul_enable = 1; // Fused Negative Multiply-Add (FMNADD)
//            4'b1010: addmul_enable = 1; // Fused Negative Multiply-Subtract (FMNSUB)
              conv_enable <= !operation[3] & !operation[2] & !operation[1];
              maxmin_enable <= !operation[3] & !operation[2] & operation[1];
              addmul_enable <= operation[3] | operation[2];
        

end
end
// Result and FPCSR aggregation
always @(posedge clk) begin
    valid = enable && (conv_enable || maxmin_enable || addmul_enable);

    if (conv_enable) begin
        result = conv_result;
        fpcsr = conv_fpcsr;
    end else if (maxmin_enable) begin
        result = maxmin_result;
        fpcsr = maxmin_fpcsr;
    end else if (addmul_enable) begin
        result = addmul_result;
        fpcsr = addmul_fpcsr;
    end else begin
        result = 32'h0;
        fpcsr = 4'h0;
    end
end



endmodule

