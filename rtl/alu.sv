module alu (
  input  logic [2:0]  op,          // 000 ADD,001 SUB,010 AND,011 OR,100 XOR,101 SLT
  input  logic [31:0] a, b,
  output logic [31:0] y,
  output logic        z, n, c, v
);
  logic [31:0] res; 
  logic c_int, v_int;

  always_comb begin
    c_int = 1'b0; 
    v_int = 1'b0; 
    res   = '0;
    unique case (op)
      3'b000: begin 
        {c_int,res} = a + b; 
        v_int = ((a[31]==b[31]) && (res[31]!=a[31])); 
      end
      3'b001: begin 
        {c_int,res} = a - b; 
        v_int = ((a[31]!=b[31]) && (res[31]!=a[31])); 
      end
      3'b010: res = a & b;
      3'b011: res = a | b;
      3'b100: res = a ^ b;
      3'b101: res = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
      default: res = '0;
    endcase

    // Assign outputs
    y = res;
    z = (res == '0);
    n = res[31];
    c = c_int;
    v = v_int;
  end
endmodule
