`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.12.2021 11:39:18
// Design Name: 
// Module Name: forwarding_check
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


module forwarding_check(input mem_regwrite, input [4:0] mem_rrwrite, wb_rrwrite ,rrs1, rrs2, input wb_regwrite, output reg [1:0] sel1,
output reg [1:0] sel2,
input memread);

always@(*)
begin 
// Execution Writeback
if ((mem_regwrite == 1) & (mem_rrwrite != 5'b0) & (mem_rrwrite == rrs1))
sel1 = 2'b01;
else if ((mem_regwrite == 1) & (mem_rrwrite != 5'b0) & (mem_rrwrite == rrs2))
sel2 = 2'b01;

// Memory Writeback
else if ((wb_regwrite ==1)& (wb_rrwrite != 5'b0) & (wb_rrwrite == rrs1) & (memread) &
!((mem_regwrite == 1) & (mem_rrwrite != 5'b0) & (mem_rrwrite == rrs1)))
sel1 = 2'b10;
else if ((wb_regwrite ==1)& (wb_rrwrite != 5'b0) & (wb_rrwrite == rrs2) & (memread) &
!((mem_regwrite == 1) & (mem_rrwrite != 5'b0) & (mem_rrwrite == rrs2)))
sel2 = 2'b10;

// Writeback Hazard
else if ((wb_regwrite ==1)& (wb_rrwrite != 5'b0) & (wb_rrwrite == rrs1) &
!((mem_regwrite == 1) & (mem_rrwrite != 5'b0) & (mem_rrwrite == rrs1)))
sel1 = 2'b11;
else if ((wb_regwrite ==1)& (wb_rrwrite != 5'b0) & (wb_rrwrite == rrs2) &
!((mem_regwrite == 1) & (mem_rrwrite != 5'b0) & (mem_rrwrite == rrs2)))
sel2 = 2'b11;

else // No hazard
begin
sel1 = 2'b00;
sel2 = 2'b00;
end

end
endmodule