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
    wire [6:0]  opcode;
    wire [4:0]  rd;
    wire [2:0]  func3;
    wire [4:0]  rs1;
    wire [11:0] imm;
    wire [4:0]  shamt;

    wire [6:0] func7;
    wire [4:0] rs2;
    //I型指令
    assign opcode = inst_i[6:0];
    assign rd     = inst_i[11:7];
    assign func3  = inst_i[14:12];
    assign rs1    = inst_i[19:15];
    assign imm    = inst_i[31:20];
    assign shamt  = inst_i[24:20];
    //R型指令
    assign func7  = inst_i[31:25];
    assign rs2    = inst_i[24:20];

    always @(*)begin
        inst_o = inst_i;
        inst_addr_o = inst_addr_i;
        case(opcode)
            //I型指令
            `INST_TYPE_I : begin          
                case(func3) 
                    `INST_ADDI, `INST_SLTI, `INST_SLTIU, `INST_XORI, `INST_ORI, `INST_ANDI: begin
                        rs1_addr_o = rs1;
                        rs2_addr_o = 5'b0;
                        //传操作数
                        op1_o      = rs1_data_i;
                        op2_o      = {{20{imm[11]}},imm};
                        //写回操作
                        reg_wen    = 1'b1;
                        rd_addr_o  = rd;
                    end
                    `INST_SLLI,`INST_SRI: begin
                        rs1_addr_o = rs1;
                        rs2_addr_o = 5'b0;
                        //传操作数
                        op1_o      = rs1_data_i;
                        op2_o      = {27'b0,shamt};
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
            //R型指令 & M型指令
            `INST_TYPE_R_M : begin
                case(func3) 
                    `INST_ADD_SUB : begin   //add 还是 sub需要通过func7进一步判断
                        rs1_addr_o = rs1;
                        rs2_addr_o = rs2;
                        //传操作数
                        op1_o      = rs1_data_i;
                        op2_o      = rs2_data_i;
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
            //J Type B
            `INST_TYPE_B :begin
                case(func3)
                    `INST_BNE,`INST_BEQ : begin
                        rs1_addr_o = rs1;
                        rs2_addr_o = rs2;
                        //传操作数
                        op1_o      = rs1_data_i;
                        op2_o      = rs2_data_i;
                        //写回操作
                        reg_wen    = 1'b0;
                        rd_addr_o  = 5'b0;
                    end
                    default :begin
                        rs1_addr_o = 5'b0;
                        rs2_addr_o = 5'b0;
                        op1_o      = 32'b0;
                        op2_o      = 32'b0;
                        reg_wen    = 1'b0;
                        rd_addr_o  = 5'b0; 
                    end
                endcase
            end
            `INST_JAL: begin
                rs1_addr_o = 5'b0;
                rs2_addr_o = 5'b0;
                op1_o      = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
                op2_o      = 32'b0;
                reg_wen    = 1'b1;
                rd_addr_o  = rd; 
            end
            `INST_LUI: begin
                rs1_addr_o = 5'b0;
                rs2_addr_o = 5'b0;
                op1_o      = {inst_i[31:12],12'b0};
                op2_o      = 32'b0;
                reg_wen    = 1'b1;
                rd_addr_o  = rd; 
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