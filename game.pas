{$I game_vbl.pas}
{$I game_dli.pas}

{$I game_const.pas}

var
  ofs:Byte absolute $db;
  ch1:Byte absolute $dc;
  ch2:Byte absolute $dd;
  adr:word absolute $50; // 50,51
  ptr:word absolute $52; // 52,53
  wSpr,hSpr:Shortint;

  DINOState:Byte          absolute $5a;
  DINOFallDist:Byte       absolute $5b;
  DINOshadowOfs:Byte      absolute $5c;
  DINOJumpVMove:Shortint  absolute $5d;

  joyDir:Byte;
  joyFire,oJoyFire:Boolean;

  pteroState:byte;//         absolute $5a;
  pteroX:ShortInt;//         absolute $5b;

  stoneState:Byte;//         absolute $5c;
  stoneDst:Shortint;//       absolute $5d;
  shadowOfs:Byte;//          absolute $5e;

  bugX:Array[0..7] of Byte absolute $78;    // 0 is not active bug
  bugType:Array[0..7] of Byte;

  x:Byte absolute $70;
  y:Byte absolute $71;
  i:Byte absolute $72;
  j:Byte absolute $73;
  k:Byte absolute $74;

  _bugX:Byte;
  _bug:Byte;
  _bugType:Byte;
  _bugDir:Byte;

{$I softspr.pas}

procedure pushRandomBug;
begin
  j:=RANDOM(2);
  case j of
    0: Begin bugX[i]:=200; bugType[i]:=RANDOM(2)*4; end;
    1: begin bugX[i]:=30; bugType[i]:=2+RANDOM(2)*4; end;
  end;
end;

procedure ResetBugs;
begin
  for i:=0 to 7 do
  begin
    bugX[i]:=0;
    bugType[i]:=0;
  end;
end;

procedure prepare_stage;
var
  tile:Byte absolute $74; // global k

begin
  ResetBugs;
  fillchar(pointer(SCREEN_ADDR),21*40+8,$45);
  fillchar(pointer(SCR2_ADDR),5*40+8,$0);
  fillchar(pointer(SCR2_ADDR)+5*40+8,16*40+8,$0);

  for i:=0 to 4 do
  begin
    tile:=RANDOM(6);
    getCactusTile(tile);
    repeat
      x:=RANDOM(40);
      y:=RANDOM(15);
      adr:=SCR2_ADDR+288;
    until isFree4Tile(x,y);
    adr:=SCR2_ADDR+288; drawTile(x,y);
  end;

  for i:=0 to 5 do
  begin
    tile:=RANDOM(4);
    getTreeTile(tile);
    repeat
      x:=RANDOM(40);
      y:=RANDOM(15);
      adr:=SCR2_ADDR+288;
    until isFree4Tile(x,y);
    adr:=SCR2_ADDR+288; drawTile(x,y);
  end;

  for i:=0 to 15 do
  begin
    tile:=RANDOM(5);
    getBushTile(tile);
    repeat
      x:=RANDOM(40);
      y:=RANDOM(15);
      adr:=SCR2_ADDR+328;
    until isFree4Tile(x,y);
    adr:=SCR2_ADDR+328; drawTile(x,y);
  end;

  for tile:=$3a to $3f do
  begin
    for i:=0 to 9 do
    begin
      repeat
        x:=RANDOM(40);
        y:=RANDOM(16);
        adr:=SCR2_ADDR+208+x+y*40;
      until peek(adr)=0;

      poke(adr,tile);
    end;
  end;

end;

procedure game_fadeIn;
var
  j:word absolute $52; // global ptr
  v:byte absolute $dd; // global ch2;

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
        poke(adr,Peek(SCR2_ADDR+j));
      inc(adr);
    end;
    adr:=SCREEN_ADDR+44;
    for j:=40 to 79 do
    begin
      v:=peek(FAD_TITLE+j);
      if (v>=i) and (v<k) then
        poke(adr,Peek(SCR2_ADDR+j));
      inc(adr);
    end;
    adr:=SCREEN_ADDR+88;
    for j:=80 to 959 do
    begin
      v:=peek(FAD_TITLE+j);
      if (v>=i) and (v<k) then
        poke(adr,Peek(SCR2_ADDR+j));
      inc(adr);
    end;
    v:=i shr 3; if v>6 then v:=6;
    poke($5f,$10+v);
    i:=k;
  until i>69;
end;

