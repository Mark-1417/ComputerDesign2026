`timescale 1ns/1ns

module sccomp_tb();
  reg clk;
  reg rstn;
  reg [4:0] reg_sel;
  wire [31:0] reg_data;

  integer i;
  integer cycles;
  reg [1023:0] imem_file;

  sccomp sccomp(.clk(clk), .rstn(rstn), .reg_sel(reg_sel), .reg_data(reg_data));

  initial begin
    if (!$value$plusargs("IMEM=%s", imem_file)) begin
      $display("[ERROR] missing +IMEM=<path>");
      $finish;
    end
    if (!$value$plusargs("CYCLES=%d", cycles)) begin
      cycles = 100;
    end

    $readmemh(imem_file, sccomp.U_imem.RAM);
    for (i = 0; i < 128; i = i + 1) begin
      sccomp.U_DM.dmem[i] = 32'h0000_0000;
    end

    clk = 1'b1;
    rstn = 1'b1;
    reg_sel = 5'd0;
    #10;
    rstn = 1'b0;
  end

  always begin
    #5 clk = ~clk;
  end

  initial begin
    repeat (cycles) @(posedge clk);

    $display("[SNAPSHOT] registers");
    for (i = 0; i < 32; i = i + 1) begin
      $display("[REG] x%0d=%08x", i, sccomp.U_SCCPU.U_RF.rf[i]);
    end

    $display("[SNAPSHOT] memory");
    for (i = 0; i < 128; i = i + 1) begin
      $display("[MEM] m%0d=%08x", i, sccomp.U_DM.dmem[i]);
    end

    $finish;
  end
endmodule