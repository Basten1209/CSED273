/* CSED273 lab5 experiment 2 */
/* lab5_2.v */

`timescale 1ns / 1ps

/* Implement srLatch */
module srLatch(
    input s, r,
    output q, q_
    );

    ////////////////////////
    nor(q, r, q_);
    nor(q_, q, s);
    ////////////////////////

endmodule

/* Implement master-slave JK flip-flop with srLatch module */
module lab5_2(
    input reset_n, j, k, clk,
    output q, q_
    );
    ////////////////////////
    wire [2:0] r;
    wire [2:0] s;
    wire p, p_;
    
    and(r[0], k, q, clk);
    and(s[0], j, q_, clk);
    or(r[1], ~reset_n, r[0]);
    and(s[1], reset_n, s[0]);
    srLatch master(s[1], r[1], p, p_);
    
    and(r[2], p_, ~clk);
    and(s[2], p, ~clk); 
    srLatch slave(s[2], r[2], q, q_);
    
    ////////////////////////
    
endmodule