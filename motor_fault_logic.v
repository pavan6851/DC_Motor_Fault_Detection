`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2026 04:00:01 PM
// Design Name: 
// Module Name: motor_fault_logic
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


module motor_fault_logic (
    input clk,
    input [15:0] current_in, // Input from your text file data
    input [15:0] speed_in,   // Input from your text file data
    output reg fault_detected
); 

    // Healthy steady state = 1980
    // Faulty steady state  = 3500
    // Threshold set to 3000 (0.3A scaled)
    
    always @(posedge clk) begin
        if (current_in > 3000) 
            fault_detected <= 1'b1;
        else
            fault_detected <= 1'b0;
    end
endmodule
