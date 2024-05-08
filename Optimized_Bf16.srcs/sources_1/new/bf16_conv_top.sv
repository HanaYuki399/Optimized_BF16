`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 06:19:26 PM
// Design Name: 
// Module Name: conversion_bf16
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


module bf16_conversion(
    input logic clk,
    input logic reset,
    input logic enable,  // Enable signal for conversion operations
    input logic [3:0] operation,    // 4-bit operation code
    input logic [31:0] operand,     // Universal operand for both BF16 and FP32
    output logic [31:0] result,     // Result, either BF16 or FP32
    output logic [3:0] fpcsr        // Floating Point Control and Status Register
);

    // Define operation codes for conversions
    localparam BF16_TO_FP32_OP = 4'b0000;
    localparam FP32_TO_BF16_OP = 4'b0001;
    
    wire bf16tofp32_en;
    wire fp32tobf16_en;
    
   

    // Internal signals for the submodules
    wire [15:0] bf16_result;
    wire [31:0] fp32_result;
    wire [3:0] bf16_fpcsr;
    wire [3:0] fp32_fpcsr;
    
    assign bf16tofp32_en = enable & (operation == BF16_TO_FP32_OP);
    assign fp32tobf16_en = enable & (operation == FP32_TO_BF16_OP);
        

    // Instantiate bf16_to_fp32 module
    bf16_to_fp32 bf16_to_fp32_inst (
        .clk(clk),
        .reset(reset),
        .instruction_enable(bf16tofp32_en),
        .operand_a(operand[15:0]),
        .result(fp32_result),
        .fpcsr(bf16_fpcsr)
    );

    // Instantiate fp32_to_bf16 module
    fp32_to_bf16 fp32_to_bf16_inst (
        .clk(clk),
        .reset(reset),
        .instruction_enable(fp32tobf16_en),
        .operand_a(operand),
        .result(bf16_result),
        .fpcsr(fp32_fpcsr)
    );

    // Logic to select the appropriate output based on operation
    
    assign result = (operation == BF16_TO_FP32_OP) ? fp32_result :
                (operation == FP32_TO_BF16_OP) ? {16'h0000, bf16_result} :
                32'h00000000;

    assign fpcsr = (operation == BF16_TO_FP32_OP) ? bf16_fpcsr :
                (operation == FP32_TO_BF16_OP) ? fp32_fpcsr :
                4'b0000;

    
    
//    always @(posedge clk ) begin
//        if(enable)begin
        
        
//        case (operation)
//            BF16_TO_FP32_OP: begin
//                result = fp32_result;
//                fpcsr = bf16_fpcsr;
//            end
//            FP32_TO_BF16_OP: begin
//                result = {16'h0000, bf16_result}; // Zero-extend BF16 result to 32 bits
//                fpcsr = fp32_fpcsr;
//            end
//            default: begin
//                result = 32'h00000000;
//                fpcsr = 4'b0000;
//            end
//        endcase
//        end
//    end

endmodule



