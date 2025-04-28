procedure TimerReset; Assembler;
asm
  ldy #7
  lda #0
ltmz:
  sta adr.timer,Y
  dey
  bpl ltmz
end;

procedure playSFX(nsfx:Byte);
begin
  if nsfx=$15 then
    MSX.SFX(nsfx,2,1)
  else
    MSX.SFX(nsfx,3,32);
end;

{
procedure doAnimation(); inline;
begin
  if timer[TM_ANIM]=0 then
  begin
    timer[TM_ANIM]:=6;
    asm
      lda MAIN.DLI_GAME_SCREEN.ACTIVE_FONT
      and #$0F
      add #$04
      ora #$90
      sta MAIN.DLI_GAME_SCREEN.ACTIVE_FONT
    end;
  end;
end;

procedure mapIn;
const
  Dfadein:Array[0..39] of Byte = (4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,0);

var
  endPos:Byte;

begin
  ScrScrollFine:=0; mapPos:=0; endPos:=StartX-10;
  Repeat
    doAnimation;
    if timer[TM_SCS]=0 then
    begin
      timer[TM_SCS]:=1;
      moveScreenF(Dfadein[mapPos]);
    end;
  until mapPos=endPos;
end;

procedure doScreenScroll(); inline;
begin
  if (timer[TM_SCS]=0) then
  begin
    if (scrDX>0) then
    begin
      if (scrDx>32) then
        timer[TM_SCS]:=1
      else
        timer[TM_SCS]:=2;

      moveScreenF(1);
    end;
  end;
end;
}
procedure turnOff;
begin
  wait4screen;
  SDMCTL:=0;
  wait4screen;
  IRQST:=$00;
end;

procedure turnOn(VBL,DLI:Pointer; DMACTL:Byte);
begin
  if VBL<>nil then
    SetIntVec(iVBL,VBL);
  if DLI<>nil then
    SetIntVec(iDLI,DLI);
  IRQST:=$C0;

  wait4screen;
  SDMCTL:=DMACTL;
end;

{
procedure decompressScreen(WTR,FNT,SCR:Word);
begin
  if wtr<>0 then
  begin
    fillchar(pointer(WATER_DATA),$100,0);
    unzx0(pointer(WTR),pointer(WATER_DATA));
  end;
  fillchar(pointer(FNT_START),$400,0);
  unzx0(pointer(FNT),pointer(FNT_START));
  fillchar(pointer(START_SCREEN),$5a0,0);
  unzx0(pointer(SCR),pointer(START_SCREEN));
end;
}