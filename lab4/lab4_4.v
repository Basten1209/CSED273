/* CSED273 lab4 experiment 4 */
/* lab4_4.v */

/* Implement 5x3 Binary Mutliplier
 * You must use lab4_2 module in lab4_2.v
 * You cannot use fullAdder or halfAdder module directly
 * You may use keword "assign" and bitwise opeartor
 * or just implement with gate-level modeling*/
module lab4_4(
    input [4:0]in_a,
    input [2:0]in_b,
    output [7:0]out_m
    );

    ////////////////////////
    /* Add your code here */
    wire [5:0] temp1;
    wire [4:0] temp2;
    wire [5:0] temp3;
    wire [4:0] temp4;
    wire c;
    assign c = 0;
    and(temp1[0], in_a[0], in_b[0]);
    and(temp1[1], in_a[1], in_b[0]);
    and(temp1[2], in_a[2], in_b[0]);
    and(temp1[3], in_a[3], in_b[0]);
    and(temp1[4], in_a[4], in_b[0]);
    assign temp1[5] = 0;
    assign out_m[0] = temp1[0];
    and(temp2[0], in_a[0], in_b[1]);
    and(temp2[1], in_a[1], in_b[1]);
    and(temp2[2], in_a[2], in_b[1]);
    and(temp2[3], in_a[3], in_b[1]);
    and(temp2[4], in_a[4], in_b[1]);

    lab4_2 add1(temp1[5:1], temp2[4:0], c, temp3[4:0], temp3[5]);
    assign out_m[1] = temp3[0];
    and(temp4[0], in_a[0], in_b[2]);
    and(temp4[1], in_a[1], in_b[2]);
    and(temp4[2], in_a[2], in_b[2]);
    and(temp4[3], in_a[3], in_b[2]);
    and(temp4[4], in_a[4], in_b[2]);
    
    lab4_2 add2(temp3[5:1], temp4[4:0], c, out_m[6:2], out_m[7]);
    
    ////////////////////////
    
endmodule