module ImmGen#(parameter Width = 32) (
    input [Width-1:0] inst,
    output reg signed [Width-1:0] imm
);
    // ImmGen generate imm value based on opcode

    wire [6:0] opcode = inst[6:0];
    always @(*) 
    begin
        case(opcode)
            
            // TODO: implement your ImmGen here
            // Hint: follow the RV32I opcode map table to set imm value
            7'b0010011 : imm = $signed(inst[31:20]); // I-type
            7'b1101111 : imm = $signed({inst[31],inst[19:12],inst[20],inst[30:12]}); // for JAL
            7'b0110111 : imm = $signed(inst[31:12]);//for lui
            7'b0000011 : imm = $signed(inst[31:20]); // lw
            7'b0100011 : imm = $signed({inst[31:25],inst[11:7]}); //sw
            7'b1100011 : imm = $signed({inst[31],inst[7],inst[30:25],inst[11:8]}); //branch instructions
            default    : imm = 0;
	endcase 
    end
            
endmodule

