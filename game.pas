{$I game_vbl.pas}
{$I game_dli.pas}

{$I game_const.pas}

var

  DINOState:Byte;
  DINOFallDist:Byte;
  DINOshadowOfs:byte;
  DINOJumpVMove:Shortint;

  joyDir:Byte;
  joyFire,oJoyFire:Boolean;

  pteroState:byte;
  pteroX:ShortInt;

  stoneState:Byte;
  stoneDst:Shortint;
  shadowOfs:Byte;

{$I softspr.pas}

procedure prepare_stage;
var
  x,y:Byte;
  i,j:Byte;

begin
  fillchar(pointer(SCREEN_ADDR),21*40+8,$45);
  fillchar(pointer(SC2_TITLE),5*40+8,$0);
  fillchar(pointer(SC2_TITLE)+5*40+8,16*40+8,$0);
  for j:=$3a to $3f do
  begin
    for i:=0 to 9 do
    begin
      repeat
        x:=RANDOM(40);
        y:=RANDOM(16);
        adr:=SC2_TITLE+208+x+y*40;
      until peek(adr)=0;

      poke(adr,j);
    end;
  end;
  for i:=0 to 9 do
  begin
    j:=RANDOM(6);
    repeat
      x:=RANDOM(40);
      y:=RANDOM(15);
      adr:=sc2_title+248;
    until testCactusSpace(x,y,j);
    adr:=sc2_title+248;
    drawCactus(x,y,j);
  end;
end;

procedure game_fadeIn;
var
  j:word absolute $d9; // d9-da
  v:byte absolute $db;
  k:Byte absolute $dc;
  i:Byte absolute $dd;
  adr:word absolute $de; // de-df

begin
  i:=0;
  repeat
    wait4screen;
    k:=i+FADE_STEP;
    adr:=SCREEN_ADDR;
    for j:=0 to 39 do
    begin
      v:=peek(FAD_TITLE+j);
      if (v>=i) and (v<k) then
        poke(adr,Peek(SC2_TITLE+j));
      inc(adr);
    end;
    adr:=SCREEN_ADDR+44;
    for j:=40 to 79 do
    begin
      v:=peek(FAD_TITLE+j);
      if (v>=i) and (v<k) then
        poke(adr,Peek(SC2_TITLE+j));
      inc(adr);
    end;
    adr:=SCREEN_ADDR+88;
    for j:=80 to 959 do
    begin
      v:=peek(FAD_TITLE+j);
      if (v>=i) and (v<k) then
        poke(adr,Peek(SC2_TITLE+j));
      inc(adr);
    end;
    i:=k;
  until i>69;
end;

procedure game_fadeOut;
var
  j:word absolute $d9; // d9-da
  v:byte absolute $db;
  k:Byte absolute $dc;
  i:Byte absolute $dd;
  adr:word absolute $de; // de-df

begin
  i:=0;
  repeat
    wait4screen;
    k:=i+FADE_STEP;
    adr:=SCREEN_ADDR;
    for j:=0 to 39 do
    begin
      v:=peek(FAD_TITLE+j);
      if (v>=i) and (v<k) then
        poke(adr,$45);
      inc(adr);
    end;
    adr:=SCREEN_ADDR+44;
    for j:=40 to 79 do
    begin
      v:=peek(FAD_TITLE+j);
      if (v>=i) and (v<k) then
        poke(adr,$45);
      inc(adr);
    end;
    adr:=SCREEN_ADDR+88;
    for j:=80 to 959 do
    begin
      v:=peek(FAD_TITLE+j);
      if (v>=i) and (v<k) then
        poke(adr,$45);
      inc(adr);
    end;
    i:=k;
  until i>69;
end;

procedure init_game;
begin
  turnOff;
  DL:=Pointer(DL_GAME);
  CHBAS:=Hi(FNT_GAME);

  FCOL[4]:=$00; FCOL[0]:=$16; FCOL[1]:=$c6; FCOL[2]:=$ca; FCOL[3]:=$1e;
  PCOLR[0]:=$04; PCOLR[1]:=$ca;

  PMGClear;

  prepare_stage;

  dpoke(DL_GAME_ADDR,SCR_GAME);
  dpoke(DL_STAT_ADDR,STATUS_ADDR);

  turnOn(@VBL_Game_Screen,@DLI_Game_Screen,%111110);

  GPRIO:=%100001; // %101000;
  PMBASE:=HI(PMG_ADDR);
  PMCNTL:=3;

  oDINOY:=255;
  DINOX:=0;  DINOY:=128;
  DINOFrm:=0;
  DINOState:=dsNone;
  wait4screen;

  pteroState:=255;
  timer[tmPteroDly]:=200+random(55);
  stoneState:=255;
  stoneDst:=0;

  gameState:=1;
