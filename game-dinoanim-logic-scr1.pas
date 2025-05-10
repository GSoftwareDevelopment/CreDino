if DINOState and (dsJUMP+dsFall)=0 then
begin // chodzenie góra/dół
  if DINODY<>0 then
  begin
    inc(DINOY,DINODY);
    if DINODY>0 then
      dec(DINODY)
    else
      inc(DINODY);
    if DINOY<60 then DINOY:=60;
    if (gameState=1) and (timer[tmHit]=0) and (DINOFrm and 1=0) then
      PlaySFX(sfxDINOSTEP);
  end;
end
else
begin // podskok
  if DINOJumpVMove<>0 then // przemieszczenie dino w pionie
  begin

    if DINOshadowOfs+DINOJumpVMove>=72 then
    begin
      fillChar(_PL0[DINOshadowOfs],4,0);
      inc(DINOY,DINOJumpVMove);
      inc(DINOshadowOfs,DINOJumpVMove);
      if DINOJumpVMove>0 then
        dec(DINOJumpVMove)
      else
        inc(DINOJumpVMove);
    end;
  end;

  if DINOState and dsFall=0 then
  begin
    if (DINOState and dsJump<>0) then
    begin
      if (DINODY<0) then // podskok
      begin
        inc(DINOY,DINODY);
        inc(DINODY,2);


        if DINOshadowOfs<=196 then // cień dinusia
        begin
          adr:=SHADOWP2[0];
          move(pointer(adr),_PL0[DINOshadowOfs],4);
        end;
        exit;
      end
      else // kończy podskok i zaczyna opadać
      begin
        DINOState:=DINOState and (not dsJUMP) or dsFall;
        if DINOshadowOfs<=196 then // cień dinusia
        begin
          adr:=SHADOWP2[0];
          move(pointer(adr),_PL0[DINOshadowOfs],4);
        end;
      end;
    end;
  end
  else
  begin // dino spada w dół
    if DINODY>0 then
      DINOFallDist:=DINOFallDist+DINODY;
    if DINOFallDist<16 then
    begin
      if DINODY<7 then inc(DINODY,2);
      inc(DINOY,DINODY);
      if DINOshadowOfs<=196 then // cień dinusia
      begin
        adr:=SHADOWP2[0];
        move(pointer(adr),_PL0[DINOshadowOfs],4);
      end;
    end
    else
    begin
      DINOState:=(DINOState and dsWalk) or dsNone;
      DINOFrm:=DINOFrm and 3;
      DINOFallDist:=0;
      DINODY:=0;
    end;
  end;

end;
