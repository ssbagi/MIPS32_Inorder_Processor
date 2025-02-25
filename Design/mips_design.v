/*
  MIPS32 Architecture 
  In Order Pipeline executing in program order.
  5 Stage In Order Pipeline. 
*/

module pipe_MIPS32 (clk1, clk2, reset); 
  input clk1, clk2, reset;     
  // Two-phase clock. The Pipeline stages are clocked by two phases. Alternate clk for each Flip-flops. 
  reg [31:0] PC, IF_ID_IR, IF_ID_NPC; 
  reg [31:0] ID_EX_IR, ID_EX_NPC, ID_EX_A, ID_EX_B, ID_EX_Imm; 
  reg [2:0]  ID_EX_type, EX_MEM_type, MEM_WB_type; 
  reg [31:0] EX_MEM_IR, EX_MEM_ALUOut, EX_MEM_B; 
  reg        EX_MEM_cond; 
  reg [31:0] MEM_WB_IR, MEM_WB_ALUOut, MEM_WB_LMD; 

  reg [31:0] Reg [0:31];   
  reg [31:0] Mem [0:1023];  

// Register bank (32 x 32) 
// 1024 x 32 memory 

// Opcodes : 6bit . 64 opcodes possible. 
parameter ADD=6'b000000, SUB=6'b000001, AND=6'b000010, OR=6'b000011, SLT=6'b000100, MUL=6'b000101, HLT=6'b111111, LW=6'b001000,  SW=6'b001001, ADDI=6'b001010, SUBI=6'b001011,SLTI=6'b001100, BNEQZ=6'b001101, BEQZ=6'b001110, NOP=6'b111110;

// Instruction Type
parameter RR_ALU=3'b000, RM_ALU=3'b001, LOAD=3'b010, STORE=3'b011, BRANCH=3'b100, HALT=3'b101; NOPOP=3'b110;
reg HALTED; // Set after HLT instruction is completed (in WB stage) 
reg TAKEN_BRANCH;  // Required to disable instructions after branch

// PC = Program Counter is Word-addressable. PC + 1. Word here is 32bit.

/* 
IF Stage : 
*/
always @(posedge clk1)       
    if (HALTED == 0)
    // No Halt Instruction. 
    begin
      if (((EX_MEM_IR[31:26] == BEQZ) && (EX_MEM_cond == 1)) || ((EX_MEM_IR[31:26] == BNEQZ) && (EX_MEM_cond == 0))) 
        begin 
          IF_ID_IR     <= #2 Mem[EX_MEM_ALUOut]; 
          TAKEN_BRANCH <= #2 1'b1; 
          IF_ID_NPC    <= #2 EX_MEM_ALUOut + 1; 
          PC           <= #2 EX_MEM_ALUOut + 1; 
          /*
          Basically In J-Type Instructions we compute the Target address from ALU and then From Icache or Imem we refer that address and extract the instruction from the cache. 
          Assuming the address and instruction is already available in I cache. 
          Target Address Cacluated in EX stage. It is EX_MEM_ALUOut.
          */
        end 

      // Synchrnous Reset.
      else if (reset == 1)
        begin
          // Reset the PC to 0. 
          PC <= #2 0;
        end

      else 
        begin 
          // Not a branch instruction. Normal Instruction in program order.
          // Fetching my Instruction 
          IF_ID_IR     <= #2 Mem[PC]; 
          TAKEN_BRANCH <= #2 1'b0;
          IF_ID_NPC    <= #2 PC + 1; 
          PC           <= #2 PC + 1;
        end
    end
    
