{$I game_vbl.pas}
{$I game_dli.pas}

const
  dsNone      = 128;
  dsWalkLeft  = 0;
  dsWalkRight = 2;
  dsWalkUp    = 4;
  dsWalkDown  = 6;
  dsWalk      = 6;
  dsFall      = 8;
  dsJump      = 16;
  dsHeadStars = 32;

  tmDinoAnim  = 0;
  tmPteroAnim = 1;
  tmPteroDly  = 2;
  tmPteroSht  = 3;
  tmStars     = 3;

  sfxDINOSTEP = $14;
  sfxDINOFALL = $11;
  sfxDINOJUMP = $10;

  sfxPTERODROP = $15;
  sfxSTONEHIT  = $12;

const
  joy2spr:Array[0..15] of Byte = (
{ 0}    255,
{ 1}    255,
{ 2}    255,
{ 3}    255,
{ 4}    255,
{ 5}    255,
{ 6}    255,
{ 7}      0, { Right }
{ 8}    255,
{ 9}    255,
{10}    255,
{11}      2, { Left }
{12}    255,
{13}      6, { Down }
{14}      4, { Up }
{15}    255
  );

  joy2dx:Array[0..15] of Shortint = (
{ 0}    0,
{ 1}    0,
{ 2}    0,
{ 3}    0,
{ 4}    0,
{ 5}    0,
{ 6}    0,
{ 7}    2, { Right }
{ 8}    0,
{ 9}    0,
{10}    0,
{11}   -2, { Left }
{12}    0,
{13}    0, { Down }
{14}    0, { Up }
{15}    0
  );

  joy2dy:Array[0..15] of Shortint = (
{ 0}    0,
{ 1}    0,
{ 2}    0,
{ 3}    0,
{ 4}    0,
{ 5}    0,
{ 6}    0,
{ 7}    0, { Right }
{ 8}    0,
{ 9}    0,
{10}    0,
{11}    0, { Left }
{12}    0,
{13}    4, { Down }
{14}   -4, { Up }
{15}    0
  );

var

  DINOState:Byte;
  DINOFallDist:Byte;
  joyDir:Byte;
  joyFire,oJoyFire:Boolean;

  pteroState:byte;
  pteroAdr:Word;
  pteroX:ShortInt;

  stoneState:Byte;
  stoneAdr:Word;
  oStoneAdr:Word;
  stoneDst:Shortint;

procedure prepare_stage;
begin
  fillchar(pointer(SCREEN_ADDR),1024,0);
end;

procedure init_game;
begin
  turnOff;
  DL:=Pointer(DL_GAME);
  CHBAS:=Hi(FNT_GAME);

  dpoke(DL_GAME+15,SCREEN_ADDR+208);

  FCOL[0]:=$00; FCOL[1]:=$16; FCOL[2]:=$1e; FCOL[3]:=$0F; FCOL[4]:=$00;
  PCOLR[0]:=$04; PCOLR[1]:=$ca;

  PMGClear;

  prepare_stage;
  dpoke(DL_GAME+33,STATUS_ADDR);

  turnOn(@VBL_Game_Screen,@DLI_Game_Screen,%111110);

  GPRIO:=$22;
  PMBASE:=HI(PMG_ADDR);
  PMCNTL:=3;

  DINOX:=128;
  DINOY:=128;
  DINOFrm:=0;
  DINOState:=dsNone;

  pteroState:=255;
  timer[tmPteroDly]:=200+random(25);
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
  adr:Word;
  ch1,ch2:Byte;
  cnsl:Byte;
  a1,a2:Boolean;

begin
//  if gameState=1 then
  begin
    if (DINOState and (dsJump+dsFall+dsNone+dsHeadStars)=0) and ((DINODX=0) and (DINODY=0)) then
    begin
      DINOState:=DINOState or dsNone;
      DINOFrm:=DINOFrm and 2;
    end;
  end;
  if DINOState and dsNone=0 then
  begin
    if timer[tmDinoAnim]=0 then
    begin
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
        DINOFrm:=(DINOState and dsWalk) or (DINOFrm and 1 xor 1); // przełączenie klatki spritea


      if DINODX<>0 then // przesunięcie Dino w osi X
      begin
        inc(DINOX,DINODX);
        if DINODX>0 then
          dec(DINODX)
        else
          inc(DINODX);
        if DINOState and (dsJUMP+dsFall)=0 then
          PlaySFX(sfxDINOSTEP);
      end;

      if gameState=1 then // ekran pierwszy
      begin
        if DINODY<>0 then
        begin
          inc(DINOY,DINODY);
          if DINODY>0 then
            dec(DINODY)
          else
            inc(DINODY);
          if gameState=1 then
            PlaySFX(sfxDINOSTEP);
        end;
      end
      else
      begin // ekran drugi
        if DINOState and dsFall=0 then
        begin
          if (DINOState and dsJump<>0) then
          begin
            if (DINODY<0) then // podskok
            begin
              inc(DINOY,DINODY);
              inc(DINODY,2);
              if DINOY=64 then // górna krawędź ekrnu gry
              begin // wyjście z krateru
                gameState:=1;
                dpoke(DL_GAME+15,SCREEN_ADDR+208);
                PMGClear;
                  DINOX:=outDINOX; DINOY:=outDINOY;
                // DINOX:=128; DINOY:=64;
                DINOState:=dsNone;
                DINODX:=0; DINODY:=0;
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
      end;

      sx:=(DINOX-46) div 4;
      sy:=(DINOY-60) div 8;
      if gameState=1 then
      begin
        adr:=SCREEN_ADDR+208+sx+sy*40;
        ch1:=peek(adr); inc(adr); ch2:=peek(adr);
        if ((ch1>=$2a) and (ch1<=$2d)) and
           ((ch2>=$2a) and (ch2<=$2d)) then
        begin // wpadnięcie do krateru
          gameState:=2;
          dpoke(DL_GAME+15,CRATER_ADDR);
          PMGClear;
          outDINOX:=DINOX+DINODX*4; outDINOY:=DINOY+DINODY*6;

          DINOY:=68; DINOX:=128;
          DINODX:=0;
          DINODY:=4;
          DINOFallDist:=0;
          PlaySFX(sfxDINOFALL);

          DINOState:=DINOState and (not dsWalk+dsNone);
          DINOState:=DINOState or dsWalkUp+dsFall;
        end;
      end
      else if gameState=2 then
      begin
        adr:=CRATER_ADDR+sx+sy*40+40;
        ch1:=peek(adr) and $7f;
        inc(adr); ch2:=peek(adr) and $7f;
        a1:=(byte(ch1)>=$42) and (byte(ch1)<=$4a);
        a2:=(byte(ch2)>=$42) and (byte(ch2)<=$4a);
        if (not a1) and (not a2) then // pusta przestrzeń w kraterze
        begin // dino spada
          DINOState:=DINOState and (not dsNone) or dsFall;
        end
        else
        begin
          if (DINOState and dsFall)<>0 then // jeżeli spadał...
          begin
            if DINOFallDist>24 then // upadek z wysokości
            begin
              if DINOState and dsWalk=dsWalkUp then
                DINOState:=(DINOState and (not dsWalk)) or dsWalkRight;
              DINOState:=(DINOState and dsWalk) or dsHeadStars;
              Timer[tmStars]:=100;
            end
            else
            begin
              DINOState:=(DINOState and dsWalk) or dsNone;
              DINOFrm:=DINOFrm and 3;
            end;
            DINOFallDist:=0;
          end;
          DINOY:=64+sy*8; DINODY:=0;
        end;
      end;
    end;
  end;
