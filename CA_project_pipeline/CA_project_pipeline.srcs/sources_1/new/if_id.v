`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2021 13:18:00
// Design Name: 
// Module Name: if_id
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


module if_id(
    input clk,
    input [31:0] PC,
    input [31:0] instruction_code,
    output reg [31:0] id_PC,
    output reg [31:0] id_inst_code
    );
    always@(posedge clk)
    begin
        id_PC<=PC;
        id_inst_code <= instruction_code; 
    end
    
endmodule