/* 
Decode Stage :
In this stage we calculate the source and destination registers.
We also calculate the immediate value for I-type instructions.
*/
always @(posedge clk2)        
    if (HALTED == 0) 
    begin 
        //Source Register decode.
        if (IF_ID_IR[25:21] == 5'b00000)  
          ID_EX_A <= 0; 
        else 
          ID_EX_A     <=  #2 Reg[IF_ID_IR[25:21]];  // "rs"
         
        //Destination Register decode.
        if (IF_ID_IR[20:16] == 5'b00000)  
          ID_EX_B <= 0; 
        else 
          ID_EX_B     <=  #2 Reg[IF_ID_IR[20:16]];  // "rt" 
        
        //Forwarding to next stage the values.
        ID_EX_NPC   <=  #2 IF_ID_NPC; 
        ID_EX_IR    <=  #2 IF_ID_IR; 

        // Immediate value is 16-bit. The sign-extension for 16-bit to 32-bit.
        ID_EX_Imm   <=  #2 {{16{IF_ID_IR[15]}}, {IF_ID_IR[15:0]}}; 
        
        /* 
        Opcode decoding : We will use following as FSM state type.
        In Branch decoded I want next fetch to be of NOP operation instead of the next instruction. Hence below flag is set.
        */
        case (IF_ID_IR[31:26]) 
            ADD,SUB,AND,OR,SLT,MUL : ID_EX_type <= #2 RR_ALU; 
            ADDI,SUBI,SLTI         : ID_EX_type <= #2 RM_ALU; 
            LW                     : ID_EX_type <= #2 LOAD;                    
            SW                     : ID_EX_type <= #2 STORE;                    
            BNEQZ,BEQZ             : ID_EX_type <= #2 BRANCH;        
            HLT                    : ID_EX_type <= #2 HALT;                   
        endcase
    end 

// EX Stage : Execute Stage.
always @(posedge clk1)        
    if (HALTED == 0) 
    begin 
        EX_MEM_type <= #2 ID_EX_type; 
        EX_MEM_IR   <= #2 ID_EX_IR; 
        TAKEN_BRANCH <= #2 1'b0; 
        case (ID_EX_type) 
            // Source Operands are Two Register. R-Type Instructions.
            RR_ALU:  begin 
                case (ID_EX_IR[31:26])  // "opcode" 
                    ADD:     EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_B; 
                    SUB:     EX_MEM_ALUOut <= #2 ID_EX_A - ID_EX_B;
                    AND:     EX_MEM_ALUOut <= #2 ID_EX_A & ID_EX_B;
                    OR:      EX_MEM_ALUOut <= #2 ID_EX_A | ID_EX_B;
                    SLT:     EX_MEM_ALUOut <= #2 ID_EX_A < ID_EX_B;
                    MUL:     EX_MEM_ALUOut <= #2 ID_EX_A * ID_EX_B;
                    default: EX_MEM_ALUOut <= #2 32'hxxxxxxxx; 
                endcase 
                end 

            // I-Type Instructions.
            RM_ALU:  begin 
                case (ID_EX_IR[31:26])  // "opcode" 
                        ADDI: EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_Imm;     
                        SUBI: EX_MEM_ALUOut <= #2 ID_EX_A - ID_EX_Imm;    
                        SLTI: EX_MEM_ALUOut <= #2 ID_EX_A < ID_EX_Imm;    
                        default: EX_MEM_ALUOut <= #2 32'hxxxxxxxx;  
                endcase 
                end 

            //Computing the Target address where to load or store. 
            LOAD, STORE: begin 
                    EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_Imm; 
                    EX_MEM_B      <= #2 ID_EX_B; 
                    end 

            //Computing the Target address for the branch.
            BRANCH: begin
                    // Target Address is calculated and stored in the EX_MEM_ALUOut. 
                    EX_MEM_ALUOut <= #2 ID_EX_NPC + ID_EX_Imm;
                    // Condition for the branch instruction.
                    EX_MEM_cond  <= #2 (ID_EX_A == 0) ? 1 : 0; 
                    end 
            
            //For NOP instruction. I am saying that my values in execute stage needs to remain same as previous stage.
            NOPOP: begin
                    EX_MEM_ALUOut <= #2 EX_MEM_ALUOut;
                    end
        endcase
    end


// MEM Stage 
always @(posedge clk2)        
    if (HALTED == 0) 
    begin 
        MEM_WB_type <= EX_MEM_type; 
        MEM_WB_IR   <= #2 EX_MEM_IR; 
        case (EX_MEM_type) 
            RR_ALU, RM_ALU : MEM_WB_ALUOut <= #2 EX_MEM_ALUOut;
            // Load the contents refered from above Execute stage.
            LOAD           : MEM_WB_LMD         <= #2 Mem[EX_MEM_ALUOut]; 
            // Store the contents into the address calculated from ALU.
            STORE          : if (TAKEN_BRANCH == 0)   // Disable write  
                                Mem[EX_MEM_ALUOut] <= #2 EX_MEM_B;
            // In the MEM stage I don't have any operation to perform for Branch, Halt and NOP instructions.
        endcase 
    end

// WB Stage
always @(posedge clk1)        
    begin 
    /*
    Based on the Instruction (R-type or I-type) format. The destination register differs.
    */
    if (TAKEN_BRANCH == 0)   
        case (MEM_WB_type) 
            RR_ALU:  Reg[MEM_WB_IR[15:11]] <= #2 MEM_WB_ALUOut; // "rd" 
            RM_ALU:  Reg[MEM_WB_IR[20:16]] <= #2 MEM_WB_ALUOut; // "rt"  
            LOAD:    Reg[MEM_WB_IR[20:16]] <= #2 MEM_WB_LMD; // "rt"
            HALT:    HALTED <= #2 1'b1; // Halt the pipeline.
        endcase 
    end 
endmodule


 
 



