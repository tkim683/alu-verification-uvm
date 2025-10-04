package alu_ref_pkg;

  task automatic ref_alu(
    input  logic [2:0]  op,
    input  logic [31:0] a, b,
    output logic [31:0] y_exp,
    output logic        z_exp, n_exp, c_exp, v_exp
  );
    logic [32:0] tmp;
    y_exp = 32'd0; z_exp = 1'b0; n_exp = 1'b0; c_exp = 1'b0; v_exp = 1'b0;

    unique case (op)
      3'b000: begin // ADD
        tmp  = {1'b0,a} + {1'b0,b};
        y_exp = tmp[31:0]; c_exp = tmp[32];
        v_exp = ((a[31]==b[31]) && (y_exp[31]!=a[31]));
      end
      3'b001: begin // SUB
        tmp  = {1'b0,a} - {1'b0,b};
        y_exp = tmp[31:0]; c_exp = tmp[32];
        v_exp = ((a[31]!=b[31]) && (y_exp[31]!=a[31]));
      end
      3'b010: y_exp = a & b;
      3'b011: y_exp = a | b;
      3'b100: y_exp = a ^ b;
      3'b101: y_exp = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
      default: y_exp = 32'd0;
    endcase

    z_exp = (y_exp == 32'd0);
    n_exp = y_exp[31];
  endtask

endpackage