end;

{
 direction frame sprite# bin dec
 Right       0      0    000  0
 Right       1      1    001  0
 Left        0      2    010  2
 Left        1      3    011  2
 Up          0      4    100  4
 Up          1      5    101  4
 Down        0      6    110  6
 Down        1      7    111  6
}
procedure DinoAnim;
var
  sprBase:Byte;
  sx,sy:Byte;
  cnsl:Byte;
  a1,a2:Boolean;

begin
  if (DINOState and (dsJump+dsFall+dsNone+dsHeadStars)=0) and ((DINODX=0) and (DINODY=0)) then
  begin
    DINOState:=DINOState or dsNone;
    DINOFrm:=DINOFrm and 2;
  end;

  if DINOState and dsNone<>0 then exit;
  if timer[tmDinoAnim]>0 then exit;

  timer[tmDinoAnim]:=3;
  if (DINOState and dsHeadStars<>0) then
  begin // gwiazdki nad dinusiem
    if timer[tmStars]<>0 then
      DINOFrm:=8 or (DINOFrm and 1 xor 1)
    else
    begin
      DINOState:=DINOState and (not dsHeadStars) or dsNone;
      DINOFrm:=(DINOState and dsWalk);
    end;
    exit;
  end;

  if DINOState and dsJUMP=0 then
    DINOFrm:=(DINOState and dsWalk) or (DINOFrm and 1 xor 1) // przełączenie klatki spritea
  else
  begin
    if gameState=1 then
      if DINOState and (dsJUMP+dsFall)<>0 then
        DINOFrm:=(DINOState and dsWalk) or (DINOFrm and 1);
  end;


  if DINODX<>0 then // chodzenie lewo/prawo
  begin
    inc(DINOX,DINODX);
    if DINODX>0 then
      dec(DINODX)
    else
      inc(DINODX);
    if (DINOState and (dsJUMP+dsFall)=0) and (timer[tmHit]=0) and ((DINOFrm and 1)=0) then
      PlaySFX(sfxDINOSTEP);
  end;

  if gameState=1 then // ekran pierwszy
  begin
    {$I 'game-dinoanim-logic-scr1.pas'}
  end
  else
  begin // ekran drugi
    {$I 'game-dinoanim-logic-scr2.pas'}
  end;

// character collisions
  if gameState=1 then
  begin
    {$I 'game-dinocollision-logic-scr1.pas'}
  end
  else if gameState=2 then
  begin
    {$I 'game-dinocollision-logic-scr2.pas'}
  end;
end;

procedure DinoControl;
begin
  joyDir:=STICK and $f;
  joyFire:=not STRIG[0];

  if gameState=1 then // -- scena główna
  begin
    if timer[tmHit]=0 then
    begin
      if (DINOState and (dsFall+dsJump)=0) then
        if (joyFire and not oJoyFire) then // -- skok dinusia
        begin
          DINODY:=-8;
          DINOState:=(DINOState and dsWalk) or dsJump;
          DINOshadowOfs:=DINOY+12;
          oJoyFire:=joyFire;
          playSFX(sfxDINOJUMP);
          exit;
        end
        else
          oJoyFire:=joyFire;

      if joy2spr[joyDir]<>255 then // -- ruch dinusia
      begin
        DINOState:=DINOState and (not (dsWalk+dsNone)) or joy2spr[joyDir];
        DINODX:=joy2dx[joyDir];
        if DINOState and (dsFall+dsJump)=0 then
          DINODY:=joy2dy[joyDir]
        else
          DINOJumpVMove:=joy2dy[joyDir];
      end;
    end;
  end
  else if gameState=2 then // -- scena z kraterem
  begin
    if (DINOState and dsHeadStars=0) then
    begin
      if (DINOState and (dsFall+dsJump)=0) then
        if (joyFire and not oJoyFire) then // -- skok dinusia
        begin
          DINODY:=-8;
          DINOState:=(DINOState and dsWalk) or dsJump;
          oJoyFire:=joyFire;
          playSFX(sfxDINOJUMP);
          exit;
        end
        else
          oJoyFire:=joyFire;
    end;
    if joy2spr[joyDir]<>255 then // ruch dinusia
    begin
      if DINOState and dsFall=0 then
        DINOState:=DINOState and (not (dsWalk+dsNone)) or joy2spr[joyDir];

      DINODX:=joy2dx[joyDir];
    end;
  end;
