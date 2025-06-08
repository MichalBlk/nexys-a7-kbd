module kbd(
  input  logic        clk_100mhz,
  input  logic        kbd_clk,
  input  logic        nrst,

  input  logic        kbd_data,

  output logic [31:0] keycodes
);
  logic [31:0] codes, codes_r;
  logic [7:0]  scancode, scancode_r;
  logic [7:0]  pv_scancode, pv_scancode_r;
  logic [3:0]  cnt, cnt_r;

  logic        db_kbd_clk;
  logic        db_kbd_data;

  debouncer #(
    .CNT (40)  
  ) KBD_CLK_DEBOUNCER(
    .clk_100mhz (clk_100mhz),
    .nrst       (nrst),
    .src        (kbd_clk),
    .dst        (db_kbd_clk)
  );

  debouncer #(
    .CNT (40)
  ) KBD_DATA_DEBOUNCER(
    .clk_100mhz (clk_100mhz),
    .nrst       (nrst),
    .src        (kbd_data),
    .dst        (db_kbd_data)
  );

  /*
   * Scancode handling
   */
  always_comb begin
    scancode = scancode_r;

    case (cnt_r)
      1: scancode[0] = db_kbd_data;
      2: scancode[1] = db_kbd_data;
      3: scancode[2] = db_kbd_data;
      4: scancode[3] = db_kbd_data;
      5: scancode[4] = db_kbd_data;
      6: scancode[5] = db_kbd_data;
      7: scancode[6] = db_kbd_data;
      8: scancode[7] = db_kbd_data;
    endcase
  end

  always_ff @(negedge db_kbd_clk)
    scancode_r <= scancode;

  /*
   * Counter handling
   */
  assign cnt = cnt_r == 10 ? 0 : cnt_r + 1;

  always_ff @(negedge db_kbd_clk, negedge nrst)
    if (!nrst)
      cnt_r <= 0;
    else
      cnt_r <= cnt;

  /*
   * Scancode history
   */
  always_comb begin
    codes       = codes_r;
    pv_scancode = pv_scancode_r;

    if (cnt_r == 9 && scancode_r != pv_scancode_r) begin
      codes       = {codes_r[23:0], scancode_r};
      pv_scancode = scancode_r;
    end
  end

  always_ff @(negedge db_kbd_clk, negedge nrst)
    if (!nrst) begin
      codes_r       <= 0;
      pv_scancode_r <= 0;
    end else begin
      codes_r       <= codes;
      pv_scancode_r <= pv_scancode;
    end

  /*
   * Output signals
   */
  assign keycodes = codes_r;
endmodule
