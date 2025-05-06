if DINOState and dsFall=0 then
begin
  if (DINOState and dsJump<>0) then
  begin
    if (DINODY<0) then // podskok
    begin
      inc(DINOY,DINODY);
      inc(DINODY,2);
      if DINOY<=64 then // górna krawędź ekrnu gry
      begin // wyjście z krateru
        gameState:=1;
        dpoke(DL_GAME_ADDR,SCR_GAME);
        PMGClear;
        DINOX:=outDINOX; DINOY:=outDINOY;
        // DINOX:=128; DINOY:=64;
        DINOState:=dsNone;
        DINODX:=0; DINODY:=0;
        playSFX(sfxDINOCOUT);
      end;
      exit;
    end
    else // kończy podskok i zaczyna opadać
      DINOState:=DINOState and (not dsJUMP) or dsFall;

  end;
end
else
begin // dino spada w dół
  if DINODY>0 then
    DINOFallDist:=DINOFallDist+DINODY;
  if DINODY<7 then inc(DINODY,2);
  inc(DINOY,DINODY);
  if DINOY>=183 then // śmierć w kraterze
  begin
    gameState:=3; DINOState:=dsNone;
    DINOX:=0;
  end;
end;
