module FullAdderFour(input clk,input rst,input key_a,input key_b,input key_cal,input[3:0]sw_dig,output[8:0]seg_rt,output[8:0]seg_lt,output[2:0]led);

	reg[8:0]seg[15:0];//数码管显示数据库.
	reg[3:0]add1;//加数一.
	reg[3:0]add2;//加数二.
	reg[7:0]sum;//和
	reg[3:0]seg_data[1:0];//数码管显示数据流.
	reg led_data[2:0];

	wire[3:0]add1_pcd;
	wire[3:0]add2_pcd;
	wire[7:0]sum_pcd;
	wire c_c1;
	wire[3:0]c_c2;
	wire key_a_dbs;
	wire key_b_dbs;
	wire key_cal_dbs;

	assign add1_pcd = add1;
	assign add2_pcd = add2;
	assign c_c1 = 0;

	initial begin
		seg[0] <= 9'h3f;
		seg[1] <= 9'h06;
		seg[2] <= 9'h5b;
		seg[3] <= 9'h4f;
		seg[4] <= 9'h66;
		seg[5] <= 9'h6d;
		seg[6] <= 9'h7d;
		seg[7] <= 9'h07;
		seg[8] <= 9'h7f;
		seg[9] <= 9'h6f;
		seg[10] <= 9'h40;
		sum <= 0;
		led_data[0] <= 1;
		led_data[1] <= 1;
		led_data[2] <= 1;
	end

	always@(posedge clk or negedge rst)begin
		if(!rst)begin
			seg_data[0] <= 10;
			seg_data[1] <= 10;
			led_data[0] <= 1;
			led_data[1] <= 1;
			led_data[2] <= 1;
			sum <= 0;
		end
		else if(!key_a)begin
			add1 <= sw_dig;
			led_data[0] <= 0;
			led_data[1] <= 1;
			led_data[2] <= 1;
			if(add1 > 9)
				{seg_data[1],seg_data[0]} <= add1 + 4'd6;//加六修正.
			else
				seg_data[0] <= add1;
		end
		else if(!key_b)begin
			add2 <= sw_dig;
			led_data[0] <= 0;
			led_data[1] <= 0;
			led_data[2] <= 1;
			if(add2 > 9)
				{seg_data[1],seg_data[0]} <= add2 + 4'd6;
			else
				seg_data[0] <= add2;
		end
		else if(!key_cal)begin
			sum<=sum_pcd;
			led_data[0] <= 1;
			led_data[1] <= 1;
			led_data[2] <= 0;
			if(sum > 29)
				{seg_data[1],seg_data[0]} <= sum + 8'd18;
			else if(sum > 19)
				{seg_data[1],seg_data[0]} <= sum + 8'd12;
			else if(sum > 9)
				{seg_data[1],seg_data[0]} <= sum + 4'd6;
			else
				{seg_data[1],seg_data[0]} <= sum;
		end
		else if(!sum)begin//当还没有进行计算的时候让数码管动态显示当前数值.
			if(sw_dig < 10)begin
				seg_data[0] <= sw_dig;
				seg_data[1] <= 0;end
			else begin
				seg_data[0] <= sw_dig-10;
				seg_data[1] <= 1;end
		end
	end

	FullAdder FA1(
		.a(add1_pcd),
		.b(add2_pcd),
		.c1(c_c1),
		.s(sum_pcd),
		.c2(c_c2)
		);

	debounce BD1(
		.clk(clk),
		.rst(rst),
		.key(key_a),
		.key_pulse(key_a_dbs)
		);

	debounce BD2(
		.clk(clk),
		.rst(rst),
		.key(key_b),
		.key_pulse(key_b_dbs)
		);

	debounce BD3(
		.clk(clk),
		.rst(rst),
		.key(key_cal),
		.key_pulse(key_cal_dbs)
		);

	assign seg_rt = seg[seg_data[0]];
	assign seg_lt = seg[seg_data[1]];
	assign led[0] = led_data[0];
	assign led[1] = led_data[1];
	assign led[2] = led_data[2];

endmodule
