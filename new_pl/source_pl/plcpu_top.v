`include "ctrl_encode_def.v"

module plcomp_top(
    input         CLK_100M,
    input         RESET_N,
    input  [15:0] sw,
    output [7:0]  disp_seg,
    output [7:0]  disp_an
);

wire        clk;
wire        reset;
wire [31:0] instr;
wire [31:0] PC;
wire        MemWrite;
wire        MemRead;
wire [31:0] dm_addr, dm_din, dm_dout;

reg [31:0]  display_data;
reg [31:0]  original_sid;
reg [31:0]  sorted_sid;
reg         sort_done;  // 排序完成标志

// 时钟和复位
assign clk = CLK_100M;
assign reset = ~RESET_N;

// 实例化指令存储器用于提取学号
wire [31:0] im_inst0, im_inst2, im_inst4, im_inst6;
im U_imem_s0(.addr(3'd0), .dout(im_inst0));  // RAM[0]: addi x2, x0, 0x02
im U_imem_s2(.addr(3'd2), .dout(im_inst2));  // RAM[2]: slli/addi x2相关


im U_imem_s4(.addr(3'd4), .dout(im_inst4));  // RAM[4]: addi x3, x0, 0x10
im U_imem_s6(.addr(3'd6), .dout(im_inst6));  // RAM[6]: slli/addi x3相关

// 流水线CPU和内存实例化
PLCPU U_PLCPU(
    .clk(clk), .reset(reset), .inst_in(instr), .Data_in(dm_dout),
    .PC_out(PC), .Addr_out(dm_addr), .Data_out(dm_din),
    .mem_w(MemWrite), .mem_r(MemRead)
);

dm U_DM(
    .clk(clk), .DMWr(MemWrite), .DMRe(MemRead),
    .addr(dm_addr), .din(dm_din), .dout(dm_dout)
);

im U_imem(
    .addr(PC[31:2]), .dout(instr)
);

// 从IM指令中提取原始学号
always @(posedge clk or posedge reset) begin
    if (reset) begin
        original_sid <= 32'h00000000;
    end else begin
        // 从指令中提取学号的四个字节
        original_sid <= {im_inst0[27:20], im_inst2[27:20], im_inst4[27:20], im_inst6[27:20]};
    end
end

// 捕获排序后的学号（写入mem[0x184]时）
always @(posedge clk or posedge reset) begin
    if (reset) begin
        sorted_sid <= 32'h00000000;
    end else begin
        if (MemWrite && (dm_addr == 32'h00000184)) begin
            sorted_sid <= dm_din;
        end
    end
end

// 检测排序是否完成（PC到达死循环地址）
always @(posedge clk or posedge reset) begin
    if (reset) begin
        sort_done <= 1'b0;
    end else begin
        // 死循环指令地址：0x000000b8（根据汇编代码计算）
        if (PC == 32'h000000b8) begin
            sort_done <= 1'b1;
        end
    end
end

// 显示选择逻辑
always @(*) begin
    if (sw[8] == 1'b0) begin
        display_data = original_sid;   // 开关8=0显示原始学号
    end else if (sort_done) begin
        display_data = sorted_sid;     // 开关8=1且排序完成显示排序结果
    end else begin
        display_data = 32'hFFFFFFFF;  // 排序中显示全1
    end
end

// 数码管扫描显示
scan_7seg #(.SCAN_DIV_BITS(15)) U_SCAN_7SEG(
    .clk(clk), .rstn(RESET_N), .data(display_data),
    .disp_seg_o(disp_seg), .disp_an_o(disp_an)
);

endmodule
