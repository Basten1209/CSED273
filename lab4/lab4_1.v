/* CSED273 lab4 experiment 1 */
/* lab4_1.v */


/* Implement Half Adder
 * You may use keword "assign" and bitwise opeartor
 * or just implement with gate-level modeling*/
module halfAdder(
    input in_a,
    input in_b,
    output out_s,
    output out_c
    );

    ////////////////////////
    /* Add your code here */
    xor(out_s, in_a, in_b);
    and(out_c, in_a, in_b);
    ////////////////////////

endmodule

/* Implement Full Adder
 * You must use halfAdder module
 * You may use keword "assign" and bitwise opeartor
 * or just implement with gate-level modeling*/
module fullAdder(
    input in_a,
    input in_b,
    input in_c,
    output out_s,
    output out_c
    );

    ////////////////////////
    /* Add your code here */
    wire c1, c2, tsum;
    halfAdder HA1(in_b, in_c, tsum, c1);
    halfAdder HA2(in_a, tsum, out_s, c2);
    or(out_c, c1, c2);
    
    ////////////////////////

endmodule