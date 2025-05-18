const
  _DINO0 = SPR_ADDR;
  DINOP0:Array[0..9] of word = (_DINO0+ 0*16, _DINO0+ 1*16, _DINO0+ 2*16, _DINO0+ 3*16, _DINO0+ 4*16, _DINO0+ 5*16, _DINO0+ 6*16, _DINO0+ 7*16, _DINO0+ 8*16, _DINO0+ 9*16);
  _DINO1 = _DINO0+10*16;
  DINOP1:Array[0..9] of word = (_DINO1+ 0*16, _DINO1+ 1*16, _DINO1+ 2*16, _DINO1+ 3*16, _DINO1+ 4*16, _DINO1+ 5*16, _DINO1+ 6*16, _DINO1+ 7*16, _DINO1+ 8*16, _DINO1+ 9*16);

  _STONE = _DINO1+10*16;
  STONEP2:Array[0..9] of word = (_STONE+ 0*16, _STONE+ 1*16, _STONE+ 2*16, _STONE+ 3*16, _STONE+ 4*16, _STONE+ 5*16, _STONE+ 6*16, _STONE+ 7*16, _STONE+ 8*16, _STONE+ 9*16);

  _SHADOW = _STONE+10*16;
  SHADOW:Array[0..2] of word = (_SHADOW+ 0*4, _SHADOW+ 1*4, _SHADOW+ 2*4);

  _PTERO0 = _SHADOW+3*4;
  PTEROP0:Array[0..3] of word = (_PTERO0+ 0*8, _PTERO0+ 1*8, _PTERO0+ 2*8, _PTERO0+ 3*8);
  _PTERO1 = _PTERO0+4*8;
  PTEROP1:Array[0..3] of word = (_PTERO1+ 0*8, _PTERO1+ 1*8, _PTERO1+ 2*8, _PTERO1+ 3*8);

  _BUG1 = _PTERO1+4*8;
  ANTP:Array[0..3] of word = (_BUG1+ 0*8, _BUG1+ 1*8, _BUG1+ 2*8, _BUG1+ 3*8);
  _BUG2 = _BUG1+4*8;
  ANTM:Array[0..3] of word = (_BUG2+ 0*8, _BUG2+ 1*8, _BUG2+ 2*8, _BUG2+ 3*8);

  _BUG3 = _BUG2+4*8;
  FLYP:Array[0..3] of word = (_BUG3+ 0*12, _BUG3+ 1*12, _BUG3+ 2*12, _BUG3+ 3*12);
  _BUG4 = _BUG3+4*12;
  FLYM:Array[0..3] of word = (_BUG4+ 0*12, _BUG4+ 1*12, _BUG4+ 2*12, _BUG4+ 3*12);

var
  DINOX:Byte      absolute $60;
  DINOY:Byte      absolute $01;
  DINODX:ShortInt absolute $62;
  DINODY:Shortint absolute $63;
  oDINOY:Byte     absolute $64;
  DINOFrm:Byte    absolute $65;
  oDINOFrm:Byte   absolute $66;
  outDINOX:Byte;
  outDINOY:Byte;

  STONEX:Byte;
  STONEY:Byte;
  STONEDX:Shortint;
  STONEDY:Shortint;
  oSTONEY:Byte;
  STONEFrm:Byte;
  oSTONEFrm:Byte;

  MultiP:Array[0..9] of byte absolute $75;

procedure putDINO;
var
  dy:Shortint;
  z:Byte;

begin
  if DINOX=0 then exit;
  if DINOX<48 then DINOX:=48;
  if DINOX>200 then DINOX:=200;
  HPOSP[0]:=DINOX;
  HPOSP[1]:=DINOX;
  if oDINOY<>DINOY then
  begin
    if DINOY<40 then DINOY:=40;
    if DINOY>184 then DINOY:=184;
    if DINOY<oDINOY then // skasuj dolną "różnice"
    Begin
      dy:=oDINOY-DINOY; if dy>16 then dy:=16;
      z:=oDINOY+16-dy;
    end
    else
    begin // skasuj górną "różnice"
      dy:=DINOY-oDINOY; if dy>16 then dy:=16;
      z:=oDINOY;
    end;
    if z<>0 then
    begin
      asm
        txa:pha
        ldy z
        ldx dy
        lda #0
      lzero:
        sta adr._PL0,y
        sta adr._PL1,y
        iny
        dex
        bpl lzero
        pla:tax
      end;
    end;
  end
  else
    z:=0;
  if (DINOFrm<>oDINOFrm) or (oDINOY<>DINOY) then
  begin

    asm
      txa:pha
      lda DINOFrm
      asl @
      tax

      lda adr.DINOP0,x
      sta ptr1
      lda adr.DINOP0+1,x
      sta ptr1+1

      lda adr.DINOP1,x
      sta ptr2
      lda adr.DINOP1+1,x
      sta ptr2+1

      ldy #0
      ldx DINOY
    ldraw:
      lda (ptr1),y
      sta adr._PL0,x
      lda (ptr2),y
      sta adr._PL1,x
      inx
      iny
      cpy #16
      bne ldraw
      pla:tax
    end;
    oDINOFrm:=DINOFrm;
    oDINOY:=DINOY;
  end;
end;

procedure putSTONE;
var
  dy:Shortint;
  z:Byte;

begin
  MultiP[2]:=STONEX;
  if oSTONEY<>STONEY then
  begin
    if STONEY=255 then
    begin
      asm
        txa:pha
        ldy oSTONEY
        ldx #16
        lda #0
      lzero1:
        sta adr._PL2,y
        iny
        dex
        bpl lzero1
        pla:tax
      end;
      exit;
    end
    else
    begin
      if STONEY<32 then STONEY:=32;
      if STONEY>184 then STONEY:=184;
    end;
    if STONEY<oSTONEY then // skasuj dolną "różnice"
    Begin
      dy:=oSTONEY-STONEY; if dy>16 then dy:=16;
      z:=oSTONEY+16-dy;
    end
    else
    begin // skasuj górną "różnice"
      dy:=STONEY-oSTONEY; if dy>16 then dy:=16;
      z:=oSTONEY;
    end;
    if z<>0 then
    begin
      asm
        txa:pha
        ldy z
        ldx dy
        lda #0
      lzero:
        sta adr._PL2,y
        iny
        dex
        bpl lzero
        pla:tax
      end;
    end;
  end
  else
    z:=0;
  if (STONEFrm<>oSTONEFrm) or (oSTONEY<>STONEY) then
  begin
    asm
      txa:pha
      lda STONEFrm
      asl @
      tax

      lda adr.STONEP2,x
      sta ptr1
      lda adr.STONEP2+1,x
      sta ptr1+1

      ldy #0
      ldx STONEY
    ldraw:
      lda (ptr1),y
      sta adr._PL2,x
      inx
      iny
      cpy #16
      bne ldraw
      pla:tax
    end;
    oSTONEFrm:=STONEFrm;
    oSTONEY:=STONEY;
  end;
end;


procedure PMGClear; Assembler;
asm
    ldy #0
    lda #0
    sta 53248
    sta 53249
    sta 53250
    sta 53251
  lzero:
    sta adr._MIS,y
    sta adr._PL0,y
    sta adr._PL1,y
    sta adr._PL2,y
    sta adr._PL3,y
    dey
    bne lzero
end;
