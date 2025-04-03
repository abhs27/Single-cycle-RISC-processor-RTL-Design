module tb_riscv_sc;
//cpu testbench

reg clk;
reg start;

wire [31:0]PCin;          //input to the PC
wire [31:0]PC_to_IM ;     //output from the OC module
wire [31:0]PC4;           //PC incremented by 4
wire [31:0]instruction;   //instruction fetched from IM
wire [3:0]ALUcntrl;       //ALU control signal
wire [31:0]ALUresult;     //result output from ALU
wire zero;                //zero flag from ALU
wire [31:0]DataRead;      //Data read from DM
wire [31:0]DataWritten;   //data to be written to register

wire branchctl;           //branch signal from the main control unit
wire memRead;             //memread control signal
wire regsrc;            //regsrc control signal for lw
wire [1:0]ALUOp;          //ALUOp signal from main control unit to ALU control unit
wire memWrite;            //memWrite control signal for sw
wire ALUSrc;              //ALUSrc control signal for register or immediate value into ALU
wire regWrite;            //regWrite control signal to write into the register file

wire [31:0]immval;        //immediate value genearted from thr immediate generation block
wire [31:0]branchoff;     //left immediate value shifted by one
wire [31:0]branchval;     //new value to be loaded into PC in case of a branch

wire [31:0] ALUinA;       //muxed output of register or PC value to be inputted into the ALU       
wire [31:0]ALUinB;        //muxed output of register or immediate value to be inputted into the ALU
wire ALUmsb;              //msb of the ALU output used to determine BGT
wire [31:0]readData1;     //rs1 value
wire [31:0]readData2;     //rs2 value
wire [31:0] upperimm;     //immediate loading for LUI
wire branchselect;        //decides between different types of branches
wire DataReadSized;       //data from DM after truncating to correct size depending on lb,lh,lw
wire PCin_final;          //PCin after including possibility of JUMP instruction
wire jumpsrc;             //jump src is either the immediate value or ALU result depending on JAL or JALR
wire ALUsrc1;             //select line for muxing rs1 and PC to ALU;

SingleCycleCPU riscv_DUT(
clk,
start,
PCin,
PC_to_IM,
instruction,
readData1,
readData2,
immval,
ALUresult,
branchctl,
PC4,
ALUcntrl,
zero,
DataRead,
DataWritten,
memRead,
regsrc,
ALUOp,
memWrite,
ALUSrc,
regWrite,
branchoff,
branchval,
ALUinB,
ALUmsb,
 upperimm,
branchselect,
DataReadSized,
PCin_final,
jumpsrc,
ALUsrc1,
 ALUinA
);

initial
	forever #5 clk = ~clk;

initial begin
	clk = 0;
	start = 0;

	#10 start = 1;

	#3000 $finish;

end

endmodule
