module regs(
          input wire clk,
          input wire rst_n,
          //from id
          input wire [4:0] reg1_raddr_i,
          input wire [4:0] reg2_raddr_i,
          //to id
          output reg [31:0] reg1_rdata_o,
          output reg [31:0] reg2_rdata_o,
          //form ex
          input wire [4:0] reg_waddr_i,
          input wire [31:0]  reg_wdata_i,
          input wire reg_wen
 );
          reg [31:0] regs[0:31];        //定义寄存器组
          always @(*)begin
                    if(!rst_n)begin
                              reg1_rdata_o = 32'b0;
                    end
                    else if(reg1_raddr_i == 0)begin         //访问0号寄存器，值永远为0
                              reg1_rdata_o = 32'b0;
                    end
                    else if(reg_wen && reg1_raddr_i == reg_waddr_i)begin     //避免写后读数据冒险
                              reg1_rdata_o = reg_wdata_i;
                    end
                    else begin
                        reg1_rdata_o = regs[reg1_raddr_i];
                    end
          end
          
          always @(*)begin
            if(!rst_n)begin
                      reg2_rdata_o = 32'b0;
            end
            else if(reg2_raddr_i == 0)begin         //访问0号寄存器，值永远为0
                      reg2_rdata_o = 32'b0;
            end
            else if(reg_wen && reg2_raddr_i == reg_waddr_i)begin     //避免写后读数据冒险
                      reg2_rdata_o = reg_wdata_i;
            end
            else begin
                reg2_rdata_o = regs[reg2_raddr_i];
            end
          end
          //写寄存器，这里采用时序逻辑
          integer i;
          always @(posedge clk)begin
                if(!rst_n)begin
                    for(i = 0 ; i < 31 ; i = i + 1)begin
                        regs[i] <= 32'b0;
                    end
                end
                else if(reg_wen && reg_waddr_i != 0)begin   //不能写0号寄存器
                    regs[reg_waddr_i] <= reg_wdata_i;
                end      
          end

endmodule