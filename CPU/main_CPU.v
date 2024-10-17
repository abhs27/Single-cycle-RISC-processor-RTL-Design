module SingleCycleCPU (
    input clk,
    input start
    
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,

wire PCin
wire PC_to_IM;
wire PC4;
wire PCbranch;
wire instruction;
wire ALUcntrl;
wire ALUresult;
wire zero;
wire DataRead;
wire DataWritten;
wire memtoReg;


PC m_PC(+
    .clk(clk),
    .rst(start),
    .pc_i(PCin),
    .pc_o(PC_to_IM)
);


//adder for incrementing the PC by 4
Adder m_Adder_1(
    .a(PC_to_IM),
    .b(#4),
    .sum(PC4)
);

InstructionMemory m_InstMem(
    .readAddr(PC_to_IM),
    .inst(instruction)
);

Control m_Control(
    .opcode(),
    .branch(),
    .memRead(),
    .memtoReg(memtoReg),
    .ALUOp(),
    .memWrite(),
    .ALUSrc(),
    .regWrite()
);


Register m_Register(
    .clk(),
    .rst(start),
    .regWrite(),
    .readReg1(),
    .readReg2(),
    .writeReg(),
    .writeData(),
    .readData1(),
    .readData2()
);


ImmGen #(.Width(32)) m_ImmGen(
    .inst(),
    .imm()
);

ShiftLeftOne m_ShiftLeftOne(
    .i(),
    .o()
);

Adder m_Adder_2(
    .a(),
    .b(),
    .sum()
);


//MUX to decide whether PC increments by 4 or branches
Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(),
    .s0(),
    .s1(),
    .out()
);

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(),
    .s0(),
    .s1(),
    .out()
);

ALUCtrl m_ALUCtrl(
    .ALUOp(),
    .funct7(),
    .funct3(),
    .ALUCtl()
);

ALU m_ALU(
    .ALUctl(ALUcntrl),
    .A(),
    .B(),
    .ALUOut(ALUresult),
    .zero(zero)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUresult),
    .writeData(),
    .readData(DataRead)
);

Mux2to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(ALUresult),
    .s1(DataRead),
    .out(DataWritten)
);

endmodule
