procedure DLI_Game_Screen; interrupt; assembler;
asm
  _regA = $6D;
  _regX = $6E;
  _regY = $6F;
  HPOSP2 = 53250;
  HPOSP3 = 53251;
  HPOSM1 = 53255;

SKY0:
  sta _regA
  stx _regX

  lda #$82
  sta WSYNC
  sta COLPF0

  lda #<SKY1
  ldx #>SKY1
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

SKY1:
  sta _regA
  stx _regX
  sty _regY

  lda #$84
  ldx $75
  ldy $76
  sta WSYNC
  sta COLPF0
  stx HPOSP2
  sty HPOSP3

  lda #<SKY2
  ldx #>SKY2
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  ldy _regY
  rti

SKY2:
  sta _regA
  stx _regX

  lda #$86
  ldx $77
  sta WSYNC
  sta COLPF0
  stx HPOSP2

  lda #<SKY3
  ldx #>SKY3
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

SKY3:
  sta _regA
  stx _regX

  lda #$88
  sta WSYNC
  sta COLPF0

  lda #<SKY4
  ldx #>SKY4
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

SKY4:
  sta _regA
  stx _regX

  lda #$8a
  sta WSYNC
  sta COLPF0

  lda #<GND0_1
  ldx #>GND0_1
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

// --------------

GND0_1:
  sta _regA
  stx _regX

  lda #$16
  ldx $78
  sta WSYNC
  sta COLPF0
  stx HPOSP3
  :8 inx
  stx HPOSM1

  lda #<GND2_3
  ldx #>GND2_3
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

GND2_3:
  sta _regA
  stx _regX

  ldx $79
  sta WSYNC
  stx HPOSP3
  :8 inx
  stx HPOSM1

  lda #<GND4_5
  ldx #>GND4_5
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

GND4_5:
  sta _regA
  stx _regX

  ldx $7A
  sta WSYNC
  stx HPOSP3
  :8 inx
  stx HPOSM1

  lda #<GND6_7
  ldx #>GND6_7
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

GND6_7:
  sta _regA
  stx _regX

  ldx $7B
  sta WSYNC
  stx HPOSP3
  :8 inx
  stx HPOSM1

  lda #<GND8_9
  ldx #>GND8_9
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

GND8_9:
  sta _regA
  stx _regX

  ldx $7C
  sta WSYNC
  stx HPOSP3
  :8 inx
  stx HPOSM1

  lda #<GND10_11
  ldx #>GND10_11
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

GND10_11:
  sta _regA
  stx _regX

  ldx $7D
  sta WSYNC
  stx HPOSP3
  :8 inx
  stx HPOSM1

  lda #<GND12_13
  ldx #>GND12_13
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

GND12_13:
  sta _regA
  stx _regX

  ldx $7E
  sta WSYNC
  stx HPOSP3
  :8 inx
  stx HPOSM1

  lda #<GND14_15
  ldx #>GND14_15
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

GND14_15:
  sta _regA
  stx _regX

  ldx $7F
  sta WSYNC
  stx HPOSP3
  :8 inx
  stx HPOSM1

  lda #<STS0
  ldx #>STS0
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

// --------------

STS0:
  sta _regA
  stx _regX

  lda >FNT_STATUS
  ldx $5F
  sta WSYNC
  sta chbase
  lda #$88
  sta COLPF1
  stx COLPF0

  lda #<STS1
  ldx #>STS1
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

STS1:
  sta _regA
  stx _regX

  lda #$86
  sta WSYNC
  sta COLPF1

  lda #<STS2
  ldx #>STS2
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

STS2:
  sta _regA
  stx _regX

  lda #$84
  sta WSYNC
  sta COLPF1

  lda #<STS3
  ldx #>STS3
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

STS3:
  sta _regA
  stx _regX

  lda #$00
  sta WSYNC
  sta COLPF0

  lda #<SKy0
  ldx #>SKY0
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

end;