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
  sta COLPF2

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
  sta COLPF2

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
  sta COLPF2

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
  sta COLPF2

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
  sta COLPF2

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
  sta COLPF2

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
  ldx #$14
  sta WSYNC
  sta chbase
  lda #$c6
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

  lda #$12
  sta WSYNC
  sta COLPF0

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

  lda #$10
  sta WSYNC
  sta COLPF0

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