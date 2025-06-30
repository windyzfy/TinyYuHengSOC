module tb_soc;
    reg clk;
    reg rst_n;

    wire [31:0] x3  = tb_soc.riscv_soc_inst.riscv_core_inst.regs_inst.regs[3];
    wire [31:0] x26 = tb_soc.riscv_soc_inst.riscv_core_inst.regs_inst.regs[26];
    wire [31:0] x27 = tb_soc.riscv_soc_inst.riscv_core_inst.regs_inst.regs[27];

    always #10 clk = ~clk;

    initial begin
        clk     <= 1'b1;
        rst_n   <=  1'b0;
        #20;
        rst_n   <= 1'b1;
    end

    riscv_soc riscv_soc_inst(
        .clk        (clk),
        .rst_n      (rst_n)
    );

    //rom initial
    initial begin
        $readmemh("rv32ui-p-slti.txt",tb_soc.riscv_soc_inst.rom_inst.rom_mem);
    end
    integer r;

    //display regs
/*    initial begin
        while(1)begin
            @(posedge clk)
            $display("x27 register value id %d",tb_soc.riscv_soc_inst.riscv_core_inst.regs_inst.regs[27]);
            $display("x28 register value id %d",tb_soc.riscv_soc_inst.riscv_core_inst.regs_inst.regs[28]);
            $display("x29 register value id %d",tb_soc.riscv_soc_inst.riscv_core_inst.regs_inst.regs[29]);
            $display("---------------------------");
        end
    end
*/    
    initial begin
        wait(x26 == 32'b1);
        #100;
        if(x27 == 32'b1) begin
			$display("############################");
			$display("########  pass  !!!#########");
			$display("############################");
		end
		else begin
			$display("############################");
			$display("########  fail  !!!#########");
			$display("############################");
			$display("fail testnum = %2d", x3);
			for(r = 0;r < 31; r = r + 1)begin
				$display("x%2d register value is %d",r,tb_soc.riscv_soc_inst.riscv_core_inst.regs_inst.regs[27]);	
			end	
		end
    end
endmodule