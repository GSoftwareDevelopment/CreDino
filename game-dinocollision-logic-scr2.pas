sx:=(DINOX-46) div 4;
sy:=(DINOY-64) div 8;

adr:=CRATER_ADDR+40+sx+sy*40; // przed stopami dinusia
ch1:=peek(adr) and $7f;
inc(adr,1); ch2:=peek(adr) and $7f;
if ((ch1=$45) or (ch2=$45)) then
begin // pełna skała
  if DINODX<0 then
    DINOX:=50+sx*4
  else
    DINOX:=46+sx*4;
  DINODX:=0;
  // DINOState:=(DINOState and dsWalk) or dsNone;
  timer[tmHit]:=3;
//  timer[tmDinoAnim]:=3;
end;

adr:=CRATER_ADDR+80+sx+sy*40; // pod stopami dinusia
ch1:=peek(adr) and $7f;
inc(adr); ch2:=peek(adr) and $7f;
if ((ch1>=$5d) and (ch1<=$5f)) or
    ((ch2>=$5d) and (ch2<=$5f)) then
begin // ostre skały
  if (DINOState and dsFall)<>0 then
  begin
    DINODY:=-8;
    DINOState:=(DINOState and dsWalk) or dsJump;
    DINOFallDist:=0;
    playSFX(sfxDINODIE);
  end;
end
else
if ((ch1>=$42) and (ch1<=$4a)) or
    ((ch2>=$42) and (ch2<=$4a)) then
begin // podłoże
  if (DINOState and dsFall)<>0 then
  begin // jeżeli spadał...
    if DINOFallDist>24 then
    begin // upadek z wysokości
      if DINOState and dsWalk=dsWalkUp then
        DINOState:=(DINOState and (not dsWalk)) or dsWalkRight;
      DINOState:=(DINOState and dsWalk) or dsHeadStars;
      Timer[tmStars]:=75;
      playSFX(sfxDINOBUM);
    end
    else
    begin
      DINOState:=(DINOState and dsWalk) or dsNone;
      DINOFrm:=DINOFrm and 3;
    end;
    DINOFallDist:=0;
    DINOY:=64+sy*8; DINODY:=0;
  end;
end
else
begin // pusta przestrzeń dino spada
  DINOState:=DINOState and (not dsNone) or dsFall;
end
