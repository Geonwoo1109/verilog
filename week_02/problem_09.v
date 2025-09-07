module full_adder (
  input wire A, B, Cin,
  output wire S, Cout
);

  assign S = A ^ B ^ Cin;    // 1이 한개만 있을 때 (얘도 되네)
  assign Cout = (A & B) | (B & Cin) | (Cin & A);    // 세 경우 중 하나라도 만족하면 자릿수올림

endmodule
