procedure drawCrater; inline;
begin
  poke(Adr,$ac); inc(Adr,1);
  poke(Adr,$ae); inc(Adr,1);
  poke(Adr,$b1); inc(Adr,1);
  poke(Adr,$b2);
end;

function isFree4Tile(x,y:Byte):boolean;
var
  j:ShortInt absolute $73; // global j
  buf:Array[0..12] of byte;

begin
  if ((x>17) and (x<23)) and
     ((y> 6) and (y<10)) then exit(false);

  if (x+wSpr)>39 then x:=39-wSpr;
//  if (y+hSpr)>15 then y:=15-hSpr;
  ofs:=0; j:=hSpr;
  adr:=adr+x+(y-wSpr)*40;
  repeat
    move(pointer(adr),@buf+ofs,wSpr+1);
    inc(ofs,wSpr+1);
    inc(adr,40);
    dec(j);
  until j<0;

  result:=true;
  for j:=0 to ofs-1 do
  begin
    ch1:=buf[j];
    if ((ch1>=$01) and (ch1<=$2b)) then
      exit(false);
  end;
end;

procedure getCactusTile(cactusType:Byte); inline;
begin
  wSpr:=cactusW[cactusType];
  hSpr:=cactusH[cactusType];
  ptr:=word(cactusDef[cactusType]);
end;

procedure getTreeTile(treeType:Byte); inline;
begin
  wSpr:=treeW[treeType];
  hSpr:=treeH[treeType];
  ptr:=word(treeDef[treeType]);
end;

procedure getBushTile(bushType:Byte); inline;
begin
  wSpr:=bushW[bushType];
  hSpr:=0;
  ptr:=word(bushDef[bushType]);
end;

procedure drawTile(x,y:Byte); inline;
begin
  if (x+wSpr)>39 then x:=39-wSpr;
  adr:=adr+x+(y-wSpr)*40;
  repeat
    move(pointer(ptr),pointer(adr),wSpr+1);
    inc(ptr,wSpr+1);
    inc(adr,40);
    dec(hSpr);
  until hSpr<0;
end;

