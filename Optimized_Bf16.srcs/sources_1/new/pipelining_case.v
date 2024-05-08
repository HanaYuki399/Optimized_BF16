`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2024 04:11:12 PM
// Design Name: 
// Module Name: pipelining_case
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

module pipelining_case_tb;

// Testbench signals
reg [2:0] b_tb;
reg clk_tb;
wire [2:0] a, c, d;

// Instantiate the Unit Under Test (UUT)
pipelining_case uut (
    .b(b_tb),
    .clk(clk_tb)
);

// Clock generation
initial begin
    clk_tb = 0; // Initial clock state
    forever #5 clk_tb = ~clk_tb; // Toggle clock every 5 ns
end

// Test sequence
initial begin
    // Initialize Inputs
    b_tb = 0;

    // Wait for the global reset
    #100;
    
    // Apply test vectors
    b_tb = 3'b001; #10;
    b_tb = 3'b010; #10;
    b_tb = 3'b100; #10;
    
    // Add more test vectors as needed
    
    // Wait for a while to observe the outputs
    #100;
    
    // Finish the simulation
    $finish;
end

endmodule




module pipelining_case(
    
    input [2:0] b,
    input clk
    );
    reg [2:0] a,c,d;
    wire [5:0] first;
    wire [5:0] second;
    
    
    always @(posedge clk) begin
    a<=b;
    end
    
    
    assign first = a + 1;
    
    
    always @(posedge clk) begin
    c<=first;
    end
    
    
    assign second = c + 1;
    
    
    always @(posedge clk) begin
    d<=second;
    end
    
    
endmodule
