Program DinoCrater;

//
// Dino musi unikać wpadnięcia do kraterów, które tworzy latający powtór Peter-Daktyl.
// W wersji grawitacyjnej, jedyne co może robić to wpaść do krateru i z niego wyjść.
// Aaa... może też zginąć podczas wspinaczki we wnętrzu "kratera" lub... zawiesić się - wtedy wciś klawisz ANY.
//
// Zabrakło sił, aby dodać wincy przeszkadzajek typu, skolopendry giganty czy skrzypłocze jadowite.
// Brak też jakiś nagród dla "maleństwa" w postaci posiłków regeneracyjnych, czy napojów pocieszających samotną
// tułaczkę w tej krainie..
//
// (G)rawitacja 7 edycja 2025 by PeBe Kris3D Miker
//

{$DEFINE BASICOFF}
{$DEFINE ROMOFF}
{$DEFINE NOROMFONT}
{$DEFINE QUICK}

Uses {Atari, }RMT;

const
{$I memory.inc}
{$R resources.rc}

const
  FADE_STEP = 3;

var
  msx:TRMT;
  VDSLST:Pointer                absolute 512;
  DL:Pointer                    absolute 560;
  SDMCTL:Byte                   absolute 559;

  GPRIO:Byte                    absolute 623;
  PCOLR:Array[0..3] of byte     absolute 704;
  FCOL:Array[0..4] of byte      absolute 708;

  CHBAS:Byte                    absolute 756;
  KEYB:Byte                     absolute 764;

  [Volatile] STICK:byte                    absolute 54016;
  [Volatile] STRIG:Array[0..3] of boolean  absolute 53264;

  [Volatile] COLPF0:Byte        absolute 53270;
  [Volatile] COLPF1:Byte        absolute 53271;
  [Volatile] COLPF2:Byte        absolute 53272;
  [Volatile] COLPF3:Byte        absolute 53273;
  [Volatile] COLBK:Byte         absolute 53274;
  [Volatile] RAND:Byte          absolute 53770;
  [Volatile] CONSOL:Byte        absolute 53279;
  [Volatile] IRQST:Byte         absolute 54286;
  [Volatile] CHBASE:Byte        absolute 54281;
  [Volatile] WSYNC:Byte         absolute 54282;

  [Volatile] SIZEP:Array[0..3] of byte absolute 53256;
  [Volatile] HPOSP:Array[0..3] of byte absolute 53248;
  [Volatile] HPOSM:Array[0..3] of byte absolute 53252;
  [Volatile] SIZEM:Byte         absolute 53260;

  [Volatile] PMBASE:Byte        absolute 54279;
  [Volatile] PMCNTL:Byte        absolute 53277;

  _PL0:Array[0..255] of byte    absolute PMG_ADDR+ 1024;
  _PL1:Array[0..255] of byte    absolute PMG_ADDR+ 1280;
  _PL2:Array[0..255] of byte    absolute PMG_ADDR+ 1536;
  _PL3:Array[0..255] of byte    absolute PMG_ADDR+ 1792;

  timer:Array[0..6] of byte     absolute $F4;

  gameState:Byte;
  startVol:Boolean;

{$I game_helpers.pas}
{$I pmg.pas}

{$I title.pas}

{$I game.pas}

begin
  fillchar(pointer($50),32,0);
  msx.player:=pointer(rmt_player);
  msx.modul:=pointer(rmt_modul);
  startVol:=false;
{$IFNDEF QUICK}
  msx.Init($0);
{$ENDIF}

  repeat

    init_title;
    title_loop;

    init_game;
    game_loop;

  until false;
end.