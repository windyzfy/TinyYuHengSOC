`include "defines.v"
module id_ex(
    input wire clk,
    input wire rst_n,

    //from id
    input wire [31:0] inst_i,
    input wire [31:0] inst_addr_i,
    input wire [31:0] op1_i,
    input wire [31:0] op2_i,
    input wire [4:0]  rd_addr_i,
    input wire        reg_wen_i,
    //from ctrl
    input wire        hold_flag_i,

    //to ex
    output wire [31:0] inst_o,
    output wire [31:0] inst_addr_o,
    output wire [31:0] op1_o,
    output wire [31:0] op2_o,
    output wire [4:0]  rd_addr_o,
    output wire        reg_wen_o
);
    dff_set #(32) dff_1(clk,rst_n,hold_flag_i,`INST_NOP,inst_i,inst_o);
    dff_set #(32) dff_2(clk,rst_n,hold_flag_i,32'b0,inst_addr_i,inst_addr_o);
    dff_set #(32) dff_3(clk,rst_n,hold_flag_i,32'b0,op1_i,op1_o);
    dff_set #(32) dff_4(clk,rst_n,hold_flag_i,32'b0,op2_i,op2_o);
    dff_set #(5)  dff_5(clk,rst_n,hold_flag_i,5'b0,rd_addr_i,rd_addr_o);
    dff_set #(1)  dff_6(clk,rst_n,hold_flag_i,1'b0,reg_wen_i,reg_wen_o);


endmodule