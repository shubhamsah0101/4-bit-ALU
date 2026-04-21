`timescale 1ns / 1ps

module ALU_testbench;

    reg  [3:0] A, B, sel;
    wire [7:0] result;

    ALU a (
        .A(A),
        .B(B),
        .sel(sel),
        .result(result)
    );

    integer i, j, sel_i;

    initial begin
        A = 0;
        B = 0;
        sel = 0;    #1;

        for (sel_i = 0; sel_i <= 9; sel_i = sel_i + 1) begin
            sel = sel_i[3:0];

            for (i = 0; i <= 15; i = i + 1) begin
                for (j = 0; j <= 15; j = j + 1) begin
                    A = i[3:0];
                    B = j[3:0]; #1;
                    $display("Time = %t | A = %0b(%0d) | B = %0b(%0d) |\t sel = %0b(%0d) |\t Result = %0b(%0d)", $time,A,A,B,B,sel,sel,$signed(result),$signed(result));
                end
            end
        end

        $finish;
    end

endmodule
