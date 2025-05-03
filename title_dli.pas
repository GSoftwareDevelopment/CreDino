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

  lda #$14
  ldx #$08
  ldy #$0e
  sta WSYNC     ; line=152
  sta color0
  stx color1
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

  lda #$94
  sta WSYNC       ;line=160
  sta chbase

  lda #<DLI9
  ldx #>DLI9
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

DLI9:
  sta _regA
  stx _regX

  lda #$90
  sta WSYNC       ;line=184
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
  sty _regY

  lda #$16
  ldx #$ca
  ldy #$1e
  sta WSYNC     ; line=192
  sta color0
  stx color1
  sty color2

  lda #<DLI11
  ldx #>DLI11
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  ldy _regY
  rti

DLI11:
  sta _regA
  stx _regX

  lda #$94
  sta WSYNC       ;line=200
  sta chbase

  lda #<DLI12
  ldx #>DLI12
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

DLI12:
  sta _regA
  stx _regX

  lda #$90
  sta WSYNC       ;line=208
  sta chbase

  lda #<DLI13
  ldx #>DLI13
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

DLI13:
  sta _regA
  stx _regX

  lda #$14
  ldx #$16
  sta WSYNC       ;line=216
  sta color0
  stx color1

  lda #<DLI0
  ldx #>DLI0
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

end;