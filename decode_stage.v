`timescale 1ns / 1ps

module decode_stage (input clk, input reset, input [31:0] instruction_code , output [31:0] out_reg1, output [31:0] out_reg2, 
output [31:0] imm_data, output alusrc, output memtoreg, output memread,output memwrite, 
output branch,
input [31:0]PC, output [31:0] branched_PC, output pcsrc,
input [31:0] writetoreg,
output [2:0]alu_ctrl, input regwrite, input [4:0] write_reg, output [4:0] next_write_reg, output next_regwrite, input stall_signal, 
output mac, output [31:0] dest_reg ); 
//Next_write_reg puts the register value in 
// pipeline.

wire [11:0] imm;
wire [1:0] imm_sel;
//wire branch;
// Control Signal module
control_unit c1(instruction_code, alusrc, memtoreg, memread,next_regwrite, memwrite, alu_ctrl,branch, imm_sel, stall_signal,
 mac);
 
 // Changes post pipeline - Give [7:11] value to register and not write into it, take write reg value from writeback stage
assign next_write_reg = instruction_code[11:7];

// Register read and write
in_register i1(reset,instruction_code[19:15],instruction_code[24:20], regwrite,write_reg ,writetoreg,out_reg1,out_reg2,
 mac, dest_reg, next_write_reg);

// Selecting 12 bit data for immediate
imm_sel_mux m1(instruction_code[20],instruction_code[7],instruction_code[8] , imm_sel,imm[0] );
imm_sel_mux m2(instruction_code[21],instruction_code[8],instruction_code[9] , imm_sel,imm[1] );
imm_sel_mux m3(instruction_code[22],instruction_code[9],instruction_code[10], imm_sel,imm[2] );
imm_sel_mux m4(instruction_code[23],instruction_code[10],instruction_code[11],imm_sel,imm[3] );
imm_sel_mux m5(instruction_code[24],instruction_code[11],instruction_code[25],imm_sel,imm[4] );
imm_sel_mux m6(instruction_code[25],instruction_code[25],instruction_code[26],imm_sel,imm[5] );
imm_sel_mux m7(instruction_code[26],instruction_code[26],instruction_code[27],imm_sel,imm[6] );
imm_sel_mux m8(instruction_code[27],instruction_code[27],instruction_code[28],imm_sel,imm[7] );
imm_sel_mux m9(instruction_code[28],instruction_code[28],instruction_code[29],imm_sel,imm[8] );
imm_sel_mux m10(instruction_code[29],instruction_code[29],instruction_code[30],imm_sel,imm[9] );
imm_sel_mux m11(instruction_code[30],instruction_code[30],instruction_code[7],imm_sel,imm[10] );
imm_sel_mux m12(instruction_code[31],instruction_code[31],instruction_code[31],imm_sel,imm[11] );

// Sign- Extending bits 
bit_extend b1(imm,imm_data);

// Predicting branch (beq  in decode stage)

/*reg [31:0] xor_out;
reg zero;

always @(*)
begin
    if (branch)
    begin
        xor_out = out_reg1 ^ out_reg2;
        if (!xor_out)
            zero = 1; 
    end
end
*/
//nextPC n1(PC,imm_data, branch, zero, branched_PC, pcsrc);
endmodule



module in_register(input reset,input [4:0] read_reg1, input [4:0] read_reg2, input regwrite, 
input [4:0] write_reg, input [31:0] write_value,output [31:0] reg1, output [31:0] reg2,
 input mac, output [31:0] dest_reg , input [4:0] next_write_reg);
 
 //P.S - next_write_reg signal is only for MAC operations where we need to read the contents of destination register.
 // In normal pipeline, we write into the registers value coming from MEM/WB pipeline register and not the 
 // [11:7] register.

reg [31:0] registers [31:0];

always @(reset)
begin
if (reset == 1)
$readmemh ("register.mem", registers);
end

assign reg1 = registers[read_reg1];
assign reg2 = registers[read_reg2];

assign dest_reg = registers[next_write_reg]; // For MAC only

always@(regwrite, write_reg, write_value)
    begin
     if (regwrite ==1)
    registers[write_reg] = write_value;
    end
endmodule

module imm_sel_mux(input in1, input in2, input in3, input [1:0] imm_sel, output reg imm_data );
always@(in1 or in2 or in3 or imm_sel)
begin
    case(imm_sel)
    2'b00:imm_data <= in1;
    2'b01:imm_data <= in2;
    2'b10:imm_data <= in3;
    2'b11:imm_data <= 2'bxx;
    endcase
end        
endmodule

module control_unit(input [31:0] ins_code, output reg alusrc, output reg memtoreg, output reg mem_read,
output reg regwrite, output reg mem_write, output reg [2:0] alu_ctrl, output reg branch, output reg [1:0] imm_sel, 
input stall_signal, output reg mac);
always@(ins_code)
begin
if (stall_signal)
    begin
        	alusrc<=1'b0;
			memtoreg <= 1'b0;
			mem_read<=1'b0; 
			regwrite<=1'b0; 
			mem_write<=1'b0;
			branch<=1'b0;
			imm_sel <= 2'b00;
	        alu_ctrl <= 3'b000;
	        mac <= 1'b0;        
    end
else
begin
    case(ins_code[6:2])
    5'b01100:begin // Register type
			alusrc=1'b0;
			memtoreg = 1'b0; 
			mem_read=1'b0;
			regwrite=1'b1; 
			mem_write=1'b0;
			branch=1'b0;
			imm_sel = 2'bxx;
		    mac = 1'b0;        
            case(ins_code[14:12])
                3'b001: alu_ctrl = 3'b010;
                3'b101: alu_ctrl = 3'b011;
                3'b111: alu_ctrl = 3'b100;
                3'b110: alu_ctrl = 3'b101; 
			    3'b000: alu_ctrl=ins_code[30]?3'b001:3'b000; 
			endcase
			end
    5'b00100:begin // Immediate 
			alusrc=1'b1;
			memtoreg = 1'b0;
			mem_read=1'b0; 
			regwrite=1'b1; 
			mem_write=1'b0;
			branch=1'b0;
			imm_sel = 2'b00;
			mac = 1'b0;
	        alu_ctrl = 3'b000; // As only addi needs to be executed
			end
    5'b00000:begin // Load
			alusrc=1'b1; 
			memtoreg = 1'b1; 
			mem_read=1'b1; 
			regwrite=1'b1; 
			mem_write=1'b0;
			branch=1'b0; 
			imm_sel = 2'b00;
			mac = 1'b0;
			alu_ctrl=3'b000;
			end
    5'b01000:begin // Store
			alusrc=1'b1;
			memtoreg = 1'b0; 
			mem_read=1'b0; 
			regwrite=1'b0; 
			mem_write=1'b1;
			branch=1'b0; 
			imm_sel = 2'b01;
			alu_ctrl=3'b000;
			mac = 1'b0;
			end
    5'b11000:begin // Branch
			alusrc=1'b0; 
			memtoreg=1'bx; 
			mem_read=1'b0; 
			regwrite=1'b0; 
			mem_write=1'b0; 
			alu_ctrl=3'b001; 
			imm_sel = 2'b10;
			branch=1'b1;
			mac = 1'b0;
			end
	5'b11111: begin
	        //alusrc=1'b0;
			memtoreg = 1'b0; 
			mem_read=1'b0;
			regwrite=1'b1; 
			mem_write=1'b0;
			branch=1'b0;
			imm_sel = 2'bxx;
		    mac = 1'b1;      
	        end
    endcase
end
end
endmodule


module bit_extend(input [11:0] imm, output reg [31:0] imm_data);
always @(imm)
begin
    case(imm[11])
    1'b1: imm_data = {20'b1, imm};
    1'b0: imm_data = {20'b0, imm};
    endcase
end
endmodule