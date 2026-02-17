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
    input rst,                 // <-- ADD RESET
    input [15:0] current_in,
    input [15:0] speed_in,     // (not used yet)
    output reg fault_detected
); 

    parameter CURRENT_THRESHOLD = 16'd3000;
    parameter STABILITY_COUNT   = 5;

    reg [3:0] counter;  // enough for count up to 15

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            fault_detected <= 0;
        end
        else begin
            if (current_in > CURRENT_THRESHOLD)
                counter <= counter + 1;
            else
                counter <= 0;

            if (counter >= STABILITY_COUNT)
                fault_detected <= 1'b1;
            else
                fault_detected <= 1'b0;
        end
    end

endmodule

