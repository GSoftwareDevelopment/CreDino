procedure DLI_Game_Screen; interrupt; assembler;
asm
  _regA = $6D;
  _regX = $6E;
  _regY = $6F;

SKY0:
  sta _regA
  stx _regX

  lda #$82
  sta WSYNC
  sta COLPF4

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

  lda #$84
  sta WSYNC
  sta COLPF4

  lda #<SKY2
  ldx #>SKY2
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

SKY2:
  sta _regA
  stx _regX

  lda #$86
  sta WSYNC
  sta COLPF4

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
  sta COLPF4

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
  sta COLPF4

  lda #<GND0
  ldx #>GND0
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

GND0:
  sta _regA
  stx _regX

  lda #$16
  sta WSYNC
  sta COLPF4

  lda #<STS0
  ldx #>STS0
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

STS0:
  sta _regA
  stx _regX

  lda >FNT_STATUS
  sta WSYNC
  sta chbase
  lda #$c6
  sta COLPF1

  lda #<SKY0
  ldx #>SKY0
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti
end;