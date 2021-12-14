`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2021 13:18:00
// Design Name: 
// Module Name: if_id
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


module if_id(
    input clk,
    input [31:0] PC,
    input [31:0] instruction_code,
    output reg [31:0] id_PC,
    output reg [31:0] id_inst_code
    );
    
/*    always @(*)
    begin
    if (clk & stall_signal)
        begin
            id_inst_code <= 32'h00000033;
            id_PC <= 32'b0;
        end
    end*/
    
    
    always@(posedge clk)
    begin
  //  case (stall_signal)
   // 1'b0: begin
            id_PC<=PC;
            id_inst_code <= instruction_code; 
     //     end
/*    1'b1: begin
            id_inst_code <= 32'h00000033;
            id_PC <= 32'b0;
          end*/
    //endcase
/*        if (stall_signal)
            begin
                id_inst_code <= 32'h00000033;
                id_PC <= 32'b0;
            end
        else*/
            //begin
               // id_PC<=PC;
                //id_inst_code <= instruction_code; 
            //end
    
    end
endmodule
