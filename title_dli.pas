procedure DLI_Title_Screen; interrupt; assembler;
asm
  _regA = $6D;
  _regX = $6E;
  _regY = $6F;

DLI0:
  sta _regA
  stx _regX

	lda #$1E
	ldx #$14
	sta wsync       ;line=24
	sta color0
	stx color2

  lda #<DLI1
  ldx #>DLI1
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

DLI1:
  sta _regA
  stx _regX

  lda #$20
  sta WSYNC       ;line=88
  sta COLOR2

  lda #<DLI2
  ldx #>DLI2
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

DLI2:
  sta _regA
  stx _regX

  lda #$14
  sta WSYNC       ;line=96
  sta COLOR2

  lda #<DLI3
  ldx #>DLI3
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

DLI3:
  sta _regA
  stx _regX

  lda #$94
  sta WSYNC       ;line=104
  sta chbase

  lda #<DLI4
  ldx #>DLI4
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

DLI4:
  sta _regA
  stx _regX

  lda #$90
  sta WSYNC       ;line=120
  sta chbase

  lda #<DLI5
  ldx #>DLI5
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

DLI5:
  sta _regA
  stx _regX

  lda #$94
  sta WSYNC       ;line=128
  sta chbase

  lda #<DLI6
  ldx #>DLI6
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

DLI6:
  sta _regA
  stx _regX

  lda #$90
  sta WSYNC       ;line=144
  sta chbase

  lda #<DLI7
  ldx #>DLI7
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

DLI7:
  sta _regA
  stx _regX
  sty _regY

  lda #$94
  ldx #$14
  ldy #$1e
  sta WSYNC
  sta chbase
  stx color0
  sty color2

  lda #<DLI8
  ldx #>DLI8
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  ldy _regY
  rti

DLI8:
  sta _regA
  stx _regX

  lda #$90
  sta WSYNC       ;line=184
  sta chbase

  lda #<DLI9
  ldx #>DLI9
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  ldy _regY
  rti

DLI9:
  sta _regA
  stx _regX

  lda #$94
  sta WSYNC       ;line=200
  sta chbase

  lda #<DLI10
  ldx #>DLI10
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

DLI10:
  sta _regA
  stx _regX

  lda #$90
  sta WSYNC       ;line=208
  sta chbase

  lda #<DLI0
  ldx #>DLI0
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

end;