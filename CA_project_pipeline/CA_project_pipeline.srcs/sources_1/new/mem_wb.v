`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2021 13:23:06
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(input clk, input [4:0] mem_rrwrite, input mem_memtoreg, input mem_regwrite,
input [31:0]mem_alu_out, input [31:0] memory_read,
output reg [4:0] wb_rrwrite, output reg wb_memtoreg, output reg wb_regwrite,
output reg [31:0]wb_alu_out, output reg [31:0] wb_memory_read );

always@(posedge clk)
begin
wb_rrwrite <= mem_rrwrite ;
wb_memtoreg <= mem_memtoreg;
wb_regwrite <= mem_regwrite;
wb_alu_out <= mem_alu_out;
wb_memory_read <= memory_read;
end
endmodule
