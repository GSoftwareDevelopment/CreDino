sx:=(DINOX-46) div 4;
sy:=(DINOY-60) div 8;
adr:=SCR_GAME+40+sx+sy*40;
ch1:=peek(adr); inc(adr); ch2:=peek(adr);
if (DINOState and (dsJUMP+dsFall)=0) then
begin
  if ((ch1>=$ac) and (ch1<=$b2)) and
     ((ch2>=$ac) and (ch2<=$b2)) then
  begin // wpadnięcie do krateru
    gameState:=2;
    poke(CRATER_ADDR+15*40+20,$5d);
    poke(CRATER_ADDR+15*40+21,$5e);
    poke(CRATER_ADDR+15*40+22,$5f);
    dpoke(DL_GAME_ADDR,CRATER_ADDR);
    PMGClear;
    outDINOX:=DINOX+DINODX*4; outDINOY:=DINOY+DINODY*6;

    DINOY:=68; DINOX:=128;
    DINODX:=0;
    DINODY:=4;
    DINOFallDist:=0;
    PlaySFX(sfxDINOFALL);

    DINOState:=DINOState and (not dsWalk+dsNone);
    DINOState:=DINOState or dsWalkUp+dsFall;
  end
  else
  if ((ch1>=$20) and (ch1<=$2b)) or
     ((ch2>=$20) and (ch2<=$2b)) then
  begin // kaktus
    if timer[tmHit]=0 then
    begin
      DINODX:=-DINODX*2;
      DINODY:=-DINODY*2;
      PlaySFX(sfxDINODIE);
      timer[tmHit]:=10;
      // DINOState:=(DINOState and dsWalk) or dsNone;
      // DINOFrm:=DINOFrm and 3;
    end;
  end
  else
  if ((ch1>=$01) and (ch1<=$17)) or
     ((ch2>=$01) and (ch2<=$17)) then
  begin // kaktus
    if DINODX<0 then DINOX:=50+sx*4
    else
    if DINODX>0 then DINOX:=45+sx*4;
    if DINODY<0 then DINOY:=68+sy*8
    else
    if DINODY>0 then DINOY:=59+sy*8;
    DINODX:=0;
    DINODY:=0;
    timer[tmHit]:=3;
  end;
end;
