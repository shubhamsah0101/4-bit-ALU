`timescale 1ns / 1ps

module ALU_Pipeline_tb;
    
    reg clk, rst;
    reg [3:0] A, B;
    reg [3:0] sel;
    
    wire [7:0] result;
    wire zero_flag, overflow_flag, div_by_zero_flag;
    
    reg [63:0] op_name; // operation name    
    
    ALU_4_bit_Pipeline alu1(
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .sel(sel),
        .result(result),
        .zero_flag(zero_flag),
        .overflow_flag(overflow_flag),
        .div_by_zero_flag(div_by_zero_flag) );
    
    always #2 clk = ~clk;
    
//    operation name decoder
    always@(*) begin
        case(sel)
            4'b0000 : op_name = "ADD";
            4'b0001 : op_name = "SUB";
            4'b0010 : op_name = "MUL";
            4'b0011 : op_name = "DIV";
            4'b0100 : op_name = "AND";
            4'b0101 : op_name = "OR";
            4'b0110 : op_name = "NAND";
            4'b0111 : op_name = "NOR";
            4'b1000 : op_name = "XOR";
            4'b1001 : op_name = "XNOR";
            default : op_name = "UNKNOWN";
        endcase
    end
    
    integer i, j, s;
    
//    main test cases
    initial begin
    
        $dumpfile("alu_pipelined.vcd");
        $dumpvars(0, ALU_Pipeline_tb);
    
        clk = 0;
        rst = 1;
        A   = 0;
        B   = 0;
        sel = 0;
        
        #5;
        rst = 0;
        
        repeat(3) @(posedge clk);
        
//      loop for all combination
        for(s = 0; s <= 9; s = s + 1) begin
            sel = s;
            
//          loop for all A and B combinations
            for(i = 0; i <= 15; i = i + 1) begin
                for(j = 0; j <= 15; j = j + 1) begin
                    A = i;
                    B = j;
                    
                    repeat(3) @(posedge clk);
                    
                    $display("T=%0t | OP=%s | A=%0d | B=%0d | Result=%0d | Z=%b | OF=%b | DBZ=%b",
         $time, op_name, A, B, result, zero_flag, overflow_flag, div_by_zero_flag);

                end
            end
                    
        end
        
        #100;
        $finish;
        
    end
               
endmodule