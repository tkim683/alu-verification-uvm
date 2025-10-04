`timescale 1ns/1ps
module top_tb;
  logic clk=0; always #5 clk = ~clk;
  logic [2:0]  op;
  logic [31:0] a, b, y;
  logic z, n, c, v;

  alu dut(.op(op), .a(a), .b(b), .y(y), .z(z), .n(n), .c(c), .v(v));

  task do_vec(input [2:0] op_i, input [31:0] a_i, b_i);
    begin op=op_i; a=a_i; b=b_i; @(posedge clk); end
  endtask

  initial begin
    $dumpfile("build/alu.vcd"); $dumpvars(0, top_tb);

    // Directed
    do_vec(3'd0, 32'd2, 32'd3); if (y!==32'd5) $error("ADD failed: %0d", y);
    do_vec(3'd1, 32'd7, 32'd7); if (!z)        $error("SUB zero flag not set");
    do_vec(3'd5, 32'hFFFF_FFFF, 32'd1); if (y!==32'd1) $error("SLT failed");

    // Random
    repeat (2000) begin
      do_vec($urandom%6, $urandom, $urandom);
    end
    $display("CHECK PASS"); $finish;
  end
endmodule
