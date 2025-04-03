module SingleCycleCPU (
    input clk,
    input start,
output wire [31:0]PCin,
output wire [31:0]PC_to_IM,
output wire [31:0]instruction,
output wire [31:0]readData1,
output wire [31:0]readData2,
output wire signed [31:0]immval,
output wire [31:0]ALUresult,
output wire branchctl,
output wire [31:0]PC4,
output wire [3:0]ALUcntrl,
output wire zero,
output wire [31:0]DataRead,
output wire [31:0]DataWritten,
output wire memRead,
output wire [1:0] regsrc,
output wire [1:0]ALUOp,
output wire memWrite,
output wire ALUSrc,
output wire regWrite,
output wire [31:0]branchoff,
output wire [31:0]branchval,
output wire [31:0]ALUinB,
output wire ALUmsb,
output wire [31:0] upperimm,
output wire branchselect,
output wire DataReadSized,
output wire PCin_final,
output wire jumpsrc,
output wire ALUsrc1,
output wire [31:0] ALUinA
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,


//-----------LIST OF ALL THE WIRES-------------------

//wire [31:0]PCin;          input to the PC
//wire [31:0]PC_to_IM ;     output from the OC module
//wire [31:0]PC4;           PC incremented by 4
//wire [31:0]instruction;   instruction fetched from IM
//wire [3:0]ALUcntrl;       ALU control signal
//wire [31:0]ALUresult;     result output from ALU
//wire zero;                zero flag from ALU
//wire [31:0]DataRead;      Data read from DM
//wire [31:0]DataWritten;   data to be written to register

//wire branchctl;           branch signal from the main control unit
//wire memRead;             memread control signal
//wire regsrc;            regsrc control signal for lw
//wire [1:0]ALUOp;          ALUOp signal from main control unit to ALU control unit
//wire memWrite;            memWrite control signal for sw
//wire ALUSrc;              ALUSrc control signal for register or immediate value into ALU
//wire regWrite;            regWrite control signal to write into the register file

//wire [31:0]immval;        immediate value genearted from thr immediate generation block
//wire [31:0]branchoff;     left immediate value shifted by one
//wire [31:0]branchval;     new value to be loaded into PC in case of a branch

//wire [31:0] ALUinA;       muxed output of register or PC value to be inputted into the ALU       
//wire [31:0]ALUinB;        muxed output of register or immediate value to be inputted into the ALU
//wire ALUmsb;              msb of the ALU output used to determine BGT
//wire [31:0]readData1;     rs1 value
//wire [31:0]readData2;     rs2 value
//wire [31:0] upperimm;     immediate loading for LUI
//wire branchselect;        decides between different types of branches
//wire DataReadSized;       data from DM after truncating to correct size depending on lb,lh,lw
//wire PCin_final;          PCin after including possibility of JUMP instruction
//wire jumpsrc;             jump src is either the immediate value or ALU result depending on JAL or JALR
//wire ALUsrc1;             select line for muxing rs1 and PC to ALU

PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(PCin),
    .pc_o(PC_to_IM)
);


//adder for incrementing the PC by 4
Adder m_Adder_1(
    .a(PC_to_IM),
    .b(32'b100),
    .sum(PC4)
);

InstructionMemory m_InstMem(
    .readAddr(PC_to_IM),
    .inst(instruction)
);

Control m_Control(
    .opcode(instruction[6:0]),
    .branch(branchctl),
    .memRead(memRead),
    .regsrc(regsrc),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite),
    .jump(jump),
    .ALUsrc1(ALUsrc1)
);


Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(regWrite),
    .readReg1(instruction[19:15]),
    .readReg2(instruction[24:20]),
    .writeReg(instruction[11:7]),
    .writeData(DataWritten),
    .readData1(readData1),
    .readData2(readData2)
);


ImmGen #(.Width(32)) m_ImmGen(
    .inst(instruction),
    .imm(immval)
);

Mux2to1 #(.size(32)) m_Mux_jump(
        .sel(jump),
        .s0(PCin), //if jump is taken then PCin is obsolete
        .s1(jumpsrc), //branchval = PC + imm, imm here is calculated for jump in this case
        .out(PCin_final)
    );

Mux2to1 #(.size(32)) m_Mux_jumpsrc(
        .sel(instruction[3]), //the bit that differs between JAL and JALR
        .s0(branchval), //if jump is taken then PCin is obsolete
        .s1(ALUresult), //branchval = PC + imm, imm here is calculated for jump in this case
        .out(jumpsrc)
    );
        
ShiftLeftOne m_ShiftLeftOne(
    .i(immval),
    .o(branchoff)
);

Adder m_Adder_2(
    .a(PC_to_IM),
    .b(branchoff),
    .sum(branchval)
);


//MUX to decide whether PC increments by 4 or branches
Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(branchselect & branchctl), // mux logic for selecting BEQ or BGE signal
    .s0(PC4),
    .s1(branchval),
    .out(PCin)
);

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(readData2),
    .s1(immval),
    .out(ALUinB)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(instruction[30]),
    .funct3(instruction[14:12]),
    .ALUCtl(ALUcntrl)
);

ALU m_ALU(
    .ALUCtl(ALUcntrl),
    .A(ALUinA),
    .B(ALUinB),
    .ALUOut(ALUresult),
    .zero(zero),
    .msb(ALUmsb)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUresult),
    .writeData(readData2),
    .readData(DataRead),
    .storesize(instruction[14:12]) //sb,sh,sw implemented in DM
);

Mux4to1 #(.size(32)) m_Mux_WriteData(
    .sel(regsrc),
    .s0(ALUresult),
    .s1(DataRead),
    .s2(PC4),
    .s3(upperimm),
    .out(DataWritten)
);

shift12 shift12(
    .in(immval),
    .out(upperimm)
);


branchsel branchsel(
    .sel(instruction[14:12]), //funct3 is select line
    .zero(zero),
    .msb(ALUmsb),
    .A(readData1),
    .B(readData2),
    .out(branchselect)
);

loadsizemux loadsizemux(
    .in(DataRead),//output from DM
    .sel(instruction[14:12]),//funct3
    .out(DataReadSized)//loaded byte,halfword or word
);

Mux2to1 #(.size(32)) m_MUX_ALUsrc1 (
    .sel(ALUsrc1),
    .s0(readData1),
    .s1(PC),
    .out(ALUinA)
);
endmodule
