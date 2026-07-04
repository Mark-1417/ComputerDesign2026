`include "ctrl_encode_def.v"

module sccomp_top(
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
wire [31:0] dm_addr, dm_din, dm_dout;

reg [31:0]  display_data;
reg [31:0]  original_sid;  
reg [31:0]  sorted_sid;
reg         sort_done;  // 排序完成标志

wire [31:0] im_inst0, im_inst2, im_inst4, im_inst6;
im U_imem_s0(.addr(3'd0), .dout(im_inst0));  // RAM[0]: addi x2, x0, 0x02
im U_imem_s2(.addr(3'd2), .dout(im_inst2));  // RAM[2]: addi x2, x2, 0x18
im U_imem_s4(.addr(3'd4), .dout(im_inst4));  // RAM[4]: addi x3, x0, 0x10
im U_imem_s6(.addr(3'd6), .dout(im_inst6));  // RAM[6]: addi x3, x3, 0x18

assign clk = CLK_100M;
assign reset = ~RESET_N;

// CPU和内存实例化
SCCPU U_SCCPU(
    .clk(clk), .reset(reset), .inst_in(instr), .Data_in(dm_dout),
    .mem_w(MemWrite), .PC_out(PC), .Addr_out(dm_addr), .Data_out(dm_din),
    .reg_sel(5'b00000), .reg_data()  // 不使用reg_sel和reg_data
);

dm U_DM(.clk(clk), .DMWr(MemWrite), .addr(dm_addr), .din(dm_din), .dout(dm_dout));
im U_imem(.addr(PC[31:2]), .dout(instr));

// 捕获排序后学号
always @(posedge clk or posedge reset) begin
    if (reset) begin
        sorted_sid <= 32'h00000000;
    end else begin
        if (MemWrite && dm_addr == 32'h00000184) begin
            sorted_sid <= dm_din;
        end
    end
end

// 检测排序是否完成（PC到达死循环地址）
always @(posedge clk or posedge reset) begin
    if (reset) begin
        sort_done <= 1'b0;
    end else begin
        // 死循环指令地址：0x000000b8（第43条指令，43*4=0xb8）
        if (PC == 32'h000000b8) begin
            sort_done <= 1'b1;
        end
    end
end

// 从IM指令中动态提取学号
always @(posedge clk or posedge reset) begin
    if (reset) begin
        original_sid <= 32'h00000000;
    end else begin
        original_sid <= {im_inst0[27:20], im_inst2[27:20], im_inst4[27:20], im_inst6[27:20]};
    end
end

// 显示选择逻辑
always @(*) begin
    if (sw[8] == 1'b0) begin
        display_data = original_sid;   // 从IM提取的原始学号
    end else if (sort_done) begin
        display_data = sorted_sid;     // 排序完成后显示排序结果
    end else begin
        display_data = 32'h00000000;  // 排序中显示0
    end
end

// 数码管显示
scan_7seg #(.SCAN_DIV_BITS(15)) U_SCAN_7SEG (
    .clk(clk), .rstn(RESET_N), .data(display_data),
    .disp_seg_o(disp_seg), .disp_an_o(disp_an)
);

endmodule