end;

procedure PteroAnim;
begin
  if (timer[tmPteroAnim]=0) and (pteroState<>255) then
  begin
    timer[tmPteroAnim]:=7;
    Adr:=SCREEN_ADDR+40+PteroX;
    drawPtero;
    inc(pteroState,1); if pteroState=4 then pteroState:=1;
    if pteroX>0 then
      dec(pteroX) // ptero przesówa się w lewo
    else
    begin // ptero kończy swój lot
      clearPtero;
      pteroState:=255; // status ptero wyłączony
{$IFNDEF QUICK}
      timer[tmPteroDly]:=25+Random(200); // losowanie nowego czasu na pokazanie się ptero
{$ELSE}
      timer[tmPteroDly]:=10; // losowanie nowego czasu na pokazanie się ptero
{$ENDIF}
    end;
  end;
end;

procedure pteroControl;
var
  a:byte;

begin
  if (pteroState=255) then // gdy wyłączony
  begin
    if timer[tmPteroDly]=0 then // gdy czas pokazania ptero upłyną, wylosuj parametry ptero
    begin
      pteroState:=0; // status ptero w locie
      pteroX:=40; // pozycja startowa prawy margines ekranu
      if gameState=1 then
      begin
        a:=Random(25);
        timer[tmPteroSht]:=a*4; // czas zrzutu
        stoneDst:=15+Random(20); // odległość zrzutu
        stoneState:=0; // status zrzutu oczekuje
      end
      else
      begin // w scenie z kraterem, ptero nie zrzuca
        stoneState:=255;
      end;
    end;
  end
end;

procedure stoneControl;
var
  n:Byte;

begin
  if stoneState=255 then exit; // pomiń, gdy status zrzutu wyłączony
  if timer[tmPteroSht]<>0 then exit; // pomiń, gdy czas zrzutu nie jest osiągnięty

  if (stoneState=0) then // jeżeli status zrzutu oczekuje
  begin // ustal parametry
    STONEX:=40+PteroX*4;
    STONEY:=40;
    stoneState:=1;
    PlaySFX(sfxPTERODROP);
    shadowOfs:=48+stoneDst*4;
  end
  else
  begin
    dec(stoneDst); // zmniejsz dystans zrzutu

    if stoneDst=0 then // jeżeli dystans zrzutu osiągnięty
    begin
      stoneState:=255; // status zrzutu, wyłączony
      adr:=SCREEN_ADDR+84+((STONEY-36) div 8)*40+((STONEX-28) div 4);
      dec(adr,2); // rysuj krater
      DrawCrater;
      STONEX:=0; STONEY:=255;
      PlaySFX(sfxSTONEHIT);

      exit;
    end;

    STONEFrm:=1-STONEFrm;
    stoneState:=1+STONEFrm;

    STONEX:=STONEX-2;
    STONEY:=STONEY+4;

    // rysuj cień
    if stoneDst>10 then n:=0
    else if stoneDst>5 then n:=1
    else if stoneDst>2 then n:=2;
    adr:=SHADOWP2[n];
    move(pointer(adr),_PL2[shadowOfs],4);

    timer[tmPteroSht]:=4; // ustaw timer szybkości zrzutu
  end;
end;

procedure Over_Init;
var
  i:Byte;

begin
  KEYB:=255;
  STONEY:=255; DINOX:=0;
  PMGClear;

  dpoke(DL_STAT_ADDR,GOVER_ADDR);
{$IFNDEF QUICK}
  msx.Init($15);
  game_fadeOut;
  wait(200);
{$ELSE}
  fillChar(pointer(SCREEN_ADDR),21*40+8,$45);
  wait4screen;
{$ENDIF}
end;

procedure game_loop;

begin
{$IFNDEF QUICK}
  msx.Init($c);
  game_fadeIn;
  wait(110);
{$ELSE}
  msx.Init($d);
  move(pointer(SC2_TITLE),pointer(SCREEN_ADDR),21*40+8);
{$ENDIF}
  DINOX:=128;  DINOY:=128;

{$IFNDEF QUICK}
  wait(100);
  msx.Init($f);
{$ENDIF}

  repeat
    DinoAnim;
    PteroAnim;
    DinoControl;
    PteroControl;
    StoneControl;
    if KEYB<>255 then gameState:=3
  until gameState=3;

  Over_Init;
end;