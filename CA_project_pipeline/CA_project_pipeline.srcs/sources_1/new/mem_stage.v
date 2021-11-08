`timescale 1ns / 1ps

module mem_stage(input reset, input [31:0] address, input memread, input memwrite,input [31:0] write_data , 
output reg [31:0] read_data);
reg [7:0] dm [60:0];
always@*
begin
if(reset==1)
$readmemh("data.mem",dm);
else
begin
if(memwrite==1)
{dm[address+3],dm[address+2],dm[address+1],dm[address]}=write_data;
else if(memread==1)
read_data={dm[address+3],dm[address+2],dm[address+1],dm[address]};
end
end
endmodule