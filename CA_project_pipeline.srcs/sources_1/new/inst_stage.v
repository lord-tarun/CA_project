`timescale 1ns / 1ps

module inst_stage (input clk, input reset, output [31:0] PC, //input [31:0] new_PC, 
output [31:0] instruction_code
, input [31:0] branched_PC , input pcsrc
);
wire [31:0] internal_PC;

new_PC p1(clk,reset,pcsrc, branched_PC,internal_PC);

instruction_mem m1(internal_PC,reset,instruction_code);

assign PC = internal_PC;
endmodule

module new_PC(input clk, input reset,input pcsrc, input [31:0] branched_PC, output reg [31:0] internal_PC);

always @ (posedge clk)
begin
        if (reset == 1)
            internal_PC =0;
        else 
        if (pcsrc == 1)
            internal_PC = branched_PC; 
            else
            internal_PC = internal_PC+4;
end

endmodule

module instruction_mem(input [31:0] PC, input reset, output [31:0] instruction_code);
reg [7:0] mem [80:0];

assign instruction_code={mem[PC+3],mem[PC+2],mem[PC+1],mem[PC]};

always@(reset)
    begin
        if (reset==0)
            $readmemh("instruction.mem", mem);
        end

endmodule