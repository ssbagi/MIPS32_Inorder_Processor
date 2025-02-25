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
  
  ![image](https://github.com/user-attachments/assets/535a0c03-35d9-47c5-ba10-9d4fec7cf36b)
  
  At time 187ns we see instead of the branch going to loop we are executing the Store operation due to branch misprediction. So, in next fetch cycle it is executing back to branch instruction.
  Every time the branch is getting executed, we are having misprediction and next instruction is getting loaded into the fetch cycle. In the following screenshot for every time an Branch Instruction
  is getting executed then Store instruction is getting executed which it should not have been executed. What if there is different instruction that is ALU operation happening and manipulationg
  the values of Register R2, R3. 

  ![Branch_Misprediction_2](https://github.com/user-attachments/assets/a4f7b1ce-fa8a-493d-a214-4bbe5c986417)

  ![Branch_Misprediction_3](https://github.com/user-attachments/assets/a533990a-9180-4eff-b96b-24fe1ce84a4c)

  ![Branch_Misprediction_4](https://github.com/user-attachments/assets/17bdbd00-8d84-4152-a0b6-a069871c4a2e)

  Resolution is whenever we are having branch, we fetch next instruction to be NOP operation type. In the below screenshot you can observe that the highlighted in Yellow color is NOP operation.
  NOP Instruction : 0xF800_0000.
  
  ![image](https://github.com/user-attachments/assets/153aa029-e9fd-4b4c-939f-bd45b6ebeaa0)

  

  


   
  

   











