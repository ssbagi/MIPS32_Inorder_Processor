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
Assembler : Converts to Binary format. 
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


# Testcase Scenarios

## Scenario 1 : Branch Instruction.

The MIPS32 is basic 5 stage In-Order Pipeline. Genrally, we know for Branch Instruction we get our Target address from Execute stage (i.e., from ALU calculation). 
In the following we observed a stange issue : 
- When we were executing the Conditional branch instruction we observed that in when branch is in execute stage and the pipeline is Fetching every time the next instruction of the program was getting loaded.
- By the time there is target address calculation in he execute stage there is a Instruction getting loaded in Fetch stage and it goes on further executing in the pipeline.
- This can lead a lot of problems. As explained below.

  ### Why ?

  - Assume in the branch loop we are executing R1 register now somehow branch misprediction happened and in the pipeline, it loaded next instruction.
  - Now, Mury's law comes into play thinking that this next instruction is changing value of R1. So, to resolve we have following options.

  **Resolution :**
  - OOO Processor Approach : Add the Branch Target Buffer (BTB) and Branch Predictor in between the Fetch and Execute stage.
  - Compiler               : When executing the code ask the compiler to introduce the NOP operation.
  - Hardware Bubble / NOP  : Whenever we see the branch instruction we will add NOP operation from the design itself.
  - Stall                  : Add a Stall instruction.

  Stall Instruction :

  ![image](https://github.com/user-attachments/assets/ac32b26c-251e-4d31-9f9c-11165be2040b)

  NOP : The assembly instruction

  ![image](https://github.com/user-attachments/assets/ee430b92-51ee-4510-bda9-7efba9d45fdd)


  Difference between Stall and Bubble : 
  - The stall means keep in the same state or previous state only. Not propagating the latest changes or input.
  - Bubble means introducing the nop instruction dynamically.
  
  ![image](https://github.com/user-attachments/assets/88453bfc-a9aa-4d2b-901e-47e41315bee3)


  For explaing above case scenario :

  Assembly code :
  
  ![image](https://github.com/user-attachments/assets/0f946588-d314-4648-87f1-bde86b095e91)

  Branch Instruction : 0x3460_FFFC
  Store  Instruction : 0x2542_FFFE
  LOOP   Instruction : 0x1443_1000

  For RAW dependency we are adding dummy instruction in between the True dependency instruction. 
  
  In the following screenshot we observe the Branch Instruction is 0x3460_FFFC is going from Fetch to Write back stage. The Target address is calculated in the Execute stage.
  
  ![Branch_Misprediction_1](https://github.com/user-attachments/assets/6fc87f8c-f53d-4489-978f-2f909f453e59)

  At time 187ns we see instead of the branch going to loop we are executing the Store operation due to branch misprediction. So, in next fetch cycle it is executing back to branch instruction.
  Every time the branch is getting executed, we are having misprediction and next instruction is getting loaded into the fetch cycle. In the following screenshot for every time an Branch Instruction
  is getting executed then Store instruction is getting executed which it should not have been executed. What if there is different instruction that is ALU operation happening and manipulationg
  the values of Register R2, R3. 

  ![Branch_Misprediction_2](https://github.com/user-attachments/assets/a4f7b1ce-fa8a-493d-a214-4bbe5c986417)

  ![Branch_Misprediction_3](https://github.com/user-attachments/assets/a533990a-9180-4eff-b96b-24fe1ce84a4c)

  ![Branch_Misprediction_4](https://github.com/user-attachments/assets/17bdbd00-8d84-4152-a0b6-a069871c4a2e)

  Resolution is whenever we are having branch, we fetch next instruction to be NOP operation type. In the below screenshot you can observe that the highlighted in Yellow color is NOP operation.
  NOP Instruction : 0xF800_0000.

  ![Branch_Misprediction_5_NOP_Insertion](https://github.com/user-attachments/assets/10c44d9b-2934-4d17-a6f7-4e4460c36e7a)

  At the end the HLT instruction is getting executed and Halting the processor or Pipeline execution.
  ![HALT_AT_END_EXECUTION](https://github.com/user-attachments/assets/99906a46-46d5-4bd3-8c84-319a8cecdeb7)


 
