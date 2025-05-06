var
  ofs:Byte absolute $db;
  ch1:Byte absolute $dc;
  ch2:Byte absolute $dd;
  adr:word absolute $de; // de-df
  wCactus,hCactus:Shortint;
  buf:Array[0..8] of byte;

procedure drawPtero; inline;
begin
  if pteroState=1 then
  begin
      poke(Adr,$60); inc(Adr);
      poke(Adr,$61); inc(Adr);
      poke(Adr,$62); inc(Adr);
      poke(Adr,$63); inc(Adr);
      poke(Adr,$0);
  end
  else
  begin
      poke(Adr,$64); inc(Adr);
      poke(Adr,$65); inc(Adr);
      poke(Adr,$66); inc(Adr);
      poke(Adr,$67); inc(Adr);
      poke(Adr,$0);
  end;
end;

procedure clearPtero; inline;
begin
  poke(Adr,$0); inc(Adr);
  poke(Adr,$0); inc(Adr);
  poke(Adr,$0); inc(Adr);
  poke(Adr,$0);
end;

procedure drawCrater; inline;
begin
  poke(Adr,$2c); inc(Adr,1);
  poke(Adr,$2d); inc(Adr,1);
  poke(Adr,$2e); inc(Adr,1);
  poke(Adr,$2f);
end;

const
  ctWidth :array[0..5] of byte = (1,1,2,2,2,2);
  ctHeight:array[0..5] of byte = (1,1,1,2,2,2);

  cactus_def0:array[0..3] of byte = ($22,$20,$25,$26);
  cactus_def1:array[0..3] of byte = ($20,$21,$29,$24);
  cactus_def2:array[0..5] of byte = ($22,$20,$21,$25,$2B,$24);
  cactus_def3:array[0..8] of byte = ($00,$20,$21,$22,$23,$24,$25,$26,$00);
  cactus_def4:array[0..8] of byte = ($22,$20,$21,$25,$2A,$24,$00,$27,$00);
  cactus_def5:array[0..8] of byte = ($22,$20,$00,$25,$28,$21,$00,$29,$24);

  cactusDef:array[0..5] of pointer = (
    @cactus_def0,
    @cactus_def1,
    @cactus_def2,
    @cactus_def3,
    @cactus_def4,
    @cactus_def5
  );

function testCactusSpace(x,y,cactusType:Byte):boolean;
var
  j:ShortInt;

begin
  if (x>17) and (x<23) and (y>10) and (y<14) then exit;
  wCactus:=ctWidth[cactusType];
  hCactus:=ctHeight[cactusType];
  if (x+wCactus)>39 then x:=39-wCactus;
//  if (y+hCactus)>15 then y:=15-hCactus;
  ofs:=0; j:=hCactus;
  adr:=adr+x+(y-wCactus)*40;
  repeat
    move(pointer(adr),@buf+ofs,wCactus+1);
    inc(ofs,wCactus+1);
    inc(adr,40);
    dec(j);
  until j<0;

  result:=true;
  for j:=0 to (wCactus+1)*(hCactus+1)-1 do
  begin
    ch1:=buf[j];
    if ((ch1>=$20) and (ch1<=$2b)) then
      exit(false);
  end;
end;

procedure drawCactus(x,y,cactusType:Byte); inline;
begin
  wCactus:=ctWidth[cactusType];
  hCactus:=ctHeight[cactusType];
  if (x+wCactus)>39 then x:=39-wCactus;
//  if (y+hCactus)>15 then y:=15-hCactus;
  ofs:=0;
  adr:=adr+x+(y-wCactus)*40;
  repeat
    move(cactusDef[cactusType]+ofs,pointer(adr),wCactus+1);
    inc(ofs,wCactus+1);
    inc(adr,40);
    dec(hCactus);
  until hCactus<0;
end;