procedure game_fadeOut;
var
  j:word absolute $52; // global ptr
  v:byte absolute $dd; // global ch2;

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
    for j:=80 to 959-3*40 do
    begin
      v:=peek(FAD_TITLE+j);
      if (v>=i) and (v<k) then
        poke(adr,$45);
      inc(adr);
    end;
    v:=i shr 3; if v>6 then v:=6;
    poke($5f,$16-v);
    i:=k;
  until i>69;
  poke($5f,$00);
end;

procedure init_game;
begin
  turnOff;
  DL:=Pointer(DL_GAME);
  CHBAS:=Hi(FNT_GAME);

  FCOL[4]:=$00; FCOL[0]:=$16; FCOL[1]:=$c6; FCOL[2]:=$ca; FCOL[3]:=$1e;
  PCOLR[0]:=$04; PCOLR[1]:=$aa;

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
  sx:Byte absolute $70; {global x}
  sy:Byte absolute $71; {global y}

begin
  if (DINOState and (dsJump+dsFall+dsNone+dsHeadStars)=0) and ((DINODX=0) and (DINODY=0)) then
  begin
    DINOState:=DINOState or dsNone;
    DINOFrm:=DINOFrm and 2;
  end;

// kolizja PM

  if HIT<>0 then
  begin
    if DINOState and (dsFall+dsJump)=0 then
      sy:=DINOY+15      // tuż pod stopami Dino
    else
      sy:=DINOshadowOfs+2;
    i:=(sy-72) div 16;  // numer robaka
    x:=DINOX+7;         // pozycja x, prawej strony Dino

    // typ tobaka
    _bugType:=bugType[i] shr 2;
    case _bugType of
      0: // mrówka
      begin
        j:=72+i*16+10;  // pozycja y, góry mrówki
        k:=j+5;         // pozycja y, dołu mrówki
        if (sy>=j) and (sy<=k) then
        begin
          j:=BugX[i];   // pozycja x, lewej strony robaka
          k:=j+7;       // pozycja x, prawej strony robaka

          if ((j>=DINOX) and (j<=x)) or
            ((k>=DINOX) and (k<=x)) then
          begin // dino jest na mrówce
            if DINOState and dsFall<>0 then
            begin
              BugX[i]:=0;
              PlaySFX(sfxDINOCOUT);
            end;
          end;
      end;
      end;
    end;
  end;

  if DINOState and dsNone<>0 then exit;
  if timer[tmDinoAnim]>0 then exit;
  timer[tmDinoAnim]:=3;

// wspólna logika scen
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

  if gameState=1 then // scena pierwsza
  begin
    {$I 'game-dinoanim-logic-scr1.pas'}
  end
  else
  begin // scena druga
    {$I 'game-dinoanim-logic-scr2.pas'}
  end;

// kolizja po znakach
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
var
  firePressed:Boolean absolute $56;
  fireReleased:Boolean absolute $57;

begin
  joyDir:=STICK and $f;
  joyFire:=not STRIG[0];

  if (joyFire<>oJoyFire) then
  begin
    if joyFire then
    begin
      if timer[tmFire]=0 then
        timer[tmFire]:=10;
      firePressed:=True;
    end
    else
      fireReleased:=True;
    oJoyFire:=joyFire;
  end
  else
  if timer[tmFire]=0 then
  begin
    firePressed:=False;
    fireReleased:=False;
  end;

  if timer[tmHit]>0 then Exit;

  if gameState=1 then // -- scena pierwsza
  begin
    if (DINOState and (dsFall+dsJump)=0) then
      if (fireReleased) and (timer[tmFire]>0) then // -- skok dinusia
      begin
        DINODY:=-8;
        DINOState:=(DINOState and dsWalk) or dsJump;
        DINOshadowOfs:=DINOY+12;
        playSFX(sfxDINOJUMP);
        exit;
      end;

    if joy2spr[joyDir]<>255 then // -- ruch dinusia we wszystkich kierunkach
    begin
      DINOState:=DINOState and (not (dsWalk+dsNone)) or joy2spr[joyDir];
      DINODX:=joy2dx[joyDir];
      if DINOState and (dsFall+dsJump)=0 then
        DINODY:=joy2dy[joyDir]
      else
        DINOJumpVMove:=joy2dy[joyDir];
    end;
  end
  else if gameState=2 then // -- scena druga (z kraterem)
  begin
    if (DINOState and dsHeadStars=0) then
    begin
      if (DINOState and (dsFall+dsJump)=0) then
        if (fireReleased) and (timer[tmFire]>0) then // -- skok dinusia
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

    if joy2spr[joyDir]<>255 then // ruch dinusia tylko w poziomie
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
    timer[tmPteroAnim]:=3;
    Adr:=SCREEN_ADDR+40+PteroX;
    i:=pteroState-1;
    Move(Pointer(PteroP0[i]),_PL2[40],8);
    Move(Pointer(PteroP1[i]),_PL3[40],8);
    j:=32+pteroX*2;
    MultiP[0]:=j;
    MultiP[1]:=j+8;
