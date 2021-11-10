`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2021 19:45:22
// Design Name: 
// Module Name: tb
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


module tb();
reg clk, reset;

main m1(clk, reset);

initial begin
clk = 0;
forever #5 clk <= ~clk;
#20 $finish;
end

initial begin
reset <= 1;
#7 reset <=0;
end
endmodule
