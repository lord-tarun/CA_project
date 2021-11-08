`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.10.2021 16:19:46
// Design Name: 
// Module Name: main
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


module main( input clk, input reset);
wire [31:0] PC, instruction_code, out_reg1, out_reg2, imm_data, writetoreg, alu_out, memory_read, branched_PC;
wire [1:0] imm_sel;
wire [2:0] alu_ctrl;
wire regwrite, alusrc, memtoreg, memread, memwrite, branch,pcsrc ;

// Pipeline Register signals
wire [31:0] id_PC, id_inst, ex_PC;
wire [31:0] ex_data1,ex_data2,ex_imm, mem_alu_out, mem_branched_PC, mem_ex_data2, wb_alu_out, wb_memory_read;
wire [2:0] ex_alu_ctrl;
wire [4:0] rrs1, rrs2, rrwrite, mem_rrwrite, mem_rs2,wb_rrwrite, next_write_reg;
wire ex_alusrc,ex_branch,ex_memread,ex_memwrite,ex_memtoreg,ex_regwrite,mem_memread, mem_memwrite, mem_memtoreg, mem_regwrite,
mem_pcsr, wb_memtoreg,wb_regwrite;


inst_stage i1(clk,reset,PC,instruction_code, mem_branched_PC, mem_pcsr);

if_id id1(clk, PC, instruction_code, id_PC, id_inst);

decode_stage d1(clk,reset,id_inst , out_reg1,out_reg2, imm_data,alusrc,memtoreg,
memread, memwrite,branch,writetoreg, alu_ctrl, wb_regwrite,wb_rrwrite,  next_write_reg, next_regwrite);

id_ex idex(clk,id_PC,out_reg1,out_reg2,imm_data,alusrc,alu_ctrl,branch,memread,memwrite,memtoreg,next_regwrite,
      ex_PC,ex_data1,ex_data2,ex_imm,ex_alusrc,ex_alu_ctrl,ex_branch,ex_memread,ex_memwrite,ex_memtoreg,ex_regwrite,
      id_inst[19:15],id_inst[24:20],next_write_reg,rrs1, rrs2, rrwrite);
      
      
ALU_stage a1(ex_data1,ex_data2,ex_imm, ex_alusrc,ex_alu_ctrl,alu_out,ex_PC, ex_branch, branched_PC, pcsrc);

ex_mem exmem( clk,ex_memread, ex_memwrite,ex_memtoreg, ex_regwrite,rrwrite,alu_out, branched_PC,pcsrc, ex_data2,
mem_memread, mem_memwrite, mem_memtoreg, mem_regwrite,mem_rrwrite,mem_alu_out,mem_branched_PC, mem_pcsr, mem_ex_data2);


mem_stage m1(reset,mem_alu_out, mem_memread,mem_memwrite,mem_ex_data2 ,memory_read);

mem_wb memwb(clk, mem_rrwrite,mem_memtoreg, mem_regwrite,mem_alu_out,memory_read,
wb_rrwrite, // Go to decode
wb_memtoreg,
wb_regwrite, // Go to decode
wb_alu_out, wb_memory_read );

wb_stage w1(wb_alu_out,wb_memory_read,wb_memtoreg,
writetoreg // Transfer to decode
);

endmodule