//    drawPtero;
    if pteroX and 1=0 then
    begin
      inc(pteroState,1); if pteroState>4 then pteroState:=1;
    end;
    if pteroX>0 then
      dec(pteroX) // ptero przesówa się w lewo
    else
    begin // ptero kończy swój lot
      MultiP[0]:=0;
      MultiP[1]:=0;
      pteroState:=255; // status ptero wyłączony

      timer[tmPteroDly]:=25+Random(200); // losowanie nowego czasu na pokazanie się ptero

    end;
  end;
end;

procedure pteroControl;
begin
  if (pteroState=255) then // gdy wyłączony
  begin
    if timer[tmPteroDly]=0 then // gdy czas pokazania ptero upłyną, wylosuj parametry ptero
    begin
      pteroState:=0; // status ptero w locie
      pteroX:=88; // pozycja startowa prawy margines ekranu
      if gameState=1 then
      begin
        k:=Random(25);
        timer[tmPteroSht]:=k*4; // czas zrzutu
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
begin
  if stoneState=255 then exit; // pomiń, gdy status zrzutu wyłączony
  if timer[tmPteroSht]<>0 then exit; // pomiń, gdy czas zrzutu nie jest osiągnięty

  if (stoneState=0) then // jeżeli status zrzutu oczekuje
  begin // ustal parametry
    STONEX:=40+PteroX*2;
    STONEY:=48;
    stoneState:=1;
    PlaySFX(sfxPTERODROP);
    shadowOfs:=56+stoneDst*4;
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
    if stoneDst>10 then k:=0
    else if stoneDst>5 then k:=1
    else if stoneDst>2 then k:=2;
    adr:=SHADOW[k];
    move(pointer(adr),_PL2[shadowOfs],4);

    timer[tmPteroSht]:=4; // ustaw timer szybkości zrzutu
  end;
end;

procedure BugAnim;
begin
  if gameState=2 then Exit;
  if timer[tmBugsAnim]=0 then
  begin
    timer[tmBugsAnim]:=2;
    for i:=0 to 7 do
    begin
      _bugX:=BugX[i];
      if _bugX>0 then
      begin
        _bug:=bugType[i] xor 1;
        bugType[i]:=_bug;
        _bugType:=_bug shr 2;
        _bugDir:=_bug and 2;
        _bug:=_bug and 3;
        j:=72+i*16;
        case _bugType of
          0: // ant
          begin
            inc(j,8);
            move(pointer(ANTP[_bug]),_PL3[j],8);
            move(pointer(ANTM[_bug]),_MIS[j],8);
          end;
          1: // fly
          begin
            inc(j,4);
            move(pointer(FLYP[_bug]),_PL3[j],12);
            move(pointer(FLYM[_bug]),_MIS[j],12);
          end;
        end;
        if _bugDir=0 then
          dec(_bugX)
        else
          inc(_bugX);
        bugX[i]:=_bugX;
      end;
    end;

  end;
end;

procedure bugControl;
begin
  if gameState=2 then Exit;
  if timer[tmBugsDly]=0 then
  begin
    timer[tmBugsDly]:=random(50);
    i:=RANDOM(8);
    if bugX[i]=0 then
    begin
      j:=72+i*16;
      fillchar(_PL3[j],16,0);
      fillchar(_MIS[j],16,0);
      pushRandomBug;
    end;
  end;
end;

//

procedure Over_Init;
begin
  KEYB:=255;
  STONEY:=255; DINOX:=0;
  PMGClear;
  poke($5f,$00);

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
  poke($5f,$16);
  wait(110);
{$ELSE}
  poke($5f,$16);
  msx.Init($d);
  move(pointer(SCR2_ADDR),pointer(SCREEN_ADDR),21*40+8);
{$ENDIF}
  DINOX:=128;  DINOY:=128;

{$IFNDEF QUICK}
  wait(100);
  msx.Init($f);
{$ENDIF}

  repeat
    BugAnim;
    BugControl;
    DinoAnim;
    PteroAnim;
    DinoControl;
    PteroControl;
    StoneControl;
    if KEYB<>255 then gameState:=3
  until gameState=3;

  Over_Init;
end;