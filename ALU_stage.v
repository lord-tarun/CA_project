`timescale 1ns / 1ps

module ALU_stage(input [31:0] read_reg1, input [31:0] read_reg2, input [31:0] imm_data, 
input alu_src, input [2:0] alu_ctrl,output[31:0] alu_out // do not comment these signals
, input [31:0] PC, input branch, output [31:0] branched_PC, output pcsrc);

wire [31:0]alu_data2;
wire zero_flag;

ALU_mux m1(read_reg2, imm_data, alu_src,alu_data2);

ALU a1(read_reg1,alu_data2,alu_ctrl,alu_out,zero_flag );

nextPC n1(PC,imm_data, branch, zero_flag, branched_PC, pcsrc
); 
endmodule


module ALU_mux(input [31:0] read_reg2, input [31:0] imm_data, input alu_src, output reg [31:0]alu_data2);
always @(read_reg2 or imm_data or alu_src)
begin
    case(alu_src)
    1'b0: alu_data2 = read_reg2;
    1'b1: alu_data2 = imm_data;
    endcase
end
endmodule

module ALU(input [31:0] a, input [31:0] b, input[2:0] ctrl,output reg[31:0] out, output reg zero_flag);
	 
always@(ctrl,a,b)
begin
case(ctrl)
3'b000: out=a+b;
3'b001: out=a-b;
3'b010: out=a<<b;
3'b011: out=a>>b;
3'b100: out=a>>>b;
default: out=32'bx;
endcase
end

always @(out)
begin
    case(out)
    32'b0: zero_flag = 1;
    default: zero_flag = 0;
    endcase
end

endmodule


module nextPC(input [31:0] PC, input [31:0]imm, input branch, input zero_flag, output [31:0] branched_PC,
 output pcsrc
// output [31:0] newPC 
);

wire [31:0] new_imm;
assign new_imm = imm<<1;
assign branched_PC = PC+ new_imm;
// PCSRC = 1, then branched PC, else +4
assign pcsrc = zero_flag & branch;
endmodule