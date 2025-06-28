module dff_set #(             //创建带同步复位的D触发器，单独创建以便代码复用
          parameter DW = 32
)(
          input wire clk,
          input wire rst_n,
          input wire [DW-1:0] set_data,
          input wire [DW-1:0] data_i,
          output reg [DW-1:0] data_o
);
          always@(posedge clk)begin
                    if(!rst_n)begin
                              data_o    <= set_data;
                    end
                    else begin
                              data_o    <= data_i;
                    end
          end
endmodule