end;

procedure DinoControl;
begin
  joyDir:=STICK and $f;
  joyFire:=not STRIG[0];

  if gameState=1 then // -- scena główna
  begin
    if joy2spr[joyDir]<>255 then // -- ruch dinusia
    begin
      DINOState:=DINOState and (not (dsWalk+dsNone)) or joy2spr[joyDir];
      DINODX:=joy2dx[joyDir];
      DINODY:=joy2dy[joyDir];
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
          // DINOState:=DINOState and (not (dsWalk+dsNone)) or joy2spr[joyDir];
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
    pteroAdr:=SCREEN_ADDR+40+PteroX;
    if pteroState=1 then
    begin
      poke(pteroAdr,$e0); inc(pteroAdr);
      poke(pteroAdr,$e1); inc(pteroAdr);
      poke(pteroAdr,$e2); inc(pteroAdr);
      poke(pteroAdr,$e3); inc(pteroAdr);
      poke(pteroAdr,$0);
    end
    else
    begin
      poke(pteroAdr,$e4); inc(pteroAdr);
      poke(pteroAdr,$e5); inc(pteroAdr);
      poke(pteroAdr,$e6); inc(pteroAdr);
      poke(pteroAdr,$e7); inc(pteroAdr);
      poke(pteroAdr,$0);
    end;
    inc(pteroState,1); if pteroState=4 then pteroState:=1;
    if pteroX>0 then
      dec(pteroX) // ptero przesówa się w lewo
    else
    begin // ptero kończy swój lot
      poke(pteroAdr,$0); inc(pteroAdr);
      poke(pteroAdr,$0); inc(pteroAdr);
      poke(pteroAdr,$0); inc(pteroAdr);
      poke(pteroAdr,$0);
      pteroState:=255; // status ptero wyłączony
      timer[tmPteroDly]:=25+Random(50); // losowanie nowego czasu na pokazanie się ptero
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
begin
  if stoneState=255 then exit; // pomiń, gdy status zrzutu wyłączony
  if timer[tmPteroSht]<>0 then exit; // pomiń, gdy czas zrzutu nie jest osiągnięty

  if (stoneState=0) then // jeżeli status zrzutu oczekuje
  begin // ustal parametry
    STONEX:=40+PteroX*4;
    STONEY:=40;
    stoneState:=1;
    PlaySFX(sfxPTERODROP);
  end
  else
  begin
    dec(stoneDst); // zmniejsza dystans zrzutu
    if stoneDst=0 then // jeżeli dystans zrzutu osiągnięty
    begin
      stoneState:=255; // status zrzutu, wyłączony
      StoneAdr:=SCREEN_ADDR+84+((STONEY-36) div 8)*40+((STONEX-28) div 4);
      dec(StoneAdr,2); // rysuj krater
      poke(StoneAdr,$2a); inc(StoneAdr,1);
      poke(StoneAdr,$2b); inc(StoneAdr,1);
      poke(StoneAdr,$2c); inc(StoneAdr,1);
      poke(StoneAdr,$2d);
      STONEX:=0; STONEY:=255;
      PlaySFX(sfxSTONEHIT);

      exit;
    end;
    oStoneAdr:=stoneAdr;

    STONEFrm:=1-STONEFrm;
    stoneState:=1+STONEFrm;

    STONEX:=STONEX-2;
    STONEY:=STONEY+4;

    timer[tmPteroSht]:=4; // ustaw timer szybkości zrzutu
  end;
end;

procedure Over_Init;
var
  i:Byte;

begin
  KEYB:=255;
  PMGClear;

  dpoke(DL_GAME+33,GOVER_ADDR);

  for i:=0 to 199 do
    wait4screen;

end;

procedure game_loop;

begin
  msx.Init($c);
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