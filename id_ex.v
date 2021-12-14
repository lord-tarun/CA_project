`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2021 13:28:50
// Design Name: 
// Module Name: id_ex
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


module id_ex(
    input clk,
    input [31:0] PC,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] imm,
    input alusrc,
    input [2:0] alu_ctrl,
    input branch,
    input memread,
    input memwrite,
    input memtoreg,
    input regwrite, 
    output reg [31:0] ex_PC, 
    output reg [31:0] ex_data1,
    output reg [31:0] ex_data2,
    output reg [31:0] ex_imm,
    output reg ex_alusrc,
    output reg [2:0] ex_alu_ctrl, // Check ALU src and ALU op.
    output reg ex_branch,
    output reg ex_memread,
    output reg ex_memwrite,
    output reg ex_memtoreg,
    output reg ex_regwrite,
   
    // Registers for checking Hazards
    input [4:0] rs1, rs2, rwrite,
    output reg [4:0] rrs1, rrs2, rrwrite,
    
    // Registers for MAC instructions
    input mac, output reg ex_mac,
    input [31:0] dest_reg, output reg [31:0] ex_dest_reg
    
    // Modified when branch checking in decode stage
    //input [31:0] branched_PC, output reg [31:0] ex_branched_PC,
    //input pcsr, output reg ex_pcsr
    );
    
    
    always @(posedge clk)
    begin
    ex_PC <= PC;
    ex_data1 <= data1;
    ex_data2 <= data2;
    ex_imm <= imm;
    ex_alusrc <= alusrc;
    ex_alu_ctrl <= alu_ctrl;
    ex_branch <= branch;
    ex_memread <= memread;
    ex_memwrite <= memwrite;
    ex_memtoreg <= memtoreg;
    ex_regwrite <= regwrite;
    rrs1 <= rs1;
    rrs2 <= rs2;
    rrwrite <= rwrite;
    ex_mac <= mac;
    ex_dest_reg <= dest_reg;
    //ex_branched_PC <= branched_PC;
    //ex_pcsr <= pcsr;
    end
    
endmodule
