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
