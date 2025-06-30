module pc_reg(
    input wire clk,
    input wire rst_n,
    //from ctrl
    input wire [31:0] jump_addr_i,
    input wire        jump_en_i,

    output reg [31:0] pc_addr_o
);
    always @(posedge clk)begin    //同步复位
        if(!rst_n)begin
            pc_addr_o   <=  32'b0;
        end
        else if(jump_en_i)begin
            pc_addr_o   <= jump_addr_i;
        end
        else begin
            pc_addr_o   <= pc_addr_o + 3'd4;
        end
    end
endmodule