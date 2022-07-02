/* CSED273 lab5 experiment 1 */
/* lab5_1.v */

`timescale 1ps / 1fs

module halfAdder(
    input in_a,
    input in_b,
    output out_s,
    output out_c
    );

    ////////////////////////
    xor (out_s, in_a, in_b);
    and (out_c, in_a, in_b);
    ////////////////////////

endmodule

module fullAdder(
    input in_a,
    input in_b,
    input in_c,
    output out_s,
    output out_c
    );
    wire s, c1, c2;
    ////////////////////////
    halfAdder M1(in_a, in_b, s, c1);
    halfAdder M2(s, in_c, out_s, c2);
    or (out_c, c1, c2);
    ////////////////////////

endmodule

/* Implement adder 
 * You must not use Verilog arithmetic operators */
module adder(
    input [3:0] x,
    input [3:0] y,
    input c_in,             // Carry in
    output [3:0] out,
    output c_out            // Carry out
); 

    ////////////////////////
    wire c1, c2, c3;
    fullAdder M1(x[0], y[0], c_in , out[0], c1); 
    fullAdder M2(x[1], y[1], c1, out[1], c2);
    fullAdder M3(x[2], y[2], c2 , out[2], c3); 
    fullAdder M4(x[3], y[3], c3, out[3], c_out); 
    ////////////////////////

endmodule

/* Implement arithmeticUnit with adder module
 * You must use one adder module.
 * You must not use Verilog arithmetic operators */
module arithmeticUnit(
    input [3:0] x,
    input [3:0] y,
    input [2:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    ////////////////////////
    wire [3:0] a;
    wire [12:1] temp;
    and(temp[1], y[3], select[1]);
    not(temp[2], y[3]);
    and(temp[3], temp[2], select[2]);
    or(a[3], temp[1], temp[3]);
    
    and(temp[4], y[2], select[1]);
    not(temp[5], y[2]);
    and(temp[6], temp[5], select[2]);
    or(a[2], temp[4], temp[6]);
    
    and(temp[7], y[1], select[1]);
    not(temp[8], y[1]);
    and(temp[9], temp[8], select[2]);
    or(a[1], temp[7], temp[9]);
    
    and(temp[10], y[0], select[1]);
    not(temp[11], y[0]);
    and(temp[12], temp[11], select[2]);
    or(a[0], temp[10], temp[12]);
    adder K1(a[3:0], x[3:0], select[0], out[3:0], c_out);
    ////////////////////////

endmodule

/* Implement 4:1 mux */
module mux4to1(
    input [3:0] in,
    input [1:0] select,
    output out
);

    ////////////////////////
    wire [6:1] temp;
    not(temp[1], select[1]);
    not(temp[2], select[0]);
    and(temp[3], in[0], temp[1], temp[2]);
    and(temp[4], in[1], temp[1], select[0]);
    and(temp[5], in[2], select[1], temp[2]);
    and(temp[6], in[3], select[1], select[0]);
    or(out, temp[3], temp[4], temp[5], temp[6]); 
    ////////////////////////

endmodule

/* Implement logicUnit with mux4to1 */
module logicUnit(
    input [3:0] x,
    input [3:0] y,
    input [1:0] select,
    output [3:0] out
);

    ////////////////////////
    wire [3:0] a;
    not(a[3], x[0]);
    xor(a[2], x[0], y[0]);
    or(a[1], x[0], y[0]);
    and(a[0], x[0], y[0]);
    mux4to1 M1(a[3:0], select[1:0], out[0]);
    
    wire [3:0] b;
    not(b[3], x[1]);
    xor(b[2], x[1], y[1]);
    or(b[1], x[1], y[1]);
    and(b[0], x[1], y[1]);
    mux4to1 M2(b[3:0], select[1:0], out[1]);

    wire [3:0] c;
    not(c[3], x[2]);
    xor(c[2], x[2], y[2]);
    or(c[1], x[2], y[2]);
    and(c[0], x[2], y[2]);
    mux4to1 M3(c[3:0], select[1:0], out[2]);
    
    wire [3:0] d;
    not(d[3], x[3]);
    xor(d[2], x[3], y[3]);
    or(d[1], x[3], y[3]);
    and(d[0], x[3], y[3]);
    mux4to1 M4(d[3:0], select[1:0], out[3]);
    ////////////////////////

endmodule

/* Implement 2:1 mux */
module mux2to1(
    input [1:0] in,
    input  select,
    output out
);

    ////////////////////////
    wire a, b, c;
    not(a, select);
    and(b, in[0], a);
    and(c, in[1], select);
    or(out, b, c); 
    ////////////////////////

endmodule

/* Implement ALU with mux2to1 */
module lab5_1(
    input [3:0] x,
    input [3:0] y,
    input [3:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    ////////////////////////
    wire [3:0] a;
    wire [3:0] b;
    wire [1:0] c;
    wire [1:0] d;
    wire [1:0] e;
    wire [1:0] f;
    
    arithmeticUnit F1(x[3:0], y[3:0], select[2:0], a[3:0], c_out);
    logicUnit F2(x[3:0], y[3:0], select[1:0], b[3:0]);
    
    assign c[0] = a[0];
    assign c[1] = b[0];
    mux2to1 F3(c[1:0], select[3], out[0]);
    
    assign d[0] = a[1];
    assign d[1] = b[1];
    mux2to1 F4(d[1:0], select[3], out[1]);
    
    assign e[0] = a[2];
    assign e[1] = b[2];
    mux2to1 F5(e[1:0], select[3], out[2]);
    
    assign f[0] = a[3];
    assign f[1] = b[3];
    mux2to1 F6(f[1:0], select[3], out[3]);
    ////////////////////////

endmodule
