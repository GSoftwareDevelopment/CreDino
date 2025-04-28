procedure DLI_Title_Screen; interrupt; assembler;
asm
  _regA = $6D;
  _regX = $6E;
  _regY = $6F;

dli0:
  sta _regA
  stx _regX

  lda #$94
  sta WSYNC
  sta chbase

  lda #<DLI1
  ldx #>DLI1
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

dli1:
  sta _regA
  stx _regX

  lda #$90
  sta WSYNC
  sta chbase

  lda #<DLI2
  ldx #>DLI2
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

dli2:
  sta _regA
  stx _regX

  lda #$94
  sta WSYNC
  sta chbase

  lda #<DLI3
  ldx #>DLI3
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

dli3:
  sta _regA
  stx _regX

  lda #$90
  sta WSYNC
  sta chbase

  lda #<DLI4
  ldx #>DLI4
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

dli4:
  sta _regA
  stx _regX

  lda #$94
  sta WSYNC
  sta chbase

  lda #<DLI5
  ldx #>DLI5
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

dli5:
  sta _regA
  stx _regX

  lda #$90
  sta WSYNC
  sta chbase

  lda #<DLI0
  ldx #>DLI0
  sta VDSLST
  stx VDSLST+1

  lda _regA
  ldx _regX
  rti

end;