`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2023 06:35:28 PM
// Design Name: 
// Module Name: Top_wrapper
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


module Top_wrapper( input logic clk,
    input logic reset,
    input logic write_enable,    // Write enable to start capturing input data
    input logic serial_data_in,  // Serial input data
    output logic serial_data_out // Serial output data
);

    // Internal signals
    logic [31:0] operand_a, operand_b, operand_c;
    logic [3:0] operation, fpcsr_out;
    logic [31:0] result;
    logic valid, enable;
    logic [99:0] input_buffer; // Buffer to store all inputs
    logic [35:0] output_buffer; // Buffer to store result and fpcsr

    // State machine states
    typedef enum {IDLE, READ_INPUTS, INVOKE_MODULE, READ_OUTPUTS} state_t;
    state_t state;

    // Counter for bit position
    integer bit_count;

    // Instantiate the accelerator module
    bf16_accelerator_top accel_module (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .operand_c(operand_c),
        .operation(operation),
        .result(result),
        .fpcsr(fpcsr_out),
        .valid(valid)
    );

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            enable <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (write_enable) begin
                        state <= READ_INPUTS;
                        bit_count <= 0;
                    end
                end
                READ_INPUTS: begin
                    if (bit_count < 100) begin
                        input_buffer[bit_count] <= serial_data_in;
                        bit_count <= bit_count + 1;
                    end else begin
                        operand_a <= input_buffer[31:0];
                        operand_b <= input_buffer[63:32];
                        operand_c <= input_buffer[95:64];
                        operation <= input_buffer[99:96];
                        state <= INVOKE_MODULE;
                        bit_count <= 0;
                    end
                end
                INVOKE_MODULE: begin
                    enable <= 1;
                    if (valid) begin
                        output_buffer[31:0] <= result;
                        output_buffer[35:32] <= fpcsr_out;
                        state <= READ_OUTPUTS;
                        bit_count <= 0;
                    end
                end
                READ_OUTPUTS: begin
                    if (bit_count < 36) begin
                        serial_data_out <= output_buffer[bit_count];
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= IDLE;
                        enable <= 0;
                    end
                end
            endcase
        end
    end

endmodule
