# CA_project

RISC V RTL Implementation with MAC unit : In addition to the normal five stage RISC-V pipeline (Fetch, Decode, Execute and Writeback), there is a MAC unit that is in parallel to the ALU stage. Seperate instruction has been defined for the MAC usage.
 
1. Top Module is main.v
2. Test-Bench is tb.v
3. Memory Files are *mem files
4. Binary of Code to be implemented is in "instruction.mem"
5. The data values are stored in "data.mem"

### Execution Details ::
1. To execute user's binary, simply add your codes(bytes) in "instruction.mem"
2. If using load/store instructions, please modify "data.mem".
