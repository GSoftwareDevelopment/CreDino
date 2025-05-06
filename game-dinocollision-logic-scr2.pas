sx:=(DINOX-46) div 4;
sy:=(DINOY-64) div 8;
adr:=CRATER_ADDR+40+sx+sy*40+40;
ch1:=peek(adr) and $7f;
inc(adr); ch2:=peek(adr) and $7f;
if ((byte(ch1)>=$5d) and (byte(ch1)<=$5f)) or
    ((byte(ch2)>=$5d) and (byte(ch2)<=$5f)) then
begin // ostre skały
  DINODY:=-8;
  DINOState:=(DINOState and dsWalk) or dsJump;
  DINOFallDist:=0;
  playSFX(sfxDINODIE);
end
else
if ((byte(ch1)>=$42) and (byte(ch1)<=$4a)) or
    ((byte(ch2)>=$42) and (byte(ch2)<=$4a)) then
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
  end;
  DINOY:=64+sy*8; DINODY:=0;
end
else
begin // pusta przestrzeń dino spada
  DINOState:=DINOState and (not dsNone) or dsFall;
end
