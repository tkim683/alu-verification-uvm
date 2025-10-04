`timescale 1ns/1ps
module top_tb;
  import alu_ref_pkg::*;

  logic clk = 0; always #5 clk = ~clk;
  logic [2:0]  op;
  logic [31:0] a, b, y;
  logic z, n, c, v;
  integer hits[0:5];

  alu dut(.op(op), .a(a), .b(b), .y(y), .z(z), .n(n), .c(c), .v(v));

  task do_vec(input [2:0] op_i, input [31:0] a_i, b_i);
    logic [31:0] y_exp; logic z_exp, n_exp, c_exp, v_exp;
    begin
      op = op_i; a = a_i; b = b_i;
      @(posedge clk);
      ref_alu(op,a,b,y_exp,z_exp,n_exp,c_exp,v_exp);

      if (y !== y_exp) $error("Y mismatch op=%0d a=%h b=%h : got=%h exp=%h", op,a,b,y,y_exp);
      if (z !== z_exp) $error("Z mismatch op=%0d : got=%0b exp=%0b", op,z,z_exp);
      if (n !== n_exp) $error("N mismatch op=%0d : got=%0b exp=%0b", op,n,n_exp);
      if (c !== c_exp) $error("C mismatch op=%0d : got=%0b exp=%0b", op,c,c_exp);
      if (v !== v_exp) $error("V mismatch op=%0d : got=%0b exp=%0b", op,v,v_exp);

      if (op==3'd5 && !(y==32'd0 || y==32'd1))
        $error("SLT not boolean: y=%h", y);

      hits[op] += 1;
    end
  endtask

  initial begin
    $dumpfile("build/alu.vcd"); $dumpvars(0, top_tb);
    for (int i=0;i<6;i++) hits[i]=0;

    // Directed
    do_vec(3'd0, 32'd2, 32'd3);
    do_vec(3'd1, 32'd7, 32'd7);
    do_vec(3'd5, 32'hFFFF_FFFF, 32'd1);

    // Random
    repeat (2000) do_vec($urandom%6, $urandom, $urandom);

    $display("COVER: OP0_ADD hits=%0d", hits[0]);
    $display("COVER: OP1_SUB hits=%0d", hits[1]);
    $display("COVER: OP2_AND hits=%0d", hits[2]);
    $display("COVER: OP3_OR  hits=%0d", hits[3]);
    $display("COVER: OP4_XOR hits=%0d", hits[4]);
    $display("COVER: OP5_SLT hits=%0d", hits[5]);

    $display("CHECK PASS");
    $finish;
  end
endmodule
