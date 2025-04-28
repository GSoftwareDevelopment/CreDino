{$I title_vbl.pas}
{$I title_dli.pas}

procedure init_title;
begin
  turnOff;
  DL:=Pointer(DL_TITLE);
  CHBAS:=Hi(FNT_TITLE);

  FCOL[0]:=$00; FCOL[1]:=$16; FCOL[2]:=$1e; FCOL[3]:=$1e; FCOL[4]:=$00;
  PCOLR[0]:=$04; PCOLR[1]:=$ca;

  PMGClear;

  turnOn(@VBL_Title_Screen,@DLI_Title_Screen,%111111);
end;

procedure title_loop;
begin
  msx.Init($0);
  repeat

  until (CONSOL=6) or (not STRIG[0]);
end;