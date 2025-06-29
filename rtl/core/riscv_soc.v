module riscv_soc(
    input wire clk,
    input wire rst_n
);
    wire [31:0] riscv_core_inst_addr_o;
    wire [31:0] rom_inst_o;
    riscv_core riscv_core_inst(
        .clk            (clk),
        .rst_n          (rst_n),
        .inst_i         (rom_inst_o),
        .inst_addr_o    (riscv_core_inst_addr_o)
    );

    rom rom_inst(
        .rom_addr_i     (riscv_core_inst_addr_o),
        .inst_o         (rom_inst_o)
    );
endmodule