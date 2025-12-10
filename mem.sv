module mem (
  input  logic        clk, we,
  input  logic [31:0] a, wd,
  output logic [31:0] rd,
  input  logic  [3:0] wm); // wm (write mask) é a máscara de escrita de 4 bits
logic  [31:0] RAM [0:255];

  // initialize memory with instructions or data
  initial
    $readmemh("riscv.hex", RAM);
assign rd = RAM[a[31:2]]; // word aligned

  always_ff @(posedge clk)
    if (we) begin // we (write enable)
      // RAM[a[31:2]] <= wd; // CÓDIGO ANTERIOR: escrita de palavra completa
      
      // NOVA LÓGICA: escrita seletiva de bytes baseada na máscara (wm)
      if (wm[0]) RAM[a[31:2]][ 7: 0] <= wd[ 7: 0]; // Byte 0
      if (wm[1]) RAM[a[31:2]][15: 8] <= wd[15: 8]; // Byte 1
      if (wm[2]) RAM[a[31:2]][23:16] <= wd[23:16]; // Byte 2
      if (wm[3]) RAM[a[31:2]][31:24] <= wd[31:24]; // Byte 3
      
    end
endmodule