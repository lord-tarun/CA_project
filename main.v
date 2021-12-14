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
reg [4:0] clk_count;
wire [31:0] PC, instruction_code, out_reg1, out_reg2, imm_data, writetoreg, alu_out, memory_read, branched_PC;
wire [1:0] imm_sel;
wire [2:0] alu_ctrl;
wire regwrite, alusrc, memtoreg, memread, memwrite, branch,pcsrc, stall_signal ;

always@(posedge clk)
begin
if (reset)
    clk_count = 1;
else
    clk_count = clk_count + 1;
end

// Pipeline Register signals
wire [31:0] id_PC, id_inst, ex_PC, decode_inst, dest_reg, ex_dest_reg;
wire [31:0] ex_data1,ex_data2,ex_imm, mem_alu_out, mem_branched_PC, mem_ex_data2, wb_alu_out, wb_memory_read;
wire [2:0] ex_alu_ctrl;
wire [4:0] rrs1, rrs2, rrwrite, mem_rrwrite, mem_rs2,wb_rrwrite, next_write_reg;
wire ex_alusrc,ex_branch,ex_memread,ex_memwrite,ex_memtoreg,ex_regwrite,mem_memread, mem_memwrite, mem_memtoreg, mem_regwrite,
mem_pcsr, wb_memtoreg,wb_regwrite;
wire [1:0] sel1, sel2;

inst_stage i1(clk,reset,PC,instruction_code, mem_branched_PC, mem_pcsr, stall_signal);

if_id id1(clk,PC, instruction_code, id_PC, id_inst);

nop_mux n1(id_inst, decode_inst,stall_signal);

wire mac;
decode_stage d1(clk,reset,decode_inst , out_reg1,out_reg2, imm_data,alusrc,memtoreg,
memread, memwrite,branch,
id_PC, branched_PC, pcsr,
writetoreg, alu_ctrl, wb_regwrite,wb_rrwrite,  next_write_reg, next_regwrite, stall_signal,
mac, dest_reg
);

id_ex idex(clk,id_PC,
        out_reg1,out_reg2,imm_data,alusrc,alu_ctrl,
        branch,
        memread,memwrite,memtoreg,next_regwrite,
        ex_PC,
        ex_data1,ex_data2,ex_imm,ex_alusrc,ex_alu_ctrl,ex_branch,
        ex_memread,ex_memwrite,ex_memtoreg,ex_regwrite,
        id_inst[19:15],id_inst[24:20],next_write_reg,rrs1, rrs2, rrwrite,
        mac, ex_mac, dest_reg, ex_dest_reg
        //, branched_PC, ex_branched_PC, pcsr, ex_pcsr
      );

wire [31:0] alu_data1, alu_data2;      
forwarding_mux f1(sel1, ex_data1, mem_alu_out,wb_memory_read, alu_data1,writetoreg );
forwarding_mux f2(sel2, ex_data2, mem_alu_out,wb_memory_read, alu_data2, writetoreg);
      
ALU_stage a1(alu_data1,alu_data2,ex_imm, ex_alusrc,ex_alu_ctrl,alu_out,
ex_PC, ex_branch, branched_PC, pcsrc, 
            ex_mac, ex_dest_reg);

ex_mem exmem( clk,ex_memread, ex_memwrite,ex_memtoreg, ex_regwrite,rrwrite,alu_out, 
branched_PC,pcsrc,
alu_data2,
mem_memread, mem_memwrite, mem_memtoreg, mem_regwrite,mem_rrwrite,mem_alu_out,
mem_branched_PC, mem_pcsr, 
mem_ex_data2);


mem_stage m1(reset,mem_alu_out, mem_memread,mem_memwrite,mem_ex_data2 ,memory_read);

mem_wb memwb(clk, mem_rrwrite,mem_memtoreg, mem_regwrite,mem_alu_out,memory_read,
wb_rrwrite, // Go to decode
wb_memtoreg,
wb_regwrite, // Go to decode
wb_alu_out, wb_memory_read );

wb_stage w1(wb_alu_out,wb_memory_read,wb_memtoreg,
writetoreg // Transfer to decode
);

forwarding_check f3(mem_regwrite, mem_rrwrite, wb_rrwrite ,rrs1, rrs2,wb_regwrite,sel1,sel2,mem_memread );
stall s1(ex_memread,id_inst[19:15],id_inst[24:20],rrwrite, stall_signal, reset );

endmodule

module forwarding_mux(input [1:0] sel, input [31:0] normal_input, ex_input, mem_input, output reg [31:0] out_data,
input [31:0] writetoreg);
always @(*)
case(sel)
2'b00: out_data = normal_input;
2'b01: out_data = ex_input;
2'b10: out_data = mem_input;
2'b11: out_data = writetoreg;
endcase
endmodule


module nop_mux(input [31:0] id_inst, output [31:0] decode_inst, input stall_signal);

assign decode_inst = stall_signal ? 32'h00000033:id_inst;

endmodule