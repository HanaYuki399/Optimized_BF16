`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2024 02:59:59 PM
// Design Name: 
// Module Name: lzc_tb
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

module clz_tb;

    // Parameters
    parameter REF_VECTOR_WIDTH = 32;

    // Inputs
    reg [REF_VECTOR_WIDTH-1:0] ref_vector;

    // Outputs
    wire [4:0] dout;

    // Instantiate the module under test
    clz #(REF_VECTOR_WIDTH) u_clz(
        .ref_vector(ref_vector),
        .dout(dout)
    );

    // Stimulus
    initial begin
        $display("Testing clz module");

        // Test case 1
        ref_vector = 32'h00000001; // No leading ones
        #10;
        $display("Input: %h, Output: %b", ref_vector, dout);

        // Test case 2
        ref_vector = 32'h00FF0000; // 8 leading zeros
        #10;
        $display("Input: %h, Output: %b", ref_vector, dout);
        
                // Test case 2
        ref_vector = 32'h00000700; // 8 leading zeros
        #10;
        $display("Input: %h, Output: %b", ref_vector, dout);

        // Test case 3
        ref_vector = 32'hFFFF0000; // No leading zeros
        #10;
        $display("Input: %h, Output: %b", ref_vector, dout);

        // Add more test cases as needed...

        // End simulation
        $finish;
    end

endmodule

