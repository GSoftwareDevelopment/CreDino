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
  dsHit       = 64;

  tmDinoAnim  = 0;
  tmPteroAnim = 1;
  tmPteroDly  = 2;
  tmPteroSht  = 3;
  tmStars     = 4;
  tmHit       = 4;

  sfxDINOSTEP = $14;
  sfxDINOFALL = $11;
  sfxDINOJUMP = $17;
  sfxDINOBUM  = $16;
  sfxDINODIE  = $18;
  sfxDINOTAKE = $19;
  sfxDINOCOUT = $1A;

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
{13}    3, { Down }
{14}   -3, { Up }
{15}    0
  );

//

  cactusW:array[0..5] of byte = (1,1,2,2,2,2);
  cactusH:array[0..5] of byte = (1,1,1,2,2,2);

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

  treeW:Array[0..3] of byte = (2,2,3,3);
  treeH:Array[0..3] of Byte = (1,2,2,2);

  tree_def0:Array[0.. 5] of byte = ($0C,$03,$0E,$15,$16,$17);
  tree_def1:Array[0.. 8] of byte = ($0C,$0D,$0E,$0F,$10,$11,$12,$13,$14);
  tree_def2:Array[0..11] of byte = ($01,$02,$03,$04,$05,$06,$07,$08,$00,$09,$0A,$0B);
  tree_def3:Array[0..11] of byte = ($0C,$03,$03,$04,$0F,$10,$07,$08,$00,$13,$0A,$38);

  treeDef:Array[0..3] of pointer = (
    @tree_def0,
    @tree_def1,
    @tree_def2,
    @tree_def3
  );

  bushW:Array[0..4] of byte = (1,2,2,3,3);

  bush_def0:Array[0..1] of byte = ($1C,$1F);
  bush_def1:Array[0..2] of byte = ($18,$1D,$1F);
  bush_def2:Array[0..2] of byte = ($1C,$1D,$1F);
  bush_def3:Array[0..3] of byte = ($1C,$1D,$1E,$1F);
  bush_def4:Array[0..3] of byte = ($18,$19,$1A,$1B);

  bushDef:Array[0..4] of pointer = (
    @bush_def0,
    @bush_def1,
    @bush_def2,
    @bush_def3,
    @bush_def4
  );

