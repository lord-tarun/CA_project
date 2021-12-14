`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.12.2021 11:46:38
// Design Name: 
// Module Name: stall
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


module stall(input ex_memread,
 input [4:0] rs1,rs2,rrwrite, 
 output reg stall_signal, input reset );
 
 always @(*)
 begin
 if (reset)
    stall_signal <= 1'b0;
 else if (ex_memread &((rrwrite == rs1) | (rrwrite == rs2)))
    stall_signal <= 1'b1;
 else
    stall_signal <= 1'b0;
 end
endmodule
