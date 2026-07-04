module pl_reg #(parameter WIDTH = 32)(
    input clk, rst, flush, en, 
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
    );
    
    always@(posedge clk, posedge rst)
      begin
          if(rst || flush)
              out <= 0;
          else if(en)
              out <= in;
      end
    
endmodule
