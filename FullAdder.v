module FullAdder(a,b,c1,c2,s);
	input[3:0]a;
	input[3:0]b;
	input c1;
	output c2;
	output[7:0]s;

	wire [3:0]var1;
	wire [3:0]var2;
	wire [3:0]var3;
	wire [2:0]var4;

	xor xor1(var1[0],a[0],b[0]);
	xor xor2(s[0],var1[0],c1);
	and and1(var2[0],a[0],b[0]);
	and and2(var3[0],c1,var1[0]);
	or or1(var4[0],var2[0],var3[0]);

	xor xor3(var1[1],a[1],b[1]);
	xor xor4(s[1],var1[1],var4[0]);
	and and3(var2[1],a[1],b[1]);
	and and4(var3[1],var4[0],var1[1]);
	or or2(var4[1],var2[1],var3[1]);

	xor xor5(var1[2],a[2],b[2]);
	xor xor6(s[2],var1[2],var4[1]);
	and and5(var2[2],a[2],b[2]);
	and and6(var3[2],var4[1],var1[2]);
	or or3(var4[2],var2[2],var3[2]);

	xor xor7(var1[3],a[3],b[3]);
	xor xor8(s[3],var1[3],var4[2]);
	and and7(var2[3],a[3],b[3]);
	and and8(var3[3],var4[2],var1[3]);
	or or4(c2,var2[3],var3[3]);

	assign s[4]=c2;
endmodule