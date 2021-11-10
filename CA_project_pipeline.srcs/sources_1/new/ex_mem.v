`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2021 12:25:29
// Design Name: 
// Module Name: ex_mem
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


module ex_mem( input clk,input ex_memread, input ex_memwrite, input ex_memtoreg, input ex_regwrite, input [4:0] rrwrite,
input [31:0] alu_out, input [31:0] branched_PC, input pcsrc,input [31:0] data2,
output reg mem_memread, output reg mem_memwrite, output reg mem_memtoreg, output reg mem_regwrite, output reg [4:0] mem_rrwrite,
output reg [31:0] mem_alu_out, output reg [31:0] mem_branched_PC, output reg mem_pcsr, output reg [31:0] mem_data2
);

always @(posedge clk)
begin
    mem_memread <= ex_memread;
    mem_memwrite <= ex_memwrite;
    mem_memtoreg <= ex_memtoreg;
    mem_regwrite <= ex_regwrite;
    mem_rrwrite  <= rrwrite;
    mem_alu_out  <= alu_out;
    mem_branched_PC <= branched_PC;
    mem_pcsr <= pcsrc;
    mem_data2 <= data2;
end
endmodule
