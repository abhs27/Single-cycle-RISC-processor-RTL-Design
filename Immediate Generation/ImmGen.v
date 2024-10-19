module ImmGen#(parameter Width = 32) (
    input [Width-1:0] inst,
    output reg signed [Width-1:0] imm
);
    // ImmGen generate imm value based on opcode

    wire [6:0] opcode = inst[6:0];
    always @(*) 
    begin
        case(opcode[6:5]) // using last tow bits of the opcode to differentiate between I/S/B - type
            
            // TODO: implement your ImmGen here
            // Hint: follow the RV32I opcode map table to set imm value
	2'b00 : imm = inst[31:20]; // I-type
	2'b01 : imm = {inst[31:25] , inst[11:7]}; //S-type
	2'b11 : imm = {inst[31],inst[7],inst[30:25],inst[11:8]}; //B-type
	default : imm = 0; //not supposed to happen

	endcase
    end
            
endmodule
