`include "defines.v"
module id(
    //from if_id
    input wire [31:0] inst_i,
    input wire [31:0] inst_addr_i,
    //to regs
    output reg [4:0] rs1_addr_o,
    output reg [4:0] rs2_addr_o,
    //from regs
    input wire [31:0] rs1_data_i,
    input wire [31:0] rs2_data_i,
    //to id_ex
    output reg [31:0] inst_o,
    output reg [31:0] inst_addr_o,
    output reg [31:0] op1_o,
    output reg [31:0] op2_o,
    output reg [4:0]  rd_addr_o,
    output reg reg_wen  //写回使能信号，是否写回rd
);
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] func3;
    wire [4:0] rs1;
    wire [11:0] imm;
    //addi指令
    assign opcode = inst_i[6:0];
    assign rd     = inst_i[11:7];
    assign func3  = inst_i[14:12];
    assign rs1    = inst_i[19:15];
    assign imm    = inst_i[31:20];

    always @(*)begin
        inst_o = inst_i;
        inst_addr_o = inst_addr_i;
        case(opcode)
            `INST_TYPE_I : begin          
                case(func3) 
                    `INST_ADDI : begin
                        rs1_addr_o = rs1;
                        rs2_addr_o = 5'b0;
                        //传操作数
                        op1_o      = rs1_data_i;
                        op2_o      = {{20{imm[11]}},imm};
                        //写回操作
                        reg_wen    = 1'b1;
                        rd_addr_o  = rd;
                    end
                    default : begin
                        rs1_addr_o = 5'b0;
                        rs2_addr_o = 5'b0;
                        op1_o      = 32'b0;
                        op2_o      = 32'b0;
                        reg_wen    = 1'b0;
                        rd_addr_o  = 5'b0;                                                            
                    end
                endcase
            end
            default: begin
                rs1_addr_o = 5'b0;
                rs2_addr_o = 5'b0;
                op1_o      = 32'b0;
                op2_o      = 32'b0;
                reg_wen    = 1'b0;
                rd_addr_o  = 5'b0;    
            end
        endcase

    end

endmodule