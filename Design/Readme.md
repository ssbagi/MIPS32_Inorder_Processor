**Design**

The design of RISC - MIPS32 Architecture 5 stage In-Order Pipeline using Verilog. 

The features of MIPS32 Architecture : 
1. 32 General Purpose Registers R0 to R31. Each is of 32-bit wide register.
2. The Register R0 by default stores value 0.
3. The PC (Program Counter) is of 32-bit wide. The use of PC is to point to the Next Instruction.
4. In this we are not having any Flag registers for indicating Sign, Carry, Zero, Overflow.
5. We need to verify the addressing modes. As we know Only Load and Store instructions can access Memory.
6. These are Word-Addressable 32 bit.

**Instruction Encoding**
We have three groups based on encoding 
1. R - type (Register type)
2. I - type (Immediate type)
3. J - type (Branch type)
4. Halt instruction.

Opcode   : 6-bit wide.
Register : Since we have 32 in count. We need 5 bit.

**R - Type Instruction Encoding**
The format is as follows : 

Opcode | RS1 | RS2 | RD | SHAMT | FUNCT

Image : 
![image](https://github.com/user-attachments/assets/092f50f5-fe74-4b32-8007-fc66846b3fd3)


Source Link : https://archive.nptel.ac.in/courses/106/105/106105165/ or https://drive.google.com/file/d/1-0O5PUyjsfL1QBoZxHBzORX9himwXR6y/view

Opcode : 6bit wide. The total number of operations avaialble is 2^6 = 64 Instructions are available. 
RS1    : 5bit wide. Source Register 1.
RS2    : 5bit wide. Source Register 2.
SHAMT  : 5bit wide. Shift Amount.
RD     : 5bit wide. Destination Register.
FUNCT  : 6bit wide. Opcode extension. 

The opcode coding used here for designing is as follows : 
INSTRUCTION        |    OPCODE
ADD                     6'b000000
SUB                     6'b000001
AND                     6'b000010
OR                      6'b000011
SLT                     6'b000100
MUL                     6'b000101
HLT                     6'b111111
LW                      6'b001000
SW                      6'b001001
ADDI                    6'b001010
SUBI                    6'b001011
SLTI                    6'b001100
BNEQZ                   6'b001101
BEQZ                    6'b001110

I have not exploted all the bits of tyhe opcode this as part of learning only encoded few only. 

Example : Generally we write a code in C or C++. As we know the compiler converts the High-level code to assembly level. Then these assembly level is converted to binary codes. Showing below is small example 

In C/C++ : result = a - b;
  Now compiler converts to following one. Below you can see in assembly we are using Source Register and Destination register.  
Assembly : sub r5, r12, r25; // R5 = R12 - R25.
Binary code : The following is understood by the MIPS32 CPU core Pipeline block. The above assembly code is converted as follows : 
0x05992800

**I - Type Instruction Encoding**
Immediate Instruction. 

OPCODE  |  RS  |  RD  | Immediate Data

Image : 
![image](https://github.com/user-attachments/assets/e2e8458c-b401-4199-9244-3c9021a6a0c6)


Source Link : https://archive.nptel.ac.in/courses/106/105/106105165/ or https://drive.google.com/file/d/1-0O5PUyjsfL1QBoZxHBzORX9himwXR6y/view

Opcode : 6bit wide.
RS     : 6bit wide. Source Register.
RD     : 6bit wide. Destination Register.
Immediate data : 16bit wide. 


**J - Type Instruction Encoding**
Jump Instruction.

OPCODE  |  Immediate data

Image : 
![image](https://github.com/user-attachments/assets/04069043-d252-4e84-94b4-1868588b1eae)

Source Link : https://archive.nptel.ac.in/courses/106/105/106105165/ or https://drive.google.com/file/d/1-0O5PUyjsfL1QBoZxHBzORX9himwXR6y/view

Opcode  : 6bit wide. 
Immediate data  : 26bit wide. The Jump offset is caclcuated. By adding PC + offset = Branch Target address.

**Instruction Cycle**
1. Instruction Fetch   : The instructions pointed by PC is fetched from I - cache. At this stage we cacluate next PC address also.
2. Instruction Decode  : We segregate the fields of instructions as Opcode, Register, Immediate field.
3. Execute             : We have ALU block for doing operations.
4. Memory Access       : The load and store Instructions access the memory to load the data or store the data.
5. Register Write back : We update our Register File block at the end of the cycle.


 
