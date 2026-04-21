`timescale 1ns / 1ps

module ALU_4_bit_Pipeline (
    input clk, rst,
    input [3:0] A, B,
    input [3:0] sel,
    
    output [7:0] result,
    output zero_flag, overflow_flag, div_by_zero_flag
);
    
//  stage - 1: Input Registers
  reg [3:0] A_r, B_r;
  reg [3:0] sel_r;
  
//  Implementation
  always@(posedge clk or posedge rst) begin
    if(rst) begin
        A_r   <= 0;
        B_r   <= 0;
        sel_r <= 0;
    end
    else begin
        A_r   <= A;
        B_r   <= B;
        sel_r <= sel;
    end
  end
  
  
//  stage - 2: Execution
  reg [7:0] alu_out;
  reg ovf_flag, dbz_flag;
  
//  Implementation
  always@(*) begin
    
    alu_out  = 0;
    ovf_flag = 0;
    dbz_flag = 0;
    
    case(sel_r)
    
        4'b0000 : begin
                  alu_out         =  A_r + B_r;   // addition
                  ovf_flag = (A_r + B_r > 8'd15);
                  end
                  
        4'b0001 : begin
                  alu_out         =  A_r - B_r;   // subtraction
                  ovf_flag = (A_r < B_r);
                  end
                  
        4'b0010 : begin
                  alu_out         =  A_r * B_r;   // multipication
                  ovf_flag = (A_r * B_r > 8'd255);
                  end
                  
        4'b0011 : begin
                    if(B_r == 0) begin
                        alu_out = 8'hFF;
                        dbz_flag = 1;
                    end else 
                    begin
                        alu_out = A_r / B_r;
                    end                      
                  end  
                  
        4'b0100 : alu_out = {4'b0,  (A_r & B_r)};  // and
        4'b0101 : alu_out = {4'b0,  (A_r | B_r)};  // or
        4'b0110 : alu_out = {4'b0, ~(A_r & B_r)};  // nand
        4'b0111 : alu_out = {4'b0, ~(A_r | B_r)};  // nor
        4'b1000 : alu_out = {4'b0,  (A_r ^ B_r)};  // xor
        4'b1001 : alu_out = {4'b0, ~(A_r ^ B_r)};  // xnor
        
        default : alu_out = 0; 
        
    endcase
end

//  Stage - 3: Register write back
reg [7:0] result_r3;
reg zero_flag_r3, overflow_flag_r3, div_by_zero_flag_r3;

always@(posedge clk or posedge rst) begin

    if(rst) begin
    
        result_r3 <= 0;
        zero_flag_r3 <= 0;
        overflow_flag_r3 <= 0;
        div_by_zero_flag_r3 <= 0;
        
    end else begin
    
        result_r3 <= alu_out;
        zero_flag_r3 <= (alu_out == 0);
        overflow_flag_r3 <= ovf_flag;
        div_by_zero_flag_r3 <= dbz_flag;
        
    end

end

//  Final Result
assign result = result_r3;
assign zero_flag = zero_flag_r3;
assign overflow_flag = overflow_flag_r3;
assign div_by_zero_flag = div_by_zero_flag_r3;
    
endmodule