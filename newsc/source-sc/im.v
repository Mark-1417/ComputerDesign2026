// Instruction Memory with initialization for FPGA
module im(input  [31:2]  addr, output [31:0] dout);
  reg  [31:0] RAM[127:0];
  integer i;  // Verilog 标准语法声明
  
  // Initialize instruction memory with student ID sorting program
  initial begin
    RAM[0]  = 32'h00200113; // addi    x2, x0, 0x02
    RAM[1]  = 32'h00811113; // slli    x2, x2, 8
    RAM[2]  = 32'h01810113; // addi    x2, x2, 0x18
    RAM[3]  = 32'h01011113; // slli    x2, x2, 16
    RAM[4]  = 32'h01000193; // addi    x3, x0, 0x10
    RAM[5]  = 32'h00819193; // slli    x3, x3, 8
    RAM[6]  = 32'h05318193; // addi    x3, x3, 0x18
    RAM[7]  = 32'h00310133; // add     x2, x2, x3
    RAM[8]  = 32'h18202023; // sw      x2, 0x180(x0)
    RAM[9]  = 32'h00800593; // addi    x11, x0, 8
    RAM[10] = 32'h18002783; // lw      x15, 0x180(x0)
    RAM[11] = 32'h00000133; // add     x2, x0, x0
    RAM[12] = 32'h00f00213; // addi    x4, x0, 0x0f
    RAM[13] = 32'h0047f3b3; // and     x7, x15, x4
    RAM[14] = 32'h00211493; // slli    x9, x2, 2
    RAM[15] = 32'h0093d3b3; // srl     x7, x7, x9
    RAM[16] = 32'h00421293; // slli    x5, x4, 4
    RAM[17] = 32'h00010633; // add     x12, x2, x0
    RAM[18] = 32'h000386b3; // add     x13, x7, x0
    RAM[19] = 32'h00110193; // addi    x3, x2, 1
    RAM[20] = 32'h02b18663; // beq     x3, x11, checkswap
    RAM[21] = 32'h0057f433; // and     x8, x15, x5
    RAM[22] = 32'h00219513; // slli    x10, x3, 2
    RAM[23] = 32'h00a45433; // srl     x8, x8, x10
    RAM[24] = 32'h0086a733; // slt     x14, x13, x8
    RAM[25] = 32'h00070663; // beq     x14, x0, incrLoop2
    RAM[26] = 32'h000406b3; // add     x13, x8, x0
    RAM[27] = 32'h00018633; // add     x12, x3, x0
    RAM[28] = 32'h00429293; // slli    x5, x5, 4
    RAM[29] = 32'h00118193; // addi    x3, x3, 1
    RAM[30] = 32'hfd9ff06f; // jal     x0, loop2
    RAM[31] = 32'h00c12733; // slt     x14, x2, x12
    RAM[32] = 32'h00070463; // beq     x14, x0, incrLoop1
    RAM[33] = 32'h02c000ef; // jal     x1, swap
    RAM[34] = 32'h00421213; // slli    x4, x4, 4
    RAM[35] = 32'h00110113; // addi    x2, x2, 1
    RAM[36] = 32'hfab112e3; // bne     x2, x11, loop1
    RAM[37] = 32'h18f02223; // sw      x15, 0x184(x0)
    RAM[38] = 32'hffff0137; // lui     x2, 0xffff0
    RAM[39] = 32'h00416093; // ori     x1, x2, 0x004
    RAM[40] = 32'h00c16113; // ori     x2, x2, 0x00c
    RAM[41] = 32'h30000293; // addi    x5, x0, 0x300
    RAM[42] = 32'h1002f293; // andi    x5, x5, 0x100
    RAM[43] = 32'hfe9ff06f; // jal     x0, result (dead loop)
    // swap procedure
    RAM[44] = 32'h00f00293; // addi    x5, x0, 0x0f
    RAM[45] = 32'h00261513; // slli    x10, x12, 2
    RAM[46] = 32'h00a292b3; // sll     x5, x5, x10
    RAM[47] = 32'h00526333; // or      x6, x4, x5
    RAM[48] = 32'hfff34313; // xori    x6, x6, -1
    RAM[49] = 32'h0067f7b3; // and     x15, x15, x6
    RAM[50] = 32'h00969433; // sll     x8, x13, x9
    RAM[51] = 32'h0087e7b3; // or      x15, x15, x8
    RAM[52] = 32'h00a393b3; // sll     x7, x7, x10
    RAM[53] = 32'h0077e7b3; // or      x15, x15, x7
    RAM[54] = 32'h00008067; // jalr    x0, x1, 0
    
    // Initialize remaining memory to 0 (Verilog standard syntax)
    for (i = 55; i < 128; i = i + 1) begin
      RAM[i] = 32'h00000000;
    end
  end
  
  assign dout = RAM[addr]; // word aligned
endmodule