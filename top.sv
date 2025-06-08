module top(
  input  logic       CLK100MHZ,
  input  logic       CPU_RESETN,

  output logic       CA,
  output logic       CB,
  output logic       CC,
  output logic       CD,
  output logic       CE,
  output logic       CF,
  output logic       CG,
  output logic       DP,
  output logic [7:0] AN,

  input  logic       PS2_CLK,
  input  logic       PS2_DATA
);
  logic [31:0] keycodes;

  kbd KBD(
    .clk_100mhz (CLK100MHZ),
    .kbd_clk    (PS2_CLK),
    .nrst       (CPU_RESETN),
    .kbd_data   (PS2_DATA),
    .keycodes   (keycodes)
  );

  seven_seg SEVEN_SEG(
    .clk_100mhz (CLK100MHZ),
    .nrst       (CPU_RESETN),
    .ca         (CA),
    .cb         (CB),
    .cc         (CC),
    .cd         (CD),
    .ce         (CE),
    .cf         (CF),
    .cg         (CG),
    .dp         (DP),
    .an         (AN),
    .val        (keycodes)
  );
endmodule
