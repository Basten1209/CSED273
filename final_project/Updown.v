`timescale 1ns / 1ps

module Updown(
    input clk,
    input startnext, reset,
    input [3:0] UserOne,// Switches
    input [3:0] UserTen,
    input UP,
    input DOWN,
    input WIN,
    input LOSE,
    
   /* input [0:6] keypad,*/
   
    output reg [0:3] ssSel, // 7seg Selector
    output reg [0:7] ssDisp, // 7seg Display
    output reg [0:15] led,
    output reg [0:7] lifedis,//life 7segment
    output reg [0:7] one,//1's digit 7segment
    output reg [0:7] ten //10's digit 7segment
    );
    
    // LED Display Update
    integer tempten = 0;
    integer tempone = 0;
    integer lifeval = 4;
    parameter ssU = 8'b10000011;
    parameter ssP = 8'b00110001;
    parameter ssD = 8'b10000101;
    parameter ssO = 8'b00000011;
    parameter ssW = 8'b10000001;
    parameter ssN = 8'b00010011;
    parameter ssL = 8'b11100011;
    parameter ssS = 8'b01001001;
    parameter ssE = 8'b01100001;
    parameter ssI = 8'b10011111;
    parameter ss_ = 9'b11111111;
    reg [0:7] ssDispBuf[0:3];
    reg [0:2] state;
    wire dead;
     /*
    always @(posedge clk) begin

    life = 8'b10011000;
    ten = 8'b00000010;
    one = 8'b00000010;
    ssSel = 4'b0000;
    ssDisp = 8'b00000000;
   
if(UserOne == 4'b0000) begin
        one = 8'b00000011;
        tempone = 0;
        end
if(UserTen == 4'b0000) begin
        ten = 8'b00000011;
        tempten = 0;
        end
        
if(UserOne == 4'b0001) begin
        one = 8'b10011111;
        tempone = 1;
        end
if(UserTen == 4'b0001) begin
        ten = 8'b10011111;
        tempten = 1;
        end

if(UserOne == 4'b0010) begin
        one = 8'b00100101;
        tempone = 2;
        end
if(UserTen == 4'b0010) begin
        ten = 8'b00100101;
        tempten = 2;
        end
        
if(UserOne == 4'b0011) begin
        one = 8'b00001101;
        tempone = 3;
        end
if(UserTen == 4'b0011) begin
        ten = 8'b00001101;
        tempten = 3;
        end

if(UserOne == 4'b0100) begin
        one = 8'b10011001;
        tempone = 4;
        end
if(UserTen == 4'b0100) begin
        ten = 8'b10011001;
        tempten = 4;
        end

if(UserOne == 4'b0101) begin
        one = 8'b01001001;
        tempone = 5;
        end
if(UserTen == 4'b0101) begin
        ten = 8'b01001001;
        tempten = 5;
        end

if(UserOne == 4'b0110) begin
        one = 8'b01000001;
        tempone = 6;
        end
if(UserTen == 4'b0110) begin
        ten = 8'b01000001;
        tempten = 6;
        end

if(UserOne == 4'b0111) begin
        one = 8'b00011111;
        tempone = 7;
        end
 if(UserTen == 4'b0111) begin
        ten = 8'b00011111;
        tempten = 7;
        end

if(UserOne == 4'b1000) begin
        one = 8'b00000001;
        tempone = 8;
        end
if(UserTen == 4'b1000) begin
        ten = 8'b00000001;
        tempten = 8;
        end
        
if(UserOne == 4'b1001) begin
        one = 8'b00001001;
        tempone = 9;
        end
if(UserTen == 4'b1001) begin
        ten = 8'b00001001;
        tempten = 9;
        end
if(UP==1) begin
    ssSel = 4'b0111;
    ssDisp = ssU;
      end
if(DOWN==1) begin
    ssSel = 4'b1011;
    ssDisp = ssD;
    end
if(WIN==1) begin
    ssSel = 4'b1101;
    ssDisp = ssW;
    end
if(LOSE==1) begin
    ssSel = 4'b1110;
    ssDisp = ssL;
    end
    
    if(life==0) begin
    dead = 1;
    end
    else begin
    dead = 0;
    end
    
end
*/
  
   //wire clock_1000_multiplied;
   //clock x1000(CLK, clock_1000_multiplied);
    wire checknonzero;

    wire [2:0] life;

    wire updown;
    wire Same;
    or (checknonzero, state[2], state[1], state[0]);
    wire checkzero;
    wire checkzeronreset;
    wire [1:0] S1S0;
    wire [2:0] S1S0UD;
    wire tens_saved;
    wire ones_saved;
    wire [3:0] tens_output;
    wire [3:0] ones_output;
    wire [2:0] decoder_output;
    wire [7:0] MultipliedTen;
    wire [7:0] random_number;
    wire [7:0] input_number;
    wire [1:0] OutOfDecoder;
    random_counter RandomNumberGenerator(checknonzero, CLK, random_number);

    Life_Counter ThrBitCounter (checkzeronreset, state[2], life);
    and (dead, life[2], life[1], life[0]);
    
    State_Transition State_T(startnext, reset, Same, dead, state);

    nor (checkzero, state[2], state[1], state[0]);
    or (checkzeronreset, checkzero, reset);
    OutputCombinationalLogic OutputLogic (state, S1S0);
    
    and (S1S0UD[2], S1S0[1], 1);
    and (S1S0UD[1], S1S0[0], 1);
    and (S1S0UD[0], updown, 1);

    wire [7:0] out_out;
    wire sub_out;
    wire [7:0] sub_user_input;
    wire [7:0] sub_rand_input;

    ripple_subtractor_8_bit subtract_module(sub_user_input,sub_rand_input,1,out_out,sub_out);
    
    
    decoder_3_by_3 ThreeToThree (state, decoder_output);

    and (tens_saved, OutOfDecoder[1], Btn2);
    and (ones_saved, OutOfDecoder[0], Btn2);
    ten_multiplier TenMultiplier (tens_output, MultipliedTen);
    adder ThreeNumAdder(ones_output, MultipliedTen, input_number);
         endmodule

// Posedge D Flip Flop with Posedge Reset
module D_FF(
        input clk,
        input reset,
        input in,
        output out
        );
    reg out_a;

    always @(posedge clk or posedge reset)
    begin
        if (reset == 1'b1) // if reset is low
        out_a <= 1'b0;  // out_1 is zero
    else
    out_a <= in;  // out_1 is in_1
    end
endmodule

module halfAdder( // halfadder to implement fulladder
    input in_a,
    input in_b,
    output out_s,
    output out_c
    );
    xor(out_s, in_a, in_b);
    and(out_c, in_a, in_b);
endmodule

module fullAdder( // fulladder to implement ripple subtractor
    input in_a,
    input in_b,
    input in_c,
    output out_s,
    output out_c
    );
    wire FA1_s, FA1_c, FA2_c;
    
    halfAdder H1(in_a, in_b, FA1_s, FA1_c);
    halfAdder H2(FA1_s, in_c, out_s, FA2_c); 
    or(out_c, FA1_c, FA2_c);
endmodule

module ripple_adder ( // ripple_adder to add tens and ones
    input [7:0] ten, input [3:0] one, output [7:0] number
    );
    wire [7:0] c_out;
    halfAdder zero_bit(ten[0], one[0], number[0], c_out[0]);
    fullAdder first_bit(ten[1], one[1], c_out[0], number[1], c_out[1]);
    fullAdder second_bit(ten[2], one[2], c_out[1], number[2], c_out[2]);
    fullAdder third_bit(ten[3], one[3], c_out[2], number[3], c_out[3]);
    halfAdder fourth_bit(ten[4], c_out[3], number[4], c_out[4]);
    halfAdder fifth_bit(ten[5], c_out[4], number[5], c_out[5]);
    halfAdder sixth_bit(ten[6], c_out[5], number[6], c_out[6]);
    halfAdder seventh_bit(ten[7], c_out[6], number[7], c_out[7]);
endmodule

module State_Transition(
        input D, // D = Start/Next
input E, // E = Reset
input F, // F = dead
input G, // G = Up/Down
input H, // H = Same
input Reset,
output [2:0] state
);
wire A;
wire B;
wire C;
wire DA;
wire DB;
wire DC;

D_FF AA (D, E, Da, state[2]);
D_FF BB (D, E, Db, state[1]);
D_FF CC (D, E, Dc, state[0]);

and (A, state[2], 1);
and (B, state[1], 1);
and (C, state[0], 1);

or (DA, (~A&~B&~C&~D), (~A&~B&~C&F), (~A&~D&~E), (~A&~E&F), (~A&B&C));
// DA = A'B'C'D', A'B'C'F, A'D'E', A'E'F, A'BC
or (DB, (~A&B&D&~F&~G&~H), (~A&~D&~E&~G&~H), (~A&C&~E&~G&~H), (~A&B&~E&~G&~H), (~A&B&~C&D&~F), (~A&B&C&~G&~H), (~A&~C&~D&~E), (~A&~B&~D&~E), (~A&~B&~C&~D), (~A&~B&~C&F), (~A&~B&C&~E), (~A&B&~C&~E), (~A&B&C&F), (~A&~E&F));
// DB = A'BDF'G'H'+A'D'E'G'H'+A'CE'G'H'+A'BE'G'H'+A'BC'DF'+A'BCG'H'+A'C'D'E'+A'B'D'E'+A'B'C'D'+A'B'C'F+A'B'CE'+A'BC'E'+A'BCF+A'E'F
or (DC, (~A&B&D&~F&~G&H), (~A&~D&~E&~G&H), (~A&B&~E&~G&H), (~A&B&C&~G&H), (~A&B&C&F&H), (~A&B&C&F&G), (~A&~C&D&~F), (~A&~E&F&H), (~A&~E&F&G), (~B&~D&~E), (~A&~C&~E), (~B&~E&F), (~B&~C), (A&~B));
// DC = A'BDF'G'H, A'D'E'G'H, A'BE'G'H, A'BCG'H, A'BCFH, A'BCFG, A'C'DF', A'E'FH, A'E'FG, B'D'E', A'C'E', B'E'F, B'C', AB'
endmodule

// Output Combination Logic

module OutputCombinationalLogic(
    input [2:0] state,
    output [1:0] OUT
);
    wire state1_neg;
    wire state0_neg;
    
    wire digit_1;
    wire digit_0;
    wire [1:0] temp;

    not(notState1, state[1]);
    not(notState0, state[0]);
    and (digit_1, state[2], state[1]);

    and (temp[1], state[2], notState1, state[0]);
    and (temp[0], state[2], state[1], notState0);
    or (digit_0, temp[1], temp[0]);

    and (OUT[1], digit_1, 1);
    and (OUT[0], digit_0, 1);

endmodule

module adder(
    input [3:0] one_digits,
    input [7:0] ten_digits,
    output [7:0] addend
);
    wire [7:0] ones_Edited;
    wire [7:0] result;

    and (ones_Edited[7], 0, 0);
    and (ones_Edited[6], 0, 0);
    and (ones_Edited[5], 0, 0);
    and (ones_Edited[4], 0, 0);
    and (ones_Edited[3], one_digits[3], 1);
    and (ones_Edited[2], one_digits[2], 1);
    and (ones_Edited[1], one_digits[1], 1);
    and (ones_Edited[0], one_digits[0], 1);

    ripple_adder OneAndTen (ones_Edited, tens, MiddleOutput);
endmodule

// 10 Times Multiplier
module ten_multiplier( // ten_multiplier to count number
    input [3:0] multiplicand, output [7:0] result
    );
    wire [2:0] c_out;
    assign result[0] = 1'b0;
    assign result[1] = multiplicand[0];
    assign result[2] = multiplicand[1];
    
    halfAdder third_bit (multiplicand[2], multiplicand[0], result[3], c_out[0]);
    fullAdder fourth_bit (multiplicand[3], multiplicand[1], c_out[0], result[4], c_out[1]);
    halfAdder fifth_bit (multiplicand[2], c_out[1], result[5], c_out[2]);
    halfAdder sixth_bit (multiplicand[3], c_out[2], result[6], result[7]);
endmodule

// life 3bit 0~7 Counter
module Life_Counter(
    input Reset,
    input count_clk,
    output [2:0]OUT
);
    wire X, Y, Z;
    wire D_X, D_Y, D_Z;
    and (D_X, (~X & Y & Z) | (X & ~Y) | (X & ~Z), 1);
    and (D_Y, (Y & ~Z) | (~Y & Z), 1);
    and (D_Z, ~Z, 1);

    D_FF D_FF_A(count_clk, Reset, DA, A);
    D_FF D_FF_B(count_clk, Reset, DB, B);
    D_FF D_FF_C(count_clk, Reset, DC, C);

    and (OUT[2], A, 1);
    and (OUT[1], B, 1);
    and (OUT[0], C, 1);
endmodule

module decoder_3_by_3(
    input [2:0] state,
    output [2:0] OUT
);
    not(OUT[2], ~state[1]);
    not(OUT[1], ~state[0]);
    and(OUT[0], state[1], state[0]);
endmodule

module ripple_subtractor_8_bit( // ripple subtractor to compare input with randomly-made number
    input [7:0] in_a,
    input [7:0] in_b,
    input in_c,
    output [7:0] out_s,
    output out_c
    );
    fullAdder subtractor(in_a, ~in_b, in_c, out_s, out_c);
endmodule


// Random Counter
module random_counter(
    input select,
    input clk,
    output reg [7:0]Random
);
    integer counter;
    initial begin
        counter = 0;
        Random <= 8'b00000000;
    end
    always @(posedge select) begin
        Random <= counter % 100;
    end
    
    always @(posedge clk) begin
        if (counter == 800000) begin counter <= 0; end
        else begin counter <= counter + 1; end
    end
endmodule

module result_decoder(
    input [2:0] out,
    output [0:7] segment
);
    and (segment[0], ~out[2], 1);
    or (segment[1], out[2], ~out[1], out[0]);
    not (segment[2], out[1]);
    not (segment[3], out[1]);
    or (segment[4], (~out[2] & ~out[1]), (out[2] & out[1]));
    not (segment[5], out[2]);
    or (segment[6], (~out[2] & ~out[1]), (~out[2] & out[0]));
    and (segment[7], 1, 1);
endmodule

module life_seg_decoder (
    input [2:0] life,
    output [0:7] segment
);
    or (segment[0], (~life[2] & ~life[1] & life[0]), (life[2] & ~life[1]& ~life[0]));
    or (segment[1], (life[2] & ~life[1] & life[0]), (life[2] & life[1] & ~life[0]));
    and (segment[2], ~life[2], life[1], ~life[0]);
    or (segment[3], (~life[2] & ~life[1] & life[0]), (life[2] & ~life[1] & ~life[0]), (life[2] & life[1] & life[0]));
    or (segment[4], life[0], (life[2] & ~life[1]));
    or (segment[5], (~life[2] & life[0]), (~life[2] & life[1]));
    or (segment[6], (~life[2] & ~life[1]), (life[2] & life[1] & life[0]));
    and (segment[7], 1, 1);
endmodule

module number_segment(
    input clk,
    input [7:0] num_input,
    output reg [3:0] choice_seg, // 7seg Selector
    output reg [0:7] display_seg // 7seg Display
);
    wire [3:0] tens;
    wire [3:0] ones;
    wire ssSel;
    assign tens = num_input[7:4];
    assign ones = num_input[3:0];
    
    parameter flck_clock = 200000;
    integer flck_counter;
    
    reg [3:0] num_of_switch;
    reg [3:0] display_state;
    reg [0:7] buffer_3;
    reg [0:7] buffer_2;
    reg [0:7] buffer_1;
    reg [0:7] buffer_0;
    decoder_for_numbers num2_dec(num2,buff2);
    decoder_for_numbers num1_dec(num1,buff1);
    decoder_for_numbers num0_dec(num0,buff0);

    initial begin
        choice_seg = 4'b1110;
        display_seg = 8'b11111111;
        num_of_switch = 0;
        display_state = 4'b0000;
        buffer_3 = 8'b11111111;
        flck_counter = 0;
    end

    //print FPGA
    always @(posedge clk) begin
    
    if (flck_counter % flck_clock == 0 ) begin
        case(ssSel)
            4'b0111 : begin choice_seg <= 4'b1110; display_seg <= buffer_0; end
            4'b1110 : begin choice_seg <= 4'b1101; display_seg <= buffer_1; end
            4'b1101 : begin choice_seg <= 4'b1011; display_seg <= buffer_2; end
            4'b1011 : begin choice_seg <= 4'b0111; display_seg <= buffer_3; end
        endcase
    end
end

    always @(posedge clk) begin
        if (flck_counter == 1000000) begin
            flck_counter <= 0;
        end
        else begin
            flck_counter <= flck_counter + 1;
        end
    end
endmodule

module decoder_for_numbers(
    input [3:0] num,
    output [0:7] seg_out
);
    or (seg_out[0], (~num[3] & ~num[2] & ~num[1] & num[0]), (num[2] & ~num[1] & ~num[0]));
    or (seg_out[1], (num[2] & ~num[1] & num[0]), (num[2] & num[1] & ~num[0]));
    and (seg_out[2], ~num[2], num[1], ~num[0]);
    or (seg_out[3], (~num[3] & ~num[2] & ~num[1] & num[0]), (num[2] & ~num[1] & ~num[0]), (num[2] & num[1] & num[0]));
    or (seg_out[4], num[0], (num[2] & ~num[1]));
    or (seg_out[5], (num[1] & ~num[2]), (~num[3] & ~num[2] & num[0]));
    or (seg_out[6], (~num[3] & ~num[2] & ~num[1]), (num[2] & num[1] & num[0]));
    and (seg_out[7], 1, 1);
endmodule
