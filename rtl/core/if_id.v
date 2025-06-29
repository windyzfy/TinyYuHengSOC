`include "defines.v"
module if_id(
          input wire clk,
          input wire rst_n,
          //from ifetch
          input wire [31:0] inst_i,
          input wire [31:0] inst_addr_i,
          //打一拍输出
          output wire [31:0] inst_addr_o,
          output wire [31:0] inst_o
);
          dff_set #(32) dff1(clk,rst_n,`INST_NOP,inst_i,inst_o);

          dff_set #(32) dff2(clk,rst_n,32'b0,inst_addr_i,inst_addr_o);

endmodule