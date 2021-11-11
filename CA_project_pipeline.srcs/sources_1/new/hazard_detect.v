`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2021 14:58:51
// Design Name: 
// Module Name: hazard_detect
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


module hazard_detect(input mem_regwrite, input [4:0] mem_rrwrite, wb_rrwrite ,rrs1, rrs2, input wb_regwrite, output reg [1:0] sel1,
output reg [1:0] sel2);

always@(*)
begin 
// Execution stage Hazard
if ((mem_regwrite == 1) & (mem_rrwrite != 5'b0) & (mem_rrwrite == rrs1))
sel1 = 2'b01;
else if ((mem_regwrite == 1) & (mem_rrwrite != 5'b0) & (mem_rrwrite == rrs2))
sel2 = 2'b01;
// Memory Hazard
else if ((wb_regwrite ==1)& (wb_rrwrite != 5'b0) & (wb_rrwrite == rrs1) &
!((mem_regwrite == 1) & (mem_rrwrite != 5'b0) & (mem_rrwrite == rrs1)))
sel1 = 2'b10;
else if ((wb_regwrite ==1)& (wb_rrwrite != 5'b0) & (wb_rrwrite == rrs2) &
!((mem_regwrite == 1) & (mem_rrwrite != 5'b0) & (mem_rrwrite == rrs2)))
sel2 = 2'b10;

else // No hazard
begin
sel1 = 2'b00;
sel2 = 2'b00;
end

end
endmodule
