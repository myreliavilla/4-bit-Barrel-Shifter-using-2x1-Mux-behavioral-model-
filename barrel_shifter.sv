//`include "mux_2x1_behavioral.sv"
module barrel_shifter (
input logic select, // select=0 shift operation, select=1 rotate operation
input logic direction, // direction=0 right move, direction=1 left move
input logic[1:0] shift_value, // number of bits to be shifted (0, 1, 2 or 3)
input logic[3:0] din,
output logic[3:0] dout
);
// Students to add code for barrel shifter
//declaring local variables
logic [3:0] stg1mux_out; //Outputs for mux0 thru mux3
logic [2:0] s; //Used to either tie in 0's or inputs i.e. (o/p of mux0, din[1], din[0], (or the
//corresponding inputs if inversion has taken place) for mux2, mux3,
//mux7.
logic [3:0] t_din, t_dout; //Input for stage 1 muxs (0-3), and output for stage 2 muxs (4-7).
//Always procedural block to store input din data to a local variable and do the swapping
//of input din bit based on direction 1 (left) or 0 (right).
//If direction == 0, then don't perform bit inversions(swapping).
//If direction == 1, then perform bit inversions(swapping).
always@(direction, din)begin
if (direction == 0)begin
//no bit inversion for input
t_din[0] = din[0];
t_din[1] = din[1];
t_din[2] = din[2];
t_din[3] = din[3];
end
//invert the bits (swap the positions) for input
else begin
t_din[0] = din[3];
t_din[1] = din[2];
t_din[2] = din[1];
t_din[3] = din[0];
end
end
//Always block based on the shift or rotate operation to either tie in zeros or connect inputs
//for mux2, mux3, mux7, (port 1).
always@(select, t_din, stg1mux_out)begin
//inject 0's in MSB bit for shift operation
if (select == 0) begin
s[0] = 0;
s[1] = 0;
s[2] = 0;
end
//connect MSB of input bits with LSB bits for rotate
else begin
s[0] = t_din[0];
s[1] = t_din[1];
s[2] = stg1mux_out[0];
end
end
//Instantiation of 8 2x1 Muxs, (Stage1: (0-3)), (Stage2: (4-7)).
mux_2x1 mux_inst0(
.in0(t_din[0]), .in1(t_din[2]),
.sel(shift_value[1]),
.out(stg1mux_out[0])
);
mux_2x1 mux_inst1(
.in0(t_din[1]), .in1(t_din[3]),
.sel(shift_value[1]),
.out(stg1mux_out[1])
);
mux_2x1 mux_inst2(
.in0(t_din[2]), .in1(s[0]),
.sel(shift_value[1]),
.out(stg1mux_out[2])
);
mux_2x1 mux_inst3(
.in0(t_din[3]), .in1(s[1]),
.sel(shift_value[1]),
.out(stg1mux_out[3])
);
mux_2x1 mux_inst4(
.in0(stg1mux_out[0]), .in1(stg1mux_out[1]),
.sel(shift_value[0]),
.out(t_dout[0])
);
mux_2x1 mux_inst5(
.in0(stg1mux_out[1]), .in1(stg1mux_out[2]),
.sel(shift_value[0]),
.out(t_dout[1])
);
mux_2x1 mux_inst6(
.in0(stg1mux_out[2]), .in1(stg1mux_out[3]),
.sel(shift_value[0]),
.out(t_dout[2])
);
mux_2x1 mux_inst7(
.in0(stg1mux_out[3]), .in1(s[2]),
.sel(shift_value[0]),
.out(t_dout[3])
);
//Always block for inverting (swapping) the output bits
always@(direction, t_dout)begin
if(direction == 0)begin
//no bit inversion (swapping) for output
dout[0] = t_dout[0];
dout[1] = t_dout[1];
dout[2] = t_dout[2];
dout[3] = t_dout[3];
end
//bit inversion (swapping) for output
else begin
dout[0] = t_dout[3];
dout[1] = t_dout[2];
dout[2] = t_dout[1];
dout[3] = t_dout[0];
end
end
endmodule: barrel_shifter


