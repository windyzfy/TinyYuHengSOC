module rom(
          //from ifetch
          input wire [31:0] rom_addr_i,
          //to iftech
          output reg [31:0] inst_o
);
          reg [31:0] rom_mem[0:4095];     //16KB = 16384字节 = 4096个32位字
          always @(*)begin
                    inst_o = rom_mem[rom_addr_i >> 2];
          end

endmodule