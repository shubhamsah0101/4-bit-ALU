`timescale 1ns / 1ps

module ALU (
    input  [3:0] A,
    input  [3:0] B,
    input  [3:0] sel,
    output reg [7:0] result
);

    always @(*) begin
        case (sel)
            4'b0000 : result = A + B;                       // ADD
            4'b0001 : result = A - B;                       // SUB
            4'b0010 : result = A * B;                       // MUL
            4'b0011 : result = (B != 0) ? (A / B) : 8'b0;   // DIV
            4'b0100 : result = A & B;                       // AND
            4'b0101 : result = A | B;                       // OR
            4'b0110 : result = ~(A & B);                    // NAND
            4'b0111 : result = ~(A | B);                    // NOR
            4'b1000 : result = A ^ B;                       // XOR
            4'b1001 : result = ~(A ^ B);                    // XNOR
            default : result = 8'b0;                        // critical
        endcase
    end

endmodule
