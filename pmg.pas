const
  DINOP0:Array[0..9] of word = (SPR_ADDR+   0, SPR_ADDR+  16, SPR_ADDR+  32, SPR_ADDR+  48, SPR_ADDR+  64, SPR_ADDR+  80, SPR_ADDR+  96, SPR_ADDR+ 112, SPR_ADDR+ 128, SPR_ADDR+ 144);
  DINOP1:Array[0..9] of word = (SPR_ADDR+ 160, SPR_ADDR+ 176, SPR_ADDR+ 192, SPR_ADDR+ 208, SPR_ADDR+ 224, SPR_ADDR+ 240, SPR_ADDR+ 256, SPR_ADDR+ 272, SPR_ADDR+ 288, SPR_ADDR+ 304);

  STONEP2:Array[0..1] of word = (SPR_ADDR+ 320, SPR_ADDR+ 336);

var
  PCOLR:Array[0..3] of byte     absolute 704;
  SDMCTL:Byte                   absolute 559;
  GPRIO:Byte                    absolute 623;
  [Volatile] SIZEP:Array[0..3] of byte absolute 53256;
  [Volatile] HPOSP:Array[0..3] of byte absolute 53248;
  [Volatile] HPOSM:Array[0..3] of byte absolute 53252;
  [Volatile] SIZEM:Byte         absolute 53260;

  [Volatile] PMBASE:Byte        absolute 54279;
  [Volatile] PMCNTL:Byte        absolute 53277;

  _PL0:Array[0..255] of byte    absolute PMG_ADDR+ 1024;
  _PL1:Array[0..255] of byte    absolute PMG_ADDR+ 1280;
  _PL2:Array[0..255] of byte    absolute PMG_ADDR+ 1536;

  DINOX:Byte absolute $56;
  DINOY:Byte absolute $57;
  DINODX:ShortInt;
  DINODY:Shortint;
  oDINOY:Byte;
  DINOFrm:Byte;
  oDINOFrm:Byte;
  outDINOX, outDINOY:Byte;

  STONEX:Byte;
  STONEY:Byte;
  STONEDX:Shortint;
  STONEDY:Shortint;
  oSTONEY:Byte;
  STONEFrm:Byte;
  oSTONEFrm:Byte;

procedure putDINO;
var
  dy:Shortint;
  z:Byte;

begin
  if DINOX<48 then DINOX:=48;
  if DINOX>212 then DINOX:=212;
  HPOSP[0]:=DINOX;
  HPOSP[1]:=DINOX;
  if oDINOY<>DINOY then
  begin
    if DINOY<64 then DINOY:=64;
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
  HPOSP[2]:=STONEX;
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
  lzero:
    sta adr._PL0,y
    sta adr._PL1,y
    dey
    bne lzero
end;
