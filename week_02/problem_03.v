module gate(x, y, a, b, c, d, e);
  input x, y;
  output wire a, b, c, d, e;

  assign a = x & y;
  assign b = x | y;
  assign c = x ^ y;
  assign d = ~(x | y);
  assign e = ~(x & y);

endmodule

  
