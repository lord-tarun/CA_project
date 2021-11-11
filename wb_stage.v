`timescale 1ns / 1ps

module wb_stage(input [31:0] alu_out, input [31:0] memory_read, input memtoreg, output [31:0] writetoreg);

assign writetoreg=memtoreg?memory_read:alu_out;

endmodule