{$I title_vbl.pas}
{$I title_dli.pas}

procedure init_title;
begin
  turnOff;
  DL:=Pointer(DL_TITLE);
  CHBAS:=Hi(FNT_TITLE);

  FCOL[4]:=$00; FCOL[0]:=$14; FCOL[1]:=$16; FCOL[2]:=$1e; FCOL[3]:=$0f;

  fillchar(pointer(SCR2_ADDR),960,0);
  PMGClear;

  turnOn(@VBL_Title_Screen,@DLI_Title_Screen,%111110);
end;

procedure title_fadeIn(volFade:Boolean);
var
  j:word absolute $da; // da-db
  v:byte absolute $dc;
  i:Byte absolute $dd;

begin
  i:=0;
  repeat
    wait4screen;
    for j:=0 to 959 do
    begin
      v:=peek(FAD_TITLE+j);
      if (v>=i) and (v<i+FADE_STEP) then
        poke(SCR2_ADDR+j,Peek(SCR_TITLE+j));
    end;
    inc(i,FADE_STEP);
    if volFade then
      setGlobalVolume(i);
  until i>63;
  RMTSetVolume(0);
  KEYB:=255;
end;

procedure title_fadeOut;
var
  j:word absolute $da; // da-db
  v:byte absolute $dc;
  i:Byte absolute $dd;

begin
  i:=0; KEYB:=255;
  repeat
    wait4screen;
    for j:=0 to 959 do
    begin
      v:=peek(FAD_TITLE+j);
      if (v>=i) and (v<i+FADE_STEP) then
        poke(SCR2_ADDR+j,0);
    end;
    inc(i,FADE_STEP);
    setGlobalVolume(63-i);
  until i>63;
  KEYB:=255;
end;

procedure title_loop;
begin
{$IFNDEF QUICK}
  if startVol then setGlobalVolume($f0);
  msx.Init($0);
  title_fadeIn(startVol);
{$ELSE}
  move(pointer(SCR_TITLE),pointer(SCR2_ADDR),960);
{$ENDIF}
  repeat

  until (CONSOL=6) or (not STRIG[0]);
{$IFNDEF QUICK}
  title_fadeOut;
{$ENDIF}
  msx.Stop();
  RMTSetVolume(0);
  startVol:=true;
end;